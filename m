Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3540 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758464Ab1I3MUH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Sep 2011 08:20:07 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv3 PATCH 3/7] V4L menu: remove the EXPERIMENTAL tag from vino and c-qcam.
Date: Fri, 30 Sep 2011 14:18:30 +0200
Message-Id: <0e431ebd7dd3134f0549c669377510396c89d87f.1317384926.git.hans.verkuil@cisco.com>
In-Reply-To: <1317385114-7475-1-git-send-email-hverkuil@xs4all.nl>
References: <1317385114-7475-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <9198dc44ea6f7b8e481c8e6bb24c80fc1b2429ed.1317384926.git.hans.verkuil@cisco.com>
References: <9198dc44ea6f7b8e481c8e6bb24c80fc1b2429ed.1317384926.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

These are really, really old drivers. These are really no longer experimental...

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/Kconfig |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 00b97dd..8d1c6cb 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -688,8 +688,8 @@ source "drivers/media/video/bt8xx/Kconfig"
 source "drivers/media/video/cpia2/Kconfig"
 
 config VIDEO_VINO
-	tristate "SGI Vino Video For Linux (EXPERIMENTAL)"
-	depends on I2C && SGI_IP22 && EXPERIMENTAL && VIDEO_V4L2
+	tristate "SGI Vino Video For Linux"
+	depends on I2C && SGI_IP22 && VIDEO_V4L2
 	select VIDEO_SAA7191 if VIDEO_HELPER_CHIPS_AUTO
 	help
 	  Say Y here to build in support for the Vino video input system found
@@ -798,8 +798,8 @@ config VIDEO_BWQCAM
 	  module will be called bw-qcam.
 
 config VIDEO_CQCAM
-	tristate "QuickCam Colour Video For Linux (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && PARPORT && VIDEO_V4L2
+	tristate "QuickCam Colour Video For Linux"
+	depends on PARPORT && VIDEO_V4L2
 	help
 	  This is the video4linux driver for the colour version of the
 	  Connectix QuickCam.  If you have one of these cameras, say Y here,
-- 
1.7.6.3

