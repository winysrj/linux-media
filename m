Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wa-out-1112.google.com ([209.85.146.181])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alireza.torabi@gmail.com>) id 1K7Agd-0000AB-Q4
	for linux-dvb@linuxtv.org; Fri, 13 Jun 2008 16:55:41 +0200
Received: by wa-out-1112.google.com with SMTP id n7so3042847wag.13
	for <linux-dvb@linuxtv.org>; Fri, 13 Jun 2008 07:55:27 -0700 (PDT)
Message-ID: <cffd8c580806130755t21f428e5qdb83daa47f4d6665@mail.gmail.com>
Date: Fri, 13 Jun 2008 15:55:26 +0100
From: "Alireza Torabi" <alireza.torabi@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <cffd8c580806130739s6f23cc11mc96db647e522f072@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <cffd8c580806130739s6f23cc11mc96db647e522f072@mail.gmail.com>
Subject: [linux-dvb] Fwd: Mantis kernel modules and VP-1041/SP400 CI,
	HD2 card
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

I did a couple of menuconfig in /usr/src and mantis dirs and "Mantis
based cards" came up. Good!
However, make now exits with an error (Err!):
Any ideas please (the same bright guys I asked before!)?


alpha:/home/alireza/VP-1041/mantis-0b04be0c088a# make
make -C /home/alireza/VP-1041/mantis-0b04be0c088a/v4l
make[1]: Entering directory `/home/alireza/VP-1041/mantis-0b04be0c088a/v4l'
./scripts/make_myconfig.pl
make[1]: Leaving directory `/home/alireza/VP-1041/mantis-0b04be0c088a/v4l'
make[1]: Entering directory `/home/alireza/VP-1041/mantis-0b04be0c088a/v4l'
perl scripts/make_config_compat.pl /lib/modules/2.6.25.4/source
./.myconfig ./config-compat.h
creating symbolic links...
Kernel build directory is /lib/modules/2.6.25.4/build
make -C /lib/modules/2.6.25.4/build
SUBDIRS=/home/alireza/VP-1041/mantis-0b04be0c088a/v4l  modules
make[2]: Entering directory `/usr/src/linux-2.6.25.4'
  CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/flexcop-pci.o
  CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/flexcop-usb.o
  CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/flexcop.o
  CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/flexcop-fe-tuner.o
  CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/flexcop-i2c.o
  CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/flexcop-sram.o
  CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/flexcop-eeprom.o
  CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/flexcop-misc.o
  CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/flexcop-hw-filter.o
  CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/flexcop-dma.o
  CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/cpia2_v4l.o
  CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/cpia2_usb.o
  CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/cpia2_core.o
  CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/cx25840-core.o
