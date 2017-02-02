Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:22922 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751143AbdBBPA0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 2 Feb 2017 10:00:26 -0500
From: Hugues Fruchet <hugues.fruchet@st.com>
To: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
CC: <kernel@stlinux.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>
Subject: [PATCH v7 09/10] [media] st-delta: add mjpeg support
Date: Thu, 2 Feb 2017 15:59:52 +0100
Message-ID: <1486047593-18581-10-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1486047593-18581-1-git-send-email-hugues.fruchet@st.com>
References: <1486047593-18581-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds support of DELTA MJPEG video decoder back-end,
implemented by calling JPEG_DECODER_HW0 firmware
using RPMSG IPC communication layer.

Acked-by: Peter Griffin <peter.griffin@linaro.org>
Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 drivers/media/platform/Kconfig                     |  12 +-
 drivers/media/platform/sti/delta/Makefile          |   4 +
 drivers/media/platform/sti/delta/delta-cfg.h       |   3 +
 drivers/media/platform/sti/delta/delta-mjpeg-dec.c | 455 +++++++++++++++++++++
 drivers/media/platform/sti/delta/delta-mjpeg-fw.h  | 225 ++++++++++
 drivers/media/platform/sti/delta/delta-mjpeg-hdr.c | 149 +++++++
 drivers/media/platform/sti/delta/delta-mjpeg.h     |  35 ++
 drivers/media/platform/sti/delta/delta-v4l2.c      |   3 +
 8 files changed, 885 insertions(+), 1 deletion(-)
 create mode 100644 drivers/media/platform/sti/delta/delta-mjpeg-dec.c
 create mode 100644 drivers/media/platform/sti/delta/delta-mjpeg-fw.h
 create mode 100644 drivers/media/platform/sti/delta/delta-mjpeg-hdr.c
 create mode 100644 drivers/media/platform/sti/delta/delta-mjpeg.h

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 2e82ec6..20b26ea 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -317,10 +317,20 @@ config VIDEO_STI_DELTA
 
 if VIDEO_STI_DELTA
 
+config VIDEO_STI_DELTA_MJPEG
+	bool "STMicroelectronics DELTA MJPEG support"
+	default y
+	help
+		Enables DELTA MJPEG hardware support.
+
+		To compile this driver as a module, choose M here:
+		the module will be called st-delta.
+
 config VIDEO_STI_DELTA_DRIVER
 	tristate
 	depends on VIDEO_STI_DELTA
-	default n
+	depends on VIDEO_STI_DELTA_MJPEG
+	default VIDEO_STI_DELTA_MJPEG
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
 	select RPMSG
diff --git a/drivers/media/platform/sti/delta/Makefile b/drivers/media/platform/sti/delta/Makefile
index b791ba0..b268df6 100644
--- a/drivers/media/platform/sti/delta/Makefile
+++ b/drivers/media/platform/sti/delta/Makefile
@@ -1,2 +1,6 @@
 obj-$(CONFIG_VIDEO_STI_DELTA_DRIVER) := st-delta.o
 st-delta-y := delta-v4l2.o delta-mem.o delta-ipc.o
+
+# MJPEG support
+st-delta-$(CONFIG_VIDEO_STI_DELTA_MJPEG) += delta-mjpeg-hdr.o
+st-delta-$(CONFIG_VIDEO_STI_DELTA_MJPEG) += delta-mjpeg-dec.o
diff --git a/drivers/media/platform/sti/delta/delta-cfg.h b/drivers/media/platform/sti/delta/delta-cfg.h
index f6674f6..c6388f5 100644
--- a/drivers/media/platform/sti/delta/delta-cfg.h
+++ b/drivers/media/platform/sti/delta/delta-cfg.h
@@ -57,5 +57,8 @@
 #define DELTA_HW_AUTOSUSPEND_DELAY_MS 5
 
 #define DELTA_MAX_DECODERS 10
+#ifdef CONFIG_VIDEO_STI_DELTA_MJPEG
+extern const struct delta_dec mjpegdec;
+#endif
 
 #endif /* DELTA_CFG_H */
