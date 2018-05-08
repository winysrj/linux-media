Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:46240 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754460AbeEHRfJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 May 2018 13:35:09 -0400
Received: by mail-pf0-f195.google.com with SMTP id p12so24273917pff.13
        for <linux-media@vger.kernel.org>; Tue, 08 May 2018 10:35:09 -0700 (PDT)
From: Sami Tolvanen <samitolvanen@google.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Kees Cook <keescook@chromium.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sami Tolvanen <samitolvanen@google.com>
Subject: [PATCH v3] media: v4l2-ioctl: fix function types for IOCTL_INFO_STD
Date: Tue,  8 May 2018 10:35:01 -0700
Message-Id: <20180508173501.22578-1-samitolvanen@google.com>
In-Reply-To: <2a04c948-82ba-c69f-891e-303db85b66a4@xs4all.nl>
References: <2a04c948-82ba-c69f-891e-303db85b66a4@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This change fixes indirect call mismatches with Control-Flow Integrity
checking, which are caused by calling standard ioctls using a function
pointer that doesn't match the type of the actual function.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 245 ++++++++++++++-------------
 1 file changed, 130 insertions(+), 115 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index de5d96dbe69e0..a40dbec271f1d 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -2489,11 +2489,8 @@ struct v4l2_ioctl_info {
 	unsigned int ioctl;
 	u32 flags;
 	const char * const name;
-	union {
-		u32 offset;
-		int (*func)(const struct v4l2_ioctl_ops *ops,
-				struct file *file, void *fh, void *p);
-	} u;
+	int (*func)(const struct v4l2_ioctl_ops *ops, struct file *file,
+		    void *fh, void *p);
 	void (*debug)(const void *arg, bool write_only);
 };
 
