Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3045 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445Ab3LLM0y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Dec 2013 07:26:54 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Luca Risolia <luca.risolia@studio.unibo.it>
Subject: [RFCv2 PATCH 1/2] sn9c102: prepare for removal by moving it to staging.
Date: Thu, 12 Dec 2013 13:26:32 +0100
Message-Id: <1386851193-3845-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1386851193-3845-1-git-send-email-hverkuil@xs4all.nl>
References: <1386851193-3845-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

During the last media summit meeting it was decided to move this driver to
staging as the first step to removing it altogether.

Most webcams covered by this driver are now supported by gspca. Nobody has the
hardware to convert the remaining devices to gspca.

This driver needs a major overhaul to have it conform to the latest frameworks
and compliancy tests.

Without hardware, however, this is next to impossible. Given the fact that
this driver seems to be pretty much unused (it has been removed from Fedora
several versions ago and nobody complained about that), we decided to drop
this driver.

This patch moves it to staging. Some time in 2014 we will drop it completely.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Luca Risolia <luca.risolia@studio.unibo.it>
---
 MAINTAINERS                                                        | 3 +--
 drivers/media/usb/Kconfig                                          | 1 -
 drivers/media/usb/Makefile                                         | 1 -
 drivers/staging/media/Kconfig                                      | 2 ++
 drivers/staging/media/Makefile                                     | 1 +
 drivers/{media/usb => staging/media}/sn9c102/Kconfig               | 7 +++++--
 drivers/{media/usb => staging/media}/sn9c102/Makefile              | 0
 drivers/{media/usb => staging/media}/sn9c102/sn9c102.h             | 0
 .../video4linux => drivers/staging/media/sn9c102}/sn9c102.txt      | 0
 drivers/{media/usb => staging/media}/sn9c102/sn9c102_config.h      | 0
 drivers/{media/usb => staging/media}/sn9c102/sn9c102_core.c        | 0
 drivers/{media/usb => staging/media}/sn9c102/sn9c102_devtable.h    | 0
 drivers/{media/usb => staging/media}/sn9c102/sn9c102_hv7131d.c     | 0
 drivers/{media/usb => staging/media}/sn9c102/sn9c102_hv7131r.c     | 0
 drivers/{media/usb => staging/media}/sn9c102/sn9c102_mi0343.c      | 0
 drivers/{media/usb => staging/media}/sn9c102/sn9c102_mi0360.c      | 0
 drivers/{media/usb => staging/media}/sn9c102/sn9c102_mt9v111.c     | 0
 drivers/{media/usb => staging/media}/sn9c102/sn9c102_ov7630.c      | 0
 drivers/{media/usb => staging/media}/sn9c102/sn9c102_ov7660.c      | 0
 drivers/{media/usb => staging/media}/sn9c102/sn9c102_pas106b.c     | 0
 drivers/{media/usb => staging/media}/sn9c102/sn9c102_pas202bcb.c   | 0
 drivers/{media/usb => staging/media}/sn9c102/sn9c102_sensor.h      | 0
 drivers/{media/usb => staging/media}/sn9c102/sn9c102_tas5110c1b.c  | 0
 drivers/{media/usb => staging/media}/sn9c102/sn9c102_tas5110d.c    | 0
 drivers/{media/usb => staging/media}/sn9c102/sn9c102_tas5130d1b.c  | 0
 25 files changed, 9 insertions(+), 6 deletions(-)
 rename drivers/{media/usb => staging/media}/sn9c102/Kconfig (58%)
 rename drivers/{media/usb => staging/media}/sn9c102/Makefile (100%)
 rename drivers/{media/usb => staging/media}/sn9c102/sn9c102.h (100%)
 rename {Documentation/video4linux => drivers/staging/media/sn9c102}/sn9c102.txt (100%)
 rename drivers/{media/usb => staging/media}/sn9c102/sn9c102_config.h (100%)
 rename drivers/{media/usb => staging/media}/sn9c102/sn9c102_core.c (100%)
 rename drivers/{media/usb => staging/media}/sn9c102/sn9c102_devtable.h (100%)
 rename drivers/{media/usb => staging/media}/sn9c102/sn9c102_hv7131d.c (100%)
 rename drivers/{media/usb => staging/media}/sn9c102/sn9c102_hv7131r.c (100%)
 rename drivers/{media/usb => staging/media}/sn9c102/sn9c102_mi0343.c (100%)
 rename drivers/{media/usb => staging/media}/sn9c102/sn9c102_mi0360.c (100%)
 rename drivers/{media/usb => staging/media}/sn9c102/sn9c102_mt9v111.c (100%)
 rename drivers/{media/usb => staging/media}/sn9c102/sn9c102_ov7630.c (100%)
 rename drivers/{media/usb => staging/media}/sn9c102/sn9c102_ov7660.c (100%)
 rename drivers/{media/usb => staging/media}/sn9c102/sn9c102_pas106b.c (100%)
 rename drivers/{media/usb => staging/media}/sn9c102/sn9c102_pas202bcb.c (100%)
 rename drivers/{media/usb => staging/media}/sn9c102/sn9c102_sensor.h (100%)
 rename drivers/{media/usb => staging/media}/sn9c102/sn9c102_tas5110c1b.c (100%)
 rename drivers/{media/usb => staging/media}/sn9c102/sn9c102_tas5110d.c (100%)
 rename drivers/{media/usb => staging/media}/sn9c102/sn9c102_tas5130d1b.c (100%)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8285ed4..5883b52 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9017,8 +9017,7 @@ L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
 W:	http://www.linux-projects.org
 S:	Maintained
