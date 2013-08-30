Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f182.google.com ([209.85.215.182]:43818 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755496Ab3H3M3m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Aug 2013 08:29:42 -0400
Received: by mail-ea0-f182.google.com with SMTP id o10so894417eaj.27
        for <linux-media@vger.kernel.org>; Fri, 30 Aug 2013 05:29:41 -0700 (PDT)
From: Gianluca Gennari <gennarone@gmail.com>
To: linux-media@vger.kernel.org, m.chehab@samsung.com,
	hans.verkuil@cisco.com
Cc: Gianluca Gennari <gennarone@gmail.com>
Subject: [PATCH 2/4] adv7511: fix compilation with GCC < 4.4.6
Date: Fri, 30 Aug 2013 14:29:23 +0200
Message-Id: <1377865765-25203-3-git-send-email-gennarone@gmail.com>
In-Reply-To: <1377865765-25203-1-git-send-email-gennarone@gmail.com>
References: <1377865765-25203-1-git-send-email-gennarone@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Gianluca Gennari <gennarone@gmail.com>
---
 drivers/media/i2c/adv7511.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/media/i2c/adv7511.c b/drivers/media/i2c/adv7511.c
index 7a57609..cc3880a 100644
--- a/drivers/media/i2c/adv7511.c
+++ b/drivers/media/i2c/adv7511.c
@@ -119,16 +119,14 @@ static int adv7511_s_clock_freq(struct v4l2_subdev *sd, u32 freq);
 
 static const struct v4l2_dv_timings_cap adv7511_timings_cap = {
 	.type = V4L2_DV_BT_656_1120,
-	.bt = {
-		.max_width = ADV7511_MAX_WIDTH,
-		.max_height = ADV7511_MAX_HEIGHT,
-		.min_pixelclock = ADV7511_MIN_PIXELCLOCK,
-		.max_pixelclock = ADV7511_MAX_PIXELCLOCK,
-		.standards = V4L2_DV_BT_STD_CEA861 | V4L2_DV_BT_STD_DMT |
+	/* keep this initialization for compatibility with GCC < 4.4.6 */
+	.reserved = { 0 },
+	V4L2_INIT_BT_TIMINGS(0, ADV7511_MAX_WIDTH, 0, ADV7511_MAX_HEIGHT,
+		ADV7511_MIN_PIXELCLOCK, ADV7511_MAX_PIXELCLOCK,
+		V4L2_DV_BT_STD_CEA861 | V4L2_DV_BT_STD_DMT |
 			V4L2_DV_BT_STD_GTF | V4L2_DV_BT_STD_CVT,
-		.capabilities = V4L2_DV_BT_CAP_PROGRESSIVE |
-			V4L2_DV_BT_CAP_REDUCED_BLANKING | V4L2_DV_BT_CAP_CUSTOM,
-	},
+		V4L2_DV_BT_CAP_PROGRESSIVE | V4L2_DV_BT_CAP_REDUCED_BLANKING |
+			V4L2_DV_BT_CAP_CUSTOM)
 };
 
 static inline struct adv7511_state *get_adv7511_state(struct v4l2_subdev *sd)
-- 
1.8.4

