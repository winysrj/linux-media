Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:43523 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756960AbcC2LcW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Mar 2016 07:32:22 -0400
From: Tiffany Lin <tiffany.lin@mediatek.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
	<daniel.thompson@linaro.org>, Rob Herring <robh+dt@kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Pawel Osciak <posciak@chromium.org>
CC: Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	<devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-media@vger.kernel.org>,
	<linux-mediatek@lists.infradead.org>, <PoChun.Lin@mediatek.com>,
	<Tiffany.lin@mediatek.com>, PoChun Lin <pochun.lin@mediatek.com>,
	Tiffany Lin <tiffany.lin@mediatek.com>
Subject: [PATCH v6 7/8] [media] vcodec: mediatek: Add Mediatek H264 Video Encoder Driver
Date: Tue, 29 Mar 2016 19:32:09 +0800
Message-ID: <1459251130-53774-8-git-send-email-tiffany.lin@mediatek.com>
In-Reply-To: <1459251130-53774-7-git-send-email-tiffany.lin@mediatek.com>
References: <1459251130-53774-1-git-send-email-tiffany.lin@mediatek.com>
 <1459251130-53774-2-git-send-email-tiffany.lin@mediatek.com>
 <1459251130-53774-3-git-send-email-tiffany.lin@mediatek.com>
 <1459251130-53774-4-git-send-email-tiffany.lin@mediatek.com>
 <1459251130-53774-5-git-send-email-tiffany.lin@mediatek.com>
 <1459251130-53774-6-git-send-email-tiffany.lin@mediatek.com>
 <1459251130-53774-7-git-send-email-tiffany.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: PoChun Lin <pochun.lin@mediatek.com>

Add h264 encoder driver for MT8173

Signed-off-by: pochun.lin <pochun.lin@mediatek.com>
Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
---
 drivers/media/platform/mtk-vcodec/Makefile         |    1 -
 .../media/platform/mtk-vcodec/h264_enc/Makefile    |    6 +
 .../platform/mtk-vcodec/h264_enc/venc_h264_if.c    |  488 ++++++++++++++++++++
 .../platform/mtk-vcodec/h264_enc/venc_h264_if.h    |  168 +++++++
 .../platform/mtk-vcodec/h264_enc/venc_h264_vpu.c   |  323 +++++++++++++
 .../platform/mtk-vcodec/h264_enc/venc_h264_vpu.h   |   31 ++
 drivers/media/platform/mtk-vcodec/venc_drv_if.c    |    4 +-
 7 files changed, 1019 insertions(+), 2 deletions(-)
 create mode 100644 drivers/media/platform/mtk-vcodec/h264_enc/Makefile
 create mode 100644 drivers/media/platform/mtk-vcodec/h264_enc/venc_h264_if.c
 create mode 100644 drivers/media/platform/mtk-vcodec/h264_enc/venc_h264_if.h
 create mode 100644 drivers/media/platform/mtk-vcodec/h264_enc/venc_h264_vpu.c
 create mode 100644 drivers/media/platform/mtk-vcodec/h264_enc/venc_h264_vpu.h

diff --git a/drivers/media/platform/mtk-vcodec/Makefile b/drivers/media/platform/mtk-vcodec/Makefile
index 30edfd7..3b54880 100644
--- a/drivers/media/platform/mtk-vcodec/Makefile
+++ b/drivers/media/platform/mtk-vcodec/Makefile
@@ -11,5 +11,4 @@ mtk-vcodec-enc-y := h264_enc/venc_h264_if.o \
 mtk-vcodec-common-y := mtk_vcodec_intr.o \
                mtk_vcodec_util.o\
 
-
 ccflags-y += -I$(srctree)/drivers/media/platform/mtk-vpu
