Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3615 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448Ab0EINza (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 May 2010 09:55:30 -0400
Message-Id: <f8a23c5d53950c0d637837d4f11cba8946679c5d.1273413060.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1273413060.git.hverkuil@xs4all.nl>
References: <cover.1273413060.git.hverkuil@xs4all.nl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Sun, 09 May 2010 15:57:01 +0200
Subject: [PATCH 1/6] [RFC] tvp514x: do NOT change the std as a side effect
To: linux-media@vger.kernel.org
Cc: hvaibhav@ti.com
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Several calls (try_fmt, g_parm among others) changed the current standard
as a side effect of that call. But the standard may only be changed by s_std.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/tvp514x.c |   53 ++++++++++++----------------------------
 1 files changed, 16 insertions(+), 37 deletions(-)

diff --git a/drivers/media/video/tvp514x.c b/drivers/media/video/tvp514x.c
index 97b7db5..1ca1247 100644
--- a/drivers/media/video/tvp514x.c
+++ b/drivers/media/video/tvp514x.c
@@ -365,13 +365,13 @@ static int tvp514x_write_regs(struct v4l2_subdev *sd,
 }
 
 /**
- * tvp514x_get_current_std() : Get the current standard detected by TVP5146/47
+ * tvp514x_query_current_std() : Query the current standard detected by TVP5146/47
  * @sd: ptr to v4l2_subdev struct
  *
- * Get current standard detected by TVP5146/47, STD_INVALID if there is no
+ * Returns the current standard detected by TVP5146/47, STD_INVALID if there is no
  * standard detected.
  */
-static enum tvp514x_std tvp514x_get_current_std(struct v4l2_subdev *sd)
+static enum tvp514x_std tvp514x_query_current_std(struct v4l2_subdev *sd)
 {
 	u8 std, std_status;
 
@@ -517,7 +517,7 @@ static int tvp514x_detect(struct v4l2_subdev *sd,
  * @std_id: standard V4L2 std_id ioctl enum
  *
  * Returns the current standard detected by TVP5146/47. If no active input is
- * detected, returns -EINVAL
+ * detected then *std_id is set to 0 and the function returns 0.
  */
 static int tvp514x_querystd(struct v4l2_subdev *sd, v4l2_std_id *std_id)
 {
@@ -529,10 +529,12 @@ static int tvp514x_querystd(struct v4l2_subdev *sd, v4l2_std_id *std_id)
 	if (std_id == NULL)
 		return -EINVAL;
 
-	/* get the current standard */
-	current_std = tvp514x_get_current_std(sd);
+	*std_id = V4L2_STD_UNKNOWN;
+
+	/* query the current standard */
+	current_std = tvp514x_query_current_std(sd);
 	if (current_std == STD_INVALID)
-		return -EINVAL;
+		return 0;
 
 	input_sel = decoder->input;
 
@@ -574,12 +576,11 @@ static int tvp514x_querystd(struct v4l2_subdev *sd, v4l2_std_id *std_id)
 	/* check whether signal is locked */
 	sync_lock_status = tvp514x_read_reg(sd, REG_STATUS1);
 	if (lock_mask != (sync_lock_status & lock_mask))
-		return -EINVAL;	/* No input detected */
+		return 0;	/* No input detected */
 
-	decoder->current_std = current_std;
 	*std_id = decoder->std_list[current_std].standard.id;
 
-	v4l2_dbg(1, debug, sd, "Current STD: %s",
+	v4l2_dbg(1, debug, sd, "Current STD: %s\n",
 			decoder->std_list[current_std].standard.name);
 	return 0;
 }
@@ -636,7 +637,6 @@ static int tvp514x_s_routing(struct v4l2_subdev *sd,
 	int err;
 	enum tvp514x_input input_sel;
 	enum tvp514x_output output_sel;
-	enum tvp514x_std current_std = STD_INVALID;
 	u8 sync_lock_status, lock_mask;
 	int try_count = LOCK_RETRY_COUNT;
 
@@ -720,11 +720,6 @@ static int tvp514x_s_routing(struct v4l2_subdev *sd,
 		/* Allow decoder to sync up with new input */
 		msleep(LOCK_RETRY_DELAY);
 
-		/* get the current standard for future reference */
-		current_std = tvp514x_get_current_std(sd);
-		if (current_std == STD_INVALID)
-			continue;
-
 		sync_lock_status = tvp514x_read_reg(sd,
 				REG_STATUS1);
 		if (lock_mask == (sync_lock_status & lock_mask))
@@ -732,15 +727,13 @@ static int tvp514x_s_routing(struct v4l2_subdev *sd,
 			break;
 	}
 
-	if ((current_std == STD_INVALID) || (try_count < 0))
+	if (try_count < 0)
 		return -EINVAL;
 
-	decoder->current_std = current_std;
 	decoder->input = input;
 	decoder->output = output;
 
-	v4l2_dbg(1, debug, sd, "Input set to: %d, std : %d",
-			input_sel, current_std);
+	v4l2_dbg(1, debug, sd, "Input set to: %d\n", input_sel);
 
 	return 0;
 }
@@ -1017,11 +1010,8 @@ tvp514x_try_fmt_cap(struct v4l2_subdev *sd, struct v4l2_format *f)
 	pix = &f->fmt.pix;
 
 	/* Calculate height and width based on current standard */
-	current_std = tvp514x_get_current_std(sd);
-	if (current_std == STD_INVALID)
-		return -EINVAL;
+	current_std = decoder->current_std;
 
-	decoder->current_std = current_std;
 	pix->width = decoder->std_list[current_std].width;
 	pix->height = decoder->std_list[current_std].height;
 
@@ -1131,15 +1121,8 @@ tvp514x_g_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *a)
 		/* only capture is supported */
 		return -EINVAL;
 
-	memset(a, 0, sizeof(*a));
-	a->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-
 	/* get the current standard */
-	current_std = tvp514x_get_current_std(sd);
-	if (current_std == STD_INVALID)
-		return -EINVAL;
-
-	decoder->current_std = current_std;
+	current_std = decoder->current_std;
 
 	cparm = &a->parm.capture;
 	cparm->capability = V4L2_CAP_TIMEPERFRAME;
@@ -1174,11 +1157,7 @@ tvp514x_s_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *a)
 	timeperframe = &a->parm.capture.timeperframe;
 
 	/* get the current standard */
-	current_std = tvp514x_get_current_std(sd);
-	if (current_std == STD_INVALID)
-		return -EINVAL;
-
-	decoder->current_std = current_std;
+	current_std = decoder->current_std;
 
 	*timeperframe =
 	    decoder->std_list[current_std].standard.frameperiod;
-- 
1.6.4.2

