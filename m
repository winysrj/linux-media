Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:48405 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758058AbcBDLff (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Feb 2016 06:35:35 -0500
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
	Tiffany Lin <tiffany.lin@mediatek.com>,
	Daniel Hsiao <daniel.hsiao@mediatek.com>
Subject: [PATCH v4 6/8] [media] vcodec: mediatek: Add Mediatek VP8 Video Encoder Driver
Date: Thu, 4 Feb 2016 19:35:01 +0800
Message-ID: <1454585703-42428-7-git-send-email-tiffany.lin@mediatek.com>
In-Reply-To: <1454585703-42428-6-git-send-email-tiffany.lin@mediatek.com>
References: <1454585703-42428-1-git-send-email-tiffany.lin@mediatek.com>
 <1454585703-42428-2-git-send-email-tiffany.lin@mediatek.com>
 <1454585703-42428-3-git-send-email-tiffany.lin@mediatek.com>
 <1454585703-42428-4-git-send-email-tiffany.lin@mediatek.com>
 <1454585703-42428-5-git-send-email-tiffany.lin@mediatek.com>
 <1454585703-42428-6-git-send-email-tiffany.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add vp8 encoder driver for MT8173

Signed-off-by: Daniel Hsiao <daniel.hsiao@mediatek.com>
Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
---
 drivers/media/platform/mtk-vcodec/Makefile         |    2 +
 drivers/media/platform/mtk-vcodec/venc_drv_if.c    |    3 +
 drivers/media/platform/mtk-vcodec/vp8_enc/Makefile |    6 +
 .../platform/mtk-vcodec/vp8_enc/venc_vp8_if.c      |  422 ++++++++++++++++++++
 .../platform/mtk-vcodec/vp8_enc/venc_vp8_if.h      |  149 +++++++
 .../platform/mtk-vcodec/vp8_enc/venc_vp8_vpu.c     |  240 +++++++++++
 .../platform/mtk-vcodec/vp8_enc/venc_vp8_vpu.h     |   28 ++
 7 files changed, 850 insertions(+)
 create mode 100644 drivers/media/platform/mtk-vcodec/vp8_enc/Makefile
 create mode 100644 drivers/media/platform/mtk-vcodec/vp8_enc/venc_vp8_if.c
 create mode 100644 drivers/media/platform/mtk-vcodec/vp8_enc/venc_vp8_if.h
 create mode 100644 drivers/media/platform/mtk-vcodec/vp8_enc/venc_vp8_vpu.c
 create mode 100644 drivers/media/platform/mtk-vcodec/vp8_enc/venc_vp8_vpu.h

diff --git a/drivers/media/platform/mtk-vcodec/Makefile b/drivers/media/platform/mtk-vcodec/Makefile
index ce38689..f4ef502 100644
--- a/drivers/media/platform/mtk-vcodec/Makefile
+++ b/drivers/media/platform/mtk-vcodec/Makefile
@@ -5,4 +5,6 @@ obj-$(CONFIG_VIDEO_MEDIATEK_VCODEC) += mtk_vcodec_intr.o \
 				       mtk_vcodec_enc_pm.o \
 				       venc_drv_if.o
 
+obj-$(CONFIG_VIDEO_MEDIATEK_VCODEC) += vp8_enc/
+
 ccflags-y += -I$(srctree)/drivers/media/platform/mtk-vpu
diff --git a/drivers/media/platform/mtk-vcodec/venc_drv_if.c b/drivers/media/platform/mtk-vcodec/venc_drv_if.c
index daa8e93..d293f2c 100644
--- a/drivers/media/platform/mtk-vcodec/venc_drv_if.c
+++ b/drivers/media/platform/mtk-vcodec/venc_drv_if.c
@@ -24,6 +24,7 @@
 #include "mtk_vpu.h"
 
 #include "venc_drv_base.h"
+#include "vp8_enc/venc_vp8_if.h"
 
 int venc_if_create(struct mtk_vcodec_ctx *ctx, unsigned int fourcc)
 {
@@ -34,6 +35,8 @@ int venc_if_create(struct mtk_vcodec_ctx *ctx, unsigned int fourcc)
 
 	switch (fourcc) {
 	case V4L2_PIX_FMT_VP8:
+                ctx->enc_if = get_vp8_enc_comm_if();
+                break;
 	case V4L2_PIX_FMT_H264:
 	default:
 		return -EINVAL;
diff --git a/drivers/media/platform/mtk-vcodec/vp8_enc/Makefile b/drivers/media/platform/mtk-vcodec/vp8_enc/Makefile
new file mode 100644
index 0000000..0f515c7
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/vp8_enc/Makefile
@@ -0,0 +1,6 @@
+obj-$(CONFIG_VIDEO_MEDIATEK_VCODEC) += venc_vp8_if.o venc_vp8_vpu.o
+
+ccflags-y += \
+    -I$(srctree)/drivers/media/platform/mtk-vcodec/ \
+    -I$(srctree)/drivers/media/platform/mtk-vcodec/vp8_enc \
+    -I$(srctree)/drivers/media/platform/mtk-vpu
diff --git a/drivers/media/platform/mtk-vcodec/vp8_enc/venc_vp8_if.c b/drivers/media/platform/mtk-vcodec/vp8_enc/venc_vp8_if.c
new file mode 100644
index 0000000..4253317
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/vp8_enc/venc_vp8_if.c
@@ -0,0 +1,422 @@
+/*
+ * Copyright (c) 2015 MediaTek Inc.
+ * Author: Daniel Hsiao <daniel.hsiao@mediatek.com>
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
+#include "mtk_vcodec_pm.h"
+#include "mtk_vpu.h"
+
+#include "venc_vp8_if.h"
+#include "venc_vp8_vpu.h"
+
+#define VENC_PIC_BITSTREAM_BYTE_CNT 0x0098
+#define VENC_PIC_BITSTREAM_BYTE_CNT1 0x00e8
+#define VENC_IRQ_STATUS_ENC_FRM_INT 0x04
+
+#define MAX_AC_TAG_SZ 10
+
+static inline void vp8_enc_write_reg(struct venc_vp8_inst *inst, u32 addr,
+				     u32 val)
+{
+	writel(val, inst->hw_base + addr);
+}
+
+static inline u32 vp8_enc_read_reg(struct venc_vp8_inst *inst, u32 addr)
+{
+	return readl(inst->hw_base + addr);
+}
+
+static void vp8_enc_free_work_buf(struct venc_vp8_inst *inst)
+{
+	int i;
+
+	mtk_vcodec_debug_enter(inst);
+
+	/* Buffers need to be freed by AP. */
+	for (i = 0; i < VENC_VP8_VPU_WORK_BUF_MAX; i++)
+		if (inst->work_bufs[i].va != NULL)
+			mtk_vcodec_mem_free(inst->ctx,
+					    &inst->work_bufs[i]);
+
+	mtk_vcodec_debug_leave(inst);
+}
+
+static int vp8_enc_alloc_work_buf(struct venc_vp8_inst *inst, void *param)
+{
+	int i;
+	int ret = 0;
+	struct venc_vp8_vpu_buf *wb = inst->vpu_inst.drv->work_bufs;
+	struct venc_enc_prm *enc_param = param;
+
+	mtk_vcodec_debug_enter(inst);
+
+	for (i = 0; i < VENC_VP8_VPU_WORK_BUF_MAX; i++) {
+		/*
+		 * Only temporal scalability mode will use RC_CODE2 & RC_CODE3
+		 * Each three temporal layer has its own rate control code.
+		 */
+		if ((i == VENC_VP8_VPU_WORK_BUF_RC_CODE2 ||
+		     i == VENC_VP8_VPU_WORK_BUF_RC_CODE3) && !inst->ts_mode)
+			continue;
+
+		/*
+		 * This 'wb' structure is set by VPU side and shared to AP for
+		 * buffer allocation and IO virtual addr mapping. For most of
+		 * the buffers, AP will allocate the buffer according to 'size'
+		 * field and store the IO virtual addr in 'iova' field. For the
+		 * RC_CODEx buffers, they are pre-allocated in the VPU side
+		 * because they are inside VPU SRAM, and save the VPU addr in
+		 * the 'vpua' field. The AP will translate the VPU addr to the
+		 * corresponding IO virtual addr and store in 'iova' field.
+		 */
+		if (i < VENC_VP8_VPU_WORK_BUF_RC_CODE) {
+			inst->work_bufs[i].size = wb[i].size;
+			ret = mtk_vcodec_mem_alloc(inst->ctx,
+						   &inst->work_bufs[i]);
+			if (ret) {
+				mtk_vcodec_err(inst,
+					       "cannot alloc work_bufs[%d]", i);
+				goto err_alloc;
+			}
+			wb[i].iova = inst->work_bufs[i].dma_addr;
+		} else if (i == VENC_VP8_VPU_WORK_BUF_SRC_LUMA ||
+			   i == VENC_VP8_VPU_WORK_BUF_SRC_CHROMA ||
+			   i == VENC_VP8_VPU_WORK_BUF_SRC_CHROMA_CB ||
+			   i == VENC_VP8_VPU_WORK_BUF_SRC_CHROMA_CR) {
+			inst->work_bufs[i].size = wb[i].size;
+			inst->work_bufs[i].dma_addr = 0;
+			inst->work_bufs[i].va = NULL;
+			wb[i].iova = inst->work_bufs[i].dma_addr;
+		} else {
+			void *tmp_va;
+
+			tmp_va = vpu_mapping_dm_addr(inst->dev, wb[i].vpua);
+			inst->work_bufs[i].size = wb[i].size;
+			ret = mtk_vcodec_mem_alloc(inst->ctx,
+						   &inst->work_bufs[i]);
+			if (ret) {
+				mtk_vcodec_err(inst,
+					       "cannot alloc work_bufs[%d]", i);
+				goto err_alloc;
+			}
+			memcpy(inst->work_bufs[i].va, tmp_va, wb[i].size);
+			wb[i].iova = inst->work_bufs[i].dma_addr;
+		}
+		mtk_vcodec_debug(inst,
+				 "work_bufs[%d] va=0x%p,iova=0x%p,size=0x%lx",
+				 i, inst->work_bufs[i].va,
+				 (void *)inst->work_bufs[i].dma_addr,
+				 inst->work_bufs[i].size);
+	}
+
+	if (enc_param->input_fourcc == VENC_YUV_FORMAT_NV12 ||
+	    enc_param->input_fourcc == VENC_YUV_FORMAT_NV21) {
+		enc_param->sizeimage[0] =
+			inst->work_bufs[VENC_VP8_VPU_WORK_BUF_SRC_LUMA].size;
+		enc_param->sizeimage[1] =
+			inst->work_bufs[VENC_VP8_VPU_WORK_BUF_SRC_CHROMA].size;
+		enc_param->sizeimage[2] = 0;
+	} else {
+		enc_param->sizeimage[0] =
+			inst->work_bufs[VENC_VP8_VPU_WORK_BUF_SRC_LUMA].size;
+		enc_param->sizeimage[1] =
+			inst->work_bufs[VENC_VP8_VPU_WORK_BUF_SRC_CHROMA_CB].size;
+		enc_param->sizeimage[2] =
+			inst->work_bufs[VENC_VP8_VPU_WORK_BUF_SRC_CHROMA_CR].size;
+	}
+	mtk_vcodec_debug_leave(inst);
+
+	return ret;
+
+err_alloc:
+	vp8_enc_free_work_buf(inst);
+
+	return ret;
+}
+
+static unsigned int vp8_enc_wait_venc_done(struct venc_vp8_inst *inst)
+{
+	unsigned int irq_status = 0;
+	struct mtk_vcodec_ctx *ctx = (struct mtk_vcodec_ctx *)inst->ctx;
+
+	mtk_vcodec_wait_for_done_ctx(ctx, MTK_INST_IRQ_RECEIVED,
+				     WAIT_INTR_TIMEOUT, true);
+	irq_status = ctx->irq_status;
+	mtk_vcodec_debug(inst, "isr return %x", irq_status);
+
+	return irq_status;
+}
+
+/*
+ * Compose ac_tag, bitstream header and bitstream payload into
+ * one bitstream buffer.
+ */
+static int vp8_enc_compose_one_frame(struct venc_vp8_inst *inst,
+				     struct mtk_vcodec_mem *bs_buf,
+				     unsigned int *bs_size)
+{
+	unsigned int is_key;
+	u32 bs_size_frm;
+	u32 bs_hdr_len;
+	unsigned int ac_tag_sz;
+	u8 ac_tag[MAX_AC_TAG_SZ];
+
+	bs_size_frm = vp8_enc_read_reg(inst,
+				       VENC_PIC_BITSTREAM_BYTE_CNT);
+	bs_hdr_len = vp8_enc_read_reg(inst,
+				      VENC_PIC_BITSTREAM_BYTE_CNT1);
+
+	/* if a frame is key frame, is_key is 0 */
+	is_key = !inst->is_key_frm;
+	*(u32 *)ac_tag = __cpu_to_le32((bs_hdr_len << 5) | 0x10 | is_key);
+	/* key frame */
+	if (is_key == 0) {
+		ac_tag[3] = 0x9d;
+		ac_tag[4] = 0x01;
+		ac_tag[5] = 0x2a;
+		ac_tag[6] = inst->vpu_inst.drv->config.pic_w;
+		ac_tag[7] = inst->vpu_inst.drv->config.pic_w >> 8;
+		ac_tag[8] = inst->vpu_inst.drv->config.pic_h;
+		ac_tag[9] = inst->vpu_inst.drv->config.pic_h >> 8;
+	}
+
+	if (is_key == 0)
+		ac_tag_sz = MAX_AC_TAG_SZ;
+	else
+		ac_tag_sz = 3;
+
+	if (bs_buf->size <= bs_hdr_len + bs_size_frm + ac_tag_sz) {
+		mtk_vcodec_err(inst, "bitstream buf size is too small(%ld)",
+			       bs_buf->size);
+		return -EINVAL;
+	}
+
+	/*
+	* (1) The vp8 bitstream header and body are generated by the HW vp8
+	* encoder separately at the same time. We cannot know the bitstream
+	* header length in advance.
+	* (2) From the vp8 spec, there is no stuffing byte allowed between the
+	* ac tag, bitstream header and bitstream body.
+	*/
+	memmove(bs_buf->va + bs_hdr_len + ac_tag_sz,
+		bs_buf->va, bs_size_frm);
+	memcpy(bs_buf->va + ac_tag_sz,
+	       inst->work_bufs[VENC_VP8_VPU_WORK_BUF_BS_HD].va,
+	       bs_hdr_len);
+	memcpy(bs_buf->va, ac_tag, ac_tag_sz);
+	*bs_size = bs_size_frm + bs_hdr_len + ac_tag_sz;
+
+	return 0;
+}
+
+static int vp8_enc_encode_frame(struct venc_vp8_inst *inst,
+				struct venc_frm_buf *frm_buf,
+				struct mtk_vcodec_mem *bs_buf,
+				unsigned int *bs_size)
+{
+	int ret = 0;
+	unsigned int irq_status;
+
+	mtk_vcodec_debug(inst, "->frm_cnt=%d", inst->frm_cnt);
+
+	ret = vp8_enc_vpu_encode(inst, frm_buf, bs_buf);
+	if (ret)
+		return ret;
+
+	irq_status = vp8_enc_wait_venc_done(inst);
+	if (irq_status != VENC_IRQ_STATUS_ENC_FRM_INT) {
+		mtk_vcodec_err(inst, "irq_status=%d failed", irq_status);
+		return -EINVAL;
+	}
+
+	if (vp8_enc_compose_one_frame(inst, bs_buf, bs_size)) {
+		mtk_vcodec_err(inst, "vp8_enc_compose_one_frame failed");
+		return -EINVAL;
+	}
+
+	inst->frm_cnt++;
+	mtk_vcodec_debug(inst, "<-size=%d key_frm=%d", *bs_size,
+			 inst->is_key_frm);
+
+	return ret;
+}
+
+static int vp8_enc_init(struct mtk_vcodec_ctx *ctx, unsigned long *handle)
+{
+	int ret = 0;
+	struct venc_vp8_inst *inst;
+
+	inst = kzalloc(sizeof(*inst), GFP_KERNEL);
+	if (!inst)
+		return -ENOMEM;
+
+	inst->ctx = ctx;
+	inst->dev = mtk_vcodec_get_plat_dev(ctx);
+	inst->hw_base = mtk_vcodec_get_reg_addr(inst->ctx, VENC_LT_SYS);
+
+	mtk_vcodec_debug_enter(inst);
+	ret = vp8_enc_vpu_init(inst);
+	if (ret)
+		kfree(inst);
+	else
+		(*handle) = (unsigned long)inst;
+
+	mtk_vcodec_debug_leave(inst);
+
+	return ret;
+}
+
+static int vp8_enc_encode(unsigned long handle,
+			  enum venc_start_opt opt,
+			  struct venc_frm_buf *frm_buf,
+			  struct mtk_vcodec_mem *bs_buf,
+			  struct venc_done_result *result)
+{
+	int ret = 0;
+	struct venc_vp8_inst *inst = (struct venc_vp8_inst *)handle;
+	struct mtk_vcodec_ctx *ctx = inst->ctx;
+
+	mtk_vcodec_debug_enter(inst);
+
+	enable_irq(ctx->dev->enc_lt_irq);
+
+	switch (opt) {
+	case VENC_START_OPT_ENCODE_FRAME:
+		ret = vp8_enc_encode_frame(inst, frm_buf, bs_buf,
+					   &result->bs_size);
+		if (ret)
+			goto encode_err;
+		result->is_key_frm = inst->is_key_frm;
+		break;
+
+	default:
+		mtk_vcodec_err(inst, "opt not support:%d", opt);
+		ret = -EINVAL;
+		break;
+	}
+
+encode_err:
+	if (ret)
+		result->msg = VENC_MESSAGE_ERR;
+	else
+		result->msg = VENC_MESSAGE_OK;
+
+	disable_irq(ctx->dev->enc_lt_irq);
+	mtk_vcodec_debug_leave(inst);
+
+	return ret;
+}
+
+static int vp8_enc_set_param(unsigned long handle,
+			     enum venc_set_param_type type, void *in)
+{
+	int ret = 0;
+	struct venc_vp8_inst *inst = (struct venc_vp8_inst *)handle;
+	struct venc_enc_prm *enc_prm;
+
+	mtk_vcodec_debug(inst, "->type=%d", type);
+
+	switch (type) {
+	case VENC_SET_PARAM_ENC:
+		enc_prm = in;
+		ret = vp8_enc_vpu_set_param(inst, type, enc_prm);
+		if (ret)
+			break;
+		if (inst->work_buf_allocated == 1) {
+			vp8_enc_free_work_buf(inst);
+			inst->work_buf_allocated = 0;
+		}
+		if (inst->work_buf_allocated == 0) {
+			ret = vp8_enc_alloc_work_buf(inst, enc_prm);
+			if (ret)
+				break;
+			inst->work_buf_allocated = 1;
+		}
+		break;
+
+	case VENC_SET_PARAM_FORCE_INTRA:
+		ret = vp8_enc_vpu_set_param(inst, type, 0);
+		break;
+
+	case VENC_SET_PARAM_ADJUST_BITRATE:
+		enc_prm = in;
+		ret = vp8_enc_vpu_set_param(inst, type, &enc_prm->bitrate);
+		break;
+
+	case VENC_SET_PARAM_ADJUST_FRAMERATE:
+		enc_prm = in;
+		ret = vp8_enc_vpu_set_param(inst, type, &enc_prm->frm_rate);
+		break;
+
+	case VENC_SET_PARAM_I_FRAME_INTERVAL:
+		ret = vp8_enc_vpu_set_param(inst, type, in);
+		break;
+
+	/*
+	 * VENC_SET_PARAM_TS_MODE must be called before
+	 * VENC_SET_PARAM_ENC
+	 */
+	case VENC_SET_PARAM_TS_MODE:
+		inst->ts_mode = 1;
+		mtk_vcodec_debug(inst, "set ts_mode");
+		break;
+
+	default:
+		mtk_vcodec_err(inst, "type not support:%d", type);
+		ret = -EINVAL;
+		break;
+	}
+
+	mtk_vcodec_debug_leave(inst);
+
+	return ret;
+}
+
+static int vp8_enc_deinit(unsigned long handle)
+{
+	int ret = 0;
+	struct venc_vp8_inst *inst = (struct venc_vp8_inst *)handle;
+
+	mtk_vcodec_debug_enter(inst);
+
+	ret = vp8_enc_vpu_deinit(inst);
+
+	if (inst->work_buf_allocated)
+		vp8_enc_free_work_buf(inst);
+
+	mtk_vcodec_debug_leave(inst);
+	kfree(inst);
+
+	return ret;
+}
+
+static struct venc_common_if venc_vp8_if = {
+	vp8_enc_init,
+	vp8_enc_encode,
+	vp8_enc_set_param,
+	vp8_enc_deinit,
+};
+
+struct venc_common_if *get_vp8_enc_comm_if(void)
+{
+	return &venc_vp8_if;
+}
diff --git a/drivers/media/platform/mtk-vcodec/vp8_enc/venc_vp8_if.h b/drivers/media/platform/mtk-vcodec/vp8_enc/venc_vp8_if.h
new file mode 100644
index 0000000..b32220e
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/vp8_enc/venc_vp8_if.h
@@ -0,0 +1,149 @@
+/*
+ * Copyright (c) 2015 MediaTek Inc.
+ * Author: Daniel Hsiao <daniel.hsiao@mediatek.com>
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
+#ifndef _VENC_VP8_IF_H_
+#define _VENC_VP8_IF_H_
+
+#include "venc_drv_base.h"
+
+/**
+ * enum venc_vp8_vpu_work_buf - vp8 encoder buffer index
+ */
+enum venc_vp8_vpu_work_buf {
+	VENC_VP8_VPU_WORK_BUF_LUMA,
+	VENC_VP8_VPU_WORK_BUF_LUMA2,
+	VENC_VP8_VPU_WORK_BUF_LUMA3,
+	VENC_VP8_VPU_WORK_BUF_CHROMA,
+	VENC_VP8_VPU_WORK_BUF_CHROMA2,
+	VENC_VP8_VPU_WORK_BUF_CHROMA3,
+	VENC_VP8_VPU_WORK_BUF_MV_INFO,
+	VENC_VP8_VPU_WORK_BUF_BS_HD,
+	VENC_VP8_VPU_WORK_BUF_PROB_BUF,
+	VENC_VP8_VPU_WORK_BUF_RC_INFO,
+	VENC_VP8_VPU_WORK_BUF_RC_CODE,
+	VENC_VP8_VPU_WORK_BUF_RC_CODE2,
+	VENC_VP8_VPU_WORK_BUF_RC_CODE3,
+	VENC_VP8_VPU_WORK_BUF_SRC_LUMA,
+	VENC_VP8_VPU_WORK_BUF_SRC_CHROMA,
+	VENC_VP8_VPU_WORK_BUF_SRC_CHROMA_CB,
+	VENC_VP8_VPU_WORK_BUF_SRC_CHROMA_CR,
+	VENC_VP8_VPU_WORK_BUF_MAX,
+};
+
+/*
+ * struct venc_vp8_vpu_config - Structure for vp8 encoder configuration
+ * @input_fourcc: input fourcc
+ * @bitrate: target bitrate (in bps)
+ * @pic_w: picture width
+ * @pic_h: picture height
+ * @buf_w: buffer width (with 16 alignment)
+ * @buf_h: buffer height (with 16 alignment)
+ * @intra_period: intra frame period
+ * @framerate: frame rate
+ * @ts_mode: temporal scalability mode (0: disable, 1: enable)
+ *	     support three temporal layers - 0: 7.5fps 1: 7.5fps 2: 15fps.
+ */
+struct venc_vp8_vpu_config {
+	u32 input_fourcc;
+	u32 bitrate;
+	u32 pic_w;
+	u32 pic_h;
+	u32 buf_w;
+	u32 buf_h;
+	u32 intra_period;
+	u32 framerate;
+	u32 ts_mode;
+};
+
+/*
+ * struct venc_vp8_vpu_buf -Structure for buffer information
+ * @align: buffer alignment (in bytes)
+ * @iova: IO virtual address
+ * @vpua: VPU side memory addr which is used by RC_CODE
+ * @size: buffer size (in bytes)
+ */
+struct venc_vp8_vpu_buf {
+	u32 align;
+	u32 iova;
+	u32 vpua;
+	u32 size;
+};
+
+/*
+ * struct venc_vp8_vpu_drv - Structure for VPU driver control and info share
+ * This structure is allocated in VPU side and shared to AP side.
+ * @config: vp8 encoder configuration
+ * @work_bufs: working buffer information in VPU side
+ * The work_bufs here is for storing the 'size' info shared to AP side.
+ * The similar item in struct venc_vp8_inst is for memory allocation
+ * in AP side. The AP driver will copy the 'size' from here to the one in
+ * struct mtk_vcodec_mem, then invoke mtk_vcodec_mem_alloc to allocate
+ * the buffer. After that, bypass the 'dma_addr' to the 'iova' field here for
+ * register setting in VPU side.
+ */
+struct venc_vp8_vpu_drv {
+	struct venc_vp8_vpu_config config;
+	struct venc_vp8_vpu_buf work_bufs[VENC_VP8_VPU_WORK_BUF_MAX];
+};
+
+/*
+ * struct venc_vp8_vpu_inst - vp8 encoder VPU driver instance
+ * @wq_hd: wait queue used for vpu cmd trigger then wait vpu interrupt done
+ * @signaled: flag used for checking vpu interrupt done
+ * @failure: flag to show vpu cmd succeeds or not
+ * @state: enum venc_ipi_msg_enc_state
+ * @id: VPU instance id
+ * @drv: driver structure allocated by VPU side and shared to AP side for
+ *	 control and info share
+ */
+struct venc_vp8_vpu_inst {
+	wait_queue_head_t wq_hd;
+	int signaled;
+	int failure;
+	int state;
+	unsigned int id;
+	struct venc_vp8_vpu_drv *drv;
+};
+
+/*
+ * struct venc_vp8_inst - vp8 encoder AP driver instance
+ * @hw_base: vp8 encoder hardware register base
+ * @work_bufs: working buffer
+ * @work_buf_allocated: working buffer allocated flag
+ * @frm_cnt: encoded frame count, it's used for I-frame judgement and
+ *	     reset when force intra cmd received.
+ * @ts_mode: temporal scalability mode (0: disable, 1: enable)
+ *	     support three temporal layers - 0: 7.5fps 1: 7.5fps 2: 15fps.
+ * @is_key_frm: key frame flag
+ * @vpu_inst: VPU instance to exchange information between AP and VPU
+ * @ctx: context for v4l2 layer integration
+ * @dev: device for v4l2 layer integration
+ */
+struct venc_vp8_inst {
+	void __iomem *hw_base;
+	struct mtk_vcodec_mem work_bufs[VENC_VP8_VPU_WORK_BUF_MAX];
+	bool work_buf_allocated;
+	unsigned int frm_cnt;
+	unsigned int ts_mode;
+	unsigned int is_key_frm;
+	struct venc_vp8_vpu_inst vpu_inst;
+	void *ctx;
+	struct platform_device *dev;
+};
+
+struct venc_common_if *get_vp8_enc_comm_if(void);
+
+#endif
diff --git a/drivers/media/platform/mtk-vcodec/vp8_enc/venc_vp8_vpu.c b/drivers/media/platform/mtk-vcodec/vp8_enc/venc_vp8_vpu.c
new file mode 100644
index 0000000..5f797c9
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/vp8_enc/venc_vp8_vpu.c
@@ -0,0 +1,240 @@
+/*
+ * Copyright (c) 2015 MediaTek Inc.
+ * Author: Daniel Hsiao <daniel.hsiao@mediatek.com>
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
+#include "venc_vp8_if.h"
+#include "venc_vp8_vpu.h"
+#include "venc_ipi_msg.h"
+
+static void handle_vp8_enc_init_msg(struct venc_vp8_inst *inst, void *data)
+{
+	struct venc_vpu_ipi_msg_init *msg = data;
+
+	inst->vpu_inst.id = msg->inst_id;
+	inst->vpu_inst.drv = (struct venc_vp8_vpu_drv *)
+		vpu_mapping_dm_addr(inst->dev, msg->inst_id);
+}
+
+static void handle_vp8_enc_encode_msg(struct venc_vp8_inst *inst, void *data)
+{
+	struct venc_vpu_ipi_msg_enc *msg = data;
+
+	inst->vpu_inst.state = msg->state;
+	inst->is_key_frm = msg->key_frame;
+}
+
+static void vp8_enc_vpu_ipi_handler(void *data, unsigned int len, void *priv)
+{
+	struct venc_vpu_ipi_msg_common *msg = data;
+	struct venc_vp8_inst *inst = (struct venc_vp8_inst *)msg->venc_inst;
+
+	mtk_vcodec_debug(inst, "->msg_id=%x status=%d",
+			 msg->msg_id, msg->status);
+
+	switch (msg->msg_id) {
+	case VPU_IPIMSG_VP8_ENC_INIT_DONE:
+		handle_vp8_enc_init_msg(inst, data);
+		break;
+	case VPU_IPIMSG_VP8_ENC_SET_PARAM_DONE:
+		break;
+	case VPU_IPIMSG_VP8_ENC_ENCODE_DONE:
+		handle_vp8_enc_encode_msg(inst, data);
+		break;
+	case VPU_IPIMSG_VP8_ENC_DEINIT_DONE:
+		break;
+	default:
+		mtk_vcodec_err(inst, "unknown msg id=%x", msg->msg_id);
+		break;
+	}
+
+	inst->vpu_inst.signaled = 1;
+	inst->vpu_inst.failure = (msg->status != VENC_IPI_MSG_STATUS_OK);
+
+	mtk_vcodec_debug_leave(inst);
+}
+
+static int vp8_enc_vpu_send_msg(struct venc_vp8_inst *inst, void *msg,
+				int len)
+{
+	int status;
+
+	mtk_vcodec_debug_enter(inst);
+	status = vpu_ipi_send(inst->dev, IPI_VENC_VP8, (void *)msg, len);
+	if (status) {
+		mtk_vcodec_err(inst,
+			       "vpu_ipi_send msg_id=%x len=%d failed status=%d",
+			       *(unsigned int *)msg, len, status);
+		return -EINVAL;
+	}
+	mtk_vcodec_debug_leave(inst);
+
+	return 0;
+}
+
+int vp8_enc_vpu_init(struct venc_vp8_inst *inst)
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
+	status = vpu_ipi_register(inst->dev, IPI_VENC_VP8,
+				  vp8_enc_vpu_ipi_handler,
+				  "vp8_enc", NULL);
+	if (status) {
+		mtk_vcodec_err(inst,
+			       "vpu_ipi_register failed status=%d", status);
+		return -EINVAL;
+	}
+
+	out.msg_id = AP_IPIMSG_VP8_ENC_INIT;
+	out.venc_inst = (unsigned long)inst;
+	if (vp8_enc_vpu_send_msg(inst, &out, sizeof(out)) ||
+	    inst->vpu_inst.failure) {
+		mtk_vcodec_err(inst, "failed");
+		return -EINVAL;
+	}
+
+	mtk_vcodec_debug_leave(inst);
+
+	return 0;
+}
+
+int vp8_enc_vpu_set_param(struct venc_vp8_inst *inst, unsigned int id,
+			  void *param)
+{
+	struct venc_ap_ipi_msg_set_param out;
+
+	mtk_vcodec_debug_enter(inst);
+
+	out.msg_id = AP_IPIMSG_VP8_ENC_SET_PARAM;
+	out.inst_id = inst->vpu_inst.id;
+	out.param_id = id;
+	switch (id) {
+	case VENC_SET_PARAM_ENC: {
+		struct venc_enc_prm *enc_param = (struct venc_enc_prm *)param;
+
+		inst->vpu_inst.drv->config.input_fourcc =
+			enc_param->input_fourcc;
+		inst->vpu_inst.drv->config.bitrate = enc_param->bitrate;
+		inst->vpu_inst.drv->config.pic_w = enc_param->width;
+		inst->vpu_inst.drv->config.pic_h = enc_param->height;
+		inst->vpu_inst.drv->config.buf_w = enc_param->buf_width;
+		inst->vpu_inst.drv->config.buf_h = enc_param->buf_height;
+		inst->vpu_inst.drv->config.intra_period =
+			enc_param->intra_period;
+		inst->vpu_inst.drv->config.framerate = enc_param->frm_rate;
+		inst->vpu_inst.drv->config.ts_mode = inst->ts_mode;
+		out.data_item = 0;
+		break;
+	}
+	case VENC_SET_PARAM_FORCE_INTRA:
+		out.data_item = 0;
+		break;
+	case VENC_SET_PARAM_ADJUST_BITRATE:
+		out.data_item = 1;
+		out.data[0] = *(unsigned int *)param;
+		break;
+	case VENC_SET_PARAM_ADJUST_FRAMERATE:
+		out.data_item = 1;
+		out.data[0] = *(unsigned int *)param;
+		break;
+	case VENC_SET_PARAM_I_FRAME_INTERVAL:
+		out.data_item = 1;
+		out.data[0] = *(unsigned int *)param;
+		break;
+	}
+	if (vp8_enc_vpu_send_msg(inst, &out, sizeof(out)) ||
+	    inst->vpu_inst.failure) {
+		mtk_vcodec_err(inst, "failed");
+		return -EINVAL;
+	}
+
+	mtk_vcodec_debug_leave(inst);
+
+	return 0;
+}
+
+int vp8_enc_vpu_encode(struct venc_vp8_inst *inst,
+		       struct venc_frm_buf *frm_buf,
+		       struct mtk_vcodec_mem *bs_buf)
+{
+	struct venc_ap_ipi_msg_enc out;
+
+	mtk_vcodec_debug_enter(inst);
+
+	out.msg_id = AP_IPIMSG_VP8_ENC_ENCODE;
+	out.inst_id = inst->vpu_inst.id;
+	if (frm_buf) {
+		if ((frm_buf->fb_addr.dma_addr % 16 == 0) &&
+		    (frm_buf->fb_addr1.dma_addr % 16 == 0) &&
+		    (frm_buf->fb_addr2.dma_addr % 16 == 0)) {
+			out.input_addr[0] = frm_buf->fb_addr.dma_addr;
+			out.input_addr[1] = frm_buf->fb_addr1.dma_addr;
+			out.input_addr[2] = frm_buf->fb_addr2.dma_addr;
+		} else {
+			mtk_vcodec_err(inst, "dma_addr not align to 16");
+			return -EINVAL;
+		}
+	} else {
+		out.input_addr[0] = 0;
+		out.input_addr[1] = 0;
+		out.input_addr[2] = 0;
+	}
+	if (bs_buf) {
+		out.bs_addr = bs_buf->dma_addr;
+		out.bs_size = bs_buf->size;
+	} else {
+		out.bs_addr = 0;
+		out.bs_size = 0;
+	}
+	if (vp8_enc_vpu_send_msg(inst, &out, sizeof(out)) ||
+	    inst->vpu_inst.failure) {
+		mtk_vcodec_err(inst, "failed");
+		return -EINVAL;
+	}
+
+	mtk_vcodec_debug(inst, "state=%d key_frm=%d",
+			 inst->vpu_inst.state, inst->is_key_frm);
+
+	mtk_vcodec_debug_leave(inst);
+
+	return 0;
+}
+
+int vp8_enc_vpu_deinit(struct venc_vp8_inst *inst)
+{
+	struct venc_ap_ipi_msg_deinit out;
+
+	mtk_vcodec_debug_enter(inst);
+
+	out.msg_id = AP_IPIMSG_VP8_ENC_DEINIT;
+	out.inst_id = inst->vpu_inst.id;
+	if (vp8_enc_vpu_send_msg(inst, &out, sizeof(out)) ||
+	    inst->vpu_inst.failure) {
+		mtk_vcodec_err(inst, "failed");
+		return -EINVAL;
+	}
+
+	mtk_vcodec_debug_leave(inst);
+
+	return 0;
+}
diff --git a/drivers/media/platform/mtk-vcodec/vp8_enc/venc_vp8_vpu.h b/drivers/media/platform/mtk-vcodec/vp8_enc/venc_vp8_vpu.h
new file mode 100644
index 0000000..d7d79a8
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/vp8_enc/venc_vp8_vpu.h
@@ -0,0 +1,28 @@
+/*
+ * Copyright (c) 2015 MediaTek Inc.
+ * Author: Daniel Hsiao <daniel.hsiao@mediatek.com>
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
+#ifndef _VENC_VP8_VPU_H_
+#define _VENC_VP8_VPU_H_
+
+int vp8_enc_vpu_init(struct venc_vp8_inst *inst);
+int vp8_enc_vpu_set_param(struct venc_vp8_inst *inst, unsigned int id,
+			  void *param);
+int vp8_enc_vpu_encode(struct venc_vp8_inst *inst,
+		       struct venc_frm_buf *frm_buf,
+		       struct mtk_vcodec_mem *bs_buf);
+int vp8_enc_vpu_deinit(struct venc_vp8_inst *inst);
+
+#endif
-- 
1.7.9.5

