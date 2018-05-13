Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:56070 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751282AbeEMLFa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 13 May 2018 07:05:30 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 2/3] zr364xx: move to staging in preparation for removal
Date: Sun, 13 May 2018 13:05:24 +0200
Message-Id: <20180513110525.20062-3-hverkuil@xs4all.nl>
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
 MAINTAINERS                                            | 2 +-
 drivers/media/usb/Kconfig                              | 1 -
 drivers/media/usb/Makefile                             | 2 +-
 drivers/staging/media/Kconfig                          | 2 ++
 drivers/staging/media/Makefile                         | 1 +
 drivers/{media/usb => staging/media}/zr364xx/Kconfig   | 0
 drivers/{media/usb => staging/media}/zr364xx/Makefile  | 0
 drivers/staging/media/zr364xx/TODO                     | 4 ++++
 drivers/{media/usb => staging/media}/zr364xx/zr364xx.c | 0
 9 files changed, 9 insertions(+), 3 deletions(-)
 rename drivers/{media/usb => staging/media}/zr364xx/Kconfig (100%)
 rename drivers/{media/usb => staging/media}/zr364xx/Makefile (100%)
 create mode 100644 drivers/staging/media/zr364xx/TODO
 rename drivers/{media/usb => staging/media}/zr364xx/zr364xx.c (100%)

diff --git a/MAINTAINERS b/MAINTAINERS
index 49003f77cedd..5e5628519799 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14803,7 +14803,7 @@ T:	git git://linuxtv.org/media_tree.git
 W:	http://royale.zerezo.com/zr364xx/
 S:	Maintained
 F:	Documentation/media/v4l-drivers/zr364xx*
-F:	drivers/media/usb/zr364xx/
+F:	drivers/staging/media/zr364xx/
 
 USER-MODE LINUX (UML)
 M:	Jeff Dike <jdike@addtoit.com>
diff --git a/drivers/media/usb/Kconfig b/drivers/media/usb/Kconfig
index 7c4058b67008..3335981f33e1 100644
--- a/drivers/media/usb/Kconfig
+++ b/drivers/media/usb/Kconfig
@@ -13,7 +13,6 @@ if MEDIA_CAMERA_SUPPORT
 source "drivers/media/usb/uvc/Kconfig"
 source "drivers/media/usb/gspca/Kconfig"
 source "drivers/media/usb/pwc/Kconfig"
-source "drivers/media/usb/zr364xx/Kconfig"
 source "drivers/media/usb/stkwebcam/Kconfig"
 source "drivers/media/usb/s2255/Kconfig"
 source "drivers/media/usb/usbtv/Kconfig"
diff --git a/drivers/media/usb/Makefile b/drivers/media/usb/Makefile
index 356b1103a0aa..014f83d445e3 100644
--- a/drivers/media/usb/Makefile
+++ b/drivers/media/usb/Makefile
@@ -5,7 +5,7 @@
 
 # DVB USB-only drivers
 obj-y += ttusb-dec/ ttusb-budget/ dvb-usb/ dvb-usb-v2/ siano/ b2c2/
-obj-y += zr364xx/ stkwebcam/ s2255/
+obj-y += stkwebcam/ s2255/
 
 obj-$(CONFIG_USB_VIDEO_CLASS)	+= uvc/
 obj-$(CONFIG_USB_GSPCA)         += gspca/
diff --git a/drivers/staging/media/Kconfig b/drivers/staging/media/Kconfig
index 68b9084d3476..00d14e735cd4 100644
--- a/drivers/staging/media/Kconfig
+++ b/drivers/staging/media/Kconfig
@@ -37,4 +37,6 @@ source "drivers/staging/media/omap4iss/Kconfig"
 
 source "drivers/staging/media/tegra-vde/Kconfig"
 
+source "drivers/staging/media/zr364xx/Kconfig"
+
 endif
diff --git a/drivers/staging/media/Makefile b/drivers/staging/media/Makefile
index f1566ac9a6c0..4d6d90aaf607 100644
--- a/drivers/staging/media/Makefile
+++ b/drivers/staging/media/Makefile
@@ -8,3 +8,4 @@ obj-$(CONFIG_VIDEO_DM365_VPFE)	+= davinci_vpfe/
 obj-$(CONFIG_VIDEO_OMAP4)	+= omap4iss/
 obj-$(CONFIG_INTEL_ATOMISP)     += atomisp/
 obj-$(CONFIG_TEGRA_VDE)		+= tegra-vde/
+obj-$(CONFIG_USB_ZR364XX)	+= zr364xx/
diff --git a/drivers/media/usb/zr364xx/Kconfig b/drivers/staging/media/zr364xx/Kconfig
similarity index 100%
rename from drivers/media/usb/zr364xx/Kconfig
rename to drivers/staging/media/zr364xx/Kconfig
diff --git a/drivers/media/usb/zr364xx/Makefile b/drivers/staging/media/zr364xx/Makefile
similarity index 100%
rename from drivers/media/usb/zr364xx/Makefile
rename to drivers/staging/media/zr364xx/Makefile
diff --git a/drivers/staging/media/zr364xx/TODO b/drivers/staging/media/zr364xx/TODO
new file mode 100644
index 000000000000..8a9a6c275e78
--- /dev/null
+++ b/drivers/staging/media/zr364xx/TODO
@@ -0,0 +1,4 @@
+The zr364xx driver is marked deprecated. It will be removed
+around May 2019 unless someone is willing to update this
+driver to the latest V4L2 frameworks (especially the vb2
+framework).
diff --git a/drivers/media/usb/zr364xx/zr364xx.c b/drivers/staging/media/zr364xx/zr364xx.c
similarity index 100%
rename from drivers/media/usb/zr364xx/zr364xx.c
rename to drivers/staging/media/zr364xx/zr364xx.c
-- 
2.17.0
