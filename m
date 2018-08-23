Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:46633 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726900AbeHWLB3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Aug 2018 07:01:29 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 7/7] vicodec: split off v4l2 specific parts for the codec
Date: Thu, 23 Aug 2018 09:33:05 +0200
Message-Id: <20180823073305.6518-8-hverkuil@xs4all.nl>
In-Reply-To: <20180823073305.6518-1-hverkuil@xs4all.nl>
References: <20180823073305.6518-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Split off the decode and encode functions into a separate
source that can be reused elsewhere.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vicodec/Makefile       |   2 +-
 .../media/platform/vicodec/codec-v4l2-fwht.c  | 325 ++++++++++++
 .../media/platform/vicodec/codec-v4l2-fwht.h  |  50 ++
 drivers/media/platform/vicodec/vicodec-core.c | 463 ++++--------------
 4 files changed, 458 insertions(+), 382 deletions(-)
 create mode 100644 drivers/media/platform/vicodec/codec-v4l2-fwht.c
 create mode 100644 drivers/media/platform/vicodec/codec-v4l2-fwht.h

diff --git a/drivers/media/platform/vicodec/Makefile b/drivers/media/platform/vicodec/Makefile
index a27242ff14ad..01bf7e9308a6 100644
--- a/drivers/media/platform/vicodec/Makefile
+++ b/drivers/media/platform/vicodec/Makefile
@@ -1,4 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0
-vicodec-objs := vicodec-core.o codec-fwht.o
+vicodec-objs := vicodec-core.o codec-fwht.o codec-v4l2-fwht.o
 
 obj-$(CONFIG_VIDEO_VICODEC) += vicodec.o
