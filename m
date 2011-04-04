Return-path: <mchehab@pedra>
Received: from sj-iport-6.cisco.com ([171.71.176.117]:56397 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753602Ab1DDLwX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Apr 2011 07:52:23 -0400
Received: from OSLEXCP11.eu.tandberg.int ([173.38.136.5])
	by rcdn-core-2.cisco.com (8.14.3/8.14.3) with ESMTP id p34BqDrj001853
	for <linux-media@vger.kernel.org>; Mon, 4 Apr 2011 11:52:22 GMT
Received: from cobaltpc1.rd.tandberg.com (cobaltpc1.rd.tandberg.com [10.47.3.155])
	by ultra.eu.tandberg.int (8.13.1/8.13.1) with ESMTP id p34BqDdN009325
	for <linux-media@vger.kernel.org>; Mon, 4 Apr 2011 13:52:14 +0200
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Subject: [RFCv1 PATCH 7/9] v4l2-ctrls: add new V4L2_EVENT_CTRL_CH_STATE event.
Date: Mon,  4 Apr 2011 13:51:52 +0200
Message-Id: <b7d112195637a8101fa2b18b7a4b9580a22a8e33.1301916466.git.hans.verkuil@cisco.com>
In-Reply-To: <1301917914-27437-1-git-send-email-hans.verkuil@cisco.com>
References: <1301917914-27437-1-git-send-email-hans.verkuil@cisco.com>
In-Reply-To: <2fa42294dbc167cae5daf227d072b2284f77b1ab.1301916466.git.hans.verkuil@cisco.com>
References: <2fa42294dbc167cae5daf227d072b2284f77b1ab.1301916466.git.hans.verkuil@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This event is triggered whenever the 'flags' field changes.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/cx2341x.c    |   58 +++++++++++++++++++++++--------------
 drivers/media/video/saa7115.c    |    3 +-
 drivers/media/video/v4l2-ctrls.c |   38 ++++++++----------------
 include/linux/videodev2.h        |    8 +++++
 include/media/v4l2-ctrls.h       |   36 +++++++++++------------
 5 files changed, 76 insertions(+), 67 deletions(-)

diff --git a/drivers/media/video/cx2341x.c b/drivers/media/video/cx2341x.c
index 103ef6b..2781889 100644
--- a/drivers/media/video/cx2341x.c
+++ b/drivers/media/video/cx2341x.c
@@ -1307,6 +1307,12 @@ static int cx2341x_try_ctrl(struct v4l2_ctrl *ctrl)
 	return 0;
 }
 
