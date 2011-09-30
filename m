Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4519 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758515Ab1I3MUH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Sep 2011 08:20:07 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv3 PATCH 2/7] V4L menu: move ISA and parport drivers into their own submenu.
Date: Fri, 30 Sep 2011 14:18:29 +0200
Message-Id: <c7d396325263f9cc714d0884e29019c0caff4582.1317384926.git.hans.verkuil@cisco.com>
In-Reply-To: <1317385114-7475-1-git-send-email-hverkuil@xs4all.nl>
References: <1317385114-7475-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <9198dc44ea6f7b8e481c8e6bb24c80fc1b2429ed.1317384926.git.hans.verkuil@cisco.com>
References: <9198dc44ea6f7b8e481c8e6bb24c80fc1b2429ed.1317384926.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/Kconfig |  102 +++++++++++++++++++++++++------------------
 1 files changed, 59 insertions(+), 43 deletions(-)

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 0f8ccb4..00b97dd 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -685,49 +685,6 @@ source "drivers/media/video/omap/Kconfig"
 
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
 source "drivers/media/video/cpia2/Kconfig"
 
 config VIDEO_VINO
@@ -817,6 +774,65 @@ source "drivers/media/video/cx18/Kconfig"
 
 source "drivers/media/video/saa7164/Kconfig"
 
+#
+# ISA & parallel port drivers configuration
+#
+
+menuconfig V4L_ISA_PARPORT_DRIVERS
+	bool "V4L ISA and parallel port devices"
+	depends on ISA || PARPORT
+	default n
+	---help---
+	  Say Y here to enable support for these ISA and parallel port drivers.
+
+if V4L_ISA_PARPORT_DRIVERS
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
+endif # V4L_ISA_PARPORT_DRIVERS
+
 source "drivers/media/video/marvell-ccic/Kconfig"
 
 config VIDEO_M32R_AR
-- 
1.7.6.3

