Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3433 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131AbaBQJ7F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Feb 2014 04:59:05 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com, ismael.luceno@corp.bluecherry.net,
	pete@sensoray.com, sakari.ailus@iki.fi,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv3 PATCH 32/35] solo6x10: implement the motion detection event.
Date: Mon, 17 Feb 2014 10:57:47 +0100
Message-Id: <1392631070-41868-33-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1392631070-41868-1-git-send-email-hverkuil@xs4all.nl>
References: <1392631070-41868-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Use the new motion detection event.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c | 68 ++++++++++++++++++----
 drivers/staging/media/solo6x10/solo6x10.h          |  7 +--
 2 files changed, 60 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c b/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
index a56a687..ccdf0f3 100644
--- a/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
+++ b/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
@@ -243,6 +243,8 @@ static int solo_enc_on(struct solo_enc_dev *solo_enc)
 	if (solo_enc->bw_weight > solo_dev->enc_bw_remain)
 		return -EBUSY;
 	solo_enc->sequence = 0;
+	solo_enc->motion_last_state = false;
+	solo_enc->frames_since_last_motion = 0;
 	solo_dev->enc_bw_remain -= solo_enc->bw_weight;
 
 	if (solo_enc->type == SOLO_ENC_TYPE_EXT)
@@ -544,15 +546,6 @@ static int solo_enc_fillbuf(struct solo_enc_dev *solo_enc,
 	const vop_header *vh = enc_buf->vh;
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
@@ -564,9 +557,49 @@ static int solo_enc_fillbuf(struct solo_enc_dev *solo_enc,
 	}
 
 	if (!ret) {
+		bool send_event = false;
+
 		vb->v4l2_buf.sequence = solo_enc->sequence++;
 		vb->v4l2_buf.timestamp.tv_sec = vop_sec(vh);
 		vb->v4l2_buf.timestamp.tv_usec = vop_usec(vh);
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
@@ -1118,6 +1151,21 @@ static int solo_s_ctrl(struct v4l2_ctrl *ctrl)
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
@@ -1156,7 +1204,7 @@ static const struct v4l2_ioctl_ops solo_enc_ioctl_ops = {
 	.vidioc_g_parm			= solo_g_parm,
 	/* Logging and events */
 	.vidioc_log_status		= v4l2_ctrl_log_status,
-	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event		= solo_subscribe_event,
 	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
 };
 
diff --git a/drivers/staging/media/solo6x10/solo6x10.h b/drivers/staging/media/solo6x10/solo6x10.h
index 19cb56b..35f9486 100644
--- a/drivers/staging/media/solo6x10/solo6x10.h
+++ b/drivers/staging/media/solo6x10/solo6x10.h
@@ -96,11 +96,6 @@
 
 #define SOLO_DEFAULT_QP			3
 
-#ifndef V4L2_BUF_FLAG_MOTION_ON
-#define V4L2_BUF_FLAG_MOTION_ON		0x10000
-#define V4L2_BUF_FLAG_MOTION_DETECTED	0x20000
-#endif
-
 #define SOLO_CID_CUSTOM_BASE		(V4L2_CID_USER_BASE | 0xf000)
 #define V4L2_CID_MOTION_TRACE		(SOLO_CID_CUSTOM_BASE+2)
 #define V4L2_CID_OSD_TEXT		(SOLO_CID_CUSTOM_BASE+3)
@@ -168,6 +163,8 @@ struct solo_enc_dev {
 	u16			motion_thresh;
 	bool			motion_global;
 	bool			motion_enabled;
+	bool			motion_last_state;
+	u8			frames_since_last_motion;
 	u16			width;
 	u16			height;
 
-- 
1.8.4.rc3

