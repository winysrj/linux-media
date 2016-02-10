Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:53882 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751755AbcBJHlB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Feb 2016 02:41:01 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: =?UTF-8?Q?Richard_R=c3=b6jfors?= <richard@puffinpack.se>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] timblogiw: move to staging in preparation for removal
Message-ID: <56BAE988.1050106@xs4all.nl>
Date: Wed, 10 Feb 2016 08:40:56 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Timberdale FPGA video driver has not seen any real development
since 2011 (and very little before that).

One of the problems with the timblogiw driver is that it uses videobuf
instead of the newer vb2 framework. The long term goal is to either
convert or remove any driver still using videobuf. Since none of the
core v4l developers has the hardware, we cannot convert it ourselves.

As far as I can tell it was only used in an Intel demo board in 2009
using Meego:

http://www.chinait.com/intelcontent/intelprc/admin/PDFFile/20106411545.pdf

which has since been superseded.

Moving this driver to staging is the first step towards removal. After 2 or
3 kernel cycles it will be removed altogether unless someone steps up to
clean up this driver.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Richard Röjfors <richard@puffinpack.se>
---
 drivers/media/platform/Kconfig                             |  9 ---------
 drivers/media/platform/Makefile                            |  1 -
 drivers/staging/media/Kconfig                              |  2 ++
 drivers/staging/media/Makefile                             |  2 +-
 drivers/staging/media/timb/Kconfig                         | 11 +++++++++++
 drivers/staging/media/timb/Makefile                        |  1 +
 drivers/{media/platform => staging/media/timb}/timblogiw.c |  0
 7 files changed, 15 insertions(+), 11 deletions(-)
 create mode 100644 drivers/staging/media/timb/Kconfig
 create mode 100644 drivers/staging/media/timb/Makefile
 rename drivers/{media/platform => staging/media/timb}/timblogiw.c (100%)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index fd4fcd5..625ea4f 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -54,15 +54,6 @@ config VIDEO_VIU
 	  Say Y here if you want to enable VIU device on MPC5121e Rev2+.
 	  In doubt, say N.

-config VIDEO_TIMBERDALE
-	tristate "Support for timberdale Video In/LogiWIN"
-	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API && HAS_DMA
-	depends on (MFD_TIMBERDALE && TIMB_DMA) || COMPILE_TEST
-	select VIDEO_ADV7180
-	select VIDEOBUF_DMA_CONTIG
-	---help---
-	  Add support for the Video In peripherial of the timberdale FPGA.
-
 config VIDEO_M32R_AR
 	tristate "AR devices"
 	depends on VIDEO_V4L2
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index 028a723..bbb7bd1 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -2,7 +2,6 @@
 # Makefile for the video capture/playback device drivers.
 #

-obj-$(CONFIG_VIDEO_TIMBERDALE)	+= timblogiw.o
 obj-$(CONFIG_VIDEO_M32R_AR_M64278) += arv.o

 obj-$(CONFIG_VIDEO_VIA_CAMERA) += via-camera.o
diff --git a/drivers/staging/media/Kconfig b/drivers/staging/media/Kconfig
index 1469768..d48a5c2 100644
--- a/drivers/staging/media/Kconfig
+++ b/drivers/staging/media/Kconfig
@@ -31,6 +31,8 @@ source "drivers/staging/media/mn88473/Kconfig"

 source "drivers/staging/media/omap4iss/Kconfig"

+source "drivers/staging/media/timb/Kconfig"
+
 # Keep LIRC at the end, as it has sub-menus
 source "drivers/staging/media/lirc/Kconfig"

diff --git a/drivers/staging/media/Makefile b/drivers/staging/media/Makefile
index 34c557b..bf943d7 100644
--- a/drivers/staging/media/Makefile
+++ b/drivers/staging/media/Makefile
@@ -4,4 +4,4 @@ obj-$(CONFIG_LIRC_STAGING)	+= lirc/
 obj-$(CONFIG_VIDEO_DM365_VPFE)	+= davinci_vpfe/
 obj-$(CONFIG_VIDEO_OMAP4)	+= omap4iss/
 obj-$(CONFIG_DVB_MN88472)       += mn88472/
-obj-$(CONFIG_DVB_MN88473)       += mn88473/
+obj-$(CONFIG_VIDEO_TIMBERDALE)  += timb/
diff --git a/drivers/staging/media/timb/Kconfig b/drivers/staging/media/timb/Kconfig
new file mode 100644
index 0000000..e413fec
--- /dev/null
+++ b/drivers/staging/media/timb/Kconfig
@@ -0,0 +1,11 @@
+config VIDEO_TIMBERDALE
+	tristate "Support for timberdale Video In/LogiWIN"
+	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API && HAS_DMA
+	depends on (MFD_TIMBERDALE && TIMB_DMA) || COMPILE_TEST
+	select VIDEO_ADV7180
+	select VIDEOBUF_DMA_CONTIG
+	---help---
+	  Add support for the Video In peripherial of the timberdale FPGA.
+
+	  This driver is deprecated and will be removed soon unless someone
+	  will start the work to convert this driver to the vb2 framework.
diff --git a/drivers/staging/media/timb/Makefile b/drivers/staging/media/timb/Makefile
new file mode 100644
index 0000000..4c989c2
--- /dev/null
+++ b/drivers/staging/media/timb/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_VIDEO_TIMBERDALE)	+= timblogiw.o
diff --git a/drivers/media/platform/timblogiw.c b/drivers/staging/media/timb/timblogiw.c
similarity index 100%
rename from drivers/media/platform/timblogiw.c
rename to drivers/staging/media/timb/timblogiw.c
-- 
2.7.0