-F:	Documentation/video4linux/sn9c102.txt
-F:	drivers/media/usb/sn9c102/
+F:	drivers/staging/media/sn9c102/
 
 USB SUBSYSTEM
 M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
diff --git a/drivers/media/usb/Kconfig b/drivers/media/usb/Kconfig
index cfe8056..39d824e 100644
--- a/drivers/media/usb/Kconfig
+++ b/drivers/media/usb/Kconfig
@@ -17,7 +17,6 @@ source "drivers/media/usb/cpia2/Kconfig"
 source "drivers/media/usb/zr364xx/Kconfig"
 source "drivers/media/usb/stkwebcam/Kconfig"
 source "drivers/media/usb/s2255/Kconfig"
-source "drivers/media/usb/sn9c102/Kconfig"
 source "drivers/media/usb/usbtv/Kconfig"
 endif
 
diff --git a/drivers/media/usb/Makefile b/drivers/media/usb/Makefile
index 0935f47..7ac4b14 100644
--- a/drivers/media/usb/Makefile
+++ b/drivers/media/usb/Makefile
@@ -10,7 +10,6 @@ obj-$(CONFIG_USB_VIDEO_CLASS)	+= uvc/
 obj-$(CONFIG_USB_GSPCA)         += gspca/
 obj-$(CONFIG_USB_PWC)           += pwc/
 obj-$(CONFIG_VIDEO_CPIA2) += cpia2/
-obj-$(CONFIG_USB_SN9C102)       += sn9c102/
 obj-$(CONFIG_VIDEO_AU0828) += au0828/
 obj-$(CONFIG_VIDEO_HDPVR)	+= hdpvr/
 obj-$(CONFIG_VIDEO_PVRUSB2) += pvrusb2/
diff --git a/drivers/staging/media/Kconfig b/drivers/staging/media/Kconfig
index 7728879..6a20217 100644
--- a/drivers/staging/media/Kconfig
+++ b/drivers/staging/media/Kconfig
@@ -33,6 +33,8 @@ source "drivers/staging/media/go7007/Kconfig"
 
 source "drivers/staging/media/msi3101/Kconfig"
 
+source "drivers/staging/media/sn9c102/Kconfig"
+
 source "drivers/staging/media/solo6x10/Kconfig"
 
 source "drivers/staging/media/omap4iss/Kconfig"
