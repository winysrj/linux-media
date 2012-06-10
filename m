Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1363 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755693Ab2FJK0U (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jun 2012 06:26:20 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pawel Osciak <pawel@osciak.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 30/32] v4l2-ioctl.c: shorten the lines of the table.
Date: Sun, 10 Jun 2012 12:25:52 +0200
Message-Id: <84ca6e9f309bcb5f2d603711a755609335b0ea89.1339321562.git.hans.verkuil@cisco.com>
In-Reply-To: <1339323954-1404-1-git-send-email-hverkuil@xs4all.nl>
References: <1339323954-1404-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <ef490f7ebca5b6df91db6b1acfb9928ada3bcd70.1339321562.git.hans.verkuil@cisco.com>
References: <ef490f7ebca5b6df91db6b1acfb9928ada3bcd70.1339321562.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Use some macro magic to reduce the length of the lines in the table. This
makes it more readable.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-ioctl.c |  189 +++++++++++++++++++-------------------
 1 file changed, 96 insertions(+), 93 deletions(-)

diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index dfd5337..c40ce1e 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -1839,106 +1839,109 @@ struct v4l2_ioctl_info {
 	  sizeof(((struct v4l2_struct *)0)->field)) << 16)
 #define INFO_FL_CLEAR_MASK (_IOC_SIZEMASK << 16)
 
