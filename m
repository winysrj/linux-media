Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:35552 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483AbbFHQGT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jun 2015 12:06:19 -0400
Received: by lbbtu8 with SMTP id tu8so67870638lbb.2
        for <linux-media@vger.kernel.org>; Mon, 08 Jun 2015 09:06:18 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 8 Jun 2015 18:06:18 +0200
Message-ID: <CAB0z4Noe_pGszj5oOz+xfKWy4-icWTJOkE=dQ9ymzjgebBA1aA@mail.gmail.com>
Subject: Unable to compile v4l-dvb in ubuntu 14.04
From: CIJOML CIJOMLovic <cijoml@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I am trying to compile v4l git with no success. I have kernel and
headers installed.
Is problem at my side or in source?

Thank you for help or solving the problem:

root@Latitude-E5550:/usr/src/v4l-dvb-3724e93f7af5# make
make -C /usr/src/v4l-dvb-3724e93f7af5/v4l
make[1]: Entering directory `/usr/src/v4l-dvb-3724e93f7af5/v4l'
No version yet, using 3.16.0-38-generic
make[1]: Leaving directory `/usr/src/v4l-dvb-3724e93f7af5/v4l'
make[1]: Entering directory `/usr/src/v4l-dvb-3724e93f7af5/v4l'
scripts/make_makefile.pl
Updating/Creating .config
Preparing to compile for kernel version 3.6.0

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

WARNING: You're using an obsolete driver! You shouldn't be using it!
     If you want anything new, you can use:
        http://git.linuxtv.org/media_build.git.
     The tree is still here just to preserve the development history.
     You've been warned.
Created default (all yes) .config file
./scripts/make_myconfig.pl
make[1]: Leaving directory `/usr/src/v4l-dvb-3724e93f7af5/v4l'
make[1]: Entering directory `/usr/src/v4l-dvb-3724e93f7af5/v4l'
perl scripts/make_config_compat.pl /lib/modules/3.6.0-38-generic/build
./.myconfig ./config-compat.h
creating symbolic links...
ln -sf . oss
make -C firmware prep
make[2]: Entering directory `/usr/src/v4l-dvb-3724e93f7af5/v4l/firmware'
make[2]: Leaving directory `/usr/src/v4l-dvb-3724e93f7af5/v4l/firmware'
make -C firmware
make[2]: Entering directory `/usr/src/v4l-dvb-3724e93f7af5/v4l/firmware'
  CC  ihex2fw
Generating vicam/firmware.fw
Generating dabusb/firmware.fw
Generating dabusb/bitstream.bin
Generating ttusb-budget/dspbootcode.bin
Generating cpia2/stv0672_vp4.bin
Generating av7110/bootcode.bin
make[2]: Leaving directory `/usr/src/v4l-dvb-3724e93f7af5/v4l/firmware'
Kernel build directory is /lib/modules/3.6.0-38-generic/build
make -C /lib/modules/3.6.0-38-generic/build
SUBDIRS=/usr/src/v4l-dvb-3724e93f7af5/v4l CFLAGS="-I../linux/include
-D__KERNEL__ -I/include -DEXPORT_SYMTAB" modules
make[2]: Entering directory `/usr/src/linux-headers-3.16.0-38-generic'
  CC [M]  /usr/src/v4l-dvb-3724e93f7af5/v4l/tuner-xc2028.o
In file included from <command-line>:0:0:
/usr/src/v4l-dvb-3724e93f7af5/v4l/config-compat.h:1235:1: fatal error:
include/linux/version.h: No such file or directory
 #endif
 ^
compilation terminated.
make[3]: *** [/usr/src/v4l-dvb-3724e93f7af5/v4l/tuner-xc2028.o] Error 1
make[2]: *** [_module_/usr/src/v4l-dvb-3724e93f7af5/v4l] Error 2
make[2]: Leaving directory `/usr/src/linux-headers-3.16.0-38-generic'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/usr/src/v4l-dvb-3724e93f7af5/v4l'
make: *** [all] Error 2


Best regards

Michal
