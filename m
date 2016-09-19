Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58292 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750750AbcISRmr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 13:42:47 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Charles-Antoine Couret <charles-antoine.couret@nexvision.fr>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH] [media] gs1662: make checkpatch happy
Date: Mon, 19 Sep 2016 14:42:18 -0300
Message-Id: <3c3ba5452e8a0e2dd9fb89222feb88f11ec6ff7a.1474306935.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

WARNING: line over 80 characters
+			     GS_HEIGHT_MAX, GS_PIXELCLOCK_MIN, GS_PIXELCLOCK_MAX,

WARNING: line over 80 characters
+		if (v4l2_match_dv_timings(timings, &reg_fmt[i].format, 0, false))

WARNING: Block comments use a trailing */ on a separate line
+	 * which looks like a video signal activity.*/

WARNING: else is not generally useful after a break or return
+		return gs_write_register(gs->pdev, REG_FORCE_FMT, reg_value);
+	} else {

WARNING: Block comments use a trailing */ on a separate line
+	 * which looks like a video signal activity.*/

ERROR: spaces required around that '=' (ctx:VxW)
+	.enum_dv_timings= gs_enum_dv_timings,
 	                ^

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/spi/gs1662.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/media/spi/gs1662.c b/drivers/media/spi/gs1662.c
index f74342339e5a..d76f36233f43 100644
--- a/drivers/media/spi/gs1662.c
+++ b/drivers/media/spi/gs1662.c
@@ -134,7 +134,8 @@ static const struct v4l2_dv_timings_cap gs_timings_cap = {
 	/* keep this initialization for compatibility with GCC < 4.4.6 */
 	.reserved = { 0 },
 	V4L2_INIT_BT_TIMINGS(GS_WIDTH_MIN, GS_WIDTH_MAX, GS_HEIGHT_MIN,
-			     GS_HEIGHT_MAX, GS_PIXELCLOCK_MIN, GS_PIXELCLOCK_MAX,
+			     GS_HEIGHT_MAX, GS_PIXELCLOCK_MIN,
+			     GS_PIXELCLOCK_MAX,
 			     V4L2_DV_BT_STD_CEA861 | V4L2_DV_BT_STD_SDI,
 			     V4L2_DV_BT_CAP_PROGRESSIVE
 			     | V4L2_DV_BT_CAP_INTERLACED)
@@ -237,7 +238,8 @@ static u16 get_register_timings(struct v4l2_dv_timings *timings)
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(reg_fmt); i++) {
-		if (v4l2_match_dv_timings(timings, &reg_fmt[i].format, 0, false))
+		if (v4l2_match_dv_timings(timings, &reg_fmt[i].format, 0,
+					  false))
 			return reg_fmt[i].reg_value | MASK_FORCE_STD;
 	}
 
@@ -283,8 +285,10 @@ static int gs_query_dv_timings(struct v4l2_subdev *sd,
 	if (gs->enabled)
 		return -EBUSY;
 
-	/* Check if the component detect a line, a frame or something else
-	 * which looks like a video signal activity.*/
+	/*
+	 * Check if the component detect a line, a frame or something else
+	 * which looks like a video signal activity.
+	 */
 	for (i = 0; i < 4; i++) {
 		gs_read_register(gs->pdev, REG_LINES_PER_FRAME + i, &reg_value);
 		if (reg_value)
@@ -337,10 +341,10 @@ static int gs_s_stream(struct v4l2_subdev *sd, int enable)
 		/* To force the specific format */
 		reg_value = get_register_timings(&gs->current_timings);
 		return gs_write_register(gs->pdev, REG_FORCE_FMT, reg_value);
-	} else {
-		/* To renable auto-detection mode */
-		return gs_write_register(gs->pdev, REG_FORCE_FMT, 0x0);
 	}
+
+	/* To renable auto-detection mode */
+	return gs_write_register(gs->pdev, REG_FORCE_FMT, 0x0);
 }
 
 static int gs_g_input_status(struct v4l2_subdev *sd, u32 *status)
@@ -349,8 +353,10 @@ static int gs_g_input_status(struct v4l2_subdev *sd, u32 *status)
 	u16 reg_value, i;
 	int ret;
 
-	/* Check if the component detect a line, a frame or something else
-	 * which looks like a video signal activity.*/
+	/*
+	 * Check if the component detect a line, a frame or something else
+	 * which looks like a video signal activity.
+	 */
 	for (i = 0; i < 4; i++) {
 		ret = gs_read_register(gs->pdev,
 				       REG_LINES_PER_FRAME + i, &reg_value);
@@ -404,7 +410,7 @@ static const struct v4l2_subdev_video_ops gs_video_ops = {
 };
 
 static const struct v4l2_subdev_pad_ops gs_pad_ops = {
-	.enum_dv_timings= gs_enum_dv_timings,
+	.enum_dv_timings = gs_enum_dv_timings,
 	.dv_timings_cap = gs_dv_timings_cap,
 };
 
-- 
2.7.4

