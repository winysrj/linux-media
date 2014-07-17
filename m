Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1554 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758651AbaGQXks (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 19:40:48 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	pete@sensoray.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH for v3.17 4/4] solo6x10: move out of staging into drivers/media/pci.
Date: Fri, 18 Jul 2014 01:40:23 +0200
Message-Id: <1405640423-1037-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1405640423-1037-1-git-send-email-hverkuil@xs4all.nl>
References: <1405640423-1037-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Now that the custom motion detection API has been replaced with a
standard API there is no reason anymore to keep it in staging.

So (finally!) move it to drivers/media/pci.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/Kconfig                                         | 1 +
 drivers/media/pci/Makefile                                        | 1 +
 drivers/{staging/media => media/pci}/solo6x10/Kconfig             | 2 +-
 drivers/{staging/media => media/pci}/solo6x10/Makefile            | 2 +-
 drivers/{staging/media => media/pci}/solo6x10/TODO                | 0
 drivers/{staging/media => media/pci}/solo6x10/solo6x10-core.c     | 0
 drivers/{staging/media => media/pci}/solo6x10/solo6x10-disp.c     | 0
 drivers/{staging/media => media/pci}/solo6x10/solo6x10-eeprom.c   | 0
 drivers/{staging/media => media/pci}/solo6x10/solo6x10-enc.c      | 0
 drivers/{staging/media => media/pci}/solo6x10/solo6x10-g723.c     | 0
 drivers/{staging/media => media/pci}/solo6x10/solo6x10-gpio.c     | 0
 drivers/{staging/media => media/pci}/solo6x10/solo6x10-i2c.c      | 0
 drivers/{staging/media => media/pci}/solo6x10/solo6x10-jpeg.h     | 0
 drivers/{staging/media => media/pci}/solo6x10/solo6x10-offsets.h  | 0
 drivers/{staging/media => media/pci}/solo6x10/solo6x10-p2m.c      | 0
 drivers/{staging/media => media/pci}/solo6x10/solo6x10-regs.h     | 0
 drivers/{staging/media => media/pci}/solo6x10/solo6x10-tw28.c     | 0
 drivers/{staging/media => media/pci}/solo6x10/solo6x10-tw28.h     | 0
 drivers/{staging/media => media/pci}/solo6x10/solo6x10-v4l2-enc.c | 0
 drivers/{staging/media => media/pci}/solo6x10/solo6x10-v4l2.c     | 0
 drivers/{staging/media => media/pci}/solo6x10/solo6x10.h          | 0
 drivers/staging/media/Kconfig                                     | 2 --
 drivers/staging/media/Makefile                                    | 1 -
 23 files changed, 4 insertions(+), 5 deletions(-)
 rename drivers/{staging/media => media/pci}/solo6x10/Kconfig (96%)
 rename drivers/{staging/media => media/pci}/solo6x10/Makefile (82%)
 rename drivers/{staging/media => media/pci}/solo6x10/TODO (100%)
 rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-core.c (100%)
 rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-disp.c (100%)
 rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-eeprom.c (100%)
 rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-enc.c (100%)
 rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-g723.c (100%)
 rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-gpio.c (100%)
 rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-i2c.c (100%)
 rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-jpeg.h (100%)
 rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-offsets.h (100%)
 rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-p2m.c (100%)
 rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-regs.h (100%)
 rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-tw28.c (100%)
 rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-tw28.h (100%)
 rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-v4l2-enc.c (100%)
 rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-v4l2.c (100%)
 rename drivers/{staging/media => media/pci}/solo6x10/solo6x10.h (100%)

diff --git a/drivers/media/pci/Kconfig b/drivers/media/pci/Kconfig
index 53196f1..5c16c9c 100644
--- a/drivers/media/pci/Kconfig
+++ b/drivers/media/pci/Kconfig
@@ -19,6 +19,7 @@ if MEDIA_ANALOG_TV_SUPPORT
 source "drivers/media/pci/ivtv/Kconfig"
 source "drivers/media/pci/zoran/Kconfig"
 source "drivers/media/pci/saa7146/Kconfig"
+source "drivers/media/pci/solo6x10/Kconfig"
 endif
 
 if MEDIA_ANALOG_TV_SUPPORT || MEDIA_DIGITAL_TV_SUPPORT
