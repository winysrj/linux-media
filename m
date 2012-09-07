Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3518 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756706Ab2IGN3k (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Sep 2012 09:29:40 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 API PATCH 26/28] v4l2-dev: improve ioctl validity checks.
Date: Fri,  7 Sep 2012 15:29:26 +0200
Message-Id: <10baddbb1e8132f522713487d23e751a1e6419ed.1347023744.git.hans.verkuil@cisco.com>
In-Reply-To: <1347024568-32602-1-git-send-email-hverkuil@xs4all.nl>
References: <1347024568-32602-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <ea8cc4841a79893a29bafb9af7df2cb0f72af169.1347023744.git.hans.verkuil@cisco.com>
References: <ea8cc4841a79893a29bafb9af7df2cb0f72af169.1347023744.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The ioctl validity checks have been improved and now take vfl_type
and vfl_dir into account.

During the 2012 Media Workshop it was decided that these improved
v4l2 core checks should be added as they simplified drivers and
made drivers behave consistently.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-dev.c   |  228 ++++++++++++++++++++--------------
 drivers/media/v4l2-core/v4l2-ioctl.c |  182 +++++++++++++++------------
 2 files changed, 237 insertions(+), 173 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index 95f92ea..3e15a079 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -551,6 +551,11 @@ static void determine_valid_ioctls(struct video_device *vdev)
 {
 	DECLARE_BITMAP(valid_ioctls, BASE_VIDIOC_PRIVATE);
 	const struct v4l2_ioctl_ops *ops = vdev->ioctl_ops;
+	bool is_vid = vdev->vfl_type == VFL_TYPE_GRABBER;
+	bool is_vbi = vdev->vfl_type == VFL_TYPE_VBI;
+	bool is_radio = vdev->vfl_type == VFL_TYPE_RADIO;
+	bool is_rx = vdev->vfl_dir != VFL_DIR_TX;
+	bool is_tx = vdev->vfl_dir != VFL_DIR_RX;
 
 	bitmap_zero(valid_ioctls, BASE_VIDIOC_PRIVATE);
 
@@ -561,66 +566,87 @@ static void determine_valid_ioctls(struct video_device *vdev)
 	if (ops->vidioc_s_priority ||
 			test_bit(V4L2_FL_USE_FH_PRIO, &vdev->flags))
 		set_bit(_IOC_NR(VIDIOC_S_PRIORITY), valid_ioctls);
-	if (ops->vidioc_enum_fmt_vid_cap ||
-	    ops->vidioc_enum_fmt_vid_out ||
-	    ops->vidioc_enum_fmt_vid_cap_mplane ||
-	    ops->vidioc_enum_fmt_vid_out_mplane ||
-	    ops->vidioc_enum_fmt_vid_overlay)
-		set_bit(_IOC_NR(VIDIOC_ENUM_FMT), valid_ioctls);
-	if (ops->vidioc_g_fmt_vid_cap ||
-	    ops->vidioc_g_fmt_vid_out ||
-	    ops->vidioc_g_fmt_vid_cap_mplane ||
-	    ops->vidioc_g_fmt_vid_out_mplane ||
-	    ops->vidioc_g_fmt_vid_overlay ||
-	    ops->vidioc_g_fmt_vbi_cap ||
-	    ops->vidioc_g_fmt_vid_out_overlay ||
-	    ops->vidioc_g_fmt_vbi_out ||
-	    ops->vidioc_g_fmt_sliced_vbi_cap ||
-	    ops->vidioc_g_fmt_sliced_vbi_out)
-		set_bit(_IOC_NR(VIDIOC_G_FMT), valid_ioctls);
-	if (ops->vidioc_s_fmt_vid_cap ||
-	    ops->vidioc_s_fmt_vid_out ||
-	    ops->vidioc_s_fmt_vid_cap_mplane ||
-	    ops->vidioc_s_fmt_vid_out_mplane ||
-	    ops->vidioc_s_fmt_vid_overlay ||
-	    ops->vidioc_s_fmt_vbi_cap ||
-	    ops->vidioc_s_fmt_vid_out_overlay ||
-	    ops->vidioc_s_fmt_vbi_out ||
-	    ops->vidioc_s_fmt_sliced_vbi_cap ||
-	    ops->vidioc_s_fmt_sliced_vbi_out)
-		set_bit(_IOC_NR(VIDIOC_S_FMT), valid_ioctls);
-	if (ops->vidioc_try_fmt_vid_cap ||
-	    ops->vidioc_try_fmt_vid_out ||
-	    ops->vidioc_try_fmt_vid_cap_mplane ||
-	    ops->vidioc_try_fmt_vid_out_mplane ||
-	    ops->vidioc_try_fmt_vid_overlay ||
-	    ops->vidioc_try_fmt_vbi_cap ||
-	    ops->vidioc_try_fmt_vid_out_overlay ||
-	    ops->vidioc_try_fmt_vbi_out ||
-	    ops->vidioc_try_fmt_sliced_vbi_cap ||
-	    ops->vidioc_try_fmt_sliced_vbi_out)
-		set_bit(_IOC_NR(VIDIOC_TRY_FMT), valid_ioctls);
+	if (is_vid) {
+		if ((is_rx && (ops->vidioc_enum_fmt_vid_cap ||
+			       ops->vidioc_enum_fmt_vid_cap_mplane ||
+			       ops->vidioc_enum_fmt_vid_overlay)) ||
+		    (is_tx && (ops->vidioc_enum_fmt_vid_out ||
+			       ops->vidioc_enum_fmt_vid_out_mplane)))
+			set_bit(_IOC_NR(VIDIOC_ENUM_FMT), valid_ioctls);
+		if ((is_rx && (ops->vidioc_g_fmt_vid_cap ||
+			       ops->vidioc_g_fmt_vid_cap_mplane ||
+			       ops->vidioc_g_fmt_vid_overlay)) ||
+		    (is_tx && (ops->vidioc_g_fmt_vid_out ||
+			       ops->vidioc_g_fmt_vid_out_mplane ||
+			       ops->vidioc_g_fmt_vid_out_overlay)))
+			 set_bit(_IOC_NR(VIDIOC_G_FMT), valid_ioctls);
+		if ((is_rx && (ops->vidioc_s_fmt_vid_cap ||
+			       ops->vidioc_s_fmt_vid_cap_mplane ||
+			       ops->vidioc_s_fmt_vid_overlay)) ||
+		    (is_tx && (ops->vidioc_s_fmt_vid_out ||
+			       ops->vidioc_s_fmt_vid_out_mplane ||
+			       ops->vidioc_s_fmt_vid_out_overlay)))
+			 set_bit(_IOC_NR(VIDIOC_S_FMT), valid_ioctls);
+		if ((is_rx && (ops->vidioc_try_fmt_vid_cap ||
+			       ops->vidioc_try_fmt_vid_cap_mplane ||
+			       ops->vidioc_try_fmt_vid_overlay)) ||
+		    (is_tx && (ops->vidioc_try_fmt_vid_out ||
+			       ops->vidioc_try_fmt_vid_out_mplane ||
+			       ops->vidioc_try_fmt_vid_out_overlay)))
+			 set_bit(_IOC_NR(VIDIOC_TRY_FMT), valid_ioctls);
+	} else if (is_vbi) {
+		if ((is_rx && (ops->vidioc_g_fmt_vbi_cap ||
+			       ops->vidioc_g_fmt_sliced_vbi_cap)) ||
+		    (is_tx && (ops->vidioc_g_fmt_vbi_out ||
+			       ops->vidioc_g_fmt_sliced_vbi_out)))
+			set_bit(_IOC_NR(VIDIOC_G_FMT), valid_ioctls);
+		if ((is_rx && (ops->vidioc_s_fmt_vbi_cap ||
+			       ops->vidioc_s_fmt_sliced_vbi_cap)) ||
+		    (is_tx && (ops->vidioc_s_fmt_vbi_out ||
+			       ops->vidioc_s_fmt_sliced_vbi_out)))
+			set_bit(_IOC_NR(VIDIOC_S_FMT), valid_ioctls);
+		if ((is_rx && (ops->vidioc_try_fmt_vbi_cap ||
+			       ops->vidioc_try_fmt_sliced_vbi_cap)) ||
+		    (is_tx && (ops->vidioc_try_fmt_vbi_out ||
+			       ops->vidioc_try_fmt_sliced_vbi_out)))
+			set_bit(_IOC_NR(VIDIOC_TRY_FMT), valid_ioctls);
+	}
 	SET_VALID_IOCTL(ops, VIDIOC_REQBUFS, vidioc_reqbufs);
 	SET_VALID_IOCTL(ops, VIDIOC_QUERYBUF, vidioc_querybuf);
 	SET_VALID_IOCTL(ops, VIDIOC_QBUF, vidioc_qbuf);
 	SET_VALID_IOCTL(ops, VIDIOC_DQBUF, vidioc_dqbuf);
-	SET_VALID_IOCTL(ops, VIDIOC_OVERLAY, vidioc_overlay);
-	SET_VALID_IOCTL(ops, VIDIOC_G_FBUF, vidioc_g_fbuf);
-	SET_VALID_IOCTL(ops, VIDIOC_S_FBUF, vidioc_s_fbuf);
+	if (is_vid) {
+		SET_VALID_IOCTL(ops, VIDIOC_OVERLAY, vidioc_overlay);
+		SET_VALID_IOCTL(ops, VIDIOC_G_FBUF, vidioc_g_fbuf);
+		SET_VALID_IOCTL(ops, VIDIOC_S_FBUF, vidioc_s_fbuf);
+	}
 	SET_VALID_IOCTL(ops, VIDIOC_STREAMON, vidioc_streamon);
 	SET_VALID_IOCTL(ops, VIDIOC_STREAMOFF, vidioc_streamoff);
-	if (vdev->tvnorms)
-		set_bit(_IOC_NR(VIDIOC_ENUMSTD), valid_ioctls);
-	if (ops->vidioc_g_std || vdev->current_norm)
-		set_bit(_IOC_NR(VIDIOC_G_STD), valid_ioctls);
-	SET_VALID_IOCTL(ops, VIDIOC_S_STD, vidioc_s_std);
-	SET_VALID_IOCTL(ops, VIDIOC_QUERYSTD, vidioc_querystd);
-	SET_VALID_IOCTL(ops, VIDIOC_ENUMINPUT, vidioc_enum_input);
-	SET_VALID_IOCTL(ops, VIDIOC_G_INPUT, vidioc_g_input);
-	SET_VALID_IOCTL(ops, VIDIOC_S_INPUT, vidioc_s_input);
-	SET_VALID_IOCTL(ops, VIDIOC_ENUMOUTPUT, vidioc_enum_output);
-	SET_VALID_IOCTL(ops, VIDIOC_G_OUTPUT, vidioc_g_output);
-	SET_VALID_IOCTL(ops, VIDIOC_S_OUTPUT, vidioc_s_output);
+	if (!is_radio) {
+		if (vdev->tvnorms)
+			set_bit(_IOC_NR(VIDIOC_ENUMSTD), valid_ioctls);
+		if (ops->vidioc_g_std || vdev->current_norm)
+			set_bit(_IOC_NR(VIDIOC_G_STD), valid_ioctls);
+		SET_VALID_IOCTL(ops, VIDIOC_S_STD, vidioc_s_std);
+		if (is_rx)
+			SET_VALID_IOCTL(ops, VIDIOC_QUERYSTD, vidioc_querystd);
+		if (is_rx) {
+			SET_VALID_IOCTL(ops, VIDIOC_ENUMINPUT, vidioc_enum_input);
+			SET_VALID_IOCTL(ops, VIDIOC_G_INPUT, vidioc_g_input);
+			SET_VALID_IOCTL(ops, VIDIOC_S_INPUT, vidioc_s_input);
+			SET_VALID_IOCTL(ops, VIDIOC_ENUMAUDIO, vidioc_enumaudio);
+			SET_VALID_IOCTL(ops, VIDIOC_G_AUDIO, vidioc_g_audio);
+			SET_VALID_IOCTL(ops, VIDIOC_S_AUDIO, vidioc_s_audio);
+		}
+		if (is_tx) {
+			SET_VALID_IOCTL(ops, VIDIOC_ENUMOUTPUT, vidioc_enum_output);
+			SET_VALID_IOCTL(ops, VIDIOC_G_OUTPUT, vidioc_g_output);
+			SET_VALID_IOCTL(ops, VIDIOC_S_OUTPUT, vidioc_s_output);
+			SET_VALID_IOCTL(ops, VIDIOC_ENUMAUDOUT, vidioc_enumaudout);
+			SET_VALID_IOCTL(ops, VIDIOC_G_AUDOUT, vidioc_g_audout);
+			SET_VALID_IOCTL(ops, VIDIOC_S_AUDOUT, vidioc_s_audout);
+		}
+	}
 	/* Note: the control handler can also be passed through the filehandle,
 	   and that can't be tested here. If the bit for these control ioctls
 	   is set, then the ioctl is valid. But if it is 0, then it can still
@@ -639,56 +665,68 @@ static void determine_valid_ioctls(struct video_device *vdev)
 		set_bit(_IOC_NR(VIDIOC_TRY_EXT_CTRLS), valid_ioctls);
 	if (vdev->ctrl_handler || ops->vidioc_querymenu)
 		set_bit(_IOC_NR(VIDIOC_QUERYMENU), valid_ioctls);
-	SET_VALID_IOCTL(ops, VIDIOC_ENUMAUDIO, vidioc_enumaudio);
-	SET_VALID_IOCTL(ops, VIDIOC_G_AUDIO, vidioc_g_audio);
-	SET_VALID_IOCTL(ops, VIDIOC_S_AUDIO, vidioc_s_audio);
-	SET_VALID_IOCTL(ops, VIDIOC_ENUMAUDOUT, vidioc_enumaudout);
-	SET_VALID_IOCTL(ops, VIDIOC_G_AUDOUT, vidioc_g_audout);
-	SET_VALID_IOCTL(ops, VIDIOC_S_AUDOUT, vidioc_s_audout);
-	SET_VALID_IOCTL(ops, VIDIOC_G_MODULATOR, vidioc_g_modulator);
-	SET_VALID_IOCTL(ops, VIDIOC_S_MODULATOR, vidioc_s_modulator);
-	if (ops->vidioc_g_crop || ops->vidioc_g_selection)
-		set_bit(_IOC_NR(VIDIOC_G_CROP), valid_ioctls);
-	if (ops->vidioc_s_crop || ops->vidioc_s_selection)
-		set_bit(_IOC_NR(VIDIOC_S_CROP), valid_ioctls);
-	SET_VALID_IOCTL(ops, VIDIOC_G_SELECTION, vidioc_g_selection);
-	SET_VALID_IOCTL(ops, VIDIOC_S_SELECTION, vidioc_s_selection);
-	if (ops->vidioc_cropcap || ops->vidioc_g_selection)
-		set_bit(_IOC_NR(VIDIOC_CROPCAP), valid_ioctls);
-	SET_VALID_IOCTL(ops, VIDIOC_G_JPEGCOMP, vidioc_g_jpegcomp);
-	SET_VALID_IOCTL(ops, VIDIOC_S_JPEGCOMP, vidioc_s_jpegcomp);
-	SET_VALID_IOCTL(ops, VIDIOC_G_ENC_INDEX, vidioc_g_enc_index);
-	SET_VALID_IOCTL(ops, VIDIOC_ENCODER_CMD, vidioc_encoder_cmd);
-	SET_VALID_IOCTL(ops, VIDIOC_TRY_ENCODER_CMD, vidioc_try_encoder_cmd);
-	SET_VALID_IOCTL(ops, VIDIOC_DECODER_CMD, vidioc_decoder_cmd);
-	SET_VALID_IOCTL(ops, VIDIOC_TRY_DECODER_CMD, vidioc_try_decoder_cmd);
-	if (ops->vidioc_g_parm || (vdev->vfl_type == VFL_TYPE_GRABBER &&
+	if (is_tx) {
+		SET_VALID_IOCTL(ops, VIDIOC_G_MODULATOR, vidioc_g_modulator);
+		SET_VALID_IOCTL(ops, VIDIOC_S_MODULATOR, vidioc_s_modulator);
+	}
+	if (!is_radio) {
+		if (ops->vidioc_g_crop || ops->vidioc_g_selection)
+			set_bit(_IOC_NR(VIDIOC_G_CROP), valid_ioctls);
+		if (ops->vidioc_s_crop || ops->vidioc_s_selection)
+			set_bit(_IOC_NR(VIDIOC_S_CROP), valid_ioctls);
+		SET_VALID_IOCTL(ops, VIDIOC_G_SELECTION, vidioc_g_selection);
+		SET_VALID_IOCTL(ops, VIDIOC_S_SELECTION, vidioc_s_selection);
+		if (ops->vidioc_cropcap || ops->vidioc_g_selection)
+			set_bit(_IOC_NR(VIDIOC_CROPCAP), valid_ioctls);
+	}
+	if (is_vid) {
+		SET_VALID_IOCTL(ops, VIDIOC_G_JPEGCOMP, vidioc_g_jpegcomp);
+		SET_VALID_IOCTL(ops, VIDIOC_S_JPEGCOMP, vidioc_s_jpegcomp);
+		SET_VALID_IOCTL(ops, VIDIOC_G_ENC_INDEX, vidioc_g_enc_index);
+		SET_VALID_IOCTL(ops, VIDIOC_ENCODER_CMD, vidioc_encoder_cmd);
+		SET_VALID_IOCTL(ops, VIDIOC_TRY_ENCODER_CMD, vidioc_try_encoder_cmd);
+		SET_VALID_IOCTL(ops, VIDIOC_DECODER_CMD, vidioc_decoder_cmd);
+		SET_VALID_IOCTL(ops, VIDIOC_TRY_DECODER_CMD, vidioc_try_decoder_cmd);
+	}
+	if (!is_radio) {
+		if (ops->vidioc_g_parm || (vdev->vfl_type == VFL_TYPE_GRABBER &&
 					(ops->vidioc_g_std || vdev->tvnorms)))
-		set_bit(_IOC_NR(VIDIOC_G_PARM), valid_ioctls);
-	SET_VALID_IOCTL(ops, VIDIOC_S_PARM, vidioc_s_parm);
-	SET_VALID_IOCTL(ops, VIDIOC_G_TUNER, vidioc_g_tuner);
-	SET_VALID_IOCTL(ops, VIDIOC_S_TUNER, vidioc_s_tuner);
+			set_bit(_IOC_NR(VIDIOC_G_PARM), valid_ioctls);
+		SET_VALID_IOCTL(ops, VIDIOC_S_PARM, vidioc_s_parm);
+	}
+	if (is_rx) {
+		SET_VALID_IOCTL(ops, VIDIOC_G_TUNER, vidioc_g_tuner);
+		SET_VALID_IOCTL(ops, VIDIOC_S_TUNER, vidioc_s_tuner);
+	}
 	SET_VALID_IOCTL(ops, VIDIOC_G_FREQUENCY, vidioc_g_frequency);
 	SET_VALID_IOCTL(ops, VIDIOC_S_FREQUENCY, vidioc_s_frequency);
-	SET_VALID_IOCTL(ops, VIDIOC_G_SLICED_VBI_CAP, vidioc_g_sliced_vbi_cap);
+	if (is_vbi)
+		SET_VALID_IOCTL(ops, VIDIOC_G_SLICED_VBI_CAP, vidioc_g_sliced_vbi_cap);
 	SET_VALID_IOCTL(ops, VIDIOC_LOG_STATUS, vidioc_log_status);
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	SET_VALID_IOCTL(ops, VIDIOC_DBG_G_REGISTER, vidioc_g_register);
 	SET_VALID_IOCTL(ops, VIDIOC_DBG_S_REGISTER, vidioc_s_register);
 #endif
 	SET_VALID_IOCTL(ops, VIDIOC_DBG_G_CHIP_IDENT, vidioc_g_chip_ident);
-	SET_VALID_IOCTL(ops, VIDIOC_S_HW_FREQ_SEEK, vidioc_s_hw_freq_seek);
-	SET_VALID_IOCTL(ops, VIDIOC_ENUM_FRAMESIZES, vidioc_enum_framesizes);
-	SET_VALID_IOCTL(ops, VIDIOC_ENUM_FRAMEINTERVALS, vidioc_enum_frameintervals);
-	SET_VALID_IOCTL(ops, VIDIOC_ENUM_DV_PRESETS, vidioc_enum_dv_presets);
-	SET_VALID_IOCTL(ops, VIDIOC_S_DV_PRESET, vidioc_s_dv_preset);
-	SET_VALID_IOCTL(ops, VIDIOC_G_DV_PRESET, vidioc_g_dv_preset);
-	SET_VALID_IOCTL(ops, VIDIOC_QUERY_DV_PRESET, vidioc_query_dv_preset);
-	SET_VALID_IOCTL(ops, VIDIOC_S_DV_TIMINGS, vidioc_s_dv_timings);
-	SET_VALID_IOCTL(ops, VIDIOC_G_DV_TIMINGS, vidioc_g_dv_timings);
-	SET_VALID_IOCTL(ops, VIDIOC_ENUM_DV_TIMINGS, vidioc_enum_dv_timings);
-	SET_VALID_IOCTL(ops, VIDIOC_QUERY_DV_TIMINGS, vidioc_query_dv_timings);
-	SET_VALID_IOCTL(ops, VIDIOC_DV_TIMINGS_CAP, vidioc_dv_timings_cap);
+	if (is_rx)
+		SET_VALID_IOCTL(ops, VIDIOC_S_HW_FREQ_SEEK, vidioc_s_hw_freq_seek);
+	if (is_vid) {
+		SET_VALID_IOCTL(ops, VIDIOC_ENUM_FRAMESIZES, vidioc_enum_framesizes);
+		SET_VALID_IOCTL(ops, VIDIOC_ENUM_FRAMEINTERVALS, vidioc_enum_frameintervals);
+	}
+	if (!is_radio) {
+		SET_VALID_IOCTL(ops, VIDIOC_ENUM_DV_PRESETS, vidioc_enum_dv_presets);
+		SET_VALID_IOCTL(ops, VIDIOC_S_DV_PRESET, vidioc_s_dv_preset);
+		SET_VALID_IOCTL(ops, VIDIOC_G_DV_PRESET, vidioc_g_dv_preset);
+		if (is_rx)
+			SET_VALID_IOCTL(ops, VIDIOC_QUERY_DV_PRESET, vidioc_query_dv_preset);
+		SET_VALID_IOCTL(ops, VIDIOC_S_DV_TIMINGS, vidioc_s_dv_timings);
+		SET_VALID_IOCTL(ops, VIDIOC_G_DV_TIMINGS, vidioc_g_dv_timings);
+		SET_VALID_IOCTL(ops, VIDIOC_ENUM_DV_TIMINGS, vidioc_enum_dv_timings);
+		if (is_rx)
+			SET_VALID_IOCTL(ops, VIDIOC_QUERY_DV_TIMINGS, vidioc_query_dv_timings);
+		SET_VALID_IOCTL(ops, VIDIOC_DV_TIMINGS_CAP, vidioc_dv_timings_cap);
+	}
 	/* yes, really vidioc_subscribe_event */
 	SET_VALID_IOCTL(ops, VIDIOC_DQEVENT, vidioc_subscribe_event);
 	SET_VALID_IOCTL(ops, VIDIOC_SUBSCRIBE_EVENT, vidioc_subscribe_event);
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 725c56e..97f4d99 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -876,52 +876,59 @@ static int check_ext_ctrls(struct v4l2_ext_controls *c, int allow_priv)
 	return 1;
 }
 
