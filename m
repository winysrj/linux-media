Return-path: <linux-media-owner@vger.kernel.org>
Received: from bgl-iport-4.cisco.com ([72.163.197.28]:19700 "EHLO
	bgl-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602AbbHWOJS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Aug 2015 10:09:18 -0400
From: Prashant Laddha <prladdha@cisco.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Prashant Laddha <prladdha@cisco.com>
Subject: [RFC PATCH 1/2] vivid: add support for reduced fps in video out.
Date: Sun, 23 Aug 2015 19:39:10 +0530
Message-Id: <1440338951-23748-2-git-send-email-prladdha@cisco.com>
In-Reply-To: <1440338951-23748-1-git-send-email-prladdha@cisco.com>
References: <1440338951-23748-1-git-send-email-prladdha@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If bt timing has REDUCED_FPS flag set, then reduce the frame rate
by factor of 1000 / 1001. For vivid, timeperframe_vid_out indicates
the frame timings used by video out thread. The timeperframe_vid_out
is derived from pixel clock. Adjusting the timeperframe_vid_out by
scaling down pixel clock with factor of 1000 / 1001.

The reduced fps is supported for CVT timings if reduced blanking v2
(indicated by vsync = 8) is true. For CEA861 timings, reduced fps is
supported if V4L2_DV_FL_CAN_REDUCE_FPS flag is true. For GTF timings,
reduced fps is not supported.

The reduced fps will allow refresh rates like 29.97, 59.94 etc.

Cc: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Prashant Laddha <prladdha@cisco.com>
---
 drivers/media/platform/vivid/vivid-vid-out.c | 30 +++++++++++++++++++++++++++-
 drivers/media/v4l2-core/v4l2-dv-timings.c    |  5 +++++
 2 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/vivid/vivid-vid-out.c b/drivers/media/platform/vivid/vivid-vid-out.c
index c404e27..ca6ec78 100644
--- a/drivers/media/platform/vivid/vivid-vid-out.c
+++ b/drivers/media/platform/vivid/vivid-vid-out.c
@@ -213,6 +213,27 @@ const struct vb2_ops vivid_vid_out_qops = {
 };
 
 /*
+ * Called to check conditions for reduced fps. For CVT timings, reduced
+ * fps is allowed only with reduced blanking v2 (vsync == 8). For CEA861
+ * timings, reduced fps is allowed if V4L2_DV_FL_CAN_REDUCE_FPS flag is
+ * true.
+ */
+static bool reduce_fps(struct v4l2_bt_timings *bt)
+{
+	if (!(bt->flags & V4L2_DV_FL_REDUCED_FPS))
+		return false;
+
+	if ((bt->standards & V4L2_DV_BT_STD_CVT) && (bt->vsync == 8))
+			return true;
+
+	if ((bt->standards & V4L2_DV_BT_STD_CEA861) &&
+	    (bt->flags & V4L2_DV_FL_CAN_REDUCE_FPS))
+			return true;
+
+	return false;
+}
+
+/*
  * Called whenever the format has to be reset which can occur when
  * changing outputs, standard, timings, etc.
  */
@@ -220,6 +241,7 @@ void vivid_update_format_out(struct vivid_dev *dev)
 {
 	struct v4l2_bt_timings *bt = &dev->dv_timings_out.bt;
 	unsigned size, p;
+	u64 pixelclock;
 
 	switch (dev->output_type[dev->output]) {
 	case SVID:
@@ -241,8 +263,14 @@ void vivid_update_format_out(struct vivid_dev *dev)
 		dev->sink_rect.width = bt->width;
 		dev->sink_rect.height = bt->height;
 		size = V4L2_DV_BT_FRAME_WIDTH(bt) * V4L2_DV_BT_FRAME_HEIGHT(bt);
+
+		if (reduce_fps(bt))
+			pixelclock = div_u64((bt->pixelclock * 1000), 1001);
+		else
+			pixelclock = bt->pixelclock;
+
 		dev->timeperframe_vid_out = (struct v4l2_fract) {
-			size / 100, (u32)bt->pixelclock / 100
+			size / 100, (u32)pixelclock / 100
 		};
 		if (bt->interlaced)
 			dev->field_out = V4L2_FIELD_ALTERNATE;
diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
index 6a83d61..adc03bd 100644
--- a/drivers/media/v4l2-core/v4l2-dv-timings.c
+++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
@@ -210,7 +210,12 @@ bool v4l2_find_dv_timings_cap(struct v4l2_dv_timings *t,
 					  fnc, fnc_handle) &&
 		    v4l2_match_dv_timings(t, v4l2_dv_timings_presets + i,
 					  pclock_delta)) {
+			u32 flags = t->bt.flags & V4L2_DV_FL_REDUCED_FPS;
+
 			*t = v4l2_dv_timings_presets[i];
+			if (t->bt.flags & V4L2_DV_FL_CAN_REDUCE_FPS)
+				t->bt.flags |= flags;
+
 			return true;
 		}
 	}
-- 
1.9.1