diff --git a/drivers/media/platform/vicodec/codec-v4l2-fwht.c b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
new file mode 100644
index 000000000000..cfcf84b8574d
--- /dev/null
+++ b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
@@ -0,0 +1,325 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * A V4L2 frontend for the FWHT codec
+ *
+ * Copyright 2018 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
+ */
+
+#include <linux/errno.h>
+#include <linux/string.h>
+#include <linux/videodev2.h>
+#include "codec-v4l2-fwht.h"
+
+static const struct v4l2_fwht_pixfmt_info v4l2_fwht_pixfmts[] = {
+	{ V4L2_PIX_FMT_YUV420,  1, 3, 2, 1, 1, 2, 2 },
+	{ V4L2_PIX_FMT_YVU420,  1, 3, 2, 1, 1, 2, 2 },
+	{ V4L2_PIX_FMT_YUV422P, 1, 2, 1, 1, 1, 2, 1 },
+	{ V4L2_PIX_FMT_NV12,    1, 3, 2, 1, 2, 2, 2 },
+	{ V4L2_PIX_FMT_NV21,    1, 3, 2, 1, 2, 2, 2 },
+	{ V4L2_PIX_FMT_NV16,    1, 2, 1, 1, 2, 2, 1 },
+	{ V4L2_PIX_FMT_NV61,    1, 2, 1, 1, 2, 2, 1 },
+	{ V4L2_PIX_FMT_NV24,    1, 3, 1, 1, 2, 1, 1 },
+	{ V4L2_PIX_FMT_NV42,    1, 3, 1, 1, 2, 1, 1 },
+	{ V4L2_PIX_FMT_YUYV,    2, 2, 1, 2, 4, 2, 1 },
+	{ V4L2_PIX_FMT_YVYU,    2, 2, 1, 2, 4, 2, 1 },
+	{ V4L2_PIX_FMT_UYVY,    2, 2, 1, 2, 4, 2, 1 },
+	{ V4L2_PIX_FMT_VYUY,    2, 2, 1, 2, 4, 2, 1 },
+	{ V4L2_PIX_FMT_BGR24,   3, 3, 1, 3, 3, 1, 1 },
+	{ V4L2_PIX_FMT_RGB24,   3, 3, 1, 3, 3, 1, 1 },
+	{ V4L2_PIX_FMT_HSV24,   3, 3, 1, 3, 3, 1, 1 },
+	{ V4L2_PIX_FMT_BGR32,   4, 4, 1, 4, 4, 1, 1 },
+	{ V4L2_PIX_FMT_XBGR32,  4, 4, 1, 4, 4, 1, 1 },
+	{ V4L2_PIX_FMT_RGB32,   4, 4, 1, 4, 4, 1, 1 },
+	{ V4L2_PIX_FMT_XRGB32,  4, 4, 1, 4, 4, 1, 1 },
+	{ V4L2_PIX_FMT_HSV32,   4, 4, 1, 4, 4, 1, 1 },
+};
+
+const struct v4l2_fwht_pixfmt_info *v4l2_fwht_find_pixfmt(u32 pixelformat)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(v4l2_fwht_pixfmts); i++)
+		if (v4l2_fwht_pixfmts[i].id == pixelformat)
+			return v4l2_fwht_pixfmts + i;
+	return NULL;
+}
+
+const struct v4l2_fwht_pixfmt_info *v4l2_fwht_get_pixfmt(u32 idx)
+{
+	if (idx >= ARRAY_SIZE(v4l2_fwht_pixfmts))
+		return NULL;
+	return v4l2_fwht_pixfmts + idx;
+}
+
+unsigned int v4l2_fwht_encode(struct v4l2_fwht_state *state,
+			      u8 *p_in, u8 *p_out)
+{
+	unsigned int size = state->width * state->height;
+	const struct v4l2_fwht_pixfmt_info *info = state->info;
+	struct fwht_cframe_hdr *p_hdr;
+	struct fwht_cframe cf;
+	struct fwht_raw_frame rf;
+	u32 encoding;
+	u32 flags = 0;
+
+	rf.width = state->width;
+	rf.height = state->height;
+	rf.luma = p_in;
+	rf.width_div = info->width_div;
+	rf.height_div = info->height_div;
+	rf.luma_step = info->luma_step;
+	rf.chroma_step = info->chroma_step;
+
+	switch (info->id) {
+	case V4L2_PIX_FMT_YUV420:
+		rf.cb = rf.luma + size;
+		rf.cr = rf.cb + size / 4;
+		break;
+	case V4L2_PIX_FMT_YVU420:
+		rf.cr = rf.luma + size;
+		rf.cb = rf.cr + size / 4;
+		break;
+	case V4L2_PIX_FMT_YUV422P:
+		rf.cb = rf.luma + size;
+		rf.cr = rf.cb + size / 2;
+		break;
+	case V4L2_PIX_FMT_NV12:
+	case V4L2_PIX_FMT_NV16:
+	case V4L2_PIX_FMT_NV24:
+		rf.cb = rf.luma + size;
+		rf.cr = rf.cb + 1;
+		break;
+	case V4L2_PIX_FMT_NV21:
+	case V4L2_PIX_FMT_NV61:
+	case V4L2_PIX_FMT_NV42:
+		rf.cr = rf.luma + size;
+		rf.cb = rf.cr + 1;
+		break;
+	case V4L2_PIX_FMT_YUYV:
+		rf.cb = rf.luma + 1;
+		rf.cr = rf.cb + 2;
+		break;
+	case V4L2_PIX_FMT_YVYU:
+		rf.cr = rf.luma + 1;
+		rf.cb = rf.cr + 2;
+		break;
+	case V4L2_PIX_FMT_UYVY:
+		rf.cb = rf.luma;
+		rf.cr = rf.cb + 2;
+		rf.luma++;
+		break;
+	case V4L2_PIX_FMT_VYUY:
+		rf.cr = rf.luma;
+		rf.cb = rf.cr + 2;
+		rf.luma++;
+		break;
+	case V4L2_PIX_FMT_RGB24:
+	case V4L2_PIX_FMT_HSV24:
+		rf.cr = rf.luma;
+		rf.cb = rf.cr + 2;
+		rf.luma++;
+		break;
+	case V4L2_PIX_FMT_BGR24:
+		rf.cb = rf.luma;
+		rf.cr = rf.cb + 2;
+		rf.luma++;
+		break;
+	case V4L2_PIX_FMT_RGB32:
+	case V4L2_PIX_FMT_XRGB32:
+	case V4L2_PIX_FMT_HSV32:
+		rf.cr = rf.luma + 1;
+		rf.cb = rf.cr + 2;
+		rf.luma += 2;
+		break;
+	case V4L2_PIX_FMT_BGR32:
+	case V4L2_PIX_FMT_XBGR32:
+		rf.cb = rf.luma;
+		rf.cr = rf.cb + 2;
+		rf.luma++;
+		break;
+	}
+
+	cf.width = state->width;
+	cf.height = state->height;
+	cf.i_frame_qp = state->i_frame_qp;
+	cf.p_frame_qp = state->p_frame_qp;
+	cf.rlc_data = (__be16 *)(p_out + sizeof(*p_hdr));
+
+	encoding = fwht_encode_frame(&rf, &state->ref_frame, &cf,
+				     !state->gop_cnt,
+				     state->gop_cnt == state->gop_size - 1);
+	if (!(encoding & FWHT_FRAME_PCODED))
+		state->gop_cnt = 0;
+	if (++state->gop_cnt >= state->gop_size)
+		state->gop_cnt = 0;
+
+	p_hdr = (struct fwht_cframe_hdr *)p_out;
+	p_hdr->magic1 = FWHT_MAGIC1;
+	p_hdr->magic2 = FWHT_MAGIC2;
+	p_hdr->version = htonl(FWHT_VERSION);
+	p_hdr->width = htonl(cf.width);
+	p_hdr->height = htonl(cf.height);
+	if (encoding & FWHT_LUMA_UNENCODED)
+		flags |= FWHT_FL_LUMA_IS_UNCOMPRESSED;
+	if (encoding & FWHT_CB_UNENCODED)
+		flags |= FWHT_FL_CB_IS_UNCOMPRESSED;
+	if (encoding & FWHT_CR_UNENCODED)
+		flags |= FWHT_FL_CR_IS_UNCOMPRESSED;
+	if (rf.height_div == 1)
+		flags |= FWHT_FL_CHROMA_FULL_HEIGHT;
+	if (rf.width_div == 1)
+		flags |= FWHT_FL_CHROMA_FULL_WIDTH;
+	p_hdr->flags = htonl(flags);
+	p_hdr->colorspace = htonl(state->colorspace);
+	p_hdr->xfer_func = htonl(state->xfer_func);
+	p_hdr->ycbcr_enc = htonl(state->ycbcr_enc);
+	p_hdr->quantization = htonl(state->quantization);
+	p_hdr->size = htonl(cf.size);
+	state->ref_frame.width = cf.width;
+	state->ref_frame.height = cf.height;
+	return cf.size + sizeof(*p_hdr);
+}
+
+int v4l2_fwht_decode(struct v4l2_fwht_state *state,
+		     u8 *p_in, u8 *p_out)
+{
+	unsigned int size = state->width * state->height;
+	unsigned int chroma_size = size;
+	unsigned int i;
+	u32 flags;
+	struct fwht_cframe_hdr *p_hdr;
+	struct fwht_cframe cf;
+	u8 *p;
+
+	p_hdr = (struct fwht_cframe_hdr *)p_in;
+	cf.width = ntohl(p_hdr->width);
+	cf.height = ntohl(p_hdr->height);
+	flags = ntohl(p_hdr->flags);
+	state->colorspace = ntohl(p_hdr->colorspace);
+	state->xfer_func = ntohl(p_hdr->xfer_func);
+	state->ycbcr_enc = ntohl(p_hdr->ycbcr_enc);
+	state->quantization = ntohl(p_hdr->quantization);
+	cf.rlc_data = (__be16 *)(p_in + sizeof(*p_hdr));
+
+	if (p_hdr->magic1 != FWHT_MAGIC1 ||
+	    p_hdr->magic2 != FWHT_MAGIC2 ||
+	    ntohl(p_hdr->version) != FWHT_VERSION ||
+	    (cf.width & 7) || (cf.height & 7))
+		return -EINVAL;
+
+	/* TODO: support resolution changes */
+	if (cf.width != state->width || cf.height != state->height)
+		return -EINVAL;
+
+	if (!(flags & FWHT_FL_CHROMA_FULL_WIDTH))
+		chroma_size /= 2;
+	if (!(flags & FWHT_FL_CHROMA_FULL_HEIGHT))
+		chroma_size /= 2;
+
+	fwht_decode_frame(&cf, &state->ref_frame, flags);
+
+	switch (state->info->id) {
+	case V4L2_PIX_FMT_YUV420:
+	case V4L2_PIX_FMT_YUV422P:
+		memcpy(p_out, state->ref_frame.luma, size);
+		p_out += size;
+		memcpy(p_out, state->ref_frame.cb, chroma_size);
+		p_out += chroma_size;
+		memcpy(p_out, state->ref_frame.cr, chroma_size);
+		break;
+	case V4L2_PIX_FMT_YVU420:
+		memcpy(p_out, state->ref_frame.luma, size);
+		p_out += size;
+		memcpy(p_out, state->ref_frame.cr, chroma_size);
+		p_out += chroma_size;
+		memcpy(p_out, state->ref_frame.cb, chroma_size);
+		break;
+	case V4L2_PIX_FMT_NV12:
+	case V4L2_PIX_FMT_NV16:
+	case V4L2_PIX_FMT_NV24:
+		memcpy(p_out, state->ref_frame.luma, size);
+		p_out += size;
+		for (i = 0, p = p_out; i < chroma_size; i++) {
+			*p++ = state->ref_frame.cb[i];
+			*p++ = state->ref_frame.cr[i];
+		}
+		break;
+	case V4L2_PIX_FMT_NV21:
+	case V4L2_PIX_FMT_NV61:
+	case V4L2_PIX_FMT_NV42:
+		memcpy(p_out, state->ref_frame.luma, size);
+		p_out += size;
+		for (i = 0, p = p_out; i < chroma_size; i++) {
+			*p++ = state->ref_frame.cr[i];
+			*p++ = state->ref_frame.cb[i];
+		}
+		break;
+	case V4L2_PIX_FMT_YUYV:
+		for (i = 0, p = p_out; i < size; i += 2) {
+			*p++ = state->ref_frame.luma[i];
+			*p++ = state->ref_frame.cb[i / 2];
+			*p++ = state->ref_frame.luma[i + 1];
+			*p++ = state->ref_frame.cr[i / 2];
+		}
+		break;
+	case V4L2_PIX_FMT_YVYU:
+		for (i = 0, p = p_out; i < size; i += 2) {
+			*p++ = state->ref_frame.luma[i];
+			*p++ = state->ref_frame.cr[i / 2];
+			*p++ = state->ref_frame.luma[i + 1];
+			*p++ = state->ref_frame.cb[i / 2];
+		}
+		break;
+	case V4L2_PIX_FMT_UYVY:
+		for (i = 0, p = p_out; i < size; i += 2) {
+			*p++ = state->ref_frame.cb[i / 2];
+			*p++ = state->ref_frame.luma[i];
+			*p++ = state->ref_frame.cr[i / 2];
+			*p++ = state->ref_frame.luma[i + 1];
+		}
+		break;
+	case V4L2_PIX_FMT_VYUY:
+		for (i = 0, p = p_out; i < size; i += 2) {
+			*p++ = state->ref_frame.cr[i / 2];
+			*p++ = state->ref_frame.luma[i];
+			*p++ = state->ref_frame.cb[i / 2];
+			*p++ = state->ref_frame.luma[i + 1];
+		}
+		break;
+	case V4L2_PIX_FMT_RGB24:
+	case V4L2_PIX_FMT_HSV24:
+		for (i = 0, p = p_out; i < size; i++) {
+			*p++ = state->ref_frame.cr[i];
+			*p++ = state->ref_frame.luma[i];
+			*p++ = state->ref_frame.cb[i];
+		}
+		break;
+	case V4L2_PIX_FMT_BGR24:
+		for (i = 0, p = p_out; i < size; i++) {
+			*p++ = state->ref_frame.cb[i];
+			*p++ = state->ref_frame.luma[i];
+			*p++ = state->ref_frame.cr[i];
+		}
+		break;
+	case V4L2_PIX_FMT_RGB32:
+	case V4L2_PIX_FMT_XRGB32:
+	case V4L2_PIX_FMT_HSV32:
+		for (i = 0, p = p_out; i < size; i++) {
+			*p++ = 0;
+			*p++ = state->ref_frame.cr[i];
+			*p++ = state->ref_frame.luma[i];
+			*p++ = state->ref_frame.cb[i];
+		}
+		break;
+	case V4L2_PIX_FMT_BGR32:
+	case V4L2_PIX_FMT_XBGR32:
+		for (i = 0, p = p_out; i < size; i++) {
+			*p++ = state->ref_frame.cb[i];
+			*p++ = state->ref_frame.luma[i];
+			*p++ = state->ref_frame.cr[i];
+			*p++ = 0;
+		}
+		break;
+	}
+	return 0;
+}
diff --git a/drivers/media/platform/vicodec/codec-v4l2-fwht.h b/drivers/media/platform/vicodec/codec-v4l2-fwht.h
new file mode 100644
index 000000000000..7794c186d905
--- /dev/null
+++ b/drivers/media/platform/vicodec/codec-v4l2-fwht.h
@@ -0,0 +1,50 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright 2018 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
+ */
+
+#ifndef CODEC_V4L2_FWHT_H
+#define CODEC_V4L2_FWHT_H
+
+#include "codec-fwht.h"
+
+struct v4l2_fwht_pixfmt_info {
+	u32 id;
+	unsigned int bytesperline_mult;
+	unsigned int sizeimage_mult;
+	unsigned int sizeimage_div;
+	unsigned int luma_step;
+	unsigned int chroma_step;
+	/* Chroma plane subsampling */
+	unsigned int width_div;
+	unsigned int height_div;
+};
+
+struct v4l2_fwht_state {
+	const struct v4l2_fwht_pixfmt_info *info;
+	unsigned int width;
+	unsigned int height;
+	unsigned int gop_size;
+	unsigned int gop_cnt;
+	u16 i_frame_qp;
+	u16 p_frame_qp;
+
+	enum v4l2_colorspace colorspace;
+	enum v4l2_ycbcr_encoding ycbcr_enc;
+	enum v4l2_xfer_func xfer_func;
+	enum v4l2_quantization quantization;
+
+	struct fwht_raw_frame ref_frame;
+	u8 *compressed_frame;
+};
+
+const struct v4l2_fwht_pixfmt_info *v4l2_fwht_find_pixfmt(u32 pixelformat);
+const struct v4l2_fwht_pixfmt_info *v4l2_fwht_get_pixfmt(u32 idx);
+
+unsigned int v4l2_fwht_encode(struct v4l2_fwht_state *state,
+			      u8 *p_in, u8 *p_out);
+
+int v4l2_fwht_decode(struct v4l2_fwht_state *state,
+		     u8 *p_in, u8 *p_out);
+
+#endif
diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index 4f2c35533e08..fdd77441a47b 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -23,7 +23,7 @@
 #include <media/v4l2-event.h>
 #include <media/videobuf2-vmalloc.h>
 
