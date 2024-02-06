use anyhow::{Context, Ok, Result};
use std::process::{exit, Command, Stdio};
use std::{
    os::unix::fs::chroot,
    path::{Path, PathBuf},
};

// Usage: your_docker.sh run <image> <command> <arg1> <arg2> ...
fn main() -> Result<()> {
    // You can use print statements as follows for debugging, they'll be visible when running tests.
    // println!("Logs from your program will appear here!");

    // Uncomment this block to pass the first stage!
    let args: Vec<_> = std::env::args().collect();
    let command = &args[3];
    let command_args = &args[4..];
    // println!(
    //     "Running: {} {}",
    //     command,
    //     command_args
    //         .iter()
    //         .map(|s| format!("<{}>", s))
    //         .collect::<Vec<String>>()
    //         .join(" ")
    // );

    let _ = setup_root_dir(command);
    let output = Command::new(command)
        .args(command_args)
        .stdout(Stdio::piped())
        .stderr(Stdio::piped())
        .output()
        .with_context(|| {
            format!(
                "Tried to run '{}' with arguments {:?}",
                command, command_args
            )
        })?;

    let std_out = std::str::from_utf8(&output.stdout)?;
    // print!("\nstdout: ");
    print!("{}", std_out);
    let std_err = std::str::from_utf8(&output.stderr)?;
    // eprint!("\nstderr: ");
    eprint!("{}", std_err);

    if !output.status.success() {
        exit(output.status.code().unwrap_or(1));
    }

    Ok(())
}

fn setup_root_dir(command: &str) -> Result<()> {
    // container_path: /tmp/your_docker_container/
    let container_path = Path::new("/tmp/your_docker_container");
    std::fs::create_dir_all(container_path.join("dev/null"))?;

    let command_path = PathBuf::from(command);
    let command_file_name = command_path.file_name().unwrap();
    let dest_command_path = container_path.join(command_path.parent().unwrap().strip_prefix("/")?);
    // println!(
    //     "command_path: {}; command_path: {}",
    //     command_path.display(),
    //     dest_command_path.display()
    // );

    std::fs::create_dir_all(dest_command_path.clone())?;
    std::fs::copy(
        command_path.clone(),
        dest_command_path.join(command_file_name),
    )?;

    chroot(container_path)?;
    std::env::set_current_dir("/")?;

    Ok(())
}