-static int check_fmt(const struct v4l2_ioctl_ops *ops, enum v4l2_buf_type type)
+static int check_fmt(struct file *file, enum v4l2_buf_type type)
 {
+	struct video_device *vfd = video_devdata(file);
+	const struct v4l2_ioctl_ops *ops = vfd->ioctl_ops;
+	bool is_vid = vfd->vfl_type == VFL_TYPE_GRABBER;
+	bool is_vbi = vfd->vfl_type == VFL_TYPE_VBI;
+	bool is_rx = vfd->vfl_dir != VFL_DIR_TX;
+	bool is_tx = vfd->vfl_dir != VFL_DIR_RX;
+
 	if (ops == NULL)
 		return -EINVAL;
 
 	switch (type) {
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
-		if (ops->vidioc_g_fmt_vid_cap ||
-				ops->vidioc_g_fmt_vid_cap_mplane)
+		if (is_vid && is_rx &&
+		    (ops->vidioc_g_fmt_vid_cap || ops->vidioc_g_fmt_vid_cap_mplane))
 			return 0;
 		break;
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
-		if (ops->vidioc_g_fmt_vid_cap_mplane)
+		if (is_vid && is_rx && ops->vidioc_g_fmt_vid_cap_mplane)
 			return 0;
 		break;
 	case V4L2_BUF_TYPE_VIDEO_OVERLAY:
-		if (ops->vidioc_g_fmt_vid_overlay)
+		if (is_vid && is_rx && ops->vidioc_g_fmt_vid_overlay)
 			return 0;
 		break;
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
-		if (ops->vidioc_g_fmt_vid_out ||
-				ops->vidioc_g_fmt_vid_out_mplane)
+		if (is_vid && is_tx &&
+		    (ops->vidioc_g_fmt_vid_out || ops->vidioc_g_fmt_vid_out_mplane))
 			return 0;
 		break;
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
-		if (ops->vidioc_g_fmt_vid_out_mplane)
+		if (is_vid && is_tx && ops->vidioc_g_fmt_vid_out_mplane)
 			return 0;
 		break;
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY:
-		if (ops->vidioc_g_fmt_vid_out_overlay)
+		if (is_vid && is_tx && ops->vidioc_g_fmt_vid_out_overlay)
 			return 0;
 		break;
 	case V4L2_BUF_TYPE_VBI_CAPTURE:
-		if (ops->vidioc_g_fmt_vbi_cap)
+		if (is_vbi && is_rx && ops->vidioc_g_fmt_vbi_cap)
 			return 0;
 		break;
 	case V4L2_BUF_TYPE_VBI_OUTPUT:
-		if (ops->vidioc_g_fmt_vbi_out)
+		if (is_vbi && is_tx && ops->vidioc_g_fmt_vbi_out)
 			return 0;
 		break;
 	case V4L2_BUF_TYPE_SLICED_VBI_CAPTURE:
-		if (ops->vidioc_g_fmt_sliced_vbi_cap)
+		if (is_vbi && is_rx && ops->vidioc_g_fmt_sliced_vbi_cap)
 			return 0;
 		break;
 	case V4L2_BUF_TYPE_SLICED_VBI_OUTPUT:
-		if (ops->vidioc_g_fmt_sliced_vbi_out)
+		if (is_vbi && is_tx && ops->vidioc_g_fmt_sliced_vbi_out)
 			return 0;
 		break;
 	default:
@@ -1024,26 +1031,29 @@ static int v4l_enum_fmt(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
 	struct v4l2_fmtdesc *p = arg;
+	struct video_device *vfd = video_devdata(file);
+	bool is_rx = vfd->vfl_dir != VFL_DIR_TX;
+	bool is_tx = vfd->vfl_dir != VFL_DIR_RX;
 
 	switch (p->type) {
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
-		if (unlikely(!ops->vidioc_enum_fmt_vid_cap))
+		if (unlikely(!is_rx || !ops->vidioc_enum_fmt_vid_cap))
 			break;
 		return ops->vidioc_enum_fmt_vid_cap(file, fh, arg);
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
-		if (unlikely(!ops->vidioc_enum_fmt_vid_cap_mplane))
+		if (unlikely(!is_rx || !ops->vidioc_enum_fmt_vid_cap_mplane))
 			break;
 		return ops->vidioc_enum_fmt_vid_cap_mplane(file, fh, arg);
 	case V4L2_BUF_TYPE_VIDEO_OVERLAY:
-		if (unlikely(!ops->vidioc_enum_fmt_vid_overlay))
+		if (unlikely(!is_rx || !ops->vidioc_enum_fmt_vid_overlay))
 			break;
 		return ops->vidioc_enum_fmt_vid_overlay(file, fh, arg);
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
-		if (unlikely(!ops->vidioc_enum_fmt_vid_out))
+		if (unlikely(!is_tx || !ops->vidioc_enum_fmt_vid_out))
 			break;
 		return ops->vidioc_enum_fmt_vid_out(file, fh, arg);
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
-		if (unlikely(!ops->vidioc_enum_fmt_vid_out_mplane))
+		if (unlikely(!is_tx || !ops->vidioc_enum_fmt_vid_out_mplane))
 			break;
 		return ops->vidioc_enum_fmt_vid_out_mplane(file, fh, arg);
 	}
@@ -1054,46 +1064,50 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
 	struct v4l2_format *p = arg;
+	struct video_device *vfd = video_devdata(file);
+	bool is_vid = vfd->vfl_type == VFL_TYPE_GRABBER;
+	bool is_rx = vfd->vfl_dir != VFL_DIR_TX;
+	bool is_tx = vfd->vfl_dir != VFL_DIR_RX;
 
 	switch (p->type) {
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
-		if (unlikely(!ops->vidioc_g_fmt_vid_cap))
+		if (unlikely(!is_rx || !is_vid || !ops->vidioc_g_fmt_vid_cap))
 			break;
 		return ops->vidioc_g_fmt_vid_cap(file, fh, arg);
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
-		if (unlikely(!ops->vidioc_g_fmt_vid_cap_mplane))
+		if (unlikely(!is_rx || !is_vid || !ops->vidioc_g_fmt_vid_cap_mplane))
 			break;
 		return ops->vidioc_g_fmt_vid_cap_mplane(file, fh, arg);
 	case V4L2_BUF_TYPE_VIDEO_OVERLAY:
-		if (unlikely(!ops->vidioc_g_fmt_vid_overlay))
+		if (unlikely(!is_rx || !is_vid || !ops->vidioc_g_fmt_vid_overlay))
 			break;
 		return ops->vidioc_g_fmt_vid_overlay(file, fh, arg);
+	case V4L2_BUF_TYPE_VBI_CAPTURE:
+		if (unlikely(!is_rx || is_vid || !ops->vidioc_g_fmt_vbi_cap))
+			break;
+		return ops->vidioc_g_fmt_vbi_cap(file, fh, arg);
+	case V4L2_BUF_TYPE_SLICED_VBI_CAPTURE:
+		if (unlikely(!is_rx || is_vid || !ops->vidioc_g_fmt_sliced_vbi_cap))
+			break;
+		return ops->vidioc_g_fmt_sliced_vbi_cap(file, fh, arg);
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
-		if (unlikely(!ops->vidioc_g_fmt_vid_out))
+		if (unlikely(!is_tx || !is_vid || !ops->vidioc_g_fmt_vid_out))
 			break;
 		return ops->vidioc_g_fmt_vid_out(file, fh, arg);
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
-		if (unlikely(!ops->vidioc_g_fmt_vid_out_mplane))
+		if (unlikely(!is_tx || !is_vid || !ops->vidioc_g_fmt_vid_out_mplane))
 			break;
 		return ops->vidioc_g_fmt_vid_out_mplane(file, fh, arg);
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY:
-		if (unlikely(!ops->vidioc_g_fmt_vid_out_overlay))
+		if (unlikely(!is_tx || !is_vid || !ops->vidioc_g_fmt_vid_out_overlay))
 			break;
 		return ops->vidioc_g_fmt_vid_out_overlay(file, fh, arg);
-	case V4L2_BUF_TYPE_VBI_CAPTURE:
-		if (unlikely(!ops->vidioc_g_fmt_vbi_cap))
-			break;
-		return ops->vidioc_g_fmt_vbi_cap(file, fh, arg);
 	case V4L2_BUF_TYPE_VBI_OUTPUT:
-		if (unlikely(!ops->vidioc_g_fmt_vbi_out))
+		if (unlikely(!is_tx || is_vid || !ops->vidioc_g_fmt_vbi_out))
 			break;
 		return ops->vidioc_g_fmt_vbi_out(file, fh, arg);
-	case V4L2_BUF_TYPE_SLICED_VBI_CAPTURE:
-		if (unlikely(!ops->vidioc_g_fmt_sliced_vbi_cap))
-			break;
-		return ops->vidioc_g_fmt_sliced_vbi_cap(file, fh, arg);
 	case V4L2_BUF_TYPE_SLICED_VBI_OUTPUT:
-		if (unlikely(!ops->vidioc_g_fmt_sliced_vbi_out))
+		if (unlikely(!is_tx || is_vid || !ops->vidioc_g_fmt_sliced_vbi_out))
 			break;
 		return ops->vidioc_g_fmt_sliced_vbi_out(file, fh, arg);
 	}
@@ -1104,55 +1118,59 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
 	struct v4l2_format *p = arg;
+	struct video_device *vfd = video_devdata(file);
+	bool is_vid = vfd->vfl_type == VFL_TYPE_GRABBER;
+	bool is_rx = vfd->vfl_dir != VFL_DIR_TX;
+	bool is_tx = vfd->vfl_dir != VFL_DIR_RX;
 
 	switch (p->type) {
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
-		if (unlikely(!ops->vidioc_s_fmt_vid_cap))
+		if (unlikely(!is_rx || !is_vid || !ops->vidioc_s_fmt_vid_cap))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.pix);
 		return ops->vidioc_s_fmt_vid_cap(file, fh, arg);
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
-		if (unlikely(!ops->vidioc_s_fmt_vid_cap_mplane))
+		if (unlikely(!is_rx || !is_vid || !ops->vidioc_s_fmt_vid_cap_mplane))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.pix_mp);
 		return ops->vidioc_s_fmt_vid_cap_mplane(file, fh, arg);
 	case V4L2_BUF_TYPE_VIDEO_OVERLAY:
-		if (unlikely(!ops->vidioc_s_fmt_vid_overlay))
+		if (unlikely(!is_rx || !is_vid || !ops->vidioc_s_fmt_vid_overlay))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.win);
 		return ops->vidioc_s_fmt_vid_overlay(file, fh, arg);
+	case V4L2_BUF_TYPE_VBI_CAPTURE:
+		if (unlikely(!is_rx || is_vid || !ops->vidioc_s_fmt_vbi_cap))
+			break;
+		CLEAR_AFTER_FIELD(p, fmt.vbi);
+		return ops->vidioc_s_fmt_vbi_cap(file, fh, arg);
+	case V4L2_BUF_TYPE_SLICED_VBI_CAPTURE:
+		if (unlikely(!is_rx || is_vid || !ops->vidioc_s_fmt_sliced_vbi_cap))
+			break;
+		CLEAR_AFTER_FIELD(p, fmt.sliced);
+		return ops->vidioc_s_fmt_sliced_vbi_cap(file, fh, arg);
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
-		if (unlikely(!ops->vidioc_s_fmt_vid_out))
+		if (unlikely(!is_tx || !is_vid || !ops->vidioc_s_fmt_vid_out))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.pix);
 		return ops->vidioc_s_fmt_vid_out(file, fh, arg);
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
-		if (unlikely(!ops->vidioc_s_fmt_vid_out_mplane))
+		if (unlikely(!is_tx || !is_vid || !ops->vidioc_s_fmt_vid_out_mplane))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.pix_mp);
 		return ops->vidioc_s_fmt_vid_out_mplane(file, fh, arg);
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY:
-		if (unlikely(!ops->vidioc_s_fmt_vid_out_overlay))
+		if (unlikely(!is_tx || !is_vid || !ops->vidioc_s_fmt_vid_out_overlay))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.win);
 		return ops->vidioc_s_fmt_vid_out_overlay(file, fh, arg);
