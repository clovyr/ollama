#!/bin/bash

set -eo pipefail

/bin/ollama serve &
sleep 3
/bin/ollama pull llama2
wait
