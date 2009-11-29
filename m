Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f215.google.com ([209.85.219.215]:50841 "EHLO
	mail-ew0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216AbZK2L4o (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Nov 2009 06:56:44 -0500
Received: by ewy7 with SMTP id 7so3374405ewy.28
        for <linux-media@vger.kernel.org>; Sun, 29 Nov 2009 03:56:50 -0800 (PST)
Date: Sun, 29 Nov 2009 11:55:56 +0000
From: Albert Gall <ss3vdr@gmail.com>
To: linux-media@vger.kernel.org
Subject: Skystar HD2 and s2-liplianin/mantis driver.
Message-ID: <20091129115555.GA14492@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="J/dobhs11T7y2rNN"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello list

I try to build latest s2-liplianin drivers but make shows severals 
warnings and module not load after build driver:

WARNING: "ir_input_keydown" [s2-liplianin/v4l/mantis.ko] undefined!
WARNING: "ir_codes_mantis_vp1041_table" [s2-liplianin/v4l/mantis.ko] undefined!
WARNING: "ir_input_nokey" [s2-liplianin/v4l/mantis.ko] undefined!
WARNING: "ir_input_init" [s2-liplianin/v4l/mantis.ko] undefined!
WARNING: "ir_codes_mantis_vp2040_table" [s2-liplianin/v4l/mantis.ko] undefined!
WARNING: "ir_codes_mantis_vp2033_table" [s2-liplianin/v4l/mantis.ko] undefined!

My kernel is 2.6.31.4.
The attached is full driver build log.

Any idea to fix this problem ?

--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="s2-liplianin-build.log"

/usr/local/src/s2-liplianin|status:0|jobs:0|# make -j 2                        
make -C /usr/local/src/s2-liplianin/v4l 
make[1]: se ingresa al directorio `/usr/local/src/s2-liplianin/v4l'
perl scripts/make_config_compat.pl /lib/modules/2.6.31.4/source ./.myconfig ./config-compat.h
creating symbolic links...
make -C firmware prep
make[2]: Entering directory `/usr/local/src/s2-liplianin/v4l/firmware'
make[2]: Leaving directory `/usr/local/src/s2-liplianin/v4l/firmware'
make -C firmware
make[2]: Entering directory `/usr/local/src/s2-liplianin/v4l/firmware'
  CC  ihex2fw
Generating vicam/firmware.fw
Generating dabusb/firmware.fw
Generating dabusb/bitstream.bin
Generating ttusb-budget/dspbootcode.bin
Generating cpia2/stv0672_vp4.bin
Generating av7110/bootcode.bin
make[2]: Leaving directory `/usr/local/src/s2-liplianin/v4l/firmware'
Kernel build directory is /lib/modules/2.6.31.4/build
make -C /lib/modules/2.6.31.4/build SUBDIRS=/usr/local/src/s2-liplianin/v4l  modules
make[2]: Entering directory `/usr/src/linux-2.6.31.4'
  CC [M]  /usr/local/src/s2-liplianin/v4l/tuner-xc2028.o
  CC [M]  /usr/local/src/s2-liplianin/v4l/tuner-simple.o
  CC [M]  /usr/local/src/s2-liplianin/v4l/tuner-types.o
  CC [M]  /usr/local/src/s2-liplianin/v4l/mt20xx.o
  CC [M]  /usr/local/src/s2-liplianin/v4l/tda8290.o
  CC [M]  /usr/local/src/s2-liplianin/v4l/tea5767.o
  CC [M]  /usr/local/src/s2-liplianin/v4l/tea5761.o
  CC [M]  /usr/local/src/s2-liplianin/v4l/tda9887.o
  CC [M]  /usr/local/src/s2-liplianin/v4l/xc5000.o
  CC [M]  /usr/local/src/s2-liplianin/v4l/mc44s803.o
  CC [M]  /usr/local/src/s2-liplianin/v4l/dvbdev.o
  CC [M]  /usr/local/src/s2-liplianin/v4l/dmxdev.o
  CC [M]  /usr/local/src/s2-liplianin/v4l/dvb_demux.o
  CC [M]  /usr/local/src/s2-liplianin/v4l/dvb_filter.o
  CC [M]  /usr/local/src/s2-liplianin/v4l/dvb_ca_en50221.o
  CC [M]  /usr/local/src/s2-liplianin/v4l/dvb_frontend.o
  CC [M]  /usr/local/src/s2-liplianin/v4l/dvb_net.o
  CC [M]  /usr/local/src/s2-liplianin/v4l/dvb_ringbuffer.o
  CC [M]  /usr/local/src/s2-liplianin/v4l/dvb_math.o
  CC [M]  /usr/local/src/s2-liplianin/v4l/mantis_core.o
  CC [M]  /usr/local/src/s2-liplianin/v4l/mantis_dma.o
  CC [M]  /usr/local/src/s2-liplianin/v4l/mantis_pci.o
  CC [M]  /usr/local/src/s2-liplianin/v4l/mantis_i2c.o
  CC [M]  /usr/local/src/s2-liplianin/v4l/mantis_dvb.o
  CC [M]  /usr/local/src/s2-liplianin/v4l/mantis_evm.o
  CC [M]  /usr/local/src/s2-liplianin/v4l/mantis_hif.o
  CC [M]  /usr/local/src/s2-liplianin/v4l/mantis_ca.o
  CC [M]  /usr/local/src/s2-liplianin/v4l/mantis_pcmcia.o
  CC [M]  /usr/local/src/s2-liplianin/v4l/mantis_vp1033.o
  CC [M]  /usr/local/src/s2-liplianin/v4l/mantis_vp1034.o
  CC [M]  /usr/local/src/s2-liplianin/v4l/mantis_vp1041.o
  CC [M]  /usr/local/src/s2-liplianin/v4l/mantis_vp2033.o
  CC [M]  /usr/local/src/s2-liplianin/v4l/mantis_vp2040.o
  CC [M]  /usr/local/src/s2-liplianin/v4l/mantis_vp3030.o
  CC [M]  /usr/local/src/s2-liplianin/v4l/mantis_rc.o
  CC [M]  /usr/local/src/s2-liplianin/v4l/dvb-pll.o
  CC [M]  /usr/local/src/s2-liplianin/v4l/stv0299.o
  CC [M]  /usr/local/src/s2-liplianin/v4l/zl10353.o
  CC [M]  /usr/local/src/s2-liplianin/v4l/mb86a16.o
  CC [M]  /usr/local/src/s2-liplianin/v4l/cu1216.o
/usr/local/src/s2-liplianin/v4l/cu1216.c:395: warning: 'cu1216_read_quality' defined but not used
  LD [M]  /usr/local/src/s2-liplianin/v4l/mantis.o
  LD [M]  /usr/local/src/s2-liplianin/v4l/dvb-core.o
/usr/local/src/s2-liplianin/v4l/mb86a16.c:1885: warning: initialization from incompatible pointer type
  Building modules, stage 2.
  MODPOST 17 modules
WARNING: "ir_input_keydown" [/usr/local/src/s2-liplianin/v4l/mantis.ko] undefined!
WARNING: "ir_codes_mantis_vp1041_table" [/usr/local/src/s2-liplianin/v4l/mantis.ko] undefined!
WARNING: "ir_input_nokey" [/usr/local/src/s2-liplianin/v4l/mantis.ko] undefined!
WARNING: "ir_input_init" [/usr/local/src/s2-liplianin/v4l/mantis.ko] undefined!
WARNING: "ir_codes_mantis_vp2040_table" [/usr/local/src/s2-liplianin/v4l/mantis.ko] undefined!
WARNING: "ir_codes_mantis_vp2033_table" [/usr/local/src/s2-liplianin/v4l/mantis.ko] undefined!
  CC      /usr/local/src/s2-liplianin/v4l/cu1216.mod.o
  CC      /usr/local/src/s2-liplianin/v4l/dvb-core.mod.o
  CC      /usr/local/src/s2-liplianin/v4l/dvb-pll.mod.o
  CC      /usr/local/src/s2-liplianin/v4l/mantis.mod.o
  CC      /usr/local/src/s2-liplianin/v4l/mb86a16.mod.o
  CC      /usr/local/src/s2-liplianin/v4l/mc44s803.mod.o
  CC      /usr/local/src/s2-liplianin/v4l/mt20xx.mod.o
  CC      /usr/local/src/s2-liplianin/v4l/stv0299.mod.o
  CC      /usr/local/src/s2-liplianin/v4l/tda8290.mod.o
  CC      /usr/local/src/s2-liplianin/v4l/tda9887.mod.o
  CC      /usr/local/src/s2-liplianin/v4l/tea5761.mod.o
  CC      /usr/local/src/s2-liplianin/v4l/tea5767.mod.o
  CC      /usr/local/src/s2-liplianin/v4l/tuner-simple.mod.o
  CC      /usr/local/src/s2-liplianin/v4l/tuner-types.mod.o
  CC      /usr/local/src/s2-liplianin/v4l/tuner-xc2028.mod.o
  CC      /usr/local/src/s2-liplianin/v4l/xc5000.mod.o
  CC      /usr/local/src/s2-liplianin/v4l/zl10353.mod.o
  LD [M]  /usr/local/src/s2-liplianin/v4l/cu1216.ko
  LD [M]  /usr/local/src/s2-liplianin/v4l/dvb-core.ko
  LD [M]  /usr/local/src/s2-liplianin/v4l/dvb-pll.ko
  LD [M]  /usr/local/src/s2-liplianin/v4l/mantis.ko
  LD [M]  /usr/local/src/s2-liplianin/v4l/mb86a16.ko
  LD [M]  /usr/local/src/s2-liplianin/v4l/mc44s803.ko
  LD [M]  /usr/local/src/s2-liplianin/v4l/mt20xx.ko
  LD [M]  /usr/local/src/s2-liplianin/v4l/stv0299.ko
  LD [M]  /usr/local/src/s2-liplianin/v4l/tda8290.ko
  LD [M]  /usr/local/src/s2-liplianin/v4l/tda9887.ko
  LD [M]  /usr/local/src/s2-liplianin/v4l/tea5761.ko
  LD [M]  /usr/local/src/s2-liplianin/v4l/tea5767.ko
  LD [M]  /usr/local/src/s2-liplianin/v4l/tuner-simple.ko
  LD [M]  /usr/local/src/s2-liplianin/v4l/tuner-types.ko
  LD [M]  /usr/local/src/s2-liplianin/v4l/tuner-xc2028.ko
  LD [M]  /usr/local/src/s2-liplianin/v4l/xc5000.ko
  LD [M]  /usr/local/src/s2-liplianin/v4l/zl10353.ko
make[2]: Leaving directory `/usr/src/linux-2.6.31.4'
./scripts/rmmod.pl check
found 17 modules
make[1]: se sale del directorio `/usr/local/src/s2-liplianin/v4l'
/usr/local/src/s2-liplianin|status:0|jobs:0|#

--J/dobhs11T7y2rNN--
