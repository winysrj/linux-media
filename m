Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38906 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060AbaDQONY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Apr 2014 10:13:24 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v4 07/49] adv7511: Add pad-level DV timings operations
Date: Thu, 17 Apr 2014 16:12:38 +0200
Message-Id: <1397744000-23967-8-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1397744000-23967-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1397744000-23967-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The video enum_dv_timings and dv_timings_cap operations are deprecated.
Implement the pad-level version of those operations to prepare for the
removal of the video version.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7511.c | 66 ++++++++++++++++++++++++++-------------------
 1 file changed, 38 insertions(+), 28 deletions(-)

diff --git a/drivers/media/i2c/adv7511.c b/drivers/media/i2c/adv7511.c
index 942ca4b..f4a1431 100644
--- a/drivers/media/i2c/adv7511.c
+++ b/drivers/media/i2c/adv7511.c
@@ -597,34 +597,6 @@ static int adv7511_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
 	return 0;
 }
 
-static int adv7511_get_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
-{
-	struct adv7511_state *state = get_adv7511_state(sd);
-
-	if (edid->pad != 0)
-		return -EINVAL;
-	if ((edid->blocks == 0) || (edid->blocks > 256))
-		return -EINVAL;
-	if (!edid->edid)
-		return -EINVAL;
-	if (!state->edid.segments) {
-		v4l2_dbg(1, debug, sd, "EDID segment 0 not found\n");
-		return -ENODATA;
-	}
-	if (edid->start_block >= state->edid.segments * 2)
-		return -E2BIG;
-	if ((edid->blocks + edid->start_block) >= state->edid.segments * 2)
-		edid->blocks = state->edid.segments * 2 - edid->start_block;
-
-	memcpy(edid->edid, &state->edid.data[edid->start_block * 128],
-			128 * edid->blocks);
-	return 0;
-}
-
-static const struct v4l2_subdev_pad_ops adv7511_pad_ops = {
-	.get_edid = adv7511_get_edid,
-};
-
 static const struct v4l2_subdev_core_ops adv7511_core_ops = {
 	.log_status = adv7511_log_status,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
@@ -700,12 +672,18 @@ static int adv7511_g_dv_timings(struct v4l2_subdev *sd,
 static int adv7511_enum_dv_timings(struct v4l2_subdev *sd,
 				   struct v4l2_enum_dv_timings *timings)
 {
+	if (timings->pad != 0)
+		return -EINVAL;
+
 	return v4l2_enum_dv_timings_cap(timings, &adv7511_timings_cap, NULL, NULL);
 }
 
 static int adv7511_dv_timings_cap(struct v4l2_subdev *sd,
 				  struct v4l2_dv_timings_cap *cap)
 {
+	if (cap->pad != 0)
+		return -EINVAL;
+
 	*cap = adv7511_timings_cap;
 	return 0;
 }
@@ -797,6 +775,38 @@ static const struct v4l2_subdev_audio_ops adv7511_audio_ops = {
 	.s_routing = adv7511_s_routing,
 };
 
+/* ---------------------------- PAD OPS ------------------------------------- */
+
+static int adv7511_get_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
+{
+	struct adv7511_state *state = get_adv7511_state(sd);
+
+	if (edid->pad != 0)
+		return -EINVAL;
+	if ((edid->blocks == 0) || (edid->blocks > 256))
+		return -EINVAL;
+	if (!edid->edid)
+		return -EINVAL;
+	if (!state->edid.segments) {
+		v4l2_dbg(1, debug, sd, "EDID segment 0 not found\n");
+		return -ENODATA;
+	}
+	if (edid->start_block >= state->edid.segments * 2)
+		return -E2BIG;
+	if ((edid->blocks + edid->start_block) >= state->edid.segments * 2)
+		edid->blocks = state->edid.segments * 2 - edid->start_block;
+
+	memcpy(edid->edid, &state->edid.data[edid->start_block * 128],
+			128 * edid->blocks);
+	return 0;
+}
+
+static const struct v4l2_subdev_pad_ops adv7511_pad_ops = {
+	.get_edid = adv7511_get_edid,
+	.enum_dv_timings = adv7511_enum_dv_timings,
+	.dv_timings_cap = adv7511_dv_timings_cap,
+};
+
 /* --------------------- SUBDEV OPS --------------------------------------- */
 
 static const struct v4l2_subdev_ops adv7511_ops = {
-- 
1.8.3.2

