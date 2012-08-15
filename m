Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36202 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754942Ab2HONs0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Aug 2012 09:48:26 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q7FDmQKS012643
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 15 Aug 2012 09:48:26 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 10/12] [media] move i2c files into drivers/media/i2c
Date: Wed, 15 Aug 2012 10:48:18 -0300
Message-Id: <1345038500-28734-11-git-send-email-mchehab@redhat.com>
In-Reply-To: <1345038500-28734-1-git-send-email-mchehab@redhat.com>
References: <502AC079.50902@gmail.com>
 <1345038500-28734-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move ancillary I2C drivers into drivers/media/i2c, in order to
better organize them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/Kconfig                              |   9 +-
 drivers/media/Makefile                             |   2 +-
 drivers/media/i2c/Kconfig                          | 566 ++++++++++++++++++++
 drivers/media/i2c/Makefile                         |  63 +++
 drivers/media/{video => i2c}/adp1653.c             |   2 +-
 drivers/media/{video => i2c}/adv7170.c             |   0
 drivers/media/{video => i2c}/adv7175.c             |   0
 drivers/media/{video => i2c}/adv7180.c             |   0
 drivers/media/{video => i2c}/adv7183.c             |   0
 drivers/media/{video => i2c}/adv7183_regs.h        |   0
 drivers/media/{video => i2c}/adv7343.c             |   0
 drivers/media/{video => i2c}/adv7343_regs.h        |   0
 drivers/media/{video => i2c}/adv7393.c             |   0
 drivers/media/{video => i2c}/adv7393_regs.h        |   0
 drivers/media/{video => i2c}/ak881x.c              |   0
 drivers/media/{video => i2c}/aptina-pll.c          |   0
 drivers/media/{video => i2c}/aptina-pll.h          |   0
 drivers/media/{video => i2c}/as3645a.c             |   2 +-
 drivers/media/{video => i2c}/bt819.c               |   0
 drivers/media/{video => i2c}/bt856.c               |   0
 drivers/media/{video => i2c}/bt866.c               |   0
 drivers/media/{video => i2c}/btcx-risc.c           |   0
 drivers/media/{video => i2c}/btcx-risc.h           |   0
 drivers/media/{video => i2c}/cs5345.c              |   0
 drivers/media/{video => i2c}/cs53l32a.c            |   0
 drivers/media/{video => i2c}/cx2341x.c             |   0
 drivers/media/{video => i2c}/cx25840/Kconfig       |   0
 drivers/media/{video => i2c}/cx25840/Makefile      |   2 +-
 .../media/{video => i2c}/cx25840/cx25840-audio.c   |   0
 .../media/{video => i2c}/cx25840/cx25840-core.c    |   0
 .../media/{video => i2c}/cx25840/cx25840-core.h    |   0
 .../{video => i2c}/cx25840/cx25840-firmware.c      |   0
 drivers/media/{video => i2c}/cx25840/cx25840-ir.c  |   0
 drivers/media/{video => i2c}/cx25840/cx25840-vbi.c |   0
 drivers/media/{video => i2c}/ir-kbd-i2c.c          |   0
 drivers/media/{video => i2c}/ks0127.c              |   0
 drivers/media/{video => i2c}/ks0127.h              |   0
 drivers/media/{video => i2c}/m52790.c              |   0
 drivers/media/{video => i2c}/m5mols/Kconfig        |   0
 drivers/media/{video => i2c}/m5mols/Makefile       |   0
 drivers/media/{video => i2c}/m5mols/m5mols.h       |   0
 .../media/{video => i2c}/m5mols/m5mols_capture.c   |   0
 .../media/{video => i2c}/m5mols/m5mols_controls.c  |   0
 drivers/media/{video => i2c}/m5mols/m5mols_core.c  |   0
 drivers/media/{video => i2c}/m5mols/m5mols_reg.h   |   0
 drivers/media/{video => i2c}/msp3400-driver.c      |   0
 drivers/media/{video => i2c}/msp3400-driver.h      |   0
 drivers/media/{video => i2c}/msp3400-kthreads.c    |   0
 drivers/media/{video => i2c}/mt9m032.c             |   0
 drivers/media/{video => i2c}/mt9p031.c             |   0
 drivers/media/{video => i2c}/mt9t001.c             |   0
 drivers/media/{video => i2c}/mt9v011.c             |   0
 drivers/media/{video => i2c}/mt9v032.c             |   0
 drivers/media/{video => i2c}/noon010pc30.c         |   0
 drivers/media/{video => i2c}/ov7670.c              |   0
 drivers/media/{video => i2c}/s5k6aa.c              |   0
 drivers/media/{video => i2c}/saa6588.c             |   0
 drivers/media/{video => i2c}/saa7110.c             |   0
 drivers/media/{video => i2c}/saa7115.c             |   0
 drivers/media/{video => i2c}/saa711x_regs.h        |   0
 drivers/media/{video => i2c}/saa7127.c             |   0
 drivers/media/{video => i2c}/saa717x.c             |   0
 drivers/media/{video => i2c}/saa7185.c             |   0
 drivers/media/{video => i2c}/saa7191.c             |   0
 drivers/media/{video => i2c}/saa7191.h             |   0
 drivers/media/{video => i2c}/smiapp-pll.c          |   2 +-
 drivers/media/{video => i2c}/smiapp-pll.h          |   2 +-
 drivers/media/{video => i2c}/smiapp/Kconfig        |   0
 drivers/media/{video => i2c}/smiapp/Makefile       |   2 +-
 drivers/media/{video => i2c}/smiapp/smiapp-core.c  |   2 +-
 .../media/{video => i2c}/smiapp/smiapp-limits.c    |   2 +-
 .../media/{video => i2c}/smiapp/smiapp-limits.h    |   2 +-
 drivers/media/{video => i2c}/smiapp/smiapp-quirk.c |   2 +-
 drivers/media/{video => i2c}/smiapp/smiapp-quirk.h |   2 +-
 .../media/{video => i2c}/smiapp/smiapp-reg-defs.h  |   2 +-
 drivers/media/{video => i2c}/smiapp/smiapp-reg.h   |   2 +-
 drivers/media/{video => i2c}/smiapp/smiapp-regs.c  |   2 +-
 drivers/media/{video => i2c}/smiapp/smiapp-regs.h  |   0
 drivers/media/{video => i2c}/smiapp/smiapp.h       |   2 +-
 drivers/media/{video => i2c}/sr030pc30.c           |   0
 drivers/media/{video => i2c}/tcm825x.c             |   2 +-
 drivers/media/{video => i2c}/tcm825x.h             |   2 +-
 drivers/media/{video => i2c}/tda7432.c             |   0
 drivers/media/{video => i2c}/tda9840.c             |   0
 drivers/media/{video => i2c}/tea6415c.c            |   0
 drivers/media/{video => i2c}/tea6415c.h            |   0
 drivers/media/{video => i2c}/tea6420.c             |   0
 drivers/media/{video => i2c}/tea6420.h             |   0
 drivers/media/{video => i2c}/ths7303.c             |   0
 drivers/media/{video => i2c}/tlv320aic23b.c        |   0
 drivers/media/{video => i2c}/tvaudio.c             |   0
 drivers/media/{video => i2c}/tveeprom.c            |   0
 drivers/media/{video => i2c}/tvp514x.c             |   2 +-
 drivers/media/{video => i2c}/tvp514x_regs.h        |   2 +-
 drivers/media/{video => i2c}/tvp5150.c             |   0
 drivers/media/{video => i2c}/tvp5150_reg.h         |   0
 drivers/media/{video => i2c}/tvp7002.c             |   0
 drivers/media/{video => i2c}/tvp7002_reg.h         |   0
 drivers/media/{video => i2c}/upd64031a.c           |   0
 drivers/media/{video => i2c}/upd64083.c            |   0
 drivers/media/{video => i2c}/vp27smpx.c            |   0
 drivers/media/{video => i2c}/vpx3220.c             |   0
 drivers/media/{video => i2c}/vs6624.c              |   0
 drivers/media/{video => i2c}/vs6624_regs.h         |   0
 drivers/media/{video => i2c}/wm8739.c              |   0
 drivers/media/{video => i2c}/wm8775.c              |   0
 drivers/media/pci/bt8xx/Makefile                   |   2 +-
 drivers/media/pci/cx23885/Makefile                 |   2 +-
 drivers/media/pci/cx25821/Makefile                 |   2 +-
 drivers/media/pci/cx88/Makefile                    |   2 +-
 drivers/media/pci/ivtv/Makefile                    |   2 +-
 drivers/media/pci/saa7134/Makefile                 |   2 +-
 drivers/media/pci/saa7146/Makefile                 |   2 +-
 drivers/media/pci/saa7164/Makefile                 |   2 +-
 drivers/media/usb/cx231xx/Makefile                 |   2 +-
 drivers/media/usb/em28xx/Makefile                  |   2 +-
 drivers/media/usb/hdpvr/Makefile                   |   2 +-
 drivers/media/usb/pvrusb2/Makefile                 |   2 +-
 drivers/media/usb/stk1160/Makefile                 |   2 +-
 drivers/media/usb/tlg2300/Makefile                 |   2 +-
 drivers/media/usb/tm6000/Makefile                  |   2 +-
 drivers/media/usb/usbvision/Makefile               |   2 +-
 drivers/media/video/Kconfig                        | 579 +--------------------
 drivers/media/video/Makefile                       |  71 ---
 124 files changed, 671 insertions(+), 689 deletions(-)
 create mode 100644 drivers/media/i2c/Kconfig
 create mode 100644 drivers/media/i2c/Makefile
 rename drivers/media/{video => i2c}/adp1653.c (99%)
 rename drivers/media/{video => i2c}/adv7170.c (100%)
 rename drivers/media/{video => i2c}/adv7175.c (100%)
 rename drivers/media/{video => i2c}/adv7180.c (100%)
 rename drivers/media/{video => i2c}/adv7183.c (100%)
 rename drivers/media/{video => i2c}/adv7183_regs.h (100%)
 rename drivers/media/{video => i2c}/adv7343.c (100%)
 rename drivers/media/{video => i2c}/adv7343_regs.h (100%)
 rename drivers/media/{video => i2c}/adv7393.c (100%)
 rename drivers/media/{video => i2c}/adv7393_regs.h (100%)
 rename drivers/media/{video => i2c}/ak881x.c (100%)
 rename drivers/media/{video => i2c}/aptina-pll.c (100%)
 rename drivers/media/{video => i2c}/aptina-pll.h (100%)
 rename drivers/media/{video => i2c}/as3645a.c (99%)
 rename drivers/media/{video => i2c}/bt819.c (100%)
 rename drivers/media/{video => i2c}/bt856.c (100%)
 rename drivers/media/{video => i2c}/bt866.c (100%)
 rename drivers/media/{video => i2c}/btcx-risc.c (100%)
 rename drivers/media/{video => i2c}/btcx-risc.h (100%)
 rename drivers/media/{video => i2c}/cs5345.c (100%)
 rename drivers/media/{video => i2c}/cs53l32a.c (100%)
 rename drivers/media/{video => i2c}/cx2341x.c (100%)
 rename drivers/media/{video => i2c}/cx25840/Kconfig (100%)
 rename drivers/media/{video => i2c}/cx25840/Makefile (80%)
 rename drivers/media/{video => i2c}/cx25840/cx25840-audio.c (100%)
 rename drivers/media/{video => i2c}/cx25840/cx25840-core.c (100%)
 rename drivers/media/{video => i2c}/cx25840/cx25840-core.h (100%)
 rename drivers/media/{video => i2c}/cx25840/cx25840-firmware.c (100%)
 rename drivers/media/{video => i2c}/cx25840/cx25840-ir.c (100%)
 rename drivers/media/{video => i2c}/cx25840/cx25840-vbi.c (100%)
 rename drivers/media/{video => i2c}/ir-kbd-i2c.c (100%)
 rename drivers/media/{video => i2c}/ks0127.c (100%)
 rename drivers/media/{video => i2c}/ks0127.h (100%)
 rename drivers/media/{video => i2c}/m52790.c (100%)
 rename drivers/media/{video => i2c}/m5mols/Kconfig (100%)
 rename drivers/media/{video => i2c}/m5mols/Makefile (100%)
 rename drivers/media/{video => i2c}/m5mols/m5mols.h (100%)
 rename drivers/media/{video => i2c}/m5mols/m5mols_capture.c (100%)
 rename drivers/media/{video => i2c}/m5mols/m5mols_controls.c (100%)
 rename drivers/media/{video => i2c}/m5mols/m5mols_core.c (100%)
 rename drivers/media/{video => i2c}/m5mols/m5mols_reg.h (100%)
 rename drivers/media/{video => i2c}/msp3400-driver.c (100%)
 rename drivers/media/{video => i2c}/msp3400-driver.h (100%)
 rename drivers/media/{video => i2c}/msp3400-kthreads.c (100%)
 rename drivers/media/{video => i2c}/mt9m032.c (100%)
 rename drivers/media/{video => i2c}/mt9p031.c (100%)
 rename drivers/media/{video => i2c}/mt9t001.c (100%)
 rename drivers/media/{video => i2c}/mt9v011.c (100%)
 rename drivers/media/{video => i2c}/mt9v032.c (100%)
 rename drivers/media/{video => i2c}/noon010pc30.c (100%)
 rename drivers/media/{video => i2c}/ov7670.c (100%)
 rename drivers/media/{video => i2c}/s5k6aa.c (100%)
 rename drivers/media/{video => i2c}/saa6588.c (100%)
 rename drivers/media/{video => i2c}/saa7110.c (100%)
 rename drivers/media/{video => i2c}/saa7115.c (100%)
 rename drivers/media/{video => i2c}/saa711x_regs.h (100%)
 rename drivers/media/{video => i2c}/saa7127.c (100%)
 rename drivers/media/{video => i2c}/saa717x.c (100%)
 rename drivers/media/{video => i2c}/saa7185.c (100%)
 rename drivers/media/{video => i2c}/saa7191.c (100%)
 rename drivers/media/{video => i2c}/saa7191.h (100%)
 rename drivers/media/{video => i2c}/smiapp-pll.c (99%)
 rename drivers/media/{video => i2c}/smiapp-pll.h (98%)
 rename drivers/media/{video => i2c}/smiapp/Kconfig (100%)
 rename drivers/media/{video => i2c}/smiapp/Makefile (78%)
 rename drivers/media/{video => i2c}/smiapp/smiapp-core.c (99%)
 rename drivers/media/{video => i2c}/smiapp/smiapp-limits.c (99%)
 rename drivers/media/{video => i2c}/smiapp/smiapp-limits.h (99%)
 rename drivers/media/{video => i2c}/smiapp/smiapp-quirk.c (99%)
 rename drivers/media/{video => i2c}/smiapp/smiapp-quirk.h (98%)
 rename drivers/media/{video => i2c}/smiapp/smiapp-reg-defs.h (99%)
 rename drivers/media/{video => i2c}/smiapp/smiapp-reg.h (98%)
 rename drivers/media/{video => i2c}/smiapp/smiapp-regs.c (99%)
 rename drivers/media/{video => i2c}/smiapp/smiapp-regs.h (100%)
 rename drivers/media/{video => i2c}/smiapp/smiapp.h (99%)
 rename drivers/media/{video => i2c}/sr030pc30.c (100%)
 rename drivers/media/{video => i2c}/tcm825x.c (99%)
 rename drivers/media/{video => i2c}/tcm825x.h (99%)
 rename drivers/media/{video => i2c}/tda7432.c (100%)
 rename drivers/media/{video => i2c}/tda9840.c (100%)
 rename drivers/media/{video => i2c}/tea6415c.c (100%)
 rename drivers/media/{video => i2c}/tea6415c.h (100%)
 rename drivers/media/{video => i2c}/tea6420.c (100%)
 rename drivers/media/{video => i2c}/tea6420.h (100%)
 rename drivers/media/{video => i2c}/ths7303.c (100%)
 rename drivers/media/{video => i2c}/tlv320aic23b.c (100%)
 rename drivers/media/{video => i2c}/tvaudio.c (100%)
 rename drivers/media/{video => i2c}/tveeprom.c (100%)
 rename drivers/media/{video => i2c}/tvp514x.c (99%)
 rename drivers/media/{video => i2c}/tvp514x_regs.h (99%)
 rename drivers/media/{video => i2c}/tvp5150.c (100%)
 rename drivers/media/{video => i2c}/tvp5150_reg.h (100%)
 rename drivers/media/{video => i2c}/tvp7002.c (100%)
 rename drivers/media/{video => i2c}/tvp7002_reg.h (100%)
 rename drivers/media/{video => i2c}/upd64031a.c (100%)
 rename drivers/media/{video => i2c}/upd64083.c (100%)
 rename drivers/media/{video => i2c}/vp27smpx.c (100%)
 rename drivers/media/{video => i2c}/vpx3220.c (100%)
 rename drivers/media/{video => i2c}/vs6624.c (100%)
 rename drivers/media/{video => i2c}/vs6624_regs.h (100%)
 rename drivers/media/{video => i2c}/wm8739.c (100%)
 rename drivers/media/{video => i2c}/wm8775.c (100%)

diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index c9cdc61..26f3de5 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -151,18 +151,15 @@ source "drivers/media/rc/Kconfig"
 
 source "drivers/media/tuners/Kconfig"
 
+source "drivers/media/i2c/Kconfig"
+
 #
-# Video/Radio/Hybrid adapters
+# V4L platform/mem2mem drivers
 #
-
 source "drivers/media/video/Kconfig"
 
 source "drivers/media/radio/Kconfig"
 
-#
-# DVB adapters
-#
-
 source "drivers/media/pci/Kconfig"
 source "drivers/media/usb/Kconfig"
 source "drivers/media/mmc/Kconfig"
diff --git a/drivers/media/Makefile b/drivers/media/Makefile
index 360c44d..e1be196 100644
--- a/drivers/media/Makefile
+++ b/drivers/media/Makefile
@@ -9,7 +9,7 @@ ifeq ($(CONFIG_MEDIA_CONTROLLER),y)
 endif
 
 obj-y += tuners/ common/ rc/ video/
-obj-y += pci/ usb/ mmc/ firewire/ parport/
+obj-y += i2c/ pci/ usb/ mmc/ firewire/ parport/
 
 obj-$(CONFIG_VIDEO_DEV) += radio/ v4l2-core/
 obj-$(CONFIG_DVB_CORE)  += dvb-core/ dvb-frontends/
diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
new file mode 100644
index 0000000..1c677f5
--- /dev/null
+++ b/drivers/media/i2c/Kconfig
@@ -0,0 +1,566 @@
+#
+# Generic video config states
+#
+
+config VIDEO_BTCX
+	depends on PCI
+	tristate
+
+config VIDEO_TVEEPROM
+	tristate
+	depends on I2C
+
+#
+# Multimedia Video device configuration
+#
+
+if VIDEO_V4L2
+
+config VIDEO_HELPER_CHIPS_AUTO
+	bool "Autoselect pertinent encoders/decoders and other helper chips"
+	default y if !EXPERT
+	---help---
+	  Most video cards may require additional modules to encode or
+	  decode audio/video standards. This option will autoselect
+	  all pertinent modules to each selected video module.
+
+	  Unselect this only if you know exactly what you are doing, since
+	  it may break support on some boards.
+
+	  In doubt, say Y.
+
+config VIDEO_IR_I2C
+	tristate "I2C module for IR" if !VIDEO_HELPER_CHIPS_AUTO
+	depends on I2C && RC_CORE
+	default y
+	---help---
+	  Most boards have an IR chip directly connected via GPIO. However,
+	  some video boards have the IR connected via I2C bus.
+
+	  If your board doesn't have an I2C IR chip, you may disable this
+	  option.
+
+	  In doubt, say Y.
+
+#
+# Encoder / Decoder module configuration
+#
+
+menu "Encoders, decoders, sensors and other helper chips"
+	visible if !VIDEO_HELPER_CHIPS_AUTO
+
+comment "Audio decoders, processors and mixers"
+
+config VIDEO_TVAUDIO
+	tristate "Simple audio decoder chips"
+	depends on VIDEO_V4L2 && I2C
+	---help---
+	  Support for several audio decoder chips found on some bt8xx boards:
+	  Philips: tda9840, tda9873h, tda9874h/a, tda9850, tda985x, tea6300,
+		   tea6320, tea6420, tda8425, ta8874z.
+	  Microchip: pic16c54 based design on ProVideo PV951 board.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called tvaudio.
+
+config VIDEO_TDA7432
+	tristate "Philips TDA7432 audio processor"
+	depends on VIDEO_V4L2 && I2C
+	---help---
+	  Support for tda7432 audio decoder chip found on some bt8xx boards.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called tda7432.
+
+config VIDEO_TDA9840
+	tristate "Philips TDA9840 audio processor"
+	depends on I2C
+	---help---
+	  Support for tda9840 audio decoder chip found on some Zoran boards.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called tda9840.
+
+config VIDEO_TEA6415C
+	tristate "Philips TEA6415C audio processor"
+	depends on I2C
+	---help---
+	  Support for tea6415c audio decoder chip found on some bt8xx boards.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called tea6415c.
+
+config VIDEO_TEA6420
+	tristate "Philips TEA6420 audio processor"
+	depends on I2C
+	---help---
+	  Support for tea6420 audio decoder chip found on some bt8xx boards.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called tea6420.
+
+config VIDEO_MSP3400
+	tristate "Micronas MSP34xx audio decoders"
+	depends on VIDEO_V4L2 && I2C
+	---help---
+	  Support for the Micronas MSP34xx series of audio decoders.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called msp3400.
+
+config VIDEO_CS5345
+	tristate "Cirrus Logic CS5345 audio ADC"
+	depends on VIDEO_V4L2 && I2C
+	---help---
+	  Support for the Cirrus Logic CS5345 24-bit, 192 kHz
+	  stereo A/D converter.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called cs5345.
+
+config VIDEO_CS53L32A
+	tristate "Cirrus Logic CS53L32A audio ADC"
+	depends on VIDEO_V4L2 && I2C
+	---help---
+	  Support for the Cirrus Logic CS53L32A low voltage
+	  stereo A/D converter.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called cs53l32a.
+
+config VIDEO_TLV320AIC23B
+	tristate "Texas Instruments TLV320AIC23B audio codec"
+	depends on VIDEO_V4L2 && I2C && EXPERIMENTAL
+	---help---
+	  Support for the Texas Instruments TLV320AIC23B audio codec.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called tlv320aic23b.
+
+config VIDEO_WM8775
+	tristate "Wolfson Microelectronics WM8775 audio ADC with input mixer"
+	depends on VIDEO_V4L2 && I2C
+	---help---
+	  Support for the Wolfson Microelectronics WM8775 high
+	  performance stereo A/D Converter with a 4 channel input mixer.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called wm8775.
+
+config VIDEO_WM8739
+	tristate "Wolfson Microelectronics WM8739 stereo audio ADC"
+	depends on VIDEO_V4L2 && I2C
+	---help---
+	  Support for the Wolfson Microelectronics WM8739
+	  stereo A/D Converter.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called wm8739.
+
+config VIDEO_VP27SMPX
+	tristate "Panasonic VP27s internal MPX"
+	depends on VIDEO_V4L2 && I2C
+	---help---
+	  Support for the internal MPX of the Panasonic VP27s tuner.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called vp27smpx.
+
+comment "RDS decoders"
+
+config VIDEO_SAA6588
+	tristate "SAA6588 Radio Chip RDS decoder support"
+	depends on VIDEO_V4L2 && I2C
+
+	help
+	  Support for this Radio Data System (RDS) decoder. This allows
+	  seeing radio station identification transmitted using this
+	  standard.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called saa6588.
+
+comment "Video decoders"
+
+config VIDEO_ADV7180
+	tristate "Analog Devices ADV7180 decoder"
+	depends on VIDEO_V4L2 && I2C
+	---help---
+	  Support for the Analog Devices ADV7180 video decoder.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called adv7180.
+
+config VIDEO_ADV7183
+	tristate "Analog Devices ADV7183 decoder"
+	depends on VIDEO_V4L2 && I2C
+	---help---
+	  V4l2 subdevice driver for the Analog Devices
+	  ADV7183 video decoder.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called adv7183.
+
+config VIDEO_BT819
+	tristate "BT819A VideoStream decoder"
+	depends on VIDEO_V4L2 && I2C
+	---help---
+	  Support for BT819A video decoder.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called bt819.
+
+config VIDEO_BT856
+	tristate "BT856 VideoStream decoder"
+	depends on VIDEO_V4L2 && I2C
+	---help---
+	  Support for BT856 video decoder.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called bt856.
+
+config VIDEO_BT866
+	tristate "BT866 VideoStream decoder"
+	depends on VIDEO_V4L2 && I2C
+	---help---
+	  Support for BT866 video decoder.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called bt866.
+
+config VIDEO_KS0127
+	tristate "KS0127 video decoder"
+	depends on VIDEO_V4L2 && I2C
+	---help---
+	  Support for KS0127 video decoder.
+
+	  This chip is used on AverMedia AVS6EYES Zoran-based MJPEG
+	  cards.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called ks0127.
+
+config VIDEO_SAA7110
+	tristate "Philips SAA7110 video decoder"
+	depends on VIDEO_V4L2 && I2C
+	---help---
+	  Support for the Philips SAA7110 video decoders.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called saa7110.
+
+config VIDEO_SAA711X
+	tristate "Philips SAA7111/3/4/5 video decoders"
+	depends on VIDEO_V4L2 && I2C
+	---help---
+	  Support for the Philips SAA7111/3/4/5 video decoders.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called saa7115.
+
+config VIDEO_SAA7191
+	tristate "Philips SAA7191 video decoder"
+	depends on VIDEO_V4L2 && I2C
+	---help---
+	  Support for the Philips SAA7191 video decoder.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called saa7191.
+
+config VIDEO_TVP514X
+	tristate "Texas Instruments TVP514x video decoder"
+	depends on VIDEO_V4L2 && I2C
+	---help---
+	  This is a Video4Linux2 sensor-level driver for the TI TVP5146/47
+	  decoder. It is currently working with the TI OMAP3 camera
+	  controller.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called tvp514x.
+
+config VIDEO_TVP5150
+	tristate "Texas Instruments TVP5150 video decoder"
+	depends on VIDEO_V4L2 && I2C
+	---help---
+	  Support for the Texas Instruments TVP5150 video decoder.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called tvp5150.
+
+config VIDEO_TVP7002
+	tristate "Texas Instruments TVP7002 video decoder"
+	depends on VIDEO_V4L2 && I2C
+	---help---
+	  Support for the Texas Instruments TVP7002 video decoder.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called tvp7002.
+
+config VIDEO_VPX3220
+	tristate "vpx3220a, vpx3216b & vpx3214c video decoders"
+	depends on VIDEO_V4L2 && I2C
+	---help---
+	  Support for VPX322x video decoders.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called vpx3220.
+
+comment "Video and audio decoders"
+
+config VIDEO_SAA717X
+	tristate "Philips SAA7171/3/4 audio/video decoders"
+	depends on VIDEO_V4L2 && I2C
+	---help---
+	  Support for the Philips SAA7171/3/4 audio/video decoders.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called saa717x.
+
+source "drivers/media/i2c/cx25840/Kconfig"
+
+comment "MPEG video encoders"
+
+config VIDEO_CX2341X
+	tristate "Conexant CX2341x MPEG encoders"
+	depends on VIDEO_V4L2 && VIDEO_V4L2_COMMON
+	---help---
+	  Support for the Conexant CX23416 MPEG encoders
+	  and CX23415 MPEG encoder/decoders.
+
+	  This module currently supports the encoding functions only.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called cx2341x.
+
+comment "Video encoders"
+
+config VIDEO_SAA7127
+	tristate "Philips SAA7127/9 digital video encoders"
+	depends on VIDEO_V4L2 && I2C
+	---help---
+	  Support for the Philips SAA7127/9 digital video encoders.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called saa7127.
+
+config VIDEO_SAA7185
+	tristate "Philips SAA7185 video encoder"
+	depends on VIDEO_V4L2 && I2C
+	---help---
+	  Support for the Philips SAA7185 video encoder.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called saa7185.
+
+config VIDEO_ADV7170
+	tristate "Analog Devices ADV7170 video encoder"
+	depends on VIDEO_V4L2 && I2C
+	---help---
+	  Support for the Analog Devices ADV7170 video encoder driver
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called adv7170.
+
+config VIDEO_ADV7175
+	tristate "Analog Devices ADV7175 video encoder"
+	depends on VIDEO_V4L2 && I2C
+	---help---
+	  Support for the Analog Devices ADV7175 video encoder driver
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called adv7175.
+
+config VIDEO_ADV7343
+	tristate "ADV7343 video encoder"
+	depends on I2C
+	help
+	  Support for Analog Devices I2C bus based ADV7343 encoder.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called adv7343.
+
+config VIDEO_ADV7393
+	tristate "ADV7393 video encoder"
+	depends on I2C
+	help
+	  Support for Analog Devices I2C bus based ADV7393 encoder.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called adv7393.
+
+config VIDEO_AK881X
+	tristate "AK8813/AK8814 video encoders"
+	depends on I2C
+	help
+	  Video output driver for AKM AK8813 and AK8814 TV encoders
+
+comment "Camera sensor devices"
+
+config VIDEO_APTINA_PLL
+	tristate
+
+config VIDEO_SMIAPP_PLL
+	tristate
+
+config VIDEO_OV7670
+	tristate "OmniVision OV7670 sensor support"
+	depends on I2C && VIDEO_V4L2
+	depends on MEDIA_CAMERA_SUPPORT
+	---help---
+	  This is a Video4Linux2 sensor-level driver for the OmniVision
+	  OV7670 VGA camera.  It currently only works with the M88ALP01
+	  controller.
+
+config VIDEO_VS6624
+	tristate "ST VS6624 sensor support"
+	depends on VIDEO_V4L2 && I2C
+	depends on MEDIA_CAMERA_SUPPORT
+	---help---
+	  This is a Video4Linux2 sensor-level driver for the ST VS6624
+	  camera.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called vs6624.
+
+config VIDEO_MT9M032
+	tristate "MT9M032 camera sensor support"
+	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
+	depends on MEDIA_CAMERA_SUPPORT
+	select VIDEO_APTINA_PLL
+	---help---
+	  This driver supports MT9M032 camera sensors from Aptina, monochrome
+	  models only.
+
+config VIDEO_MT9P031
+	tristate "Aptina MT9P031 support"
+	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
+	depends on MEDIA_CAMERA_SUPPORT
+	select VIDEO_APTINA_PLL
+	---help---
+	  This is a Video4Linux2 sensor-level driver for the Aptina
+	  (Micron) mt9p031 5 Mpixel camera.
+
+config VIDEO_MT9T001
+	tristate "Aptina MT9T001 support"
+	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
+	depends on MEDIA_CAMERA_SUPPORT
+	---help---
+	  This is a Video4Linux2 sensor-level driver for the Aptina
+	  (Micron) mt0t001 3 Mpixel camera.
+
+config VIDEO_MT9V011
+	tristate "Micron mt9v011 sensor support"
+	depends on I2C && VIDEO_V4L2
+	depends on MEDIA_CAMERA_SUPPORT
+	---help---
+	  This is a Video4Linux2 sensor-level driver for the Micron
+	  mt0v011 1.3 Mpixel camera.  It currently only works with the
+	  em28xx driver.
+
+config VIDEO_MT9V032
+	tristate "Micron MT9V032 sensor support"
+	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
+	depends on MEDIA_CAMERA_SUPPORT
+	---help---
+	  This is a Video4Linux2 sensor-level driver for the Micron
+	  MT9V032 752x480 CMOS sensor.
+
+config VIDEO_TCM825X
+	tristate "TCM825x camera sensor support"
+	depends on I2C && VIDEO_V4L2
+	depends on MEDIA_CAMERA_SUPPORT
+	---help---
+	  This is a driver for the Toshiba TCM825x VGA camera sensor.
+	  It is used for example in Nokia N800.
+
+config VIDEO_SR030PC30
+	tristate "Siliconfile SR030PC30 sensor support"
+	depends on I2C && VIDEO_V4L2
+	depends on MEDIA_CAMERA_SUPPORT
+	---help---
+	  This driver supports SR030PC30 VGA camera from Siliconfile
+
+config VIDEO_NOON010PC30
+	tristate "Siliconfile NOON010PC30 sensor support"
+	depends on I2C && VIDEO_V4L2 && EXPERIMENTAL && VIDEO_V4L2_SUBDEV_API
+	depends on MEDIA_CAMERA_SUPPORT
+	---help---
+	  This driver supports NOON010PC30 CIF camera from Siliconfile
+
+source "drivers/media/i2c/m5mols/Kconfig"
+
+config VIDEO_S5K6AA
+	tristate "Samsung S5K6AAFX sensor support"
+	depends on MEDIA_CAMERA_SUPPORT
+	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
+	---help---
+	  This is a V4L2 sensor-level driver for Samsung S5K6AA(FX) 1.3M
+	  camera sensor with an embedded SoC image signal processor.
+
+source "drivers/media/i2c/smiapp/Kconfig"
+
+comment "Flash devices"
+
+config VIDEO_ADP1653
+	tristate "ADP1653 flash support"
+	depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
+	depends on MEDIA_CAMERA_SUPPORT
+	---help---
+	  This is a driver for the ADP1653 flash controller. It is used for
+	  example in Nokia N900.
+
+config VIDEO_AS3645A
+	tristate "AS3645A flash driver support"
+	depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
+	depends on MEDIA_CAMERA_SUPPORT
+	---help---
+	  This is a driver for the AS3645A and LM3555 flash controllers. It has
+	  build in control for flash, torch and indicator LEDs.
+
+comment "Video improvement chips"
+
+config VIDEO_UPD64031A
+	tristate "NEC Electronics uPD64031A Ghost Reduction"
+	depends on VIDEO_V4L2 && I2C
+	---help---
+	  Support for the NEC Electronics uPD64031A Ghost Reduction
+	  video chip. It is most often found in NTSC TV cards made for
+	  Japan and is used to reduce the 'ghosting' effect that can
+	  be present in analog TV broadcasts.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called upd64031a.
+
+config VIDEO_UPD64083
+	tristate "NEC Electronics uPD64083 3-Dimensional Y/C separation"
+	depends on VIDEO_V4L2 && I2C
+	---help---
+	  Support for the NEC Electronics uPD64083 3-Dimensional Y/C
+	  separation video chip. It is used to improve the quality of
+	  the colors of a composite signal.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called upd64083.
+
+comment "Miscelaneous helper chips"
+
+config VIDEO_THS7303
+	tristate "THS7303 Video Amplifier"
+	depends on I2C
+	help
+	  Support for TI THS7303 video amplifier
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called ths7303.
+
+config VIDEO_M52790
+	tristate "Mitsubishi M52790 A/V switch"
+	depends on VIDEO_V4L2 && I2C
+	---help---
+	 Support for the Mitsubishi M52790 A/V switch.
+
+	 To compile this driver as a module, choose M here: the
+	 module will be called m52790.
+
+endmenu
+endif
diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
new file mode 100644
index 0000000..93e8c14
--- /dev/null
+++ b/drivers/media/i2c/Makefile
@@ -0,0 +1,63 @@
+msp3400-objs	:=	msp3400-driver.o msp3400-kthreads.o
+obj-$(CONFIG_VIDEO_MSP3400) += msp3400.o
+
+obj-$(CONFIG_VIDEO_SMIAPP)	+= smiapp/
+obj-$(CONFIG_VIDEO_CX25840) += cx25840/
+obj-$(CONFIG_VIDEO_M5MOLS)	+= m5mols/
+
+obj-$(CONFIG_VIDEO_APTINA_PLL) += aptina-pll.o
+obj-$(CONFIG_VIDEO_TVAUDIO) += tvaudio.o
+obj-$(CONFIG_VIDEO_TDA7432) += tda7432.o
+obj-$(CONFIG_VIDEO_SAA6588) += saa6588.o
+obj-$(CONFIG_VIDEO_TDA9840) += tda9840.o
+obj-$(CONFIG_VIDEO_TEA6415C) += tea6415c.o
+obj-$(CONFIG_VIDEO_TEA6420) += tea6420.o
+obj-$(CONFIG_VIDEO_SAA7110) += saa7110.o
+obj-$(CONFIG_VIDEO_SAA711X) += saa7115.o
+obj-$(CONFIG_VIDEO_SAA717X) += saa717x.o
+obj-$(CONFIG_VIDEO_SAA7127) += saa7127.o
+obj-$(CONFIG_VIDEO_SAA7185) += saa7185.o
+obj-$(CONFIG_VIDEO_SAA7191) += saa7191.o
+obj-$(CONFIG_VIDEO_ADV7170) += adv7170.o
+obj-$(CONFIG_VIDEO_ADV7175) += adv7175.o
+obj-$(CONFIG_VIDEO_ADV7180) += adv7180.o
+obj-$(CONFIG_VIDEO_ADV7183) += adv7183.o
+obj-$(CONFIG_VIDEO_ADV7343) += adv7343.o
+obj-$(CONFIG_VIDEO_ADV7393) += adv7393.o
+obj-$(CONFIG_VIDEO_VPX3220) += vpx3220.o
+obj-$(CONFIG_VIDEO_VS6624)  += vs6624.o
+obj-$(CONFIG_VIDEO_BT819) += bt819.o
+obj-$(CONFIG_VIDEO_BT856) += bt856.o
+obj-$(CONFIG_VIDEO_BT866) += bt866.o
+obj-$(CONFIG_VIDEO_KS0127) += ks0127.o
+obj-$(CONFIG_VIDEO_THS7303) += ths7303.o
+obj-$(CONFIG_VIDEO_TVP5150) += tvp5150.o
+obj-$(CONFIG_VIDEO_TVP514X) += tvp514x.o
+obj-$(CONFIG_VIDEO_TVP7002) += tvp7002.o
+obj-$(CONFIG_VIDEO_CS5345) += cs5345.o
+obj-$(CONFIG_VIDEO_CS53L32A) += cs53l32a.o
+obj-$(CONFIG_VIDEO_M52790) += m52790.o
+obj-$(CONFIG_VIDEO_TLV320AIC23B) += tlv320aic23b.o
+obj-$(CONFIG_VIDEO_WM8775) += wm8775.o
+obj-$(CONFIG_VIDEO_WM8739) += wm8739.o
+obj-$(CONFIG_VIDEO_VP27SMPX) += vp27smpx.o
+obj-$(CONFIG_VIDEO_UPD64031A) += upd64031a.o
+obj-$(CONFIG_VIDEO_UPD64083) += upd64083.o
+obj-$(CONFIG_VIDEO_OV7670) 	+= ov7670.o
+obj-$(CONFIG_VIDEO_TCM825X) += tcm825x.o
+obj-$(CONFIG_VIDEO_TVEEPROM) += tveeprom.o
+obj-$(CONFIG_VIDEO_MT9M032) += mt9m032.o
+obj-$(CONFIG_VIDEO_MT9P031) += mt9p031.o
+obj-$(CONFIG_VIDEO_MT9T001) += mt9t001.o
+obj-$(CONFIG_VIDEO_MT9V011) += mt9v011.o
+obj-$(CONFIG_VIDEO_MT9V032) += mt9v032.o
+obj-$(CONFIG_VIDEO_SR030PC30)	+= sr030pc30.o
+obj-$(CONFIG_VIDEO_NOON010PC30)	+= noon010pc30.o
+obj-$(CONFIG_VIDEO_S5K6AA)	+= s5k6aa.o
+obj-$(CONFIG_VIDEO_ADP1653)	+= adp1653.o
+obj-$(CONFIG_VIDEO_AS3645A)	+= as3645a.o
+obj-$(CONFIG_VIDEO_SMIAPP_PLL)	+= smiapp-pll.o
+obj-$(CONFIG_VIDEO_BTCX)  += btcx-risc.o
+obj-$(CONFIG_VIDEO_CX2341X) += cx2341x.o
+obj-$(CONFIG_VIDEO_AK881X)		+= ak881x.o
+obj-$(CONFIG_VIDEO_IR_I2C)  += ir-kbd-i2c.o
diff --git a/drivers/media/video/adp1653.c b/drivers/media/i2c/adp1653.c
similarity index 99%
rename from drivers/media/video/adp1653.c
rename to drivers/media/i2c/adp1653.c
index 57e8709..18a38b3 100644
--- a/drivers/media/video/adp1653.c
+++ b/drivers/media/i2c/adp1653.c
@@ -1,5 +1,5 @@
 /*
- * drivers/media/video/adp1653.c
+ * drivers/media/i2c/adp1653.c
  *
  * Copyright (C) 2008--2011 Nokia Corporation
  *
diff --git a/drivers/media/video/adv7170.c b/drivers/media/i2c/adv7170.c
similarity index 100%
rename from drivers/media/video/adv7170.c
rename to drivers/media/i2c/adv7170.c
diff --git a/drivers/media/video/adv7175.c b/drivers/media/i2c/adv7175.c
similarity index 100%
rename from drivers/media/video/adv7175.c
rename to drivers/media/i2c/adv7175.c
diff --git a/drivers/media/video/adv7180.c b/drivers/media/i2c/adv7180.c
similarity index 100%
rename from drivers/media/video/adv7180.c
rename to drivers/media/i2c/adv7180.c
diff --git a/drivers/media/video/adv7183.c b/drivers/media/i2c/adv7183.c
similarity index 100%
rename from drivers/media/video/adv7183.c
rename to drivers/media/i2c/adv7183.c
diff --git a/drivers/media/video/adv7183_regs.h b/drivers/media/i2c/adv7183_regs.h
similarity index 100%
rename from drivers/media/video/adv7183_regs.h
rename to drivers/media/i2c/adv7183_regs.h
diff --git a/drivers/media/video/adv7343.c b/drivers/media/i2c/adv7343.c
similarity index 100%
rename from drivers/media/video/adv7343.c
rename to drivers/media/i2c/adv7343.c
diff --git a/drivers/media/video/adv7343_regs.h b/drivers/media/i2c/adv7343_regs.h
similarity index 100%
rename from drivers/media/video/adv7343_regs.h
rename to drivers/media/i2c/adv7343_regs.h
diff --git a/drivers/media/video/adv7393.c b/drivers/media/i2c/adv7393.c
similarity index 100%
rename from drivers/media/video/adv7393.c
rename to drivers/media/i2c/adv7393.c
diff --git a/drivers/media/video/adv7393_regs.h b/drivers/media/i2c/adv7393_regs.h
similarity index 100%
rename from drivers/media/video/adv7393_regs.h
rename to drivers/media/i2c/adv7393_regs.h
diff --git a/drivers/media/video/ak881x.c b/drivers/media/i2c/ak881x.c
similarity index 100%
rename from drivers/media/video/ak881x.c
rename to drivers/media/i2c/ak881x.c
diff --git a/drivers/media/video/aptina-pll.c b/drivers/media/i2c/aptina-pll.c
similarity index 100%
rename from drivers/media/video/aptina-pll.c
rename to drivers/media/i2c/aptina-pll.c
diff --git a/drivers/media/video/aptina-pll.h b/drivers/media/i2c/aptina-pll.h
similarity index 100%
rename from drivers/media/video/aptina-pll.h
rename to drivers/media/i2c/aptina-pll.h
diff --git a/drivers/media/video/as3645a.c b/drivers/media/i2c/as3645a.c
similarity index 99%
rename from drivers/media/video/as3645a.c
rename to drivers/media/i2c/as3645a.c
index c4b0357..3bfdbf9 100644
--- a/drivers/media/video/as3645a.c
+++ b/drivers/media/i2c/as3645a.c
@@ -1,5 +1,5 @@
 /*
- * drivers/media/video/as3645a.c - AS3645A and LM3555 flash controllers driver
+ * drivers/media/i2c/as3645a.c - AS3645A and LM3555 flash controllers driver
  *
  * Copyright (C) 2008-2011 Nokia Corporation
  * Copyright (c) 2011, Intel Corporation.
diff --git a/drivers/media/video/bt819.c b/drivers/media/i2c/bt819.c
similarity index 100%
rename from drivers/media/video/bt819.c
rename to drivers/media/i2c/bt819.c
diff --git a/drivers/media/video/bt856.c b/drivers/media/i2c/bt856.c
similarity index 100%
rename from drivers/media/video/bt856.c
rename to drivers/media/i2c/bt856.c
diff --git a/drivers/media/video/bt866.c b/drivers/media/i2c/bt866.c
similarity index 100%
rename from drivers/media/video/bt866.c
rename to drivers/media/i2c/bt866.c
diff --git a/drivers/media/video/btcx-risc.c b/drivers/media/i2c/btcx-risc.c
similarity index 100%
rename from drivers/media/video/btcx-risc.c
rename to drivers/media/i2c/btcx-risc.c
diff --git a/drivers/media/video/btcx-risc.h b/drivers/media/i2c/btcx-risc.h
similarity index 100%
rename from drivers/media/video/btcx-risc.h
rename to drivers/media/i2c/btcx-risc.h
diff --git a/drivers/media/video/cs5345.c b/drivers/media/i2c/cs5345.c
similarity index 100%
rename from drivers/media/video/cs5345.c
rename to drivers/media/i2c/cs5345.c
diff --git a/drivers/media/video/cs53l32a.c b/drivers/media/i2c/cs53l32a.c
similarity index 100%
rename from drivers/media/video/cs53l32a.c
rename to drivers/media/i2c/cs53l32a.c
diff --git a/drivers/media/video/cx2341x.c b/drivers/media/i2c/cx2341x.c
similarity index 100%
rename from drivers/media/video/cx2341x.c
rename to drivers/media/i2c/cx2341x.c
diff --git a/drivers/media/video/cx25840/Kconfig b/drivers/media/i2c/cx25840/Kconfig
similarity index 100%
rename from drivers/media/video/cx25840/Kconfig
rename to drivers/media/i2c/cx25840/Kconfig
diff --git a/drivers/media/video/cx25840/Makefile b/drivers/media/i2c/cx25840/Makefile
similarity index 80%
rename from drivers/media/video/cx25840/Makefile
rename to drivers/media/i2c/cx25840/Makefile
index dc40dde..898eb13 100644
--- a/drivers/media/video/cx25840/Makefile
+++ b/drivers/media/i2c/cx25840/Makefile
@@ -3,4 +3,4 @@ cx25840-objs    := cx25840-core.o cx25840-audio.o cx25840-firmware.o \
 
 obj-$(CONFIG_VIDEO_CX25840) += cx25840.o
 
-ccflags-y += -Idrivers/media/video
+ccflags-y += -Idrivers/media/i2c
diff --git a/drivers/media/video/cx25840/cx25840-audio.c b/drivers/media/i2c/cx25840/cx25840-audio.c
similarity index 100%
rename from drivers/media/video/cx25840/cx25840-audio.c
rename to drivers/media/i2c/cx25840/cx25840-audio.c
diff --git a/drivers/media/video/cx25840/cx25840-core.c b/drivers/media/i2c/cx25840/cx25840-core.c
similarity index 100%
rename from drivers/media/video/cx25840/cx25840-core.c
rename to drivers/media/i2c/cx25840/cx25840-core.c
diff --git a/drivers/media/video/cx25840/cx25840-core.h b/drivers/media/i2c/cx25840/cx25840-core.h
similarity index 100%
rename from drivers/media/video/cx25840/cx25840-core.h
rename to drivers/media/i2c/cx25840/cx25840-core.h
diff --git a/drivers/media/video/cx25840/cx25840-firmware.c b/drivers/media/i2c/cx25840/cx25840-firmware.c
similarity index 100%
rename from drivers/media/video/cx25840/cx25840-firmware.c
rename to drivers/media/i2c/cx25840/cx25840-firmware.c
diff --git a/drivers/media/video/cx25840/cx25840-ir.c b/drivers/media/i2c/cx25840/cx25840-ir.c
similarity index 100%
rename from drivers/media/video/cx25840/cx25840-ir.c
rename to drivers/media/i2c/cx25840/cx25840-ir.c
diff --git a/drivers/media/video/cx25840/cx25840-vbi.c b/drivers/media/i2c/cx25840/cx25840-vbi.c
similarity index 100%
rename from drivers/media/video/cx25840/cx25840-vbi.c
rename to drivers/media/i2c/cx25840/cx25840-vbi.c
diff --git a/drivers/media/video/ir-kbd-i2c.c b/drivers/media/i2c/ir-kbd-i2c.c
similarity index 100%
rename from drivers/media/video/ir-kbd-i2c.c
rename to drivers/media/i2c/ir-kbd-i2c.c
diff --git a/drivers/media/video/ks0127.c b/drivers/media/i2c/ks0127.c
similarity index 100%
rename from drivers/media/video/ks0127.c
rename to drivers/media/i2c/ks0127.c
diff --git a/drivers/media/video/ks0127.h b/drivers/media/i2c/ks0127.h
similarity index 100%
rename from drivers/media/video/ks0127.h
rename to drivers/media/i2c/ks0127.h
diff --git a/drivers/media/video/m52790.c b/drivers/media/i2c/m52790.c
similarity index 100%
rename from drivers/media/video/m52790.c
rename to drivers/media/i2c/m52790.c
diff --git a/drivers/media/video/m5mols/Kconfig b/drivers/media/i2c/m5mols/Kconfig
similarity index 100%
rename from drivers/media/video/m5mols/Kconfig
rename to drivers/media/i2c/m5mols/Kconfig
diff --git a/drivers/media/video/m5mols/Makefile b/drivers/media/i2c/m5mols/Makefile
similarity index 100%
rename from drivers/media/video/m5mols/Makefile
rename to drivers/media/i2c/m5mols/Makefile
diff --git a/drivers/media/video/m5mols/m5mols.h b/drivers/media/i2c/m5mols/m5mols.h
similarity index 100%
rename from drivers/media/video/m5mols/m5mols.h
rename to drivers/media/i2c/m5mols/m5mols.h
diff --git a/drivers/media/video/m5mols/m5mols_capture.c b/drivers/media/i2c/m5mols/m5mols_capture.c
similarity index 100%
rename from drivers/media/video/m5mols/m5mols_capture.c
rename to drivers/media/i2c/m5mols/m5mols_capture.c
diff --git a/drivers/media/video/m5mols/m5mols_controls.c b/drivers/media/i2c/m5mols/m5mols_controls.c
similarity index 100%
rename from drivers/media/video/m5mols/m5mols_controls.c
rename to drivers/media/i2c/m5mols/m5mols_controls.c
diff --git a/drivers/media/video/m5mols/m5mols_core.c b/drivers/media/i2c/m5mols/m5mols_core.c
similarity index 100%
rename from drivers/media/video/m5mols/m5mols_core.c
rename to drivers/media/i2c/m5mols/m5mols_core.c
diff --git a/drivers/media/video/m5mols/m5mols_reg.h b/drivers/media/i2c/m5mols/m5mols_reg.h
similarity index 100%
rename from drivers/media/video/m5mols/m5mols_reg.h
rename to drivers/media/i2c/m5mols/m5mols_reg.h
diff --git a/drivers/media/video/msp3400-driver.c b/drivers/media/i2c/msp3400-driver.c
similarity index 100%
rename from drivers/media/video/msp3400-driver.c
rename to drivers/media/i2c/msp3400-driver.c
diff --git a/drivers/media/video/msp3400-driver.h b/drivers/media/i2c/msp3400-driver.h
similarity index 100%
rename from drivers/media/video/msp3400-driver.h
rename to drivers/media/i2c/msp3400-driver.h
diff --git a/drivers/media/video/msp3400-kthreads.c b/drivers/media/i2c/msp3400-kthreads.c
similarity index 100%
rename from drivers/media/video/msp3400-kthreads.c
rename to drivers/media/i2c/msp3400-kthreads.c
diff --git a/drivers/media/video/mt9m032.c b/drivers/media/i2c/mt9m032.c
similarity index 100%
rename from drivers/media/video/mt9m032.c
rename to drivers/media/i2c/mt9m032.c
diff --git a/drivers/media/video/mt9p031.c b/drivers/media/i2c/mt9p031.c
similarity index 100%
rename from drivers/media/video/mt9p031.c
rename to drivers/media/i2c/mt9p031.c
diff --git a/drivers/media/video/mt9t001.c b/drivers/media/i2c/mt9t001.c
similarity index 100%
rename from drivers/media/video/mt9t001.c
rename to drivers/media/i2c/mt9t001.c
diff --git a/drivers/media/video/mt9v011.c b/drivers/media/i2c/mt9v011.c
similarity index 100%
rename from drivers/media/video/mt9v011.c
rename to drivers/media/i2c/mt9v011.c
diff --git a/drivers/media/video/mt9v032.c b/drivers/media/i2c/mt9v032.c
similarity index 100%
rename from drivers/media/video/mt9v032.c
rename to drivers/media/i2c/mt9v032.c
diff --git a/drivers/media/video/noon010pc30.c b/drivers/media/i2c/noon010pc30.c
similarity index 100%
rename from drivers/media/video/noon010pc30.c
rename to drivers/media/i2c/noon010pc30.c
diff --git a/drivers/media/video/ov7670.c b/drivers/media/i2c/ov7670.c
similarity index 100%
rename from drivers/media/video/ov7670.c
rename to drivers/media/i2c/ov7670.c
diff --git a/drivers/media/video/s5k6aa.c b/drivers/media/i2c/s5k6aa.c
similarity index 100%
rename from drivers/media/video/s5k6aa.c
rename to drivers/media/i2c/s5k6aa.c
diff --git a/drivers/media/video/saa6588.c b/drivers/media/i2c/saa6588.c
similarity index 100%
rename from drivers/media/video/saa6588.c
rename to drivers/media/i2c/saa6588.c
diff --git a/drivers/media/video/saa7110.c b/drivers/media/i2c/saa7110.c
similarity index 100%
rename from drivers/media/video/saa7110.c
rename to drivers/media/i2c/saa7110.c
diff --git a/drivers/media/video/saa7115.c b/drivers/media/i2c/saa7115.c
similarity index 100%
rename from drivers/media/video/saa7115.c
rename to drivers/media/i2c/saa7115.c
diff --git a/drivers/media/video/saa711x_regs.h b/drivers/media/i2c/saa711x_regs.h
similarity index 100%
rename from drivers/media/video/saa711x_regs.h
rename to drivers/media/i2c/saa711x_regs.h
diff --git a/drivers/media/video/saa7127.c b/drivers/media/i2c/saa7127.c
similarity index 100%
rename from drivers/media/video/saa7127.c
rename to drivers/media/i2c/saa7127.c
diff --git a/drivers/media/video/saa717x.c b/drivers/media/i2c/saa717x.c
similarity index 100%
rename from drivers/media/video/saa717x.c
rename to drivers/media/i2c/saa717x.c
diff --git a/drivers/media/video/saa7185.c b/drivers/media/i2c/saa7185.c
similarity index 100%
rename from drivers/media/video/saa7185.c
rename to drivers/media/i2c/saa7185.c
diff --git a/drivers/media/video/saa7191.c b/drivers/media/i2c/saa7191.c
similarity index 100%
rename from drivers/media/video/saa7191.c
rename to drivers/media/i2c/saa7191.c
diff --git a/drivers/media/video/saa7191.h b/drivers/media/i2c/saa7191.h
similarity index 100%
rename from drivers/media/video/saa7191.h
rename to drivers/media/i2c/saa7191.h
diff --git a/drivers/media/video/smiapp-pll.c b/drivers/media/i2c/smiapp-pll.c
similarity index 99%
rename from drivers/media/video/smiapp-pll.c
rename to drivers/media/i2c/smiapp-pll.c
index a2e41a2..a577614 100644
--- a/drivers/media/video/smiapp-pll.c
+++ b/drivers/media/i2c/smiapp-pll.c
@@ -1,5 +1,5 @@
 /*
- * drivers/media/video/smiapp-pll.c
+ * drivers/media/i2c/smiapp-pll.c
  *
  * Generic driver for SMIA/SMIA++ compliant camera modules
  *
diff --git a/drivers/media/video/smiapp-pll.h b/drivers/media/i2c/smiapp-pll.h
similarity index 98%
rename from drivers/media/video/smiapp-pll.h
rename to drivers/media/i2c/smiapp-pll.h
index 9eab63f..cb2d2db 100644
--- a/drivers/media/video/smiapp-pll.h
+++ b/drivers/media/i2c/smiapp-pll.h
@@ -1,5 +1,5 @@
 /*
- * drivers/media/video/smiapp-pll.h
+ * drivers/media/i2c/smiapp-pll.h
  *
  * Generic driver for SMIA/SMIA++ compliant camera modules
  *
diff --git a/drivers/media/video/smiapp/Kconfig b/drivers/media/i2c/smiapp/Kconfig
similarity index 100%
rename from drivers/media/video/smiapp/Kconfig
rename to drivers/media/i2c/smiapp/Kconfig
diff --git a/drivers/media/video/smiapp/Makefile b/drivers/media/i2c/smiapp/Makefile
similarity index 78%
rename from drivers/media/video/smiapp/Makefile
rename to drivers/media/i2c/smiapp/Makefile
index 36b0cfa..f45a003 100644
--- a/drivers/media/video/smiapp/Makefile
+++ b/drivers/media/i2c/smiapp/Makefile
@@ -2,4 +2,4 @@ smiapp-objs			+= smiapp-core.o smiapp-regs.o \
 				   smiapp-quirk.o smiapp-limits.o
 obj-$(CONFIG_VIDEO_SMIAPP)	+= smiapp.o
 
-ccflags-y += -Idrivers/media/video
+ccflags-y += -Idrivers/media/i2c
diff --git a/drivers/media/video/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
similarity index 99%
rename from drivers/media/video/smiapp/smiapp-core.c
rename to drivers/media/i2c/smiapp/smiapp-core.c
index bfd47c1..1cf914d 100644
--- a/drivers/media/video/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -1,5 +1,5 @@
 /*
- * drivers/media/video/smiapp/smiapp-core.c
+ * drivers/media/i2c/smiapp/smiapp-core.c
  *
  * Generic driver for SMIA/SMIA++ compliant camera modules
  *
diff --git a/drivers/media/video/smiapp/smiapp-limits.c b/drivers/media/i2c/smiapp/smiapp-limits.c
similarity index 99%
rename from drivers/media/video/smiapp/smiapp-limits.c
rename to drivers/media/i2c/smiapp/smiapp-limits.c
index 0800e09..fb2f81a 100644
--- a/drivers/media/video/smiapp/smiapp-limits.c
+++ b/drivers/media/i2c/smiapp/smiapp-limits.c
@@ -1,5 +1,5 @@
 /*
- * drivers/media/video/smiapp/smiapp-limits.c
+ * drivers/media/i2c/smiapp/smiapp-limits.c
  *
  * Generic driver for SMIA/SMIA++ compliant camera modules
  *
diff --git a/drivers/media/video/smiapp/smiapp-limits.h b/drivers/media/i2c/smiapp/smiapp-limits.h
similarity index 99%
rename from drivers/media/video/smiapp/smiapp-limits.h
rename to drivers/media/i2c/smiapp/smiapp-limits.h
index 7f4836bb..9ae765e 100644
--- a/drivers/media/video/smiapp/smiapp-limits.h
+++ b/drivers/media/i2c/smiapp/smiapp-limits.h
@@ -1,5 +1,5 @@
 /*
- * drivers/media/video/smiapp/smiapp-limits.h
+ * drivers/media/i2c/smiapp/smiapp-limits.h
  *
  * Generic driver for SMIA/SMIA++ compliant camera modules
  *
diff --git a/drivers/media/video/smiapp/smiapp-quirk.c b/drivers/media/i2c/smiapp/smiapp-quirk.c
similarity index 99%
rename from drivers/media/video/smiapp/smiapp-quirk.c
rename to drivers/media/i2c/smiapp/smiapp-quirk.c
index 55e8795..cf04812 100644
--- a/drivers/media/video/smiapp/smiapp-quirk.c
+++ b/drivers/media/i2c/smiapp/smiapp-quirk.c
@@ -1,5 +1,5 @@
 /*
- * drivers/media/video/smiapp/smiapp-quirk.c
+ * drivers/media/i2c/smiapp/smiapp-quirk.c
  *
  * Generic driver for SMIA/SMIA++ compliant camera modules
  *
diff --git a/drivers/media/video/smiapp/smiapp-quirk.h b/drivers/media/i2c/smiapp/smiapp-quirk.h
similarity index 98%
rename from drivers/media/video/smiapp/smiapp-quirk.h
rename to drivers/media/i2c/smiapp/smiapp-quirk.h
index f4dcaab..86fd3e8 100644
--- a/drivers/media/video/smiapp/smiapp-quirk.h
+++ b/drivers/media/i2c/smiapp/smiapp-quirk.h
@@ -1,5 +1,5 @@
 /*
- * drivers/media/video/smiapp/smiapp-quirk.h
+ * drivers/media/i2c/smiapp/smiapp-quirk.h
  *
  * Generic driver for SMIA/SMIA++ compliant camera modules
  *
diff --git a/drivers/media/video/smiapp/smiapp-reg-defs.h b/drivers/media/i2c/smiapp/smiapp-reg-defs.h
similarity index 99%
rename from drivers/media/video/smiapp/smiapp-reg-defs.h
rename to drivers/media/i2c/smiapp/smiapp-reg-defs.h
index a089eb8..defa7c5 100644
--- a/drivers/media/video/smiapp/smiapp-reg-defs.h
+++ b/drivers/media/i2c/smiapp/smiapp-reg-defs.h
@@ -1,5 +1,5 @@
 /*
- * drivers/media/video/smiapp/smiapp-reg-defs.h
+ * drivers/media/i2c/smiapp/smiapp-reg-defs.h
  *
  * Generic driver for SMIA/SMIA++ compliant camera modules
  *
diff --git a/drivers/media/video/smiapp/smiapp-reg.h b/drivers/media/i2c/smiapp/smiapp-reg.h
similarity index 98%
rename from drivers/media/video/smiapp/smiapp-reg.h
rename to drivers/media/i2c/smiapp/smiapp-reg.h
index d0167aa..54568ca 100644
--- a/drivers/media/video/smiapp/smiapp-reg.h
+++ b/drivers/media/i2c/smiapp/smiapp-reg.h
@@ -1,5 +1,5 @@
 /*
- * drivers/media/video/smiapp/smiapp-reg.h
+ * drivers/media/i2c/smiapp/smiapp-reg.h
  *
  * Generic driver for SMIA/SMIA++ compliant camera modules
  *
diff --git a/drivers/media/video/smiapp/smiapp-regs.c b/drivers/media/i2c/smiapp/smiapp-regs.c
similarity index 99%
rename from drivers/media/video/smiapp/smiapp-regs.c
rename to drivers/media/i2c/smiapp/smiapp-regs.c
index b1812b1..70e0d8d 100644
--- a/drivers/media/video/smiapp/smiapp-regs.c
+++ b/drivers/media/i2c/smiapp/smiapp-regs.c
@@ -1,5 +1,5 @@
 /*
- * drivers/media/video/smiapp/smiapp-regs.c
+ * drivers/media/i2c/smiapp/smiapp-regs.c
  *
  * Generic driver for SMIA/SMIA++ compliant camera modules
  *
diff --git a/drivers/media/video/smiapp/smiapp-regs.h b/drivers/media/i2c/smiapp/smiapp-regs.h
similarity index 100%
rename from drivers/media/video/smiapp/smiapp-regs.h
rename to drivers/media/i2c/smiapp/smiapp-regs.h
diff --git a/drivers/media/video/smiapp/smiapp.h b/drivers/media/i2c/smiapp/smiapp.h
similarity index 99%
rename from drivers/media/video/smiapp/smiapp.h
rename to drivers/media/i2c/smiapp/smiapp.h
index 587f7f1..4182a69 100644
--- a/drivers/media/video/smiapp/smiapp.h
+++ b/drivers/media/i2c/smiapp/smiapp.h
@@ -1,5 +1,5 @@
 /*
- * drivers/media/video/smiapp/smiapp.h
+ * drivers/media/i2c/smiapp/smiapp.h
  *
  * Generic driver for SMIA/SMIA++ compliant camera modules
  *
diff --git a/drivers/media/video/sr030pc30.c b/drivers/media/i2c/sr030pc30.c
similarity index 100%
rename from drivers/media/video/sr030pc30.c
rename to drivers/media/i2c/sr030pc30.c
diff --git a/drivers/media/video/tcm825x.c b/drivers/media/i2c/tcm825x.c
similarity index 99%
rename from drivers/media/video/tcm825x.c
rename to drivers/media/i2c/tcm825x.c
index 462caa4..9252529 100644
--- a/drivers/media/video/tcm825x.c
+++ b/drivers/media/i2c/tcm825x.c
@@ -1,5 +1,5 @@
 /*
- * drivers/media/video/tcm825x.c
+ * drivers/media/i2c/tcm825x.c
  *
  * TCM825X camera sensor driver.
  *
diff --git a/drivers/media/video/tcm825x.h b/drivers/media/i2c/tcm825x.h
similarity index 99%
rename from drivers/media/video/tcm825x.h
rename to drivers/media/i2c/tcm825x.h
index 5b7e696..8ebab95 100644
--- a/drivers/media/video/tcm825x.h
+++ b/drivers/media/i2c/tcm825x.h
@@ -1,5 +1,5 @@
 /*
- * drivers/media/video/tcm825x.h
+ * drivers/media/i2c/tcm825x.h
  *
  * Register definitions for the TCM825X CameraChip.
  *
diff --git a/drivers/media/video/tda7432.c b/drivers/media/i2c/tda7432.c
similarity index 100%
rename from drivers/media/video/tda7432.c
rename to drivers/media/i2c/tda7432.c
diff --git a/drivers/media/video/tda9840.c b/drivers/media/i2c/tda9840.c
similarity index 100%
rename from drivers/media/video/tda9840.c
rename to drivers/media/i2c/tda9840.c
diff --git a/drivers/media/video/tea6415c.c b/drivers/media/i2c/tea6415c.c
similarity index 100%
rename from drivers/media/video/tea6415c.c
rename to drivers/media/i2c/tea6415c.c
diff --git a/drivers/media/video/tea6415c.h b/drivers/media/i2c/tea6415c.h
similarity index 100%
rename from drivers/media/video/tea6415c.h
rename to drivers/media/i2c/tea6415c.h
diff --git a/drivers/media/video/tea6420.c b/drivers/media/i2c/tea6420.c
similarity index 100%
rename from drivers/media/video/tea6420.c
rename to drivers/media/i2c/tea6420.c
diff --git a/drivers/media/video/tea6420.h b/drivers/media/i2c/tea6420.h
similarity index 100%
rename from drivers/media/video/tea6420.h
rename to drivers/media/i2c/tea6420.h
diff --git a/drivers/media/video/ths7303.c b/drivers/media/i2c/ths7303.c
similarity index 100%
rename from drivers/media/video/ths7303.c
rename to drivers/media/i2c/ths7303.c
diff --git a/drivers/media/video/tlv320aic23b.c b/drivers/media/i2c/tlv320aic23b.c
similarity index 100%
rename from drivers/media/video/tlv320aic23b.c
rename to drivers/media/i2c/tlv320aic23b.c
diff --git a/drivers/media/video/tvaudio.c b/drivers/media/i2c/tvaudio.c
similarity index 100%
rename from drivers/media/video/tvaudio.c
rename to drivers/media/i2c/tvaudio.c
diff --git a/drivers/media/video/tveeprom.c b/drivers/media/i2c/tveeprom.c
similarity index 100%
rename from drivers/media/video/tveeprom.c
rename to drivers/media/i2c/tveeprom.c
diff --git a/drivers/media/video/tvp514x.c b/drivers/media/i2c/tvp514x.c
similarity index 99%
rename from drivers/media/video/tvp514x.c
rename to drivers/media/i2c/tvp514x.c
index cd615c1..1f3943b 100644
--- a/drivers/media/video/tvp514x.c
+++ b/drivers/media/i2c/tvp514x.c
@@ -1,5 +1,5 @@
 /*
- * drivers/media/video/tvp514x.c
+ * drivers/media/i2c/tvp514x.c
  *
  * TI TVP5146/47 decoder driver
  *
diff --git a/drivers/media/video/tvp514x_regs.h b/drivers/media/i2c/tvp514x_regs.h
similarity index 99%
rename from drivers/media/video/tvp514x_regs.h
rename to drivers/media/i2c/tvp514x_regs.h
index 18f29ad..d23aa2f 100644
--- a/drivers/media/video/tvp514x_regs.h
+++ b/drivers/media/i2c/tvp514x_regs.h
@@ -1,5 +1,5 @@
 /*
- * drivers/media/video/tvp514x_regs.h
+ * drivers/media/i2c/tvp514x_regs.h
  *
  * Copyright (C) 2008 Texas Instruments Inc
  * Author: Vaibhav Hiremath <hvaibhav@ti.com>
diff --git a/drivers/media/video/tvp5150.c b/drivers/media/i2c/tvp5150.c
similarity index 100%
rename from drivers/media/video/tvp5150.c
rename to drivers/media/i2c/tvp5150.c
diff --git a/drivers/media/video/tvp5150_reg.h b/drivers/media/i2c/tvp5150_reg.h
similarity index 100%
rename from drivers/media/video/tvp5150_reg.h
rename to drivers/media/i2c/tvp5150_reg.h
diff --git a/drivers/media/video/tvp7002.c b/drivers/media/i2c/tvp7002.c
similarity index 100%
rename from drivers/media/video/tvp7002.c
rename to drivers/media/i2c/tvp7002.c
diff --git a/drivers/media/video/tvp7002_reg.h b/drivers/media/i2c/tvp7002_reg.h
similarity index 100%
rename from drivers/media/video/tvp7002_reg.h
rename to drivers/media/i2c/tvp7002_reg.h
diff --git a/drivers/media/video/upd64031a.c b/drivers/media/i2c/upd64031a.c
similarity index 100%
rename from drivers/media/video/upd64031a.c
rename to drivers/media/i2c/upd64031a.c
diff --git a/drivers/media/video/upd64083.c b/drivers/media/i2c/upd64083.c
similarity index 100%
rename from drivers/media/video/upd64083.c
rename to drivers/media/i2c/upd64083.c
diff --git a/drivers/media/video/vp27smpx.c b/drivers/media/i2c/vp27smpx.c
similarity index 100%
rename from drivers/media/video/vp27smpx.c
rename to drivers/media/i2c/vp27smpx.c
diff --git a/drivers/media/video/vpx3220.c b/drivers/media/i2c/vpx3220.c
similarity index 100%
rename from drivers/media/video/vpx3220.c
rename to drivers/media/i2c/vpx3220.c
diff --git a/drivers/media/video/vs6624.c b/drivers/media/i2c/vs6624.c
similarity index 100%
rename from drivers/media/video/vs6624.c
rename to drivers/media/i2c/vs6624.c
diff --git a/drivers/media/video/vs6624_regs.h b/drivers/media/i2c/vs6624_regs.h
similarity index 100%
rename from drivers/media/video/vs6624_regs.h
rename to drivers/media/i2c/vs6624_regs.h
diff --git a/drivers/media/video/wm8739.c b/drivers/media/i2c/wm8739.c
similarity index 100%
rename from drivers/media/video/wm8739.c
rename to drivers/media/i2c/wm8739.c
diff --git a/drivers/media/video/wm8775.c b/drivers/media/i2c/wm8775.c
similarity index 100%
rename from drivers/media/video/wm8775.c
rename to drivers/media/i2c/wm8775.c
diff --git a/drivers/media/pci/bt8xx/Makefile b/drivers/media/pci/bt8xx/Makefile
index ae347b7..5f06597 100644
--- a/drivers/media/pci/bt8xx/Makefile
+++ b/drivers/media/pci/bt8xx/Makefile
@@ -7,5 +7,5 @@ obj-$(CONFIG_DVB_BT8XX) += bt878.o dvb-bt8xx.o dst.o dst_ca.o
 
 ccflags-y += -Idrivers/media/dvb-core
 ccflags-y += -Idrivers/media/dvb-frontends
-ccflags-y += -Idrivers/media/video
+ccflags-y += -Idrivers/media/i2c
 ccflags-y += -Idrivers/media/tuners
diff --git a/drivers/media/pci/cx23885/Makefile b/drivers/media/pci/cx23885/Makefile
index f92cc4c..a2cbdcf 100644
--- a/drivers/media/pci/cx23885/Makefile
+++ b/drivers/media/pci/cx23885/Makefile
@@ -7,7 +7,7 @@ cx23885-objs	:= cx23885-cards.o cx23885-video.o cx23885-vbi.o \
 obj-$(CONFIG_VIDEO_CX23885) += cx23885.o
 obj-$(CONFIG_MEDIA_ALTERA_CI) += altera-ci.o
 
-ccflags-y += -Idrivers/media/video
+ccflags-y += -Idrivers/media/i2c
 ccflags-y += -Idrivers/media/tuners
 ccflags-y += -Idrivers/media/dvb-core
 ccflags-y += -Idrivers/media/dvb-frontends
diff --git a/drivers/media/pci/cx25821/Makefile b/drivers/media/pci/cx25821/Makefile
index 1434e80..c038941 100644
--- a/drivers/media/pci/cx25821/Makefile
+++ b/drivers/media/pci/cx25821/Makefile
@@ -7,7 +7,7 @@ cx25821-y   := cx25821-core.o cx25821-cards.o cx25821-i2c.o \
 obj-$(CONFIG_VIDEO_CX25821) += cx25821.o
 obj-$(CONFIG_VIDEO_CX25821_ALSA) += cx25821-alsa.o
 
-ccflags-y := -Idrivers/media/video
+ccflags-y := -Idrivers/media/i2c
 ccflags-y += -Idrivers/media/tuners
 ccflags-y += -Idrivers/media/dvb-core
 ccflags-y += -Idrivers/media/dvb-frontends
diff --git a/drivers/media/pci/cx88/Makefile b/drivers/media/pci/cx88/Makefile
index 884b4cd..d3679c3 100644
--- a/drivers/media/pci/cx88/Makefile
+++ b/drivers/media/pci/cx88/Makefile
@@ -10,7 +10,7 @@ obj-$(CONFIG_VIDEO_CX88_BLACKBIRD) += cx88-blackbird.o
 obj-$(CONFIG_VIDEO_CX88_DVB) += cx88-dvb.o
 obj-$(CONFIG_VIDEO_CX88_VP3054) += cx88-vp3054-i2c.o
 
-ccflags-y += -Idrivers/media/video
+ccflags-y += -Idrivers/media/i2c
 ccflags-y += -Idrivers/media/tuners
 ccflags-y += -Idrivers/media/dvb-core
 ccflags-y += -Idrivers/media/dvb-frontends
diff --git a/drivers/media/pci/ivtv/Makefile b/drivers/media/pci/ivtv/Makefile
index 80b4ec1..1408c9f 100644
--- a/drivers/media/pci/ivtv/Makefile
+++ b/drivers/media/pci/ivtv/Makefile
@@ -7,7 +7,7 @@ ivtv-objs	:= ivtv-routing.o ivtv-cards.o ivtv-controls.o \
 obj-$(CONFIG_VIDEO_IVTV) += ivtv.o
 obj-$(CONFIG_VIDEO_FB_IVTV) += ivtvfb.o
 
-ccflags-y += -I$(srctree)/drivers/media/video
+ccflags-y += -I$(srctree)/drivers/media/i2c
 ccflags-y += -I$(srctree)/drivers/media/tuners
 ccflags-y += -I$(srctree)/drivers/media/dvb-core
 ccflags-y += -I$(srctree)/drivers/media/dvb-frontends
diff --git a/drivers/media/pci/saa7134/Makefile b/drivers/media/pci/saa7134/Makefile
index aba5008..9e510c1 100644
--- a/drivers/media/pci/saa7134/Makefile
+++ b/drivers/media/pci/saa7134/Makefile
@@ -10,7 +10,7 @@ obj-$(CONFIG_VIDEO_SAA7134_ALSA) += saa7134-alsa.o
 
 obj-$(CONFIG_VIDEO_SAA7134_DVB) += saa7134-dvb.o
 
-ccflags-y += -I$(srctree)/drivers/media/video
+ccflags-y += -I$(srctree)/drivers/media/i2c
 ccflags-y += -I$(srctree)/drivers/media/tuners
 ccflags-y += -I$(srctree)/drivers/media/dvb-core
 ccflags-y += -I$(srctree)/drivers/media/dvb-frontends
diff --git a/drivers/media/pci/saa7146/Makefile b/drivers/media/pci/saa7146/Makefile
index 362a38b..f3566a9 100644
--- a/drivers/media/pci/saa7146/Makefile
+++ b/drivers/media/pci/saa7146/Makefile
@@ -2,4 +2,4 @@ obj-$(CONFIG_VIDEO_MXB) += mxb.o
 obj-$(CONFIG_VIDEO_HEXIUM_ORION) += hexium_orion.o
 obj-$(CONFIG_VIDEO_HEXIUM_GEMINI) += hexium_gemini.o
 
-ccflags-y += -I$(srctree)/drivers/media/video
+ccflags-y += -I$(srctree)/drivers/media/i2c
diff --git a/drivers/media/pci/saa7164/Makefile b/drivers/media/pci/saa7164/Makefile
index 847110c..ba0e33a 100644
--- a/drivers/media/pci/saa7164/Makefile
+++ b/drivers/media/pci/saa7164/Makefile
@@ -4,7 +4,7 @@ saa7164-objs	:= saa7164-cards.o saa7164-core.o saa7164-i2c.o saa7164-dvb.o \
 
 obj-$(CONFIG_VIDEO_SAA7164) += saa7164.o
 
-ccflags-y += -I$(srctree)/drivers/media/video
+ccflags-y += -I$(srctree)/drivers/media/i2c
 ccflags-y += -I$(srctree)/drivers/media/tuners
 ccflags-y += -I$(srctree)/drivers/media/dvb-core
 ccflags-y += -I$(srctree)/drivers/media/dvb-frontends
diff --git a/drivers/media/usb/cx231xx/Makefile b/drivers/media/usb/cx231xx/Makefile
index 1d40fce..52cf769 100644
--- a/drivers/media/usb/cx231xx/Makefile
+++ b/drivers/media/usb/cx231xx/Makefile
@@ -8,7 +8,7 @@ obj-$(CONFIG_VIDEO_CX231XX) += cx231xx.o
 obj-$(CONFIG_VIDEO_CX231XX_ALSA) += cx231xx-alsa.o
 obj-$(CONFIG_VIDEO_CX231XX_DVB) += cx231xx-dvb.o
 
-ccflags-y += -Idrivers/media/video
+ccflags-y += -Idrivers/media/i2c
 ccflags-y += -Idrivers/media/tuners
 ccflags-y += -Idrivers/media/dvb-core
 ccflags-y += -Idrivers/media/dvb-frontends
diff --git a/drivers/media/usb/em28xx/Makefile b/drivers/media/usb/em28xx/Makefile
index 65c7c29..6c5f338 100644
--- a/drivers/media/usb/em28xx/Makefile
+++ b/drivers/media/usb/em28xx/Makefile
@@ -9,7 +9,7 @@ obj-$(CONFIG_VIDEO_EM28XX_ALSA) += em28xx-alsa.o
 obj-$(CONFIG_VIDEO_EM28XX_DVB) += em28xx-dvb.o
 obj-$(CONFIG_VIDEO_EM28XX_RC) += em28xx-rc.o
 
-ccflags-y += -Idrivers/media/video
+ccflags-y += -Idrivers/media/i2c
 ccflags-y += -Idrivers/media/tuners
 ccflags-y += -Idrivers/media/dvb-core
 ccflags-y += -Idrivers/media/dvb-frontends
diff --git a/drivers/media/usb/hdpvr/Makefile b/drivers/media/usb/hdpvr/Makefile
index 52f057f..9b8d146 100644
--- a/drivers/media/usb/hdpvr/Makefile
+++ b/drivers/media/usb/hdpvr/Makefile
@@ -2,6 +2,6 @@ hdpvr-objs	:= hdpvr-control.o hdpvr-core.o hdpvr-video.o hdpvr-i2c.o
 
 obj-$(CONFIG_VIDEO_HDPVR) += hdpvr.o
 
-ccflags-y += -Idrivers/media/video
+ccflags-y += -Idrivers/media/i2c
 
 ccflags-y += $(extra-cflags-y) $(extra-cflags-m)
diff --git a/drivers/media/usb/pvrusb2/Makefile b/drivers/media/usb/pvrusb2/Makefile
index bc716db..ad70554 100644
--- a/drivers/media/usb/pvrusb2/Makefile
+++ b/drivers/media/usb/pvrusb2/Makefile
@@ -16,7 +16,7 @@ pvrusb2-objs	:= pvrusb2-i2c-core.o \
 
 obj-$(CONFIG_VIDEO_PVRUSB2) += pvrusb2.o
 
-ccflags-y += -Idrivers/media/video
+ccflags-y += -Idrivers/media/i2c
 ccflags-y += -Idrivers/media/tuners
 ccflags-y += -Idrivers/media/dvb-core
 ccflags-y += -Idrivers/media/dvb-frontends
diff --git a/drivers/media/usb/stk1160/Makefile b/drivers/media/usb/stk1160/Makefile
index 8a3c784..dfe3e90 100644
--- a/drivers/media/usb/stk1160/Makefile
+++ b/drivers/media/usb/stk1160/Makefile
@@ -8,4 +8,4 @@ stk1160-y := 	stk1160-core.o \
 
 obj-$(CONFIG_VIDEO_STK1160) += stk1160.o
 
-ccflags-y += -Idrivers/media/video
+ccflags-y += -Idrivers/media/i2c
diff --git a/drivers/media/usb/tlg2300/Makefile b/drivers/media/usb/tlg2300/Makefile
index 4d66087..137f8e3 100644
--- a/drivers/media/usb/tlg2300/Makefile
+++ b/drivers/media/usb/tlg2300/Makefile
@@ -2,7 +2,7 @@ poseidon-objs := pd-video.o pd-alsa.o pd-dvb.o pd-radio.o pd-main.o
 
 obj-$(CONFIG_VIDEO_TLG2300) += poseidon.o
 
-ccflags-y += -Idrivers/media/video
+ccflags-y += -Idrivers/media/i2c
 ccflags-y += -Idrivers/media/tuners
 ccflags-y += -Idrivers/media/dvb-core
 ccflags-y += -Idrivers/media/dvb-frontends
diff --git a/drivers/media/usb/tm6000/Makefile b/drivers/media/usb/tm6000/Makefile
index 1feb8c9..6fa1f10 100644
--- a/drivers/media/usb/tm6000/Makefile
+++ b/drivers/media/usb/tm6000/Makefile
@@ -9,7 +9,7 @@ obj-$(CONFIG_VIDEO_TM6000) += tm6000.o
 obj-$(CONFIG_VIDEO_TM6000_ALSA) += tm6000-alsa.o
 obj-$(CONFIG_VIDEO_TM6000_DVB) += tm6000-dvb.o
 
-ccflags-y := -Idrivers/media/video
+ccflags-y := -Idrivers/media/i2c
 ccflags-y += -Idrivers/media/tuners
 ccflags-y += -Idrivers/media/dvb-core
 ccflags-y += -Idrivers/media/dvb-frontends
diff --git a/drivers/media/usb/usbvision/Makefile b/drivers/media/usb/usbvision/Makefile
index d55c6bd..9b3a558 100644
--- a/drivers/media/usb/usbvision/Makefile
+++ b/drivers/media/usb/usbvision/Makefile
@@ -2,5 +2,5 @@ usbvision-objs  := usbvision-core.o usbvision-video.o usbvision-i2c.o usbvision-
 
 obj-$(CONFIG_VIDEO_USBVISION) += usbvision.o
 
-ccflags-y += -Idrivers/media/video
+ccflags-y += -Idrivers/media/i2c
 ccflags-y += -Idrivers/media/tuners
diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index a7bd9576c..f2171e7 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -1,578 +1,4 @@
-#
-# Generic video config states
-#
-
-config VIDEO_BTCX
-	depends on PCI
-	tristate
-
-config VIDEO_TVEEPROM
-	tristate
-	depends on I2C
-
-#
-# Multimedia Video device configuration
-#
-
-menuconfig VIDEO_CAPTURE_DRIVERS
-	bool "Video capture adapters"
-	depends on VIDEO_V4L2
-	depends on MEDIA_CAMERA_SUPPORT || MEDIA_ANALOG_TV_SUPPORT
-	default y
-	---help---
-	  Say Y here to enable selecting the video adapters for
-	  webcams, analog TV, and hybrid analog/digital TV.
-	  Some of those devices also supports FM radio.
-
-if VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2
-
-config VIDEO_HELPER_CHIPS_AUTO
-	bool "Autoselect pertinent encoders/decoders and other helper chips"
-	default y if !EXPERT
-	---help---
-	  Most video cards may require additional modules to encode or
-	  decode audio/video standards. This option will autoselect
-	  all pertinent modules to each selected video module.
-
-	  Unselect this only if you know exactly what you are doing, since
-	  it may break support on some boards.
-
-	  In doubt, say Y.
-
-config VIDEO_IR_I2C
-	tristate "I2C module for IR" if !VIDEO_HELPER_CHIPS_AUTO
-	depends on I2C && RC_CORE
-	default y
-	---help---
-	  Most boards have an IR chip directly connected via GPIO. However,
-	  some video boards have the IR connected via I2C bus.
-
-	  If your board doesn't have an I2C IR chip, you may disable this
-	  option.
-
-	  In doubt, say Y.
-
-#
-# Encoder / Decoder module configuration
-#
-
-menu "Encoders, decoders, sensors and other helper chips"
-	visible if !VIDEO_HELPER_CHIPS_AUTO
-
-comment "Audio decoders, processors and mixers"
-
-config VIDEO_TVAUDIO
-	tristate "Simple audio decoder chips"
-	depends on VIDEO_V4L2 && I2C
-	---help---
-	  Support for several audio decoder chips found on some bt8xx boards:
-	  Philips: tda9840, tda9873h, tda9874h/a, tda9850, tda985x, tea6300,
-		   tea6320, tea6420, tda8425, ta8874z.
-	  Microchip: pic16c54 based design on ProVideo PV951 board.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called tvaudio.
-
-config VIDEO_TDA7432
-	tristate "Philips TDA7432 audio processor"
-	depends on VIDEO_V4L2 && I2C
-	---help---
-	  Support for tda7432 audio decoder chip found on some bt8xx boards.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called tda7432.
-
-config VIDEO_TDA9840
-	tristate "Philips TDA9840 audio processor"
-	depends on I2C
-	---help---
-	  Support for tda9840 audio decoder chip found on some Zoran boards.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called tda9840.
-
-config VIDEO_TEA6415C
-	tristate "Philips TEA6415C audio processor"
-	depends on I2C
-	---help---
-	  Support for tea6415c audio decoder chip found on some bt8xx boards.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called tea6415c.
-
-config VIDEO_TEA6420
-	tristate "Philips TEA6420 audio processor"
-	depends on I2C
-	---help---
-	  Support for tea6420 audio decoder chip found on some bt8xx boards.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called tea6420.
-
-config VIDEO_MSP3400
-	tristate "Micronas MSP34xx audio decoders"
-	depends on VIDEO_V4L2 && I2C
-	---help---
-	  Support for the Micronas MSP34xx series of audio decoders.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called msp3400.
-
-config VIDEO_CS5345
-	tristate "Cirrus Logic CS5345 audio ADC"
-	depends on VIDEO_V4L2 && I2C
-	---help---
-	  Support for the Cirrus Logic CS5345 24-bit, 192 kHz
-	  stereo A/D converter.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called cs5345.
-
-config VIDEO_CS53L32A
-	tristate "Cirrus Logic CS53L32A audio ADC"
-	depends on VIDEO_V4L2 && I2C
-	---help---
-	  Support for the Cirrus Logic CS53L32A low voltage
-	  stereo A/D converter.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called cs53l32a.
-
-config VIDEO_TLV320AIC23B
-	tristate "Texas Instruments TLV320AIC23B audio codec"
-	depends on VIDEO_V4L2 && I2C && EXPERIMENTAL
-	---help---
-	  Support for the Texas Instruments TLV320AIC23B audio codec.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called tlv320aic23b.
-
-config VIDEO_WM8775
-	tristate "Wolfson Microelectronics WM8775 audio ADC with input mixer"
-	depends on VIDEO_V4L2 && I2C
-	---help---
-	  Support for the Wolfson Microelectronics WM8775 high
-	  performance stereo A/D Converter with a 4 channel input mixer.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called wm8775.
-
-config VIDEO_WM8739
-	tristate "Wolfson Microelectronics WM8739 stereo audio ADC"
-	depends on VIDEO_V4L2 && I2C
-	---help---
-	  Support for the Wolfson Microelectronics WM8739
-	  stereo A/D Converter.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called wm8739.
-
-config VIDEO_VP27SMPX
-	tristate "Panasonic VP27s internal MPX"
-	depends on VIDEO_V4L2 && I2C
-	---help---
-	  Support for the internal MPX of the Panasonic VP27s tuner.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called vp27smpx.
-
-comment "RDS decoders"
-
-config VIDEO_SAA6588
-	tristate "SAA6588 Radio Chip RDS decoder support"
-	depends on VIDEO_V4L2 && I2C
-
-	help
-	  Support for this Radio Data System (RDS) decoder. This allows
-	  seeing radio station identification transmitted using this
-	  standard.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called saa6588.
-
-comment "Video decoders"
-
-config VIDEO_ADV7180
-	tristate "Analog Devices ADV7180 decoder"
-	depends on VIDEO_V4L2 && I2C
-	---help---
-	  Support for the Analog Devices ADV7180 video decoder.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called adv7180.
-
-config VIDEO_ADV7183
-	tristate "Analog Devices ADV7183 decoder"
-	depends on VIDEO_V4L2 && I2C
-	---help---
-	  V4l2 subdevice driver for the Analog Devices
-	  ADV7183 video decoder.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called adv7183.
-
-config VIDEO_BT819
-	tristate "BT819A VideoStream decoder"
-	depends on VIDEO_V4L2 && I2C
-	---help---
-	  Support for BT819A video decoder.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called bt819.
-
-config VIDEO_BT856
-	tristate "BT856 VideoStream decoder"
-	depends on VIDEO_V4L2 && I2C
-	---help---
-	  Support for BT856 video decoder.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called bt856.
-
-config VIDEO_BT866
-	tristate "BT866 VideoStream decoder"
-	depends on VIDEO_V4L2 && I2C
-	---help---
-	  Support for BT866 video decoder.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called bt866.
-
-config VIDEO_KS0127
-	tristate "KS0127 video decoder"
-	depends on VIDEO_V4L2 && I2C
-	---help---
-	  Support for KS0127 video decoder.
-
-	  This chip is used on AverMedia AVS6EYES Zoran-based MJPEG
-	  cards.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called ks0127.
-
-config VIDEO_SAA7110
-	tristate "Philips SAA7110 video decoder"
-	depends on VIDEO_V4L2 && I2C
-	---help---
-	  Support for the Philips SAA7110 video decoders.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called saa7110.
-
-config VIDEO_SAA711X
-	tristate "Philips SAA7111/3/4/5 video decoders"
-	depends on VIDEO_V4L2 && I2C
-	---help---
-	  Support for the Philips SAA7111/3/4/5 video decoders.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called saa7115.
-
-config VIDEO_SAA7191
-	tristate "Philips SAA7191 video decoder"
-	depends on VIDEO_V4L2 && I2C
-	---help---
-	  Support for the Philips SAA7191 video decoder.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called saa7191.
-
-config VIDEO_TVP514X
-	tristate "Texas Instruments TVP514x video decoder"
-	depends on VIDEO_V4L2 && I2C
-	---help---
-	  This is a Video4Linux2 sensor-level driver for the TI TVP5146/47
-	  decoder. It is currently working with the TI OMAP3 camera
-	  controller.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called tvp514x.
-
-config VIDEO_TVP5150
-	tristate "Texas Instruments TVP5150 video decoder"
-	depends on VIDEO_V4L2 && I2C
-	---help---
-	  Support for the Texas Instruments TVP5150 video decoder.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called tvp5150.
-
-config VIDEO_TVP7002
-	tristate "Texas Instruments TVP7002 video decoder"
-	depends on VIDEO_V4L2 && I2C
-	---help---
-	  Support for the Texas Instruments TVP7002 video decoder.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called tvp7002.
-
-config VIDEO_VPX3220
-	tristate "vpx3220a, vpx3216b & vpx3214c video decoders"
-	depends on VIDEO_V4L2 && I2C
-	---help---
-	  Support for VPX322x video decoders.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called vpx3220.
-
-comment "Video and audio decoders"
-
-config VIDEO_SAA717X
-	tristate "Philips SAA7171/3/4 audio/video decoders"
-	depends on VIDEO_V4L2 && I2C
-	---help---
-	  Support for the Philips SAA7171/3/4 audio/video decoders.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called saa717x.
-
-source "drivers/media/video/cx25840/Kconfig"
-
-comment "MPEG video encoders"
-
-config VIDEO_CX2341X
-	tristate "Conexant CX2341x MPEG encoders"
-	depends on VIDEO_V4L2 && VIDEO_V4L2_COMMON
-	---help---
-	  Support for the Conexant CX23416 MPEG encoders
-	  and CX23415 MPEG encoder/decoders.
-
-	  This module currently supports the encoding functions only.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called cx2341x.
-
-comment "Video encoders"
-
-config VIDEO_SAA7127
-	tristate "Philips SAA7127/9 digital video encoders"
-	depends on VIDEO_V4L2 && I2C
-	---help---
-	  Support for the Philips SAA7127/9 digital video encoders.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called saa7127.
-
-config VIDEO_SAA7185
-	tristate "Philips SAA7185 video encoder"
-	depends on VIDEO_V4L2 && I2C
-	---help---
-	  Support for the Philips SAA7185 video encoder.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called saa7185.
-
-config VIDEO_ADV7170
-	tristate "Analog Devices ADV7170 video encoder"
-	depends on VIDEO_V4L2 && I2C
-	---help---
-	  Support for the Analog Devices ADV7170 video encoder driver
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called adv7170.
-
-config VIDEO_ADV7175
-	tristate "Analog Devices ADV7175 video encoder"
-	depends on VIDEO_V4L2 && I2C
-	---help---
-	  Support for the Analog Devices ADV7175 video encoder driver
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called adv7175.
-
-config VIDEO_ADV7343
-	tristate "ADV7343 video encoder"
-	depends on I2C
-	help
-	  Support for Analog Devices I2C bus based ADV7343 encoder.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called adv7343.
-
-config VIDEO_ADV7393
-	tristate "ADV7393 video encoder"
-	depends on I2C
-	help
-	  Support for Analog Devices I2C bus based ADV7393 encoder.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called adv7393.
-
-config VIDEO_AK881X
-	tristate "AK8813/AK8814 video encoders"
-	depends on I2C
-	help
-	  Video output driver for AKM AK8813 and AK8814 TV encoders
-
-comment "Camera sensor devices"
-
-config VIDEO_APTINA_PLL
-	tristate
-
-config VIDEO_SMIAPP_PLL
-	tristate
-
-config VIDEO_OV7670
-	tristate "OmniVision OV7670 sensor support"
-	depends on I2C && VIDEO_V4L2
-	depends on MEDIA_CAMERA_SUPPORT
-	---help---
-	  This is a Video4Linux2 sensor-level driver for the OmniVision
-	  OV7670 VGA camera.  It currently only works with the M88ALP01
-	  controller.
-
-config VIDEO_VS6624
-	tristate "ST VS6624 sensor support"
-	depends on VIDEO_V4L2 && I2C
-	depends on MEDIA_CAMERA_SUPPORT
-	---help---
-	  This is a Video4Linux2 sensor-level driver for the ST VS6624
-	  camera.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called vs6624.
-
-config VIDEO_MT9M032
-	tristate "MT9M032 camera sensor support"
-	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
-	depends on MEDIA_CAMERA_SUPPORT
-	select VIDEO_APTINA_PLL
-	---help---
-	  This driver supports MT9M032 camera sensors from Aptina, monochrome
-	  models only.
-
-config VIDEO_MT9P031
-	tristate "Aptina MT9P031 support"
-	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
-	depends on MEDIA_CAMERA_SUPPORT
-	select VIDEO_APTINA_PLL
-	---help---
-	  This is a Video4Linux2 sensor-level driver for the Aptina
-	  (Micron) mt9p031 5 Mpixel camera.
-
-config VIDEO_MT9T001
-	tristate "Aptina MT9T001 support"
-	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
-	depends on MEDIA_CAMERA_SUPPORT
-	---help---
-	  This is a Video4Linux2 sensor-level driver for the Aptina
-	  (Micron) mt0t001 3 Mpixel camera.
-
-config VIDEO_MT9V011
-	tristate "Micron mt9v011 sensor support"
-	depends on I2C && VIDEO_V4L2
-	depends on MEDIA_CAMERA_SUPPORT
-	---help---
-	  This is a Video4Linux2 sensor-level driver for the Micron
-	  mt0v011 1.3 Mpixel camera.  It currently only works with the
-	  em28xx driver.
-
-config VIDEO_MT9V032
-	tristate "Micron MT9V032 sensor support"
-	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
-	depends on MEDIA_CAMERA_SUPPORT
-	---help---
-	  This is a Video4Linux2 sensor-level driver for the Micron
-	  MT9V032 752x480 CMOS sensor.
-
-config VIDEO_TCM825X
-	tristate "TCM825x camera sensor support"
-	depends on I2C && VIDEO_V4L2
-	depends on MEDIA_CAMERA_SUPPORT
-	---help---
-	  This is a driver for the Toshiba TCM825x VGA camera sensor.
-	  It is used for example in Nokia N800.
-
-config VIDEO_SR030PC30
-	tristate "Siliconfile SR030PC30 sensor support"
-	depends on I2C && VIDEO_V4L2
-	depends on MEDIA_CAMERA_SUPPORT
-	---help---
-	  This driver supports SR030PC30 VGA camera from Siliconfile
-
-config VIDEO_NOON010PC30
-	tristate "Siliconfile NOON010PC30 sensor support"
-	depends on I2C && VIDEO_V4L2 && EXPERIMENTAL && VIDEO_V4L2_SUBDEV_API
-	depends on MEDIA_CAMERA_SUPPORT
-	---help---
-	  This driver supports NOON010PC30 CIF camera from Siliconfile
-
-source "drivers/media/video/m5mols/Kconfig"
-
-config VIDEO_S5K6AA
-	tristate "Samsung S5K6AAFX sensor support"
-	depends on MEDIA_CAMERA_SUPPORT
-	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
-	---help---
-	  This is a V4L2 sensor-level driver for Samsung S5K6AA(FX) 1.3M
-	  camera sensor with an embedded SoC image signal processor.
-
-source "drivers/media/video/smiapp/Kconfig"
-
-comment "Flash devices"
-
-config VIDEO_ADP1653
-	tristate "ADP1653 flash support"
-	depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
-	depends on MEDIA_CAMERA_SUPPORT
-	---help---
-	  This is a driver for the ADP1653 flash controller. It is used for
-	  example in Nokia N900.
-
-config VIDEO_AS3645A
-	tristate "AS3645A flash driver support"
-	depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
-	depends on MEDIA_CAMERA_SUPPORT
-	---help---
-	  This is a driver for the AS3645A and LM3555 flash controllers. It has
-	  build in control for flash, torch and indicator LEDs.
-
-comment "Video improvement chips"
-
-config VIDEO_UPD64031A
-	tristate "NEC Electronics uPD64031A Ghost Reduction"
-	depends on VIDEO_V4L2 && I2C
-	---help---
-	  Support for the NEC Electronics uPD64031A Ghost Reduction
-	  video chip. It is most often found in NTSC TV cards made for
-	  Japan and is used to reduce the 'ghosting' effect that can
-	  be present in analog TV broadcasts.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called upd64031a.
-
-config VIDEO_UPD64083
-	tristate "NEC Electronics uPD64083 3-Dimensional Y/C separation"
-	depends on VIDEO_V4L2 && I2C
-	---help---
-	  Support for the NEC Electronics uPD64083 3-Dimensional Y/C
-	  separation video chip. It is used to improve the quality of
-	  the colors of a composite signal.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called upd64083.
-
-comment "Miscelaneous helper chips"
-
-config VIDEO_THS7303
-	tristate "THS7303 Video Amplifier"
-	depends on I2C
-	help
-	  Support for TI THS7303 video amplifier
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called ths7303.
-
-config VIDEO_M52790
-	tristate "Mitsubishi M52790 A/V switch"
-	depends on VIDEO_V4L2 && I2C
-	---help---
-	 Support for the Mitsubishi M52790 A/V switch.
-
-	 To compile this driver as a module, choose M here: the
-	 module will be called m52790.
-
-endmenu # encoder / decoder chips
+if MEDIA_CAMERA_SUPPORT
 
 config VIDEO_VIVI
 	tristate "Virtual Video Driver"
@@ -877,7 +303,6 @@ source "drivers/media/video/s5p-fimc/Kconfig"
 source "drivers/media/video/s5p-tv/Kconfig"
 
 endif # V4L_PLATFORM_DRIVERS
-endif # VIDEO_CAPTURE_DRIVERS
 
 menuconfig V4L_MEM2MEM_DRIVERS
 	bool "Memory-to-memory multimedia devices"
@@ -955,3 +380,5 @@ config VIDEO_MX2_EMMAPRP
 	    conversion.
 
 endif # V4L_MEM2MEM_DRIVERS
+
+endif # MEDIA_CAMERA_SUPPORT
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index a0c6692..52a04fa 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -2,73 +2,9 @@
 # Makefile for the video capture/playback device drivers.
 #
 
-msp3400-objs	:=	msp3400-driver.o msp3400-kthreads.o
-
 omap2cam-objs	:=	omap24xxcam.o omap24xxcam-dma.o
 
-# Helper modules
-
-obj-$(CONFIG_VIDEO_APTINA_PLL) += aptina-pll.o
-
-# All i2c modules must come first:
-
-obj-$(CONFIG_VIDEO_TVAUDIO) += tvaudio.o
-obj-$(CONFIG_VIDEO_TDA7432) += tda7432.o
-obj-$(CONFIG_VIDEO_SAA6588) += saa6588.o
-obj-$(CONFIG_VIDEO_TDA9840) += tda9840.o
-obj-$(CONFIG_VIDEO_TEA6415C) += tea6415c.o
-obj-$(CONFIG_VIDEO_TEA6420) += tea6420.o
-obj-$(CONFIG_VIDEO_SAA7110) += saa7110.o
-obj-$(CONFIG_VIDEO_SAA711X) += saa7115.o
-obj-$(CONFIG_VIDEO_SAA717X) += saa717x.o
-obj-$(CONFIG_VIDEO_SAA7127) += saa7127.o
-obj-$(CONFIG_VIDEO_SAA7185) += saa7185.o
-obj-$(CONFIG_VIDEO_SAA7191) += saa7191.o
-obj-$(CONFIG_VIDEO_ADV7170) += adv7170.o
-obj-$(CONFIG_VIDEO_ADV7175) += adv7175.o
-obj-$(CONFIG_VIDEO_ADV7180) += adv7180.o
-obj-$(CONFIG_VIDEO_ADV7183) += adv7183.o
-obj-$(CONFIG_VIDEO_ADV7343) += adv7343.o
-obj-$(CONFIG_VIDEO_ADV7393) += adv7393.o
-obj-$(CONFIG_VIDEO_VPX3220) += vpx3220.o
-obj-$(CONFIG_VIDEO_VS6624)  += vs6624.o
-obj-$(CONFIG_VIDEO_BT819) += bt819.o
-obj-$(CONFIG_VIDEO_BT856) += bt856.o
-obj-$(CONFIG_VIDEO_BT866) += bt866.o
-obj-$(CONFIG_VIDEO_KS0127) += ks0127.o
-obj-$(CONFIG_VIDEO_THS7303) += ths7303.o
 obj-$(CONFIG_VIDEO_VINO) += indycam.o
-obj-$(CONFIG_VIDEO_TVP5150) += tvp5150.o
-obj-$(CONFIG_VIDEO_TVP514X) += tvp514x.o
-obj-$(CONFIG_VIDEO_TVP7002) += tvp7002.o
-obj-$(CONFIG_VIDEO_MSP3400) += msp3400.o
-obj-$(CONFIG_VIDEO_CS5345) += cs5345.o
-obj-$(CONFIG_VIDEO_CS53L32A) += cs53l32a.o
-obj-$(CONFIG_VIDEO_M52790) += m52790.o
-obj-$(CONFIG_VIDEO_TLV320AIC23B) += tlv320aic23b.o
-obj-$(CONFIG_VIDEO_WM8775) += wm8775.o
-obj-$(CONFIG_VIDEO_WM8739) += wm8739.o
-obj-$(CONFIG_VIDEO_VP27SMPX) += vp27smpx.o
-obj-$(CONFIG_VIDEO_CX25840) += cx25840/
-obj-$(CONFIG_VIDEO_UPD64031A) += upd64031a.o
-obj-$(CONFIG_VIDEO_UPD64083) += upd64083.o
-obj-$(CONFIG_VIDEO_OV7670) 	+= ov7670.o
-obj-$(CONFIG_VIDEO_TCM825X) += tcm825x.o
-obj-$(CONFIG_VIDEO_TVEEPROM) += tveeprom.o
-obj-$(CONFIG_VIDEO_MT9M032) += mt9m032.o
-obj-$(CONFIG_VIDEO_MT9P031) += mt9p031.o
-obj-$(CONFIG_VIDEO_MT9T001) += mt9t001.o
-obj-$(CONFIG_VIDEO_MT9V011) += mt9v011.o
-obj-$(CONFIG_VIDEO_MT9V032) += mt9v032.o
-obj-$(CONFIG_VIDEO_SR030PC30)	+= sr030pc30.o
-obj-$(CONFIG_VIDEO_NOON010PC30)	+= noon010pc30.o
-obj-$(CONFIG_VIDEO_M5MOLS)	+= m5mols/
-obj-$(CONFIG_VIDEO_S5K6AA)	+= s5k6aa.o
-obj-$(CONFIG_VIDEO_SMIAPP)	+= smiapp/
-obj-$(CONFIG_VIDEO_ADP1653)	+= adp1653.o
-obj-$(CONFIG_VIDEO_AS3645A)	+= as3645a.o
-
-obj-$(CONFIG_VIDEO_SMIAPP_PLL)	+= smiapp-pll.o
 
 obj-$(CONFIG_SOC_CAMERA_IMX074)		+= imx074.o
 obj-$(CONFIG_SOC_CAMERA_MT9M001)	+= mt9m001.o
@@ -85,16 +21,12 @@ obj-$(CONFIG_SOC_CAMERA_OV9740)		+= ov9740.o
 obj-$(CONFIG_SOC_CAMERA_RJ54N1)		+= rj54n1cb0c.o
 obj-$(CONFIG_SOC_CAMERA_TW9910)		+= tw9910.o
 
-# And now the v4l2 drivers:
-
 obj-$(CONFIG_VIDEO_VINO) += vino.o
 obj-$(CONFIG_VIDEO_TIMBERDALE)	+= timblogiw.o
 
-obj-$(CONFIG_VIDEO_BTCX)  += btcx-risc.o
 
 obj-$(CONFIG_VIDEO_M32R_AR_M64278) += arv.o
 
-obj-$(CONFIG_VIDEO_CX2341X) += cx2341x.o
 
 obj-$(CONFIG_VIDEO_CAFE_CCIC) += marvell-ccic/
 obj-$(CONFIG_VIDEO_MMP_CAMERA) += marvell-ccic/
@@ -107,7 +39,6 @@ obj-$(CONFIG_VIDEO_VIU) += fsl-viu.o
 obj-$(CONFIG_VIDEO_VIVI) += vivi.o
 obj-$(CONFIG_VIDEO_MEM2MEM_TESTDEV) += mem2mem_testdev.o
 
-obj-$(CONFIG_VIDEO_AK881X)		+= ak881x.o
 
 obj-$(CONFIG_VIDEO_OMAP2)		+= omap2cam.o
 obj-$(CONFIG_SOC_CAMERA)		+= soc_camera.o soc_mediabus.o
@@ -140,8 +71,6 @@ obj-$(CONFIG_ARCH_DAVINCI)		+= davinci/
 
 obj-$(CONFIG_VIDEO_SH_VOU)		+= sh_vou.o
 
-obj-$(CONFIG_VIDEO_IR_I2C)  += ir-kbd-i2c.o
-
 obj-y	+= davinci/
 
 obj-$(CONFIG_ARCH_OMAP)	+= omap/
-- 
1.7.11.2

