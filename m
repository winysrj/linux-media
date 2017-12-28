Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:49446 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753640AbdL1TV4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Dec 2017 14:21:56 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Andy Walls <awalls@md.metrocast.net>,
        Patrice Chotard <patrice.chotard@st.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mike Isely <isely@pobox.com>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Yannick Fertre <yannick.fertre@st.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Helen Koike <helen.koike@collabora.com>,
        Jacob Chen <jacob-chen@iotwrt.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 2/2] media: don't include drivers/media/i2c at cflags
Date: Thu, 28 Dec 2017 14:21:49 -0500
Message-Id: <ada795551aff6662d2322f63e55a853a58389eb5.1514488526.git.mchehab@s-opensource.com>
In-Reply-To: <fada1935590f66dc6784981e0d557ca09013c847.1514488526.git.mchehab@s-opensource.com>
References: <fada1935590f66dc6784981e0d557ca09013c847.1514488526.git.mchehab@s-opensource.com>
In-Reply-To: <fada1935590f66dc6784981e0d557ca09013c847.1514488526.git.mchehab@s-opensource.com>
References: <fada1935590f66dc6784981e0d557ca09013c847.1514488526.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Most of the I2C headers got moved a long time ago to
include/media/i2c. Stop including them at the patch.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/i2c/cx25840/Makefile            | 2 --
 drivers/media/pci/bt8xx/Makefile              | 1 -
 drivers/media/pci/cx23885/Makefile            | 1 -
 drivers/media/pci/cx25821/Makefile            | 2 --
 drivers/media/pci/cx88/Makefile               | 2 --
 drivers/media/pci/ivtv/Makefile               | 1 -
 drivers/media/pci/saa7134/Makefile            | 1 -
 drivers/media/pci/saa7164/Makefile            | 3 ---
 drivers/media/platform/Makefile               | 2 --
 drivers/media/platform/sti/c8sectpfe/Makefile | 1 -
 drivers/media/usb/cx231xx/Makefile            | 1 -
 drivers/media/usb/em28xx/Makefile             | 1 -
 drivers/media/usb/hdpvr/Makefile              | 4 ----
 drivers/media/usb/pvrusb2/Makefile            | 1 -
 drivers/media/usb/stk1160/Makefile            | 2 --
 drivers/media/usb/tm6000/Makefile             | 1 -
 drivers/media/usb/usbvision/Makefile          | 1 -
 17 files changed, 27 deletions(-)

diff --git a/drivers/media/i2c/cx25840/Makefile b/drivers/media/i2c/cx25840/Makefile
index 898eb13340ae..ac545812fc6a 100644
--- a/drivers/media/i2c/cx25840/Makefile
+++ b/drivers/media/i2c/cx25840/Makefile
@@ -2,5 +2,3 @@ cx25840-objs    := cx25840-core.o cx25840-audio.o cx25840-firmware.o \
 		   cx25840-vbi.o cx25840-ir.o
 
 obj-$(CONFIG_VIDEO_CX25840) += cx25840.o
-
-ccflags-y += -Idrivers/media/i2c
diff --git a/drivers/media/pci/bt8xx/Makefile b/drivers/media/pci/bt8xx/Makefile
index ab0ea64d3910..7f1c3beb1bbc 100644
--- a/drivers/media/pci/bt8xx/Makefile
+++ b/drivers/media/pci/bt8xx/Makefile
@@ -7,6 +7,5 @@ obj-$(CONFIG_VIDEO_BT848) += bttv.o
 obj-$(CONFIG_DVB_BT8XX) += bt878.o dvb-bt8xx.o dst.o dst_ca.o
 
 ccflags-y += -Idrivers/media/dvb-frontends
-ccflags-y += -Idrivers/media/i2c
 ccflags-y += -Idrivers/media/common
 ccflags-y += -Idrivers/media/tuners
diff --git a/drivers/media/pci/cx23885/Makefile b/drivers/media/pci/cx23885/Makefile
index 3f37dcadbaaf..130f0aa29ac6 100644
--- a/drivers/media/pci/cx23885/Makefile
+++ b/drivers/media/pci/cx23885/Makefile
@@ -8,7 +8,6 @@ cx23885-objs	:= cx23885-cards.o cx23885-video.o cx23885-vbi.o \
 obj-$(CONFIG_VIDEO_CX23885) += cx23885.o
 obj-$(CONFIG_MEDIA_ALTERA_CI) += altera-ci.o
 
-ccflags-y += -Idrivers/media/i2c
 ccflags-y += -Idrivers/media/tuners
 ccflags-y += -Idrivers/media/dvb-frontends
 
diff --git a/drivers/media/pci/cx25821/Makefile b/drivers/media/pci/cx25821/Makefile
index d14d65b1b042..94633d02ac7f 100644
--- a/drivers/media/pci/cx25821/Makefile
+++ b/drivers/media/pci/cx25821/Makefile
@@ -5,5 +5,3 @@ cx25821-y   := cx25821-core.o cx25821-cards.o cx25821-i2c.o \
 
 obj-$(CONFIG_VIDEO_CX25821) += cx25821.o
 obj-$(CONFIG_VIDEO_CX25821_ALSA) += cx25821-alsa.o
