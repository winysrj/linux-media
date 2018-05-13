Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:56139 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751313AbeEMLFa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 13 May 2018 07:05:30 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 3/3] usbvision: move to staging in preparation for removal
Date: Sun, 13 May 2018 13:05:25 +0200
Message-Id: <20180513110525.20062-4-hverkuil@xs4all.nl>
In-Reply-To: <20180513110525.20062-1-hverkuil@xs4all.nl>
References: <20180513110525.20062-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This driver hasn't been tested in a long, long time. The hardware is
ancient and pretty much obsolete. This driver also needs to be converted
to newer media frameworks (vb2!) but due to the lack of time and interest
that is unlikely to happen.

So this driver is a prime candidate for removal. If someone is interested
in working on this driver to prevent its removal, then please contact the
linux-media mailinglist.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 MAINTAINERS                                                   | 2 +-
 drivers/media/usb/Kconfig                                     | 1 -
 drivers/media/usb/Makefile                                    | 1 -
 drivers/staging/media/Kconfig                                 | 2 ++
 drivers/staging/media/Makefile                                | 1 +
 drivers/{media/usb => staging/media}/usbvision/Kconfig        | 2 +-
 drivers/{media/usb => staging/media}/usbvision/Makefile       | 0
 drivers/staging/media/usbvision/TODO                          | 4 ++++
 .../{media/usb => staging/media}/usbvision/usbvision-cards.c  | 0
 .../{media/usb => staging/media}/usbvision/usbvision-cards.h  | 0
 .../{media/usb => staging/media}/usbvision/usbvision-core.c   | 0
 .../{media/usb => staging/media}/usbvision/usbvision-i2c.c    | 0
 .../{media/usb => staging/media}/usbvision/usbvision-video.c  | 0
 drivers/{media/usb => staging/media}/usbvision/usbvision.h    | 0
 14 files changed, 9 insertions(+), 4 deletions(-)
 rename drivers/{media/usb => staging/media}/usbvision/Kconfig (82%)
 rename drivers/{media/usb => staging/media}/usbvision/Makefile (100%)
 create mode 100644 drivers/staging/media/usbvision/TODO
 rename drivers/{media/usb => staging/media}/usbvision/usbvision-cards.c (100%)
 rename drivers/{media/usb => staging/media}/usbvision/usbvision-cards.h (100%)
 rename drivers/{media/usb => staging/media}/usbvision/usbvision-core.c (100%)
 rename drivers/{media/usb => staging/media}/usbvision/usbvision-i2c.c (100%)
 rename drivers/{media/usb => staging/media}/usbvision/usbvision-video.c (100%)
 rename drivers/{media/usb => staging/media}/usbvision/usbvision.h (100%)

diff --git a/MAINTAINERS b/MAINTAINERS
index 5e5628519799..8cd175777316 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14767,7 +14767,7 @@ L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
 W:	https://linuxtv.org
 S:	Odd Fixes
-F:	drivers/media/usb/usbvision/
+F:	drivers/staging/media/usbvision/
 
 USB WEBCAM GADGET
 M:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
diff --git a/drivers/media/usb/Kconfig b/drivers/media/usb/Kconfig
index 3335981f33e1..f5de4846e12d 100644
--- a/drivers/media/usb/Kconfig
+++ b/drivers/media/usb/Kconfig
@@ -22,7 +22,6 @@ if MEDIA_ANALOG_TV_SUPPORT
 	comment "Analog TV USB devices"
 source "drivers/media/usb/pvrusb2/Kconfig"
 source "drivers/media/usb/hdpvr/Kconfig"
-source "drivers/media/usb/usbvision/Kconfig"
 source "drivers/media/usb/stk1160/Kconfig"
 source "drivers/media/usb/go7007/Kconfig"
 endif
diff --git a/drivers/media/usb/Makefile b/drivers/media/usb/Makefile
index 014f83d445e3..c13d72ec53f2 100644
--- a/drivers/media/usb/Makefile
+++ b/drivers/media/usb/Makefile
@@ -16,7 +16,6 @@ obj-$(CONFIG_USB_MSI2500)       += msi2500/
 obj-$(CONFIG_VIDEO_AU0828) += au0828/
 obj-$(CONFIG_VIDEO_HDPVR)	+= hdpvr/
 obj-$(CONFIG_VIDEO_PVRUSB2) += pvrusb2/
-obj-$(CONFIG_VIDEO_USBVISION) += usbvision/
 obj-$(CONFIG_VIDEO_STK1160) += stk1160/
 obj-$(CONFIG_VIDEO_CX231XX) += cx231xx/
 obj-$(CONFIG_VIDEO_TM6000) += tm6000/