-	case V4L2_BUF_TYPE_VBI_CAPTURE:
-		if (unlikely(!ops->vidioc_s_fmt_vbi_cap))
-			break;
-		CLEAR_AFTER_FIELD(p, fmt.vbi);
-		return ops->vidioc_s_fmt_vbi_cap(file, fh, arg);
 	case V4L2_BUF_TYPE_VBI_OUTPUT:
-		if (unlikely(!ops->vidioc_s_fmt_vbi_out))
+		if (unlikely(!is_tx || is_vid || !ops->vidioc_s_fmt_vbi_out))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.vbi);
 		return ops->vidioc_s_fmt_vbi_out(file, fh, arg);
-	case V4L2_BUF_TYPE_SLICED_VBI_CAPTURE:
-		if (unlikely(!ops->vidioc_s_fmt_sliced_vbi_cap))
-			break;
-		CLEAR_AFTER_FIELD(p, fmt.sliced);
-		return ops->vidioc_s_fmt_sliced_vbi_cap(file, fh, arg);
 	case V4L2_BUF_TYPE_SLICED_VBI_OUTPUT:
-		if (unlikely(!ops->vidioc_s_fmt_sliced_vbi_out))
+		if (unlikely(!is_tx || is_vid || !ops->vidioc_s_fmt_sliced_vbi_out))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.sliced);
 		return ops->vidioc_s_fmt_sliced_vbi_out(file, fh, arg);
