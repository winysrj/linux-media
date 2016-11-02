Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:53247 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753924AbcKBMqj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 2 Nov 2016 08:46:39 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 09/11] pulse8-cec: move out of staging
Date: Wed,  2 Nov 2016 13:46:33 +0100
Message-Id: <20161102124635.11989-10-hverkuil@xs4all.nl>
In-Reply-To: <20161102124635.11989-1-hverkuil@xs4all.nl>
References: <20161102124635.11989-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Now that the CEC framework has been moved out of staging and into the
mainline kernel we can do the same for the pulse8-cec driver.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/Kconfig                          |  5 +++
 drivers/media/usb/Makefile                         |  1 +
 .../media => media/usb}/pulse8-cec/Kconfig         |  0
 .../media => media/usb}/pulse8-cec/Makefile        |  0
 .../media => media/usb}/pulse8-cec/pulse8-cec.c    |  0
 drivers/staging/media/Kconfig                      |  2 -
 drivers/staging/media/Makefile                     |  1 -
 drivers/staging/media/pulse8-cec/TODO              | 52 ----------------------
 8 files changed, 6 insertions(+), 55 deletions(-)
 rename drivers/{staging/media => media/usb}/pulse8-cec/Kconfig (100%)
 rename drivers/{staging/media => media/usb}/pulse8-cec/Makefile (100%)
 rename drivers/{staging/media => media/usb}/pulse8-cec/pulse8-cec.c (100%)
 delete mode 100644 drivers/staging/media/pulse8-cec/TODO

diff --git a/drivers/media/usb/Kconfig b/drivers/media/usb/Kconfig
index 7496f33..c9644b6 100644
--- a/drivers/media/usb/Kconfig
+++ b/drivers/media/usb/Kconfig
@@ -60,5 +60,10 @@ source "drivers/media/usb/hackrf/Kconfig"
 source "drivers/media/usb/msi2500/Kconfig"
 endif
 
+if MEDIA_CEC_SUPPORT
+	comment "USB HDMI CEC adapters"
+source "drivers/media/usb/pulse8-cec/Kconfig"
+endif
+
 endif #MEDIA_USB_SUPPORT
 endif #USB
diff --git a/drivers/media/usb/Makefile b/drivers/media/usb/Makefile
index 8874ba7..0f15e33 100644
--- a/drivers/media/usb/Makefile
+++ b/drivers/media/usb/Makefile
@@ -24,3 +24,4 @@ obj-$(CONFIG_VIDEO_EM28XX) += em28xx/
 obj-$(CONFIG_VIDEO_USBTV) += usbtv/
 obj-$(CONFIG_VIDEO_GO7007) += go7007/
 obj-$(CONFIG_DVB_AS102) += as102/
+obj-$(CONFIG_USB_PULSE8_CEC) += pulse8-cec/
diff --git a/drivers/staging/media/pulse8-cec/Kconfig b/drivers/media/usb/pulse8-cec/Kconfig
similarity index 100%
rename from drivers/staging/media/pulse8-cec/Kconfig
rename to drivers/media/usb/pulse8-cec/Kconfig
diff --git a/drivers/staging/media/pulse8-cec/Makefile b/drivers/media/usb/pulse8-cec/Makefile
similarity index 100%
rename from drivers/staging/media/pulse8-cec/Makefile
rename to drivers/media/usb/pulse8-cec/Makefile
diff --git a/drivers/staging/media/pulse8-cec/pulse8-cec.c b/drivers/media/usb/pulse8-cec/pulse8-cec.c
similarity index 100%
rename from drivers/staging/media/pulse8-cec/pulse8-cec.c
rename to drivers/media/usb/pulse8-cec/pulse8-cec.c
diff --git a/drivers/staging/media/Kconfig b/drivers/staging/media/Kconfig
index 0abe5ff..ffb8fa7 100644
--- a/drivers/staging/media/Kconfig
+++ b/drivers/staging/media/Kconfig
@@ -27,8 +27,6 @@ source "drivers/staging/media/davinci_vpfe/Kconfig"
 
 source "drivers/staging/media/omap4iss/Kconfig"
 