/home/alireza/VP-1041/mantis-0b04be0c088a/v4l/cx25840-core.c:71:
error: conflicting type qualifiers for 'addr_data'
/home/alireza/VP-1041/mantis-0b04be0c088a/v4l/../linux/include/media/v4l2-i2c-drv-legacy.h:41:
error: previous declaration of 'addr_data' was here
make[3]: *** [/home/alireza/VP-1041/mantis-0b04be0c088a/v4l/cx25840-core.o]
Error 1
make[2]: *** [_module_/home/alireza/VP-1041/mantis-0b04be0c088a/v4l] Error 2
make[2]: Leaving directory `/usr/src/linux-2.6.25.4'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/home/alireza/VP-1041/mantis-0b04be0c088a/v4l'
make: *** [all] Error 2


---------- Forwarded message ----------
From: Alireza Torabi <alireza.torabi@gmail.com>
Date: Jun 13, 2008 3:39 PM
Subject: Mantis kernel modules and VP-1041/SP400 CI, HD2 card
To: linux-dvb@linuxtv.org


I'm trying to compile this "Mantis" driver for my VP-1041 dvb card
(which I am told will support this card).
I've downloaded this from:

http://jusst.de/hg/mantis

and then ran "make". I can't see any Mantis related kernel module that
I can load for this card.

For all the bright guys out there: What am I missing here?


Here is some output you might like to have a look at and give me a trash about:

1)
alpha:/home/alireza/VP-1041/mantis-0b04be0c088a# uname -a
Linux alpha 2.6.25.4 #1 SMP Fri Jun 13 11:20:05 BST 2008 i686 GNU/Linux

2)
alpha:/home/alireza/VP-1041/mantis-0b04be0c088a# gcc -v
Using built-in specs.
Target: i686-pc-linux-gnu
Configured with: ./configure --enable-languages=c,c++
Thread model: posix
gcc version 4.3.1 (GCC)
3)
alpha:/home/alireza/VP-1041/mantis-0b04be0c088a# ld -v
GNU ld (GNU Binutils) 2.18


make output)
alpha:/home/alireza/VP-1041/mantis-0b04be0c088a# make
make -C /home/alireza/VP-1041/mantis-0b04be0c088a/v4l
make[1]: Entering directory `/home/alireza/VP-1041/mantis-0b04be0c088a/v4l'
scripts/make_makefile.pl
./scripts/make_myconfig.pl
make[1]: Leaving directory `/home/alireza/VP-1041/mantis-0b04be0c088a/v4l'
make[1]: Entering directory `/home/alireza/VP-1041/mantis-0b04be0c088a/v4l'
perl scripts/make_config_compat.pl /lib/modules/2.6.25.4/source
./.myconfig ./config-compat.h
creating symbolic links...
ln -sf . oss
Kernel build directory is /lib/modules/2.6.25.4/build
make -C /lib/modules/2.6.25.4/build
SUBDIRS=/home/alireza/VP-1041/mantis-0b04be0c088a/v4l  modules
make[2]: Entering directory `/usr/src/linux-2.6.25.4'
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/cpia2_v4l.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/cpia2_usb.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/cpia2_core.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/dvbdev.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/dmxdev.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/dvb_demux.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/dvb_filter.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/dvb_ca_en50221.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/dvb_frontend.o
/home/alireza/VP-1041/mantis-0b04be0c088a/v4l/dvb_frontend.c: In
function 'dvb_frontend_thread':
/home/alireza/VP-1041/mantis-0b04be0c088a/v4l/dvb_frontend.c:1126:
warning: unused variable 'status'
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/dvb_net.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/dvb_ringbuffer.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/dvb_math.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/et61x251_core.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/et61x251_tas5130d1b.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/ir-functions.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/ir-keymaps.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/pwc-if.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/pwc-misc.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/pwc-ctrl.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/pwc-v4l.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/pwc-uncompress.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/pwc-dec1.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/pwc-dec23.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/pwc-kiara.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/pwc-timon.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/sn9c102_core.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/sn9c102_hv7131d.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/sn9c102_hv7131r.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/sn9c102_mi0343.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/sn9c102_mi0360.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/sn9c102_mt9v111.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/sn9c102_ov7630.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/sn9c102_ov7660.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/sn9c102_pas106b.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/sn9c102_pas202bcb.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/sn9c102_tas5110c1b.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/sn9c102_tas5110d.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/sn9c102_tas5130d1b.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/stk-webcam.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/stk-sensor.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/zc0301_core.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/zc0301_pb0330.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/zc0301_pas202bcb.o
 LD [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/ir-common.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/videodev.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/compat_ioctl32.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/v4l2-int-device.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/v4l2-common.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/v4l1-compat.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/ir-kbd-i2c.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/zr36060.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/stradis.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/cpia.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/cpia_usb.o
 LD [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/cpia2.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/tuner-types.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/videobuf-core.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/videobuf-dma-sg.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/videobuf-vmalloc.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/videobuf-dvb.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/btcx-risc.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/cx2341x.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/dabusb.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/ov511.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/se401.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/stv680.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/zr364xx.o
 LD [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/stkwebcam.o
 LD [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/sn9c102.o
 LD [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/et61x251.o
 LD [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/pwc.o
 LD [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/zc0301.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/usbvideo.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/ibmcam.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/ultracam.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/konicawc.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/vicam.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/quickcam_messenger.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/vivi.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/radio-maxiradio.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/radio-gemtek-pci.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/radio-maestro.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/dsbr100.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/radio-si470x.o
/home/alireza/VP-1041/mantis-0b04be0c088a/v4l/radio-si470x.c: In
function 'si470x_get_rds_registers':
/home/alireza/VP-1041/mantis-0b04be0c088a/v4l/radio-si470x.c:562:
warning: format '%ld' expects type 'long int', but argument 3 has type
'unsigned int'
 LD [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/dvb-core.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/ttpci-eeprom.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/ttusb_dec.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/ttusbdecfe.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/cinergyT2.o
 CC [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/btaudio.o
 Building modules, stage 2.
 MODPOST 47 modules
WARNING: "videocodec_register"
[/home/alireza/VP-1041/mantis-0b04be0c088a/v4l/zr36060.ko] undefined!
WARNING: "videocodec_unregister"
[/home/alireza/VP-1041/mantis-0b04be0c088a/v4l/zr36060.ko] undefined!
WARNING: "i2c_transfer"
[/home/alireza/VP-1041/mantis-0b04be0c088a/v4l/ttpci-eeprom.ko]
undefined!
WARNING: "i2c_register_driver"
[/home/alireza/VP-1041/mantis-0b04be0c088a/v4l/ir-kbd-i2c.ko]
undefined!
WARNING: "i2c_attach_client"
[/home/alireza/VP-1041/mantis-0b04be0c088a/v4l/ir-kbd-i2c.ko]
undefined!
WARNING: "i2c_master_recv"
[/home/alireza/VP-1041/mantis-0b04be0c088a/v4l/ir-kbd-i2c.ko]
undefined!
WARNING: "i2c_detach_client"
[/home/alireza/VP-1041/mantis-0b04be0c088a/v4l/ir-kbd-i2c.ko]
undefined!
WARNING: "i2c_del_driver"
[/home/alireza/VP-1041/mantis-0b04be0c088a/v4l/ir-kbd-i2c.ko]
undefined!
 CC      /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/btaudio.mod.o
 LD [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/btaudio.ko
 CC      /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/btcx-risc.mod.o
 LD [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/btcx-risc.ko
 CC      /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/cinergyT2.mod.o
 LD [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/cinergyT2.ko
 CC      /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/compat_ioctl32.mod.o
 LD [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/compat_ioctl32.ko
 CC      /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/cpia.mod.o
 LD [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/cpia.ko
 CC      /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/cpia2.mod.o
 LD [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/cpia2.ko
 CC      /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/cpia_usb.mod.o
 LD [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/cpia_usb.ko
 CC      /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/cx2341x.mod.o
 LD [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/cx2341x.ko
 CC      /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/dabusb.mod.o
 LD [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/dabusb.ko
 CC      /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/dsbr100.mod.o
 LD [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/dsbr100.ko
 CC      /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/dvb-core.mod.o
 LD [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/dvb-core.ko
 CC      /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/et61x251.mod.o
 LD [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/et61x251.ko
 CC      /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/ibmcam.mod.o
 LD [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/ibmcam.ko
 CC      /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/ir-common.mod.o
 LD [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/ir-common.ko
 CC      /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/ir-kbd-i2c.mod.o
 LD [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/ir-kbd-i2c.ko
 CC      /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/konicawc.mod.o
 LD [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/konicawc.ko
 CC      /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/ov511.mod.o
 LD [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/ov511.ko
 CC      /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/pwc.mod.o
 LD [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/pwc.ko
 CC      /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/quickcam_messenger.mod.o
 LD [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/quickcam_messenger.ko
 CC      /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/radio-gemtek-pci.mod.o
 LD [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/radio-gemtek-pci.ko
 CC      /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/radio-maestro.mod.o
 LD [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/radio-maestro.ko
 CC      /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/radio-maxiradio.mod.o
 LD [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/radio-maxiradio.ko
 CC      /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/radio-si470x.mod.o
 LD [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/radio-si470x.ko
 CC      /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/se401.mod.o
 LD [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/se401.ko
 CC      /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/sn9c102.mod.o
 LD [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/sn9c102.ko
 CC      /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/stkwebcam.mod.o
 LD [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/stkwebcam.ko
 CC      /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/stradis.mod.o
 LD [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/stradis.ko
 CC      /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/stv680.mod.o
 LD [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/stv680.ko
 CC      /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/ttpci-eeprom.mod.o
 LD [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/ttpci-eeprom.ko
 CC      /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/ttusb_dec.mod.o
 LD [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/ttusb_dec.ko
 CC      /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/ttusbdecfe.mod.o
 LD [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/ttusbdecfe.ko
 CC      /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/tuner-types.mod.o
 LD [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/tuner-types.ko
 CC      /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/ultracam.mod.o
 LD [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/ultracam.ko
 CC      /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/usbvideo.mod.o
 LD [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/usbvideo.ko
 CC      /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/v4l1-compat.mod.o
 LD [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/v4l1-compat.ko
 CC      /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/v4l2-common.mod.o
 LD [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/v4l2-common.ko
 CC      /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/v4l2-int-device.mod.o
 LD [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/v4l2-int-device.ko
 CC      /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/vicam.mod.o
 LD [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/vicam.ko
 CC      /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/videobuf-core.mod.o
 LD [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/videobuf-core.ko
 CC      /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/videobuf-dma-sg.mod.o
 LD [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/videobuf-dma-sg.ko
 CC      /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/videobuf-dvb.mod.o
 LD [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/videobuf-dvb.ko
 CC      /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/videobuf-vmalloc.mod.o
 LD [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/videobuf-vmalloc.ko
 CC      /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/videodev.mod.o
 LD [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/videodev.ko
 CC      /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/vivi.mod.o
 LD [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/vivi.ko
 CC      /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/zc0301.mod.o
 LD [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/zc0301.ko
 CC      /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/zr36060.mod.o
 LD [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/zr36060.ko
 CC      /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/zr364xx.mod.o
 LD [M]  /home/alireza/VP-1041/mantis-0b04be0c088a/v4l/zr364xx.ko
make[2]: Leaving directory `/usr/src/linux-2.6.25.4'
./scripts/rmmod.pl check
found 47 modules
make[1]: Leaving directory `/home/alireza/VP-1041/mantis-0b04be0c088a/v4l'
alpha:/home/alireza/VP-1041/mantis-0b04be0c088a# make install
make -C /home/alireza/VP-1041/mantis-0b04be0c088a/v4l install
make[1]: Entering directory `/home/alireza/VP-1041/mantis-0b04be0c088a/v4l'
Stripping debug info from files

