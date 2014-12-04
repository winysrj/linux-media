Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:45023 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753729AbaLDJ4G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Dec 2014 04:56:06 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, laurent.pinchart@ideasonboard.com,
	prabhakar.csengg@gmail.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 5/8] media/i2c/Kconfig: drop superfluous MEDIA_CONTROLLER
Date: Thu,  4 Dec 2014 10:54:56 +0100
Message-Id: <1417686899-30149-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1417686899-30149-1-git-send-email-hverkuil@xs4all.nl>
References: <1417686899-30149-1-git-send-email-hverkuil@xs4all.nl>
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
index f40b4cf..29276fd 100644
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
 
@@ -431,7 +431,7 @@ config VIDEO_ADV7393
 
 config VIDEO_ADV7511
 	tristate "Analog Devices ADV7511 encoder"
-	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API && MEDIA_CONTROLLER
+	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
 	---help---
 	  Support for the Analog Devices ADV7511 video encoder.
 
-- 
2.1.3

