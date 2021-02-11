# rieMiner 0.92 for Android

**This is the Android branch. It is intended for people willing to cross compile rieMiner for Android systems. If it is not the case for you, you should go to the [master branch](https://github.com/Pttn/rieMiner). Also note that this branch is not actively maintained; as an user you are on your own using it and are expected to have decent Android knowledge and development abilities, and be able to fix any issue by yourself. So please don't report issues or ask for help if you encounter any problem**. Contributions to this branch are still welcome and we will be glad to support developers.

rieMiner is a Riecoin miner supporting both solo and pooled mining, and can also be run standalone for prime constellation record attempts. Find the latest binaries [here](https://github.com/Pttn/rieMiner/releases) for Linux and Windows.

This README is intended for advanced users and will mainly only describe the different configuration options and give information for developers like how to compile or contribute. For more practical information on how to use rieMiner like configuration file templates and mining or record attempts guides, visit the [rieMiner's page](https://riecoin.dev/en/rieMiner).

Happy Mining!

## Differences from the main version

* Based on the [Light](https://github.com/Pttn/rieMiner/tree/Light) Branch;
* Build instructions for Android replace the ones for Linux/Windows;
* The Makefile is altered so the compilation can work.

The C++ code itself is actually the same as the Light version. No interface was added, there is no Android Studio project, etc. You are more than welcome to fork this branch and make great Riecoin mining applications, create a proper APK file,... However, please don't use the code to create hidden miners or anything giving bad user experience.

## Minimum requirements

* Recent enough 64 bits Linux for the compilation (it was tested on a Debian 10 Live CD), recent enough Android (no Root needed);
* Recent 32 or 64 bits ARM CPU, a powerful one from at most the latest couple of years recommended;
* 512 MiB of RAM (the prime table limit must be manually set at a lower value in the options). Recommended 4-8 GiB.

There is no built-in temperature control and you are responsible that the heat does not damage your device.

## Compile this program

**Again, you are on your own, so please don't report compiling issues when using the Android branch**.

### Get Android NDK

Get the Android NDK Tools from [here](https://developer.android.com/ndk/downloads).

You should now have an `android-ndk-r21e` folder somewhere, we will use `/home/user/dev/android-ndk-r21e` as an example for the following instructions.

### Preparation

#### Get basic development tools

You may need to install basic build tools like `make` or `m4`. Install them using your package manager, for example

```bash
apt install make m4 git
```

If later you still encounter error messages indicating that something was not found, try to install the missing tool.

#### Get and prepare the rieMiner's source code

Get the rieMiner's source code and use the Android branch.

```bash
git clone https://github.com/Pttn/rieMiner.git
cd rieMiner
git checkout Android
```

Create `incs` and `libs` folders in the rieMiner directory.

#### Android API Level

You must now choose your target Android API Level. Each level correspond to a minimum Android version with which an application is compatible, for example API Level 30 corresponds to Android 11. A list can be found [here](https://developer.android.com/studio/releases/platforms).

The compilation was tested with levels 23 (Android 6) and 29 (Android 10), and should work for other common versions. The API Level 29 and the Aarch64 architecture are used in the following instructions, of course make the required adaptations if needed.

### Compile the dependencies

You must build yourself all the rieMiner's dependencies with these NDK tools.

#### Enviroment variables

When you are going to build a library, set (or just ensure that they are set) the following environment variables before running `configure`.

```
export NDK=/home/user/dev/android-ndk-r21e
export HOST_TAG=linux-x86_64
export TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/$HOST_TAG
export AR=$TOOLCHAIN/bin/aarch64-linux-android-ar
export AS=$TOOLCHAIN/bin/aarch64-linux-android-as
export CC=$TOOLCHAIN/bin/aarch64-linux-android29-clang
export CXX=$TOOLCHAIN/bin/aarch64-linux-android29-clang++
export LD=$TOOLCHAIN/bin/aarch64-linux-android-ld
export RANLIB=$TOOLCHAIN/bin/aarch64-linux-android-ranlib
export STRIP=$TOOLCHAIN/bin/aarch64-linux-android-strip
```

#### Curl

Download Curl [here](https://curl.se/download.html). You should now have a folder like `curl-7.75.0` somewhere, enter it. Then set the environment variables above. Finally, configure and compile with

```
./configure --host aarch64-linux-android --with-pic --disable-dict --disable-file --disable-ftp --disable-gopher --disable-imap --disable-ldap --disable-ldaps --disable-pop3 --disable-rtsp --disable-smtp --disable-telnet --disable-tftp --without-ssl --without-libssh2 --without-zlib --without-brotli --without-zstd --without-libidn2  --without-ldap  --without-ldaps --without-rtsp --without-psl --without-librtmp --without-libpsl --without-nghttp2 --disable-shared --disable-libcurl-option
make
```

Now, go to the `include` directory and copy the `curl` folder to the rieMiner's `incs` folder that you created. Do the same with `libcurl.a` from the `libs/.lib` folder to the rieMiner's `libs` folder.

#### GMP

Download GMP [here](https://gmplib.org/). You should now have a folder like `gmp-6.2.1` somewhere, enter it. Set the environment variables above. Configure and compile with

```
./configure --host aarch64-linux-android --enable-cxx --disable-shared
make
```

Now, copy `gmp.h` and `gmpxx.h` from the GMP's folder to the rieMiner's `incs` folder. Do the same with `libgmp.a` and `libgmpxx.a` from the `.libs` folder to the rieMiner's `libs` folder.

#### Jansson

Download Jansson [here](http://www.digip.org/jansson/). You should now have a folder like `jansson-2.13.1` somewhere, enter it. Set the environment variables above. Configure and compile with

```
./configure --host aarch64-linux-android --disable-shared
make
```

Now, copy `jansson.h` from the `src` directory and `jansson_config.h` from `android` to the rieMiner's `incs` folder. Do the same with `libjansson.a` from the `src/.libs` folder to the rieMiner's `libs` folder.

#### OpenSSL

Download OpenSSL [here](https://www.openssl.org/source/). You should now have a folder like `openssl-1.1.1i` somewhere, enter it. You don't need to set the environment variables above, but must set the following ones, then configure and compile with

```
export ANDROID_NDK_HOME=/home/user/dev/android-ndk-r21e
PATH=$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64/bin:$ANDROID_NDK_HOME/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin:$PATH
./Configure android-arm64 -D__ANDROID_API__=29
make
```

Now, go to the `include` directory and copy the `openssl` folder to the rieMiner's `incs` folder. Do the same with the `libcrypto.a` file to the rieMiner's `libs` folder.

### Compile and run rieMiner

Now go to the rieMiner's directory, set the environment variables above, and do the final build with `make`.

This will produce the binary file named `rieMinerAnd` that you can run using a Terminal Emulator on your phone or via Adb (don't forget to set it as executable). The configuration of the miner is exactly the same as usual versions of rieMiner.

## Configure this program

rieMiner uses a text configuration file, by default a "rieMiner.conf" file next to the executable. It is also possible to use custom paths, examples:

```bash
./rieMiner config/example.txt
./rieMiner "config 2.conf"
./rieMiner /home/user/rieMiner/rieMiner.conf
```

If the provided configuration file was not found, you will be asked a few questions to configure very basic settings of Solo or Pooled Mining.

For other Modes or more options, you need to know how to write a configuration file yourself. The rieMiner.conf syntax is very simple: each option is set by a line like

```
Option = Value
```

It is case sensitive. A line starting with "#" will be ignored, as well as invalid ones. A single space or tab before or after "=" is also ignored. If an option is missing, the default value(s) will be used. If there are duplicate lines for the same option, the last one will be used.

### Modes

rieMiner proposes the following Modes depending on what you want to do. Use the `Mode` option to choose one of them (by default, `Benchmark`), below are the values to use.

* `Solo`: solo mining via GetBlockTemplate;
* `Pool`: pooled mining using Stratum;
* `Benchmark`: test performance with a simulated and deterministic network (use this to compare different settings or share your benchmark results);
* `Search`: pure prime constellation search (useful for record attempts);
* `Test`: simulates various network situations for testing, see below.

#### Test Mode

It does the following:

* Start at Difficulty 1600, the first time with constellation pattern 0, 2, 4, 2, 4;
* Increases Difficulty by 10 every 10 s two times;
* After 10 more seconds, sets Difficulty to 1200 and the constellation pattern to 0, 2, 4, 2, 4, 6, 2;
* Decreases Difficulty by 20 every 10 s (the time taken to restart the miner is counted, so if it takes more than 10 s, it is normal that a new block appears immediately after the reinitialization);
* The miner restarts several times due to the Difficulty variation (this adjusts some parameters if not set);
* When the Difficulty reaches 1040, a disconnect is simulated;
* Repeat (keeping the 7-tuple constellation). The miner will restart twice as when it disconnects, it is not aware that the Difficulty increased a lot.

### Solo and Pooled Mining options

* `Host`: IP of the Riecoin server. Default: 127.0.0.1 (your computer);
* `Port`: port of the Riecoin server (same as rpcport in riecoin.conf for solo mining). Default: 28332 (default RPC port for Riecoin Core);
* `Username`: username used to connect to the server (same as rpcuser in riecoin.conf for solo mining). Default: empty;
* `Password`: password used to connect to the server (same as rpcpassword in riecoin.conf for solo mining). Default: empty;
* `PayoutAddress`: payout address for solo mining. You can use Bech32 "ric1" addresses (only lowercase). Default: a donation address;
* `Donate`: for solo mining, there is a developer fee of 1%. Choose how many % you wish to donate between 1 and 99 (only integers!). Default: 2;
* `Rules`: for solo mining, add consensus rules in the GetBlockTemplate RPC call, each separated by a comma. `segwit` must be present. You should not touch this unless a major Riecoin upgrade is upcoming and it is said to use this option. Default: segwit.

### Benchmark and Search Modes options

* `Difficulty`: for Benchmark and Search Modes, sets the difficulty (which is the number of binary digits, it must be at least 128). It can take decimal values and the numbers will be around 2^(Difficulty - 1). Default: 1024;
* `TupleLengthMin`: for Search Mode, the base prime of tuples of at least this length will be shown. 0 for the length of the constellation pattern - 1 (minimum 1). Default: 0;
* `BenchmarkBlockInterval`: for Benchmark Mode, sets the time between blocks in s. <= 0 for no block. Default: 150;
* `BenchmarkTimeLimit`: for Benchmark Mode, sets the testing duration limit in s. <= 0 for no time limit. Default: 86400;
* `BenchmarkPrimeCountLimit`: for Benchmark Mode, stops testing after finding this number of 1-tuples. 0 for no limit. Default: 1000000;
* `TuplesFile`: for Search Mode, write tuples of at least length TupleLengthMin to the given file. Default: Tuples.txt.

### More options

* `Threads`: number of threads used for mining, 0 to autodetect. Default: 0;
* `PrimeTableLimit`: the prime table used for mining will contain primes up to the given number. Set to 0 to automatically calculate according to the current Difficulty. You can try a larger limit as this will reduce the ratio between the n-tuple and (n + 1)-tuple counts (but also the candidates/s rate). It must be lower than 2^32. Reduce if you want to lower memory usage. Default: 0;
* `EnableAVX2`: by default, AVX2 is disabled, as it may increase the power consumption more than the performance improvements. If your processor supports AVX2, you can choose to take advantage of this instruction set if you wish by setting this option to `Yes`. Do your own testing to find out if it is worth it. AVX2 is known to degrade performance for AMD Ryzens and similar before Zen2 (e. g. 1800X, 1950X, 2700X) and should be left disabled in these cases. Note: a good part of the AVX2 optimizations is currently broken and disabled regardless of this setting, so the description does not apply until the bug is fixed: enabling or disabling AVX2 does not seem to have noticeable effects currently;
* `SieveBits`: the size of the primorial factors table for the sieve is 2^SieveBits bits. 23 seems to be an good value for slower processors. Default: 23 if SieveWorkers <= 4, 22 otherwise;
* `SieveIterations`: how many times the primorial factors table is reused for sieving. Increasing will decrease the frequency of new jobs, so less time would be "lost" in sieving, but this will also increase the memory usage. It is not clear however how this actually plays performance wise, Default: 16;
* `SieveWorkers`: the number of threads to use for sieving. Increasing it may solve some CPU underuse problems, but will use more memory. 0 for choosing automatically. Default: 0.
* `ConstellationPattern`: which sort of constellations to look for, as offsets separated by commas. Note that they are not cumulative, so '0, 2, 4, 2, 4, 6, 2' corresponds to n + (0, 2, 6, 8, 12, 18, 20). If empty (or not accepted by the server), a valid pattern will be chosen (0, 2, 4, 2, 4, 6, 2 in Search and Benchmark Modes). Default: empty;
* `PrimorialNumber`: Primorial Number for the sieve process. Higher is better, but it is limited by the target offset limit. 0 to set automatically, it should be left as is. Default: 0;
* `PrimorialOffsets`: list of offsets from a primorial multiple to use for the sieve process, separated by commas. If empty, a default one will be chosen if possible (see main.hpp source file), otherwise rieMiner will not start (if the chosen constellation pattern is not in main.hpp). Default: empty;
* `RefreshInterval`: refresh rate of the stats in seconds. <= 0 to disable them and only notify when a long enough tuple or share is found, or when the network finds a block. Default: 30;
* `GeneratePrimeTableFileUpTo`: if > 1, generates the table of primes up to the given limit and saves it to a `PrimeTable64.bin` file, which will be reused instead of recomputing the table at every miner initialization. This does not affect mining, but is useful if restarting rieMiner often with large Prime Table Limits, notably for debugging or benchmarks. However, the file will take a few GB of disk space for large limits and you should have a fast SSD. Default: 0;
* `Debug`: activate Debug Mode: rieMiner will print a lot of debug messages. Set to 1 to enable, 0 to disable. Other values may introduce some more specific debug messages. Default : 0.

## Interface

For now, rieMiner only works in a console. First, it will summarize the settings and print some information about the miner initialization, and you should look there to ensure that your settings were taken in account.

During mining, rieMiner will regularly print some statistics (use the `RefreshInterval` parameter to change the frequency). They consist of the candidates per second speed `c/s` and the 0 to 1-tuples/s ratio `r`. The estimate of the average time to find a block (for pooled mining, the earnings in RIC/day) is also shown. The number of tuples found since the start of mining is also shown (for pooled mining, the numbers of valid and total shares).

rieMiner will also notify if it found a block or a share, and if the network found a new block. If it finds a block or a share, it will tell if the submission was accepted (solo mining only) or not by the server.

In Benchmark, Search and Test Modes, the behavior is essentially the same as Solo mining. In mining and Test Modes, the statistics are based on the tuples found during the latest five blocks, including the current one. In the other Modes, everything since the beginning is taken in account.

## Developers and license

* [Pttn](https://github.com/Pttn), author and maintainer, contact: dev at Pttn dot me

This work is released under the MIT license, except the modified GMP code which is licensed with the LGPL license.

### Notable contributors

* [Michael Bell](https://github.com/MichaelBell/): assembly optimizations, improvements of work management between threads, and some more.

### Versioning

The version naming scheme is 0.9, 0.99, 0.999 and so on for major versions, analogous to 1.0, 2.0, 3.0,.... The first non 9 decimal digit is minor, etc. For example, the version 0.9925a can be thought as 2.2.5a. A perfect bug-free software will be version 1. No precise criteria have been decided about incrementing major or minor versions for now.

## Contributing

Feel free to do a pull request or open an issue, and I will review it. I am open for adding new features, but I also wish to keep this project minimalist. Any useful contribution will be welcomed.

By contributing to rieMiner, you accept to place your code in the MIT license.

Donations welcome:

* Riecoin: ric1qpttn5u8u9470za84kt4y0lzz4zllzm4pyzhuge
* Bitcoin: bc1qpttn5u8u9470za84kt4y0lzz4zllzm4pwvel4c

Or donate directly to the Riecoin project: ric1qr3yxckxtl7lacvtuzhrdrtrlzvlydane2h37ja (RIC), bc1qr3yxckxtl7lacvtuzhrdrtrlzvlydaneqela0u (BTC).

### Quick contributor's checklist

* Your code must compile and work on recent Debian based distributions, and Windows using MSYS;
* If modifying the miner, you must ensure that your changes do not cause any performance loss. You have to do proper and long enough before/after benchmarks;
* Document well non trivial contributions to the miner so other and future developers can understand easily and quickly the code;
* rieMiner must work for any realistic setting, the Test Mode must work as expected;
* Ensure that your changes did not break anything, even if it compiles. Examples (if applicable):
  * There should never be random (or not) segmentation faults or any other bug, try to do actual mining with Gdb, debugging symbols and Debug Mode enabled during hours or even days to catch possible bugs;
  * Ensure that valid work is produced (pools and Riecoin Core must not reject submissions);
  * Mining must stop completely while disconnected and restart properly when connection is established again.
* Follow the style of the rest of the code (curly braces position, camelCase variable names, tabs and not spaces, spaces around + and - but not around * and /,...).
  * Avoid using old C style and prefer modern C++ code;
  * Prefer longer and explicit variable names (except for loops indexes where single letter variables should be used in most cases).

## Resources

* [Riecoin website](https://Riecoin.dev/);
  * [rieMiner's page](https://riecoin.dev/en/rieMiner);
  * [Explanation of the miner algorithm](https://riecoin.dev/en/Mining_Algorithm), you can also learn the theoretics behind some options.
* [Bitcoin Wiki - Getblocktemplate](https://en.bitcoin.it/wiki/Getblocktemplate)
* [BIP141](https://github.com/bitcoin/bips/blob/master/bip-0141.mediawiki) (Segwit)
* [Bitcoin Wiki - Stratum](https://en.bitcoin.it/wiki/Stratum_mining_protocol)
