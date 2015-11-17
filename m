Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:53435 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753515AbbKQMzX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2015 07:55:23 -0500
From: Tiffany Lin <tiffany.lin@mediatek.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will.deacon@arm.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Hongzhou Yang <hongzhou.yang@mediatek.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
	Fabien Dessenne <fabien.dessenne@st.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Darren Etheridge <detheridge@ti.com>,
	Peter Griffin <peter.griffin@linaro.org>,
	Benoit Parrot <bparrot@ti.com>
CC: Tiffany Lin <tiffany.lin@mediatek.com>,
	Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
	Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	James Liao <jamesjj.liao@mediatek.com>,
	Daniel Hsiao <daniel.hsiao@mediatek.com>,
	<devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-media@vger.kernel.org>, <linux-mediatek@lists.infradead.org>
Subject: [RESEND RFC/PATCH 7/8] media: platform: mtk-vcodec: Add Mediatek VP8 Video Encoder Driver
Date: Tue, 17 Nov 2015 20:54:44 +0800
Message-ID: <1447764885-23100-8-git-send-email-tiffany.lin@mediatek.com>
In-Reply-To: <1447764885-23100-1-git-send-email-tiffany.lin@mediatek.com>
References: <1447764885-23100-1-git-send-email-tiffany.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Hsiao <daniel.hsiao@mediatek.com>

Signed-off-by: Daniel Hsiao <daniel.hsiao@mediatek.com>
---
 drivers/media/platform/mtk-vcodec/Makefile         |    2 +-
 drivers/media/platform/mtk-vcodec/common/Makefile  |    4 +-
 .../media/platform/mtk-vcodec/common/venc_drv_if.c |    6 +-
 drivers/media/platform/mtk-vcodec/vp8_enc/Makefile |    9 +
 .../platform/mtk-vcodec/vp8_enc/venc_vp8_if.c      |  371 ++++++++++++++++++++
 .../platform/mtk-vcodec/vp8_enc/venc_vp8_if.h      |   48 +++
 .../platform/mtk-vcodec/vp8_enc/venc_vp8_vpu.c     |  245 +++++++++++++
 7 files changed, 682 insertions(+), 3 deletions(-)
 create mode 100644 drivers/media/platform/mtk-vcodec/vp8_enc/Makefile
 create mode 100644 drivers/media/platform/mtk-vcodec/vp8_enc/venc_vp8_if.c
 create mode 100644 drivers/media/platform/mtk-vcodec/vp8_enc/venc_vp8_if.h
 create mode 100644 drivers/media/platform/mtk-vcodec/vp8_enc/venc_vp8_vpu.c

diff --git a/drivers/media/platform/mtk-vcodec/Makefile b/drivers/media/platform/mtk-vcodec/Makefile
index c7f7174..b881a8b 100644
--- a/drivers/media/platform/mtk-vcodec/Makefile
+++ b/drivers/media/platform/mtk-vcodec/Makefile
@@ -4,7 +4,7 @@ obj-$(CONFIG_VIDEO_MEDIATEK_VCODEC) += mtk_vcodec_intr.o \
 				       mtk_vcodec_enc.o \
 				       mtk_vcodec_enc_pm.o
 
-obj-$(CONFIG_VIDEO_MEDIATEK_VCODEC) += common/
+obj-$(CONFIG_VIDEO_MEDIATEK_VCODEC) += common/ vp8_enc/
 
 ccflags-y += -I$(srctree)/drivers/media/platform/mtk-vcodec/include \
 	     -I$(srctree)/drivers/media/platform/mtk-vcodec \
diff --git a/drivers/media/platform/mtk-vcodec/common/Makefile b/drivers/media/platform/mtk-vcodec/common/Makefile
index 477ab80..71ae856 100644
--- a/drivers/media/platform/mtk-vcodec/common/Makefile
+++ b/drivers/media/platform/mtk-vcodec/common/Makefile
@@ -5,4 +5,6 @@ ccflags-y += \
     -I$(srctree)/include/ \
     -I$(srctree)/drivers/media/platform/mtk-vcodec \
     -I$(srctree)/drivers/media/platform/mtk-vcodec/include \
