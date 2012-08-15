Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17111 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754917Ab2HONsZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Aug 2012 09:48:25 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q7FDmPGQ011265
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 15 Aug 2012 09:48:25 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 03/12] [media] bt8xx: move analog TV part to be together with DTV one
Date: Wed, 15 Aug 2012 10:48:11 -0300
Message-Id: <1345038500-28734-4-git-send-email-mchehab@redhat.com>
In-Reply-To: <1345038500-28734-1-git-send-email-mchehab@redhat.com>
References: <502AC079.50902@gmail.com>
 <1345038500-28734-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/pci/bt8xx/Kconfig                    | 23 +++++++++++++++++-
 drivers/media/pci/bt8xx/Makefile                   |  7 +++++-
 drivers/media/{video => pci}/bt8xx/bt848.h         |  0
 .../media/{video => pci}/bt8xx/bttv-audio-hook.c   |  0
 .../media/{video => pci}/bt8xx/bttv-audio-hook.h   |  0
 drivers/media/{video => pci}/bt8xx/bttv-cards.c    |  0
 drivers/media/{video => pci}/bt8xx/bttv-driver.c   |  0
 drivers/media/{video => pci}/bt8xx/bttv-gpio.c     |  0
 drivers/media/{video => pci}/bt8xx/bttv-i2c.c      |  0
 drivers/media/{video => pci}/bt8xx/bttv-if.c       |  0
 drivers/media/{video => pci}/bt8xx/bttv-input.c    |  0
 drivers/media/{video => pci}/bt8xx/bttv-risc.c     |  0
 drivers/media/{video => pci}/bt8xx/bttv-vbi.c      |  0
 drivers/media/{video => pci}/bt8xx/bttv.h          |  0
 drivers/media/{video => pci}/bt8xx/bttvp.h         |  0
 drivers/media/video/Kconfig                        |  2 --
 drivers/media/video/Makefile                       |  1 -
 drivers/media/video/bt8xx/Kconfig                  | 27 ----------------------
 drivers/media/video/bt8xx/Makefile                 | 13 -----------
 19 files changed, 28 insertions(+), 45 deletions(-)
 rename drivers/media/{video => pci}/bt8xx/bt848.h (100%)
 rename drivers/media/{video => pci}/bt8xx/bttv-audio-hook.c (100%)
 rename drivers/media/{video => pci}/bt8xx/bttv-audio-hook.h (100%)
 rename drivers/media/{video => pci}/bt8xx/bttv-cards.c (100%)
 rename drivers/media/{video => pci}/bt8xx/bttv-driver.c (100%)
 rename drivers/media/{video => pci}/bt8xx/bttv-gpio.c (100%)
 rename drivers/media/{video => pci}/bt8xx/bttv-i2c.c (100%)
 rename drivers/media/{video => pci}/bt8xx/bttv-if.c (100%)
 rename drivers/media/{video => pci}/bt8xx/bttv-input.c (100%)
 rename drivers/media/{video => pci}/bt8xx/bttv-risc.c (100%)
 rename drivers/media/{video => pci}/bt8xx/bttv-vbi.c (100%)
 rename drivers/media/{video => pci}/bt8xx/bttv.h (100%)
 rename drivers/media/{video => pci}/bt8xx/bttvp.h (100%)
 delete mode 100644 drivers/media/video/bt8xx/Kconfig
 delete mode 100644 drivers/media/video/bt8xx/Makefile

diff --git a/drivers/media/pci/bt8xx/Kconfig b/drivers/media/pci/bt8xx/Kconfig
index 8668e63..f2667a5 100644
--- a/drivers/media/pci/bt8xx/Kconfig
+++ b/drivers/media/pci/bt8xx/Kconfig
@@ -1,5 +1,26 @@
+config VIDEO_BT848
+	tristate "BT848 Video For Linux"
+	depends on VIDEO_DEV && PCI && I2C && VIDEO_V4L2
+	select I2C_ALGOBIT
+	select VIDEO_BTCX
+	select VIDEOBUF_DMA_SG
+	depends on RC_CORE
+	select VIDEO_TUNER
+	select VIDEO_TVEEPROM
+	select VIDEO_MSP3400 if VIDEO_HELPER_CHIPS_AUTO
+	select VIDEO_TVAUDIO if VIDEO_HELPER_CHIPS_AUTO
+	select VIDEO_TDA7432 if VIDEO_HELPER_CHIPS_AUTO
+	select VIDEO_SAA6588 if VIDEO_HELPER_CHIPS_AUTO
+	---help---
+	  Support for BT848 based frame grabber/overlay boards. This includes
+	  the Miro, Hauppauge and STB boards. Please read the material in
+	  <file:Documentation/video4linux/bttv/> for more information.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called bttv.
+
 config DVB_BT8XX
