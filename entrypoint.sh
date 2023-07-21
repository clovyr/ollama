#!/bin/bash

set -eo pipefail

cd $HOME

# options: llama2 llama2:13b
if [[ -z "$MODEL" ]]; then
  export MODEL="llama2"
fi

if [[ -z "$TEMPERATURE" ]]; then
  export TEMPERATURE=0.8
fi

create_model() {

(cat <<-EOF
FROM ${MODEL}

# set the temperature to 1 [higher is more creative, lower is more coherent]
PARAMETER temperature ${TEMPERATURE}

# set the system prompt
SYSTEM """
${SYSTEM_PROMPT}
"""
EOF
) > Modelfile

  /bin/ollama create custom_model -f Modelfile
}

# (sleep 5 && /bin/ollama pull llama2) &
/bin/ollama serve &
sleep 3
/bin/ollama pull $MODEL

if [[ -n "$SYSTEM_PROMPT" ]]; then
  create_model
fi

wait
