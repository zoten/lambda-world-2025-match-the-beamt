# Troubleshooting

I understand the setup for the workshop may not be trivial and I'm sorry for that! When you have to bring together many different systems (sound, languages, network...) complexity explodes easily. We'll try our best to come prepared!

## Sound issues

### Select the sound sink

You may be bound to the wrong sink if you have many available. You can try to manually change it

``` bash
pactl list short sinks # list the audio output devices
pactl set-default-sink 58 # example id 58
```

or install a graphical tool like `qpwgraph` to edit them visually (recommended)

### Ensure audio working via PipeWire

``` bash
# 1) Install/ensure PipeWire JACK stack + session manager + RT kit
sudo apt update
sudo apt install -y pipewire pipewire-audio-client-libraries pipewire-pulse pipewire-jack wireplumber rtkit

# 2) Remove a conflicting jackd daemon (we want PipeWire to provide JACK)
sudo apt remove -y jackd jackd2 || true

# 3) Enable + restart the user services
systemctl --user enable --now pipewire pipewire-pulse wireplumber
systemctl --user restart pipewire pipewire-pulse wireplumber

# 4) Verify PipeWire is your audio server
pactl info | grep -E 'Server Name|Server String'
# Expect "PulseAudio (on PipeWire)" or "PipeWire"

# 5) Check that JACK ports exist via PipeWire
pw-jack jack_lsp
# Expect to see: system:playback_1 and system:playback_2

# 6) Optional: RT scheduling helper should be running
systemctl status rtkit-daemon | sed -n '1,5p'
```

## VM troubleshooting

When on a VM you may need to play with virtual sound cards to have your sound
Here's a list of useful commands

``` bash
# List your sound devices. You should have at least 1 card with at least 1 subdevice
aplay -l
# test your speakers
speaker-test -t sine
```
