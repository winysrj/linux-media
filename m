Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3649 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755876Ab3HLK70 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Aug 2013 06:59:26 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: ismael.luceno@corp.bluecherry.net, pete@sensoray.com,
	sylvester.nawrocki@gmail.com, sakari.ailus@iki.fi,
	laurent.pinchart@ideasonboard.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 06/10] solo6x10: implement motion detection events and controls.
Date: Mon, 12 Aug 2013 12:58:29 +0200
Message-Id: <1376305113-17128-7-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1376305113-17128-1-git-send-email-hverkuil@xs4all.nl>
References: <1376305113-17128-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c | 117 +++++++++++++--------
 drivers/staging/media/solo6x10/solo6x10.h          |   9 +-
 2 files changed, 74 insertions(+), 52 deletions(-)

diff --git a/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c b/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
index 6858993..db5ce20 100644
--- a/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
+++ b/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
@@ -270,6 +270,8 @@ static int solo_enc_on(struct solo_enc_dev *solo_enc)
 	if (solo_enc->bw_weight > solo_dev->enc_bw_remain)
 		return -EBUSY;
 	solo_enc->sequence = 0;
+	solo_enc->motion_last_state = false;
+	solo_enc->frames_since_last_motion = 0;
 	solo_dev->enc_bw_remain -= solo_enc->bw_weight;
 
 	if (solo_enc->type == SOLO_ENC_TYPE_EXT)
