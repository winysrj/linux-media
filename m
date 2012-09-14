Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:43207 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756175Ab2INK6J (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Sep 2012 06:58:09 -0400
Received: from cobaltpc1.cisco.com (dhcp-10-54-92-107.cisco.com [10.54.92.107])
	by ams-core-3.cisco.com (8.14.5/8.14.5) with ESMTP id q8EAvqC1013688
	for <linux-media@vger.kernel.org>; Fri, 14 Sep 2012 10:58:00 GMT
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Subject: [RFCv3 API PATCH 30/31] v4l2-dev: reorder checks into blocks of ioctls with similar properties.
Date: Fri, 14 Sep 2012 12:57:45 +0200
Message-Id: <3b93baf0c9337c48a9deb8ced363d0d0feb9c420.1347619766.git.hans.verkuil@cisco.com>
In-Reply-To: <1347620266-13767-1-git-send-email-hans.verkuil@cisco.com>
References: <1347620266-13767-1-git-send-email-hans.verkuil@cisco.com>
In-Reply-To: <7447a305817a5e6c63f089c2e1e948533f1d57ea.1347619765.git.hans.verkuil@cisco.com>
References: <7447a305817a5e6c63f089c2e1e948533f1d57ea.1347619765.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This makes it easier to read and also ties in more closely with the
profile concept.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-dev.c |  156 +++++++++++++++++-------------------
 1 file changed, 74 insertions(+), 82 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index b437daa..a2df842 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -559,6 +559,8 @@ static void determine_valid_ioctls(struct video_device *vdev)
 
 	bitmap_zero(valid_ioctls, BASE_VIDIOC_PRIVATE);
 
+	/* vfl_type and vfl_dir independent ioctls */
+
 	SET_VALID_IOCTL(ops, VIDIOC_QUERYCAP, vidioc_querycap);
 	if (ops->vidioc_g_priority ||
 			test_bit(V4L2_FL_USE_FH_PRIO, &vdev->flags))
@@ -566,7 +568,49 @@ static void determine_valid_ioctls(struct video_device *vdev)
 	if (ops->vidioc_s_priority ||
 			test_bit(V4L2_FL_USE_FH_PRIO, &vdev->flags))
 		set_bit(_IOC_NR(VIDIOC_S_PRIORITY), valid_ioctls);
+	SET_VALID_IOCTL(ops, VIDIOC_REQBUFS, vidioc_reqbufs);
+	SET_VALID_IOCTL(ops, VIDIOC_QUERYBUF, vidioc_querybuf);
+	SET_VALID_IOCTL(ops, VIDIOC_QBUF, vidioc_qbuf);
+	SET_VALID_IOCTL(ops, VIDIOC_DQBUF, vidioc_dqbuf);
+	SET_VALID_IOCTL(ops, VIDIOC_STREAMON, vidioc_streamon);
+	SET_VALID_IOCTL(ops, VIDIOC_STREAMOFF, vidioc_streamoff);
+	/* Note: the control handler can also be passed through the filehandle,
+	   and that can't be tested here. If the bit for these control ioctls
+	   is set, then the ioctl is valid. But if it is 0, then it can still
+	   be valid if the filehandle passed the control handler. */
+	if (vdev->ctrl_handler || ops->vidioc_queryctrl)
+		set_bit(_IOC_NR(VIDIOC_QUERYCTRL), valid_ioctls);
+	if (vdev->ctrl_handler || ops->vidioc_g_ctrl || ops->vidioc_g_ext_ctrls)
+		set_bit(_IOC_NR(VIDIOC_G_CTRL), valid_ioctls);
+	if (vdev->ctrl_handler || ops->vidioc_s_ctrl || ops->vidioc_s_ext_ctrls)
+		set_bit(_IOC_NR(VIDIOC_S_CTRL), valid_ioctls);
+	if (vdev->ctrl_handler || ops->vidioc_g_ext_ctrls)
+		set_bit(_IOC_NR(VIDIOC_G_EXT_CTRLS), valid_ioctls);
+	if (vdev->ctrl_handler || ops->vidioc_s_ext_ctrls)
+		set_bit(_IOC_NR(VIDIOC_S_EXT_CTRLS), valid_ioctls);
+	if (vdev->ctrl_handler || ops->vidioc_try_ext_ctrls)
+		set_bit(_IOC_NR(VIDIOC_TRY_EXT_CTRLS), valid_ioctls);
+	if (vdev->ctrl_handler || ops->vidioc_querymenu)
+		set_bit(_IOC_NR(VIDIOC_QUERYMENU), valid_ioctls);
+	SET_VALID_IOCTL(ops, VIDIOC_G_FREQUENCY, vidioc_g_frequency);
+	SET_VALID_IOCTL(ops, VIDIOC_S_FREQUENCY, vidioc_s_frequency);
+	SET_VALID_IOCTL(ops, VIDIOC_LOG_STATUS, vidioc_log_status);
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+	SET_VALID_IOCTL(ops, VIDIOC_DBG_G_REGISTER, vidioc_g_register);
+	SET_VALID_IOCTL(ops, VIDIOC_DBG_S_REGISTER, vidioc_s_register);
+#endif
+	SET_VALID_IOCTL(ops, VIDIOC_DBG_G_CHIP_IDENT, vidioc_g_chip_ident);
+	/* yes, really vidioc_subscribe_event */
+	SET_VALID_IOCTL(ops, VIDIOC_DQEVENT, vidioc_subscribe_event);
+	SET_VALID_IOCTL(ops, VIDIOC_SUBSCRIBE_EVENT, vidioc_subscribe_event);
+	SET_VALID_IOCTL(ops, VIDIOC_UNSUBSCRIBE_EVENT, vidioc_unsubscribe_event);
+	SET_VALID_IOCTL(ops, VIDIOC_CREATE_BUFS, vidioc_create_bufs);
+	SET_VALID_IOCTL(ops, VIDIOC_PREPARE_BUF, vidioc_prepare_buf);
+	if (ops->vidioc_enum_freq_bands || ops->vidioc_g_tuner || ops->vidioc_g_modulator)
+		set_bit(_IOC_NR(VIDIOC_ENUM_FREQ_BANDS), valid_ioctls);
+
 	if (is_vid) {
+		/* video specific ioctls */
 		if ((is_rx && (ops->vidioc_enum_fmt_vid_cap ||
 			       ops->vidioc_enum_fmt_vid_cap_mplane ||
 			       ops->vidioc_enum_fmt_vid_overlay)) ||
@@ -594,7 +638,20 @@ static void determine_valid_ioctls(struct video_device *vdev)
 			       ops->vidioc_try_fmt_vid_out_mplane ||
 			       ops->vidioc_try_fmt_vid_out_overlay)))
 			 set_bit(_IOC_NR(VIDIOC_TRY_FMT), valid_ioctls);
