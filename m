Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:60918 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751226AbeEMLFa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 13 May 2018 07:05:30 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 1/3] cpia2: move to staging in preparation for removal
Date: Sun, 13 May 2018 13:05:23 +0200
Message-Id: <20180513110525.20062-2-hverkuil@xs4all.nl>
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
 drivers/media/usb/Kconfig                                    | 1 -
 drivers/media/usb/Makefile                                   | 1 -
 drivers/staging/media/Kconfig                                | 2 ++
 drivers/staging/media/Makefile                               | 1 +
 drivers/{media/usb => staging/media}/cpia2/Kconfig           | 2 +-
 drivers/{media/usb => staging/media}/cpia2/Makefile          | 0
 drivers/staging/media/cpia2/TODO                             | 4 ++++
 drivers/{media/usb => staging/media}/cpia2/cpia2.h           | 0
 drivers/{media/usb => staging/media}/cpia2/cpia2_core.c      | 0
 drivers/{media/usb => staging/media}/cpia2/cpia2_registers.h | 0
 drivers/{media/usb => staging/media}/cpia2/cpia2_usb.c       | 0
 drivers/{media/usb => staging/media}/cpia2/cpia2_v4l.c       | 0
 12 files changed, 8 insertions(+), 3 deletions(-)
 rename drivers/{media/usb => staging/media}/cpia2/Kconfig (87%)
 rename drivers/{media/usb => staging/media}/cpia2/Makefile (100%)
 create mode 100644 drivers/staging/media/cpia2/TODO
 rename drivers/{media/usb => staging/media}/cpia2/cpia2.h (100%)
 rename drivers/{media/usb => staging/media}/cpia2/cpia2_core.c (100%)
 rename drivers/{media/usb => staging/media}/cpia2/cpia2_registers.h (100%)
 rename drivers/{media/usb => staging/media}/cpia2/cpia2_usb.c (100%)
 rename drivers/{media/usb => staging/media}/cpia2/cpia2_v4l.c (100%)

diff --git a/drivers/media/usb/Kconfig b/drivers/media/usb/Kconfig
index b24e753c4766..7c4058b67008 100644
--- a/drivers/media/usb/Kconfig
+++ b/drivers/media/usb/Kconfig
@@ -13,7 +13,6 @@ if MEDIA_CAMERA_SUPPORT
 source "drivers/media/usb/uvc/Kconfig"
 source "drivers/media/usb/gspca/Kconfig"
 source "drivers/media/usb/pwc/Kconfig"
-source "drivers/media/usb/cpia2/Kconfig"
 source "drivers/media/usb/zr364xx/Kconfig"
 source "drivers/media/usb/stkwebcam/Kconfig"
 source "drivers/media/usb/s2255/Kconfig"
diff --git a/drivers/media/usb/Makefile b/drivers/media/usb/Makefile
index 21e46b10caa5..356b1103a0aa 100644
--- a/drivers/media/usb/Makefile
+++ b/drivers/media/usb/Makefile
@@ -13,7 +13,6 @@ obj-$(CONFIG_USB_PWC)           += pwc/
 obj-$(CONFIG_USB_AIRSPY)        += airspy/
 obj-$(CONFIG_USB_HACKRF)        += hackrf/
 obj-$(CONFIG_USB_MSI2500)       += msi2500/
-obj-$(CONFIG_VIDEO_CPIA2) += cpia2/
 obj-$(CONFIG_VIDEO_AU0828) += au0828/
 obj-$(CONFIG_VIDEO_HDPVR)	+= hdpvr/
 obj-$(CONFIG_VIDEO_PVRUSB2) += pvrusb2/
diff --git a/drivers/staging/media/Kconfig b/drivers/staging/media/Kconfig
index 4c495a10025c..68b9084d3476 100644
--- a/drivers/staging/media/Kconfig
+++ b/drivers/staging/media/Kconfig
@@ -23,6 +23,8 @@ source "drivers/staging/media/atomisp/Kconfig"
 
 source "drivers/staging/media/bcm2048/Kconfig"
 
