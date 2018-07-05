Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:50228 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754392AbeGENFW (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Jul 2018 09:05:22 -0400
Received: by mail-wm0-f65.google.com with SMTP id v25-v6so11042163wmc.0
        for <linux-media@vger.kernel.org>; Thu, 05 Jul 2018 06:05:21 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH v5 12/27] venus: hfi_parser: add common capability parser
Date: Thu,  5 Jul 2018 16:03:46 +0300
Message-Id: <20180705130401.24315-13-stanimir.varbanov@linaro.org>
In-Reply-To: <20180705130401.24315-1-stanimir.varbanov@linaro.org>
References: <20180705130401.24315-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds common capability parser for all supported Venus
versions. Having it will help to enumerate better the supported
raw formats and codecs and also the capabilities for every
codec like max/min width/height, framerate, bitrate and so on.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Reviewed-by: Tomasz Figa <tfiga@chromium.org>
---
 drivers/media/platform/qcom/venus/Makefile     |   3 +-
 drivers/media/platform/qcom/venus/core.c       |  85 ++++++
 drivers/media/platform/qcom/venus/core.h       |  74 ++---
 drivers/media/platform/qcom/venus/hfi.c        |   5 +-
 drivers/media/platform/qcom/venus/hfi_helper.h |  28 +-
 drivers/media/platform/qcom/venus/hfi_msgs.c   | 356 ++-----------------------
 drivers/media/platform/qcom/venus/hfi_parser.c | 283 ++++++++++++++++++++
 drivers/media/platform/qcom/venus/hfi_parser.h |  45 ++++
 drivers/media/platform/qcom/venus/vdec.c       |  38 +--
 drivers/media/platform/qcom/venus/venc.c       |  52 ++--
 10 files changed, 525 insertions(+), 444 deletions(-)
 create mode 100644 drivers/media/platform/qcom/venus/hfi_parser.c
 create mode 100644 drivers/media/platform/qcom/venus/hfi_parser.h

diff --git a/drivers/media/platform/qcom/venus/Makefile b/drivers/media/platform/qcom/venus/Makefile
index bfd4edf7c83f..b44b11b03e12 100644
--- a/drivers/media/platform/qcom/venus/Makefile
+++ b/drivers/media/platform/qcom/venus/Makefile
@@ -2,7 +2,8 @@
 # Makefile for Qualcomm Venus driver
 
 venus-core-objs += core.o helpers.o firmware.o \
-		   hfi_venus.o hfi_msgs.o hfi_cmds.o hfi.o
+		   hfi_venus.o hfi_msgs.o hfi_cmds.o hfi.o \
+		   hfi_parser.o
 
 venus-dec-objs += vdec.o vdec_ctrls.o
 venus-enc-objs += venc.o venc_ctrls.o
diff --git a/drivers/media/platform/qcom/venus/core.c b/drivers/media/platform/qcom/venus/core.c
index 41eef376eb2d..381bfdd688db 100644
--- a/drivers/media/platform/qcom/venus/core.c
+++ b/drivers/media/platform/qcom/venus/core.c
@@ -152,6 +152,83 @@ static void venus_clks_disable(struct venus_core *core)
 		clk_disable_unprepare(core->clks[i]);
 }
 
+static u32 to_v4l2_codec_type(u32 codec)
+{
+	switch (codec) {
+	case HFI_VIDEO_CODEC_H264:
+		return V4L2_PIX_FMT_H264;
+	case HFI_VIDEO_CODEC_H263:
+		return V4L2_PIX_FMT_H263;
+	case HFI_VIDEO_CODEC_MPEG1:
+		return V4L2_PIX_FMT_MPEG1;
+	case HFI_VIDEO_CODEC_MPEG2:
+		return V4L2_PIX_FMT_MPEG2;
+	case HFI_VIDEO_CODEC_MPEG4:
+		return V4L2_PIX_FMT_MPEG4;
+	case HFI_VIDEO_CODEC_VC1:
+		return V4L2_PIX_FMT_VC1_ANNEX_G;
+	case HFI_VIDEO_CODEC_VP8:
+		return V4L2_PIX_FMT_VP8;
+	case HFI_VIDEO_CODEC_VP9:
+		return V4L2_PIX_FMT_VP9;
+	case HFI_VIDEO_CODEC_DIVX:
+	case HFI_VIDEO_CODEC_DIVX_311:
+		return V4L2_PIX_FMT_XVID;
+	default:
+		return 0;
+	}
+}
+
+static int venus_enumerate_codecs(struct venus_core *core, u32 type)
+{
+	const struct hfi_inst_ops dummy_ops = {};
+	struct venus_inst *inst;
+	u32 codec, codecs;
+	unsigned int i;
+	int ret;
+
+	if (core->res->hfi_version != HFI_VERSION_1XX)
+		return 0;
+
+	inst = kzalloc(sizeof(*inst), GFP_KERNEL);
+	if (!inst)
+		return -ENOMEM;
+
+	mutex_init(&inst->lock);
+	inst->core = core;
+	inst->session_type = type;
+	if (type == VIDC_SESSION_TYPE_DEC)
+		codecs = core->dec_codecs;
+	else
+		codecs = core->enc_codecs;
+
+	ret = hfi_session_create(inst, &dummy_ops);
+	if (ret)
+		goto err;
+
+	for (i = 0; i < MAX_CODEC_NUM; i++) {
+		codec = (1 << i) & codecs;
+		if (!codec)
+			continue;
+
+		ret = hfi_session_init(inst, to_v4l2_codec_type(codec));
+		if (ret)
+			goto done;
+
+		ret = hfi_session_deinit(inst);
+		if (ret)
+			goto done;
+	}
+
+done:
+	hfi_session_destroy(inst);
+err:
+	mutex_destroy(&inst->lock);
+	kfree(inst);
+
+	return ret;
+}
+
 static int venus_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -219,6 +296,14 @@ static int venus_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_venus_shutdown;
 
+	ret = venus_enumerate_codecs(core, VIDC_SESSION_TYPE_DEC);
+	if (ret)
+		goto err_venus_shutdown;
+
+	ret = venus_enumerate_codecs(core, VIDC_SESSION_TYPE_ENC);
+	if (ret)
+		goto err_venus_shutdown;
+
 	ret = v4l2_device_register(dev, &core->v4l2_dev);
 	if (ret)
 		goto err_core_deinit;