Removing obsolete files from /lib/modules/2.6.25.4/kernel/drivers/media/video:

Installing kernel modules under /lib/modules/2.6.25.4/kernel/drivers/media/:
       dvb/ttpci/: ttpci-eeprom.ko
       video/et61x251/: et61x251.ko
       video/cpia2/: cpia2.ko
       dvb/cinergyT2/: cinergyT2.ko
       video/usbvideo/: ibmcam.ko usbvideo.ko vicam.ko
               ultracam.ko konicawc.ko quickcam_messenger.ko
       video/sn9c102/: sn9c102.ko
       dvb/dvb-core/: dvb-core.ko
       video/: videobuf-dma-sg.ko stradis.ko videobuf-core.ko
               cx2341x.ko zr364xx.ko stv680.ko
               videobuf-dvb.ko stkwebcam.ko ir-kbd-i2c.ko
               ov511.ko dabusb.ko cpia_usb.ko
               videodev.ko zr36060.ko vivi.ko
               btcx-risc.ko se401.ko v4l2-common.ko
               v4l1-compat.ko videobuf-vmalloc.ko compat_ioctl32.ko
               v4l2-int-device.ko tuner-types.ko cpia.ko
       common/: ir-common.ko
       radio/: dsbr100.ko radio-maestro.ko radio-maxiradio.ko
               radio-si470x.ko radio-gemtek-pci.ko
       dvb/ttusb-dec/: ttusbdecfe.ko ttusb_dec.ko
       video/pwc/: pwc.ko
       video/zc0301/: zc0301.ko
/sbin/depmod -a 2.6.25.4
make[1]: Leaving directory `/home/alireza/VP-1041/mantis-0b04be0c088a/v4l'

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
