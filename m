Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:60831 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753615AbcGDNfC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jul 2016 09:35:02 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/7] adv7511: drop adv7511_set_IT_content_AVI_InfoFrame
Date: Mon,  4 Jul 2016 15:34:46 +0200
Message-Id: <1467639292-1066-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1467639292-1066-1-git-send-email-hverkuil@xs4all.nl>
References: <1467639292-1066-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The IT Content bit has nothing to do with CE vs IT timings.
Delete this code. This will also fix a bug where this could
override the 'content type' control, which is actually the
correct place to set/clear the ITC bit.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7511.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/drivers/media/i2c/adv7511.c b/drivers/media/i2c/adv7511.c
index 39271c3..1695da0 100644
--- a/drivers/media/i2c/adv7511.c
+++ b/drivers/media/i2c/adv7511.c
@@ -343,18 +343,6 @@ static void adv7511_csc_rgb_full2limit(struct v4l2_subdev *sd, bool enable)
 	}
 }
 
-static void adv7511_set_IT_content_AVI_InfoFrame(struct v4l2_subdev *sd)
-{
-	struct adv7511_state *state = get_adv7511_state(sd);
-	if (state->dv_timings.bt.flags & V4L2_DV_FL_IS_CE_VIDEO) {
-		/* CE format, not IT  */
-		adv7511_wr_and_or(sd, 0x57, 0x7f, 0x00);
-	} else {
-		/* IT format */
-		adv7511_wr_and_or(sd, 0x57, 0x7f, 0x80);
-	}
-}
-
 static int adv7511_set_rgb_quantization_mode(struct v4l2_subdev *sd, struct v4l2_ctrl *ctrl)
 {
 	switch (ctrl->val) {
@@ -774,9 +762,6 @@ static int adv7511_s_dv_timings(struct v4l2_subdev *sd,
 	/* update quantization range based on new dv_timings */
 	adv7511_set_rgb_quantization_mode(sd, state->rgb_quantization_range_ctrl);
 
-	/* update AVI infoframe */
-	adv7511_set_IT_content_AVI_InfoFrame(sd);
-
 	return 0;
 }
 
-- 
2.8.1