diff --git a/drivers/media/platform/qcom/venus/core.h b/drivers/media/platform/qcom/venus/core.h
index 2bf8839784fa..b995d1601c87 100644
--- a/drivers/media/platform/qcom/venus/core.h
+++ b/drivers/media/platform/qcom/venus/core.h
@@ -57,6 +57,30 @@ struct venus_format {
 	u32 type;
 };
 
+#define MAX_PLANES		4
+#define MAX_FMT_ENTRIES		32
+#define MAX_CAP_ENTRIES		32
+#define MAX_ALLOC_MODE_ENTRIES	16
+#define MAX_CODEC_NUM		32
+
+struct raw_formats {
+	u32 buftype;
+	u32 fmt;
+};
+
+struct venus_caps {
+	u32 codec;
+	u32 domain;
+	bool cap_bufs_mode_dynamic;
+	unsigned int num_caps;
+	struct hfi_capability caps[MAX_CAP_ENTRIES];
+	unsigned int num_pl;
+	struct hfi_profile_level pl[HFI_MAX_PROFILE_COUNT];
+	unsigned int num_fmts;
+	struct raw_formats fmts[MAX_FMT_ENTRIES];
+	bool valid;	/* used only for Venus v1xx */
+};
+
 /**
  * struct venus_core - holds core parameters valid for all instances
  *
@@ -113,8 +137,8 @@ struct venus_core {
 	unsigned int error;
 	bool sys_error;
 	const struct hfi_core_ops *core_ops;
-	u32 enc_codecs;
-	u32 dec_codecs;
+	unsigned long enc_codecs;
+	unsigned long dec_codecs;
 	unsigned int max_sessions_supported;
 #define ENC_ROTATION_CAPABILITY		0x1
 #define ENC_SCALING_CAPABILITY		0x2
@@ -124,6 +148,8 @@ struct venus_core {
 	void *priv;
 	const struct hfi_ops *ops;
 	struct delayed_work work;
+	struct venus_caps caps[MAX_CODEC_NUM];
+	unsigned int codecs_count;
 };
 
 struct vdec_controls {
@@ -216,6 +242,7 @@ struct venus_buffer {
  * @reconfig:	a flag raised by decoder when the stream resolution changed
  * @reconfig_width:	holds the new width
  * @reconfig_height:	holds the new height
+ * @hfi_codec:		current codec for this instance in HFI space
  * @sequence_cap:	a sequence counter for capture queue
  * @sequence_out:	a sequence counter for output queue
  * @m2m_dev:	a reference to m2m device structure
@@ -228,22 +255,8 @@ struct venus_buffer {
  * @priv:	a private for HFI operations callbacks
  * @session_type:	the type of the session (decoder or encoder)
  * @hprop:	a union used as a holder by get property
- * @cap_width:	width capability
- * @cap_height:	height capability
- * @cap_mbs_per_frame:	macroblocks per frame capability
- * @cap_mbs_per_sec:	macroblocks per second capability
- * @cap_framerate:	framerate capability
- * @cap_scale_x:		horizontal scaling capability
- * @cap_scale_y:		vertical scaling capability
- * @cap_bitrate:		bitrate capability
- * @cap_hier_p:		hier capability
- * @cap_ltr_count:	LTR count capability
- * @cap_secure_output2_threshold: secure OUTPUT2 threshold capability
  * @cap_bufs_mode_static:	buffers allocation mode capability
  * @cap_bufs_mode_dynamic:	buffers allocation mode capability
- * @pl_count:	count of supported profiles/levels
- * @pl:		supported profiles/levels
- * @bufreq:	holds buffer requirements
  */
 struct venus_inst {
 	struct list_head list;
@@ -280,6 +293,7 @@ struct venus_inst {
 	bool reconfig;
 	u32 reconfig_width;
 	u32 reconfig_height;
+	u32 hfi_codec;
 	u32 sequence_cap;
 	u32 sequence_out;
 	struct v4l2_m2m_dev *m2m_dev;
@@ -291,22 +305,8 @@ struct venus_inst {
 	const struct hfi_inst_ops *ops;
 	u32 session_type;
 	union hfi_get_property hprop;
-	struct hfi_capability cap_width;
-	struct hfi_capability cap_height;
-	struct hfi_capability cap_mbs_per_frame;
-	struct hfi_capability cap_mbs_per_sec;
-	struct hfi_capability cap_framerate;
-	struct hfi_capability cap_scale_x;
-	struct hfi_capability cap_scale_y;
-	struct hfi_capability cap_bitrate;
-	struct hfi_capability cap_hier_p;
-	struct hfi_capability cap_ltr_count;
-	struct hfi_capability cap_secure_output2_threshold;
 	bool cap_bufs_mode_static;
 	bool cap_bufs_mode_dynamic;
-	unsigned int pl_count;
-	struct hfi_profile_level pl[HFI_MAX_PROFILE_COUNT];
-	struct hfi_buffer_requirements bufreq[HFI_BUFFER_TYPE_MAX];
 };
 
 #define IS_V1(core)	((core)->res->hfi_version == HFI_VERSION_1XX)
@@ -326,4 +326,18 @@ static inline void *to_hfi_priv(struct venus_core *core)
 	return core->priv;
 }
 
+static inline struct venus_caps *
+venus_caps_by_codec(struct venus_core *core, u32 codec, u32 domain)
+{
+	unsigned int c;
+
+	for (c = 0; c < core->codecs_count; c++) {
+		if (core->caps[c].codec == codec &&
+		    core->caps[c].domain == domain)
+			return &core->caps[c];
+	}
+
+	return NULL;
+}
+
 #endif
diff --git a/drivers/media/platform/qcom/venus/hfi.c b/drivers/media/platform/qcom/venus/hfi.c
index a570fdad0de0..94ca27b0bb99 100644
--- a/drivers/media/platform/qcom/venus/hfi.c
+++ b/drivers/media/platform/qcom/venus/hfi.c
@@ -203,13 +203,12 @@ int hfi_session_init(struct venus_inst *inst, u32 pixfmt)
 {
 	struct venus_core *core = inst->core;
 	const struct hfi_ops *ops = core->ops;
-	u32 codec;
 	int ret;
 
-	codec = to_codec_type(pixfmt);
+	inst->hfi_codec = to_codec_type(pixfmt);
 	reinit_completion(&inst->done);
 
-	ret = ops->session_init(inst, inst->session_type, codec);
+	ret = ops->session_init(inst, inst->session_type, inst->hfi_codec);
 	if (ret)
 		return ret;
 
diff --git a/drivers/media/platform/qcom/venus/hfi_helper.h b/drivers/media/platform/qcom/venus/hfi_helper.h
index 1bc5aab1ce6b..15804ad7e65d 100644
--- a/drivers/media/platform/qcom/venus/hfi_helper.h
+++ b/drivers/media/platform/qcom/venus/hfi_helper.h
@@ -858,10 +858,23 @@ struct hfi_uncompressed_format_select {
 	u32 format;
 };
 
+struct hfi_uncompressed_plane_constraints {
+	u32 stride_multiples;
+	u32 max_stride;
+	u32 min_plane_buffer_height_multiple;
+	u32 buffer_alignment;
+};
+
+struct hfi_uncompressed_plane_info {
+	u32 format;
+	u32 num_planes;
+	struct hfi_uncompressed_plane_constraints plane_constraints[1];
+};
+
 struct hfi_uncompressed_format_supported {
 	u32 buffer_type;
 	u32 format_entries;
-	u32 format_info[1];
+	struct hfi_uncompressed_plane_info plane_info[1];
 };
 
 struct hfi_uncompressed_plane_actual {
@@ -875,19 +888,6 @@ struct hfi_uncompressed_plane_actual_info {
 	struct hfi_uncompressed_plane_actual plane_format[1];
 };
 
-struct hfi_uncompressed_plane_constraints {
-	u32 stride_multiples;
-	u32 max_stride;
-	u32 min_plane_buffer_height_multiple;
-	u32 buffer_alignment;
-};
-
-struct hfi_uncompressed_plane_info {
-	u32 format;
-	u32 num_planes;
-	struct hfi_uncompressed_plane_constraints plane_format[1];
-};
-
 struct hfi_uncompressed_plane_actual_constraints_info {
 	u32 buffer_type;
 	u32 num_planes;
diff --git a/drivers/media/platform/qcom/venus/hfi_msgs.c b/drivers/media/platform/qcom/venus/hfi_msgs.c
index c0f3bef8299f..0ecdaa15c296 100644
--- a/drivers/media/platform/qcom/venus/hfi_msgs.c
+++ b/drivers/media/platform/qcom/venus/hfi_msgs.c
@@ -21,6 +21,7 @@
 #include "hfi.h"
 #include "hfi_helper.h"
 #include "hfi_msgs.h"
+#include "hfi_parser.h"
 
 static void event_seq_changed(struct venus_core *core, struct venus_inst *inst,
 			      struct hfi_msg_event_notify_pkt *pkt)
@@ -217,81 +218,28 @@ static void hfi_sys_init_done(struct venus_core *core, struct venus_inst *inst,
 			      void *packet)
 {
 	struct hfi_msg_sys_init_done_pkt *pkt = packet;
-	u32 rem_bytes, read_bytes = 0, num_properties;
-	u32 error, ptype;
-	u8 *data;
+	int rem_bytes;
+	u32 error;
 
 	error = pkt->error_type;
 	if (error != HFI_ERR_NONE)
-		goto err_no_prop;
-
-	num_properties = pkt->num_properties;
+		goto done;
 
-	if (!num_properties) {
+	if (!pkt->num_properties) {
 		error = HFI_ERR_SYS_INVALID_PARAMETER;
-		goto err_no_prop;
+		goto done;
 	}
 
 	rem_bytes = pkt->hdr.size - sizeof(*pkt) + sizeof(u32);
-
-	if (!rem_bytes) {
+	if (rem_bytes <= 0) {
 		/* missing property data */
 		error = HFI_ERR_SYS_INSUFFICIENT_RESOURCES;
-		goto err_no_prop;
+		goto done;
 	}
 
-	data = (u8 *)&pkt->data[0];
-
-	if (core->res->hfi_version == HFI_VERSION_3XX)
-		goto err_no_prop;
-
-	while (num_properties && rem_bytes >= sizeof(u32)) {
-		ptype = *((u32 *)data);
-		data += sizeof(u32);
-
-		switch (ptype) {
-		case HFI_PROPERTY_PARAM_CODEC_SUPPORTED: {
-			struct hfi_codec_supported *prop;
-
-			prop = (struct hfi_codec_supported *)data;
-
-			if (rem_bytes < sizeof(*prop)) {
-				error = HFI_ERR_SYS_INSUFFICIENT_RESOURCES;
-				break;
-			}
-
-			read_bytes += sizeof(*prop) + sizeof(u32);
-			core->dec_codecs = prop->dec_codecs;
-			core->enc_codecs = prop->enc_codecs;
-			break;
-		}
-		case HFI_PROPERTY_PARAM_MAX_SESSIONS_SUPPORTED: {
-			struct hfi_max_sessions_supported *prop;
-
-			if (rem_bytes < sizeof(*prop)) {
-				error = HFI_ERR_SYS_INSUFFICIENT_RESOURCES;
-				break;
-			}
-
-			prop = (struct hfi_max_sessions_supported *)data;
-			read_bytes += sizeof(*prop) + sizeof(u32);
-			core->max_sessions_supported = prop->max_sessions;
-			break;
-		}
-		default:
-			error = HFI_ERR_SYS_INVALID_PARAMETER;
-			break;
-		}
-
-		if (error)
-			break;
+	error = hfi_parser(core, inst, pkt->data, rem_bytes);
 
-		rem_bytes -= read_bytes;
-		data += read_bytes;
-		num_properties--;
-	}
-
-err_no_prop:
+done:
 	core->error = error;
 	complete(&core->done);
 }
@@ -369,51 +317,6 @@ static void hfi_sys_pc_prepare_done(struct venus_core *core,
 	dev_dbg(core->dev, "pc prepare done (error %x)\n", pkt->error_type);
 }
 
-static void
-hfi_copy_cap_prop(struct hfi_capability *in, struct venus_inst *inst)
-{
-	if (!in || !inst)
-		return;
-
-	switch (in->capability_type) {
-	case HFI_CAPABILITY_FRAME_WIDTH:
-		inst->cap_width = *in;
-		break;
-	case HFI_CAPABILITY_FRAME_HEIGHT:
-		inst->cap_height = *in;
-		break;
-	case HFI_CAPABILITY_MBS_PER_FRAME:
-		inst->cap_mbs_per_frame = *in;
-		break;
-	case HFI_CAPABILITY_MBS_PER_SECOND:
-		inst->cap_mbs_per_sec = *in;
-		break;
-	case HFI_CAPABILITY_FRAMERATE:
-		inst->cap_framerate = *in;
-		break;
-	case HFI_CAPABILITY_SCALE_X:
-		inst->cap_scale_x = *in;
-		break;
-	case HFI_CAPABILITY_SCALE_Y:
-		inst->cap_scale_y = *in;
-		break;
-	case HFI_CAPABILITY_BITRATE:
-		inst->cap_bitrate = *in;
-		break;
-	case HFI_CAPABILITY_HIER_P_NUM_ENH_LAYERS:
-		inst->cap_hier_p = *in;
-		break;
-	case HFI_CAPABILITY_ENC_LTR_COUNT:
-		inst->cap_ltr_count = *in;
-		break;
-	case HFI_CAPABILITY_CP_OUTPUT2_THRESH:
-		inst->cap_secure_output2_threshold = *in;
-		break;
-	default:
-		break;
-	}
-}
-
 static unsigned int
 session_get_prop_profile_level(struct hfi_msg_session_property_info_pkt *pkt,
 			       struct hfi_profile_level *profile_level)
@@ -503,248 +406,27 @@ static void hfi_session_prop_info(struct venus_core *core,
 	complete(&inst->done);
 }
 
-static u32 init_done_read_prop(struct venus_core *core, struct venus_inst *inst,
-			       struct hfi_msg_session_init_done_pkt *pkt)
-{
-	struct device *dev = core->dev;
-	u32 rem_bytes, num_props;
-	u32 ptype, next_offset = 0;
-	u32 err;
-	u8 *data;
-
-	rem_bytes = pkt->shdr.hdr.size - sizeof(*pkt) + sizeof(u32);
-	if (!rem_bytes) {
-		dev_err(dev, "%s: missing property info\n", __func__);
-		return HFI_ERR_SESSION_INSUFFICIENT_RESOURCES;
-	}
-
-	err = pkt->error_type;
-	if (err)
-		return err;
-
-	data = (u8 *)&pkt->data[0];
-	num_props = pkt->num_properties;
-
-	while (err == HFI_ERR_NONE && num_props && rem_bytes >= sizeof(u32)) {
-		ptype = *((u32 *)data);
-		next_offset = sizeof(u32);
-
-		switch (ptype) {
-		case HFI_PROPERTY_PARAM_CODEC_MASK_SUPPORTED: {
-			struct hfi_codec_mask_supported *masks =
-				(struct hfi_codec_mask_supported *)
-				(data + next_offset);
-
-			next_offset += sizeof(*masks);
-			num_props--;
-			break;
-		}
-		case HFI_PROPERTY_PARAM_CAPABILITY_SUPPORTED: {
-			struct hfi_capabilities *caps;
-			struct hfi_capability *cap;
-			u32 num_caps;
-
-			if ((rem_bytes - next_offset) < sizeof(*cap)) {
-				err = HFI_ERR_SESSION_INVALID_PARAMETER;
-				break;
-			}
-
-			caps = (struct hfi_capabilities *)(data + next_offset);
-
-			num_caps = caps->num_capabilities;
-			cap = &caps->data[0];
-			next_offset += sizeof(u32);
-
-			while (num_caps &&
-			       (rem_bytes - next_offset) >= sizeof(u32)) {
-				hfi_copy_cap_prop(cap, inst);
-				cap++;
-				next_offset += sizeof(*cap);
-				num_caps--;
-			}
-			num_props--;
-			break;
-		}
-		case HFI_PROPERTY_PARAM_UNCOMPRESSED_FORMAT_SUPPORTED: {
-			struct hfi_uncompressed_format_supported *prop =
-				(struct hfi_uncompressed_format_supported *)
-				(data + next_offset);
-			u32 num_fmt_entries;
-			u8 *fmt;
-			struct hfi_uncompressed_plane_info *inf;
-
-			if ((rem_bytes - next_offset) < sizeof(*prop)) {
-				err = HFI_ERR_SESSION_INVALID_PARAMETER;
-				break;
-			}
-
-			num_fmt_entries = prop->format_entries;
-			next_offset = sizeof(*prop) - sizeof(u32);
-			fmt = (u8 *)&prop->format_info[0];
-
-			dev_dbg(dev, "uncomm format support num entries:%u\n",
-				num_fmt_entries);
-
-			while (num_fmt_entries) {
-				struct hfi_uncompressed_plane_constraints *cnts;
-				u32 bytes_to_skip;
-
-				inf = (struct hfi_uncompressed_plane_info *)fmt;
-
-				if ((rem_bytes - next_offset) < sizeof(*inf)) {
-					err = HFI_ERR_SESSION_INVALID_PARAMETER;
-					break;
-				}
-
-				dev_dbg(dev, "plane info: fmt:%x, planes:%x\n",
-					inf->format, inf->num_planes);
-
-				cnts = &inf->plane_format[0];
-				dev_dbg(dev, "%u %u %u %u\n",
-					cnts->stride_multiples,
-					cnts->max_stride,
-					cnts->min_plane_buffer_height_multiple,
-					cnts->buffer_alignment);
-
-				bytes_to_skip = sizeof(*inf) - sizeof(*cnts) +
-						inf->num_planes * sizeof(*cnts);
-
-				fmt += bytes_to_skip;
-				next_offset += bytes_to_skip;
-				num_fmt_entries--;
-			}
-			num_props--;
-			break;
-		}
-		case HFI_PROPERTY_PARAM_PROPERTIES_SUPPORTED: {
-			struct hfi_properties_supported *prop =
-				(struct hfi_properties_supported *)
-				(data + next_offset);
-
-			next_offset += sizeof(*prop) - sizeof(u32)
-					+ prop->num_properties * sizeof(u32);
-			num_props--;
-			break;
-		}
-		case HFI_PROPERTY_PARAM_PROFILE_LEVEL_SUPPORTED: {
-			struct hfi_profile_level_supported *prop =
-				(struct hfi_profile_level_supported *)
-				(data + next_offset);
-			struct hfi_profile_level *pl;
-			unsigned int prop_count = 0;
-			unsigned int count = 0;
-			u8 *ptr;
-
-			ptr = (u8 *)&prop->profile_level[0];
-			prop_count = prop->profile_count;
-
-			if (prop_count > HFI_MAX_PROFILE_COUNT)
-				prop_count = HFI_MAX_PROFILE_COUNT;
-
-			while (prop_count) {
-				ptr++;
-				pl = (struct hfi_profile_level *)ptr;
-
-				inst->pl[count].profile = pl->profile;
-				inst->pl[count].level = pl->level;
-				prop_count--;
-				count++;
-				ptr += sizeof(*pl) / sizeof(u32);
-			}
-
-			inst->pl_count = count;
-			next_offset += sizeof(*prop) - sizeof(*pl) +
-				       prop->profile_count * sizeof(*pl);
-
-			num_props--;
-			break;
-		}
-		case HFI_PROPERTY_PARAM_INTERLACE_FORMAT_SUPPORTED: {
-			next_offset +=
-				sizeof(struct hfi_interlace_format_supported);
-			num_props--;
-			break;
-		}
-		case HFI_PROPERTY_PARAM_NAL_STREAM_FORMAT_SUPPORTED: {
-			struct hfi_nal_stream_format *nal =
-				(struct hfi_nal_stream_format *)
-				(data + next_offset);
-			dev_dbg(dev, "NAL format: %x\n", nal->format);
-			next_offset += sizeof(*nal);
-			num_props--;
-			break;
-		}
-		case HFI_PROPERTY_PARAM_NAL_STREAM_FORMAT_SELECT: {
-			next_offset += sizeof(u32);
-			num_props--;
-			break;
-		}
-		case HFI_PROPERTY_PARAM_MAX_SEQUENCE_HEADER_SIZE: {
-			u32 *max_seq_sz = (u32 *)(data + next_offset);
-
-			dev_dbg(dev, "max seq header sz: %x\n", *max_seq_sz);
-			next_offset += sizeof(u32);
-			num_props--;
-			break;
-		}
-		case HFI_PROPERTY_PARAM_VENC_INTRA_REFRESH: {
-			next_offset += sizeof(struct hfi_intra_refresh);
-			num_props--;
-			break;
-		}
-		case HFI_PROPERTY_PARAM_BUFFER_ALLOC_MODE_SUPPORTED: {
-			struct hfi_buffer_alloc_mode_supported *prop =
-				(struct hfi_buffer_alloc_mode_supported *)
-				(data + next_offset);
-			unsigned int i;
-
-			for (i = 0; i < prop->num_entries; i++) {
-				if (prop->buffer_type == HFI_BUFFER_OUTPUT ||
-				    prop->buffer_type == HFI_BUFFER_OUTPUT2) {
-					switch (prop->data[i]) {
-					case HFI_BUFFER_MODE_STATIC:
-						inst->cap_bufs_mode_static = true;
-						break;
-					case HFI_BUFFER_MODE_DYNAMIC:
-						inst->cap_bufs_mode_dynamic = true;
-						break;
-					default:
-						break;
-					}
-				}
-			}
-			next_offset += sizeof(*prop) -
-				sizeof(u32) + prop->num_entries * sizeof(u32);
-			num_props--;
-			break;
-		}
-		default:
-			dev_dbg(dev, "%s: default case %#x\n", __func__, ptype);
-			break;
-		}
-
-		rem_bytes -= next_offset;
-		data += next_offset;
-	}
-
-	return err;
-}
-
 static void hfi_session_init_done(struct venus_core *core,
 				  struct venus_inst *inst, void *packet)
 {
 	struct hfi_msg_session_init_done_pkt *pkt = packet;
-	unsigned int error;
+	int rem_bytes;
+	u32 error;
 
 	error = pkt->error_type;
 	if (error != HFI_ERR_NONE)
 		goto done;
 
-	if (core->res->hfi_version != HFI_VERSION_1XX)
+	if (!IS_V1(core))
 		goto done;
 
-	error = init_done_read_prop(core, inst, pkt);
+	rem_bytes = pkt->shdr.hdr.size - sizeof(*pkt) + sizeof(u32);
+	if (rem_bytes <= 0) {
+		error = HFI_ERR_SESSION_INSUFFICIENT_RESOURCES;
+		goto done;
+	}
 
+	error = hfi_parser(core, inst, pkt->data, rem_bytes);
 done:
 	inst->error = error;
 	complete(&inst->done);
diff --git a/drivers/media/platform/qcom/venus/hfi_parser.c b/drivers/media/platform/qcom/venus/hfi_parser.c
new file mode 100644
index 000000000000..afc0db3b5dc3
--- /dev/null
+++ b/drivers/media/platform/qcom/venus/hfi_parser.c
@@ -0,0 +1,283 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2018 Linaro Ltd.
+ *
+ * Author: Stanimir Varbanov <stanimir.varbanov@linaro.org>
+ */
+#include <linux/bitops.h>
+#include <linux/kernel.h>
+
+#include "core.h"
+#include "hfi_helper.h"
+#include "hfi_parser.h"
+
+typedef void (*func)(struct venus_caps *cap, const void *data,
+		     unsigned int size);
+
+static void init_codecs(struct venus_core *core)
+{
+	struct venus_caps *caps = core->caps, *cap;
+	unsigned long bit;
+
+	for_each_set_bit(bit, &core->dec_codecs, MAX_CODEC_NUM) {
+		cap = &caps[core->codecs_count++];
+		cap->codec = BIT(bit);
+		cap->domain = VIDC_SESSION_TYPE_DEC;
+		cap->valid = false;
+	}
+
+	for_each_set_bit(bit, &core->enc_codecs, MAX_CODEC_NUM) {
+		cap = &caps[core->codecs_count++];
+		cap->codec = BIT(bit);
+		cap->domain = VIDC_SESSION_TYPE_ENC;
+		cap->valid = false;
+	}
+}
+
+static void for_each_codec(struct venus_caps *caps, unsigned int caps_num,
+			   u32 codecs, u32 domain, func cb, void *data,
+			   unsigned int size)
+{
+	struct venus_caps *cap;
+	unsigned int i;
+
+	for (i = 0; i < caps_num; i++) {
+		cap = &caps[i];
+		if (cap->valid && cap->domain == domain)
+			continue;
+		if (cap->codec & codecs && cap->domain == domain)
+			cb(cap, data, size);
+	}
+}
+
+static void
+fill_buf_mode(struct venus_caps *cap, const void *data, unsigned int num)
+{
+	const u32 *type = data;
+
+	if (*type == HFI_BUFFER_MODE_DYNAMIC)
+		cap->cap_bufs_mode_dynamic = true;
+}
+
+static void
+parse_alloc_mode(struct venus_core *core, struct venus_inst *inst, u32 codecs,
+		 u32 domain, void *data)
+{
+	struct hfi_buffer_alloc_mode_supported *mode = data;
+	u32 num_entries = mode->num_entries;
+	u32 *type;
+
+	if (num_entries > MAX_ALLOC_MODE_ENTRIES)
+		return;
+
+	type = mode->data;
+
+	while (num_entries--) {
+		if (mode->buffer_type == HFI_BUFFER_OUTPUT ||
+		    mode->buffer_type == HFI_BUFFER_OUTPUT2) {
+			if (*type == HFI_BUFFER_MODE_DYNAMIC && inst)
+				inst->cap_bufs_mode_dynamic = true;
+
+			for_each_codec(core->caps, ARRAY_SIZE(core->caps),
+				       codecs, domain, fill_buf_mode, type, 1);
+		}
+
+		type++;
+	}
+}
+
+static void fill_profile_level(struct venus_caps *cap, const void *data,
+			       unsigned int num)
+{
+	const struct hfi_profile_level *pl = data;
+
+	memcpy(&cap->pl[cap->num_pl], pl, num * sizeof(*pl));
+	cap->num_pl += num;
+}
+
+static void
+parse_profile_level(struct venus_core *core, u32 codecs, u32 domain, void *data)
+{
+	struct hfi_profile_level_supported *pl = data;
+	struct hfi_profile_level *proflevel = pl->profile_level;
+	struct hfi_profile_level pl_arr[HFI_MAX_PROFILE_COUNT] = {};
+
+	if (pl->profile_count > HFI_MAX_PROFILE_COUNT)
+		return;
+
+	memcpy(pl_arr, proflevel, pl->profile_count * sizeof(*proflevel));
+
+	for_each_codec(core->caps, ARRAY_SIZE(core->caps), codecs, domain,
+		       fill_profile_level, pl_arr, pl->profile_count);
+}
+
+static void
+fill_caps(struct venus_caps *cap, const void *data, unsigned int num)
+{
+	const struct hfi_capability *caps = data;
+
+	memcpy(&cap->caps[cap->num_caps], caps, num * sizeof(*caps));
+	cap->num_caps += num;
+}
+
+static void
+parse_caps(struct venus_core *core, u32 codecs, u32 domain, void *data)
+{
+	struct hfi_capabilities *caps = data;
+	struct hfi_capability *cap = caps->data;
+	u32 num_caps = caps->num_capabilities;
+	struct hfi_capability caps_arr[MAX_CAP_ENTRIES] = {};
+
+	if (num_caps > MAX_CAP_ENTRIES)
+		return;
+
+	memcpy(caps_arr, cap, num_caps * sizeof(*cap));
+
+	for_each_codec(core->caps, ARRAY_SIZE(core->caps), codecs, domain,
+		       fill_caps, caps_arr, num_caps);
+}
+
+static void fill_raw_fmts(struct venus_caps *cap, const void *fmts,
+			  unsigned int num_fmts)
+{
+	const struct raw_formats *formats = fmts;
+
+	memcpy(&cap->fmts[cap->num_fmts], formats, num_fmts * sizeof(*formats));
+	cap->num_fmts += num_fmts;
+}
+
+static void
+parse_raw_formats(struct venus_core *core, u32 codecs, u32 domain, void *data)
+{
+	struct hfi_uncompressed_format_supported *fmt = data;
+	struct hfi_uncompressed_plane_info *pinfo = fmt->plane_info;
+	struct hfi_uncompressed_plane_constraints *constr;
+	struct raw_formats rawfmts[MAX_FMT_ENTRIES] = {};
+	u32 entries = fmt->format_entries;
+	unsigned int i = 0;
+	u32 num_planes;
+
+	while (entries) {
+		num_planes = pinfo->num_planes;
+
+		rawfmts[i].fmt = pinfo->format;
+		rawfmts[i].buftype = fmt->buffer_type;
+		i++;
+
+		if (pinfo->num_planes > MAX_PLANES)
+			break;
+
+		pinfo = (void *)pinfo + sizeof(*constr) * num_planes +
+			2 * sizeof(u32);
+		entries--;
+	}
+
+	for_each_codec(core->caps, ARRAY_SIZE(core->caps), codecs, domain,
+		       fill_raw_fmts, rawfmts, i);
+}
+
+static void parse_codecs(struct venus_core *core, void *data)
+{
+	struct hfi_codec_supported *codecs = data;
+
+	core->dec_codecs = codecs->dec_codecs;
+	core->enc_codecs = codecs->enc_codecs;
+
+	if (IS_V1(core)) {
+		core->dec_codecs &= ~HFI_VIDEO_CODEC_HEVC;
+		core->dec_codecs &= ~HFI_VIDEO_CODEC_SPARK;
+	}
+}
+
+static void parse_max_sessions(struct venus_core *core, const void *data)
+{
+	const struct hfi_max_sessions_supported *sessions = data;
+
+	core->max_sessions_supported = sessions->max_sessions;
+}
+
+static void parse_codecs_mask(u32 *codecs, u32 *domain, void *data)
+{
+	struct hfi_codec_mask_supported *mask = data;
+
+	*codecs = mask->codecs;
+	*domain = mask->video_domains;
+}
+
+static void parser_init(struct venus_inst *inst, u32 *codecs, u32 *domain)
+{
+	if (!inst || !IS_V1(inst->core))
+		return;
+
+	*codecs = inst->hfi_codec;
+	*domain = inst->session_type;
+}
+
+static void parser_fini(struct venus_inst *inst, u32 codecs, u32 domain)
+{
+	struct venus_caps *caps, *cap;
+	unsigned int i;
+	u32 dom;
+
+	if (!inst || !IS_V1(inst->core))
+		return;
+
+	caps = inst->core->caps;
+	dom = inst->session_type;
+
+	for (i = 0; i < MAX_CODEC_NUM; i++) {
+		cap = &caps[i];
+		if (cap->codec & codecs && cap->domain == dom)
+			cap->valid = true;
+	}
+}
+
+u32 hfi_parser(struct venus_core *core, struct venus_inst *inst, void *buf,
+	       u32 size)
+{
+	unsigned int words_count = size >> 2;
+	u32 *word = buf, *data, codecs = 0, domain = 0;
+
+	if (size % 4)
+		return HFI_ERR_SYS_INSUFFICIENT_RESOURCES;
+
+	parser_init(inst, &codecs, &domain);
+
+	while (words_count) {
+		data = word + 1;
+
+		switch (*word) {
+		case HFI_PROPERTY_PARAM_CODEC_SUPPORTED:
+			parse_codecs(core, data);
+			init_codecs(core);
+			break;
+		case HFI_PROPERTY_PARAM_MAX_SESSIONS_SUPPORTED:
+			parse_max_sessions(core, data);
+			break;
+		case HFI_PROPERTY_PARAM_CODEC_MASK_SUPPORTED:
+			parse_codecs_mask(&codecs, &domain, data);
+			break;
+		case HFI_PROPERTY_PARAM_UNCOMPRESSED_FORMAT_SUPPORTED:
+			parse_raw_formats(core, codecs, domain, data);
+			break;
+		case HFI_PROPERTY_PARAM_CAPABILITY_SUPPORTED:
+			parse_caps(core, codecs, domain, data);
+			break;
+		case HFI_PROPERTY_PARAM_PROFILE_LEVEL_SUPPORTED:
+			parse_profile_level(core, codecs, domain, data);
+			break;
+		case HFI_PROPERTY_PARAM_BUFFER_ALLOC_MODE_SUPPORTED:
+			parse_alloc_mode(core, inst, codecs, domain, data);
+			break;
+		default:
+			break;
+		}
+
+		word++;
+		words_count--;
+	}
+
+	parser_fini(inst, codecs, domain);
+
+	return HFI_ERR_NONE;
+}
diff --git a/drivers/media/platform/qcom/venus/hfi_parser.h b/drivers/media/platform/qcom/venus/hfi_parser.h
new file mode 100644
index 000000000000..2fa4a345a3eb
--- /dev/null
+++ b/drivers/media/platform/qcom/venus/hfi_parser.h
@@ -0,0 +1,45 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2018 Linaro Ltd. */
+#ifndef __VENUS_HFI_PARSER_H__
+#define __VENUS_HFI_PARSER_H__
+
+#include "core.h"
+
+u32 hfi_parser(struct venus_core *core, struct venus_inst *inst,
+	       void *buf, u32 size);
+
+static inline struct hfi_capability *get_cap(struct venus_inst *inst, u32 type)
+{
+	struct venus_core *core = inst->core;
+	struct venus_caps *caps;
+	unsigned int i;
+
+	caps = venus_caps_by_codec(core, inst->hfi_codec, inst->session_type);
+	if (!caps)
+		return ERR_PTR(-EINVAL);
+
+	for (i = 0; i < caps->num_caps; i++) {
+		if (caps->caps[i].capability_type == type)
+			return &caps->caps[i];
+	}
+
+	return ERR_PTR(-EINVAL);
+}
+
+#define CAP_MIN(inst, type)	((get_cap(inst, type))->min)
+#define CAP_MAX(inst, type)	((get_cap(inst, type))->max)
+#define CAP_STEP(inst, type)	((get_cap(inst, type))->step_size)
+
+#define FRAME_WIDTH_MIN(inst)	CAP_MIN(inst, HFI_CAPABILITY_FRAME_WIDTH)
+#define FRAME_WIDTH_MAX(inst)	CAP_MAX(inst, HFI_CAPABILITY_FRAME_WIDTH)
+#define FRAME_WIDTH_STEP(inst)	CAP_STEP(inst, HFI_CAPABILITY_FRAME_WIDTH)
+
+#define FRAME_HEIGHT_MIN(inst)	CAP_MIN(inst, HFI_CAPABILITY_FRAME_HEIGHT)
+#define FRAME_HEIGHT_MAX(inst)	CAP_MAX(inst, HFI_CAPABILITY_FRAME_HEIGHT)
+#define FRAME_HEIGHT_STEP(inst)	CAP_STEP(inst, HFI_CAPABILITY_FRAME_HEIGHT)
+
+#define FRATE_MIN(inst)		CAP_MIN(inst, HFI_CAPABILITY_FRAMERATE)
+#define FRATE_MAX(inst)		CAP_MAX(inst, HFI_CAPABILITY_FRAMERATE)
+#define FRATE_STEP(inst)	CAP_STEP(inst, HFI_CAPABILITY_FRAMERATE)
+
+#endif
diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
index d22969d2758a..95892090e2f3 100644
--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -24,6 +24,7 @@
 #include <media/videobuf2-dma-sg.h>
 
 #include "hfi_venus_io.h"
+#include "hfi_parser.h"
 #include "core.h"
 #include "helpers.h"
 #include "vdec.h"
@@ -177,10 +178,10 @@ vdec_try_fmt_common(struct venus_inst *inst, struct v4l2_format *f)
 		pixmp->height = 720;
 	}
 
-	pixmp->width = clamp(pixmp->width, inst->cap_width.min,
-			     inst->cap_width.max);
-	pixmp->height = clamp(pixmp->height, inst->cap_height.min,
-			      inst->cap_height.max);
+	pixmp->width = clamp(pixmp->width, FRAME_WIDTH_MIN(inst),
+			     FRAME_WIDTH_MAX(inst));
+	pixmp->height = clamp(pixmp->height, FRAME_HEIGHT_MIN(inst),
+			      FRAME_HEIGHT_MAX(inst));
 
 	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
 		pixmp->height = ALIGN(pixmp->height, 32);
@@ -442,12 +443,12 @@ static int vdec_enum_framesizes(struct file *file, void *fh,
 
 	fsize->type = V4L2_FRMSIZE_TYPE_STEPWISE;
 
-	fsize->stepwise.min_width = inst->cap_width.min;
-	fsize->stepwise.max_width = inst->cap_width.max;
-	fsize->stepwise.step_width = inst->cap_width.step_size;
-	fsize->stepwise.min_height = inst->cap_height.min;
-	fsize->stepwise.max_height = inst->cap_height.max;
-	fsize->stepwise.step_height = inst->cap_height.step_size;
+	fsize->stepwise.min_width = FRAME_WIDTH_MIN(inst);
+	fsize->stepwise.max_width = FRAME_WIDTH_MAX(inst);
+	fsize->stepwise.step_width = FRAME_WIDTH_STEP(inst);
+	fsize->stepwise.min_height = FRAME_HEIGHT_MIN(inst);
+	fsize->stepwise.max_height = FRAME_HEIGHT_MAX(inst);
+	fsize->stepwise.step_height = FRAME_HEIGHT_STEP(inst);
 
 	return 0;
 }
@@ -902,22 +903,7 @@ static void vdec_inst_init(struct venus_inst *inst)
 	inst->fps = 30;
 	inst->timeperframe.numerator = 1;
 	inst->timeperframe.denominator = 30;
-
-	inst->cap_width.min = 64;
-	inst->cap_width.max = 1920;
-	if (inst->core->res->hfi_version == HFI_VERSION_3XX)
-		inst->cap_width.max = 3840;
-	inst->cap_width.step_size = 1;
-	inst->cap_height.min = 64;
-	inst->cap_height.max = ALIGN(1080, 32);
-	if (inst->core->res->hfi_version == HFI_VERSION_3XX)
-		inst->cap_height.max = ALIGN(2160, 32);
-	inst->cap_height.step_size = 1;
-	inst->cap_framerate.min = 1;
-	inst->cap_framerate.max = 30;
-	inst->cap_framerate.step_size = 1;
-	inst->cap_mbs_per_frame.min = 16;
-	inst->cap_mbs_per_frame.max = 8160;
+	inst->hfi_codec = HFI_VIDEO_CODEC_H264;
 }
 
 static const struct v4l2_m2m_ops vdec_m2m_ops = {
diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
index 596539d433c9..df54841c910d 100644
--- a/drivers/media/platform/qcom/venus/venc.c
+++ b/drivers/media/platform/qcom/venus/venc.c
@@ -24,6 +24,7 @@
 #include <media/v4l2-ctrls.h>
 
 #include "hfi_venus_io.h"
+#include "hfi_parser.h"
 #include "core.h"
 #include "helpers.h"
 #include "venc.h"
@@ -301,10 +302,10 @@ venc_try_fmt_common(struct venus_inst *inst, struct v4l2_format *f)
 		pixmp->height = 720;
 	}
 
-	pixmp->width = clamp(pixmp->width, inst->cap_width.min,
-			     inst->cap_width.max);
-	pixmp->height = clamp(pixmp->height, inst->cap_height.min,
-			      inst->cap_height.max);
+	pixmp->width = clamp(pixmp->width, FRAME_WIDTH_MIN(inst),
+			     FRAME_WIDTH_MAX(inst));
+	pixmp->height = clamp(pixmp->height, FRAME_HEIGHT_MIN(inst),
+			      FRAME_HEIGHT_MAX(inst));
 
 	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
 		pixmp->height = ALIGN(pixmp->height, 32);
@@ -553,12 +554,12 @@ static int venc_enum_framesizes(struct file *file, void *fh,
 	if (fsize->index)
 		return -EINVAL;
 
-	fsize->stepwise.min_width = inst->cap_width.min;
-	fsize->stepwise.max_width = inst->cap_width.max;
-	fsize->stepwise.step_width = inst->cap_width.step_size;
-	fsize->stepwise.min_height = inst->cap_height.min;
-	fsize->stepwise.max_height = inst->cap_height.max;
-	fsize->stepwise.step_height = inst->cap_height.step_size;
+	fsize->stepwise.min_width = FRAME_WIDTH_MIN(inst);
+	fsize->stepwise.max_width = FRAME_WIDTH_MAX(inst);
+	fsize->stepwise.step_width = FRAME_WIDTH_STEP(inst);
+	fsize->stepwise.min_height = FRAME_HEIGHT_MIN(inst);
+	fsize->stepwise.max_height = FRAME_HEIGHT_MAX(inst);
+	fsize->stepwise.step_height = FRAME_HEIGHT_STEP(inst);
 
 	return 0;
 }
@@ -586,18 +587,18 @@ static int venc_enum_frameintervals(struct file *file, void *fh,
 	if (!fival->width || !fival->height)
 		return -EINVAL;
 
-	if (fival->width > inst->cap_width.max ||
-	    fival->width < inst->cap_width.min ||
-	    fival->height > inst->cap_height.max ||
-	    fival->height < inst->cap_height.min)
+	if (fival->width > FRAME_WIDTH_MAX(inst) ||
+	    fival->width < FRAME_WIDTH_MIN(inst) ||
+	    fival->height > FRAME_HEIGHT_MAX(inst) ||
+	    fival->height < FRAME_HEIGHT_MIN(inst))
 		return -EINVAL;
 
 	fival->stepwise.min.numerator = 1;
-	fival->stepwise.min.denominator = inst->cap_framerate.max;
+	fival->stepwise.min.denominator = FRATE_MAX(inst);
 	fival->stepwise.max.numerator = 1;
-	fival->stepwise.max.denominator = inst->cap_framerate.min;
+	fival->stepwise.max.denominator = FRATE_MIN(inst);
 	fival->stepwise.step.numerator = 1;
-	fival->stepwise.step.denominator = inst->cap_framerate.max;
+	fival->stepwise.step.denominator = FRATE_MAX(inst);
 
 	return 0;
 }
@@ -1091,22 +1092,7 @@ static void venc_inst_init(struct venus_inst *inst)
 	inst->fps = 15;
 	inst->timeperframe.numerator = 1;
 	inst->timeperframe.denominator = 15;
-
-	inst->cap_width.min = 96;
-	inst->cap_width.max = 1920;
-	if (inst->core->res->hfi_version == HFI_VERSION_3XX)
-		inst->cap_width.max = 3840;
-	inst->cap_width.step_size = 2;
-	inst->cap_height.min = 64;
-	inst->cap_height.max = ALIGN(1080, 32);
-	if (inst->core->res->hfi_version == HFI_VERSION_3XX)
-		inst->cap_height.max = ALIGN(2160, 32);
-	inst->cap_height.step_size = 2;
-	inst->cap_framerate.min = 1;
-	inst->cap_framerate.max = 30;
-	inst->cap_framerate.step_size = 1;
-	inst->cap_mbs_per_frame.min = 24;
-	inst->cap_mbs_per_frame.max = 8160;
+	inst->hfi_codec = HFI_VIDEO_CODEC_H264;
 }
 
 static int venc_open(struct file *file)
-- 
2.14.1
