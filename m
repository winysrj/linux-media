Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:2684 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755700Ab1HaNj2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Aug 2011 09:39:28 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 3/6] V4L menu: remove the EXPERIMENTAL tag from vino and c-qcam.
Date: Wed, 31 Aug 2011 15:38:42 +0200
Message-Id: <76dc3bcfdd0ba0d4320f673b3ba36a8df8845c07.1314797675.git.hans.verkuil@cisco.com>
In-Reply-To: <1314797925-8113-1-git-send-email-hverkuil@xs4all.nl>
References: <1314797925-8113-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <b5c71c4b9e2f88bd5698a9920b24d24786e4a28c.1314797675.git.hans.verkuil@cisco.com>
References: <b5c71c4b9e2f88bd5698a9920b24d24786e4a28c.1314797675.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

These are really, really old drivers. These are really no longer experimental...

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/Kconfig |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 815700b..8a16a69 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -656,8 +656,8 @@ source "drivers/media/video/omap/Kconfig"
 source "drivers/media/video/bt8xx/Kconfig"
 
 config VIDEO_VINO
-	tristate "SGI Vino Video For Linux (EXPERIMENTAL)"
-	depends on I2C && SGI_IP22 && EXPERIMENTAL && VIDEO_V4L2
+	tristate "SGI Vino Video For Linux"
+	depends on I2C && SGI_IP22 && VIDEO_V4L2
 	select VIDEO_SAA7191 if VIDEO_HELPER_CHIPS_AUTO
 	help
 	  Say Y here to build in support for the Vino video input system found
@@ -1001,8 +1001,8 @@ config VIDEO_BWQCAM
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
1.7.5.4