diff --git a/drivers/media/pci/Makefile b/drivers/media/pci/Makefile
index 35cc578..e5b53fb 100644
--- a/drivers/media/pci/Makefile
+++ b/drivers/media/pci/Makefile
@@ -24,3 +24,4 @@ obj-$(CONFIG_VIDEO_SAA7134) += saa7134/
 obj-$(CONFIG_VIDEO_SAA7164) += saa7164/
 obj-$(CONFIG_VIDEO_MEYE) += meye/
 obj-$(CONFIG_STA2X11_VIP) += sta2x11/
+obj-$(CONFIG_VIDEO_SOLO6X10) += solo6x10/
diff --git a/drivers/staging/media/solo6x10/Kconfig b/drivers/media/pci/solo6x10/Kconfig
similarity index 96%
rename from drivers/staging/media/solo6x10/Kconfig
rename to drivers/media/pci/solo6x10/Kconfig
index 1ce2819..d9e06a6 100644
--- a/drivers/staging/media/solo6x10/Kconfig
+++ b/drivers/media/pci/solo6x10/Kconfig
@@ -1,4 +1,4 @@
-config SOLO6X10
+config VIDEO_SOLO6X10
 	tristate "Bluecherry / Softlogic 6x10 capture cards (MPEG-4/H.264)"
 	depends on PCI && VIDEO_DEV && SND && I2C
 	select BITREVERSE
diff --git a/drivers/staging/media/solo6x10/Makefile b/drivers/media/pci/solo6x10/Makefile
similarity index 82%
rename from drivers/staging/media/solo6x10/Makefile
rename to drivers/media/pci/solo6x10/Makefile
index 7aae118..f474226 100644
--- a/drivers/staging/media/solo6x10/Makefile
+++ b/drivers/media/pci/solo6x10/Makefile
@@ -2,4 +2,4 @@ solo6x10-y := solo6x10-core.o solo6x10-i2c.o solo6x10-p2m.o solo6x10-v4l2.o \
 		solo6x10-tw28.o solo6x10-gpio.o solo6x10-disp.o solo6x10-enc.o \
 		solo6x10-v4l2-enc.o solo6x10-g723.o solo6x10-eeprom.o
 
