Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-ew0-f217.google.com ([209.85.219.217])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <ss3vdr@gmail.com>) id 1NEllt-00046N-Rg
	for linux-dvb@linuxtv.org; Sun, 29 Nov 2009 16:33:10 +0100
Received: by ewy9 with SMTP id 9so322377ewy.11
	for <linux-dvb@linuxtv.org>; Sun, 29 Nov 2009 07:32:36 -0800 (PST)
Date: Sun, 29 Nov 2009 15:31:48 +0000
From: Albert Gall <ss3vdr@gmail.com>
To: linux-dvb@linuxtv.org
Message-ID: <20091129153148.GA20727@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="UlVJffcvxoiEqYs2"
Content-Disposition: inline
Subject: [linux-dvb] Skystar HD2 and s2-liplianin/mantis driver
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--UlVJffcvxoiEqYs2
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

--UlVJffcvxoiEqYs2
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

--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--UlVJffcvxoiEqYs2--