diff --git a/drivers/staging/media/Makefile b/drivers/staging/media/Makefile
index 0bd1a88..2a15451 100644
--- a/drivers/staging/media/Makefile
+++ b/drivers/staging/media/Makefile
@@ -8,3 +8,4 @@ obj-$(CONFIG_VIDEO_GO7007)	+= go7007/
 obj-$(CONFIG_USB_MSI3101)	+= msi3101/
 obj-$(CONFIG_VIDEO_DM365_VPFE)	+= davinci_vpfe/
 obj-$(CONFIG_VIDEO_OMAP4)	+= omap4iss/
+obj-$(CONFIG_USB_SN9C102)       += sn9c102/
diff --git a/drivers/media/usb/sn9c102/Kconfig b/drivers/staging/media/sn9c102/Kconfig
similarity index 58%
rename from drivers/media/usb/sn9c102/Kconfig
rename to drivers/staging/media/sn9c102/Kconfig
index 6ebaf29..d8ae235 100644
--- a/drivers/media/usb/sn9c102/Kconfig
+++ b/drivers/staging/media/sn9c102/Kconfig
@@ -2,13 +2,16 @@ config USB_SN9C102
 	tristate "USB SN9C1xx PC Camera Controller support (DEPRECATED)"
 	depends on VIDEO_V4L2
 	---help---
-	  This driver is DEPRECATED please use the gspca sonixb and
+	  This driver is DEPRECATED, please use the gspca sonixb and
 	  sonixj modules instead.
 
 	  Say Y here if you want support for cameras based on SONiX SN9C101,
 	  SN9C102, SN9C103, SN9C105 and SN9C120 PC Camera Controllers.
 
