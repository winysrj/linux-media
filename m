Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:2538 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758763AbaGQXkt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 19:40:49 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	pete@sensoray.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH for v3.17 2/4] go7007: move out of staging into drivers/media/usb.
Date: Fri, 18 Jul 2014 01:40:21 +0200
Message-Id: <1405640423-1037-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1405640423-1037-1-git-send-email-hverkuil@xs4all.nl>
References: <1405640423-1037-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Now that the custom motion detection API in this driver has been
replaced with a standard API there is no reason anymore to keep it
in staging. So (finally!) move it to drivers/media/usb.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/Kconfig                                    | 1 +
 drivers/media/usb/Makefile                                   | 1 +
 drivers/{staging/media => media/usb}/go7007/Kconfig          | 0
 drivers/{staging/media => media/usb}/go7007/Makefile         | 0
 drivers/{staging/media => media/usb}/go7007/README           | 0
 drivers/{staging/media => media/usb}/go7007/go7007-driver.c  | 0
 drivers/{staging/media => media/usb}/go7007/go7007-fw.c      | 0
 drivers/{staging/media => media/usb}/go7007/go7007-i2c.c     | 0
 drivers/{staging/media => media/usb}/go7007/go7007-loader.c  | 0
 drivers/{staging/media => media/usb}/go7007/go7007-priv.h    | 0
 drivers/{staging/media => media/usb}/go7007/go7007-usb.c     | 0
 drivers/{staging/media => media/usb}/go7007/go7007-v4l2.c    | 0
 drivers/{staging/media => media/usb}/go7007/go7007.txt       | 0
 drivers/{staging/media => media/usb}/go7007/s2250-board.c    | 0
 drivers/{staging/media => media/usb}/go7007/saa7134-go7007.c | 0
 drivers/{staging/media => media/usb}/go7007/snd-go7007.c     | 0
 drivers/staging/media/Kconfig                                | 2 --
 drivers/staging/media/Makefile                               | 1 -
 18 files changed, 2 insertions(+), 3 deletions(-)
 rename drivers/{staging/media => media/usb}/go7007/Kconfig (100%)
 rename drivers/{staging/media => media/usb}/go7007/Makefile (100%)
 rename drivers/{staging/media => media/usb}/go7007/README (100%)
 rename drivers/{staging/media => media/usb}/go7007/go7007-driver.c (100%)
 rename drivers/{staging/media => media/usb}/go7007/go7007-fw.c (100%)
 rename drivers/{staging/media => media/usb}/go7007/go7007-i2c.c (100%)
 rename drivers/{staging/media => media/usb}/go7007/go7007-loader.c (100%)
 rename drivers/{staging/media => media/usb}/go7007/go7007-priv.h (100%)
 rename drivers/{staging/media => media/usb}/go7007/go7007-usb.c (100%)
 rename drivers/{staging/media => media/usb}/go7007/go7007-v4l2.c (100%)
 rename drivers/{staging/media => media/usb}/go7007/go7007.txt (100%)
 rename drivers/{staging/media => media/usb}/go7007/s2250-board.c (100%)
 rename drivers/{staging/media => media/usb}/go7007/saa7134-go7007.c (100%)
 rename drivers/{staging/media => media/usb}/go7007/snd-go7007.c (100%)

diff --git a/drivers/media/usb/Kconfig b/drivers/media/usb/Kconfig
index 39d824e..52cbd90 100644
--- a/drivers/media/usb/Kconfig
+++ b/drivers/media/usb/Kconfig
@@ -27,6 +27,7 @@ source "drivers/media/usb/hdpvr/Kconfig"
 source "drivers/media/usb/tlg2300/Kconfig"
 source "drivers/media/usb/usbvision/Kconfig"
 source "drivers/media/usb/stk1160/Kconfig"
+source "drivers/media/usb/go7007/Kconfig"
 endif
 
 if (MEDIA_ANALOG_TV_SUPPORT || MEDIA_DIGITAL_TV_SUPPORT)
diff --git a/drivers/media/usb/Makefile b/drivers/media/usb/Makefile
index 7ac4b14..4eef650 100644
--- a/drivers/media/usb/Makefile
+++ b/drivers/media/usb/Makefile
@@ -20,3 +20,4 @@ obj-$(CONFIG_VIDEO_CX231XX) += cx231xx/
 obj-$(CONFIG_VIDEO_TM6000) += tm6000/
 obj-$(CONFIG_VIDEO_EM28XX) += em28xx/
 obj-$(CONFIG_VIDEO_USBTV) += usbtv/