diff --git a/drivers/media/platform/sti/delta/delta-mjpeg-dec.c b/drivers/media/platform/sti/delta/delta-mjpeg-dec.c
new file mode 100644
index 0000000..e79bdc6
--- /dev/null
+++ b/drivers/media/platform/sti/delta/delta-mjpeg-dec.c
@@ -0,0 +1,455 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2013
+ * Author: Hugues Fruchet <hugues.fruchet@st.com> for STMicroelectronics.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#include <linux/slab.h>
+
+#include "delta.h"
+#include "delta-ipc.h"
+#include "delta-mjpeg.h"
+#include "delta-mjpeg-fw.h"
+
+#define DELTA_MJPEG_MAX_RESO DELTA_MAX_RESO
+
+struct delta_mjpeg_ctx {
+	/* jpeg header */
+	struct mjpeg_header header_struct;
+	struct mjpeg_header *header;
+
+	/* ipc */
+	void *ipc_hdl;
+	struct delta_buf *ipc_buf;
+
+	/* decoded output frame */
+	struct delta_frame *out_frame;
+
+	unsigned char str[3000];
+};
+
+#define to_ctx(ctx) ((struct delta_mjpeg_ctx *)(ctx)->priv)
+
+static char *ipc_open_param_str(struct jpeg_video_decode_init_params_t *p,
+				char *str, unsigned int len)
+{
+	char *b = str;
+
+	if (!p)
+		return "";
+
+	b += snprintf(b, len,
+		      "jpeg_video_decode_init_params_t\n"
+		      "circular_buffer_begin_addr_p 0x%x\n"
+		      "circular_buffer_end_addr_p   0x%x\n",
+		      p->circular_buffer_begin_addr_p,
+		      p->circular_buffer_end_addr_p);
+
+	return str;
+}
+
+static char *ipc_decode_param_str(struct jpeg_decode_params_t *p,
+				  char *str, unsigned int len)
+{
+	char *b = str;
+
+	if (!p)
+		return "";
+
+	b += snprintf(b, len,
+		      "jpeg_decode_params_t\n"
+		      "picture_start_addr_p                  0x%x\n"
+		      "picture_end_addr_p                    0x%x\n"
+		      "decoding_mode                        %d\n"
+		      "display_buffer_addr.display_decimated_luma_p   0x%x\n"
+		      "display_buffer_addr.display_decimated_chroma_p 0x%x\n"
+		      "main_aux_enable                       %d\n"
+		      "additional_flags                     0x%x\n"
+		      "field_flag                           %x\n"
+		      "is_jpeg_image                        %x\n",
+		      p->picture_start_addr_p,
+		      p->picture_end_addr_p,
+		      p->decoding_mode,
+		      p->display_buffer_addr.display_decimated_luma_p,
+		      p->display_buffer_addr.display_decimated_chroma_p,
+		      p->main_aux_enable, p->additional_flags,
+		      p->field_flag,
+		      p->is_jpeg_image);
+
+	return str;
+}
+
+static inline bool is_stream_error(enum jpeg_decoding_error_t err)
+{
+	switch (err) {
+	case JPEG_DECODER_UNDEFINED_HUFF_TABLE:
+	case JPEG_DECODER_BAD_RESTART_MARKER:
+	case JPEG_DECODER_BAD_SOS_SPECTRAL:
+	case JPEG_DECODER_BAD_SOS_SUCCESSIVE:
+	case JPEG_DECODER_BAD_HEADER_LENGTH:
+	case JPEG_DECODER_BAD_COUNT_VALUE:
+	case JPEG_DECODER_BAD_DHT_MARKER:
+	case JPEG_DECODER_BAD_INDEX_VALUE:
+	case JPEG_DECODER_BAD_NUMBER_HUFFMAN_TABLES:
+	case JPEG_DECODER_BAD_QUANT_TABLE_LENGTH:
+	case JPEG_DECODER_BAD_NUMBER_QUANT_TABLES:
+	case JPEG_DECODER_BAD_COMPONENT_COUNT:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static inline const char *err_str(enum jpeg_decoding_error_t err)
+{
+	switch (err) {
+	case JPEG_DECODER_NO_ERROR:
+		return "JPEG_DECODER_NO_ERROR";
+	case JPEG_DECODER_UNDEFINED_HUFF_TABLE:
+		return "JPEG_DECODER_UNDEFINED_HUFF_TABLE";
+	case JPEG_DECODER_UNSUPPORTED_MARKER:
+		return "JPEG_DECODER_UNSUPPORTED_MARKER";
+	case JPEG_DECODER_UNABLE_ALLOCATE_MEMORY:
+		return "JPEG_DECODER_UNABLE_ALLOCATE_MEMORY";
+	case JPEG_DECODER_NON_SUPPORTED_SAMP_FACTORS:
+		return "JPEG_DECODER_NON_SUPPORTED_SAMP_FACTORS";
+	case JPEG_DECODER_BAD_PARAMETER:
+		return "JPEG_DECODER_BAD_PARAMETER";
+	case JPEG_DECODER_DECODE_ERROR:
+		return "JPEG_DECODER_DECODE_ERROR";
+	case JPEG_DECODER_BAD_RESTART_MARKER:
+		return "JPEG_DECODER_BAD_RESTART_MARKER";
+	case JPEG_DECODER_UNSUPPORTED_COLORSPACE:
+		return "JPEG_DECODER_UNSUPPORTED_COLORSPACE";
+	case JPEG_DECODER_BAD_SOS_SPECTRAL:
+		return "JPEG_DECODER_BAD_SOS_SPECTRAL";
+	case JPEG_DECODER_BAD_SOS_SUCCESSIVE:
+		return "JPEG_DECODER_BAD_SOS_SUCCESSIVE";
+	case JPEG_DECODER_BAD_HEADER_LENGTH:
+		return "JPEG_DECODER_BAD_HEADER_LENGTH";
+	case JPEG_DECODER_BAD_COUNT_VALUE:
+		return "JPEG_DECODER_BAD_COUNT_VALUE";
+	case JPEG_DECODER_BAD_DHT_MARKER:
+		return "JPEG_DECODER_BAD_DHT_MARKER";
+	case JPEG_DECODER_BAD_INDEX_VALUE:
+		return "JPEG_DECODER_BAD_INDEX_VALUE";
+	case JPEG_DECODER_BAD_NUMBER_HUFFMAN_TABLES:
+		return "JPEG_DECODER_BAD_NUMBER_HUFFMAN_TABLES";
+	case JPEG_DECODER_BAD_QUANT_TABLE_LENGTH:
+		return "JPEG_DECODER_BAD_QUANT_TABLE_LENGTH";
+	case JPEG_DECODER_BAD_NUMBER_QUANT_TABLES:
+		return "JPEG_DECODER_BAD_NUMBER_QUANT_TABLES";
+	case JPEG_DECODER_BAD_COMPONENT_COUNT:
+		return "JPEG_DECODER_BAD_COMPONENT_COUNT";
+	case JPEG_DECODER_DIVIDE_BY_ZERO_ERROR:
+		return "JPEG_DECODER_DIVIDE_BY_ZERO_ERROR";
+	case JPEG_DECODER_NOT_JPG_IMAGE:
+		return "JPEG_DECODER_NOT_JPG_IMAGE";
+	case JPEG_DECODER_UNSUPPORTED_ROTATION_ANGLE:
+		return "JPEG_DECODER_UNSUPPORTED_ROTATION_ANGLE";
+	case JPEG_DECODER_UNSUPPORTED_SCALING:
+		return "JPEG_DECODER_UNSUPPORTED_SCALING";
+	case JPEG_DECODER_INSUFFICIENT_OUTPUTBUFFER_SIZE:
+		return "JPEG_DECODER_INSUFFICIENT_OUTPUTBUFFER_SIZE";
+	case JPEG_DECODER_BAD_HWCFG_GP_VERSION_VALUE:
+		return "JPEG_DECODER_BAD_HWCFG_GP_VERSION_VALUE";
+	case JPEG_DECODER_BAD_VALUE_FROM_RED:
+		return "JPEG_DECODER_BAD_VALUE_FROM_RED";
+	case JPEG_DECODER_BAD_SUBREGION_PARAMETERS:
+		return "JPEG_DECODER_BAD_SUBREGION_PARAMETERS";
+	case JPEG_DECODER_PROGRESSIVE_DECODE_NOT_SUPPORTED:
+		return "JPEG_DECODER_PROGRESSIVE_DECODE_NOT_SUPPORTED";
+	case JPEG_DECODER_ERROR_TASK_TIMEOUT:
+		return "JPEG_DECODER_ERROR_TASK_TIMEOUT";
+	case JPEG_DECODER_ERROR_FEATURE_NOT_SUPPORTED:
+		return "JPEG_DECODER_ERROR_FEATURE_NOT_SUPPORTED";
+	default:
+		return "!unknown MJPEG error!";
+	}
+}
+
+static bool delta_mjpeg_check_status(struct delta_ctx *pctx,
+				     struct jpeg_decode_return_params_t *status)
+{
+	struct delta_dev *delta = pctx->dev;
+	bool dump = false;
+
+	if (status->error_code == JPEG_DECODER_NO_ERROR)
+		goto out;
+
+	if (is_stream_error(status->error_code)) {
+		dev_warn_ratelimited(delta->dev,
+				     "%s  firmware: stream error @ frame %d (%s)\n",
+				     pctx->name, pctx->decoded_frames,
+				     err_str(status->error_code));
+		pctx->stream_errors++;
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
+		"%s  firmware: decoding time(us)=%d\n", pctx->name,
+		status->decode_time_in_us);
+
+	return dump;
+}
+
+static int delta_mjpeg_ipc_open(struct delta_ctx *pctx)
+{
+	struct delta_dev *delta = pctx->dev;
+	struct delta_mjpeg_ctx *ctx = to_ctx(pctx);
+	int ret = 0;
+	struct jpeg_video_decode_init_params_t params_struct;
+	struct jpeg_video_decode_init_params_t *params = &params_struct;
+	struct delta_buf *ipc_buf;
+	u32 ipc_buf_size;
+	struct delta_ipc_param ipc_param;
+	void *hdl;
+
+	memset(params, 0, sizeof(*params));
+	params->circular_buffer_begin_addr_p = 0x00000000;
+	params->circular_buffer_end_addr_p = 0xffffffff;
+
+	dev_vdbg(delta->dev,
+		 "%s  %s\n", pctx->name,
+		 ipc_open_param_str(params, ctx->str, sizeof(ctx->str)));
+
+	ipc_param.size = sizeof(*params);
+	ipc_param.data = params;
+	ipc_buf_size = sizeof(struct jpeg_decode_params_t) +
+	    sizeof(struct jpeg_decode_return_params_t);
+	ret = delta_ipc_open(pctx, "JPEG_DECODER_HW0", &ipc_param,
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
+	return 0;
+}
+
+static int delta_mjpeg_ipc_decode(struct delta_ctx *pctx, struct delta_au *au)
+{
+	struct delta_dev *delta = pctx->dev;
+	struct delta_mjpeg_ctx *ctx = to_ctx(pctx);
+	int ret = 0;
+	struct jpeg_decode_params_t *params = ctx->ipc_buf->vaddr;
+	struct jpeg_decode_return_params_t *status =
+	    ctx->ipc_buf->vaddr + sizeof(*params);
+	struct delta_frame *frame;
+	struct delta_ipc_param ipc_param, ipc_status;
+
+	ret = delta_get_free_frame(pctx, &frame);
+	if (ret)
+		return ret;
+
+	memset(params, 0, sizeof(*params));
+
+	params->picture_start_addr_p = (u32)(au->paddr);
+	params->picture_end_addr_p = (u32)(au->paddr + au->size - 1);
+
+	/*
+	 * !WARNING!
+	 * the NV12 decoded frame is only available
+	 * on decimated output when enabling flag
+	 * "JPEG_ADDITIONAL_FLAG_420MB"...
+	 * the non decimated output gives YUV422SP
+	 */
+	params->main_aux_enable = JPEG_DISP_AUX_EN;
+	params->additional_flags = JPEG_ADDITIONAL_FLAG_420MB;
+	params->horizontal_decimation_factor = JPEG_HDEC_1;
+	params->vertical_decimation_factor = JPEG_VDEC_1;
+	params->decoding_mode = JPEG_NORMAL_DECODE;
+
+	params->display_buffer_addr.struct_size =
+	    sizeof(struct jpeg_display_buffer_address_t);
+	params->display_buffer_addr.display_decimated_luma_p =
+	    (u32)frame->paddr;
+	params->display_buffer_addr.display_decimated_chroma_p =
+	    (u32)(frame->paddr
+		  + frame->info.aligned_width * frame->info.aligned_height);
+
+	dev_vdbg(delta->dev,
+		 "%s  %s\n", pctx->name,
+		 ipc_decode_param_str(params, ctx->str, sizeof(ctx->str)));
+
+	/* status */
+	memset(status, 0, sizeof(*status));
+	status->error_code = JPEG_DECODER_NO_ERROR;
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
+	if (delta_mjpeg_check_status(pctx, status)) {
+		dev_err(delta->dev,
+			"%s  dumping command %s\n", pctx->name,
+			ipc_decode_param_str(params, ctx->str,
+					     sizeof(ctx->str)));
+	}
+
+	frame->field = V4L2_FIELD_NONE;
+	frame->flags = V4L2_BUF_FLAG_KEYFRAME;
+	frame->state |= DELTA_FRAME_DEC;
+
+	ctx->out_frame = frame;
+
+	return 0;
+}
+
+static int delta_mjpeg_open(struct delta_ctx *pctx)
+{
+	struct delta_mjpeg_ctx *ctx;
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+	pctx->priv = ctx;
+
+	return 0;
+}
+
+static int delta_mjpeg_close(struct delta_ctx *pctx)
+{
+	struct delta_mjpeg_ctx *ctx = to_ctx(pctx);
+
+	if (ctx->ipc_hdl) {
+		delta_ipc_close(ctx->ipc_hdl);
+		ctx->ipc_hdl = NULL;
+	}
+
+	kfree(ctx);
+
+	return 0;
+}
+
+static int delta_mjpeg_get_streaminfo(struct delta_ctx *pctx,
+				      struct delta_streaminfo *streaminfo)
+{
+	struct delta_mjpeg_ctx *ctx = to_ctx(pctx);
+
+	if (!ctx->header)
+		goto nodata;
+
+	streaminfo->streamformat = V4L2_PIX_FMT_MJPEG;
+	streaminfo->width = ctx->header->frame_width;
+	streaminfo->height = ctx->header->frame_height;
+
+	/* progressive stream */
+	streaminfo->field = V4L2_FIELD_NONE;
+
+	streaminfo->dpb = 1;
+
+	return 0;
+
+nodata:
+	return -ENODATA;
+}
+
+static int delta_mjpeg_decode(struct delta_ctx *pctx, struct delta_au *pau)
+{
+	struct delta_dev *delta = pctx->dev;
+	struct delta_mjpeg_ctx *ctx = to_ctx(pctx);
+	int ret;
+	struct delta_au au = *pau;
+	unsigned int data_offset;
+	struct mjpeg_header *header = &ctx->header_struct;
+
+	if (!ctx->header) {
+		ret = delta_mjpeg_read_header(pctx, au.vaddr, au.size,
+					      header, &data_offset);
+		if (ret) {
+			pctx->stream_errors++;
+			goto err;
+		}
+		if (header->frame_width * header->frame_height >
+		    DELTA_MJPEG_MAX_RESO) {
+			dev_err(delta->dev,
+				"%s  stream resolution too large: %dx%d > %d pixels budget\n",
+				pctx->name,
+				header->frame_width,
+				header->frame_height, DELTA_MJPEG_MAX_RESO);
+			ret = -EINVAL;
+			goto err;
+		}
+		ctx->header = header;
+		goto out;
+	}
+
+	if (!ctx->ipc_hdl) {
+		ret = delta_mjpeg_ipc_open(pctx);
+		if (ret)
+			goto err;
+	}
+
+	ret = delta_mjpeg_read_header(pctx, au.vaddr, au.size,
+				      ctx->header, &data_offset);
+	if (ret) {
+		pctx->stream_errors++;
+		goto err;
+	}
+
+	au.paddr += data_offset;
+	au.vaddr += data_offset;
+
+	ret = delta_mjpeg_ipc_decode(pctx, &au);
+	if (ret)
+		goto err;
+
+out:
+	return 0;
+
+err:
+	return ret;
+}
+
+static int delta_mjpeg_get_frame(struct delta_ctx *pctx,
+				 struct delta_frame **frame)
+{
+	struct delta_mjpeg_ctx *ctx = to_ctx(pctx);
+
+	if (!ctx->out_frame)
+		return -ENODATA;
+
+	*frame = ctx->out_frame;
+
+	ctx->out_frame = NULL;
+
+	return 0;
+}
+
+const struct delta_dec mjpegdec = {
+	.name = "MJPEG",
+	.streamformat = V4L2_PIX_FMT_MJPEG,
+	.pixelformat = V4L2_PIX_FMT_NV12,
+	.open = delta_mjpeg_open,
+	.close = delta_mjpeg_close,
+	.get_streaminfo = delta_mjpeg_get_streaminfo,
+	.get_frameinfo = delta_get_frameinfo_default,
+	.decode = delta_mjpeg_decode,
+	.get_frame = delta_mjpeg_get_frame,
+	.recycle = delta_recycle_default,
+};
diff --git a/drivers/media/platform/sti/delta/delta-mjpeg-fw.h b/drivers/media/platform/sti/delta/delta-mjpeg-fw.h
new file mode 100644
index 0000000..de803d0
--- /dev/null
+++ b/drivers/media/platform/sti/delta/delta-mjpeg-fw.h
@@ -0,0 +1,225 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2015
+ * Author: Hugues Fruchet <hugues.fruchet@st.com> for STMicroelectronics.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#ifndef DELTA_MJPEG_FW_H
+#define DELTA_MJPEG_FW_H
+
+/*
+ * struct jpeg_decoded_buffer_address_t
+ *
+ * defines the addresses where the decoded picture/additional
+ * info related to the block structures will be stored
+ *
+ * @display_luma_p:		address of the luma buffer
+ * @display_chroma_p:		address of the chroma buffer
+ */
+struct jpeg_decoded_buffer_address_t {
+	u32 luma_p;
+	u32 chroma_p;
+};
+
+/*
+ * struct jpeg_display_buffer_address_t
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
+struct jpeg_display_buffer_address_t {
+	u32 struct_size;
+	u32 display_luma_p;
+	u32 display_chroma_p;
+	u32 display_decimated_luma_p;
+	u32 display_decimated_chroma_p;
+};
+
+/*
+ * used for enabling main/aux outputs for both display &
+ * reference reconstruction blocks
+ */
+enum jpeg_rcn_ref_disp_enable_t {
+	/* enable decimated (for display) reconstruction */
+	JPEG_DISP_AUX_EN = 0x00000010,
+	/* enable main (for display) reconstruction */
+	JPEG_DISP_MAIN_EN = 0x00000020,
+	/* enable both main & decimated (for display) reconstruction */
+	JPEG_DISP_AUX_MAIN_EN = 0x00000030,
+	/* enable only reference output(ex. for trick modes) */
+	JPEG_REF_MAIN_EN = 0x00000100,
+	/*
+	 * enable reference output with decimated
+	 * (for display) reconstruction
+	 */
+	JPEG_REF_MAIN_DISP_AUX_EN = 0x00000110,
+	/*
+	 * enable reference output with main
+	 * (for display) reconstruction
+	 */
+	JPEG_REF_MAIN_DISP_MAIN_EN = 0x00000120,
+	/*
+	 * enable reference output with main & decimated
+	 * (for display) reconstruction
+	 */
+	JPEG_REF_MAIN_DISP_MAIN_AUX_EN = 0x00000130
+};
+
+/* identifies the horizontal decimation factor */
+enum jpeg_horizontal_deci_factor_t {
+	/* no resize */
+	JPEG_HDEC_1 = 0x00000000,
+	/* Advanced H/2 resize using improved 8-tap filters */
+	JPEG_HDEC_ADVANCED_2 = 0x00000101,
+	/* Advanced H/4 resize using improved 8-tap filters */
+	JPEG_HDEC_ADVANCED_4 = 0x00000102
+};
+
+/* identifies the vertical decimation factor */
+enum jpeg_vertical_deci_factor_t {
+	/* no resize */
+	JPEG_VDEC_1 = 0x00000000,
+	/* V/2 , progressive resize */
+	JPEG_VDEC_ADVANCED_2_PROG = 0x00000204,
+	/* V/2 , interlaced resize */
+	JPEG_VDEC_ADVANCED_2_INT = 0x000000208
+};
+
+/* status of the decoding process */
+enum jpeg_decoding_error_t {
+	JPEG_DECODER_NO_ERROR = 0,
+	JPEG_DECODER_UNDEFINED_HUFF_TABLE = 1,
+	JPEG_DECODER_UNSUPPORTED_MARKER = 2,
+	JPEG_DECODER_UNABLE_ALLOCATE_MEMORY = 3,
+	JPEG_DECODER_NON_SUPPORTED_SAMP_FACTORS = 4,
+	JPEG_DECODER_BAD_PARAMETER = 5,
+	JPEG_DECODER_DECODE_ERROR = 6,
+	JPEG_DECODER_BAD_RESTART_MARKER = 7,
+	JPEG_DECODER_UNSUPPORTED_COLORSPACE = 8,
+	JPEG_DECODER_BAD_SOS_SPECTRAL = 9,
+	JPEG_DECODER_BAD_SOS_SUCCESSIVE = 10,
+	JPEG_DECODER_BAD_HEADER_LENGTH = 11,
+	JPEG_DECODER_BAD_COUNT_VALUE = 12,
+	JPEG_DECODER_BAD_DHT_MARKER = 13,
+	JPEG_DECODER_BAD_INDEX_VALUE = 14,
+	JPEG_DECODER_BAD_NUMBER_HUFFMAN_TABLES = 15,
+	JPEG_DECODER_BAD_QUANT_TABLE_LENGTH = 16,
+	JPEG_DECODER_BAD_NUMBER_QUANT_TABLES = 17,
+	JPEG_DECODER_BAD_COMPONENT_COUNT = 18,
+	JPEG_DECODER_DIVIDE_BY_ZERO_ERROR = 19,
+	JPEG_DECODER_NOT_JPG_IMAGE = 20,
+	JPEG_DECODER_UNSUPPORTED_ROTATION_ANGLE = 21,
+	JPEG_DECODER_UNSUPPORTED_SCALING = 22,
+	JPEG_DECODER_INSUFFICIENT_OUTPUTBUFFER_SIZE = 23,
+	JPEG_DECODER_BAD_HWCFG_GP_VERSION_VALUE = 24,
+	JPEG_DECODER_BAD_VALUE_FROM_RED = 25,
+	JPEG_DECODER_BAD_SUBREGION_PARAMETERS = 26,
+	JPEG_DECODER_PROGRESSIVE_DECODE_NOT_SUPPORTED = 27,
+	JPEG_DECODER_ERROR_TASK_TIMEOUT = 28,
+	JPEG_DECODER_ERROR_FEATURE_NOT_SUPPORTED = 29
+};
+
+/* identifies the decoding mode */
+enum jpeg_decoding_mode_t {
+	JPEG_NORMAL_DECODE = 0,
+};
+
+enum jpeg_additional_flags_t {
+	JPEG_ADDITIONAL_FLAG_NONE = 0,
+	/* request firmware to return values of the CEH registers */
+	JPEG_ADDITIONAL_FLAG_CEH = 1,
+	/* output storage of auxiliary reconstruction in Raster format. */
+	JPEG_ADDITIONAL_FLAG_RASTER = 64,
+	/* output storage of auxiliary reconstruction in 420MB format. */
+	JPEG_ADDITIONAL_FLAG_420MB = 128
+};
+
+/*
+ * struct jpeg_video_decode_init_params_t - initialization command parameters
+ *
+ * @circular_buffer_begin_addr_p:	start address of fw circular buffer
+ * @circular_buffer_end_addr_p:		end address of fw circular buffer
+ */
+struct jpeg_video_decode_init_params_t {
+	u32 circular_buffer_begin_addr_p;
+	u32 circular_buffer_end_addr_p;
+	u32 reserved;
+};
+
+/*
+ * struct jpeg_decode_params_t - decode command parameters
+ *
+ * @picture_start_addr_p:	start address of jpeg picture
+ * @picture_end_addr_p:		end address of jpeg picture
+ * @decoded_buffer_addr:	decoded picture buffer
+ * @display_buffer_addr:	display picture buffer
+ * @main_aux_enable:		enable main and/or aux outputs
+ * @horizontal_decimation_factor:horizontal decimation factor
+ * @vertical_decimation_factor:	vertical decimation factor
+ * @xvalue0:			the x(0) coordinate for subregion decoding
+ * @xvalue1:			the x(1) coordinate for subregion decoding
+ * @yvalue0:			the y(0) coordinate for subregion decoding
+ * @yvalue1:			the y(1) coordinate for subregion decoding
+ * @decoding_mode:		decoding mode
+ * @additional_flags:		additional flags
+ * @field_flag:			determines frame/field scan
+ * @is_jpeg_image:		1 = still jpeg, 0 = motion jpeg
+ */
+struct jpeg_decode_params_t {
+	u32 picture_start_addr_p;
+	u32 picture_end_addr_p;
+	struct jpeg_decoded_buffer_address_t decoded_buffer_addr;
+	struct jpeg_display_buffer_address_t display_buffer_addr;
+	enum jpeg_rcn_ref_disp_enable_t main_aux_enable;
+	enum jpeg_horizontal_deci_factor_t horizontal_decimation_factor;
+	enum jpeg_vertical_deci_factor_t vertical_decimation_factor;
+	u32 xvalue0;
+	u32 xvalue1;
+	u32 yvalue0;
+	u32 yvalue1;
+	enum jpeg_decoding_mode_t decoding_mode;
+	u32 additional_flags;
+	u32 field_flag;
+	u32 reserved;
+	u32 is_jpeg_image;
+};
+
+/*
+ * struct jpeg_decode_return_params_t
+ *
+ * status returned by firmware after decoding
+ *
+ * @decode_time_in_us:	decoding time in microseconds
+ * @pm_cycles:		profiling information
+ * @pm_dmiss:		profiling information
+ * @pm_imiss:		profiling information
+ * @pm_bundles:		profiling information
+ * @pm_pft:		profiling information
+ * @error_code:		status of the decoding process
+ * @ceh_registers:	array where values of the Contrast Enhancement
+ *			Histogram (CEH) registers will be stored.
+ *			ceh_registers[0] correspond to register MBE_CEH_0_7,
+ *			ceh_registers[1] correspond to register MBE_CEH_8_15
+ *			ceh_registers[2] correspond to register MBE_CEH_16_23
+ *			Note that elements of this array will be updated only
+ *			if additional_flags has JPEG_ADDITIONAL_FLAG_CEH set.
+ */
+struct jpeg_decode_return_params_t {
+	/* profiling info */
+	u32 decode_time_in_us;
+	u32 pm_cycles;
+	u32 pm_dmiss;
+	u32 pm_imiss;
+	u32 pm_bundles;
+	u32 pm_pft;
+	enum jpeg_decoding_error_t error_code;
+	u32 ceh_registers[32];
+};
+
+#endif /* DELTA_MJPEG_FW_H */
diff --git a/drivers/media/platform/sti/delta/delta-mjpeg-hdr.c b/drivers/media/platform/sti/delta/delta-mjpeg-hdr.c
new file mode 100644
index 0000000..a8fd8fa
--- /dev/null
+++ b/drivers/media/platform/sti/delta/delta-mjpeg-hdr.c
@@ -0,0 +1,149 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2013
+ * Author: Hugues Fruchet <hugues.fruchet@st.com> for STMicroelectronics.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#include "delta.h"
+#include "delta-mjpeg.h"
+
+#define MJPEG_SOF_0  0xc0
+#define MJPEG_SOF_1  0xc1
+#define MJPEG_SOI    0xd8
+#define MJPEG_MARKER 0xff
+
+static char *header_str(struct mjpeg_header *header,
+			char *str,
+			unsigned int len)
+{
+	char *cur = str;
+	unsigned int left = len;
+
+	if (!header)
+		return "";
+
+	snprintf(cur, left, "[MJPEG header]\n"
+			"|- length     = %d\n"
+			"|- precision  = %d\n"
+			"|- width      = %d\n"
+			"|- height     = %d\n"
+			"|- components = %d\n",
+			header->length,
+			header->sample_precision,
+			header->frame_width,
+			header->frame_height,
+			header->nb_of_components);
+
+	return str;
+}
+
+static int delta_mjpeg_read_sof(struct delta_ctx *pctx,
+				unsigned char *data, unsigned int size,
+				struct mjpeg_header *header)
+{
+	struct delta_dev *delta = pctx->dev;
+	unsigned int offset = 0;
+
+	if (size < 64)
+		goto err_no_more;
+
+	memset(header, 0, sizeof(*header));
+	header->length           = be16_to_cpu(*(__be16 *)(data + offset));
+	offset += sizeof(u16);
+	header->sample_precision = *(u8 *)(data + offset);
+	offset += sizeof(u8);
+	header->frame_height     = be16_to_cpu(*(__be16 *)(data + offset));
+	offset += sizeof(u16);
+	header->frame_width      = be16_to_cpu(*(__be16 *)(data + offset));
+	offset += sizeof(u16);
+	header->nb_of_components = *(u8 *)(data + offset);
+	offset += sizeof(u8);
+
+	if (header->nb_of_components >= MJPEG_MAX_COMPONENTS) {
+		dev_err(delta->dev,
+			"%s   unsupported number of components (%d > %d)\n",
+			pctx->name, header->nb_of_components,
+			MJPEG_MAX_COMPONENTS);
+		return -EINVAL;
+	}
+
+	if ((offset + header->nb_of_components *
+	     sizeof(header->components[0])) > size)
+		goto err_no_more;
+
+	return 0;
+
+err_no_more:
+	dev_err(delta->dev,
+		"%s   sof: reached end of %d size input stream\n",
+		pctx->name, size);
+	return -ENODATA;
+}
+
+int delta_mjpeg_read_header(struct delta_ctx *pctx,
+			    unsigned char *data, unsigned int size,
+			    struct mjpeg_header *header,
+			    unsigned int *data_offset)
+{
+	struct delta_dev *delta = pctx->dev;
+	unsigned char str[200];
+
+	unsigned int ret = 0;
+	unsigned int offset = 0;
+	unsigned int soi = 0;
+
+	if (size < 2)
+		goto err_no_more;
+
+	offset = 0;
+	while (1) {
+		if (data[offset] == MJPEG_MARKER)
+			switch (data[offset + 1]) {
+			case MJPEG_SOI:
+				soi = 1;
+				*data_offset = offset;
+				break;
+
+			case MJPEG_SOF_0:
+			case MJPEG_SOF_1:
+				if (!soi) {
+					dev_err(delta->dev,
+						"%s   wrong sequence, got SOF while SOI not seen\n",
+						pctx->name);
+					return -EINVAL;
+				}
+
+				ret = delta_mjpeg_read_sof(pctx,
+							   &data[offset + 2],
+							   size - (offset + 2),
+							   header);
+				if (ret)
+					goto err;
+
+				goto done;
+
+			default:
+				break;
+			}
+
+		offset++;
+		if ((offset + 2) >= size)
+			goto err_no_more;
+	}
+
+done:
+	dev_dbg(delta->dev,
+		"%s   found header @ offset %d:\n%s", pctx->name,
+		*data_offset,
+		header_str(header, str, sizeof(str)));
+	return 0;
+
+err_no_more:
+	dev_err(delta->dev,
+		"%s   no header found within %d bytes input stream\n",
+		pctx->name, size);
+	return -ENODATA;
+
+err:
+	return ret;
+}
diff --git a/drivers/media/platform/sti/delta/delta-mjpeg.h b/drivers/media/platform/sti/delta/delta-mjpeg.h
new file mode 100644
index 0000000..18e6b37
--- /dev/null
+++ b/drivers/media/platform/sti/delta/delta-mjpeg.h
@@ -0,0 +1,35 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2013
+ * Author: Hugues Fruchet <hugues.fruchet@st.com> for STMicroelectronics.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#ifndef DELTA_MJPEG_H
+#define DELTA_MJPEG_H
+
+#include "delta.h"
+
+struct mjpeg_component {
+	unsigned int id;/* 1=Y, 2=Cb, 3=Cr, 4=L, 5=Q */
+	unsigned int h_sampling_factor;
+	unsigned int v_sampling_factor;
+	unsigned int quant_table_index;
+};
+
+#define MJPEG_MAX_COMPONENTS 5
+
+struct mjpeg_header {
+	unsigned int length;
+	unsigned int sample_precision;
+	unsigned int frame_width;
+	unsigned int frame_height;
+	unsigned int nb_of_components;
+	struct mjpeg_component components[MJPEG_MAX_COMPONENTS];
+};
+
+int delta_mjpeg_read_header(struct delta_ctx *pctx,
+			    unsigned char *data, unsigned int size,
+			    struct mjpeg_header *header,
+			    unsigned int *data_offset);
+
+#endif /* DELTA_MJPEG_H */
diff --git a/drivers/media/platform/sti/delta/delta-v4l2.c b/drivers/media/platform/sti/delta/delta-v4l2.c
index c959614..6b29497 100644
--- a/drivers/media/platform/sti/delta/delta-v4l2.c
+++ b/drivers/media/platform/sti/delta/delta-v4l2.c
@@ -32,6 +32,9 @@
 
 /* registry of available decoders */
 static const struct delta_dec *delta_decoders[] = {
+#ifdef CONFIG_VIDEO_STI_DELTA_MJPEG
+	&mjpegdec,
+#endif
 };
 
 static inline int frame_size(u32 w, u32 h, u32 fmt)
-- 
1.9.1