-#include "codec-fwht.h"
+#include "codec-v4l2-fwht.h"
 
 MODULE_DESCRIPTION("Virtual codec device");
 MODULE_AUTHOR("Hans Verkuil <hans.verkuil@cisco.com>");
@@ -60,31 +60,7 @@ struct pixfmt_info {
 	unsigned int height_div;
 };
 
-static const struct pixfmt_info pixfmts[] = {
-	{ V4L2_PIX_FMT_YUV420,  1, 3, 2, 1, 1, 2, 2 },
-	{ V4L2_PIX_FMT_YVU420,  1, 3, 2, 1, 1, 2, 2 },
-	{ V4L2_PIX_FMT_YUV422P, 1, 2, 1, 1, 1, 2, 1 },
-	{ V4L2_PIX_FMT_NV12,    1, 3, 2, 1, 2, 2, 2 },
-	{ V4L2_PIX_FMT_NV21,    1, 3, 2, 1, 2, 2, 2 },
-	{ V4L2_PIX_FMT_NV16,    1, 2, 1, 1, 2, 2, 1 },
-	{ V4L2_PIX_FMT_NV61,    1, 2, 1, 1, 2, 2, 1 },
-	{ V4L2_PIX_FMT_NV24,    1, 3, 1, 1, 2, 1, 1 },
-	{ V4L2_PIX_FMT_NV42,    1, 3, 1, 1, 2, 1, 1 },
-	{ V4L2_PIX_FMT_YUYV,    2, 2, 1, 2, 4, 2, 1 },
-	{ V4L2_PIX_FMT_YVYU,    2, 2, 1, 2, 4, 2, 1 },
-	{ V4L2_PIX_FMT_UYVY,    2, 2, 1, 2, 4, 2, 1 },
-	{ V4L2_PIX_FMT_VYUY,    2, 2, 1, 2, 4, 2, 1 },
-	{ V4L2_PIX_FMT_BGR24,   3, 3, 1, 3, 3, 1, 1 },
-	{ V4L2_PIX_FMT_RGB24,   3, 3, 1, 3, 3, 1, 1 },
-	{ V4L2_PIX_FMT_HSV24,   3, 3, 1, 3, 3, 1, 1 },
-	{ V4L2_PIX_FMT_BGR32,   4, 4, 1, 4, 4, 1, 1 },
-	{ V4L2_PIX_FMT_XBGR32,  4, 4, 1, 4, 4, 1, 1 },
-	{ V4L2_PIX_FMT_RGB32,   4, 4, 1, 4, 4, 1, 1 },
-	{ V4L2_PIX_FMT_XRGB32,  4, 4, 1, 4, 4, 1, 1 },
-	{ V4L2_PIX_FMT_HSV32,   4, 4, 1, 4, 4, 1, 1 },
-};
-
-static const struct pixfmt_info pixfmt_fwht = {
+static const struct v4l2_fwht_pixfmt_info pixfmt_fwht = {
 	V4L2_PIX_FMT_FWHT, 0, 3, 1, 1, 1, 1, 1
 };
 
@@ -103,7 +79,7 @@ struct vicodec_q_data {
 	unsigned int		height;
 	unsigned int		sizeimage;
 	unsigned int		sequence;
-	const struct pixfmt_info *info;
+	const struct v4l2_fwht_pixfmt_info *info;
 };
 
 enum {
@@ -135,25 +111,16 @@ struct vicodec_ctx {
 	spinlock_t		*lock;
 
 	struct v4l2_ctrl_handler hdl;
-	unsigned int		gop_size;
-	unsigned int		gop_cnt;
-	u16			i_frame_qp;
-	u16			p_frame_qp;
 
 	/* Abort requested by m2m */
 	int			aborting;
 	struct vb2_v4l2_buffer *last_src_buf;
 	struct vb2_v4l2_buffer *last_dst_buf;
 
-	enum v4l2_colorspace	colorspace;
-	enum v4l2_ycbcr_encoding ycbcr_enc;
-	enum v4l2_xfer_func	xfer_func;
-	enum v4l2_quantization	quantization;
-
 	/* Source and destination queue data */
 	struct vicodec_q_data   q_data[2];
-	struct fwht_raw_frame	ref_frame;
-	u8			*compressed_frame;
+	struct v4l2_fwht_state	state;
+
 	u32			cur_buf_offset;
 	u32			comp_max_size;
 	u32			comp_size;
@@ -185,288 +152,13 @@ static struct vicodec_q_data *get_q_data(struct vicodec_ctx *ctx,
 	return NULL;
 }
 
-static void encode(struct vicodec_ctx *ctx,
-		   struct vicodec_q_data *q_data,
-		   u8 *p_in, u8 *p_out, u32 flags)
-{
-	unsigned int size = q_data->width * q_data->height;
-	const struct pixfmt_info *info = q_data->info;
-	struct fwht_cframe_hdr *p_hdr;
-	struct fwht_cframe cf;
-	struct fwht_raw_frame rf;
-	u32 encoding;
-
-	rf.width = q_data->width;
-	rf.height = q_data->height;
-	rf.luma = p_in;
-	rf.width_div = info->width_div;
-	rf.height_div = info->height_div;
-	rf.luma_step = info->luma_step;
-	rf.chroma_step = info->chroma_step;
-
-	switch (info->id) {
-	case V4L2_PIX_FMT_YUV420:
-		rf.cb = rf.luma + size;
-		rf.cr = rf.cb + size / 4;
-		break;
-	case V4L2_PIX_FMT_YVU420:
-		rf.cr = rf.luma + size;
-		rf.cb = rf.cr + size / 4;
-		break;
-	case V4L2_PIX_FMT_YUV422P:
-		rf.cb = rf.luma + size;
-		rf.cr = rf.cb + size / 2;
-		break;
-	case V4L2_PIX_FMT_NV12:
-	case V4L2_PIX_FMT_NV16:
-	case V4L2_PIX_FMT_NV24:
-		rf.cb = rf.luma + size;
-		rf.cr = rf.cb + 1;
-		break;
-	case V4L2_PIX_FMT_NV21:
-	case V4L2_PIX_FMT_NV61:
-	case V4L2_PIX_FMT_NV42:
-		rf.cr = rf.luma + size;
-		rf.cb = rf.cr + 1;
-		break;
-	case V4L2_PIX_FMT_YUYV:
-		rf.cb = rf.luma + 1;
-		rf.cr = rf.cb + 2;
-		break;
-	case V4L2_PIX_FMT_YVYU:
-		rf.cr = rf.luma + 1;
-		rf.cb = rf.cr + 2;
-		break;
-	case V4L2_PIX_FMT_UYVY:
-		rf.cb = rf.luma;
-		rf.cr = rf.cb + 2;
-		rf.luma++;
-		break;
-	case V4L2_PIX_FMT_VYUY:
-		rf.cr = rf.luma;
-		rf.cb = rf.cr + 2;
-		rf.luma++;
-		break;
-	case V4L2_PIX_FMT_RGB24:
-	case V4L2_PIX_FMT_HSV24:
-		rf.cr = rf.luma;
-		rf.cb = rf.cr + 2;
-		rf.luma++;
-		break;
-	case V4L2_PIX_FMT_BGR24:
-		rf.cb = rf.luma;
-		rf.cr = rf.cb + 2;
-		rf.luma++;
-		break;
-	case V4L2_PIX_FMT_RGB32:
-	case V4L2_PIX_FMT_XRGB32:
-	case V4L2_PIX_FMT_HSV32:
-		rf.cr = rf.luma + 1;
-		rf.cb = rf.cr + 2;
-		rf.luma += 2;
-		break;
-	case V4L2_PIX_FMT_BGR32:
-	case V4L2_PIX_FMT_XBGR32:
-		rf.cb = rf.luma;
-		rf.cr = rf.cb + 2;
-		rf.luma++;
-		break;
-	}
-
-	cf.width = q_data->width;
-	cf.height = q_data->height;
-	cf.i_frame_qp = ctx->i_frame_qp;
-	cf.p_frame_qp = ctx->p_frame_qp;
-	cf.rlc_data = (__be16 *)(p_out + sizeof(*p_hdr));
-
-	encoding = fwht_encode_frame(&rf, &ctx->ref_frame, &cf, !ctx->gop_cnt,
-				     ctx->gop_cnt == ctx->gop_size - 1);
-	if (!(encoding & FWHT_FRAME_PCODED))
-		ctx->gop_cnt = 0;
-	if (++ctx->gop_cnt >= ctx->gop_size)
-		ctx->gop_cnt = 0;
-
-	p_hdr = (struct fwht_cframe_hdr *)p_out;
-	p_hdr->magic1 = FWHT_MAGIC1;
-	p_hdr->magic2 = FWHT_MAGIC2;
-	p_hdr->version = htonl(FWHT_VERSION);
-	p_hdr->width = htonl(cf.width);
-	p_hdr->height = htonl(cf.height);
-	if (encoding & FWHT_LUMA_UNENCODED)
-		flags |= FWHT_FL_LUMA_IS_UNCOMPRESSED;
-	if (encoding & FWHT_CB_UNENCODED)
-		flags |= FWHT_FL_CB_IS_UNCOMPRESSED;
-	if (encoding & FWHT_CR_UNENCODED)
-		flags |= FWHT_FL_CR_IS_UNCOMPRESSED;
-	if (rf.height_div == 1)
-		flags |= FWHT_FL_CHROMA_FULL_HEIGHT;
-	if (rf.width_div == 1)
-		flags |= FWHT_FL_CHROMA_FULL_WIDTH;
-	p_hdr->flags = htonl(flags);
-	p_hdr->colorspace = htonl(ctx->colorspace);
-	p_hdr->xfer_func = htonl(ctx->xfer_func);
-	p_hdr->ycbcr_enc = htonl(ctx->ycbcr_enc);
-	p_hdr->quantization = htonl(ctx->quantization);
-	p_hdr->size = htonl(cf.size);
-	ctx->ref_frame.width = cf.width;
-	ctx->ref_frame.height = cf.height;
-}
-
-static int decode(struct vicodec_ctx *ctx,
-		  struct vicodec_q_data *q_data,
-		  u8 *p_in, u8 *p_out)
-{
-	unsigned int size = q_data->width * q_data->height;
-	unsigned int chroma_size = size;
-	unsigned int i;
-	u32 flags;
-	struct fwht_cframe_hdr *p_hdr;
-	struct fwht_cframe cf;
-	u8 *p;
-
-	p_hdr = (struct fwht_cframe_hdr *)p_in;
-	cf.width = ntohl(p_hdr->width);
-	cf.height = ntohl(p_hdr->height);
-	flags = ntohl(p_hdr->flags);
-	ctx->colorspace = ntohl(p_hdr->colorspace);
-	ctx->xfer_func = ntohl(p_hdr->xfer_func);
-	ctx->ycbcr_enc = ntohl(p_hdr->ycbcr_enc);
-	ctx->quantization = ntohl(p_hdr->quantization);
-	cf.rlc_data = (__be16 *)(p_in + sizeof(*p_hdr));
-
-	if (p_hdr->magic1 != FWHT_MAGIC1 ||
-	    p_hdr->magic2 != FWHT_MAGIC2 ||
-	    ntohl(p_hdr->version) != FWHT_VERSION ||
-	    cf.width < MIN_WIDTH ||
-	    cf.width > MAX_WIDTH ||
-	    cf.height < MIN_HEIGHT ||
-	    cf.height > MAX_HEIGHT ||
-	    (cf.width & 7) || (cf.height & 7))
-		return -EINVAL;
-
-	/* TODO: support resolution changes */
-	if (cf.width != q_data->width || cf.height != q_data->height)
-		return -EINVAL;
-
-	if (!(flags & FWHT_FL_CHROMA_FULL_WIDTH))
-		chroma_size /= 2;
-	if (!(flags & FWHT_FL_CHROMA_FULL_HEIGHT))
-		chroma_size /= 2;
-
-	fwht_decode_frame(&cf, &ctx->ref_frame, flags);
-
-	switch (q_data->info->id) {
-	case V4L2_PIX_FMT_YUV420:
-	case V4L2_PIX_FMT_YUV422P:
-		memcpy(p_out, ctx->ref_frame.luma, size);
-		p_out += size;
-		memcpy(p_out, ctx->ref_frame.cb, chroma_size);
-		p_out += chroma_size;
-		memcpy(p_out, ctx->ref_frame.cr, chroma_size);
-		break;
-	case V4L2_PIX_FMT_YVU420:
-		memcpy(p_out, ctx->ref_frame.luma, size);
-		p_out += size;
-		memcpy(p_out, ctx->ref_frame.cr, chroma_size);
-		p_out += chroma_size;
-		memcpy(p_out, ctx->ref_frame.cb, chroma_size);
-		break;
-	case V4L2_PIX_FMT_NV12:
-	case V4L2_PIX_FMT_NV16:
-	case V4L2_PIX_FMT_NV24:
-		memcpy(p_out, ctx->ref_frame.luma, size);
-		p_out += size;
-		for (i = 0, p = p_out; i < chroma_size; i++) {
-			*p++ = ctx->ref_frame.cb[i];
-			*p++ = ctx->ref_frame.cr[i];
-		}
-		break;
-	case V4L2_PIX_FMT_NV21:
-	case V4L2_PIX_FMT_NV61:
-	case V4L2_PIX_FMT_NV42:
-		memcpy(p_out, ctx->ref_frame.luma, size);
-		p_out += size;
-		for (i = 0, p = p_out; i < chroma_size; i++) {
-			*p++ = ctx->ref_frame.cr[i];
-			*p++ = ctx->ref_frame.cb[i];
-		}
-		break;
-	case V4L2_PIX_FMT_YUYV:
-		for (i = 0, p = p_out; i < size; i += 2) {
-			*p++ = ctx->ref_frame.luma[i];
-			*p++ = ctx->ref_frame.cb[i / 2];
-			*p++ = ctx->ref_frame.luma[i + 1];
-			*p++ = ctx->ref_frame.cr[i / 2];
-		}
-		break;
-	case V4L2_PIX_FMT_YVYU:
-		for (i = 0, p = p_out; i < size; i += 2) {
-			*p++ = ctx->ref_frame.luma[i];
-			*p++ = ctx->ref_frame.cr[i / 2];
-			*p++ = ctx->ref_frame.luma[i + 1];
-			*p++ = ctx->ref_frame.cb[i / 2];
-		}
-		break;
-	case V4L2_PIX_FMT_UYVY:
-		for (i = 0, p = p_out; i < size; i += 2) {
-			*p++ = ctx->ref_frame.cb[i / 2];
-			*p++ = ctx->ref_frame.luma[i];
-			*p++ = ctx->ref_frame.cr[i / 2];
-			*p++ = ctx->ref_frame.luma[i + 1];
-		}
-		break;
-	case V4L2_PIX_FMT_VYUY:
-		for (i = 0, p = p_out; i < size; i += 2) {
-			*p++ = ctx->ref_frame.cr[i / 2];
-			*p++ = ctx->ref_frame.luma[i];
-			*p++ = ctx->ref_frame.cb[i / 2];
-			*p++ = ctx->ref_frame.luma[i + 1];
-		}
-		break;
-	case V4L2_PIX_FMT_RGB24:
-	case V4L2_PIX_FMT_HSV24:
-		for (i = 0, p = p_out; i < size; i++) {
-			*p++ = ctx->ref_frame.cr[i];
-			*p++ = ctx->ref_frame.luma[i];
-			*p++ = ctx->ref_frame.cb[i];
-		}
-		break;
-	case V4L2_PIX_FMT_BGR24:
-		for (i = 0, p = p_out; i < size; i++) {
-			*p++ = ctx->ref_frame.cb[i];
-			*p++ = ctx->ref_frame.luma[i];
-			*p++ = ctx->ref_frame.cr[i];
-		}
-		break;
-	case V4L2_PIX_FMT_RGB32:
-	case V4L2_PIX_FMT_XRGB32:
-	case V4L2_PIX_FMT_HSV32:
-		for (i = 0, p = p_out; i < size; i++) {
-			*p++ = 0;
-			*p++ = ctx->ref_frame.cr[i];
-			*p++ = ctx->ref_frame.luma[i];
-			*p++ = ctx->ref_frame.cb[i];
-		}
-		break;
-	case V4L2_PIX_FMT_BGR32:
-	case V4L2_PIX_FMT_XBGR32:
-		for (i = 0, p = p_out; i < size; i++) {
-			*p++ = ctx->ref_frame.cb[i];
-			*p++ = ctx->ref_frame.luma[i];
-			*p++ = ctx->ref_frame.cr[i];
-			*p++ = 0;
-		}
-		break;
-	}
-	return 0;
-}
-
 static int device_process(struct vicodec_ctx *ctx,
 			  struct vb2_v4l2_buffer *in_vb,
 			  struct vb2_v4l2_buffer *out_vb)
 {
 	struct vicodec_dev *dev = ctx->dev;
 	struct vicodec_q_data *q_out, *q_cap;
+	struct v4l2_fwht_state *state = &ctx->state;
 	u8 *p_in, *p_out;
 	int ret;
 
@@ -475,7 +167,7 @@ static int device_process(struct vicodec_ctx *ctx,
 	if (ctx->is_enc)
 		p_in = vb2_plane_vaddr(&in_vb->vb2_buf, 0);
 	else
-		p_in = ctx->compressed_frame;
+		p_in = state->compressed_frame;
 	p_out = vb2_plane_vaddr(&out_vb->vb2_buf, 0);
 	if (!p_in || !p_out) {
 		v4l2_err(&dev->v4l2_dev,
@@ -484,13 +176,11 @@ static int device_process(struct vicodec_ctx *ctx,
 	}
 
 	if (ctx->is_enc) {
-		struct fwht_cframe_hdr *p_hdr = (struct fwht_cframe_hdr *)p_out;
+		unsigned int size = v4l2_fwht_encode(state, p_in, p_out);
 
-		encode(ctx, q_out, p_in, p_out, 0);
-		vb2_set_plane_payload(&out_vb->vb2_buf, 0,
-				      sizeof(*p_hdr) + ntohl(p_hdr->size));
+		vb2_set_plane_payload(&out_vb->vb2_buf, 0, size);
 	} else {
-		ret = decode(ctx, q_cap, p_in, p_out);
+		ret = v4l2_fwht_decode(state, p_in, p_out);
 		if (ret)
 			return ret;
 		vb2_set_plane_payload(&out_vb->vb2_buf, 0, q_cap->sizeimage);
@@ -619,10 +309,11 @@ static int job_ready(void *priv)
 			copy = sizeof(magic) - ctx->comp_magic_cnt;
 			if (p_out + sz - p < copy)
 				copy = p_out + sz - p;
-			memcpy(ctx->compressed_frame + ctx->comp_magic_cnt,
+			memcpy(ctx->state.compressed_frame + ctx->comp_magic_cnt,
 			       p, copy);
 			ctx->comp_magic_cnt += copy;
-			if (!memcmp(ctx->compressed_frame, magic, ctx->comp_magic_cnt)) {
+			if (!memcmp(ctx->state.compressed_frame, magic,
+				    ctx->comp_magic_cnt)) {
 				p += copy;
 				state = VB2_BUF_STATE_DONE;
 				break;
@@ -637,12 +328,12 @@ static int job_ready(void *priv)
 	}
 	if (ctx->comp_size < sizeof(struct fwht_cframe_hdr)) {
 		struct fwht_cframe_hdr *p_hdr =
-			(struct fwht_cframe_hdr *)ctx->compressed_frame;
+			(struct fwht_cframe_hdr *)ctx->state.compressed_frame;
 		u32 copy = sizeof(struct fwht_cframe_hdr) - ctx->comp_size;
 
 		if (copy > p_out + sz - p)
 			copy = p_out + sz - p;
-		memcpy(ctx->compressed_frame + ctx->comp_size,
+		memcpy(ctx->state.compressed_frame + ctx->comp_size,
 		       p, copy);
 		p += copy;
 		ctx->comp_size += copy;
@@ -659,7 +350,7 @@ static int job_ready(void *priv)
 
 		if (copy > p_out + sz - p)
 			copy = p_out + sz - p;
-		memcpy(ctx->compressed_frame + ctx->comp_size,
+		memcpy(ctx->state.compressed_frame + ctx->comp_size,
 		       p, copy);
 		p += copy;
 		ctx->comp_size += copy;
@@ -694,14 +385,14 @@ static void job_abort(void *priv)
  * video ioctls
  */
 
-static const struct pixfmt_info *find_fmt(u32 fmt)
+static const struct v4l2_fwht_pixfmt_info *find_fmt(u32 fmt)
 {
-	unsigned int i;
+	const struct v4l2_fwht_pixfmt_info *info =
+		v4l2_fwht_find_pixfmt(fmt);
 
-	for (i = 0; i < ARRAY_SIZE(pixfmts); i++)
-		if (pixfmts[i].id == fmt)
-			return &pixfmts[i];
-	return &pixfmts[0];
+	if (!info)
+		info = v4l2_fwht_get_pixfmt(0);
+	return info;
 }
 
 static int vidioc_querycap(struct file *file, void *priv,
@@ -727,13 +418,19 @@ static int enum_fmt(struct v4l2_fmtdesc *f, bool is_enc, bool is_out)
 		return -EINVAL;
 	if (!V4L2_TYPE_IS_MULTIPLANAR(f->type) && multiplanar)
 		return -EINVAL;
-	if (f->index >= (is_uncomp ? ARRAY_SIZE(pixfmts) : 1))
-		return -EINVAL;
 
-	if (is_uncomp)
-		f->pixelformat = pixfmts[f->index].id;
-	else
+	if (is_uncomp) {
+		const struct v4l2_fwht_pixfmt_info *info =
+			v4l2_fwht_get_pixfmt(f->index);
+
+		if (!info)
+			return -EINVAL;
+		f->pixelformat = info->id;
+	} else {
+		if (f->index)
+			return -EINVAL;
 		f->pixelformat = V4L2_PIX_FMT_FWHT;
+	}
 	return 0;
 }
 
@@ -759,7 +456,7 @@ static int vidioc_g_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
 	struct vicodec_q_data *q_data;
 	struct v4l2_pix_format_mplane *pix_mp;
 	struct v4l2_pix_format *pix;
-	const struct pixfmt_info *info;
+	const struct v4l2_fwht_pixfmt_info *info;
 
 	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
 	if (!vq)
@@ -780,10 +477,10 @@ static int vidioc_g_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
 		pix->pixelformat = info->id;
 		pix->bytesperline = q_data->width * info->bytesperline_mult;
 		pix->sizeimage = q_data->sizeimage;
-		pix->colorspace = ctx->colorspace;
-		pix->xfer_func = ctx->xfer_func;
-		pix->ycbcr_enc = ctx->ycbcr_enc;
-		pix->quantization = ctx->quantization;
+		pix->colorspace = ctx->state.colorspace;
+		pix->xfer_func = ctx->state.xfer_func;
+		pix->ycbcr_enc = ctx->state.ycbcr_enc;
+		pix->quantization = ctx->state.quantization;
 		break;
 
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
@@ -799,10 +496,10 @@ static int vidioc_g_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
 		pix_mp->plane_fmt[0].bytesperline =
 				q_data->width * info->bytesperline_mult;
 		pix_mp->plane_fmt[0].sizeimage = q_data->sizeimage;
-		pix_mp->colorspace = ctx->colorspace;
-		pix_mp->xfer_func = ctx->xfer_func;
-		pix_mp->ycbcr_enc = ctx->ycbcr_enc;
-		pix_mp->quantization = ctx->quantization;
+		pix_mp->colorspace = ctx->state.colorspace;
+		pix_mp->xfer_func = ctx->state.xfer_func;
+		pix_mp->ycbcr_enc = ctx->state.ycbcr_enc;
+		pix_mp->quantization = ctx->state.quantization;
 		memset(pix_mp->reserved, 0, sizeof(pix_mp->reserved));
 		memset(pix_mp->plane_fmt[0].reserved, 0,
 		       sizeof(pix_mp->plane_fmt[0].reserved));
@@ -830,7 +527,7 @@ static int vidioc_try_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
 	struct v4l2_pix_format_mplane *pix_mp;
 	struct v4l2_pix_format *pix;
 	struct v4l2_plane_pix_format *plane;
-	const struct pixfmt_info *info = &pixfmt_fwht;
+	const struct v4l2_fwht_pixfmt_info *info = &pixfmt_fwht;
 
 	switch (f->type) {
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
@@ -889,10 +586,10 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 		pix = &f->fmt.pix;
 		pix->pixelformat = ctx->is_enc ? V4L2_PIX_FMT_FWHT :
 				   find_fmt(f->fmt.pix.pixelformat)->id;
-		pix->colorspace = ctx->colorspace;
-		pix->xfer_func = ctx->xfer_func;
-		pix->ycbcr_enc = ctx->ycbcr_enc;
-		pix->quantization = ctx->quantization;
+		pix->colorspace = ctx->state.colorspace;
+		pix->xfer_func = ctx->state.xfer_func;
+		pix->ycbcr_enc = ctx->state.ycbcr_enc;
+		pix->quantization = ctx->state.quantization;
 		break;
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
 		if (!multiplanar)
@@ -900,10 +597,10 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 		pix_mp = &f->fmt.pix_mp;
 		pix_mp->pixelformat = ctx->is_enc ? V4L2_PIX_FMT_FWHT :
 				      find_fmt(pix_mp->pixelformat)->id;
-		pix_mp->colorspace = ctx->colorspace;
-		pix_mp->xfer_func = ctx->xfer_func;
-		pix_mp->ycbcr_enc = ctx->ycbcr_enc;
-		pix_mp->quantization = ctx->quantization;
+		pix_mp->colorspace = ctx->state.colorspace;
+		pix_mp->xfer_func = ctx->state.xfer_func;
+		pix_mp->ycbcr_enc = ctx->state.ycbcr_enc;
+		pix_mp->quantization = ctx->state.quantization;
 		break;
 	default:
 		return -EINVAL;
@@ -1043,18 +740,18 @@ static int vidioc_s_fmt_vid_out(struct file *file, void *priv,
 		case V4L2_BUF_TYPE_VIDEO_CAPTURE:
 		case V4L2_BUF_TYPE_VIDEO_OUTPUT:
 			pix = &f->fmt.pix;
-			ctx->colorspace = pix->colorspace;
-			ctx->xfer_func = pix->xfer_func;
-			ctx->ycbcr_enc = pix->ycbcr_enc;
-			ctx->quantization = pix->quantization;
+			ctx->state.colorspace = pix->colorspace;
+			ctx->state.xfer_func = pix->xfer_func;
+			ctx->state.ycbcr_enc = pix->ycbcr_enc;
+			ctx->state.quantization = pix->quantization;
 			break;
 		case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
 		case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
 			pix_mp = &f->fmt.pix_mp;
-			ctx->colorspace = pix_mp->colorspace;
-			ctx->xfer_func = pix_mp->xfer_func;
-			ctx->ycbcr_enc = pix_mp->ycbcr_enc;
-			ctx->quantization = pix_mp->quantization;
+			ctx->state.colorspace = pix_mp->colorspace;
+			ctx->state.xfer_func = pix_mp->xfer_func;
+			ctx->state.ycbcr_enc = pix_mp->ycbcr_enc;
+			ctx->state.quantization = pix_mp->quantization;
 			break;
 		default:
 			break;
@@ -1297,8 +994,9 @@ static int vicodec_start_streaming(struct vb2_queue *q,
 {
 	struct vicodec_ctx *ctx = vb2_get_drv_priv(q);
 	struct vicodec_q_data *q_data = get_q_data(ctx, q->type);
+	struct v4l2_fwht_state *state = &ctx->state;
 	unsigned int size = q_data->width * q_data->height;
-	const struct pixfmt_info *info = q_data->info;
+	const struct v4l2_fwht_pixfmt_info *info = q_data->info;
 	unsigned int chroma_div = info->width_div * info->height_div;
 
 	q_data->sequence = 0;
@@ -1306,22 +1004,25 @@ static int vicodec_start_streaming(struct vb2_queue *q,
 	if (!V4L2_TYPE_IS_OUTPUT(q->type))
 		return 0;
 
-	ctx->ref_frame.width = ctx->ref_frame.height = 0;
-	ctx->ref_frame.luma = kvmalloc(size + 2 * size / chroma_div, GFP_KERNEL);
+	state->width = q_data->width;
+	state->height = q_data->height;
+	state->ref_frame.width = state->ref_frame.height = 0;
+	state->ref_frame.luma = kvmalloc(size + 2 * size / chroma_div,
+					 GFP_KERNEL);
 	ctx->comp_max_size = size + 2 * size / chroma_div +
 			     sizeof(struct fwht_cframe_hdr);
-	ctx->compressed_frame = kvmalloc(ctx->comp_max_size, GFP_KERNEL);
-	if (!ctx->ref_frame.luma || !ctx->compressed_frame) {
-		kvfree(ctx->ref_frame.luma);
-		kvfree(ctx->compressed_frame);
+	state->compressed_frame = kvmalloc(ctx->comp_max_size, GFP_KERNEL);
+	if (!state->ref_frame.luma || !state->compressed_frame) {
+		kvfree(state->ref_frame.luma);
+		kvfree(state->compressed_frame);
 		vicodec_return_bufs(q, VB2_BUF_STATE_QUEUED);
 		return -ENOMEM;
 	}
-	ctx->ref_frame.cb = ctx->ref_frame.luma + size;
-	ctx->ref_frame.cr = ctx->ref_frame.cb + size / chroma_div;
+	state->ref_frame.cb = state->ref_frame.luma + size;
+	state->ref_frame.cr = state->ref_frame.cb + size / chroma_div;
 	ctx->last_src_buf = NULL;
 	ctx->last_dst_buf = NULL;
-	ctx->gop_cnt = 0;
+	state->gop_cnt = 0;
 	ctx->cur_buf_offset = 0;
 	ctx->comp_size = 0;
 	ctx->comp_magic_cnt = 0;
@@ -1339,8 +1040,8 @@ static void vicodec_stop_streaming(struct vb2_queue *q)
 	if (!V4L2_TYPE_IS_OUTPUT(q->type))
 		return;
 
-	kvfree(ctx->ref_frame.luma);
-	kvfree(ctx->compressed_frame);
+	kvfree(ctx->state.ref_frame.luma);
+	kvfree(ctx->state.compressed_frame);
 }
 
 static const struct vb2_ops vicodec_qops = {
@@ -1400,19 +1101,19 @@ static int vicodec_s_ctrl(struct v4l2_ctrl *ctrl)
 
 	switch (ctrl->id) {
 	case V4L2_CID_MPEG_VIDEO_GOP_SIZE:
-		ctx->gop_size = ctrl->val;
+		ctx->state.gop_size = ctrl->val;
 		return 0;
 	case VICODEC_CID_I_FRAME_QP:
-		ctx->i_frame_qp = ctrl->val;
+		ctx->state.i_frame_qp = ctrl->val;
 		return 0;
 	case VICODEC_CID_P_FRAME_QP:
-		ctx->p_frame_qp = ctrl->val;
+		ctx->state.p_frame_qp = ctrl->val;
 		return 0;
 	}
 	return -EINVAL;
 }
 
-static const struct v4l2_ctrl_ops vicodec_ctrl_ops = {
+static struct v4l2_ctrl_ops vicodec_ctrl_ops = {
 	.s_ctrl = vicodec_s_ctrl,
 };
 
@@ -1480,7 +1181,7 @@ static int vicodec_open(struct file *file)
 	v4l2_ctrl_handler_setup(hdl);
 
 	ctx->q_data[V4L2_M2M_SRC].info =
-		ctx->is_enc ? pixfmts : &pixfmt_fwht;
+		ctx->is_enc ? v4l2_fwht_get_pixfmt(0) : &pixfmt_fwht;
 	ctx->q_data[V4L2_M2M_SRC].width = 1280;
 	ctx->q_data[V4L2_M2M_SRC].height = 720;
 	size = 1280 * 720 * ctx->q_data[V4L2_M2M_SRC].info->sizeimage_mult /
@@ -1488,11 +1189,11 @@ static int vicodec_open(struct file *file)
 	ctx->q_data[V4L2_M2M_SRC].sizeimage = size;
 	ctx->q_data[V4L2_M2M_DST] = ctx->q_data[V4L2_M2M_SRC];
 	ctx->q_data[V4L2_M2M_DST].info =
-		ctx->is_enc ? &pixfmt_fwht : pixfmts;
+		ctx->is_enc ? &pixfmt_fwht : v4l2_fwht_get_pixfmt(0);
 	size = 1280 * 720 * ctx->q_data[V4L2_M2M_DST].info->sizeimage_mult /
 		ctx->q_data[V4L2_M2M_DST].info->sizeimage_div;
 	ctx->q_data[V4L2_M2M_DST].sizeimage = size;
-	ctx->colorspace = V4L2_COLORSPACE_REC709;
+	ctx->state.colorspace = V4L2_COLORSPACE_REC709;
 
 	size += sizeof(struct fwht_cframe_hdr);
 	if (ctx->is_enc) {
-- 
2.18.0