@@ -1164,55 +1182,59 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
 	struct v4l2_format *p = arg;
+	struct video_device *vfd = video_devdata(file);
+	bool is_vid = vfd->vfl_type == VFL_TYPE_GRABBER;
+	bool is_rx = vfd->vfl_dir != VFL_DIR_TX;
+	bool is_tx = vfd->vfl_dir != VFL_DIR_RX;
 
 	switch (p->type) {
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
-		if (unlikely(!ops->vidioc_try_fmt_vid_cap))
+		if (unlikely(!is_rx || !is_vid || !ops->vidioc_try_fmt_vid_cap))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.pix);
 		return ops->vidioc_try_fmt_vid_cap(file, fh, arg);
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
-		if (unlikely(!ops->vidioc_try_fmt_vid_cap_mplane))
+		if (unlikely(!is_rx || !is_vid || !ops->vidioc_try_fmt_vid_cap_mplane))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.pix_mp);
 		return ops->vidioc_try_fmt_vid_cap_mplane(file, fh, arg);
 	case V4L2_BUF_TYPE_VIDEO_OVERLAY:
-		if (unlikely(!ops->vidioc_try_fmt_vid_overlay))
+		if (unlikely(!is_rx || !is_vid || !ops->vidioc_try_fmt_vid_overlay))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.win);
 		return ops->vidioc_try_fmt_vid_overlay(file, fh, arg);
