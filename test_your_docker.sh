#!/bin/sh
CODECRAFTERS_SUBMISSION_DIR="./docker"
CODECRAFTERS_TEST_CASES_JSON='''
[
  {
    "slug": "init",
    "tester_log_prefix": "stage-1",
    "title": "Stage #1: Execute a program",
  },
  {
    "slug": "stdio",
    "tester_log_prefix": "stage-2",
    "title": "Stage #2: Wireup stdout \u0026 stderr",
  },
  {
    "slug": "exit_code",
    "tester_log_prefix": "stage-3",
    "title": "Stage #3: Handle exit codes",
  },
  {
    "slug": "fs_isolation",
    "tester_log_prefix": "stage-4",
    "title": "Stage #4: Filesystem isolation",
  },
  {
    "slug": "process_isolation",
    "tester_log_prefix": "stage-5",
    "title": "Stage #5: Process isolation",
  },
  {
    "slug": "fetch_from_registry",
    "tester_log_prefix": "stage-6",
    "title": "Stage #6: Fetch an image from the Docker Registry",
  },
]
'''
make test_in_docker_container