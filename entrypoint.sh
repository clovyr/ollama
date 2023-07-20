#!/bin/sh

/bin/ollama &
sleep 3
/bin/ollama pull llama2
fg
