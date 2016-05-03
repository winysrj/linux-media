Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:20267 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755699AbcECKLi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 May 2016 06:11:38 -0400
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
	<Tiffany.lin@mediatek.com>, Tiffany Lin <tiffany.lin@mediatek.com>,
	PoChun Lin <pochun.lin@mediatek.com>
Subject: [PATCH v10 6/8] [media] vcodec: mediatek: Add Mediatek VP8 Video Encoder Driver
Date: Tue, 3 May 2016 18:11:25 +0800
Message-ID: <1462270287-11374-7-git-send-email-tiffany.lin@mediatek.com>
In-Reply-To: <1462270287-11374-6-git-send-email-tiffany.lin@mediatek.com>
References: <1462270287-11374-1-git-send-email-tiffany.lin@mediatek.com>
 <1462270287-11374-2-git-send-email-tiffany.lin@mediatek.com>
 <1462270287-11374-3-git-send-email-tiffany.lin@mediatek.com>
 <1462270287-11374-4-git-send-email-tiffany.lin@mediatek.com>
 <1462270287-11374-5-git-send-email-tiffany.lin@mediatek.com>
 <1462270287-11374-6-git-send-email-tiffany.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add vp8 encoder driver for MT8173

Signed-off-by: PoChun Lin <pochun.lin@mediatek.com>
Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>

---
 drivers/media/platform/mtk-vcodec/Makefile         |    6 +-
 .../media/platform/mtk-vcodec/venc/venc_vp8_if.c   |  481 ++++++++++++++++++++
 drivers/media/platform/mtk-vcodec/venc_drv_if.c    |    7 +-
 drivers/media/platform/mtk-vcodec/venc_vpu_if.c    |  237 ++++++++++
 drivers/media/platform/mtk-vcodec/venc_vpu_if.h    |   61 +++
 5 files changed, 790 insertions(+), 2 deletions(-)
 create mode 100644 drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c
 create mode 100644 drivers/media/platform/mtk-vcodec/venc_vpu_if.c
 create mode 100644 drivers/media/platform/mtk-vcodec/venc_vpu_if.h

diff --git a/drivers/media/platform/mtk-vcodec/Makefile b/drivers/media/platform/mtk-vcodec/Makefile
index d04433be..bf73a45 100644
--- a/drivers/media/platform/mtk-vcodec/Makefile
+++ b/drivers/media/platform/mtk-vcodec/Makefile
@@ -1,12 +1,16 @@
 
+
 obj-$(CONFIG_VIDEO_MEDIATEK_VCODEC) += mtk-vcodec-enc.o mtk-vcodec-common.o
 
 
 
-mtk-vcodec-enc-y := mtk_vcodec_enc.o \
+mtk-vcodec-enc-y := venc/venc_vp8_if.o \
+		venc/venc_h264_if.o \
+		mtk_vcodec_enc.o \
 		mtk_vcodec_enc_drv.o \
 		mtk_vcodec_enc_pm.o \
 		venc_drv_if.o \
+		venc_vpu_if.o \
 
 mtk-vcodec-common-y := mtk_vcodec_intr.o \
 		mtk_vcodec_util.o\
