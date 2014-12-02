Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:43882 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932464AbaLBPlU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Dec 2014 10:41:20 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 3/3] bq/c-qcam, w9966, pms: move to staging in preparation for removal
Date: Tue,  2 Dec 2014 16:40:33 +0100
Message-Id: <1417534833-46844-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1417534833-46844-1-git-send-email-hverkuil@xs4all.nl>
References: <1417534833-46844-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

These drivers haven't been tested in a long, long time. The hardware is
ancient and hopelessly obsolete. These drivers also need to be converted
to newer media frameworks but due to the lack of hardware that's going
to be impossible. In addition, cheaper and vastly better hardware is
available today.

So these drivers are a prime candidate for removal. If someone is
interested in working on these drivers to prevent their removal, then
please contact the linux-media mailinglist.

Let's be honest, the age of parallel port webcams and ISA video capture
boards is really gone.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/Kconfig                         |  1 -
 drivers/media/Makefile                        |  2 +-
 drivers/staging/media/Kconfig                 |  2 ++
 drivers/staging/media/Makefile                |  1 +
 drivers/{ => staging}/media/parport/Kconfig   | 24 ++++++++++++++++++++----
 drivers/{ => staging}/media/parport/Makefile  |  0
 drivers/{ => staging}/media/parport/bw-qcam.c |  0
 drivers/{ => staging}/media/parport/c-qcam.c  |  0
 drivers/{ => staging}/media/parport/pms.c     |  0
 drivers/{ => staging}/media/parport/w9966.c   |  0
 10 files changed, 24 insertions(+), 6 deletions(-)
 rename drivers/{ => staging}/media/parport/Kconfig (65%)
 rename drivers/{ => staging}/media/parport/Makefile (100%)
 rename drivers/{ => staging}/media/parport/bw-qcam.c (100%)
 rename drivers/{ => staging}/media/parport/c-qcam.c (100%)
 rename drivers/{ => staging}/media/parport/pms.c (100%)
 rename drivers/{ => staging}/media/parport/w9966.c (100%)

diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index 3c89fcb..49cd308 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -160,7 +160,6 @@ source "drivers/media/usb/Kconfig"
 source "drivers/media/pci/Kconfig"
 source "drivers/media/platform/Kconfig"
 source "drivers/media/mmc/Kconfig"
-source "drivers/media/parport/Kconfig"
 source "drivers/media/radio/Kconfig"
 
 comment "Supported FireWire (IEEE 1394) Adapters"
diff --git a/drivers/media/Makefile b/drivers/media/Makefile
index 620f275..e608bbc 100644
--- a/drivers/media/Makefile
+++ b/drivers/media/Makefile
@@ -28,6 +28,6 @@ obj-y += rc/
 # Finally, merge the drivers that require the core
 #
 
-obj-y += common/ platform/ pci/ usb/ mmc/ firewire/ parport/
+obj-y += common/ platform/ pci/ usb/ mmc/ firewire/
 obj-$(CONFIG_VIDEO_DEV) += radio/
 
diff --git a/drivers/staging/media/Kconfig b/drivers/staging/media/Kconfig
index 209b265..2a054a9 100644
--- a/drivers/staging/media/Kconfig
+++ b/drivers/staging/media/Kconfig
@@ -35,6 +35,8 @@ source "drivers/staging/media/mn88473/Kconfig"
 
 source "drivers/staging/media/omap4iss/Kconfig"
 
+source "drivers/staging/media/parport/Kconfig"
+
 source "drivers/staging/media/vino/Kconfig"
 
 # Keep LIRC at the end, as it has sub-menus
diff --git a/drivers/staging/media/Makefile b/drivers/staging/media/Makefile
index a0eec73..412b284 100644
--- a/drivers/staging/media/Makefile
+++ b/drivers/staging/media/Makefile
@@ -6,6 +6,7 @@ obj-$(CONFIG_VIDEO_DM365_VPFE)	+= davinci_vpfe/
 obj-$(CONFIG_VIDEO_OMAP4)	+= omap4iss/
 obj-$(CONFIG_DVB_MN88472)       += mn88472/
 obj-$(CONFIG_DVB_MN88473)       += mn88473/
+obj-y				+= parport/
 obj-$(CONFIG_VIDEO_TLG2300)	+= tlg2300/
 obj-y                           += vino/
 
