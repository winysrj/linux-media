Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56883 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936480AbcIHVhu (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 17:37:50 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 14/15] [media] v4l2-flash-led-class.h: document v4l2_flash_ops
Date: Thu,  8 Sep 2016 18:37:40 -0300
Message-Id: <e6996867c1675c08c47ddc8dc93f815172709903.1473370390.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473370390.git.mchehab@s-opensource.com>
References: <cover.1473370390.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473370390.git.mchehab@s-opensource.com>
References: <cover.1473370390.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix this warning:
	./include/media/v4l2-flash-led-class.h:103: WARNING: c:type reference target not found: v4l2_flash_ops

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/media/v4l2-flash-led-class.h | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/include/media/v4l2-flash-led-class.h b/include/media/v4l2-flash-led-class.h
index 3d184ab52274..b0fe4d6f4a5f 100644
--- a/include/media/v4l2-flash-led-class.h
+++ b/include/media/v4l2-flash-led-class.h
@@ -20,7 +20,7 @@ struct led_classdev;
 struct v4l2_flash;
 enum led_brightness;
 
-/*
+/**
  * struct v4l2_flash_ctrl_data - flash control initialization data, filled
  *				basing on the features declared by the LED flash
  *				class driver in the v4l2_flash_config
@@ -33,14 +33,21 @@ struct v4l2_flash_ctrl_data {
 	u32 cid;
 };
 
+/**
+ * struct v4l2_flash_ops - V4L2 flash operations
+ *
+ * @external_strobe_set: Setup strobing the flash by hardware pin state
+ *	assertion.
+ * @intensity_to_led_brightness: Convert intensity to brightness in a device
+ *	specific manner
+ * @led_brightness_to_intensity: convert brightness to intensity in a device
+ *	specific manner.
+ */
 struct v4l2_flash_ops {
-	/* setup strobing the flash by hardware pin state assertion */
 	int (*external_strobe_set)(struct v4l2_flash *v4l2_flash,
 					bool enable);
-	/* convert intensity to brightness in a device specific manner */
 	enum led_brightness (*intensity_to_led_brightness)
 		(struct v4l2_flash *v4l2_flash, s32 intensity);
-	/* convert brightness to intensity in a device specific manner */
 	s32 (*led_brightness_to_intensity)
 		(struct v4l2_flash *v4l2_flash, enum led_brightness);
 };
-- 
2.7.4


