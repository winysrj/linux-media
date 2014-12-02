Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:43882 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932430AbaLBPlF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Dec 2014 10:41:05 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/3] vino/saa7191: move to staging in preparation for removal
Date: Tue,  2 Dec 2014 16:40:31 +0100
Message-Id: <1417534833-46844-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1417534833-46844-1-git-send-email-hverkuil@xs4all.nl>
References: <1417534833-46844-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

These drivers haven't been tested in a long, long time. The hardware is
ancient and hopelessly obsolete. These drivers also need to be converted
to newer media frameworks but due to the lack of hardware that's going
to be impossible.

So these drivers are a prime candidate for removal. If someone is
interested in working on these drivers to prevent their removal, then
please contact the linux-media mailinglist.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/Kconfig                          |  9 --------
 drivers/media/i2c/Makefile                         |  1 -
 drivers/media/platform/Kconfig                     |  8 --------
 drivers/media/platform/Makefile                    |  3 ---
 drivers/staging/media/Kconfig                      |  2 ++
 drivers/staging/media/Makefile                     |  1 +
 drivers/staging/media/vino/Kconfig                 | 24 ++++++++++++++++++++++
 drivers/staging/media/vino/Makefile                |  3 +++
 .../platform => staging/media/vino}/indycam.c      |  0
 .../platform => staging/media/vino}/indycam.h      |  0
 .../{media/i2c => staging/media/vino}/saa7191.c    |  0
 .../{media/i2c => staging/media/vino}/saa7191.h    |  0
 .../{media/platform => staging/media/vino}/vino.c  |  0
 .../{media/platform => staging/media/vino}/vino.h  |  0
 14 files changed, 30 insertions(+), 21 deletions(-)
 create mode 100644 drivers/staging/media/vino/Kconfig
 create mode 100644 drivers/staging/media/vino/Makefile
 rename drivers/{media/platform => staging/media/vino}/indycam.c (100%)
 rename drivers/{media/platform => staging/media/vino}/indycam.h (100%)
 rename drivers/{media/i2c => staging/media/vino}/saa7191.c (100%)
 rename drivers/{media/i2c => staging/media/vino}/saa7191.h (100%)
 rename drivers/{media/platform => staging/media/vino}/vino.c (100%)
 rename drivers/{media/platform => staging/media/vino}/vino.h (100%)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index f40b4cf..205d713 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -284,15 +284,6 @@ config VIDEO_SAA711X
 	  To compile this driver as a module, choose M here: the
 	  module will be called saa7115.
 
-config VIDEO_SAA7191
-	tristate "Philips SAA7191 video decoder"
-	depends on VIDEO_V4L2 && I2C
-	---help---
-	  Support for the Philips SAA7191 video decoder.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called saa7191.
-
 config VIDEO_TVP514X
 	tristate "Texas Instruments TVP514x video decoder"
 	depends on VIDEO_V4L2 && I2C
diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
index 01ae932..98589001 100644
--- a/drivers/media/i2c/Makefile
+++ b/drivers/media/i2c/Makefile
@@ -18,7 +18,6 @@ obj-$(CONFIG_VIDEO_SAA711X) += saa7115.o
 obj-$(CONFIG_VIDEO_SAA717X) += saa717x.o
 obj-$(CONFIG_VIDEO_SAA7127) += saa7127.o
 obj-$(CONFIG_VIDEO_SAA7185) += saa7185.o
-obj-$(CONFIG_VIDEO_SAA7191) += saa7191.o
 obj-$(CONFIG_VIDEO_SAA6752HS) += saa6752hs.o
 obj-$(CONFIG_VIDEO_ADV7170) += adv7170.o
 obj-$(CONFIG_VIDEO_ADV7175) += adv7175.o
diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 0c61155..dba29b8 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -65,14 +65,6 @@ config VIDEO_TIMBERDALE
 	---help---
 	  Add support for the Video In peripherial of the timberdale FPGA.
 
-config VIDEO_VINO
-	tristate "SGI Vino Video For Linux"
-	depends on I2C && SGI_IP22 && VIDEO_V4L2
-	select VIDEO_SAA7191 if MEDIA_SUBDRV_AUTOSELECT
-	help
-	  Say Y here to build in support for the Vino video input system found
-	  on SGI Indy machines.
-
 config VIDEO_M32R_AR
 	tristate "AR devices"
 	depends on VIDEO_V4L2
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index b818afb..a49936b 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -2,9 +2,6 @@
 # Makefile for the video capture/playback device drivers.
 #
 
