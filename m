Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1365 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755883Ab1HaNj2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Aug 2011 09:39:28 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 2/6] V4L menu: move legacy drivers into their own submenu.
Date: Wed, 31 Aug 2011 15:38:41 +0200
Message-Id: <838c371cecce26c959eb550bc6f25f6f94b75b13.1314797675.git.hans.verkuil@cisco.com>
In-Reply-To: <1314797925-8113-1-git-send-email-hverkuil@xs4all.nl>
References: <1314797925-8113-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <b5c71c4b9e2f88bd5698a9920b24d24786e4a28c.1314797675.git.hans.verkuil@cisco.com>
References: <b5c71c4b9e2f88bd5698a9920b24d24786e4a28c.1314797675.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/Kconfig |  185 +++++++++++++++++++++++-------------------
 1 files changed, 101 insertions(+), 84 deletions(-)

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 336251f..815700b 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -655,51 +655,6 @@ source "drivers/media/video/omap/Kconfig"
 
 source "drivers/media/video/bt8xx/Kconfig"
 
-config VIDEO_PMS
-	tristate "Mediavision Pro Movie Studio Video For Linux"
-	depends on ISA && VIDEO_V4L2
-	help
-	  Say Y if you have such a thing.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called pms.
-
-config VIDEO_BWQCAM
-	tristate "Quickcam BW Video For Linux"
-	depends on PARPORT && VIDEO_V4L2
-	help
-	  Say Y have if you the black and white version of the QuickCam
-	  camera. See the next option for the color version.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called bw-qcam.
-
-config VIDEO_CQCAM
-	tristate "QuickCam Colour Video For Linux (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && PARPORT && VIDEO_V4L2
-	help
-	  This is the video4linux driver for the colour version of the
-	  Connectix QuickCam.  If you have one of these cameras, say Y here,
-	  otherwise say N.  This driver does not work with the original
-	  monochrome QuickCam, QuickCam VC or QuickClip.  It is also available
-	  as a module (c-qcam).
-	  Read <file:Documentation/video4linux/CQcam.txt> for more information.
-
-config VIDEO_W9966
-	tristate "W9966CF Webcam (FlyCam Supra and others) Video For Linux"
-	depends on PARPORT_1284 && PARPORT && VIDEO_V4L2
-	help
-	  Video4linux driver for Winbond's w9966 based Webcams.
-	  Currently tested with the LifeView FlyCam Supra.
-	  If you have one of these cameras, say Y here
-	  otherwise say N.
-	  This driver is also available as a module (w9966).
-
-	  Check out <file:Documentation/video4linux/w9966.txt> for more
-	  information.
-
-source "drivers/media/video/cpia2/Kconfig"
-
 config VIDEO_VINO
 	tristate "SGI Vino Video For Linux (EXPERIMENTAL)"
 	depends on I2C && SGI_IP22 && EXPERIMENTAL && VIDEO_V4L2
@@ -726,45 +681,6 @@ config VIDEO_MEYE
 
 source "drivers/media/video/saa7134/Kconfig"
 
-config VIDEO_MXB
-	tristate "Siemens-Nixdorf 'Multimedia eXtension Board'"
-	depends on PCI && VIDEO_V4L2 && I2C
-	select VIDEO_SAA7146_VV
-	select VIDEO_TUNER
-	select VIDEO_SAA711X if VIDEO_HELPER_CHIPS_AUTO
-	select VIDEO_TDA9840 if VIDEO_HELPER_CHIPS_AUTO
-	select VIDEO_TEA6415C if VIDEO_HELPER_CHIPS_AUTO
-	select VIDEO_TEA6420 if VIDEO_HELPER_CHIPS_AUTO
-	---help---
-	  This is a video4linux driver for the 'Multimedia eXtension Board'
-	  TV card by Siemens-Nixdorf.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called mxb.
-
-config VIDEO_HEXIUM_ORION
-	tristate "Hexium HV-PCI6 and Orion frame grabber"
-	depends on PCI && VIDEO_V4L2 && I2C
-	select VIDEO_SAA7146_VV
-	---help---
-	  This is a video4linux driver for the Hexium HV-PCI6 and
-	  Orion frame grabber cards by Hexium.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called hexium_orion.
-
-config VIDEO_HEXIUM_GEMINI
-	tristate "Hexium Gemini frame grabber"
-	depends on PCI && VIDEO_V4L2 && I2C
-	select VIDEO_SAA7146_VV
-	---help---
-	  This is a video4linux driver for the Hexium Gemini frame
-	  grabber card by Hexium. Please note that the Gemini Dual
-	  card is *not* fully supported.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called hexium_gemini.
-
 config VIDEO_TIMBERDALE
 	tristate "Support for timberdale Video In/LogiWIN"
 	depends on VIDEO_V4L2 && I2C && DMADEVICES
