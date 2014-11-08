Return-path: <linux-media-owner@vger.kernel.org>
Received: from pop3.pb.cz ([109.72.0.20]:57575 "EHLO pop3.pb.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932081AbaKHSSo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 8 Nov 2014 13:18:44 -0500
Received: from [192.168.1.15] (unknown [109.72.4.22])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by pop3.pb.cz (Postfix) with ESMTPS id C561180980
	for <linux-media@vger.kernel.org>; Sat,  8 Nov 2014 19:18:37 +0100 (CET)
Message-ID: <545E5E7D.4060402@mizera.cz>
Date: Sat, 08 Nov 2014 19:18:37 +0100
From: kapetr@mizera.cz
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: AF9035 not builded from git
Content-Type: multipart/mixed;
 boundary="------------090106020706090303080507"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090106020706090303080507
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Content-Transfer-Encoding: 8bit

Hello.

The Problem still persist.

In attachment is log of ./build command - the module dvb-usb-af9035 is 
not buided.

./v4l/af9035.c/h are there ?!

I would be really happy to watch my TV again.
Could someone check where is the problem ?
Maybe in makefiles ? (I don't understand them).

Thanks.

--kapetr

xxxxxxxxxxxxxxxxxxxxxxxx orig post:

Hello.

I have:
Bus 001 Device 004: ID 048d:9135 Integrated Technology Express, Inc. 
Zolid Mini DVB-T Stick

This is well supported DVB-T USB card - used successfully with
dvb-usb-af9035 module.

Till now.


After every kernel update I have to rebuild v4l driver.

After last time (with kernel 3.2.0-70-generic #105-Ubuntu SMP Wed Sep 24 
19:49:16 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux)

the build process has end successfully, but there is not builded this 
module, what I need ?-(

xxxxxxxxxxxxx

git clone --depth=1 git://linuxtv.org/media_build.git
cd media_build/
./build
sudo make install

xxxxxxxxxxxxx there are only these modules installed:

$ ll /lib/modules/3.2.0-70-generic/kernel/drivers/media/usb/dvb-usb/
celkem 1,1M
drwxr-xr-x  2 root root 4,0K ¯Ìj 30 09:34 ./
drwxr-xr-x 21 root root 4,0K ¯Ìj 30 09:34 ../
-rw-r--r--  1 root root  61K ¯Ìj 30 09:34 dvb-usb-af9005.ko
-rw-r--r--  1 root root 7,3K ¯Ìj 30 09:34 dvb-usb-af9005-remote.ko
-rw-r--r--  1 root root  31K ¯Ìj 30 09:34 dvb-usb-az6027.ko
-rw-r--r--  1 root root  14K ¯Ìj 30 09:34 dvb-usb-a800.ko
-rw-r--r--  1 root root  18K ¯Ìj 30 09:34 dvb-usb-cinergyT2.ko
-rw-r--r--  1 root root 100K ¯Ìj 30 09:34 dvb-usb-cxusb.ko
-rw-r--r--  1 root root  18K ¯Ìj 30 09:34 dvb-usb-dibusb-common.ko
-rw-r--r--  1 root root  32K ¯Ìj 30 09:34 dvb-usb-dibusb-mb.ko
-rw-r--r--  1 root root  14K ¯Ìj 30 09:34 dvb-usb-dibusb-mc.ko
-rw-r--r--  1 root root 210K ¯Ìj 30 09:34 dvb-usb-dib0700.ko
-rw-r--r--  1 root root  18K ¯Ìj 30 09:34 dvb-usb-digitv.ko
-rw-r--r--  1 root root  35K ¯Ìj 30 09:34 dvb-usb-dtt200u.ko
-rw-r--r--  1 root root  15K ¯Ìj 30 09:34 dvb-usb-dtv5100.ko
-rw-r--r--  1 root root  82K ¯Ìj 30 09:34 dvb-usb-dw2102.ko
-rw-r--r--  1 root root  25K ¯Ìj 30 09:34 dvb-usb-friio.ko
-rw-r--r--  1 root root  26K ¯Ìj 30 09:34 dvb-usb-gp8psk.ko
-rw-r--r--  1 root root  44K ¯Ìj 30 09:34 dvb-usb.ko
-rw-r--r--  1 root root  58K ¯Ìj 30 09:34 dvb-usb-m920x.ko
-rw-r--r--  1 root root  14K ¯Ìj 30 09:34 dvb-usb-nova-t-usb2.ko
-rw-r--r--  1 root root  21K ¯Ìj 30 09:34 dvb-usb-opera.ko
-rw-r--r--  1 root root  34K ¯Ìj 30 09:34 dvb-usb-pctv452e.ko
-rw-r--r--  1 root root  23K ¯Ìj 30 09:34 dvb-usb-technisat-usb2.ko
-rw-r--r--  1 root root  37K ¯Ìj 30 09:34 dvb-usb-ttusb2.ko
-rw-r--r--  1 root root  14K ¯Ìj 30 09:34 dvb-usb-umt-010.ko
-rw-r--r--  1 root root  26K ¯Ìj 30 09:34 dvb-usb-vp702x.ko
-rw-r--r--  1 root root  21K ¯Ìj 30 09:34 dvb-usb-vp7045.ko

$ ll /lib/modules/3.2.0-70-generic/kernel/drivers/media/usb/dvb-usb-v2/
celkem 324K
drwxr-xr-x  2 root root 4,0K ¯Ìj 30 09:34 ./
drwxr-xr-x 21 root root 4,0K ¯Ìj 30 09:34 ../
-rw-r--r--  1 root root  43K ¯Ìj 30 09:34 dvb-usb-af9015.ko
-rw-r--r--  1 root root  12K ¯Ìj 30 09:34 dvb-usb-au6610.ko
-rw-r--r--  1 root root  26K ¯Ìj 30 09:34 dvb-usb-az6007.ko
-rw-r--r--  1 root root  13K ¯Ìj 30 09:34 dvb-usb-ce6230.ko
-rw-r--r--  1 root root  15K ¯Ìj 30 09:34 dvb-usb-ec168.ko
-rw-r--r--  1 root root  12K ¯Ìj 30 09:34 dvb-usb-gl861.ko
-rw-r--r--  1 root root  36K ¯Ìj 30 09:34 dvb-usb-lmedm04.ko
-rw-r--r--  1 root root  82K ¯Ìj 30 09:34 dvb-usb-mxl111sf.ko
-rw-r--r--  1 root root  34K ¯Ìj 30 09:34 dvb_usb_v2.ko
-rw-r--r--  1 root root  15K ¯Ìj 30 09:34 mxl111sf-demod.ko
-rw-r--r--  1 root root  13K ¯Ìj 30 09:34 mxl111sf-tuner.ko

xxxxxxxxx


Thanks for help

--kapetr

--------------090106020706090303080507
Content-Type: text/plain; charset=UTF-8;
 name="log.txt"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename="log.txt"

Checking if the needed tools for Ubuntu 12.04.5 LTS are available
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
make: Entering directory `/home/hugo/tmp/media_build/linux'
wget http://linuxtv.org/downloads/drivers/linux-media-LATEST.tar.bz2.md5 -O linux-media.tar.bz2.md5.tmp
--2014-10-30 11:18:01--  http://linuxtv.org/downloads/drivers/linux-media-LATEST.tar.bz2.md5
P≈ôekl√°d√°m linuxtv.org (linuxtv.org)‚Ä¶ 130.149.80.248
Navazuje se spojen√≠ s¬†linuxtv.org (linuxtv.org)|130.149.80.248|:80‚Ä¶ spojeno.
HTTP po≈æadavek odesl√°n, program ƒçek√° na odpovƒõƒè‚Ä¶ 200 OK
D√©lka: 101 [application/x-bzip2]
Ukl√°d√°m do: ‚Äûlinux-media.tar.bz2.md5.tmp‚Äú

     0K                                                       100% 14,9M=0s

2014-10-30 11:18:01 (14,9 MB/s)¬†‚Äì ‚Äûlinux-media.tar.bz2.md5.tmp‚Äú ulo≈æeno [101/101]

make: Leaving directory `/home/hugo/tmp/media_build/linux'
make: Entering directory `/home/hugo/tmp/media_build/linux'
tar xfj linux-media.tar.bz2
rm -f .patches_applied .linked_dir .git_log.md5
make: Leaving directory `/home/hugo/tmp/media_build/linux'
**********************************************************
* Downloading firmwares from linuxtv.org.                *
**********************************************************
Boot.S
as102_data1_st.hex
as102_data2_st.hex
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
make -C /home/hugo/tmp/media_build/v4l allyesconfig
make[1]: Entering directory `/home/hugo/tmp/media_build/v4l'
make[2]: Entering directory `/home/hugo/tmp/media_build/linux'
Applying patches for kernel 3.2.0-70-generic
patch -s -f -N -p1 -i ../backports/api_version.patch
patch -s -f -N -p1 -i ../backports/pr_fmt.patch
patch -s -f -N -p1 -i ../backports/debug.patch
patch -s -f -N -p1 -i ../backports/drx39xxj.patch
patch -s -f -N -p1 -i ../backports/v3.16_netdev.patch
patch -s -f -N -p1 -i ../backports/v3.16_wait_on_bit.patch
patch -s -f -N -p1 -i ../backports/v3.16_void_gpiochip_remove.patch
patch -s -f -N -p1 -i ../backports/v3.11_dev_groups.patch
patch -s -f -N -p1 -i ../backports/v3.10_fw_driver_probe.patch
patch -s -f -N -p1 -i ../backports/v3.10_ir_hix5hd2.patch
patch -s -f -N -p1 -i ../backports/v3.9_pfn_warning.patch
patch -s -f -N -p1 -i ../backports/v3.9_drxj_warnings.patch
patch -s -f -N -p1 -i ../backports/v3.8_config_of.patch
patch -s -f -N -p1 -i ../backports/v3.6_pci_error_handlers.patch
patch -s -f -N -p1 -i ../backports/v3.6_i2c_add_mux_adapter.patch
patch -s -f -N -p1 -i ../backports/v3.4_i2c_add_mux_adapter.patch
patch -s -f -N -p1 -i ../backports/v3.2_devnode_uses_mode_t.patch
patch -s -f -N -p1 -i ../backports/v3.2_alloc_ordered_workqueue.patch
Patched drivers/media/dvb-core/dvbdev.c
Patched drivers/media/v4l2-core/v4l2-dev.c
Patched drivers/media/rc/rc-main.c
make[2]: Leaving directory `/home/hugo/tmp/media_build/linux'
./scripts/make_kconfig.pl /lib/modules/3.2.0-70-generic/build /lib/modules/3.2.0-70-generic/build 1
Preparing to compile for kernel version 3.2.0

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
VIDEOBUF2_DMA_CONTIG: Requires at least kernel 3.6.0
IR_HIX5HD2: Requires at least kernel 3.10.0
IR_IMG: Requires at least kernel 3.9.0
IR_GPIO_CIR: Requires at least kernel 3.4.0
RC_ST: Requires at least kernel 3.15.0
DVB_PT3: Requires at least kernel 3.11.0
VIDEO_RCAR_VIN: Requires at least kernel 3.9.0
VIDEO_CODA: Requires at least kernel 3.5.0
VIDEO_MEM2MEM_DEINTERLACE: Requires at least kernel 3.3.0
VIDEO_SH_VEU: Requires at least kernel 3.9.0
VIDEO_RENESAS_VSP1: Requires at least kernel 3.9.0
VIDEO_ADV7183: Requires at least kernel 3.5.0
VIDEO_ADV7604: Requires at least kernel 3.13.0
VIDEO_TVP514X: Requires at least kernel 3.3.0
VIDEO_TVP7002: Requires at least kernel 3.3.0
VIDEO_ADV7343: Requires at least kernel 3.4.0
VIDEO_OV9650: Requires at least kernel 3.5.0
VIDEO_VS6624: Requires at least kernel 3.5.0
VIDEO_MT9P031: Requires at least kernel 3.5.0
VIDEO_MT9T001: Requires at least kernel 3.5.0
VIDEO_MT9V032: Requires at least kernel 3.5.0
VIDEO_NOON010PC30: Requires at least kernel 3.5.0
VIDEO_M5MOLS: Requires at least kernel 3.6.0
VIDEO_S5K6AA: Requires at least kernel 3.5.0
VIDEO_S5K6A3: Requires at least kernel 3.5.0
VIDEO_S5K4ECGX: Requires at least kernel 3.4.0
VIDEO_S5K5BAF: Requires at least kernel 3.5.0
VIDEO_S5C73M3: Requires at least kernel 3.6.0
VIDEO_LM3560: Requires at least kernel 3.4.0
VIDEO_LM3646: Requires at least kernel 3.4.0
MEDIA_TUNER_MSI001: Requires at least kernel 3.4.0
MEDIA_TUNER_TDA18212: Requires at least kernel 3.4.0
MEDIA_TUNER_E4000: Requires at least kernel 3.5.0
MEDIA_TUNER_M88TS2022: Requires at least kernel 3.4.0
MEDIA_TUNER_IT913X: Requires at least kernel 3.4.0
DVB_M88DS3103: Requires at least kernel 3.7.0
Created default (all yes) .config file
./scripts/fix_kconfig.pl
make[1]: Leaving directory `/home/hugo/tmp/media_build/v4l'
make -C /home/hugo/tmp/media_build/v4l 
make[1]: Entering directory `/home/hugo/tmp/media_build/v4l'
./scripts/make_myconfig.pl
make[1]: Leaving directory `/home/hugo/tmp/media_build/v4l'
make[1]: Entering directory `/home/hugo/tmp/media_build/v4l'
perl scripts/make_config_compat.pl /lib/modules/3.2.0-70-generic/build ./.myconfig ./config-compat.h
creating symbolic links...
make -C firmware prep
make[2]: Entering directory `/home/hugo/tmp/media_build/v4l/firmware'
make[2]: Leaving directory `/home/hugo/tmp/media_build/v4l/firmware'
make -C firmware
make[2]: Entering directory `/home/hugo/tmp/media_build/v4l/firmware'
  CC  ihex2fw
Generating vicam/firmware.fw
Generating ttusb-budget/dspbootcode.bin
Generating cpia2/stv0672_vp4.bin
Generating av7110/bootcode.bin
make[2]: Leaving directory `/home/hugo/tmp/media_build/v4l/firmware'
Kernel build directory is /lib/modules/3.2.0-70-generic/build
make -C ../linux apply_patches
make[2]: Entering directory `/home/hugo/tmp/media_build/linux'
Patches for 3.2.0-70-generic already applied.
make[2]: Leaving directory `/home/hugo/tmp/media_build/linux'
make -C /lib/modules/3.2.0-70-generic/build SUBDIRS=/home/hugo/tmp/media_build/v4l  modules
make[2]: Entering directory `/usr/src/linux-headers-3.2.0-70-generic'
  CC [M]  /home/hugo/tmp/media_build/v4l/altera-lpt.o
  CC [M]  /home/hugo/tmp/media_build/v4l/altera-jtag.o
  CC [M]  /home/hugo/tmp/media_build/v4l/altera-comp.o
  CC [M]  /home/hugo/tmp/media_build/v4l/altera.o
  CC [M]  /home/hugo/tmp/media_build/v4l/au0828-core.o
  CC [M]  /home/hugo/tmp/media_build/v4l/au0828-i2c.o
  CC [M]  /home/hugo/tmp/media_build/v4l/au0828-cards.o
  CC [M]  /home/hugo/tmp/media_build/v4l/au0828-dvb.o
  CC [M]  /home/hugo/tmp/media_build/v4l/au0828-video.o
  CC [M]  /home/hugo/tmp/media_build/v4l/au0828-vbi.o
  CC [M]  /home/hugo/tmp/media_build/v4l/au0828-input.o
  CC [M]  /home/hugo/tmp/media_build/v4l/flexcop-dma.o
  CC [M]  /home/hugo/tmp/media_build/v4l/flexcop-pci.o
  CC [M]  /home/hugo/tmp/media_build/v4l/flexcop-usb.o
  CC [M]  /home/hugo/tmp/media_build/v4l/flexcop.o
  CC [M]  /home/hugo/tmp/media_build/v4l/flexcop-fe-tuner.o
  CC [M]  /home/hugo/tmp/media_build/v4l/flexcop-i2c.o
  CC [M]  /home/hugo/tmp/media_build/v4l/flexcop-sram.o
  CC [M]  /home/hugo/tmp/media_build/v4l/flexcop-eeprom.o
  CC [M]  /home/hugo/tmp/media_build/v4l/flexcop-misc.o
  CC [M]  /home/hugo/tmp/media_build/v4l/flexcop-hw-filter.o
  CC [M]  /home/hugo/tmp/media_build/v4l/bttv-driver.o
  CC [M]  /home/hugo/tmp/media_build/v4l/bttv-cards.o
  CC [M]  /home/hugo/tmp/media_build/v4l/bttv-if.o
  CC [M]  /home/hugo/tmp/media_build/v4l/bttv-risc.o
  CC [M]  /home/hugo/tmp/media_build/v4l/bttv-vbi.o
  CC [M]  /home/hugo/tmp/media_build/v4l/bttv-i2c.o
  CC [M]  /home/hugo/tmp/media_build/v4l/bttv-gpio.o
  CC [M]  /home/hugo/tmp/media_build/v4l/bttv-input.o
  CC [M]  /home/hugo/tmp/media_build/v4l/bttv-audio-hook.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cpia2_v4l.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cpia2_usb.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cpia2_core.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx18-alsa-main.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx18-alsa-pcm.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx18-driver.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx18-cards.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx18-i2c.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx18-firmware.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx18-gpio.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx18-queue.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx18-streams.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx18-fileops.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx18-ioctl.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx18-controls.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx18-mailbox.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx18-vbi.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx18-audio.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx18-video.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx18-irq.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx18-av-core.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx18-av-audio.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx18-av-firmware.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx18-av-vbi.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx18-scb.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx18-dvb.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx18-io.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx231xx-audio.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx231xx-video.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx231xx-i2c.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx231xx-cards.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx231xx-core.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx231xx-avcore.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx231xx-417.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx231xx-pcb-cfg.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx231xx-vbi.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx231xx-input.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx25821-core.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx25821-cards.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx25821-i2c.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx25821-gpio.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx25821-medusa-video.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx25821-video.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx25821-video-upstream.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx25840-core.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx25840-audio.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx25840-firmware.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx25840-vbi.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx25840-ir.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx88-video.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx88-vbi.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx88-mpeg.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx88-cards.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx88-core.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx88-i2c.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx88-tvaudio.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx88-dsp.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx88-input.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cxd2820r_core.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cxd2820r_c.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cxd2820r_t.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cxd2820r_t2.o
  CC [M]  /home/hugo/tmp/media_build/v4l/ddbridge-core.o
  CC [M]  /home/hugo/tmp/media_build/v4l/drxj.o
  CC [M]  /home/hugo/tmp/media_build/v4l/drxd_firm.o
  CC [M]  /home/hugo/tmp/media_build/v4l/drxd_hard.o
  CC [M]  /home/hugo/tmp/media_build/v4l/drxk_hard.o
  CC [M]  /home/hugo/tmp/media_build/v4l/as102_drv.o
  CC [M]  /home/hugo/tmp/media_build/v4l/as102_fw.o
  CC [M]  /home/hugo/tmp/media_build/v4l/as10x_cmd.o
  CC [M]  /home/hugo/tmp/media_build/v4l/as10x_cmd_stream.o
  CC [M]  /home/hugo/tmp/media_build/v4l/as102_usb_drv.o
  CC [M]  /home/hugo/tmp/media_build/v4l/as10x_cmd_cfg.o
  CC [M]  /home/hugo/tmp/media_build/v4l/dvbdev.o
  CC [M]  /home/hugo/tmp/media_build/v4l/dmxdev.o
  CC [M]  /home/hugo/tmp/media_build/v4l/dvb_demux.o
  CC [M]  /home/hugo/tmp/media_build/v4l/dvb_filter.o
  CC [M]  /home/hugo/tmp/media_build/v4l/dvb_ca_en50221.o
  CC [M]  /home/hugo/tmp/media_build/v4l/dvb_frontend.o
  CC [M]  /home/hugo/tmp/media_build/v4l/dvb_net.o
  CC [M]  /home/hugo/tmp/media_build/v4l/dvb_ringbuffer.o
  CC [M]  /home/hugo/tmp/media_build/v4l/dvb_math.o
  CC [M]  /home/hugo/tmp/media_build/v4l/av7110_hw.o
  CC [M]  /home/hugo/tmp/media_build/v4l/av7110_v4l.o
  CC [M]  /home/hugo/tmp/media_build/v4l/av7110_av.o
  CC [M]  /home/hugo/tmp/media_build/v4l/av7110_ca.o
  CC [M]  /home/hugo/tmp/media_build/v4l/av7110.o
  CC [M]  /home/hugo/tmp/media_build/v4l/av7110_ipack.o
  CC [M]  /home/hugo/tmp/media_build/v4l/av7110_ir.o
  CC [M]  /home/hugo/tmp/media_build/v4l/a800.o
  CC [M]  /home/hugo/tmp/media_build/v4l/af9005-remote.o
  CC [M]  /home/hugo/tmp/media_build/v4l/af9005.o
  CC [M]  /home/hugo/tmp/media_build/v4l/af9005-fe.o
  CC [M]  /home/hugo/tmp/media_build/v4l/af9015.o
  CC [M]  /home/hugo/tmp/media_build/v4l/au6610.o
  CC [M]  /home/hugo/tmp/media_build/v4l/az6007.o
  CC [M]  /home/hugo/tmp/media_build/v4l/az6027.o
  CC [M]  /home/hugo/tmp/media_build/v4l/ce6230.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cinergyT2-core.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cinergyT2-fe.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cxusb.o
  CC [M]  /home/hugo/tmp/media_build/v4l/dib0700_core.o
  CC [M]  /home/hugo/tmp/media_build/v4l/dib0700_devices.o
  CC [M]  /home/hugo/tmp/media_build/v4l/dibusb-common.o
  CC [M]  /home/hugo/tmp/media_build/v4l/dibusb-mb.o
  CC [M]  /home/hugo/tmp/media_build/v4l/dibusb-mc.o
  CC [M]  /home/hugo/tmp/media_build/v4l/digitv.o
  CC [M]  /home/hugo/tmp/media_build/v4l/dtt200u.o
  CC [M]  /home/hugo/tmp/media_build/v4l/dtt200u-fe.o
  CC [M]  /home/hugo/tmp/media_build/v4l/dtv5100.o
  CC [M]  /home/hugo/tmp/media_build/v4l/dw2102.o
  CC [M]  /home/hugo/tmp/media_build/v4l/ec168.o
  CC [M]  /home/hugo/tmp/media_build/v4l/friio.o
  CC [M]  /home/hugo/tmp/media_build/v4l/friio-fe.o
  CC [M]  /home/hugo/tmp/media_build/v4l/gl861.o
  CC [M]  /home/hugo/tmp/media_build/v4l/gp8psk.o
  CC [M]  /home/hugo/tmp/media_build/v4l/gp8psk-fe.o
  CC [M]  /home/hugo/tmp/media_build/v4l/lmedm04.o
  CC [M]  /home/hugo/tmp/media_build/v4l/m920x.o
  CC [M]  /home/hugo/tmp/media_build/v4l/mxl111sf.o
  CC [M]  /home/hugo/tmp/media_build/v4l/mxl111sf-phy.o
  CC [M]  /home/hugo/tmp/media_build/v4l/mxl111sf-i2c.o
  CC [M]  /home/hugo/tmp/media_build/v4l/mxl111sf-gpio.o
  CC [M]  /home/hugo/tmp/media_build/v4l/nova-t-usb2.o
  CC [M]  /home/hugo/tmp/media_build/v4l/opera1.o
  CC [M]  /home/hugo/tmp/media_build/v4l/pctv452e.o
  CC [M]  /home/hugo/tmp/media_build/v4l/technisat-usb2.o
  CC [M]  /home/hugo/tmp/media_build/v4l/ttusb2.o
  CC [M]  /home/hugo/tmp/media_build/v4l/umt-010.o
  CC [M]  /home/hugo/tmp/media_build/v4l/vp702x.o
  CC [M]  /home/hugo/tmp/media_build/v4l/vp702x-fe.o
  CC [M]  /home/hugo/tmp/media_build/v4l/vp7045.o
  CC [M]  /home/hugo/tmp/media_build/v4l/vp7045-fe.o
  CC [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-firmware.o
  CC [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-init.o
  CC [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-urb.o
  CC [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-i2c.o
  CC [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-dvb.o
  CC [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-remote.o
  CC [M]  /home/hugo/tmp/media_build/v4l/usb-urb.o
  CC [M]  /home/hugo/tmp/media_build/v4l/dvb_usb_core.o
  CC [M]  /home/hugo/tmp/media_build/v4l/dvb_usb_urb.o
  CC [M]  /home/hugo/tmp/media_build/v4l/usb_urb.o
  CC [M]  /home/hugo/tmp/media_build/v4l/pt1.o
  CC [M]  /home/hugo/tmp/media_build/v4l/va1j5jf8007s.o
  CC [M]  /home/hugo/tmp/media_build/v4l/va1j5jf8007t.o
  CC [M]  /home/hugo/tmp/media_build/v4l/em28xx-audio.o
  CC [M]  /home/hugo/tmp/media_build/v4l/em28xx-input.o
  CC [M]  /home/hugo/tmp/media_build/v4l/em28xx-core.o
  CC [M]  /home/hugo/tmp/media_build/v4l/em28xx-i2c.o
  CC [M]  /home/hugo/tmp/media_build/v4l/em28xx-cards.o
  CC [M]  /home/hugo/tmp/media_build/v4l/em28xx-camera.o
  CC [M]  /home/hugo/tmp/media_build/v4l/firedtv-avc.o
  CC [M]  /home/hugo/tmp/media_build/v4l/firedtv-ci.o
  CC [M]  /home/hugo/tmp/media_build/v4l/firedtv-dvb.o
  CC [M]  /home/hugo/tmp/media_build/v4l/firedtv-fe.o
  CC [M]  /home/hugo/tmp/media_build/v4l/firedtv-fw.o
  CC [M]  /home/hugo/tmp/media_build/v4l/firedtv-rc.o
  CC [M]  /home/hugo/tmp/media_build/v4l/benq.o
  CC [M]  /home/hugo/tmp/media_build/v4l/conex.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cpia1.o
  CC [M]  /home/hugo/tmp/media_build/v4l/dtcs033.o
  CC [M]  /home/hugo/tmp/media_build/v4l/etoms.o
  CC [M]  /home/hugo/tmp/media_build/v4l/finepix.o
  CC [M]  /home/hugo/tmp/media_build/v4l/gl860.o
  CC [M]  /home/hugo/tmp/media_build/v4l/gl860-mi1320.o
  CC [M]  /home/hugo/tmp/media_build/v4l/gl860-ov2640.o
  CC [M]  /home/hugo/tmp/media_build/v4l/gl860-ov9655.o
  CC [M]  /home/hugo/tmp/media_build/v4l/gl860-mi2020.o
  CC [M]  /home/hugo/tmp/media_build/v4l/jeilinj.o
  CC [M]  /home/hugo/tmp/media_build/v4l/jl2005bcd.o
  CC [M]  /home/hugo/tmp/media_build/v4l/kinect.o
  CC [M]  /home/hugo/tmp/media_build/v4l/konica.o
  CC [M]  /home/hugo/tmp/media_build/v4l/m5602_core.o
  CC [M]  /home/hugo/tmp/media_build/v4l/m5602_ov9650.o
  CC [M]  /home/hugo/tmp/media_build/v4l/m5602_ov7660.o
  CC [M]  /home/hugo/tmp/media_build/v4l/m5602_mt9m111.o
  CC [M]  /home/hugo/tmp/media_build/v4l/m5602_po1030.o
  CC [M]  /home/hugo/tmp/media_build/v4l/m5602_s5k83a.o
  CC [M]  /home/hugo/tmp/media_build/v4l/m5602_s5k4aa.o
  CC [M]  /home/hugo/tmp/media_build/v4l/gspca.o
  CC [M]  /home/hugo/tmp/media_build/v4l/autogain_functions.o
  CC [M]  /home/hugo/tmp/media_build/v4l/mars.o
  CC [M]  /home/hugo/tmp/media_build/v4l/mr97310a.o
  CC [M]  /home/hugo/tmp/media_build/v4l/nw80x.o
  CC [M]  /home/hugo/tmp/media_build/v4l/ov519.o
  CC [M]  /home/hugo/tmp/media_build/v4l/ov534.o
  CC [M]  /home/hugo/tmp/media_build/v4l/ov534_9.o
  CC [M]  /home/hugo/tmp/media_build/v4l/pac207.o
  CC [M]  /home/hugo/tmp/media_build/v4l/pac7302.o
  CC [M]  /home/hugo/tmp/media_build/v4l/pac7311.o
  CC [M]  /home/hugo/tmp/media_build/v4l/se401.o
  CC [M]  /home/hugo/tmp/media_build/v4l/sn9c2028.o
  CC [M]  /home/hugo/tmp/media_build/v4l/sn9c20x.o
  CC [M]  /home/hugo/tmp/media_build/v4l/sonixb.o
  CC [M]  /home/hugo/tmp/media_build/v4l/sonixj.o
  CC [M]  /home/hugo/tmp/media_build/v4l/spca1528.o
  CC [M]  /home/hugo/tmp/media_build/v4l/spca500.o
  CC [M]  /home/hugo/tmp/media_build/v4l/spca501.o
  CC [M]  /home/hugo/tmp/media_build/v4l/spca505.o
  CC [M]  /home/hugo/tmp/media_build/v4l/spca506.o
  CC [M]  /home/hugo/tmp/media_build/v4l/spca508.o
  CC [M]  /home/hugo/tmp/media_build/v4l/spca561.o
  CC [M]  /home/hugo/tmp/media_build/v4l/sq905.o
  CC [M]  /home/hugo/tmp/media_build/v4l/sq905c.o
  CC [M]  /home/hugo/tmp/media_build/v4l/sq930x.o
  CC [M]  /home/hugo/tmp/media_build/v4l/stk014.o
  CC [M]  /home/hugo/tmp/media_build/v4l/stk1135.o
  CC [M]  /home/hugo/tmp/media_build/v4l/stv0680.o
  CC [M]  /home/hugo/tmp/media_build/v4l/stv06xx.o
  CC [M]  /home/hugo/tmp/media_build/v4l/stv06xx_vv6410.o
  CC [M]  /home/hugo/tmp/media_build/v4l/stv06xx_hdcs.o
  CC [M]  /home/hugo/tmp/media_build/v4l/stv06xx_pb0100.o
  CC [M]  /home/hugo/tmp/media_build/v4l/stv06xx_st6422.o
  CC [M]  /home/hugo/tmp/media_build/v4l/sunplus.o
  CC [M]  /home/hugo/tmp/media_build/v4l/t613.o
  CC [M]  /home/hugo/tmp/media_build/v4l/topro.o
  CC [M]  /home/hugo/tmp/media_build/v4l/tv8532.o
  CC [M]  /home/hugo/tmp/media_build/v4l/vc032x.o
  CC [M]  /home/hugo/tmp/media_build/v4l/vicam.o
  CC [M]  /home/hugo/tmp/media_build/v4l/xirlink_cit.o
  CC [M]  /home/hugo/tmp/media_build/v4l/zc3xx.o
  CC [M]  /home/hugo/tmp/media_build/v4l/hdpvr-control.o
  CC [M]  /home/hugo/tmp/media_build/v4l/hdpvr-core.o
  CC [M]  /home/hugo/tmp/media_build/v4l/hdpvr-video.o
  CC [M]  /home/hugo/tmp/media_build/v4l/hdpvr-i2c.o
  CC [M]  /home/hugo/tmp/media_build/v4l/hopper_cards.o
  CC [M]  /home/hugo/tmp/media_build/v4l/hopper_vp3028.o
  CC [M]  /home/hugo/tmp/media_build/v4l/ivtv-alsa-main.o
  CC [M]  /home/hugo/tmp/media_build/v4l/ivtv-alsa-pcm.o
  CC [M]  /home/hugo/tmp/media_build/v4l/ivtv-routing.o
  CC [M]  /home/hugo/tmp/media_build/v4l/ivtv-cards.o
  CC [M]  /home/hugo/tmp/media_build/v4l/ivtv-controls.o
  CC [M]  /home/hugo/tmp/media_build/v4l/ivtv-driver.o
  CC [M]  /home/hugo/tmp/media_build/v4l/ivtv-fileops.o
  CC [M]  /home/hugo/tmp/media_build/v4l/ivtv-firmware.o
  CC [M]  /home/hugo/tmp/media_build/v4l/ivtv-gpio.o
  CC [M]  /home/hugo/tmp/media_build/v4l/ivtv-i2c.o
  CC [M]  /home/hugo/tmp/media_build/v4l/ivtv-ioctl.o
  CC [M]  /home/hugo/tmp/media_build/v4l/ivtv-irq.o
  CC [M]  /home/hugo/tmp/media_build/v4l/ivtv-mailbox.o
  CC [M]  /home/hugo/tmp/media_build/v4l/ivtv-queue.o
  CC [M]  /home/hugo/tmp/media_build/v4l/ivtv-streams.o
  CC [M]  /home/hugo/tmp/media_build/v4l/ivtv-udma.o
  CC [M]  /home/hugo/tmp/media_build/v4l/ivtv-vbi.o
  CC [M]  /home/hugo/tmp/media_build/v4l/ivtv-yuv.o
  CC [M]  /home/hugo/tmp/media_build/v4l/mantis_cards.o
  CC [M]  /home/hugo/tmp/media_build/v4l/mantis_vp1033.o
  CC [M]  /home/hugo/tmp/media_build/v4l/mantis_vp1034.o
  CC [M]  /home/hugo/tmp/media_build/v4l/mantis_vp1041.o
  CC [M]  /home/hugo/tmp/media_build/v4l/mantis_vp2033.o
  CC [M]  /home/hugo/tmp/media_build/v4l/mantis_vp2040.o
  CC [M]  /home/hugo/tmp/media_build/v4l/mantis_vp3030.o
  CC [M]  /home/hugo/tmp/media_build/v4l/mantis_ioc.o
  CC [M]  /home/hugo/tmp/media_build/v4l/mantis_uart.o
  CC [M]  /home/hugo/tmp/media_build/v4l/mantis_dma.o
  CC [M]  /home/hugo/tmp/media_build/v4l/mantis_pci.o
  CC [M]  /home/hugo/tmp/media_build/v4l/mantis_i2c.o
  CC [M]  /home/hugo/tmp/media_build/v4l/mantis_dvb.o
  CC [M]  /home/hugo/tmp/media_build/v4l/mantis_evm.o
  CC [M]  /home/hugo/tmp/media_build/v4l/mantis_hif.o
  CC [M]  /home/hugo/tmp/media_build/v4l/mantis_ca.o
  CC [M]  /home/hugo/tmp/media_build/v4l/mantis_pcmcia.o
  CC [M]  /home/hugo/tmp/media_build/v4l/mantis_input.o
  CC [M]  /home/hugo/tmp/media_build/v4l/media-device.o
  CC [M]  /home/hugo/tmp/media_build/v4l/media-devnode.o
  CC [M]  /home/hugo/tmp/media_build/v4l/media-entity.o
  CC [M]  /home/hugo/tmp/media_build/v4l/msp3400-driver.o
  CC [M]  /home/hugo/tmp/media_build/v4l/msp3400-kthreads.o
  CC [M]  /home/hugo/tmp/media_build/v4l/ngene-core.o
  CC [M]  /home/hugo/tmp/media_build/v4l/ngene-i2c.o
  CC [M]  /home/hugo/tmp/media_build/v4l/ngene-cards.o
  CC [M]  /home/hugo/tmp/media_build/v4l/ngene-dvb.o
  CC [M]  /home/hugo/tmp/media_build/v4l/pd-video.o
  CC [M]  /home/hugo/tmp/media_build/v4l/pd-alsa.o
  CC [M]  /home/hugo/tmp/media_build/v4l/pd-dvb.o
  CC [M]  /home/hugo/tmp/media_build/v4l/pd-radio.o
  CC [M]  /home/hugo/tmp/media_build/v4l/pd-main.o
  CC [M]  /home/hugo/tmp/media_build/v4l/pvrusb2-i2c-core.o
  CC [M]  /home/hugo/tmp/media_build/v4l/pvrusb2-audio.o
  CC [M]  /home/hugo/tmp/media_build/v4l/pvrusb2-encoder.o
  CC [M]  /home/hugo/tmp/media_build/v4l/pvrusb2-video-v4l.o
  CC [M]  /home/hugo/tmp/media_build/v4l/pvrusb2-eeprom.o
  CC [M]  /home/hugo/tmp/media_build/v4l/pvrusb2-main.o
  CC [M]  /home/hugo/tmp/media_build/v4l/pvrusb2-hdw.o
  CC [M]  /home/hugo/tmp/media_build/v4l/pvrusb2-v4l2.o
  CC [M]  /home/hugo/tmp/media_build/v4l/pvrusb2-ctrl.o
  CC [M]  /home/hugo/tmp/media_build/v4l/pvrusb2-std.o
  CC [M]  /home/hugo/tmp/media_build/v4l/pvrusb2-devattr.o
  CC [M]  /home/hugo/tmp/media_build/v4l/pvrusb2-context.o
  CC [M]  /home/hugo/tmp/media_build/v4l/pvrusb2-io.o
  CC [M]  /home/hugo/tmp/media_build/v4l/pvrusb2-ioread.o
  CC [M]  /home/hugo/tmp/media_build/v4l/pvrusb2-cx2584x-v4l.o
  CC [M]  /home/hugo/tmp/media_build/v4l/pvrusb2-wm8775.o
  CC [M]  /home/hugo/tmp/media_build/v4l/pvrusb2-cs53l32a.o
  CC [M]  /home/hugo/tmp/media_build/v4l/pvrusb2-dvb.o
  CC [M]  /home/hugo/tmp/media_build/v4l/pvrusb2-sysfs.o
  CC [M]  /home/hugo/tmp/media_build/v4l/pvrusb2-debugifc.o
  CC [M]  /home/hugo/tmp/media_build/v4l/radio-si470x-usb.o
  CC [M]  /home/hugo/tmp/media_build/v4l/radio-si470x-common.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-main.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-ir-raw.o
  CC [M]  /home/hugo/tmp/media_build/v4l/saa7146_i2c.o
  CC [M]  /home/hugo/tmp/media_build/v4l/saa7146_core.o
  CC [M]  /home/hugo/tmp/media_build/v4l/saa7146_fops.o
  CC [M]  /home/hugo/tmp/media_build/v4l/saa7146_video.o
  CC [M]  /home/hugo/tmp/media_build/v4l/saa7146_hlp.o
  CC [M]  /home/hugo/tmp/media_build/v4l/saa7146_vbi.o
  CC [M]  /home/hugo/tmp/media_build/v4l/saa7164-cards.o
  CC [M]  /home/hugo/tmp/media_build/v4l/saa7164-core.o
  CC [M]  /home/hugo/tmp/media_build/v4l/saa7164-i2c.o
  CC [M]  /home/hugo/tmp/media_build/v4l/saa7164-dvb.o
  CC [M]  /home/hugo/tmp/media_build/v4l/saa7164-fw.o
  CC [M]  /home/hugo/tmp/media_build/v4l/saa7164-bus.o
  CC [M]  /home/hugo/tmp/media_build/v4l/saa7164-cmd.o
  CC [M]  /home/hugo/tmp/media_build/v4l/saa7164-api.o
  CC [M]  /home/hugo/tmp/media_build/v4l/saa7164-buffer.o
  CC [M]  /home/hugo/tmp/media_build/v4l/saa7164-encoder.o
  CC [M]  /home/hugo/tmp/media_build/v4l/saa7164-vbi.o
  CC [M]  /home/hugo/tmp/media_build/v4l/radio-shark2.o
  CC [M]  /home/hugo/tmp/media_build/v4l/radio-tea5777.o
  CC [M]  /home/hugo/tmp/media_build/v4l/smsdvb-main.o
  CC [M]  /home/hugo/tmp/media_build/v4l/smsdvb-debugfs.o
  CC [M]  /home/hugo/tmp/media_build/v4l/smscoreapi.o
  CC [M]  /home/hugo/tmp/media_build/v4l/sms-cards.o
  CC [M]  /home/hugo/tmp/media_build/v4l/smsendian.o
  CC [M]  /home/hugo/tmp/media_build/v4l/smsir.o
  CC [M]  /home/hugo/tmp/media_build/v4l/bt87x.o
  CC [M]  /home/hugo/tmp/media_build/v4l/stb0899_drv.o
  CC [M]  /home/hugo/tmp/media_build/v4l/stb0899_algo.o
  CC [M]  /home/hugo/tmp/media_build/v4l/stk-webcam.o
  CC [M]  /home/hugo/tmp/media_build/v4l/stk-sensor.o
  CC [M]  /home/hugo/tmp/media_build/v4l/stv0900_core.o
  CC [M]  /home/hugo/tmp/media_build/v4l/stv0900_sw.o
  CC [M]  /home/hugo/tmp/media_build/v4l/tda18271-maps.o
  CC [M]  /home/hugo/tmp/media_build/v4l/tda18271-common.o
  CC [M]  /home/hugo/tmp/media_build/v4l/tda18271-fe.o
  CC [M]  /home/hugo/tmp/media_build/v4l/tm6000-cards.o
  CC [M]  /home/hugo/tmp/media_build/v4l/tm6000-core.o
  CC [M]  /home/hugo/tmp/media_build/v4l/tm6000-i2c.o
  CC [M]  /home/hugo/tmp/media_build/v4l/tm6000-video.o
  CC [M]  /home/hugo/tmp/media_build/v4l/tm6000-stds.o
  CC [M]  /home/hugo/tmp/media_build/v4l/tm6000-input.o
  CC [M]  /home/hugo/tmp/media_build/v4l/tuner-core.o
  CC [M]  /home/hugo/tmp/media_build/v4l/usbvision-core.o
  CC [M]  /home/hugo/tmp/media_build/v4l/usbvision-video.o
  CC [M]  /home/hugo/tmp/media_build/v4l/usbvision-i2c.o
  CC [M]  /home/hugo/tmp/media_build/v4l/usbvision-cards.o
  CC [M]  /home/hugo/tmp/media_build/v4l/v4l2-dev.o
  CC [M]  /home/hugo/tmp/media_build/v4l/v4l2-ioctl.o
  CC [M]  /home/hugo/tmp/media_build/v4l/v4l2-device.o
  CC [M]  /home/hugo/tmp/media_build/v4l/v4l2-fh.o
  CC [M]  /home/hugo/tmp/media_build/v4l/v4l2-event.o
  CC [M]  /home/hugo/tmp/media_build/v4l/v4l2-ctrls.o
  CC [M]  /home/hugo/tmp/media_build/v4l/v4l2-subdev.o
  CC [M]  /home/hugo/tmp/media_build/v4l/v4l2-clk.o
  CC [M]  /home/hugo/tmp/media_build/v4l/v4l2-async.o
  CC [M]  /home/hugo/tmp/media_build/v4l/v4l2-compat-ioctl32.o
  CC [M]  /home/hugo/tmp/media_build/v4l/zoran_procfs.o
  CC [M]  /home/hugo/tmp/media_build/v4l/zoran_device.o
  CC [M]  /home/hugo/tmp/media_build/v4l/zoran_driver.o
  CC [M]  /home/hugo/tmp/media_build/v4l/zoran_card.o
  LD [M]  /home/hugo/tmp/media_build/v4l/msp3400.o
  LD [M]  /home/hugo/tmp/media_build/v4l/cx25840.o
  CC [M]  /home/hugo/tmp/media_build/v4l/aptina-pll.o
  CC [M]  /home/hugo/tmp/media_build/v4l/tvaudio.o
  CC [M]  /home/hugo/tmp/media_build/v4l/tda7432.o
  CC [M]  /home/hugo/tmp/media_build/v4l/saa6588.o
  CC [M]  /home/hugo/tmp/media_build/v4l/tda9840.o
  CC [M]  /home/hugo/tmp/media_build/v4l/tea6415c.o
  CC [M]  /home/hugo/tmp/media_build/v4l/tea6420.o
  CC [M]  /home/hugo/tmp/media_build/v4l/saa7110.o
  CC [M]  /home/hugo/tmp/media_build/v4l/saa7115.o
  CC [M]  /home/hugo/tmp/media_build/v4l/saa717x.o
  CC [M]  /home/hugo/tmp/media_build/v4l/saa7127.o
  CC [M]  /home/hugo/tmp/media_build/v4l/saa7185.o
  CC [M]  /home/hugo/tmp/media_build/v4l/saa7191.o
  CC [M]  /home/hugo/tmp/media_build/v4l/saa6752hs.o
  CC [M]  /home/hugo/tmp/media_build/v4l/adv7170.o
  CC [M]  /home/hugo/tmp/media_build/v4l/adv7175.o
  CC [M]  /home/hugo/tmp/media_build/v4l/adv7180.o
  CC [M]  /home/hugo/tmp/media_build/v4l/adv7393.o
  CC [M]  /home/hugo/tmp/media_build/v4l/adv7842.o
  CC [M]  /home/hugo/tmp/media_build/v4l/ad9389b.o
  CC [M]  /home/hugo/tmp/media_build/v4l/adv7511.o
  CC [M]  /home/hugo/tmp/media_build/v4l/vpx3220.o
  CC [M]  /home/hugo/tmp/media_build/v4l/bt819.o
  CC [M]  /home/hugo/tmp/media_build/v4l/bt856.o
  CC [M]  /home/hugo/tmp/media_build/v4l/bt866.o
  CC [M]  /home/hugo/tmp/media_build/v4l/ks0127.o
  CC [M]  /home/hugo/tmp/media_build/v4l/ths7303.o
  CC [M]  /home/hugo/tmp/media_build/v4l/ths8200.o
  CC [M]  /home/hugo/tmp/media_build/v4l/tvp5150.o
  CC [M]  /home/hugo/tmp/media_build/v4l/tw2804.o
  CC [M]  /home/hugo/tmp/media_build/v4l/tw9903.o
  CC [M]  /home/hugo/tmp/media_build/v4l/tw9906.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cs5345.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cs53l32a.o
  CC [M]  /home/hugo/tmp/media_build/v4l/m52790.o
  CC [M]  /home/hugo/tmp/media_build/v4l/tlv320aic23b.o
  CC [M]  /home/hugo/tmp/media_build/v4l/uda1342.o
  CC [M]  /home/hugo/tmp/media_build/v4l/wm8775.o
  CC [M]  /home/hugo/tmp/media_build/v4l/wm8739.o
  CC [M]  /home/hugo/tmp/media_build/v4l/vp27smpx.o
  CC [M]  /home/hugo/tmp/media_build/v4l/sony-btf-mpx.o
  CC [M]  /home/hugo/tmp/media_build/v4l/upd64031a.o
  CC [M]  /home/hugo/tmp/media_build/v4l/upd64083.o
  CC [M]  /home/hugo/tmp/media_build/v4l/ov7640.o
  CC [M]  /home/hugo/tmp/media_build/v4l/ov7670.o
  CC [M]  /home/hugo/tmp/media_build/v4l/mt9m032.o
  CC [M]  /home/hugo/tmp/media_build/v4l/mt9v011.o
  CC [M]  /home/hugo/tmp/media_build/v4l/sr030pc30.o
  CC [M]  /home/hugo/tmp/media_build/v4l/adp1653.o
  CC [M]  /home/hugo/tmp/media_build/v4l/as3645a.o
  CC [M]  /home/hugo/tmp/media_build/v4l/smiapp-pll.o
  CC [M]  /home/hugo/tmp/media_build/v4l/ak881x.o
  CC [M]  /home/hugo/tmp/media_build/v4l/ir-kbd-i2c.o
  CC [M]  /home/hugo/tmp/media_build/v4l/ml86v7667.o
  CC [M]  /home/hugo/tmp/media_build/v4l/tuner-xc2028.o
  CC [M]  /home/hugo/tmp/media_build/v4l/tuner-simple.o
  CC [M]  /home/hugo/tmp/media_build/v4l/tuner-types.o
  CC [M]  /home/hugo/tmp/media_build/v4l/mt20xx.o
  CC [M]  /home/hugo/tmp/media_build/v4l/tda8290.o
  CC [M]  /home/hugo/tmp/media_build/v4l/tea5767.o
  CC [M]  /home/hugo/tmp/media_build/v4l/tea5761.o
  CC [M]  /home/hugo/tmp/media_build/v4l/tda9887.o
  CC [M]  /home/hugo/tmp/media_build/v4l/tda827x.o
  LD [M]  /home/hugo/tmp/media_build/v4l/tda18271.o
  CC [M]  /home/hugo/tmp/media_build/v4l/xc5000.o
  CC [M]  /home/hugo/tmp/media_build/v4l/xc4000.o
  CC [M]  /home/hugo/tmp/media_build/v4l/mt2060.o
  CC [M]  /home/hugo/tmp/media_build/v4l/mt2063.o
  CC [M]  /home/hugo/tmp/media_build/v4l/mt2266.o
  CC [M]  /home/hugo/tmp/media_build/v4l/qt1010.o
  CC [M]  /home/hugo/tmp/media_build/v4l/mt2131.o
  CC [M]  /home/hugo/tmp/media_build/v4l/mxl5005s.o
  CC [M]  /home/hugo/tmp/media_build/v4l/mxl5007t.o
  CC [M]  /home/hugo/tmp/media_build/v4l/mc44s803.o
  CC [M]  /home/hugo/tmp/media_build/v4l/max2165.o
  CC [M]  /home/hugo/tmp/media_build/v4l/tda18218.o
  CC [M]  /home/hugo/tmp/media_build/v4l/fc2580.o
  CC [M]  /home/hugo/tmp/media_build/v4l/tua9001.o
  CC [M]  /home/hugo/tmp/media_build/v4l/si2157.o
  CC [M]  /home/hugo/tmp/media_build/v4l/fc0011.o
  CC [M]  /home/hugo/tmp/media_build/v4l/fc0012.o
  CC [M]  /home/hugo/tmp/media_build/v4l/fc0013.o
  CC [M]  /home/hugo/tmp/media_build/v4l/r820t.o
  CC [M]  /home/hugo/tmp/media_build/v4l/mxl301rf.o
  CC [M]  /home/hugo/tmp/media_build/v4l/qm1d1c0042.o
  CC [M]  /home/hugo/tmp/media_build/v4l/dvb-pll.o
  CC [M]  /home/hugo/tmp/media_build/v4l/stv0299.o
  LD [M]  /home/hugo/tmp/media_build/v4l/stb0899.o
  CC [M]  /home/hugo/tmp/media_build/v4l/stb6100.o
  CC [M]  /home/hugo/tmp/media_build/v4l/sp8870.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx22700.o
  CC [M]  /home/hugo/tmp/media_build/v4l/s5h1432.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx24110.o
  CC [M]  /home/hugo/tmp/media_build/v4l/tda8083.o
  CC [M]  /home/hugo/tmp/media_build/v4l/l64781.o
  CC [M]  /home/hugo/tmp/media_build/v4l/dib3000mb.o
  CC [M]  /home/hugo/tmp/media_build/v4l/dib3000mc.o
  CC [M]  /home/hugo/tmp/media_build/v4l/dibx000_common.o
  CC [M]  /home/hugo/tmp/media_build/v4l/dib7000m.o
  CC [M]  /home/hugo/tmp/media_build/v4l/dib7000p.o
  CC [M]  /home/hugo/tmp/media_build/v4l/dib8000.o
  CC [M]  /home/hugo/tmp/media_build/v4l/dib9000.o
  CC [M]  /home/hugo/tmp/media_build/v4l/mt312.o
  CC [M]  /home/hugo/tmp/media_build/v4l/ves1820.o
  CC [M]  /home/hugo/tmp/media_build/v4l/ves1x93.o
  CC [M]  /home/hugo/tmp/media_build/v4l/tda1004x.o
  CC [M]  /home/hugo/tmp/media_build/v4l/sp887x.o
  CC [M]  /home/hugo/tmp/media_build/v4l/nxt6000.o
  CC [M]  /home/hugo/tmp/media_build/v4l/mt352.o
  CC [M]  /home/hugo/tmp/media_build/v4l/zl10036.o
  CC [M]  /home/hugo/tmp/media_build/v4l/zl10039.o
  CC [M]  /home/hugo/tmp/media_build/v4l/zl10353.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx22702.o
  LD [M]  /home/hugo/tmp/media_build/v4l/drxd.o
  CC [M]  /home/hugo/tmp/media_build/v4l/tda10021.o
  CC [M]  /home/hugo/tmp/media_build/v4l/tda10023.o
  CC [M]  /home/hugo/tmp/media_build/v4l/stv0297.o
  CC [M]  /home/hugo/tmp/media_build/v4l/nxt200x.o
  CC [M]  /home/hugo/tmp/media_build/v4l/or51211.o
  CC [M]  /home/hugo/tmp/media_build/v4l/or51132.o
  CC [M]  /home/hugo/tmp/media_build/v4l/bcm3510.o
  CC [M]  /home/hugo/tmp/media_build/v4l/s5h1420.o
  CC [M]  /home/hugo/tmp/media_build/v4l/lgdt330x.o
  CC [M]  /home/hugo/tmp/media_build/v4l/lgdt3305.o
  CC [M]  /home/hugo/tmp/media_build/v4l/lg2160.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx24123.o
  CC [M]  /home/hugo/tmp/media_build/v4l/lnbp21.o
  CC [M]  /home/hugo/tmp/media_build/v4l/lnbp22.o
  CC [M]  /home/hugo/tmp/media_build/v4l/isl6405.o
  CC [M]  /home/hugo/tmp/media_build/v4l/isl6421.o
  CC [M]  /home/hugo/tmp/media_build/v4l/tda10086.o
  CC [M]  /home/hugo/tmp/media_build/v4l/tda826x.o
  CC [M]  /home/hugo/tmp/media_build/v4l/tda8261.o
  CC [M]  /home/hugo/tmp/media_build/v4l/dib0070.o
  CC [M]  /home/hugo/tmp/media_build/v4l/dib0090.o
  CC [M]  /home/hugo/tmp/media_build/v4l/tua6100.o
  CC [M]  /home/hugo/tmp/media_build/v4l/s5h1409.o
  CC [M]  /home/hugo/tmp/media_build/v4l/itd1000.o
  CC [M]  /home/hugo/tmp/media_build/v4l/au8522_common.o
  CC [M]  /home/hugo/tmp/media_build/v4l/au8522_dig.o
  CC [M]  /home/hugo/tmp/media_build/v4l/au8522_decoder.o
  CC [M]  /home/hugo/tmp/media_build/v4l/tda10048.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx24113.o
  CC [M]  /home/hugo/tmp/media_build/v4l/s5h1411.o
  CC [M]  /home/hugo/tmp/media_build/v4l/lgs8gl5.o
  CC [M]  /home/hugo/tmp/media_build/v4l/tda665x.o
  CC [M]  /home/hugo/tmp/media_build/v4l/lgs8gxx.o
  CC [M]  /home/hugo/tmp/media_build/v4l/atbm8830.o
  CC [M]  /home/hugo/tmp/media_build/v4l/dvb_dummy_fe.o
  CC [M]  /home/hugo/tmp/media_build/v4l/af9013.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx24116.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx24117.o
  CC [M]  /home/hugo/tmp/media_build/v4l/si21xx.o
  CC [M]  /home/hugo/tmp/media_build/v4l/si2168.o
  CC [M]  /home/hugo/tmp/media_build/v4l/stv0288.o
  CC [M]  /home/hugo/tmp/media_build/v4l/stb6000.o
  CC [M]  /home/hugo/tmp/media_build/v4l/s921.o
  CC [M]  /home/hugo/tmp/media_build/v4l/stv6110.o
  LD [M]  /home/hugo/tmp/media_build/v4l/stv0900.o
  CC [M]  /home/hugo/tmp/media_build/v4l/stv090x.o
  CC [M]  /home/hugo/tmp/media_build/v4l/stv6110x.o
  CC [M]  /home/hugo/tmp/media_build/v4l/isl6423.o
  CC [M]  /home/hugo/tmp/media_build/v4l/ec100.o
  CC [M]  /home/hugo/tmp/media_build/v4l/hd29l2.o
  CC [M]  /home/hugo/tmp/media_build/v4l/ds3000.o
  CC [M]  /home/hugo/tmp/media_build/v4l/ts2020.o
  CC [M]  /home/hugo/tmp/media_build/v4l/mb86a16.o
  LD [M]  /home/hugo/tmp/media_build/v4l/drx39xyj.o
  CC [M]  /home/hugo/tmp/media_build/v4l/mb86a20s.o
  CC [M]  /home/hugo/tmp/media_build/v4l/ix2505v.o
  CC [M]  /home/hugo/tmp/media_build/v4l/stv0367.o
  LD [M]  /home/hugo/tmp/media_build/v4l/cxd2820r.o
  LD [M]  /home/hugo/tmp/media_build/v4l/drxk.o
  CC [M]  /home/hugo/tmp/media_build/v4l/tda18271c2dd.o
  CC [M]  /home/hugo/tmp/media_build/v4l/si2165.o
  CC [M]  /home/hugo/tmp/media_build/v4l/a8293.o
  CC [M]  /home/hugo/tmp/media_build/v4l/sp2.o
  CC [M]  /home/hugo/tmp/media_build/v4l/tda10071.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rtl2830.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rtl2832.o
  CC [M]  /home/hugo/tmp/media_build/v4l/m88rs2000.o
  CC [M]  /home/hugo/tmp/media_build/v4l/af9033.o
  CC [M]  /home/hugo/tmp/media_build/v4l/as102_fe.o
  CC [M]  /home/hugo/tmp/media_build/v4l/tc90522.o
  LD [M]  /home/hugo/tmp/media_build/v4l/media.o
  LD [M]  /home/hugo/tmp/media_build/v4l/videodev.o
  CC [M]  /home/hugo/tmp/media_build/v4l/v4l2-common.o
  CC [M]  /home/hugo/tmp/media_build/v4l/v4l2-dv-timings.o
  LD [M]  /home/hugo/tmp/media_build/v4l/tuner.o
  CC [M]  /home/hugo/tmp/media_build/v4l/videobuf-core.o
  CC [M]  /home/hugo/tmp/media_build/v4l/videobuf-dma-sg.o
  CC [M]  /home/hugo/tmp/media_build/v4l/videobuf-dma-contig.o
  CC [M]  /home/hugo/tmp/media_build/v4l/videobuf-vmalloc.o
  CC [M]  /home/hugo/tmp/media_build/v4l/videobuf-dvb.o
  CC [M]  /home/hugo/tmp/media_build/v4l/videobuf2-memops.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-core.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-adstech-dvb-t-pci.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-alink-dtu-m.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-anysee.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-apac-viewcomp.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-asus-pc39.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-asus-ps3-100.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-ati-tv-wonder-hd-600.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-ati-x10.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-avermedia-a16d.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-avermedia.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-avermedia-cardbus.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-avermedia-dvbt.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-avermedia-m135a.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-avermedia-m733a-rm-k6.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-avermedia-rm-ks.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-avertv-303.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-azurewave-ad-tu700.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-behold.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-behold-columbus.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-budget-ci-old.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-cinergy-1400.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-cinergy.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-delock-61959.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-dib0700-nec.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-dib0700-rc5.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-digitalnow-tinytwin.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-digittrade.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-dm1105-nec.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-dntv-live-dvb-t.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-dntv-live-dvbt-pro.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-dvbsky.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-em-terratec.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-encore-enltv2.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-encore-enltv.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-encore-enltv-fm53.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-evga-indtube.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-eztv.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-flydvb.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-flyvideo.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-fusionhdtv-mce.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-gadmei-rm008z.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-genius-tvgo-a11mce.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-gotview7135.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-imon-mce.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-imon-pad.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-iodata-bctv7e.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-it913x-v1.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-it913x-v2.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-kaiomy.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-kworld-315u.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-kworld-pc150u.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-kworld-plus-tv-analog.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-leadtek-y04g0051.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-lirc.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-lme2510.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-manli.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-medion-x10.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-medion-x10-digitainer.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-medion-x10-or2x.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-msi-digivox-ii.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-msi-digivox-iii.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-msi-tvanywhere.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-msi-tvanywhere-plus.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-nebula.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-nec-terratec-cinergy-xs.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-norwood.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-npgtech.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-pctv-sedna.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-pinnacle-color.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-pinnacle-grey.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-pinnacle-pctv-hd.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-pixelview.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-pixelview-mk12.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-pixelview-002t.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-pixelview-new.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-powercolor-real-angel.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-proteus-2309.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-purpletv.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-pv951.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-hauppauge.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-rc6-mce.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-real-audio-220-32-keys.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-reddo.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-snapstream-firefly.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-streamzap.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-tbs-nec.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-technisat-usb2.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-terratec-cinergy-xs.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-terratec-slim.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-terratec-slim-2.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-tevii-nec.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-tivo.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-total-media-in-hand.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-total-media-in-hand-02.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-trekstor.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-tt-1500.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-twinhan1027.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-videomate-m1f.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-videomate-s350.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-videomate-tv-pvr.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-winfast.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-winfast-usbii-deluxe.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-su3000.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-core.o
  CC [M]  /home/hugo/tmp/media_build/v4l/lirc_dev.o
  CC [M]  /home/hugo/tmp/media_build/v4l/ir-nec-decoder.o
  CC [M]  /home/hugo/tmp/media_build/v4l/ir-rc5-decoder.o
  CC [M]  /home/hugo/tmp/media_build/v4l/ir-rc6-decoder.o
  CC [M]  /home/hugo/tmp/media_build/v4l/ir-jvc-decoder.o
  CC [M]  /home/hugo/tmp/media_build/v4l/ir-sony-decoder.o
  CC [M]  /home/hugo/tmp/media_build/v4l/ir-sanyo-decoder.o
  CC [M]  /home/hugo/tmp/media_build/v4l/ir-sharp-decoder.o
  CC [M]  /home/hugo/tmp/media_build/v4l/ir-mce_kbd-decoder.o
  CC [M]  /home/hugo/tmp/media_build/v4l/ir-lirc-codec.o
  CC [M]  /home/hugo/tmp/media_build/v4l/ir-xmp-decoder.o
  CC [M]  /home/hugo/tmp/media_build/v4l/ati_remote.o
  CC [M]  /home/hugo/tmp/media_build/v4l/imon.o
  CC [M]  /home/hugo/tmp/media_build/v4l/ite-cir.o
  CC [M]  /home/hugo/tmp/media_build/v4l/mceusb.o
  CC [M]  /home/hugo/tmp/media_build/v4l/fintek-cir.o
  CC [M]  /home/hugo/tmp/media_build/v4l/nuvoton-cir.o
  CC [M]  /home/hugo/tmp/media_build/v4l/ene_ir.o
  CC [M]  /home/hugo/tmp/media_build/v4l/redrat3.o
  CC [M]  /home/hugo/tmp/media_build/v4l/streamzap.o
  CC [M]  /home/hugo/tmp/media_build/v4l/winbond-cir.o
  CC [M]  /home/hugo/tmp/media_build/v4l/rc-loopback.o
  CC [M]  /home/hugo/tmp/media_build/v4l/iguanair.o
  CC [M]  /home/hugo/tmp/media_build/v4l/ttusbir.o
  LD [M]  /home/hugo/tmp/media_build/v4l/b2c2-flexcop.o
  LD [M]  /home/hugo/tmp/media_build/v4l/saa7146.o
  LD [M]  /home/hugo/tmp/media_build/v4l/saa7146_vv.o
  LD [M]  /home/hugo/tmp/media_build/v4l/smsmdtv.o
  LD [M]  /home/hugo/tmp/media_build/v4l/smsdvb.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx2341x.o
  CC [M]  /home/hugo/tmp/media_build/v4l/btcx-risc.o
  CC [M]  /home/hugo/tmp/media_build/v4l/tveeprom.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cypress_firmware.o
  CC [M]  /home/hugo/tmp/media_build/v4l/timblogiw.o
  CC [M]  /home/hugo/tmp/media_build/v4l/via-camera.o
  CC [M]  /home/hugo/tmp/media_build/v4l/soc_scale_crop.o
  CC [M]  /home/hugo/tmp/media_build/v4l/ttpci-eeprom.o
  CC [M]  /home/hugo/tmp/media_build/v4l/budget-core.o
  CC [M]  /home/hugo/tmp/media_build/v4l/budget.o
  CC [M]  /home/hugo/tmp/media_build/v4l/budget-av.o
  CC [M]  /home/hugo/tmp/media_build/v4l/budget-ci.o
  CC [M]  /home/hugo/tmp/media_build/v4l/budget-patch.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-ttpci.o
  LD [M]  /home/hugo/tmp/media_build/v4l/b2c2-flexcop-pci.o
  CC [M]  /home/hugo/tmp/media_build/v4l/pluto2.o
  CC [M]  /home/hugo/tmp/media_build/v4l/dm1105.o
  LD [M]  /home/hugo/tmp/media_build/v4l/earth-pt1.o
  LD [M]  /home/hugo/tmp/media_build/v4l/mantis_core.o
  LD [M]  /home/hugo/tmp/media_build/v4l/mantis.o
  LD [M]  /home/hugo/tmp/media_build/v4l/hopper.o
  LD [M]  /home/hugo/tmp/media_build/v4l/ngene.o
  LD [M]  /home/hugo/tmp/media_build/v4l/ddbridge.o
  CC [M]  /home/hugo/tmp/media_build/v4l/mxb.o
  CC [M]  /home/hugo/tmp/media_build/v4l/hexium_orion.o
  CC [M]  /home/hugo/tmp/media_build/v4l/hexium_gemini.o
  LD [M]  /home/hugo/tmp/media_build/v4l/ivtv.o
  LD [M]  /home/hugo/tmp/media_build/v4l/ivtv-alsa.o
  CC [M]  /home/hugo/tmp/media_build/v4l/ivtvfb.o
  LD [M]  /home/hugo/tmp/media_build/v4l/zr36067.o
  CC [M]  /home/hugo/tmp/media_build/v4l/videocodec.o
  CC [M]  /home/hugo/tmp/media_build/v4l/zr36050.o
  CC [M]  /home/hugo/tmp/media_build/v4l/zr36016.o
  CC [M]  /home/hugo/tmp/media_build/v4l/zr36060.o
  LD [M]  /home/hugo/tmp/media_build/v4l/cx18.o
  LD [M]  /home/hugo/tmp/media_build/v4l/cx18-alsa.o
  LD [M]  /home/hugo/tmp/media_build/v4l/cx25821.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx25821-alsa.o
  LD [M]  /home/hugo/tmp/media_build/v4l/cx88xx.o
  LD [M]  /home/hugo/tmp/media_build/v4l/cx8800.o
  LD [M]  /home/hugo/tmp/media_build/v4l/cx8802.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx88-alsa.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx88-blackbird.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx88-dvb.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx88-vp3054-i2c.o
  LD [M]  /home/hugo/tmp/media_build/v4l/bttv.o
  CC [M]  /home/hugo/tmp/media_build/v4l/bt878.o
  CC [M]  /home/hugo/tmp/media_build/v4l/dvb-bt8xx.o
  CC [M]  /home/hugo/tmp/media_build/v4l/dst.o
  CC [M]  /home/hugo/tmp/media_build/v4l/dst_ca.o
  LD [M]  /home/hugo/tmp/media_build/v4l/saa7164.o
  CC [M]  /home/hugo/tmp/media_build/v4l/meye.o
  CC [M]  /home/hugo/tmp/media_build/v4l/ttusb_dec.o
  CC [M]  /home/hugo/tmp/media_build/v4l/ttusbdecfe.o
  CC [M]  /home/hugo/tmp/media_build/v4l/dvb-ttusb-budget.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-usb.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-vp7045.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-vp702x.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-gp8psk.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-dtt200u.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-dibusb-common.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-a800.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-dibusb-mb.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-dibusb-mc.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-nova-t-usb2.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-umt-010.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-m920x.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-digitv.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-cxusb.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-ttusb2.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-dib0700.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-opera.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-af9005.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-af9005-remote.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-pctv452e.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-dw2102.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-dtv5100.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-cinergyT2.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-friio.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-az6027.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-technisat-usb2.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb_usb_v2.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-af9015.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-au6610.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-az6007.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-ce6230.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-ec168.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-lmedm04.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-gl861.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-mxl111sf.o
  CC [M]  /home/hugo/tmp/media_build/v4l/mxl111sf-demod.o
  CC [M]  /home/hugo/tmp/media_build/v4l/mxl111sf-tuner.o
  CC [M]  /home/hugo/tmp/media_build/v4l/smsusb.o
  LD [M]  /home/hugo/tmp/media_build/v4l/b2c2-flexcop-usb.o
  CC [M]  /home/hugo/tmp/media_build/v4l/zr364xx.o
  LD [M]  /home/hugo/tmp/media_build/v4l/stkwebcam.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_main.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_benq.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_conex.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_cpia1.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_dtcs033.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_etoms.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_finepix.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_jeilinj.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_jl2005bcd.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_kinect.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_konica.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_mars.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_mr97310a.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_nw80x.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_ov519.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_ov534.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_ov534_9.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_pac207.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_pac7302.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_pac7311.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_se401.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_sn9c2028.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_sn9c20x.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_sonixb.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_sonixj.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_spca500.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_spca501.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_spca505.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_spca506.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_spca508.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_spca561.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_spca1528.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_sq905.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_sq905c.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_sq930x.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_sunplus.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_stk014.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_stk1135.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_stv0680.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_t613.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_topro.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_tv8532.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_vc032x.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_vicam.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_xirlink_cit.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_zc3xx.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_m5602.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_stv06xx.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_gl860.o
  LD [M]  /home/hugo/tmp/media_build/v4l/cpia2.o
  LD [M]  /home/hugo/tmp/media_build/v4l/au0828.o
  LD [M]  /home/hugo/tmp/media_build/v4l/hdpvr.o
  LD [M]  /home/hugo/tmp/media_build/v4l/pvrusb2.o
  LD [M]  /home/hugo/tmp/media_build/v4l/poseidon.o
  LD [M]  /home/hugo/tmp/media_build/v4l/usbvision.o
  LD [M]  /home/hugo/tmp/media_build/v4l/cx231xx.o
  LD [M]  /home/hugo/tmp/media_build/v4l/cx231xx-alsa.o
  CC [M]  /home/hugo/tmp/media_build/v4l/cx231xx-dvb.o
  LD [M]  /home/hugo/tmp/media_build/v4l/tm6000.o
  CC [M]  /home/hugo/tmp/media_build/v4l/tm6000-alsa.o
  CC [M]  /home/hugo/tmp/media_build/v4l/tm6000-dvb.o
  LD [M]  /home/hugo/tmp/media_build/v4l/em28xx.o
  LD [M]  /home/hugo/tmp/media_build/v4l/em28xx-alsa.o
  LD [M]  /home/hugo/tmp/media_build/v4l/em28xx-rc.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-as102.o
  CC [M]  /home/hugo/tmp/media_build/v4l/smssdio.o
  LD [M]  /home/hugo/tmp/media_build/v4l/firedtv.o
  CC [M]  /home/hugo/tmp/media_build/v4l/c-qcam.o
  CC [M]  /home/hugo/tmp/media_build/v4l/w9966.o
  CC [M]  /home/hugo/tmp/media_build/v4l/radio-maxiradio.o
  CC [M]  /home/hugo/tmp/media_build/v4l/radio-shark.o
  LD [M]  /home/hugo/tmp/media_build/v4l/shark2.o
  CC [M]  /home/hugo/tmp/media_build/v4l/dsbr100.o
  LD [M]  /home/hugo/tmp/media_build/v4l/radio-usb-si470x.o
  CC [M]  /home/hugo/tmp/media_build/v4l/si4713.o
  CC [M]  /home/hugo/tmp/media_build/v4l/radio-usb-si4713.o
  CC [M]  /home/hugo/tmp/media_build/v4l/radio-platform-si4713.o
  CC [M]  /home/hugo/tmp/media_build/v4l/radio-mr800.o
  CC [M]  /home/hugo/tmp/media_build/v4l/radio-keene.o
  CC [M]  /home/hugo/tmp/media_build/v4l/radio-ma901.o
  CC [M]  /home/hugo/tmp/media_build/v4l/radio-tea5764.o
  CC [M]  /home/hugo/tmp/media_build/v4l/saa7706h.o
  CC [M]  /home/hugo/tmp/media_build/v4l/tef6862.o
  CC [M]  /home/hugo/tmp/media_build/v4l/radio-timb.o
  CC [M]  /home/hugo/tmp/media_build/v4l/radio-wl1273.o
  CC [M]  /home/hugo/tmp/media_build/v4l/tea575x.o
  CC [M]  /home/hugo/tmp/media_build/v4l/radio-raremono.o
  LD [M]  /home/hugo/tmp/media_build/v4l/altera-stapl.o
  LD [M]  /home/hugo/tmp/media_build/v4l/snd-bt87x.o
  Building modules, stage 2.
  MODPOST 516 modules
  CC      /home/hugo/tmp/media_build/v4l/a8293.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/a8293.ko
  CC      /home/hugo/tmp/media_build/v4l/ad9389b.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/ad9389b.ko
  CC      /home/hugo/tmp/media_build/v4l/adp1653.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/adp1653.ko
  CC      /home/hugo/tmp/media_build/v4l/adv7170.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/adv7170.ko
  CC      /home/hugo/tmp/media_build/v4l/adv7175.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/adv7175.ko
  CC      /home/hugo/tmp/media_build/v4l/adv7180.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/adv7180.ko
  CC      /home/hugo/tmp/media_build/v4l/adv7393.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/adv7393.ko
  CC      /home/hugo/tmp/media_build/v4l/adv7511.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/adv7511.ko
  CC      /home/hugo/tmp/media_build/v4l/adv7842.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/adv7842.ko
  CC      /home/hugo/tmp/media_build/v4l/af9013.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/af9013.ko
  CC      /home/hugo/tmp/media_build/v4l/af9033.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/af9033.ko
  CC      /home/hugo/tmp/media_build/v4l/ak881x.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/ak881x.ko
  CC      /home/hugo/tmp/media_build/v4l/altera-stapl.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/altera-stapl.ko
  CC      /home/hugo/tmp/media_build/v4l/aptina-pll.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/aptina-pll.ko
  CC      /home/hugo/tmp/media_build/v4l/as102_fe.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/as102_fe.ko
  CC      /home/hugo/tmp/media_build/v4l/as3645a.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/as3645a.ko
  CC      /home/hugo/tmp/media_build/v4l/atbm8830.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/atbm8830.ko
  CC      /home/hugo/tmp/media_build/v4l/ati_remote.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/ati_remote.ko
  CC      /home/hugo/tmp/media_build/v4l/au0828.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/au0828.ko
  CC      /home/hugo/tmp/media_build/v4l/au8522_common.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/au8522_common.ko
  CC      /home/hugo/tmp/media_build/v4l/au8522_decoder.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/au8522_decoder.ko
  CC      /home/hugo/tmp/media_build/v4l/au8522_dig.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/au8522_dig.ko
  CC      /home/hugo/tmp/media_build/v4l/b2c2-flexcop-pci.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/b2c2-flexcop-pci.ko
  CC      /home/hugo/tmp/media_build/v4l/b2c2-flexcop-usb.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/b2c2-flexcop-usb.ko
  CC      /home/hugo/tmp/media_build/v4l/b2c2-flexcop.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/b2c2-flexcop.ko
  CC      /home/hugo/tmp/media_build/v4l/bcm3510.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/bcm3510.ko
  CC      /home/hugo/tmp/media_build/v4l/bt819.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/bt819.ko
  CC      /home/hugo/tmp/media_build/v4l/bt856.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/bt856.ko
  CC      /home/hugo/tmp/media_build/v4l/bt866.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/bt866.ko
  CC      /home/hugo/tmp/media_build/v4l/bt878.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/bt878.ko
  CC      /home/hugo/tmp/media_build/v4l/btcx-risc.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/btcx-risc.ko
  CC      /home/hugo/tmp/media_build/v4l/bttv.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/bttv.ko
  CC      /home/hugo/tmp/media_build/v4l/budget-av.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/budget-av.ko
  CC      /home/hugo/tmp/media_build/v4l/budget-ci.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/budget-ci.ko
  CC      /home/hugo/tmp/media_build/v4l/budget-core.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/budget-core.ko
  CC      /home/hugo/tmp/media_build/v4l/budget-patch.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/budget-patch.ko
  CC      /home/hugo/tmp/media_build/v4l/budget.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/budget.ko
  CC      /home/hugo/tmp/media_build/v4l/c-qcam.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/c-qcam.ko
  CC      /home/hugo/tmp/media_build/v4l/cpia2.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/cpia2.ko
  CC      /home/hugo/tmp/media_build/v4l/cs5345.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/cs5345.ko
  CC      /home/hugo/tmp/media_build/v4l/cs53l32a.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/cs53l32a.ko
  CC      /home/hugo/tmp/media_build/v4l/cx18-alsa.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/cx18-alsa.ko
  CC      /home/hugo/tmp/media_build/v4l/cx18.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/cx18.ko
  CC      /home/hugo/tmp/media_build/v4l/cx22700.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/cx22700.ko
  CC      /home/hugo/tmp/media_build/v4l/cx22702.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/cx22702.ko
  CC      /home/hugo/tmp/media_build/v4l/cx231xx-alsa.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/cx231xx-alsa.ko
  CC      /home/hugo/tmp/media_build/v4l/cx231xx-dvb.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/cx231xx-dvb.ko
  CC      /home/hugo/tmp/media_build/v4l/cx231xx.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/cx231xx.ko
  CC      /home/hugo/tmp/media_build/v4l/cx2341x.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/cx2341x.ko
  CC      /home/hugo/tmp/media_build/v4l/cx24110.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/cx24110.ko
  CC      /home/hugo/tmp/media_build/v4l/cx24113.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/cx24113.ko
  CC      /home/hugo/tmp/media_build/v4l/cx24116.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/cx24116.ko
  CC      /home/hugo/tmp/media_build/v4l/cx24117.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/cx24117.ko
  CC      /home/hugo/tmp/media_build/v4l/cx24123.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/cx24123.ko
  CC      /home/hugo/tmp/media_build/v4l/cx25821-alsa.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/cx25821-alsa.ko
  CC      /home/hugo/tmp/media_build/v4l/cx25821.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/cx25821.ko
  CC      /home/hugo/tmp/media_build/v4l/cx25840.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/cx25840.ko
  CC      /home/hugo/tmp/media_build/v4l/cx88-alsa.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/cx88-alsa.ko
  CC      /home/hugo/tmp/media_build/v4l/cx88-blackbird.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/cx88-blackbird.ko
  CC      /home/hugo/tmp/media_build/v4l/cx88-dvb.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/cx88-dvb.ko
  CC      /home/hugo/tmp/media_build/v4l/cx88-vp3054-i2c.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/cx88-vp3054-i2c.ko
  CC      /home/hugo/tmp/media_build/v4l/cx8800.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/cx8800.ko
  CC      /home/hugo/tmp/media_build/v4l/cx8802.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/cx8802.ko
  CC      /home/hugo/tmp/media_build/v4l/cx88xx.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/cx88xx.ko
  CC      /home/hugo/tmp/media_build/v4l/cxd2820r.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/cxd2820r.ko
  CC      /home/hugo/tmp/media_build/v4l/cypress_firmware.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/cypress_firmware.ko
  CC      /home/hugo/tmp/media_build/v4l/ddbridge.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/ddbridge.ko
  CC      /home/hugo/tmp/media_build/v4l/dib0070.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dib0070.ko
  CC      /home/hugo/tmp/media_build/v4l/dib0090.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dib0090.ko
  CC      /home/hugo/tmp/media_build/v4l/dib3000mb.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dib3000mb.ko
  CC      /home/hugo/tmp/media_build/v4l/dib3000mc.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dib3000mc.ko
  CC      /home/hugo/tmp/media_build/v4l/dib7000m.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dib7000m.ko
  CC      /home/hugo/tmp/media_build/v4l/dib7000p.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dib7000p.ko
  CC      /home/hugo/tmp/media_build/v4l/dib8000.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dib8000.ko
  CC      /home/hugo/tmp/media_build/v4l/dib9000.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dib9000.ko
  CC      /home/hugo/tmp/media_build/v4l/dibx000_common.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dibx000_common.ko
  CC      /home/hugo/tmp/media_build/v4l/dm1105.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dm1105.ko
  CC      /home/hugo/tmp/media_build/v4l/drx39xyj.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/drx39xyj.ko
  CC      /home/hugo/tmp/media_build/v4l/drxd.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/drxd.ko
  CC      /home/hugo/tmp/media_build/v4l/drxk.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/drxk.ko
  CC      /home/hugo/tmp/media_build/v4l/ds3000.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/ds3000.ko
  CC      /home/hugo/tmp/media_build/v4l/dsbr100.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dsbr100.ko
  CC      /home/hugo/tmp/media_build/v4l/dst.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dst.ko
  CC      /home/hugo/tmp/media_build/v4l/dst_ca.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dst_ca.ko
  CC      /home/hugo/tmp/media_build/v4l/dvb-as102.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-as102.ko
  CC      /home/hugo/tmp/media_build/v4l/dvb-bt8xx.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-bt8xx.ko
  CC      /home/hugo/tmp/media_build/v4l/dvb-core.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-core.ko
  CC      /home/hugo/tmp/media_build/v4l/dvb-pll.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-pll.ko
  CC      /home/hugo/tmp/media_build/v4l/dvb-ttpci.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-ttpci.ko
  CC      /home/hugo/tmp/media_build/v4l/dvb-ttusb-budget.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-ttusb-budget.ko
  CC      /home/hugo/tmp/media_build/v4l/dvb-usb-a800.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-a800.ko
  CC      /home/hugo/tmp/media_build/v4l/dvb-usb-af9005-remote.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-af9005-remote.ko
  CC      /home/hugo/tmp/media_build/v4l/dvb-usb-af9005.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-af9005.ko
  CC      /home/hugo/tmp/media_build/v4l/dvb-usb-af9015.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-af9015.ko
  CC      /home/hugo/tmp/media_build/v4l/dvb-usb-au6610.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-au6610.ko
  CC      /home/hugo/tmp/media_build/v4l/dvb-usb-az6007.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-az6007.ko
  CC      /home/hugo/tmp/media_build/v4l/dvb-usb-az6027.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-az6027.ko
  CC      /home/hugo/tmp/media_build/v4l/dvb-usb-ce6230.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-ce6230.ko
  CC      /home/hugo/tmp/media_build/v4l/dvb-usb-cinergyT2.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-cinergyT2.ko
  CC      /home/hugo/tmp/media_build/v4l/dvb-usb-cxusb.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-cxusb.ko
  CC      /home/hugo/tmp/media_build/v4l/dvb-usb-dib0700.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-dib0700.ko
  CC      /home/hugo/tmp/media_build/v4l/dvb-usb-dibusb-common.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-dibusb-common.ko
  CC      /home/hugo/tmp/media_build/v4l/dvb-usb-dibusb-mb.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-dibusb-mb.ko
  CC      /home/hugo/tmp/media_build/v4l/dvb-usb-dibusb-mc.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-dibusb-mc.ko
  CC      /home/hugo/tmp/media_build/v4l/dvb-usb-digitv.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-digitv.ko
  CC      /home/hugo/tmp/media_build/v4l/dvb-usb-dtt200u.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-dtt200u.ko
  CC      /home/hugo/tmp/media_build/v4l/dvb-usb-dtv5100.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-dtv5100.ko
  CC      /home/hugo/tmp/media_build/v4l/dvb-usb-dw2102.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-dw2102.ko
  CC      /home/hugo/tmp/media_build/v4l/dvb-usb-ec168.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-ec168.ko
  CC      /home/hugo/tmp/media_build/v4l/dvb-usb-friio.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-friio.ko
  CC      /home/hugo/tmp/media_build/v4l/dvb-usb-gl861.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-gl861.ko
  CC      /home/hugo/tmp/media_build/v4l/dvb-usb-gp8psk.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-gp8psk.ko
  CC      /home/hugo/tmp/media_build/v4l/dvb-usb-lmedm04.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-lmedm04.ko
  CC      /home/hugo/tmp/media_build/v4l/dvb-usb-m920x.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-m920x.ko
  CC      /home/hugo/tmp/media_build/v4l/dvb-usb-mxl111sf.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-mxl111sf.ko
  CC      /home/hugo/tmp/media_build/v4l/dvb-usb-nova-t-usb2.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-nova-t-usb2.ko
  CC      /home/hugo/tmp/media_build/v4l/dvb-usb-opera.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-opera.ko
  CC      /home/hugo/tmp/media_build/v4l/dvb-usb-pctv452e.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-pctv452e.ko
  CC      /home/hugo/tmp/media_build/v4l/dvb-usb-technisat-usb2.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-technisat-usb2.ko
  CC      /home/hugo/tmp/media_build/v4l/dvb-usb-ttusb2.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-ttusb2.ko
  CC      /home/hugo/tmp/media_build/v4l/dvb-usb-umt-010.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-umt-010.ko
  CC      /home/hugo/tmp/media_build/v4l/dvb-usb-vp702x.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-vp702x.ko
  CC      /home/hugo/tmp/media_build/v4l/dvb-usb-vp7045.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-usb-vp7045.ko
  CC      /home/hugo/tmp/media_build/v4l/dvb-usb.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb-usb.ko
  CC      /home/hugo/tmp/media_build/v4l/dvb_dummy_fe.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb_dummy_fe.ko
  CC      /home/hugo/tmp/media_build/v4l/dvb_usb_v2.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/dvb_usb_v2.ko
  CC      /home/hugo/tmp/media_build/v4l/earth-pt1.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/earth-pt1.ko
  CC      /home/hugo/tmp/media_build/v4l/ec100.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/ec100.ko
  CC      /home/hugo/tmp/media_build/v4l/em28xx-alsa.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/em28xx-alsa.ko
  CC      /home/hugo/tmp/media_build/v4l/em28xx-rc.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/em28xx-rc.ko
  CC      /home/hugo/tmp/media_build/v4l/em28xx.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/em28xx.ko
  CC      /home/hugo/tmp/media_build/v4l/ene_ir.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/ene_ir.ko
  CC      /home/hugo/tmp/media_build/v4l/fc0011.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/fc0011.ko
  CC      /home/hugo/tmp/media_build/v4l/fc0012.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/fc0012.ko
  CC      /home/hugo/tmp/media_build/v4l/fc0013.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/fc0013.ko
  CC      /home/hugo/tmp/media_build/v4l/fc2580.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/fc2580.ko
  CC      /home/hugo/tmp/media_build/v4l/fintek-cir.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/fintek-cir.ko
  CC      /home/hugo/tmp/media_build/v4l/firedtv.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/firedtv.ko
  CC      /home/hugo/tmp/media_build/v4l/gspca_benq.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_benq.ko
  CC      /home/hugo/tmp/media_build/v4l/gspca_conex.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_conex.ko
  CC      /home/hugo/tmp/media_build/v4l/gspca_cpia1.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_cpia1.ko
  CC      /home/hugo/tmp/media_build/v4l/gspca_dtcs033.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_dtcs033.ko
  CC      /home/hugo/tmp/media_build/v4l/gspca_etoms.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_etoms.ko
  CC      /home/hugo/tmp/media_build/v4l/gspca_finepix.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_finepix.ko
  CC      /home/hugo/tmp/media_build/v4l/gspca_gl860.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_gl860.ko
  CC      /home/hugo/tmp/media_build/v4l/gspca_jeilinj.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_jeilinj.ko
  CC      /home/hugo/tmp/media_build/v4l/gspca_jl2005bcd.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_jl2005bcd.ko
  CC      /home/hugo/tmp/media_build/v4l/gspca_kinect.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_kinect.ko
  CC      /home/hugo/tmp/media_build/v4l/gspca_konica.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_konica.ko
  CC      /home/hugo/tmp/media_build/v4l/gspca_m5602.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_m5602.ko
  CC      /home/hugo/tmp/media_build/v4l/gspca_main.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_main.ko
  CC      /home/hugo/tmp/media_build/v4l/gspca_mars.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_mars.ko
  CC      /home/hugo/tmp/media_build/v4l/gspca_mr97310a.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_mr97310a.ko
  CC      /home/hugo/tmp/media_build/v4l/gspca_nw80x.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_nw80x.ko
  CC      /home/hugo/tmp/media_build/v4l/gspca_ov519.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_ov519.ko
  CC      /home/hugo/tmp/media_build/v4l/gspca_ov534.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_ov534.ko
  CC      /home/hugo/tmp/media_build/v4l/gspca_ov534_9.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_ov534_9.ko
  CC      /home/hugo/tmp/media_build/v4l/gspca_pac207.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_pac207.ko
  CC      /home/hugo/tmp/media_build/v4l/gspca_pac7302.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_pac7302.ko
  CC      /home/hugo/tmp/media_build/v4l/gspca_pac7311.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_pac7311.ko
  CC      /home/hugo/tmp/media_build/v4l/gspca_se401.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_se401.ko
  CC      /home/hugo/tmp/media_build/v4l/gspca_sn9c2028.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_sn9c2028.ko
  CC      /home/hugo/tmp/media_build/v4l/gspca_sn9c20x.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_sn9c20x.ko
  CC      /home/hugo/tmp/media_build/v4l/gspca_sonixb.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_sonixb.ko
  CC      /home/hugo/tmp/media_build/v4l/gspca_sonixj.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_sonixj.ko
  CC      /home/hugo/tmp/media_build/v4l/gspca_spca1528.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_spca1528.ko
  CC      /home/hugo/tmp/media_build/v4l/gspca_spca500.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_spca500.ko
  CC      /home/hugo/tmp/media_build/v4l/gspca_spca501.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_spca501.ko
  CC      /home/hugo/tmp/media_build/v4l/gspca_spca505.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_spca505.ko
  CC      /home/hugo/tmp/media_build/v4l/gspca_spca506.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_spca506.ko
  CC      /home/hugo/tmp/media_build/v4l/gspca_spca508.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_spca508.ko
  CC      /home/hugo/tmp/media_build/v4l/gspca_spca561.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_spca561.ko
  CC      /home/hugo/tmp/media_build/v4l/gspca_sq905.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_sq905.ko
  CC      /home/hugo/tmp/media_build/v4l/gspca_sq905c.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_sq905c.ko
  CC      /home/hugo/tmp/media_build/v4l/gspca_sq930x.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_sq930x.ko
  CC      /home/hugo/tmp/media_build/v4l/gspca_stk014.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_stk014.ko
  CC      /home/hugo/tmp/media_build/v4l/gspca_stk1135.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_stk1135.ko
  CC      /home/hugo/tmp/media_build/v4l/gspca_stv0680.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_stv0680.ko
  CC      /home/hugo/tmp/media_build/v4l/gspca_stv06xx.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_stv06xx.ko
  CC      /home/hugo/tmp/media_build/v4l/gspca_sunplus.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_sunplus.ko
  CC      /home/hugo/tmp/media_build/v4l/gspca_t613.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_t613.ko
  CC      /home/hugo/tmp/media_build/v4l/gspca_topro.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_topro.ko
  CC      /home/hugo/tmp/media_build/v4l/gspca_tv8532.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_tv8532.ko
  CC      /home/hugo/tmp/media_build/v4l/gspca_vc032x.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_vc032x.ko
  CC      /home/hugo/tmp/media_build/v4l/gspca_vicam.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_vicam.ko
  CC      /home/hugo/tmp/media_build/v4l/gspca_xirlink_cit.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_xirlink_cit.ko
  CC      /home/hugo/tmp/media_build/v4l/gspca_zc3xx.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/gspca_zc3xx.ko
  CC      /home/hugo/tmp/media_build/v4l/hd29l2.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/hd29l2.ko
  CC      /home/hugo/tmp/media_build/v4l/hdpvr.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/hdpvr.ko
  CC      /home/hugo/tmp/media_build/v4l/hexium_gemini.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/hexium_gemini.ko
  CC      /home/hugo/tmp/media_build/v4l/hexium_orion.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/hexium_orion.ko
  CC      /home/hugo/tmp/media_build/v4l/hopper.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/hopper.ko
  CC      /home/hugo/tmp/media_build/v4l/iguanair.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/iguanair.ko
  CC      /home/hugo/tmp/media_build/v4l/imon.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/imon.ko
  CC      /home/hugo/tmp/media_build/v4l/ir-jvc-decoder.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/ir-jvc-decoder.ko
  CC      /home/hugo/tmp/media_build/v4l/ir-kbd-i2c.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/ir-kbd-i2c.ko
  CC      /home/hugo/tmp/media_build/v4l/ir-lirc-codec.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/ir-lirc-codec.ko
  CC      /home/hugo/tmp/media_build/v4l/ir-mce_kbd-decoder.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/ir-mce_kbd-decoder.ko
  CC      /home/hugo/tmp/media_build/v4l/ir-nec-decoder.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/ir-nec-decoder.ko
  CC      /home/hugo/tmp/media_build/v4l/ir-rc5-decoder.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/ir-rc5-decoder.ko
  CC      /home/hugo/tmp/media_build/v4l/ir-rc6-decoder.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/ir-rc6-decoder.ko
  CC      /home/hugo/tmp/media_build/v4l/ir-sanyo-decoder.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/ir-sanyo-decoder.ko
  CC      /home/hugo/tmp/media_build/v4l/ir-sharp-decoder.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/ir-sharp-decoder.ko
  CC      /home/hugo/tmp/media_build/v4l/ir-sony-decoder.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/ir-sony-decoder.ko
  CC      /home/hugo/tmp/media_build/v4l/ir-xmp-decoder.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/ir-xmp-decoder.ko
  CC      /home/hugo/tmp/media_build/v4l/isl6405.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/isl6405.ko
  CC      /home/hugo/tmp/media_build/v4l/isl6421.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/isl6421.ko
  CC      /home/hugo/tmp/media_build/v4l/isl6423.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/isl6423.ko
  CC      /home/hugo/tmp/media_build/v4l/itd1000.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/itd1000.ko
  CC      /home/hugo/tmp/media_build/v4l/ite-cir.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/ite-cir.ko
  CC      /home/hugo/tmp/media_build/v4l/ivtv-alsa.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/ivtv-alsa.ko
  CC      /home/hugo/tmp/media_build/v4l/ivtv.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/ivtv.ko
  CC      /home/hugo/tmp/media_build/v4l/ivtvfb.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/ivtvfb.ko
  CC      /home/hugo/tmp/media_build/v4l/ix2505v.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/ix2505v.ko
  CC      /home/hugo/tmp/media_build/v4l/ks0127.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/ks0127.ko
  CC      /home/hugo/tmp/media_build/v4l/l64781.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/l64781.ko
  CC      /home/hugo/tmp/media_build/v4l/lg2160.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/lg2160.ko
  CC      /home/hugo/tmp/media_build/v4l/lgdt3305.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/lgdt3305.ko
  CC      /home/hugo/tmp/media_build/v4l/lgdt330x.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/lgdt330x.ko
  CC      /home/hugo/tmp/media_build/v4l/lgs8gl5.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/lgs8gl5.ko
  CC      /home/hugo/tmp/media_build/v4l/lgs8gxx.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/lgs8gxx.ko
  CC      /home/hugo/tmp/media_build/v4l/lirc_dev.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/lirc_dev.ko
  CC      /home/hugo/tmp/media_build/v4l/lnbp21.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/lnbp21.ko
  CC      /home/hugo/tmp/media_build/v4l/lnbp22.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/lnbp22.ko
  CC      /home/hugo/tmp/media_build/v4l/m52790.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/m52790.ko
  CC      /home/hugo/tmp/media_build/v4l/m88rs2000.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/m88rs2000.ko
  CC      /home/hugo/tmp/media_build/v4l/mantis.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/mantis.ko
  CC      /home/hugo/tmp/media_build/v4l/mantis_core.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/mantis_core.ko
  CC      /home/hugo/tmp/media_build/v4l/max2165.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/max2165.ko
  CC      /home/hugo/tmp/media_build/v4l/mb86a16.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/mb86a16.ko
  CC      /home/hugo/tmp/media_build/v4l/mb86a20s.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/mb86a20s.ko
  CC      /home/hugo/tmp/media_build/v4l/mc44s803.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/mc44s803.ko
  CC      /home/hugo/tmp/media_build/v4l/mceusb.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/mceusb.ko
  CC      /home/hugo/tmp/media_build/v4l/media.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/media.ko
  CC      /home/hugo/tmp/media_build/v4l/meye.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/meye.ko
  CC      /home/hugo/tmp/media_build/v4l/ml86v7667.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/ml86v7667.ko
  CC      /home/hugo/tmp/media_build/v4l/msp3400.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/msp3400.ko
  CC      /home/hugo/tmp/media_build/v4l/mt2060.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/mt2060.ko
  CC      /home/hugo/tmp/media_build/v4l/mt2063.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/mt2063.ko
  CC      /home/hugo/tmp/media_build/v4l/mt20xx.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/mt20xx.ko
  CC      /home/hugo/tmp/media_build/v4l/mt2131.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/mt2131.ko
  CC      /home/hugo/tmp/media_build/v4l/mt2266.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/mt2266.ko
  CC      /home/hugo/tmp/media_build/v4l/mt312.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/mt312.ko
  CC      /home/hugo/tmp/media_build/v4l/mt352.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/mt352.ko
  CC      /home/hugo/tmp/media_build/v4l/mt9m032.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/mt9m032.ko
  CC      /home/hugo/tmp/media_build/v4l/mt9v011.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/mt9v011.ko
  CC      /home/hugo/tmp/media_build/v4l/mxb.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/mxb.ko
  CC      /home/hugo/tmp/media_build/v4l/mxl111sf-demod.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/mxl111sf-demod.ko
  CC      /home/hugo/tmp/media_build/v4l/mxl111sf-tuner.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/mxl111sf-tuner.ko
  CC      /home/hugo/tmp/media_build/v4l/mxl301rf.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/mxl301rf.ko
  CC      /home/hugo/tmp/media_build/v4l/mxl5005s.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/mxl5005s.ko
  CC      /home/hugo/tmp/media_build/v4l/mxl5007t.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/mxl5007t.ko
  CC      /home/hugo/tmp/media_build/v4l/ngene.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/ngene.ko
  CC      /home/hugo/tmp/media_build/v4l/nuvoton-cir.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/nuvoton-cir.ko
  CC      /home/hugo/tmp/media_build/v4l/nxt200x.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/nxt200x.ko
  CC      /home/hugo/tmp/media_build/v4l/nxt6000.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/nxt6000.ko
  CC      /home/hugo/tmp/media_build/v4l/or51132.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/or51132.ko
  CC      /home/hugo/tmp/media_build/v4l/or51211.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/or51211.ko
  CC      /home/hugo/tmp/media_build/v4l/ov7640.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/ov7640.ko
  CC      /home/hugo/tmp/media_build/v4l/ov7670.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/ov7670.ko
  CC      /home/hugo/tmp/media_build/v4l/pluto2.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/pluto2.ko
  CC      /home/hugo/tmp/media_build/v4l/poseidon.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/poseidon.ko
  CC      /home/hugo/tmp/media_build/v4l/pvrusb2.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/pvrusb2.ko
  CC      /home/hugo/tmp/media_build/v4l/qm1d1c0042.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/qm1d1c0042.ko
  CC      /home/hugo/tmp/media_build/v4l/qt1010.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/qt1010.ko
  CC      /home/hugo/tmp/media_build/v4l/r820t.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/r820t.ko
  CC      /home/hugo/tmp/media_build/v4l/radio-keene.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/radio-keene.ko
  CC      /home/hugo/tmp/media_build/v4l/radio-ma901.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/radio-ma901.ko
  CC      /home/hugo/tmp/media_build/v4l/radio-maxiradio.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/radio-maxiradio.ko
  CC      /home/hugo/tmp/media_build/v4l/radio-mr800.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/radio-mr800.ko
  CC      /home/hugo/tmp/media_build/v4l/radio-platform-si4713.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/radio-platform-si4713.ko
  CC      /home/hugo/tmp/media_build/v4l/radio-raremono.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/radio-raremono.ko
  CC      /home/hugo/tmp/media_build/v4l/radio-shark.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/radio-shark.ko
  CC      /home/hugo/tmp/media_build/v4l/radio-tea5764.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/radio-tea5764.ko
  CC      /home/hugo/tmp/media_build/v4l/radio-timb.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/radio-timb.ko
  CC      /home/hugo/tmp/media_build/v4l/radio-usb-si470x.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/radio-usb-si470x.ko
  CC      /home/hugo/tmp/media_build/v4l/radio-usb-si4713.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/radio-usb-si4713.ko
  CC      /home/hugo/tmp/media_build/v4l/radio-wl1273.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/radio-wl1273.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-adstech-dvb-t-pci.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-adstech-dvb-t-pci.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-alink-dtu-m.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-alink-dtu-m.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-anysee.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-anysee.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-apac-viewcomp.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-apac-viewcomp.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-asus-pc39.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-asus-pc39.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-asus-ps3-100.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-asus-ps3-100.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-ati-tv-wonder-hd-600.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-ati-tv-wonder-hd-600.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-ati-x10.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-ati-x10.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-avermedia-a16d.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-avermedia-a16d.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-avermedia-cardbus.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-avermedia-cardbus.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-avermedia-dvbt.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-avermedia-dvbt.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-avermedia-m135a.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-avermedia-m135a.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-avermedia-m733a-rm-k6.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-avermedia-m733a-rm-k6.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-avermedia-rm-ks.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-avermedia-rm-ks.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-avermedia.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-avermedia.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-avertv-303.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-avertv-303.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-azurewave-ad-tu700.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-azurewave-ad-tu700.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-behold-columbus.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-behold-columbus.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-behold.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-behold.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-budget-ci-old.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-budget-ci-old.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-cinergy-1400.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-cinergy-1400.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-cinergy.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-cinergy.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-core.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-core.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-delock-61959.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-delock-61959.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-dib0700-nec.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-dib0700-nec.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-dib0700-rc5.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-dib0700-rc5.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-digitalnow-tinytwin.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-digitalnow-tinytwin.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-digittrade.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-digittrade.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-dm1105-nec.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-dm1105-nec.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-dntv-live-dvb-t.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-dntv-live-dvb-t.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-dntv-live-dvbt-pro.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-dntv-live-dvbt-pro.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-dvbsky.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-dvbsky.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-em-terratec.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-em-terratec.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-encore-enltv-fm53.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-encore-enltv-fm53.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-encore-enltv.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-encore-enltv.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-encore-enltv2.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-encore-enltv2.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-evga-indtube.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-evga-indtube.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-eztv.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-eztv.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-flydvb.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-flydvb.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-flyvideo.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-flyvideo.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-fusionhdtv-mce.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-fusionhdtv-mce.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-gadmei-rm008z.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-gadmei-rm008z.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-genius-tvgo-a11mce.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-genius-tvgo-a11mce.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-gotview7135.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-gotview7135.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-hauppauge.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-hauppauge.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-imon-mce.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-imon-mce.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-imon-pad.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-imon-pad.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-iodata-bctv7e.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-iodata-bctv7e.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-it913x-v1.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-it913x-v1.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-it913x-v2.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-it913x-v2.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-kaiomy.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-kaiomy.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-kworld-315u.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-kworld-315u.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-kworld-pc150u.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-kworld-pc150u.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-kworld-plus-tv-analog.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-kworld-plus-tv-analog.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-leadtek-y04g0051.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-leadtek-y04g0051.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-lirc.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-lirc.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-lme2510.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-lme2510.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-loopback.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-loopback.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-manli.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-manli.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-medion-x10-digitainer.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-medion-x10-digitainer.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-medion-x10-or2x.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-medion-x10-or2x.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-medion-x10.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-medion-x10.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-msi-digivox-ii.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-msi-digivox-ii.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-msi-digivox-iii.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-msi-digivox-iii.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-msi-tvanywhere-plus.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-msi-tvanywhere-plus.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-msi-tvanywhere.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-msi-tvanywhere.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-nebula.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-nebula.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-nec-terratec-cinergy-xs.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-nec-terratec-cinergy-xs.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-norwood.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-norwood.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-npgtech.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-npgtech.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-pctv-sedna.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-pctv-sedna.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-pinnacle-color.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-pinnacle-color.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-pinnacle-grey.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-pinnacle-grey.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-pinnacle-pctv-hd.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-pinnacle-pctv-hd.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-pixelview-002t.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-pixelview-002t.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-pixelview-mk12.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-pixelview-mk12.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-pixelview-new.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-pixelview-new.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-pixelview.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-pixelview.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-powercolor-real-angel.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-powercolor-real-angel.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-proteus-2309.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-proteus-2309.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-purpletv.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-purpletv.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-pv951.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-pv951.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-rc6-mce.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-rc6-mce.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-real-audio-220-32-keys.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-real-audio-220-32-keys.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-reddo.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-reddo.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-snapstream-firefly.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-snapstream-firefly.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-streamzap.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-streamzap.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-su3000.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-su3000.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-tbs-nec.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-tbs-nec.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-technisat-usb2.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-technisat-usb2.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-terratec-cinergy-xs.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-terratec-cinergy-xs.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-terratec-slim-2.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-terratec-slim-2.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-terratec-slim.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-terratec-slim.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-tevii-nec.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-tevii-nec.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-tivo.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-tivo.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-total-media-in-hand-02.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-total-media-in-hand-02.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-total-media-in-hand.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-total-media-in-hand.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-trekstor.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-trekstor.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-tt-1500.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-tt-1500.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-twinhan1027.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-twinhan1027.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-videomate-m1f.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-videomate-m1f.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-videomate-s350.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-videomate-s350.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-videomate-tv-pvr.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-videomate-tv-pvr.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-winfast-usbii-deluxe.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-winfast-usbii-deluxe.ko
  CC      /home/hugo/tmp/media_build/v4l/rc-winfast.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rc-winfast.ko
  CC      /home/hugo/tmp/media_build/v4l/redrat3.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/redrat3.ko
  CC      /home/hugo/tmp/media_build/v4l/rtl2830.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rtl2830.ko
  CC      /home/hugo/tmp/media_build/v4l/rtl2832.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/rtl2832.ko
  CC      /home/hugo/tmp/media_build/v4l/s5h1409.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/s5h1409.ko
  CC      /home/hugo/tmp/media_build/v4l/s5h1411.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/s5h1411.ko
  CC      /home/hugo/tmp/media_build/v4l/s5h1420.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/s5h1420.ko
  CC      /home/hugo/tmp/media_build/v4l/s5h1432.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/s5h1432.ko
  CC      /home/hugo/tmp/media_build/v4l/s921.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/s921.ko
  CC      /home/hugo/tmp/media_build/v4l/saa6588.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/saa6588.ko
  CC      /home/hugo/tmp/media_build/v4l/saa6752hs.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/saa6752hs.ko
  CC      /home/hugo/tmp/media_build/v4l/saa7110.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/saa7110.ko
  CC      /home/hugo/tmp/media_build/v4l/saa7115.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/saa7115.ko
  CC      /home/hugo/tmp/media_build/v4l/saa7127.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/saa7127.ko
  CC      /home/hugo/tmp/media_build/v4l/saa7146.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/saa7146.ko
  CC      /home/hugo/tmp/media_build/v4l/saa7146_vv.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/saa7146_vv.ko
  CC      /home/hugo/tmp/media_build/v4l/saa7164.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/saa7164.ko
  CC      /home/hugo/tmp/media_build/v4l/saa717x.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/saa717x.ko
  CC      /home/hugo/tmp/media_build/v4l/saa7185.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/saa7185.ko
  CC      /home/hugo/tmp/media_build/v4l/saa7191.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/saa7191.ko
  CC      /home/hugo/tmp/media_build/v4l/saa7706h.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/saa7706h.ko
  CC      /home/hugo/tmp/media_build/v4l/shark2.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/shark2.ko
  CC      /home/hugo/tmp/media_build/v4l/si2157.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/si2157.ko
  CC      /home/hugo/tmp/media_build/v4l/si2165.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/si2165.ko
  CC      /home/hugo/tmp/media_build/v4l/si2168.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/si2168.ko
  CC      /home/hugo/tmp/media_build/v4l/si21xx.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/si21xx.ko
  CC      /home/hugo/tmp/media_build/v4l/si4713.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/si4713.ko
  CC      /home/hugo/tmp/media_build/v4l/smiapp-pll.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/smiapp-pll.ko
  CC      /home/hugo/tmp/media_build/v4l/smsdvb.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/smsdvb.ko
  CC      /home/hugo/tmp/media_build/v4l/smsmdtv.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/smsmdtv.ko
  CC      /home/hugo/tmp/media_build/v4l/smssdio.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/smssdio.ko
  CC      /home/hugo/tmp/media_build/v4l/smsusb.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/smsusb.ko
  CC      /home/hugo/tmp/media_build/v4l/snd-bt87x.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/snd-bt87x.ko
  CC      /home/hugo/tmp/media_build/v4l/soc_scale_crop.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/soc_scale_crop.ko
  CC      /home/hugo/tmp/media_build/v4l/sony-btf-mpx.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/sony-btf-mpx.ko
  CC      /home/hugo/tmp/media_build/v4l/sp2.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/sp2.ko
  CC      /home/hugo/tmp/media_build/v4l/sp8870.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/sp8870.ko
  CC      /home/hugo/tmp/media_build/v4l/sp887x.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/sp887x.ko
  CC      /home/hugo/tmp/media_build/v4l/sr030pc30.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/sr030pc30.ko
  CC      /home/hugo/tmp/media_build/v4l/stb0899.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/stb0899.ko
  CC      /home/hugo/tmp/media_build/v4l/stb6000.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/stb6000.ko
  CC      /home/hugo/tmp/media_build/v4l/stb6100.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/stb6100.ko
  CC      /home/hugo/tmp/media_build/v4l/stkwebcam.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/stkwebcam.ko
  CC      /home/hugo/tmp/media_build/v4l/streamzap.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/streamzap.ko
  CC      /home/hugo/tmp/media_build/v4l/stv0288.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/stv0288.ko
  CC      /home/hugo/tmp/media_build/v4l/stv0297.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/stv0297.ko
  CC      /home/hugo/tmp/media_build/v4l/stv0299.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/stv0299.ko
  CC      /home/hugo/tmp/media_build/v4l/stv0367.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/stv0367.ko
  CC      /home/hugo/tmp/media_build/v4l/stv0900.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/stv0900.ko
  CC      /home/hugo/tmp/media_build/v4l/stv090x.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/stv090x.ko
  CC      /home/hugo/tmp/media_build/v4l/stv6110.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/stv6110.ko
  CC      /home/hugo/tmp/media_build/v4l/stv6110x.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/stv6110x.ko
  CC      /home/hugo/tmp/media_build/v4l/tc90522.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/tc90522.ko
  CC      /home/hugo/tmp/media_build/v4l/tda10021.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/tda10021.ko
  CC      /home/hugo/tmp/media_build/v4l/tda10023.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/tda10023.ko
  CC      /home/hugo/tmp/media_build/v4l/tda10048.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/tda10048.ko
  CC      /home/hugo/tmp/media_build/v4l/tda1004x.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/tda1004x.ko
  CC      /home/hugo/tmp/media_build/v4l/tda10071.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/tda10071.ko
  CC      /home/hugo/tmp/media_build/v4l/tda10086.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/tda10086.ko
  CC      /home/hugo/tmp/media_build/v4l/tda18218.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/tda18218.ko
  CC      /home/hugo/tmp/media_build/v4l/tda18271.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/tda18271.ko
  CC      /home/hugo/tmp/media_build/v4l/tda18271c2dd.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/tda18271c2dd.ko
  CC      /home/hugo/tmp/media_build/v4l/tda665x.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/tda665x.ko
  CC      /home/hugo/tmp/media_build/v4l/tda7432.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/tda7432.ko
  CC      /home/hugo/tmp/media_build/v4l/tda8083.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/tda8083.ko
  CC      /home/hugo/tmp/media_build/v4l/tda8261.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/tda8261.ko
  CC      /home/hugo/tmp/media_build/v4l/tda826x.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/tda826x.ko
  CC      /home/hugo/tmp/media_build/v4l/tda827x.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/tda827x.ko
  CC      /home/hugo/tmp/media_build/v4l/tda8290.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/tda8290.ko
  CC      /home/hugo/tmp/media_build/v4l/tda9840.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/tda9840.ko
  CC      /home/hugo/tmp/media_build/v4l/tda9887.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/tda9887.ko
  CC      /home/hugo/tmp/media_build/v4l/tea575x.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/tea575x.ko
  CC      /home/hugo/tmp/media_build/v4l/tea5761.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/tea5761.ko
  CC      /home/hugo/tmp/media_build/v4l/tea5767.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/tea5767.ko
  CC      /home/hugo/tmp/media_build/v4l/tea6415c.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/tea6415c.ko
  CC      /home/hugo/tmp/media_build/v4l/tea6420.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/tea6420.ko
  CC      /home/hugo/tmp/media_build/v4l/tef6862.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/tef6862.ko
  CC      /home/hugo/tmp/media_build/v4l/ths7303.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/ths7303.ko
  CC      /home/hugo/tmp/media_build/v4l/ths8200.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/ths8200.ko
  CC      /home/hugo/tmp/media_build/v4l/timblogiw.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/timblogiw.ko
  CC      /home/hugo/tmp/media_build/v4l/tlv320aic23b.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/tlv320aic23b.ko
  CC      /home/hugo/tmp/media_build/v4l/tm6000-alsa.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/tm6000-alsa.ko
  CC      /home/hugo/tmp/media_build/v4l/tm6000-dvb.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/tm6000-dvb.ko
  CC      /home/hugo/tmp/media_build/v4l/tm6000.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/tm6000.ko
  CC      /home/hugo/tmp/media_build/v4l/ts2020.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/ts2020.ko
  CC      /home/hugo/tmp/media_build/v4l/ttpci-eeprom.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/ttpci-eeprom.ko
  CC      /home/hugo/tmp/media_build/v4l/ttusb_dec.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/ttusb_dec.ko
  CC      /home/hugo/tmp/media_build/v4l/ttusbdecfe.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/ttusbdecfe.ko
  CC      /home/hugo/tmp/media_build/v4l/ttusbir.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/ttusbir.ko
  CC      /home/hugo/tmp/media_build/v4l/tua6100.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/tua6100.ko
  CC      /home/hugo/tmp/media_build/v4l/tua9001.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/tua9001.ko
  CC      /home/hugo/tmp/media_build/v4l/tuner-simple.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/tuner-simple.ko
  CC      /home/hugo/tmp/media_build/v4l/tuner-types.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/tuner-types.ko
  CC      /home/hugo/tmp/media_build/v4l/tuner-xc2028.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/tuner-xc2028.ko
  CC      /home/hugo/tmp/media_build/v4l/tuner.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/tuner.ko
  CC      /home/hugo/tmp/media_build/v4l/tvaudio.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/tvaudio.ko
  CC      /home/hugo/tmp/media_build/v4l/tveeprom.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/tveeprom.ko
  CC      /home/hugo/tmp/media_build/v4l/tvp5150.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/tvp5150.ko
  CC      /home/hugo/tmp/media_build/v4l/tw2804.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/tw2804.ko
  CC      /home/hugo/tmp/media_build/v4l/tw9903.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/tw9903.ko
  CC      /home/hugo/tmp/media_build/v4l/tw9906.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/tw9906.ko
  CC      /home/hugo/tmp/media_build/v4l/uda1342.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/uda1342.ko
  CC      /home/hugo/tmp/media_build/v4l/upd64031a.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/upd64031a.ko
  CC      /home/hugo/tmp/media_build/v4l/upd64083.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/upd64083.ko
  CC      /home/hugo/tmp/media_build/v4l/usbvision.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/usbvision.ko
  CC      /home/hugo/tmp/media_build/v4l/v4l2-common.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/v4l2-common.ko
  CC      /home/hugo/tmp/media_build/v4l/v4l2-dv-timings.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/v4l2-dv-timings.ko
  CC      /home/hugo/tmp/media_build/v4l/ves1820.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/ves1820.ko
  CC      /home/hugo/tmp/media_build/v4l/ves1x93.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/ves1x93.ko
  CC      /home/hugo/tmp/media_build/v4l/via-camera.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/via-camera.ko
  CC      /home/hugo/tmp/media_build/v4l/videobuf-core.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/videobuf-core.ko
  CC      /home/hugo/tmp/media_build/v4l/videobuf-dma-contig.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/videobuf-dma-contig.ko
  CC      /home/hugo/tmp/media_build/v4l/videobuf-dma-sg.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/videobuf-dma-sg.ko
  CC      /home/hugo/tmp/media_build/v4l/videobuf-dvb.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/videobuf-dvb.ko
  CC      /home/hugo/tmp/media_build/v4l/videobuf-vmalloc.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/videobuf-vmalloc.ko
  CC      /home/hugo/tmp/media_build/v4l/videobuf2-memops.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/videobuf2-memops.ko
  CC      /home/hugo/tmp/media_build/v4l/videocodec.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/videocodec.ko
  CC      /home/hugo/tmp/media_build/v4l/videodev.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/videodev.ko
  CC      /home/hugo/tmp/media_build/v4l/vp27smpx.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/vp27smpx.ko
  CC      /home/hugo/tmp/media_build/v4l/vpx3220.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/vpx3220.ko
  CC      /home/hugo/tmp/media_build/v4l/w9966.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/w9966.ko
  CC      /home/hugo/tmp/media_build/v4l/winbond-cir.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/winbond-cir.ko
  CC      /home/hugo/tmp/media_build/v4l/wm8739.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/wm8739.ko
  CC      /home/hugo/tmp/media_build/v4l/wm8775.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/wm8775.ko
  CC      /home/hugo/tmp/media_build/v4l/xc4000.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/xc4000.ko
  CC      /home/hugo/tmp/media_build/v4l/xc5000.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/xc5000.ko
  CC      /home/hugo/tmp/media_build/v4l/zl10036.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/zl10036.ko
  CC      /home/hugo/tmp/media_build/v4l/zl10039.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/zl10039.ko
  CC      /home/hugo/tmp/media_build/v4l/zl10353.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/zl10353.ko
  CC      /home/hugo/tmp/media_build/v4l/zr36016.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/zr36016.ko
  CC      /home/hugo/tmp/media_build/v4l/zr36050.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/zr36050.ko
  CC      /home/hugo/tmp/media_build/v4l/zr36060.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/zr36060.ko
  CC      /home/hugo/tmp/media_build/v4l/zr36067.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/zr36067.ko
  CC      /home/hugo/tmp/media_build/v4l/zr364xx.mod.o
  LD [M]  /home/hugo/tmp/media_build/v4l/zr364xx.ko
make[2]: Leaving directory `/usr/src/linux-headers-3.2.0-70-generic'
./scripts/rmmod.pl check
found 516 modules
make[1]: Leaving directory `/home/hugo/tmp/media_build/v4l'
**********************************************************
* Compilation finished. Use 'make install' to install them
**********************************************************

--------------090106020706090303080507--
