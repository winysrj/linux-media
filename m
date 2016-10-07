Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:41941 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S934666AbcJGRAL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Oct 2016 13:00:11 -0400
From: Hugues Fruchet <hugues.fruchet@st.com>
To: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
CC: <kernel@stlinux.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>
Subject: [PATCH v1 2/2] [media] st-delta: add mpeg2 support
Date: Fri, 7 Oct 2016 18:59:55 +0200
Message-ID: <1475859595-732-3-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1475859595-732-1-git-send-email-hugues.fruchet@st.com>
References: <1475859595-732-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change-Id: Ic586e3b2c7c15e76ea9aff318f8580eb3493e21b
Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 drivers/media/platform/Kconfig                     |    6 +
 drivers/media/platform/sti/delta/Makefile          |    3 +
 drivers/media/platform/sti/delta/delta-cfg.h       |    5 +
 drivers/media/platform/sti/delta/delta-mpeg2-dec.c | 1412 ++++++++++++++++++++
 drivers/media/platform/sti/delta/delta-mpeg2-fw.h  |  415 ++++++
 drivers/media/platform/sti/delta/delta-v4l2.c      |    4 +
 6 files changed, 1845 insertions(+)
 create mode 100644 drivers/media/platform/sti/delta/delta-mpeg2-dec.c
 create mode 100644 drivers/media/platform/sti/delta/delta-mpeg2-fw.h

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 29d7dee..94a71bb 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -288,6 +288,12 @@ config VIDEO_STI_DELTA_MJPEG
 	help
 		Enables DELTA MJPEG hardware support.
 
+config VIDEO_STI_DELTA_MPEG2
+	bool "STMicroelectronics DELTA MPEG2/MPEG1 support"
+	default y
+	help
+		Enables DELTA MPEG2 hardware support.
+
 endif # VIDEO_STI_DELTA
 
 config VIDEO_SH_VEU
diff --git a/drivers/media/platform/sti/delta/Makefile b/drivers/media/platform/sti/delta/Makefile
index f95580e..e509bcb 100644
--- a/drivers/media/platform/sti/delta/Makefile
+++ b/drivers/media/platform/sti/delta/Makefile
@@ -4,3 +4,6 @@ st-delta-y := delta-v4l2.o delta-mem.o delta-ipc.o delta-debug.o
 # MJPEG support
 st-delta-$(CONFIG_VIDEO_STI_DELTA_MJPEG) += delta-mjpeg-hdr.o
 st-delta-$(CONFIG_VIDEO_STI_DELTA_MJPEG) += delta-mjpeg-dec.o
+
+# MPEG2 support
+st-delta-$(CONFIG_VIDEO_STI_DELTA_MPEG2) += delta-mpeg2-dec.o
diff --git a/drivers/media/platform/sti/delta/delta-cfg.h b/drivers/media/platform/sti/delta/delta-cfg.h
index cf30e50..9129e4d 100644
--- a/drivers/media/platform/sti/delta/delta-cfg.h
+++ b/drivers/media/platform/sti/delta/delta-cfg.h
@@ -59,4 +59,9 @@
 extern const struct delta_dec mjpegdec;
 #endif
 
+#ifdef CONFIG_VIDEO_STI_DELTA_MPEG2
+extern const struct delta_dec mpeg2dec;
+extern const struct delta_dec mpeg1dec;
+#endif
+
 #endif /* DELTA_CFG_H */
