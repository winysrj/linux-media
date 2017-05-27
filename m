Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:38349 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750732AbdE0T2M (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 27 May 2017 15:28:12 -0400
Received: by mail-wm0-f52.google.com with SMTP id e127so17923284wmg.1
        for <linux-media@vger.kernel.org>; Sat, 27 May 2017 12:28:12 -0700 (PDT)
MIME-Version: 1.0
From: Karl Wallin <karl.wallin.86@gmail.com>
Date: Sat, 27 May 2017 21:28:10 +0200
Message-ID: <CAML3znFcKR9wx3wvjBDeQLn7mbtkhU0Knn56cMrXek6H-mTUjQ@mail.gmail.com>
Subject: Build fails Ubuntu 17.04 / "error: implicit declaration of function"
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

Sorry if this is something I should have figured out, I am bit
experienced with Linux but not at all a pro.

Trying to build v4l-dvb on Ubuntu 17.04 (kernel 4.10.0-21-generic) and
get build errors.

Dependencies are met:

ubuntu@nuc-d54250wyk:~/media_build$ sudo apt-get install
linux-headers-$(uname -r) && sudo apt-get install libdigest-sha-perl
&& sudo apt-get install make && sudo apt-get install make && sudo
apt-get install gcc && sudo apt-get install git && sudo apt-get
install patch && sudo apt-get install patchutils && sudo apt-get
install libproc-processtable-perl
Reading package lists... Done
Building dependency tree
Reading state information... Done
linux-headers-4.10.0-21-generic is already the newest version (4.10.0-21.23=
).
0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
Reading package lists... Done
Building dependency tree
Reading state information... Done
libdigest-sha-perl is already the newest version (5.96-1build1).
0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
Reading package lists... Done
Building dependency tree
Reading state information... Done
make is already the newest version (4.1-9.1).
0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
Reading package lists... Done
Building dependency tree
Reading state information... Done
make is already the newest version (4.1-9.1).
0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
Reading package lists... Done
Building dependency tree
Reading state information... Done
gcc is already the newest version (4:6.3.0-2ubuntu1).
0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
Reading package lists... Done
Building dependency tree
Reading state information... Done
git is already the newest version (1:2.11.0-2ubuntu0.1).
0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
Reading package lists... Done
Building dependency tree
Reading state information... Done
patch is already the newest version (2.7.5-1).
0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
Reading package lists... Done
Building dependency tree
Reading state information... Done
patchutils is already the newest version (0.3.4-2).
0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
Reading package lists... Done
Building dependency tree
Reading state information... Done
libproc-processtable-perl is already the newest version (0.53-2).
0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
ubuntu@nuc-d54250wyk:~/media_build$

Build log:

ubuntu@nuc-d54250wyk:~/media_build$ ./build
Checking if the needed tools for Ubuntu 17.04 are available
Needed package dependencies are met.

************************************************************
* This script will download the latest tarball and build it*
* Assuming that your kernel is compatible with the latest  *
* drivers. If not, you'll need to add some extra backports,*
* ./backports/<kernel> directory.                          *
* It will also update this tree to be sure that all compat *
* bits are there, to avoid compilation failures            *
************************************************************
************************************************************
* All drivers and build system are under GPLv2 License     *
* Firmware files are under the license terms found at:     *
* http://www.linuxtv.org/downloads/firmware/               *
* Please abort in the next 5 secs if you don't agree with  *
* the license                                              *
************************************************************

Not aborted. It means that the licence was agreed. Proceeding...

****************************
Updating the building system
****************************
>From git://linuxtv.org/media_build
 * branch            master     -> FETCH_HEAD
Already up-to-date.
make: Entering directory '/home/ubuntu/media_build/linux'
wget http://linuxtv.org/downloads/drivers/linux-media-LATEST.tar.bz2.md5
-O linux-media.tar.bz2.md5.tmp
--2017-05-27 16:20:16--
http://linuxtv.org/downloads/drivers/linux-media-LATEST.tar.bz2.md5
Resolving linuxtv.org (linuxtv.org)... 130.149.80.248
Connecting to linuxtv.org (linuxtv.org)|130.149.80.248|:80... connected.
HTTP request sent, awaiting response... 301 Moved Permanently
Location: https://linuxtv.org/downloads/drivers/linux-media-LATEST.tar.bz2.=
md5
[following]
--2017-05-27 16:20:16--
https://linuxtv.org/downloads/drivers/linux-media-LATEST.tar.bz2.md5
Connecting to linuxtv.org (linuxtv.org)|130.149.80.248|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 105 [application/x-bzip2]
Saving to: =E2=80=98linux-media.tar.bz2.md5.tmp=E2=80=99

linux-media.tar.bz2 100%[=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D>]     105  --.-KB/s    in 0s

2017-05-27 16:20:16 (5,72 MB/s) - =E2=80=98linux-media.tar.bz2.md5.tmp=E2=
=80=99 saved [105/105]

cat: linux-media.tar.bz2.md5: No such file or directory
--2017-05-27 16:20:16--
http://linuxtv.org/downloads/drivers/linux-media-LATEST.tar.bz2
Resolving linuxtv.org (linuxtv.org)... 130.149.80.248
Connecting to linuxtv.org (linuxtv.org)|130.149.80.248|:80... connected.
HTTP request sent, awaiting response... 301 Moved Permanently
Location: https://linuxtv.org/downloads/drivers/linux-media-LATEST.tar.bz2
[following]
--2017-05-27 16:20:16--
https://linuxtv.org/downloads/drivers/linux-media-LATEST.tar.bz2
Connecting to linuxtv.org (linuxtv.org)|130.149.80.248|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 6388049 (6,1M) [application/x-bzip2]
Saving to: =E2=80=98linux-media.tar.bz2=E2=80=99

linux-media.tar.bz2 100%[=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D>]   6,09M  8,41MB/s    in 0,7s

2017-05-27 16:20:17 (8,41 MB/s) - =E2=80=98linux-media.tar.bz2=E2=80=99 sav=
ed [6388049/6388049]

make: Leaving directory '/home/ubuntu/media_build/linux'
make: Entering directory '/home/ubuntu/media_build/linux'
tar xfj linux-media.tar.bz2
rm -f .patches_applied .linked_dir .git_log.md5
make: Leaving directory '/home/ubuntu/media_build/linux'
**********************************************************
* Downloading firmwares from linuxtv.org.                *
**********************************************************
--2017-05-27 16:20:19--
http://www.linuxtv.org/downloads/firmware//dvb-firmwares.tar.bz2
Resolving www.linuxtv.org (www.linuxtv.org)... 130.149.80.248
Connecting to www.linuxtv.org (www.linuxtv.org)|130.149.80.248|:80... conne=
cted.
HTTP request sent, awaiting response... 301 Moved Permanently
Location: https://www.linuxtv.org/downloads/firmware//dvb-firmwares.tar.bz2
[following]
--2017-05-27 16:20:19--
https://www.linuxtv.org/downloads/firmware//dvb-firmwares.tar.bz2
Connecting to www.linuxtv.org (www.linuxtv.org)|130.149.80.248|:443...
connected.
HTTP request sent, awaiting response... 200 OK
Length: 1235003 (1,2M) [application/x-bzip2]
Saving to: =E2=80=98dvb-firmwares.tar.bz2=E2=80=99

dvb-firmwares.tar.b 100%[=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D>]   1,18M  4,09MB/s    in 0,3s

2017-05-27 16:20:19 (4,09 MB/s) - =E2=80=98dvb-firmwares.tar.bz2=E2=80=99 s=
aved
[1235003/1235003]

as102_data1_st.hex
as102_data2_st.hex
cmmb_vega_12mhz.inp
cmmb_venice_12mhz.inp
dvb-fe-bcm3510-01.fw
dvb-fe-drxj-mc-1.0.8.fw
dvb-fe-drxj-mc-vsb-1.0.8.fw
dvb-fe-drxj-mc-vsb-qam-1.0.8.fw
dvb-fe-or51132-qam.fw
dvb-fe-or51132-vsb.fw
dvb-fe-or51211.fw
dvb-fe-xc4000-1.4.1.fw
dvb-fe-xc5000-1.6.114.fw
dvb-fe-xc5000c-4.1.30.7.fw
dvb-firmwares.tar.bz2
dvb-ttpci-01.fw-261a
dvb-ttpci-01.fw-261b
dvb-ttpci-01.fw-261c
dvb-ttpci-01.fw-261d
dvb-ttpci-01.fw-261f
dvb-ttpci-01.fw-2622
dvb-usb-avertv-a800-02.fw
dvb-usb-bluebird-01.fw
dvb-usb-dib0700-1.20.fw
dvb-usb-dibusb-5.0.0.11.fw
dvb-usb-dibusb-6.0.0.8.fw
dvb-usb-dtt200u-01.fw
dvb-usb-it9135-01.fw
dvb-usb-it9135-02.fw
dvb-usb-terratec-h5-drxk.fw
dvb-usb-terratec-h7-az6007.fw
dvb-usb-terratec-h7-drxk.fw
dvb-usb-umt-010-02.fw
dvb-usb-vp702x-01.fw
dvb-usb-vp7045-01.fw
dvb-usb-wt220u-01.fw
dvb-usb-wt220u-02.fw
dvb_nova_12mhz.inp
dvb_nova_12mhz_b0.inp
isdbt_nova_12mhz.inp
isdbt_nova_12mhz_b0.inp
isdbt_rio.inp
sms1xxx-hcw-55xxx-dvbt-02.fw
sms1xxx-hcw-55xxx-isdbt-02.fw
sms1xxx-nova-a-dvbt-01.fw
sms1xxx-nova-b-dvbt-01.fw
sms1xxx-stellar-dvbt-01.fw
tdmb_nova_12mhz.inp
v4l-cx231xx-avcore-01.fw
v4l-cx23418-apu.fw
v4l-cx23418-cpu.fw
v4l-cx23418-dig.fw
v4l-cx23885-avcore-01.fw
v4l-cx23885-enc-broken.fw
v4l-cx25840.fw
******************
* Start building *
******************
make -C /home/ubuntu/media_build/v4l allyesconfig
make[1]: Entering directory '/home/ubuntu/media_build/v4l'
No version yet, using 4.10.0-21-generic
make[2]: Entering directory '/home/ubuntu/media_build/linux'
Applying patches for kernel 4.10.0-21-generic
patch -s -f -N -p1 -i ../backports/api_version.patch
patch -s -f -N -p1 -i ../backports/pr_fmt.patch
patch -s -f -N -p1 -i ../backports/debug.patch
patch -s -f -N -p1 -i ../backports/drx39xxj.patch
patch -s -f -N -p1 -i ../backports/v4.10_sched_signal.patch
patch -s -f -N -p1 -i ../backports/v4.10_fault_page.patch
patch -s -f -N -p1 -i ../backports/v4.10_refcount.patch
Patched drivers/media/dvb-core/dvbdev.c
Patched drivers/media/v4l2-core/v4l2-dev.c
Patched drivers/media/rc/rc-main.c
make[2]: Leaving directory '/home/ubuntu/media_build/linux'
./scripts/make_kconfig.pl /lib/modules/4.10.0-21-generic/build
/lib/modules/4.10.0-21-generic/build 1
Preparing to compile for kernel version 4.10.0

***WARNING:*** You do not have the full kernel sources installed.
This does not prevent you from building the v4l-dvb tree if you have the
kernel headers, but the full kernel source may be required in order to use
make menuconfig / xconfig / qconfig.

If you are experiencing problems building the v4l-dvb tree, please try
building against a vanilla kernel before reporting a bug.

Vanilla kernels are available at http://kernel.org.
On most distros, this will compile a newly downloaded kernel:

cp /boot/config-`uname -r` <your kernel dir>/.config
cd <your kernel dir>
make all modules_install install

Please see your distro's web site for instructions to build a new kernel.

WARNING: This is the V4L/DVB backport tree, with experimental drivers
 backported to run on legacy kernels from the development tree at:
http://git.linuxtv.org/media-tree.git.
 It is generally safe to use it for testing a new driver or
 feature, but its usage on production environments is risky.
 Don't use it in production. You've been warned.
INTEL_ATOMISP: Requires at least kernel 9.255.255
Created default (all yes) .config file
./scripts/fix_kconfig.pl
make[1]: Leaving directory '/home/ubuntu/media_build/v4l'
make -C /home/ubuntu/media_build/v4l
make[1]: Entering directory '/home/ubuntu/media_build/v4l'
scripts/make_makefile.pl
Can't handle includes! In
../linux/drivers/staging/media/atomisp/pci/atomisp2/css2400/Makefile
at scripts/make_makefile.pl line 109, <GEN153> line 4.
./scripts/make_myconfig.pl
perl scripts/make_config_compat.pl
/lib/modules/4.10.0-21-generic/build ./.myconfig ./config-compat.h
creating symbolic links...
make -C firmware prep
make[2]: Entering directory '/home/ubuntu/media_build/v4l/firmware'
make[2]: Leaving directory '/home/ubuntu/media_build/v4l/firmware'
make -C firmware
make[2]: Entering directory '/home/ubuntu/media_build/v4l/firmware'
  CC  ihex2fw
Generating vicam/firmware.fw
Generating ttusb-budget/dspbootcode.bin
Generating cpia2/stv0672_vp4.bin
Generating av7110/bootcode.bin
make[2]: Leaving directory '/home/ubuntu/media_build/v4l/firmware'
Kernel build directory is /lib/modules/4.10.0-21-generic/build
make -C ../linux apply_patches
make[2]: Entering directory '/home/ubuntu/media_build/linux'
Patches for 4.10.0-21-generic already applied.
make[2]: Leaving directory '/home/ubuntu/media_build/linux'
make -C /lib/modules/4.10.0-21-generic/build
SUBDIRS=3D/home/ubuntu/media_build/v4l  modules
make[2]: Entering directory '/usr/src/linux-headers-4.10.0-21-generic'
  CC [M]  /home/ubuntu/media_build/v4l/cec-core.o
/home/ubuntu/media_build/v4l/cec-core.c: In function 'cec_devnode_register'=
:
/home/ubuntu/media_build/v4l/cec-core.c:142:8: error: implicit
declaration of function 'cdev_device_add'
[-Werror=3Dimplicit-function-declaration]
  ret =3D cdev_device_add(&devnode->cdev, &devnode->dev);
        ^~~~~~~~~~~~~~~
/home/ubuntu/media_build/v4l/cec-core.c: In function 'cec_devnode_unregiste=
r':
/home/ubuntu/media_build/v4l/cec-core.c:186:2: error: implicit
declaration of function 'cdev_device_del'
[-Werror=3Dimplicit-function-declaration]
  cdev_device_del(&devnode->cdev, &devnode->dev);
  ^~~~~~~~~~~~~~~
cc1: some warnings being treated as errors
scripts/Makefile.build:294: recipe for target
'/home/ubuntu/media_build/v4l/cec-core.o' failed
make[3]: *** [/home/ubuntu/media_build/v4l/cec-core.o] Error 1
Makefile:1524: recipe for target '_module_/home/ubuntu/media_build/v4l' fai=
led
make[2]: *** [_module_/home/ubuntu/media_build/v4l] Error 2
make[2]: Leaving directory '/usr/src/linux-headers-4.10.0-21-generic'
Makefile:51: recipe for target 'default' failed
make[1]: *** [default] Error 2
make[1]: Leaving directory '/home/ubuntu/media_build/v4l'
Makefile:26: recipe for target 'all' failed
make: *** [all] Error 2
build failed at ./build line 502.

Would be grateful for any assistance / TheSwede86
