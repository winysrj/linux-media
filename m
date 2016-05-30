Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:8403 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933108AbcE3M3f (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 May 2016 08:29:35 -0400
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
	PC Chen <pc.chen@mediatek.com>
Subject: [PATCH v3 6/9] vcodec: mediatek: Add Mediatek H264 Video Decoder Driver
Date: Mon, 30 May 2016 20:29:20 +0800
Message-ID: <1464611363-14936-7-git-send-email-tiffany.lin@mediatek.com>
In-Reply-To: <1464611363-14936-6-git-send-email-tiffany.lin@mediatek.com>
References: <1464611363-14936-1-git-send-email-tiffany.lin@mediatek.com>
 <1464611363-14936-2-git-send-email-tiffany.lin@mediatek.com>
 <1464611363-14936-3-git-send-email-tiffany.lin@mediatek.com>
 <1464611363-14936-4-git-send-email-tiffany.lin@mediatek.com>
 <1464611363-14936-5-git-send-email-tiffany.lin@mediatek.com>
 <1464611363-14936-6-git-send-email-tiffany.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add h264 decoder driver for MT8173

Signed-off-by: PC Chen <pc.chen@mediatek.com>
Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
---
 drivers/media/platform/mtk-vcodec/Makefile         |    5 +-
 .../media/platform/mtk-vcodec/vdec/vdec_h264_if.c  |  503 ++++++++++++++++++++
 drivers/media/platform/mtk-vcodec/vdec_drv_if.c    |    4 +
 drivers/media/platform/mtk-vcodec/vdec_vpu_if.c    |  168 +++++++
 drivers/media/platform/mtk-vcodec/vdec_vpu_if.h    |   96 ++++
 5 files changed, 774 insertions(+), 2 deletions(-)
 create mode 100644 drivers/media/platform/mtk-vcodec/vdec/vdec_h264_if.c
 create mode 100644 drivers/media/platform/mtk-vcodec/vdec_vpu_if.c
 create mode 100644 drivers/media/platform/mtk-vcodec/vdec_vpu_if.h

diff --git a/drivers/media/platform/mtk-vcodec/Makefile b/drivers/media/platform/mtk-vcodec/Makefile
index 4c8ed2f..58243ed 100644
--- a/drivers/media/platform/mtk-vcodec/Makefile
+++ b/drivers/media/platform/mtk-vcodec/Makefile
@@ -1,11 +1,12 @@
 
-
 obj-$(CONFIG_VIDEO_MEDIATEK_VCODEC) += mtk-vcodec-dec.o \
 				       mtk-vcodec-enc.o \
 				       mtk-vcodec-common.o
 
-mtk-vcodec-dec-y := mtk_vcodec_dec_drv.o \
+mtk-vcodec-dec-y := vdec/vdec_h264_if.o \
+		mtk_vcodec_dec_drv.o \
 		vdec_drv_if.o \
+		vdec_vpu_if.o \
 		mtk_vcodec_dec.o \
 		mtk_vcodec_dec_pm.o \
 
diff --git a/drivers/media/platform/mtk-vcodec/vdec/vdec_h264_if.c b/drivers/media/platform/mtk-vcodec/vdec/vdec_h264_if.c
new file mode 100644
index 0000000..8de0b53
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/vdec/vdec_h264_if.c
@@ -0,0 +1,503 @@
+/*
+ * Copyright (c) 2016 MediaTek Inc.
+ * Author: PC Chen <pc.chen@mediatek.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/slab.h>
+
+#include "../mtk_vcodec_intr.h"
+#include "../vdec_vpu_if.h"
+#include "../vdec_drv_base.h"
+
+#define NAL_NON_IDR_SLICE			0x01
+#define NAL_IDR_SLICE				0x05
+#define NAL_H264_PPS				0x08
+#define NAL_TYPE(value)				((value) & 0x1F)
+
+#define BUF_PREDICTION_SZ			(32 * 1024)
+
+#define MB_UNIT_LEN				16
+
+/* motion vector size (bytes) for every macro block */
+#define HW_MB_STORE_SZ				64
+
+#define H264_MAX_FB_NUM				17
+#define HDR_PARSING_BUF_SZ			1024
+
+/**
+ * struct h264_fb - h264 decode frame buffer information
+ * @vdec_fb_va  : virtual address of struct vdec_fb
+ * @y_fb_dma    : dma address of Y frame buffer (luma)
+ * @c_fb_dma    : dma address of C frame buffer (chroma)
+ * @poc         : picture order count of frame buffer
+ * @reserved    : for 8 bytes alignment
+ */
+struct h264_fb {
+	uint64_t vdec_fb_va;
+	uint64_t y_fb_dma;
+	uint64_t c_fb_dma;
+	int32_t poc;
+	uint32_t reserved;
+};
+
+/**
+ * struct h264_ring_fb_list - ring frame buffer list
+ * @fb_list   : frame buffer arrary
+ * @read_idx  : read index
+ * @write_idx : write index
+ * @count     : buffer count in list
+ */
+struct h264_ring_fb_list {
+	struct h264_fb fb_list[H264_MAX_FB_NUM];
+	unsigned int read_idx;
+	unsigned int write_idx;
+	unsigned int count;
+	unsigned int reserved;
+};
+
+/**
+ * struct vdec_h264_dec_info - decode information
+ * @dpb_sz		: decoding picture buffer size
+ * @resolution_changed  : resoltion change happen
+ * @realloc_mv_buf	: flag to notify driver to re-allocate mv buffer
+ * @reserved		: for 8 bytes alignment
+ * @bs_dma		: Input bit-stream buffer dma address
+ * @y_fb_dma		: Y frame buffer dma address
+ * @c_fb_dma		: C frame buffer dma address
+ * @vdec_fb_va		: VDEC frame buffer struct virtual address
+ */
+struct vdec_h264_dec_info {
+	uint32_t dpb_sz;
+	uint32_t resolution_changed;
+	uint32_t realloc_mv_buf;
+	uint32_t reserved;
+	uint64_t bs_dma;
+	uint64_t y_fb_dma;
+	uint64_t c_fb_dma;
+	uint64_t vdec_fb_va;
+};
+
+/**
+ * struct vdec_h264_vsi - shared memory for decode information exchange
+ *                        between VPU and Host.
+ *                        The memory is allocated by VPU then mapping to Host
+ *                        in vpu_dec_init() and freed in vpu_dec_deinit()
+ *                        by VPU.
+ *                        AP-W/R : AP is writer/reader on this item
+ *                        VPU-W/R: VPU is write/reader on this item
+ * @hdr_buf      : Header parsing buffer (AP-W, VPU-R)
+ * @pred_buf_dma : HW working predication buffer dma address (AP-W, VPU-R)
+ * @mv_buf_dma   : HW working motion vector buffer dma address (AP-W, VPU-R)
+ * @list_free    : free frame buffer ring list (AP-W/R, VPU-W)
+ * @list_disp    : display frame buffer ring list (AP-R, VPU-W)
+ * @dec          : decode information (AP-R, VPU-W)
+ * @pic          : picture information (AP-R, VPU-W)
+ * @crop         : crop information (AP-R, VPU-W)
+ */
+struct vdec_h264_vsi {
+	unsigned char hdr_buf[HDR_PARSING_BUF_SZ];
+	uint64_t pred_buf_dma;
+	uint64_t mv_buf_dma[H264_MAX_FB_NUM];
+	struct h264_ring_fb_list list_free;
+	struct h264_ring_fb_list list_disp;
+	struct vdec_h264_dec_info dec;
+	struct vdec_pic_info pic;
+	struct v4l2_rect crop;
+};
+
+/**
+ * struct vdec_h264_inst - h264 decoder instance
+ * @num_nalu : how many nalus be decoded
+ * @ctx      : point to mtk_vcodec_ctx
+ * @pred_buf : HW working predication buffer
+ * @mv_buf   : HW working motion vector buffer
+ * @vpu      : VPU instance
+ * @vsi      : VPU shared information
+ */
+struct vdec_h264_inst {
+	unsigned int num_nalu;
+	struct mtk_vcodec_ctx *ctx;
+	struct mtk_vcodec_mem pred_buf;
+	struct mtk_vcodec_mem mv_buf[H264_MAX_FB_NUM];
+	struct vdec_vpu_inst vpu;
+	struct vdec_h264_vsi *vsi;
+};
+
+static unsigned int get_mv_buf_size(unsigned int width, unsigned int height)
+{
+	return HW_MB_STORE_SZ * (width/MB_UNIT_LEN) * (height/MB_UNIT_LEN);
+}
+
+static int allocate_predication_buf(struct vdec_h264_inst *inst)
+{
+	int err = 0;
+
+	inst->pred_buf.size = BUF_PREDICTION_SZ;
+	err = mtk_vcodec_mem_alloc(inst->ctx, &inst->pred_buf);
+	if (err) {
+		mtk_vcodec_err(inst, "failed to allocate ppl buf");
+		return err;
+	}
+
+	inst->vsi->pred_buf_dma = inst->pred_buf.dma_addr;
+	return 0;
+}
+
+static void free_predication_buf(struct vdec_h264_inst *inst)
+{
+	struct mtk_vcodec_mem *mem = NULL;
+
+	mtk_vcodec_debug_enter(inst);
+
+	inst->vsi->pred_buf_dma = 0;
+	mem = &inst->pred_buf;
+	if (mem->va)
+		mtk_vcodec_mem_free(inst->ctx, mem);
+}
+
+static int alloc_mv_buf(struct vdec_h264_inst *inst, struct vdec_pic_info *pic)
+{
+	int i;
+	int err;
+	struct mtk_vcodec_mem *mem = NULL;
+	unsigned int buf_sz = get_mv_buf_size(pic->buf_w, pic->buf_h);
+
+	for (i = 0; i < H264_MAX_FB_NUM; i++) {
+		mem = &inst->mv_buf[i];
+		if (mem->va)
+			mtk_vcodec_mem_free(inst->ctx, mem);
+		mem->size = buf_sz;
+		err = mtk_vcodec_mem_alloc(inst->ctx, mem);
+		if (err) {
+			mtk_vcodec_err(inst, "failed to allocate mv buf");
+			return err;
+		}
+		inst->vsi->mv_buf_dma[i] = mem->dma_addr;
+	}
+
+	return 0;
+}
+
+static void free_mv_buf(struct vdec_h264_inst *inst)
+{
+	int i;
+	struct mtk_vcodec_mem *mem = NULL;
+
+	for (i = 0; i < H264_MAX_FB_NUM; i++) {
+		inst->vsi->mv_buf_dma[i] = 0;
+		mem = &inst->mv_buf[i];
+		if (mem->va)
+			mtk_vcodec_mem_free(inst->ctx, mem);
+	}
+}
+
+static int check_list_validity(struct vdec_h264_inst *inst, bool disp_list)
+{
+	struct h264_ring_fb_list *list;
+
+	list = disp_list ? &inst->vsi->list_disp : &inst->vsi->list_free;
+
+	if (list->count > H264_MAX_FB_NUM ||
+	    list->read_idx >= H264_MAX_FB_NUM ||
+	    list->write_idx >= H264_MAX_FB_NUM) {
+		mtk_vcodec_err(inst, "%s list err: cnt=%d r_idx=%d w_idx=%d",
+			       disp_list ? "disp" : "free", list->count,
+			       list->read_idx, list->write_idx);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static void put_fb_to_free(struct vdec_h264_inst *inst, struct vdec_fb *fb)
+{
+	struct h264_ring_fb_list *list;
+
+	if (fb) {
+		if (check_list_validity(inst, false))
+			return;
+
+		list = &inst->vsi->list_free;
+		if (list->count == H264_MAX_FB_NUM) {
+			mtk_vcodec_err(inst, "[FB] put fb free_list full");
+			return;
+		}
+
+		mtk_vcodec_debug(inst, "[FB] put fb into free_list @(%p, %llx)",
+				 fb->base_y.va, (u64)fb->base_y.dma_addr);
+
+		list->fb_list[list->write_idx].vdec_fb_va = (u64)fb;
+		list->write_idx = (list->write_idx == H264_MAX_FB_NUM - 1) ?
+				  0 : list->write_idx + 1;
+		list->count++;
+	}
+}
+
+static void get_pic_info(struct vdec_h264_inst *inst,
+			 struct vdec_pic_info *pic)
+{
+	*pic = inst->vsi->pic;
+	mtk_vcodec_debug(inst, "pic(%d, %d), buf(%d, %d)",
+			 pic->pic_w, pic->pic_h, pic->buf_w, pic->buf_h);
+	mtk_vcodec_debug(inst, "Y(%d, %d), C(%d, %d)", pic->y_bs_sz,
+			 pic->y_len_sz, pic->c_bs_sz, pic->c_len_sz);
+}
+
+static void get_crop_info(struct vdec_h264_inst *inst, struct v4l2_rect *cr)
+{
+	cr->left = inst->vsi->crop.left;
+	cr->top = inst->vsi->crop.top;
+	cr->width = inst->vsi->crop.width;
+	cr->height = inst->vsi->crop.height;
+
+	mtk_vcodec_debug(inst, "l=%d, t=%d, w=%d, h=%d",
+			 cr->left, cr->top, cr->width, cr->height);
+}
+
+static void get_dpb_size(struct vdec_h264_inst *inst, unsigned int *dpb_sz)
+{
+	*dpb_sz = inst->vsi->dec.dpb_sz;
+	mtk_vcodec_debug(inst, "sz=%d", *dpb_sz);
+}
+
+static int vdec_h264_init(struct mtk_vcodec_ctx *ctx, unsigned long *h_vdec)
+{
+	struct vdec_h264_inst *inst = NULL;
+	int err;
+
+	inst = kzalloc(sizeof(*inst), GFP_KERNEL);
+	if (!inst)
+		return -ENOMEM;
+
+	inst->ctx = ctx;
+
+	inst->vpu.id = IPI_VDEC_H264;
+	inst->vpu.dev = ctx->dev->vpu_plat_dev;
+	inst->vpu.ctx = ctx;
+	inst->vpu.handler = vpu_dec_ipi_handler;
+
+	err = vpu_dec_init(&inst->vpu);
+	if (err) {
+		mtk_vcodec_err(inst, "vdec_h264 init err=%d", err);
+		goto error_free_inst;
+	}
+
+	inst->vsi = (struct vdec_h264_vsi *)inst->vpu.vsi;
+	err = allocate_predication_buf(inst);
+	if (err)
+		goto error_deinit;
+
+	mtk_vcodec_debug(inst, "H264 Instance >> %p", inst);
+
+	*h_vdec = (unsigned long)inst;
+	return 0;
+
+error_deinit:
+	vpu_dec_deinit(&inst->vpu);
+
+error_free_inst:
+	kfree(inst);
+	return err;
+}
+
+static void vdec_h264_deinit(unsigned long h_vdec)
+{
+	struct vdec_h264_inst *inst = (struct vdec_h264_inst *)h_vdec;
+
+	mtk_vcodec_debug_enter(inst);
+
+	vpu_dec_deinit(&inst->vpu);
+	free_predication_buf(inst);
+	free_mv_buf(inst);
+
+	kfree(inst);
+}
+
+static int find_start_code(unsigned char *data, unsigned int data_sz)
+{
+	if (data_sz > 3 && data[0] == 0 && data[1] == 0 && data[2] == 1)
+		return 3;
+
+	if (data_sz > 4 && data[0] == 0 && data[1] == 0 && data[2] == 0 &&
+	    data[3] == 1)
+		return 4;
+
+	return -1;
+}
+
+static int vdec_h264_decode(unsigned long h_vdec, struct mtk_vcodec_mem *bs,
+			    struct vdec_fb *fb, bool *res_chg)
+{
+	struct vdec_h264_inst *inst = (struct vdec_h264_inst *)h_vdec;
+	struct vdec_vpu_inst *vpu = &inst->vpu;
+	int nal_start_idx = 0;
+	int err = 0;
+	unsigned int nal_start;
+	unsigned int nal_type;
+	unsigned char *buf;
+	unsigned int buf_sz;
+	unsigned int data[2];
+	uint64_t vdec_fb_va = (u64)fb;
+	uint64_t y_fb_dma = fb ? (u64)fb->base_y.dma_addr : 0;
+	uint64_t c_fb_dma = fb ? (u64)fb->base_c.dma_addr : 0;
+
+	mtk_vcodec_debug(inst, "+ [%d] FB y_dma=%llx c_dma=%llx va=%p",
+			 ++inst->num_nalu, y_fb_dma, c_fb_dma, fb);
+
+	/* bs NULL means flush decoder */
+	if (bs == NULL)
+		return vpu_dec_reset(vpu);
+
+	buf = (unsigned char *)bs->va;
+	buf_sz = bs->size;
+	nal_start_idx = find_start_code(buf, buf_sz);
+	if (nal_start_idx < 0)
+		goto err_free_fb_out;
+
+	nal_start = buf[nal_start_idx];
+	nal_type = NAL_TYPE(buf[nal_start_idx]);
+	mtk_vcodec_debug(inst, "\n + NALU[%d] type %d +\n", inst->num_nalu,
+			 nal_type);
+
+	if (nal_type == NAL_H264_PPS) {
+		buf_sz -= nal_start_idx;
+		if (buf_sz > HDR_PARSING_BUF_SZ) {
+			err = -EILSEQ;
+			goto err_free_fb_out;
+		}
+		memcpy(inst->vsi->hdr_buf, buf + nal_start_idx, buf_sz);
+	}
+
+	inst->vsi->dec.bs_dma = (uint64_t)bs->dma_addr;
+	inst->vsi->dec.y_fb_dma = y_fb_dma;
+	inst->vsi->dec.c_fb_dma = c_fb_dma;
+	inst->vsi->dec.vdec_fb_va = vdec_fb_va;
+
+	data[0] = buf_sz;
+	data[1] = nal_start;
+	err = vpu_dec_start(vpu, data, 2);
+	if (err)
+		goto err_free_fb_out;
+
+	*res_chg = inst->vsi->dec.resolution_changed;
+	if (*res_chg) {
+		struct vdec_pic_info pic;
+
+		mtk_vcodec_debug(inst, "- resolution changed -");
+		get_pic_info(inst, &pic);
+
+		if (inst->vsi->dec.realloc_mv_buf) {
+			err = alloc_mv_buf(inst, &pic);
+			if (err)
+				goto err_free_fb_out;
+		}
+	}
+
+	if (nal_type == NAL_NON_IDR_SLICE || nal_type == NAL_IDR_SLICE) {
+		/* wait decoder done interrupt */
+		err = mtk_vcodec_wait_for_done_ctx(inst->ctx,
+						   MTK_INST_IRQ_RECEIVED,
+						   WAIT_INTR_TIMEOUT_MS);
+		if (err)
+			goto err_free_fb_out;
+
+		vpu_dec_end(vpu);
+	}
+
+	mtk_vcodec_debug(inst, "\n - NALU[%d] type=%d -\n", inst->num_nalu,
+			 nal_type);
+	return 0;
+
+err_free_fb_out:
+	put_fb_to_free(inst, fb);
+	mtk_vcodec_err(inst, "\n - NALU[%d] err=%d -\n", inst->num_nalu, err);
+	return err;
+}
+
+static void vdec_h264_get_fb(struct vdec_h264_inst *inst,
+			     struct h264_ring_fb_list *list,
+			     bool disp_list, struct vdec_fb **out_fb)
+{
+	struct vdec_fb *fb;
+
+	if (check_list_validity(inst, disp_list))
+		return;
+
+	if (list->count == 0) {
+		mtk_vcodec_debug(inst, "[FB] there is no %s fb",
+				 disp_list ? "disp" : "free");
+		*out_fb = NULL;
+		return;
+	}
+
+	fb = (struct vdec_fb *)list->fb_list[list->read_idx].vdec_fb_va;
+	fb->status |= (disp_list ? FB_ST_DISPLAY : FB_ST_FREE);
+
+	*out_fb = fb;
+	mtk_vcodec_debug(inst, "[FB] get %s fb st=%d poc=%d %llx",
+			 disp_list ? "disp" : "free",
+			 fb->status, list->fb_list[list->read_idx].poc,
+			 list->fb_list[list->read_idx].vdec_fb_va);
+
+	list->read_idx = (list->read_idx == H264_MAX_FB_NUM - 1) ?
+			 0 : list->read_idx + 1;
+	list->count--;
+}
+
+static int vdec_h264_get_param(unsigned long h_vdec,
+			       enum vdec_get_param_type type, void *out)
+{
+	struct vdec_h264_inst *inst = (struct vdec_h264_inst *)h_vdec;
+
+	switch (type) {
+	case GET_PARAM_DISP_FRAME_BUFFER:
+		vdec_h264_get_fb(inst, &inst->vsi->list_disp, true, out);
+		break;
+
+	case GET_PARAM_FREE_FRAME_BUFFER:
+		vdec_h264_get_fb(inst, &inst->vsi->list_free, false, out);
+		break;
+
+	case GET_PARAM_PIC_INFO:
+		get_pic_info(inst, out);
+		break;
+
+	case GET_PARAM_DPB_SIZE:
+		get_dpb_size(inst, out);
+		break;
+
+	case GET_PARAM_CROP_INFO:
+		get_crop_info(inst, out);
+		break;
+
+	default:
+		mtk_vcodec_err(inst, "invalid get parameter type=%d", type);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static struct vdec_common_if vdec_h264_if = {
+	vdec_h264_init,
+	vdec_h264_decode,
+	vdec_h264_get_param,
+	vdec_h264_deinit,
+};
+
+struct vdec_common_if *get_h264_dec_comm_if(void);
+
+struct vdec_common_if *get_h264_dec_comm_if(void)
+{
+	return &vdec_h264_if;
+}
diff --git a/drivers/media/platform/mtk-vcodec/vdec_drv_if.c b/drivers/media/platform/mtk-vcodec/vdec_drv_if.c
index 8202b14..e61f541 100644
--- a/drivers/media/platform/mtk-vcodec/vdec_drv_if.c
+++ b/drivers/media/platform/mtk-vcodec/vdec_drv_if.c
@@ -24,12 +24,16 @@
 #include "mtk_vcodec_util.h"
 #include "mtk_vpu.h"
 
+struct vdec_common_if *get_h264_dec_comm_if(void);
+
 int vdec_if_init(struct mtk_vcodec_ctx *ctx, unsigned int fourcc)
 {
 	int ret = 0;
 
 	switch (fourcc) {
 	case V4L2_PIX_FMT_H264:
+		ctx->dec_if = get_h264_dec_comm_if();
+		break;
 	case V4L2_PIX_FMT_VP8:
 	case V4L2_PIX_FMT_VP9:
 	default:
diff --git a/drivers/media/platform/mtk-vcodec/vdec_vpu_if.c b/drivers/media/platform/mtk-vcodec/vdec_vpu_if.c
new file mode 100644
index 0000000..0798a6b
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/vdec_vpu_if.c
@@ -0,0 +1,168 @@
+/*
+ * Copyright (c) 2016 MediaTek Inc.
+ * Author: PC Chen <pc.chen@mediatek.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include "mtk_vcodec_drv.h"
+#include "mtk_vcodec_util.h"
+#include "vdec_ipi_msg.h"
+#include "vdec_vpu_if.h"
+
+static void handle_init_ack_msg(struct vdec_vpu_ipi_init_ack *msg)
+{
+	struct vdec_vpu_inst *vpu = (struct vdec_vpu_inst *)msg->ap_inst_addr;
+
+	mtk_vcodec_debug(vpu, "+ ap_inst_addr = 0x%llx", msg->ap_inst_addr);
+
+	/* mapping VPU address to kernel virtual address */
+	/* the content in vsi is initialized to 0 in VPU */
+	vpu->vsi = vpu_mapping_dm_addr(vpu->dev, msg->vpu_inst_addr);
+	vpu->inst_addr = msg->vpu_inst_addr;
+
+	mtk_vcodec_debug(vpu, "- vpu_inst_addr = 0x%x", vpu->inst_addr);
+}
+
+/*
+ * This function runs in interrupt context and it means there's an IPI MSG
+ * from VPU.
+ */
+void vpu_dec_ipi_handler(void *data, unsigned int len, void *priv)
+{
+	struct vdec_vpu_ipi_ack *msg = data;
+	struct vdec_vpu_inst *vpu = (struct vdec_vpu_inst *)msg->ap_inst_addr;
+
+	mtk_vcodec_debug(vpu, "+ id=%X", msg->msg_id);
+
+	if (msg->status == 0) {
+		switch (msg->msg_id) {
+		case VPU_IPIMSG_DEC_INIT_ACK:
+			handle_init_ack_msg(data);
+			break;
+
+		case VPU_IPIMSG_DEC_START_ACK:
+		case VPU_IPIMSG_DEC_END_ACK:
+		case VPU_IPIMSG_DEC_DEINIT_ACK:
+		case VPU_IPIMSG_DEC_RESET_ACK:
+			break;
+
+		default:
+			mtk_vcodec_err(vpu, "invalid msg=%X", msg->msg_id);
+			break;
+		}
+	}
+
+	mtk_vcodec_debug(vpu, "- id=%X", msg->msg_id);
+	vpu->failure = msg->status;
+	vpu->signaled = 1;
+}
+
+static int vcodec_vpu_send_msg(struct vdec_vpu_inst *vpu, void *msg, int len)
+{
+	int err;
+	uint32_t msg_id = *(uint32_t *)msg;
+
+	mtk_vcodec_debug(vpu, "id=%X", msg_id);
+
+	vpu->failure = 0;
+	vpu->signaled = 0;
+
+	err = vpu_ipi_send(vpu->dev, vpu->id, msg, len);
+	if (err) {
+		mtk_vcodec_err(vpu, "send fail vpu_id=%d msg_id=%X status=%d",
+			       vpu->id, msg_id, err);
+		return err;
+	}
+
+	return vpu->failure;
+}
+
+static int vcodec_send_ap_ipi(struct vdec_vpu_inst *vpu, unsigned int msg_id)
+{
+	struct vdec_ap_ipi_cmd msg;
+	int err = 0;
+
+	mtk_vcodec_debug(vpu, "+ id=%X", msg_id);
+
+	memset(&msg, 0, sizeof(msg));
+	msg.msg_id = msg_id;
+	msg.vpu_inst_addr = vpu->inst_addr;
+
+	err = vcodec_vpu_send_msg(vpu, &msg, sizeof(msg));
+	mtk_vcodec_debug(vpu, "- id=%X ret=%d", msg_id, err);
+	return err;
+}
+
+int vpu_dec_init(struct vdec_vpu_inst *vpu)
+{
+	struct vdec_ap_ipi_init msg;
+	int err;
+
+	mtk_vcodec_debug_enter(vpu);
+
+	init_waitqueue_head(&vpu->wq);
+
+	err = vpu_ipi_register(vpu->dev, vpu->id, vpu->handler, "vdec", NULL);
+	if (err != 0) {
+		mtk_vcodec_err(vpu, "vpu_ipi_register fail status=%d", err);
+		return err;
+	}
+
+	memset(&msg, 0, sizeof(msg));
+	msg.msg_id = AP_IPIMSG_DEC_INIT;
+	msg.ap_inst_addr = (unsigned long)vpu;
+
+	mtk_vcodec_debug(vpu, "vdec_inst=%p", vpu);
+
+	err = vcodec_vpu_send_msg(vpu, (void *)&msg, sizeof(msg));
+	mtk_vcodec_debug(vpu, "- ret=%d", err);
+	return err;
+}
+
+int vpu_dec_start(struct vdec_vpu_inst *vpu, uint32_t *data, unsigned int len)
+{
+	struct vdec_ap_ipi_dec_start msg;
+	int i;
+	int err = 0;
+
+	mtk_vcodec_debug_enter(vpu);
+
+	if (len > ARRAY_SIZE(msg.data)) {
+		mtk_vcodec_err(vpu, "invalid len = %d\n", len);
+		return -EINVAL;
+	}
+
+	memset(&msg, 0, sizeof(msg));
+	msg.msg_id = AP_IPIMSG_DEC_START;
+	msg.vpu_inst_addr = vpu->inst_addr;
+
+	for (i = 0; i < len; i++)
+		msg.data[i] = data[i];
+
+	err = vcodec_vpu_send_msg(vpu, (void *)&msg, sizeof(msg));
+	mtk_vcodec_debug(vpu, "- ret=%d", err);
+	return err;
+}
+
+int vpu_dec_end(struct vdec_vpu_inst *vpu)
+{
+	return vcodec_send_ap_ipi(vpu, AP_IPIMSG_DEC_END);
+}
+
+int vpu_dec_deinit(struct vdec_vpu_inst *vpu)
+{
+	return vcodec_send_ap_ipi(vpu, AP_IPIMSG_DEC_DEINIT);
+}
+
+int vpu_dec_reset(struct vdec_vpu_inst *vpu)
+{
+	return vcodec_send_ap_ipi(vpu, AP_IPIMSG_DEC_RESET);
+}
diff --git a/drivers/media/platform/mtk-vcodec/vdec_vpu_if.h b/drivers/media/platform/mtk-vcodec/vdec_vpu_if.h
new file mode 100644
index 0000000..8dcc1cb
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/vdec_vpu_if.h
@@ -0,0 +1,96 @@
+/*
+ * Copyright (c) 2016 MediaTek Inc.
+ * Author: PC Chen <pc.chen@mediatek.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _VDEC_VPU_IF_H_
+#define _VDEC_VPU_IF_H_
+
+#include "mtk_vpu.h"
+
+/**
+ * struct vdec_vpu_inst - VPU instance for video codec
+ * @ipi_id      : ipi id for each decoder
+ * @vsi         : driver structure allocated by VPU side and shared to AP side
+ *                for control and info share
+ * @failure     : VPU execution result status, 0: success, others: fail
+ * @inst_addr	: VPU decoder instance address
+ * @signaled    : 1 - Host has received ack message from VPU, 0 - not received
+ * @ctx         : context for v4l2 layer integration
+ * @dev	        : platform device of VPU
+ * @wq          : wait queue to wait VPU message ack
+ * @handler     : ipi handler for each decoder
+ */
+struct vdec_vpu_inst {
+	enum ipi_id id;
+	void *vsi;
+	int32_t failure;
+	uint32_t inst_addr;
+	unsigned int signaled;
+	struct mtk_vcodec_ctx *ctx;
+	struct platform_device *dev;
+	wait_queue_head_t wq;
+	ipi_handler_t handler;
+};
+
+/**
+ * vpu_dec_init - init decoder instance and allocate required resource in VPU.
+ *
+ * @vpu: instance for vdec_vpu_inst
+ */
+int vpu_dec_init(struct vdec_vpu_inst *vpu);
+
+/**
+ * vpu_dec_start - start decoding, basically the function will be invoked once
+ *                 every frame.
+ *
+ * @vpu : instance for vdec_vpu_inst
+ * @data: meta data to pass bitstream info to VPU decoder
+ * @len : meta data length
+ */
+int vpu_dec_start(struct vdec_vpu_inst *vpu, uint32_t *data, unsigned int len);
+
+/**
+ * vpu_dec_end - end decoding, basically the function will be invoked once
+ *               when HW decoding done interrupt received successfully. The
+ *               decoder in VPU will continute to do referene frame management
+ *               and check if there is a new decoded frame available to display.
+ *
+ * @vpu : instance for vdec_vpu_inst
+ */
+int vpu_dec_end(struct vdec_vpu_inst *vpu);
+
+/**
+ * vpu_dec_deinit - deinit decoder instance and resource freed in VPU.
+ *
+ * @vpu: instance for vdec_vpu_inst
+ */
+int vpu_dec_deinit(struct vdec_vpu_inst *vpu);
+
+/**
+ * vpu_dec_reset - reset decoder, use for flush decoder when end of stream or
+ *                 seek. Remainig non displayed frame will be pushed to display.
+ *
+ * @vpu: instance for vdec_vpu_inst
+ */
+int vpu_dec_reset(struct vdec_vpu_inst *vpu);
+
+/**
+ * vpu_dec_ipi_handler - Handler for VPU ipi message.
+ *
+ * @data: ipi message
+ * @len : length of ipi message
+ * @priv: callback private data whcih is passed by decoder when register.
+ */
+void vpu_dec_ipi_handler(void *data, unsigned int len, void *priv);
+
+#endif
-- 
1.7.9.5