-#define IOCTL_INFO_STD(_ioctl, _vidioc, _debug, _flags)			\
-	[_IOC_NR(_ioctl)] = {						\
-		.ioctl = _ioctl,					\
+/* Standard calling sequence: use the offset of the op in v4l2_ioctl_ops */
+#define STD(_ioctl, _vidioc, _debug, _flags)				\
+	[_IOC_NR(VIDIOC_ ## _ioctl)] = {				\
+		.ioctl = VIDIOC_ ## _ioctl,				\
 		.flags = _flags | INFO_FL_STD,				\
-		.name = #_ioctl,					\
-		.offset = offsetof(struct v4l2_ioctl_ops, _vidioc),	\
-		.debug = _debug,					\
+		.name = "VIDIOC_" #_ioctl,				\
+		.offset = offsetof(struct v4l2_ioctl_ops, vidioc_ ## _vidioc),	\
+		.debug = v4l_print_ ## _debug,				\
 	}
 
-#define IOCTL_INFO_FNC(_ioctl, _func, _debug, _flags)			\
-	[_IOC_NR(_ioctl)] = {						\
-		.ioctl = _ioctl,					\
+/* Call a function instead of the op for ioctls where the core needs to do
+   something extra. */
+#define FNC(_ioctl, _func, _debug, _flags)				\
+	[_IOC_NR(VIDIOC_ ## _ioctl)] = {				\
+		.ioctl = VIDIOC_ ## _ioctl,				\
 		.flags = _flags | INFO_FL_FUNC,				\
-		.name = #_ioctl,					\
-		.func = _func,						\
-		.debug = _debug,					\
+		.name = "VIDIOC_" #_ioctl,				\
+		.func = v4l_ ## _func,					\
+		.debug = v4l_print_ ## _debug,				\
 	}
 
 static struct v4l2_ioctl_info v4l2_ioctls[] = {
-	IOCTL_INFO_FNC(VIDIOC_QUERYCAP, v4l_querycap, v4l_print_querycap, 0),
-	IOCTL_INFO_FNC(VIDIOC_ENUM_FMT, v4l_enum_fmt, v4l_print_fmtdesc, INFO_FL_CLEAR(v4l2_fmtdesc, type)),
-	IOCTL_INFO_FNC(VIDIOC_G_FMT, v4l_g_fmt, v4l_print_format, INFO_FL_CLEAR(v4l2_format, type)),
-	IOCTL_INFO_FNC(VIDIOC_S_FMT, v4l_s_fmt, v4l_print_format, INFO_FL_PRIO),
-	IOCTL_INFO_FNC(VIDIOC_REQBUFS, v4l_reqbufs, v4l_print_requestbuffers, INFO_FL_PRIO | INFO_FL_QUEUE),
-	IOCTL_INFO_FNC(VIDIOC_QUERYBUF, v4l_querybuf, v4l_print_buffer, INFO_FL_QUEUE | INFO_FL_CLEAR(v4l2_buffer, length)),
-	IOCTL_INFO_STD(VIDIOC_G_FBUF, vidioc_g_fbuf, v4l_print_framebuffer, 0),
-	IOCTL_INFO_STD(VIDIOC_S_FBUF, vidioc_s_fbuf, v4l_print_framebuffer, INFO_FL_PRIO),
-	IOCTL_INFO_STD(VIDIOC_OVERLAY, vidioc_overlay, v4l_print_u32, INFO_FL_PRIO),
-	IOCTL_INFO_FNC(VIDIOC_QBUF, v4l_qbuf, v4l_print_buffer, INFO_FL_QUEUE),
-	IOCTL_INFO_FNC(VIDIOC_DQBUF, v4l_dqbuf, v4l_print_buffer, INFO_FL_QUEUE),
-	IOCTL_INFO_FNC(VIDIOC_STREAMON, v4l_streamon, v4l_print_buftype, INFO_FL_PRIO | INFO_FL_QUEUE),
-	IOCTL_INFO_FNC(VIDIOC_STREAMOFF, v4l_streamoff, v4l_print_buftype, INFO_FL_PRIO | INFO_FL_QUEUE),
-	IOCTL_INFO_FNC(VIDIOC_G_PARM, v4l_g_parm, v4l_print_streamparm, INFO_FL_CLEAR(v4l2_streamparm, type)),
-	IOCTL_INFO_FNC(VIDIOC_S_PARM, v4l_s_parm, v4l_print_streamparm, INFO_FL_PRIO),
-	IOCTL_INFO_FNC(VIDIOC_G_STD, v4l_g_std, v4l_print_std, 0),
-	IOCTL_INFO_FNC(VIDIOC_S_STD, v4l_s_std, v4l_print_std, INFO_FL_PRIO),
-	IOCTL_INFO_FNC(VIDIOC_ENUMSTD, v4l_enumstd, v4l_print_standard, INFO_FL_CLEAR(v4l2_standard, index)),
-	IOCTL_INFO_FNC(VIDIOC_ENUMINPUT, v4l_enuminput, v4l_print_enuminput, INFO_FL_CLEAR(v4l2_input, index)),
-	IOCTL_INFO_FNC(VIDIOC_G_CTRL, v4l_g_ctrl, v4l_print_control, INFO_FL_CTRL | INFO_FL_CLEAR(v4l2_control, id)),
-	IOCTL_INFO_FNC(VIDIOC_S_CTRL, v4l_s_ctrl, v4l_print_control, INFO_FL_PRIO | INFO_FL_CTRL),
-	IOCTL_INFO_FNC(VIDIOC_G_TUNER, v4l_g_tuner, v4l_print_g_tuner, INFO_FL_CLEAR(v4l2_tuner, index)),
-	IOCTL_INFO_FNC(VIDIOC_S_TUNER, v4l_s_tuner, v4l_print_s_tuner, INFO_FL_PRIO),
-	IOCTL_INFO_STD(VIDIOC_G_AUDIO, vidioc_g_audio, v4l_print_audio, 0),
-	IOCTL_INFO_STD(VIDIOC_S_AUDIO, vidioc_s_audio, v4l_print_s_audio, INFO_FL_PRIO),
-	IOCTL_INFO_FNC(VIDIOC_QUERYCTRL, v4l_queryctrl, v4l_print_queryctrl, INFO_FL_CTRL | INFO_FL_CLEAR(v4l2_queryctrl, id)),
-	IOCTL_INFO_FNC(VIDIOC_QUERYMENU, v4l_querymenu, v4l_print_querymenu, INFO_FL_CTRL | INFO_FL_CLEAR(v4l2_querymenu, index)),
-	IOCTL_INFO_STD(VIDIOC_G_INPUT, vidioc_g_input, v4l_print_u32, 0),
-	IOCTL_INFO_FNC(VIDIOC_S_INPUT, v4l_s_input, v4l_print_u32, INFO_FL_PRIO),
-	IOCTL_INFO_STD(VIDIOC_G_OUTPUT, vidioc_g_output, v4l_print_u32, 0),
-	IOCTL_INFO_FNC(VIDIOC_S_OUTPUT, v4l_s_output, v4l_print_u32, INFO_FL_PRIO),
-	IOCTL_INFO_FNC(VIDIOC_ENUMOUTPUT, v4l_enumoutput, v4l_print_enumoutput, INFO_FL_CLEAR(v4l2_output, index)),
-	IOCTL_INFO_STD(VIDIOC_G_AUDOUT, vidioc_g_audout, v4l_print_audioout, 0),
-	IOCTL_INFO_STD(VIDIOC_S_AUDOUT, vidioc_s_audout, v4l_print_s_audioout, INFO_FL_PRIO),
-	IOCTL_INFO_STD(VIDIOC_G_MODULATOR, vidioc_g_modulator, v4l_print_g_modulator, INFO_FL_CLEAR(v4l2_modulator, index)),
-	IOCTL_INFO_STD(VIDIOC_S_MODULATOR, vidioc_s_modulator, v4l_print_s_modulator, INFO_FL_PRIO),
-	IOCTL_INFO_FNC(VIDIOC_G_FREQUENCY, v4l_g_frequency, v4l_print_frequency, INFO_FL_CLEAR(v4l2_frequency, tuner)),
-	IOCTL_INFO_FNC(VIDIOC_S_FREQUENCY, v4l_s_frequency, v4l_print_frequency, INFO_FL_PRIO),
-	IOCTL_INFO_FNC(VIDIOC_CROPCAP, v4l_cropcap, v4l_print_cropcap, INFO_FL_CLEAR(v4l2_cropcap, type)),
-	IOCTL_INFO_FNC(VIDIOC_G_CROP, v4l_g_crop, v4l_print_crop, INFO_FL_CLEAR(v4l2_crop, type)),
-	IOCTL_INFO_FNC(VIDIOC_S_CROP, v4l_s_crop, v4l_print_crop, INFO_FL_PRIO),
-	IOCTL_INFO_STD(VIDIOC_G_SELECTION, vidioc_g_selection, v4l_print_selection, 0),
-	IOCTL_INFO_STD(VIDIOC_S_SELECTION, vidioc_s_selection, v4l_print_selection, INFO_FL_PRIO),
-	IOCTL_INFO_STD(VIDIOC_G_JPEGCOMP, vidioc_g_jpegcomp, v4l_print_jpegcompression, 0),
-	IOCTL_INFO_STD(VIDIOC_S_JPEGCOMP, vidioc_s_jpegcomp, v4l_print_jpegcompression, INFO_FL_PRIO),
-	IOCTL_INFO_FNC(VIDIOC_QUERYSTD, v4l_querystd, v4l_print_std, 0),
-	IOCTL_INFO_FNC(VIDIOC_TRY_FMT, v4l_try_fmt, v4l_print_format, 0),
-	IOCTL_INFO_STD(VIDIOC_ENUMAUDIO, vidioc_enumaudio, v4l_print_audio, INFO_FL_CLEAR(v4l2_audio, index)),
-	IOCTL_INFO_STD(VIDIOC_ENUMAUDOUT, vidioc_enumaudout, v4l_print_audioout, INFO_FL_CLEAR(v4l2_audioout, index)),
-	IOCTL_INFO_FNC(VIDIOC_G_PRIORITY, v4l_g_priority, v4l_print_u32, 0),
-	IOCTL_INFO_FNC(VIDIOC_S_PRIORITY, v4l_s_priority, v4l_print_u32, INFO_FL_PRIO),
-	IOCTL_INFO_FNC(VIDIOC_G_SLICED_VBI_CAP, v4l_g_sliced_vbi_cap, v4l_print_sliced_vbi_cap, INFO_FL_CLEAR(v4l2_sliced_vbi_cap, type)),
-	IOCTL_INFO_FNC(VIDIOC_LOG_STATUS, v4l_log_status, v4l_print_newline, 0),
-	IOCTL_INFO_FNC(VIDIOC_G_EXT_CTRLS, v4l_g_ext_ctrls, v4l_print_ext_controls, INFO_FL_CTRL),
-	IOCTL_INFO_FNC(VIDIOC_S_EXT_CTRLS, v4l_s_ext_ctrls, v4l_print_ext_controls, INFO_FL_PRIO | INFO_FL_CTRL),
-	IOCTL_INFO_FNC(VIDIOC_TRY_EXT_CTRLS, v4l_try_ext_ctrls, v4l_print_ext_controls, 0),
-	IOCTL_INFO_STD(VIDIOC_ENUM_FRAMESIZES, vidioc_enum_framesizes, v4l_print_frmsizeenum, INFO_FL_CLEAR(v4l2_frmsizeenum, pixel_format)),
-	IOCTL_INFO_STD(VIDIOC_ENUM_FRAMEINTERVALS, vidioc_enum_frameintervals, v4l_print_frmivalenum, INFO_FL_CLEAR(v4l2_frmivalenum, height)),
-	IOCTL_INFO_STD(VIDIOC_G_ENC_INDEX, vidioc_g_enc_index, v4l_print_enc_idx, 0),
-	IOCTL_INFO_STD(VIDIOC_ENCODER_CMD, vidioc_encoder_cmd, v4l_print_encoder_cmd, INFO_FL_PRIO | INFO_FL_CLEAR(v4l2_encoder_cmd, flags)),
-	IOCTL_INFO_STD(VIDIOC_TRY_ENCODER_CMD, vidioc_try_encoder_cmd, v4l_print_encoder_cmd, INFO_FL_CLEAR(v4l2_encoder_cmd, flags)),
-	IOCTL_INFO_STD(VIDIOC_DECODER_CMD, vidioc_decoder_cmd, v4l_print_decoder_cmd, INFO_FL_PRIO),
-	IOCTL_INFO_STD(VIDIOC_TRY_DECODER_CMD, vidioc_try_decoder_cmd, v4l_print_decoder_cmd, 0),
-	IOCTL_INFO_FNC(VIDIOC_DBG_S_REGISTER, v4l_dbg_s_register, v4l_print_dbg_register, 0),
-	IOCTL_INFO_FNC(VIDIOC_DBG_G_REGISTER, v4l_dbg_g_register, v4l_print_dbg_register, 0),
-	IOCTL_INFO_FNC(VIDIOC_DBG_G_CHIP_IDENT, v4l_dbg_g_chip_ident, v4l_print_dbg_chip_ident, 0),
-	IOCTL_INFO_FNC(VIDIOC_S_HW_FREQ_SEEK, v4l_s_hw_freq_seek, v4l_print_hw_freq_seek, INFO_FL_PRIO),
-	IOCTL_INFO_STD(VIDIOC_ENUM_DV_PRESETS, vidioc_enum_dv_presets, v4l_print_dv_enum_presets, 0),
-	IOCTL_INFO_STD(VIDIOC_S_DV_PRESET, vidioc_s_dv_preset, v4l_print_dv_preset, INFO_FL_PRIO),
-	IOCTL_INFO_STD(VIDIOC_G_DV_PRESET, vidioc_g_dv_preset, v4l_print_dv_preset, 0),
-	IOCTL_INFO_STD(VIDIOC_QUERY_DV_PRESET, vidioc_query_dv_preset, v4l_print_dv_preset, 0),
-	IOCTL_INFO_STD(VIDIOC_S_DV_TIMINGS, vidioc_s_dv_timings, v4l_print_dv_timings, INFO_FL_PRIO),
-	IOCTL_INFO_STD(VIDIOC_G_DV_TIMINGS, vidioc_g_dv_timings, v4l_print_dv_timings, 0),
-	IOCTL_INFO_FNC(VIDIOC_DQEVENT, v4l_dqevent, v4l_print_event, 0),
-	IOCTL_INFO_FNC(VIDIOC_SUBSCRIBE_EVENT, v4l_subscribe_event, v4l_print_event_subscription, 0),
-	IOCTL_INFO_FNC(VIDIOC_UNSUBSCRIBE_EVENT, v4l_unsubscribe_event, v4l_print_event_subscription, 0),
-	IOCTL_INFO_FNC(VIDIOC_CREATE_BUFS, v4l_create_bufs, v4l_print_create_buffers, INFO_FL_PRIO | INFO_FL_QUEUE),
-	IOCTL_INFO_FNC(VIDIOC_PREPARE_BUF, v4l_prepare_buf, v4l_print_buffer, INFO_FL_QUEUE),
-	IOCTL_INFO_STD(VIDIOC_ENUM_DV_TIMINGS, vidioc_enum_dv_timings, v4l_print_enum_dv_timings, 0),
-	IOCTL_INFO_STD(VIDIOC_QUERY_DV_TIMINGS, vidioc_query_dv_timings, v4l_print_dv_timings, 0),
-	IOCTL_INFO_STD(VIDIOC_DV_TIMINGS_CAP, vidioc_dv_timings_cap, v4l_print_dv_timings_cap, 0),
+	FNC(QUERYCAP, querycap, querycap, 0),
+	FNC(ENUM_FMT, enum_fmt, fmtdesc, INFO_FL_CLEAR(v4l2_fmtdesc, type)),
+	FNC(G_FMT, g_fmt, format, INFO_FL_CLEAR(v4l2_format, type)),
+	FNC(S_FMT, s_fmt, format, INFO_FL_PRIO),
+	FNC(REQBUFS, reqbufs, requestbuffers, INFO_FL_PRIO | INFO_FL_QUEUE),
+	FNC(QUERYBUF, querybuf, buffer, INFO_FL_QUEUE | INFO_FL_CLEAR(v4l2_buffer, length)),
+	STD(G_FBUF, g_fbuf, framebuffer, 0),
+	STD(S_FBUF, s_fbuf, framebuffer, INFO_FL_PRIO),
+	STD(OVERLAY, overlay, u32, INFO_FL_PRIO),
+	FNC(QBUF, qbuf, buffer, INFO_FL_QUEUE),
+	FNC(DQBUF, dqbuf, buffer, INFO_FL_QUEUE),
+	FNC(STREAMON, streamon, buftype, INFO_FL_PRIO | INFO_FL_QUEUE),
+	FNC(STREAMOFF, streamoff, buftype, INFO_FL_PRIO | INFO_FL_QUEUE),
+	FNC(G_PARM, g_parm, streamparm, INFO_FL_CLEAR(v4l2_streamparm, type)),
+	FNC(S_PARM, s_parm, streamparm, INFO_FL_PRIO),
+	FNC(G_STD, g_std, std, 0),
+	FNC(S_STD, s_std, std, INFO_FL_PRIO),
+	FNC(ENUMSTD, enumstd, standard, INFO_FL_CLEAR(v4l2_standard, index)),
+	FNC(ENUMINPUT, enuminput, enuminput, INFO_FL_CLEAR(v4l2_input, index)),
+	FNC(G_CTRL, g_ctrl, control, INFO_FL_CTRL | INFO_FL_CLEAR(v4l2_control, id)),
+	FNC(S_CTRL, s_ctrl, control, INFO_FL_PRIO | INFO_FL_CTRL),
+	FNC(G_TUNER, g_tuner, g_tuner, INFO_FL_CLEAR(v4l2_tuner, index)),
+	FNC(S_TUNER, s_tuner, s_tuner, INFO_FL_PRIO),
+	STD(G_AUDIO, g_audio, audio, 0),
+	STD(S_AUDIO, s_audio, s_audio, INFO_FL_PRIO),
+	FNC(QUERYCTRL, queryctrl, queryctrl, INFO_FL_CTRL | INFO_FL_CLEAR(v4l2_queryctrl, id)),
+	FNC(QUERYMENU, querymenu, querymenu, INFO_FL_CTRL | INFO_FL_CLEAR(v4l2_querymenu, index)),
+	STD(G_INPUT, g_input, u32, 0),
+	FNC(S_INPUT, s_input, u32, INFO_FL_PRIO),
+	STD(G_OUTPUT, g_output, u32, 0),
+	FNC(S_OUTPUT, s_output, u32, INFO_FL_PRIO),
+	FNC(ENUMOUTPUT, enumoutput, enumoutput, INFO_FL_CLEAR(v4l2_output, index)),
+	STD(G_AUDOUT, g_audout, audioout, 0),
+	STD(S_AUDOUT, s_audout, s_audioout, INFO_FL_PRIO),
+	STD(G_MODULATOR, g_modulator, g_modulator, INFO_FL_CLEAR(v4l2_modulator, index)),
+	STD(S_MODULATOR, s_modulator, s_modulator, INFO_FL_PRIO),
+	FNC(G_FREQUENCY, g_frequency, frequency, INFO_FL_CLEAR(v4l2_frequency, tuner)),
+	FNC(S_FREQUENCY, s_frequency, frequency, INFO_FL_PRIO),
+	FNC(CROPCAP, cropcap, cropcap, INFO_FL_CLEAR(v4l2_cropcap, type)),
+	FNC(G_CROP, g_crop, crop, INFO_FL_CLEAR(v4l2_crop, type)),
+	FNC(S_CROP, s_crop, crop, INFO_FL_PRIO),
+	STD(G_SELECTION, g_selection, selection, 0),
+	STD(S_SELECTION, s_selection, selection, INFO_FL_PRIO),
+	STD(G_JPEGCOMP, g_jpegcomp, jpegcompression, 0),
+	STD(S_JPEGCOMP, s_jpegcomp, jpegcompression, INFO_FL_PRIO),
+	FNC(QUERYSTD, querystd, std, 0),
+	FNC(TRY_FMT, try_fmt, format, 0),
+	STD(ENUMAUDIO, enumaudio, audio, INFO_FL_CLEAR(v4l2_audio, index)),
+	STD(ENUMAUDOUT, enumaudout, audioout, INFO_FL_CLEAR(v4l2_audioout, index)),
+	FNC(G_PRIORITY, g_priority, u32, 0),
+	FNC(S_PRIORITY, s_priority, u32, INFO_FL_PRIO),
+	FNC(G_SLICED_VBI_CAP, g_sliced_vbi_cap, sliced_vbi_cap, INFO_FL_CLEAR(v4l2_sliced_vbi_cap, type)),
+	FNC(LOG_STATUS, log_status, newline, 0),
+	FNC(G_EXT_CTRLS, g_ext_ctrls, ext_controls, INFO_FL_CTRL),
+	FNC(S_EXT_CTRLS, s_ext_ctrls, ext_controls, INFO_FL_PRIO | INFO_FL_CTRL),
+	FNC(TRY_EXT_CTRLS, try_ext_ctrls, ext_controls, 0),
+	STD(ENUM_FRAMESIZES, enum_framesizes, frmsizeenum, INFO_FL_CLEAR(v4l2_frmsizeenum, pixel_format)),
+	STD(ENUM_FRAMEINTERVALS, enum_frameintervals, frmivalenum, INFO_FL_CLEAR(v4l2_frmivalenum, height)),
+	STD(G_ENC_INDEX, g_enc_index, enc_idx, 0),
+	STD(ENCODER_CMD, encoder_cmd, encoder_cmd, INFO_FL_PRIO | INFO_FL_CLEAR(v4l2_encoder_cmd, flags)),
+	STD(TRY_ENCODER_CMD, try_encoder_cmd, encoder_cmd, INFO_FL_CLEAR(v4l2_encoder_cmd, flags)),
+	STD(DECODER_CMD, decoder_cmd, decoder_cmd, INFO_FL_PRIO),
+	STD(TRY_DECODER_CMD, try_decoder_cmd, decoder_cmd, 0),
+	FNC(DBG_S_REGISTER, dbg_s_register, dbg_register, 0),
+	FNC(DBG_G_REGISTER, dbg_g_register, dbg_register, 0),
+	FNC(DBG_G_CHIP_IDENT, dbg_g_chip_ident, dbg_chip_ident, 0),
+	FNC(S_HW_FREQ_SEEK, s_hw_freq_seek, hw_freq_seek, INFO_FL_PRIO),
+	STD(ENUM_DV_PRESETS, enum_dv_presets, dv_enum_presets, 0),
+	STD(S_DV_PRESET, s_dv_preset, dv_preset, INFO_FL_PRIO),
+	STD(G_DV_PRESET, g_dv_preset, dv_preset, 0),
+	STD(QUERY_DV_PRESET, query_dv_preset, dv_preset, 0),
+	STD(S_DV_TIMINGS, s_dv_timings, dv_timings, INFO_FL_PRIO),
+	STD(G_DV_TIMINGS, g_dv_timings, dv_timings, 0),
+	FNC(DQEVENT, dqevent, event, 0),
+	FNC(SUBSCRIBE_EVENT, subscribe_event, event_subscription, 0),
+	FNC(UNSUBSCRIBE_EVENT, unsubscribe_event, event_subscription, 0),
+	FNC(CREATE_BUFS, create_bufs, create_buffers, INFO_FL_PRIO | INFO_FL_QUEUE),
+	FNC(PREPARE_BUF, prepare_buf, buffer, INFO_FL_QUEUE),
+	STD(ENUM_DV_TIMINGS, enum_dv_timings, enum_dv_timings, 0),
+	STD(QUERY_DV_TIMINGS, query_dv_timings, dv_timings, 0),
+	STD(DV_TIMINGS_CAP, dv_timings_cap, dv_timings_cap, 0),
 };
 #define V4L2_IOCTLS ARRAY_SIZE(v4l2_ioctls)
 
-- 
1.7.10

