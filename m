Return-path: <mchehab@pedra>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1329 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932540Ab1EYNeQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2011 09:34:16 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 04/11] v4l2-ctrls: Replace v4l2_ctrl_activate/grab with v4l2_ctrl_flags.
Date: Wed, 25 May 2011 15:33:48 +0200
Message-Id: <6170b5a8f168957ed3675d9976e434d227867d27.1306329390.git.hans.verkuil@cisco.com>
In-Reply-To: <1306330435-11799-1-git-send-email-hverkuil@xs4all.nl>
References: <1306330435-11799-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <6cea502820c1684f34b9e862a64be2972afb718f.1306329390.git.hans.verkuil@cisco.com>
References: <6cea502820c1684f34b9e862a64be2972afb718f.1306329390.git.hans.verkuil@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Hans Verkuil <hans.verkuil@cisco.com>

This more generic function makes it possible to have a single function
that takes care of flags handling, in particular with regards to sending
a control event when the flags change.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/video4linux/v4l2-controls.txt |   28 +++++++------
 drivers/media/video/cx2341x.c               |   58 ++++++++++++++++----------
 drivers/media/video/saa7115.c               |    3 +-
 drivers/media/video/v4l2-ctrls.c            |   33 ++++-----------
 include/media/v4l2-ctrls.h                  |   34 +++++++---------
 5 files changed, 76 insertions(+), 80 deletions(-)

diff --git a/Documentation/video4linux/v4l2-controls.txt b/Documentation/video4linux/v4l2-controls.txt
index 881e7f4..bc24be4 100644
--- a/Documentation/video4linux/v4l2-controls.txt
+++ b/Documentation/video4linux/v4l2-controls.txt
@@ -381,24 +381,26 @@ Active and Grabbed Controls
 ===========================
 
 If you get more complex relationships between controls, then you may have to
-activate and deactivate controls. For example, if the Chroma AGC control is
-on, then the Chroma Gain control is inactive. That is, you may set it, but
-the value will not be used by the hardware as long as the automatic gain
-control is on. Typically user interfaces can disable such input fields.
+activate and deactivate controls. For example, depending on the chosen MPEG
+audio codec only the audio bitrate control correspending to that audio codec
+is marked 'active', all other audio bitrate controls will be marked 'inactive'.
+That is, you may set it, but the value will not be used by the hardware.
+Typically user interfaces will disable inactive input fields.
 
-You can set the 'active' status using v4l2_ctrl_activate(). By default all
-controls are active. Note that the framework does not check for this flag.
-It is meant purely for GUIs. The function is typically called from within
-s_ctrl.
+By default all controls are active. Note that the framework does not check
+for this flag. It is meant purely for GUIs.
 
-The other flag is the 'grabbed' flag. A grabbed control means that you cannot
+You may also have to grab controls. A grabbed control means that you cannot
 change it because it is in use by some resource. Typical examples are MPEG
 bitrate controls that cannot be changed while capturing is in progress.
 
-If a control is set to 'grabbed' using v4l2_ctrl_grab(), then the framework
-will return -EBUSY if an attempt is made to set this control. The
-v4l2_ctrl_grab() function is typically called from the driver when it
-starts or stops streaming.
+If a control is set to 'grabbed', then the framework will return -EBUSY if
+an attempt is made to set this control. You typically change the 'grabbed'
+status from the driver when it starts or stops streaming.
+
+You can change the control's status using the v4l2_ctrl_flags() or
+v4l2_ctrl_flags_lock() calls. The first can be called from within s_ctrl,
+the second can be called from elsewhere and will lock first.
 
 
 Control Clusters
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
index 2afd632..d895048 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -1173,40 +1173,23 @@ void v4l2_ctrl_cluster(unsigned ncontrols, struct v4l2_ctrl **controls)
 }
 EXPORT_SYMBOL(v4l2_ctrl_cluster);
 
-/* Activate/deactivate a control. */
-void v4l2_ctrl_activate(struct v4l2_ctrl *ctrl, bool active)
+void v4l2_ctrl_flags(struct v4l2_ctrl *ctrl, u32 clear_flags, u32 set_flags)
 {
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
 }
-EXPORT_SYMBOL(v4l2_ctrl_activate);
+EXPORT_SYMBOL(v4l2_ctrl_flags);
 
-/* Grab/ungrab a control.
-   Typically used when streaming starts and you want to grab controls,
-   preventing the user from changing them.
-
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
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 97d0638..0f5004b 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -372,32 +372,28 @@ void v4l2_ctrl_cluster(unsigned ncontrols, struct v4l2_ctrl **controls);
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

