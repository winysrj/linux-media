Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4272 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757539Ab2ENTMN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 May 2012 15:12:13 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 1/2] pms/w9966/bw-qcam/c-qcam: mark drivers as deprecated.
Date: Mon, 14 May 2012 21:11:58 +0200
Message-Id: <c367be3c7c534b7b3124bd45dbdd87776e86fec7.1337022203.git.hans.verkuil@cisco.com>
In-Reply-To: <1337022719-13868-1-git-send-email-hverkuil@xs4all.nl>
References: <1337022719-13868-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Nobody has the hardware anymore to test it with, and really nobody cares.
Deprecated these drivers.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/Kconfig |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 3dc0ea7..6c092dc 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -813,9 +813,12 @@ menuconfig V4L_ISA_PARPORT_DRIVERS
 if V4L_ISA_PARPORT_DRIVERS
 
 config VIDEO_BWQCAM
-	tristate "Quickcam BW Video For Linux"
+	tristate "Quickcam BW Video For Linux (DEPRECATED)"
 	depends on PARPORT && VIDEO_V4L2
 	help
+	  This driver is DEPRECATED due to lack of hardware to test it and
+	  because parallel port webcams are obsolete.
+
 	  Say Y have if you the black and white version of the QuickCam
 	  camera. See the next option for the color version.
 
@@ -823,9 +826,12 @@ config VIDEO_BWQCAM
 	  module will be called bw-qcam.
 
 config VIDEO_CQCAM
-	tristate "QuickCam Colour Video For Linux"
+	tristate "QuickCam Colour Video For Linux (DEPRECATED)"
 	depends on PARPORT && VIDEO_V4L2
 	help
+	  This driver is DEPRECATED due to lack of hardware to test it and
+	  because parallel port webcams are obsolete.
+
 	  This is the video4linux driver for the colour version of the
 	  Connectix QuickCam.  If you have one of these cameras, say Y here,
 	  otherwise say N.  This driver does not work with the original
@@ -834,9 +840,12 @@ config VIDEO_CQCAM
 	  Read <file:Documentation/video4linux/CQcam.txt> for more information.
 
 config VIDEO_PMS
-	tristate "Mediavision Pro Movie Studio Video For Linux"
+	tristate "Mediavision Pro Movie Studio Video For Linux (DEPRECATED)"
 	depends on ISA && VIDEO_V4L2
 	help
+	  This driver is DEPRECATED due to lack of hardware to test it and
+	  because ISA capture boards are obsolete.
+
 	  Say Y if you have the ISA Mediavision Pro Movie Studio
 	  capture card.
 
@@ -844,9 +853,12 @@ config VIDEO_PMS
 	  module will be called pms.
 
 config VIDEO_W9966
-	tristate "W9966CF Webcam (FlyCam Supra and others) Video For Linux"
+	tristate "W9966CF Webcam (FlyCam Supra and others) Video For Linux (DEPRECATED)"
 	depends on PARPORT_1284 && PARPORT && VIDEO_V4L2
 	help
+	  This driver is DEPRECATED due to lack of hardware to test it and
+	  because parallel port webcams are obsolete.
+
 	  Video4linux driver for Winbond's w9966 based Webcams.
 	  Currently tested with the LifeView FlyCam Supra.
 	  If you have one of these cameras, say Y here
-- 
1.7.10