+	case V4L2_BUF_TYPE_VBI_CAPTURE:
+		if (unlikely(!is_rx || is_vid || !ops->vidioc_try_fmt_vbi_cap))
+			break;
+		CLEAR_AFTER_FIELD(p, fmt.vbi);
+		return ops->vidioc_try_fmt_vbi_cap(file, fh, arg);
+	case V4L2_BUF_TYPE_SLICED_VBI_CAPTURE:
+		if (unlikely(!is_rx || is_vid || !ops->vidioc_try_fmt_sliced_vbi_cap))
+			break;
+		CLEAR_AFTER_FIELD(p, fmt.sliced);
+		return ops->vidioc_try_fmt_sliced_vbi_cap(file, fh, arg);
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
-		if (unlikely(!ops->vidioc_try_fmt_vid_out))
+		if (unlikely(!is_tx || !is_vid || !ops->vidioc_try_fmt_vid_out))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.pix);
 		return ops->vidioc_try_fmt_vid_out(file, fh, arg);
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
-		if (unlikely(!ops->vidioc_try_fmt_vid_out_mplane))
+		if (unlikely(!is_tx || !is_vid || !ops->vidioc_try_fmt_vid_out_mplane))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.pix_mp);
 		return ops->vidioc_try_fmt_vid_out_mplane(file, fh, arg);
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY:
-		if (unlikely(!ops->vidioc_try_fmt_vid_out_overlay))
+		if (unlikely(!is_tx || !is_vid || !ops->vidioc_try_fmt_vid_out_overlay))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.win);
 		return ops->vidioc_try_fmt_vid_out_overlay(file, fh, arg);