diff --git a/drivers/media/parport/Kconfig b/drivers/staging/media/parport/Kconfig
similarity index 65%
rename from drivers/media/parport/Kconfig
rename to drivers/staging/media/parport/Kconfig
index 948c981..15974ef 100644
--- a/drivers/media/parport/Kconfig
+++ b/drivers/staging/media/parport/Kconfig
@@ -7,18 +7,22 @@ menuconfig MEDIA_PARPORT_SUPPORT
 
 if MEDIA_PARPORT_SUPPORT
 config VIDEO_BWQCAM
-	tristate "Quickcam BW Video For Linux"
+	tristate "Quickcam BW Video For Linux (Deprecated)"
 	depends on PARPORT && VIDEO_V4L2
 	select VIDEOBUF2_VMALLOC
 	help
 	  Say Y have if you the black and white version of the QuickCam
 	  camera. See the next option for the color version.
 
+	  This driver is deprecated and will be removed soon. If you have
+	  hardware for this and you want to work on this driver, then contact
+	  the linux-media mailinglist.
+
 	  To compile this driver as a module, choose M here: the
 	  module will be called bw-qcam.
 
 config VIDEO_CQCAM
-	tristate "QuickCam Colour Video For Linux"
+	tristate "QuickCam Colour Video For Linux (Deprecated)"
 	depends on PARPORT && VIDEO_V4L2
 	help
 	  This is the video4linux driver for the colour version of the
@@ -28,18 +32,26 @@ config VIDEO_CQCAM
 	  as a module (c-qcam).
 	  Read <file:Documentation/video4linux/CQcam.txt> for more information.
 
+	  This driver is deprecated and will be removed soon. If you have
+	  hardware for this and you want to work on this driver, then contact
+	  the linux-media mailinglist.
+
 config VIDEO_PMS
-	tristate "Mediavision Pro Movie Studio Video For Linux"
+	tristate "Mediavision Pro Movie Studio Video For Linux (Deprecated)"
 	depends on ISA && VIDEO_V4L2
 	help
 	  Say Y if you have the ISA Mediavision Pro Movie Studio
 	  capture card.
 
+	  This driver is deprecated and will be removed soon. If you have
+	  hardware for this and you want to work on this driver, then contact
+	  the linux-media mailinglist.
+
 	  To compile this driver as a module, choose M here: the
 	  module will be called pms.
 
 config VIDEO_W9966
-	tristate "W9966CF Webcam (FlyCam Supra and others) Video For Linux"
+	tristate "W9966CF Webcam (FlyCam Supra and others) Video For Linux (Deprecated)"
 	depends on PARPORT_1284 && PARPORT && VIDEO_V4L2
 	help
 	  Video4linux driver for Winbond's w9966 based Webcams.
@@ -50,4 +62,8 @@ config VIDEO_W9966
 
 	  Check out <file:Documentation/video4linux/w9966.txt> for more
 	  information.
+
+	  This driver is deprecated and will be removed soon. If you have
+	  hardware for this and you want to work on this driver, then contact
+	  the linux-media mailinglist.
 endif
diff --git a/drivers/media/parport/Makefile b/drivers/staging/media/parport/Makefile
similarity index 100%
rename from drivers/media/parport/Makefile
rename to drivers/staging/media/parport/Makefile
diff --git a/drivers/media/parport/bw-qcam.c b/drivers/staging/media/parport/bw-qcam.c
similarity index 100%
rename from drivers/media/parport/bw-qcam.c
rename to drivers/staging/media/parport/bw-qcam.c
diff --git a/drivers/media/parport/c-qcam.c b/drivers/staging/media/parport/c-qcam.c
similarity index 100%
rename from drivers/media/parport/c-qcam.c
rename to drivers/staging/media/parport/c-qcam.c
diff --git a/drivers/media/parport/pms.c b/drivers/staging/media/parport/pms.c
similarity index 100%
rename from drivers/media/parport/pms.c
rename to drivers/staging/media/parport/pms.c
diff --git a/drivers/media/parport/w9966.c b/drivers/staging/media/parport/w9966.c
similarity index 100%
rename from drivers/media/parport/w9966.c
rename to drivers/staging/media/parport/w9966.c
-- 
2.1.3