diff --git a/drivers/media/platform/mtk-vcodec/h264_enc/Makefile b/drivers/media/platform/mtk-vcodec/h264_enc/Makefile
new file mode 100644
index 0000000..765b45f
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/h264_enc/Makefile
@@ -0,0 +1,6 @@
+obj-$(CONFIG_VIDEO_MEDIATEK_VCODEC) += venc_h264_if.o venc_h264_vpu.o
+
+ccflags-y += \
+    -I$(srctree)/drivers/media/platform/mtk-vcodec/ \
+    -I$(srctree)/drivers/media/platform/mtk-vcodec/h264_enc \
+    -I$(srctree)/drivers/media/platform/mtk-vpu
diff --git a/drivers/media/platform/mtk-vcodec/h264_enc/venc_h264_if.c b/drivers/media/platform/mtk-vcodec/h264_enc/venc_h264_if.c
new file mode 100644
index 0000000..9fc2953
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/h264_enc/venc_h264_if.c
@@ -0,0 +1,488 @@
+/*
+ * Copyright (c) 2016 MediaTek Inc.
+ * Author: Jungchang Tsao <jungchang.tsao@mediatek.com>
+ *         Daniel Hsiao <daniel.hsiao@mediatek.com>
+ *         PoChun Lin <pochun.lin@mediatek.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+
+#include "mtk_vcodec_drv.h"
+#include "mtk_vcodec_util.h"
+#include "mtk_vcodec_intr.h"
+#include "mtk_vcodec_enc.h"
+#include "mtk_vcodec_enc_pm.h"
+#include "mtk_vpu.h"
+
+#include "venc_h264_if.h"
+#include "venc_h264_vpu.h"
+
+static const char h264_filler_marker[] = {0x0, 0x0, 0x0, 0x1, 0xc};
+
+#define H264_FILLER_MARKER_SIZE ARRAY_SIZE(h264_filler_marker)
+#define VENC_PIC_BITSTREAM_BYTE_CNT 0x0098
+
+static inline void h264_write_reg(struct venc_h264_inst *inst, u32 addr,
+				  u32 val)
+{
+	writel(val, inst->hw_base + addr);
+}
+
+static inline u32 h264_read_reg(struct venc_h264_inst *inst, u32 addr)
+{
+	return readl(inst->hw_base + addr);
+}
+
+static void h264_enc_free_work_buf(struct venc_h264_inst *inst)
+{
+	int i;
+
+	mtk_vcodec_debug_enter(inst);
+
+	/* Except the SKIP_FRAME buffers,
+	 * other buffers need to be freed by AP.
+	 */
+	for (i = 0; i < VENC_H264_VPU_WORK_BUF_MAX; i++) {
+		if (i != VENC_H264_VPU_WORK_BUF_SKIP_FRAME)
+			mtk_vcodec_mem_free(inst->ctx, &inst->work_bufs[i]);
+	}
+
+	mtk_vcodec_mem_free(inst->ctx, &inst->pps_buf);
+
+	mtk_vcodec_debug_leave(inst);
+}
+
+static int h264_enc_alloc_work_buf(struct venc_h264_inst *inst)
+{
+	int i;
+	int ret = 0;
+	struct venc_h264_vpu_buf *wb = inst->vpu_inst.vsi->work_bufs;
+
+	mtk_vcodec_debug_enter(inst);
+
+	for (i = 0; i < VENC_H264_VPU_WORK_BUF_MAX; i++) {
+		/*
+		 * This 'wb' structure is set by VPU side and shared to AP for
+		 * buffer allocation and IO virtual addr mapping. For most of
+		 * the buffers, AP will allocate the buffer according to 'size'
+		 * field and store the IO virtual addr in 'iova' field. There
+		 * are two exceptions:
+		 * (1) RC_CODE buffer, it's pre-allocated in the VPU side, and
+		 * save the VPU addr in the 'vpua' field. The AP will translate
+		 * the VPU addr to the corresponding IO virtual addr and store
+		 * in 'iova' field for reg setting in VPU side.
+		 * (2) SKIP_FRAME buffer, it's pre-allocated in the VPU side,
+		 * and save the VPU addr in the 'vpua' field. The AP will
+		 * translate the VPU addr to the corresponding AP side virtual
+		 * address and do some memcpy access to move to bitstream buffer
+		 * assigned by v4l2 layer.
+		 */
+		inst->work_bufs[i].size = wb[i].size;
+		if (i == VENC_H264_VPU_WORK_BUF_SKIP_FRAME) {
+			inst->work_bufs[i].va = vpu_mapping_dm_addr(
+				inst->dev, wb[i].vpua);
+			inst->work_bufs[i].dma_addr = 0;
+		} else {
+			ret = mtk_vcodec_mem_alloc(inst->ctx,
+						   &inst->work_bufs[i]);
+			if (ret) {
+				mtk_vcodec_err(inst,
+					       "cannot allocate buf %d", i);
+				goto err_alloc;
+			}
+			/*
+			 * This RC_CODE is pre-allocated by VPU and saved in VPU
+			 * addr. So we need use memcpy to copy RC_CODE from VPU
+			 * addr into IO virtual addr in 'iova' field for reg
+			 * setting in VPU side.
+			 */
+			if (i == VENC_H264_VPU_WORK_BUF_RC_CODE) {
+				void *tmp_va;
+
+				tmp_va = vpu_mapping_dm_addr(inst->dev,
+							     wb[i].vpua);
+				memcpy(inst->work_bufs[i].va, tmp_va,
+				       wb[i].size);
+			}
+		}
+		wb[i].iova = inst->work_bufs[i].dma_addr;
+
+		mtk_vcodec_debug(inst,
+				 "work_buf[%d] va=0x%p iova=0x%p size=0x%lx",
+				 i, inst->work_bufs[i].va,
+				 (void *)inst->work_bufs[i].dma_addr,
+				 inst->work_bufs[i].size);
+	}
+
+	/* the pps_buf is used by AP side only */
+	inst->pps_buf.size = 128;
+	ret = mtk_vcodec_mem_alloc(inst->ctx, &inst->pps_buf);
+	if (ret) {
+		mtk_vcodec_err(inst, "cannot allocate pps_buf");
+		goto err_alloc;
+	}
+
+	mtk_vcodec_debug_leave(inst);
+
+	return ret;
+
+err_alloc:
+	h264_enc_free_work_buf(inst);
+
+	return ret;
+}
+
+static unsigned int h264_enc_wait_venc_done(struct venc_h264_inst *inst)
+{
+	unsigned int irq_status = 0;
+	struct mtk_vcodec_ctx *ctx = (struct mtk_vcodec_ctx *)inst->ctx;
+
+	if (!mtk_vcodec_wait_for_done_ctx(ctx, MTK_INST_IRQ_RECEIVED,
+					  WAIT_INTR_TIMEOUT_MS)) {
+		irq_status = ctx->irq_status;
+		mtk_vcodec_debug(inst, "irq_status %x <-", irq_status);
+	}
+	return irq_status;
+}
+
+static int h264_encode_sps(struct venc_h264_inst *inst,
+			   struct mtk_vcodec_mem *bs_buf,
+			   unsigned int *bs_size)
+{
+	int ret = 0;
+	unsigned int irq_status;
+
+	mtk_vcodec_debug_enter(inst);
+
+	ret = h264_enc_vpu_encode(inst, H264_BS_MODE_SPS, NULL,
+				  bs_buf, bs_size);
+	if (ret)
+		return ret;
+
+	irq_status = h264_enc_wait_venc_done(inst);
+	if (irq_status != MTK_VENC_IRQ_STATUS_SPS) {
+		mtk_vcodec_err(inst, "expect irq status %d",
+			       MTK_VENC_IRQ_STATUS_SPS);
+		return -EINVAL;
+	}
+
+	*bs_size = h264_read_reg(inst, VENC_PIC_BITSTREAM_BYTE_CNT);
+	mtk_vcodec_debug(inst, "bs size %d <-", *bs_size);
+
+	return ret;
+}
+
+static int h264_encode_pps(struct venc_h264_inst *inst,
+			   struct mtk_vcodec_mem *bs_buf,
+			   unsigned int *bs_size)
+{
+	int ret = 0;
+	unsigned int irq_status;
+
+	mtk_vcodec_debug_enter(inst);
+
+	ret = h264_enc_vpu_encode(inst, H264_BS_MODE_PPS, NULL,
+				  bs_buf, bs_size);
+	if (ret)
+		return ret;
+
+	irq_status = h264_enc_wait_venc_done(inst);
+	if (irq_status != MTK_VENC_IRQ_STATUS_PPS) {
+		mtk_vcodec_err(inst, "expect irq status %d",
+			       MTK_VENC_IRQ_STATUS_PPS);
+		return -EINVAL;
+	}
+
+	*bs_size = h264_read_reg(inst, VENC_PIC_BITSTREAM_BYTE_CNT);
+	mtk_vcodec_debug(inst, "bs size %d <-", *bs_size);
+
+	return ret;
+}
+
+static int h264_encode_header(struct venc_h264_inst *inst,
+			      struct mtk_vcodec_mem *bs_buf,
+			      unsigned int *bs_size)
+{
+	int ret = 0;
+	unsigned int bs_size_sps;
+	unsigned int bs_size_pps;
+
+	ret = h264_encode_sps(inst, bs_buf, &bs_size_sps);
+	if (ret)
+		return ret;
+
+	ret = h264_encode_pps(inst, &inst->pps_buf, &bs_size_pps);
+	if (ret)
+		return ret;
+
+	memcpy(bs_buf->va + bs_size_sps, inst->pps_buf.va, bs_size_pps);
+	*bs_size = bs_size_sps + bs_size_pps;
+
+	return ret;
+}
+
+static int h264_encode_frame(struct venc_h264_inst *inst,
+			     struct venc_frm_buf *frm_buf,
+			     struct mtk_vcodec_mem *bs_buf,
+			     unsigned int *bs_size)
+{
+	int ret = 0;
+	unsigned int irq_status;
+
+	mtk_vcodec_debug_enter(inst);
+
+	ret = h264_enc_vpu_encode(inst, H264_BS_MODE_FRAME, frm_buf,
+				  bs_buf, bs_size);
+	if (ret)
+		return ret;
+
+	/*
+	 * skip frame case: The skip frame buffer is composed by vpu side only,
+	 * it does not trigger the hw, so skip the wait interrupt operation.
+	 */
+	if (!inst->vpu_inst.wait_int) {
+		++inst->frm_cnt;
+		return ret;
+	}
+
+	irq_status = h264_enc_wait_venc_done(inst);
+	if (irq_status != MTK_VENC_IRQ_STATUS_FRM) {
+		mtk_vcodec_err(inst, "irq_status=%d failed", irq_status);
+		return -EIO;
+	}
+
+	*bs_size = h264_read_reg(inst, VENC_PIC_BITSTREAM_BYTE_CNT);
+
+	++inst->frm_cnt;
+	mtk_vcodec_debug(inst, "frm %d bs size %d key_frm %d <-",
+			 inst->frm_cnt,
+			 *bs_size, inst->is_key_frm);
+
+	return ret;
+}
+
+static void h264_encode_filler(struct venc_h264_inst *inst, void *buf,
+			       int size)
+{
+	unsigned char *p = buf;
+
+	if (size < H264_FILLER_MARKER_SIZE) {
+		mtk_vcodec_err(inst, "filler size too small %d", size);
+		return;
+	}
+
+	memcpy(p, h264_filler_marker, ARRAY_SIZE(h264_filler_marker));
+	size -= H264_FILLER_MARKER_SIZE;
+	p += H264_FILLER_MARKER_SIZE;
+	memset(p, 0xff, size);
+}
+
+static int h264_enc_init(struct mtk_vcodec_ctx *ctx, unsigned long *handle)
+{
+	int ret = 0;
+	struct venc_h264_inst *inst;
+
+	inst = kzalloc(sizeof(*inst), GFP_KERNEL);
+	if (!inst)
+		return -ENOMEM;
+
+	inst->ctx = ctx;
+	inst->dev = mtk_vcodec_get_plat_dev(ctx);
+	inst->hw_base = mtk_vcodec_get_reg_addr(inst->ctx, VENC_SYS);
+
+	mtk_vcodec_debug_enter(inst);
+
+	ret = h264_enc_vpu_init(inst);
+
+	mtk_vcodec_debug_leave(inst);
+
+	if (ret)
+		kfree(inst);
+	else
+		(*handle) = (unsigned long)inst;
+
+	return ret;
+}
+
+static int h264_enc_encode(unsigned long handle,
+			   enum venc_start_opt opt,
+			   struct venc_frm_buf *frm_buf,
+			   struct mtk_vcodec_mem *bs_buf,
+			   struct venc_done_result *result)
+{
+	int ret = 0;
+	struct venc_h264_inst *inst = (struct venc_h264_inst *)handle;
+	struct mtk_vcodec_ctx *ctx = inst->ctx;
+
+	mtk_vcodec_debug(inst, "opt %d ->", opt);
+
+	enable_irq(ctx->dev->enc_irq);
+
+	switch (opt) {
+	case VENC_START_OPT_ENCODE_SEQUENCE_HEADER: {
+		unsigned int bs_size_hdr;
+
+		ret = h264_encode_header(inst, bs_buf, &bs_size_hdr);
+		if (ret)
+			goto encode_err;
+
+		result->bs_size = bs_size_hdr;
+		result->is_key_frm = false;
+		break;
+	}
+
+	case VENC_START_OPT_ENCODE_FRAME: {
+		int hdr_sz;
+		int hdr_sz_ext;
+		int filler_sz = 0;
+		const int bs_alignment = 128;
+		struct mtk_vcodec_mem tmp_bs_buf;
+		unsigned int bs_size_hdr;
+		unsigned int bs_size_frm;
+
+		if (!inst->prepend_hdr) {
+			ret = h264_encode_frame(inst, frm_buf, bs_buf,
+						&result->bs_size);
+			if (ret)
+				goto encode_err;
+			result->is_key_frm = inst->is_key_frm;
+			break;
+		}
+
+		mtk_vcodec_debug(inst, "h264_encode_frame prepend SPS/PPS");
+
+		ret = h264_encode_header(inst, bs_buf, &bs_size_hdr);
+		if (ret)
+			goto encode_err;
+
+		hdr_sz = bs_size_hdr;
+		hdr_sz_ext = (hdr_sz & (bs_alignment - 1));
+		if (hdr_sz_ext) {
+			filler_sz = bs_alignment - hdr_sz_ext;
+			if (hdr_sz_ext + H264_FILLER_MARKER_SIZE > bs_alignment)
+				filler_sz += bs_alignment;
+			h264_encode_filler(inst, bs_buf->va + hdr_sz,
+					   filler_sz);
+		}
+
+		tmp_bs_buf.va = bs_buf->va + hdr_sz + filler_sz;
+		tmp_bs_buf.dma_addr = bs_buf->dma_addr + hdr_sz + filler_sz;
+		tmp_bs_buf.size = bs_buf->size - (hdr_sz + filler_sz);
+
+		ret = h264_encode_frame(inst, frm_buf, &tmp_bs_buf,
+					&bs_size_frm);
+		if (ret)
+			goto encode_err;
+
+		result->bs_size = hdr_sz + filler_sz + bs_size_frm;
+
+		mtk_vcodec_debug(inst, "hdr %d filler %d frame %d bs %d",
+				 hdr_sz, filler_sz, bs_size_frm,
+				 result->bs_size);
+
+		inst->prepend_hdr = 0;
+		result->is_key_frm = inst->is_key_frm;
+		break;
+	}
+
+	default:
+		mtk_vcodec_err(inst, "venc_start_opt %d not supported", opt);
+		ret = -EINVAL;
+		break;
+	}
+
+encode_err:
+
+	disable_irq(ctx->dev->enc_irq);
+	mtk_vcodec_debug(inst, "opt %d <-", opt);
+
+	return ret;
+}
+
+static int h264_enc_set_param(unsigned long handle,
+			      enum venc_set_param_type type,
+			      struct venc_enc_prm *enc_prm)
+{
+	int i;
+	int ret = 0;
+	struct venc_h264_inst *inst = (struct venc_h264_inst *)handle;
+
+	mtk_vcodec_debug(inst, "->type=%d", type);
+
+	switch (type) {
+	case VENC_SET_PARAM_ENC:
+		ret = h264_enc_vpu_set_param(inst, type, enc_prm);
+		if (ret)
+			break;
+		if (inst->work_buf_allocated) {
+			h264_enc_free_work_buf(inst);
+			inst->work_buf_allocated = false;
+		}
+		ret = h264_enc_alloc_work_buf(inst);
+		if (ret)
+			break;
+		inst->work_buf_allocated = true;
+		for (i = 0; i < MTK_VCODEC_MAX_PLANES; i++) {
+			enc_prm->sizeimage[i] =
+				inst->vpu_inst.vsi->sizeimage[i];
+			mtk_vcodec_debug(inst, "sizeimage[%d] size=0x%x", i,
+					 enc_prm->sizeimage[i]);
+		}
+		break;
+
+	case VENC_SET_PARAM_PREPEND_HEADER:
+		inst->prepend_hdr = 1;
+		mtk_vcodec_debug(inst, "set prepend header mode");
+		break;
+
+	default:
+		ret = h264_enc_vpu_set_param(inst, type, enc_prm);
+		break;
+	}
+
+	mtk_vcodec_debug_leave(inst);
+
+	return ret;
+}
+
+static int h264_enc_deinit(unsigned long handle)
+{
+	int ret = 0;
+	struct venc_h264_inst *inst = (struct venc_h264_inst *)handle;
+
+	mtk_vcodec_debug_enter(inst);
+
+	ret = h264_enc_vpu_deinit(inst);
+
+	if (inst->work_buf_allocated)
+		h264_enc_free_work_buf(inst);
+
+	mtk_vcodec_debug_leave(inst);
+	kfree(inst);
+
+	return ret;
+}
+
+static struct venc_common_if venc_h264_if = {
+	h264_enc_init,
+	h264_enc_encode,
+	h264_enc_set_param,
+	h264_enc_deinit,
+};
+
+struct venc_common_if *get_h264_enc_comm_if(void)
+{
+	return &venc_h264_if;
+}
diff --git a/drivers/media/platform/mtk-vcodec/h264_enc/venc_h264_if.h b/drivers/media/platform/mtk-vcodec/h264_enc/venc_h264_if.h
new file mode 100644
index 0000000..422eaca
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/h264_enc/venc_h264_if.h
@@ -0,0 +1,168 @@
+/*
+ * Copyright (c) 2016 MediaTek Inc.
+ * Author: Jungchang Tsao <jungchang.tsao@mediatek.com>
+ *         Daniel Hsiao <daniel.hsiao@mediatek.com>
+ *         PoChun Lin <pochun.lin@mediatek.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _VENC_H264_IF_H_
+#define _VENC_H264_IF_H_
+
+#include "venc_drv_base.h"
+
+/**
+ * enum venc_h264_vpu_work_buf - h264 encoder buffer index
+ */
+enum venc_h264_vpu_work_buf {
+	VENC_H264_VPU_WORK_BUF_RC_INFO,
+	VENC_H264_VPU_WORK_BUF_RC_CODE,
+	VENC_H264_VPU_WORK_BUF_REC_LUMA,
+	VENC_H264_VPU_WORK_BUF_REC_CHROMA,
+	VENC_H264_VPU_WORK_BUF_REF_LUMA,
+	VENC_H264_VPU_WORK_BUF_REF_CHROMA,
+	VENC_H264_VPU_WORK_BUF_MV_INFO_1,
+	VENC_H264_VPU_WORK_BUF_MV_INFO_2,
+	VENC_H264_VPU_WORK_BUF_SKIP_FRAME,
+	VENC_H264_VPU_WORK_BUF_MAX,
+};
+
+/**
+ * enum venc_h264_bs_mode - for bs_mode argument in h264_enc_vpu_encode
+ */
+enum venc_h264_bs_mode {
+	H264_BS_MODE_SPS,
+	H264_BS_MODE_PPS,
+	H264_BS_MODE_FRAME,
+};
+
+/*
+ * struct venc_h264_vpu_config - Structure for h264 encoder configuration
+ * @input_fourcc: input fourcc
+ * @bitrate: target bitrate (in bps)
+ * @pic_w: picture width. Picture size is visible stream resolution, in pixels,
+ *         to be used for display purposes; must be smaller or equal to buffer
+ *         size.
+ * @pic_h: picture height
+ * @buf_w: buffer width. Buffer size is stream resolution in pixels aligned to
+ *         hardware requirements.
+ * @buf_h: buffer height
+ * @gop_size: group of picture size (idr frame)
+ * @intra_period: intra frame period
+ * @framerate: frame rate in fps
+ * @profile: as specified in standard
+ * @level: as specified in standard
+ * @wfd: WFD mode 1:on, 0:off
+ */
+struct venc_h264_vpu_config {
+	u32 input_fourcc;
+	u32 bitrate;
+	u32 pic_w;
+	u32 pic_h;
+	u32 buf_w;
+	u32 buf_h;
+	u32 gop_size;
+	u32 intra_period;
+	u32 framerate;
+	u32 profile;
+	u32 level;
+	u32 wfd;
+};
+
+/*
+ * struct venc_h264_vpu_buf - Structure for buffer information
+ * @align: buffer alignment (in bytes)
+ * @iova: IO virtual address
+ * @vpua: VPU side memory addr which is used by RC_CODE
+ * @size: buffer size (in bytes)
+ */
+struct venc_h264_vpu_buf {
+	u32 align;
+	u32 iova;
+	u32 vpua;
+	u32 size;
+};
+
+/*
+ * struct venc_h264_vsi - Structure for VPU driver control and info share
+ * This structure is allocated in VPU side and shared to AP side.
+ * @config: h264 encoder configuration
+ * @work_bufs: working buffer information in VPU side
+ * The work_bufs here is for storing the 'size' info shared to AP side.
+ * The similar item in struct venc_h264_inst is for memory allocation
+ * in AP side. The AP driver will copy the 'size' from here to the one in
+ * struct mtk_vcodec_mem, then invoke mtk_vcodec_mem_alloc to allocate
+ * the buffer. After that, bypass the 'dma_addr' to the 'iova' field here for
+ * register setting in VPU side.
+ * @sizeimage: image size for each plane
+ */
+struct venc_h264_vsi {
+	struct venc_h264_vpu_config config;
+	struct venc_h264_vpu_buf work_bufs[VENC_H264_VPU_WORK_BUF_MAX];
+	unsigned int sizeimage[MTK_VCODEC_MAX_PLANES];
+};
+
+/*
+ * struct venc_h264_vpu_inst - h264 encoder VPU driver instance
+ * @wq_hd: wait queue used for vpu cmd trigger then wait vpu interrupt done
+ * @signaled: flag used for checking vpu interrupt done
+ * @failure: flag to show vpu cmd succeeds or not
+ * @state: enum venc_ipi_msg_enc_state
+ * @bs_size: bitstream size for skip frame case usage
+ * @wait_int: flag to wait interrupt done (0: for skip frame case, 1: normal
+ *	      case)
+ * @id: VPU instance id
+ * @vsi: driver structure allocated by VPU side and shared to AP side for
+ *	 control and info share
+ */
+struct venc_h264_vpu_inst {
+	wait_queue_head_t wq_hd;
+	int signaled;
+	int failure;
+	int state;
+	int bs_size;
+	int wait_int;
+	unsigned int id;
+	struct venc_h264_vsi *vsi;
+};
+
+/*
+ * struct venc_h264_inst - h264 encoder AP driver instance
+ * @hw_base: h264 encoder hardware register base
+ * @work_bufs: working buffer
+ * @pps_buf: buffer to store the pps bitstream
+ * @work_buf_allocated: working buffer allocated flag
+ * @frm_cnt: encoded frame count
+ * @prepend_hdr: when the v4l2 layer send VENC_SET_PARAM_PREPEND_HEADER cmd
+ *  through h264_enc_set_param interface, it will set this flag and prepend the
+ *  sps/pps in h264_enc_encode function.
+ * @is_key_frm: key frame flag
+ * @vpu_inst: VPU instance to exchange information between AP and VPU
+ * @ctx: context for v4l2 layer integration
+ * @dev: device for v4l2 layer integration
+ */
+struct venc_h264_inst {
+	void __iomem *hw_base;
+	struct mtk_vcodec_mem work_bufs[VENC_H264_VPU_WORK_BUF_MAX];
+	struct mtk_vcodec_mem pps_buf;
+	bool work_buf_allocated;
+	unsigned int frm_cnt;
+	unsigned int prepend_hdr;
+	unsigned int is_key_frm;
+	struct venc_h264_vpu_inst vpu_inst;
+	void *ctx;
+	struct platform_device *dev;
+};
+
+struct venc_common_if *get_h264_enc_comm_if(void);
+
+#endif
diff --git a/drivers/media/platform/mtk-vcodec/h264_enc/venc_h264_vpu.c b/drivers/media/platform/mtk-vcodec/h264_enc/venc_h264_vpu.c
new file mode 100644
index 0000000..4f61262
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/h264_enc/venc_h264_vpu.c
@@ -0,0 +1,323 @@
+/*
+ * Copyright (c) 2016 MediaTek Inc.
+ * Author: Jungchang Tsao <jungchang.tsao@mediatek.com>
+ *         Daniel Hsiao <daniel.hsiao@mediatek.com>
+ *         PoChun Lin <pochun.lin@mediatek.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include "mtk_vpu.h"
+
+#include "venc_h264_if.h"
+#include "venc_h264_vpu.h"
+#include "venc_ipi_msg.h"
+
+static unsigned int h264_get_profile(struct venc_h264_inst *inst,
+				     unsigned int profile)
+{
+	switch (profile) {
+	case V4L2_MPEG_VIDEO_H264_PROFILE_BASELINE:
+		return 66;
+	case V4L2_MPEG_VIDEO_H264_PROFILE_MAIN:
+		return 77;
+	case V4L2_MPEG_VIDEO_H264_PROFILE_HIGH:
+		return 100;
+	case V4L2_MPEG_VIDEO_H264_PROFILE_CONSTRAINED_BASELINE:
+		mtk_vcodec_err(inst, "unsupported CONSTRAINED_BASELINE");
+		return 0;
+	case V4L2_MPEG_VIDEO_H264_PROFILE_EXTENDED:
+		mtk_vcodec_err(inst, "unsupported EXTENDED");
+		return 0;
+	default:
+		mtk_vcodec_debug(inst, "unsupported profile %d", profile);
+		return 100;
+	}
+}
+
+static unsigned int h264_get_level(struct venc_h264_inst *inst,
+				   unsigned int level)
+{
+	switch (level) {
+	case V4L2_MPEG_VIDEO_H264_LEVEL_1B:
+		mtk_vcodec_err(inst, "unsupported 1B");
+		return 0;
+	case V4L2_MPEG_VIDEO_H264_LEVEL_1_0:
+		return 10;
+	case V4L2_MPEG_VIDEO_H264_LEVEL_1_1:
+		return 11;
+	case V4L2_MPEG_VIDEO_H264_LEVEL_1_2:
+		return 12;
+	case V4L2_MPEG_VIDEO_H264_LEVEL_1_3:
+		return 13;
+	case V4L2_MPEG_VIDEO_H264_LEVEL_2_0:
+		return 20;
+	case V4L2_MPEG_VIDEO_H264_LEVEL_2_1:
+		return 21;
+	case V4L2_MPEG_VIDEO_H264_LEVEL_2_2:
+		return 22;
+	case V4L2_MPEG_VIDEO_H264_LEVEL_3_0:
+		return 30;
+	case V4L2_MPEG_VIDEO_H264_LEVEL_3_1:
+		return 31;
+	case V4L2_MPEG_VIDEO_H264_LEVEL_3_2:
+		return 32;
+	case V4L2_MPEG_VIDEO_H264_LEVEL_4_0:
+		return 40;
+	case V4L2_MPEG_VIDEO_H264_LEVEL_4_1:
+		return 41;
+	default:
+		mtk_vcodec_debug(inst, "unsupported level %d", level);
+		return 31;
+	}
+}
+
+static void handle_h264_enc_init_msg(struct venc_h264_inst *inst, void *data)
+{
+	struct venc_vpu_ipi_msg_init *msg = data;
+
+	inst->vpu_inst.id = msg->vpu_inst_addr;
+	inst->vpu_inst.vsi = (struct venc_h264_vsi *)vpu_mapping_dm_addr(
+		inst->dev, msg->vpu_inst_addr);
+}
+
+static void handle_h264_enc_encode_msg(struct venc_h264_inst *inst, void *data)
+{
+	struct venc_vpu_ipi_msg_enc *msg = data;
+
+	inst->vpu_inst.state = msg->state;
+	inst->vpu_inst.bs_size = msg->bs_size;
+	inst->is_key_frm = msg->is_key_frm;
+}
+
+static void h264_enc_vpu_ipi_handler(void *data, unsigned int len, void *priv)
+{
+	struct venc_vpu_ipi_msg_common *msg = data;
+	struct venc_h264_inst *inst = (struct venc_h264_inst *)msg->venc_inst;
+
+	mtk_vcodec_debug(inst, "msg_id %x inst %p status %d",
+			 msg->msg_id, inst, msg->status);
+
+	switch (msg->msg_id) {
+	case VPU_IPIMSG_ENC_INIT_DONE:
+		handle_h264_enc_init_msg(inst, data);
+		break;
+	case VPU_IPIMSG_ENC_SET_PARAM_DONE:
+		break;
+	case VPU_IPIMSG_ENC_ENCODE_DONE:
+		handle_h264_enc_encode_msg(inst, data);
+		break;
+	case VPU_IPIMSG_ENC_DEINIT_DONE:
+		break;
+	default:
+		mtk_vcodec_err(inst, "unknown msg id %x", msg->msg_id);
+		break;
+	}
+
+	inst->vpu_inst.signaled = 1;
+	inst->vpu_inst.failure = (msg->status != VENC_IPI_MSG_STATUS_OK);
+
+	mtk_vcodec_debug_leave(inst);
+}
+
+static int h264_enc_vpu_send_msg(struct venc_h264_inst *inst, void *msg,
+				 int len)
+{
+	int status;
+
+	mtk_vcodec_debug_enter(inst);
+
+	status = vpu_ipi_send(inst->dev, IPI_VENC_H264, msg, len);
+	if (status) {
+		uint32_t msg_id = *(uint32_t *)msg;
+
+		mtk_vcodec_err(inst, "vpu_ipi_send msg_id %x len %d fail %d",
+			       msg_id, len, status);
+		return -EINVAL;
+	}
+	if (inst->vpu_inst.failure)
+		return -EINVAL;
+
+	mtk_vcodec_debug_leave(inst);
+
+	return 0;
+}
+
+int h264_enc_vpu_init(struct venc_h264_inst *inst)
+{
+	int status;
+	struct venc_ap_ipi_msg_init out;
+
+	mtk_vcodec_debug_enter(inst);
+
+	init_waitqueue_head(&inst->vpu_inst.wq_hd);
+	inst->vpu_inst.signaled = 0;
+	inst->vpu_inst.failure = 0;
+
+	status = vpu_ipi_register(inst->dev, IPI_VENC_H264,
+				  h264_enc_vpu_ipi_handler,
+				  "h264_enc", NULL);
+	if (status) {
+		mtk_vcodec_err(inst, "vpu_ipi_register fail %d", status);
+		return -EINVAL;
+	}
+
+	out.msg_id = AP_IPIMSG_ENC_INIT;
+	out.venc_inst = (unsigned long)inst;
+	if (h264_enc_vpu_send_msg(inst, &out, sizeof(out))) {
+		mtk_vcodec_err(inst, "AP_IPIMSG_ENC_INIT fail");
+		return -EINVAL;
+	}
+
+	mtk_vcodec_debug_leave(inst);
+
+	return 0;
+}
+
+int h264_enc_vpu_set_param(struct venc_h264_inst *inst,
+			   enum venc_set_param_type id,
+			   struct venc_enc_prm *enc_param)
+{
+	struct venc_ap_ipi_msg_set_param out;
+
+	mtk_vcodec_debug(inst, "id %d ->", id);
+
+	out.msg_id = AP_IPIMSG_ENC_SET_PARAM;
+	out.vpu_inst_addr = inst->vpu_inst.id;
+	out.param_id = id;
+	switch (id) {
+	case VENC_SET_PARAM_ENC: {
+		inst->vpu_inst.vsi->config.input_fourcc =
+			enc_param->input_fourcc;
+		inst->vpu_inst.vsi->config.bitrate = enc_param->bitrate;
+		inst->vpu_inst.vsi->config.pic_w = enc_param->width;
+		inst->vpu_inst.vsi->config.pic_h = enc_param->height;
+		inst->vpu_inst.vsi->config.buf_w = enc_param->buf_width;
+		inst->vpu_inst.vsi->config.buf_h = enc_param->buf_height;
+		inst->vpu_inst.vsi->config.gop_size = enc_param->gop_size;
+		inst->vpu_inst.vsi->config.intra_period =
+			enc_param->intra_period;
+		inst->vpu_inst.vsi->config.framerate = enc_param->frm_rate;
+		inst->vpu_inst.vsi->config.profile =
+			h264_get_profile(inst, enc_param->h264_profile);
+		inst->vpu_inst.vsi->config.level =
+			h264_get_level(inst, enc_param->h264_level);
+		inst->vpu_inst.vsi->config.wfd = 0;
+		out.data_item = 0;
+		break;
+	}
+	case VENC_SET_PARAM_FORCE_INTRA:
+		out.data_item = 0;
+		break;
+	case VENC_SET_PARAM_ADJUST_BITRATE:
+		out.data_item = 1;
+		out.data[0] = enc_param->bitrate;
+		break;
+	case VENC_SET_PARAM_ADJUST_FRAMERATE:
+		out.data_item = 1;
+		out.data[0] = enc_param->frm_rate;
+		break;
+	case VENC_SET_PARAM_GOP_SIZE:
+		out.data_item = 1;
+		out.data[0] = enc_param->gop_size;
+		break;
+	case VENC_SET_PARAM_INTRA_PERIOD:
+		out.data_item = 1;
+		out.data[0] = enc_param->intra_period;
+		break;
+	case VENC_SET_PARAM_SKIP_FRAME:
+		out.data_item = 0;
+		break;
+	default:
+		mtk_vcodec_err(inst, "id %d not supported", id);
+		return -EINVAL;
+	}
+	if (h264_enc_vpu_send_msg(inst, &out, sizeof(out))) {
+		mtk_vcodec_err(inst,
+			       "AP_IPIMSG_ENC_SET_PARAM %d fail", id);
+		return -EINVAL;
+	}
+
+	mtk_vcodec_debug(inst, "id %d <-", id);
+
+	return 0;
+}
+
+int h264_enc_vpu_encode(struct venc_h264_inst *inst, unsigned int bs_mode,
+			struct venc_frm_buf *frm_buf,
+			struct mtk_vcodec_mem *bs_buf,
+			unsigned int *bs_size)
+{
+	struct venc_ap_ipi_msg_enc out;
+
+	mtk_vcodec_debug(inst, "bs_mode %d ->", bs_mode);
+
+	memset(&out, 0, sizeof(out));
+	out.msg_id = AP_IPIMSG_ENC_ENCODE;
+	out.vpu_inst_addr = inst->vpu_inst.id;
+	out.bs_mode = bs_mode;
+	if (frm_buf) {
+		if ((frm_buf->fb_addr[0].dma_addr % 16 == 0) &&
+		    (frm_buf->fb_addr[1].dma_addr % 16 == 0) &&
+		    (frm_buf->fb_addr[2].dma_addr % 16 == 0)) {
+			out.input_addr[0] = frm_buf->fb_addr[0].dma_addr;
+			out.input_addr[1] = frm_buf->fb_addr[1].dma_addr;
+			out.input_addr[2] = frm_buf->fb_addr[2].dma_addr;
+		} else {
+			mtk_vcodec_err(inst, "dma_addr not align to 16");
+			return -EINVAL;
+		}
+	}
+	if (bs_buf) {
+		out.bs_addr = bs_buf->dma_addr;
+		out.bs_size = bs_buf->size;
+	}
+	if (h264_enc_vpu_send_msg(inst, &out, sizeof(out))) {
+		mtk_vcodec_err(inst, "AP_IPIMSG_ENC_ENCODE %d fail",
+			       bs_mode);
+		return -EINVAL;
+	}
+
+	mtk_vcodec_debug(inst, "state %d size %d key_frm %d",
+			 inst->vpu_inst.state, inst->vpu_inst.bs_size,
+			 inst->is_key_frm);
+
+	inst->vpu_inst.wait_int = 1;
+	if (inst->vpu_inst.state == VEN_IPI_MSG_ENC_STATE_SKIP) {
+		*bs_size = inst->vpu_inst.bs_size;
+		memcpy(bs_buf->va,
+		       inst->work_bufs[VENC_H264_VPU_WORK_BUF_SKIP_FRAME].va,
+		       *bs_size);
+		inst->vpu_inst.wait_int = 0;
+	}
+
+	mtk_vcodec_debug(inst, "bs_mode %d <-", bs_mode);
+
+	return 0;
+}
+
+int h264_enc_vpu_deinit(struct venc_h264_inst *inst)
+{
+	struct venc_ap_ipi_msg_deinit out;
+
+	mtk_vcodec_debug_enter(inst);
+
+	out.msg_id = AP_IPIMSG_ENC_DEINIT;
+	out.vpu_inst_addr = inst->vpu_inst.id;
+	if (h264_enc_vpu_send_msg(inst, &out, sizeof(out))) {
+		mtk_vcodec_err(inst, "AP_IPIMSG_ENC_DEINIT fail");
+		return -EINVAL;
+	}
+
+	mtk_vcodec_debug_leave(inst);
+
+	return 0;
+}
diff --git a/drivers/media/platform/mtk-vcodec/h264_enc/venc_h264_vpu.h b/drivers/media/platform/mtk-vcodec/h264_enc/venc_h264_vpu.h
new file mode 100644
index 0000000..c1f3738
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/h264_enc/venc_h264_vpu.h
@@ -0,0 +1,31 @@
+/*
+ * Copyright (c) 2016 MediaTek Inc.
+ * Author: Jungchang Tsao <jungchang.tsao@mediatek.com>
+ *         Daniel Hsiao <daniel.hsiao@mediatek.com>
+ *         PoChun Lin <pochun.lin@mediatek.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _VENC_H264_VPU_H_
+#define _VENC_H264_VPU_H_
+
+int h264_enc_vpu_init(struct venc_h264_inst *inst);
+int h264_enc_vpu_set_param(struct venc_h264_inst *inst,
+			   enum venc_set_param_type id,
+			   struct venc_enc_prm *param);
+int h264_enc_vpu_encode(struct venc_h264_inst *inst, unsigned int bs_mode,
+			struct venc_frm_buf *frm_buf,
+			struct mtk_vcodec_mem *bs_buf,
+			unsigned int *bs_size);
+int h264_enc_vpu_deinit(struct venc_h264_inst *inst);
+
+#endif
diff --git a/drivers/media/platform/mtk-vcodec/venc_drv_if.c b/drivers/media/platform/mtk-vcodec/venc_drv_if.c
index 89213ed..c0c67b5 100644
--- a/drivers/media/platform/mtk-vcodec/venc_drv_if.c
+++ b/drivers/media/platform/mtk-vcodec/venc_drv_if.c
@@ -26,7 +26,7 @@
 
 #include "venc_drv_base.h"
 #include "vp8_enc/venc_vp8_if.h"
-
+#include "h264_enc/venc_h264_if.h"
 
 int venc_if_init(struct mtk_vcodec_ctx *ctx, unsigned int fourcc)
 {
@@ -37,6 +37,8 @@ int venc_if_init(struct mtk_vcodec_ctx *ctx, unsigned int fourcc)
 		ctx->enc_if = get_vp8_enc_comm_if();
 		break;
 	case V4L2_PIX_FMT_H264:
+		ctx->enc_if = get_h264_enc_comm_if();
+		break;
 	default:
 		return -EINVAL;
 	}
-- 
1.7.9.5