+source "drivers/staging/media/cpia2/Kconfig"
+
 source "drivers/staging/media/davinci_vpfe/Kconfig"
 
 source "drivers/staging/media/imx/Kconfig"
diff --git a/drivers/staging/media/Makefile b/drivers/staging/media/Makefile
index 61a5765cb98f..f1566ac9a6c0 100644
--- a/drivers/staging/media/Makefile
+++ b/drivers/staging/media/Makefile
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_I2C_BCM2048)	+= bcm2048/
+obj-$(CONFIG_VIDEO_CPIA2) 	+= cpia2/
 obj-$(CONFIG_VIDEO_IMX_MEDIA)	+= imx/
 obj-$(CONFIG_SOC_CAMERA_IMX074)	+= imx074/
 obj-$(CONFIG_SOC_CAMERA_MT9T031)	+= mt9t031/
diff --git a/drivers/media/usb/cpia2/Kconfig b/drivers/staging/media/cpia2/Kconfig
similarity index 87%
rename from drivers/media/usb/cpia2/Kconfig
rename to drivers/staging/media/cpia2/Kconfig
index 66e9283f5993..805670826281 100644
--- a/drivers/media/usb/cpia2/Kconfig
+++ b/drivers/staging/media/cpia2/Kconfig
@@ -1,5 +1,5 @@
 config VIDEO_CPIA2
-	tristate "CPiA2 Video For Linux"
+	tristate "CPiA2 Video For Linux (Deprecated)"
 	depends on VIDEO_DEV && USB && VIDEO_V4L2
 	---help---
 	  This is the video4linux driver for cameras based on Vision's CPiA2
diff --git a/drivers/media/usb/cpia2/Makefile b/drivers/staging/media/cpia2/Makefile
similarity index 100%
rename from drivers/media/usb/cpia2/Makefile
rename to drivers/staging/media/cpia2/Makefile
diff --git a/drivers/staging/media/cpia2/TODO b/drivers/staging/media/cpia2/TODO
new file mode 100644
index 000000000000..4a4dff2073cd
--- /dev/null
+++ b/drivers/staging/media/cpia2/TODO
@@ -0,0 +1,4 @@
+The cpia2 driver is marked deprecated. It will be removed
+around May 2019 unless someone is willing to update this
+driver to the latest V4L2 frameworks (especially the vb2
+framework).
diff --git a/drivers/media/usb/cpia2/cpia2.h b/drivers/staging/media/cpia2/cpia2.h
similarity index 100%
rename from drivers/media/usb/cpia2/cpia2.h
rename to drivers/staging/media/cpia2/cpia2.h
diff --git a/drivers/media/usb/cpia2/cpia2_core.c b/drivers/staging/media/cpia2/cpia2_core.c
similarity index 100%
rename from drivers/media/usb/cpia2/cpia2_core.c
rename to drivers/staging/media/cpia2/cpia2_core.c
diff --git a/drivers/media/usb/cpia2/cpia2_registers.h b/drivers/staging/media/cpia2/cpia2_registers.h
similarity index 100%
rename from drivers/media/usb/cpia2/cpia2_registers.h
rename to drivers/staging/media/cpia2/cpia2_registers.h
diff --git a/drivers/media/usb/cpia2/cpia2_usb.c b/drivers/staging/media/cpia2/cpia2_usb.c
similarity index 100%
rename from drivers/media/usb/cpia2/cpia2_usb.c
rename to drivers/staging/media/cpia2/cpia2_usb.c
diff --git a/drivers/media/usb/cpia2/cpia2_v4l.c b/drivers/staging/media/cpia2/cpia2_v4l.c
similarity index 100%
rename from drivers/media/usb/cpia2/cpia2_v4l.c
rename to drivers/staging/media/cpia2/cpia2_v4l.c
-- 
2.17.0