-	case V4L2_BUF_TYPE_VBI_CAPTURE:
-		if (unlikely(!ops->vidioc_try_fmt_vbi_cap))
-			break;
-		CLEAR_AFTER_FIELD(p, fmt.vbi);
-		return ops->vidioc_try_fmt_vbi_cap(file, fh, arg);
 	case V4L2_BUF_TYPE_VBI_OUTPUT:
-		if (unlikely(!ops->vidioc_try_fmt_vbi_out))
+		if (unlikely(!is_tx || is_vid || !ops->vidioc_try_fmt_vbi_out))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.vbi);
 		return ops->vidioc_try_fmt_vbi_out(file, fh, arg);
-	case V4L2_BUF_TYPE_SLICED_VBI_CAPTURE:
-		if (unlikely(!ops->vidioc_try_fmt_sliced_vbi_cap))
-			break;
-		CLEAR_AFTER_FIELD(p, fmt.sliced);
-		return ops->vidioc_try_fmt_sliced_vbi_cap(file, fh, arg);
 	case V4L2_BUF_TYPE_SLICED_VBI_OUTPUT:
-		if (unlikely(!ops->vidioc_try_fmt_sliced_vbi_out))
+		if (unlikely(!is_tx || is_vid || !ops->vidioc_try_fmt_sliced_vbi_out))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.sliced);
 		return ops->vidioc_try_fmt_sliced_vbi_out(file, fh, arg);