-obj-$(CONFIG_VIDEO_VINO) += indycam.o
-obj-$(CONFIG_VIDEO_VINO) += vino.o
-
 obj-$(CONFIG_VIDEO_TIMBERDALE)	+= timblogiw.o
 obj-$(CONFIG_VIDEO_M32R_AR_M64278) += arv.o
 
diff --git a/drivers/staging/media/Kconfig b/drivers/staging/media/Kconfig
index 96498b7..6dce44e 100644
--- a/drivers/staging/media/Kconfig
+++ b/drivers/staging/media/Kconfig
@@ -33,6 +33,8 @@ source "drivers/staging/media/mn88473/Kconfig"
 
 source "drivers/staging/media/omap4iss/Kconfig"
 
+source "drivers/staging/media/vino/Kconfig"
+
 # Keep LIRC at the end, as it has sub-menus
 source "drivers/staging/media/lirc/Kconfig"
 
diff --git a/drivers/staging/media/Makefile b/drivers/staging/media/Makefile
index 30fb352..7b713e7 100644
--- a/drivers/staging/media/Makefile
+++ b/drivers/staging/media/Makefile
@@ -6,4 +6,5 @@ obj-$(CONFIG_VIDEO_DM365_VPFE)	+= davinci_vpfe/
 obj-$(CONFIG_VIDEO_OMAP4)	+= omap4iss/
 obj-$(CONFIG_DVB_MN88472)       += mn88472/
 obj-$(CONFIG_DVB_MN88473)       += mn88473/
+obj-y                           += vino/
 
diff --git a/drivers/staging/media/vino/Kconfig b/drivers/staging/media/vino/Kconfig
new file mode 100644
index 0000000..03700da
--- /dev/null
+++ b/drivers/staging/media/vino/Kconfig
@@ -0,0 +1,24 @@
+config VIDEO_VINO
+	tristate "SGI Vino Video For Linux (Deprecated)"
+	depends on I2C && SGI_IP22 && VIDEO_V4L2
+	select VIDEO_SAA7191 if MEDIA_SUBDRV_AUTOSELECT
+	help
+	  Say Y here to build in support for the Vino video input system found
+	  on SGI Indy machines.
+
+	  This driver is deprecated and will be removed soon. If you have
+	  hardware for this and you want to work on this driver, then contact
+	  the linux-media mailinglist.
+
+config VIDEO_SAA7191
+	tristate "Philips SAA7191 video decoder (Deprecated)"
+	depends on VIDEO_V4L2 && I2C
+	---help---
+	  Support for the Philips SAA7191 video decoder.
+
+	  This driver is deprecated and will be removed soon. If you have
+	  hardware for this and you want to work on this driver, then contact
+	  the linux-media mailinglist.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called saa7191.
diff --git a/drivers/staging/media/vino/Makefile b/drivers/staging/media/vino/Makefile
new file mode 100644
index 0000000..914c251
--- /dev/null
+++ b/drivers/staging/media/vino/Makefile
@@ -0,0 +1,3 @@
+obj-$(CONFIG_VIDEO_VINO) += indycam.o
+obj-$(CONFIG_VIDEO_VINO) += vino.o
+obj-$(CONFIG_VIDEO_SAA7191) += saa7191.o
diff --git a/drivers/media/platform/indycam.c b/drivers/staging/media/vino/indycam.c
similarity index 100%
rename from drivers/media/platform/indycam.c
rename to drivers/staging/media/vino/indycam.c
diff --git a/drivers/media/platform/indycam.h b/drivers/staging/media/vino/indycam.h
similarity index 100%
rename from drivers/media/platform/indycam.h
rename to drivers/staging/media/vino/indycam.h
diff --git a/drivers/media/i2c/saa7191.c b/drivers/staging/media/vino/saa7191.c
similarity index 100%
rename from drivers/media/i2c/saa7191.c
rename to drivers/staging/media/vino/saa7191.c
diff --git a/drivers/media/i2c/saa7191.h b/drivers/staging/media/vino/saa7191.h
similarity index 100%
rename from drivers/media/i2c/saa7191.h
rename to drivers/staging/media/vino/saa7191.h
diff --git a/drivers/media/platform/vino.c b/drivers/staging/media/vino/vino.c
similarity index 100%
rename from drivers/media/platform/vino.c
rename to drivers/staging/media/vino/vino.c
diff --git a/drivers/media/platform/vino.h b/drivers/staging/media/vino/vino.h
similarity index 100%
rename from drivers/media/platform/vino.h
rename to drivers/staging/media/vino/vino.h
-- 
2.1.3

