Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:44765 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752092AbaLSOwR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Dec 2014 09:52:17 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, g.liakhovetski@gmx.de,
	prabhakar.csengg@gmail.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 04/11] media/i2c/Kconfig: drop superfluous MEDIA_CONTROLLER
Date: Fri, 19 Dec 2014 15:51:29 +0100
Message-Id: <1419000696-25202-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1419000696-25202-1-git-send-email-hverkuil@xs4all.nl>
References: <1419000696-25202-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

These drivers depend on VIDEO_V4L2_SUBDEV_API, which in turn
depends on MEDIA_CONTROLLER. So it is sufficient to just depend
on VIDEO_V4L2_SUBDEV_API.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/Kconfig | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 205d713..ca84543 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -196,7 +196,7 @@ config VIDEO_ADV7183
 
 config VIDEO_ADV7604
 	tristate "Analog Devices ADV7604 decoder"
-	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API && MEDIA_CONTROLLER
+	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
 	---help---
 	  Support for the Analog Devices ADV7604 video decoder.
 
@@ -208,7 +208,7 @@ config VIDEO_ADV7604
 
 config VIDEO_ADV7842
 	tristate "Analog Devices ADV7842 decoder"
-	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API && MEDIA_CONTROLLER
+	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
 	---help---
 	  Support for the Analog Devices ADV7842 video decoder.
 
@@ -422,7 +422,7 @@ config VIDEO_ADV7393
 
 config VIDEO_ADV7511
 	tristate "Analog Devices ADV7511 encoder"
-	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API && MEDIA_CONTROLLER
+	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
 	---help---
 	  Support for the Analog Devices ADV7511 video encoder.
 
-- 
2.1.3