-obj-$(CONFIG_SOLO6X10) += solo6x10.o
+obj-$(CONFIG_VIDEO_SOLO6X10) += solo6x10.o
diff --git a/drivers/staging/media/solo6x10/TODO b/drivers/media/pci/solo6x10/TODO
similarity index 100%
rename from drivers/staging/media/solo6x10/TODO
rename to drivers/media/pci/solo6x10/TODO
diff --git a/drivers/staging/media/solo6x10/solo6x10-core.c b/drivers/media/pci/solo6x10/solo6x10-core.c
similarity index 100%
rename from drivers/staging/media/solo6x10/solo6x10-core.c
rename to drivers/media/pci/solo6x10/solo6x10-core.c
diff --git a/drivers/staging/media/solo6x10/solo6x10-disp.c b/drivers/media/pci/solo6x10/solo6x10-disp.c
similarity index 100%
rename from drivers/staging/media/solo6x10/solo6x10-disp.c
rename to drivers/media/pci/solo6x10/solo6x10-disp.c
diff --git a/drivers/staging/media/solo6x10/solo6x10-eeprom.c b/drivers/media/pci/solo6x10/solo6x10-eeprom.c
similarity index 100%
rename from drivers/staging/media/solo6x10/solo6x10-eeprom.c
rename to drivers/media/pci/solo6x10/solo6x10-eeprom.c
diff --git a/drivers/staging/media/solo6x10/solo6x10-enc.c b/drivers/media/pci/solo6x10/solo6x10-enc.c
similarity index 100%
rename from drivers/staging/media/solo6x10/solo6x10-enc.c
rename to drivers/media/pci/solo6x10/solo6x10-enc.c
diff --git a/drivers/staging/media/solo6x10/solo6x10-g723.c b/drivers/media/pci/solo6x10/solo6x10-g723.c
similarity index 100%
rename from drivers/staging/media/solo6x10/solo6x10-g723.c
rename to drivers/media/pci/solo6x10/solo6x10-g723.c
diff --git a/drivers/staging/media/solo6x10/solo6x10-gpio.c b/drivers/media/pci/solo6x10/solo6x10-gpio.c
similarity index 100%
rename from drivers/staging/media/solo6x10/solo6x10-gpio.c
rename to drivers/media/pci/solo6x10/solo6x10-gpio.c
diff --git a/drivers/staging/media/solo6x10/solo6x10-i2c.c b/drivers/media/pci/solo6x10/solo6x10-i2c.c
similarity index 100%
rename from drivers/staging/media/solo6x10/solo6x10-i2c.c
rename to drivers/media/pci/solo6x10/solo6x10-i2c.c
diff --git a/drivers/staging/media/solo6x10/solo6x10-jpeg.h b/drivers/media/pci/solo6x10/solo6x10-jpeg.h
similarity index 100%
rename from drivers/staging/media/solo6x10/solo6x10-jpeg.h
rename to drivers/media/pci/solo6x10/solo6x10-jpeg.h
diff --git a/drivers/staging/media/solo6x10/solo6x10-offsets.h b/drivers/media/pci/solo6x10/solo6x10-offsets.h
similarity index 100%
rename from drivers/staging/media/solo6x10/solo6x10-offsets.h
rename to drivers/media/pci/solo6x10/solo6x10-offsets.h
diff --git a/drivers/staging/media/solo6x10/solo6x10-p2m.c b/drivers/media/pci/solo6x10/solo6x10-p2m.c
similarity index 100%
rename from drivers/staging/media/solo6x10/solo6x10-p2m.c
rename to drivers/media/pci/solo6x10/solo6x10-p2m.c
diff --git a/drivers/staging/media/solo6x10/solo6x10-regs.h b/drivers/media/pci/solo6x10/solo6x10-regs.h
similarity index 100%
rename from drivers/staging/media/solo6x10/solo6x10-regs.h
rename to drivers/media/pci/solo6x10/solo6x10-regs.h
diff --git a/drivers/staging/media/solo6x10/solo6x10-tw28.c b/drivers/media/pci/solo6x10/solo6x10-tw28.c
similarity index 100%
rename from drivers/staging/media/solo6x10/solo6x10-tw28.c
rename to drivers/media/pci/solo6x10/solo6x10-tw28.c
diff --git a/drivers/staging/media/solo6x10/solo6x10-tw28.h b/drivers/media/pci/solo6x10/solo6x10-tw28.h
similarity index 100%
rename from drivers/staging/media/solo6x10/solo6x10-tw28.h
rename to drivers/media/pci/solo6x10/solo6x10-tw28.h
diff --git a/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
similarity index 100%
rename from drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
rename to drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
diff --git a/drivers/staging/media/solo6x10/solo6x10-v4l2.c b/drivers/media/pci/solo6x10/solo6x10-v4l2.c
similarity index 100%
rename from drivers/staging/media/solo6x10/solo6x10-v4l2.c
rename to drivers/media/pci/solo6x10/solo6x10-v4l2.c
diff --git a/drivers/staging/media/solo6x10/solo6x10.h b/drivers/media/pci/solo6x10/solo6x10.h
similarity index 100%
rename from drivers/staging/media/solo6x10/solo6x10.h
rename to drivers/media/pci/solo6x10/solo6x10.h
diff --git a/drivers/staging/media/Kconfig b/drivers/staging/media/Kconfig
index 6d242be..c90d950 100644
--- a/drivers/staging/media/Kconfig
+++ b/drivers/staging/media/Kconfig
@@ -33,8 +33,6 @@ source "drivers/staging/media/msi3101/Kconfig"
 
 source "drivers/staging/media/omap24xx/Kconfig"
 
-source "drivers/staging/media/solo6x10/Kconfig"
-
 source "drivers/staging/media/omap4iss/Kconfig"
 
 source "drivers/staging/media/rtl2832u_sdr/Kconfig"
diff --git a/drivers/staging/media/Makefile b/drivers/staging/media/Makefile
index 9ce9634..7c81a9f 100644
--- a/drivers/staging/media/Makefile
+++ b/drivers/staging/media/Makefile
@@ -2,7 +2,6 @@ obj-$(CONFIG_DVB_AS102)		+= as102/
 obj-$(CONFIG_I2C_BCM2048)	+= bcm2048/
 obj-$(CONFIG_DVB_CXD2099)	+= cxd2099/
 obj-$(CONFIG_LIRC_STAGING)	+= lirc/
-obj-$(CONFIG_SOLO6X10)		+= solo6x10/
 obj-$(CONFIG_VIDEO_DT3155)	+= dt3155v4l/
 obj-$(CONFIG_USB_MSI3101)	+= msi3101/
 obj-$(CONFIG_VIDEO_DM365_VPFE)	+= davinci_vpfe/
-- 
2.0.0

