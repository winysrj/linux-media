Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39759 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbcGWD32 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jul 2016 23:29:28 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 3/3] [media] v4l2-ioctl.h add debug info for struct v4l2_ioctl_ops
Date: Sat, 23 Jul 2016 00:29:22 -0300
Message-Id: <b7e8371b9c3fceccfaf7773c26a0d4ed621c6ec0.1469244556.git.mchehab@s-opensource.com>
In-Reply-To: <fd20fc5ae65d3cd338b9925f633b2b962546b73f.1469244556.git.mchehab@s-opensource.com>
References: <fd20fc5ae65d3cd338b9925f633b2b962546b73f.1469244556.git.mchehab@s-opensource.com>
In-Reply-To: <fd20fc5ae65d3cd338b9925f633b2b962546b73f.1469244556.git.mchehab@s-opensource.com>
References: <fd20fc5ae65d3cd338b9925f633b2b962546b73f.1469244556.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This struct is mentioned at the kAPI docbook. So, let's document
it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/kapi/v4l2-common.rst |   2 +
 include/media/v4l2-ioctl.h               | 266 +++++++++++++++++++++++++++++++
 2 files changed, 268 insertions(+)

diff --git a/Documentation/media/kapi/v4l2-common.rst b/Documentation/media/kapi/v4l2-common.rst
index d1ea1c9e35a0..525d804871ff 100644
--- a/Documentation/media/kapi/v4l2-common.rst
+++ b/Documentation/media/kapi/v4l2-common.rst
@@ -2,3 +2,5 @@ V4L2 common functions and data structures
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
 .. kernel-doc:: include/media/v4l2-common.h
+
+.. kernel-doc:: include/media/v4l2-ioctl.h
diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
index 017ffb2220c7..8b1d19bc9b0e 100644
--- a/include/media/v4l2-ioctl.h
+++ b/include/media/v4l2-ioctl.h
@@ -17,6 +17,272 @@
 
 struct v4l2_fh;
 