@@ -2501,121 +2498,145 @@ struct v4l2_ioctl_info {
 #define INFO_FL_PRIO		(1 << 0)
 /* This control can be valid if the filehandle passes a control handler. */
 #define INFO_FL_CTRL		(1 << 1)
-/* This is a standard ioctl, no need for special code */
-#define INFO_FL_STD		(1 << 2)
-/* This is ioctl has its own function */
-#define INFO_FL_FUNC		(1 << 3)
 /* Queuing ioctl */
-#define INFO_FL_QUEUE		(1 << 4)
+#define INFO_FL_QUEUE		(1 << 2)
 /* Always copy back result, even on error */
-#define INFO_FL_ALWAYS_COPY	(1 << 5)
+#define INFO_FL_ALWAYS_COPY	(1 << 3)
 /* Zero struct from after the field to the end */
 #define INFO_FL_CLEAR(v4l2_struct, field)			\
 	((offsetof(struct v4l2_struct, field) +			\
 	  sizeof(((struct v4l2_struct *)0)->field)) << 16)
 #define INFO_FL_CLEAR_MASK	(_IOC_SIZEMASK << 16)
 
-#define IOCTL_INFO_STD(_ioctl, _vidioc, _debug, _flags)			\
-	[_IOC_NR(_ioctl)] = {						\
-		.ioctl = _ioctl,					\
-		.flags = _flags | INFO_FL_STD,				\
-		.name = #_ioctl,					\
-		.u.offset = offsetof(struct v4l2_ioctl_ops, _vidioc),	\
-		.debug = _debug,					\
+#define DEFINE_V4L_STUB_FUNC(_vidioc)				\
+	static int v4l_stub_ ## _vidioc(			\
+			const struct v4l2_ioctl_ops *ops,	\
+			struct file *file, void *fh, void *p)	\
+	{							\
+		return ops->vidioc_ ## _vidioc(file, fh, p);	\
 	}
 
-#define IOCTL_INFO_FNC(_ioctl, _func, _debug, _flags)			\
-	[_IOC_NR(_ioctl)] = {						\
-		.ioctl = _ioctl,					\
-		.flags = _flags | INFO_FL_FUNC,				\
-		.name = #_ioctl,					\
-		.u.func = _func,					\
-		.debug = _debug,					\
+#define IOCTL_INFO(_ioctl, _func, _debug, _flags)		\
+	[_IOC_NR(_ioctl)] = {					\
+		.ioctl = _ioctl,				\
+		.flags = _flags,				\
+		.name = #_ioctl,				\
+		.func = _func,					\
+		.debug = _debug,				\
 	}
 
+DEFINE_V4L_STUB_FUNC(g_fbuf)
+DEFINE_V4L_STUB_FUNC(s_fbuf)
+DEFINE_V4L_STUB_FUNC(expbuf)
+DEFINE_V4L_STUB_FUNC(g_std)
+DEFINE_V4L_STUB_FUNC(g_audio)
+DEFINE_V4L_STUB_FUNC(s_audio)
+DEFINE_V4L_STUB_FUNC(g_input)
+DEFINE_V4L_STUB_FUNC(g_edid)
+DEFINE_V4L_STUB_FUNC(s_edid)
+DEFINE_V4L_STUB_FUNC(g_output)
+DEFINE_V4L_STUB_FUNC(g_audout)
+DEFINE_V4L_STUB_FUNC(s_audout)
+DEFINE_V4L_STUB_FUNC(g_jpegcomp)
+DEFINE_V4L_STUB_FUNC(s_jpegcomp)
+DEFINE_V4L_STUB_FUNC(enumaudio)
+DEFINE_V4L_STUB_FUNC(enumaudout)
+DEFINE_V4L_STUB_FUNC(enum_framesizes)
+DEFINE_V4L_STUB_FUNC(enum_frameintervals)
+DEFINE_V4L_STUB_FUNC(g_enc_index)
+DEFINE_V4L_STUB_FUNC(encoder_cmd)
+DEFINE_V4L_STUB_FUNC(try_encoder_cmd)
+DEFINE_V4L_STUB_FUNC(decoder_cmd)
+DEFINE_V4L_STUB_FUNC(try_decoder_cmd)
+DEFINE_V4L_STUB_FUNC(s_dv_timings)
+DEFINE_V4L_STUB_FUNC(g_dv_timings)
+DEFINE_V4L_STUB_FUNC(enum_dv_timings)
+DEFINE_V4L_STUB_FUNC(query_dv_timings)
+DEFINE_V4L_STUB_FUNC(dv_timings_cap)
+
 static struct v4l2_ioctl_info v4l2_ioctls[] = {
-	IOCTL_INFO_FNC(VIDIOC_QUERYCAP, v4l_querycap, v4l_print_querycap, 0),
-	IOCTL_INFO_FNC(VIDIOC_ENUM_FMT, v4l_enum_fmt, v4l_print_fmtdesc, INFO_FL_CLEAR(v4l2_fmtdesc, type)),
-	IOCTL_INFO_FNC(VIDIOC_G_FMT, v4l_g_fmt, v4l_print_format, 0),
-	IOCTL_INFO_FNC(VIDIOC_S_FMT, v4l_s_fmt, v4l_print_format, INFO_FL_PRIO),
-	IOCTL_INFO_FNC(VIDIOC_REQBUFS, v4l_reqbufs, v4l_print_requestbuffers, INFO_FL_PRIO | INFO_FL_QUEUE),
-	IOCTL_INFO_FNC(VIDIOC_QUERYBUF, v4l_querybuf, v4l_print_buffer, INFO_FL_QUEUE | INFO_FL_CLEAR(v4l2_buffer, length)),
-	IOCTL_INFO_STD(VIDIOC_G_FBUF, vidioc_g_fbuf, v4l_print_framebuffer, 0),
-	IOCTL_INFO_STD(VIDIOC_S_FBUF, vidioc_s_fbuf, v4l_print_framebuffer, INFO_FL_PRIO),
-	IOCTL_INFO_FNC(VIDIOC_OVERLAY, v4l_overlay, v4l_print_u32, INFO_FL_PRIO),
-	IOCTL_INFO_FNC(VIDIOC_QBUF, v4l_qbuf, v4l_print_buffer, INFO_FL_QUEUE),
-	IOCTL_INFO_STD(VIDIOC_EXPBUF, vidioc_expbuf, v4l_print_exportbuffer, INFO_FL_QUEUE | INFO_FL_CLEAR(v4l2_exportbuffer, flags)),
-	IOCTL_INFO_FNC(VIDIOC_DQBUF, v4l_dqbuf, v4l_print_buffer, INFO_FL_QUEUE),
-	IOCTL_INFO_FNC(VIDIOC_STREAMON, v4l_streamon, v4l_print_buftype, INFO_FL_PRIO | INFO_FL_QUEUE),
-	IOCTL_INFO_FNC(VIDIOC_STREAMOFF, v4l_streamoff, v4l_print_buftype, INFO_FL_PRIO | INFO_FL_QUEUE),
-	IOCTL_INFO_FNC(VIDIOC_G_PARM, v4l_g_parm, v4l_print_streamparm, INFO_FL_CLEAR(v4l2_streamparm, type)),
-	IOCTL_INFO_FNC(VIDIOC_S_PARM, v4l_s_parm, v4l_print_streamparm, INFO_FL_PRIO),
-	IOCTL_INFO_STD(VIDIOC_G_STD, vidioc_g_std, v4l_print_std, 0),
-	IOCTL_INFO_FNC(VIDIOC_S_STD, v4l_s_std, v4l_print_std, INFO_FL_PRIO),
-	IOCTL_INFO_FNC(VIDIOC_ENUMSTD, v4l_enumstd, v4l_print_standard, INFO_FL_CLEAR(v4l2_standard, index)),
-	IOCTL_INFO_FNC(VIDIOC_ENUMINPUT, v4l_enuminput, v4l_print_enuminput, INFO_FL_CLEAR(v4l2_input, index)),
-	IOCTL_INFO_FNC(VIDIOC_G_CTRL, v4l_g_ctrl, v4l_print_control, INFO_FL_CTRL | INFO_FL_CLEAR(v4l2_control, id)),
-	IOCTL_INFO_FNC(VIDIOC_S_CTRL, v4l_s_ctrl, v4l_print_control, INFO_FL_PRIO | INFO_FL_CTRL),
-	IOCTL_INFO_FNC(VIDIOC_G_TUNER, v4l_g_tuner, v4l_print_tuner, INFO_FL_CLEAR(v4l2_tuner, index)),
-	IOCTL_INFO_FNC(VIDIOC_S_TUNER, v4l_s_tuner, v4l_print_tuner, INFO_FL_PRIO),
-	IOCTL_INFO_STD(VIDIOC_G_AUDIO, vidioc_g_audio, v4l_print_audio, 0),
-	IOCTL_INFO_STD(VIDIOC_S_AUDIO, vidioc_s_audio, v4l_print_audio, INFO_FL_PRIO),
-	IOCTL_INFO_FNC(VIDIOC_QUERYCTRL, v4l_queryctrl, v4l_print_queryctrl, INFO_FL_CTRL | INFO_FL_CLEAR(v4l2_queryctrl, id)),
-	IOCTL_INFO_FNC(VIDIOC_QUERYMENU, v4l_querymenu, v4l_print_querymenu, INFO_FL_CTRL | INFO_FL_CLEAR(v4l2_querymenu, index)),
-	IOCTL_INFO_STD(VIDIOC_G_INPUT, vidioc_g_input, v4l_print_u32, 0),
-	IOCTL_INFO_FNC(VIDIOC_S_INPUT, v4l_s_input, v4l_print_u32, INFO_FL_PRIO),
-	IOCTL_INFO_STD(VIDIOC_G_EDID, vidioc_g_edid, v4l_print_edid, INFO_FL_ALWAYS_COPY),
-	IOCTL_INFO_STD(VIDIOC_S_EDID, vidioc_s_edid, v4l_print_edid, INFO_FL_PRIO | INFO_FL_ALWAYS_COPY),
-	IOCTL_INFO_STD(VIDIOC_G_OUTPUT, vidioc_g_output, v4l_print_u32, 0),
-	IOCTL_INFO_FNC(VIDIOC_S_OUTPUT, v4l_s_output, v4l_print_u32, INFO_FL_PRIO),
-	IOCTL_INFO_FNC(VIDIOC_ENUMOUTPUT, v4l_enumoutput, v4l_print_enumoutput, INFO_FL_CLEAR(v4l2_output, index)),
-	IOCTL_INFO_STD(VIDIOC_G_AUDOUT, vidioc_g_audout, v4l_print_audioout, 0),
-	IOCTL_INFO_STD(VIDIOC_S_AUDOUT, vidioc_s_audout, v4l_print_audioout, INFO_FL_PRIO),
-	IOCTL_INFO_FNC(VIDIOC_G_MODULATOR, v4l_g_modulator, v4l_print_modulator, INFO_FL_CLEAR(v4l2_modulator, index)),
-	IOCTL_INFO_FNC(VIDIOC_S_MODULATOR, v4l_s_modulator, v4l_print_modulator, INFO_FL_PRIO),
-	IOCTL_INFO_FNC(VIDIOC_G_FREQUENCY, v4l_g_frequency, v4l_print_frequency, INFO_FL_CLEAR(v4l2_frequency, tuner)),
-	IOCTL_INFO_FNC(VIDIOC_S_FREQUENCY, v4l_s_frequency, v4l_print_frequency, INFO_FL_PRIO),
-	IOCTL_INFO_FNC(VIDIOC_CROPCAP, v4l_cropcap, v4l_print_cropcap, INFO_FL_CLEAR(v4l2_cropcap, type)),
-	IOCTL_INFO_FNC(VIDIOC_G_CROP, v4l_g_crop, v4l_print_crop, INFO_FL_CLEAR(v4l2_crop, type)),
-	IOCTL_INFO_FNC(VIDIOC_S_CROP, v4l_s_crop, v4l_print_crop, INFO_FL_PRIO),
-	IOCTL_INFO_FNC(VIDIOC_G_SELECTION, v4l_g_selection, v4l_print_selection, INFO_FL_CLEAR(v4l2_selection, r)),
-	IOCTL_INFO_FNC(VIDIOC_S_SELECTION, v4l_s_selection, v4l_print_selection, INFO_FL_PRIO | INFO_FL_CLEAR(v4l2_selection, r)),
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
-	IOCTL_INFO_FNC(VIDIOC_TRY_EXT_CTRLS, v4l_try_ext_ctrls, v4l_print_ext_controls, INFO_FL_CTRL),
-	IOCTL_INFO_STD(VIDIOC_ENUM_FRAMESIZES, vidioc_enum_framesizes, v4l_print_frmsizeenum, INFO_FL_CLEAR(v4l2_frmsizeenum, pixel_format)),
-	IOCTL_INFO_STD(VIDIOC_ENUM_FRAMEINTERVALS, vidioc_enum_frameintervals, v4l_print_frmivalenum, INFO_FL_CLEAR(v4l2_frmivalenum, height)),
-	IOCTL_INFO_STD(VIDIOC_G_ENC_INDEX, vidioc_g_enc_index, v4l_print_enc_idx, 0),
-	IOCTL_INFO_STD(VIDIOC_ENCODER_CMD, vidioc_encoder_cmd, v4l_print_encoder_cmd, INFO_FL_PRIO | INFO_FL_CLEAR(v4l2_encoder_cmd, flags)),
-	IOCTL_INFO_STD(VIDIOC_TRY_ENCODER_CMD, vidioc_try_encoder_cmd, v4l_print_encoder_cmd, INFO_FL_CLEAR(v4l2_encoder_cmd, flags)),
-	IOCTL_INFO_STD(VIDIOC_DECODER_CMD, vidioc_decoder_cmd, v4l_print_decoder_cmd, INFO_FL_PRIO),
-	IOCTL_INFO_STD(VIDIOC_TRY_DECODER_CMD, vidioc_try_decoder_cmd, v4l_print_decoder_cmd, 0),
-	IOCTL_INFO_FNC(VIDIOC_DBG_S_REGISTER, v4l_dbg_s_register, v4l_print_dbg_register, 0),
-	IOCTL_INFO_FNC(VIDIOC_DBG_G_REGISTER, v4l_dbg_g_register, v4l_print_dbg_register, 0),
-	IOCTL_INFO_FNC(VIDIOC_S_HW_FREQ_SEEK, v4l_s_hw_freq_seek, v4l_print_hw_freq_seek, INFO_FL_PRIO),
-	IOCTL_INFO_STD(VIDIOC_S_DV_TIMINGS, vidioc_s_dv_timings, v4l_print_dv_timings, INFO_FL_PRIO | INFO_FL_CLEAR(v4l2_dv_timings, bt.flags)),
-	IOCTL_INFO_STD(VIDIOC_G_DV_TIMINGS, vidioc_g_dv_timings, v4l_print_dv_timings, 0),
-	IOCTL_INFO_FNC(VIDIOC_DQEVENT, v4l_dqevent, v4l_print_event, 0),
-	IOCTL_INFO_FNC(VIDIOC_SUBSCRIBE_EVENT, v4l_subscribe_event, v4l_print_event_subscription, 0),
-	IOCTL_INFO_FNC(VIDIOC_UNSUBSCRIBE_EVENT, v4l_unsubscribe_event, v4l_print_event_subscription, 0),
-	IOCTL_INFO_FNC(VIDIOC_CREATE_BUFS, v4l_create_bufs, v4l_print_create_buffers, INFO_FL_PRIO | INFO_FL_QUEUE),
-	IOCTL_INFO_FNC(VIDIOC_PREPARE_BUF, v4l_prepare_buf, v4l_print_buffer, INFO_FL_QUEUE),
-	IOCTL_INFO_STD(VIDIOC_ENUM_DV_TIMINGS, vidioc_enum_dv_timings, v4l_print_enum_dv_timings, INFO_FL_CLEAR(v4l2_enum_dv_timings, pad)),
-	IOCTL_INFO_STD(VIDIOC_QUERY_DV_TIMINGS, vidioc_query_dv_timings, v4l_print_dv_timings, INFO_FL_ALWAYS_COPY),
-	IOCTL_INFO_STD(VIDIOC_DV_TIMINGS_CAP, vidioc_dv_timings_cap, v4l_print_dv_timings_cap, INFO_FL_CLEAR(v4l2_dv_timings_cap, pad)),
-	IOCTL_INFO_FNC(VIDIOC_ENUM_FREQ_BANDS, v4l_enum_freq_bands, v4l_print_freq_band, 0),
-	IOCTL_INFO_FNC(VIDIOC_DBG_G_CHIP_INFO, v4l_dbg_g_chip_info, v4l_print_dbg_chip_info, INFO_FL_CLEAR(v4l2_dbg_chip_info, match)),
-	IOCTL_INFO_FNC(VIDIOC_QUERY_EXT_CTRL, v4l_query_ext_ctrl, v4l_print_query_ext_ctrl, INFO_FL_CTRL | INFO_FL_CLEAR(v4l2_query_ext_ctrl, id)),
+	IOCTL_INFO(VIDIOC_QUERYCAP, v4l_querycap, v4l_print_querycap, 0),
+	IOCTL_INFO(VIDIOC_ENUM_FMT, v4l_enum_fmt, v4l_print_fmtdesc, INFO_FL_CLEAR(v4l2_fmtdesc, type)),
+	IOCTL_INFO(VIDIOC_G_FMT, v4l_g_fmt, v4l_print_format, 0),
+	IOCTL_INFO(VIDIOC_S_FMT, v4l_s_fmt, v4l_print_format, INFO_FL_PRIO),
+	IOCTL_INFO(VIDIOC_REQBUFS, v4l_reqbufs, v4l_print_requestbuffers, INFO_FL_PRIO | INFO_FL_QUEUE),
+	IOCTL_INFO(VIDIOC_QUERYBUF, v4l_querybuf, v4l_print_buffer, INFO_FL_QUEUE | INFO_FL_CLEAR(v4l2_buffer, length)),
+	IOCTL_INFO(VIDIOC_G_FBUF, v4l_stub_g_fbuf, v4l_print_framebuffer, 0),
+	IOCTL_INFO(VIDIOC_S_FBUF, v4l_stub_s_fbuf, v4l_print_framebuffer, INFO_FL_PRIO),
+	IOCTL_INFO(VIDIOC_OVERLAY, v4l_overlay, v4l_print_u32, INFO_FL_PRIO),
+	IOCTL_INFO(VIDIOC_QBUF, v4l_qbuf, v4l_print_buffer, INFO_FL_QUEUE),
+	IOCTL_INFO(VIDIOC_EXPBUF, v4l_stub_expbuf, v4l_print_exportbuffer, INFO_FL_QUEUE | INFO_FL_CLEAR(v4l2_exportbuffer, flags)),
+	IOCTL_INFO(VIDIOC_DQBUF, v4l_dqbuf, v4l_print_buffer, INFO_FL_QUEUE),
+	IOCTL_INFO(VIDIOC_STREAMON, v4l_streamon, v4l_print_buftype, INFO_FL_PRIO | INFO_FL_QUEUE),
+	IOCTL_INFO(VIDIOC_STREAMOFF, v4l_streamoff, v4l_print_buftype, INFO_FL_PRIO | INFO_FL_QUEUE),
+	IOCTL_INFO(VIDIOC_G_PARM, v4l_g_parm, v4l_print_streamparm, INFO_FL_CLEAR(v4l2_streamparm, type)),
+	IOCTL_INFO(VIDIOC_S_PARM, v4l_s_parm, v4l_print_streamparm, INFO_FL_PRIO),
+	IOCTL_INFO(VIDIOC_G_STD, v4l_stub_g_std, v4l_print_std, 0),
+	IOCTL_INFO(VIDIOC_S_STD, v4l_s_std, v4l_print_std, INFO_FL_PRIO),
+	IOCTL_INFO(VIDIOC_ENUMSTD, v4l_enumstd, v4l_print_standard, INFO_FL_CLEAR(v4l2_standard, index)),
+	IOCTL_INFO(VIDIOC_ENUMINPUT, v4l_enuminput, v4l_print_enuminput, INFO_FL_CLEAR(v4l2_input, index)),
+	IOCTL_INFO(VIDIOC_G_CTRL, v4l_g_ctrl, v4l_print_control, INFO_FL_CTRL | INFO_FL_CLEAR(v4l2_control, id)),
+	IOCTL_INFO(VIDIOC_S_CTRL, v4l_s_ctrl, v4l_print_control, INFO_FL_PRIO | INFO_FL_CTRL),
+	IOCTL_INFO(VIDIOC_G_TUNER, v4l_g_tuner, v4l_print_tuner, INFO_FL_CLEAR(v4l2_tuner, index)),
+	IOCTL_INFO(VIDIOC_S_TUNER, v4l_s_tuner, v4l_print_tuner, INFO_FL_PRIO),
+	IOCTL_INFO(VIDIOC_G_AUDIO, v4l_stub_g_audio, v4l_print_audio, 0),
+	IOCTL_INFO(VIDIOC_S_AUDIO, v4l_stub_s_audio, v4l_print_audio, INFO_FL_PRIO),
+	IOCTL_INFO(VIDIOC_QUERYCTRL, v4l_queryctrl, v4l_print_queryctrl, INFO_FL_CTRL | INFO_FL_CLEAR(v4l2_queryctrl, id)),
+	IOCTL_INFO(VIDIOC_QUERYMENU, v4l_querymenu, v4l_print_querymenu, INFO_FL_CTRL | INFO_FL_CLEAR(v4l2_querymenu, index)),
+	IOCTL_INFO(VIDIOC_G_INPUT, v4l_stub_g_input, v4l_print_u32, 0),
+	IOCTL_INFO(VIDIOC_S_INPUT, v4l_s_input, v4l_print_u32, INFO_FL_PRIO),
+	IOCTL_INFO(VIDIOC_G_EDID, v4l_stub_g_edid, v4l_print_edid, INFO_FL_ALWAYS_COPY),
+	IOCTL_INFO(VIDIOC_S_EDID, v4l_stub_s_edid, v4l_print_edid, INFO_FL_PRIO | INFO_FL_ALWAYS_COPY),
+	IOCTL_INFO(VIDIOC_G_OUTPUT, v4l_stub_g_output, v4l_print_u32, 0),
+	IOCTL_INFO(VIDIOC_S_OUTPUT, v4l_s_output, v4l_print_u32, INFO_FL_PRIO),
+	IOCTL_INFO(VIDIOC_ENUMOUTPUT, v4l_enumoutput, v4l_print_enumoutput, INFO_FL_CLEAR(v4l2_output, index)),
+	IOCTL_INFO(VIDIOC_G_AUDOUT, v4l_stub_g_audout, v4l_print_audioout, 0),
+	IOCTL_INFO(VIDIOC_S_AUDOUT, v4l_stub_s_audout, v4l_print_audioout, INFO_FL_PRIO),
+	IOCTL_INFO(VIDIOC_G_MODULATOR, v4l_g_modulator, v4l_print_modulator, INFO_FL_CLEAR(v4l2_modulator, index)),
+	IOCTL_INFO(VIDIOC_S_MODULATOR, v4l_s_modulator, v4l_print_modulator, INFO_FL_PRIO),
+	IOCTL_INFO(VIDIOC_G_FREQUENCY, v4l_g_frequency, v4l_print_frequency, INFO_FL_CLEAR(v4l2_frequency, tuner)),
+	IOCTL_INFO(VIDIOC_S_FREQUENCY, v4l_s_frequency, v4l_print_frequency, INFO_FL_PRIO),
+	IOCTL_INFO(VIDIOC_CROPCAP, v4l_cropcap, v4l_print_cropcap, INFO_FL_CLEAR(v4l2_cropcap, type)),
+	IOCTL_INFO(VIDIOC_G_CROP, v4l_g_crop, v4l_print_crop, INFO_FL_CLEAR(v4l2_crop, type)),
+	IOCTL_INFO(VIDIOC_S_CROP, v4l_s_crop, v4l_print_crop, INFO_FL_PRIO),
+	IOCTL_INFO(VIDIOC_G_SELECTION, v4l_g_selection, v4l_print_selection, INFO_FL_CLEAR(v4l2_selection, r)),
+	IOCTL_INFO(VIDIOC_S_SELECTION, v4l_s_selection, v4l_print_selection, INFO_FL_PRIO | INFO_FL_CLEAR(v4l2_selection, r)),
+	IOCTL_INFO(VIDIOC_G_JPEGCOMP, v4l_stub_g_jpegcomp, v4l_print_jpegcompression, 0),
+	IOCTL_INFO(VIDIOC_S_JPEGCOMP, v4l_stub_s_jpegcomp, v4l_print_jpegcompression, INFO_FL_PRIO),
+	IOCTL_INFO(VIDIOC_QUERYSTD, v4l_querystd, v4l_print_std, 0),
+	IOCTL_INFO(VIDIOC_TRY_FMT, v4l_try_fmt, v4l_print_format, 0),
+	IOCTL_INFO(VIDIOC_ENUMAUDIO, v4l_stub_enumaudio, v4l_print_audio, INFO_FL_CLEAR(v4l2_audio, index)),
+	IOCTL_INFO(VIDIOC_ENUMAUDOUT, v4l_stub_enumaudout, v4l_print_audioout, INFO_FL_CLEAR(v4l2_audioout, index)),
+	IOCTL_INFO(VIDIOC_G_PRIORITY, v4l_g_priority, v4l_print_u32, 0),
+	IOCTL_INFO(VIDIOC_S_PRIORITY, v4l_s_priority, v4l_print_u32, INFO_FL_PRIO),
+	IOCTL_INFO(VIDIOC_G_SLICED_VBI_CAP, v4l_g_sliced_vbi_cap, v4l_print_sliced_vbi_cap, INFO_FL_CLEAR(v4l2_sliced_vbi_cap, type)),
+	IOCTL_INFO(VIDIOC_LOG_STATUS, v4l_log_status, v4l_print_newline, 0),
+	IOCTL_INFO(VIDIOC_G_EXT_CTRLS, v4l_g_ext_ctrls, v4l_print_ext_controls, INFO_FL_CTRL),
+	IOCTL_INFO(VIDIOC_S_EXT_CTRLS, v4l_s_ext_ctrls, v4l_print_ext_controls, INFO_FL_PRIO | INFO_FL_CTRL),
+	IOCTL_INFO(VIDIOC_TRY_EXT_CTRLS, v4l_try_ext_ctrls, v4l_print_ext_controls, INFO_FL_CTRL),
+	IOCTL_INFO(VIDIOC_ENUM_FRAMESIZES, v4l_stub_enum_framesizes, v4l_print_frmsizeenum, INFO_FL_CLEAR(v4l2_frmsizeenum, pixel_format)),
+	IOCTL_INFO(VIDIOC_ENUM_FRAMEINTERVALS, v4l_stub_enum_frameintervals, v4l_print_frmivalenum, INFO_FL_CLEAR(v4l2_frmivalenum, height)),
+	IOCTL_INFO(VIDIOC_G_ENC_INDEX, v4l_stub_g_enc_index, v4l_print_enc_idx, 0),
+	IOCTL_INFO(VIDIOC_ENCODER_CMD, v4l_stub_encoder_cmd, v4l_print_encoder_cmd, INFO_FL_PRIO | INFO_FL_CLEAR(v4l2_encoder_cmd, flags)),
+	IOCTL_INFO(VIDIOC_TRY_ENCODER_CMD, v4l_stub_try_encoder_cmd, v4l_print_encoder_cmd, INFO_FL_CLEAR(v4l2_encoder_cmd, flags)),
+	IOCTL_INFO(VIDIOC_DECODER_CMD, v4l_stub_decoder_cmd, v4l_print_decoder_cmd, INFO_FL_PRIO),
+	IOCTL_INFO(VIDIOC_TRY_DECODER_CMD, v4l_stub_try_decoder_cmd, v4l_print_decoder_cmd, 0),
+	IOCTL_INFO(VIDIOC_DBG_S_REGISTER, v4l_dbg_s_register, v4l_print_dbg_register, 0),
+	IOCTL_INFO(VIDIOC_DBG_G_REGISTER, v4l_dbg_g_register, v4l_print_dbg_register, 0),
+	IOCTL_INFO(VIDIOC_S_HW_FREQ_SEEK, v4l_s_hw_freq_seek, v4l_print_hw_freq_seek, INFO_FL_PRIO),
+	IOCTL_INFO(VIDIOC_S_DV_TIMINGS, v4l_stub_s_dv_timings, v4l_print_dv_timings, INFO_FL_PRIO | INFO_FL_CLEAR(v4l2_dv_timings, bt.flags)),
+	IOCTL_INFO(VIDIOC_G_DV_TIMINGS, v4l_stub_g_dv_timings, v4l_print_dv_timings, 0),
+	IOCTL_INFO(VIDIOC_DQEVENT, v4l_dqevent, v4l_print_event, 0),
+	IOCTL_INFO(VIDIOC_SUBSCRIBE_EVENT, v4l_subscribe_event, v4l_print_event_subscription, 0),
+	IOCTL_INFO(VIDIOC_UNSUBSCRIBE_EVENT, v4l_unsubscribe_event, v4l_print_event_subscription, 0),
+	IOCTL_INFO(VIDIOC_CREATE_BUFS, v4l_create_bufs, v4l_print_create_buffers, INFO_FL_PRIO | INFO_FL_QUEUE),
+	IOCTL_INFO(VIDIOC_PREPARE_BUF, v4l_prepare_buf, v4l_print_buffer, INFO_FL_QUEUE),
+	IOCTL_INFO(VIDIOC_ENUM_DV_TIMINGS, v4l_stub_enum_dv_timings, v4l_print_enum_dv_timings, INFO_FL_CLEAR(v4l2_enum_dv_timings, pad)),
+	IOCTL_INFO(VIDIOC_QUERY_DV_TIMINGS, v4l_stub_query_dv_timings, v4l_print_dv_timings, INFO_FL_ALWAYS_COPY),
+	IOCTL_INFO(VIDIOC_DV_TIMINGS_CAP, v4l_stub_dv_timings_cap, v4l_print_dv_timings_cap, INFO_FL_CLEAR(v4l2_dv_timings_cap, pad)),
+	IOCTL_INFO(VIDIOC_ENUM_FREQ_BANDS, v4l_enum_freq_bands, v4l_print_freq_band, 0),
+	IOCTL_INFO(VIDIOC_DBG_G_CHIP_INFO, v4l_dbg_g_chip_info, v4l_print_dbg_chip_info, INFO_FL_CLEAR(v4l2_dbg_chip_info, match)),
+	IOCTL_INFO(VIDIOC_QUERY_EXT_CTRL, v4l_query_ext_ctrl, v4l_print_query_ext_ctrl, INFO_FL_CTRL | INFO_FL_CLEAR(v4l2_query_ext_ctrl, id)),
 };
 #define V4L2_IOCTLS ARRAY_SIZE(v4l2_ioctls)
 
@@ -2717,14 +2738,8 @@ static long __video_do_ioctl(struct file *file,
 	}
 
 	write_only = _IOC_DIR(cmd) == _IOC_WRITE;
-	if (info->flags & INFO_FL_STD) {
-		typedef int (*vidioc_op)(struct file *file, void *fh, void *p);
-		const void *p = vfd->ioctl_ops;
-		const vidioc_op *vidioc = p + info->u.offset;
-
-		ret = (*vidioc)(file, fh, arg);
-	} else if (info->flags & INFO_FL_FUNC) {
-		ret = info->u.func(ops, file, fh, arg);
+	if (info != &default_info) {
+		ret = info->func(ops, file, fh, arg);
 	} else if (!ops->vidioc_default) {
 		ret = -ENOTTY;
 	} else {
-- 
2.17.0.441.gb46fe60e1d-goog