+		SET_VALID_IOCTL(ops, VIDIOC_OVERLAY, vidioc_overlay);
+		SET_VALID_IOCTL(ops, VIDIOC_G_FBUF, vidioc_g_fbuf);
+		SET_VALID_IOCTL(ops, VIDIOC_S_FBUF, vidioc_s_fbuf);
+		SET_VALID_IOCTL(ops, VIDIOC_G_JPEGCOMP, vidioc_g_jpegcomp);
+		SET_VALID_IOCTL(ops, VIDIOC_S_JPEGCOMP, vidioc_s_jpegcomp);
+		SET_VALID_IOCTL(ops, VIDIOC_G_ENC_INDEX, vidioc_g_enc_index);
+		SET_VALID_IOCTL(ops, VIDIOC_ENCODER_CMD, vidioc_encoder_cmd);
+		SET_VALID_IOCTL(ops, VIDIOC_TRY_ENCODER_CMD, vidioc_try_encoder_cmd);
+		SET_VALID_IOCTL(ops, VIDIOC_DECODER_CMD, vidioc_decoder_cmd);
+		SET_VALID_IOCTL(ops, VIDIOC_TRY_DECODER_CMD, vidioc_try_decoder_cmd);
+		SET_VALID_IOCTL(ops, VIDIOC_ENUM_FRAMESIZES, vidioc_enum_framesizes);
+		SET_VALID_IOCTL(ops, VIDIOC_ENUM_FRAMEINTERVALS, vidioc_enum_frameintervals);
 	} else if (is_vbi) {
+		/* vbi specific ioctls */
 		if ((is_rx && (ops->vidioc_g_fmt_vbi_cap ||
 			       ops->vidioc_g_fmt_sliced_vbi_cap)) ||
 		    (is_tx && (ops->vidioc_g_fmt_vbi_out ||
@@ -610,33 +667,25 @@ static void determine_valid_ioctls(struct video_device *vdev)
 		    (is_tx && (ops->vidioc_try_fmt_vbi_out ||
 			       ops->vidioc_try_fmt_sliced_vbi_out)))
 			set_bit(_IOC_NR(VIDIOC_TRY_FMT), valid_ioctls);
+		SET_VALID_IOCTL(ops, VIDIOC_G_SLICED_VBI_CAP, vidioc_g_sliced_vbi_cap);
 	}
-	SET_VALID_IOCTL(ops, VIDIOC_REQBUFS, vidioc_reqbufs);
-	SET_VALID_IOCTL(ops, VIDIOC_QUERYBUF, vidioc_querybuf);
-	SET_VALID_IOCTL(ops, VIDIOC_QBUF, vidioc_qbuf);
-	SET_VALID_IOCTL(ops, VIDIOC_DQBUF, vidioc_dqbuf);
-	if (is_vid) {
-		SET_VALID_IOCTL(ops, VIDIOC_OVERLAY, vidioc_overlay);
-		SET_VALID_IOCTL(ops, VIDIOC_G_FBUF, vidioc_g_fbuf);
-		SET_VALID_IOCTL(ops, VIDIOC_S_FBUF, vidioc_s_fbuf);
-	}
-	SET_VALID_IOCTL(ops, VIDIOC_STREAMON, vidioc_streamon);
-	SET_VALID_IOCTL(ops, VIDIOC_STREAMOFF, vidioc_streamoff);
 	if (!is_radio) {
+		/* ioctls valid for video or vbi */
 		if (ops->vidioc_s_std)
 			set_bit(_IOC_NR(VIDIOC_ENUMSTD), valid_ioctls);
 		if (ops->vidioc_g_std || vdev->current_norm)
 			set_bit(_IOC_NR(VIDIOC_G_STD), valid_ioctls);
 		SET_VALID_IOCTL(ops, VIDIOC_S_STD, vidioc_s_std);
-		if (is_rx)
-			SET_VALID_IOCTL(ops, VIDIOC_QUERYSTD, vidioc_querystd);
 		if (is_rx) {
+			SET_VALID_IOCTL(ops, VIDIOC_QUERYSTD, vidioc_querystd);
 			SET_VALID_IOCTL(ops, VIDIOC_ENUMINPUT, vidioc_enum_input);
 			SET_VALID_IOCTL(ops, VIDIOC_G_INPUT, vidioc_g_input);
 			SET_VALID_IOCTL(ops, VIDIOC_S_INPUT, vidioc_s_input);
 			SET_VALID_IOCTL(ops, VIDIOC_ENUMAUDIO, vidioc_enumaudio);
 			SET_VALID_IOCTL(ops, VIDIOC_G_AUDIO, vidioc_g_audio);
 			SET_VALID_IOCTL(ops, VIDIOC_S_AUDIO, vidioc_s_audio);
+			SET_VALID_IOCTL(ops, VIDIOC_QUERY_DV_PRESET, vidioc_query_dv_preset);
+			SET_VALID_IOCTL(ops, VIDIOC_QUERY_DV_TIMINGS, vidioc_query_dv_timings);
 		}
 		if (is_tx) {
 			SET_VALID_IOCTL(ops, VIDIOC_ENUMOUTPUT, vidioc_enum_output);
@@ -646,30 +695,6 @@ static void determine_valid_ioctls(struct video_device *vdev)
 			SET_VALID_IOCTL(ops, VIDIOC_G_AUDOUT, vidioc_g_audout);
 			SET_VALID_IOCTL(ops, VIDIOC_S_AUDOUT, vidioc_s_audout);
 		}
-	}
-	/* Note: the control handler can also be passed through the filehandle,
-	   and that can't be tested here. If the bit for these control ioctls
-	   is set, then the ioctl is valid. But if it is 0, then it can still
-	   be valid if the filehandle passed the control handler. */
-	if (vdev->ctrl_handler || ops->vidioc_queryctrl)
-		set_bit(_IOC_NR(VIDIOC_QUERYCTRL), valid_ioctls);
-	if (vdev->ctrl_handler || ops->vidioc_g_ctrl || ops->vidioc_g_ext_ctrls)
-		set_bit(_IOC_NR(VIDIOC_G_CTRL), valid_ioctls);
-	if (vdev->ctrl_handler || ops->vidioc_s_ctrl || ops->vidioc_s_ext_ctrls)
-		set_bit(_IOC_NR(VIDIOC_S_CTRL), valid_ioctls);
-	if (vdev->ctrl_handler || ops->vidioc_g_ext_ctrls)
-		set_bit(_IOC_NR(VIDIOC_G_EXT_CTRLS), valid_ioctls);
-	if (vdev->ctrl_handler || ops->vidioc_s_ext_ctrls)
-		set_bit(_IOC_NR(VIDIOC_S_EXT_CTRLS), valid_ioctls);
-	if (vdev->ctrl_handler || ops->vidioc_try_ext_ctrls)
-		set_bit(_IOC_NR(VIDIOC_TRY_EXT_CTRLS), valid_ioctls);
-	if (vdev->ctrl_handler || ops->vidioc_querymenu)
-		set_bit(_IOC_NR(VIDIOC_QUERYMENU), valid_ioctls);
-	if (is_tx) {
-		SET_VALID_IOCTL(ops, VIDIOC_G_MODULATOR, vidioc_g_modulator);
-		SET_VALID_IOCTL(ops, VIDIOC_S_MODULATOR, vidioc_s_modulator);
-	}
-	if (!is_radio) {
 		if (ops->vidioc_g_crop || ops->vidioc_g_selection)
 			set_bit(_IOC_NR(VIDIOC_G_CROP), valid_ioctls);
 		if (ops->vidioc_s_crop || ops->vidioc_s_selection)
@@ -678,63 +703,30 @@ static void determine_valid_ioctls(struct video_device *vdev)
 		SET_VALID_IOCTL(ops, VIDIOC_S_SELECTION, vidioc_s_selection);
 		if (ops->vidioc_cropcap || ops->vidioc_g_selection)
 			set_bit(_IOC_NR(VIDIOC_CROPCAP), valid_ioctls);
-	}
-	if (is_vid) {
-		SET_VALID_IOCTL(ops, VIDIOC_G_JPEGCOMP, vidioc_g_jpegcomp);
-		SET_VALID_IOCTL(ops, VIDIOC_S_JPEGCOMP, vidioc_s_jpegcomp);
-		SET_VALID_IOCTL(ops, VIDIOC_G_ENC_INDEX, vidioc_g_enc_index);
-		SET_VALID_IOCTL(ops, VIDIOC_ENCODER_CMD, vidioc_encoder_cmd);
-		SET_VALID_IOCTL(ops, VIDIOC_TRY_ENCODER_CMD, vidioc_try_encoder_cmd);
-		SET_VALID_IOCTL(ops, VIDIOC_DECODER_CMD, vidioc_decoder_cmd);
-		SET_VALID_IOCTL(ops, VIDIOC_TRY_DECODER_CMD, vidioc_try_decoder_cmd);
-	}
-	if (!is_radio) {
 		if (ops->vidioc_g_parm || (vdev->vfl_type == VFL_TYPE_GRABBER &&
 					(ops->vidioc_g_std || vdev->current_norm)))
 			set_bit(_IOC_NR(VIDIOC_G_PARM), valid_ioctls);
 		SET_VALID_IOCTL(ops, VIDIOC_S_PARM, vidioc_s_parm);
-	}
-	if (is_rx) {
-		SET_VALID_IOCTL(ops, VIDIOC_G_TUNER, vidioc_g_tuner);
-		SET_VALID_IOCTL(ops, VIDIOC_S_TUNER, vidioc_s_tuner);
-	}
-	SET_VALID_IOCTL(ops, VIDIOC_G_FREQUENCY, vidioc_g_frequency);
-	SET_VALID_IOCTL(ops, VIDIOC_S_FREQUENCY, vidioc_s_frequency);
-	if (is_vbi)
-		SET_VALID_IOCTL(ops, VIDIOC_G_SLICED_VBI_CAP, vidioc_g_sliced_vbi_cap);
-	SET_VALID_IOCTL(ops, VIDIOC_LOG_STATUS, vidioc_log_status);
-#ifdef CONFIG_VIDEO_ADV_DEBUG
-	SET_VALID_IOCTL(ops, VIDIOC_DBG_G_REGISTER, vidioc_g_register);
-	SET_VALID_IOCTL(ops, VIDIOC_DBG_S_REGISTER, vidioc_s_register);
-#endif
-	SET_VALID_IOCTL(ops, VIDIOC_DBG_G_CHIP_IDENT, vidioc_g_chip_ident);
-	if (is_rx)
-		SET_VALID_IOCTL(ops, VIDIOC_S_HW_FREQ_SEEK, vidioc_s_hw_freq_seek);
-	if (is_vid) {
-		SET_VALID_IOCTL(ops, VIDIOC_ENUM_FRAMESIZES, vidioc_enum_framesizes);
-		SET_VALID_IOCTL(ops, VIDIOC_ENUM_FRAMEINTERVALS, vidioc_enum_frameintervals);
-	}
-	if (!is_radio) {
 		SET_VALID_IOCTL(ops, VIDIOC_ENUM_DV_PRESETS, vidioc_enum_dv_presets);
 		SET_VALID_IOCTL(ops, VIDIOC_S_DV_PRESET, vidioc_s_dv_preset);
 		SET_VALID_IOCTL(ops, VIDIOC_G_DV_PRESET, vidioc_g_dv_preset);
-		if (is_rx)
-			SET_VALID_IOCTL(ops, VIDIOC_QUERY_DV_PRESET, vidioc_query_dv_preset);
 		SET_VALID_IOCTL(ops, VIDIOC_S_DV_TIMINGS, vidioc_s_dv_timings);
 		SET_VALID_IOCTL(ops, VIDIOC_G_DV_TIMINGS, vidioc_g_dv_timings);
 		SET_VALID_IOCTL(ops, VIDIOC_ENUM_DV_TIMINGS, vidioc_enum_dv_timings);
-		if (is_rx)
-			SET_VALID_IOCTL(ops, VIDIOC_QUERY_DV_TIMINGS, vidioc_query_dv_timings);
 		SET_VALID_IOCTL(ops, VIDIOC_DV_TIMINGS_CAP, vidioc_dv_timings_cap);
 	}
-	/* yes, really vidioc_subscribe_event */
-	SET_VALID_IOCTL(ops, VIDIOC_DQEVENT, vidioc_subscribe_event);
-	SET_VALID_IOCTL(ops, VIDIOC_SUBSCRIBE_EVENT, vidioc_subscribe_event);
-	SET_VALID_IOCTL(ops, VIDIOC_UNSUBSCRIBE_EVENT, vidioc_unsubscribe_event);
-	SET_VALID_IOCTL(ops, VIDIOC_CREATE_BUFS, vidioc_create_bufs);
-	SET_VALID_IOCTL(ops, VIDIOC_PREPARE_BUF, vidioc_prepare_buf);
-	if (ops->vidioc_enum_freq_bands || ops->vidioc_g_tuner || ops->vidioc_g_modulator)
-		set_bit(_IOC_NR(VIDIOC_ENUM_FREQ_BANDS), valid_ioctls);
+	if (is_tx) {
+		/* transmitter only ioctls */
+		SET_VALID_IOCTL(ops, VIDIOC_G_MODULATOR, vidioc_g_modulator);
+		SET_VALID_IOCTL(ops, VIDIOC_S_MODULATOR, vidioc_s_modulator);
+	}
+	if (is_rx) {
+		/* receiver only ioctls */
+		SET_VALID_IOCTL(ops, VIDIOC_G_TUNER, vidioc_g_tuner);
+		SET_VALID_IOCTL(ops, VIDIOC_S_TUNER, vidioc_s_tuner);
+		SET_VALID_IOCTL(ops, VIDIOC_S_HW_FREQ_SEEK, vidioc_s_hw_freq_seek);
+	}
+
 	bitmap_andnot(vdev->valid_ioctls, valid_ioctls, vdev->valid_ioctls,
 			BASE_VIDIOC_PRIVATE);
 }
-- 
1.7.10.4