+/**
+ * struct v4l2_ioctl_ops - describe operations for each V4L2 ioctl
+ *
+ * @vidioc_querycap: pointer to the function that implements
+ *	:ref:`VIDIOC_QUERYCAP <vidioc_querycap>` ioctl
+ * @vidioc_enum_fmt_vid_cap: pointer to the function that implements
+ *	:ref:`VIDIOC_ENUM_FMT <vidioc_enum_fmt>` ioctl logic
+ *	for video capture in single plane mode
+ * @vidioc_enum_fmt_vid_overlay: pointer to the function that implements
+ *	:ref:`VIDIOC_ENUM_FMT <vidioc_enum_fmt>` ioctl logic
+ *	for video overlay
+ * @vidioc_enum_fmt_vid_out: pointer to the function that implements
+ *	:ref:`VIDIOC_ENUM_FMT <vidioc_enum_fmt>` ioctl logic
+ *	for video output in single plane mode
+ * @vidioc_enum_fmt_vid_cap_mplane: pointer to the function that implements
+ *	:ref:`VIDIOC_ENUM_FMT <vidioc_enum_fmt>` ioctl logic
+ *	for video capture in multiplane mode
+ * @vidioc_enum_fmt_vid_out_mplane: pointer to the function that implements
+ *	:ref:`VIDIOC_ENUM_FMT <vidioc_enum_fmt>` ioctl logic
+ *	for video output in multiplane mode
+ * @vidioc_enum_fmt_sdr_cap: pointer to the function that implements
+ *	:ref:`VIDIOC_ENUM_FMT <vidioc_enum_fmt>` ioctl logic
+ *	for Software Defined Radio capture
+ * @vidioc_enum_fmt_sdr_out: pointer to the function that implements
+ *	:ref:`VIDIOC_ENUM_FMT <vidioc_enum_fmt>` ioctl logic
+ *	for Software Defined Radio output
+ * @vidioc_g_fmt_vid_cap: pointer to the function that implements
+ *	:ref:`VIDIOC_G_FMT <vidioc_g_fmt>` ioctl logic for video capture
+ *	in single plane mode
+ * @vidioc_g_fmt_vid_overlay: pointer to the function that implements
+ *	:ref:`VIDIOC_G_FMT <vidioc_g_fmt>` ioctl logic for video overlay
+ * @vidioc_g_fmt_vid_out: pointer to the function that implements
+ *	:ref:`VIDIOC_G_FMT <vidioc_g_fmt>` ioctl logic for video out
+ *	in single plane mode
+ * @vidioc_g_fmt_vid_out_overlay: pointer to the function that implements
+ *	:ref:`VIDIOC_G_FMT <vidioc_g_fmt>` ioctl logic for video overlay output
+ * @vidioc_g_fmt_vbi_cap: pointer to the function that implements
+ *	:ref:`VIDIOC_G_FMT <vidioc_g_fmt>` ioctl logic for raw VBI capture
+ * @vidioc_g_fmt_vbi_out: pointer to the function that implements
+ *	:ref:`VIDIOC_G_FMT <vidioc_g_fmt>` ioctl logic for raw VBI output
+ * @vidioc_g_fmt_sliced_vbi_cap: pointer to the function that implements
+ *	:ref:`VIDIOC_G_FMT <vidioc_g_fmt>` ioctl logic for sliced VBI capture
+ * @vidioc_g_fmt_sliced_vbi_out: pointer to the function that implements
+ *	:ref:`VIDIOC_G_FMT <vidioc_g_fmt>` ioctl logic for sliced VBI output
+ * @vidioc_g_fmt_vid_cap_mplane: pointer to the function that implements
+ *	:ref:`VIDIOC_G_FMT <vidioc_g_fmt>` ioctl logic for video capture
+ *	in multiple plane mode
+ * @vidioc_g_fmt_vid_out_mplane: pointer to the function that implements
+ *	:ref:`VIDIOC_G_FMT <vidioc_g_fmt>` ioctl logic for video out
+ *	in multiplane plane mode
+ * @vidioc_g_fmt_sdr_cap: pointer to the function that implements
+ *	:ref:`VIDIOC_G_FMT <vidioc_g_fmt>` ioctl logic for Software Defined
+ *	Radio capture
+ * @vidioc_g_fmt_sdr_out: pointer to the function that implements
+ *	:ref:`VIDIOC_G_FMT <vidioc_g_fmt>` ioctl logic for Software Defined
+ *	Radio output
+ * @vidioc_s_fmt_vid_cap: pointer to the function that implements
+ *	:ref:`VIDIOC_S_FMT <vidioc_g_fmt>` ioctl logic for video capture
+ *	in single plane mode
+ * @vidioc_s_fmt_vid_overlay: pointer to the function that implements
+ *	:ref:`VIDIOC_S_FMT <vidioc_g_fmt>` ioctl logic for video overlay
+ * @vidioc_s_fmt_vid_out: pointer to the function that implements
+ *	:ref:`VIDIOC_S_FMT <vidioc_g_fmt>` ioctl logic for video out
+ *	in single plane mode
+ * @vidioc_s_fmt_vid_out_overlay: pointer to the function that implements
+ *	:ref:`VIDIOC_S_FMT <vidioc_g_fmt>` ioctl logic for video overlay output
+ * @vidioc_s_fmt_vbi_cap: pointer to the function that implements
+ *	:ref:`VIDIOC_S_FMT <vidioc_g_fmt>` ioctl logic for raw VBI capture
+ * @vidioc_s_fmt_vbi_out: pointer to the function that implements
+ *	:ref:`VIDIOC_S_FMT <vidioc_g_fmt>` ioctl logic for raw VBI output
+ * @vidioc_s_fmt_sliced_vbi_cap: pointer to the function that implements
+ *	:ref:`VIDIOC_S_FMT <vidioc_g_fmt>` ioctl logic for sliced VBI capture
+ * @vidioc_s_fmt_sliced_vbi_out: pointer to the function that implements
+ *	:ref:`VIDIOC_S_FMT <vidioc_g_fmt>` ioctl logic for sliced VBI output
+ * @vidioc_s_fmt_vid_cap_mplane: pointer to the function that implements
+ *	:ref:`VIDIOC_S_FMT <vidioc_g_fmt>` ioctl logic for video capture
+ *	in multiple plane mode
+ * @vidioc_s_fmt_vid_out_mplane: pointer to the function that implements
+ *	:ref:`VIDIOC_S_FMT <vidioc_g_fmt>` ioctl logic for video out
+ *	in multiplane plane mode
+ * @vidioc_s_fmt_sdr_cap: pointer to the function that implements
+ *	:ref:`VIDIOC_S_FMT <vidioc_g_fmt>` ioctl logic for Software Defined
+ *	Radio capture
+ * @vidioc_s_fmt_sdr_out: pointer to the function that implements
+ *	:ref:`VIDIOC_S_FMT <vidioc_g_fmt>` ioctl logic for Software Defined
+ *	Radio output
+ * @vidioc_try_fmt_vid_cap: pointer to the function that implements
+ *	:ref:`VIDIOC_TRY_FMT <vidioc_g_fmt>` ioctl logic for video capture
+ *	in single plane mode
+ * @vidioc_try_fmt_vid_overlay: pointer to the function that implements
+ *	:ref:`VIDIOC_TRY_FMT <vidioc_g_fmt>` ioctl logic for video overlay
+ * @vidioc_try_fmt_vid_out: pointer to the function that implements
+ *	:ref:`VIDIOC_TRY_FMT <vidioc_g_fmt>` ioctl logic for video out
+ *	in single plane mode
+ * @vidioc_try_fmt_vid_out_overlay: pointer to the function that implements
+ *	:ref:`VIDIOC_TRY_FMT <vidioc_g_fmt>` ioctl logic for video overlay
+ *	output
+ * @vidioc_try_fmt_vbi_cap: pointer to the function that implements
+ *	:ref:`VIDIOC_TRY_FMT <vidioc_g_fmt>` ioctl logic for raw VBI capture
+ * @vidioc_try_fmt_vbi_out: pointer to the function that implements
+ *	:ref:`VIDIOC_TRY_FMT <vidioc_g_fmt>` ioctl logic for raw VBI output
+ * @vidioc_try_fmt_sliced_vbi_cap: pointer to the function that implements
+ *	:ref:`VIDIOC_TRY_FMT <vidioc_g_fmt>` ioctl logic for sliced VBI
+ *	capture
+ * @vidioc_try_fmt_sliced_vbi_out: pointer to the function that implements
+ *	:ref:`VIDIOC_TRY_FMT <vidioc_g_fmt>` ioctl logic for sliced VBI output
+ * @vidioc_try_fmt_vid_cap_mplane: pointer to the function that implements
+ *	:ref:`VIDIOC_TRY_FMT <vidioc_g_fmt>` ioctl logic for video capture
+ *	in multiple plane mode
+ * @vidioc_try_fmt_vid_out_mplane: pointer to the function that implements
+ *	:ref:`VIDIOC_TRY_FMT <vidioc_g_fmt>` ioctl logic for video out
+ *	in multiplane plane mode
+ * @vidioc_try_fmt_sdr_cap: pointer to the function that implements
+ *	:ref:`VIDIOC_TRY_FMT <vidioc_g_fmt>` ioctl logic for Software Defined
+ *	Radio capture
+ * @vidioc_try_fmt_sdr_out: pointer to the function that implements
+ *	:ref:`VIDIOC_TRY_FMT <vidioc_g_fmt>` ioctl logic for Software Defined
+ *	Radio output
+ * @vidioc_reqbufs: pointer to the function that implements
+ *	:ref:`VIDIOC_REQBUFS <vidioc_reqbufs>` ioctl
+ * @vidioc_querybuf: pointer to the function that implements
+ *	:ref:`VIDIOC_QUERYBUF <vidioc_querybuf>` ioctl
+ * @vidioc_qbuf: pointer to the function that implements
+ *	:ref:`VIDIOC_QBUF <vidioc_qbuf>` ioctl
+ * @vidioc_expbuf: pointer to the function that implements
+ *	:ref:`VIDIOC_EXPBUF <vidioc_expbuf>` ioctl
+ * @vidioc_dqbuf: pointer to the function that implements
+ *	:ref:`VIDIOC_DQBUF <vidioc_qbuf>` ioctl
+ * @vidioc_create_bufs: pointer to the function that implements
+ *	:ref:`VIDIOC_CREATE_BUFS <vidioc_create_bufs>` ioctl
+ * @vidioc_prepare_buf: pointer to the function that implements
+ *	:ref:`VIDIOC_PREPARE_BUF <vidioc_prepare_buf>` ioctl
+ * @vidioc_overlay: pointer to the function that implements
+ *	:ref:`VIDIOC_OVERLAY <vidioc_overlay>` ioctl
+ * @vidioc_g_fbuf: pointer to the function that implements
+ *	:ref:`VIDIOC_G_FBUF <vidioc_g_fbuf>` ioctl
+ * @vidioc_s_fbuf: pointer to the function that implements
+ *	:ref:`VIDIOC_S_FBUF <vidioc_g_fbuf>` ioctl
+ * @vidioc_streamon: pointer to the function that implements
+ *	:ref:`VIDIOC_STREAMON <vidioc_streamon>` ioctl
+ * @vidioc_streamoff: pointer to the function that implements
+ *	:ref:`VIDIOC_STREAMOFF <vidioc_streamon>` ioctl
+ * @vidioc_g_std: pointer to the function that implements
+ *	:ref:`VIDIOC_G_STD <vidioc_g_std>` ioctl
+ * @vidioc_s_std: pointer to the function that implements
+ *	:ref:`VIDIOC_S_STD <vidioc_g_std>` ioctl
+ * @vidioc_querystd: pointer to the function that implements
+ *	:ref:`VIDIOC_QUERYSTD <vidioc_querystd>` ioctl
+ * @vidioc_enum_input: pointer to the function that implements
+ *	:ref:`VIDIOC_ENUM_INPUT <vidioc_g_input>` ioctl
+ * @vidioc_g_input: pointer to the function that implements
+ *	:ref:`VIDIOC_G_INPUT <vidioc_g_input>` ioctl
+ * @vidioc_s_input: pointer to the function that implements
+ *	:ref:`VIDIOC_S_INPUT <vidioc_g_input>` ioctl
+ * @vidioc_enum_output: pointer to the function that implements
+ *	:ref:`VIDIOC_ENUM_OUTPUT <vidioc_g_output>` ioctl
+ * @vidioc_g_output: pointer to the function that implements
+ *	:ref:`VIDIOC_G_OUTPUT <vidioc_g_output>` ioctl
+ * @vidioc_s_output: pointer to the function that implements
+ *	:ref:`VIDIOC_S_OUTPUT <vidioc_g_output>` ioctl
+ * @vidioc_queryctrl: pointer to the function that implements
+ *	:ref:`VIDIOC_QUERYCTRL <vidioc_queryctrl>` ioctl
+ * @vidioc_query_ext_ctrl: pointer to the function that implements
+ *	:ref:`VIDIOC_QUERY_EXT_CTRL <vidioc_queryctrl>` ioctl
+ * @vidioc_g_ctrl: pointer to the function that implements
+ *	:ref:`VIDIOC_G_CTRL <vidioc_g_ctrl>` ioctl
+ * @vidioc_s_ctrl: pointer to the function that implements
+ *	:ref:`VIDIOC_S_CTRL <vidioc_g_ctrl>` ioctl
+ * @vidioc_g_ext_ctrls: pointer to the function that implements
+ *	:ref:`VIDIOC_G_EXT_CTRLS <vidioc_g_ext_ctrls>` ioctl
+ * @vidioc_s_ext_ctrls: pointer to the function that implements
+ *	:ref:`VIDIOC_S_EXT_CTRLS <vidioc_g_ext_ctrls>` ioctl
+ * @vidioc_try_ext_ctrls: pointer to the function that implements
+ *	:ref:`VIDIOC_TRY_EXT_CTRLS <vidioc_g_ext_ctrls>` ioctl
+ * @vidioc_querymenu: pointer to the function that implements
+ *	:ref:`VIDIOC_QUERYMENU <vidioc_queryctrl>` ioctl
+ * @vidioc_enumaudio: pointer to the function that implements
+ *	:ref:`VIDIOC_ENUMAUDIO <vidioc_enumaudio>` ioctl
+ * @vidioc_g_audio: pointer to the function that implements
+ *	:ref:`VIDIOC_G_AUDIO <vidioc_g_audio>` ioctl
+ * @vidioc_s_audio: pointer to the function that implements
+ *	:ref:`VIDIOC_S_AUDIO <vidioc_g_audio>` ioctl
+ * @vidioc_enumaudout: pointer to the function that implements
+ *	:ref:`VIDIOC_ENUMAUDOUT <vidioc_enumaudout>` ioctl
+ * @vidioc_g_audout: pointer to the function that implements
+ *	:ref:`VIDIOC_G_AUDOUT <vidioc_g_audout>` ioctl
+ * @vidioc_s_audout: pointer to the function that implements
+ *	:ref:`VIDIOC_S_AUDOUT <vidioc_g_audout>` ioctl
+ * @vidioc_g_modulator: pointer to the function that implements
+ *	:ref:`VIDIOC_G_MODULATOR <vidioc_g_modulator>` ioctl
+ * @vidioc_s_modulator: pointer to the function that implements
+ *	:ref:`VIDIOC_S_MODULATOR <vidioc_g_modulator>` ioctl
+ * @vidioc_cropcap: pointer to the function that implements
+ *	:ref:`VIDIOC_CROPCAP <vidioc_cropcap>` ioctl
+ * @vidioc_g_crop: pointer to the function that implements
+ *	:ref:`VIDIOC_G_CROP <vidioc_g_crop>` ioctl
+ * @vidioc_s_crop: pointer to the function that implements
+ *	:ref:`VIDIOC_S_CROP <vidioc_g_crop>` ioctl
+ * @vidioc_g_selection: pointer to the function that implements
+ *	:ref:`VIDIOC_G_SELECTION <vidioc_g_selection>` ioctl
+ * @vidioc_s_selection: pointer to the function that implements
+ *	:ref:`VIDIOC_S_SELECTION <vidioc_g_selection>` ioctl
+ * @vidioc_g_jpegcomp: pointer to the function that implements
+ *	:ref:`VIDIOC_G_JPEGCOMP <vidioc_g_jpegcomp>` ioctl
+ * @vidioc_s_jpegcomp: pointer to the function that implements
+ *	:ref:`VIDIOC_S_JPEGCOMP <vidioc_g_jpegcomp>` ioctl
+ * @vidioc_g_enc_index: pointer to the function that implements
+ *	:ref:`VIDIOC_G_ENC_INDEX <vidioc_g_enc_index>` ioctl
+ * @vidioc_encoder_cmd: pointer to the function that implements
+ *	:ref:`VIDIOC_ENCODER_CMD <vidioc_encoder_cmd>` ioctl
+ * @vidioc_try_encoder_cmd: pointer to the function that implements
+ *	:ref:`VIDIOC_TRY_ENCODER_CMD <vidioc_encoder_cmd>` ioctl
+ * @vidioc_decoder_cmd: pointer to the function that implements
+ *	:ref:`VIDIOC_DECODER_CMD <vidioc_decoder_cmd>` ioctl
+ * @vidioc_try_decoder_cmd: pointer to the function that implements
+ *	:ref:`VIDIOC_TRY_DECODER_CMD <vidioc_decoder_cmd>` ioctl
+ * @vidioc_g_parm: pointer to the function that implements
+ *	:ref:`VIDIOC_G_PARM <vidioc_g_parm>` ioctl
+ * @vidioc_s_parm: pointer to the function that implements
+ *	:ref:`VIDIOC_S_PARM <vidioc_g_parm>` ioctl
+ * @vidioc_g_tuner: pointer to the function that implements
+ *	:ref:`VIDIOC_G_TUNER <vidioc_g_tuner>` ioctl
+ * @vidioc_s_tuner: pointer to the function that implements
+ *	:ref:`VIDIOC_S_TUNER <vidioc_g_tuner>` ioctl
+ * @vidioc_g_frequency: pointer to the function that implements
+ *	:ref:`VIDIOC_G_FREQUENCY <vidioc_g_frequency>` ioctl
+ * @vidioc_s_frequency: pointer to the function that implements
+ *	:ref:`VIDIOC_S_FREQUENCY <vidioc_g_frequency>` ioctl
+ * @vidioc_enum_freq_bands: pointer to the function that implements
+ *	:ref:`VIDIOC_ENUM_FREQ_BANDS <vidioc_enum_freq_bands>` ioctl
+ * @vidioc_g_sliced_vbi_cap: pointer to the function that implements
+ *	:ref:`VIDIOC_G_SLICED_VBI_CAP <vidioc_g_sliced_vbi_cap>` ioctl
+ * @vidioc_log_status: pointer to the function that implements
+ *	:ref:`VIDIOC_LOG_STATUS <vidioc_log_status>` ioctl
+ * @vidioc_s_hw_freq_seek: pointer to the function that implements
+ *	:ref:`VIDIOC_S_HW_FREQ_SEEK <vidioc_s_hw_freq_seek>` ioctl
+ * @vidioc_g_register: pointer to the function that implements
+ *	:ref:`VIDIOC_DBG_G_REGISTER <vidioc_dbg_g_register>` ioctl
+ * @vidioc_s_register: pointer to the function that implements
+ *	:ref:`VIDIOC_DBG_S_REGISTER <vidioc_dbg_g_register>` ioctl
+ * @vidioc_g_chip_info: pointer to the function that implements
+ *	:ref:`VIDIOC_DBG_G_CHIP_INFO <vidioc_dbg_g_chip_info>` ioctl
+ * @vidioc_enum_framesizes: pointer to the function that implements
+ *	:ref:`VIDIOC_ENUM_FRAMESIZES <vidioc_enum_framesizes>` ioctl
+ * @vidioc_enum_frameintervals: pointer to the function that implements
+ *	:ref:`VIDIOC_ENUM_FRAMEINTERVALS <vidioc_enum_frameintervals>` ioctl
+ * @vidioc_s_dv_timings: pointer to the function that implements
+ *	:ref:`VIDIOC_S_DV_TIMINGS <vidioc_g_dv_timings>` ioctl
+ * @vidioc_g_dv_timings: pointer to the function that implements
+ *	:ref:`VIDIOC_G_DV_TIMINGS <vidioc_g_dv_timings>` ioctl
+ * @vidioc_query_dv_timings: pointer to the function that implements
+ *	:ref:`VIDIOC_QUERY_DV_TIMINGS <vidioc_query_dv_timings>` ioctl
+ * @vidioc_enum_dv_timings: pointer to the function that implements
+ *	:ref:`VIDIOC_ENUM_DV_TIMINGS <vidioc_enum_dv_timings>` ioctl
+ * @vidioc_dv_timings_cap: pointer to the function that implements
+ *	:ref:`VIDIOC_DV_TIMINGS_CAP <vidioc_dv_timings_cap>` ioctl
+ * @vidioc_g_edid: pointer to the function that implements
+ *	:ref:`VIDIOC_G_EDID <vidioc_g_edid>` ioctl
+ * @vidioc_s_edid: pointer to the function that implements
+ *	:ref:`VIDIOC_S_EDID <vidioc_g_edid>` ioctl
+ * @vidioc_subscribe_event: pointer to the function that implements
+ *	:ref:`VIDIOC_SUBSCRIBE_EVENT <vidioc_subscribe_event>` ioctl
+ * @vidioc_unsubscribe_event: pointer to the function that implements
+ *	:ref:`VIDIOC_UNSUBSCRIBE_EVENT <vidioc_unsubscribe_event>` ioctl
+ * @vidioc_default: pointed used to allow other ioctls
+ */
 struct v4l2_ioctl_ops {
 	/* ioctl callbacks */
 
-- 
2.7.4