diff --git a/drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c b/drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c
new file mode 100644
index 0000000..431ae70
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c
@@ -0,0 +1,481 @@
+/*
+ * Copyright (c) 2016 MediaTek Inc.
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
+#include "../mtk_vcodec_drv.h"
+#include "../mtk_vcodec_util.h"
+#include "../mtk_vcodec_intr.h"
+#include "../mtk_vcodec_enc.h"
+#include "../mtk_vcodec_enc_pm.h"
+#include "../venc_drv_base.h"
+#include "../venc_ipi_msg.h"
+#include "../venc_vpu_if.h"
+#include "mtk_vpu.h"
+
+#define VENC_BITSTREAM_FRAME_SIZE 0x0098
+#define VENC_BITSTREAM_HEADER_LEN 0x00e8
+
+/* This ac_tag is vp8 frame tag. */
+#define MAX_AC_TAG_SIZE 10
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
+	VENC_VP8_VPU_WORK_BUF_BS_HEADER,
+	VENC_VP8_VPU_WORK_BUF_PROB_BUF,
+	VENC_VP8_VPU_WORK_BUF_RC_INFO,
+	VENC_VP8_VPU_WORK_BUF_RC_CODE,
+	VENC_VP8_VPU_WORK_BUF_RC_CODE2,
+	VENC_VP8_VPU_WORK_BUF_RC_CODE3,
+	VENC_VP8_VPU_WORK_BUF_MAX,
+};
+
+/*
+ * struct venc_vp8_vpu_config - Structure for vp8 encoder configuration
+ * @input_fourcc: input fourcc
+ * @bitrate: target bitrate (in bps)
+ * @pic_w: picture width. Picture size is visible stream resolution, in pixels,
+ *         to be used for display purposes; must be smaller or equal to buffer
+ *         size.
+ * @pic_h: picture height
+ * @buf_w: buffer width (with 16 alignment). Buffer size is stream resolution
+ *         in pixels aligned to hardware requirements.
+ * @buf_h: buffer height (with 16 alignment)
+ * @gop_size: group of picture size (key frame)
+ * @framerate: frame rate in fps
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
+	u32 gop_size;
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
+ * struct venc_vp8_vsi - Structure for VPU driver control and info share
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
+struct venc_vp8_vsi {
+	struct venc_vp8_vpu_config config;
+	struct venc_vp8_vpu_buf work_bufs[VENC_VP8_VPU_WORK_BUF_MAX];
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
+ * @vpu_inst: VPU instance to exchange information between AP and VPU
+ * @vsi: driver structure allocated by VPU side and shared to AP side for
+ *	 control and info share
+ * @ctx: context for v4l2 layer integration
+ */
+struct venc_vp8_inst {
+	void __iomem *hw_base;
+	struct mtk_vcodec_mem work_bufs[VENC_VP8_VPU_WORK_BUF_MAX];
+	bool work_buf_allocated;
+	unsigned int frm_cnt;
+	unsigned int ts_mode;
+	struct venc_vpu_inst vpu_inst;
+	struct venc_vp8_vsi *vsi;
+	struct mtk_vcodec_ctx *ctx;
+};
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
+	for (i = 0; i < VENC_VP8_VPU_WORK_BUF_MAX; i++) {
+		if ((inst->work_bufs[i].size == 0))
+			continue;
+		mtk_vcodec_mem_free(inst->ctx, &inst->work_bufs[i]);
+	}
+
+	mtk_vcodec_debug_leave(inst);
+}
+
+static int vp8_enc_alloc_work_buf(struct venc_vp8_inst *inst)
+{
+	int i;
+	int ret = 0;
+	struct venc_vp8_vpu_buf *wb = inst->vsi->work_bufs;
+
+	mtk_vcodec_debug_enter(inst);
+
+	for (i = 0; i < VENC_VP8_VPU_WORK_BUF_MAX; i++) {
+		if ((wb[i].size == 0))
+			continue;
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
+		inst->work_bufs[i].size = wb[i].size;
+		ret = mtk_vcodec_mem_alloc(inst->ctx, &inst->work_bufs[i]);
+		if (ret) {
+			mtk_vcodec_err(inst,
+				       "cannot alloc work_bufs[%d]", i);
+			goto err_alloc;
+		}
+		/*
+		 * This RC_CODEx is pre-allocated by VPU and saved in VPU addr.
+		 * So we need use memcpy to copy RC_CODEx from VPU addr into IO
+		 * virtual addr in 'iova' field for reg setting in VPU side.
+		 */
+		if (i == VENC_VP8_VPU_WORK_BUF_RC_CODE ||
+		    i == VENC_VP8_VPU_WORK_BUF_RC_CODE2 ||
+		    i == VENC_VP8_VPU_WORK_BUF_RC_CODE3) {
+			void *tmp_va;
+
+			tmp_va = vpu_mapping_dm_addr(inst->vpu_inst.dev,
+						     wb[i].vpua);
+			memcpy(inst->work_bufs[i].va, tmp_va, wb[i].size);
+		}
+		wb[i].iova = inst->work_bufs[i].dma_addr;
+
+		mtk_vcodec_debug(inst,
+				 "work_bufs[%d] va=0x%p,iova=0x%p,size=%zu",
+				 i, inst->work_bufs[i].va,
+				 (void *)inst->work_bufs[i].dma_addr,
+				 inst->work_bufs[i].size);
+	}
+
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
+	if (!mtk_vcodec_wait_for_done_ctx(ctx, MTK_INST_IRQ_RECEIVED,
+					  WAIT_INTR_TIMEOUT_MS)) {
+		irq_status = ctx->irq_status;
+		mtk_vcodec_debug(inst, "isr return %x", irq_status);
+	}
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
+	unsigned int not_key;
+	u32 bs_frm_size;
+	u32 bs_hdr_len;
+	unsigned int ac_tag_size;
+	u8 ac_tag[MAX_AC_TAG_SIZE];
+
+	bs_frm_size = vp8_enc_read_reg(inst, VENC_BITSTREAM_FRAME_SIZE);
+	bs_hdr_len = vp8_enc_read_reg(inst, VENC_BITSTREAM_HEADER_LEN);
+
+	/* if a frame is key frame, not_key is 0 */
+	not_key = !inst->vpu_inst.is_key_frm;
+	*(u32 *)ac_tag = __cpu_to_le32((bs_hdr_len << 5) | 0x10 | not_key);
+	/* key frame */
+	if (not_key == 0) {
+		ac_tag_size = MAX_AC_TAG_SIZE;
+		ac_tag[3] = 0x9d;
+		ac_tag[4] = 0x01;
+		ac_tag[5] = 0x2a;
+		ac_tag[6] = inst->vsi->config.pic_w;
+		ac_tag[7] = inst->vsi->config.pic_w >> 8;
+		ac_tag[8] = inst->vsi->config.pic_h;
+		ac_tag[9] = inst->vsi->config.pic_h >> 8;
+	} else {
+		ac_tag_size = 3;
+	}
+
+	if (bs_buf->size < bs_hdr_len + bs_frm_size + ac_tag_size) {
+		mtk_vcodec_err(inst, "bitstream buf size is too small(%zu)",
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
+	memmove(bs_buf->va + bs_hdr_len + ac_tag_size,
+		bs_buf->va, bs_frm_size);
+	memcpy(bs_buf->va + ac_tag_size,
+	       inst->work_bufs[VENC_VP8_VPU_WORK_BUF_BS_HEADER].va,
+	       bs_hdr_len);
+	memcpy(bs_buf->va, ac_tag, ac_tag_size);
+	*bs_size = bs_frm_size + bs_hdr_len + ac_tag_size;
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
+	ret = vpu_enc_encode(&inst->vpu_inst, 0, frm_buf, bs_buf, bs_size);
+	if (ret)
+		return ret;
+
+	irq_status = vp8_enc_wait_venc_done(inst);
+	if (irq_status != MTK_VENC_IRQ_STATUS_FRM) {
+		mtk_vcodec_err(inst, "irq_status=%d failed", irq_status);
+		return -EIO;
+	}
+
+	if (vp8_enc_compose_one_frame(inst, bs_buf, bs_size)) {
+		mtk_vcodec_err(inst, "vp8_enc_compose_one_frame failed");
+		return -EINVAL;
+	}
+
+	inst->frm_cnt++;
+	mtk_vcodec_debug(inst, "<-size=%d key_frm=%d", *bs_size,
+			 inst->vpu_inst.is_key_frm);
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
+	inst->vpu_inst.ctx = ctx;
+	inst->vpu_inst.dev = ctx->dev->vpu_plat_dev;
+	inst->vpu_inst.id = IPI_VENC_VP8;
+	inst->hw_base = mtk_vcodec_get_reg_addr(inst->ctx, VENC_LT_SYS);
+
+	mtk_vcodec_debug_enter(inst);
+
+	ret = vpu_enc_init(&inst->vpu_inst);
+
+	inst->vsi = (struct venc_vp8_vsi *)inst->vpu_inst.vsi;
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
+		result->is_key_frm = inst->vpu_inst.is_key_frm;
+		break;
+
+	default:
+		mtk_vcodec_err(inst, "opt not support:%d", opt);
+		ret = -EINVAL;
+		break;
+	}
+
+encode_err:
+
+	disable_irq(ctx->dev->enc_lt_irq);
+	mtk_vcodec_debug_leave(inst);
+
+	return ret;
+}
+
+static int vp8_enc_set_param(unsigned long handle,
+			     enum venc_set_param_type type,
+			     struct venc_enc_param *enc_prm)
+{
+	int ret = 0;
+	struct venc_vp8_inst *inst = (struct venc_vp8_inst *)handle;
+
+	mtk_vcodec_debug(inst, "->type=%d", type);
+
+	switch (type) {
+	case VENC_SET_PARAM_ENC:
+		inst->vsi->config.input_fourcc = enc_prm->input_yuv_fmt;
+		inst->vsi->config.bitrate = enc_prm->bitrate;
+		inst->vsi->config.pic_w = enc_prm->width;
+		inst->vsi->config.pic_h = enc_prm->height;
+		inst->vsi->config.buf_w = enc_prm->buf_width;
+		inst->vsi->config.buf_h = enc_prm->buf_height;
+		inst->vsi->config.gop_size = enc_prm->gop_size;
+		inst->vsi->config.framerate = enc_prm->frm_rate;
+		inst->vsi->config.ts_mode = inst->ts_mode;
+		ret = vpu_enc_set_param(&inst->vpu_inst, type, enc_prm);
+		if (ret)
+			break;
+		if (inst->work_buf_allocated) {
+			vp8_enc_free_work_buf(inst);
+			inst->work_buf_allocated = false;
+		}
+		ret = vp8_enc_alloc_work_buf(inst);
+		if (ret)
+			break;
+		inst->work_buf_allocated = true;
+		break;
+
+	/*
+	 * VENC_SET_PARAM_TS_MODE must be called before VENC_SET_PARAM_ENC
+	 */
+	case VENC_SET_PARAM_TS_MODE:
+		inst->ts_mode = 1;
+		mtk_vcodec_debug(inst, "set ts_mode");
+		break;
+
+	default:
+		ret = vpu_enc_set_param(&inst->vpu_inst, type, enc_prm);
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
+	ret = vpu_enc_deinit(&inst->vpu_inst);
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
+struct venc_common_if *get_vp8_enc_comm_if(void);
+
+struct venc_common_if *get_vp8_enc_comm_if(void)
+{
+	return &venc_vp8_if;
+}
diff --git a/drivers/media/platform/mtk-vcodec/venc_drv_if.c b/drivers/media/platform/mtk-vcodec/venc_drv_if.c
index 79ec9f5..77c39d2 100644
--- a/drivers/media/platform/mtk-vcodec/venc_drv_if.c
+++ b/drivers/media/platform/mtk-vcodec/venc_drv_if.c
@@ -19,12 +19,15 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 
+#include "venc_drv_base.h"
 #include "venc_drv_if.h"
+
 #include "mtk_vcodec_enc.h"
 #include "mtk_vcodec_enc_pm.h"
 #include "mtk_vpu.h"
 
-#include "venc_drv_base.h"
+
+struct venc_common_if *get_vp8_enc_comm_if(void);
 
 int venc_if_init(struct mtk_vcodec_ctx *ctx, unsigned int fourcc)
 {
@@ -32,6 +35,8 @@ int venc_if_init(struct mtk_vcodec_ctx *ctx, unsigned int fourcc)
 
 	switch (fourcc) {
 	case V4L2_PIX_FMT_VP8:
+		ctx->enc_if = get_vp8_enc_comm_if();
+		break;
 	case V4L2_PIX_FMT_H264:
 	default:
 		return -EINVAL;
diff --git a/drivers/media/platform/mtk-vcodec/venc_vpu_if.c b/drivers/media/platform/mtk-vcodec/venc_vpu_if.c
new file mode 100644
index 0000000..b92c6d2
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/venc_vpu_if.c
@@ -0,0 +1,237 @@
+/*
+ * Copyright (c) 2016 MediaTek Inc.
+ * Author: PoChun Lin <pochun.lin@mediatek.com>
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
+#include "venc_ipi_msg.h"
+#include "venc_vpu_if.h"
+
+static void handle_enc_init_msg(struct venc_vpu_inst *vpu, void *data)
+{
+	struct venc_vpu_ipi_msg_init *msg = data;
+
+	vpu->inst_addr = msg->vpu_inst_addr;
+	vpu->vsi = vpu_mapping_dm_addr(vpu->dev, msg->vpu_inst_addr);
+}
+
+static void handle_enc_encode_msg(struct venc_vpu_inst *vpu, void *data)
+{
+	struct venc_vpu_ipi_msg_enc *msg = data;
+
+	vpu->state = msg->state;
+	vpu->bs_size = msg->bs_size;
+	vpu->is_key_frm = msg->is_key_frm;
+}
+
+static void vpu_enc_ipi_handler(void *data, unsigned int len, void *priv)
+{
+	struct venc_vpu_ipi_msg_common *msg = data;
+	struct venc_vpu_inst *vpu = (struct venc_vpu_inst *)msg->venc_inst;
+
+	mtk_vcodec_debug(vpu, "msg_id %x inst %p status %d",
+			 msg->msg_id, vpu, msg->status);
+
+	switch (msg->msg_id) {
+	case VPU_IPIMSG_ENC_INIT_DONE:
+		handle_enc_init_msg(vpu, data);
+		break;
+	case VPU_IPIMSG_ENC_SET_PARAM_DONE:
+		break;
+	case VPU_IPIMSG_ENC_ENCODE_DONE:
+		handle_enc_encode_msg(vpu, data);
+		break;
+	case VPU_IPIMSG_ENC_DEINIT_DONE:
+		break;
+	default:
+		mtk_vcodec_err(vpu, "unknown msg id %x", msg->msg_id);
+		break;
+	}
+
+	vpu->signaled = 1;
+	vpu->failure = (msg->status != VENC_IPI_MSG_STATUS_OK);
+
+	mtk_vcodec_debug_leave(vpu);
+}
+
+static int vpu_enc_send_msg(struct venc_vpu_inst *vpu, void *msg,
+			    int len)
+{
+	int status;
+
+	mtk_vcodec_debug_enter(vpu);
+
+	if (!vpu->dev) {
+		mtk_vcodec_err(vpu, "inst dev is NULL");
+		return -EINVAL;
+	}
+
+	status = vpu_ipi_send(vpu->dev, vpu->id, msg, len);
+	if (status) {
+		uint32_t msg_id = *(uint32_t *)msg;
+
+		mtk_vcodec_err(vpu, "vpu_ipi_send msg_id %x len %d fail %d",
+			       msg_id, len, status);
+		return -EINVAL;
+	}
+	if (vpu->failure)
+		return -EINVAL;
+
+	mtk_vcodec_debug_leave(vpu);
+
+	return 0;
+}
+
+int vpu_enc_init(struct venc_vpu_inst *vpu)
+{
+	int status;
+	struct venc_ap_ipi_msg_init out;
+
+	mtk_vcodec_debug_enter(vpu);
+
+	init_waitqueue_head(&vpu->wq_hd);
+	vpu->signaled = 0;
+	vpu->failure = 0;
+
+	status = vpu_ipi_register(vpu->dev, vpu->id, vpu_enc_ipi_handler,
+				  NULL, NULL);
+	if (status) {
+		mtk_vcodec_err(vpu, "vpu_ipi_register fail %d", status);
+		return -EINVAL;
+	}
+
+	memset(&out, 0, sizeof(out));
+	out.msg_id = AP_IPIMSG_ENC_INIT;
+	out.venc_inst = (unsigned long)vpu;
+	if (vpu_enc_send_msg(vpu, &out, sizeof(out))) {
+		mtk_vcodec_err(vpu, "AP_IPIMSG_ENC_INIT fail");
+		return -EINVAL;
+	}
+
+	mtk_vcodec_debug_leave(vpu);
+
+	return 0;
+}
+
+int vpu_enc_set_param(struct venc_vpu_inst *vpu,
+		      enum venc_set_param_type id,
+		      struct venc_enc_param *enc_param)
+{
+	struct venc_ap_ipi_msg_set_param out;
+
+	mtk_vcodec_debug(vpu, "id %d ->", id);
+
+	memset(&out, 0, sizeof(out));
+	out.msg_id = AP_IPIMSG_ENC_SET_PARAM;
+	out.vpu_inst_addr = vpu->inst_addr;
+	out.param_id = id;
+	switch (id) {
+	case VENC_SET_PARAM_ENC:
+		out.data_item = 0;
+		break;
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
+		mtk_vcodec_err(vpu, "id %d not supported", id);
+		return -EINVAL;
+	}
+	if (vpu_enc_send_msg(vpu, &out, sizeof(out))) {
+		mtk_vcodec_err(vpu,
+			       "AP_IPIMSG_ENC_SET_PARAM %d fail", id);
+		return -EINVAL;
+	}
+
+	mtk_vcodec_debug(vpu, "id %d <-", id);
+
+	return 0;
+}
+
+int vpu_enc_encode(struct venc_vpu_inst *vpu, unsigned int bs_mode,
+		   struct venc_frm_buf *frm_buf,
+		   struct mtk_vcodec_mem *bs_buf,
+		   unsigned int *bs_size)
+{
+	struct venc_ap_ipi_msg_enc out;
+
+	mtk_vcodec_debug(vpu, "bs_mode %d ->", bs_mode);
+
+	memset(&out, 0, sizeof(out));
+	out.msg_id = AP_IPIMSG_ENC_ENCODE;
+	out.vpu_inst_addr = vpu->inst_addr;
+	out.bs_mode = bs_mode;
+	if (frm_buf) {
+		if ((frm_buf->fb_addr[0].dma_addr % 16 == 0) &&
+		    (frm_buf->fb_addr[1].dma_addr % 16 == 0) &&
+		    (frm_buf->fb_addr[2].dma_addr % 16 == 0)) {
+			out.input_addr[0] = frm_buf->fb_addr[0].dma_addr;
+			out.input_addr[1] = frm_buf->fb_addr[1].dma_addr;
+			out.input_addr[2] = frm_buf->fb_addr[2].dma_addr;
+		} else {
+			mtk_vcodec_err(vpu, "dma_addr not align to 16");
+			return -EINVAL;
+		}
+	}
+	if (bs_buf) {
+		out.bs_addr = bs_buf->dma_addr;
+		out.bs_size = bs_buf->size;
+	}
+	if (vpu_enc_send_msg(vpu, &out, sizeof(out))) {
+		mtk_vcodec_err(vpu, "AP_IPIMSG_ENC_ENCODE %d fail",
+			       bs_mode);
+		return -EINVAL;
+	}
+
+	mtk_vcodec_debug(vpu, "bs_mode %d state %d size %d key_frm %d <-",
+			 bs_mode, vpu->state, vpu->bs_size, vpu->is_key_frm);
+
+	return 0;
+}
+
+int vpu_enc_deinit(struct venc_vpu_inst *vpu)
+{
+	struct venc_ap_ipi_msg_deinit out;
+
+	mtk_vcodec_debug_enter(vpu);
+
+	memset(&out, 0, sizeof(out));
+	out.msg_id = AP_IPIMSG_ENC_DEINIT;
+	out.vpu_inst_addr = vpu->inst_addr;
+	if (vpu_enc_send_msg(vpu, &out, sizeof(out))) {
+		mtk_vcodec_err(vpu, "AP_IPIMSG_ENC_DEINIT fail");
+		return -EINVAL;
+	}
+
+	mtk_vcodec_debug_leave(vpu);
+
+	return 0;
+}
diff --git a/drivers/media/platform/mtk-vcodec/venc_vpu_if.h b/drivers/media/platform/mtk-vcodec/venc_vpu_if.h
new file mode 100644
index 0000000..215d1e0
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/venc_vpu_if.h
@@ -0,0 +1,61 @@
+/*
+ * Copyright (c) 2016 MediaTek Inc.
+ * Author: PoChun Lin <pochun.lin@mediatek.com>
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
+#ifndef _VENC_VPU_IF_H_
+#define _VENC_VPU_IF_H_
+
+#include "mtk_vpu.h"
+#include "venc_drv_if.h"
+
+/*
+ * struct venc_vpu_inst - encoder VPU driver instance
+ * @wq_hd: wait queue used for vpu cmd trigger then wait vpu interrupt done
+ * @signaled: flag used for checking vpu interrupt done
+ * @failure: flag to show vpu cmd succeeds or not
+ * @state: enum venc_ipi_msg_enc_state
+ * @bs_size: bitstream size for skip frame case usage
+ * @is_key_frm: key frame flag
+ * @inst_addr: VPU instance addr
+ * @vsi: driver structure allocated by VPU side and shared to AP side for
+ *	 control and info share
+ * @id: the id of inter-processor interrupt
+ * @ctx: context for v4l2 layer integration
+ * @dev: device for v4l2 layer integration
+ */
+struct venc_vpu_inst {
+	wait_queue_head_t wq_hd;
+	int signaled;
+	int failure;
+	int state;
+	int bs_size;
+	int is_key_frm;
+	unsigned int inst_addr;
+	void *vsi;
+	enum ipi_id id;
+	struct mtk_vcodec_ctx *ctx;
+	struct platform_device *dev;
+};
+
+int vpu_enc_init(struct venc_vpu_inst *vpu);
+int vpu_enc_set_param(struct venc_vpu_inst *vpu,
+		      enum venc_set_param_type id,
+		      struct venc_enc_param *param);
+int vpu_enc_encode(struct venc_vpu_inst *vpu, unsigned int bs_mode,
+		   struct venc_frm_buf *frm_buf,
+		   struct mtk_vcodec_mem *bs_buf,
+		   unsigned int *bs_size);
+int vpu_enc_deinit(struct venc_vpu_inst *vpu);
+
+#endif
-- 
1.7.9.5

