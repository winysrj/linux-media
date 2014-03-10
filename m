Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48726 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912AbaCJXOi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 19:14:38 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v2 07/48] ad9389b: Add pad-level DV timings operations
Date: Tue, 11 Mar 2014 00:15:18 +0100
Message-Id: <1394493359-14115-8-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1394493359-14115-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1394493359-14115-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The video enum_dv_timings and dv_timings_cap operations are deprecated.
Implement the pad-level version of those operations to prepare for the
removal of the video version.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/ad9389b.c | 69 ++++++++++++++++++++++++++-------------------
 1 file changed, 40 insertions(+), 29 deletions(-)

diff --git a/drivers/media/i2c/ad9389b.c b/drivers/media/i2c/ad9389b.c
index 83225d6..44c037d 100644
--- a/drivers/media/i2c/ad9389b.c
+++ b/drivers/media/i2c/ad9389b.c
@@ -571,35 +571,6 @@ static const struct v4l2_subdev_core_ops ad9389b_core_ops = {
 	.interrupt_service_routine = ad9389b_isr,
 };
 
-/* ------------------------------ PAD OPS ------------------------------ */
-
-static int ad9389b_get_edid(struct v4l2_subdev *sd, struct v4l2_subdev_edid *edid)
-{
-	struct ad9389b_state *state = get_ad9389b_state(sd);
-
-	if (edid->pad != 0)
-		return -EINVAL;
-	if (edid->blocks == 0 || edid->blocks > 256)
-		return -EINVAL;
-	if (!edid->edid)
-		return -EINVAL;
-	if (!state->edid.segments) {
-		v4l2_dbg(1, debug, sd, "EDID segment 0 not found\n");
-		return -ENODATA;
-	}
-	if (edid->start_block >= state->edid.segments * 2)
-		return -E2BIG;
-	if (edid->blocks + edid->start_block >= state->edid.segments * 2)
-		edid->blocks = state->edid.segments * 2 - edid->start_block;
-	memcpy(edid->edid, &state->edid.data[edid->start_block * 128],
-	       128 * edid->blocks);
-	return 0;
-}
-
-static const struct v4l2_subdev_pad_ops ad9389b_pad_ops = {
-	.get_edid = ad9389b_get_edid,
-};
-
 /* ------------------------------ VIDEO OPS ------------------------------ */
 
 /* Enable/disable ad9389b output */
@@ -678,6 +649,9 @@ static int ad9389b_g_dv_timings(struct v4l2_subdev *sd,
 static int ad9389b_enum_dv_timings(struct v4l2_subdev *sd,
 				   struct v4l2_enum_dv_timings *timings)
 {
+	if (timings->pad != 0)
+		return -EINVAL;
+
 	return v4l2_enum_dv_timings_cap(timings, &ad9389b_timings_cap,
 			NULL, NULL);
 }
@@ -685,6 +659,9 @@ static int ad9389b_enum_dv_timings(struct v4l2_subdev *sd,
 static int ad9389b_dv_timings_cap(struct v4l2_subdev *sd,
 				  struct v4l2_dv_timings_cap *cap)
 {
+	if (cap->pad != 0)
+		return -EINVAL;
+
 	*cap = ad9389b_timings_cap;
 	return 0;
 }
@@ -697,6 +674,40 @@ static const struct v4l2_subdev_video_ops ad9389b_video_ops = {
 	.dv_timings_cap = ad9389b_dv_timings_cap,
 };
 
+/* ------------------------------ PAD OPS ------------------------------ */
+
+static int ad9389b_get_edid(struct v4l2_subdev *sd,
+			    struct v4l2_subdev_edid *edid)
+{
+	struct ad9389b_state *state = get_ad9389b_state(sd);
+
+	if (edid->pad != 0)
+		return -EINVAL;
+	if (edid->blocks == 0 || edid->blocks > 256)
+		return -EINVAL;
+	if (!edid->edid)
+		return -EINVAL;
+	if (!state->edid.segments) {
+		v4l2_dbg(1, debug, sd, "EDID segment 0 not found\n");
+		return -ENODATA;
+	}
+	if (edid->start_block >= state->edid.segments * 2)
+		return -E2BIG;
+	if (edid->blocks + edid->start_block >= state->edid.segments * 2)
+		edid->blocks = state->edid.segments * 2 - edid->start_block;
+	memcpy(edid->edid, &state->edid.data[edid->start_block * 128],
+	       128 * edid->blocks);
+	return 0;
+}
+
+static const struct v4l2_subdev_pad_ops ad9389b_pad_ops = {
+	.get_edid = ad9389b_get_edid,
+	.enum_dv_timings = ad9389b_enum_dv_timings,
+	.dv_timings_cap = ad9389b_dv_timings_cap,
+};
+
+/* ------------------------------ AUDIO OPS ------------------------------ */
+
 static int ad9389b_s_audio_stream(struct v4l2_subdev *sd, int enable)
 {
 	v4l2_dbg(1, debug, sd, "%s: %sable\n", __func__, (enable ? "en" : "dis"));
-- 
1.8.3.2