@@ -1050,6 +966,107 @@ config VIDEO_S5P_MIPI_CSIS
 
 source "drivers/media/video/s5p-tv/Kconfig"
 
+#
+# Legacy drivers configuration
+#
+
+menuconfig V4L_LEGACY_DRIVERS
+	bool "V4L legacy devices"
+	default n
+	---help---
+	  Say Y here to enable support for these legacy drivers. These drivers
+	  are for old and obsure hardware (e.g. parallel port webcams, ISA
+	  drivers, niche hardware).
+
+if V4L_LEGACY_DRIVERS
+
+config VIDEO_PMS
+	tristate "Mediavision Pro Movie Studio Video For Linux"
+	depends on ISA && VIDEO_V4L2
+	help
+	  Say Y if you have the ISA Mediavision Pro Movie Studio
+	  capture card.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called pms.
+
+config VIDEO_BWQCAM
+	tristate "Quickcam BW Video For Linux"
+	depends on PARPORT && VIDEO_V4L2
+	help
+	  Say Y have if you the black and white version of the QuickCam
+	  camera. See the next option for the color version.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called bw-qcam.
+
+config VIDEO_CQCAM
+	tristate "QuickCam Colour Video For Linux (EXPERIMENTAL)"
+	depends on EXPERIMENTAL && PARPORT && VIDEO_V4L2
+	help
+	  This is the video4linux driver for the colour version of the
+	  Connectix QuickCam.  If you have one of these cameras, say Y here,
+	  otherwise say N.  This driver does not work with the original
+	  monochrome QuickCam, QuickCam VC or QuickClip.  It is also available
+	  as a module (c-qcam).
+	  Read <file:Documentation/video4linux/CQcam.txt> for more information.
+
+config VIDEO_W9966
+	tristate "W9966CF Webcam (FlyCam Supra and others) Video For Linux"
+	depends on PARPORT_1284 && PARPORT && VIDEO_V4L2
+	help
+	  Video4linux driver for Winbond's w9966 based Webcams.
+	  Currently tested with the LifeView FlyCam Supra.
+	  If you have one of these cameras, say Y here
+	  otherwise say N.
+	  This driver is also available as a module (w9966).
+
+	  Check out <file:Documentation/video4linux/w9966.txt> for more
+	  information.
+
+source "drivers/media/video/cpia2/Kconfig"
+
+config VIDEO_MXB
+	tristate "Siemens-Nixdorf 'Multimedia eXtension Board'"
+	depends on PCI && VIDEO_V4L2 && I2C
+	select VIDEO_SAA7146_VV
+	select VIDEO_TUNER
+	select VIDEO_SAA711X if VIDEO_HELPER_CHIPS_AUTO
+	select VIDEO_TDA9840 if VIDEO_HELPER_CHIPS_AUTO
+	select VIDEO_TEA6415C if VIDEO_HELPER_CHIPS_AUTO
+	select VIDEO_TEA6420 if VIDEO_HELPER_CHIPS_AUTO
+	---help---
+	  This is a video4linux driver for the 'Multimedia eXtension Board'
+	  TV card by Siemens-Nixdorf.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called mxb.
+
+config VIDEO_HEXIUM_ORION
+	tristate "Hexium HV-PCI6 and Orion frame grabber"
+	depends on PCI && VIDEO_V4L2 && I2C
+	select VIDEO_SAA7146_VV
+	---help---
+	  This is a video4linux driver for the Hexium HV-PCI6 and
+	  Orion frame grabber cards by Hexium.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called hexium_orion.
+
+config VIDEO_HEXIUM_GEMINI
+	tristate "Hexium Gemini frame grabber"
+	depends on PCI && VIDEO_V4L2 && I2C
+	select VIDEO_SAA7146_VV
+	---help---
+	  This is a video4linux driver for the Hexium Gemini frame
+	  grabber card by Hexium. Please note that the Gemini Dual
+	  card is *not* fully supported.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called hexium_gemini.
+
+endif # V4L_LEGACY_DRIVERS
+
 endif # VIDEO_CAPTURE_DRIVERS
 
 menuconfig V4L_MEM2MEM_DRIVERS
-- 
1.7.5.4

