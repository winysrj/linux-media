Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.188])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <user.vdr@gmail.com>) id 1KJANT-0001HQ-HR
	for linux-dvb@linuxtv.org; Wed, 16 Jul 2008 19:01:23 +0200
Received: by nf-out-0910.google.com with SMTP id g13so2001002nfb.11
	for <linux-dvb@linuxtv.org>; Wed, 16 Jul 2008 10:01:13 -0700 (PDT)
Message-ID: <a3ef07920807161001n4a67984emcfbe58f84c50f3e1@mail.gmail.com>
Date: Wed, 16 Jul 2008 10:01:13 -0700
From: "VDR User" <user.vdr@gmail.com>
To: "mailing list: linux-dvb" <linux-dvb@linuxtv.org>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] bt878 appears to be broken.
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

Debian testing/lenny, 2.6.26 stable kernel

Here's the log:

test:/v4l$ make
make -C /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l
make[1]: Entering directory `/usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l'
./scripts/make_myconfig.pl
make[1]: Leaving directory `/usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l'
make[1]: Entering directory `/usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l'
perl scripts/make_config_compat.pl
/lib/modules/2.6.26.amd64-x2.071608.1/source ./.myconfig
./config-compat.h
creating symbolic links...
Kernel build directory is /lib/modules/2.6.26.amd64-x2.071608.1/build
make -C /lib/modules/2.6.26.amd64-x2.071608.1/build
SUBDIRS=/usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l  modules
make[2]: Entering directory `/usr/src/linux-2.6.26'
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/tuner-xc2028.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/tuner-simple.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/tuner-types.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/mt20xx.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/tda8290.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/tea5767.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/tea5761.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/tda9887.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/xc5000.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/bttv-driver.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/bttv-cards.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/bttv-if.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/bttv-risc.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/bttv-vbi.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/bttv-i2c.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/bttv-gpio.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/bttv-input.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/bttv-audio-hook.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/dvbdev.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/dmxdev.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/dvb_demux.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/dvb_filter.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/dvb_ca_en50221.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/dvb_frontend.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/dvb_net.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/dvb_ringbuffer.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/dvb_math.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/gp8psk.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/gp8psk-fe.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/dvb-usb-firmware.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/dvb-usb-init.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/dvb-usb-urb.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/dvb-usb-i2c.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/dvb-usb-dvb.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/dvb-usb-remote.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/usb-urb.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/ir-functions.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/ir-keymaps.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/saa7146_i2c.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/saa7146_core.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/tuner-core.o
  LD [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/saa7146.o
  LD [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/ir-common.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/videodev.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/compat_ioctl32.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/v4l2-int-device.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/v4l2-common.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/v4l1-compat.o
  LD [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/bttv.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/ir-kbd-i2c.o
  LD [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/tuner.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/videobuf-core.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/videobuf-dma-sg.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/btcx-risc.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/tveeprom.o
  LD [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/dvb-core.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/stv0299.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/cx24110.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/tda8083.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/l64781.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/ves1820.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/ves1x93.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/sp887x.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/nxt6000.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/mt352.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/zl10353.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/tda10021.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/tda10023.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/or51211.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/s5h1420.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/lgdt330x.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/lnbp21.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/tda10086.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/tda826x.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/ttpci-eeprom.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/budget-core.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/budget.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/bt878.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/dvb-bt8xx.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/dst.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/dst_ca.o
  LD [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/dvb-usb.o
  LD [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/dvb-usb-gp8psk.o
  Building modules, stage 2.
  MODPOST 51 modules
WARNING: "i2c_bit_add_bus"
[/usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/bttv.ko]
undefined!
  CC      /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/bt878.mod.o
  LD [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/bt878.ko
  CC      /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/btcx-risc.mod.o
  LD [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/btcx-risc.ko
  CC      /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/bttv.mod.o
  LD [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/bttv.ko
  CC      /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/budget-core.mod.o
  LD [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/budget-core.ko
  CC      /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/budget.mod.o
  LD [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/budget.ko
  CC      /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/compat_ioctl32.mod.o
  LD [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/compat_ioctl32.ko
  CC      /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/cx24110.mod.o
  LD [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/cx24110.ko
  CC      /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/dst.mod.o
  LD [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/dst.ko
  CC      /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/dst_ca.mod.o
  LD [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/dst_ca.ko
  CC      /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/dvb-bt8xx.mod.o
  LD [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/dvb-bt8xx.ko
  CC      /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/dvb-core.mod.o
  LD [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/dvb-core.ko
  CC      /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/dvb-usb-gp8psk.mod.o
  LD [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/dvb-usb-gp8psk.ko
  CC      /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/dvb-usb.mod.o
  LD [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/dvb-usb.ko
  CC      /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/ir-common.mod.o
  LD [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/ir-common.ko
  CC      /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/ir-kbd-i2c.mod.o
  LD [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/ir-kbd-i2c.ko
  CC      /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/l64781.mod.o
  LD [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/l64781.ko
  CC      /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/lgdt330x.mod.o
  LD [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/lgdt330x.ko
  CC      /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/lnbp21.mod.o
  LD [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/lnbp21.ko
  CC      /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/mt20xx.mod.o
  LD [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/mt20xx.ko
  CC      /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/mt352.mod.o
  LD [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/mt352.ko
  CC      /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/nxt6000.mod.o
  LD [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/nxt6000.ko
  CC      /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/or51211.mod.o
  LD [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/or51211.ko
  CC      /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/s5h1420.mod.o
  LD [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/s5h1420.ko
  CC      /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/saa7146.mod.o
  LD [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/saa7146.ko
  CC      /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/sp887x.mod.o
  LD [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/sp887x.ko
  CC      /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/stv0299.mod.o
  LD [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/stv0299.ko
  CC      /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/tda10021.mod.o
  LD [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/tda10021.ko
  CC      /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/tda10023.mod.o
  LD [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/tda10023.ko
  CC      /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/tda10086.mod.o
  LD [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/tda10086.ko
  CC      /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/tda8083.mod.o
  LD [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/tda8083.ko
  CC      /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/tda826x.mod.o
  LD [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/tda826x.ko
  CC      /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/tda8290.mod.o
  LD [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/tda8290.ko
  CC      /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/tda9887.mod.o
  LD [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/tda9887.ko
  CC      /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/tea5761.mod.o
  LD [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/tea5761.ko
  CC      /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/tea5767.mod.o
  LD [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/tea5767.ko
  CC      /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/ttpci-eeprom.mod.o
  LD [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/ttpci-eeprom.ko
  CC      /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/tuner-simple.mod.o
  LD [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/tuner-simple.ko
  CC      /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/tuner-types.mod.o
  LD [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/tuner-types.ko
  CC      /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/tuner-xc2028.mod.o
  LD [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/tuner-xc2028.ko
  CC      /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/tuner.mod.o
  LD [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/tuner.ko
  CC      /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/tveeprom.mod.o
  LD [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/tveeprom.ko
  CC      /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/v4l1-compat.mod.o
  LD [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/v4l1-compat.ko
  CC      /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/v4l2-common.mod.o
  LD [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/v4l2-common.ko
  CC      /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/v4l2-int-device.mod.o
  LD [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/v4l2-int-device.ko
  CC      /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/ves1820.mod.o
  LD [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/ves1820.ko
  CC      /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/ves1x93.mod.o
  LD [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/ves1x93.ko
  CC      /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/videobuf-core.mod.o
  LD [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/videobuf-core.ko
  CC      /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/videobuf-dma-sg.mod.o
  LD [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/videobuf-dma-sg.ko
  CC      /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/videodev.mod.o
  LD [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/videodev.ko
  CC      /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/xc5000.mod.o
  LD [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/xc5000.ko
  CC      /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/zl10353.mod.o
  LD [M]  /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l/zl10353.ko
make[2]: Leaving directory `/usr/src/linux-2.6.26'
./scripts/rmmod.pl check
found 53 modules
make[1]: Leaving directory `/usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l'
test:/v4l$ sudo make install
make -C /usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l install
make[1]: Entering directory `/usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l'
Stripping debug info from files

Removing obsolete files from
/lib/modules/2.6.26.amd64-x2.071608.1/kernel/drivers/media/video:


Removing obsolete files from
/lib/modules/2.6.26.amd64-x2.071608.1/kernel/drivers/media/dvb/frontends:

Installing kernel modules under
/lib/modules/2.6.26.amd64-x2.071608.1/kernel/drivers/media/:
        dvb/dvb-usb/: dvb-usb-gp8psk.ko dvb-usb.ko
        common/tuners/: mt20xx.ko xc5000.ko tuner-xc2028.ko
                tea5761.ko tuner-types.ko tda9887.ko
                tda8290.ko tuner-simple.ko tea5767.ko
        dvb/dvb-core/: dvb-core.ko
        video/: videobuf-dma-sg.ko videobuf-core.ko tuner.ko
                ir-kbd-i2c.ko videodev.ko btcx-risc.ko
                v4l2-common.ko v4l1-compat.ko compat_ioctl32.ko
                v4l2-int-device.ko tveeprom.ko
        dvb/bt8xx/: dst_ca.ko dvb-bt8xx.ko bt878.ko
                dst.ko
        dvb/ttpci/: ttpci-eeprom.ko budget.ko budget-core.ko
        dvb/frontends/: nxt6000.ko s5h1420.ko mt352.ko
                sp887x.ko sp8870.ko l64781.ko
                ves1x93.ko tda8083.ko ves1820.ko
                stv0297.ko tda10086.ko zl10353.ko
                cx24110.ko stv0299.ko lgdt330x.ko
                lnbp21.ko tda10023.ko tda10021.ko
                or51211.ko tda826x.ko
        video/bt8xx/: bttv.ko
        common/: ir-common.ko saa7146.ko
/sbin/depmod -a 2.6.26.amd64-x2.071608.1
make[1]: Leaving directory `/usr/local/dvb/v4l.source/v4l.20080716/v4l-dvb/v4l'
test:/v4l$ drivers load budget
Loading: DVB driver modules -> dst dvb-bt8xx
WARNING: Error inserting bttv
(/lib/modules/2.6.26.amd64-x2.071608.1/kernel/drivers/media/video/bt8xx/bttv.ko):
Unknown symbol in module, or unknown parameter (see dmesg)
WARNING: Error inserting bt878
(/lib/modules/2.6.26.amd64-x2.071608.1/kernel/drivers/media/dvb/bt8xx/bt878.ko):
Unknown symbol in module, or unknown parameter (see dmesg)
WARNING: Error inserting dst
(/lib/modules/2.6.26.amd64-x2.071608.1/kernel/drivers/media/dvb/bt8xx/dst.ko):
Unknown symbol in module, or unknown parameter (see dmesg)
WARNING: Error inserting bttv
(/lib/modules/2.6.26.amd64-x2.071608.1/kernel/drivers/media/video/bt8xx/bttv.ko):
Unknown symbol in module, or unknown parameter (see dmesg)
WARNING: Error inserting bt878
(/lib/modules/2.6.26.amd64-x2.071608.1/kernel/drivers/media/dvb/bt8xx/bt878.ko):
Unknown symbol in module, or unknown parameter (see dmesg)
WARNING: Error inserting dvb_bt8xx
(/lib/modules/2.6.26.amd64-x2.071608.1/kernel/drivers/media/dvb/bt8xx/dvb-bt8xx.ko):
Unknown symbol in module, or unknown parameter (see dmesg)
test:/v4l$ dmesg

[ 5037.519895] bttv: Unknown symbol i2c_bit_add_bus
[ 5037.522127] bt878: Unknown symbol bttv_read_gpio
[ 5037.522202] bt878: Unknown symbol bttv_write_gpio
[ 5037.522258] bt878: Unknown symbol bttv_gpio_enable
[ 5037.524110] dst: Unknown symbol bt878_device_control
[ 5037.529094] bttv: Unknown symbol i2c_bit_add_bus
[ 5037.531917] bt878: Unknown symbol bttv_read_gpio
[ 5037.531993] bt878: Unknown symbol bttv_write_gpio
[ 5037.532049] bt878: Unknown symbol bttv_gpio_enable
[ 5037.532528] dvb_bt8xx: Unknown symbol bt878_num
[ 5037.532564] dvb_bt8xx: Unknown symbol bttv_sub_unregister
[ 5037.532650] dvb_bt8xx: Unknown symbol bttv_write_gpio
[ 5037.532719] dvb_bt8xx: Unknown symbol bttv_sub_register
[ 5037.532807] dvb_bt8xx: Unknown symbol bttv_get_pcidev
[ 5037.532978] dvb_bt8xx: Unknown symbol bt878_start
[ 5037.533041] dvb_bt8xx: Unknown symbol bttv_gpio_enable
[ 5037.533144] dvb_bt8xx: Unknown symbol bt878_stop
[ 5037.533273] dvb_bt8xx: Unknown symbol bt878

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