@@ -510,15 +512,6 @@ static int solo_enc_fillbuf(struct solo_enc_dev *solo_enc,
 	struct vop_header *vh = enc_buf->vh;
 	int ret;
 
-	/* Check for motion flags */
-	vb->v4l2_buf.flags &= ~(V4L2_BUF_FLAG_MOTION_ON |
-				V4L2_BUF_FLAG_MOTION_DETECTED);
-	if (solo_is_motion_on(solo_enc)) {
-		vb->v4l2_buf.flags |= V4L2_BUF_FLAG_MOTION_ON;
-		if (enc_buf->motion)
-			vb->v4l2_buf.flags |= V4L2_BUF_FLAG_MOTION_DETECTED;
-	}
-
 	switch (solo_enc->fmt) {
 	case V4L2_PIX_FMT_MPEG4:
 	case V4L2_PIX_FMT_H264:
@@ -530,9 +523,49 @@ static int solo_enc_fillbuf(struct solo_enc_dev *solo_enc,
 	}
 
 	if (!ret) {
+		bool send_event = false;
+
 		vb->v4l2_buf.sequence = solo_enc->sequence++;
 		vb->v4l2_buf.timestamp.tv_sec = vh->sec;
 		vb->v4l2_buf.timestamp.tv_usec = vh->usec;
+
+		/* Check for motion flags */
+		if (solo_is_motion_on(solo_enc)) {
+			/* It takes a few frames for the hardware to detect
+			 * motion. Once it does it clears the motion detection
+			 * register and it takes again a few frames before
+			 * motion is seen. This means in practice that when the
+			 * motion field is 1, it will go back to 0 for the next
+			 * frame. This leads to motion detection event being
+			 * sent all the time, which is not what we want.
+			 * Instead wait a few frames before deciding that the
+			 * motion has halted. After some experimentation it
+			 * turns out that waiting for 5 frames works well.
+			 */
+			if (enc_buf->motion == 0 &&
+			    solo_enc->motion_last_state &&
+			    solo_enc->frames_since_last_motion++ > 5)
+				send_event = true;
+			else if (enc_buf->motion) {
+				solo_enc->frames_since_last_motion = 0;
+				send_event = !solo_enc->motion_last_state;
+			}
+		}
+
+		if (send_event) {
+			struct v4l2_event ev = {
+				.type = V4L2_EVENT_MOTION_DET,
+				.u.motion_det = {
+					.flags = V4L2_EVENT_MD_FL_HAVE_FRAME_SEQ,
+					.frame_sequence = vb->v4l2_buf.sequence,
+					.region_mask = enc_buf->motion ? 1 : 0,
+				},
+			};
+
+			solo_enc->motion_last_state = enc_buf->motion;
+			solo_enc->frames_since_last_motion = 0;
+			v4l2_event_queue(solo_enc->vfd, &ev);
+		}
 	}
 
 	vb2_buffer_done(vb, ret ? VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
@@ -1145,14 +1178,15 @@ static int solo_s_ctrl(struct v4l2_ctrl *ctrl)
 	case V4L2_CID_MPEG_VIDEO_GOP_SIZE:
 		solo_enc->gop = ctrl->val;
 		return 0;
-	case V4L2_CID_MOTION_THRESHOLD:
-		solo_enc->motion_thresh = ctrl->val;
+	case V4L2_CID_DETECT_MOTION_THRESHOLD:
+		solo_enc->motion_thresh = ctrl->val << 8;
 		if (!solo_enc->motion_global || !solo_enc->motion_enabled)
 			return 0;
-		return solo_set_motion_threshold(solo_dev, solo_enc->ch, ctrl->val);
-	case V4L2_CID_MOTION_MODE:
-		solo_enc->motion_global = ctrl->val == 1;
-		solo_enc->motion_enabled = ctrl->val > 0;
+		return solo_set_motion_threshold(solo_dev, solo_enc->ch,
+				solo_enc->motion_thresh);
+	case V4L2_CID_DETECT_MOTION_MODE:
+		solo_enc->motion_global = ctrl->val == V4L2_DETECT_MOTION_GLOBAL;
+		solo_enc->motion_enabled = ctrl->val > V4L2_DETECT_MOTION_DISABLED;
 		if (ctrl->val) {
 			if (solo_enc->motion_global)
 				solo_set_motion_threshold(solo_dev, solo_enc->ch,
@@ -1174,6 +1208,21 @@ static int solo_s_ctrl(struct v4l2_ctrl *ctrl)
 	return 0;
 }
 
+static int solo_subscribe_event(struct v4l2_fh *fh,
+				const struct v4l2_event_subscription *sub)
+{
+
+	switch (sub->type) {
+	case V4L2_EVENT_CTRL:
+		return v4l2_ctrl_subscribe_event(fh, sub);
+	case V4L2_EVENT_MOTION_DET:
+		/* Allow for up to 30 events (1 second for NTSC) to be
+		 * stored. */
+		return v4l2_event_subscribe(fh, sub, 30, NULL);
+	}
+	return -EINVAL;
+}
+
 static const struct v4l2_file_operations solo_enc_fops = {
 	.owner			= THIS_MODULE,
 	.open			= v4l2_fh_open,
@@ -1216,7 +1265,7 @@ static const struct v4l2_ioctl_ops solo_enc_ioctl_ops = {
 	.vidioc_s_matrix		= solo_s_matrix,
 	/* Logging and events */
 	.vidioc_log_status		= v4l2_ctrl_log_status,
-	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event		= solo_subscribe_event,
 	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
 };
 
@@ -1233,33 +1282,6 @@ static const struct v4l2_ctrl_ops solo_ctrl_ops = {
 	.s_ctrl = solo_s_ctrl,
 };
 
-static const struct v4l2_ctrl_config solo_motion_threshold_ctrl = {
-	.ops = &solo_ctrl_ops,
-	.id = V4L2_CID_MOTION_THRESHOLD,
-	.name = "Motion Detection Threshold",
-	.type = V4L2_CTRL_TYPE_INTEGER,
-	.max = 0xffff,
-	.def = SOLO_DEF_MOT_THRESH,
-	.step = 1,
-	.flags = V4L2_CTRL_FLAG_SLIDER,
-};
-
-static const char * const solo_motion_mode_menu[] = {
-	"Disabled",
-	"Global Threshold",
-	"Regional Threshold",
-	NULL
-};
-
-static const struct v4l2_ctrl_config solo_motion_enable_ctrl = {
-	.ops = &solo_ctrl_ops,
-	.id = V4L2_CID_MOTION_MODE,
-	.name = "Motion Detection Mode",
-	.type = V4L2_CTRL_TYPE_MENU,
-	.qmenu = solo_motion_mode_menu,
-	.max = 2,
-};
-
 static const struct v4l2_ctrl_config solo_osd_text_ctrl = {
 	.ops = &solo_ctrl_ops,
 	.id = V4L2_CID_OSD_TEXT,
@@ -1296,8 +1318,13 @@ static struct solo_enc_dev *solo_enc_alloc(struct solo_dev *solo_dev,
 			V4L2_CID_SHARPNESS, 0, 15, 1, 0);
 	v4l2_ctrl_new_std(hdl, &solo_ctrl_ops,
 			V4L2_CID_MPEG_VIDEO_GOP_SIZE, 1, 255, 1, solo_dev->fps);
-	v4l2_ctrl_new_custom(hdl, &solo_motion_threshold_ctrl, NULL);
-	v4l2_ctrl_new_custom(hdl, &solo_motion_enable_ctrl, NULL);
+	v4l2_ctrl_new_std_menu(hdl, &solo_ctrl_ops,
+			V4L2_CID_DETECT_MOTION_MODE,
+			V4L2_DETECT_MOTION_REGIONAL, 0,
+			V4L2_DETECT_MOTION_DISABLED);
+	v4l2_ctrl_new_std(hdl, &solo_ctrl_ops,
+			V4L2_CID_DETECT_MOTION_THRESHOLD, 0, 0xff, 1,
+			SOLO_DEF_MOT_THRESH >> 8);
 	v4l2_ctrl_new_custom(hdl, &solo_osd_text_ctrl, NULL);
 	if (hdl->error) {
 		ret = hdl->error;
diff --git a/drivers/staging/media/solo6x10/solo6x10.h b/drivers/staging/media/solo6x10/solo6x10.h
index 01c8655..df34a31 100644
--- a/drivers/staging/media/solo6x10/solo6x10.h
+++ b/drivers/staging/media/solo6x10/solo6x10.h
@@ -97,14 +97,7 @@
 #define SOLO_DEFAULT_GOP		30
 #define SOLO_DEFAULT_QP			3
 
-#ifndef V4L2_BUF_FLAG_MOTION_ON
-#define V4L2_BUF_FLAG_MOTION_ON		0x10000
-#define V4L2_BUF_FLAG_MOTION_DETECTED	0x20000
-#endif
-
 #define SOLO_CID_CUSTOM_BASE		(V4L2_CID_USER_BASE | 0xf000)
-#define V4L2_CID_MOTION_MODE		(SOLO_CID_CUSTOM_BASE+0)
-#define V4L2_CID_MOTION_THRESHOLD	(SOLO_CID_CUSTOM_BASE+1)
 #define V4L2_CID_MOTION_TRACE		(SOLO_CID_CUSTOM_BASE+2)
 #define V4L2_CID_OSD_TEXT		(SOLO_CID_CUSTOM_BASE+3)
 
@@ -174,6 +167,8 @@ struct solo_enc_dev {
 	struct solo_motion_thresholds motion_thresholds;
 	bool			motion_global;
 	bool			motion_enabled;
+	bool			motion_last_state;
+	u8			frames_since_last_motion;
 	u16			width;
 	u16			height;
 
-- 
1.8.3.2

