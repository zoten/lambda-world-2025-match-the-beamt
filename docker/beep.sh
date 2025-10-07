#!/usr/bin/env bash
# Simple OSC beep for SuperCollider/scsynth
# Requires: liblo-tools installed in the container

SC_HOST=${SC_HOST:-localhost}
SC_PORT=${SC_PORT:-57110}
NODE_ID=1000

# Start a node with the built-in 'default' synth
oscsend $SC_HOST $SC_PORT /s_new siiii default $NODE_ID 1 0

# Set its frequency and amplitude
oscsend $SC_HOST $SC_PORT /n_set isfi $NODE_ID freq 440 amp 0.2

# Hold the note for 2s, then free the node
sleep 2
oscsend $SC_HOST $SC_PORT /n_free i $NODE_ID