-    -I$(srctree)/drivers/media/platform/mtk-vpu
\ No newline at end of file
+    -I$(srctree)/drivers/media/platform/mtk-vcodec/vp8_enc \
+    -I$(srctree)/drivers/media/platform/mtk-vpu \
+    -I$(srctree)/drivers/media/platform/mtk-vpu/vp8_enc
diff --git a/drivers/media/platform/mtk-vcodec/common/venc_drv_if.c b/drivers/media/platform/mtk-vcodec/common/venc_drv_if.c
index 9b3f025..e9be186 100644
--- a/drivers/media/platform/mtk-vcodec/common/venc_drv_if.c
+++ b/drivers/media/platform/mtk-vcodec/common/venc_drv_if.c
@@ -26,7 +26,7 @@
 
 #include "venc_drv_if.h"
 #include "venc_drv_base.h"
-
+#include "venc_vp8_if.h"
 
 int venc_if_create(void *ctx, unsigned int fourcc, unsigned long *handle)
 {
@@ -44,6 +44,10 @@ int venc_if_create(void *ctx, unsigned int fourcc, unsigned long *handle)
 	mtk_vcodec_debug(h, "fmt = %s handle = %p", str, h);
 
 	switch (fourcc) {
+	case V4L2_PIX_FMT_VP8:
+		h->enc_if = get_vp8_enc_comm_if();
+		break;
+	case V4L2_PIX_FMT_H264:
 	default:
 		mtk_vcodec_err(h, "invalid format %s", str);
 		goto err_out;
diff --git a/drivers/media/platform/mtk-vcodec/vp8_enc/Makefile b/drivers/media/platform/mtk-vcodec/vp8_enc/Makefile
new file mode 100644
index 0000000..ac78c33
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/vp8_enc/Makefile
@@ -0,0 +1,9 @@
+obj-$(CONFIG_VIDEO_MEDIATEK_VCODEC) += venc_vp8_if.o venc_vp8_vpu.o
+
+ccflags-y += \
+    -I$(srctree)/include/ \
+    -I$(srctree)/drivers/media/platform/mtk-vcodec/ \
+    -I$(srctree)/drivers/media/platform/mtk-vcodec/include \
+    -I$(srctree)/drivers/media/platform/mtk-vcodec/vp8_enc \
+    -I$(srctree)/drivers/media/platform/mtk-vpu/ \
+    -I$(srctree)/drivers/media/platform/mtk-vpu/vp8_enc
diff --git a/drivers/media/platform/mtk-vcodec/vp8_enc/venc_vp8_if.c b/drivers/media/platform/mtk-vcodec/vp8_enc/venc_vp8_if.c
new file mode 100644
index 0000000..cc6aaf4
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/vp8_enc/venc_vp8_if.c
@@ -0,0 +1,371 @@
+/*
+ * Copyright (c) 2015 MediaTek Inc.
+ * Author: Daniel Hsiao <daniel.hsiao@mediatek.com>
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
+#include <linux/time.h>
+
+#include "mtk_vcodec_drv.h"
+#include "mtk_vcodec_util.h"
+#include "mtk_vcodec_intr.h"
+#include "mtk_vcodec_enc.h"
+#include "mtk_vcodec_pm.h"
+#include "mtk_vpu_core.h"
+
+#include "venc_vp8_if.h"
+#include "venc_vp8_vpu.h"
+
+#define vp8_enc_write_reg(h, addr, val)	writel(val, h->hw_base + addr)
+#define vp8_enc_read_reg(h, addr) readl(h->hw_base + addr)
+
+#define VENC_PIC_BITSTREAM_BYTE_CNT 0x0098
+#define VENC_PIC_BITSTREAM_BYTE_CNT1 0x00e8
+#define VENC_IRQ_STATUS_ENC_FRM_INT 0x04
+
+#define MAX_AC_TAG_SZ 10
+
+static void vp8_enc_free_work_buf(struct venc_vp8_handle *hndl)
+{
+	int i;
+
+	mtk_vcodec_debug_enter(hndl);
+
+	/* Except the RC_CODEx buffers, other buffers need to be freed by AP. */
+	for (i = 0; i < VENC_VP8_VPU_WORK_BUF_RC_CODE; i++)
+		if (hndl->work_bufs[i].va != NULL)
+			mtk_vcodec_mem_free(hndl->ctx, &hndl->work_bufs[i]);
+
+	mtk_vcodec_debug_leave(hndl);
+}
+
+static int vp8_enc_alloc_work_buf(struct venc_vp8_handle *hndl)
+{
+	int i;
+	int ret = 0;
+	struct venc_vp8_vpu_buf *wb = hndl->vpu_inst.drv->work_bufs;
+
+	mtk_vcodec_debug_enter(hndl);
+	for (i = 0; i < VENC_VP8_VPU_WORK_BUF_MAX; i++) {
+		/*
+		 * Only temporal scalability mode will use RC_CODE2 & RC_CODE3
+		 * Each three temporal layer has its own rate control code.
+		 */
+		if ((i == VENC_VP8_VPU_WORK_BUF_RC_CODE2 ||
+		     i == VENC_VP8_VPU_WORK_BUF_RC_CODE3) && !hndl->ts_mode)
+			continue;
+
+		/*
+		 * This 'wb' structure is set by VPU side and shared to AP for
+		 * buffer allocation and physical addr mapping. For most of
+		 * the buffers, AP will allocate the buffer according to 'size'
+		 * field and store the physical addr in 'pa' field. For the
+		 * RC_CODEx buffers, they are pre-allocated in the VPU side
+		 * because they are inside VPU SRAM, and save the VPU addr in
+		 * the 'vpua' field. The AP will translate the VPU addr to the
+		 * corresponding physical addr and store in 'pa' field.
+		 */
+		if (i < VENC_VP8_VPU_WORK_BUF_RC_CODE) {
+			hndl->work_bufs[i].size = wb[i].size;
+			ret = mtk_vcodec_mem_alloc(hndl->ctx,
+						   &hndl->work_bufs[i]);
+			if (ret) {
+				mtk_vcodec_err(hndl,
+					       "cannot alloc work_bufs[%d]", i);
+				goto err_alloc;
+			}
+			wb[i].pa = hndl->work_bufs[i].dma_addr;
+
+			mtk_vcodec_debug(hndl,
+					 "work_bufs[%d] va=0x%p,pa=0x%p,size=0x%lx",
+					 i, hndl->work_bufs[i].va,
+					 (void *)hndl->work_bufs[i].dma_addr,
+					 hndl->work_bufs[i].size);
+		} else {
+			hndl->work_bufs[i].size = wb[i].size;
+			hndl->work_bufs[i].va =
+				vpu_mapping_dm_addr(hndl->dev,
+						    (uintptr_t *)
+						    (unsigned long)wb[i].vpua);
+			hndl->work_bufs[i].dma_addr =
+				(dma_addr_t)vpu_mapping_iommu_dm_addr(hndl->dev,
+					(uintptr_t *)(unsigned long)wb[i].vpua);
+			wb[i].pa = hndl->work_bufs[i].dma_addr;
+		}
+	}
+	mtk_vcodec_debug_leave(hndl);
+
+	return ret;
+
+err_alloc:
+	vp8_enc_free_work_buf(hndl);
+	return ret;
+}
+
+static unsigned int vp8_enc_wait_venc_done(struct venc_vp8_handle *hndl)
+{
+	struct mtk_vcodec_ctx *ctx = (struct mtk_vcodec_ctx *)hndl->ctx;
+	unsigned int irq_status;
+
+	mtk_vcodec_wait_for_done_ctx(ctx, MTK_INST_IRQ_RECEIVED, 1000, true);
+	irq_status = ctx->irq_status;
+	mtk_vcodec_debug(hndl, "isr return %x", irq_status);
+
+	return irq_status;
+}
+
+/*
+ * Compose ac_tag, bitstream header and bitstream payload into
+ * one bitstream buffer.
+ */
+static int vp8_enc_compose_one_frame(struct venc_vp8_handle *hndl,
+				     struct mtk_vcodec_mem *bs_buf,
+				     unsigned int *bs_size)
+{
+	unsigned int is_key;
+	u32 bs_size_frm;
+	u32 bs_hdr_len;
+	unsigned int ac_tag_sz;
+	u8 ac_tag[MAX_AC_TAG_SZ];
+
+	bs_size_frm = vp8_enc_read_reg(hndl,
+				       VENC_PIC_BITSTREAM_BYTE_CNT);
+	bs_hdr_len = vp8_enc_read_reg(hndl,
+				      VENC_PIC_BITSTREAM_BYTE_CNT1);
+
+	/* if a frame is key frame, is_key is 0 */
+	is_key = (hndl->frm_cnt %
+		  hndl->vpu_inst.drv->config.intra_period) ? 1 : 0;
+	*(u32 *)ac_tag = __cpu_to_le32((bs_hdr_len << 5) | 0x10 | is_key);
+	/* key frame */
+	if (is_key == 0) {
+		ac_tag[3] = 0x9d;
+		ac_tag[4] = 0x01;
+		ac_tag[5] = 0x2a;
+		ac_tag[6] = hndl->vpu_inst.drv->config.pic_w;
+		ac_tag[7] = hndl->vpu_inst.drv->config.pic_w >> 8;
+		ac_tag[8] = hndl->vpu_inst.drv->config.pic_h;
+		ac_tag[9] = hndl->vpu_inst.drv->config.pic_h >> 8;
+	}
+
+	if (is_key == 0)
+		ac_tag_sz = MAX_AC_TAG_SZ;
+	else
+		ac_tag_sz = 3;
+
+	if (bs_buf->size <= bs_hdr_len + bs_size_frm + ac_tag_sz) {
+		mtk_vcodec_err(hndl, "bitstream buf size is too small(%ld)",
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
+	       hndl->work_bufs[VENC_VP8_VPU_WORK_BUF_BS_HD].va,
+	       bs_hdr_len);
+	memcpy(bs_buf->va, ac_tag, ac_tag_sz);
+	*bs_size = bs_size_frm + bs_hdr_len + ac_tag_sz;
+
+	return 0;
+}
+
+static int vp8_enc_encode_frame(struct venc_vp8_handle *hndl,
+				struct venc_frm_buf *frm_buf,
+				struct mtk_vcodec_mem *bs_buf,
+				unsigned int *bs_size)
+{
+	int ret = 0;
+	unsigned int irq_status;
+
+	mtk_vcodec_debug(hndl, "->frm_cnt=%d", hndl->frm_cnt);
+
+	ret = vp8_enc_vpu_encode(hndl, frm_buf, bs_buf);
+
+	irq_status = vp8_enc_wait_venc_done(hndl);
+	if (irq_status != VENC_IRQ_STATUS_ENC_FRM_INT) {
+		mtk_vcodec_err(hndl, "irq_status=%d failed", irq_status);
+		return -EINVAL;
+	}
+
+	if (vp8_enc_compose_one_frame(hndl, bs_buf, bs_size)) {
+		mtk_vcodec_err(hndl, "vp8_enc_compose_one_frame failed");
+		return -EINVAL;
+	}
+
+	hndl->frm_cnt++;
+	mtk_vcodec_debug(hndl, "<-size=%d", *bs_size);
+
+	return ret;
+}
+
+int vp8_enc_init(struct mtk_vcodec_ctx *ctx, unsigned long *handle)
+{
+	int ret = 0;
+	struct venc_vp8_handle *h;
+
+	h = kzalloc(sizeof(*h), GFP_KERNEL);
+	if (!h)
+		return -ENOMEM;
+
+	h->ctx = ctx;
+	h->dev = mtk_vcodec_get_plat_dev(ctx);
+	h->hw_base = mtk_vcodec_get_reg_addr(h->ctx, VENC_LT_SYS);
+
+	ret = vp8_enc_vpu_init(h);
+	if (ret)
+		kfree(h);
+	else
+		(*handle) = (unsigned long)h;
+
+	return ret;
+}
+
+int vp8_enc_encode(unsigned long handle,
+		   enum venc_start_opt opt,
+		   struct venc_frm_buf *frm_buf,
+		   struct mtk_vcodec_mem *bs_buf,
+		   struct venc_done_result *result)
+{
+	int ret = 0;
+	struct venc_vp8_handle *h = (struct venc_vp8_handle *)handle;
+
+	mtk_vcodec_debug_enter(h);
+
+	switch (opt) {
+	case VENC_START_OPT_ENCODE_FRAME:
+		ret = vp8_enc_encode_frame(h, frm_buf, bs_buf,
+					   &result->bs_size);
+		if (ret) {
+			result->msg = VENC_MESSAGE_ERR;
+		} else {
+			result->msg = VENC_MESSAGE_OK;
+			result->is_key_frm = ((*((unsigned char *)bs_buf->va) &
+					       0x01) == 0);
+		}
+		break;
+
+	default:
+		mtk_vcodec_err(h, "opt not support:%d", opt);
+		ret = -EINVAL;
+		break;
+	}
+
+	mtk_vcodec_debug_leave(h);
+	return ret;
+}
+
+int vp8_enc_set_param(unsigned long handle,
+		      enum venc_set_param_type type, void *in)
+{
+	int ret = 0;
+	struct venc_vp8_handle *h = (struct venc_vp8_handle *)handle;
+	struct venc_enc_prm *enc_prm;
+
+	mtk_vcodec_debug(h, "->type=%d", type);
+
+	switch (type) {
+	case VENC_SET_PARAM_ENC:
+		enc_prm = in;
+		ret = vp8_enc_vpu_set_param(h, type, enc_prm);
+		if (ret)
+			break;
+		if (h->work_buf_allocated == 0) {
+			ret = vp8_enc_alloc_work_buf(h);
+			if (ret)
+				break;
+			h->work_buf_allocated = 1;
+		}
+		break;
+
+	case VENC_SET_PARAM_FORCE_INTRA:
+		ret = vp8_enc_vpu_set_param(h, type, 0);
+		if (ret)
+			break;
+		h->frm_cnt = 0;
+		break;
+
+	case VENC_SET_PARAM_ADJUST_BITRATE:
+		enc_prm = in;
+		ret = vp8_enc_vpu_set_param(h, type, &enc_prm->bitrate);
+		break;
+
+	case VENC_SET_PARAM_ADJUST_FRAMERATE:
+		enc_prm = in;
+		ret = vp8_enc_vpu_set_param(h, type, &enc_prm->frm_rate);
+		break;
+
+	case VENC_SET_PARAM_I_FRAME_INTERVAL:
+		ret = vp8_enc_vpu_set_param(h, type, in);
+		if (ret)
+			break;
+		h->frm_cnt = 0; /* reset counter */
+		break;
+
+	/*
+	 * VENC_SET_PARAM_TS_MODE must be called before
+	 * VENC_SET_PARAM_ENC
+	 */
+	case VENC_SET_PARAM_TS_MODE:
+		h->ts_mode = 1;
+		mtk_vcodec_debug(h, "set ts_mode");
+		break;
+
+	default:
+		mtk_vcodec_err(h, "type not support:%d", type);
+		ret = -EINVAL;
+		break;
+	}
+
+	mtk_vcodec_debug_leave(h);
+	return ret;
+}
+
+int vp8_enc_deinit(unsigned long handle)
+{
+	int ret = 0;
+	struct venc_vp8_handle *h = (struct venc_vp8_handle *)handle;
+
+	mtk_vcodec_debug_enter(h);
+
+	ret = vp8_enc_vpu_deinit(h);
+
+	if (h->work_buf_allocated)
+		vp8_enc_free_work_buf(h);
+
+	mtk_vcodec_debug_leave(h);
+	kfree(h);
+
+	return ret;
+}
+
+struct venc_common_if venc_vp8_if = {
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
index 0000000..57caf88
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/vp8_enc/venc_vp8_if.h
@@ -0,0 +1,48 @@
+/*
+ * Copyright (c) 2015 MediaTek Inc.
+ * Author: Daniel Hsiao <daniel.hsiao@mediatek.com>
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
+#include "venc_vp8_vpu.h"
+
+/*
+ * struct venc_vp8_handle - vp8 encoder AP driver handle
+ * @hw_base: vp8 encoder hardware register base
+ * @work_bufs: working buffer
+ * @work_buf_allocated: working buffer allocated flag
+ * @frm_cnt: encoded frame count, it's used for I-frame judgement and
+ *	     reset when force intra cmd received.
+ * @ts_mode: temporal scalability mode (0: disable, 1: enable)
+ *	     support three temporal layers - 0: 7.5fps 1: 7.5fps 2: 15fps.
+ * @vpu_inst: VPU instance to exchange information between AP and VPU
+ * @ctx: context for v4l2 layer integration
+ * @dev: device for v4l2 layer integration
+ */
+struct venc_vp8_handle {
+	void __iomem *hw_base;
+	struct mtk_vcodec_mem work_bufs[VENC_VP8_VPU_WORK_BUF_MAX];
+	bool work_buf_allocated;
+	unsigned int frm_cnt;
+	unsigned int ts_mode;
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
index 0000000..06a1ad3
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/vp8_enc/venc_vp8_vpu.c
@@ -0,0 +1,245 @@
+/*
+ * Copyright (c) 2015 MediaTek Inc.
+ * Author: Daniel Hsiao <daniel.hsiao@mediatek.com>
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
+#include "mtk_vpu_core.h"
+
+#include "venc_vp8_if.h"
+#include "venc_vp8_vpu.h"
+#include "venc_ipi_msg.h"
+
+static void handle_vp8_enc_init_msg(struct venc_vp8_handle *hndl, void *data)
+{
+	struct venc_vpu_ipi_msg_init *msg = data;
+
+	hndl->vpu_inst.id = msg->inst_id;
+	hndl->vpu_inst.drv = (struct venc_vp8_vpu_drv *)
+		vpu_mapping_dm_addr(hndl->dev,
+				    (uintptr_t *)((unsigned long)msg->inst_id));
+}
+
+static void vp8_enc_vpu_ipi_handler(void *data, unsigned int len, void *priv)
+{
+	struct venc_vpu_ipi_msg_common *msg = data;
+	struct venc_vp8_handle *hndl = (struct venc_vp8_handle *)msg->venc_inst;
+
+	mtk_vcodec_debug(hndl, "->msg_id=%x status=%d",
+			 msg->msg_id, msg->status);
+
+	switch (msg->msg_id) {
+	case VPU_IPIMSG_VP8_ENC_INIT_DONE:
+		handle_vp8_enc_init_msg(hndl, data);
+		break;
+	case VPU_IPIMSG_VP8_ENC_SET_PARAM_DONE:
+	case VPU_IPIMSG_VP8_ENC_ENCODE_DONE:
+	case VPU_IPIMSG_VP8_ENC_DEINIT_DONE:
+		break;
+	default:
+		mtk_vcodec_err(hndl, "unknown msg id=%x", msg->msg_id);
+		break;
+	}
+
+	hndl->vpu_inst.signaled = 1;
+	hndl->vpu_inst.failure = (msg->status != VENC_IPI_MSG_STATUS_OK);
+	wake_up_interruptible(&hndl->vpu_inst.wq_hd);
+
+	mtk_vcodec_debug_leave(hndl);
+}
+
+static int vp8_enc_vpu_wait_ack(struct venc_vp8_handle *hndl,
+				unsigned int timeout_ms)
+{
+	int ret;
+
+	mtk_vcodec_debug_enter(hndl);
+	ret = wait_event_interruptible_timeout(hndl->vpu_inst.wq_hd,
+					       (hndl->vpu_inst.signaled == 1),
+					       msecs_to_jiffies(timeout_ms));
+	if (0 == ret) {
+		mtk_vcodec_err(hndl, "wait vpu ack time out");
+		return -EINVAL;
+	}
+	if (-ERESTARTSYS == ret) {
+		mtk_vcodec_err(hndl, "wait vpu ack interrupted by a signal");
+		return -EINVAL;
+	}
+
+	hndl->vpu_inst.signaled = 0;
+
+	mtk_vcodec_debug_leave(hndl);
+	return 0;
+}
+
+static int vp8_enc_vpu_send_msg(struct venc_vp8_handle *hndl, void *msg,
+				int len, int wait_ack)
+{
+	int status;
+
+	mtk_vcodec_debug_enter(hndl);
+	status = vpu_ipi_send(hndl->dev, IPI_VENC_VP8, (void *)msg, len, 1);
+	if (status) {
+		mtk_vcodec_err(hndl,
+			       "vpu_ipi_send msg_id=%x len=%d failed status=%d",
+			       *(unsigned int *)msg, len, status);
+		return -EINVAL;
+	}
+
+	if (wait_ack && vp8_enc_vpu_wait_ack(hndl, 2000)) {
+		mtk_vcodec_err(hndl, "vp8_enc_vpu_wait_ack failed");
+		return -EINVAL;
+	}
+
+	mtk_vcodec_debug_leave(hndl);
+	return 0;
+}
+
+int vp8_enc_vpu_init(void *handle)
+{
+	int status;
+	struct venc_vp8_handle *hndl = handle;
+	struct venc_ap_ipi_msg_init out;
+
+	mtk_vcodec_debug_enter(hndl);
+	init_waitqueue_head(&hndl->vpu_inst.wq_hd);
+	hndl->vpu_inst.signaled = 0;
+	hndl->vpu_inst.failure = 0;
+
+	status = vpu_ipi_register(hndl->dev, IPI_VENC_VP8,
+				  vp8_enc_vpu_ipi_handler,
+				  "vp8_enc", NULL);
+	if (status) {
+		mtk_vcodec_err(hndl,
+			       "vpu_ipi_register failed status=%d", status);
+		return -EINVAL;
+	}
+
+	out.msg_id = AP_IPIMSG_VP8_ENC_INIT;
+	out.venc_inst = (unsigned long)hndl;
+	if (vp8_enc_vpu_send_msg(hndl, &out, sizeof(out), 1) ||
+	    hndl->vpu_inst.failure) {
+		mtk_vcodec_err(hndl, "failed");
+		return -EINVAL;
+	}
+
+	mtk_vcodec_debug_leave(hndl);
+	return 0;
+}
+
+int vp8_enc_vpu_set_param(void *handle, unsigned int id,
+			  void *param)
+{
+	struct venc_vp8_handle *hndl = handle;
+	struct venc_ap_ipi_msg_set_param out;
+
+	mtk_vcodec_debug_enter(hndl);
+	out.msg_id = AP_IPIMSG_VP8_ENC_SET_PARAM;
+	out.inst_id = hndl->vpu_inst.id;
+	out.param_id = id;
+	switch (id) {
+	case VENC_SET_PARAM_ENC: {
+		struct venc_enc_prm *enc_param = (struct venc_enc_prm *)param;
+
+		hndl->vpu_inst.drv->config.input_fourcc = enc_param->input_fourcc;
+		hndl->vpu_inst.drv->config.bitrate = enc_param->bitrate;
+		hndl->vpu_inst.drv->config.pic_w = enc_param->width;
+		hndl->vpu_inst.drv->config.pic_h = enc_param->height;
+		hndl->vpu_inst.drv->config.buf_w = enc_param->buf_width;
+		hndl->vpu_inst.drv->config.buf_h = enc_param->buf_height;
+		hndl->vpu_inst.drv->config.intra_period =
+			enc_param->intra_period;
+		hndl->vpu_inst.drv->config.framerate = enc_param->frm_rate;
+		hndl->vpu_inst.drv->config.ts_mode = hndl->ts_mode;
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
+	if (vp8_enc_vpu_send_msg(hndl, &out, sizeof(out), 1) ||
+	    hndl->vpu_inst.failure) {
+		mtk_vcodec_err(hndl, "failed");
+		return -EINVAL;
+	}
+
+	mtk_vcodec_debug_leave(hndl);
+	return 0;
+}
+
+int vp8_enc_vpu_encode(void *handle,
+		       struct venc_frm_buf *frm_buf,
+		       struct mtk_vcodec_mem *bs_buf)
+{
+	struct venc_vp8_handle *hndl = handle;
+	struct venc_ap_ipi_msg_enc out;
+
+	mtk_vcodec_debug_enter(hndl);
+	out.msg_id = AP_IPIMSG_VP8_ENC_ENCODE;
+	out.inst_id = hndl->vpu_inst.id;
+	if (frm_buf) {
+		out.input_addr[0] = frm_buf->fb_addr.dma_addr;
+		out.input_addr[1] = frm_buf->fb_addr1.dma_addr;
+		out.input_addr[2] = frm_buf->fb_addr2.dma_addr;
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
+
+	if (vp8_enc_vpu_send_msg(hndl, &out, sizeof(out), 1) ||
+	    hndl->vpu_inst.failure) {
+		mtk_vcodec_err(hndl, "failed");
+		return -EINVAL;
+	}
+
+	mtk_vcodec_debug_leave(hndl);
+	return 0;
+}
+
+int vp8_enc_vpu_deinit(void *handle)
+{
+	struct venc_vp8_handle *hndl = handle;
+	struct venc_ap_ipi_msg_deinit out;
+
+	mtk_vcodec_debug_enter(hndl);
+	out.msg_id = AP_IPIMSG_VP8_ENC_DEINIT;
+	out.inst_id = hndl->vpu_inst.id;
+	if (vp8_enc_vpu_send_msg(hndl, &out, sizeof(out), 1) ||
+	    hndl->vpu_inst.failure) {
+		mtk_vcodec_err(hndl, "failed");
+		return -EINVAL;
+	}
+
+	mtk_vcodec_debug_leave(hndl);
+	return 0;
+}
-- 
1.7.9.5