-	tristate "BT8xx based PCI cards"
+	tristate "DVB/ATSC Support for bt878 based TV cards"
 	depends on DVB_CORE && PCI && I2C && VIDEO_BT848
 	select DVB_MT352 if !DVB_FE_CUSTOMISE
 	select DVB_SP887X if !DVB_FE_CUSTOMISE
diff --git a/drivers/media/pci/bt8xx/Makefile b/drivers/media/pci/bt8xx/Makefile
index c008d0c..ae347b7 100644
--- a/drivers/media/pci/bt8xx/Makefile
+++ b/drivers/media/pci/bt8xx/Makefile
@@ -1,6 +1,11 @@
+bttv-objs      :=      bttv-driver.o bttv-cards.o bttv-if.o \
+		       bttv-risc.o bttv-vbi.o bttv-i2c.o bttv-gpio.o \
+		       bttv-input.o bttv-audio-hook.o
+
+obj-$(CONFIG_VIDEO_BT848) += bttv.o
 obj-$(CONFIG_DVB_BT8XX) += bt878.o dvb-bt8xx.o dst.o dst_ca.o
 
 ccflags-y += -Idrivers/media/dvb-core
 ccflags-y += -Idrivers/media/dvb-frontends
-ccflags-y += -Idrivers/media/video/bt8xx
+ccflags-y += -Idrivers/media/video
 ccflags-y += -Idrivers/media/tuners
diff --git a/drivers/media/video/bt8xx/bt848.h b/drivers/media/pci/bt8xx/bt848.h
similarity index 100%
rename from drivers/media/video/bt8xx/bt848.h
rename to drivers/media/pci/bt8xx/bt848.h
diff --git a/drivers/media/video/bt8xx/bttv-audio-hook.c b/drivers/media/pci/bt8xx/bttv-audio-hook.c
similarity index 100%
rename from drivers/media/video/bt8xx/bttv-audio-hook.c
rename to drivers/media/pci/bt8xx/bttv-audio-hook.c
diff --git a/drivers/media/video/bt8xx/bttv-audio-hook.h b/drivers/media/pci/bt8xx/bttv-audio-hook.h
similarity index 100%
rename from drivers/media/video/bt8xx/bttv-audio-hook.h
rename to drivers/media/pci/bt8xx/bttv-audio-hook.h
diff --git a/drivers/media/video/bt8xx/bttv-cards.c b/drivers/media/pci/bt8xx/bttv-cards.c
similarity index 100%
rename from drivers/media/video/bt8xx/bttv-cards.c
rename to drivers/media/pci/bt8xx/bttv-cards.c
diff --git a/drivers/media/video/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
similarity index 100%
rename from drivers/media/video/bt8xx/bttv-driver.c
rename to drivers/media/pci/bt8xx/bttv-driver.c
diff --git a/drivers/media/video/bt8xx/bttv-gpio.c b/drivers/media/pci/bt8xx/bttv-gpio.c
similarity index 100%
rename from drivers/media/video/bt8xx/bttv-gpio.c
rename to drivers/media/pci/bt8xx/bttv-gpio.c
diff --git a/drivers/media/video/bt8xx/bttv-i2c.c b/drivers/media/pci/bt8xx/bttv-i2c.c
similarity index 100%
rename from drivers/media/video/bt8xx/bttv-i2c.c
rename to drivers/media/pci/bt8xx/bttv-i2c.c
diff --git a/drivers/media/video/bt8xx/bttv-if.c b/drivers/media/pci/bt8xx/bttv-if.c
similarity index 100%
rename from drivers/media/video/bt8xx/bttv-if.c
rename to drivers/media/pci/bt8xx/bttv-if.c
diff --git a/drivers/media/video/bt8xx/bttv-input.c b/drivers/media/pci/bt8xx/bttv-input.c
similarity index 100%
rename from drivers/media/video/bt8xx/bttv-input.c
rename to drivers/media/pci/bt8xx/bttv-input.c
diff --git a/drivers/media/video/bt8xx/bttv-risc.c b/drivers/media/pci/bt8xx/bttv-risc.c
similarity index 100%
rename from drivers/media/video/bt8xx/bttv-risc.c
rename to drivers/media/pci/bt8xx/bttv-risc.c
diff --git a/drivers/media/video/bt8xx/bttv-vbi.c b/drivers/media/pci/bt8xx/bttv-vbi.c
similarity index 100%
rename from drivers/media/video/bt8xx/bttv-vbi.c
rename to drivers/media/pci/bt8xx/bttv-vbi.c
diff --git a/drivers/media/video/bt8xx/bttv.h b/drivers/media/pci/bt8xx/bttv.h
similarity index 100%
rename from drivers/media/video/bt8xx/bttv.h
rename to drivers/media/pci/bt8xx/bttv.h
diff --git a/drivers/media/video/bt8xx/bttvp.h b/drivers/media/pci/bt8xx/bttvp.h
similarity index 100%
rename from drivers/media/video/bt8xx/bttvp.h
rename to drivers/media/pci/bt8xx/bttvp.h
diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index f527992..f3d4228 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -619,8 +619,6 @@ menuconfig V4L_PCI_DRIVERS
 
 if V4L_PCI_DRIVERS
 