-	  See <file:Documentation/video4linux/sn9c102.txt> for more info.
+	  See <file:drivers/staging/media/sn9c102/sn9c102.txt> for more info.
+
+	  If you have webcams that are only supported by this driver and not by
+	  the gspca driver, then contact the linux-media mailinglist.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called sn9c102.
diff --git a/drivers/media/usb/sn9c102/Makefile b/drivers/staging/media/sn9c102/Makefile
similarity index 100%
rename from drivers/media/usb/sn9c102/Makefile
rename to drivers/staging/media/sn9c102/Makefile
diff --git a/drivers/media/usb/sn9c102/sn9c102.h b/drivers/staging/media/sn9c102/sn9c102.h
similarity index 100%
rename from drivers/media/usb/sn9c102/sn9c102.h
rename to drivers/staging/media/sn9c102/sn9c102.h
diff --git a/Documentation/video4linux/sn9c102.txt b/drivers/staging/media/sn9c102/sn9c102.txt
similarity index 100%
rename from Documentation/video4linux/sn9c102.txt
rename to drivers/staging/media/sn9c102/sn9c102.txt
diff --git a/drivers/media/usb/sn9c102/sn9c102_config.h b/drivers/staging/media/sn9c102/sn9c102_config.h
similarity index 100%
rename from drivers/media/usb/sn9c102/sn9c102_config.h
rename to drivers/staging/media/sn9c102/sn9c102_config.h
diff --git a/drivers/media/usb/sn9c102/sn9c102_core.c b/drivers/staging/media/sn9c102/sn9c102_core.c
similarity index 100%
rename from drivers/media/usb/sn9c102/sn9c102_core.c
rename to drivers/staging/media/sn9c102/sn9c102_core.c
diff --git a/drivers/media/usb/sn9c102/sn9c102_devtable.h b/drivers/staging/media/sn9c102/sn9c102_devtable.h
similarity index 100%
rename from drivers/media/usb/sn9c102/sn9c102_devtable.h
rename to drivers/staging/media/sn9c102/sn9c102_devtable.h
diff --git a/drivers/media/usb/sn9c102/sn9c102_hv7131d.c b/drivers/staging/media/sn9c102/sn9c102_hv7131d.c
similarity index 100%
rename from drivers/media/usb/sn9c102/sn9c102_hv7131d.c
rename to drivers/staging/media/sn9c102/sn9c102_hv7131d.c
diff --git a/drivers/media/usb/sn9c102/sn9c102_hv7131r.c b/drivers/staging/media/sn9c102/sn9c102_hv7131r.c
similarity index 100%
rename from drivers/media/usb/sn9c102/sn9c102_hv7131r.c
rename to drivers/staging/media/sn9c102/sn9c102_hv7131r.c
diff --git a/drivers/media/usb/sn9c102/sn9c102_mi0343.c b/drivers/staging/media/sn9c102/sn9c102_mi0343.c
similarity index 100%
rename from drivers/media/usb/sn9c102/sn9c102_mi0343.c
rename to drivers/staging/media/sn9c102/sn9c102_mi0343.c
diff --git a/drivers/media/usb/sn9c102/sn9c102_mi0360.c b/drivers/staging/media/sn9c102/sn9c102_mi0360.c
similarity index 100%
rename from drivers/media/usb/sn9c102/sn9c102_mi0360.c
rename to drivers/staging/media/sn9c102/sn9c102_mi0360.c
diff --git a/drivers/media/usb/sn9c102/sn9c102_mt9v111.c b/drivers/staging/media/sn9c102/sn9c102_mt9v111.c
similarity index 100%
rename from drivers/media/usb/sn9c102/sn9c102_mt9v111.c
rename to drivers/staging/media/sn9c102/sn9c102_mt9v111.c
diff --git a/drivers/media/usb/sn9c102/sn9c102_ov7630.c b/drivers/staging/media/sn9c102/sn9c102_ov7630.c
similarity index 100%
rename from drivers/media/usb/sn9c102/sn9c102_ov7630.c
rename to drivers/staging/media/sn9c102/sn9c102_ov7630.c
diff --git a/drivers/media/usb/sn9c102/sn9c102_ov7660.c b/drivers/staging/media/sn9c102/sn9c102_ov7660.c
similarity index 100%
rename from drivers/media/usb/sn9c102/sn9c102_ov7660.c
rename to drivers/staging/media/sn9c102/sn9c102_ov7660.c
diff --git a/drivers/media/usb/sn9c102/sn9c102_pas106b.c b/drivers/staging/media/sn9c102/sn9c102_pas106b.c
similarity index 100%
rename from drivers/media/usb/sn9c102/sn9c102_pas106b.c
rename to drivers/staging/media/sn9c102/sn9c102_pas106b.c
diff --git a/drivers/media/usb/sn9c102/sn9c102_pas202bcb.c b/drivers/staging/media/sn9c102/sn9c102_pas202bcb.c
similarity index 100%
rename from drivers/media/usb/sn9c102/sn9c102_pas202bcb.c
rename to drivers/staging/media/sn9c102/sn9c102_pas202bcb.c
diff --git a/drivers/media/usb/sn9c102/sn9c102_sensor.h b/drivers/staging/media/sn9c102/sn9c102_sensor.h
similarity index 100%
rename from drivers/media/usb/sn9c102/sn9c102_sensor.h
rename to drivers/staging/media/sn9c102/sn9c102_sensor.h
diff --git a/drivers/media/usb/sn9c102/sn9c102_tas5110c1b.c b/drivers/staging/media/sn9c102/sn9c102_tas5110c1b.c
similarity index 100%
rename from drivers/media/usb/sn9c102/sn9c102_tas5110c1b.c
rename to drivers/staging/media/sn9c102/sn9c102_tas5110c1b.c
diff --git a/drivers/media/usb/sn9c102/sn9c102_tas5110d.c b/drivers/staging/media/sn9c102/sn9c102_tas5110d.c
similarity index 100%
rename from drivers/media/usb/sn9c102/sn9c102_tas5110d.c
rename to drivers/staging/media/sn9c102/sn9c102_tas5110d.c
diff --git a/drivers/media/usb/sn9c102/sn9c102_tas5130d1b.c b/drivers/staging/media/sn9c102/sn9c102_tas5130d1b.c
similarity index 100%
rename from drivers/media/usb/sn9c102/sn9c102_tas5130d1b.c
rename to drivers/staging/media/sn9c102/sn9c102_tas5130d1b.c
-- 
1.8.4.3