@@ -1399,7 +1421,7 @@ static int v4l_reqbufs(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
 	struct v4l2_requestbuffers *p = arg;
-	int ret = check_fmt(ops, p->type);
+	int ret = check_fmt(file, p->type);
 
 	if (ret)
 		return ret;
@@ -1413,7 +1435,7 @@ static int v4l_querybuf(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
 	struct v4l2_buffer *p = arg;
-	int ret = check_fmt(ops, p->type);
+	int ret = check_fmt(file, p->type);
 
 	return ret ? ret : ops->vidioc_querybuf(file, fh, p);
 }
@@ -1422,7 +1444,7 @@ static int v4l_qbuf(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
 	struct v4l2_buffer *p = arg;
-	int ret = check_fmt(ops, p->type);
+	int ret = check_fmt(file, p->type);
 
 	return ret ? ret : ops->vidioc_qbuf(file, fh, p);
 }
@@ -1431,7 +1453,7 @@ static int v4l_dqbuf(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
 	struct v4l2_buffer *p = arg;
-	int ret = check_fmt(ops, p->type);
+	int ret = check_fmt(file, p->type);
 
 	return ret ? ret : ops->vidioc_dqbuf(file, fh, p);
 }
@@ -1440,7 +1462,7 @@ static int v4l_create_bufs(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
 	struct v4l2_create_buffers *create = arg;
-	int ret = check_fmt(ops, create->format.type);
+	int ret = check_fmt(file, create->format.type);
 
 	return ret ? ret : ops->vidioc_create_bufs(file, fh, create);
 }
@@ -1449,7 +1471,7 @@ static int v4l_prepare_buf(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
 	struct v4l2_buffer *b = arg;
-	int ret = check_fmt(ops, b->type);
+	int ret = check_fmt(file, b->type);
 
 	return ret ? ret : ops->vidioc_prepare_buf(file, fh, b);
 }
@@ -1460,7 +1482,7 @@ static int v4l_g_parm(const struct v4l2_ioctl_ops *ops,
 	struct video_device *vfd = video_devdata(file);
 	struct v4l2_streamparm *p = arg;
 	v4l2_std_id std;
-	int ret = check_fmt(ops, p->type);
+	int ret = check_fmt(file, p->type);
 
 	if (ret)
 		return ret;
@@ -1483,7 +1505,7 @@ static int v4l_s_parm(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
 	struct v4l2_streamparm *p = arg;
-	int ret = check_fmt(ops, p->type);
+	int ret = check_fmt(file, p->type);
 
 	return ret ? ret : ops->vidioc_s_parm(file, fh, p);
 }
@@ -1805,6 +1827,10 @@ static int v4l_g_sliced_vbi_cap(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
 	struct v4l2_sliced_vbi_cap *p = arg;
+	int ret = check_fmt(file, p->type);
+
+	if (ret)
+		return ret;
 
 	/* Clear up to type, everything after type is zeroed already */
 	memset(p, 0, offsetof(struct v4l2_sliced_vbi_cap, type));
-- 
1.7.10.4