diff --git a/drivers/media/platform/sti/delta/delta-mpeg2-dec.c b/drivers/media/platform/sti/delta/delta-mpeg2-dec.c
new file mode 100644
index 0000000..7885b072
--- /dev/null
+++ b/drivers/media/platform/sti/delta/delta-mpeg2-dec.c
@@ -0,0 +1,1412 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2015
+ * Authors: Hugues Fruchet <hugues.fruchet@st.com>
+ *          Chetan Nanda <chetan.nanda@st.com>
+ *          Jean-Christophe Trotin <jean-christophe.trotin@st.com>
+ *          for STMicroelectronics.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#include "delta.h"
+#include "delta-ipc.h"
+#include "delta-mem.h"
+#include "delta-mpeg2-fw.h"
+
+#define DELTA_MPEG2_MAX_RESO DELTA_MAX_RESO
+
+/* minimal number of frames for decoding = 1 dec + 2 refs frames */
+#define DELTA_MPEG2_DPB_FRAMES_NEEDED     3
+
+struct delta_mpeg2_ctx {
+	/* ipc */
+	void *ipc_hdl;
+	struct delta_buf *ipc_buf;
+
+	/* stream information */
+	struct delta_streaminfo streaminfo;
+
+	unsigned int header_parsed;
+
+	/* reference frames mgt */
+	struct delta_mpeg2_frame *prev_ref_frame;
+	struct delta_mpeg2_frame *next_ref_frame;
+
+	/* output frames reordering management */
+	struct delta_frame *out_frame;
+	struct delta_frame *delayed_frame;
+
+	/* interlaced frame management */
+	struct delta_frame *last_frame;
+	enum mpeg2_picture_structure_t accumulated_picture_structure;
+
+	unsigned char str[3000];
+};
+
+/* codec specific frame struct */
+struct delta_mpeg2_frame {
+	struct delta_frame frame;
+	struct timeval dts;
+	struct delta_buf omega_buf;	/* 420mb buffer for decoding */
+};
+
+#define to_ctx(ctx) ((struct delta_mpeg2_ctx *)ctx->priv)
+#define to_mpeg2_frame(frame) ((struct delta_mpeg2_frame *)frame)
+#define to_frame(mpeg2_frame) ((struct delta_frame *)mpeg2_frame)
+
+static u8 default_intra_matrix[] = {
+	/* non-scan ordered */
+	0x08, 0x10, 0x13, 0x16, 0x1a, 0x1b, 0x1d, 0x22,
+	0x10, 0x10, 0x16, 0x18, 0x1b, 0x1d, 0x22, 0x25,
+	0x13, 0x16, 0x1a, 0x1b, 0x1d, 0x22, 0x22, 0x26,
+	0x16, 0x16, 0x1a, 0x1b, 0x1d, 0x22, 0x25, 0x28,
+	0x16, 0x1a, 0x1B, 0x1d, 0x20, 0x23, 0x28, 0x30,
+	0x1a, 0x1b, 0x1d, 0x20, 0x23, 0x28, 0x30, 0x3a,
+	0x1a, 0x1b, 0x1d, 0x22, 0x26, 0x2e, 0x38, 0x45,
+	0x1b, 0x1d, 0x23, 0x26, 0x2e, 0x38, 0x45, 0x53
+};
+
+static u8 default_non_intra_matrix[] = {
+	0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10,
+	0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10,
+	0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10,
+	0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10,
+	0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10,
+	0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10,
+	0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10,
+	0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10
+};
+
+static inline const char *profile_str(unsigned int p)
+{
+	switch (p) {
+	case 1:
+		return "High profile (HP)";
+	case 2:
+		return "Spatially scalable profile (Spatial)";
+	case 3:
+		return "SNR Scalable profile (SNR)";
+	case 4:
+		return "Main profile (MP)";
+	case 5:
+		return "Simple profile (SP)";
+	case 130:
+		return "422@HL profile";
+	case 133:
+		return "422@ML profile";
+	default:
+		return "unknown profile";
+	}
+}
+
+static inline const char *level_str(unsigned int l)
+{
+	switch (l) {
+	case 4:
+		return "High level (HL)";
+	case 6:
+		return "High 1440 level (H-14)";
+	case 8:
+		return "Main level (ML)";
+	case 10:
+		return "Low level (LL)";
+	default:
+		return "unknown level";
+	}
+}
+
+static inline const char *chroma_str(unsigned int c)
+{
+	switch (c) {
+	case MPEG2_CHROMA_4_2_0:
+		return "4:2:0";
+	case MPEG2_CHROMA_4_2_2:
+		return "4:2:2";
+	case MPEG2_CHROMA_4_4_4:
+		return "4:4:4";
+	default:
+		return "unknown chroma";
+	}
+}
+
+static char *ipc_open_param_str(struct mpeg2_init_transformer_param_t *p,
+				char *str, unsigned int len)
+{
+	if (!p)
+		return NULL;
+
+	snprintf(str, len,
+		 "mpeg2_init_transformer_param_t size=%zu\n"
+		 "input_buffer_begin\t%d\n"
+		 "input_buffer_end\t%d\n",
+		 sizeof(*p),
+		 p->input_buffer_begin,
+		 p->input_buffer_end);
+
+	return str;
+}
+
+static char *ipc_stream_param_str(struct mpeg2_set_global_param_sequence_t *p,
+				  char *str, unsigned int len)
+{
+	if (!p)
+		return NULL;
+
+	snprintf(str, len,
+		 "mpeg2_set_global_param_sequence_t size=%zu\n"
+		 "mpeg_stream_type_flag\t%d\n"
+		 "horizontal_size\t\t%d\n"
+		 "vertical_size\t\t%d\n"
+		 "progressive_sequence\t%d\n"
+		 "chroma_format\t\t%d\n"
+		 "matrix_flags\t\t0x%x\n"
+		 "intra_quantiser_matrix\t\t%02x %02x %02x %02x %02x %02x %02x %02x\n"
+		 "non_intra_quantiser_matrix\t%02x %02x %02x %02x %02x %02x %02x %02x\n"
+		 "chroma_intra_quantiser_matrix\t%02x %02x %02x %02x %02x %02x %02x %02x\n"
+		 "chroma_non_intra_quantiser_matrix\t%02x %02x %02x %02x %02x %02x %02x %02x\n",
+		 sizeof(*p),
+		 p->mpeg_stream_type_flag,
+		 p->horizontal_size,
+		 p->vertical_size,
+		 p->progressive_sequence,
+		 p->chroma_format,
+		 p->matrix_flags,
+		 p->intra_quantiser_matrix[0],
+		 p->intra_quantiser_matrix[1],
+		 p->intra_quantiser_matrix[2],
+		 p->intra_quantiser_matrix[3],
+		 p->intra_quantiser_matrix[4],
+		 p->intra_quantiser_matrix[5],
+		 p->intra_quantiser_matrix[6],
+		 p->intra_quantiser_matrix[7],
+		 p->non_intra_quantiser_matrix[0],
+		 p->non_intra_quantiser_matrix[1],
+		 p->non_intra_quantiser_matrix[2],
+		 p->non_intra_quantiser_matrix[3],
+		 p->non_intra_quantiser_matrix[4],
+		 p->non_intra_quantiser_matrix[5],
+		 p->non_intra_quantiser_matrix[6],
+		 p->non_intra_quantiser_matrix[7],
+		 p->chroma_intra_quantiser_matrix[0],
+		 p->chroma_intra_quantiser_matrix[1],
+		 p->chroma_intra_quantiser_matrix[2],
+		 p->chroma_intra_quantiser_matrix[3],
+		 p->chroma_intra_quantiser_matrix[4],
+		 p->chroma_intra_quantiser_matrix[5],
+		 p->chroma_intra_quantiser_matrix[6],
+		 p->chroma_intra_quantiser_matrix[7],
+		 p->chroma_non_intra_quantiser_matrix[0],
+		 p->chroma_non_intra_quantiser_matrix[1],
+		 p->chroma_non_intra_quantiser_matrix[2],
+		 p->chroma_non_intra_quantiser_matrix[3],
+		 p->chroma_non_intra_quantiser_matrix[4],
+		 p->chroma_non_intra_quantiser_matrix[5],
+		 p->chroma_non_intra_quantiser_matrix[6],
+		 p->chroma_non_intra_quantiser_matrix[7]);
+
+	return str;
+}
+
+static char *ipc_decode_param_str(struct mpeg2_transform_param_t *p,
+				  char *str, unsigned int len)
+{
+	char *cur = str;
+	unsigned int left = len;
+	unsigned int cnt;
+
+	if (!p)
+		return NULL;
+
+	cnt = snprintf(cur, left,
+		       "mpeg2_transform_param_t, size=%zu\n"
+		       "picture_start_addr\t\t%x\n"
+		       "picture_stop_addr\t\t%x\n"
+		       "main_aux_enable\t\t\t%d\n"
+		       "decoding_mode\t\t\t%d\n"
+		       "additional_flags\t\t\t0x%x\n"
+		       "[decoded_buffer]\n"
+		       " decoded_luma_p\t\t\t%x\n"
+		       " decoded_chroma_p\t\t%x\n"
+		       " decoded_temporal_reference\t%x\n"
+		       " display_luma_p\t\t\t%x\n"
+		       " display_chroma_p\t\t%x\n"
+		       "[ref_pic_list]\n"
+		       " backward_reference_luma_p\t%x\n"
+		       " backward_reference_chroma_p\t%x\n"
+		       " backward_temporal_reference\t%d\n"
+		       " forward_reference_luma_p\t%x\n"
+		       " forward_reference_chroma_p\t%x\n"
+		       " forward_temporal_reference\t%d\n"
+		       "[picture_parameters]\n"
+		       " picture_coding_type\t\t%d\n"
+		       " forward_horizontal_f_code\t%d\n"
+		       " forward_vertical_f_code\t\t%d\n"
+		       " backward_horizontal_f_code\t%d\n"
+		       " backward_vertical_f_code\t%d\n"
+		       " intra_dc_precision\t\t%d\n"
+		       " picture_structure\t\t%d\n"
+		       " mpeg_decoding_flags\t\t0x%x\n",
+		       sizeof(*p),
+		       p->picture_start_addr_compressed_buffer_p,
+		       p->picture_stop_addr_compressed_buffer_p,
+		       p->main_aux_enable,
+		       p->decoding_mode,
+		       p->additional_flags,
+		       p->decoded_buffer_address.decoded_luma_p,
+		       p->decoded_buffer_address.decoded_chroma_p,
+		       p->decoded_buffer_address.
+				decoded_temporal_reference_value,
+		       p->display_buffer_address.display_luma_p,
+		       p->display_buffer_address.display_chroma_p,
+		       p->ref_pic_list_address.backward_reference_luma_p,
+		       p->ref_pic_list_address.backward_reference_chroma_p,
+		       p->ref_pic_list_address.
+				backward_temporal_reference_value,
+		       p->ref_pic_list_address.forward_reference_luma_p,
+		       p->ref_pic_list_address.forward_reference_chroma_p,
+		       p->ref_pic_list_address.forward_temporal_reference_value,
+		       p->picture_parameters.picture_coding_type,
+		       p->picture_parameters.forward_horizontal_f_code,
+		       p->picture_parameters.forward_vertical_f_code,
+		       p->picture_parameters.backward_horizontal_f_code,
+		       p->picture_parameters.backward_vertical_f_code,
+		       p->picture_parameters.intra_dc_precision,
+		       p->picture_parameters.picture_structure,
+		       p->picture_parameters.mpeg_decoding_flags);
+
+	return str;
+}
+
+static inline char *picture_coding_type_str(unsigned int type)
+{
+	switch (type) {
+	case MPEG2_INTRA_PICTURE:
+		return "I";
+	case MPEG2_DC_INTRA_PICTURE:
+		return "I(DC)";
+	case MPEG2_PREDICTIVE_PICTURE:
+		return "P";
+	case MPEG2_BIDIRECTIONAL_PICTURE:
+		return "B";
+	default:
+		return "unknown picture coding type";
+	}
+}
+
+static inline char *picture_structure_str(enum mpeg2_picture_structure_t s)
+{
+	switch (s) {
+	case MPEG2_RESERVED_TYPE:
+		return "X";
+	case MPEG2_TOP_FIELD_TYPE:
+		return "T";
+	case MPEG2_BOTTOM_FIELD_TYPE:
+		return "B";
+	case MPEG2_FRAME_TYPE:
+		return "F";
+	default:
+		return "unknown picture structure";
+	}
+}
+
+static inline void to_v4l2_frame_type(unsigned int type, __u32 *flags)
+{
+	switch (type) {
+	case MPEG2_INTRA_PICTURE:
+	case MPEG2_DC_INTRA_PICTURE:
+		*flags |= V4L2_BUF_FLAG_KEYFRAME;
+		break;
+	case MPEG2_PREDICTIVE_PICTURE:
+		*flags |= V4L2_BUF_FLAG_PFRAME;
+		break;
+	case MPEG2_BIDIRECTIONAL_PICTURE:
+		*flags |= V4L2_BUF_FLAG_BFRAME;
+		break;
+	default:
+		*flags |= V4L2_BUF_FLAG_ERROR;
+	}
+}
+
+static inline enum v4l2_field to_v4l2_field_type(bool interlaced,
+						 bool top_field_first)
+{
+	if (interlaced)
+		return (top_field_first ? V4L2_FIELD_INTERLACED_TB :
+					  V4L2_FIELD_INTERLACED_BT);
+	else
+		return V4L2_FIELD_NONE;
+}
+
+static inline const char *err_str(enum mpeg2_decoding_error_t err)
+{
+	switch (err) {
+	case MPEG2_DECODER_NO_ERROR:
+		return "MPEG2_DECODER_NO_ERROR";
+	case MPEG2_DECODER_ERROR_TASK_TIMEOUT:
+		return "MPEG2_DECODER_ERROR_TASK_TIMEOUT";
+	case MPEG2_DECODER_ERROR_MB_OVERFLOW:
+		return "MPEG2_DECODER_ERROR_MB_OVERFLOW";
+	case MPEG2_DECODER_ERROR_NOT_RECOVERED:
+		return "MPEG2_DECODER_ERROR_NOT_RECOVERED";
+	case MPEG2_DECODER_ERROR_RECOVERED:
+		return "MPEG2_DECODER_ERROR_RECOVERED";
+	case MPEG2_DECODER_ERROR_FEATURE_NOT_SUPPORTED:
+		return "MPEG2_DECODER_ERROR_FEATURE_NOT_SUPPORTED";
+	default:
+		return "unknown mpeg2 error";
+	}
+}
+
+static inline bool is_stream_error(enum mpeg2_decoding_error_t err)
+{
+	switch (err) {
+	case MPEG2_DECODER_ERROR_MB_OVERFLOW:
+	case MPEG2_DECODER_ERROR_RECOVERED:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static int compute_corrupted_mbs(struct mpeg2_command_status_t *status)
+{
+	unsigned int i;
+	unsigned int j;
+	unsigned int cnt = 0;
+
+	for (i = 0; i < MPEG2_STATUS_PARTITION; i++)
+		for (j = 0; j < MPEG2_STATUS_PARTITION; j++)
+			cnt += status->status[i][j];
+
+	return cnt;
+}
+
+static bool delta_mpeg2_check_status(struct delta_ctx *pctx,
+				     struct mpeg2_command_status_t *status)
+{
+	struct delta_dev *delta = pctx->dev;
+	bool dump = false;
+
+	if (status->error_code == MPEG2_DECODER_NO_ERROR)
+		goto out;
+
+	if (is_stream_error(status->error_code)) {
+		dev_warn_ratelimited(delta->dev,
+				     "%s  firmware: stream error @ frame %d (%s)\n",
+				     pctx->name, pctx->decoded_frames,
+				     err_str(status->error_code));
+		pctx->stream_errors++;
+
+		if (status->error_code & MPEG2_DECODER_ERROR_RECOVERED) {
+			/* errors, but recovered,
+			 * update corrupted MBs stats
+			 */
+			unsigned int corrupted = compute_corrupted_mbs(status);
+
+			if (corrupted)
+				dev_warn_ratelimited(delta->dev,
+						     "%s  firmware: %d MBs corrupted @ frame %d\n",
+						     pctx->name,
+						     corrupted,
+						     pctx->decoded_frames);
+		}
+	} else {
+		dev_warn_ratelimited(delta->dev,
+				     "%s  firmware: decode error @ frame %d (%s)\n",
+				     pctx->name, pctx->decoded_frames,
+				     err_str(status->error_code));
+		pctx->decode_errors++;
+		dump = true;
+	}
+
+out:
+	dev_dbg(delta->dev,
+		"%s  firmware: mean QP=%d variance QP=%d\n", pctx->name,
+		status->picture_mean_qp, status->picture_variance_qp);
+
+	dev_dbg(delta->dev,
+		"%s  firmware: decoding time(us)=%d\n", pctx->name,
+		status->decode_time_in_micros);
+	return dump;
+}
+
+static int delta_mpeg2_ipc_open(struct delta_ctx *pctx)
+{
+	struct delta_dev *delta = pctx->dev;
+	struct delta_mpeg2_ctx *ctx = to_ctx(pctx);
+	int ret = 0;
+	struct mpeg2_init_transformer_param_t params_struct;
+	struct mpeg2_init_transformer_param_t *params = &params_struct;
+	struct delta_ipc_param ipc_param;
+	struct delta_buf *ipc_buf;
+	__u32 ipc_buf_size;
+	void *hdl;
+
+	dev_dbg(delta->dev, "%s  > %s\n", pctx->name, __func__);
+
+	memset(params, 0, sizeof(*params));
+	params->input_buffer_begin = 0x00000000;
+	params->input_buffer_end = 0xffffffff;
+
+	dev_vdbg(delta->dev,
+		 "%s  %s\n", pctx->name,
+		 ipc_open_param_str(params, ctx->str, sizeof(ctx->str)));
+
+	ipc_param.size = sizeof(*params);
+	ipc_param.data = params;
+	ipc_buf_size = sizeof(struct mpeg2_transform_param_t) +
+		       sizeof(struct mpeg2_command_status_t);
+	ret = delta_ipc_open(pctx, "MPEG2_TRANSFORMER0", &ipc_param,
+			     ipc_buf_size, &ipc_buf, &hdl);
+	if (ret) {
+		dev_err(delta->dev,
+			"%s  dumping command %s\n", pctx->name,
+			ipc_open_param_str(params, ctx->str, sizeof(ctx->str)));
+		return ret;
+	}
+
+	ctx->ipc_buf = ipc_buf;
+	ctx->ipc_hdl = hdl;
+
+	dev_dbg(delta->dev, "%s  < %s\n", pctx->name, __func__);
+	return 0;
+}
+
+static int delta_mpeg2_ipc_set_stream(struct delta_ctx *pctx,
+				      struct mpeg2_meta_seq *meta_seq)
+{
+	struct delta_dev *delta = pctx->dev;
+	struct delta_mpeg2_ctx *ctx = to_ctx(pctx);
+	const struct delta_dec *dec = pctx->dec;
+	int ret;
+
+	struct mpeg2_set_global_param_sequence_t *params = ctx->ipc_buf->vaddr;
+	struct mpeg_video_sequence_hdr *seq_header = NULL;
+	struct mpeg_video_sequence_ext *seq_ext_header = NULL;
+	struct mpeg_video_quant_matrix_ext *matrix_ext = NULL;
+	struct delta_ipc_param ipc_param;
+
+	unsigned char *intra_quantizer_matrix;
+	unsigned char *non_intra_quantizer_matrix;
+	unsigned char *chroma_intra_quantizer_matrix;
+	unsigned char *chroma_non_intra_quantizer_matrix;
+
+	dev_dbg(delta->dev, "%s  > %s\n", pctx->name, __func__);
+
+	if (!(meta_seq->flags & MPEG2_META_SEQ_FLAG_HDR)) {
+		dev_err(delta->dev, "%s  failed to set stream on ipc, no header in meta sequence\n",
+			pctx->name);
+		return -EINVAL;
+	}
+	seq_header = &meta_seq->seq_h;
+
+	if (meta_seq->flags & MPEG2_META_SEQ_FLAG_EXT)
+		seq_ext_header = &meta_seq->seq_e;
+	if (meta_seq->flags & MPEG2_META_SEQ_FLAG_MATRIX_EXT)
+		matrix_ext = &meta_seq->qua_m;
+
+	memset(params, 0, sizeof(*params));
+	params->struct_size = sizeof(*params);
+
+	/* Sequence header */
+	params->mpeg_stream_type_flag =
+		(dec->streamformat == V4L2_PIX_FMT_MPEG2) ? 1 : 0;
+
+	params->horizontal_size = seq_header->width;
+	params->vertical_size = seq_header->height;
+	params->progressive_sequence = true;
+	params->chroma_format = MPEG2_CHROMA_4_2_0;
+
+	params->matrix_flags =
+		(seq_header->load_intra_flag ?
+		 MPEG2_LOAD_INTRA_QUANTIZER_MATRIX_FLAG : 0) |
+		(seq_header->load_non_intra_flag ?
+		 MPEG2_LOAD_NON_INTRA_QUANTIZER_MATRIX_FLAG : 0);
+
+	/* Sequence header, matrix part */
+	intra_quantizer_matrix =
+		seq_header->load_intra_flag ?
+			seq_header->intra_quantiser_matrix :
+			default_intra_matrix;
+	chroma_intra_quantizer_matrix = intra_quantizer_matrix;
+
+	non_intra_quantizer_matrix =
+		seq_header->load_non_intra_flag ?
+			seq_header->non_intra_quantiser_matrix :
+			default_non_intra_matrix;
+	chroma_non_intra_quantizer_matrix = non_intra_quantizer_matrix;
+
+	/* Sequence header extension */
+	if (seq_ext_header) {
+		params->horizontal_size |=
+		    (seq_ext_header->horiz_size_ext << 12);
+		params->vertical_size |= (seq_ext_header->vert_size_ext << 12);
+		params->progressive_sequence = seq_ext_header->progressive;
+		params->chroma_format =
+			(enum mpeg2_chroma_format_t)seq_ext_header->chroma_format;
+	}
+
+	/* Matrix extension */
+	if (matrix_ext) {
+		params->matrix_flags =
+			(matrix_ext->load_intra_quantiser_matrix ?
+			 MPEG2_LOAD_INTRA_QUANTIZER_MATRIX_FLAG : 0) |
+			(matrix_ext->load_non_intra_quantiser_matrix ?
+			 MPEG2_LOAD_NON_INTRA_QUANTIZER_MATRIX_FLAG : 0);
+
+		intra_quantizer_matrix =
+			matrix_ext->load_intra_quantiser_matrix ?
+				matrix_ext->intra_quantiser_matrix :
+				default_intra_matrix;
+		chroma_intra_quantizer_matrix =
+			matrix_ext->load_chroma_intra_quantiser_matrix ?
+				matrix_ext->chroma_intra_quantiser_matrix :
+				default_intra_matrix;
+
+		non_intra_quantizer_matrix =
+			matrix_ext->load_non_intra_quantiser_matrix ?
+				matrix_ext->non_intra_quantiser_matrix :
+				default_non_intra_matrix;
+		chroma_non_intra_quantizer_matrix =
+			matrix_ext->load_chroma_non_intra_quantiser_matrix ?
+				matrix_ext->chroma_non_intra_quantiser_matrix :
+				default_non_intra_matrix;
+	}
+
+	memcpy(params->intra_quantiser_matrix,
+		intra_quantizer_matrix,
+		sizeof(params->intra_quantiser_matrix));
+	memcpy(params->non_intra_quantiser_matrix,
+		non_intra_quantizer_matrix,
+		sizeof(params->non_intra_quantiser_matrix));
+	memcpy(params->chroma_intra_quantiser_matrix,
+		chroma_intra_quantizer_matrix,
+		sizeof(params->chroma_intra_quantiser_matrix));
+	memcpy(params->chroma_non_intra_quantiser_matrix,
+		chroma_non_intra_quantizer_matrix,
+		sizeof(params->chroma_non_intra_quantiser_matrix));
+
+	dev_vdbg(delta->dev,
+		 "%s  %s\n", pctx->name,
+		 ipc_stream_param_str(params, ctx->str, sizeof(ctx->str)));
+
+	ipc_param.size = sizeof(*params);
+	ipc_param.data = params;
+	ret = delta_ipc_set_stream(ctx->ipc_hdl, &ipc_param);
+	if (ret) {
+		dev_err(delta->dev,
+			"%s  dumping command %s\n", pctx->name,
+			ipc_stream_param_str(params, ctx->str,
+					     sizeof(ctx->str)));
+		return ret;
+	}
+
+	dev_dbg(delta->dev, "%s  < %s\n", pctx->name, __func__);
+	return 0;
+}
+
+static int delta_mpeg2_ipc_decode(struct delta_ctx *pctx, struct delta_au *pau,
+				  struct mpeg2_meta_pic *pmeta_pic)
+{
+	struct delta_dev *delta = pctx->dev;
+	struct delta_mpeg2_ctx *ctx = to_ctx(pctx);
+	struct delta_au au = *pau;
+	struct mpeg2_meta_pic *meta_pic = pmeta_pic;
+	int ret = 0;
+	struct delta_mpeg2_frame *mpeg2_frame = NULL;
+	struct delta_frame *frame = NULL;
+	struct delta_mpeg2_frame *next_ref_frame = ctx->next_ref_frame;
+	struct delta_mpeg2_frame *prev_ref_frame = ctx->prev_ref_frame;
+	struct mpeg2_transform_param_t *params = ctx->ipc_buf->vaddr;
+	struct mpeg2_command_status_t *status = ctx->ipc_buf->vaddr +
+						sizeof(*params);
+	struct mpeg2_decoded_buffer_address_t *params_dec;
+	struct mpeg2_param_picture_t *params_pic;
+	struct mpeg2_display_buffer_address_t *params_disp;
+	struct mpeg2_ref_pic_list_address_t *params_ref;
+	struct mpeg_video_picture_hdr *pic_header = NULL;
+	struct mpeg_video_picture_ext *pic_ext_header = NULL;
+	struct delta_ipc_param ipc_param, ipc_status;
+	enum mpeg2_picture_structure_t picture_structure = MPEG2_FRAME_TYPE;
+	bool interlaced = false;
+	bool top_field_first = true;
+
+	dev_dbg(delta->dev, "%s  > %s\n", pctx->name, __func__);
+
+	ctx->out_frame = NULL;
+
+next_field:
+
+	if ((au.size <= 0) || (au.size < meta_pic->offset)) {
+		dev_err(delta->dev, "%s  invalid access unit size (%d)\n",
+			pctx->name, au.size);
+		return -EINVAL;
+	}
+
+	dev_dbg(delta->dev, "%s  processing au[%p/%pad, %d], offset=%lu\n",
+		pctx->name, au.vaddr, &au.paddr, au.size, meta_pic->offset);
+
+	au.vaddr = pau->vaddr + meta_pic->offset;
+	au.paddr = pau->paddr + meta_pic->offset;
+	au.size = pau->size - meta_pic->offset;
+
+	if (!(meta_pic->flags & MPEG2_META_PIC_FLAG_HDR)) {
+		dev_err(delta->dev, "%s  failed to decode, no header in meta picture\n",
+			pctx->name);
+		return -EINVAL;
+	}
+	pic_header = &meta_pic->pic_h;
+
+	if (meta_pic->flags & MPEG2_META_PIC_FLAG_EXT)
+		pic_ext_header = &meta_pic->pic_e;
+
+	/* progressive/interlaced frame,
+	 * if interlaced, picture can be either a frame,
+	 * a top field or a bottom field
+	 */
+	if (pic_ext_header &&
+	    (pic_ext_header->picture_structure != MPEG2_RESERVED_TYPE))
+		picture_structure = pic_ext_header->picture_structure;
+	else
+		picture_structure = MPEG2_FRAME_TYPE;
+	/* store frame, top+bottom or bottom+top fields sequence */
+	ctx->accumulated_picture_structure |= picture_structure;
+
+	if (pic_ext_header) {
+		interlaced = !pic_ext_header->progressive_frame;
+		top_field_first = pic_ext_header->top_field_first;
+	}
+
+	/* recalculate top_field_first as it is always set to false
+	 * in case of field picture decoding...
+	 */
+	if (picture_structure != MPEG2_FRAME_TYPE)
+		top_field_first =
+			((!ctx->last_frame) ==
+			 (picture_structure == MPEG2_TOP_FIELD_TYPE));
+
+	if (!ctx->last_frame) {
+		/* Progressive frame to be decoded or
+		 * first field of an interlaced frame to be decoded
+		 */
+		ret = delta_get_free_frame(pctx, &frame);
+		if (ret)
+			return ret;
+		mpeg2_frame = to_mpeg2_frame(frame);
+	} else {
+		/* 2 fields decoding are needed to get 1 frame
+		 * and the first field has already been decoded
+		 */
+		frame = ctx->last_frame;
+		mpeg2_frame = to_mpeg2_frame(frame);
+	}
+
+	memset(params, 0, sizeof(*params));
+	params->struct_size = sizeof(*params);
+
+	params->picture_start_addr_compressed_buffer_p =
+		(u32)(au.paddr);
+	params->picture_stop_addr_compressed_buffer_p =
+		(u32)(au.paddr + au.size - 1);
+
+	params->main_aux_enable = MPEG2_REF_MAIN_DISP_MAIN_AUX_EN;
+	params->horizontal_decimation_factor = MPEG2_HDEC_1;
+	params->vertical_decimation_factor = MPEG2_VDEC_1;
+
+	params->decoding_mode = MPEG2_NORMAL_DECODE;
+	params->additional_flags = MPEG2_ADDITIONAL_FLAG_NONE;
+
+	params_dec = &params->decoded_buffer_address;
+	params_dec->struct_size = sizeof(*params_dec);
+	params_dec->decoded_luma_p =
+		(u32)mpeg2_frame->omega_buf.paddr;
+	params_dec->decoded_chroma_p =
+		(u32)(mpeg2_frame->omega_buf.paddr +
+				  (to_frame(mpeg2_frame))->info.aligned_width *
+				  (to_frame(mpeg2_frame))->info.aligned_height);
+
+	params_dec->decoded_temporal_reference_value = pic_header->tsn;
+
+	params_disp = &params->display_buffer_address;
+	params_disp->struct_size = sizeof(*params_disp);
+	params_disp->display_luma_p = (u32)frame->paddr;
+	params_disp->display_chroma_p =
+		(u32)(frame->paddr +
+				  frame->info.aligned_width *
+				  frame->info.aligned_height);
+	params_pic = &params->picture_parameters;
+	params_pic->struct_size = sizeof(*params_pic);
+	params_pic->picture_coding_type =
+		(enum mpeg2_picture_coding_type_t)pic_header->pic_type;
+
+	/* if not enough ref frames, skip... */
+	if ((params_pic->picture_coding_type == MPEG2_BIDIRECTIONAL_PICTURE) &&
+	    (!(prev_ref_frame && next_ref_frame))) {
+		dev_warn(delta->dev,
+			 "%s  B frame missing references (prev=%p, next=%p) @ frame %d\n",
+			 pctx->name,
+			 prev_ref_frame, next_ref_frame, pctx->decoded_frames);
+		pctx->dropped_frames++;
+		goto out;
+	}
+
+	if (pic_ext_header) {
+		params_pic->forward_horizontal_f_code =
+			pic_ext_header->f_code[0][0];
+		params_pic->forward_vertical_f_code =
+			pic_ext_header->f_code[0][1];
+		params_pic->backward_horizontal_f_code =
+			pic_ext_header->f_code[1][0];
+		params_pic->backward_vertical_f_code =
+			pic_ext_header->f_code[1][1];
+		params_pic->intra_dc_precision =
+			(enum mpeg2_intra_dc_precision_t)
+				pic_ext_header->intra_dc_precision;
+		params_pic->picture_structure =
+			(enum mpeg2_picture_structure_t) picture_structure;
+		params_pic->mpeg_decoding_flags =
+			(pic_ext_header->top_field_first << 0) |
+			(pic_ext_header->frame_pred_frame_dct << 1) |
+			(pic_ext_header->concealment_motion_vectors << 2) |
+			(pic_ext_header->q_scale_type << 3) |
+			(pic_ext_header->intra_vlc_format << 4) |
+			(pic_ext_header->alternate_scan << 5) |
+			(pic_ext_header->progressive_frame << 6);
+
+		if (picture_structure == MPEG2_TOP_FIELD_TYPE)
+			params->additional_flags = top_field_first ?
+				MPEG2_ADDITIONAL_FLAG_FIRST_FIELD :
+				MPEG2_ADDITIONAL_FLAG_SECOND_FIELD;
+		else if (picture_structure == MPEG2_BOTTOM_FIELD_TYPE)
+			params->additional_flags = top_field_first ?
+				MPEG2_ADDITIONAL_FLAG_SECOND_FIELD :
+				MPEG2_ADDITIONAL_FLAG_FIRST_FIELD;
+	} else {
+		params_pic->forward_horizontal_f_code =
+			pic_header->full_pel_forward_vector;
+		params_pic->forward_vertical_f_code =
+			pic_header->f_f_code;
+		params_pic->backward_horizontal_f_code =
+			pic_header->full_pel_backward_vector;
+		params_pic->backward_vertical_f_code =
+			pic_header->b_f_code;
+		params_pic->intra_dc_precision =
+			MPEG2_INTRA_DC_PRECISION_8_BITS;
+		params_pic->picture_structure = MPEG2_FRAME_TYPE;
+		params_pic->mpeg_decoding_flags =
+			MPEG_DECODING_FLAGS_TOP_FIELD_FIRST |
+			MPEG_DECODING_FLAGS_PROGRESSIVE_FRAME;
+	}
+
+	params_ref = &params->ref_pic_list_address;
+	params_ref->struct_size = sizeof(*params_ref);
+	/*
+	 * MPEG2 transformer always takes past reference in Forward field (P
+	 * or B frames) and future reference in Backward field (B frames).
+	 * This complies with recommendation naming.
+	 * In contrast, MPEG4 transformer is bugged and uses Backward field for
+	 * P frames past reference (B frames decoding is ok).
+	 */
+	if (params_pic->picture_coding_type == MPEG2_PREDICTIVE_PICTURE) {
+		/*
+		 * a P frame AU needs the most recently decoded reference as
+		 * past ref: this is the one pointed by next_ref_frame
+		 */
+		if (next_ref_frame) {
+			params_ref->forward_reference_luma_p =
+				(u32)next_ref_frame->omega_buf.
+				paddr;
+			params_ref->forward_reference_chroma_p =
+				(u32)(next_ref_frame->omega_buf.
+						  paddr +
+						  (to_frame(next_ref_frame))->
+						  info.aligned_width *
+						  (to_frame(next_ref_frame))->
+						  info.aligned_height);
+			params_ref->forward_temporal_reference_value =
+				pic_header->tsn - 1;
+		}
+	}
+
+	if (params_pic->picture_coding_type == MPEG2_BIDIRECTIONAL_PICTURE) {
+		/*
+		 * Most recently decoded ref frame (in next_ref_frame) was
+		 * intended as a future reference frame for the current batch
+		 * of B frames. The related past reference frame is the
+		 * one even before that, in prev_next_frame
+		 */
+		if (prev_ref_frame) {
+			params_ref->forward_reference_luma_p =
+				(u32)prev_ref_frame->omega_buf.
+				paddr;
+			params_ref->forward_reference_chroma_p =
+				(u32)(prev_ref_frame->omega_buf.
+						  paddr +
+						  (to_frame(prev_ref_frame))->
+						  info.aligned_width *
+						  (to_frame(prev_ref_frame))->
+						  info.aligned_height);
+			params_ref->forward_temporal_reference_value =
+				pic_header->tsn - 1;
+		}
+		if (next_ref_frame) {
+			params_ref->backward_reference_luma_p =
+				(u32)next_ref_frame->omega_buf.
+				paddr;
+			params_ref->backward_reference_chroma_p =
+				(u32)(next_ref_frame->omega_buf.
+						  paddr +
+						  (to_frame(next_ref_frame))->
+						  info.aligned_width *
+						  (to_frame(next_ref_frame))->
+						  info.aligned_height);
+			params_ref->backward_temporal_reference_value =
+				pic_header->tsn + 1;
+		}
+	}
+
+	dev_vdbg(delta->dev,
+		 "%s  %s\n", pctx->name,
+		 ipc_decode_param_str(params, ctx->str, sizeof(ctx->str)));
+
+	/* status */
+	memset(status, 0, sizeof(*status));
+	status->struct_size = sizeof(*status);
+	status->error_code = MPEG2_DECODER_NO_ERROR;
+
+	ipc_param.size = sizeof(*params);
+	ipc_param.data = params;
+	ipc_status.size = sizeof(*status);
+	ipc_status.data = status;
+	ret = delta_ipc_decode(ctx->ipc_hdl, &ipc_param, &ipc_status);
+	if (ret) {
+		dev_err(delta->dev,
+			"%s  dumping command %s\n", pctx->name,
+			ipc_decode_param_str(params, ctx->str,
+					     sizeof(ctx->str)));
+		return ret;
+	}
+
+	pctx->decoded_frames++;
+
+	/* check firmware decoding status */
+	if (delta_mpeg2_check_status(pctx, status)) {
+		dev_err(delta->dev,
+			"%s  dumping command %s\n", pctx->name,
+			ipc_decode_param_str(params, ctx->str,
+					     sizeof(ctx->str)));
+	}
+
+	mpeg2_frame->dts.tv_usec = pic_header->tsn;
+	frame->state |= DELTA_FRAME_DEC;
+	frame->flags = 0;
+	to_v4l2_frame_type(params_pic->picture_coding_type,
+			   &frame->flags);
+	frame->field = to_v4l2_field_type(interlaced, top_field_first);
+
+	dev_dbg(delta->dev, "%s  dec frame[%d] tref=%03lu type=%s pic=%s cnt=%03d %s\n",
+		pctx->name,
+		(to_frame(mpeg2_frame))->index,
+		mpeg2_frame->dts.tv_usec,
+		picture_coding_type_str(params_pic->picture_coding_type),
+		picture_structure_str(picture_structure),
+		pctx->decoded_frames,
+		frame_state_str(frame->state, ctx->str, sizeof(ctx->str)));
+
+	/* check if the frame has been entirely decoded (progressive frame
+	 * decoded or all fields of an interlaced frame decoded
+	 */
+	if (ctx->accumulated_picture_structure == MPEG2_FRAME_TYPE) {
+		/* Update reference frames & output ordering */
+		switch (params_pic->picture_coding_type) {
+		case MPEG2_INTRA_PICTURE:
+			if ((!ctx->prev_ref_frame) && (!ctx->next_ref_frame)) {
+				/* first I in sequence */
+
+				/* this is a reference frame */
+				ctx->next_ref_frame = mpeg2_frame;
+				(to_frame(ctx->next_ref_frame))->state |=
+					DELTA_FRAME_REF;
+
+				/* immediate output */
+				ctx->out_frame = frame;
+				/* skip Predictive case code */
+				break;
+			}
+			/* If not first frame, do the same for I and P */
+		case MPEG2_PREDICTIVE_PICTURE:
+
+			/* I or P within sequence */
+
+			/* 2 references frames (prev/next) on a sliding window,
+			 * if more, release the oldest frame
+			 * Most recently decoded reference is always in
+			 * next_ref_frame
+			 */
+			if (ctx->prev_ref_frame)
+				(to_frame(ctx->prev_ref_frame))->state &=
+					~DELTA_FRAME_REF;
+			ctx->prev_ref_frame = ctx->next_ref_frame;
+			ctx->next_ref_frame = mpeg2_frame;
+			(to_frame(ctx->next_ref_frame))->state |=
+			    DELTA_FRAME_REF;
+
+			/* delay output on next I/P */
+			ctx->out_frame = ctx->delayed_frame;
+			ctx->delayed_frame = frame;
+			break;
+
+		case MPEG2_BIDIRECTIONAL_PICTURE:
+			/* B frame not used for reference, immediate output */
+			ctx->out_frame = frame;
+			break;
+		default:
+			dev_err(delta->dev, "%s  unknown coding type\n",
+				pctx->name);
+			break;
+		}
+
+		ctx->accumulated_picture_structure = 0;
+		if (ctx->last_frame)
+			ctx->last_frame = NULL;
+	} else {
+		/* switch to next field decoding */
+		meta_pic = &pmeta_pic[1];
+		ctx->last_frame = frame;
+		goto next_field;
+	}
+
+out:
+	dev_dbg(delta->dev, "%s  < %s\n", pctx->name, __func__);
+	return ret;
+}
+
+static int delta_mpeg2_open(struct delta_ctx *pctx)
+{
+	struct delta_dev *delta = pctx->dev;
+	struct delta_mpeg2_ctx *ctx;
+
+	dev_dbg(delta->dev, "%s  > %s\n", pctx->name, __func__);
+
+	if (sizeof(struct delta_mpeg2_frame) > (sizeof(struct delta_frame) +
+						DELTA_MAX_FRAME_PRIV_SIZE)) {
+		dev_err(delta->dev,
+			"%s  not enough memory for codec specific data\n",
+			pctx->name);
+		return -ENOMEM;
+	}
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+
+	pctx->priv = ctx;
+
+	dev_dbg(delta->dev, "%s  < %s\n", pctx->name, __func__);
+	return 0;
+}
+
+static int delta_mpeg2_close(struct delta_ctx *pctx)
+{
+	struct delta_dev *delta = pctx->dev;
+	struct delta_mpeg2_ctx *ctx = to_ctx(pctx);
+	int i = 0;
+
+	dev_dbg(delta->dev, "%s  > %s\n", pctx->name, __func__);
+
+	if (ctx->ipc_hdl) {
+		delta_ipc_close(ctx->ipc_hdl);
+		ctx->ipc_hdl = NULL;
+	}
+
+	for (i = 0; i < pctx->nb_of_frames; i++) {
+		struct delta_mpeg2_frame *mpeg2_frame =
+		    to_mpeg2_frame(pctx->frames[i]);
+		if (mpeg2_frame && mpeg2_frame->omega_buf.paddr) {
+			hw_free(pctx, &mpeg2_frame->omega_buf);
+			mpeg2_frame->omega_buf.paddr = 0;
+		}
+	}
+
+	kfree(ctx);
+
+	dev_dbg(delta->dev, "%s  < %s\n", pctx->name, __func__);
+	return 0;
+}
+
+static int delta_mpeg2_setup_frame(struct delta_ctx *pctx,
+				   struct delta_frame *frame)
+{
+	struct delta_dev *delta = pctx->dev;
+	struct delta_mpeg2_frame *mpeg2_frame = to_mpeg2_frame(frame);
+	int size = 0;
+	int ret = 0;
+
+	dev_dbg(delta->dev, "%s  > %s\n", pctx->name, __func__);
+
+	/* allocate 420mb buffer */
+	size = (frame->info.aligned_width *
+		frame->info.aligned_height * 3) / 2;
+
+	if (mpeg2_frame->omega_buf.paddr) {
+		dev_err(delta->dev,
+			"%s  omega_buf for frame[%d] already allocated !!!!\n",
+			pctx->name, frame->index);
+		return -ENOMEM;
+	}
+	ret = hw_alloc(pctx, size, "420mb omega buffer",
+		       &mpeg2_frame->omega_buf);
+	if (ret)
+		return ret;
+
+	dev_dbg(delta->dev, "%s  < %s\n", pctx->name, __func__);
+	return 0;
+}
+
+static int delta_mpeg2_get_streaminfo(struct delta_ctx *pctx,
+				      struct delta_streaminfo *streaminfo)
+{
+	struct delta_dev *delta = pctx->dev;
+	struct delta_mpeg2_ctx *ctx = to_ctx(pctx);
+
+	dev_dbg(delta->dev, "%s  > %s\n", pctx->name, __func__);
+
+	if (!ctx->header_parsed)
+		goto nodata;
+
+	*streaminfo = ctx->streaminfo;
+
+	dev_dbg(delta->dev, "%s  < %s\n", pctx->name, __func__);
+	return 0;
+
+nodata:
+	dev_dbg(delta->dev, "%s  < %s no streaminfo\n", pctx->name, __func__);
+	return -ENODATA;
+}
+
+static int delta_mpeg2_set_streaminfo(struct delta_ctx *pctx,
+				      struct mpeg2_meta_seq *meta_seq)
+{
+	struct delta_dev *delta = pctx->dev;
+	struct delta_mpeg2_ctx *ctx = to_ctx(pctx);
+	const struct delta_dec *dec = pctx->dec;
+	__u32 width, height, frame_width, frame_height;
+	struct v4l2_rect crop;
+	__u32 streamformat;
+	__u32 flags = 0;
+	const char *profile = NULL;
+	const char *level = NULL;
+	const char *chroma = NULL;
+	const char *extension = NULL;
+	enum v4l2_field field = V4L2_FIELD_NONE;
+	struct mpeg_video_sequence_hdr *seq_header = NULL;
+	struct mpeg_video_sequence_ext *seq_ext_header = NULL;
+	struct mpeg_video_sequence_display_ext *seq_disp_ext_header = NULL;
+
+	dev_dbg(delta->dev, "%s  > %s\n", pctx->name, __func__);
+
+	if (!(meta_seq->flags & MPEG2_META_SEQ_FLAG_HDR)) {
+		dev_err(delta->dev, "%s  failed to set streaminfo, no header in meta sequence\n",
+			pctx->name);
+		return -EINVAL;
+	}
+	seq_header = &meta_seq->seq_h;
+
+	if (meta_seq->flags & MPEG2_META_SEQ_FLAG_EXT)
+		seq_ext_header = &meta_seq->seq_e;
+	if (meta_seq->flags & MPEG2_META_SEQ_FLAG_DISPLAY_EXT)
+		seq_disp_ext_header = &meta_seq->seq_d;
+
+	/* stream format */
+	streamformat = dec->streamformat;
+
+	/* width/height */
+	width = seq_header->width;
+	height = seq_header->height;
+	if (seq_ext_header) {
+		width |= seq_ext_header->horiz_size_ext << 12;
+		height |= seq_ext_header->vert_size_ext << 12;
+	}
+	if ((width * height) > DELTA_MPEG2_MAX_RESO) {
+		dev_err(delta->dev,
+			"%s  stream resolution too large: %dx%d > %d pixels budget\n",
+			pctx->name, width, height, DELTA_MPEG2_MAX_RESO);
+		return -EINVAL;
+	}
+
+	/* delta decoder request 32 pixels alignment */
+	frame_width = (width + 31) & ~31;
+	frame_height = (height + 31) & ~31;
+	/* crop */
+	crop.top = 0;
+	crop.left = 0;
+	if (seq_disp_ext_header &&
+	    (seq_disp_ext_header->display_horizontal_size != 0) &&
+	    (seq_disp_ext_header->display_vertical_size != 0)) {
+		/*  As per MPEG2 standard (section 6.3.6)
+		 *
+		 * display_horizontal_size and display_vertical_size together
+		 * define a rectangle which may be considered as the
+		 * "intended display's" active region.
+		 * If this rectangle is smaller than the encoded frame size,
+		 * then the display process may be expected to display only a
+		 * portion of the encoded frame (Crop).
+		 * Conversely if the display rectangle is larger than the
+		 * encoded frame size, then the display process may be expected
+		 * to display the reconstructed frames on a portion of the
+		 * display device rather than on the whole display device.
+		 *
+		 * Thus as per above, crop info valid only if display rectangle
+		 * is smaller than encoded frame size.
+		 */
+		if ((seq_disp_ext_header->display_horizontal_size < width) ||
+		    (seq_disp_ext_header->display_vertical_size < height)) {
+			flags |= DELTA_STREAMINFO_FLAG_CROP;
+			crop.width =
+				seq_disp_ext_header->display_horizontal_size;
+			crop.height =
+				seq_disp_ext_header->display_vertical_size;
+		}
+	}
+	/* seq_ext_header->progressive_sequence set to 1 indicates a
+	 * progressive stream
+	 * Rec. ITU-T H.262 (1995 E): "progressive_sequence -- When set to '1'
+	 * the coded video sequence contains only progressive frame-pictures"
+	 */
+	if (seq_ext_header)
+		field = (seq_ext_header->progressive) ?
+			V4L2_FIELD_NONE : V4L2_FIELD_INTERLACED;
+
+	/* profile & level */
+	if (seq_ext_header) {
+		if (seq_ext_header->profile_and_level < 130) {
+			profile = profile_str(seq_ext_header->
+						profile_and_level >> 4);
+			level = level_str(seq_ext_header->
+						profile_and_level & 0xF);
+		} else {
+			profile = profile_str(seq_ext_header->
+						profile_and_level);
+		}
+	}
+	/* other... */
+	flags |= DELTA_STREAMINFO_FLAG_OTHER;
+	chroma = chroma_str(MPEG2_CHROMA_4_2_0);
+	if (seq_ext_header)
+		chroma = chroma_str((enum mpeg2_chroma_format_t)
+				    seq_ext_header->chroma_format);
+	if (seq_ext_header && seq_disp_ext_header)
+		extension = " ext:seq+disp";
+	else if (seq_disp_ext_header)
+		extension = " ext:disp";
+	else if (seq_ext_header)
+		extension = " ext:seq";
+	else
+		extension = "";
+
+	/* update streaminfo */
+	ctx->streaminfo.flags = flags;
+	ctx->streaminfo.streamformat = streamformat;
+	ctx->streaminfo.width = width;
+	ctx->streaminfo.height = height;
+	ctx->streaminfo.crop = crop;
+	ctx->streaminfo.field = field;
+
+	ctx->streaminfo.dpb = DELTA_MPEG2_DPB_FRAMES_NEEDED;
+
+	snprintf(ctx->streaminfo.profile,
+		 sizeof(ctx->streaminfo.profile), "%s", profile);
+	snprintf(ctx->streaminfo.level,
+		 sizeof(ctx->streaminfo.level), "%s", level);
+
+	snprintf(ctx->streaminfo.other,
+		 sizeof(ctx->streaminfo.other), "%s%s", chroma, extension);
+
+	ctx->header_parsed = true;
+
+	dev_dbg(delta->dev, "%s  < %s\n", pctx->name, __func__);
+
+	return 0;
+}
+
+static int delta_mpeg2_decode(struct delta_ctx *pctx, struct delta_au *au)
+{
+	struct delta_dev *delta = pctx->dev;
+	struct delta_mpeg2_ctx *ctx = to_ctx(pctx);
+	int ret;
+	struct v4l2_ctrl_mpeg2_meta *meta =
+		(struct v4l2_ctrl_mpeg2_meta *)au->meta;
+	struct mpeg2_meta_seq *meta_seq = NULL;
+	struct mpeg2_meta_pic *meta_pic = NULL;
+
+	if (!meta) {
+		dev_err(delta->dev, "%s  no meta provided\n", pctx->name);
+		return -EINVAL;
+	}
+	if (meta->struct_size != sizeof(*meta)) {
+		dev_err(delta->dev, "%s  unexpected meta size (%d while %zu expected)\n",
+			pctx->name, meta->struct_size, sizeof(*meta));
+		return -EINVAL;
+	}
+
+	if (meta->flags & V4L2_CTRL_MPEG2_FLAG_SEQ)
+		meta_seq = &meta->seq;
+	if (meta->flags & V4L2_CTRL_MPEG2_FLAG_PIC)
+		meta_pic = &meta->pic[0];
+
+	if (!ctx->ipc_hdl) {
+		ret = delta_mpeg2_ipc_open(pctx);
+		if (ret)
+			return ret;
+	}
+
+	if (meta_seq) {
+		/* refresh streaminfo with new sequence header */
+		ret = delta_mpeg2_set_streaminfo(pctx, meta_seq);
+		if (ret)
+			return ret;
+
+		/* send new sequence header to firmware */
+		ret = delta_mpeg2_ipc_set_stream(pctx, meta_seq);
+		if (ret)
+			return ret;
+	}
+
+	if (meta_pic) {
+		/* send new access unit to decode with its picture header */
+		ret = delta_mpeg2_ipc_decode(pctx, au, meta_pic);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int delta_mpeg2_get_frame(struct delta_ctx *pctx,
+				 struct delta_frame **pframe)
+{
+	struct delta_dev *delta = pctx->dev;
+	struct delta_mpeg2_ctx *ctx = to_ctx(pctx);
+	struct delta_frame *frame = NULL;
+
+	dev_dbg(delta->dev, "%s  > %s\n", pctx->name, __func__);
+
+	if (!ctx->out_frame)
+		goto nodata;
+
+	frame = ctx->out_frame;
+
+	*pframe = frame;
+
+	dev_dbg(delta->dev,
+		"%s  out frame[%d] tref=%03lu type=%s field=%s cnt=%03d %s\n",
+		pctx->name,
+		frame->index,
+		to_mpeg2_frame(frame)->dts.tv_usec,
+		frame_type_str(frame->flags),
+		frame_field_str(frame->field),
+		pctx->output_frames + 1,
+		frame_state_str(frame->state, ctx->str, sizeof(ctx->str)));
+
+	ctx->out_frame = NULL;
+
+	dev_dbg(delta->dev, "%s  < %s frame[%d]\n", pctx->name, __func__,
+		frame->index);
+	return 0;
+
+nodata:
+	dev_dbg(delta->dev, "%s  < %s\n", pctx->name, __func__);
+	return -ENODATA;
+}
+
+static void delta_mpeg2_recycle(struct delta_ctx *pctx,
+				struct delta_frame *frame)
+{
+	struct delta_dev *delta = pctx->dev;
+	struct delta_mpeg2_ctx *ctx = to_ctx(pctx);
+	struct delta_mpeg2_frame *mpeg2_frame = to_mpeg2_frame(frame);
+
+	dev_dbg(delta->dev, "%s  > %s frame[%d]\n", pctx->name, __func__,
+		frame->index);
+
+	dev_dbg(delta->dev,
+		"%s  rec frame[%d] tref=%03lu %s\n",
+		pctx->name,
+		frame->index,
+		mpeg2_frame->dts.tv_usec,
+		frame_state_str(frame->state, ctx->str, sizeof(ctx->str)));
+
+	frame->state &= ~DELTA_FRAME_DEC;
+
+	dev_dbg(delta->dev, "%s  < %s\n", pctx->name, __func__);
+}
+
+static void delta_mpeg2_flush(struct delta_ctx *pctx)
+{
+	struct delta_dev *delta = pctx->dev;
+	struct delta_mpeg2_ctx *ctx = to_ctx(pctx);
+
+	dev_dbg(delta->dev, "%s  > %s\n", pctx->name, __func__);
+
+	ctx->prev_ref_frame = NULL;
+	ctx->next_ref_frame = NULL;
+	ctx->out_frame = NULL;
+	ctx->delayed_frame = NULL;
+
+	dev_dbg(delta->dev, "%s  < %s\n", pctx->name, __func__);
+}
+
+static void delta_mpeg2_drain(struct delta_ctx *pctx)
+{
+	struct delta_dev *delta = pctx->dev;
+	struct delta_mpeg2_ctx *ctx = to_ctx(pctx);
+	struct delta_frame *prev_ref = to_frame(ctx->prev_ref_frame);
+	struct delta_frame *next_ref = to_frame(ctx->next_ref_frame);
+
+	dev_dbg(delta->dev, "%s  > %s\n", pctx->name, __func__);
+
+	/* mark any pending buffer as out */
+	if (prev_ref &&
+	    (prev_ref->state & DELTA_FRAME_DEC) &&
+	    !(prev_ref->state & DELTA_FRAME_OUT)) {
+		ctx->out_frame = prev_ref;
+	} else if (next_ref &&
+		   (next_ref->state & DELTA_FRAME_DEC) &&
+		   !(next_ref->state & DELTA_FRAME_OUT)) {
+		ctx->out_frame = next_ref;
+	}
+
+	dev_dbg(delta->dev, "%s  < %s\n", pctx->name, __func__);
+}
+
+/* MPEG2 decoder can decode MPEG2 and MPEG1 contents */
+const struct delta_dec mpeg2dec = {
+	.name = "MPEG2",
+	.streamformat = V4L2_PIX_FMT_MPEG2,
+	.pixelformat = V4L2_PIX_FMT_NV12,
+	.open = delta_mpeg2_open,
+	.close = delta_mpeg2_close,
+	.get_streaminfo = delta_mpeg2_get_streaminfo,
+	.get_frameinfo = delta_get_frameinfo_default,
+	.decode = delta_mpeg2_decode,
+	.setup_frame = delta_mpeg2_setup_frame,
+	.get_frame = delta_mpeg2_get_frame,
+	.recycle = delta_mpeg2_recycle,
+	.flush = delta_mpeg2_flush,
+	.drain = delta_mpeg2_drain,
+};
+
+const struct delta_dec mpeg1dec = {
+	.name = "MPEG1",
+	.streamformat = V4L2_PIX_FMT_MPEG1,
+	.pixelformat = V4L2_PIX_FMT_NV12,
+	.open = delta_mpeg2_open,
+	.close = delta_mpeg2_close,
+	.setup_frame = delta_mpeg2_setup_frame,
+	.get_streaminfo = delta_mpeg2_get_streaminfo,
+	.get_frameinfo = delta_get_frameinfo_default,
+	.decode = delta_mpeg2_decode,
+	.get_frame = delta_mpeg2_get_frame,
+	.recycle = delta_mpeg2_recycle,
+	.flush = delta_mpeg2_flush,
+	.drain = delta_mpeg2_drain,
+};
diff --git a/drivers/media/platform/sti/delta/delta-mpeg2-fw.h b/drivers/media/platform/sti/delta/delta-mpeg2-fw.h
new file mode 100644
index 0000000..8123b56
--- /dev/null
+++ b/drivers/media/platform/sti/delta/delta-mpeg2-fw.h
@@ -0,0 +1,415 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2015
+ * Author: Hugues Fruchet <hugues.fruchet@st.com> for STMicroelectronics.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#ifndef DELTA_MPEG2_FW_H
+#define DELTA_MPEG2_FW_H
+
+#define MPEG2_Q_MATRIX_SIZE	64
+
+#define MPEG2_DECODER_ID	0xCAFE
+#define MPEG2_DECODER_BASE	(MPEG2_DECODER_ID << 16)
+
+#define MPEG2_NUMBER_OF_CEH_INTERVALS 32
+
+enum mpeg_decoding_flags_t {
+	/* used to determine the type of picture */
+	MPEG_DECODING_FLAGS_TOP_FIELD_FIRST = 0x00000001,
+	/* used for parsing progression purpose only */
+	MPEG_DECODING_FLAGS_FRAME_PRED_FRAME_DCT = 0x00000002,
+	/* used for parsing progression purpose only */
+	MPEG_DECODING_FLAGS_CONCEALMENT_MOTION_VECTORS = 0x00000004,
+	/* used for the inverse Quantisation process */
+	MPEG_DECODING_FLAGS_Q_SCALE_TYPE = 0x00000008,
+	/* VLC tables selection when decoding the DCT coefficients */
+	MPEG_DECODING_FLAGS_INTRA_VLC_FORMAT = 0x00000010,
+	/* used for the inverse Scan process */
+	MPEG_DECODING_FLAGS_ALTERNATE_SCAN = 0x00000020,
+	/* used for progressive frame signaling */
+	MPEG_DECODING_FLAGS_PROGRESSIVE_FRAME = 0x00000040
+};
+
+/* additional decoding flags */
+enum mpeg2_additional_flags_t {
+	MPEG2_ADDITIONAL_FLAG_NONE = 0x00000000,
+	MPEG2_ADDITIONAL_FLAG_DEBLOCKING_ENABLE = 0x00000001,
+	MPEG2_ADDITIONAL_FLAG_DERINGING_ENABLE = 0x00000002,
+	MPEG2_ADDITIONAL_FLAG_TRANSCODING_H264 = 0x00000004,
+	MPEG2_ADDITIONAL_FLAG_CEH = 0x00000008,
+	MPEG2_ADDITIONAL_FLAG_FIRST_FIELD = 0x00000010,
+	MPEG2_ADDITIONAL_FLAG_SECOND_FIELD = 0x00000020
+};
+
+/* horizontal decimation factor */
+enum mpeg2_horizontal_deci_factor_t {
+	MPEG2_HDEC_1 = 0x00000000, /* no H resize */
+	MPEG2_HDEC_2 = 0x00000001, /* H/2  resize */
+	MPEG2_HDEC_4 = 0x00000002, /* H/4  resize */
+	/* advanced H/2 resize using improved 8-tap filters */
+	MPEG2_HDEC_ADVANCED_2 = 0x00000101,
+	/* advanced H/4 resize using improved 8-tap filters */
+	MPEG2_HDEC_ADVANCED_4 = 0x00000102
+};
+
+/* vertical decimation factor */
+enum mpeg2_vertical_deci_factor_t {
+	MPEG2_VDEC_1 = 0x00000000, /* no V resize */
+	MPEG2_VDEC_2_PROG = 0x00000004, /* V/2, progressive resize */
+	MPEG2_VDEC_2_INT = 0x00000008, /* V/2, interlaced resize */
+	/* advanced V/2, progressive resize */
+	MPEG2_VDEC_ADVANCED_2_PROG = 0x00000204,
+	/* advanced V/2, interlaced resize */
+	MPEG2_VDEC_ADVANCED_2_INT = 0x00000208
+};
+
+/* used to enable main/aux outputs for both display &
+ * reference reconstruction blocks
+ */
+enum mpeg2_rcn_ref_disp_enable_t {
+	/* enable decimated (for display) reconstruction */
+	MPEG2_DISP_AUX_EN = 0x00000010,
+	/* enable main (for display) reconstruction */
+	MPEG2_DISP_MAIN_EN = 0x00000020,
+	/* enable both main & decimated (for display) reconstruction */
+	MPEG2_DISP_AUX_MAIN_EN = 0x00000030,
+	/* enable only reference output (ex. for trick modes) */
+	MPEG2_REF_MAIN_EN = 0x00000100,
+	/* enable reference output with decimated
+	 * (for display) reconstruction
+	 */
+	MPEG2_REF_MAIN_DISP_AUX_EN = 0x00000110,
+	/* enable reference output with main (for display) reconstruction */
+	MPEG2_REF_MAIN_DISP_MAIN_EN = 0x00000120,
+	/* enable reference output with main & decimated
+	 * (for display) reconstruction
+	 */
+	MPEG2_REF_MAIN_DISP_MAIN_AUX_EN = 0x00000130
+};
+
+/* picture prediction coding type (none, one or two reference pictures) */
+enum mpeg2_picture_coding_type_t {
+	/* forbidden coding type */
+	MPEG2_FORBIDDEN_PICTURE = 0x00000000,
+	/* intra (I) picture coding type */
+	MPEG2_INTRA_PICTURE = 0x00000001,
+	/* predictive (P) picture coding type */
+	MPEG2_PREDICTIVE_PICTURE = 0x00000002,
+	/* bidirectional (B) picture coding type */
+	MPEG2_BIDIRECTIONAL_PICTURE = 0x00000003,
+	/* dc intra (D) picture coding type */
+	MPEG2_DC_INTRA_PICTURE = 0x00000004,
+	/* reserved coding type*/
+	MPEG2_RESERVED_1_PICTURE = 0x00000005,
+	MPEG2_RESERVED_2_PICTURE = 0x00000006,
+	MPEG2_RESERVED_3_PICTURE = 0x00000007
+};
+
+/* picture structure type (progressive, interlaced top/bottom) */
+enum mpeg2_picture_structure_t {
+	MPEG2_RESERVED_TYPE = 0,
+	/* identifies a top field picture type */
+	MPEG2_TOP_FIELD_TYPE = 1,
+	/* identifies a bottom field picture type */
+	MPEG2_BOTTOM_FIELD_TYPE = 2,
+	/* identifies a frame picture type */
+	MPEG2_FRAME_TYPE = 3
+};
+
+/* decoding mode */
+enum mpeg2_decoding_mode_t {
+	MPEG2_NORMAL_DECODE = 0,
+	MPEG2_NORMAL_DECODE_WITHOUT_ERROR_RECOVERY = 1,
+	MPEG2_DOWNGRADED_DECODE_LEVEL1 = 2,
+	MPEG2_DOWNGRADED_DECODE_LEVEL2 = 4
+};
+
+/* quantization matrix flags */
+enum mpeg2_default_matrix_flags_t {
+	MPEG2_LOAD_INTRA_QUANTIZER_MATRIX_FLAG = 0x00000001,
+	MPEG2_LOAD_NON_INTRA_QUANTIZER_MATRIX_FLAG = 0x00000002
+};
+
+/*
+ * struct mpeg2_decoded_buffer_address_t
+ *
+ * defines the addresses where the decoded pictures will be stored
+ *
+ * @struct_size:		size of the structure in bytes
+ * @decoded_luma_p:		address of the luma buffer
+ * @decoded_chroma_p:		address of the chroma buffer
+ * @decoded_temporal_reference_value:	temporal_reference value
+ *				of the decoded (current) picture
+ * @mb_descr_p:			buffer where to store data related
+ *				to every MBs of the picture
+ */
+struct mpeg2_decoded_buffer_address_t {
+	u32 struct_size;
+	u32 decoded_luma_p;
+	u32 decoded_chroma_p;
+	u32 decoded_temporal_reference_value;	/*  */
+
+	u32 mb_descr_p;
+};
+
+/*
+ * struct mpeg2_display_buffer_address_t
+ *
+ * defines the addresses (used by the Display Reconstruction block)
+ * where the pictures to be displayed will be stored
+ *
+ * @struct_size:		size of the structure in bytes
+ * @display_luma_p:		address of the luma buffer
+ * @display_chroma_p:		address of the chroma buffer
+ * @display_decimated_luma_p:	address of the decimated luma buffer
+ * @display_decimated_chroma_p:	address of the decimated chroma buffer
+ */
+struct mpeg2_display_buffer_address_t {
+	u32 struct_size;
+	u32 display_luma_p;
+	u32 display_chroma_p;
+	u32 display_decimated_luma_p;
+	u32 display_decimated_chroma_p;
+};
+
+/*
+ * struct mpeg2_display_buffer_address_t
+ *
+ * defines the addresses where the two reference pictures
+ * will be stored
+ *
+ * @struct_size:		size of the structure in bytes
+ * @backward_reference_luma_p:	address of the backward reference luma buffer
+ * @backward_reference_chroma_p:address of the backward reference chroma buffer
+ * @backward_temporal_reference_value:	temporal_reference value of the
+ *				backward reference picture
+ * @forward_reference_luma_p:	address of the forward reference luma buffer
+ * @forward_reference_chroma_p:	address of the forward reference chroma buffer
+ * @forward_temporal_reference_value:	temporal_reference value of the
+ *				forward reference picture
+ */
+struct mpeg2_ref_pic_list_address_t {
+	u32 struct_size;
+	u32 backward_reference_luma_p;
+	u32 backward_reference_chroma_p;
+	u32 backward_temporal_reference_value;
+	u32 forward_reference_luma_p;
+	u32 forward_reference_chroma_p;
+	u32 forward_temporal_reference_value;
+};
+
+/* identifies the type of chroma of the decoded picture */
+enum mpeg2_chroma_format_t {
+	MPEG2_CHROMA_RESERVED = 0,
+	/* chroma type 4:2:0 */
+	MPEG2_CHROMA_4_2_0 = 1,
+	/* chroma type 4:2:2 */
+	MPEG2_CHROMA_4_2_2 = 2,
+	/* chroma type 4:4:4 */
+	MPEG2_CHROMA_4_4_4 = 3
+};
+
+/* identifies the Intra DC Precision */
+enum mpeg2_intra_dc_precision_t {
+	/* 8 bits Intra DC Precision*/
+	MPEG2_INTRA_DC_PRECISION_8_BITS = 0,
+	/* 9 bits Intra DC Precision  */
+	MPEG2_INTRA_DC_PRECISION_9_BITS = 1,
+	/* 10 bits Intra DC Precision */
+	MPEG2_INTRA_DC_PRECISION_10_BITS = 2,
+	/* 11 bits Intra DC Precision */
+	MPEG2_INTRA_DC_PRECISION_11_BITS = 3
+};
+
+/* decoding errors bitfield returned by firmware, several bits can be
+ * raised at the same time to signal several errors.
+ */
+enum mpeg2_decoding_error_t {
+	/* the firmware decoding was successful */
+	MPEG2_DECODER_NO_ERROR = (MPEG2_DECODER_BASE + 0),
+	/* the firmware decoded too much MBs:
+	 * - The mpeg2_command_status_t.status doesn't locate
+	 *   these erroneous MBs because the firmware can't know
+	 *   where are these extra MBs.
+	 * - MPEG2_DECODER_ERROR_RECOVERED could also be set
+	 */
+	MPEG2_DECODER_ERROR_MB_OVERFLOW = (MPEG2_DECODER_BASE + 1),
+	/* the firmware encountered error(s) that were recovered:
+	 * - mpeg2_command_status_t.status locates the erroneous MBs.
+	 * - MPEG2_DECODER_ERROR_MB_OVERFLOW could also be set
+	 */
+	MPEG2_DECODER_ERROR_RECOVERED = (MPEG2_DECODER_BASE + 2),
+	/* the firmware encountered an error that can't be recovered:
+	 * - mpeg2_command_status_t.status has no meaning
+	 */
+	MPEG2_DECODER_ERROR_NOT_RECOVERED = (MPEG2_DECODER_BASE + 4),
+	/* the firmware task is hanged and doesn't get back to watchdog
+	 * task even after maximum time alloted has lapsed:
+	 * - mpeg2_command_status_t.status has no meaning.
+	 */
+	MPEG2_DECODER_ERROR_TASK_TIMEOUT = (MPEG2_DECODER_BASE + 8),
+	/* This feature is not supported by firmware */
+	MPEG2_DECODER_ERROR_FEATURE_NOT_SUPPORTED = (MPEG2_DECODER_BASE + 16)
+};
+
+/*
+ * struct mpeg2_set_global_param_sequence_t
+ *
+ * overall video sequence parameters required
+ * by firmware to prepare picture decoding
+ *
+ * @struct_size:		size of the structure in bytes
+ * @mpeg_stream_type_flag:	type of the bitstream MPEG1/MPEG2:
+ *				 = 0  for MPEG1 coded stream,
+ *				 = 1  for MPEG2 coded stream
+ * @horizontal_size:		horizontal size of the video picture: based
+ *				on the two elements "horizontal_size_value"
+ *				and "horizontal_size_extension"
+ * @vertical_size:		vertical size of the video picture: based
+ *				on the two elements "vertical_size_value"
+ *				and "vertical_size_extension"
+ * @progressive_sequence:	progressive/interlaced sequence
+ * @chroma_format:		type of chroma of the decoded picture
+ * @matrix_flags:		load or not the intra or non-intra
+ *				quantization matrices
+ * @intra_quantiser_matrix:	intra quantization matrix
+ * @non_intra_quantiser_matrix:	non-intra quantization matrix
+ * @chroma_intra_quantiser_matrix:	chroma of intra quantization matrix
+ * @chroma_non_intra_quantiser_matrix:	chroma of non-intra quantization matrix
+ */
+struct mpeg2_set_global_param_sequence_t {
+	u32 struct_size;
+	bool mpeg_stream_type_flag;
+	u32 horizontal_size;
+	u32 vertical_size;
+	u32 progressive_sequence;
+	enum mpeg2_chroma_format_t chroma_format;
+	enum mpeg2_default_matrix_flags_t matrix_flags;
+	u8 intra_quantiser_matrix[MPEG2_Q_MATRIX_SIZE];
+	u8 non_intra_quantiser_matrix[MPEG2_Q_MATRIX_SIZE];
+	u8 chroma_intra_quantiser_matrix[MPEG2_Q_MATRIX_SIZE];
+	u8 chroma_non_intra_quantiser_matrix[MPEG2_Q_MATRIX_SIZE];
+};
+
+/*
+ * struct mpeg2_param_picture_t
+ *
+ * picture specific parameters required by firmware to perform a picture decode
+ *
+ * @struct_size:		size of the structure in bytes
+ * @picture_coding_type:	identifies the picture prediction
+ *				(none, one or two reference pictures)
+ * @forward_horizontal_f_code:	motion vector: forward horizontal F code
+ * @forward_vertical_f_code:	motion vector: forward vertical F code
+ * @backward_horizontal_f_code:	motion vector: backward horizontal F code
+ * @backward_vertical_f_code:	motion vector: backward vertical F code
+ * @intra_dc_precision:		inverse quantisation process precision
+ * @picture_structure:		picture structure type (progressive,
+ *				interlaced top/bottom)
+ * @mpeg_decoding_flags:	flags to control decoding process
+ */
+struct mpeg2_param_picture_t {
+	u32 struct_size;
+	enum mpeg2_picture_coding_type_t picture_coding_type;
+	u32 forward_horizontal_f_code;
+	u32 forward_vertical_f_code;
+	u32 backward_horizontal_f_code;
+	u32 backward_vertical_f_code;
+	enum mpeg2_intra_dc_precision_t intra_dc_precision;
+	enum mpeg2_picture_structure_t picture_structure;
+	enum mpeg_decoding_flags_t mpeg_decoding_flags;
+};
+
+/*
+ * struct mpeg2_transform_param_t
+ *
+ * control parameters required by firmware to decode a picture
+ *
+ * @struct_size:		size of the structure in bytes
+ * @picture_start_addr_compressed_buffer_p:	start address of the
+ *						compressed MPEG data
+ * @picture_stop_addr_compressed_buffer_p:	stop address of the
+ *						compressed MPEG data
+ * @decoded_buffer_address:	buffer addresses of decoded frame
+ * @display_buffer_address:	buffer addresses of decoded frame
+ *				to be displayed
+ * @ref_pic_list_address:	buffer addresses where the backward
+ *				and forward reference pictures will
+ *				be stored
+ * @main_aux_enable:		output reconstruction stage control
+ * @horizontal_decimation_factor: horizontal decimation control
+ * @vertical_decimation_factor:	vertical decimation control
+ * @decoding_mode:		decoding control (normal,
+ *				recovery, downgraded...)
+ * @additional_flags:		optional additional decoding controls
+ *				(deblocking, deringing...)
+ * @picture_parameters:		picture specific parameters
+ */
+struct mpeg2_transform_param_t {
+	u32 struct_size;
+	u32 picture_start_addr_compressed_buffer_p;
+	u32 picture_stop_addr_compressed_buffer_p;
+	struct mpeg2_decoded_buffer_address_t decoded_buffer_address;
+	struct mpeg2_display_buffer_address_t display_buffer_address;
+	struct mpeg2_ref_pic_list_address_t ref_pic_list_address;
+	enum mpeg2_rcn_ref_disp_enable_t main_aux_enable;
+	enum mpeg2_horizontal_deci_factor_t horizontal_decimation_factor;
+	enum mpeg2_vertical_deci_factor_t vertical_decimation_factor;
+	enum mpeg2_decoding_mode_t decoding_mode;
+	enum mpeg2_additional_flags_t additional_flags;
+	struct mpeg2_param_picture_t picture_parameters;
+	bool reserved;
+};
+
+/*
+ * struct mpeg2_init_transformer_param_t
+ *
+ * defines the addresses where the decoded pictures will be stored
+ *
+ * @input_buffer_begin:	 start address of the input circular buffer
+ * @input_buffer_end:	stop address of the input circular buffer
+ */
+struct mpeg2_init_transformer_param_t {
+	u32 input_buffer_begin;
+	u32 input_buffer_end;
+	bool reserved;
+};
+
+#define MPEG2_STATUS_PARTITION   6
+
+/*
+ * struct mpeg2_init_transformer_param_t
+ *
+ * @struct_size:	size of the structure in bytes
+ * @status:		decoding quality indicator which can be used
+ *			to assess the level corruption of input
+ *			MPEG bitstream. The picture to decode
+ *			is divided into a maximum of
+ *			MPEG2_STATUS_PARTITION * MPEG2_STATUS_PARTITION
+ *			areas in order to locate the decoding errors.
+ * @error_code:		decoding errors bitfield returned by firmware
+ * @decode_time_in_micros:	stop address of the input circular buffer
+ * @ceh_registers:	array where values of the Contrast Enhancement
+ *			Histogram (CEH) registers will be stored.
+ *			ceh_registers[0] correspond to register MBE_CEH_0_7,
+ *			ceh_registers[1] correspond to register MBE_CEH_8_15,
+ *			ceh_registers[2] correspond to register MBE_CEH_16_23.
+ *			Note that elements of this array will be updated
+ *			only if mpeg2_transform_param_t.additional_flags has
+ *			the flag MPEG2_ADDITIONAL_FLAG_CEH set.
+ *			They will remain unchanged otherwise.
+ * @picture_mean_qp:	picture mean QP factor
+ * @picture_variance_qp:picture variance QP factor
+  */
+struct mpeg2_command_status_t {
+	u32 struct_size;
+	u8 status[MPEG2_STATUS_PARTITION][MPEG2_STATUS_PARTITION];
+	enum mpeg2_decoding_error_t error_code;
+	u32 decode_time_in_micros;
+	u32 ceh_registers[MPEG2_NUMBER_OF_CEH_INTERVALS];
+	u32 picture_mean_qp;
+	u32 picture_variance_qp;
+};
+
+#endif /* DELTA_MPEG2_FW_H */
diff --git a/drivers/media/platform/sti/delta/delta-v4l2.c b/drivers/media/platform/sti/delta/delta-v4l2.c
index a0d2f3e..26e56a0 100644
--- a/drivers/media/platform/sti/delta/delta-v4l2.c
+++ b/drivers/media/platform/sti/delta/delta-v4l2.c
@@ -36,6 +36,10 @@ static const struct delta_dec *delta_decoders[] = {
 #ifdef CONFIG_VIDEO_STI_DELTA_MJPEG
 	&mjpegdec,
 #endif
+#ifdef CONFIG_VIDEO_STI_DELTA_MPEG2
+	&mpeg2dec,
+	&mpeg1dec,
+#endif
 };
 
 static inline int frame_size(__u32 w, __u32 h, __u32 fmt)
-- 
1.9.1

