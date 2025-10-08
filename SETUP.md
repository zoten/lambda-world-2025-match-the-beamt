# Setup

The workshop can be followed via different means. What we basically need from every setup flavour is:

 * [git](https://git-scm.com/), to follow the workshop's step
 * an instance of [Sonic Pi](https://sonic-pi.net/) version `4.6.0` running and playing sounds
 * a fairly modern [Erlang](https://www.erlang.org/) installation (the workshop's code has been written using OTP-27)
 * a fairly modern [Elixir](https://elixir-lang.org/) installation (the workshop's code has been written using 1.18.4-otp27)
 * your editor of choice, better if supporting Elixir (the workshop's code has been written using [VSCodium](https://vscodium.com/))

This can be achieved using different combinations of tools.

> ⚠️ **Security disclaimer** if you're following the workshop live, there will be a moment when we will be all connected in a cluster. While I'm fairly confident we'll all be having fun and be well intentioned, this represent a **high risk security issue**, so my advice is to use containerized, restricted options (containers, virtual machines) for running the Elixir code or bare metal machines that do not contain sensitive data

> Sonic Pi can run anywhere, but the Elixir code should be able to talk with it via UDP on port 4560

> My personal recommendation is, if it works for you, to use the provided VM, with the notes shared below

## Sonic Pi

If you can open the Sonic Pi GUI, write

``` ruby
play 70
```

and hear a sound, you're set up. We will use it just as a sound server.


### Sonic Pi on the host

There are pre-compiled binaries for Mac and Windows on the Sonic Pi official page.
Unluckily Linux users only have outdated packages, so we have to compile it from source or use one of the following options.

If you choose to compile it from source and you are on an Ubuntu based system, you can just follow the steps used by the [Dockerfile.sonicpi](./Dockerfile.sonicpi) file.

### Sonic Pi via Docker

There's a [Dockerfile.sonicpi](./Dockerfile.sonicpi) file that you can build to have your sound server up and running. I will still bring a USB stick with a pre-built image. Use the [build.sh](./build.sh) script to build and tag the image.

``` bash
chmod +x build.sh
./build.sh
```

**Note** the working dir is on an `/app` folder. To spin up Sonic Pi, you should

``` bash
cd ../bin
./sonic-pi
```

> **Note** before launching any of the `run-compose-*.sh` files, you should copy [.env.sample](./.env.sample) to a `.env` file and edit it to your needs

``` bash
cp .env.sample .env
```

#### Linux users

A [run-compose-x11.sh](./run-compose-x11.sh) is included in this repository. Some users had to uncomment the 

``` yaml
devices:
    - /dev/snd
    # - /dev/dri
```

line to get it to work.

If you're still not able to hear sounds, please refer to the [TROUBLESHOOTING](./TROUBLESHOOTING.md) file.

#### Mac users

The [run-compose-x11-macos.sh](./run-compose-x11-macos.sh) has not been tested yet. I hope I will be able to change this line soon.

However, Mac users probably have access to Docker desktop, which has some useful features like monitor forward that may make this more usable.

## Erlang / Elixir

If you're not inside a dedicated container (e.g. using [VSCode Dev Containers](https://code.visualstudio.com/docs/devcontainers/containers)) you may benefit from using a language manager like [asdf](https://asdf-vm.com/) or [mise](https://mise.jdx.dev/).

Please follow the instructions for your specific system.

## Virtual Machines

I prepared a virtual machine (Ubuntu based) that I will also use while conducting the workshop. It already contains a working Sonic Pi installation, a configured VSCodium installation with a minimal plugins set, Erlang and Elixir installed through *mise* and a minimal configuration.

I recommend to reserve 4 cores and at least 4GB of RAM for a smooth experience, but you should tune it adapting to your machine. I also recommend to bridge your network interface, so you'll be able to connect to the cluster.

> If you're attending live, you should receive a link to a Google Drive with the `.ova` image you can import in your virtualization system. No crypto miners, promise. Otherwise, feel free to contact me for the link

### VirtualBox

I created and exported the virtual machine using VirtualBox 7.0, so I expect it to work smoothly on that version. However, in my machine I had to set the video mode to `VBoxVGA` to solve a black screen bug.

On Apple Silicon M3 (arm64) virtualBox seems not to be working ("Cannot run the machine because its platform architecture x86 is not supported on ARM"). See the UTM section for an alternative.

### Qemu

If you've already been bitten by VirtualBox bricking your machine's kernel modules, you may want to use Qemu. Here some steps that worked for my colleagues:

``` bash
tar vxf Lambda\ World\ 2025.ova
qemu-img convert -f vmdk -O qcow2 Lambda\ World\ 2025-disk001.vmdk lambda_world_2025_ws.qcow2
qemu-system-x86_64 -m 4096 -cpu host -device intel-hda -device hda-duplex -enable-kvm -hda lambda_world_2025_ws.qcow2 -boot c
```

### UTM

To run the machine via UTM on Mac:

 * rename the `.ova` file to `.tar`
 * extract the content
 * on UTM
   * Create new virtual machine
   * EMULATE
   * Architecture (x86_64)
   * boot (boot from Drive)
   * **uncheck** UEFI boot
   * select the vmdk file