-
-ccflags-y += -Idrivers/media/i2c
diff --git a/drivers/media/pci/cx88/Makefile b/drivers/media/pci/cx88/Makefile
index dea0e7ac32e8..d0f45d652d6e 100644
--- a/drivers/media/pci/cx88/Makefile
+++ b/drivers/media/pci/cx88/Makefile
@@ -10,7 +10,5 @@ obj-$(CONFIG_VIDEO_CX88_ALSA) += cx88-alsa.o
 obj-$(CONFIG_VIDEO_CX88_BLACKBIRD) += cx88-blackbird.o
 obj-$(CONFIG_VIDEO_CX88_DVB) += cx88-dvb.o
 obj-$(CONFIG_VIDEO_CX88_VP3054) += cx88-vp3054-i2c.o
-
-ccflags-y += -Idrivers/media/i2c
 ccflags-y += -Idrivers/media/tuners
 ccflags-y += -Idrivers/media/dvb-frontends
diff --git a/drivers/media/pci/ivtv/Makefile b/drivers/media/pci/ivtv/Makefile
index 08987a5d55fc..5de95dbe3256 100644
--- a/drivers/media/pci/ivtv/Makefile
+++ b/drivers/media/pci/ivtv/Makefile
@@ -10,7 +10,6 @@ obj-$(CONFIG_VIDEO_IVTV) += ivtv.o
 obj-$(CONFIG_VIDEO_IVTV_ALSA) += ivtv-alsa.o
 obj-$(CONFIG_VIDEO_FB_IVTV) += ivtvfb.o
 
-ccflags-y += -I$(srctree)/drivers/media/i2c
 ccflags-y += -I$(srctree)/drivers/media/tuners
 ccflags-y += -I$(srctree)/drivers/media/dvb-frontends
 
diff --git a/drivers/media/pci/saa7134/Makefile b/drivers/media/pci/saa7134/Makefile
index 959f2766b093..82ac7f31221b 100644
--- a/drivers/media/pci/saa7134/Makefile
+++ b/drivers/media/pci/saa7134/Makefile
@@ -12,7 +12,6 @@ obj-$(CONFIG_VIDEO_SAA7134_ALSA) += saa7134-alsa.o
 
 obj-$(CONFIG_VIDEO_SAA7134_DVB) += saa7134-dvb.o
 
-ccflags-y += -I$(srctree)/drivers/media/i2c
 ccflags-y += -I$(srctree)/drivers/media/tuners
 ccflags-y += -I$(srctree)/drivers/media/dvb-frontends
 ccflags-y += -I$(srctree)/drivers/media/usb/go7007
diff --git a/drivers/media/pci/saa7164/Makefile b/drivers/media/pci/saa7164/Makefile
index 54840d659a5d..dea076744ec9 100644
--- a/drivers/media/pci/saa7164/Makefile
+++ b/drivers/media/pci/saa7164/Makefile
@@ -5,8 +5,5 @@ saa7164-objs	:= saa7164-cards.o saa7164-core.o saa7164-i2c.o saa7164-dvb.o \
 
 obj-$(CONFIG_VIDEO_SAA7164) += saa7164.o
 
-ccflags-y += -I$(srctree)/drivers/media/i2c
 ccflags-y += -I$(srctree)/drivers/media/tuners
 ccflags-y += -I$(srctree)/drivers/media/dvb-frontends
-
-ccflags-y += $(extra-cflags-y) $(extra-cflags-m)
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index 003b0bb2cddf..347fba8177b5 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -82,8 +82,6 @@ obj-$(CONFIG_VIDEO_ATMEL_ISI)		+= atmel/
 
 obj-$(CONFIG_VIDEO_STM32_DCMI)		+= stm32/
 
-ccflags-y += -I$(srctree)/drivers/media/i2c
-
 obj-$(CONFIG_VIDEO_MEDIATEK_VPU)	+= mtk-vpu/
 
 obj-$(CONFIG_VIDEO_MEDIATEK_VCODEC)	+= mtk-vcodec/
diff --git a/drivers/media/platform/sti/c8sectpfe/Makefile b/drivers/media/platform/sti/c8sectpfe/Makefile
index 927dd930c943..34d69472b6f0 100644
--- a/drivers/media/platform/sti/c8sectpfe/Makefile
+++ b/drivers/media/platform/sti/c8sectpfe/Makefile
@@ -4,7 +4,6 @@ c8sectpfe-y += c8sectpfe-core.o c8sectpfe-common.o c8sectpfe-dvb.o \
 
 obj-$(CONFIG_DVB_C8SECTPFE) += c8sectpfe.o
 
-ccflags-y += -Idrivers/media/i2c
 ccflags-y += -Idrivers/media/common
 ccflags-y += -Idrivers/media/dvb-frontends/
 ccflags-y += -Idrivers/media/tuners/
