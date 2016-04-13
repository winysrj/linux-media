Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:11610 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965853AbcDMMCH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Apr 2016 08:02:07 -0400
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
Subject: [PATCH 4/7] [media] vcodec: mediatek: Add Mediatek H264 Video Decoder Driver
Date: Wed, 13 Apr 2016 20:01:52 +0800
Message-ID: <1460548915-17536-5-git-send-email-tiffany.lin@mediatek.com>
In-Reply-To: <1460548915-17536-4-git-send-email-tiffany.lin@mediatek.com>
References: <1460548915-17536-1-git-send-email-tiffany.lin@mediatek.com>
 <1460548915-17536-2-git-send-email-tiffany.lin@mediatek.com>
 <1460548915-17536-3-git-send-email-tiffany.lin@mediatek.com>
 <1460548915-17536-4-git-send-email-tiffany.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add h264 driver for MT8173

Signed-off-by: PC Chen <pc.chen@mediatek.com>
Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
---
 drivers/media/platform/mtk-vcodec/Makefile         |    5 +-
 .../media/platform/mtk-vcodec/vdec/vdec_h264_if.c  |  487 ++++++++++++++++++++
 drivers/media/platform/mtk-vcodec/vdec_drv_if.c    |    4 +
 drivers/media/platform/mtk-vcodec/vdec_ipi_msg.h   |   28 +-
 drivers/media/platform/mtk-vcodec/vdec_vpu_if.c    |  164 +++++++
 drivers/media/platform/mtk-vcodec/vdec_vpu_if.h    |   60 +++
 6 files changed, 739 insertions(+), 9 deletions(-)
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
index 0000000..9762bbf
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/vdec/vdec_h264_if.c
@@ -0,0 +1,487 @@
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
+#include "mtk_vcodec_intr.h"
+#include "vdec_vpu_if.h"
+#include "vdec_drv_base.h"
+
+#define NON_IDR_SLICE				0x01
+#define IDR_SLICE				0x05
+#define H264_PPS				0x08
+
+#define BUF_PREDICTION_SZ			(32 * 1024)
+#define BUF_PP_SZ				(30 * 4096)
+#define BUF_LD_SZ				(15 * 4096)
+
+#define MB_UNIT_SZ				16
+#define HW_MB_STORE_SZ				64
+
+#define H264_MAX_FB_NUM				17
+#define HDR_PARSING_BUF_SZ			1024
+#define NAL_TYPE(value)				((value) & 0x1F)
+
+/**
+ * struct h264_fb - h264 decode frame buffer information
+ * @vdec_fb_va  : virtual address of struct vdec_fb
+ * @y_fb_dma    : dma address of Y frame buffer
+ * @c_fb_dma    : dma address of C frame buffer
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
+ *                        The memory is allocated by VPU and mapping to Host
+ *                        in vpu_dec_init()
+ * @hdr_buf     : Header parsing buffer
+ * @ppl_buf_dma : HW working buffer ppl dma address
+ * @mv_buf_dma  : HW working buffer mv dma address
+ * @list_free   : free frame buffer ring list
+ * @list_disp   : display frame buffer ring list
+ * @dec		: decode information
+ * @pic		: picture information
+ * @crop        : crop information
+ */
+struct vdec_h264_vsi {
+	unsigned char hdr_buf[HDR_PARSING_BUF_SZ];
+	uint64_t ppl_buf_dma;
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
+ * @ppl_buf  : HW working buffer for ppl
+ * @mv_buf   : HW working buffer for mv
+ * @vpu      : VPU instance
+ * @vsi      : VPU shared information
+ */
+struct vdec_h264_inst {
+	unsigned int num_nalu;
+	struct mtk_vcodec_ctx *ctx;
+	struct mtk_vcodec_mem ppl_buf;
+	struct mtk_vcodec_mem mv_buf[H264_MAX_FB_NUM];
+	struct vdec_vpu_inst vpu;
+	struct vdec_h264_vsi *vsi;
+};
+
+static unsigned int get_mv_buf_size(unsigned int width, unsigned int height)
+{
+	return HW_MB_STORE_SZ * (width/MB_UNIT_SZ) * (height/MB_UNIT_SZ);
+}
+
+static int alloc_mv_buf(struct vdec_h264_inst *inst, struct vdec_pic_info *pic)
+{
+	int i;
+	int err;
+	struct mtk_vcodec_mem *mem = NULL;
+	unsigned int buf_sz;
+
+	buf_sz = get_mv_buf_size(pic->buf_w, pic->buf_h);
+
+	for (i = 0; i < H264_MAX_FB_NUM; i++) {
+		mem = &inst->mv_buf[i];
+		if (mem->va)
+			mtk_vcodec_mem_free(inst->ctx, mem);
+		mem->size = buf_sz;
+		err = mtk_vcodec_mem_alloc(inst->ctx, mem);
+		if (err) {
+			mtk_vcodec_err(inst, "failed to allocate mv buf");
+			return -ENOMEM;
+		}
+		inst->vsi->mv_buf_dma[i] = mem->dma_addr;
+	}
+
+	return 0;
+}
+
+static void free_all_working_buf(struct vdec_h264_inst *inst)
+{
+	int i;
+	struct mtk_vcodec_mem *mem = NULL;
+
+	mtk_vcodec_debug_enter(inst);
+
+	inst->vsi->ppl_buf_dma = 0;
+	mem = &inst->ppl_buf;
+	if (mem->va)
+		mtk_vcodec_mem_free(inst->ctx, mem);
+
+	for (i = 0; i < H264_MAX_FB_NUM; i++) {
+		inst->vsi->mv_buf_dma[i] = 0;
+		mem = &inst->mv_buf[i];
+		if (mem->va)
+			mtk_vcodec_mem_free(inst->ctx, mem);
+	}
+}
+
+static int allocate_working_buf(struct vdec_h264_inst *inst)
+{
+	int err = 0;
+
+	inst->ppl_buf.size = BUF_PREDICTION_SZ + BUF_PP_SZ + BUF_LD_SZ;
+	err = mtk_vcodec_mem_alloc(inst->ctx, &inst->ppl_buf);
+	if (err) {
+		mtk_vcodec_err(inst, "failed to allocate ppl buf");
+		return -ENOMEM;
+	}
+
+	inst->vsi->ppl_buf_dma = inst->ppl_buf.dma_addr;
+	return 0;
+}
+
+static void put_fb_to_free(struct vdec_h264_inst *inst, struct vdec_fb *fb)
+{
+	struct h264_ring_fb_list *list;
+
+	if (fb) {
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
+	pic->pic_w = inst->vsi->pic.pic_w;
+	pic->pic_h = inst->vsi->pic.pic_h;
+	pic->buf_w = inst->vsi->pic.buf_w;
+	pic->buf_h = inst->vsi->pic.buf_h;
+	pic->y_bs_sz = inst->vsi->pic.y_bs_sz;
+	pic->c_bs_sz = inst->vsi->pic.c_bs_sz;
+	pic->y_len_sz = inst->vsi->pic.y_len_sz;
+	pic->c_len_sz = inst->vsi->pic.c_len_sz;
+
+	mtk_vcodec_debug(inst, "pic(%d, %d), buf(%d, %d)",
+			 pic->pic_w, pic->pic_h, pic->buf_w, pic->buf_h);
+	mtk_vcodec_debug(inst, "Y(%d, %d), C(%d, %d)", pic->y_bs_sz,
+			 pic->y_len_sz, pic->c_bs_sz, pic->c_len_sz);
+}
+
+static void get_crop_info(struct vdec_h264_inst *inst, struct v4l2_crop *cr)
+{
+	cr->c.left	= inst->vsi->crop.left;
+	cr->c.top	= inst->vsi->crop.top;
+	cr->c.width	= inst->vsi->crop.width;
+	cr->c.height	= inst->vsi->crop.height;
+	mtk_vcodec_debug(inst, "l=%d, t=%d, w=%d, h=%d",
+			 cr->c.left, cr->c.top, cr->c.width, cr->c.height);
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
+	err = allocate_working_buf(inst);
+	if (err)
+		goto error_free_inst;
+
+	mtk_vcodec_debug(inst, "H264 Instance >> %p", inst);
+
+	*h_vdec = (unsigned long)inst;
+	return 0;
+
+error_free_inst:
+	kfree(inst);
+
+	return err;
+}
+
+static int vdec_h264_deinit(unsigned long h_vdec)
+{
+	struct vdec_h264_inst *inst = (struct vdec_h264_inst *)h_vdec;
+
+	mtk_vcodec_debug_enter(inst);
+
+	vpu_dec_deinit(&inst->vpu);
+	free_all_working_buf(inst);
+
+	kfree(inst);
+	return 0;
+}
+
+static int find_start_code(unsigned char *data, unsigned int data_sz)
+{
+	if (data_sz >= 3 && data[0] == 0 && data[1] == 0 && data[2] == 1)
+		return 3;
+
+	if (data_sz >= 4 && data[0] == 0 && data[1] == 0 && data[2] == 0 &&
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
+	int idx = 0;
+	int err = 0;
+	unsigned int nal_start;
+	unsigned int nal_type;
+	unsigned char *buf;
+	unsigned int buf_sz;
+	unsigned int data[2];
+	uint64_t vdec_fb_va;
+	uint64_t y_fb_dma;
+	uint64_t c_fb_dma;
+
+	y_fb_dma = fb ? (u64)fb->base_y.dma_addr : 0;
+	c_fb_dma = fb ? (u64)fb->base_c.dma_addr : 0;
+
+	vdec_fb_va = (u64)fb;
+
+	mtk_vcodec_debug(inst, "+ [%d] FB y_dma=%llx c_dma=%llx va=%p",
+			 inst->num_nalu, y_fb_dma, c_fb_dma, fb);
+
+	/* bs NULL means flush decoder */
+	if (bs == NULL)
+		return vpu_dec_reset(vpu);
+
+	buf = (unsigned char *)bs->va;
+	buf_sz = bs->size;
+	idx = find_start_code(buf, buf_sz);
+	if (idx < 0)
+		goto err_free_fb_out;
+
+	nal_start = buf[idx];
+	nal_type = NAL_TYPE(buf[idx]);
+	mtk_vcodec_debug(inst, "\n + NALU[%d] type %d +\n", inst->num_nalu,
+			 nal_type);
+
+	if (nal_type == H264_PPS) {
+		if (buf_sz > HDR_PARSING_BUF_SZ) {
+			err = -EILSEQ;
+			goto err_free_fb_out;
+		}
+		buf_sz -= idx;
+		memcpy(inst->vsi->hdr_buf, buf + idx, buf_sz);
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
+	if (nal_type == NON_IDR_SLICE || nal_type == IDR_SLICE) {
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
+	inst->num_nalu++;
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
+	unsigned long vdec_fb_va;
+	struct vdec_fb *fb;
+
+	if (list->count == 0) {
+		mtk_vcodec_debug(inst, "[FB] there is no %s fb",
+				 disp_list ? "disp" : "free");
+		*out_fb = NULL;
+		return;
+	}
+
+	vdec_fb_va = (unsigned long)list->fb_list[list->read_idx].vdec_fb_va;
+	fb = (struct vdec_fb *)vdec_fb_va;
+	if (disp_list)
+		fb->status |= FB_ST_DISPLAY;
+	else
+		fb->status |= FB_ST_FREE;
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
+struct vdec_common_if *get_h264_dec_comm_if(void)
+{
+	return &vdec_h264_if;
+}
diff --git a/drivers/media/platform/mtk-vcodec/vdec_drv_if.c b/drivers/media/platform/mtk-vcodec/vdec_drv_if.c
index 1d12719..576920c 100644
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
diff --git a/drivers/media/platform/mtk-vcodec/vdec_ipi_msg.h b/drivers/media/platform/mtk-vcodec/vdec_ipi_msg.h
index 937192c..131928b 100644
--- a/drivers/media/platform/mtk-vcodec/vdec_ipi_msg.h
+++ b/drivers/media/platform/mtk-vcodec/vdec_ipi_msg.h
@@ -54,7 +54,7 @@ struct vdec_ap_ipi_cmd {
 struct vdec_vpu_ipi_ack {
 	uint32_t msg_id;
 	int32_t status;
-	uint64_t vdec_inst;
+	uint64_t ap_inst_addr;
 };
 
 /**
@@ -66,20 +66,34 @@ struct vdec_vpu_ipi_ack {
 struct vdec_ap_ipi_init {
 	uint32_t msg_id;
 	uint32_t reserved;
-	uint64_t vdec_inst;
+	uint64_t ap_inst_addr;
 };
 
 /**
- * struct vdec_vpu_ipi_init_ack - for VPU_IPIMSG_DEC_INIT_ACK
- * @msg_id        : VPU_IPIMSG_DEC_INIT_ACK
- * @status        : VPU exeuction result
- * @vdec_inst     : AP video decoder instance address
+ * struct vdec_ap_ipi_dec_start - for AP_IPIMSG_DEC_START
+ * @msg_id        : AP_IPIMSG_DEC_START
  * @vpu_inst_addr : VPU decoder instance address
+ * @data          : Header info
+ * @reserved      : Reserved field
+ */
+struct vdec_ap_ipi_dec_start {
+	uint32_t msg_id;
+	uint32_t vpu_inst_addr;
+	uint32_t data[3];
+	uint32_t reserved;
+};
+
+/**
+ * struct vdec_vpu_ipi_init_ack - for VPU_IPIMSG_DEC_INIT_ACK
+ * @msg_id		: VPU_IPIMSG_DEC_INIT_ACK
+ * @status		: VPU exeuction result
+ * @ap_inst_addr	: AP vcodec_vpu_inst instance address
+ * @vpu_inst_addr	: VPU decoder instance address
  */
 struct vdec_vpu_ipi_init_ack {
 	uint32_t msg_id;
 	int32_t status;
-	uint64_t vdec_inst;
+	uint64_t ap_inst_addr;
 	uint32_t vpu_inst_addr;
 };
 
diff --git a/drivers/media/platform/mtk-vcodec/vdec_vpu_if.c b/drivers/media/platform/mtk-vcodec/vdec_vpu_if.c
new file mode 100644
index 0000000..33b96db
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/vdec_vpu_if.c
@@ -0,0 +1,164 @@
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
+	vpu->vsi = vpu_mapping_dm_addr(vpu->dev, msg->vpu_inst_addr);
+	vpu->inst_addr = msg->vpu_inst_addr;
+
+	mtk_vcodec_debug(vpu, "- vpu_inst_addr = 0x%x", vpu->inst_addr);
+}
+
+/*
+ * This function runs in interrupt context and it means there's a IPI MSG
+ * from VPU.
+ */
+void vpu_dec_ipi_handler(void *data, unsigned int len, void *priv)
+{
+	struct vdec_vpu_ipi_ack *msg = data;
+	struct vdec_vpu_inst *vpu = (struct vdec_vpu_inst *)msg->ap_inst_addr;
+
+	mtk_vcodec_debug(vpu, "+ id=%X", msg->msg_id);
+
+	vpu->failure = msg->status;
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
+	vpu->signaled = 1;
+}
+
+static int vcodec_vpu_send_msg(struct vdec_vpu_inst *vpu, void *msg, int len)
+{
+	int err;
+
+	mtk_vcodec_debug(vpu, "id=%X", *(unsigned int *)msg);
+
+	vpu->failure = 0;
+	vpu->signaled = 0;
+
+	err = vpu_ipi_send(vpu->dev, vpu->id, msg, len);
+	if (err) {
+		mtk_vcodec_err(vpu, "vpu_ipi_send fail status=%d", err);
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
+	vpu->signaled = 0;
+	vpu->failure = 0;
+
+	err = vpu_ipi_register(vpu->dev, vpu->id, vpu->handler, NULL, NULL);
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
+int vpu_dec_start(struct vdec_vpu_inst *vpu, unsigned int *data,
+		  unsigned int length)
+{
+	struct vdec_ap_ipi_dec_start msg;
+	int i;
+	int err = 0;
+
+	mtk_vcodec_debug_enter(vpu);
+
+	memset(&msg, 0, sizeof(msg));
+	msg.msg_id = AP_IPIMSG_DEC_START;
+	msg.vpu_inst_addr = vpu->inst_addr;
+
+	for (i = 0; i < length; i++)
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
index 0000000..c16cd75
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/vdec_vpu_if.h
@@ -0,0 +1,60 @@
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
+ * @dev	        : platform device of VPU
+ * @inst_addr	: VPU decoder instance addr
+ * @signaled    : 1 - Host has received ack message from VPU, 0 - not recevie
+ * @failure     : VPU execution result status
+ * @wq          : Wait queue to wait VPU message ack
+ */
+struct vdec_vpu_inst {
+	enum ipi_id id;
+	void *vsi;
+	int failure;
+	unsigned int inst_addr;
+	unsigned int signaled;
+	struct mtk_vcodec_ctx *ctx;
+	struct platform_device *dev;
+	wait_queue_head_t wq;
+	ipi_handler_t handler;
+};
+
+/*
+ * Note these functions are not thread-safe for the same decoder instance.
+ * the reason is |signaled|. In vdec_vpu_wait_ack,
+ * wait_event_interruptible_timeout waits |signaled| to be 1.
+ * Suppose wait_event_interruptible_timeout returns and the execution has not
+ * reached line 127. If another thread calls vpu_dec_end,
+ * |signaled| will be 1 and wait_event_interruptible_timeout will return
+ *  immediately. We enusure thread-safe to add mtk_vdec_lock()/unlock() in
+ * vdec_drv_if.c
+ *
+ */
+
+int vpu_dec_init(struct vdec_vpu_inst *vpu);
+int vpu_dec_start(struct vdec_vpu_inst *vpu, unsigned int *data,
+		  unsigned int length);
+int vpu_dec_end(struct vdec_vpu_inst *vpu);
+int vpu_dec_deinit(struct vdec_vpu_inst *vpu);
+int vpu_dec_reset(struct vdec_vpu_inst *vpu);
+void vpu_dec_ipi_handler(void *data, unsigned int len, void *priv);
+
+#endif
-- 
1.7.9.5