diff --git a/drivers/staging/media/Kconfig b/drivers/staging/media/Kconfig
index 00d14e735cd4..c48b3bff7de9 100644
--- a/drivers/staging/media/Kconfig
+++ b/drivers/staging/media/Kconfig
@@ -37,6 +37,8 @@ source "drivers/staging/media/omap4iss/Kconfig"
 
 source "drivers/staging/media/tegra-vde/Kconfig"
 
+source "drivers/staging/media/usbvision/Kconfig"
+
 source "drivers/staging/media/zr364xx/Kconfig"
 
 endif
diff --git a/drivers/staging/media/Makefile b/drivers/staging/media/Makefile
index 4d6d90aaf607..e54cef574b1e 100644
--- a/drivers/staging/media/Makefile
+++ b/drivers/staging/media/Makefile
@@ -8,4 +8,5 @@ obj-$(CONFIG_VIDEO_DM365_VPFE)	+= davinci_vpfe/
 obj-$(CONFIG_VIDEO_OMAP4)	+= omap4iss/
 obj-$(CONFIG_INTEL_ATOMISP)     += atomisp/
 obj-$(CONFIG_TEGRA_VDE)		+= tegra-vde/
+obj-$(CONFIG_VIDEO_USBVISION)	+= usbvision/
 obj-$(CONFIG_USB_ZR364XX)	+= zr364xx/
diff --git a/drivers/media/usb/usbvision/Kconfig b/drivers/staging/media/usbvision/Kconfig
similarity index 82%
rename from drivers/media/usb/usbvision/Kconfig
rename to drivers/staging/media/usbvision/Kconfig
index 6b6afc5d8f7e..1c7290356e70 100644
--- a/drivers/media/usb/usbvision/Kconfig
+++ b/drivers/staging/media/usbvision/Kconfig
@@ -1,5 +1,5 @@
 config VIDEO_USBVISION
-	tristate "USB video devices based on Nogatech NT1003/1004/1005"
+	tristate "USB video devices based on Nogatech NT1003/1004/1005 (Deprecated)"
 	depends on I2C && VIDEO_V4L2
 	select VIDEO_TUNER
 	select VIDEO_SAA711X if MEDIA_SUBDRV_AUTOSELECT
diff --git a/drivers/media/usb/usbvision/Makefile b/drivers/staging/media/usbvision/Makefile
similarity index 100%
rename from drivers/media/usb/usbvision/Makefile
rename to drivers/staging/media/usbvision/Makefile
diff --git a/drivers/staging/media/usbvision/TODO b/drivers/staging/media/usbvision/TODO
new file mode 100644
index 000000000000..1fe53ceb9ce2
--- /dev/null
+++ b/drivers/staging/media/usbvision/TODO
@@ -0,0 +1,4 @@
+The usbvision driver is marked deprecated. It will be removed
+around May 2019 unless someone is willing to update this
+driver to the latest V4L2 frameworks (especially the vb2
+framework).
diff --git a/drivers/media/usb/usbvision/usbvision-cards.c b/drivers/staging/media/usbvision/usbvision-cards.c
similarity index 100%
rename from drivers/media/usb/usbvision/usbvision-cards.c
rename to drivers/staging/media/usbvision/usbvision-cards.c
diff --git a/drivers/media/usb/usbvision/usbvision-cards.h b/drivers/staging/media/usbvision/usbvision-cards.h
similarity index 100%
rename from drivers/media/usb/usbvision/usbvision-cards.h
rename to drivers/staging/media/usbvision/usbvision-cards.h
diff --git a/drivers/media/usb/usbvision/usbvision-core.c b/drivers/staging/media/usbvision/usbvision-core.c
similarity index 100%
rename from drivers/media/usb/usbvision/usbvision-core.c
rename to drivers/staging/media/usbvision/usbvision-core.c
diff --git a/drivers/media/usb/usbvision/usbvision-i2c.c b/drivers/staging/media/usbvision/usbvision-i2c.c
similarity index 100%
rename from drivers/media/usb/usbvision/usbvision-i2c.c
rename to drivers/staging/media/usbvision/usbvision-i2c.c
diff --git a/drivers/media/usb/usbvision/usbvision-video.c b/drivers/staging/media/usbvision/usbvision-video.c
similarity index 100%
rename from drivers/media/usb/usbvision/usbvision-video.c
rename to drivers/staging/media/usbvision/usbvision-video.c
diff --git a/drivers/media/usb/usbvision/usbvision.h b/drivers/staging/media/usbvision/usbvision.h
similarity index 100%
rename from drivers/media/usb/usbvision/usbvision.h
rename to drivers/staging/media/usbvision/usbvision.h
-- 
2.17.0