-source "drivers/staging/media/pulse8-cec/Kconfig"
-
 source "drivers/staging/media/s5p-cec/Kconfig"
 
 # Keep LIRC at the end, as it has sub-menus
diff --git a/drivers/staging/media/Makefile b/drivers/staging/media/Makefile
index 246299e..a28e82c 100644
--- a/drivers/staging/media/Makefile
+++ b/drivers/staging/media/Makefile
@@ -4,5 +4,4 @@ obj-$(CONFIG_DVB_CXD2099)	+= cxd2099/
 obj-$(CONFIG_LIRC_STAGING)	+= lirc/
 obj-$(CONFIG_VIDEO_DM365_VPFE)	+= davinci_vpfe/
 obj-$(CONFIG_VIDEO_OMAP4)	+= omap4iss/
-obj-$(CONFIG_USB_PULSE8_CEC)    += pulse8-cec/
 obj-$(CONFIG_VIDEO_STI_HDMI_CEC) += st-cec/
diff --git a/drivers/staging/media/pulse8-cec/TODO b/drivers/staging/media/pulse8-cec/TODO
deleted file mode 100644
index fa66602..0000000
--- a/drivers/staging/media/pulse8-cec/TODO
+++ /dev/null
@@ -1,52 +0,0 @@
-This driver needs to mature a bit more and another round of
-code cleanups.
-
-Otherwise it looks to be in good shape. And of course the fact
-that the CEC framework is in staging at the moment also prevents
-this driver from being mainlined.
-
-Some notes:
-
-1) Regarding the "autonomous" mode of the Pulse-Eight: currently this
-is disabled, but the idea is that this allows basic functionality
-when the PC is off, and it can wake-up the PC through USB.
-
-To prevent the device to go into autonomous mode the driver would
-have to send MSGCODE_SET_CONTROLLED 1 and then send a ping every
-30 seconds (in practice once every 15 seconds would be good). When
-powering off or going to standby send MSGCODE_SET_CONTROLLED 0 to
-turn the autonomous mode back on.
-
-This needs to be implemented in the driver. Autonomous mode was
-added in firmware v2.
-
-2) Writing to the EEPROM can only be done once every 10 seconds.
-
-3) To use this driver you also need to patch the inputattach utility,
-this patch will be submitted once this driver is moved out of staging.
-
-diff -urN linuxconsoletools-1.4.9/utils/inputattach.c linuxconsoletools-1.4.9.new/utils/inputattach.c
---- linuxconsoletools-1.4.9/utils/inputattach.c	2016-01-09 16:27:02.000000000 +0100
-+++ linuxconsoletools-1.4.9.new/utils/inputattach.c	2016-03-20 11:35:31.707788967 +0100
-@@ -861,6 +861,9 @@
- { "--wacom_iv",		"-wacom_iv",	"Wacom protocol IV tablet",
- 	B9600, CS8 | CRTSCTS,
- 	SERIO_WACOM_IV,		0x00,	0x00,	0,	wacom_iv_init },
-+{ "--pulse8-cec",		"-pulse8-cec",	"Pulse Eight HDMI CEC dongle",
-+	B9600, CS8,
-+	SERIO_PULSE8_CEC,		0x00,	0x00,	0,	NULL },
- { NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL }
- };
- 
-diff -urN linuxconsoletools-1.4.9/utils/serio-ids.h linuxconsoletools-1.4.9.new/utils/serio-ids.h
---- linuxconsoletools-1.4.9/utils/serio-ids.h	2015-04-26 18:29:42.000000000 +0200
-+++ linuxconsoletools-1.4.9.new/utils/serio-ids.h	2016-03-20 11:41:00.153558539 +0100
-@@ -131,5 +131,8 @@
- #ifndef SERIO_EASYPEN
- # define SERIO_EASYPEN		0x3f
- #endif
-+#ifndef SERIO_PULSE8_CEC
-+# define SERIO_PULSE8_CEC	0x40
-+#endif
- 
- #endif
-- 
2.10.1

