#!/bin/bash

set -eo pipefail

# (sleep 5 && /bin/ollama pull llama2) &
/bin/ollama serve &
sleep 3
/bin/ollama pull llama2
wait