-source "drivers/media/video/bt8xx/Kconfig"
-
 source "drivers/media/video/cx18/Kconfig"
 
 source "drivers/media/video/cx23885/Kconfig"
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 4ad5bd9..df60ffa 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -87,7 +87,6 @@ obj-$(CONFIG_SOC_CAMERA_TW9910)		+= tw9910.o
 
 # And now the v4l2 drivers:
 
-obj-$(CONFIG_VIDEO_BT848) += bt8xx/
 obj-$(CONFIG_VIDEO_ZORAN) += zoran/
 obj-$(CONFIG_VIDEO_CQCAM) += c-qcam.o
 obj-$(CONFIG_VIDEO_BWQCAM) += bw-qcam.o
diff --git a/drivers/media/video/bt8xx/Kconfig b/drivers/media/video/bt8xx/Kconfig
deleted file mode 100644
index 7da5c2e..0000000
--- a/drivers/media/video/bt8xx/Kconfig
+++ /dev/null
@@ -1,27 +0,0 @@
-config VIDEO_BT848
-	tristate "BT848 Video For Linux"
-	depends on VIDEO_DEV && PCI && I2C && VIDEO_V4L2
-	select I2C_ALGOBIT
-	select VIDEO_BTCX
-	select VIDEOBUF_DMA_SG
-	depends on RC_CORE
-	select VIDEO_TUNER
-	select VIDEO_TVEEPROM
-	select VIDEO_MSP3400 if VIDEO_HELPER_CHIPS_AUTO
-	select VIDEO_TVAUDIO if VIDEO_HELPER_CHIPS_AUTO
-	select VIDEO_TDA7432 if VIDEO_HELPER_CHIPS_AUTO
-	select VIDEO_SAA6588 if VIDEO_HELPER_CHIPS_AUTO
-	---help---
-	  Support for BT848 based frame grabber/overlay boards. This includes
-	  the Miro, Hauppauge and STB boards. Please read the material in
-	  <file:Documentation/video4linux/bttv/> for more information.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called bttv.
-
-config VIDEO_BT848_DVB
-	bool "DVB/ATSC Support for bt878 based TV cards"
-	depends on VIDEO_BT848 && DVB_CORE
-	select DVB_BT8XX
-	---help---
-	  This adds support for DVB/ATSC cards based on the BT878 chip.
diff --git a/drivers/media/video/bt8xx/Makefile b/drivers/media/video/bt8xx/Makefile
deleted file mode 100644
index f6351a2..0000000
--- a/drivers/media/video/bt8xx/Makefile
+++ /dev/null
@@ -1,13 +0,0 @@
-#
-# Makefile for the video capture/playback device drivers.
-#
-
-bttv-objs      :=      bttv-driver.o bttv-cards.o bttv-if.o \
-		       bttv-risc.o bttv-vbi.o bttv-i2c.o bttv-gpio.o \
-		       bttv-input.o bttv-audio-hook.o
-
-obj-$(CONFIG_VIDEO_BT848) += bttv.o
-
-ccflags-y += -Idrivers/media/video
-ccflags-y += -Idrivers/media/tuners
-ccflags-y += -Idrivers/media/dvb-core
-- 
1.7.11.2

