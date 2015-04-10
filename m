Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:33034 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828AbbDJV2i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Apr 2015 17:28:38 -0400
Received: by wgin8 with SMTP id n8so29518290wgi.0
        for <linux-media@vger.kernel.org>; Fri, 10 Apr 2015 14:28:37 -0700 (PDT)
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Cc: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH] media: i2c: ov2659: add VIDEO_V4L2_SUBDEV_API dependency
Date: Fri, 10 Apr 2015 22:28:33 +0100
Message-Id: <1428701313-16367-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

this patch adds dependency of VIDEO_V4L2_SUBDEV_API
for VIDEO_OV2659 so that it doesn't complain for random
config builds.

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/i2c/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 6f30ea7..8b05681 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -468,7 +468,7 @@ config VIDEO_SMIAPP_PLL
 
 config VIDEO_OV2659
 	tristate "OmniVision OV2659 sensor support"
-	depends on VIDEO_V4L2 && I2C
+	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
 	depends on MEDIA_CAMERA_SUPPORT
 	---help---
 	  This is a Video4Linux2 sensor-level driver for the OmniVision
-- 
2.1.0