+obj-$(CONFIG_VIDEO_GO7007) += go7007/
diff --git a/drivers/staging/media/go7007/Kconfig b/drivers/media/usb/go7007/Kconfig
similarity index 100%
rename from drivers/staging/media/go7007/Kconfig
rename to drivers/media/usb/go7007/Kconfig
diff --git a/drivers/staging/media/go7007/Makefile b/drivers/media/usb/go7007/Makefile
similarity index 100%
rename from drivers/staging/media/go7007/Makefile
rename to drivers/media/usb/go7007/Makefile
diff --git a/drivers/staging/media/go7007/README b/drivers/media/usb/go7007/README
similarity index 100%
rename from drivers/staging/media/go7007/README
rename to drivers/media/usb/go7007/README
diff --git a/drivers/staging/media/go7007/go7007-driver.c b/drivers/media/usb/go7007/go7007-driver.c
similarity index 100%
rename from drivers/staging/media/go7007/go7007-driver.c
rename to drivers/media/usb/go7007/go7007-driver.c
diff --git a/drivers/staging/media/go7007/go7007-fw.c b/drivers/media/usb/go7007/go7007-fw.c
similarity index 100%
rename from drivers/staging/media/go7007/go7007-fw.c
rename to drivers/media/usb/go7007/go7007-fw.c
diff --git a/drivers/staging/media/go7007/go7007-i2c.c b/drivers/media/usb/go7007/go7007-i2c.c
similarity index 100%
rename from drivers/staging/media/go7007/go7007-i2c.c
rename to drivers/media/usb/go7007/go7007-i2c.c
diff --git a/drivers/staging/media/go7007/go7007-loader.c b/drivers/media/usb/go7007/go7007-loader.c
similarity index 100%
rename from drivers/staging/media/go7007/go7007-loader.c
rename to drivers/media/usb/go7007/go7007-loader.c
diff --git a/drivers/staging/media/go7007/go7007-priv.h b/drivers/media/usb/go7007/go7007-priv.h
similarity index 100%
rename from drivers/staging/media/go7007/go7007-priv.h
rename to drivers/media/usb/go7007/go7007-priv.h
diff --git a/drivers/staging/media/go7007/go7007-usb.c b/drivers/media/usb/go7007/go7007-usb.c
similarity index 100%
rename from drivers/staging/media/go7007/go7007-usb.c
rename to drivers/media/usb/go7007/go7007-usb.c
diff --git a/drivers/staging/media/go7007/go7007-v4l2.c b/drivers/media/usb/go7007/go7007-v4l2.c
similarity index 100%
rename from drivers/staging/media/go7007/go7007-v4l2.c
rename to drivers/media/usb/go7007/go7007-v4l2.c
diff --git a/drivers/staging/media/go7007/go7007.txt b/drivers/media/usb/go7007/go7007.txt
similarity index 100%
rename from drivers/staging/media/go7007/go7007.txt
rename to drivers/media/usb/go7007/go7007.txt
diff --git a/drivers/staging/media/go7007/s2250-board.c b/drivers/media/usb/go7007/s2250-board.c
similarity index 100%
rename from drivers/staging/media/go7007/s2250-board.c
rename to drivers/media/usb/go7007/s2250-board.c
diff --git a/drivers/staging/media/go7007/saa7134-go7007.c b/drivers/media/usb/go7007/saa7134-go7007.c
similarity index 100%
rename from drivers/staging/media/go7007/saa7134-go7007.c
rename to drivers/media/usb/go7007/saa7134-go7007.c
diff --git a/drivers/staging/media/go7007/snd-go7007.c b/drivers/media/usb/go7007/snd-go7007.c
similarity index 100%
rename from drivers/staging/media/go7007/snd-go7007.c
rename to drivers/media/usb/go7007/snd-go7007.c
diff --git a/drivers/staging/media/Kconfig b/drivers/staging/media/Kconfig
index cd2af376..6d242be 100644
--- a/drivers/staging/media/Kconfig
+++ b/drivers/staging/media/Kconfig
@@ -29,8 +29,6 @@ source "drivers/staging/media/davinci_vpfe/Kconfig"
 
 source "drivers/staging/media/dt3155v4l/Kconfig"
 
-source "drivers/staging/media/go7007/Kconfig"
-
 source "drivers/staging/media/msi3101/Kconfig"
 
 source "drivers/staging/media/omap24xx/Kconfig"
diff --git a/drivers/staging/media/Makefile b/drivers/staging/media/Makefile
index 2766a3e..9ce9634 100644
--- a/drivers/staging/media/Makefile
+++ b/drivers/staging/media/Makefile
@@ -4,7 +4,6 @@ obj-$(CONFIG_DVB_CXD2099)	+= cxd2099/
 obj-$(CONFIG_LIRC_STAGING)	+= lirc/
 obj-$(CONFIG_SOLO6X10)		+= solo6x10/
 obj-$(CONFIG_VIDEO_DT3155)	+= dt3155v4l/
-obj-$(CONFIG_VIDEO_GO7007)	+= go7007/
 obj-$(CONFIG_USB_MSI3101)	+= msi3101/
 obj-$(CONFIG_VIDEO_DM365_VPFE)	+= davinci_vpfe/
 obj-$(CONFIG_VIDEO_OMAP4)	+= omap4iss/
-- 
2.0.0