diff --git a/drivers/media/usb/cx231xx/Makefile b/drivers/media/usb/cx231xx/Makefile
index 79cf46eb151a..c023d97407de 100644
--- a/drivers/media/usb/cx231xx/Makefile
+++ b/drivers/media/usb/cx231xx/Makefile
@@ -9,7 +9,6 @@ obj-$(CONFIG_VIDEO_CX231XX) += cx231xx.o
 obj-$(CONFIG_VIDEO_CX231XX_ALSA) += cx231xx-alsa.o
 obj-$(CONFIG_VIDEO_CX231XX_DVB) += cx231xx-dvb.o
 
-ccflags-y += -Idrivers/media/i2c
 ccflags-y += -Idrivers/media/tuners
 ccflags-y += -Idrivers/media/dvb-frontends
 ccflags-y += -Idrivers/media/usb/dvb-usb
diff --git a/drivers/media/usb/em28xx/Makefile b/drivers/media/usb/em28xx/Makefile
index c3d3570584e1..8a224007d755 100644
--- a/drivers/media/usb/em28xx/Makefile
+++ b/drivers/media/usb/em28xx/Makefile
@@ -11,6 +11,5 @@ obj-$(CONFIG_VIDEO_EM28XX_ALSA) += em28xx-alsa.o
 obj-$(CONFIG_VIDEO_EM28XX_DVB) += em28xx-dvb.o
 obj-$(CONFIG_VIDEO_EM28XX_RC) += em28xx-rc.o
 
-ccflags-y += -Idrivers/media/i2c
 ccflags-y += -Idrivers/media/tuners
 ccflags-y += -Idrivers/media/dvb-frontends
diff --git a/drivers/media/usb/hdpvr/Makefile b/drivers/media/usb/hdpvr/Makefile
index 9b8d1463c526..644dd99ffce3 100644
--- a/drivers/media/usb/hdpvr/Makefile
+++ b/drivers/media/usb/hdpvr/Makefile
@@ -1,7 +1,3 @@
 hdpvr-objs	:= hdpvr-control.o hdpvr-core.o hdpvr-video.o hdpvr-i2c.o
 
 obj-$(CONFIG_VIDEO_HDPVR) += hdpvr.o
-
-ccflags-y += -Idrivers/media/i2c
-
-ccflags-y += $(extra-cflags-y) $(extra-cflags-m)
diff --git a/drivers/media/usb/pvrusb2/Makefile b/drivers/media/usb/pvrusb2/Makefile
index 552e4f12c496..9facf6873404 100644
--- a/drivers/media/usb/pvrusb2/Makefile
+++ b/drivers/media/usb/pvrusb2/Makefile
@@ -17,6 +17,5 @@ pvrusb2-objs	:= pvrusb2-i2c-core.o \
 
 obj-$(CONFIG_VIDEO_PVRUSB2) += pvrusb2.o
 
-ccflags-y += -Idrivers/media/i2c
 ccflags-y += -Idrivers/media/tuners
 ccflags-y += -Idrivers/media/dvb-frontends
diff --git a/drivers/media/usb/stk1160/Makefile b/drivers/media/usb/stk1160/Makefile
index 613471528749..8e6c22fb1803 100644
--- a/drivers/media/usb/stk1160/Makefile
+++ b/drivers/media/usb/stk1160/Makefile
@@ -6,5 +6,3 @@ stk1160-y := 	stk1160-core.o \
 		stk1160-ac97.o
 
 obj-$(CONFIG_VIDEO_STK1160) += stk1160.o
-
-ccflags-y += -Idrivers/media/i2c
diff --git a/drivers/media/usb/tm6000/Makefile b/drivers/media/usb/tm6000/Makefile
index 62f8528daef2..744c039e621a 100644
--- a/drivers/media/usb/tm6000/Makefile
+++ b/drivers/media/usb/tm6000/Makefile
@@ -10,6 +10,5 @@ obj-$(CONFIG_VIDEO_TM6000) += tm6000.o
 obj-$(CONFIG_VIDEO_TM6000_ALSA) += tm6000-alsa.o
 obj-$(CONFIG_VIDEO_TM6000_DVB) += tm6000-dvb.o
 
-ccflags-y += -Idrivers/media/i2c
 ccflags-y += -Idrivers/media/tuners
 ccflags-y += -Idrivers/media/dvb-frontends
diff --git a/drivers/media/usb/usbvision/Makefile b/drivers/media/usb/usbvision/Makefile
index 9b3a5581df42..494d030b4979 100644
--- a/drivers/media/usb/usbvision/Makefile
+++ b/drivers/media/usb/usbvision/Makefile
@@ -2,5 +2,4 @@ usbvision-objs  := usbvision-core.o usbvision-video.o usbvision-i2c.o usbvision-
 
 obj-$(CONFIG_VIDEO_USBVISION) += usbvision.o
 
-ccflags-y += -Idrivers/media/i2c
 ccflags-y += -Idrivers/media/tuners
-- 
2.14.3
