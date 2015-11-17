Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:53395 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753516AbbKQMzX (ORCPT
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
Subject: [RESEND RFC/PATCH 8/8] media: platform: mtk-vcodec: Add Mediatek H264 Video Encoder Driver
Date: Tue, 17 Nov 2015 20:54:45 +0800
Message-ID: <1447764885-23100-9-git-send-email-tiffany.lin@mediatek.com>
In-Reply-To: <1447764885-23100-1-git-send-email-tiffany.lin@mediatek.com>
References: <1447764885-23100-1-git-send-email-tiffany.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Daniel Hsiao <daniel.hsiao@mediatek.com>
---
 drivers/media/platform/mtk-vcodec/Makefile         |    2 +-
 drivers/media/platform/mtk-vcodec/common/Makefile  |    4 +-
 .../media/platform/mtk-vcodec/common/venc_drv_if.c |    3 +
 .../media/platform/mtk-vcodec/h264_enc/Makefile    |    9 +
 .../platform/mtk-vcodec/h264_enc/venc_h264_if.c    |  529 ++++++++++++++++++++
 .../platform/mtk-vcodec/h264_enc/venc_h264_if.h    |   53 ++
 .../platform/mtk-vcodec/h264_enc/venc_h264_vpu.c   |  341 +++++++++++++
 7 files changed, 939 insertions(+), 2 deletions(-)
 create mode 100644 drivers/media/platform/mtk-vcodec/h264_enc/Makefile
 create mode 100644 drivers/media/platform/mtk-vcodec/h264_enc/venc_h264_if.c
 create mode 100644 drivers/media/platform/mtk-vcodec/h264_enc/venc_h264_if.h
 create mode 100644 drivers/media/platform/mtk-vcodec/h264_enc/venc_h264_vpu.c

diff --git a/drivers/media/platform/mtk-vcodec/Makefile b/drivers/media/platform/mtk-vcodec/Makefile
index b881a8b..d2189f7 100644
--- a/drivers/media/platform/mtk-vcodec/Makefile
+++ b/drivers/media/platform/mtk-vcodec/Makefile
@@ -4,7 +4,7 @@ obj-$(CONFIG_VIDEO_MEDIATEK_VCODEC) += mtk_vcodec_intr.o \
 				       mtk_vcodec_enc.o \
 				       mtk_vcodec_enc_pm.o
 
-obj-$(CONFIG_VIDEO_MEDIATEK_VCODEC) += common/ vp8_enc/
+obj-$(CONFIG_VIDEO_MEDIATEK_VCODEC) += common/ vp8_enc/ h264_enc/
 
 ccflags-y += -I$(srctree)/drivers/media/platform/mtk-vcodec/include \
 	     -I$(srctree)/drivers/media/platform/mtk-vcodec \
diff --git a/drivers/media/platform/mtk-vcodec/common/Makefile b/drivers/media/platform/mtk-vcodec/common/Makefile
index 71ae856..b33d48d 100644
--- a/drivers/media/platform/mtk-vcodec/common/Makefile
+++ b/drivers/media/platform/mtk-vcodec/common/Makefile
@@ -6,5 +6,7 @@ ccflags-y += \
     -I$(srctree)/drivers/media/platform/mtk-vcodec \
     -I$(srctree)/drivers/media/platform/mtk-vcodec/include \
     -I$(srctree)/drivers/media/platform/mtk-vcodec/vp8_enc \
+    -I$(srctree)/drivers/media/platform/mtk-vcodec/h264_enc \
     -I$(srctree)/drivers/media/platform/mtk-vpu \
-    -I$(srctree)/drivers/media/platform/mtk-vpu/vp8_enc
+    -I$(srctree)/drivers/media/platform/mtk-vpu/vp8_enc \
+    -I$(srctree)/drivers/media/platform/mtk-vpu/h264_enc
diff --git a/drivers/media/platform/mtk-vcodec/common/venc_drv_if.c b/drivers/media/platform/mtk-vcodec/common/venc_drv_if.c
index e9be186..930254b 100644
--- a/drivers/media/platform/mtk-vcodec/common/venc_drv_if.c
+++ b/drivers/media/platform/mtk-vcodec/common/venc_drv_if.c
@@ -27,6 +27,7 @@
 #include "venc_drv_if.h"
 #include "venc_drv_base.h"
 #include "venc_vp8_if.h"
+#include "venc_h264_if.h"
 
 int venc_if_create(void *ctx, unsigned int fourcc, unsigned long *handle)
 {
@@ -48,6 +49,8 @@ int venc_if_create(void *ctx, unsigned int fourcc, unsigned long *handle)
 		h->enc_if = get_vp8_enc_comm_if();
 		break;
 	case V4L2_PIX_FMT_H264:
+		h->enc_if = get_h264_enc_comm_if();
+		break;
 	default:
 		mtk_vcodec_err(h, "invalid format %s", str);
 		goto err_out;
diff --git a/drivers/media/platform/mtk-vcodec/h264_enc/Makefile b/drivers/media/platform/mtk-vcodec/h264_enc/Makefile
new file mode 100644
index 0000000..6559908
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/h264_enc/Makefile
@@ -0,0 +1,9 @@
+obj-$(CONFIG_VIDEO_MEDIATEK_VCODEC) += venc_h264_if.o venc_h264_vpu.o
+
+ccflags-y += \
+    -I$(srctree)/include/ \
+    -I$(srctree)/drivers/media/platform/mtk-vcodec/ \
+    -I$(srctree)/drivers/media/platform/mtk-vcodec/include \
+    -I$(srctree)/drivers/media/platform/mtk-vcodec/h264_enc \
+    -I$(srctree)/drivers/media/platform/mtk-vpu \
+    -I$(srctree)/drivers/media/platform/mtk-vpu/h264_enc
diff --git a/drivers/media/platform/mtk-vcodec/h264_enc/venc_h264_if.c b/drivers/media/platform/mtk-vcodec/h264_enc/venc_h264_if.c
new file mode 100644
index 0000000..c880865
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/h264_enc/venc_h264_if.c
@@ -0,0 +1,529 @@
+/*
+ * Copyright (c) 2015 MediaTek Inc.
+ * Author: Jungchang Tsao <jungchang.tsao@mediatek.com>
+ *         Daniel Hsiao <daniel.hsiao@mediatek.com>
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
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/interrupt.h>
+
+#include "mtk_vcodec_drv.h"
+#include "mtk_vcodec_util.h"
+#include "mtk_vcodec_intr.h"
+#include "mtk_vcodec_enc.h"
+#include "mtk_vcodec_pm.h"
+#include "mtk_vpu_core.h"
+
+#include "venc_h264_if.h"
+#include "venc_h264_vpu.h"
+
+#define h264_write_reg(h, addr, val)	writel(val, h->hw_base + addr)
+#define h264_read_reg(h, addr) readl(h->hw_base + addr)
+
+#define VENC_PIC_BITSTREAM_BYTE_CNT 0x0098
+
+enum venc_h264_irq_status {
+	H264_IRQ_STATUS_ENC_SPS_INT = (1 << 0),
+	H264_IRQ_STATUS_ENC_PPS_INT = (1 << 1),
+	H264_IRQ_STATUS_ENC_FRM_INT = (1 << 2),
+};
+
+static int h264_enc_alloc_work_buf(struct venc_h264_handle *handle)
+{
+	int i, j;
+	int ret = 0;
+	struct venc_h264_vpu_buf *wb = handle->vpu_inst.drv->work_bufs;
+
+	mtk_vcodec_debug_enter(handle);
+
+	for (i = 0; i < VENC_H264_VPU_WORK_BUF_MAX; i++) {
+		/*
+		 * This 'wb' structure is set by VPU side and shared to AP for
+		 * buffer allocation and physical addr mapping. For most of
+		 * the buffers, AP will allocate the buffer according to 'size'
+		 * field and store the physical addr in 'pa' field. There are two
+		 * exceptions:
+		 * (1) RC_CODE buffer, it's pre-allocated in the VPU side, and
+		 * save the VPU addr in the 'vpua' field. The AP will translate
+		 * the VPU addr to the corresponding physical addr and store
+		 * in 'pa' field for reg setting in VPU side.
+		 * (2) SKIP_FRAME buffer, it's pre-allocated in the VPU side, and
+		 * save the VPU addr in the 'vpua' field. The AP will translate
+		 * the VPU addr to the corresponding AP side virtual address and
+		 * do some memcpy access to move to bitstream buffer assigned
+		 * by v4l2 layer.
+		 */
+		if (i == VENC_H264_VPU_WORK_BUF_RC_CODE) {
+			handle->work_bufs[i].size = wb[i].size;
+			handle->work_bufs[i].va = vpu_mapping_dm_addr(
+				handle->dev, (uintptr_t *)(unsigned long)
+				wb[i].vpua);
+			handle->work_bufs[i].dma_addr =
+				(dma_addr_t)vpu_mapping_iommu_dm_addr(
+				handle->dev, (uintptr_t *)(unsigned long)
+				wb[i].vpua);
+			wb[i].pa = handle->work_bufs[i].dma_addr;
+		} else if (i == VENC_H264_VPU_WORK_BUF_SKIP_FRAME) {
+			handle->work_bufs[i].size = wb[i].size;
+			handle->work_bufs[i].va = vpu_mapping_dm_addr(
+				handle->dev, (uintptr_t *)(unsigned long)
+				wb[i].vpua);
+			handle->work_bufs[i].dma_addr = 0;
+			wb[i].pa = handle->work_bufs[i].dma_addr;
+		} else {
+			handle->work_bufs[i].size = wb[i].size;
+			if (mtk_vcodec_mem_alloc(handle->ctx,
+						 &handle->work_bufs[i])) {
+				mtk_vcodec_err(handle, "cannot allocate buf %d", i);
+				ret = -ENOMEM;
+				goto err_alloc;
+			}
+			wb[i].pa = handle->work_bufs[i].dma_addr;
+		}
+		mtk_vcodec_debug(handle, "buf[%d] va=0x%p pa=0x%p size=0x%lx", i,
+				 handle->work_bufs[i].va,
+				 (void *)handle->work_bufs[i].dma_addr,
+				 handle->work_bufs[i].size);
+	}
+
+	/* the pps_buf is used by AP side only */
+	handle->pps_buf.size = 128;
+	if (mtk_vcodec_mem_alloc(handle->ctx,
+				 &handle->pps_buf)) {
+		mtk_vcodec_err(handle, "cannot allocate pps_buf");
+		ret = -ENOMEM;
+		goto err_alloc;
+	}
+	mtk_vcodec_debug_leave(handle);
+
+	return ret;
+
+err_alloc:
+	for (j = 0; j < i; j++) {
+		if ((j != VENC_H264_VPU_WORK_BUF_RC_CODE) &&
+		    (j != VENC_H264_VPU_WORK_BUF_SKIP_FRAME))
+			mtk_vcodec_mem_free(handle->ctx, &handle->work_bufs[j]);
+	}
+
+	return ret;
+}
+
+static void h264_enc_free_work_buf(struct venc_h264_handle *handle)
+{
+	int i;
+
+	mtk_vcodec_debug_enter(handle);
+	for (i = 0; i < VENC_H264_VPU_WORK_BUF_MAX; i++) {
+		if ((i != VENC_H264_VPU_WORK_BUF_RC_CODE) &&
+		    (i != VENC_H264_VPU_WORK_BUF_SKIP_FRAME))
+			mtk_vcodec_mem_free(handle->ctx, &handle->work_bufs[i]);
+	}
+	mtk_vcodec_mem_free(handle->ctx, &handle->pps_buf);
+	mtk_vcodec_debug_leave(handle);
+}
+
+static unsigned int h264_enc_wait_venc_done(struct venc_h264_handle *handle)
+{
+	unsigned int irq_status = 0;
+	struct mtk_vcodec_ctx *pctx = handle->ctx;
+
+	mtk_vcodec_debug_enter(handle);
+	mtk_vcodec_wait_for_done_ctx(pctx, MTK_INST_IRQ_RECEIVED, 1000, true);
+	irq_status = pctx->irq_status;
+	mtk_vcodec_debug(handle, "irq_status %x <-", irq_status);
+
+	return irq_status;
+}
+
+static int h264_encode_sps(struct venc_h264_handle *handle,
+			   struct mtk_vcodec_mem *bs_buf,
+			   unsigned int *bs_size)
+{
+	unsigned int irq_status;
+
+	mtk_vcodec_debug_enter(handle);
+
+	if (h264_enc_vpu_encode(handle, H264_BS_MODE_SPS, NULL,
+				bs_buf, bs_size)) {
+		mtk_vcodec_err(handle, "h264_enc_vpu_encode sps failed");
+		return -EINVAL;
+	}
+
+	irq_status = h264_enc_wait_venc_done(handle);
+	if (irq_status != H264_IRQ_STATUS_ENC_SPS_INT) {
+		mtk_vcodec_err(handle, "expect irq status %d",
+			       H264_IRQ_STATUS_ENC_SPS_INT);
+		return -EINVAL;
+	}
+
+	*bs_size = h264_read_reg(handle, VENC_PIC_BITSTREAM_BYTE_CNT);
+	mtk_vcodec_debug(handle, "bs size %d <-", *bs_size);
+
+	return 0;
+}
+
+static int h264_encode_pps(struct venc_h264_handle *handle,
+			   struct mtk_vcodec_mem *bs_buf,
+			   unsigned int *bs_size)
+{
+	unsigned int irq_status;
+
+	mtk_vcodec_debug_enter(handle);
+
+	if (h264_enc_vpu_encode(handle, H264_BS_MODE_PPS, NULL,
+				bs_buf, bs_size)) {
+		mtk_vcodec_err(handle, "h264_enc_vpu_encode pps failed");
+		return -EINVAL;
+	}
+
+	irq_status = h264_enc_wait_venc_done(handle);
+	if (irq_status != H264_IRQ_STATUS_ENC_PPS_INT) {
+		mtk_vcodec_err(handle, "expect irq status %d",
+			       H264_IRQ_STATUS_ENC_PPS_INT);
+		return -EINVAL;
+	}
+
+	*bs_size = h264_read_reg(handle, VENC_PIC_BITSTREAM_BYTE_CNT);
+	mtk_vcodec_debug(handle, "bs size %d <-", *bs_size);
+
+	return 0;
+}
+
+static int h264_encode_frame(struct venc_h264_handle *handle,
+			     struct venc_frm_buf *frm_buf,
+			     struct mtk_vcodec_mem *bs_buf,
+			     unsigned int *bs_size)
+{
+	unsigned int irq_status;
+
+	mtk_vcodec_debug_enter(handle);
+
+	if (h264_enc_vpu_encode(handle, H264_BS_MODE_FRAME, frm_buf,
+				bs_buf, bs_size)) {
+		mtk_vcodec_err(handle, "h264_enc_vpu_encode frame failed");
+		return -EINVAL;
+	}
+
+	/*
+	 * skip frame case: The skip frame buffer is composed by vpu side only,
+	 * it does not trigger the hw, so skip the wait interrupt operation.
+	 */
+	if (!handle->vpu_inst.wait_int) {
+		++handle->frm_cnt;
+		return 0;
+	}
+
+	irq_status = h264_enc_wait_venc_done(handle);
+	if (irq_status != H264_IRQ_STATUS_ENC_FRM_INT) {
+		mtk_vcodec_err(handle, "irq_status=%d failed", irq_status);
+		return -EINVAL;
+	}
+
+	*bs_size = h264_read_reg(handle,
+				 VENC_PIC_BITSTREAM_BYTE_CNT);
+	++handle->frm_cnt;
+	mtk_vcodec_debug(handle, "frm %d bs size %d key_frm %d <-",
+			 handle->frm_cnt,
+			 *bs_size, handle->is_key_frm);
+
+	return 0;
+}
+
+static void h264_encode_filler(struct venc_h264_handle *handle, void *buf, int size)
+{
+	unsigned char *p = buf;
+
+	*p++ = 0x0;
+	*p++ = 0x0;
+	*p++ = 0x0;
+	*p++ = 0x1;
+	*p++ = 0xc;
+	size -= 5;
+	while (size) {
+		*p++ = 0xff;
+		size -= 1;
+	}
+}
+
+int h264_enc_init(struct mtk_vcodec_ctx *ctx, unsigned long *handle)
+{
+	struct venc_h264_handle *h;
+
+	h = kzalloc(sizeof(*h), GFP_KERNEL);
+	if (!h)
+		return -ENOMEM;
+
+	h->ctx = ctx;
+	h->dev = mtk_vcodec_get_plat_dev(ctx);
+	h->hw_base = mtk_vcodec_get_reg_addr(h->ctx, VENC_SYS);
+
+	if (h264_enc_vpu_init(h)) {
+		mtk_vcodec_err(h, "h264_enc_init failed");
+		return -EINVAL;
+	}
+
+	(*handle) = (unsigned long)h;
+
+	return 0;
+}
+
+int h264_enc_encode(unsigned long handle,
+		    enum venc_start_opt opt,
+		    struct venc_frm_buf *frm_buf,
+		    struct mtk_vcodec_mem *bs_buf,
+		    struct venc_done_result *result)
+{
+	int ret = 0;
+	struct venc_h264_handle *h = (struct venc_h264_handle *)handle;
+
+	mtk_vcodec_debug(h, "opt %d ->", opt);
+
+	switch (opt) {
+	case VENC_START_OPT_ENCODE_SEQUENCE_HEADER: {
+		unsigned int bs_size_sps;
+		unsigned int bs_size_pps;
+
+		memset(bs_buf->va, 0x38, 20);
+		if (h264_encode_sps(h, bs_buf, &bs_size_sps)) {
+			mtk_vcodec_err(h, "h264_encode_sps failed");
+			ret = -EINVAL;
+			goto encode_err;
+		}
+		memset(h->pps_buf.va, 0x49, 20);
+
+		if (h264_encode_pps(h, &h->pps_buf, &bs_size_pps)) {
+			mtk_vcodec_err(h, "h264_encode_pps failed");
+			ret = -EINVAL;
+			goto encode_err;
+		}
+
+		memcpy(bs_buf->va + bs_size_sps,
+		       h->pps_buf.va,
+		       bs_size_pps);
+		result->bs_size = bs_size_sps + bs_size_pps;
+		result->is_key_frm = false;
+	}
+	break;
+
+	case VENC_START_OPT_ENCODE_FRAME:
+		if (h->prepend_hdr) {
+			int hdr_sz;
+			int hdr_sz_ext;
+			int bs_alignment = 128;
+			int filler_sz = 0;
+			struct mtk_vcodec_mem tmp_bs_buf;
+			unsigned int bs_size_sps;
+			unsigned int bs_size_pps;
+			unsigned int bs_size_frm;
+
+			mtk_vcodec_debug(h,
+					 "h264_encode_frame prepend SPS/PPS");
+			if (h264_encode_sps(h, bs_buf, &bs_size_sps)) {
+				mtk_vcodec_err(h,
+					       "h264_encode_sps failed");
+				ret = -EINVAL;
+				goto encode_err;
+			}
+
+			if (h264_encode_pps(h, &h->pps_buf, &bs_size_pps)) {
+				mtk_vcodec_err(h,
+					       "h264_encode_pps failed");
+				ret = -EINVAL;
+				goto encode_err;
+			}
+			memcpy(bs_buf->va + bs_size_sps,
+			       h->pps_buf.va,
+			       bs_size_pps);
+
+			hdr_sz = bs_size_sps + bs_size_pps;
+			hdr_sz_ext = (hdr_sz & (bs_alignment - 1));
+			if (hdr_sz_ext) {
+				filler_sz = bs_alignment - hdr_sz_ext;
+				if (hdr_sz_ext + 5 > bs_alignment)
+					filler_sz += bs_alignment;
+				h264_encode_filler(
+					h, bs_buf->va + hdr_sz,
+					filler_sz);
+			}
+
+			tmp_bs_buf.va = bs_buf->va + hdr_sz +
+				filler_sz;
+			tmp_bs_buf.dma_addr = bs_buf->dma_addr + hdr_sz +
+				filler_sz;
+			tmp_bs_buf.size = bs_buf->size -
+				(hdr_sz + filler_sz);
+
+			if (h264_encode_frame(h, frm_buf,
+					      &tmp_bs_buf,
+					      &bs_size_frm)) {
+				mtk_vcodec_err(h,
+					       "h264_encode_frame failed");
+				ret = -EINVAL;
+				goto encode_err;
+			}
+
+			result->bs_size = hdr_sz + filler_sz + bs_size_frm;
+			mtk_vcodec_debug(h,
+					 "hdr %d filler %d frame %d bs %d",
+					 hdr_sz, filler_sz, bs_size_frm,
+					 result->bs_size);
+
+			h->prepend_hdr = 0;
+		} else {
+			if (h264_encode_frame(h, frm_buf, bs_buf,
+					      &result->bs_size)) {
+				mtk_vcodec_err(h,
+					       "h264_encode_frame failed");
+				ret = -EINVAL;
+				goto encode_err;
+			}
+		}
+		result->is_key_frm = h->is_key_frm;
+		break;
+
+	default:
+		mtk_vcodec_err(h, "venc_start_opt %d not supported",
+			       opt);
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
+	mtk_vcodec_debug(h, "opt %d <-", opt);
+	return ret;
+}
+
+int h264_enc_set_param(unsigned long handle,
+		       enum venc_set_param_type type, void *in)
+{
+	int ret = 0;
+	struct venc_h264_handle *h = (struct venc_h264_handle *)handle;
+	struct venc_enc_prm *enc_prm;
+
+	mtk_vcodec_debug(h, "->type=%d", type);
+
+	switch (type) {
+	case VENC_SET_PARAM_ENC:
+		enc_prm = in;
+		if (h264_enc_vpu_set_param(h,
+					   VENC_SET_PARAM_ENC,
+					   enc_prm)) {
+			ret = -EINVAL;
+			break;
+		}
+		if (h->work_buf_alloc == 0) {
+			if (h264_enc_alloc_work_buf(h)) {
+				mtk_vcodec_err(h,
+					       "h264_enc_alloc_work_buf failed");
+				ret = -ENOMEM;
+			} else {
+				h->work_buf_alloc = 1;
+			}
+		}
+		break;
+
+	case VENC_SET_PARAM_FORCE_INTRA:
+		if (h264_enc_vpu_set_param(h,
+					   VENC_SET_PARAM_FORCE_INTRA, 0)) {
+			mtk_vcodec_err(h, "force intra failed");
+			ret = -EINVAL;
+		}
+		break;
+
+	case VENC_SET_PARAM_ADJUST_BITRATE:
+		enc_prm = in;
+		if (h264_enc_vpu_set_param(h, VENC_SET_PARAM_ADJUST_BITRATE,
+					   &enc_prm->bitrate)) {
+			mtk_vcodec_err(h, "adjust bitrate failed");
+			ret = -EINVAL;
+		}
+		break;
+
+	case VENC_SET_PARAM_ADJUST_FRAMERATE:
+		enc_prm = in;
+		if (h264_enc_vpu_set_param(h, VENC_SET_PARAM_ADJUST_FRAMERATE,
+					   &enc_prm->frm_rate)) {
+			mtk_vcodec_err(h, "adjust frame rate failed");
+			ret = -EINVAL;
+		}
+		break;
+
+	case VENC_SET_PARAM_I_FRAME_INTERVAL:
+		if (h264_enc_vpu_set_param(h,
+					   VENC_SET_PARAM_I_FRAME_INTERVAL,
+					   in)) {
+			mtk_vcodec_err(h, "set I frame interval failed");
+			ret = -EINVAL;
+		}
+		break;
+
+	case VENC_SET_PARAM_SKIP_FRAME:
+		if (h264_enc_vpu_set_param(h, VENC_SET_PARAM_SKIP_FRAME, 0)) {
+			mtk_vcodec_err(h, "skip frame failed");
+			ret = -EINVAL;
+		}
+		break;
+
+	case VENC_SET_PARAM_PREPEND_HEADER:
+		h->prepend_hdr = 1;
+		mtk_vcodec_debug(h, "set prepend header mode");
+		break;
+
+	default:
+		mtk_vcodec_err(h, "type %d not supported", type);
+		ret = -EINVAL;
+		break;
+	}
+
+	mtk_vcodec_debug_leave(h);
+	return ret;
+}
+
+int h264_enc_deinit(unsigned long handle)
+{
+	int ret = 0;
+	struct venc_h264_handle *h = (struct venc_h264_handle *)handle;
+
+	mtk_vcodec_debug_enter(h);
+
+	if (h264_enc_vpu_deinit(h)) {
+		mtk_vcodec_err(h, "h264_enc_vpu_deinit failed");
+		ret = -EINVAL;
+	}
+
+	if (h->work_buf_alloc)
+		h264_enc_free_work_buf(h);
+
+	mtk_vcodec_debug_leave(h);
+	kfree(h);
+
+	return ret;
+}
+
+struct venc_common_if venc_h264_if = {
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
index 0000000..4deb7d4
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/h264_enc/venc_h264_if.h
@@ -0,0 +1,53 @@
+/*
+ * Copyright (c) 2015 MediaTek Inc.
+ * Author: Jungchang Tsao <jungchang.tsao@mediatek.com>
+ *         Daniel Hsiao <daniel.hsiao@mediatek.com>
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
+#include "venc_h264_vpu.h"
+
+/*
+ * struct venc_h264_handle - h264 encoder AP driver handle
+ * @hw_base: h264 encoder hardware register base
+ * @work_bufs: working buffer
+ * @pps_buf: buffer to store the pps bitstream
+ * @work_buf_alloc: working buffer allocated flag
+ * @frm_cnt: encoded frame count
+ * @prepend_hdr: when the v4l2 layer send VENC_SET_PARAM_PREPEND_HEADER cmd
+ *  through h264_enc_set_param interface, it will set this flag and prepend the
+ *  sps/pps in h264_enc_encode function.
+ * @is_key_frm: key frame flag
+ * @vpu_inst: VPU instance to exchange information between AP and VPU
+ * @ctx: context for v4l2 layer integration
+ * @dev: device for v4l2 layer integration
+ */
+struct venc_h264_handle {
+	void __iomem *hw_base;
+	struct mtk_vcodec_mem work_bufs[VENC_H264_VPU_WORK_BUF_MAX];
+	struct mtk_vcodec_mem pps_buf;
+	unsigned int work_buf_alloc;
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
index 0000000..5715971
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/h264_enc/venc_h264_vpu.c
@@ -0,0 +1,341 @@
+/*
+ * Copyright (c) 2015 MediaTek Inc.
+ * Author: Jungchang Tsao <jungchang.tsao@mediatek.com>
+ *         Daniel Hsiao <daniel.hsiao@mediatek.com>
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
+#include "venc_h264_if.h"
+#include "venc_h264_vpu.h"
+#include "venc_ipi_msg.h"
+
+static unsigned int h264_get_profile(unsigned int profile)
+{
+	/* (Baseline=66, Main=77, High=100) */
+	switch (profile) {
+	case V4L2_MPEG_VIDEO_H264_PROFILE_BASELINE:
+		return 66;
+	case V4L2_MPEG_VIDEO_H264_PROFILE_MAIN:
+		return 77;
+	case V4L2_MPEG_VIDEO_H264_PROFILE_HIGH:
+		return 100;
+	default:
+		return 100;
+	}
+}
+
+static unsigned int h264_get_level(unsigned int level)
+{
+	/* (UpTo4.1(HighProfile)) */
+	switch (level) {
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
+		return 31;
+	}
+}
+
+static void handle_h264_enc_init_msg(struct venc_h264_handle *hndl, void *data)
+{
+	struct venc_vpu_ipi_msg_init *msg = data;
+
+	hndl->vpu_inst.id = msg->inst_id;
+	hndl->vpu_inst.drv = (struct venc_h264_vpu_drv *)vpu_mapping_dm_addr(
+		hndl->dev, (uintptr_t *)(unsigned long)msg->inst_id);
+}
+
+static void handle_h264_enc_encode_msg(struct venc_h264_handle *hndl,
+				       void *data)
+{
+	struct venc_vpu_ipi_msg_enc *msg = data;
+
+	hndl->vpu_inst.state = msg->state;
+	hndl->vpu_inst.bs_size = msg->bs_size;
+	hndl->is_key_frm = msg->key_frame;
+}
+
+static void h264_enc_vpu_ipi_handler(void *data, unsigned int len, void *priv)
+{
+	struct venc_vpu_ipi_msg_common *msg = data;
+	struct venc_h264_handle *hndl = (struct venc_h264_handle *)msg->venc_inst;
+
+	mtk_vcodec_debug_enter(hndl);
+
+	mtk_vcodec_debug(hndl, "msg_id %x hndl %p status %d",
+			 msg->msg_id, hndl, msg->status);
+
+	switch (msg->msg_id) {
+	case VPU_IPIMSG_H264_ENC_INIT_DONE:
+		handle_h264_enc_init_msg(hndl, data);
+		break;
+	case VPU_IPIMSG_H264_ENC_SET_PARAM_DONE:
+		break;
+	case VPU_IPIMSG_H264_ENC_ENCODE_DONE:
+		handle_h264_enc_encode_msg(hndl, data);
+		break;
+	case VPU_IPIMSG_H264_ENC_DEINIT_DONE:
+		break;
+	default:
+		mtk_vcodec_err(hndl, "unknown msg id %x", msg->msg_id);
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
+static int h264_enc_vpu_wait_ack(struct venc_h264_handle *hndl,
+				 unsigned int timeout_ms)
+{
+	int ret;
+
+	mtk_vcodec_debug_enter(hndl);
+
+	ret = wait_event_interruptible_timeout(hndl->vpu_inst.wq_hd,
+					       hndl->vpu_inst.signaled == 1,
+					       msecs_to_jiffies(timeout_ms));
+	if (0 == ret) {
+		mtk_vcodec_err(hndl, "wait vpu ack time out !");
+		return -EINVAL;
+	}
+	if (-ERESTARTSYS == ret) {
+		mtk_vcodec_err(hndl,
+			       "wait vpu ack interrupted by a signal");
+		return -EINVAL;
+	}
+
+	hndl->vpu_inst.signaled = 0;
+
+	mtk_vcodec_debug_leave(hndl);
+	return 0;
+}
+
+static int h264_enc_vpu_send_msg(struct venc_h264_handle *hndl, void *msg,
+				 int len, int wait_ack)
+{
+	int status;
+
+	mtk_vcodec_debug_enter(hndl);
+
+	status = vpu_ipi_send(hndl->dev, IPI_VENC_H264, msg, len, 1);
+	if (status) {
+		mtk_vcodec_err(hndl, "vpu_ipi_send msg %x len %d fail %d",
+			       *(unsigned int *)msg, len, status);
+		return -EINVAL;
+	}
+	mtk_vcodec_debug(hndl, "vpu_ipi_send msg %x success",
+			 *(unsigned int *)msg);
+
+	if (wait_ack && h264_enc_vpu_wait_ack(hndl, 2000)) {
+		mtk_vcodec_err(hndl, "h264_enc_vpu_wait_ack failed");
+		return -EINVAL;
+	}
+
+	mtk_vcodec_debug_leave(hndl);
+	return 0;
+}
+
+int h264_enc_vpu_init(void *handle)
+{
+	int status;
+	struct venc_h264_handle *hndl = handle;
+	struct venc_ap_ipi_msg_init out;
+
+	mtk_vcodec_debug_enter(hndl);
+
+	init_waitqueue_head(&hndl->vpu_inst.wq_hd);
+	hndl->vpu_inst.signaled = 0;
+	hndl->vpu_inst.failure = 0;
+
+	status = vpu_ipi_register(hndl->dev, IPI_VENC_H264,
+				  h264_enc_vpu_ipi_handler,
+				  "h264_enc", NULL);
+	if (status) {
+		mtk_vcodec_err(hndl, "vpu_ipi_register fail %d", status);
+		return -EINVAL;
+	}
+	mtk_vcodec_debug(hndl, "vpu_ipi_register success");
+
+	out.msg_id = AP_IPIMSG_H264_ENC_INIT;
+	out.venc_inst = (unsigned long)hndl;
+	if (h264_enc_vpu_send_msg(hndl, &out, sizeof(out), 1) ||
+	    hndl->vpu_inst.failure) {
+		mtk_vcodec_err(hndl, "AP_IPIMSG_H264_ENC_INIT failed");
+		return -EINVAL;
+	}
+
+	mtk_vcodec_debug_leave(hndl);
+
+	return 0;
+}
+
+int h264_enc_vpu_set_param(void *handle, unsigned int id, void *param)
+{
+	struct venc_h264_handle *hndl = handle;
+	struct venc_ap_ipi_msg_set_param out;
+
+	mtk_vcodec_debug(hndl, "id %d ->", id);
+
+	out.msg_id = AP_IPIMSG_H264_ENC_SET_PARAM;
+	out.inst_id = hndl->vpu_inst.id;
+	out.param_id = id;
+	switch (id) {
+	case VENC_SET_PARAM_ENC: {
+		struct venc_enc_prm *enc_param = param;
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
+		hndl->vpu_inst.drv->config.profile =
+			h264_get_profile(enc_param->h264_profile);
+		hndl->vpu_inst.drv->config.level =
+			h264_get_level(enc_param->h264_level);
+		hndl->vpu_inst.drv->config.wfd = 0;
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
+	case VENC_SET_PARAM_SKIP_FRAME:
+		out.data_item = 0;
+		break;
+	}
+	if (h264_enc_vpu_send_msg(hndl, &out, sizeof(out), 1) ||
+	    hndl->vpu_inst.failure) {
+		mtk_vcodec_err(hndl,
+			       "AP_IPIMSG_H264_ENC_SET_PARAM %d fail", id);
+		return -EINVAL;
+	}
+
+	mtk_vcodec_debug(hndl, "id %d <-", id);
+
+	return 0;
+}
+
+int h264_enc_vpu_encode(void *handle, unsigned int bs_mode,
+			struct venc_frm_buf *frm_buf,
+			struct mtk_vcodec_mem *bs_buf,
+			unsigned int *bs_size)
+{
+	struct venc_h264_handle *hndl = handle;
+	struct venc_ap_ipi_msg_enc out;
+
+	mtk_vcodec_debug(hndl, "bs_mode %d ->", bs_mode);
+
+	out.msg_id = AP_IPIMSG_H264_ENC_ENCODE;
+	out.inst_id = hndl->vpu_inst.id;
+	out.bs_mode = bs_mode;
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
+	if (h264_enc_vpu_send_msg(hndl, &out, sizeof(out), 1) ||
+	    hndl->vpu_inst.failure) {
+		mtk_vcodec_err(hndl, "AP_IPIMSG_H264_ENC_ENCODE %d fail",
+			       bs_mode);
+		return -EINVAL;
+	}
+
+	mtk_vcodec_debug(hndl, "state %d size %d key_frm %d",
+			 hndl->vpu_inst.state, hndl->vpu_inst.bs_size,
+			 hndl->is_key_frm);
+	hndl->vpu_inst.wait_int = 1;
+	if (hndl->vpu_inst.state == VEN_IPI_MSG_ENC_STATE_SKIP) {
+		*bs_size = hndl->vpu_inst.bs_size;
+		memcpy(bs_buf->va,
+		       hndl->work_bufs[VENC_H264_VPU_WORK_BUF_SKIP_FRAME].va,
+		       *bs_size);
+		hndl->vpu_inst.wait_int = 0;
+	}
+
+	mtk_vcodec_debug(hndl, "bs_mode %d ->", bs_mode);
+
+	return 0;
+}
+
+int h264_enc_vpu_deinit(void *handle)
+{
+	struct venc_h264_handle *hndl = handle;
+	struct venc_ap_ipi_msg_deinit out;
+
+	mtk_vcodec_debug_enter(hndl);
+
+	out.msg_id = AP_IPIMSG_H264_ENC_DEINIT;
+	out.inst_id = hndl->vpu_inst.id;
+	if (h264_enc_vpu_send_msg(hndl, &out, sizeof(out), 1) ||
+	    hndl->vpu_inst.failure) {
+		mtk_vcodec_err(hndl, "AP_IPIMSG_H264_ENC_DEINIT fail");
+		return -EINVAL;
+	}
+
+	mtk_vcodec_debug_leave(hndl);
+
+	return 0;
+}
-- 
1.7.9.5

