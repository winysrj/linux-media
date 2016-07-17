Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:44954 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750940AbcGQJC5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 05:02:57 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 2EF30180C37
	for <linux-media@vger.kernel.org>; Sun, 17 Jul 2016 11:02:51 +0200 (CEST)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] adv7511: fix VIC autodetect
Message-ID: <18fc7b36-df66-7cd7-ccba-571c27426f42@xs4all.nl>
Date: Sun, 17 Jul 2016 11:02:51 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The adv7511 will automatically fill in the VIC code in the AVI InfoFrame
based on the timings of the incoming pixelport signals.

However, to have this work correctly it needs to specify the fps
value in a register. After doing this the proper VIC code is filled in.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7511.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/adv7511.c b/drivers/media/i2c/adv7511.c
index 6d7cad5..53030d6 100644
--- a/drivers/media/i2c/adv7511.c
+++ b/drivers/media/i2c/adv7511.c
@@ -1041,6 +1041,8 @@ static int adv7511_s_dv_timings(struct v4l2_subdev *sd,
 			       struct v4l2_dv_timings *timings)
 {
 	struct adv7511_state *state = get_adv7511_state(sd);
+	struct v4l2_bt_timings *bt = &timings->bt;
+	u32 fps;

 	v4l2_dbg(1, debug, sd, "%s:\n", __func__);

@@ -1052,15 +1054,29 @@ static int adv7511_s_dv_timings(struct v4l2_subdev *sd,
 	   if the format is one of the CEA or DMT timings. */
 	v4l2_find_dv_timings_cap(timings, &adv7511_timings_cap, 0, NULL, NULL);

-	timings->bt.flags &= ~V4L2_DV_FL_REDUCED_FPS;
-
 	/* save timings */
 	state->dv_timings = *timings;

 	/* set h/vsync polarities */
 	adv7511_wr_and_or(sd, 0x17, 0x9f,
-		((timings->bt.polarities & V4L2_DV_VSYNC_POS_POL) ? 0 : 0x40) |
-		((timings->bt.polarities & V4L2_DV_HSYNC_POS_POL) ? 0 : 0x20));
+		((bt->polarities & V4L2_DV_VSYNC_POS_POL) ? 0 : 0x40) |
+		((bt->polarities & V4L2_DV_HSYNC_POS_POL) ? 0 : 0x20));
+
+	fps = (u32)bt->pixelclock / (V4L2_DV_BT_FRAME_WIDTH(bt) * V4L2_DV_BT_FRAME_HEIGHT(bt));
+	switch (fps) {
+	case 24:
+		adv7511_wr_and_or(sd, 0xfb, 0xf9, 1 << 1);
+		break;
+	case 25:
+		adv7511_wr_and_or(sd, 0xfb, 0xf9, 2 << 1);
+		break;
+	case 30:
+		adv7511_wr_and_or(sd, 0xfb, 0xf9, 3 << 1);
+		break;
+	default:
+		adv7511_wr_and_or(sd, 0xfb, 0xf9, 0);
+		break;
+	}

 	/* update quantization range based on new dv_timings */
 	adv7511_set_rgb_quantization_mode(sd, state->rgb_quantization_range_ctrl);
-- 
2.8.1

