Return-path: <linux-media-owner@vger.kernel.org>
Received: from bld-mail18.adl2.internode.on.net ([150.101.137.103]:44557 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755363Ab0CXKqK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Mar 2010 06:46:10 -0400
Subject: saa716x driver status
From: Rodd Clarkson <rodd@clarkson.id.au>
To: linux-media@vger.kernel.org, linux-dvb <linux-dvb@linuxtv.org>
Content-Type: multipart/mixed; boundary="=-rspzbcc9BcgC/i9/v3NX"
Date: Wed, 24 Mar 2010 21:45:50 +1100
Message-ID: <1269427550.2680.54.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-rspzbcc9BcgC/i9/v3NX
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hi All,

I've recently acquired a AverMedia Hybrid NanoExpress tv tuner and I'm
trying to get it working with Fedora 13 and Fedora 12.

I've found drivers at http://www.jusst.de/hg/saa716x/

On f12 the driver build and install, but I have missing symbols when I
try to modprobe the drivers.

On f13 the drivers fail to build.

I've tried contacting Manu Abraham (whom I believe is the developer)
about the f12 issues, but haven't heard back.

I've searched google for everything from saa716x, AverMedia Hybrid Nano
Express, HC82 and 1461:0555 (the pci address, I guess).  There's bits
and pieces about this driver in the results, but most are that they can
build the driver, but it doesn't work.

I'm happy to 'risk' my card and try stuff to get this to work, but I'm
curious about whether or not development is ongoing and how I can help
(not being a c coder)

I'll attach the output of the build attempt on f13 in case someone can
advise what is going wrong.  The build log was captured using:

$ make &> /tmp/saa716x.build.log.f13

regards 


Rodd


--=-rspzbcc9BcgC/i9/v3NX
Content-Disposition: attachment; filename="saa716x.build.log.f13"
Content-Type: text/plain; name="saa716x.build.log.f13"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

make -C /tmp/saa716x-01c9f2163edd/v4l 
make[1]: Entering directory `/tmp/saa716x-01c9f2163edd/v4l'
perl scripts/make_config_compat.pl /lib/modules/2.6.33-1.fc13.x86_64/source ./.myconfig ./config-compat.h
creating symbolic links...
make -C firmware prep
make[2]: Entering directory `/tmp/saa716x-01c9f2163edd/v4l/firmware'
make[2]: Leaving directory `/tmp/saa716x-01c9f2163edd/v4l/firmware'
make -C firmware
make[2]: Entering directory `/tmp/saa716x-01c9f2163edd/v4l/firmware'
  CC  ihex2fw
Generating vicam/firmware.fw
Generating dabusb/firmware.fw
Generating dabusb/bitstream.bin
Generating ttusb-budget/dspbootcode.bin
Generating cpia2/stv0672_vp4.bin
Generating av7110/bootcode.bin
make[2]: Leaving directory `/tmp/saa716x-01c9f2163edd/v4l/firmware'
Kernel build directory is /lib/modules/2.6.33-1.fc13.x86_64/build
make -C /lib/modules/2.6.33-1.fc13.x86_64/build SUBDIRS=/tmp/saa716x-01c9f2163edd/v4l  modules
make[2]: Entering directory `/usr/src/kernels/2.6.33-1.fc13.x86_64'
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/tuner-xc2028.o
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/tuner-simple.o
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/tuner-types.o
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/mt20xx.o
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/tda8290.o
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/tea5767.o
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/tea5761.o
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/tda9887.o
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/tda827x.o
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/au0828-core.o
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/au0828-i2c.o
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/au0828-cards.o
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/au0828-dvb.o
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/au0828-video.o
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/au8522_dig.o
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/au8522_decoder.o
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/flexcop-pci.o
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/flexcop-usb.o
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/flexcop.o
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/flexcop-fe-tuner.o
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/flexcop-i2c.o
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/flexcop-sram.o
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/flexcop-eeprom.o
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/flexcop-misc.o
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/flexcop-hw-filter.o
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/flexcop-dma.o
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/bttv-driver.o
In file included from /tmp/saa716x-01c9f2163edd/v4l/bttvp.h:36,
                 from /tmp/saa716x-01c9f2163edd/v4l/bttv-driver.c:47:
include/linux/input.h:599:1: warning: "KEY_RFKILL" redefined
include/linux/input.h:379:1: warning: this is the location of the previous definition
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/bttv-cards.o
In file included from /tmp/saa716x-01c9f2163edd/v4l/bttvp.h:36,
                 from /tmp/saa716x-01c9f2163edd/v4l/bttv-cards.c:41:
include/linux/input.h:599:1: warning: "KEY_RFKILL" redefined
include/linux/input.h:379:1: warning: this is the location of the previous definition
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/bttv-if.o
In file included from /tmp/saa716x-01c9f2163edd/v4l/bttvp.h:36,
                 from /tmp/saa716x-01c9f2163edd/v4l/bttv-if.c:34:
include/linux/input.h:599:1: warning: "KEY_RFKILL" redefined
include/linux/input.h:379:1: warning: this is the location of the previous definition
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/bttv-risc.o
In file included from /tmp/saa716x-01c9f2163edd/v4l/bttvp.h:36,
                 from /tmp/saa716x-01c9f2163edd/v4l/bttv-risc.c:36:
include/linux/input.h:599:1: warning: "KEY_RFKILL" redefined
include/linux/input.h:379:1: warning: this is the location of the previous definition
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/bttv-vbi.o
In file included from /tmp/saa716x-01c9f2163edd/v4l/bttvp.h:36,
                 from /tmp/saa716x-01c9f2163edd/v4l/bttv-vbi.c:34:
include/linux/input.h:599:1: warning: "KEY_RFKILL" redefined
include/linux/input.h:379:1: warning: this is the location of the previous definition
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/bttv-i2c.o
In file included from /tmp/saa716x-01c9f2163edd/v4l/bttvp.h:36,
                 from /tmp/saa716x-01c9f2163edd/v4l/bttv-i2c.c:34:
include/linux/input.h:599:1: warning: "KEY_RFKILL" redefined
include/linux/input.h:379:1: warning: this is the location of the previous definition
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/bttv-gpio.o
In file included from /tmp/saa716x-01c9f2163edd/v4l/bttvp.h:36,
                 from /tmp/saa716x-01c9f2163edd/v4l/bttv-gpio.c:35:
include/linux/input.h:599:1: warning: "KEY_RFKILL" redefined
include/linux/input.h:379:1: warning: this is the location of the previous definition
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/bttv-input.o
In file included from /tmp/saa716x-01c9f2163edd/v4l/bttv-input.c:25:
include/linux/input.h:599:1: warning: "KEY_RFKILL" redefined
include/linux/input.h:379:1: warning: this is the location of the previous definition
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/bttv-audio-hook.o
In file included from /tmp/saa716x-01c9f2163edd/v4l/bttvp.h:36,
                 from /tmp/saa716x-01c9f2163edd/v4l/bttv-audio-hook.h:8,
                 from /tmp/saa716x-01c9f2163edd/v4l/bttv-audio-hook.c:8:
include/linux/input.h:599:1: warning: "KEY_RFKILL" redefined
include/linux/input.h:379:1: warning: this is the location of the previous definition
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/cpia2_v4l.o
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/cpia2_usb.o
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/cpia2_core.o
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/cx18-driver.o
In file included from /tmp/saa716x-01c9f2163edd/v4l/../linux/include/media/ir-common.h:26,
                 from /tmp/saa716x-01c9f2163edd/v4l/../linux/include/media/ir-kbd-i2c.h:4,
                 from /tmp/saa716x-01c9f2163edd/v4l/cx18-driver.h:54,
                 from /tmp/saa716x-01c9f2163edd/v4l/cx18-driver.c:25:
include/linux/input.h:599:1: warning: "KEY_RFKILL" redefined
include/linux/input.h:379:1: warning: this is the location of the previous definition
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/cx18-cards.o
In file included from /tmp/saa716x-01c9f2163edd/v4l/../linux/include/media/ir-common.h:26,
                 from /tmp/saa716x-01c9f2163edd/v4l/../linux/include/media/ir-kbd-i2c.h:4,
                 from /tmp/saa716x-01c9f2163edd/v4l/cx18-driver.h:54,
                 from /tmp/saa716x-01c9f2163edd/v4l/cx18-cards.c:25:
include/linux/input.h:599:1: warning: "KEY_RFKILL" redefined
include/linux/input.h:379:1: warning: this is the location of the previous definition
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/cx18-i2c.o
In file included from /tmp/saa716x-01c9f2163edd/v4l/../linux/include/media/ir-common.h:26,
                 from /tmp/saa716x-01c9f2163edd/v4l/../linux/include/media/ir-kbd-i2c.h:4,
                 from /tmp/saa716x-01c9f2163edd/v4l/cx18-driver.h:54,
                 from /tmp/saa716x-01c9f2163edd/v4l/cx18-i2c.c:25:
include/linux/input.h:599:1: warning: "KEY_RFKILL" redefined
include/linux/input.h:379:1: warning: this is the location of the previous definition
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/cx18-firmware.o
In file included from /tmp/saa716x-01c9f2163edd/v4l/../linux/include/media/ir-common.h:26,
                 from /tmp/saa716x-01c9f2163edd/v4l/../linux/include/media/ir-kbd-i2c.h:4,
                 from /tmp/saa716x-01c9f2163edd/v4l/cx18-driver.h:54,
                 from /tmp/saa716x-01c9f2163edd/v4l/cx18-firmware.c:23:
include/linux/input.h:599:1: warning: "KEY_RFKILL" redefined
include/linux/input.h:379:1: warning: this is the location of the previous definition
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/cx18-gpio.o
In file included from /tmp/saa716x-01c9f2163edd/v4l/../linux/include/media/ir-common.h:26,
                 from /tmp/saa716x-01c9f2163edd/v4l/../linux/include/media/ir-kbd-i2c.h:4,
                 from /tmp/saa716x-01c9f2163edd/v4l/cx18-driver.h:54,
                 from /tmp/saa716x-01c9f2163edd/v4l/cx18-gpio.c:25:
include/linux/input.h:599:1: warning: "KEY_RFKILL" redefined
include/linux/input.h:379:1: warning: this is the location of the previous definition
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/cx18-queue.o
In file included from /tmp/saa716x-01c9f2163edd/v4l/../linux/include/media/ir-common.h:26,
                 from /tmp/saa716x-01c9f2163edd/v4l/../linux/include/media/ir-kbd-i2c.h:4,
                 from /tmp/saa716x-01c9f2163edd/v4l/cx18-driver.h:54,
                 from /tmp/saa716x-01c9f2163edd/v4l/cx18-queue.c:25:
include/linux/input.h:599:1: warning: "KEY_RFKILL" redefined
include/linux/input.h:379:1: warning: this is the location of the previous definition
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/cx18-streams.o
In file included from /tmp/saa716x-01c9f2163edd/v4l/../linux/include/media/ir-common.h:26,
                 from /tmp/saa716x-01c9f2163edd/v4l/../linux/include/media/ir-kbd-i2c.h:4,
                 from /tmp/saa716x-01c9f2163edd/v4l/cx18-driver.h:54,
                 from /tmp/saa716x-01c9f2163edd/v4l/cx18-streams.c:25:
include/linux/input.h:599:1: warning: "KEY_RFKILL" redefined
include/linux/input.h:379:1: warning: this is the location of the previous definition
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/cx18-fileops.o
In file included from /tmp/saa716x-01c9f2163edd/v4l/../linux/include/media/ir-common.h:26,
                 from /tmp/saa716x-01c9f2163edd/v4l/../linux/include/media/ir-kbd-i2c.h:4,
                 from /tmp/saa716x-01c9f2163edd/v4l/cx18-driver.h:54,
                 from /tmp/saa716x-01c9f2163edd/v4l/cx18-fileops.c:25:
include/linux/input.h:599:1: warning: "KEY_RFKILL" redefined
include/linux/input.h:379:1: warning: this is the location of the previous definition
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/cx18-ioctl.o
In file included from /tmp/saa716x-01c9f2163edd/v4l/../linux/include/media/ir-common.h:26,
                 from /tmp/saa716x-01c9f2163edd/v4l/../linux/include/media/ir-kbd-i2c.h:4,
                 from /tmp/saa716x-01c9f2163edd/v4l/cx18-driver.h:54,
                 from /tmp/saa716x-01c9f2163edd/v4l/cx18-ioctl.c:25:
include/linux/input.h:599:1: warning: "KEY_RFKILL" redefined
include/linux/input.h:379:1: warning: this is the location of the previous definition
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/cx18-controls.o
In file included from /tmp/saa716x-01c9f2163edd/v4l/../linux/include/media/ir-common.h:26,
                 from /tmp/saa716x-01c9f2163edd/v4l/../linux/include/media/ir-kbd-i2c.h:4,
                 from /tmp/saa716x-01c9f2163edd/v4l/cx18-driver.h:54,
                 from /tmp/saa716x-01c9f2163edd/v4l/cx18-controls.c:25:
include/linux/input.h:599:1: warning: "KEY_RFKILL" redefined
include/linux/input.h:379:1: warning: this is the location of the previous definition
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/cx18-mailbox.o
In file included from /tmp/saa716x-01c9f2163edd/v4l/../linux/include/media/ir-common.h:26,
                 from /tmp/saa716x-01c9f2163edd/v4l/../linux/include/media/ir-kbd-i2c.h:4,
                 from /tmp/saa716x-01c9f2163edd/v4l/cx18-driver.h:54,
                 from /tmp/saa716x-01c9f2163edd/v4l/cx18-mailbox.c:25:
include/linux/input.h:599:1: warning: "KEY_RFKILL" redefined
include/linux/input.h:379:1: warning: this is the location of the previous definition
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/cx18-vbi.o
In file included from /tmp/saa716x-01c9f2163edd/v4l/../linux/include/media/ir-common.h:26,
                 from /tmp/saa716x-01c9f2163edd/v4l/../linux/include/media/ir-kbd-i2c.h:4,
                 from /tmp/saa716x-01c9f2163edd/v4l/cx18-driver.h:54,
                 from /tmp/saa716x-01c9f2163edd/v4l/cx18-vbi.c:24:
include/linux/input.h:599:1: warning: "KEY_RFKILL" redefined
include/linux/input.h:379:1: warning: this is the location of the previous definition
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/cx18-audio.o
In file included from /tmp/saa716x-01c9f2163edd/v4l/../linux/include/media/ir-common.h:26,
                 from /tmp/saa716x-01c9f2163edd/v4l/../linux/include/media/ir-kbd-i2c.h:4,
                 from /tmp/saa716x-01c9f2163edd/v4l/cx18-driver.h:54,
                 from /tmp/saa716x-01c9f2163edd/v4l/cx18-audio.c:24:
include/linux/input.h:599:1: warning: "KEY_RFKILL" redefined
include/linux/input.h:379:1: warning: this is the location of the previous definition
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/cx18-video.o
In file included from /tmp/saa716x-01c9f2163edd/v4l/../linux/include/media/ir-common.h:26,
                 from /tmp/saa716x-01c9f2163edd/v4l/../linux/include/media/ir-kbd-i2c.h:4,
                 from /tmp/saa716x-01c9f2163edd/v4l/cx18-driver.h:54,
                 from /tmp/saa716x-01c9f2163edd/v4l/cx18-video.c:22:
include/linux/input.h:599:1: warning: "KEY_RFKILL" redefined
include/linux/input.h:379:1: warning: this is the location of the previous definition
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/cx18-irq.o
In file included from /tmp/saa716x-01c9f2163edd/v4l/../linux/include/media/ir-common.h:26,
                 from /tmp/saa716x-01c9f2163edd/v4l/../linux/include/media/ir-kbd-i2c.h:4,
                 from /tmp/saa716x-01c9f2163edd/v4l/cx18-driver.h:54,
                 from /tmp/saa716x-01c9f2163edd/v4l/cx18-irq.c:23:
include/linux/input.h:599:1: warning: "KEY_RFKILL" redefined
include/linux/input.h:379:1: warning: this is the location of the previous definition
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/cx18-av-core.o
In file included from /tmp/saa716x-01c9f2163edd/v4l/../linux/include/media/ir-common.h:26,
                 from /tmp/saa716x-01c9f2163edd/v4l/../linux/include/media/ir-kbd-i2c.h:4,
                 from /tmp/saa716x-01c9f2163edd/v4l/cx18-driver.h:54,
                 from /tmp/saa716x-01c9f2163edd/v4l/cx18-av-core.c:26:
include/linux/input.h:599:1: warning: "KEY_RFKILL" redefined
include/linux/input.h:379:1: warning: this is the location of the previous definition
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/cx18-av-audio.o
In file included from /tmp/saa716x-01c9f2163edd/v4l/../linux/include/media/ir-common.h:26,
                 from /tmp/saa716x-01c9f2163edd/v4l/../linux/include/media/ir-kbd-i2c.h:4,
                 from /tmp/saa716x-01c9f2163edd/v4l/cx18-driver.h:54,
                 from /tmp/saa716x-01c9f2163edd/v4l/cx18-av-audio.c:25:
include/linux/input.h:599:1: warning: "KEY_RFKILL" redefined
include/linux/input.h:379:1: warning: this is the location of the previous definition
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/cx18-av-firmware.o
In file included from /tmp/saa716x-01c9f2163edd/v4l/../linux/include/media/ir-common.h:26,
                 from /tmp/saa716x-01c9f2163edd/v4l/../linux/include/media/ir-kbd-i2c.h:4,
                 from /tmp/saa716x-01c9f2163edd/v4l/cx18-driver.h:54,
                 from /tmp/saa716x-01c9f2163edd/v4l/cx18-av-firmware.c:23:
include/linux/input.h:599:1: warning: "KEY_RFKILL" redefined
include/linux/input.h:379:1: warning: this is the location of the previous definition
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/cx18-av-vbi.o
In file included from /tmp/saa716x-01c9f2163edd/v4l/../linux/include/media/ir-common.h:26,
                 from /tmp/saa716x-01c9f2163edd/v4l/../linux/include/media/ir-kbd-i2c.h:4,
                 from /tmp/saa716x-01c9f2163edd/v4l/cx18-driver.h:54,
                 from /tmp/saa716x-01c9f2163edd/v4l/cx18-av-vbi.c:25:
include/linux/input.h:599:1: warning: "KEY_RFKILL" redefined
include/linux/input.h:379:1: warning: this is the location of the previous definition
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/cx18-scb.o
In file included from /tmp/saa716x-01c9f2163edd/v4l/../linux/include/media/ir-common.h:26,
                 from /tmp/saa716x-01c9f2163edd/v4l/../linux/include/media/ir-kbd-i2c.h:4,
                 from /tmp/saa716x-01c9f2163edd/v4l/cx18-driver.h:54,
                 from /tmp/saa716x-01c9f2163edd/v4l/cx18-scb.c:23:
include/linux/input.h:599:1: warning: "KEY_RFKILL" redefined
include/linux/input.h:379:1: warning: this is the location of the previous definition
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/cx18-dvb.o
In file included from /tmp/saa716x-01c9f2163edd/v4l/../linux/include/media/ir-common.h:26,
                 from /tmp/saa716x-01c9f2163edd/v4l/../linux/include/media/ir-kbd-i2c.h:4,
                 from /tmp/saa716x-01c9f2163edd/v4l/cx18-driver.h:54,
                 from /tmp/saa716x-01c9f2163edd/v4l/cx18-dvb.h:22,
                 from /tmp/saa716x-01c9f2163edd/v4l/cx18-dvb.c:24:
include/linux/input.h:599:1: warning: "KEY_RFKILL" redefined
include/linux/input.h:379:1: warning: this is the location of the previous definition
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/cx18-io.o
In file included from /tmp/saa716x-01c9f2163edd/v4l/../linux/include/media/ir-common.h:26,
                 from /tmp/saa716x-01c9f2163edd/v4l/../linux/include/media/ir-kbd-i2c.h:4,
                 from /tmp/saa716x-01c9f2163edd/v4l/cx18-driver.h:54,
                 from /tmp/saa716x-01c9f2163edd/v4l/cx18-io.c:23:
include/linux/input.h:599:1: warning: "KEY_RFKILL" redefined
include/linux/input.h:379:1: warning: this is the location of the previous definition
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/cx231xx-audio.o
In file included from /tmp/saa716x-01c9f2163edd/v4l/../linux/include/media/ir-common.h:26,
                 from /tmp/saa716x-01c9f2163edd/v4l/../linux/include/media/ir-kbd-i2c.h:4,
                 from /tmp/saa716x-01c9f2163edd/v4l/cx231xx.h:36,
                 from /tmp/saa716x-01c9f2163edd/v4l/cx231xx-audio.c:41:
include/linux/input.h:599:1: warning: "KEY_RFKILL" redefined
include/linux/input.h:379:1: warning: this is the location of the previous definition
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/cx231xx-video.o
In file included from /tmp/saa716x-01c9f2163edd/v4l/../linux/include/media/ir-common.h:26,
                 from /tmp/saa716x-01c9f2163edd/v4l/../linux/include/media/ir-kbd-i2c.h:4,
                 from /tmp/saa716x-01c9f2163edd/v4l/cx231xx.h:36,
                 from /tmp/saa716x-01c9f2163edd/v4l/cx231xx-video.c:44:
include/linux/input.h:599:1: warning: "KEY_RFKILL" redefined
include/linux/input.h:379:1: warning: this is the location of the previous definition
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/cx231xx-i2c.o
In file included from /tmp/saa716x-01c9f2163edd/v4l/../linux/include/media/ir-common.h:26,
                 from /tmp/saa716x-01c9f2163edd/v4l/../linux/include/media/ir-kbd-i2c.h:4,
                 from /tmp/saa716x-01c9f2163edd/v4l/cx231xx.h:36,
                 from /tmp/saa716x-01c9f2163edd/v4l/cx231xx-i2c.c:30:
include/linux/input.h:599:1: warning: "KEY_RFKILL" redefined
include/linux/input.h:379:1: warning: this is the location of the previous definition
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/cx231xx-cards.o
In file included from /tmp/saa716x-01c9f2163edd/v4l/../linux/include/media/ir-common.h:26,
                 from /tmp/saa716x-01c9f2163edd/v4l/../linux/include/media/ir-kbd-i2c.h:4,
                 from /tmp/saa716x-01c9f2163edd/v4l/cx231xx.h:36,
                 from /tmp/saa716x-01c9f2163edd/v4l/cx231xx-cards.c:37:
include/linux/input.h:599:1: warning: "KEY_RFKILL" redefined
include/linux/input.h:379:1: warning: this is the location of the previous definition
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/cx231xx-core.o
In file included from /tmp/saa716x-01c9f2163edd/v4l/../linux/include/media/ir-common.h:26,
                 from /tmp/saa716x-01c9f2163edd/v4l/../linux/include/media/ir-kbd-i2c.h:4,
                 from /tmp/saa716x-01c9f2163edd/v4l/cx231xx.h:36,
                 from /tmp/saa716x-01c9f2163edd/v4l/cx231xx-core.c:30:
include/linux/input.h:599:1: warning: "KEY_RFKILL" redefined
include/linux/input.h:379:1: warning: this is the location of the previous definition
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/cx231xx-avcore.o
In file included from /tmp/saa716x-01c9f2163edd/v4l/../linux/include/media/ir-common.h:26,
                 from /tmp/saa716x-01c9f2163edd/v4l/../linux/include/media/ir-kbd-i2c.h:4,
                 from /tmp/saa716x-01c9f2163edd/v4l/cx231xx.h:36,
                 from /tmp/saa716x-01c9f2163edd/v4l/cx231xx-avcore.c:39:
include/linux/input.h:599:1: warning: "KEY_RFKILL" redefined
include/linux/input.h:379:1: warning: this is the location of the previous definition
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/cx231xx-pcb-cfg.o
In file included from /tmp/saa716x-01c9f2163edd/v4l/../linux/include/media/ir-common.h:26,
                 from /tmp/saa716x-01c9f2163edd/v4l/../linux/include/media/ir-kbd-i2c.h:4,
                 from /tmp/saa716x-01c9f2163edd/v4l/cx231xx.h:36,
                 from /tmp/saa716x-01c9f2163edd/v4l/cx231xx-pcb-cfg.c:22:
include/linux/input.h:599:1: warning: "KEY_RFKILL" redefined
include/linux/input.h:379:1: warning: this is the location of the previous definition
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/cx231xx-vbi.o
In file included from /tmp/saa716x-01c9f2163edd/v4l/../linux/include/media/ir-common.h:26,
                 from /tmp/saa716x-01c9f2163edd/v4l/../linux/include/media/ir-kbd-i2c.h:4,
                 from /tmp/saa716x-01c9f2163edd/v4l/cx231xx.h:36,
                 from /tmp/saa716x-01c9f2163edd/v4l/cx231xx-vbi.c:38:
include/linux/input.h:599:1: warning: "KEY_RFKILL" redefined
include/linux/input.h:379:1: warning: this is the location of the previous definition
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/cx23885-cards.o
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/cx23885-video.o
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/cx23885-vbi.o
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/cx23885-core.o
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/cx23885-i2c.o
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/cx23885-dvb.o
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/cx23885-417.o
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/cx23885-ioctl.o
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/cx23885-ir.o
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/cx23885-input.o
In file included from /tmp/saa716x-01c9f2163edd/v4l/cx23885-input.c:38:
include/linux/input.h:599:1: warning: "KEY_RFKILL" redefined
include/linux/input.h:379:1: warning: this is the location of the previous definition
  CC [M]  /tmp/saa716x-01c9f2163edd/v4l/cx23888-ir.o
/tmp/saa716x-01c9f2163edd/v4l/cx23888-ir.c: In function 'cx23888_ir_irq_handler':
/tmp/saa716x-01c9f2163edd/v4l/cx23888-ir.c:623: error: implicit declaration of function 'kfifo_put'
/tmp/saa716x-01c9f2163edd/v4l/cx23888-ir.c: In function 'cx23888_ir_rx_read':
/tmp/saa716x-01c9f2163edd/v4l/cx23888-ir.c:686: error: implicit declaration of function 'kfifo_get'
/tmp/saa716x-01c9f2163edd/v4l/cx23888-ir.c: In function 'cx23888_ir_probe':
/tmp/saa716x-01c9f2163edd/v4l/cx23888-ir.c:1238: warning: passing argument 1 of 'kfifo_alloc' makes pointer from integer without a cast
include/linux/kfifo.h:109: note: expected 'struct kfifo *' but argument is of type 'long unsigned int'
/tmp/saa716x-01c9f2163edd/v4l/cx23888-ir.c:1238: warning: passing argument 3 of 'kfifo_alloc' makes integer from pointer without a cast
include/linux/kfifo.h:109: note: expected 'gfp_t' but argument is of type 'struct spinlock_t *'
/tmp/saa716x-01c9f2163edd/v4l/cx23888-ir.c:1238: warning: assignment makes pointer from integer without a cast
/tmp/saa716x-01c9f2163edd/v4l/cx23888-ir.c:1244: warning: passing argument 1 of 'kfifo_alloc' makes pointer from integer without a cast
include/linux/kfifo.h:109: note: expected 'struct kfifo *' but argument is of type 'long unsigned int'
/tmp/saa716x-01c9f2163edd/v4l/cx23888-ir.c:1244: warning: passing argument 3 of 'kfifo_alloc' makes integer from pointer without a cast
include/linux/kfifo.h:109: note: expected 'gfp_t' but argument is of type 'struct spinlock_t *'
/tmp/saa716x-01c9f2163edd/v4l/cx23888-ir.c:1244: warning: assignment makes pointer from integer without a cast
make[3]: *** [/tmp/saa716x-01c9f2163edd/v4l/cx23888-ir.o] Error 1
make[2]: *** [_module_/tmp/saa716x-01c9f2163edd/v4l] Error 2
make[2]: Leaving directory `/usr/src/kernels/2.6.33-1.fc13.x86_64'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/tmp/saa716x-01c9f2163edd/v4l'
make: *** [all] Error 2

--=-rspzbcc9BcgC/i9/v3NX--