+static void cx2341x_activate(struct v4l2_ctrl *ctrl, bool activate)
+{
+	v4l2_ctrl_flags(ctrl, V4L2_CTRL_FLAG_INACTIVE,
+			activate ? 0 : V4L2_CTRL_FLAG_INACTIVE);
+}
+
 static int cx2341x_s_ctrl(struct v4l2_ctrl *ctrl)
 {
 	static const int mpeg_stream_type[] = {
@@ -1380,10 +1386,10 @@ static int cx2341x_s_ctrl(struct v4l2_ctrl *ctrl)
 			int is_ac3 = hdl->audio_encoding->val ==
 						V4L2_MPEG_AUDIO_ENCODING_AC3;
 
-			v4l2_ctrl_activate(hdl->audio_ac3_bitrate, is_ac3);
-			v4l2_ctrl_activate(hdl->audio_l2_bitrate, !is_ac3);
+			cx2341x_activate(hdl->audio_ac3_bitrate, is_ac3);
+			cx2341x_activate(hdl->audio_l2_bitrate, !is_ac3);
 		}
-		v4l2_ctrl_activate(hdl->audio_mode_extension,
+		cx2341x_activate(hdl->audio_mode_extension,
 			hdl->audio_mode->val == V4L2_MPEG_AUDIO_MODE_JOINT_STEREO);
 		if (cx2341x_neq(hdl->audio_sampling_freq) &&
 		    hdl->ops && hdl->ops->s_audio_sampling_freq)
@@ -1413,9 +1419,9 @@ static int cx2341x_s_ctrl(struct v4l2_ctrl *ctrl)
 		if (err)
 			return err;
 
-		v4l2_ctrl_activate(hdl->video_bitrate_mode,
+		cx2341x_activate(hdl->video_bitrate_mode,
 			hdl->video_encoding->val != V4L2_MPEG_VIDEO_ENCODING_MPEG_1);
-		v4l2_ctrl_activate(hdl->video_bitrate_peak,
+		cx2341x_activate(hdl->video_bitrate_peak,
 			hdl->video_bitrate_mode->val != V4L2_MPEG_VIDEO_BITRATE_MODE_CBR);
 		if (cx2341x_neq(hdl->video_encoding) &&
 		    hdl->ops && hdl->ops->s_video_encoding)
@@ -1441,18 +1447,18 @@ static int cx2341x_s_ctrl(struct v4l2_ctrl *ctrl)
 
 		active_filter = hdl->video_spatial_filter_mode->val !=
 				V4L2_MPEG_CX2341X_VIDEO_SPATIAL_FILTER_MODE_AUTO;
-		v4l2_ctrl_activate(hdl->video_spatial_filter, active_filter);
-		v4l2_ctrl_activate(hdl->video_luma_spatial_filter_type, active_filter);
-		v4l2_ctrl_activate(hdl->video_chroma_spatial_filter_type, active_filter);
+		cx2341x_activate(hdl->video_spatial_filter, active_filter);
+		cx2341x_activate(hdl->video_luma_spatial_filter_type, active_filter);
+		cx2341x_activate(hdl->video_chroma_spatial_filter_type, active_filter);
 		active_filter = hdl->video_temporal_filter_mode->val !=
 				V4L2_MPEG_CX2341X_VIDEO_TEMPORAL_FILTER_MODE_AUTO;
-		v4l2_ctrl_activate(hdl->video_temporal_filter, active_filter);
+		cx2341x_activate(hdl->video_temporal_filter, active_filter);
 		active_filter = hdl->video_median_filter_type->val !=
 				V4L2_MPEG_CX2341X_VIDEO_MEDIAN_FILTER_TYPE_OFF;
-		v4l2_ctrl_activate(hdl->video_luma_median_filter_bottom, active_filter);
-		v4l2_ctrl_activate(hdl->video_luma_median_filter_top, active_filter);
-		v4l2_ctrl_activate(hdl->video_chroma_median_filter_bottom, active_filter);
-		v4l2_ctrl_activate(hdl->video_chroma_median_filter_top, active_filter);
+		cx2341x_activate(hdl->video_luma_median_filter_bottom, active_filter);
+		cx2341x_activate(hdl->video_luma_median_filter_top, active_filter);
+		cx2341x_activate(hdl->video_chroma_median_filter_bottom, active_filter);
+		cx2341x_activate(hdl->video_chroma_median_filter_top, active_filter);
 		return 0;
 	}
 
@@ -1711,16 +1717,24 @@ int cx2341x_handler_setup(struct cx2341x_handler *cxhdl)
 }
 EXPORT_SYMBOL(cx2341x_handler_setup);
 
+static void cx2341x_grab(struct v4l2_ctrl *ctrl, bool busy)
+{
+	v4l2_ctrl_flags(ctrl, V4L2_CTRL_FLAG_GRABBED,
+			busy ? V4L2_CTRL_FLAG_GRABBED : 0);
+}
+
 void cx2341x_handler_set_busy(struct cx2341x_handler *cxhdl, int busy)
 {
-	v4l2_ctrl_grab(cxhdl->audio_sampling_freq, busy);
-	v4l2_ctrl_grab(cxhdl->audio_encoding, busy);
-	v4l2_ctrl_grab(cxhdl->audio_l2_bitrate, busy);
-	v4l2_ctrl_grab(cxhdl->audio_ac3_bitrate, busy);
-	v4l2_ctrl_grab(cxhdl->stream_vbi_fmt, busy);
-	v4l2_ctrl_grab(cxhdl->stream_type, busy);
-	v4l2_ctrl_grab(cxhdl->video_bitrate_mode, busy);
-	v4l2_ctrl_grab(cxhdl->video_bitrate, busy);
-	v4l2_ctrl_grab(cxhdl->video_bitrate_peak, busy);
+	mutex_lock(&cxhdl->hdl.lock);
+	cx2341x_grab(cxhdl->audio_sampling_freq, busy);
+	cx2341x_grab(cxhdl->audio_encoding, busy);
+	cx2341x_grab(cxhdl->audio_l2_bitrate, busy);
+	cx2341x_grab(cxhdl->audio_ac3_bitrate, busy);
+	cx2341x_grab(cxhdl->stream_vbi_fmt, busy);
+	cx2341x_grab(cxhdl->stream_type, busy);
+	cx2341x_grab(cxhdl->video_bitrate_mode, busy);
+	cx2341x_grab(cxhdl->video_bitrate, busy);
+	cx2341x_grab(cxhdl->video_bitrate_peak, busy);
+	mutex_unlock(&cxhdl->hdl.lock);
 }
 EXPORT_SYMBOL(cx2341x_handler_set_busy);
diff --git a/drivers/media/video/saa7115.c b/drivers/media/video/saa7115.c
index 0db9092..ae4b299 100644
--- a/drivers/media/video/saa7115.c
+++ b/drivers/media/video/saa7115.c
@@ -793,7 +793,8 @@ static int saa711x_s_ctrl(struct v4l2_ctrl *ctrl)
 			saa711x_write(sd, R_0F_CHROMA_GAIN_CNTL, state->gain->val);
 		else
 			saa711x_write(sd, R_0F_CHROMA_GAIN_CNTL, state->gain->val | 0x80);
-		v4l2_ctrl_activate(state->gain, !state->agc->val);
+		v4l2_ctrl_flags(state->gain, V4L2_CTRL_FLAG_INACTIVE,
+				state->agc->val ? V4L2_CTRL_FLAG_INACTIVE : 0);
 		break;
 
 	default:
diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 163f412..122c6da 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -1205,40 +1205,28 @@ void v4l2_ctrl_cluster(unsigned ncontrols, struct v4l2_ctrl **controls)
 }
 EXPORT_SYMBOL(v4l2_ctrl_cluster);
 
-/* Activate/deactivate a control. */
-void v4l2_ctrl_activate(struct v4l2_ctrl *ctrl, bool active)
+void v4l2_ctrl_flags(struct v4l2_ctrl *ctrl, u32 clear_flags, u32 set_flags)
 {
+	struct v4l2_event ev;
+
 	if (ctrl == NULL)
 		return;
-
-	if (!active)
-		/* set V4L2_CTRL_FLAG_INACTIVE */
-		set_bit(4, &ctrl->flags);
-	else
-		/* clear V4L2_CTRL_FLAG_INACTIVE */
-		clear_bit(4, &ctrl->flags);
+	ctrl->flags = (ctrl->flags & ~clear_flags) | set_flags;
+	ev.u.ctrl_ch_state.flags = ctrl->flags;
+	ev.type = V4L2_EVENT_CTRL_CH_STATE;
+	send_event(ctrl, &ev);
 }
-EXPORT_SYMBOL(v4l2_ctrl_activate);
-
-/* Grab/ungrab a control.
-   Typically used when streaming starts and you want to grab controls,
-   preventing the user from changing them.
+EXPORT_SYMBOL(v4l2_ctrl_flags);
 
-   Just call this and the framework will block any attempts to change
-   these controls. */
-void v4l2_ctrl_grab(struct v4l2_ctrl *ctrl, bool grabbed)
+void v4l2_ctrl_flags_lock(struct v4l2_ctrl *ctrl, u32 clear_flags, u32 set_flags)
 {
 	if (ctrl == NULL)
 		return;
-
-	if (grabbed)
-		/* set V4L2_CTRL_FLAG_GRABBED */
-		set_bit(1, &ctrl->flags);
-	else
-		/* clear V4L2_CTRL_FLAG_GRABBED */
-		clear_bit(1, &ctrl->flags);
+	v4l2_ctrl_lock(ctrl);
+	v4l2_ctrl_flags(ctrl, clear_flags, set_flags);
+	v4l2_ctrl_unlock(ctrl);
 }
-EXPORT_SYMBOL(v4l2_ctrl_grab);
+EXPORT_SYMBOL(v4l2_ctrl_flags_lock);
 
 /* Log the control name and value */
 static void log_ctrl(const struct v4l2_ctrl *ctrl,
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index f7238c1..eb56685 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1788,6 +1788,7 @@ struct v4l2_streamparm {
 #define V4L2_EVENT_VSYNC			1
 #define V4L2_EVENT_EOS				2
 #define V4L2_EVENT_CTRL_CH_VALUE		3
+#define V4L2_EVENT_CTRL_CH_STATE		4
 #define V4L2_EVENT_PRIVATE_START		0x08000000
 
 /* Payload for V4L2_EVENT_VSYNC */
@@ -1805,11 +1806,18 @@ struct v4l2_event_ctrl_ch_value {
 	};
 } __attribute__ ((packed));
 
+/* Payload for V4L2_EVENT_CTRL_CH_STATE */
+struct v4l2_event_ctrl_ch_state {
+	__u32 type;
+	__u32 flags;
+} __attribute__ ((packed));
+
 struct v4l2_event {
 	__u32				type;
 	union {
 		struct v4l2_event_vsync vsync;
 		struct v4l2_event_ctrl_ch_value ctrl_ch_value;
+		struct v4l2_event_ctrl_ch_state ctrl_ch_state;
 		__u8			data[64];
 	} u;
 	__u32				pending;
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 7ca45a5..e6917f4 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -379,32 +379,30 @@ void v4l2_ctrl_cluster(unsigned ncontrols, struct v4l2_ctrl **controls);
   */
 struct v4l2_ctrl *v4l2_ctrl_find(struct v4l2_ctrl_handler *hdl, u32 id);
 
-/** v4l2_ctrl_activate() - Make the control active or inactive.
-  * @ctrl:	The control to (de)activate.
-  * @active:	True if the control should become active.
+/** v4l2_ctrl_flags() - Clear and set flags for a control.
+  * @ctrl:	The control whose flags should be changed.
+  * @clear_flags:	Mask out these flags.
+  * @set_flags:	Set these flags.
   *
-  * This sets or clears the V4L2_CTRL_FLAG_INACTIVE flag atomically.
-  * Does nothing if @ctrl == NULL.
-  * This will usually be called from within the s_ctrl op.
+  * This clears and sets flags. Does nothing if @ctrl == NULL.
+  * The V4L2_EVENT_CTRL_CH_STATE event will be generated afterwards.
   *
-  * This function can be called regardless of whether the control handler
-  * is locked or not.
+  * This function expects that the control handler is locked.
   */
-void v4l2_ctrl_activate(struct v4l2_ctrl *ctrl, bool active);
+void v4l2_ctrl_flags(struct v4l2_ctrl *ctrl, u32 clear_flags, u32 set_flags);
 
-/** v4l2_ctrl_grab() - Mark the control as grabbed or not grabbed.
-  * @ctrl:	The control to (de)activate.
-  * @grabbed:	True if the control should become grabbed.
+/** v4l2_ctrl_flags_lock() - Clear and set flags for a control.
+  * @ctrl:	The control whose flags should be changed.
+  * @clear_flags:	Mask out these flags.
+  * @set_flags:	Set these flags.
   *
-  * This sets or clears the V4L2_CTRL_FLAG_GRABBED flag atomically.
-  * Does nothing if @ctrl == NULL.
-  * This will usually be called when starting or stopping streaming in the
-  * driver.
+  * This clears and sets flags. Does nothing if @ctrl == NULL.
+  * The V4L2_EVENT_CTRL_CH_STATE event will be generated afterwards.
   *
-  * This function can be called regardless of whether the control handler
-  * is locked or not.
+  * This function expects that the control handler is unlocked and will lock
+  * it before changing flags.
   */
-void v4l2_ctrl_grab(struct v4l2_ctrl *ctrl, bool grabbed);
+void v4l2_ctrl_flags_lock(struct v4l2_ctrl *ctrl, u32 clear_flags, u32 set_flags);
 
 /** v4l2_ctrl_lock() - Helper function to lock the handler
   * associated with the control.
-- 
1.7.1

