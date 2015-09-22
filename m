Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:34967 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933738AbbIVNbE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2015 09:31:04 -0400
Received: from epcpsbgr4.samsung.com
 (u144.gpu120.samsung.co.kr [203.254.230.144])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NV202WA4YV4DC50@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 22 Sep 2015 22:30:40 +0900 (KST)
From: Junghak Sung <jh1009.sung@samsung.com>
To: linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, pawel@osciak.com
Cc: inki.dae@samsung.com, sw0312.kim@samsung.com,
	nenggun.kim@samsung.com, sangbae90.lee@samsung.com,
	rany.kwon@samsung.com, Junghak Sung <jh1009.sung@samsung.com>
Subject: [RFC PATCH v5 4/8] media: videobuf2: Restructure vb2_buffer (3/3)
Date: Tue, 22 Sep 2015 22:30:32 +0900
Message-id: <1442928636-3589-5-git-send-email-jh1009.sung@samsung.com>
In-reply-to: <1442928636-3589-1-git-send-email-jh1009.sung@samsung.com>
References: <1442928636-3589-1-git-send-email-jh1009.sung@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Modify all device drivers related with previous change that
restructures vb2_buffer for common use.

Signed-off-by: Junghak Sung <jh1009.sung@samsung.com>
Signed-off-by: Geunyoung Kim <nenggun.kim@samsung.com>
Acked-by: Seung-Woo Kim <sw0312.kim@samsung.com>
Acked-by: Inki Dae <inki.dae@samsung.com>
---
 drivers/media/platform/am437x/am437x-vpfe.c        |   35 +++---
 drivers/media/platform/am437x/am437x-vpfe.h        |    3 +-
 drivers/media/platform/blackfin/bfin_capture.c     |   34 +++--
 drivers/media/platform/coda/coda-bit.c             |  133 ++++++++++----------
 drivers/media/platform/coda/coda-common.c          |   21 ++--
 drivers/media/platform/coda/coda-jpeg.c            |    6 +-
 drivers/media/platform/coda/coda.h                 |    6 +-
 drivers/media/platform/coda/trace.h                |   16 +--
 drivers/media/platform/davinci/vpbe_display.c      |   31 +++--
 drivers/media/platform/davinci/vpif_capture.c      |   30 +++--
 drivers/media/platform/davinci/vpif_capture.h      |    2 +-
 drivers/media/platform/davinci/vpif_display.c      |   28 +++--
 drivers/media/platform/davinci/vpif_display.h      |    2 +-
 drivers/media/platform/exynos-gsc/gsc-core.h       |    2 +-
 drivers/media/platform/exynos-gsc/gsc-m2m.c        |   23 ++--
 drivers/media/platform/exynos4-is/fimc-capture.c   |   22 ++--
 drivers/media/platform/exynos4-is/fimc-core.h      |    2 +-
 drivers/media/platform/exynos4-is/fimc-isp-video.c |   13 +-
 drivers/media/platform/exynos4-is/fimc-isp.h       |    2 +-
 drivers/media/platform/exynos4-is/fimc-lite.c      |   15 +--
 drivers/media/platform/exynos4-is/fimc-lite.h      |    2 +-
 drivers/media/platform/exynos4-is/fimc-m2m.c       |   19 +--
 drivers/media/platform/m2m-deinterlace.c           |   23 ++--
 drivers/media/platform/marvell-ccic/mcam-core.c    |   43 ++++---
 drivers/media/platform/mx2_emmaprp.c               |   15 +--
 drivers/media/platform/omap3isp/ispvideo.c         |   25 ++--
 drivers/media/platform/omap3isp/ispvideo.h         |    2 +-
 drivers/media/platform/rcar_jpu.c                  |   59 +++++----
 drivers/media/platform/s3c-camif/camif-capture.c   |   15 +--
 drivers/media/platform/s3c-camif/camif-core.h      |    2 +-
 drivers/media/platform/s5p-g2d/g2d.c               |   15 +--
 drivers/media/platform/s5p-jpeg/jpeg-core.c        |   30 ++---
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |   78 ++++++------
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h    |    2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |   15 +--
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |   58 +++++----
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c    |   46 +++----
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c    |   33 ++---
 drivers/media/platform/s5p-tv/mixer.h              |    2 +-
 drivers/media/platform/s5p-tv/mixer_grp_layer.c    |    2 +-
 drivers/media/platform/s5p-tv/mixer_reg.c          |    2 +-
 drivers/media/platform/s5p-tv/mixer_video.c        |   11 +-
 drivers/media/platform/s5p-tv/mixer_vp_layer.c     |    5 +-
 drivers/media/platform/sh_veu.c                    |   19 +--
 drivers/media/platform/sh_vou.c                    |   26 ++--
 drivers/media/platform/soc_camera/atmel-isi.c      |   26 ++--
 drivers/media/platform/soc_camera/mx2_camera.c     |   19 +--
 drivers/media/platform/soc_camera/mx3_camera.c     |   27 ++--
 drivers/media/platform/soc_camera/rcar_vin.c       |   45 +++----
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |   57 +++++----
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c      |   23 ++--
 drivers/media/platform/ti-vpe/vpe.c                |   40 +++---
 drivers/media/platform/vim2m.c                     |   52 ++++----
 drivers/media/platform/vivid/vivid-core.h          |    2 +-
 drivers/media/platform/vivid/vivid-kthread-cap.c   |   73 ++++++-----
 drivers/media/platform/vivid/vivid-kthread-out.c   |   34 ++---
 drivers/media/platform/vivid/vivid-sdr-cap.c       |   44 ++++---
 drivers/media/platform/vivid/vivid-vbi-cap.c       |   45 ++++---
 drivers/media/platform/vivid/vivid-vbi-out.c       |   18 ++-
 drivers/media/platform/vivid/vivid-vid-cap.c       |   15 ++-
 drivers/media/platform/vivid/vivid-vid-out.c       |   15 ++-
 drivers/media/platform/vsp1/vsp1_rpf.c             |    4 +-
 drivers/media/platform/vsp1/vsp1_video.c           |   18 +--
 drivers/media/platform/vsp1/vsp1_video.h           |    6 +-
 drivers/media/platform/vsp1/vsp1_wpf.c             |    4 +-
 drivers/media/platform/xilinx/xilinx-dma.c         |   24 ++--
 66 files changed, 856 insertions(+), 710 deletions(-)

diff --git a/drivers/media/platform/am437x/am437x-vpfe.c b/drivers/media/platform/am437x/am437x-vpfe.c
index c8447fa..488d275 100644
--- a/drivers/media/platform/am437x/am437x-vpfe.c
+++ b/drivers/media/platform/am437x/am437x-vpfe.c
@@ -307,7 +307,8 @@ static inline struct vpfe_device *to_vpfe(struct vpfe_ccdc *ccdc)
 	return container_of(ccdc, struct vpfe_device, ccdc);
 }
 
-static inline struct vpfe_cap_buffer *to_vpfe_buffer(struct vb2_buffer *vb)
+static inline
+struct vpfe_cap_buffer *to_vpfe_buffer(struct vb2_v4l2_buffer *vb)
 {
 	return container_of(vb, struct vpfe_cap_buffer, vb);
 }
@@ -1257,14 +1258,14 @@ static inline void vpfe_schedule_next_buffer(struct vpfe_device *vpfe)
 	list_del(&vpfe->next_frm->list);
 
 	vpfe_set_sdr_addr(&vpfe->ccdc,
-		       vb2_dma_contig_plane_dma_addr(&vpfe->next_frm->vb, 0));
+	       vb2_dma_contig_plane_dma_addr(&vpfe->next_frm->vb.vb2_buf, 0));
 }
 
 static inline void vpfe_schedule_bottom_field(struct vpfe_device *vpfe)
 {
 	unsigned long addr;
 
-	addr = vb2_dma_contig_plane_dma_addr(&vpfe->next_frm->vb, 0) +
+	addr = vb2_dma_contig_plane_dma_addr(&vpfe->next_frm->vb.vb2_buf, 0) +
 					vpfe->field_off;
 
 	vpfe_set_sdr_addr(&vpfe->ccdc, addr);
@@ -1280,10 +1281,10 @@ static inline void vpfe_schedule_bottom_field(struct vpfe_device *vpfe)
  */
 static inline void vpfe_process_buffer_complete(struct vpfe_device *vpfe)
 {
-	v4l2_get_timestamp(&vpfe->cur_frm->vb.v4l2_buf.timestamp);
-	vpfe->cur_frm->vb.v4l2_buf.field = vpfe->fmt.fmt.pix.field;
-	vpfe->cur_frm->vb.v4l2_buf.sequence = vpfe->sequence++;
-	vb2_buffer_done(&vpfe->cur_frm->vb, VB2_BUF_STATE_DONE);
+	v4l2_get_timestamp(&vpfe->cur_frm->vb.timestamp);
+	vpfe->cur_frm->vb.field = vpfe->fmt.fmt.pix.field;
+	vpfe->cur_frm->vb.sequence = vpfe->sequence++;
+	vb2_buffer_done(&vpfe->cur_frm->vb.vb2_buf, VB2_BUF_STATE_DONE);
 	vpfe->cur_frm = vpfe->next_frm;
 }
 
@@ -1942,6 +1943,7 @@ static int vpfe_queue_setup(struct vb2_queue *vq,
  */
 static int vpfe_buffer_prepare(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vpfe_device *vpfe = vb2_get_drv_priv(vb->vb2_queue);
 
 	vb2_set_plane_payload(vb, 0, vpfe->fmt.fmt.pix.sizeimage);
@@ -1949,7 +1951,7 @@ static int vpfe_buffer_prepare(struct vb2_buffer *vb)
 	if (vb2_get_plane_payload(vb, 0) > vb2_plane_size(vb, 0))
 		return -EINVAL;
 
-	vb->v4l2_buf.field = vpfe->fmt.fmt.pix.field;
+	vbuf->field = vpfe->fmt.fmt.pix.field;
 
 	return 0;
 }
@@ -1960,8 +1962,9 @@ static int vpfe_buffer_prepare(struct vb2_buffer *vb)
  */
 static void vpfe_buffer_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vpfe_device *vpfe = vb2_get_drv_priv(vb->vb2_queue);
-	struct vpfe_cap_buffer *buf = to_vpfe_buffer(vb);
+	struct vpfe_cap_buffer *buf = to_vpfe_buffer(vbuf);
 	unsigned long flags = 0;
 
 	/* add the buffer to the DMA queue */
@@ -2006,7 +2009,7 @@ static int vpfe_start_streaming(struct vb2_queue *vq, unsigned int count)
 	list_del(&vpfe->cur_frm->list);
 	spin_unlock_irqrestore(&vpfe->dma_queue_lock, flags);
 
-	addr = vb2_dma_contig_plane_dma_addr(&vpfe->cur_frm->vb, 0);
+	addr = vb2_dma_contig_plane_dma_addr(&vpfe->cur_frm->vb.vb2_buf, 0);
 
 	vpfe_set_sdr_addr(&vpfe->ccdc, (unsigned long)(addr));
 
@@ -2023,7 +2026,7 @@ static int vpfe_start_streaming(struct vb2_queue *vq, unsigned int count)
 err:
 	list_for_each_entry_safe(buf, tmp, &vpfe->dma_queue, list) {
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_QUEUED);
 	}
 
 	return ret;
@@ -2055,13 +2058,14 @@ static void vpfe_stop_streaming(struct vb2_queue *vq)
 	/* release all active buffers */
 	spin_lock_irqsave(&vpfe->dma_queue_lock, flags);
 	if (vpfe->cur_frm == vpfe->next_frm) {
-		vb2_buffer_done(&vpfe->cur_frm->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&vpfe->cur_frm->vb.vb2_buf,
+				VB2_BUF_STATE_ERROR);
 	} else {
 		if (vpfe->cur_frm != NULL)
-			vb2_buffer_done(&vpfe->cur_frm->vb,
+			vb2_buffer_done(&vpfe->cur_frm->vb.vb2_buf,
 					VB2_BUF_STATE_ERROR);
 		if (vpfe->next_frm != NULL)
-			vb2_buffer_done(&vpfe->next_frm->vb,
+			vb2_buffer_done(&vpfe->next_frm->vb.vb2_buf,
 					VB2_BUF_STATE_ERROR);
 	}
 
@@ -2069,7 +2073,8 @@ static void vpfe_stop_streaming(struct vb2_queue *vq)
 		vpfe->next_frm = list_entry(vpfe->dma_queue.next,
 						struct vpfe_cap_buffer, list);
 		list_del(&vpfe->next_frm->list);
-		vb2_buffer_done(&vpfe->next_frm->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&vpfe->next_frm->vb.vb2_buf,
+				VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irqrestore(&vpfe->dma_queue_lock, flags);
 }
diff --git a/drivers/media/platform/am437x/am437x-vpfe.h b/drivers/media/platform/am437x/am437x-vpfe.h
index 5bfb356..777bf97 100644
--- a/drivers/media/platform/am437x/am437x-vpfe.h
+++ b/drivers/media/platform/am437x/am437x-vpfe.h
@@ -31,6 +31,7 @@
 #include <media/v4l2-dev.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
+#include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-dma-contig.h>
 
 #include "am437x-vpfe_regs.h"
@@ -104,7 +105,7 @@ struct vpfe_config {
 };
 
 struct vpfe_cap_buffer {
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head list;
 };
 
diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index b7e70fb..db059eb 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -54,7 +54,7 @@ struct bcap_format {
 };
 
 struct bcap_buffer {
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head list;
 };
 
@@ -149,7 +149,7 @@ static const struct bcap_format bcap_formats[] = {
 
 static irqreturn_t bcap_isr(int irq, void *dev_id);
 
-static struct bcap_buffer *to_bcap_vb(struct vb2_buffer *vb)
+static struct bcap_buffer *to_bcap_vb(struct vb2_v4l2_buffer *vb)
 {
 	return container_of(vb, struct bcap_buffer, vb);
 }
@@ -223,6 +223,7 @@ static int bcap_queue_setup(struct vb2_queue *vq,
 
 static int bcap_buffer_prepare(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct bcap_device *bcap_dev = vb2_get_drv_priv(vb->vb2_queue);
 	unsigned long size = bcap_dev->fmt.sizeimage;
 
@@ -233,15 +234,16 @@ static int bcap_buffer_prepare(struct vb2_buffer *vb)
 	}
 	vb2_set_plane_payload(vb, 0, size);
 
-	vb->v4l2_buf.field = bcap_dev->fmt.field;
+	vbuf->field = bcap_dev->fmt.field;
 
 	return 0;
 }
 
 static void bcap_buffer_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct bcap_device *bcap_dev = vb2_get_drv_priv(vb->vb2_queue);
-	struct bcap_buffer *buf = to_bcap_vb(vb);
+	struct bcap_buffer *buf = to_bcap_vb(vbuf);
 	unsigned long flags;
 
 	spin_lock_irqsave(&bcap_dev->lock, flags);
@@ -251,8 +253,9 @@ static void bcap_buffer_queue(struct vb2_buffer *vb)
 
 static void bcap_buffer_cleanup(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct bcap_device *bcap_dev = vb2_get_drv_priv(vb->vb2_queue);
-	struct bcap_buffer *buf = to_bcap_vb(vb);
+	struct bcap_buffer *buf = to_bcap_vb(vbuf);
 	unsigned long flags;
 
 	spin_lock_irqsave(&bcap_dev->lock, flags);
@@ -333,7 +336,8 @@ static int bcap_start_streaming(struct vb2_queue *vq, unsigned int count)
 					struct bcap_buffer, list);
 	/* remove buffer from the dma queue */
 	list_del_init(&bcap_dev->cur_frm->list);
-	addr = vb2_dma_contig_plane_dma_addr(&bcap_dev->cur_frm->vb, 0);
+	addr = vb2_dma_contig_plane_dma_addr(&bcap_dev->cur_frm->vb.vb2_buf,
+						0);
 	/* update DMA address */
 	ppi->ops->update_addr(ppi, (unsigned long)addr);
 	/* enable ppi */
@@ -344,7 +348,7 @@ static int bcap_start_streaming(struct vb2_queue *vq, unsigned int count)
 err:
 	list_for_each_entry_safe(buf, tmp, &bcap_dev->dma_queue, list) {
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_QUEUED);
 	}
 
 	return ret;
@@ -367,13 +371,15 @@ static void bcap_stop_streaming(struct vb2_queue *vq)
 
 	/* release all active buffers */
 	if (bcap_dev->cur_frm)
-		vb2_buffer_done(&bcap_dev->cur_frm->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&bcap_dev->cur_frm->vb.vb2_buf,
+				VB2_BUF_STATE_ERROR);
 
 	while (!list_empty(&bcap_dev->dma_queue)) {
 		bcap_dev->cur_frm = list_entry(bcap_dev->dma_queue.next,
 						struct bcap_buffer, list);
 		list_del_init(&bcap_dev->cur_frm->list);
-		vb2_buffer_done(&bcap_dev->cur_frm->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&bcap_dev->cur_frm->vb.vb2_buf,
+				VB2_BUF_STATE_ERROR);
 	}
 }
 
@@ -392,18 +398,19 @@ static irqreturn_t bcap_isr(int irq, void *dev_id)
 {
 	struct ppi_if *ppi = dev_id;
 	struct bcap_device *bcap_dev = ppi->priv;
-	struct vb2_buffer *vb = &bcap_dev->cur_frm->vb;
+	struct vb2_v4l2_buffer *vbuf = &bcap_dev->cur_frm->vb;
+	struct vb2_buffer *vb = &vbuf->vb2_buf;
 	dma_addr_t addr;
 
 	spin_lock(&bcap_dev->lock);
 
 	if (!list_empty(&bcap_dev->dma_queue)) {
-		v4l2_get_timestamp(&vb->v4l2_buf.timestamp);
+		v4l2_get_timestamp(&vbuf->timestamp);
 		if (ppi->err) {
 			vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
 			ppi->err = false;
 		} else {
-			vb->v4l2_buf.sequence = bcap_dev->sequence++;
+			vbuf->sequence = bcap_dev->sequence++;
 			vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
 		}
 		bcap_dev->cur_frm = list_entry(bcap_dev->dma_queue.next,
@@ -420,7 +427,8 @@ static irqreturn_t bcap_isr(int irq, void *dev_id)
 	if (bcap_dev->stop) {
 		complete(&bcap_dev->comp);
 	} else {
-		addr = vb2_dma_contig_plane_dma_addr(&bcap_dev->cur_frm->vb, 0);
+		addr = vb2_dma_contig_plane_dma_addr(
+				&bcap_dev->cur_frm->vb.vb2_buf, 0);
 		ppi->ops->update_addr(ppi, (unsigned long)addr);
 		ppi->ops->start(ppi);
 	}
diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index cd41d49..654e964 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -179,31 +179,32 @@ static void coda_kfifo_sync_to_device_write(struct coda_ctx *ctx)
 }
 
 static int coda_bitstream_queue(struct coda_ctx *ctx,
-				struct vb2_buffer *src_buf)
+				struct vb2_v4l2_buffer *src_buf)
 {
-	u32 src_size = vb2_get_plane_payload(src_buf, 0);
+	u32 src_size = vb2_get_plane_payload(&src_buf->vb2_buf, 0);
 	u32 n;
 
-	n = kfifo_in(&ctx->bitstream_fifo, vb2_plane_vaddr(src_buf, 0),
-		     src_size);
+	n = kfifo_in(&ctx->bitstream_fifo,
+			vb2_plane_vaddr(&src_buf->vb2_buf, 0), src_size);
 	if (n < src_size)
 		return -ENOSPC;
 
-	src_buf->v4l2_buf.sequence = ctx->qsequence++;
+	src_buf->sequence = ctx->qsequence++;
 
 	return 0;
 }
 
 static bool coda_bitstream_try_queue(struct coda_ctx *ctx,
-				     struct vb2_buffer *src_buf)
+				     struct vb2_v4l2_buffer *src_buf)
 {
 	int ret;
 
 	if (coda_get_bitstream_payload(ctx) +
-	    vb2_get_plane_payload(src_buf, 0) + 512 >= ctx->bitstream.size)
+	    vb2_get_plane_payload(&src_buf->vb2_buf, 0) + 512 >=
+	    ctx->bitstream.size)
 		return false;
 
-	if (vb2_plane_vaddr(src_buf, 0) == NULL) {
+	if (vb2_plane_vaddr(&src_buf->vb2_buf, 0) == NULL) {
 		v4l2_err(&ctx->dev->v4l2_dev, "trying to queue empty buffer\n");
 		return true;
 	}
@@ -224,7 +225,7 @@ static bool coda_bitstream_try_queue(struct coda_ctx *ctx,
 
 void coda_fill_bitstream(struct coda_ctx *ctx, bool streaming)
 {
-	struct vb2_buffer *src_buf;
+	struct vb2_v4l2_buffer *src_buf;
 	struct coda_buffer_meta *meta;
 	unsigned long flags;
 	u32 start;
@@ -257,7 +258,7 @@ void coda_fill_bitstream(struct coda_ctx *ctx, bool streaming)
 		}
 
 		/* Dump empty buffers */
-		if (!vb2_get_plane_payload(src_buf, 0)) {
+		if (!vb2_get_plane_payload(&src_buf->vb2_buf, 0)) {
 			src_buf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
 			v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_DONE);
 			continue;
@@ -276,9 +277,9 @@ void coda_fill_bitstream(struct coda_ctx *ctx, bool streaming)
 
 			meta = kmalloc(sizeof(*meta), GFP_KERNEL);
 			if (meta) {
-				meta->sequence = src_buf->v4l2_buf.sequence;
-				meta->timecode = src_buf->v4l2_buf.timecode;
-				meta->timestamp = src_buf->v4l2_buf.timestamp;
+				meta->sequence = src_buf->sequence;
+				meta->timecode = src_buf->timecode;
+				meta->timestamp = src_buf->timestamp;
 				meta->start = start;
 				meta->end = ctx->bitstream_fifo.kfifo.in &
 					    ctx->bitstream_fifo.kfifo.mask;
@@ -483,20 +484,21 @@ err:
 	return ret;
 }
 
-static int coda_encode_header(struct coda_ctx *ctx, struct vb2_buffer *buf,
+static int coda_encode_header(struct coda_ctx *ctx, struct vb2_v4l2_buffer *buf,
 			      int header_code, u8 *header, int *size)
 {
+	struct vb2_buffer *vb = &buf->vb2_buf;
 	struct coda_dev *dev = ctx->dev;
 	size_t bufsize;
 	int ret;
 	int i;
 
 	if (dev->devtype->product == CODA_960)
-		memset(vb2_plane_vaddr(buf, 0), 0, 64);
+		memset(vb2_plane_vaddr(vb, 0), 0, 64);
 
-	coda_write(dev, vb2_dma_contig_plane_dma_addr(buf, 0),
+	coda_write(dev, vb2_dma_contig_plane_dma_addr(vb, 0),
 		   CODA_CMD_ENC_HEADER_BB_START);
-	bufsize = vb2_plane_size(buf, 0);
+	bufsize = vb2_plane_size(vb, 0);
 	if (dev->devtype->product == CODA_960)
 		bufsize /= 1024;
 	coda_write(dev, bufsize, CODA_CMD_ENC_HEADER_BB_SIZE);
@@ -509,14 +511,14 @@ static int coda_encode_header(struct coda_ctx *ctx, struct vb2_buffer *buf,
 
 	if (dev->devtype->product == CODA_960) {
 		for (i = 63; i > 0; i--)
-			if (((char *)vb2_plane_vaddr(buf, 0))[i] != 0)
+			if (((char *)vb2_plane_vaddr(vb, 0))[i] != 0)
 				break;
 		*size = i + 1;
 	} else {
 		*size = coda_read(dev, CODA_REG_BIT_WR_PTR(ctx->reg_idx)) -
 			coda_read(dev, CODA_CMD_ENC_HEADER_BB_START);
 	}
-	memcpy(header, vb2_plane_vaddr(buf, 0), *size);
+	memcpy(header, vb2_plane_vaddr(vb, 0), *size);
 
 	return 0;
 }
@@ -799,7 +801,7 @@ static int coda_start_encoding(struct coda_ctx *ctx)
 	struct v4l2_device *v4l2_dev = &dev->v4l2_dev;
 	struct coda_q_data *q_data_src, *q_data_dst;
 	u32 bitstream_buf, bitstream_size;
-	struct vb2_buffer *buf;
+	struct vb2_v4l2_buffer *buf;
 	int gamma, ret, value;
 	u32 dst_fourcc;
 	int num_fb;
@@ -810,7 +812,7 @@ static int coda_start_encoding(struct coda_ctx *ctx)
 	dst_fourcc = q_data_dst->fourcc;
 
 	buf = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
-	bitstream_buf = vb2_dma_contig_plane_dma_addr(buf, 0);
+	bitstream_buf = vb2_dma_contig_plane_dma_addr(&buf->vb2_buf, 0);
 	bitstream_size = q_data_dst->sizeimage;
 
 	if (!coda_is_initialized(dev)) {
@@ -1185,7 +1187,7 @@ out:
 static int coda_prepare_encode(struct coda_ctx *ctx)
 {
 	struct coda_q_data *q_data_src, *q_data_dst;
-	struct vb2_buffer *src_buf, *dst_buf;
+	struct vb2_v4l2_buffer *src_buf, *dst_buf;
 	struct coda_dev *dev = ctx->dev;
 	int force_ipicture;
 	int quant_param = 0;
@@ -1200,8 +1202,8 @@ static int coda_prepare_encode(struct coda_ctx *ctx)
 	q_data_dst = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
 	dst_fourcc = q_data_dst->fourcc;
 
-	src_buf->v4l2_buf.sequence = ctx->osequence;
-	dst_buf->v4l2_buf.sequence = ctx->osequence;
+	src_buf->sequence = ctx->osequence;
+	dst_buf->sequence = ctx->osequence;
 	ctx->osequence++;
 
 	/*
@@ -1209,12 +1211,12 @@ static int coda_prepare_encode(struct coda_ctx *ctx)
 	 * frame as IDR. This is a problem for some decoders that can't
 	 * recover when a frame is lost.
 	 */
-	if (src_buf->v4l2_buf.sequence % ctx->params.gop_size) {
-		src_buf->v4l2_buf.flags |= V4L2_BUF_FLAG_PFRAME;
-		src_buf->v4l2_buf.flags &= ~V4L2_BUF_FLAG_KEYFRAME;
+	if (src_buf->sequence % ctx->params.gop_size) {
+		src_buf->flags |= V4L2_BUF_FLAG_PFRAME;
+		src_buf->flags &= ~V4L2_BUF_FLAG_KEYFRAME;
 	} else {
-		src_buf->v4l2_buf.flags |= V4L2_BUF_FLAG_KEYFRAME;
-		src_buf->v4l2_buf.flags &= ~V4L2_BUF_FLAG_PFRAME;
+		src_buf->flags |= V4L2_BUF_FLAG_KEYFRAME;
+		src_buf->flags &= ~V4L2_BUF_FLAG_PFRAME;
 	}
 
 	if (dev->devtype->product == CODA_960)
@@ -1224,9 +1226,9 @@ static int coda_prepare_encode(struct coda_ctx *ctx)
 	 * Copy headers at the beginning of the first frame for H.264 only.
 	 * In MPEG4 they are already copied by the coda.
 	 */
-	if (src_buf->v4l2_buf.sequence == 0) {
+	if (src_buf->sequence == 0) {
 		pic_stream_buffer_addr =
-			vb2_dma_contig_plane_dma_addr(dst_buf, 0) +
+			vb2_dma_contig_plane_dma_addr(&dst_buf->vb2_buf, 0) +
 			ctx->vpu_header_size[0] +
 			ctx->vpu_header_size[1] +
 			ctx->vpu_header_size[2];
@@ -1234,20 +1236,21 @@ static int coda_prepare_encode(struct coda_ctx *ctx)
 			ctx->vpu_header_size[0] -
 			ctx->vpu_header_size[1] -
 			ctx->vpu_header_size[2];
-		memcpy(vb2_plane_vaddr(dst_buf, 0),
+		memcpy(vb2_plane_vaddr(&dst_buf->vb2_buf, 0),
 		       &ctx->vpu_header[0][0], ctx->vpu_header_size[0]);
-		memcpy(vb2_plane_vaddr(dst_buf, 0) + ctx->vpu_header_size[0],
-		       &ctx->vpu_header[1][0], ctx->vpu_header_size[1]);
-		memcpy(vb2_plane_vaddr(dst_buf, 0) + ctx->vpu_header_size[0] +
-			ctx->vpu_header_size[1], &ctx->vpu_header[2][0],
-			ctx->vpu_header_size[2]);
+		memcpy(vb2_plane_vaddr(&dst_buf->vb2_buf, 0)
+			+ ctx->vpu_header_size[0], &ctx->vpu_header[1][0],
+			ctx->vpu_header_size[1]);
+		memcpy(vb2_plane_vaddr(&dst_buf->vb2_buf, 0)
+			+ ctx->vpu_header_size[0] + ctx->vpu_header_size[1],
+			&ctx->vpu_header[2][0], ctx->vpu_header_size[2]);
 	} else {
 		pic_stream_buffer_addr =
-			vb2_dma_contig_plane_dma_addr(dst_buf, 0);
+			vb2_dma_contig_plane_dma_addr(&dst_buf->vb2_buf, 0);
 		pic_stream_buffer_size = q_data_dst->sizeimage;
 	}
 
-	if (src_buf->v4l2_buf.flags & V4L2_BUF_FLAG_KEYFRAME) {
+	if (src_buf->flags & V4L2_BUF_FLAG_KEYFRAME) {
 		force_ipicture = 1;
 		switch (dst_fourcc) {
 		case V4L2_PIX_FMT_H264:
@@ -1324,7 +1327,7 @@ static int coda_prepare_encode(struct coda_ctx *ctx)
 
 static void coda_finish_encode(struct coda_ctx *ctx)
 {
-	struct vb2_buffer *src_buf, *dst_buf;
+	struct vb2_v4l2_buffer *src_buf, *dst_buf;
 	struct coda_dev *dev = ctx->dev;
 	u32 wr_ptr, start_ptr;
 
@@ -1338,13 +1341,13 @@ static void coda_finish_encode(struct coda_ctx *ctx)
 	wr_ptr = coda_read(dev, CODA_REG_BIT_WR_PTR(ctx->reg_idx));
 
 	/* Calculate bytesused field */
-	if (dst_buf->v4l2_buf.sequence == 0) {
-		vb2_set_plane_payload(dst_buf, 0, wr_ptr - start_ptr +
+	if (dst_buf->sequence == 0) {
+		vb2_set_plane_payload(&dst_buf->vb2_buf, 0,
 					ctx->vpu_header_size[0] +
 					ctx->vpu_header_size[1] +
 					ctx->vpu_header_size[2]);
 	} else {
-		vb2_set_plane_payload(dst_buf, 0, wr_ptr - start_ptr);
+		vb2_set_plane_payload(&dst_buf->vb2_buf, 0, wr_ptr - start_ptr);
 	}
 
 	v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev, "frame size = %u\n",
@@ -1354,18 +1357,18 @@ static void coda_finish_encode(struct coda_ctx *ctx)
 	coda_read(dev, CODA_RET_ENC_PIC_FLAG);
 
 	if (coda_read(dev, CODA_RET_ENC_PIC_TYPE) == 0) {
-		dst_buf->v4l2_buf.flags |= V4L2_BUF_FLAG_KEYFRAME;
-		dst_buf->v4l2_buf.flags &= ~V4L2_BUF_FLAG_PFRAME;
+		dst_buf->flags |= V4L2_BUF_FLAG_KEYFRAME;
+		dst_buf->flags &= ~V4L2_BUF_FLAG_PFRAME;
 	} else {
-		dst_buf->v4l2_buf.flags |= V4L2_BUF_FLAG_PFRAME;
-		dst_buf->v4l2_buf.flags &= ~V4L2_BUF_FLAG_KEYFRAME;
+		dst_buf->flags |= V4L2_BUF_FLAG_PFRAME;
+		dst_buf->flags &= ~V4L2_BUF_FLAG_KEYFRAME;
 	}
 
-	dst_buf->v4l2_buf.timestamp = src_buf->v4l2_buf.timestamp;
-	dst_buf->v4l2_buf.flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
-	dst_buf->v4l2_buf.flags |=
-		src_buf->v4l2_buf.flags & V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
-	dst_buf->v4l2_buf.timecode = src_buf->v4l2_buf.timecode;
+	dst_buf->timestamp = src_buf->timestamp;
+	dst_buf->flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
+	dst_buf->flags |=
+		src_buf->flags & V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
+	dst_buf->timecode = src_buf->timecode;
 
 	v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_DONE);
 
@@ -1378,8 +1381,8 @@ static void coda_finish_encode(struct coda_ctx *ctx)
 
 	v4l2_dbg(1, coda_debug, &dev->v4l2_dev,
 		"job finished: encoding frame (%d) (%s)\n",
-		dst_buf->v4l2_buf.sequence,
-		(dst_buf->v4l2_buf.flags & V4L2_BUF_FLAG_KEYFRAME) ?
+		dst_buf->sequence,
+		(dst_buf->flags & V4L2_BUF_FLAG_KEYFRAME) ?
 		"KEYFRAME" : "PFRAME");
 }
 
@@ -1716,7 +1719,7 @@ static int coda_start_decoding(struct coda_ctx *ctx)
 
 static int coda_prepare_decode(struct coda_ctx *ctx)
 {
-	struct vb2_buffer *dst_buf;
+	struct vb2_v4l2_buffer *dst_buf;
 	struct coda_dev *dev = ctx->dev;
 	struct coda_q_data *q_data_dst;
 	struct coda_buffer_meta *meta;
@@ -1763,7 +1766,7 @@ static int coda_prepare_decode(struct coda_ctx *ctx)
 		 * well as the rotator buffer output.
 		 * ROT_INDEX needs to be < 0x40, but > ctx->num_internal_frames.
 		 */
-		coda_write(dev, CODA_MAX_FRAMEBUFFERS + dst_buf->v4l2_buf.index,
+		coda_write(dev, CODA_MAX_FRAMEBUFFERS + dst_buf->vb2_buf.index,
 				CODA9_CMD_DEC_PIC_ROT_INDEX);
 
 		reg_addr = CODA9_CMD_DEC_PIC_ROT_ADDR_Y;
@@ -1838,7 +1841,7 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 	struct coda_dev *dev = ctx->dev;
 	struct coda_q_data *q_data_src;
 	struct coda_q_data *q_data_dst;
-	struct vb2_buffer *dst_buf;
+	struct vb2_v4l2_buffer *dst_buf;
 	struct coda_buffer_meta *meta;
 	unsigned long payload;
 	unsigned long flags;
@@ -2029,15 +2032,15 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 	if (ctx->display_idx >= 0 &&
 	    ctx->display_idx < ctx->num_internal_frames) {
 		dst_buf = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
-		dst_buf->v4l2_buf.sequence = ctx->osequence++;
+		dst_buf->sequence = ctx->osequence++;
 
-		dst_buf->v4l2_buf.flags &= ~(V4L2_BUF_FLAG_KEYFRAME |
+		dst_buf->flags &= ~(V4L2_BUF_FLAG_KEYFRAME |
 					     V4L2_BUF_FLAG_PFRAME |
 					     V4L2_BUF_FLAG_BFRAME);
-		dst_buf->v4l2_buf.flags |= ctx->frame_types[ctx->display_idx];
+		dst_buf->flags |= ctx->frame_types[ctx->display_idx];
 		meta = &ctx->frame_metas[ctx->display_idx];
-		dst_buf->v4l2_buf.timecode = meta->timecode;
-		dst_buf->v4l2_buf.timestamp = meta->timestamp;
+		dst_buf->timecode = meta->timecode;
+		dst_buf->timestamp = meta->timestamp;
 
 		trace_coda_dec_rot_done(ctx, dst_buf, meta);
 
@@ -2052,15 +2055,15 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 			payload = width * height * 2;
 			break;
 		}
-		vb2_set_plane_payload(dst_buf, 0, payload);
+		vb2_set_plane_payload(&dst_buf->vb2_buf, 0, payload);
 
 		coda_m2m_buf_done(ctx, dst_buf, ctx->frame_errors[display_idx] ?
 				  VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
 
 		v4l2_dbg(1, coda_debug, &dev->v4l2_dev,
 			"job finished: decoding frame (%d) (%s)\n",
-			dst_buf->v4l2_buf.sequence,
-			(dst_buf->v4l2_buf.flags & V4L2_BUF_FLAG_KEYFRAME) ?
+			dst_buf->sequence,
+			(dst_buf->flags & V4L2_BUF_FLAG_KEYFRAME) ?
 			"KEYFRAME" : "PFRAME");
 	} else {
 		v4l2_dbg(1, coda_debug, &dev->v4l2_dev,
diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 998fe66..60336ee 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -84,9 +84,9 @@ unsigned int coda_read(struct coda_dev *dev, u32 reg)
 }
 
 void coda_write_base(struct coda_ctx *ctx, struct coda_q_data *q_data,
-		     struct vb2_buffer *buf, unsigned int reg_y)
+		     struct vb2_v4l2_buffer *buf, unsigned int reg_y)
 {
-	u32 base_y = vb2_dma_contig_plane_dma_addr(buf, 0);
+	u32 base_y = vb2_dma_contig_plane_dma_addr(&buf->vb2_buf, 0);
 	u32 base_cb, base_cr;
 
 	switch (q_data->fourcc) {
@@ -684,17 +684,17 @@ static int coda_qbuf(struct file *file, void *priv,
 }
 
 static bool coda_buf_is_end_of_stream(struct coda_ctx *ctx,
-				      struct vb2_buffer *buf)
+				      struct vb2_v4l2_buffer *buf)
 {
 	struct vb2_queue *src_vq;
 
 	src_vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
 
 	return ((ctx->bit_stream_param & CODA_BIT_STREAM_END_FLAG) &&
-		(buf->v4l2_buf.sequence == (ctx->qsequence - 1)));
+		(buf->sequence == (ctx->qsequence - 1)));
 }
 
-void coda_m2m_buf_done(struct coda_ctx *ctx, struct vb2_buffer *buf,
+void coda_m2m_buf_done(struct coda_ctx *ctx, struct vb2_v4l2_buffer *buf,
 		       enum vb2_buffer_state state)
 {
 	const struct v4l2_event eos_event = {
@@ -702,7 +702,7 @@ void coda_m2m_buf_done(struct coda_ctx *ctx, struct vb2_buffer *buf,
 	};
 
 	if (coda_buf_is_end_of_stream(ctx, buf)) {
-		buf->v4l2_buf.flags |= V4L2_BUF_FLAG_LAST;
+		buf->flags |= V4L2_BUF_FLAG_LAST;
 
 		v4l2_event_queue_fh(&ctx->fh, &eos_event);
 	}
@@ -1175,6 +1175,7 @@ static int coda_buf_prepare(struct vb2_buffer *vb)
 
 static void coda_buf_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct coda_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
 	struct vb2_queue *vq = vb->vb2_queue;
 	struct coda_q_data *q_data;
@@ -1193,12 +1194,12 @@ static void coda_buf_queue(struct vb2_buffer *vb)
 		if (vb2_get_plane_payload(vb, 0) == 0)
 			coda_bit_stream_end_flag(ctx);
 		mutex_lock(&ctx->bitstream_mutex);
-		v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vb);
+		v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vbuf);
 		if (vb2_is_streaming(vb->vb2_queue))
 			coda_fill_bitstream(ctx, true);
 		mutex_unlock(&ctx->bitstream_mutex);
 	} else {
-		v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vb);
+		v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vbuf);
 	}
 }
 
@@ -1247,7 +1248,7 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 	struct coda_ctx *ctx = vb2_get_drv_priv(q);
 	struct v4l2_device *v4l2_dev = &ctx->dev->v4l2_dev;
 	struct coda_q_data *q_data_src, *q_data_dst;
-	struct vb2_buffer *buf;
+	struct vb2_v4l2_buffer *buf;
 	int ret = 0;
 
 	q_data_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
@@ -1338,7 +1339,7 @@ static void coda_stop_streaming(struct vb2_queue *q)
 {
 	struct coda_ctx *ctx = vb2_get_drv_priv(q);
 	struct coda_dev *dev = ctx->dev;
-	struct vb2_buffer *buf;
+	struct vb2_v4l2_buffer *buf;
 	unsigned long flags;
 	bool stop;
 
diff --git a/drivers/media/platform/coda/coda-jpeg.c b/drivers/media/platform/coda/coda-jpeg.c
index 11e734b..96cd42a 100644
--- a/drivers/media/platform/coda/coda-jpeg.c
+++ b/drivers/media/platform/coda/coda-jpeg.c
@@ -178,12 +178,12 @@ int coda_jpeg_write_tables(struct coda_ctx *ctx)
 	return 0;
 }
 
-bool coda_jpeg_check_buffer(struct coda_ctx *ctx, struct vb2_buffer *vb)
+bool coda_jpeg_check_buffer(struct coda_ctx *ctx, struct vb2_v4l2_buffer *vb)
 {
-	void *vaddr = vb2_plane_vaddr(vb, 0);
+	void *vaddr = vb2_plane_vaddr(&vb->vb2_buf, 0);
 	u16 soi = be16_to_cpup((__be16 *)vaddr);
 	u16 eoi = be16_to_cpup((__be16 *)(vaddr +
-					  vb2_get_plane_payload(vb, 0) - 2));
+			  vb2_get_plane_payload(&vb->vb2_buf, 0) - 2));
 
 	return soi == SOI_MARKER && eoi == EOI_MARKER;
 }
diff --git a/drivers/media/platform/coda/coda.h b/drivers/media/platform/coda/coda.h
index feb9671..96532b0 100644
--- a/drivers/media/platform/coda/coda.h
+++ b/drivers/media/platform/coda/coda.h
@@ -243,7 +243,7 @@ extern int coda_debug;
 void coda_write(struct coda_dev *dev, u32 data, u32 reg);
 unsigned int coda_read(struct coda_dev *dev, u32 reg);
 void coda_write_base(struct coda_ctx *ctx, struct coda_q_data *q_data,
-		     struct vb2_buffer *buf, unsigned int reg_y);
+		     struct vb2_v4l2_buffer *buf, unsigned int reg_y);
 
 int coda_alloc_aux_buf(struct coda_dev *dev, struct coda_aux_buf *buf,
 		       size_t size, const char *name, struct dentry *parent);
@@ -284,12 +284,12 @@ static inline unsigned int coda_get_bitstream_payload(struct coda_ctx *ctx)
 
 void coda_bit_stream_end_flag(struct coda_ctx *ctx);
 
-void coda_m2m_buf_done(struct coda_ctx *ctx, struct vb2_buffer *buf,
+void coda_m2m_buf_done(struct coda_ctx *ctx, struct vb2_v4l2_buffer *buf,
 		       enum vb2_buffer_state state);
 
 int coda_h264_padding(int size, char *p);
 
-bool coda_jpeg_check_buffer(struct coda_ctx *ctx, struct vb2_buffer *vb);
+bool coda_jpeg_check_buffer(struct coda_ctx *ctx, struct vb2_v4l2_buffer *vb);
 int coda_jpeg_write_tables(struct coda_ctx *ctx);
 void coda_set_jpeg_compression_quality(struct coda_ctx *ctx, int quality);
 
diff --git a/drivers/media/platform/coda/trace.h b/drivers/media/platform/coda/trace.h
index 9db6a66..f20666a 100644
--- a/drivers/media/platform/coda/trace.h
+++ b/drivers/media/platform/coda/trace.h
@@ -49,7 +49,7 @@ TRACE_EVENT(coda_bit_done,
 );
 
 DECLARE_EVENT_CLASS(coda_buf_class,
-	TP_PROTO(struct coda_ctx *ctx, struct vb2_buffer *buf),
+	TP_PROTO(struct coda_ctx *ctx, struct vb2_v4l2_buffer *buf),
 
 	TP_ARGS(ctx, buf),
 
@@ -61,7 +61,7 @@ DECLARE_EVENT_CLASS(coda_buf_class,
 
 	TP_fast_assign(
 		__entry->minor = ctx->fh.vdev->minor;
-		__entry->index = buf->v4l2_buf.index;
+		__entry->index = buf->vb2_buf.index;
 		__entry->ctx = ctx->idx;
 	),
 
@@ -70,17 +70,17 @@ DECLARE_EVENT_CLASS(coda_buf_class,
 );
 
 DEFINE_EVENT(coda_buf_class, coda_enc_pic_run,
-	TP_PROTO(struct coda_ctx *ctx, struct vb2_buffer *buf),
+	TP_PROTO(struct coda_ctx *ctx, struct vb2_v4l2_buffer *buf),
 	TP_ARGS(ctx, buf)
 );
 
 DEFINE_EVENT(coda_buf_class, coda_enc_pic_done,
-	TP_PROTO(struct coda_ctx *ctx, struct vb2_buffer *buf),
+	TP_PROTO(struct coda_ctx *ctx, struct vb2_v4l2_buffer *buf),
 	TP_ARGS(ctx, buf)
 );
 
 DECLARE_EVENT_CLASS(coda_buf_meta_class,
-	TP_PROTO(struct coda_ctx *ctx, struct vb2_buffer *buf,
+	TP_PROTO(struct coda_ctx *ctx, struct vb2_v4l2_buffer *buf,
 		 struct coda_buffer_meta *meta),
 
 	TP_ARGS(ctx, buf, meta),
@@ -95,7 +95,7 @@ DECLARE_EVENT_CLASS(coda_buf_meta_class,
 
 	TP_fast_assign(
 		__entry->minor = ctx->fh.vdev->minor;
-		__entry->index = buf->v4l2_buf.index;
+		__entry->index = buf->vb2_buf.index;
 		__entry->start = meta->start;
 		__entry->end = meta->end;
 		__entry->ctx = ctx->idx;
@@ -107,7 +107,7 @@ DECLARE_EVENT_CLASS(coda_buf_meta_class,
 );
 
 DEFINE_EVENT(coda_buf_meta_class, coda_bit_queue,
-	TP_PROTO(struct coda_ctx *ctx, struct vb2_buffer *buf,
+	TP_PROTO(struct coda_ctx *ctx, struct vb2_v4l2_buffer *buf,
 		 struct coda_buffer_meta *meta),
 	TP_ARGS(ctx, buf, meta)
 );
@@ -146,7 +146,7 @@ DEFINE_EVENT(coda_meta_class, coda_dec_pic_done,
 );
 
 DEFINE_EVENT(coda_buf_meta_class, coda_dec_rot_done,
-	TP_PROTO(struct coda_ctx *ctx, struct vb2_buffer *buf,
+	TP_PROTO(struct coda_ctx *ctx, struct vb2_v4l2_buffer *buf,
 		 struct coda_buffer_meta *meta),
 	TP_ARGS(ctx, buf, meta)
 );
diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
index f69cdd7..39f8ccf 100644
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -74,8 +74,8 @@ static void vpbe_isr_even_field(struct vpbe_display *disp_obj,
 	if (layer->cur_frm == layer->next_frm)
 		return;
 
-	v4l2_get_timestamp(&layer->cur_frm->vb.v4l2_buf.timestamp);
-	vb2_buffer_done(&layer->cur_frm->vb, VB2_BUF_STATE_DONE);
+	v4l2_get_timestamp(&layer->cur_frm->vb.timestamp);
+	vb2_buffer_done(&layer->cur_frm->vb.vb2_buf, VB2_BUF_STATE_DONE);
 	/* Make cur_frm pointing to next_frm */
 	layer->cur_frm = layer->next_frm;
 }
@@ -104,8 +104,8 @@ static void vpbe_isr_odd_field(struct vpbe_display *disp_obj,
 	list_del(&layer->next_frm->list);
 	spin_unlock(&disp_obj->dma_queue_lock);
 	/* Mark state of the frame to active */
-	layer->next_frm->vb.state = VB2_BUF_STATE_ACTIVE;
-	addr = vb2_dma_contig_plane_dma_addr(&layer->next_frm->vb, 0);
+	layer->next_frm->vb.vb2_buf.state = VB2_BUF_STATE_ACTIVE;
+	addr = vb2_dma_contig_plane_dma_addr(&layer->next_frm->vb.vb2_buf, 0);
 	osd_device->ops.start_layer(osd_device,
 			layer->layer_info.id,
 			addr,
@@ -259,8 +259,9 @@ vpbe_buffer_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
  */
 static void vpbe_buffer_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	/* Get the file handle object and layer object */
-	struct vpbe_disp_buffer *buf = container_of(vb,
+	struct vpbe_disp_buffer *buf = container_of(vbuf,
 				struct vpbe_disp_buffer, vb);
 	struct vpbe_layer *layer = vb2_get_drv_priv(vb->vb2_queue);
 	struct vpbe_display *disp = layer->disp_dev;
@@ -290,7 +291,7 @@ static int vpbe_start_streaming(struct vb2_queue *vq, unsigned int count)
 	/* Remove buffer from the buffer queue */
 	list_del(&layer->cur_frm->list);
 	/* Mark state of the current frame to active */
-	layer->cur_frm->vb.state = VB2_BUF_STATE_ACTIVE;
+	layer->cur_frm->vb.vb2_buf.state = VB2_BUF_STATE_ACTIVE;
 	/* Initialize field_id and started member */
 	layer->field_id = 0;
 
@@ -299,10 +300,12 @@ static int vpbe_start_streaming(struct vb2_queue *vq, unsigned int count)
 	if (ret < 0) {
 		struct vpbe_disp_buffer *buf, *tmp;
 
-		vb2_buffer_done(&layer->cur_frm->vb, VB2_BUF_STATE_QUEUED);
+		vb2_buffer_done(&layer->cur_frm->vb.vb2_buf,
+				VB2_BUF_STATE_QUEUED);
 		list_for_each_entry_safe(buf, tmp, &layer->dma_queue, list) {
 			list_del(&buf->list);
-			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+			vb2_buffer_done(&buf->vb.vb2_buf,
+					VB2_BUF_STATE_QUEUED);
 		}
 
 		return ret;
@@ -332,13 +335,14 @@ static void vpbe_stop_streaming(struct vb2_queue *vq)
 	/* release all active buffers */
 	spin_lock_irqsave(&disp->dma_queue_lock, flags);
 	if (layer->cur_frm == layer->next_frm) {
-		vb2_buffer_done(&layer->cur_frm->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&layer->cur_frm->vb.vb2_buf,
+				VB2_BUF_STATE_ERROR);
 	} else {
 		if (layer->cur_frm != NULL)
-			vb2_buffer_done(&layer->cur_frm->vb,
+			vb2_buffer_done(&layer->cur_frm->vb.vb2_buf,
 					VB2_BUF_STATE_ERROR);
 		if (layer->next_frm != NULL)
-			vb2_buffer_done(&layer->next_frm->vb,
+			vb2_buffer_done(&layer->next_frm->vb.vb2_buf,
 					VB2_BUF_STATE_ERROR);
 	}
 
@@ -346,7 +350,8 @@ static void vpbe_stop_streaming(struct vb2_queue *vq)
 		layer->next_frm = list_entry(layer->dma_queue.next,
 						struct vpbe_disp_buffer, list);
 		list_del(&layer->next_frm->list);
-		vb2_buffer_done(&layer->next_frm->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&layer->next_frm->vb.vb2_buf,
+				VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irqrestore(&disp->dma_queue_lock, flags);
 }
@@ -383,7 +388,7 @@ static int vpbe_set_osd_display_params(struct vpbe_display *disp_dev,
 	unsigned long addr;
 	int ret;
 
-	addr = vb2_dma_contig_plane_dma_addr(&layer->cur_frm->vb, 0);
+	addr = vb2_dma_contig_plane_dma_addr(&layer->cur_frm->vb.vb2_buf, 0);
 	/* Set address in the display registers */
 	osd_device->ops.start_layer(osd_device,
 				    layer->layer_info.id,
diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index a5f5481..b29bb64 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -57,7 +57,8 @@ static u8 channel_first_int[VPIF_NUMBER_OF_OBJECTS][2] = { {1, 1} };
 /* Is set to 1 in case of SDTV formats, 2 in case of HDTV formats. */
 static int ycmux_mode;
 
-static inline struct vpif_cap_buffer *to_vpif_buffer(struct vb2_buffer *vb)
+static inline
+struct vpif_cap_buffer *to_vpif_buffer(struct vb2_v4l2_buffer *vb)
 {
 	return container_of(vb, struct vpif_cap_buffer, vb);
 }
@@ -72,6 +73,7 @@ static inline struct vpif_cap_buffer *to_vpif_buffer(struct vb2_buffer *vb)
  */
 static int vpif_buffer_prepare(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vb2_queue *q = vb->vb2_queue;
 	struct channel_obj *ch = vb2_get_drv_priv(q);
 	struct common_obj *common;
@@ -85,7 +87,7 @@ static int vpif_buffer_prepare(struct vb2_buffer *vb)
 	if (vb2_get_plane_payload(vb, 0) > vb2_plane_size(vb, 0))
 		return -EINVAL;
 
-	vb->v4l2_buf.field = common->fmt.fmt.pix.field;
+	vbuf->field = common->fmt.fmt.pix.field;
 
 	addr = vb2_dma_contig_plane_dma_addr(vb, 0);
 	if (!IS_ALIGNED((addr + common->ytop_off), 8) ||
@@ -145,8 +147,9 @@ static int vpif_buffer_queue_setup(struct vb2_queue *vq,
  */
 static void vpif_buffer_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct channel_obj *ch = vb2_get_drv_priv(vb->vb2_queue);
-	struct vpif_cap_buffer *buf = to_vpif_buffer(vb);
+	struct vpif_cap_buffer *buf = to_vpif_buffer(vbuf);
 	struct common_obj *common;
 	unsigned long flags;
 
@@ -214,7 +217,7 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 	list_del(&common->cur_frm->list);
 	spin_unlock_irqrestore(&common->irqlock, flags);
 
-	addr = vb2_dma_contig_plane_dma_addr(&common->cur_frm->vb, 0);
+	addr = vb2_dma_contig_plane_dma_addr(&common->cur_frm->vb.vb2_buf, 0);
 
 	common->set_addr(addr + common->ytop_off,
 			 addr + common->ybtm_off,
@@ -243,7 +246,7 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 err:
 	list_for_each_entry_safe(buf, tmp, &common->dma_queue, list) {
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_QUEUED);
 	}
 	spin_unlock_irqrestore(&common->irqlock, flags);
 
@@ -286,13 +289,14 @@ static void vpif_stop_streaming(struct vb2_queue *vq)
 	/* release all active buffers */
 	spin_lock_irqsave(&common->irqlock, flags);
 	if (common->cur_frm == common->next_frm) {
-		vb2_buffer_done(&common->cur_frm->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&common->cur_frm->vb.vb2_buf,
+				VB2_BUF_STATE_ERROR);
 	} else {
 		if (common->cur_frm != NULL)
-			vb2_buffer_done(&common->cur_frm->vb,
+			vb2_buffer_done(&common->cur_frm->vb.vb2_buf,
 					VB2_BUF_STATE_ERROR);
 		if (common->next_frm != NULL)
-			vb2_buffer_done(&common->next_frm->vb,
+			vb2_buffer_done(&common->next_frm->vb.vb2_buf,
 					VB2_BUF_STATE_ERROR);
 	}
 
@@ -300,7 +304,8 @@ static void vpif_stop_streaming(struct vb2_queue *vq)
 		common->next_frm = list_entry(common->dma_queue.next,
 						struct vpif_cap_buffer, list);
 		list_del(&common->next_frm->list);
-		vb2_buffer_done(&common->next_frm->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&common->next_frm->vb.vb2_buf,
+				VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irqrestore(&common->irqlock, flags);
 }
@@ -325,9 +330,8 @@ static struct vb2_ops video_qops = {
  */
 static void vpif_process_buffer_complete(struct common_obj *common)
 {
-	v4l2_get_timestamp(&common->cur_frm->vb.v4l2_buf.timestamp);
-	vb2_buffer_done(&common->cur_frm->vb,
-					    VB2_BUF_STATE_DONE);
+	v4l2_get_timestamp(&common->cur_frm->vb.timestamp);
+	vb2_buffer_done(&common->cur_frm->vb.vb2_buf, VB2_BUF_STATE_DONE);
 	/* Make curFrm pointing to nextFrm */
 	common->cur_frm = common->next_frm;
 }
@@ -350,7 +354,7 @@ static void vpif_schedule_next_buffer(struct common_obj *common)
 	/* Remove that buffer from the buffer queue */
 	list_del(&common->next_frm->list);
 	spin_unlock(&common->irqlock);
-	addr = vb2_dma_contig_plane_dma_addr(&common->next_frm->vb, 0);
+	addr = vb2_dma_contig_plane_dma_addr(&common->next_frm->vb.vb2_buf, 0);
 
 	/* Set top and bottom field addresses in VPIF registers */
 	common->set_addr(addr + common->ytop_off,
diff --git a/drivers/media/platform/davinci/vpif_capture.h b/drivers/media/platform/davinci/vpif_capture.h
index 8b8a663..4a76009 100644
--- a/drivers/media/platform/davinci/vpif_capture.h
+++ b/drivers/media/platform/davinci/vpif_capture.h
@@ -52,7 +52,7 @@ struct video_obj {
 };
 
 struct vpif_cap_buffer {
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head list;
 };
 
diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index 682e5d5..85a3641 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -77,7 +77,7 @@ static int vpif_buffer_prepare(struct vb2_buffer *vb)
 	if (vb2_get_plane_payload(vb, 0) > vb2_plane_size(vb, 0))
 		return -EINVAL;
 
-	vb->v4l2_buf.field = common->fmt.fmt.pix.field;
+	vb->field = common->fmt.fmt.pix.field;
 
 	if (vb->vb2_queue->type != V4L2_BUF_TYPE_SLICED_VBI_OUTPUT) {
 		unsigned long addr = vb2_dma_contig_plane_dma_addr(vb, 0);
@@ -229,7 +229,7 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 err:
 	list_for_each_entry_safe(buf, tmp, &common->dma_queue, list) {
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_QUEUED);
 	}
 	spin_unlock_irqrestore(&common->irqlock, flags);
 
@@ -264,13 +264,14 @@ static void vpif_stop_streaming(struct vb2_queue *vq)
 	/* release all active buffers */
 	spin_lock_irqsave(&common->irqlock, flags);
 	if (common->cur_frm == common->next_frm) {
-		vb2_buffer_done(&common->cur_frm->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&common->cur_frm->vb.vb2_buf,
+				VB2_BUF_STATE_ERROR);
 	} else {
 		if (common->cur_frm != NULL)
-			vb2_buffer_done(&common->cur_frm->vb,
+			vb2_buffer_done(&common->cur_frm->vb.vb2_buf,
 					VB2_BUF_STATE_ERROR);
 		if (common->next_frm != NULL)
-			vb2_buffer_done(&common->next_frm->vb,
+			vb2_buffer_done(&common->next_frm->vb.vb2_buf,
 					VB2_BUF_STATE_ERROR);
 	}
 
@@ -278,7 +279,8 @@ static void vpif_stop_streaming(struct vb2_queue *vq)
 		common->next_frm = list_entry(common->dma_queue.next,
 						struct vpif_disp_buffer, list);
 		list_del(&common->next_frm->list);
-		vb2_buffer_done(&common->next_frm->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&common->next_frm->vb.vb2_buf,
+				VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irqrestore(&common->irqlock, flags);
 }
@@ -324,10 +326,10 @@ static void process_interlaced_mode(int fid, struct common_obj *common)
 		/* one frame is displayed If next frame is
 		 *  available, release cur_frm and move on */
 		/* Copy frame display time */
-		v4l2_get_timestamp(&common->cur_frm->vb.v4l2_buf.timestamp);
+		v4l2_get_timestamp(&common->cur_frm->vb.timestamp);
 		/* Change status of the cur_frm */
-		vb2_buffer_done(&common->cur_frm->vb,
-					    VB2_BUF_STATE_DONE);
+		vb2_buffer_done(&common->cur_frm->vb.vb2_buf,
+					VB2_BUF_STATE_DONE);
 		/* Make cur_frm pointing to next_frm */
 		common->cur_frm = common->next_frm;
 
@@ -380,10 +382,10 @@ static irqreturn_t vpif_channel_isr(int irq, void *dev_id)
 			if (!channel_first_int[i][channel_id]) {
 				/* Mark status of the cur_frm to
 				 * done and unlock semaphore on it */
-				v4l2_get_timestamp(&common->cur_frm->vb.
-						   v4l2_buf.timestamp);
-				vb2_buffer_done(&common->cur_frm->vb,
-					    VB2_BUF_STATE_DONE);
+				v4l2_get_timestamp(
+					&common->cur_frm->vb.timestamp);
+				vb2_buffer_done(&common->cur_frm->vb.vb2_buf,
+						VB2_BUF_STATE_DONE);
 				/* Make cur_frm pointing to next_frm */
 				common->cur_frm = common->next_frm;
 			}
diff --git a/drivers/media/platform/davinci/vpif_display.h b/drivers/media/platform/davinci/vpif_display.h
index 849e0e3..e7a1723 100644
--- a/drivers/media/platform/davinci/vpif_display.h
+++ b/drivers/media/platform/davinci/vpif_display.h
@@ -62,7 +62,7 @@ struct video_obj {
 };
 
 struct vpif_disp_buffer {
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head list;
 };
 
diff --git a/drivers/media/platform/exynos-gsc/gsc-core.h b/drivers/media/platform/exynos-gsc/gsc-core.h
index 769ff50..e93a233 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.h
+++ b/drivers/media/platform/exynos-gsc/gsc-core.h
@@ -136,7 +136,7 @@ struct gsc_fmt {
  * @idx : index of G-Scaler input buffer
  */
 struct gsc_input_buf {
-	struct vb2_buffer	vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head	list;
 	int			idx;
 };
diff --git a/drivers/media/platform/exynos-gsc/gsc-m2m.c b/drivers/media/platform/exynos-gsc/gsc-m2m.c
index d5cffef..59d134d 100644
--- a/drivers/media/platform/exynos-gsc/gsc-m2m.c
+++ b/drivers/media/platform/exynos-gsc/gsc-m2m.c
@@ -77,7 +77,7 @@ static void gsc_m2m_stop_streaming(struct vb2_queue *q)
 
 void gsc_m2m_job_finish(struct gsc_ctx *ctx, int vb_state)
 {
-	struct vb2_buffer *src_vb, *dst_vb;
+	struct vb2_v4l2_buffer *src_vb, *dst_vb;
 
 	if (!ctx || !ctx->m2m_ctx)
 		return;
@@ -86,11 +86,11 @@ void gsc_m2m_job_finish(struct gsc_ctx *ctx, int vb_state)
 	dst_vb = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
 
 	if (src_vb && dst_vb) {
-		dst_vb->v4l2_buf.timestamp = src_vb->v4l2_buf.timestamp;
-		dst_vb->v4l2_buf.timecode = src_vb->v4l2_buf.timecode;
-		dst_vb->v4l2_buf.flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
-		dst_vb->v4l2_buf.flags |=
-			src_vb->v4l2_buf.flags
+		dst_vb->timestamp = src_vb->timestamp;
+		dst_vb->timecode = src_vb->timecode;
+		dst_vb->flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
+		dst_vb->flags |=
+			src_vb->flags
 			& V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
 
 		v4l2_m2m_buf_done(src_vb, vb_state);
@@ -109,23 +109,23 @@ static void gsc_m2m_job_abort(void *priv)
 static int gsc_get_bufs(struct gsc_ctx *ctx)
 {
 	struct gsc_frame *s_frame, *d_frame;
-	struct vb2_buffer *src_vb, *dst_vb;
+	struct vb2_v4l2_buffer *src_vb, *dst_vb;
 	int ret;
 
 	s_frame = &ctx->s_frame;
 	d_frame = &ctx->d_frame;
 
 	src_vb = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
-	ret = gsc_prepare_addr(ctx, src_vb, s_frame, &s_frame->addr);
+	ret = gsc_prepare_addr(ctx, &src_vb->vb2_buf, s_frame, &s_frame->addr);
 	if (ret)
 		return ret;
 
 	dst_vb = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
-	ret = gsc_prepare_addr(ctx, dst_vb, d_frame, &d_frame->addr);
+	ret = gsc_prepare_addr(ctx, &dst_vb->vb2_buf, d_frame, &d_frame->addr);
 	if (ret)
 		return ret;
 
-	dst_vb->v4l2_buf.timestamp = src_vb->v4l2_buf.timestamp;
+	dst_vb->timestamp = src_vb->timestamp;
 
 	return 0;
 }
@@ -255,12 +255,13 @@ static int gsc_m2m_buf_prepare(struct vb2_buffer *vb)
 
 static void gsc_m2m_buf_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct gsc_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
 
 	pr_debug("ctx: %p, ctx->state: 0x%x", ctx, ctx->state);
 
 	if (ctx->m2m_ctx)
-		v4l2_m2m_buf_queue(ctx->m2m_ctx, vb);
+		v4l2_m2m_buf_queue(ctx->m2m_ctx, vbuf);
 }
 
 static struct vb2_ops gsc_m2m_qops = {
diff --git a/drivers/media/platform/exynos4-is/fimc-capture.c b/drivers/media/platform/exynos4-is/fimc-capture.c
index d0ceae3..84b9817 100644
--- a/drivers/media/platform/exynos4-is/fimc-capture.c
+++ b/drivers/media/platform/exynos4-is/fimc-capture.c
@@ -103,7 +103,7 @@ static int fimc_capture_state_cleanup(struct fimc_dev *fimc, bool suspend)
 	/* Release unused buffers */
 	while (!suspend && !list_empty(&cap->pending_buf_q)) {
 		buf = fimc_pending_queue_pop(cap);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
 	/* If suspending put unused buffers onto pending queue */
 	while (!list_empty(&cap->active_buf_q)) {
@@ -111,7 +111,7 @@ static int fimc_capture_state_cleanup(struct fimc_dev *fimc, bool suspend)
 		if (suspend)
 			fimc_pending_queue_add(cap, buf);
 		else
-			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+			vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
 
 	fimc_hw_reset(fimc);
@@ -197,12 +197,12 @@ void fimc_capture_irq_handler(struct fimc_dev *fimc, int deq_buf)
 
 		v_buf = fimc_active_queue_pop(cap);
 
-		tv = &v_buf->vb.v4l2_buf.timestamp;
+		tv = &v_buf->vb.timestamp;
 		tv->tv_sec = ts.tv_sec;
 		tv->tv_usec = ts.tv_nsec / NSEC_PER_USEC;
-		v_buf->vb.v4l2_buf.sequence = cap->frame_count++;
+		v_buf->vb.sequence = cap->frame_count++;
 
-		vb2_buffer_done(&v_buf->vb, VB2_BUF_STATE_DONE);
+		vb2_buffer_done(&v_buf->vb.vb2_buf, VB2_BUF_STATE_DONE);
 	}
 
 	if (!list_empty(&cap->pending_buf_q)) {
@@ -233,7 +233,7 @@ void fimc_capture_irq_handler(struct fimc_dev *fimc, int deq_buf)
 		list_for_each_entry(v_buf, &cap->active_buf_q, list) {
 			if (v_buf->index != index)
 				continue;
-			vaddr = vb2_plane_vaddr(&v_buf->vb, plane);
+			vaddr = vb2_plane_vaddr(&v_buf->vb.vb2_buf, plane);
 			v4l2_subdev_call(csis, video, s_rx_buffer,
 					 vaddr, &size);
 			break;
@@ -338,7 +338,7 @@ int fimc_capture_resume(struct fimc_dev *fimc)
 		if (list_empty(&vid_cap->pending_buf_q))
 			break;
 		buf = fimc_pending_queue_pop(vid_cap);
-		buffer_queue(&buf->vb);
+		buffer_queue(&buf->vb.vb2_buf);
 	}
 	return 0;
 
@@ -410,8 +410,9 @@ static int buffer_prepare(struct vb2_buffer *vb)
 
 static void buffer_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct fimc_vid_buffer *buf
-		= container_of(vb, struct fimc_vid_buffer, vb);
+		= container_of(vbuf, struct fimc_vid_buffer, vb);
 	struct fimc_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
 	struct fimc_dev *fimc = ctx->fimc_dev;
 	struct fimc_vid_cap *vid_cap = &fimc->vid_cap;
@@ -420,7 +421,7 @@ static void buffer_queue(struct vb2_buffer *vb)
 	int min_bufs;
 
 	spin_lock_irqsave(&fimc->slock, flags);
-	fimc_prepare_addr(ctx, &buf->vb, &ctx->d_frame, &buf->paddr);
+	fimc_prepare_addr(ctx, &buf->vb.vb2_buf, &ctx->d_frame, &buf->paddr);
 
 	if (!test_bit(ST_CAPT_SUSPENDED, &fimc->state) &&
 	    !test_bit(ST_CAPT_STREAM, &fimc->state) &&
@@ -1472,7 +1473,8 @@ void fimc_sensor_notify(struct v4l2_subdev *sd, unsigned int notification,
 		if (!list_empty(&fimc->vid_cap.active_buf_q)) {
 			buf = list_entry(fimc->vid_cap.active_buf_q.next,
 					 struct fimc_vid_buffer, list);
-			vb2_set_plane_payload(&buf->vb, 0, *((u32 *)arg));
+			vb2_set_plane_payload(&buf->vb.vb2_buf, 0,
+					      *((u32 *)arg));
 		}
 		fimc_capture_irq_handler(fimc, 1);
 		fimc_deactivate_capture(fimc);
diff --git a/drivers/media/platform/exynos4-is/fimc-core.h b/drivers/media/platform/exynos4-is/fimc-core.h
index ccb5d91..d336fa2 100644
--- a/drivers/media/platform/exynos4-is/fimc-core.h
+++ b/drivers/media/platform/exynos4-is/fimc-core.h
@@ -224,7 +224,7 @@ struct fimc_addr {
  * @index: buffer index for the output DMA engine
  */
 struct fimc_vid_buffer {
-	struct vb2_buffer	vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head	list;
 	struct fimc_addr	paddr;
 	int			index;
diff --git a/drivers/media/platform/exynos4-is/fimc-isp-video.c b/drivers/media/platform/exynos4-is/fimc-isp-video.c
index 195f9b5..bacc3a3 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp-video.c
+++ b/drivers/media/platform/exynos4-is/fimc-isp-video.c
@@ -194,10 +194,11 @@ static int isp_video_capture_buffer_prepare(struct vb2_buffer *vb)
 
 static void isp_video_capture_buffer_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct fimc_isp *isp = vb2_get_drv_priv(vb->vb2_queue);
 	struct fimc_is_video *video = &isp->video_capture;
 	struct fimc_is *is = fimc_isp_to_is(isp);
-	struct isp_video_buf *ivb = to_isp_video_buf(vb);
+	struct isp_video_buf *ivb = to_isp_video_buf(vbuf);
 	unsigned long flags;
 	unsigned int i;
 
@@ -220,7 +221,7 @@ static void isp_video_capture_buffer_queue(struct vb2_buffer *vb)
 
 			isp_dbg(2, &video->ve.vdev,
 				"dma_buf %pad (%d/%d/%d) addr: %pad\n",
-				&buf_index, ivb->index, i, vb->v4l2_buf.index,
+				&buf_index, ivb->index, i, vb->index,
 				&ivb->dma_addr[i]);
 		}
 
@@ -242,7 +243,7 @@ static void isp_video_capture_buffer_queue(struct vb2_buffer *vb)
 void fimc_isp_video_irq_handler(struct fimc_is *is)
 {
 	struct fimc_is_video *video = &is->isp.video_capture;
-	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vbuf;
 	int buf_index;
 
 	/* TODO: Ensure the DMA is really stopped in stop_streaming callback */
@@ -250,10 +251,10 @@ void fimc_isp_video_irq_handler(struct fimc_is *is)
 		return;
 
 	buf_index = (is->i2h_cmd.args[1] - 1) % video->buf_count;
-	vb = &video->buffers[buf_index]->vb;
+	vbuf = &video->buffers[buf_index]->vb;
 
-	v4l2_get_timestamp(&vb->v4l2_buf.timestamp);
-	vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
+	v4l2_get_timestamp(&vbuf->timestamp);
+	vb2_buffer_done(&vbuf->vb2_buf, VB2_BUF_STATE_DONE);
 
 	video->buf_mask &= ~BIT(buf_index);
 	fimc_is_hw_set_isp_buf_mask(is, video->buf_mask);
diff --git a/drivers/media/platform/exynos4-is/fimc-isp.h b/drivers/media/platform/exynos4-is/fimc-isp.h
index ad9908b..c2d25df 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp.h
+++ b/drivers/media/platform/exynos4-is/fimc-isp.h
@@ -102,7 +102,7 @@ struct fimc_isp_ctrls {
 };
 
 struct isp_video_buf {
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	dma_addr_t dma_addr[FIMC_ISP_MAX_PLANES];
 	unsigned int index;
 };
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index 7e37c9a..04c245b 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -200,7 +200,7 @@ static int fimc_lite_reinit(struct fimc_lite *fimc, bool suspend)
 	/* Release unused buffers */
 	while (!suspend && !list_empty(&fimc->pending_buf_q)) {
 		buf = fimc_lite_pending_queue_pop(fimc);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
 	/* If suspending put unused buffers onto pending queue */
 	while (!list_empty(&fimc->active_buf_q)) {
@@ -208,7 +208,7 @@ static int fimc_lite_reinit(struct fimc_lite *fimc, bool suspend)
 		if (suspend)
 			fimc_lite_pending_queue_add(fimc, buf);
 		else
-			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+			vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
 
 	spin_unlock_irqrestore(&fimc->slock, flags);
@@ -295,12 +295,12 @@ static irqreturn_t flite_irq_handler(int irq, void *priv)
 	    !list_empty(&fimc->active_buf_q)) {
 		vbuf = fimc_lite_active_queue_pop(fimc);
 		ktime_get_ts(&ts);
-		tv = &vbuf->vb.v4l2_buf.timestamp;
+		tv = &vbuf->vb.timestamp;
 		tv->tv_sec = ts.tv_sec;
 		tv->tv_usec = ts.tv_nsec / NSEC_PER_USEC;
-		vbuf->vb.v4l2_buf.sequence = fimc->frame_count++;
+		vbuf->vb.sequence = fimc->frame_count++;
 		flite_hw_mask_dma_buffer(fimc, vbuf->index);
-		vb2_buffer_done(&vbuf->vb, VB2_BUF_STATE_DONE);
+		vb2_buffer_done(&vbuf->vb.vb2_buf, VB2_BUF_STATE_DONE);
 	}
 
 	if (test_bit(ST_FLITE_CONFIG, &fimc->state))
@@ -422,8 +422,9 @@ static int buffer_prepare(struct vb2_buffer *vb)
 
 static void buffer_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct flite_buffer *buf
-		= container_of(vb, struct flite_buffer, vb);
+		= container_of(vbuf, struct flite_buffer, vb);
 	struct fimc_lite *fimc = vb2_get_drv_priv(vb->vb2_queue);
 	unsigned long flags;
 
@@ -1637,7 +1638,7 @@ static int fimc_lite_resume(struct device *dev)
 		if (list_empty(&fimc->pending_buf_q))
 			break;
 		buf = fimc_lite_pending_queue_pop(fimc);
-		buffer_queue(&buf->vb);
+		buffer_queue(&buf->vb.vb2_buf);
 	}
 	return 0;
 }
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.h b/drivers/media/platform/exynos4-is/fimc-lite.h
index 7e4c708..b302305 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.h
+++ b/drivers/media/platform/exynos4-is/fimc-lite.h
@@ -100,7 +100,7 @@ struct flite_frame {
  * @index: DMA start address register's index
  */
 struct flite_buffer {
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head list;
 	dma_addr_t paddr;
 	unsigned short index;
diff --git a/drivers/media/platform/exynos4-is/fimc-m2m.c b/drivers/media/platform/exynos4-is/fimc-m2m.c
index 07bfddb..79b8a3b 100644
--- a/drivers/media/platform/exynos4-is/fimc-m2m.c
+++ b/drivers/media/platform/exynos4-is/fimc-m2m.c
@@ -42,7 +42,7 @@ static unsigned int get_m2m_fmt_flags(unsigned int stream_type)
 
 void fimc_m2m_job_finish(struct fimc_ctx *ctx, int vb_state)
 {
-	struct vb2_buffer *src_vb, *dst_vb;
+	struct vb2_v4l2_buffer *src_vb, *dst_vb;
 
 	if (!ctx || !ctx->fh.m2m_ctx)
 		return;
@@ -99,7 +99,7 @@ static void stop_streaming(struct vb2_queue *q)
 
 static void fimc_device_run(void *priv)
 {
-	struct vb2_buffer *src_vb, *dst_vb;
+	struct vb2_v4l2_buffer *src_vb, *dst_vb;
 	struct fimc_ctx *ctx = priv;
 	struct fimc_frame *sf, *df;
 	struct fimc_dev *fimc;
@@ -123,19 +123,19 @@ static void fimc_device_run(void *priv)
 	}
 
 	src_vb = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
-	ret = fimc_prepare_addr(ctx, src_vb, sf, &sf->paddr);
+	ret = fimc_prepare_addr(ctx, &src_vb->vb2_buf, sf, &sf->paddr);
 	if (ret)
 		goto dma_unlock;
 
 	dst_vb = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
-	ret = fimc_prepare_addr(ctx, dst_vb, df, &df->paddr);
+	ret = fimc_prepare_addr(ctx, &dst_vb->vb2_buf, df, &df->paddr);
 	if (ret)
 		goto dma_unlock;
 
-	dst_vb->v4l2_buf.timestamp = src_vb->v4l2_buf.timestamp;
-	dst_vb->v4l2_buf.flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
-	dst_vb->v4l2_buf.flags |=
-		src_vb->v4l2_buf.flags & V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
+	dst_vb->timestamp = src_vb->timestamp;
+	dst_vb->flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
+	dst_vb->flags |=
+		src_vb->flags & V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
 
 	/* Reconfigure hardware if the context has changed. */
 	if (fimc->m2m.ctx != ctx) {
@@ -220,8 +220,9 @@ static int fimc_buf_prepare(struct vb2_buffer *vb)
 
 static void fimc_buf_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct fimc_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
-	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vb);
+	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vbuf);
 }
 
 static struct vb2_ops fimc_qops = {
diff --git a/drivers/media/platform/m2m-deinterlace.c b/drivers/media/platform/m2m-deinterlace.c
index c07f367..bdd8f11 100644
--- a/drivers/media/platform/m2m-deinterlace.c
+++ b/drivers/media/platform/m2m-deinterlace.c
@@ -200,18 +200,18 @@ static void dma_callback(void *data)
 {
 	struct deinterlace_ctx *curr_ctx = data;
 	struct deinterlace_dev *pcdev = curr_ctx->dev;
-	struct vb2_buffer *src_vb, *dst_vb;
+	struct vb2_v4l2_buffer *src_vb, *dst_vb;
 
 	atomic_set(&pcdev->busy, 0);
 
 	src_vb = v4l2_m2m_src_buf_remove(curr_ctx->m2m_ctx);
 	dst_vb = v4l2_m2m_dst_buf_remove(curr_ctx->m2m_ctx);
 
-	dst_vb->v4l2_buf.timestamp = src_vb->v4l2_buf.timestamp;
-	dst_vb->v4l2_buf.flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
-	dst_vb->v4l2_buf.flags |=
-		src_vb->v4l2_buf.flags & V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
-	dst_vb->v4l2_buf.timecode = src_vb->v4l2_buf.timecode;
+	dst_vb->timestamp = src_vb->timestamp;
+	dst_vb->flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
+	dst_vb->flags |=
+		src_vb->flags & V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
+	dst_vb->timecode = src_vb->timecode;
 
 	v4l2_m2m_buf_done(src_vb, VB2_BUF_STATE_DONE);
 	v4l2_m2m_buf_done(dst_vb, VB2_BUF_STATE_DONE);
@@ -225,7 +225,7 @@ static void deinterlace_issue_dma(struct deinterlace_ctx *ctx, int op,
 				  int do_callback)
 {
 	struct deinterlace_q_data *s_q_data;
-	struct vb2_buffer *src_buf, *dst_buf;
+	struct vb2_v4l2_buffer *src_buf, *dst_buf;
 	struct deinterlace_dev *pcdev = ctx->dev;
 	struct dma_chan *chan = pcdev->dma_chan;
 	struct dma_device *dmadev = chan->device;
@@ -243,8 +243,9 @@ static void deinterlace_issue_dma(struct deinterlace_ctx *ctx, int op,
 	s_height = s_q_data->height;
 	s_size = s_width * s_height;
 
-	p_in = (dma_addr_t)vb2_dma_contig_plane_dma_addr(src_buf, 0);
-	p_out = (dma_addr_t)vb2_dma_contig_plane_dma_addr(dst_buf, 0);
+	p_in = (dma_addr_t)vb2_dma_contig_plane_dma_addr(&src_buf->vb2_buf, 0);
+	p_out = (dma_addr_t)vb2_dma_contig_plane_dma_addr(&dst_buf->vb2_buf,
+							  0);
 	if (!p_in || !p_out) {
 		v4l2_err(&pcdev->v4l2_dev,
 			 "Acquiring kernel pointers to buffers failed\n");
@@ -849,8 +850,10 @@ static int deinterlace_buf_prepare(struct vb2_buffer *vb)
 
 static void deinterlace_buf_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct deinterlace_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
-	v4l2_m2m_buf_queue(ctx->m2m_ctx, vb);
+
+	v4l2_m2m_buf_queue(ctx->m2m_ctx, vbuf);
 }
 
 static struct vb2_ops deinterlace_qops = {
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index 5e2b4df..1d95842 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -201,18 +201,18 @@ struct mcam_dma_desc {
 
 /*
  * Our buffer type for working with videobuf2.  Note that the vb2
- * developers have decreed that struct vb2_buffer must be at the
+ * developers have decreed that struct vb2_v4l2_buffer must be at the
  * beginning of this structure.
  */
 struct mcam_vb_buffer {
-	struct vb2_buffer vb_buf;
+	struct vb2_v4l2_buffer vb_buf;
 	struct list_head queue;
 	struct mcam_dma_desc *dma_desc;	/* Descriptor virtual address */
 	dma_addr_t dma_desc_pa;		/* Descriptor physical address */
 	int dma_desc_nent;		/* Number of mapped descriptors */
 };
 
-static inline struct mcam_vb_buffer *vb_to_mvb(struct vb2_buffer *vb)
+static inline struct mcam_vb_buffer *vb_to_mvb(struct vb2_v4l2_buffer *vb)
 {
 	return container_of(vb, struct mcam_vb_buffer, vb_buf);
 }
@@ -221,14 +221,14 @@ static inline struct mcam_vb_buffer *vb_to_mvb(struct vb2_buffer *vb)
  * Hand a completed buffer back to user space.
  */
 static void mcam_buffer_done(struct mcam_camera *cam, int frame,
-		struct vb2_buffer *vbuf)
+		struct vb2_v4l2_buffer *vbuf)
 {
-	vbuf->v4l2_buf.bytesused = cam->pix_format.sizeimage;
-	vbuf->v4l2_buf.sequence = cam->buf_seq[frame];
-	vbuf->v4l2_buf.field = V4L2_FIELD_NONE;
-	v4l2_get_timestamp(&vbuf->v4l2_buf.timestamp);
-	vb2_set_plane_payload(vbuf, 0, cam->pix_format.sizeimage);
-	vb2_buffer_done(vbuf, VB2_BUF_STATE_DONE);
+	vbuf->vb2_buf.planes[0].bytesused = cam->pix_format.sizeimage;
+	vbuf->sequence = cam->buf_seq[frame];
+	vbuf->field = V4L2_FIELD_NONE;
+	v4l2_get_timestamp(&vbuf->timestamp);
+	vb2_set_plane_payload(&vbuf->vb2_buf, 0, cam->pix_format.sizeimage);
+	vb2_buffer_done(&vbuf->vb2_buf, VB2_BUF_STATE_DONE);
 }
 
 
@@ -482,7 +482,8 @@ static void mcam_frame_tasklet(unsigned long data)
 		 * Drop the lock during the big copy.  This *should* be safe...
 		 */
 		spin_unlock_irqrestore(&cam->dev_lock, flags);
-		memcpy(vb2_plane_vaddr(&buf->vb_buf, 0), cam->dma_bufs[bufno],
+		memcpy(vb2_plane_vaddr(&buf->vb_buf.vb2_buf, 0),
+				cam->dma_bufs[bufno],
 				cam->pix_format.sizeimage);
 		mcam_buffer_done(cam, bufno, &buf->vb_buf);
 		spin_lock_irqsave(&cam->dev_lock, flags);
@@ -548,7 +549,7 @@ static void mcam_set_contig_buffer(struct mcam_camera *cam, int frame)
 {
 	struct mcam_vb_buffer *buf;
 	dma_addr_t dma_handle;
-	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vb;
 
 	/*
 	 * If there are no available buffers, go into single mode
@@ -570,7 +571,7 @@ static void mcam_set_contig_buffer(struct mcam_camera *cam, int frame)
 	cam->vb_bufs[frame] = buf;
 	vb = &buf->vb_buf;
 
-	dma_handle = vb2_dma_contig_plane_dma_addr(vb, 0);
+	dma_handle = vb2_dma_contig_plane_dma_addr(&vb->vb2_buf, 0);
 	mcam_write_yuv_bases(cam, frame, dma_handle);
 }
 
@@ -1071,7 +1072,8 @@ static int mcam_vb_queue_setup(struct vb2_queue *vq,
 
 static void mcam_vb_buf_queue(struct vb2_buffer *vb)
 {
-	struct mcam_vb_buffer *mvb = vb_to_mvb(vb);
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct mcam_vb_buffer *mvb = vb_to_mvb(vbuf);
 	struct mcam_camera *cam = vb2_get_drv_priv(vb->vb2_queue);
 	unsigned long flags;
 	int start;
@@ -1096,14 +1098,14 @@ static void mcam_vb_requeue_bufs(struct vb2_queue *vq,
 
 	spin_lock_irqsave(&cam->dev_lock, flags);
 	list_for_each_entry_safe(buf, node, &cam->buffers, queue) {
-		vb2_buffer_done(&buf->vb_buf, state);
+		vb2_buffer_done(&buf->vb_buf.vb2_buf, state);
 		list_del(&buf->queue);
 	}
 	for (i = 0; i < MAX_DMA_BUFS; i++) {
 		buf = cam->vb_bufs[i];
 
 		if (buf) {
-			vb2_buffer_done(&buf->vb_buf, state);
+			vb2_buffer_done(&buf->vb_buf.vb2_buf, state);
 			cam->vb_bufs[i] = NULL;
 		}
 	}
@@ -1198,7 +1200,8 @@ static const struct vb2_ops mcam_vb2_ops = {
  */
 static int mcam_vb_sg_buf_init(struct vb2_buffer *vb)
 {
-	struct mcam_vb_buffer *mvb = vb_to_mvb(vb);
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct mcam_vb_buffer *mvb = vb_to_mvb(vbuf);
 	struct mcam_camera *cam = vb2_get_drv_priv(vb->vb2_queue);
 	int ndesc = cam->pix_format.sizeimage/PAGE_SIZE + 1;
 
@@ -1214,7 +1217,8 @@ static int mcam_vb_sg_buf_init(struct vb2_buffer *vb)
 
 static int mcam_vb_sg_buf_prepare(struct vb2_buffer *vb)
 {
-	struct mcam_vb_buffer *mvb = vb_to_mvb(vb);
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct mcam_vb_buffer *mvb = vb_to_mvb(vbuf);
 	struct sg_table *sg_table = vb2_dma_sg_plane_desc(vb, 0);
 	struct mcam_dma_desc *desc = mvb->dma_desc;
 	struct scatterlist *sg;
@@ -1230,8 +1234,9 @@ static int mcam_vb_sg_buf_prepare(struct vb2_buffer *vb)
 
 static void mcam_vb_sg_buf_cleanup(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct mcam_camera *cam = vb2_get_drv_priv(vb->vb2_queue);
-	struct mcam_vb_buffer *mvb = vb_to_mvb(vb);
+	struct mcam_vb_buffer *mvb = vb_to_mvb(vbuf);
 	int ndesc = cam->pix_format.sizeimage/PAGE_SIZE + 1;
 
 	dma_free_coherent(cam->dev, ndesc * sizeof(struct mcam_dma_desc),
diff --git a/drivers/media/platform/mx2_emmaprp.c b/drivers/media/platform/mx2_emmaprp.c
index 87314b7..b7cea27 100644
--- a/drivers/media/platform/mx2_emmaprp.c
+++ b/drivers/media/platform/mx2_emmaprp.c
@@ -351,7 +351,7 @@ static irqreturn_t emmaprp_irq(int irq_emma, void *data)
 {
 	struct emmaprp_dev *pcdev = data;
 	struct emmaprp_ctx *curr_ctx;
-	struct vb2_buffer *src_vb, *dst_vb;
+	struct vb2_v4l2_buffer *src_vb, *dst_vb;
 	unsigned long flags;
 	u32 irqst;
 
@@ -375,13 +375,13 @@ static irqreturn_t emmaprp_irq(int irq_emma, void *data)
 			src_vb = v4l2_m2m_src_buf_remove(curr_ctx->m2m_ctx);
 			dst_vb = v4l2_m2m_dst_buf_remove(curr_ctx->m2m_ctx);
 
-			dst_vb->v4l2_buf.timestamp = src_vb->v4l2_buf.timestamp;
-			dst_vb->v4l2_buf.flags &=
+			dst_vb->timestamp = src_vb->timestamp;
+			dst_vb->flags &=
 				~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
-			dst_vb->v4l2_buf.flags |=
-				src_vb->v4l2_buf.flags
+			dst_vb->flags |=
+				src_vb->flags
 				& V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
-			dst_vb->v4l2_buf.timecode = src_vb->v4l2_buf.timecode;
+			dst_vb->timecode = src_vb->timecode;
 
 			spin_lock_irqsave(&pcdev->irqlock, flags);
 			v4l2_m2m_buf_done(src_vb, VB2_BUF_STATE_DONE);
@@ -742,8 +742,9 @@ static int emmaprp_buf_prepare(struct vb2_buffer *vb)
 
 static void emmaprp_buf_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct emmaprp_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
-	v4l2_m2m_buf_queue(ctx->m2m_ctx, vb);
+	v4l2_m2m_buf_queue(ctx->m2m_ctx, vbuf);
 }
 
 static struct vb2_ops emmaprp_qops = {
diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index 41bb8df..786cc85 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -342,8 +342,9 @@ static int isp_video_queue_setup(struct vb2_queue *queue,
 
 static int isp_video_buffer_prepare(struct vb2_buffer *buf)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(buf);
 	struct isp_video_fh *vfh = vb2_get_drv_priv(buf->vb2_queue);
-	struct isp_buffer *buffer = to_isp_buffer(buf);
+	struct isp_buffer *buffer = to_isp_buffer(vbuf);
 	struct isp_video *video = vfh->video;
 	dma_addr_t addr;
 
@@ -363,7 +364,8 @@ static int isp_video_buffer_prepare(struct vb2_buffer *buf)
 		return -EINVAL;
 	}
 
-	vb2_set_plane_payload(&buffer->vb, 0, vfh->format.fmt.pix.sizeimage);
+	vb2_set_plane_payload(&buffer->vb.vb2_buf, 0,
+			      vfh->format.fmt.pix.sizeimage);
 	buffer->dma = addr;
 
 	return 0;
@@ -380,8 +382,9 @@ static int isp_video_buffer_prepare(struct vb2_buffer *buf)
  */
 static void isp_video_buffer_queue(struct vb2_buffer *buf)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(buf);
 	struct isp_video_fh *vfh = vb2_get_drv_priv(buf->vb2_queue);
-	struct isp_buffer *buffer = to_isp_buffer(buf);
+	struct isp_buffer *buffer = to_isp_buffer(vbuf);
 	struct isp_video *video = vfh->video;
 	struct isp_pipeline *pipe = to_isp_pipeline(&video->video.entity);
 	enum isp_pipeline_state state;
@@ -392,7 +395,7 @@ static void isp_video_buffer_queue(struct vb2_buffer *buf)
 	spin_lock_irqsave(&video->irqlock, flags);
 
 	if (unlikely(video->error)) {
-		vb2_buffer_done(&buffer->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buffer->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 		spin_unlock_irqrestore(&video->irqlock, flags);
 		return;
 	}
@@ -464,7 +467,7 @@ struct isp_buffer *omap3isp_video_buffer_next(struct isp_video *video)
 	list_del(&buf->irqlist);
 	spin_unlock_irqrestore(&video->irqlock, flags);
 
-	v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
+	v4l2_get_timestamp(&buf->vb.timestamp);
 
 	/* Do frame number propagation only if this is the output video node.
 	 * Frame number either comes from the CSI receivers or it gets
@@ -473,15 +476,15 @@ struct isp_buffer *omap3isp_video_buffer_next(struct isp_video *video)
 	 * first, so the input number might lag behind by 1 in some cases.
 	 */
 	if (video == pipe->output && !pipe->do_propagation)
-		buf->vb.v4l2_buf.sequence =
+		buf->vb.sequence =
 			atomic_inc_return(&pipe->frame_number);
 	else
-		buf->vb.v4l2_buf.sequence = atomic_read(&pipe->frame_number);
+		buf->vb.sequence = atomic_read(&pipe->frame_number);
 
 	if (pipe->field != V4L2_FIELD_NONE)
-		buf->vb.v4l2_buf.sequence /= 2;
+		buf->vb.sequence /= 2;
 
-	buf->vb.v4l2_buf.field = pipe->field;
+	buf->vb.field = pipe->field;
 
 	/* Report pipeline errors to userspace on the capture device side. */
 	if (video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE && pipe->error) {
@@ -491,7 +494,7 @@ struct isp_buffer *omap3isp_video_buffer_next(struct isp_video *video)
 		state = VB2_BUF_STATE_DONE;
 	}
 
-	vb2_buffer_done(&buf->vb, state);
+	vb2_buffer_done(&buf->vb.vb2_buf, state);
 
 	spin_lock_irqsave(&video->irqlock, flags);
 
@@ -546,7 +549,7 @@ void omap3isp_video_cancel_stream(struct isp_video *video)
 		buf = list_first_entry(&video->dmaqueue,
 				       struct isp_buffer, irqlist);
 		list_del(&buf->irqlist);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
 
 	video->error = true;
diff --git a/drivers/media/platform/omap3isp/ispvideo.h b/drivers/media/platform/omap3isp/ispvideo.h
index 31c2445..bcf0e0a 100644
--- a/drivers/media/platform/omap3isp/ispvideo.h
+++ b/drivers/media/platform/omap3isp/ispvideo.h
@@ -122,7 +122,7 @@ static inline int isp_pipeline_ready(struct isp_pipeline *pipe)
  * @dma: DMA address
  */
 struct isp_buffer {
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head irqlist;
 	dma_addr_t dma;
 };
diff --git a/drivers/media/platform/rcar_jpu.c b/drivers/media/platform/rcar_jpu.c
index 18e62d0..7533b9e 100644
--- a/drivers/media/platform/rcar_jpu.c
+++ b/drivers/media/platform/rcar_jpu.c
@@ -471,7 +471,7 @@ static const char *error_to_text[16] = {
 	"Unknown"
 };
 
-static struct jpu_buffer *vb2_to_jpu_buffer(struct vb2_buffer *vb)
+static struct jpu_buffer *vb2_to_jpu_buffer(struct vb2_v4l2_buffer *vb)
 {
 	struct v4l2_m2m_buffer *b =
 		container_of(vb, struct v4l2_m2m_buffer, vb);
@@ -1044,6 +1044,7 @@ static int jpu_queue_setup(struct vb2_queue *vq,
 
 static int jpu_buf_prepare(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct jpu_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
 	struct jpu_q_data *q_data;
 	unsigned int i;
@@ -1051,9 +1052,9 @@ static int jpu_buf_prepare(struct vb2_buffer *vb)
 	q_data = jpu_get_q_data(ctx, vb->vb2_queue->type);
 
 	if (V4L2_TYPE_IS_OUTPUT(vb->vb2_queue->type)) {
-		if (vb->v4l2_buf.field == V4L2_FIELD_ANY)
-			vb->v4l2_buf.field = V4L2_FIELD_NONE;
-		if (vb->v4l2_buf.field != V4L2_FIELD_NONE) {
+		if (vbuf->field == V4L2_FIELD_ANY)
+			vbuf->field = V4L2_FIELD_NONE;
+		if (vbuf->field != V4L2_FIELD_NONE) {
 			dev_err(ctx->jpu->dev, "%s field isn't supported\n",
 					__func__);
 			return -EINVAL;
@@ -1080,10 +1081,11 @@ static int jpu_buf_prepare(struct vb2_buffer *vb)
 
 static void jpu_buf_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct jpu_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
 
 	if (!ctx->encoder && V4L2_TYPE_IS_OUTPUT(vb->vb2_queue->type)) {
-		struct jpu_buffer *jpu_buf = vb2_to_jpu_buffer(vb);
+		struct jpu_buffer *jpu_buf = vb2_to_jpu_buffer(vbuf);
 		struct jpu_q_data *q_data, adjust;
 		void *buffer = vb2_plane_vaddr(vb, 0);
 		unsigned long buf_size = vb2_get_plane_payload(vb, 0);
@@ -1117,7 +1119,7 @@ static void jpu_buf_queue(struct vb2_buffer *vb)
 	}
 
 	if (ctx->fh.m2m_ctx)
-		v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vb);
+		v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vbuf);
 
 	return;
 
@@ -1128,14 +1130,15 @@ format_error:
 
 static void jpu_buf_finish(struct vb2_buffer *vb)
 {
-	struct jpu_buffer *jpu_buf = vb2_to_jpu_buffer(vb);
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct jpu_buffer *jpu_buf = vb2_to_jpu_buffer(vbuf);
 	struct jpu_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
 	struct jpu_q_data *q_data = &ctx->out_q;
 	enum v4l2_buf_type type = vb->vb2_queue->type;
 	u8 *buffer;
 
 	if (vb->state == VB2_BUF_STATE_DONE)
-		vb->v4l2_buf.sequence = jpu_get_q_data(ctx, type)->sequence++;
+		vbuf->sequence = jpu_get_q_data(ctx, type)->sequence++;
 
 	if (!ctx->encoder || vb->state != VB2_BUF_STATE_DONE ||
 	    V4L2_TYPE_IS_OUTPUT(type))
@@ -1163,7 +1166,7 @@ static int jpu_start_streaming(struct vb2_queue *vq, unsigned count)
 static void jpu_stop_streaming(struct vb2_queue *vq)
 {
 	struct jpu_ctx *ctx = vb2_get_drv_priv(vq);
-	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vb;
 	unsigned long flags;
 
 	for (;;) {
@@ -1327,7 +1330,7 @@ static const struct v4l2_file_operations jpu_fops = {
 static void jpu_cleanup(struct jpu_ctx *ctx, bool reset)
 {
 	/* remove current buffers and finish job */
-	struct vb2_buffer *src_buf, *dst_buf;
+	struct vb2_v4l2_buffer *src_buf, *dst_buf;
 	unsigned long flags;
 
 	spin_lock_irqsave(&ctx->jpu->lock, flags);
@@ -1353,7 +1356,7 @@ static void jpu_device_run(void *priv)
 	struct jpu *jpu = ctx->jpu;
 	struct jpu_buffer *jpu_buf;
 	struct jpu_q_data *q_data;
-	struct vb2_buffer *src_buf, *dst_buf;
+	struct vb2_v4l2_buffer *src_buf, *dst_buf;
 	unsigned int w, h, bpl;
 	unsigned char num_planes, subsampling;
 	unsigned long flags;
@@ -1389,10 +1392,12 @@ static void jpu_device_run(void *priv)
 		unsigned long src_1_addr, src_2_addr, dst_addr;
 		unsigned int redu, inft;
 
-		dst_addr = vb2_dma_contig_plane_dma_addr(dst_buf, 0);
-		src_1_addr = vb2_dma_contig_plane_dma_addr(src_buf, 0);
+		dst_addr = vb2_dma_contig_plane_dma_addr(&dst_buf->vb2_buf, 0);
+		src_1_addr =
+			vb2_dma_contig_plane_dma_addr(&src_buf->vb2_buf, 0);
 		if (num_planes > 1)
-			src_2_addr = vb2_dma_contig_plane_dma_addr(src_buf, 1);
+			src_2_addr = vb2_dma_contig_plane_dma_addr(
+					&src_buf->vb2_buf, 1);
 		else
 			src_2_addr = src_1_addr + w * h;
 
@@ -1453,10 +1458,12 @@ static void jpu_device_run(void *priv)
 			return;
 		}
 
-		src_addr = vb2_dma_contig_plane_dma_addr(src_buf, 0);
-		dst_1_addr = vb2_dma_contig_plane_dma_addr(dst_buf, 0);
+		src_addr = vb2_dma_contig_plane_dma_addr(&src_buf->vb2_buf, 0);
+		dst_1_addr =
+			vb2_dma_contig_plane_dma_addr(&dst_buf->vb2_buf, 0);
 		if (q_data->fmtinfo->num_planes > 1)
-			dst_2_addr = vb2_dma_contig_plane_dma_addr(dst_buf, 1);
+			dst_2_addr = vb2_dma_contig_plane_dma_addr(
+					&dst_buf->vb2_buf, 1);
 		else
 			dst_2_addr = dst_1_addr + w * h;
 
@@ -1511,7 +1518,7 @@ static irqreturn_t jpu_irq_handler(int irq, void *dev_id)
 {
 	struct jpu *jpu = dev_id;
 	struct jpu_ctx *curr_ctx;
-	struct vb2_buffer *src_buf, *dst_buf;
+	struct vb2_v4l2_buffer *src_buf, *dst_buf;
 	unsigned int int_status;
 
 	int_status = jpu_read(jpu, JINTS);
@@ -1547,18 +1554,18 @@ static irqreturn_t jpu_irq_handler(int irq, void *dev_id)
 			unsigned long payload_size = jpu_read(jpu, JCDTCU) << 16
 						   | jpu_read(jpu, JCDTCM) << 8
 						   | jpu_read(jpu, JCDTCD);
-			vb2_set_plane_payload(dst_buf, 0,
+			vb2_set_plane_payload(&dst_buf->vb2_buf, 0,
 				payload_size + JPU_JPEG_HDR_SIZE);
 		}
 
-		dst_buf->v4l2_buf.field = src_buf->v4l2_buf.field;
-		dst_buf->v4l2_buf.timestamp = src_buf->v4l2_buf.timestamp;
-		if (src_buf->v4l2_buf.flags & V4L2_BUF_FLAG_TIMECODE)
-			dst_buf->v4l2_buf.timecode = src_buf->v4l2_buf.timecode;
-		dst_buf->v4l2_buf.flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
-		dst_buf->v4l2_buf.flags |= src_buf->v4l2_buf.flags &
+		dst_buf->field = src_buf->field;
+		dst_buf->timestamp = src_buf->timestamp;
+		if (src_buf->flags & V4L2_BUF_FLAG_TIMECODE)
+			dst_buf->timecode = src_buf->timecode;
+		dst_buf->flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
+		dst_buf->flags |= src_buf->flags &
 					V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
-		dst_buf->v4l2_buf.flags = src_buf->v4l2_buf.flags &
+		dst_buf->flags = src_buf->flags &
 			(V4L2_BUF_FLAG_TIMECODE | V4L2_BUF_FLAG_KEYFRAME |
 			 V4L2_BUF_FLAG_PFRAME | V4L2_BUF_FLAG_BFRAME |
 			 V4L2_BUF_FLAG_TSTAMP_SRC_MASK);
diff --git a/drivers/media/platform/s3c-camif/camif-capture.c b/drivers/media/platform/s3c-camif/camif-capture.c
index bb01eaa..9df34c7 100644
--- a/drivers/media/platform/s3c-camif/camif-capture.c
+++ b/drivers/media/platform/s3c-camif/camif-capture.c
@@ -164,12 +164,12 @@ static int camif_reinitialize(struct camif_vp *vp)
 	/* Release unused buffers */
 	while (!list_empty(&vp->pending_buf_q)) {
 		buf = camif_pending_queue_pop(vp);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
 
 	while (!list_empty(&vp->active_buf_q)) {
 		buf = camif_active_queue_pop(vp);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
 
 	spin_unlock_irqrestore(&camif->slock, flags);
@@ -342,11 +342,11 @@ irqreturn_t s3c_camif_irq_handler(int irq, void *priv)
 
 		if (!WARN_ON(vbuf == NULL)) {
 			/* Dequeue a filled buffer */
-			tv = &vbuf->vb.v4l2_buf.timestamp;
+			tv = &vbuf->vb.timestamp;
 			tv->tv_sec = ts.tv_sec;
 			tv->tv_usec = ts.tv_nsec / NSEC_PER_USEC;
-			vbuf->vb.v4l2_buf.sequence = vp->frame_sequence++;
-			vb2_buffer_done(&vbuf->vb, VB2_BUF_STATE_DONE);
+			vbuf->vb.sequence = vp->frame_sequence++;
+			vb2_buffer_done(&vbuf->vb.vb2_buf, VB2_BUF_STATE_DONE);
 
 			/* Set up an empty buffer at the DMA engine */
 			vbuf = camif_pending_queue_pop(vp);
@@ -496,13 +496,14 @@ static int buffer_prepare(struct vb2_buffer *vb)
 
 static void buffer_queue(struct vb2_buffer *vb)
 {
-	struct camif_buffer *buf = container_of(vb, struct camif_buffer, vb);
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct camif_buffer *buf = container_of(vbuf, struct camif_buffer, vb);
 	struct camif_vp *vp = vb2_get_drv_priv(vb->vb2_queue);
 	struct camif_dev *camif = vp->camif;
 	unsigned long flags;
 
 	spin_lock_irqsave(&camif->slock, flags);
-	WARN_ON(camif_prepare_addr(vp, &buf->vb, &buf->paddr));
+	WARN_ON(camif_prepare_addr(vp, &buf->vb.vb2_buf, &buf->paddr));
 
 	if (!(vp->state & ST_VP_STREAMING) && vp->active_buffers < 2) {
 		/* Schedule an empty buffer in H/W */
diff --git a/drivers/media/platform/s3c-camif/camif-core.h b/drivers/media/platform/s3c-camif/camif-core.h
index 8ef6f26..adaf196 100644
--- a/drivers/media/platform/s3c-camif/camif-core.h
+++ b/drivers/media/platform/s3c-camif/camif-core.h
@@ -322,7 +322,7 @@ struct camif_addr {
  * @index: an identifier of this buffer at the DMA engine
  */
 struct camif_buffer {
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head list;
 	struct camif_addr paddr;
 	unsigned int index;
diff --git a/drivers/media/platform/s5p-g2d/g2d.c b/drivers/media/platform/s5p-g2d/g2d.c
index 81483da..4db507a 100644
--- a/drivers/media/platform/s5p-g2d/g2d.c
+++ b/drivers/media/platform/s5p-g2d/g2d.c
@@ -134,8 +134,9 @@ static int g2d_buf_prepare(struct vb2_buffer *vb)
 
 static void g2d_buf_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct g2d_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
-	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vb);
+	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vbuf);
 }
 
 static struct vb2_ops g2d_qops = {
@@ -537,7 +538,7 @@ static irqreturn_t g2d_isr(int irq, void *prv)
 {
 	struct g2d_dev *dev = prv;
 	struct g2d_ctx *ctx = dev->curr;
-	struct vb2_buffer *src, *dst;
+	struct vb2_v4l2_buffer *src, *dst;
 
 	g2d_clear_int(dev);
 	clk_disable(dev->gate);
@@ -550,11 +551,11 @@ static irqreturn_t g2d_isr(int irq, void *prv)
 	BUG_ON(src == NULL);
 	BUG_ON(dst == NULL);
 
-	dst->v4l2_buf.timecode = src->v4l2_buf.timecode;
-	dst->v4l2_buf.timestamp = src->v4l2_buf.timestamp;
-	dst->v4l2_buf.flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
-	dst->v4l2_buf.flags |=
-		src->v4l2_buf.flags & V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
+	dst->timecode = src->timecode;
+	dst->timestamp = src->timestamp;
+	dst->flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
+	dst->flags |=
+		src->flags & V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
 
 	v4l2_m2m_buf_done(src, VB2_BUF_STATE_DONE);
 	v4l2_m2m_buf_done(dst, VB2_BUF_STATE_DONE);
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 5b1861b..d742457 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -2170,6 +2170,7 @@ static int s5p_jpeg_buf_prepare(struct vb2_buffer *vb)
 
 static void s5p_jpeg_buf_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct s5p_jpeg_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
 
 	if (ctx->mode == S5P_JPEG_DECODE &&
@@ -2193,7 +2194,7 @@ static void s5p_jpeg_buf_queue(struct vb2_buffer *vb)
 		q_data->h = tmp.h;
 	}
 
-	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vb);
+	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vbuf);
 }
 
 static int s5p_jpeg_start_streaming(struct vb2_queue *q, unsigned int count)
@@ -2264,7 +2265,7 @@ static irqreturn_t s5p_jpeg_irq(int irq, void *dev_id)
 {
 	struct s5p_jpeg *jpeg = dev_id;
 	struct s5p_jpeg_ctx *curr_ctx;
-	struct vb2_buffer *src_buf, *dst_buf;
+	struct vb2_v4l2_buffer *src_buf, *dst_buf;
 	unsigned long payload_size = 0;
 	enum vb2_buffer_state state = VB2_BUF_STATE_DONE;
 	bool enc_jpeg_too_large = false;
@@ -2298,15 +2299,15 @@ static irqreturn_t s5p_jpeg_irq(int irq, void *dev_id)
 		payload_size = s5p_jpeg_compressed_size(jpeg->regs);
 	}
 
-	dst_buf->v4l2_buf.timecode = src_buf->v4l2_buf.timecode;
-	dst_buf->v4l2_buf.timestamp = src_buf->v4l2_buf.timestamp;
-	dst_buf->v4l2_buf.flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
-	dst_buf->v4l2_buf.flags |=
-		src_buf->v4l2_buf.flags & V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
+	dst_buf->timecode = src_buf->timecode;
+	dst_buf->timestamp = src_buf->timestamp;
+	dst_buf->flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
+	dst_buf->flags |=
+		src_buf->flags & V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
 
 	v4l2_m2m_buf_done(src_buf, state);
 	if (curr_ctx->mode == S5P_JPEG_ENCODE)
-		vb2_set_plane_payload(dst_buf, 0, payload_size);
+		vb2_set_plane_payload(&dst_buf->vb2_buf, 0, payload_size);
 	v4l2_m2m_buf_done(dst_buf, state);
 	v4l2_m2m_job_finish(jpeg->m2m_dev, curr_ctx->fh.m2m_ctx);
 
@@ -2321,7 +2322,7 @@ static irqreturn_t s5p_jpeg_irq(int irq, void *dev_id)
 static irqreturn_t exynos4_jpeg_irq(int irq, void *priv)
 {
 	unsigned int int_status;
-	struct vb2_buffer *src_vb, *dst_vb;
+	struct vb2_v4l2_buffer *src_vb, *dst_vb;
 	struct s5p_jpeg *jpeg = priv;
 	struct s5p_jpeg_ctx *curr_ctx;
 	unsigned long payload_size = 0;
@@ -2363,7 +2364,8 @@ static irqreturn_t exynos4_jpeg_irq(int irq, void *priv)
 	if (jpeg->irq_ret == OK_ENC_OR_DEC) {
 		if (curr_ctx->mode == S5P_JPEG_ENCODE) {
 			payload_size = exynos4_jpeg_get_stream_size(jpeg->regs);
-			vb2_set_plane_payload(dst_vb, 0, payload_size);
+			vb2_set_plane_payload(&dst_vb->vb2_buf,
+					0, payload_size);
 		}
 		v4l2_m2m_buf_done(src_vb, VB2_BUF_STATE_DONE);
 		v4l2_m2m_buf_done(dst_vb, VB2_BUF_STATE_DONE);
@@ -2383,7 +2385,7 @@ static irqreturn_t exynos3250_jpeg_irq(int irq, void *dev_id)
 {
 	struct s5p_jpeg *jpeg = dev_id;
 	struct s5p_jpeg_ctx *curr_ctx;
-	struct vb2_buffer *src_buf, *dst_buf;
+	struct vb2_v4l2_buffer *src_buf, *dst_buf;
 	unsigned long payload_size = 0;
 	enum vb2_buffer_state state = VB2_BUF_STATE_DONE;
 	bool interrupt_timeout = false;
@@ -2427,12 +2429,12 @@ static irqreturn_t exynos3250_jpeg_irq(int irq, void *dev_id)
 	src_buf = v4l2_m2m_src_buf_remove(curr_ctx->fh.m2m_ctx);
 	dst_buf = v4l2_m2m_dst_buf_remove(curr_ctx->fh.m2m_ctx);
 
-	dst_buf->v4l2_buf.timecode = src_buf->v4l2_buf.timecode;
-	dst_buf->v4l2_buf.timestamp = src_buf->v4l2_buf.timestamp;
+	dst_buf->timecode = src_buf->timecode;
+	dst_buf->timestamp = src_buf->timestamp;
 
 	v4l2_m2m_buf_done(src_buf, state);
 	if (curr_ctx->mode == S5P_JPEG_ENCODE)
-		vb2_set_plane_payload(dst_buf, 0, payload_size);
+		vb2_set_plane_payload(&dst_buf->vb2_buf, 0, payload_size);
 	v4l2_m2m_buf_done(dst_buf, state);
 	v4l2_m2m_job_finish(jpeg->m2m_dev, curr_ctx->fh.m2m_ctx);
 
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index b3758b8..7b646c2 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -199,22 +199,22 @@ static void s5p_mfc_handle_frame_all_extracted(struct s5p_mfc_ctx *ctx)
 		dst_buf = list_entry(ctx->dst_queue.next,
 				     struct s5p_mfc_buf, list);
 		mfc_debug(2, "Cleaning up buffer: %d\n",
-					  dst_buf->b->v4l2_buf.index);
-		vb2_set_plane_payload(dst_buf->b, 0, 0);
-		vb2_set_plane_payload(dst_buf->b, 1, 0);
+					  dst_buf->b->vb2_buf.index);
+		vb2_set_plane_payload(&dst_buf->b->vb2_buf, 0, 0);
+		vb2_set_plane_payload(&dst_buf->b->vb2_buf, 1, 0);
 		list_del(&dst_buf->list);
 		ctx->dst_queue_cnt--;
-		dst_buf->b->v4l2_buf.sequence = (ctx->sequence++);
+		dst_buf->b->sequence = (ctx->sequence++);
 
 		if (s5p_mfc_hw_call(dev->mfc_ops, get_pic_type_top, ctx) ==
 			s5p_mfc_hw_call(dev->mfc_ops, get_pic_type_bot, ctx))
-			dst_buf->b->v4l2_buf.field = V4L2_FIELD_NONE;
+			dst_buf->b->field = V4L2_FIELD_NONE;
 		else
-			dst_buf->b->v4l2_buf.field = V4L2_FIELD_INTERLACED;
-		dst_buf->b->v4l2_buf.flags |= V4L2_BUF_FLAG_LAST;
+			dst_buf->b->field = V4L2_FIELD_INTERLACED;
+		dst_buf->b->flags |= V4L2_BUF_FLAG_LAST;
 
-		ctx->dec_dst_flag &= ~(1 << dst_buf->b->v4l2_buf.index);
-		vb2_buffer_done(dst_buf->b, VB2_BUF_STATE_DONE);
+		ctx->dec_dst_flag &= ~(1 << dst_buf->b->vb2_buf.index);
+		vb2_buffer_done(&dst_buf->b->vb2_buf, VB2_BUF_STATE_DONE);
 	}
 }
 
@@ -235,27 +235,28 @@ static void s5p_mfc_handle_frame_copy_time(struct s5p_mfc_ctx *ctx)
 	   appropriate flags. */
 	src_buf = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
 	list_for_each_entry(dst_buf, &ctx->dst_queue, list) {
-		if (vb2_dma_contig_plane_dma_addr(dst_buf->b, 0) == dec_y_addr) {
-			dst_buf->b->v4l2_buf.timecode =
-						src_buf->b->v4l2_buf.timecode;
-			dst_buf->b->v4l2_buf.timestamp =
-						src_buf->b->v4l2_buf.timestamp;
-			dst_buf->b->v4l2_buf.flags &=
+		if (vb2_dma_contig_plane_dma_addr(&dst_buf->b->vb2_buf, 0)
+				== dec_y_addr) {
+			dst_buf->b->timecode =
+						src_buf->b->timecode;
+			dst_buf->b->timestamp =
+						src_buf->b->timestamp;
+			dst_buf->b->flags &=
 				~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
-			dst_buf->b->v4l2_buf.flags |=
-				src_buf->b->v4l2_buf.flags
+			dst_buf->b->flags |=
+				src_buf->b->flags
 				& V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
 			switch (frame_type) {
 			case S5P_FIMV_DECODE_FRAME_I_FRAME:
-				dst_buf->b->v4l2_buf.flags |=
+				dst_buf->b->flags |=
 						V4L2_BUF_FLAG_KEYFRAME;
 				break;
 			case S5P_FIMV_DECODE_FRAME_P_FRAME:
-				dst_buf->b->v4l2_buf.flags |=
+				dst_buf->b->flags |=
 						V4L2_BUF_FLAG_PFRAME;
 				break;
 			case S5P_FIMV_DECODE_FRAME_B_FRAME:
-				dst_buf->b->v4l2_buf.flags |=
+				dst_buf->b->flags |=
 						V4L2_BUF_FLAG_BFRAME;
 				break;
 			default:
@@ -296,25 +297,28 @@ static void s5p_mfc_handle_frame_new(struct s5p_mfc_ctx *ctx, unsigned int err)
 	 * check which videobuf does it correspond to */
 	list_for_each_entry(dst_buf, &ctx->dst_queue, list) {
 		/* Check if this is the buffer we're looking for */
-		if (vb2_dma_contig_plane_dma_addr(dst_buf->b, 0) == dspl_y_addr) {
+		if (vb2_dma_contig_plane_dma_addr(&dst_buf->b->vb2_buf, 0)
+				== dspl_y_addr) {
 			list_del(&dst_buf->list);
 			ctx->dst_queue_cnt--;
-			dst_buf->b->v4l2_buf.sequence = ctx->sequence;
+			dst_buf->b->sequence = ctx->sequence;
 			if (s5p_mfc_hw_call(dev->mfc_ops,
 					get_pic_type_top, ctx) ==
 				s5p_mfc_hw_call(dev->mfc_ops,
 					get_pic_type_bot, ctx))
-				dst_buf->b->v4l2_buf.field = V4L2_FIELD_NONE;
+				dst_buf->b->field = V4L2_FIELD_NONE;
 			else
-				dst_buf->b->v4l2_buf.field =
+				dst_buf->b->field =
 							V4L2_FIELD_INTERLACED;
-			vb2_set_plane_payload(dst_buf->b, 0, ctx->luma_size);
-			vb2_set_plane_payload(dst_buf->b, 1, ctx->chroma_size);
-			clear_bit(dst_buf->b->v4l2_buf.index,
+			vb2_set_plane_payload(&dst_buf->b->vb2_buf, 0,
+						ctx->luma_size);
+			vb2_set_plane_payload(&dst_buf->b->vb2_buf, 1,
+						ctx->chroma_size);
+			clear_bit(dst_buf->b->vb2_buf.index,
 							&ctx->dec_dst_flag);
 
-			vb2_buffer_done(dst_buf->b,
-				err ? VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
+			vb2_buffer_done(&dst_buf->b->vb2_buf, err ?
+				VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
 
 			break;
 		}
@@ -395,7 +399,7 @@ static void s5p_mfc_handle_frame(struct s5p_mfc_ctx *ctx,
 		if (ctx->codec_mode != S5P_MFC_CODEC_H264_DEC &&
 			ctx->codec_mode != S5P_MFC_CODEC_VP8_DEC &&
 			ctx->consumed_stream + STUFF_BYTE <
-			src_buf->b->v4l2_planes[0].bytesused) {
+			src_buf->b->vb2_buf.planes[0].bytesused) {
 			/* Run MFC again on the same buffer */
 			mfc_debug(2, "Running again the same buffer\n");
 			ctx->after_packed_pb = 1;
@@ -407,9 +411,11 @@ static void s5p_mfc_handle_frame(struct s5p_mfc_ctx *ctx,
 			list_del(&src_buf->list);
 			ctx->src_queue_cnt--;
 			if (s5p_mfc_hw_call(dev->mfc_ops, err_dec, err) > 0)
-				vb2_buffer_done(src_buf->b, VB2_BUF_STATE_ERROR);
+				vb2_buffer_done(&src_buf->b->vb2_buf,
+						VB2_BUF_STATE_ERROR);
 			else
-				vb2_buffer_done(src_buf->b, VB2_BUF_STATE_DONE);
+				vb2_buffer_done(&src_buf->b->vb2_buf,
+						VB2_BUF_STATE_DONE);
 		}
 	}
 leave_handle_frame:
@@ -510,7 +516,7 @@ static void s5p_mfc_handle_seq_done(struct s5p_mfc_ctx *ctx,
 					struct s5p_mfc_buf, list);
 			if (s5p_mfc_hw_call(dev->mfc_ops, get_consumed_stream,
 						dev) <
-					src_buf->b->v4l2_planes[0].bytesused)
+					src_buf->b->vb2_buf.planes[0].bytesused)
 				ctx->head_processed = 0;
 			else
 				ctx->head_processed = 1;
@@ -551,7 +557,7 @@ static void s5p_mfc_handle_init_buffers(struct s5p_mfc_ctx *ctx,
 					     struct s5p_mfc_buf, list);
 				list_del(&src_buf->list);
 				ctx->src_queue_cnt--;
-				vb2_buffer_done(src_buf->b,
+				vb2_buffer_done(&src_buf->b->vb2_buf,
 						VB2_BUF_STATE_DONE);
 			}
 			spin_unlock_irqrestore(&dev->irqlock, flags);
@@ -592,8 +598,8 @@ static void s5p_mfc_handle_stream_complete(struct s5p_mfc_ctx *ctx,
 									list);
 		list_del(&mb_entry->list);
 		ctx->dst_queue_cnt--;
-		vb2_set_plane_payload(mb_entry->b, 0, 0);
-		vb2_buffer_done(mb_entry->b, VB2_BUF_STATE_DONE);
+		vb2_set_plane_payload(&mb_entry->b->vb2_buf, 0, 0);
+		vb2_buffer_done(&mb_entry->b->vb2_buf, VB2_BUF_STATE_DONE);
 	}
 	spin_unlock(&dev->irqlock);
 
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
index 10884a7..d1a3f9b 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
@@ -179,8 +179,8 @@ struct s5p_mfc_ctx;
  * struct s5p_mfc_buf - MFC buffer
  */
 struct s5p_mfc_buf {
+	struct vb2_v4l2_buffer *b;
 	struct list_head list;
-	struct vb2_buffer *b;
 	union {
 		struct {
 			size_t luma;
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index 2fd59e7..1734775 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -945,6 +945,7 @@ static int s5p_mfc_queue_setup(struct vb2_queue *vq,
 
 static int s5p_mfc_buf_init(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vb2_queue *vq = vb->vb2_queue;
 	struct s5p_mfc_ctx *ctx = fh_to_ctx(vq->drv_priv);
 	unsigned int i;
@@ -964,8 +965,8 @@ static int s5p_mfc_buf_init(struct vb2_buffer *vb)
 			mfc_err("Plane buffer (CAPTURE) is too small\n");
 			return -EINVAL;
 		}
-		i = vb->v4l2_buf.index;
-		ctx->dst_bufs[i].b = vb;
+		i = vb->index;
+		ctx->dst_bufs[i].b = vbuf;
 		ctx->dst_bufs[i].cookie.raw.luma =
 					vb2_dma_contig_plane_dma_addr(vb, 0);
 		ctx->dst_bufs[i].cookie.raw.chroma =
@@ -982,8 +983,8 @@ static int s5p_mfc_buf_init(struct vb2_buffer *vb)
 			return -EINVAL;
 		}
 
-		i = vb->v4l2_buf.index;
-		ctx->src_bufs[i].b = vb;
+		i = vb->index;
+		ctx->src_bufs[i].b = vbuf;
 		ctx->src_bufs[i].cookie.stream =
 					vb2_dma_contig_plane_dma_addr(vb, 0);
 		ctx->src_bufs_cnt++;
@@ -1065,18 +1066,18 @@ static void s5p_mfc_buf_queue(struct vb2_buffer *vb)
 	struct s5p_mfc_buf *mfc_buf;
 
 	if (vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
-		mfc_buf = &ctx->src_bufs[vb->v4l2_buf.index];
+		mfc_buf = &ctx->src_bufs[vb->index];
 		mfc_buf->flags &= ~MFC_BUF_FLAG_USED;
 		spin_lock_irqsave(&dev->irqlock, flags);
 		list_add_tail(&mfc_buf->list, &ctx->src_queue);
 		ctx->src_queue_cnt++;
 		spin_unlock_irqrestore(&dev->irqlock, flags);
 	} else if (vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
-		mfc_buf = &ctx->dst_bufs[vb->v4l2_buf.index];
+		mfc_buf = &ctx->dst_bufs[vb->index];
 		mfc_buf->flags &= ~MFC_BUF_FLAG_USED;
 		/* Mark destination as available for use by MFC */
 		spin_lock_irqsave(&dev->irqlock, flags);
-		set_bit(vb->v4l2_buf.index, &ctx->dec_dst_flag);
+		set_bit(vb->index, &ctx->dec_dst_flag);
 		list_add_tail(&mfc_buf->list, &ctx->dst_queue);
 		ctx->dst_queue_cnt++;
 		spin_unlock_irqrestore(&dev->irqlock, flags);
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index e42014c..94868f7 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -773,8 +773,8 @@ static int enc_pre_seq_start(struct s5p_mfc_ctx *ctx)
 
 	spin_lock_irqsave(&dev->irqlock, flags);
 	dst_mb = list_entry(ctx->dst_queue.next, struct s5p_mfc_buf, list);
-	dst_addr = vb2_dma_contig_plane_dma_addr(dst_mb->b, 0);
-	dst_size = vb2_plane_size(dst_mb->b, 0);
+	dst_addr = vb2_dma_contig_plane_dma_addr(&dst_mb->b->vb2_buf, 0);
+	dst_size = vb2_plane_size(&dst_mb->b->vb2_buf, 0);
 	s5p_mfc_hw_call_void(dev->mfc_ops, set_enc_stream_buffer, ctx, dst_addr,
 			dst_size);
 	spin_unlock_irqrestore(&dev->irqlock, flags);
@@ -796,10 +796,11 @@ static int enc_post_seq_start(struct s5p_mfc_ctx *ctx)
 					struct s5p_mfc_buf, list);
 			list_del(&dst_mb->list);
 			ctx->dst_queue_cnt--;
-			vb2_set_plane_payload(dst_mb->b, 0,
+			vb2_set_plane_payload(&dst_mb->b->vb2_buf, 0,
 				s5p_mfc_hw_call(dev->mfc_ops, get_enc_strm_size,
 						dev));
-			vb2_buffer_done(dst_mb->b, VB2_BUF_STATE_DONE);
+			vb2_buffer_done(&dst_mb->b->vb2_buf,
+					VB2_BUF_STATE_DONE);
 		}
 		spin_unlock_irqrestore(&dev->irqlock, flags);
 	}
@@ -831,16 +832,16 @@ static int enc_pre_frame_start(struct s5p_mfc_ctx *ctx)
 
 	spin_lock_irqsave(&dev->irqlock, flags);
 	src_mb = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
-	src_y_addr = vb2_dma_contig_plane_dma_addr(src_mb->b, 0);
-	src_c_addr = vb2_dma_contig_plane_dma_addr(src_mb->b, 1);
+	src_y_addr = vb2_dma_contig_plane_dma_addr(&src_mb->b->vb2_buf, 0);
+	src_c_addr = vb2_dma_contig_plane_dma_addr(&src_mb->b->vb2_buf, 1);
 	s5p_mfc_hw_call_void(dev->mfc_ops, set_enc_frame_buffer, ctx,
 							src_y_addr, src_c_addr);
 	spin_unlock_irqrestore(&dev->irqlock, flags);
 
 	spin_lock_irqsave(&dev->irqlock, flags);
 	dst_mb = list_entry(ctx->dst_queue.next, struct s5p_mfc_buf, list);
-	dst_addr = vb2_dma_contig_plane_dma_addr(dst_mb->b, 0);
-	dst_size = vb2_plane_size(dst_mb->b, 0);
+	dst_addr = vb2_dma_contig_plane_dma_addr(&dst_mb->b->vb2_buf, 0);
+	dst_size = vb2_plane_size(&dst_mb->b->vb2_buf, 0);
 	s5p_mfc_hw_call_void(dev->mfc_ops, set_enc_stream_buffer, ctx, dst_addr,
 			dst_size);
 	spin_unlock_irqrestore(&dev->irqlock, flags);
@@ -869,25 +870,29 @@ static int enc_post_frame_start(struct s5p_mfc_ctx *ctx)
 		s5p_mfc_hw_call_void(dev->mfc_ops, get_enc_frame_buffer, ctx,
 				&enc_y_addr, &enc_c_addr);
 		list_for_each_entry(mb_entry, &ctx->src_queue, list) {
-			mb_y_addr = vb2_dma_contig_plane_dma_addr(mb_entry->b, 0);
-			mb_c_addr = vb2_dma_contig_plane_dma_addr(mb_entry->b, 1);
+			mb_y_addr = vb2_dma_contig_plane_dma_addr(
+					&mb_entry->b->vb2_buf, 0);
+			mb_c_addr = vb2_dma_contig_plane_dma_addr(
+					&mb_entry->b->vb2_buf, 1);
 			if ((enc_y_addr == mb_y_addr) &&
 						(enc_c_addr == mb_c_addr)) {
 				list_del(&mb_entry->list);
 				ctx->src_queue_cnt--;
-				vb2_buffer_done(mb_entry->b,
+				vb2_buffer_done(&mb_entry->b->vb2_buf,
 							VB2_BUF_STATE_DONE);
 				break;
 			}
 		}
 		list_for_each_entry(mb_entry, &ctx->ref_queue, list) {
-			mb_y_addr = vb2_dma_contig_plane_dma_addr(mb_entry->b, 0);
-			mb_c_addr = vb2_dma_contig_plane_dma_addr(mb_entry->b, 1);
+			mb_y_addr = vb2_dma_contig_plane_dma_addr(
+					&mb_entry->b->vb2_buf, 0);
+			mb_c_addr = vb2_dma_contig_plane_dma_addr(
+					&mb_entry->b->vb2_buf, 1);
 			if ((enc_y_addr == mb_y_addr) &&
 						(enc_c_addr == mb_c_addr)) {
 				list_del(&mb_entry->list);
 				ctx->ref_queue_cnt--;
-				vb2_buffer_done(mb_entry->b,
+				vb2_buffer_done(&mb_entry->b->vb2_buf,
 							VB2_BUF_STATE_DONE);
 				break;
 			}
@@ -912,17 +917,17 @@ static int enc_post_frame_start(struct s5p_mfc_ctx *ctx)
 		ctx->dst_queue_cnt--;
 		switch (slice_type) {
 		case S5P_FIMV_ENC_SI_SLICE_TYPE_I:
-			mb_entry->b->v4l2_buf.flags |= V4L2_BUF_FLAG_KEYFRAME;
+			mb_entry->b->flags |= V4L2_BUF_FLAG_KEYFRAME;
 			break;
 		case S5P_FIMV_ENC_SI_SLICE_TYPE_P:
-			mb_entry->b->v4l2_buf.flags |= V4L2_BUF_FLAG_PFRAME;
+			mb_entry->b->flags |= V4L2_BUF_FLAG_PFRAME;
 			break;
 		case S5P_FIMV_ENC_SI_SLICE_TYPE_B:
-			mb_entry->b->v4l2_buf.flags |= V4L2_BUF_FLAG_BFRAME;
+			mb_entry->b->flags |= V4L2_BUF_FLAG_BFRAME;
 			break;
 		}
-		vb2_set_plane_payload(mb_entry->b, 0, strm_size);
-		vb2_buffer_done(mb_entry->b, VB2_BUF_STATE_DONE);
+		vb2_set_plane_payload(&mb_entry->b->vb2_buf, 0, strm_size);
+		vb2_buffer_done(&mb_entry->b->vb2_buf, VB2_BUF_STATE_DONE);
 	}
 	spin_unlock_irqrestore(&dev->irqlock, flags);
 	if ((ctx->src_queue_cnt == 0) || (ctx->dst_queue_cnt == 0))
@@ -1806,7 +1811,7 @@ static int check_vb_with_fmt(struct s5p_mfc_fmt *fmt, struct vb2_buffer *vb)
 			return -EINVAL;
 		}
 		mfc_debug(2, "index: %d, plane[%d] cookie: %pad\n",
-			  vb->v4l2_buf.index, i, &dma);
+			  vb->index, i, &dma);
 	}
 	return 0;
 }
@@ -1869,6 +1874,7 @@ static int s5p_mfc_queue_setup(struct vb2_queue *vq,
 
 static int s5p_mfc_buf_init(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vb2_queue *vq = vb->vb2_queue;
 	struct s5p_mfc_ctx *ctx = fh_to_ctx(vq->drv_priv);
 	unsigned int i;
@@ -1878,8 +1884,8 @@ static int s5p_mfc_buf_init(struct vb2_buffer *vb)
 		ret = check_vb_with_fmt(ctx->dst_fmt, vb);
 		if (ret < 0)
 			return ret;
-		i = vb->v4l2_buf.index;
-		ctx->dst_bufs[i].b = vb;
+		i = vb->index;
+		ctx->dst_bufs[i].b = vbuf;
 		ctx->dst_bufs[i].cookie.stream =
 					vb2_dma_contig_plane_dma_addr(vb, 0);
 		ctx->dst_bufs_cnt++;
@@ -1887,8 +1893,8 @@ static int s5p_mfc_buf_init(struct vb2_buffer *vb)
 		ret = check_vb_with_fmt(ctx->src_fmt, vb);
 		if (ret < 0)
 			return ret;
-		i = vb->v4l2_buf.index;
-		ctx->src_bufs[i].b = vb;
+		i = vb->index;
+		ctx->src_bufs[i].b = vbuf;
 		ctx->src_bufs[i].cookie.raw.luma =
 					vb2_dma_contig_plane_dma_addr(vb, 0);
 		ctx->src_bufs[i].cookie.raw.chroma =
@@ -2012,7 +2018,7 @@ static void s5p_mfc_buf_queue(struct vb2_buffer *vb)
 		return;
 	}
 	if (vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
-		mfc_buf = &ctx->dst_bufs[vb->v4l2_buf.index];
+		mfc_buf = &ctx->dst_bufs[vb->index];
 		mfc_buf->flags &= ~MFC_BUF_FLAG_USED;
 		/* Mark destination as available for use by MFC */
 		spin_lock_irqsave(&dev->irqlock, flags);
@@ -2020,7 +2026,7 @@ static void s5p_mfc_buf_queue(struct vb2_buffer *vb)
 		ctx->dst_queue_cnt++;
 		spin_unlock_irqrestore(&dev->irqlock, flags);
 	} else if (vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
-		mfc_buf = &ctx->src_bufs[vb->v4l2_buf.index];
+		mfc_buf = &ctx->src_bufs[vb->index];
 		mfc_buf->flags &= ~MFC_BUF_FLAG_USED;
 		spin_lock_irqsave(&dev->irqlock, flags);
 		list_add_tail(&mfc_buf->list, &ctx->src_queue);
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
index 6402f76..873c933 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
@@ -1208,11 +1208,11 @@ static int s5p_mfc_run_dec_frame(struct s5p_mfc_ctx *ctx, int last_frame)
 	temp_vb = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
 	temp_vb->flags |= MFC_BUF_FLAG_USED;
 	s5p_mfc_set_dec_stream_buffer_v5(ctx,
-		vb2_dma_contig_plane_dma_addr(temp_vb->b, 0),
-		ctx->consumed_stream, temp_vb->b->v4l2_planes[0].bytesused);
+		vb2_dma_contig_plane_dma_addr(&temp_vb->b->vb2_buf, 0),
+		ctx->consumed_stream, temp_vb->b->vb2_buf.planes[0].bytesused);
 	spin_unlock_irqrestore(&dev->irqlock, flags);
 	dev->curr_ctx = ctx->num;
-	if (temp_vb->b->v4l2_planes[0].bytesused == 0) {
+	if (temp_vb->b->vb2_buf.planes[0].bytesused == 0) {
 		last_frame = MFC_DEC_LAST_FRAME;
 		mfc_debug(2, "Setting ctx->state to FINISHING\n");
 		ctx->state = MFCINST_FINISHING;
@@ -1249,16 +1249,16 @@ static int s5p_mfc_run_enc_frame(struct s5p_mfc_ctx *ctx)
 		src_mb = list_entry(ctx->src_queue.next, struct s5p_mfc_buf,
 									list);
 		src_mb->flags |= MFC_BUF_FLAG_USED;
-		if (src_mb->b->v4l2_planes[0].bytesused == 0) {
+		if (src_mb->b->vb2_buf.planes[0].bytesused == 0) {
 			/* send null frame */
 			s5p_mfc_set_enc_frame_buffer_v5(ctx, dev->bank2,
 								dev->bank2);
 			ctx->state = MFCINST_FINISHING;
 		} else {
-			src_y_addr = vb2_dma_contig_plane_dma_addr(src_mb->b,
-									0);
-			src_c_addr = vb2_dma_contig_plane_dma_addr(src_mb->b,
-									1);
+			src_y_addr = vb2_dma_contig_plane_dma_addr(
+					&src_mb->b->vb2_buf, 0);
+			src_c_addr = vb2_dma_contig_plane_dma_addr(
+					&src_mb->b->vb2_buf, 1);
 			s5p_mfc_set_enc_frame_buffer_v5(ctx, src_y_addr,
 								src_c_addr);
 			if (src_mb->flags & MFC_BUF_FLAG_EOS)
@@ -1267,13 +1267,13 @@ static int s5p_mfc_run_enc_frame(struct s5p_mfc_ctx *ctx)
 	}
 	dst_mb = list_entry(ctx->dst_queue.next, struct s5p_mfc_buf, list);
 	dst_mb->flags |= MFC_BUF_FLAG_USED;
-	dst_addr = vb2_dma_contig_plane_dma_addr(dst_mb->b, 0);
-	dst_size = vb2_plane_size(dst_mb->b, 0);
+	dst_addr = vb2_dma_contig_plane_dma_addr(&dst_mb->b->vb2_buf, 0);
+	dst_size = vb2_plane_size(&dst_mb->b->vb2_buf, 0);
 	s5p_mfc_set_enc_stream_buffer_v5(ctx, dst_addr, dst_size);
 	spin_unlock_irqrestore(&dev->irqlock, flags);
 	dev->curr_ctx = ctx->num;
 	mfc_debug(2, "encoding buffer with index=%d state=%d\n",
-		  src_mb ? src_mb->b->v4l2_buf.index : -1, ctx->state);
+		  src_mb ? src_mb->b->vb2_buf.index : -1, ctx->state);
 	s5p_mfc_encode_one_frame_v5(ctx);
 	return 0;
 }
@@ -1289,10 +1289,11 @@ static void s5p_mfc_run_init_dec(struct s5p_mfc_ctx *ctx)
 	mfc_debug(2, "Preparing to init decoding\n");
 	temp_vb = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
 	s5p_mfc_set_dec_desc_buffer(ctx);
-	mfc_debug(2, "Header size: %d\n", temp_vb->b->v4l2_planes[0].bytesused);
+	mfc_debug(2, "Header size: %d\n",
+			temp_vb->b->vb2_buf.planes[0].bytesused);
 	s5p_mfc_set_dec_stream_buffer_v5(ctx,
-				vb2_dma_contig_plane_dma_addr(temp_vb->b, 0),
-				0, temp_vb->b->v4l2_planes[0].bytesused);
+			vb2_dma_contig_plane_dma_addr(&temp_vb->b->vb2_buf, 0),
+			0, temp_vb->b->vb2_buf.planes[0].bytesused);
 	spin_unlock_irqrestore(&dev->irqlock, flags);
 	dev->curr_ctx = ctx->num;
 	s5p_mfc_init_decode_v5(ctx);
@@ -1309,8 +1310,8 @@ static void s5p_mfc_run_init_enc(struct s5p_mfc_ctx *ctx)
 	s5p_mfc_set_enc_ref_buffer_v5(ctx);
 	spin_lock_irqsave(&dev->irqlock, flags);
 	dst_mb = list_entry(ctx->dst_queue.next, struct s5p_mfc_buf, list);
-	dst_addr = vb2_dma_contig_plane_dma_addr(dst_mb->b, 0);
-	dst_size = vb2_plane_size(dst_mb->b, 0);
+	dst_addr = vb2_dma_contig_plane_dma_addr(&dst_mb->b->vb2_buf, 0);
+	dst_size = vb2_plane_size(&dst_mb->b->vb2_buf, 0);
 	s5p_mfc_set_enc_stream_buffer_v5(ctx, dst_addr, dst_size);
 	spin_unlock_irqrestore(&dev->irqlock, flags);
 	dev->curr_ctx = ctx->num;
@@ -1342,10 +1343,11 @@ static int s5p_mfc_run_init_dec_buffers(struct s5p_mfc_ctx *ctx)
 		return -EIO;
 	}
 	temp_vb = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
-	mfc_debug(2, "Header size: %d\n", temp_vb->b->v4l2_planes[0].bytesused);
+	mfc_debug(2, "Header size: %d\n",
+			temp_vb->b->vb2_buf.planes[0].bytesused);
 	s5p_mfc_set_dec_stream_buffer_v5(ctx,
-				vb2_dma_contig_plane_dma_addr(temp_vb->b, 0),
-				0, temp_vb->b->v4l2_planes[0].bytesused);
+			vb2_dma_contig_plane_dma_addr(&temp_vb->b->vb2_buf, 0),
+			0, temp_vb->b->vb2_buf.planes[0].bytesused);
 	spin_unlock_irqrestore(&dev->irqlock, flags);
 	dev->curr_ctx = ctx->num;
 	ret = s5p_mfc_set_dec_frame_buffer_v5(ctx);
@@ -1478,9 +1480,9 @@ static void s5p_mfc_cleanup_queue_v5(struct list_head *lh, struct vb2_queue *vq)
 
 	while (!list_empty(lh)) {
 		b = list_entry(lh->next, struct s5p_mfc_buf, list);
-		for (i = 0; i < b->b->num_planes; i++)
-			vb2_set_plane_payload(b->b, i, 0);
-		vb2_buffer_done(b->b, VB2_BUF_STATE_ERROR);
+		for (i = 0; i < b->b->vb2_buf.num_planes; i++)
+			vb2_set_plane_payload(&b->b->vb2_buf, i, 0);
+		vb2_buffer_done(&b->b->vb2_buf, VB2_BUF_STATE_ERROR);
 		list_del(&b->list);
 	}
 }
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index e5cb30e..6e8d6c3 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -1562,13 +1562,13 @@ static inline int s5p_mfc_run_dec_frame(struct s5p_mfc_ctx *ctx)
 	temp_vb = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
 	temp_vb->flags |= MFC_BUF_FLAG_USED;
 	s5p_mfc_set_dec_stream_buffer_v6(ctx,
-		vb2_dma_contig_plane_dma_addr(temp_vb->b, 0),
-			ctx->consumed_stream,
-			temp_vb->b->v4l2_planes[0].bytesused);
+		vb2_dma_contig_plane_dma_addr(&temp_vb->b->vb2_buf, 0),
+		ctx->consumed_stream,
+		temp_vb->b->vb2_buf.planes[0].bytesused);
 	spin_unlock_irqrestore(&dev->irqlock, flags);
 
 	dev->curr_ctx = ctx->num;
-	if (temp_vb->b->v4l2_planes[0].bytesused == 0) {
+	if (temp_vb->b->vb2_buf.planes[0].bytesused == 0) {
 		last_frame = 1;
 		mfc_debug(2, "Setting ctx->state to FINISHING\n");
 		ctx->state = MFCINST_FINISHING;
@@ -1606,8 +1606,8 @@ static inline int s5p_mfc_run_enc_frame(struct s5p_mfc_ctx *ctx)
 
 	src_mb = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
 	src_mb->flags |= MFC_BUF_FLAG_USED;
-	src_y_addr = vb2_dma_contig_plane_dma_addr(src_mb->b, 0);
-	src_c_addr = vb2_dma_contig_plane_dma_addr(src_mb->b, 1);
+	src_y_addr = vb2_dma_contig_plane_dma_addr(&src_mb->b->vb2_buf, 0);
+	src_c_addr = vb2_dma_contig_plane_dma_addr(&src_mb->b->vb2_buf, 1);
 
 	mfc_debug(2, "enc src y addr: 0x%08lx\n", src_y_addr);
 	mfc_debug(2, "enc src c addr: 0x%08lx\n", src_c_addr);
@@ -1616,8 +1616,8 @@ static inline int s5p_mfc_run_enc_frame(struct s5p_mfc_ctx *ctx)
 
 	dst_mb = list_entry(ctx->dst_queue.next, struct s5p_mfc_buf, list);
 	dst_mb->flags |= MFC_BUF_FLAG_USED;
-	dst_addr = vb2_dma_contig_plane_dma_addr(dst_mb->b, 0);
-	dst_size = vb2_plane_size(dst_mb->b, 0);
+	dst_addr = vb2_dma_contig_plane_dma_addr(&dst_mb->b->vb2_buf, 0);
+	dst_size = vb2_plane_size(&dst_mb->b->vb2_buf, 0);
 
 	s5p_mfc_set_enc_stream_buffer_v6(ctx, dst_addr, dst_size);
 
@@ -1639,10 +1639,11 @@ static inline void s5p_mfc_run_init_dec(struct s5p_mfc_ctx *ctx)
 	spin_lock_irqsave(&dev->irqlock, flags);
 	mfc_debug(2, "Preparing to init decoding.\n");
 	temp_vb = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
-	mfc_debug(2, "Header size: %d\n", temp_vb->b->v4l2_planes[0].bytesused);
+	mfc_debug(2, "Header size: %d\n",
+		temp_vb->b->vb2_buf.planes[0].bytesused);
 	s5p_mfc_set_dec_stream_buffer_v6(ctx,
-		vb2_dma_contig_plane_dma_addr(temp_vb->b, 0), 0,
-			temp_vb->b->v4l2_planes[0].bytesused);
+		vb2_dma_contig_plane_dma_addr(&temp_vb->b->vb2_buf, 0), 0,
+		temp_vb->b->vb2_buf.planes[0].bytesused);
 	spin_unlock_irqrestore(&dev->irqlock, flags);
 	dev->curr_ctx = ctx->num;
 	s5p_mfc_init_decode_v6(ctx);
@@ -1659,8 +1660,8 @@ static inline void s5p_mfc_run_init_enc(struct s5p_mfc_ctx *ctx)
 	spin_lock_irqsave(&dev->irqlock, flags);
 
 	dst_mb = list_entry(ctx->dst_queue.next, struct s5p_mfc_buf, list);
-	dst_addr = vb2_dma_contig_plane_dma_addr(dst_mb->b, 0);
-	dst_size = vb2_plane_size(dst_mb->b, 0);
+	dst_addr = vb2_dma_contig_plane_dma_addr(&dst_mb->b->vb2_buf, 0);
+	dst_size = vb2_plane_size(&dst_mb->b->vb2_buf, 0);
 	s5p_mfc_set_enc_stream_buffer_v6(ctx, dst_addr, dst_size);
 	spin_unlock_irqrestore(&dev->irqlock, flags);
 	dev->curr_ctx = ctx->num;
@@ -1836,9 +1837,9 @@ static void s5p_mfc_cleanup_queue_v6(struct list_head *lh, struct vb2_queue *vq)
 
 	while (!list_empty(lh)) {
 		b = list_entry(lh->next, struct s5p_mfc_buf, list);
-		for (i = 0; i < b->b->num_planes; i++)
-			vb2_set_plane_payload(b->b, i, 0);
-		vb2_buffer_done(b->b, VB2_BUF_STATE_ERROR);
+		for (i = 0; i < b->b->vb2_buf.num_planes; i++)
+			vb2_set_plane_payload(&b->b->vb2_buf, i, 0);
+		vb2_buffer_done(&b->b->vb2_buf, VB2_BUF_STATE_ERROR);
 		list_del(&b->list);
 	}
 }
diff --git a/drivers/media/platform/s5p-tv/mixer.h b/drivers/media/platform/s5p-tv/mixer.h
index 855b723..42cd270 100644
--- a/drivers/media/platform/s5p-tv/mixer.h
+++ b/drivers/media/platform/s5p-tv/mixer.h
@@ -113,7 +113,7 @@ struct mxr_geometry {
 /** instance of a buffer */
 struct mxr_buffer {
 	/** common v4l buffer stuff -- must be first */
-	struct vb2_buffer	vb;
+	struct vb2_v4l2_buffer vb;
 	/** node for layer's lists */
 	struct list_head	list;
 };
diff --git a/drivers/media/platform/s5p-tv/mixer_grp_layer.c b/drivers/media/platform/s5p-tv/mixer_grp_layer.c
index 74344c7..db3163b 100644
--- a/drivers/media/platform/s5p-tv/mixer_grp_layer.c
+++ b/drivers/media/platform/s5p-tv/mixer_grp_layer.c
@@ -86,7 +86,7 @@ static void mxr_graph_buffer_set(struct mxr_layer *layer,
 	dma_addr_t addr = 0;
 
 	if (buf)
-		addr = vb2_dma_contig_plane_dma_addr(&buf->vb, 0);
+		addr = vb2_dma_contig_plane_dma_addr(&buf->vb.vb2_buf, 0);
 	mxr_reg_graph_buffer(layer->mdev, layer->idx, addr);
 }
 
diff --git a/drivers/media/platform/s5p-tv/mixer_reg.c b/drivers/media/platform/s5p-tv/mixer_reg.c
index 5127acb..a0ec14a 100644
--- a/drivers/media/platform/s5p-tv/mixer_reg.c
+++ b/drivers/media/platform/s5p-tv/mixer_reg.c
@@ -279,7 +279,7 @@ static void mxr_irq_layer_handle(struct mxr_layer *layer)
 	layer->ops.buffer_set(layer, layer->update_buf);
 
 	if (done && done != layer->shadow_buf)
-		vb2_buffer_done(&done->vb, VB2_BUF_STATE_DONE);
+		vb2_buffer_done(&done->vb.vb2_buf, VB2_BUF_STATE_DONE);
 
 done:
 	spin_unlock(&layer->enq_slock);
diff --git a/drivers/media/platform/s5p-tv/mixer_video.c b/drivers/media/platform/s5p-tv/mixer_video.c
index 751f3b6..dba92b5 100644
--- a/drivers/media/platform/s5p-tv/mixer_video.c
+++ b/drivers/media/platform/s5p-tv/mixer_video.c
@@ -914,7 +914,8 @@ static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *pfmt,
 
 static void buf_queue(struct vb2_buffer *vb)
 {
-	struct mxr_buffer *buffer = container_of(vb, struct mxr_buffer, vb);
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct mxr_buffer *buffer = container_of(vbuf, struct mxr_buffer, vb);
 	struct mxr_layer *layer = vb2_get_drv_priv(vb->vb2_queue);
 	struct mxr_device *mdev = layer->mdev;
 	unsigned long flags;
@@ -963,11 +964,13 @@ static void mxr_watchdog(unsigned long arg)
 	if (layer->update_buf == layer->shadow_buf)
 		layer->update_buf = NULL;
 	if (layer->update_buf) {
-		vb2_buffer_done(&layer->update_buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&layer->update_buf->vb.vb2_buf,
+				VB2_BUF_STATE_ERROR);
 		layer->update_buf = NULL;
 	}
 	if (layer->shadow_buf) {
-		vb2_buffer_done(&layer->shadow_buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&layer->shadow_buf->vb.vb2_buf,
+				VB2_BUF_STATE_ERROR);
 		layer->shadow_buf = NULL;
 	}
 	spin_unlock_irqrestore(&layer->enq_slock, flags);
@@ -991,7 +994,7 @@ static void stop_streaming(struct vb2_queue *vq)
 	/* set all buffer to be done */
 	list_for_each_entry_safe(buf, buf_tmp, &layer->enq_list, list) {
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
 
 	spin_unlock_irqrestore(&layer->enq_slock, flags);
diff --git a/drivers/media/platform/s5p-tv/mixer_vp_layer.c b/drivers/media/platform/s5p-tv/mixer_vp_layer.c
index c9388c4..dd002a4 100644
--- a/drivers/media/platform/s5p-tv/mixer_vp_layer.c
+++ b/drivers/media/platform/s5p-tv/mixer_vp_layer.c
@@ -97,9 +97,10 @@ static void mxr_vp_buffer_set(struct mxr_layer *layer,
 		mxr_reg_vp_buffer(layer->mdev, luma_addr, chroma_addr);
 		return;
 	}
-	luma_addr[0] = vb2_dma_contig_plane_dma_addr(&buf->vb, 0);
+	luma_addr[0] = vb2_dma_contig_plane_dma_addr(&buf->vb.vb2_buf, 0);
 	if (layer->fmt->num_subframes == 2) {
-		chroma_addr[0] = vb2_dma_contig_plane_dma_addr(&buf->vb, 1);
+		chroma_addr[0] =
+			vb2_dma_contig_plane_dma_addr(&buf->vb.vb2_buf, 1);
 	} else {
 		/* FIXME: mxr_get_plane_size compute integer division,
 		 * which is slow and should not be performed in interrupt */
diff --git a/drivers/media/platform/sh_veu.c b/drivers/media/platform/sh_veu.c
index f5e3eb3a..6455cb9 100644
--- a/drivers/media/platform/sh_veu.c
+++ b/drivers/media/platform/sh_veu.c
@@ -931,9 +931,10 @@ static int sh_veu_buf_prepare(struct vb2_buffer *vb)
 
 static void sh_veu_buf_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct sh_veu_dev *veu = vb2_get_drv_priv(vb->vb2_queue);
-	dev_dbg(veu->dev, "%s(%d)\n", __func__, vb->v4l2_buf.type);
-	v4l2_m2m_buf_queue(veu->m2m_ctx, vb);
+	dev_dbg(veu->dev, "%s(%d)\n", __func__, vb->type);
+	v4l2_m2m_buf_queue(veu->m2m_ctx, vbuf);
 }
 
 static const struct vb2_ops sh_veu_qops = {
@@ -1084,8 +1085,8 @@ static irqreturn_t sh_veu_bh(int irq, void *dev_id)
 static irqreturn_t sh_veu_isr(int irq, void *dev_id)
 {
 	struct sh_veu_dev *veu = dev_id;
-	struct vb2_buffer *dst;
-	struct vb2_buffer *src;
+	struct vb2_v4l2_buffer *dst;
+	struct vb2_v4l2_buffer *src;
 	u32 status = sh_veu_reg_read(veu, VEU_EVTR);
 
 	/* bundle read mode not used */
@@ -1105,11 +1106,11 @@ static irqreturn_t sh_veu_isr(int irq, void *dev_id)
 	if (!src || !dst)
 		return IRQ_NONE;
 
-	dst->v4l2_buf.timestamp = src->v4l2_buf.timestamp;
-	dst->v4l2_buf.flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
-	dst->v4l2_buf.flags |=
-		src->v4l2_buf.flags & V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
-	dst->v4l2_buf.timecode = src->v4l2_buf.timecode;
+	dst->timestamp = src->timestamp;
+	dst->flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
+	dst->flags |=
+		src->flags & V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
+	dst->timecode = src->timecode;
 
 	spin_lock(&veu->lock);
 	v4l2_m2m_buf_done(src, VB2_BUF_STATE_DONE);
diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
index fe5c8ab..7967a75 100644
--- a/drivers/media/platform/sh_vou.c
+++ b/drivers/media/platform/sh_vou.c
@@ -27,6 +27,7 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-mediabus.h>
+#include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-dma-contig.h>
 
 /* Mirror addresses are not available for all registers */
@@ -62,11 +63,12 @@ enum sh_vou_status {
 #define VOU_MIN_IMAGE_HEIGHT	16
 
 struct sh_vou_buffer {
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head list;
 };
 
-static inline struct sh_vou_buffer *to_sh_vou_buffer(struct vb2_buffer *vb2)
+static inline struct
+sh_vou_buffer *to_sh_vou_buffer(struct vb2_v4l2_buffer *vb2)
 {
 	return container_of(vb2, struct sh_vou_buffer, vb);
 }
@@ -193,11 +195,11 @@ static struct sh_vou_fmt vou_fmt[] = {
 };
 
 static void sh_vou_schedule_next(struct sh_vou_device *vou_dev,
-				 struct vb2_buffer *vb)
+				 struct vb2_v4l2_buffer *vbuf)
 {
 	dma_addr_t addr1, addr2;
 
-	addr1 = vb2_dma_contig_plane_dma_addr(vb, 0);
+	addr1 = vb2_dma_contig_plane_dma_addr(&vbuf->vb2_buf, 0);
 	switch (vou_dev->pix.pixelformat) {
 	case V4L2_PIX_FMT_NV12:
 	case V4L2_PIX_FMT_NV16:
@@ -282,8 +284,9 @@ static int sh_vou_buf_prepare(struct vb2_buffer *vb)
 /* Locking: caller holds fop_lock mutex and vq->irqlock spinlock */
 static void sh_vou_buf_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct sh_vou_device *vou_dev = vb2_get_drv_priv(vb->vb2_queue);
-	struct sh_vou_buffer *shbuf = to_sh_vou_buffer(vb);
+	struct sh_vou_buffer *shbuf = to_sh_vou_buffer(vbuf);
 	unsigned long flags;
 
 	spin_lock_irqsave(&vou_dev->lock, flags);
@@ -302,7 +305,8 @@ static int sh_vou_start_streaming(struct vb2_queue *vq, unsigned int count)
 					 video, s_stream, 1);
 	if (ret < 0 && ret != -ENOIOCTLCMD) {
 		list_for_each_entry_safe(buf, node, &vou_dev->buf_list, list) {
-			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+			vb2_buffer_done(&buf->vb.vb2_buf,
+					VB2_BUF_STATE_QUEUED);
 			list_del(&buf->list);
 		}
 		vou_dev->active = NULL;
@@ -353,7 +357,7 @@ static void sh_vou_stop_streaming(struct vb2_queue *vq)
 	msleep(50);
 	spin_lock_irqsave(&vou_dev->lock, flags);
 	list_for_each_entry_safe(buf, node, &vou_dev->buf_list, list) {
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 		list_del(&buf->list);
 	}
 	vou_dev->active = NULL;
@@ -1066,10 +1070,10 @@ static irqreturn_t sh_vou_isr(int irq, void *dev_id)
 
 	list_del(&vb->list);
 
-	v4l2_get_timestamp(&vb->vb.v4l2_buf.timestamp);
-	vb->vb.v4l2_buf.sequence = vou_dev->sequence++;
-	vb->vb.v4l2_buf.field = V4L2_FIELD_INTERLACED;
-	vb2_buffer_done(&vb->vb, VB2_BUF_STATE_DONE);
+	v4l2_get_timestamp(&vb->vb.timestamp);
+	vb->vb.sequence = vou_dev->sequence++;
+	vb->vb.field = V4L2_FIELD_INTERLACED;
+	vb2_buffer_done(&vb->vb.vb2_buf, VB2_BUF_STATE_DONE);
 
 	vou_dev->active = list_entry(vou_dev->buf_list.next,
 				     struct sh_vou_buffer, list);
diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index 9070172..f24f603 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -59,7 +59,7 @@ struct isi_dma_desc {
 
 /* Frame buffer data */
 struct frame_buffer {
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	struct isi_dma_desc *p_dma_desc;
 	struct list_head list;
 };
@@ -151,13 +151,13 @@ static int configure_geometry(struct atmel_isi *isi, u32 width,
 static irqreturn_t atmel_isi_handle_streaming(struct atmel_isi *isi)
 {
 	if (isi->active) {
-		struct vb2_buffer *vb = &isi->active->vb;
+		struct vb2_v4l2_buffer *vbuf = &isi->active->vb;
 		struct frame_buffer *buf = isi->active;
 
 		list_del_init(&buf->list);
-		v4l2_get_timestamp(&vb->v4l2_buf.timestamp);
-		vb->v4l2_buf.sequence = isi->sequence++;
-		vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
+		v4l2_get_timestamp(&vbuf->timestamp);
+		vbuf->sequence = isi->sequence++;
+		vb2_buffer_done(&vbuf->vb2_buf, VB2_BUF_STATE_DONE);
 	}
 
 	if (list_empty(&isi->video_buffer_list)) {
@@ -267,7 +267,8 @@ static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 
 static int buffer_init(struct vb2_buffer *vb)
 {
-	struct frame_buffer *buf = container_of(vb, struct frame_buffer, vb);
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct frame_buffer *buf = container_of(vbuf, struct frame_buffer, vb);
 
 	buf->p_dma_desc = NULL;
 	INIT_LIST_HEAD(&buf->list);
@@ -277,8 +278,9 @@ static int buffer_init(struct vb2_buffer *vb)
 
 static int buffer_prepare(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
-	struct frame_buffer *buf = container_of(vb, struct frame_buffer, vb);
+	struct frame_buffer *buf = container_of(vbuf, struct frame_buffer, vb);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct atmel_isi *isi = ici->priv;
 	unsigned long size;
@@ -292,7 +294,7 @@ static int buffer_prepare(struct vb2_buffer *vb)
 		return -EINVAL;
 	}
 
-	vb2_set_plane_payload(&buf->vb, 0, size);
+	vb2_set_plane_payload(vb, 0, size);
 
 	if (!buf->p_dma_desc) {
 		if (list_empty(&isi->dma_desc_head)) {
@@ -319,10 +321,11 @@ static int buffer_prepare(struct vb2_buffer *vb)
 
 static void buffer_cleanup(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct atmel_isi *isi = ici->priv;
-	struct frame_buffer *buf = container_of(vb, struct frame_buffer, vb);
+	struct frame_buffer *buf = container_of(vbuf, struct frame_buffer, vb);
 
 	/* This descriptor is available now and we add to head list */
 	if (buf->p_dma_desc)
@@ -360,10 +363,11 @@ static void start_dma(struct atmel_isi *isi, struct frame_buffer *buffer)
 
 static void buffer_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct atmel_isi *isi = ici->priv;
-	struct frame_buffer *buf = container_of(vb, struct frame_buffer, vb);
+	struct frame_buffer *buf = container_of(vbuf, struct frame_buffer, vb);
 	unsigned long flags = 0;
 
 	spin_lock_irqsave(&isi->lock, flags);
@@ -422,7 +426,7 @@ static void stop_streaming(struct vb2_queue *vq)
 	/* Release all active buffers */
 	list_for_each_entry_safe(buf, node, &isi->video_buffer_list, list) {
 		list_del_init(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irq(&isi->lock);
 
diff --git a/drivers/media/platform/soc_camera/mx2_camera.c b/drivers/media/platform/soc_camera/mx2_camera.c
index 6e41335..9079196 100644
--- a/drivers/media/platform/soc_camera/mx2_camera.c
+++ b/drivers/media/platform/soc_camera/mx2_camera.c
@@ -225,7 +225,7 @@ struct mx2_buf_internal {
 /* buffer for one video frame */
 struct mx2_buffer {
 	/* common v4l buffer stuff -- must be first */
-	struct vb2_buffer		vb;
+	struct vb2_v4l2_buffer vb;
 	struct mx2_buf_internal		internal;
 };
 
@@ -530,11 +530,12 @@ out:
 
 static void mx2_videobuf_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
 	struct soc_camera_host *ici =
 		to_soc_camera_host(icd->parent);
 	struct mx2_camera_dev *pcdev = ici->priv;
-	struct mx2_buffer *buf = container_of(vb, struct mx2_buffer, vb);
+	struct mx2_buffer *buf = container_of(vbuf, struct mx2_buffer, vb);
 	unsigned long flags;
 
 	dev_dbg(icd->parent, "%s (vb=0x%p) 0x%p %lu\n", __func__,
@@ -664,7 +665,7 @@ static int mx2_start_streaming(struct vb2_queue *q, unsigned int count)
 	buf = list_first_entry(&pcdev->capture, struct mx2_buffer,
 			       internal.queue);
 	buf->internal.bufnum = 0;
-	vb = &buf->vb;
+	vb = &buf->vb.vb2_buf;
 
 	phys = vb2_dma_contig_plane_dma_addr(vb, 0);
 	mx27_update_emma_buf(pcdev, phys, buf->internal.bufnum);
@@ -673,7 +674,7 @@ static int mx2_start_streaming(struct vb2_queue *q, unsigned int count)
 	buf = list_first_entry(&pcdev->capture, struct mx2_buffer,
 			       internal.queue);
 	buf->internal.bufnum = 1;
-	vb = &buf->vb;
+	vb = &buf->vb.vb2_buf;
 
 	phys = vb2_dma_contig_plane_dma_addr(vb, 0);
 	mx27_update_emma_buf(pcdev, phys, buf->internal.bufnum);
@@ -1307,6 +1308,7 @@ static void mx27_camera_frame_done_emma(struct mx2_camera_dev *pcdev,
 	struct mx2_buf_internal *ibuf;
 	struct mx2_buffer *buf;
 	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vbuf;
 	unsigned long phys;
 
 	ibuf = list_first_entry(&pcdev->active_bufs, struct mx2_buf_internal,
@@ -1323,7 +1325,8 @@ static void mx27_camera_frame_done_emma(struct mx2_camera_dev *pcdev,
 	} else {
 		buf = mx2_ibuf_to_buf(ibuf);
 
-		vb = &buf->vb;
+		vb = &buf->vb.vb2_buf;
+		vbuf = to_vb2_v4l2_buffer(vb);
 #ifdef DEBUG
 		phys = vb2_dma_contig_plane_dma_addr(vb, 0);
 		if (prp->cfg.channel == 1) {
@@ -1347,8 +1350,8 @@ static void mx27_camera_frame_done_emma(struct mx2_camera_dev *pcdev,
 				vb2_get_plane_payload(vb, 0));
 
 		list_del_init(&buf->internal.queue);
-		v4l2_get_timestamp(&vb->v4l2_buf.timestamp);
-		vb->v4l2_buf.sequence = pcdev->frame_count;
+		v4l2_get_timestamp(&vbuf->timestamp);
+		vbuf->sequence = pcdev->frame_count;
 		if (err)
 			vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
 		else
@@ -1380,7 +1383,7 @@ static void mx27_camera_frame_done_emma(struct mx2_camera_dev *pcdev,
 
 	list_move_tail(pcdev->capture.next, &pcdev->active_bufs);
 
-	vb = &buf->vb;
+	vb = &buf->vb.vb2_buf;
 
 	phys = vb2_dma_contig_plane_dma_addr(vb, 0);
 	mx27_update_emma_buf(pcdev, phys, bufnum);
diff --git a/drivers/media/platform/soc_camera/mx3_camera.c b/drivers/media/platform/soc_camera/mx3_camera.c
index ace41f5..5ea4350 100644
--- a/drivers/media/platform/soc_camera/mx3_camera.c
+++ b/drivers/media/platform/soc_camera/mx3_camera.c
@@ -63,7 +63,7 @@
 
 struct mx3_camera_buffer {
 	/* common v4l buffer stuff -- must be first */
-	struct vb2_buffer			vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head			queue;
 
 	/* One descriptot per scatterlist (per frame) */
@@ -133,7 +133,7 @@ static void csi_reg_write(struct mx3_camera_dev *mx3, u32 value, off_t reg)
 	__raw_writel(value, mx3->base + reg);
 }
 
-static struct mx3_camera_buffer *to_mx3_vb(struct vb2_buffer *vb)
+static struct mx3_camera_buffer *to_mx3_vb(struct vb2_v4l2_buffer *vb)
 {
 	return container_of(vb, struct mx3_camera_buffer, vb);
 }
@@ -151,14 +151,14 @@ static void mx3_cam_dma_done(void *arg)
 
 	spin_lock(&mx3_cam->lock);
 	if (mx3_cam->active) {
-		struct vb2_buffer *vb = &mx3_cam->active->vb;
+		struct vb2_v4l2_buffer *vb = &mx3_cam->active->vb;
 		struct mx3_camera_buffer *buf = to_mx3_vb(vb);
 
 		list_del_init(&buf->queue);
-		v4l2_get_timestamp(&vb->v4l2_buf.timestamp);
-		vb->v4l2_buf.field = mx3_cam->field;
-		vb->v4l2_buf.sequence = mx3_cam->sequence++;
-		vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
+		v4l2_get_timestamp(&vb->timestamp);
+		vb->field = mx3_cam->field;
+		vb->sequence = mx3_cam->sequence++;
+		vb2_buffer_done(&vb->vb2_buf, VB2_BUF_STATE_DONE);
 	}
 
 	if (list_empty(&mx3_cam->capture)) {
@@ -257,10 +257,11 @@ static enum pixel_fmt fourcc_to_ipu_pix(__u32 fourcc)
 
 static void mx3_videobuf_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct mx3_camera_dev *mx3_cam = ici->priv;
-	struct mx3_camera_buffer *buf = to_mx3_vb(vb);
+	struct mx3_camera_buffer *buf = to_mx3_vb(vbuf);
 	struct scatterlist *sg = &buf->sg;
 	struct dma_async_tx_descriptor *txd;
 	struct idmac_channel *ichan = mx3_cam->idmac_channel[0];
@@ -273,7 +274,7 @@ static void mx3_videobuf_queue(struct vb2_buffer *vb)
 
 	if (vb2_plane_size(vb, 0) < new_size) {
 		dev_err(icd->parent, "Buffer #%d too small (%lu < %zu)\n",
-			vb->v4l2_buf.index, vb2_plane_size(vb, 0), new_size);
+			vbuf->vb2_buf.index, vb2_plane_size(vb, 0), new_size);
 		goto error;
 	}
 
@@ -357,10 +358,11 @@ error:
 
 static void mx3_videobuf_release(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct mx3_camera_dev *mx3_cam = ici->priv;
-	struct mx3_camera_buffer *buf = to_mx3_vb(vb);
+	struct mx3_camera_buffer *buf = to_mx3_vb(vbuf);
 	struct dma_async_tx_descriptor *txd = buf->txd;
 	unsigned long flags;
 
@@ -390,10 +392,11 @@ static void mx3_videobuf_release(struct vb2_buffer *vb)
 
 static int mx3_videobuf_init(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct mx3_camera_dev *mx3_cam = ici->priv;
-	struct mx3_camera_buffer *buf = to_mx3_vb(vb);
+	struct mx3_camera_buffer *buf = to_mx3_vb(vbuf);
 
 	if (!buf->txd) {
 		/* This is for locking debugging only */
@@ -424,7 +427,7 @@ static void mx3_stop_streaming(struct vb2_queue *q)
 
 	list_for_each_entry_safe(buf, tmp, &mx3_cam->capture, queue) {
 		list_del_init(&buf->queue);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
 
 	spin_unlock_irqrestore(&mx3_cam->lock, flags);
diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index 71dd71c..1dcf4d1 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -478,7 +478,7 @@ struct rcar_vin_priv {
 	struct soc_camera_host		ici;
 	struct list_head		capture;
 #define MAX_BUFFER_NUM			3
-	struct vb2_buffer		*queue_buf[MAX_BUFFER_NUM];
+	struct vb2_v4l2_buffer		*queue_buf[MAX_BUFFER_NUM];
 	struct vb2_alloc_ctx		*alloc_ctx;
 	enum v4l2_field			field;
 	unsigned int			pdata_flags;
@@ -492,7 +492,7 @@ struct rcar_vin_priv {
 #define is_continuous_transfer(priv)	(priv->vb_count > MAX_BUFFER_NUM)
 
 struct rcar_vin_buffer {
-	struct vb2_buffer		vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head		list;
 };
 
@@ -748,7 +748,7 @@ static int rcar_vin_hw_ready(struct rcar_vin_priv *priv)
 /* Moves a buffer from the queue to the HW slots */
 static int rcar_vin_fill_hw_slot(struct rcar_vin_priv *priv)
 {
-	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vbuf;
 	dma_addr_t phys_addr_top;
 	int slot;
 
@@ -760,10 +760,11 @@ static int rcar_vin_fill_hw_slot(struct rcar_vin_priv *priv)
 	if (slot < 0)
 		return 0;
 
-	vb = &list_entry(priv->capture.next, struct rcar_vin_buffer, list)->vb;
-	list_del_init(to_buf_list(vb));
-	priv->queue_buf[slot] = vb;
-	phys_addr_top = vb2_dma_contig_plane_dma_addr(vb, 0);
+	vbuf = &list_entry(priv->capture.next,
+			struct rcar_vin_buffer, list)->vb;
+	list_del_init(to_buf_list(vbuf));
+	priv->queue_buf[slot] = vbuf;
+	phys_addr_top = vb2_dma_contig_plane_dma_addr(&vbuf->vb2_buf, 0);
 	iowrite32(phys_addr_top, priv->base + VNMB_REG(slot));
 
 	return 1;
@@ -771,6 +772,7 @@ static int rcar_vin_fill_hw_slot(struct rcar_vin_priv *priv)
 
 static void rcar_vin_videobuf_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct rcar_vin_priv *priv = ici->priv;
@@ -780,7 +782,7 @@ static void rcar_vin_videobuf_queue(struct vb2_buffer *vb)
 
 	if (vb2_plane_size(vb, 0) < size) {
 		dev_err(icd->parent, "Buffer #%d too small (%lu < %lu)\n",
-			vb->v4l2_buf.index, vb2_plane_size(vb, 0), size);
+			vb->index, vb2_plane_size(vb, 0), size);
 		goto error;
 	}
 
@@ -791,14 +793,14 @@ static void rcar_vin_videobuf_queue(struct vb2_buffer *vb)
 
 	spin_lock_irq(&priv->lock);
 
-	list_add_tail(to_buf_list(vb), &priv->capture);
+	list_add_tail(to_buf_list(vbuf), &priv->capture);
 	rcar_vin_fill_hw_slot(priv);
 
 	/* If we weren't running, and have enough buffers, start capturing! */
 	if (priv->state != RUNNING && rcar_vin_hw_ready(priv)) {
 		if (rcar_vin_setup(priv)) {
 			/* Submit error */
-			list_del_init(to_buf_list(vb));
+			list_del_init(to_buf_list(vbuf));
 			spin_unlock_irq(&priv->lock);
 			goto error;
 		}
@@ -854,7 +856,7 @@ static void rcar_vin_stop_streaming(struct vb2_queue *vq)
 
 	for (i = 0; i < MAX_BUFFER_NUM; i++) {
 		if (priv->queue_buf[i]) {
-			vb2_buffer_done(priv->queue_buf[i],
+			vb2_buffer_done(&priv->queue_buf[i]->vb2_buf,
 					VB2_BUF_STATE_ERROR);
 			priv->queue_buf[i] = NULL;
 		}
@@ -862,7 +864,7 @@ static void rcar_vin_stop_streaming(struct vb2_queue *vq)
 
 	list_for_each_safe(buf_head, tmp, &priv->capture) {
 		vb2_buffer_done(&list_entry(buf_head,
-					struct rcar_vin_buffer, list)->vb,
+				struct rcar_vin_buffer, list)->vb.vb2_buf,
 				VB2_BUF_STATE_ERROR);
 		list_del_init(buf_head);
 	}
@@ -907,10 +909,11 @@ static irqreturn_t rcar_vin_irq(int irq, void *data)
 		else
 			slot = 0;
 
-		priv->queue_buf[slot]->v4l2_buf.field = priv->field;
-		priv->queue_buf[slot]->v4l2_buf.sequence = priv->sequence++;
-		v4l2_get_timestamp(&priv->queue_buf[slot]->v4l2_buf.timestamp);
-		vb2_buffer_done(priv->queue_buf[slot], VB2_BUF_STATE_DONE);
+		priv->queue_buf[slot]->field = priv->field;
+		priv->queue_buf[slot]->sequence = priv->sequence++;
+		v4l2_get_timestamp(&priv->queue_buf[slot]->timestamp);
+		vb2_buffer_done(&priv->queue_buf[slot]->vb2_buf,
+				VB2_BUF_STATE_DONE);
 		priv->queue_buf[slot] = NULL;
 
 		if (priv->state != STOPPING)
@@ -964,7 +967,7 @@ static void rcar_vin_remove_device(struct soc_camera_device *icd)
 {
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct rcar_vin_priv *priv = ici->priv;
-	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vbuf;
 	int i;
 
 	/* disable capture, disable interrupts */
@@ -978,10 +981,10 @@ static void rcar_vin_remove_device(struct soc_camera_device *icd)
 	/* make sure active buffer is cancelled */
 	spin_lock_irq(&priv->lock);
 	for (i = 0; i < MAX_BUFFER_NUM; i++) {
-		vb = priv->queue_buf[i];
-		if (vb) {
-			list_del_init(to_buf_list(vb));
-			vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
+		vbuf = priv->queue_buf[i];
+		if (vbuf) {
+			list_del_init(to_buf_list(vbuf));
+			vb2_buffer_done(&vbuf->vb2_buf, VB2_BUF_STATE_ERROR);
 		}
 	}
 	spin_unlock_irq(&priv->lock);
diff --git a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
index efdeea4..1719942 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
@@ -93,7 +93,7 @@
 
 /* per video frame buffer */
 struct sh_mobile_ceu_buffer {
-	struct vb2_buffer vb; /* v4l buffer must be first */
+	struct vb2_v4l2_buffer vb; /* v4l buffer must be first */
 	struct list_head queue;
 };
 
@@ -112,7 +112,7 @@ struct sh_mobile_ceu_dev {
 
 	spinlock_t lock;		/* Protects video buffer lists */
 	struct list_head capture;
-	struct vb2_buffer *active;
+	struct vb2_v4l2_buffer *active;
 	struct vb2_alloc_ctx *alloc_ctx;
 
 	struct sh_mobile_ceu_info *pdata;
@@ -152,9 +152,9 @@ struct sh_mobile_ceu_cam {
 	u32 code;
 };
 
-static struct sh_mobile_ceu_buffer *to_ceu_vb(struct vb2_buffer *vb)
+static struct sh_mobile_ceu_buffer *to_ceu_vb(struct vb2_v4l2_buffer *vbuf)
 {
-	return container_of(vb, struct sh_mobile_ceu_buffer, vb);
+	return container_of(vbuf, struct sh_mobile_ceu_buffer, vb);
 }
 
 static void ceu_write(struct sh_mobile_ceu_dev *priv,
@@ -334,7 +334,8 @@ static int sh_mobile_ceu_capture(struct sh_mobile_ceu_dev *pcdev)
 		bottom2	= CDBCR;
 	}
 
-	phys_addr_top = vb2_dma_contig_plane_dma_addr(pcdev->active, 0);
+	phys_addr_top =
+		vb2_dma_contig_plane_dma_addr(&pcdev->active->vb2_buf, 0);
 
 	switch (icd->current_fmt->host_fmt->fourcc) {
 	case V4L2_PIX_FMT_NV12:
@@ -369,7 +370,8 @@ static int sh_mobile_ceu_capture(struct sh_mobile_ceu_dev *pcdev)
 
 static int sh_mobile_ceu_videobuf_prepare(struct vb2_buffer *vb)
 {
-	struct sh_mobile_ceu_buffer *buf = to_ceu_vb(vb);
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct sh_mobile_ceu_buffer *buf = to_ceu_vb(vbuf);
 
 	/* Added list head initialization on alloc */
 	WARN(!list_empty(&buf->queue), "Buffer %p on queue!\n", vb);
@@ -379,17 +381,19 @@ static int sh_mobile_ceu_videobuf_prepare(struct vb2_buffer *vb)
 
 static void sh_mobile_ceu_videobuf_queue(struct vb2_buffer *vb)
 {
-	struct soc_camera_device *icd = container_of(vb->vb2_queue, struct soc_camera_device, vb2_vidq);
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct soc_camera_device *icd = container_of(vb->vb2_queue,
+			struct soc_camera_device, vb2_vidq);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
-	struct sh_mobile_ceu_buffer *buf = to_ceu_vb(vb);
+	struct sh_mobile_ceu_buffer *buf = to_ceu_vb(vbuf);
 	unsigned long size;
 
 	size = icd->sizeimage;
 
 	if (vb2_plane_size(vb, 0) < size) {
 		dev_err(icd->parent, "Buffer #%d too small (%lu < %lu)\n",
-			vb->v4l2_buf.index, vb2_plane_size(vb, 0), size);
+			vb->index, vb2_plane_size(vb, 0), size);
 		goto error;
 	}
 
@@ -416,7 +420,7 @@ static void sh_mobile_ceu_videobuf_queue(struct vb2_buffer *vb)
 		 * we are not interested in the return value of
 		 * sh_mobile_ceu_capture here.
 		 */
-		pcdev->active = vb;
+		pcdev->active = vbuf;
 		sh_mobile_ceu_capture(pcdev);
 	}
 	spin_unlock_irq(&pcdev->lock);
@@ -429,14 +433,16 @@ error:
 
 static void sh_mobile_ceu_videobuf_release(struct vb2_buffer *vb)
 {
-	struct soc_camera_device *icd = container_of(vb->vb2_queue, struct soc_camera_device, vb2_vidq);
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct soc_camera_device *icd = container_of(vb->vb2_queue,
+			struct soc_camera_device, vb2_vidq);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
-	struct sh_mobile_ceu_buffer *buf = to_ceu_vb(vb);
+	struct sh_mobile_ceu_buffer *buf = to_ceu_vb(vbuf);
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
 
 	spin_lock_irq(&pcdev->lock);
 
-	if (pcdev->active == vb) {
+	if (pcdev->active == vbuf) {
 		/* disable capture (release DMA buffer), reset */
 		ceu_write(pcdev, CAPSR, 1 << 16);
 		pcdev->active = NULL;
@@ -458,7 +464,9 @@ static void sh_mobile_ceu_videobuf_release(struct vb2_buffer *vb)
 
 static int sh_mobile_ceu_videobuf_init(struct vb2_buffer *vb)
 {
-	struct soc_camera_device *icd = container_of(vb->vb2_queue, struct soc_camera_device, vb2_vidq);
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct soc_camera_device *icd = container_of(vb->vb2_queue,
+			struct soc_camera_device, vb2_vidq);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
 
@@ -467,7 +475,7 @@ static int sh_mobile_ceu_videobuf_init(struct vb2_buffer *vb)
 		pcdev->buf_total);
 
 	/* This is for locking debugging only */
-	INIT_LIST_HEAD(&to_ceu_vb(vb)->queue);
+	INIT_LIST_HEAD(&to_ceu_vb(vbuf)->queue);
 	return 0;
 }
 
@@ -504,17 +512,17 @@ static struct vb2_ops sh_mobile_ceu_videobuf_ops = {
 static irqreturn_t sh_mobile_ceu_irq(int irq, void *data)
 {
 	struct sh_mobile_ceu_dev *pcdev = data;
-	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vbuf;
 	int ret;
 
 	spin_lock(&pcdev->lock);
 
-	vb = pcdev->active;
-	if (!vb)
+	vbuf = pcdev->active;
+	if (!vbuf)
 		/* Stale interrupt from a released buffer */
 		goto out;
 
-	list_del_init(&to_ceu_vb(vb)->queue);
+	list_del_init(&to_ceu_vb(vbuf)->queue);
 
 	if (!list_empty(&pcdev->capture))
 		pcdev->active = &list_entry(pcdev->capture.next,
@@ -523,12 +531,13 @@ static irqreturn_t sh_mobile_ceu_irq(int irq, void *data)
 		pcdev->active = NULL;
 
 	ret = sh_mobile_ceu_capture(pcdev);
-	v4l2_get_timestamp(&vb->v4l2_buf.timestamp);
+	v4l2_get_timestamp(&vbuf->timestamp);
 	if (!ret) {
-		vb->v4l2_buf.field = pcdev->field;
-		vb->v4l2_buf.sequence = pcdev->sequence++;
+		vbuf->field = pcdev->field;
+		vbuf->sequence = pcdev->sequence++;
 	}
-	vb2_buffer_done(vb, ret < 0 ? VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
+	vb2_buffer_done(&vbuf->vb2_buf,
+			ret < 0 ? VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
 
 out:
 	spin_unlock(&pcdev->lock);
@@ -633,7 +642,7 @@ static void sh_mobile_ceu_clock_stop(struct soc_camera_host *ici)
 	spin_lock_irq(&pcdev->lock);
 	if (pcdev->active) {
 		list_del_init(&to_ceu_vb(pcdev->active)->queue);
-		vb2_buffer_done(pcdev->active, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&pcdev->active->vb2_buf, VB2_BUF_STATE_ERROR);
 		pcdev->active = NULL;
 	}
 	spin_unlock_irq(&pcdev->lock);
diff --git a/drivers/media/platform/sti/bdisp/bdisp-v4l2.c b/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
index df61355..62b9842 100644
--- a/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
+++ b/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
@@ -180,7 +180,7 @@ static struct bdisp_frame *ctx_get_frame(struct bdisp_ctx *ctx,
 
 static void bdisp_job_finish(struct bdisp_ctx *ctx, int vb_state)
 {
-	struct vb2_buffer *src_vb, *dst_vb;
+	struct vb2_v4l2_buffer *src_vb, *dst_vb;
 
 	if (WARN(!ctx || !ctx->fh.m2m_ctx, "Null hardware context\n"))
 		return;
@@ -191,10 +191,10 @@ static void bdisp_job_finish(struct bdisp_ctx *ctx, int vb_state)
 	dst_vb = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
 
 	if (src_vb && dst_vb) {
-		dst_vb->v4l2_buf.timestamp = src_vb->v4l2_buf.timestamp;
-		dst_vb->v4l2_buf.timecode = src_vb->v4l2_buf.timecode;
-		dst_vb->v4l2_buf.flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
-		dst_vb->v4l2_buf.flags |= src_vb->v4l2_buf.flags &
+		dst_vb->timestamp = src_vb->timestamp;
+		dst_vb->timecode = src_vb->timecode;
+		dst_vb->flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
+		dst_vb->flags |= src_vb->flags &
 					  V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
 
 		v4l2_m2m_buf_done(src_vb, vb_state);
@@ -281,23 +281,23 @@ static int bdisp_get_addr(struct bdisp_ctx *ctx, struct vb2_buffer *vb,
 static int bdisp_get_bufs(struct bdisp_ctx *ctx)
 {
 	struct bdisp_frame *src, *dst;
-	struct vb2_buffer *src_vb, *dst_vb;
+	struct vb2_v4l2_buffer *src_vb, *dst_vb;
 	int ret;
 
 	src = &ctx->src;
 	dst = &ctx->dst;
 
 	src_vb = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
-	ret = bdisp_get_addr(ctx, src_vb, src, src->paddr);
+	ret = bdisp_get_addr(ctx, &src_vb->vb2_buf, src, src->paddr);
 	if (ret)
 		return ret;
 
 	dst_vb = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
-	ret = bdisp_get_addr(ctx, dst_vb, dst, dst->paddr);
+	ret = bdisp_get_addr(ctx, &dst_vb->vb2_buf, dst, dst->paddr);
 	if (ret)
 		return ret;
 
-	dst_vb->v4l2_buf.timestamp = src_vb->v4l2_buf.timestamp;
+	dst_vb->timestamp = src_vb->timestamp;
 
 	return 0;
 }
@@ -483,6 +483,7 @@ static int bdisp_buf_prepare(struct vb2_buffer *vb)
 
 static void bdisp_buf_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct bdisp_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
 
 	/* return to V4L2 any 0-size buffer so it can be dequeued by user */
@@ -493,13 +494,13 @@ static void bdisp_buf_queue(struct vb2_buffer *vb)
 	}
 
 	if (ctx->fh.m2m_ctx)
-		v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vb);
+		v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vbuf);
 }
 
 static int bdisp_start_streaming(struct vb2_queue *q, unsigned int count)
 {
 	struct bdisp_ctx *ctx = q->drv_priv;
-	struct vb2_buffer *buf;
+	struct vb2_v4l2_buffer *buf;
 	int ret = pm_runtime_get_sync(ctx->bdisp_dev->dev);
 
 	if (ret < 0) {
diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index d82c2f2..4902453 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -384,8 +384,8 @@ struct vpe_ctx {
 	unsigned int		bufs_completed;		/* bufs done in this batch */
 
 	struct vpe_q_data	q_data[2];		/* src & dst queue data */
-	struct vb2_buffer	*src_vbs[VPE_MAX_SRC_BUFS];
-	struct vb2_buffer	*dst_vb;
+	struct vb2_v4l2_buffer	*src_vbs[VPE_MAX_SRC_BUFS];
+	struct vb2_v4l2_buffer	*dst_vb;
 
 	dma_addr_t		mv_buf_dma[2];		/* dma addrs of motion vector in/out bufs */
 	void			*mv_buf[2];		/* virtual addrs of motion vector bufs */
@@ -988,7 +988,7 @@ static void add_out_dtd(struct vpe_ctx *ctx, int port)
 {
 	struct vpe_q_data *q_data = &ctx->q_data[Q_DATA_DST];
 	const struct vpe_port_data *p_data = &port_data[port];
-	struct vb2_buffer *vb = ctx->dst_vb;
+	struct vb2_buffer *vb = &ctx->dst_vb->vb2_buf;
 	struct vpe_fmt *fmt = q_data->fmt;
 	const struct vpdma_data_format *vpdma_fmt;
 	int mv_buf_selector = !ctx->src_mv_buf_selector;
@@ -1025,11 +1025,12 @@ static void add_in_dtd(struct vpe_ctx *ctx, int port)
 {
 	struct vpe_q_data *q_data = &ctx->q_data[Q_DATA_SRC];
 	const struct vpe_port_data *p_data = &port_data[port];
-	struct vb2_buffer *vb = ctx->src_vbs[p_data->vb_index];
+	struct vb2_buffer *vb = &ctx->src_vbs[p_data->vb_index]->vb2_buf;
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vpe_fmt *fmt = q_data->fmt;
 	const struct vpdma_data_format *vpdma_fmt;
 	int mv_buf_selector = ctx->src_mv_buf_selector;
-	int field = vb->v4l2_buf.field == V4L2_FIELD_BOTTOM;
+	int field = vbuf->field == V4L2_FIELD_BOTTOM;
 	int frame_width, frame_height;
 	dma_addr_t dma_addr;
 	u32 flags = 0;
@@ -1222,8 +1223,7 @@ static irqreturn_t vpe_irq(int irq_vpe, void *data)
 	struct vpe_dev *dev = (struct vpe_dev *)data;
 	struct vpe_ctx *ctx;
 	struct vpe_q_data *d_q_data;
-	struct vb2_buffer *s_vb, *d_vb;
-	struct v4l2_buffer *s_buf, *d_buf;
+	struct vb2_v4l2_buffer *s_vb, *d_vb;
 	unsigned long flags;
 	u32 irqst0, irqst1;
 
@@ -1286,20 +1286,18 @@ static irqreturn_t vpe_irq(int irq_vpe, void *data)
 
 	s_vb = ctx->src_vbs[0];
 	d_vb = ctx->dst_vb;
-	s_buf = &s_vb->v4l2_buf;
-	d_buf = &d_vb->v4l2_buf;
 
-	d_buf->flags = s_buf->flags;
+	d_vb->flags = s_vb->flags;
+	d_vb->timestamp = s_vb->timestamp;
 
-	d_buf->timestamp = s_buf->timestamp;
-	if (s_buf->flags & V4L2_BUF_FLAG_TIMECODE)
-		d_buf->timecode = s_buf->timecode;
+	if (s_vb->flags & V4L2_BUF_FLAG_TIMECODE)
+		d_vb->timecode = s_vb->timecode;
 
-	d_buf->sequence = ctx->sequence;
+	d_vb->sequence = ctx->sequence;
 
 	d_q_data = &ctx->q_data[Q_DATA_DST];
 	if (d_q_data->flags & Q_DATA_INTERLACED) {
-		d_buf->field = ctx->field;
+		d_vb->field = ctx->field;
 		if (ctx->field == V4L2_FIELD_BOTTOM) {
 			ctx->sequence++;
 			ctx->field = V4L2_FIELD_TOP;
@@ -1308,7 +1306,7 @@ static irqreturn_t vpe_irq(int irq_vpe, void *data)
 			ctx->field = V4L2_FIELD_BOTTOM;
 		}
 	} else {
-		d_buf->field = V4L2_FIELD_NONE;
+		d_vb->field = V4L2_FIELD_NONE;
 		ctx->sequence++;
 	}
 
@@ -1825,6 +1823,7 @@ static int vpe_queue_setup(struct vb2_queue *vq,
 
 static int vpe_buf_prepare(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vpe_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
 	struct vpe_q_data *q_data;
 	int i, num_planes;
@@ -1836,10 +1835,10 @@ static int vpe_buf_prepare(struct vb2_buffer *vb)
 
 	if (vb->vb2_queue->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
 		if (!(q_data->flags & Q_DATA_INTERLACED)) {
-			vb->v4l2_buf.field = V4L2_FIELD_NONE;
+			vbuf->field = V4L2_FIELD_NONE;
 		} else {
-			if (vb->v4l2_buf.field != V4L2_FIELD_TOP &&
-					vb->v4l2_buf.field != V4L2_FIELD_BOTTOM)
+			if (vbuf->field != V4L2_FIELD_TOP &&
+					vbuf->field != V4L2_FIELD_BOTTOM)
 				return -EINVAL;
 		}
 	}
@@ -1862,9 +1861,10 @@ static int vpe_buf_prepare(struct vb2_buffer *vb)
 
 static void vpe_buf_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vpe_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
 
-	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vb);
+	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vbuf);
 }
 
 static int vpe_start_streaming(struct vb2_queue *q, unsigned int count)
diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index 295fde5..f2d38b9 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -197,8 +197,8 @@ static struct vim2m_q_data *get_q_data(struct vim2m_ctx *ctx,
 
 
 static int device_process(struct vim2m_ctx *ctx,
-			  struct vb2_buffer *in_vb,
-			  struct vb2_buffer *out_vb)
+			  struct vb2_v4l2_buffer *in_vb,
+			  struct vb2_v4l2_buffer *out_vb)
 {
 	struct vim2m_dev *dev = ctx->dev;
 	struct vim2m_q_data *q_data;
@@ -213,15 +213,16 @@ static int device_process(struct vim2m_ctx *ctx,
 	height	= q_data->height;
 	bytesperline	= (q_data->width * q_data->fmt->depth) >> 3;
 
-	p_in = vb2_plane_vaddr(in_vb, 0);
-	p_out = vb2_plane_vaddr(out_vb, 0);
+	p_in = vb2_plane_vaddr(&in_vb->vb2_buf, 0);
+	p_out = vb2_plane_vaddr(&out_vb->vb2_buf, 0);
 	if (!p_in || !p_out) {
 		v4l2_err(&dev->v4l2_dev,
 			 "Acquiring kernel pointers to buffers failed\n");
 		return -EFAULT;
 	}
 
-	if (vb2_plane_size(in_vb, 0) > vb2_plane_size(out_vb, 0)) {
+	if (vb2_plane_size(&in_vb->vb2_buf, 0) >
+			vb2_plane_size(&out_vb->vb2_buf, 0)) {
 		v4l2_err(&dev->v4l2_dev, "Output buffer is too small\n");
 		return -EINVAL;
 	}
@@ -231,16 +232,17 @@ static int device_process(struct vim2m_ctx *ctx,
 	bytes_left = bytesperline - tile_w * MEM2MEM_NUM_TILES;
 	w = 0;
 
-	out_vb->v4l2_buf.sequence = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE)->sequence++;
-	in_vb->v4l2_buf.sequence = q_data->sequence++;
-	memcpy(&out_vb->v4l2_buf.timestamp,
-			&in_vb->v4l2_buf.timestamp,
+	out_vb->sequence =
+		get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE)->sequence++;
+	in_vb->sequence = q_data->sequence++;
+	memcpy(&out_vb->timestamp,
+			&in_vb->timestamp,
 			sizeof(struct timeval));
-	if (in_vb->v4l2_buf.flags & V4L2_BUF_FLAG_TIMECODE)
-		memcpy(&out_vb->v4l2_buf.timecode, &in_vb->v4l2_buf.timecode,
+	if (in_vb->flags & V4L2_BUF_FLAG_TIMECODE)
+		memcpy(&out_vb->timecode, &in_vb->timecode,
 			sizeof(struct v4l2_timecode));
-	out_vb->v4l2_buf.field = in_vb->v4l2_buf.field;
-	out_vb->v4l2_buf.flags = in_vb->v4l2_buf.flags &
+	out_vb->field = in_vb->field;
+	out_vb->flags = in_vb->flags &
 		(V4L2_BUF_FLAG_TIMECODE |
 		 V4L2_BUF_FLAG_KEYFRAME |
 		 V4L2_BUF_FLAG_PFRAME |
@@ -374,7 +376,7 @@ static void device_run(void *priv)
 {
 	struct vim2m_ctx *ctx = priv;
 	struct vim2m_dev *dev = ctx->dev;
-	struct vb2_buffer *src_buf, *dst_buf;
+	struct vb2_v4l2_buffer *src_buf, *dst_buf;
 
 	src_buf = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
 	dst_buf = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
@@ -389,7 +391,7 @@ static void device_isr(unsigned long priv)
 {
 	struct vim2m_dev *vim2m_dev = (struct vim2m_dev *)priv;
 	struct vim2m_ctx *curr_ctx;
-	struct vb2_buffer *src_vb, *dst_vb;
+	struct vb2_v4l2_buffer *src_vb, *dst_vb;
 	unsigned long flags;
 
 	curr_ctx = v4l2_m2m_get_curr_priv(vim2m_dev->m2m_dev);
@@ -747,6 +749,7 @@ static int vim2m_queue_setup(struct vb2_queue *vq,
 
 static int vim2m_buf_prepare(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vim2m_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
 	struct vim2m_q_data *q_data;
 
@@ -754,9 +757,9 @@ static int vim2m_buf_prepare(struct vb2_buffer *vb)
 
 	q_data = get_q_data(ctx, vb->vb2_queue->type);
 	if (V4L2_TYPE_IS_OUTPUT(vb->vb2_queue->type)) {
-		if (vb->v4l2_buf.field == V4L2_FIELD_ANY)
-			vb->v4l2_buf.field = V4L2_FIELD_NONE;
-		if (vb->v4l2_buf.field != V4L2_FIELD_NONE) {
+		if (vbuf->field == V4L2_FIELD_ANY)
+			vbuf->field = V4L2_FIELD_NONE;
+		if (vbuf->field != V4L2_FIELD_NONE) {
 			dprintk(ctx->dev, "%s field isn't supported\n",
 					__func__);
 			return -EINVAL;
@@ -776,9 +779,10 @@ static int vim2m_buf_prepare(struct vb2_buffer *vb)
 
 static void vim2m_buf_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vim2m_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
 
-	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vb);
+	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vbuf);
 }
 
 static int vim2m_start_streaming(struct vb2_queue *q, unsigned count)
@@ -793,18 +797,18 @@ static int vim2m_start_streaming(struct vb2_queue *q, unsigned count)
 static void vim2m_stop_streaming(struct vb2_queue *q)
 {
 	struct vim2m_ctx *ctx = vb2_get_drv_priv(q);
-	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vbuf;
 	unsigned long flags;
 
 	for (;;) {
 		if (V4L2_TYPE_IS_OUTPUT(q->type))
-			vb = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
+			vbuf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
 		else
-			vb = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
-		if (vb == NULL)
+			vbuf = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
+		if (vbuf == NULL)
 			return;
 		spin_lock_irqsave(&ctx->dev->irqlock, flags);
-		v4l2_m2m_buf_done(vb, VB2_BUF_STATE_ERROR);
+		v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_ERROR);
 		spin_unlock_irqrestore(&ctx->dev->irqlock, flags);
 	}
 }
diff --git a/drivers/media/platform/vivid/vivid-core.h b/drivers/media/platform/vivid/vivid-core.h
index 5f1b1da..b039103 100644
--- a/drivers/media/platform/vivid/vivid-core.h
+++ b/drivers/media/platform/vivid/vivid-core.h
@@ -93,7 +93,7 @@ extern struct vivid_fmt vivid_formats[];
 /* buffer for one video frame */
 struct vivid_buffer {
 	/* common v4l buffer stuff -- must be first */
-	struct vb2_buffer	vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head	list;
 };
 
diff --git a/drivers/media/platform/vivid/vivid-kthread-cap.c b/drivers/media/platform/vivid/vivid-kthread-cap.c
index 1727f54..83cc6d3 100644
--- a/drivers/media/platform/vivid/vivid-kthread-cap.c
+++ b/drivers/media/platform/vivid/vivid-kthread-cap.c
@@ -236,8 +236,8 @@ static void *plane_vaddr(struct tpg_data *tpg, struct vivid_buffer *buf,
 	void *vbuf;
 
 	if (p == 0 || tpg_g_buffers(tpg) > 1)
-		return vb2_plane_vaddr(&buf->vb, p);
-	vbuf = vb2_plane_vaddr(&buf->vb, 0);
+		return vb2_plane_vaddr(&buf->vb.vb2_buf, p);
+	vbuf = vb2_plane_vaddr(&buf->vb.vb2_buf, 0);
 	for (i = 0; i < p; i++)
 		vbuf += bpl[i] * h / tpg->vdownsampling[i];
 	return vbuf;
@@ -246,7 +246,7 @@ static void *plane_vaddr(struct tpg_data *tpg, struct vivid_buffer *buf,
 static int vivid_copy_buffer(struct vivid_dev *dev, unsigned p, u8 *vcapbuf,
 		struct vivid_buffer *vid_cap_buf)
 {
-	bool blank = dev->must_blank[vid_cap_buf->vb.v4l2_buf.index];
+	bool blank = dev->must_blank[vid_cap_buf->vb.vb2_buf.index];
 	struct tpg_data *tpg = &dev->tpg;
 	struct vivid_buffer *vid_out_buf = NULL;
 	unsigned vdiv = dev->fmt_out->vdownsampling[p];
@@ -283,12 +283,12 @@ static int vivid_copy_buffer(struct vivid_dev *dev, unsigned p, u8 *vcapbuf,
 	if (vid_out_buf == NULL)
 		return -ENODATA;
 
-	vid_cap_buf->vb.v4l2_buf.field = vid_out_buf->vb.v4l2_buf.field;
+	vid_cap_buf->vb.field = vid_out_buf->vb.field;
 
 	voutbuf = plane_vaddr(tpg, vid_out_buf, p,
 			      dev->bytesperline_out, dev->fmt_out_rect.height);
 	if (p < dev->fmt_out->buffers)
-		voutbuf += vid_out_buf->vb.v4l2_planes[p].data_offset;
+		voutbuf += vid_out_buf->vb.vb2_buf.planes[p].data_offset;
 	voutbuf += tpg_hdiv(tpg, p, dev->loop_vid_out.left) +
 		(dev->loop_vid_out.top / vdiv) * stride_out;
 	vcapbuf += tpg_hdiv(tpg, p, dev->compose_cap.left) +
@@ -429,17 +429,19 @@ static void vivid_fillbuff(struct vivid_dev *dev, struct vivid_buffer *buf)
 	bool is_loop = false;
 
 	if (dev->loop_video && dev->can_loop_video &&
-	    ((vivid_is_svid_cap(dev) && !VIVID_INVALID_SIGNAL(dev->std_signal_mode)) ||
-	     (vivid_is_hdmi_cap(dev) && !VIVID_INVALID_SIGNAL(dev->dv_timings_signal_mode))))
+		((vivid_is_svid_cap(dev) &&
+		!VIVID_INVALID_SIGNAL(dev->std_signal_mode)) ||
+		(vivid_is_hdmi_cap(dev) &&
+		!VIVID_INVALID_SIGNAL(dev->dv_timings_signal_mode))))
 		is_loop = true;
 
-	buf->vb.v4l2_buf.sequence = dev->vid_cap_seq_count;
+	buf->vb.sequence = dev->vid_cap_seq_count;
 	/*
 	 * Take the timestamp now if the timestamp source is set to
 	 * "Start of Exposure".
 	 */
 	if (dev->tstamp_src_is_soe)
-		v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
+		v4l2_get_timestamp(&buf->vb.timestamp);
 	if (dev->field_cap == V4L2_FIELD_ALTERNATE) {
 		/*
 		 * 60 Hz standards start with the bottom field, 50 Hz standards
@@ -447,19 +449,19 @@ static void vivid_fillbuff(struct vivid_dev *dev, struct vivid_buffer *buf)
 		 * then the field is TOP for 50 Hz and BOTTOM for 60 Hz
 		 * standards.
 		 */
-		buf->vb.v4l2_buf.field = ((dev->vid_cap_seq_count & 1) ^ is_60hz) ?
+		buf->vb.field = ((dev->vid_cap_seq_count & 1) ^ is_60hz) ?
 			V4L2_FIELD_BOTTOM : V4L2_FIELD_TOP;
 		/*
 		 * The sequence counter counts frames, not fields. So divide
 		 * by two.
 		 */
-		buf->vb.v4l2_buf.sequence /= 2;
+		buf->vb.sequence /= 2;
 	} else {
-		buf->vb.v4l2_buf.field = dev->field_cap;
+		buf->vb.field = dev->field_cap;
 	}
-	tpg_s_field(tpg, buf->vb.v4l2_buf.field,
+	tpg_s_field(tpg, buf->vb.field,
 		    dev->field_cap == V4L2_FIELD_ALTERNATE);
-	tpg_s_perc_fill_blank(tpg, dev->must_blank[buf->vb.v4l2_buf.index]);
+	tpg_s_perc_fill_blank(tpg, dev->must_blank[buf->vb.vb2_buf.index]);
 
 	vivid_precalc_copy_rects(dev);
 
@@ -479,13 +481,16 @@ static void vivid_fillbuff(struct vivid_dev *dev, struct vivid_buffer *buf)
 		}
 		tpg_calc_text_basep(tpg, basep, p, vbuf);
 		if (!is_loop || vivid_copy_buffer(dev, p, vbuf, buf))
-			tpg_fill_plane_buffer(tpg, vivid_get_std_cap(dev), p, vbuf);
+			tpg_fill_plane_buffer(tpg, vivid_get_std_cap(dev),
+					p, vbuf);
 	}
-	dev->must_blank[buf->vb.v4l2_buf.index] = false;
+	dev->must_blank[buf->vb.vb2_buf.index] = false;
 
 	/* Updates stream time, only update at the start of a new frame. */
-	if (dev->field_cap != V4L2_FIELD_ALTERNATE || (buf->vb.v4l2_buf.sequence & 1) == 0)
-		dev->ms_vid_cap = jiffies_to_msecs(jiffies - dev->jiffies_vid_cap);
+	if (dev->field_cap != V4L2_FIELD_ALTERNATE ||
+			(buf->vb.sequence & 1) == 0)
+		dev->ms_vid_cap =
+			jiffies_to_msecs(jiffies - dev->jiffies_vid_cap);
 
 	ms = dev->ms_vid_cap;
 	if (dev->osd_mode <= 1) {
@@ -494,9 +499,9 @@ static void vivid_fillbuff(struct vivid_dev *dev, struct vivid_buffer *buf)
 				(ms / (60 * 1000)) % 60,
 				(ms / 1000) % 60,
 				ms % 1000,
-				buf->vb.v4l2_buf.sequence,
+				buf->vb.sequence,
 				(dev->field_cap == V4L2_FIELD_ALTERNATE) ?
-					(buf->vb.v4l2_buf.field == V4L2_FIELD_TOP ?
+					(buf->vb.field == V4L2_FIELD_TOP ?
 					 " top" : " bottom") : "");
 		tpg_gen_text(tpg, basep, line++ * line_height, 16, str);
 	}
@@ -553,8 +558,8 @@ static void vivid_fillbuff(struct vivid_dev *dev, struct vivid_buffer *buf)
 	 * the timestamp now.
 	 */
 	if (!dev->tstamp_src_is_soe)
-		v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
-	buf->vb.v4l2_buf.timestamp.tv_sec += dev->time_wrap_offset;
+		v4l2_get_timestamp(&buf->vb.timestamp);
+	buf->vb.timestamp.tv_sec += dev->time_wrap_offset;
 }
 
 /*
@@ -600,7 +605,7 @@ static void vivid_overlay(struct vivid_dev *dev, struct vivid_buffer *buf)
 	struct tpg_data *tpg = &dev->tpg;
 	unsigned pixsize = tpg_g_twopixelsize(tpg, 0) / 2;
 	void *vbase = dev->fb_vbase_cap;
-	void *vbuf = vb2_plane_vaddr(&buf->vb, 0);
+	void *vbuf = vb2_plane_vaddr(&buf->vb.vb2_buf, 0);
 	unsigned img_width = dev->compose_cap.width;
 	unsigned img_height = dev->compose_cap.height;
 	unsigned stride = tpg->bytesperline[0];
@@ -616,7 +621,7 @@ static void vivid_overlay(struct vivid_dev *dev, struct vivid_buffer *buf)
 		return;
 	if ((dev->overlay_cap_field == V4L2_FIELD_TOP ||
 	     dev->overlay_cap_field == V4L2_FIELD_BOTTOM) &&
-	    dev->overlay_cap_field != buf->vb.v4l2_buf.field)
+	    dev->overlay_cap_field != buf->vb.field)
 		return;
 
 	vbuf += dev->compose_cap.left * pixsize + dev->compose_cap.top * stride;
@@ -699,17 +704,17 @@ static void vivid_thread_vid_cap_tick(struct vivid_dev *dev, int dropped_bufs)
 		/* Fill buffer */
 		vivid_fillbuff(dev, vid_cap_buf);
 		dprintk(dev, 1, "filled buffer %d\n",
-			vid_cap_buf->vb.v4l2_buf.index);
+			vid_cap_buf->vb.vb2_buf.index);
 
 		/* Handle overlay */
 		if (dev->overlay_cap_owner && dev->fb_cap.base &&
-				dev->fb_cap.fmt.pixelformat == dev->fmt_cap->fourcc)
+			dev->fb_cap.fmt.pixelformat == dev->fmt_cap->fourcc)
 			vivid_overlay(dev, vid_cap_buf);
 
-		vb2_buffer_done(&vid_cap_buf->vb, dev->dqbuf_error ?
+		vb2_buffer_done(&vid_cap_buf->vb.vb2_buf, dev->dqbuf_error ?
 				VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
 		dprintk(dev, 2, "vid_cap buffer %d done\n",
-				vid_cap_buf->vb.v4l2_buf.index);
+				vid_cap_buf->vb.vb2_buf.index);
 	}
 
 	if (vbi_cap_buf) {
@@ -717,10 +722,10 @@ static void vivid_thread_vid_cap_tick(struct vivid_dev *dev, int dropped_bufs)
 			vivid_sliced_vbi_cap_process(dev, vbi_cap_buf);
 		else
 			vivid_raw_vbi_cap_process(dev, vbi_cap_buf);
-		vb2_buffer_done(&vbi_cap_buf->vb, dev->dqbuf_error ?
+		vb2_buffer_done(&vbi_cap_buf->vb.vb2_buf, dev->dqbuf_error ?
 				VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
 		dprintk(dev, 2, "vbi_cap %d done\n",
-				vbi_cap_buf->vb.v4l2_buf.index);
+				vbi_cap_buf->vb.vb2_buf.index);
 	}
 	dev->dqbuf_error = false;
 
@@ -884,9 +889,9 @@ void vivid_stop_generating_vid_cap(struct vivid_dev *dev, bool *pstreaming)
 			buf = list_entry(dev->vid_cap_active.next,
 					 struct vivid_buffer, list);
 			list_del(&buf->list);
-			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+			vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 			dprintk(dev, 2, "vid_cap buffer %d done\n",
-				buf->vb.v4l2_buf.index);
+				buf->vb.vb2_buf.index);
 		}
 	}
 
@@ -897,9 +902,9 @@ void vivid_stop_generating_vid_cap(struct vivid_dev *dev, bool *pstreaming)
 			buf = list_entry(dev->vbi_cap_active.next,
 					 struct vivid_buffer, list);
 			list_del(&buf->list);
-			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+			vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 			dprintk(dev, 2, "vbi_cap buffer %d done\n",
-				buf->vb.v4l2_buf.index);
+				buf->vb.vb2_buf.index);
 		}
 	}
 
diff --git a/drivers/media/platform/vivid/vivid-kthread-out.c b/drivers/media/platform/vivid/vivid-kthread-out.c
index d9f36cc..c2c46dc 100644
--- a/drivers/media/platform/vivid/vivid-kthread-out.c
+++ b/drivers/media/platform/vivid/vivid-kthread-out.c
@@ -87,33 +87,33 @@ static void vivid_thread_vid_out_tick(struct vivid_dev *dev)
 		return;
 
 	if (vid_out_buf) {
-		vid_out_buf->vb.v4l2_buf.sequence = dev->vid_out_seq_count;
+		vid_out_buf->vb.sequence = dev->vid_out_seq_count;
 		if (dev->field_out == V4L2_FIELD_ALTERNATE) {
 			/*
-			 * The sequence counter counts frames, not fields. So divide
-			 * by two.
+			 * The sequence counter counts frames, not fields.
+			 * So divide by two.
 			 */
-			vid_out_buf->vb.v4l2_buf.sequence /= 2;
+			vid_out_buf->vb.sequence /= 2;
 		}
-		v4l2_get_timestamp(&vid_out_buf->vb.v4l2_buf.timestamp);
-		vid_out_buf->vb.v4l2_buf.timestamp.tv_sec += dev->time_wrap_offset;
-		vb2_buffer_done(&vid_out_buf->vb, dev->dqbuf_error ?
+		v4l2_get_timestamp(&vid_out_buf->vb.timestamp);
+		vid_out_buf->vb.timestamp.tv_sec += dev->time_wrap_offset;
+		vb2_buffer_done(&vid_out_buf->vb.vb2_buf, dev->dqbuf_error ?
 				VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
 		dprintk(dev, 2, "vid_out buffer %d done\n",
-			vid_out_buf->vb.v4l2_buf.index);
+			vid_out_buf->vb.vb2_buf.index);
 	}
 
 	if (vbi_out_buf) {
 		if (dev->stream_sliced_vbi_out)
 			vivid_sliced_vbi_out_process(dev, vbi_out_buf);
 
-		vbi_out_buf->vb.v4l2_buf.sequence = dev->vbi_out_seq_count;
-		v4l2_get_timestamp(&vbi_out_buf->vb.v4l2_buf.timestamp);
-		vbi_out_buf->vb.v4l2_buf.timestamp.tv_sec += dev->time_wrap_offset;
-		vb2_buffer_done(&vbi_out_buf->vb, dev->dqbuf_error ?
+		vbi_out_buf->vb.sequence = dev->vbi_out_seq_count;
+		v4l2_get_timestamp(&vbi_out_buf->vb.timestamp);
+		vbi_out_buf->vb.timestamp.tv_sec += dev->time_wrap_offset;
+		vb2_buffer_done(&vbi_out_buf->vb.vb2_buf, dev->dqbuf_error ?
 				VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
 		dprintk(dev, 2, "vbi_out buffer %d done\n",
-			vbi_out_buf->vb.v4l2_buf.index);
+			vbi_out_buf->vb.vb2_buf.index);
 	}
 	dev->dqbuf_error = false;
 }
@@ -274,9 +274,9 @@ void vivid_stop_generating_vid_out(struct vivid_dev *dev, bool *pstreaming)
 			buf = list_entry(dev->vid_out_active.next,
 					 struct vivid_buffer, list);
 			list_del(&buf->list);
-			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+			vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 			dprintk(dev, 2, "vid_out buffer %d done\n",
-				buf->vb.v4l2_buf.index);
+				buf->vb.vb2_buf.index);
 		}
 	}
 
@@ -287,9 +287,9 @@ void vivid_stop_generating_vid_out(struct vivid_dev *dev, bool *pstreaming)
 			buf = list_entry(dev->vbi_out_active.next,
 					 struct vivid_buffer, list);
 			list_del(&buf->list);
-			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+			vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 			dprintk(dev, 2, "vbi_out buffer %d done\n",
-				buf->vb.v4l2_buf.index);
+				buf->vb.vb2_buf.index);
 		}
 	}
 
diff --git a/drivers/media/platform/vivid/vivid-sdr-cap.c b/drivers/media/platform/vivid/vivid-sdr-cap.c
index d2f2188..bdc9f33 100644
--- a/drivers/media/platform/vivid/vivid-sdr-cap.c
+++ b/drivers/media/platform/vivid/vivid-sdr-cap.c
@@ -114,11 +114,11 @@ static void vivid_thread_sdr_cap_tick(struct vivid_dev *dev)
 	spin_unlock(&dev->slock);
 
 	if (sdr_cap_buf) {
-		sdr_cap_buf->vb.v4l2_buf.sequence = dev->sdr_cap_seq_count;
+		sdr_cap_buf->vb.sequence = dev->sdr_cap_seq_count;
 		vivid_sdr_cap_process(dev, sdr_cap_buf);
-		v4l2_get_timestamp(&sdr_cap_buf->vb.v4l2_buf.timestamp);
-		sdr_cap_buf->vb.v4l2_buf.timestamp.tv_sec += dev->time_wrap_offset;
-		vb2_buffer_done(&sdr_cap_buf->vb, dev->dqbuf_error ?
+		v4l2_get_timestamp(&sdr_cap_buf->vb.timestamp);
+		sdr_cap_buf->vb.timestamp.tv_sec += dev->time_wrap_offset;
+		vb2_buffer_done(&sdr_cap_buf->vb.vb2_buf, dev->dqbuf_error ?
 				VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
 		dev->dqbuf_error = false;
 	}
@@ -161,7 +161,8 @@ static int vivid_thread_sdr_cap(void *data)
 		/* Calculate the number of jiffies since we started streaming */
 		jiffies_since_start = cur_jiffies - dev->jiffies_sdr_cap;
 		/* Get the number of buffers streamed since the start */
-		buffers_since_start = (u64)jiffies_since_start * dev->sdr_adc_freq +
+		buffers_since_start =
+			(u64)jiffies_since_start * dev->sdr_adc_freq +
 				      (HZ * SDR_CAP_SAMPLES_PER_BUF) / 2;
 		do_div(buffers_since_start, HZ * SDR_CAP_SAMPLES_PER_BUF);
 
@@ -176,7 +177,8 @@ static int vivid_thread_sdr_cap(void *data)
 			dev->sdr_cap_seq_offset = buffers_since_start;
 			buffers_since_start = 0;
 		}
-		dev->sdr_cap_seq_count = buffers_since_start + dev->sdr_cap_seq_offset;
+		dev->sdr_cap_seq_count =
+			buffers_since_start + dev->sdr_cap_seq_offset;
 
 		vivid_thread_sdr_cap_tick(dev);
 		mutex_unlock(&dev->mutex);
@@ -247,8 +249,9 @@ static int sdr_cap_buf_prepare(struct vb2_buffer *vb)
 
 static void sdr_cap_buf_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vivid_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
-	struct vivid_buffer *buf = container_of(vb, struct vivid_buffer, vb);
+	struct vivid_buffer *buf = container_of(vbuf, struct vivid_buffer, vb);
 
 	dprintk(dev, 1, "%s\n", __func__);
 
@@ -282,7 +285,8 @@ static int sdr_cap_start_streaming(struct vb2_queue *vq, unsigned count)
 
 		list_for_each_entry_safe(buf, tmp, &dev->sdr_cap_active, list) {
 			list_del(&buf->list);
-			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+			vb2_buffer_done(&buf->vb.vb2_buf,
+					VB2_BUF_STATE_QUEUED);
 		}
 	}
 	return err;
@@ -299,9 +303,10 @@ static void sdr_cap_stop_streaming(struct vb2_queue *vq)
 	while (!list_empty(&dev->sdr_cap_active)) {
 		struct vivid_buffer *buf;
 
-		buf = list_entry(dev->sdr_cap_active.next, struct vivid_buffer, list);
+		buf = list_entry(dev->sdr_cap_active.next,
+				struct vivid_buffer, list);
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
 
 	/* shutdown control thread */
@@ -321,7 +326,8 @@ const struct vb2_ops vivid_sdr_cap_qops = {
 	.wait_finish		= vb2_ops_wait_finish,
 };
 
-int vivid_sdr_enum_freq_bands(struct file *file, void *fh, struct v4l2_frequency_band *band)
+int vivid_sdr_enum_freq_bands(struct file *file, void *fh,
+		struct v4l2_frequency_band *band)
 {
 	switch (band->tuner) {
 	case 0:
@@ -339,7 +345,8 @@ int vivid_sdr_enum_freq_bands(struct file *file, void *fh, struct v4l2_frequency
 	}
 }
 
-int vivid_sdr_g_frequency(struct file *file, void *fh, struct v4l2_frequency *vf)
+int vivid_sdr_g_frequency(struct file *file, void *fh,
+		struct v4l2_frequency *vf)
 {
 	struct vivid_dev *dev = video_drvdata(file);
 
@@ -357,7 +364,8 @@ int vivid_sdr_g_frequency(struct file *file, void *fh, struct v4l2_frequency *vf
 	}
 }
 
-int vivid_sdr_s_frequency(struct file *file, void *fh, const struct v4l2_frequency *vf)
+int vivid_sdr_s_frequency(struct file *file, void *fh,
+		const struct v4l2_frequency *vf)
 {
 	struct vivid_dev *dev = video_drvdata(file);
 	unsigned freq = vf->frequency;
@@ -403,14 +411,16 @@ int vivid_sdr_g_tuner(struct file *file, void *fh, struct v4l2_tuner *vt)
 	case 0:
 		strlcpy(vt->name, "ADC", sizeof(vt->name));
 		vt->type = V4L2_TUNER_ADC;
-		vt->capability = V4L2_TUNER_CAP_1HZ | V4L2_TUNER_CAP_FREQ_BANDS;
+		vt->capability =
+			V4L2_TUNER_CAP_1HZ | V4L2_TUNER_CAP_FREQ_BANDS;
 		vt->rangelow = bands_adc[0].rangelow;
 		vt->rangehigh = bands_adc[2].rangehigh;
 		return 0;
 	case 1:
 		strlcpy(vt->name, "RF", sizeof(vt->name));
 		vt->type = V4L2_TUNER_RF;
-		vt->capability = V4L2_TUNER_CAP_1HZ | V4L2_TUNER_CAP_FREQ_BANDS;
+		vt->capability =
+			V4L2_TUNER_CAP_1HZ | V4L2_TUNER_CAP_FREQ_BANDS;
 		vt->rangelow = bands_fm[0].rangelow;
 		vt->rangehigh = bands_fm[0].rangehigh;
 		return 0;
@@ -491,9 +501,9 @@ int vidioc_try_fmt_sdr_cap(struct file *file, void *fh, struct v4l2_format *f)
 
 void vivid_sdr_cap_process(struct vivid_dev *dev, struct vivid_buffer *buf)
 {
-	u8 *vbuf = vb2_plane_vaddr(&buf->vb, 0);
+	u8 *vbuf = vb2_plane_vaddr(&buf->vb.vb2_buf, 0);
 	unsigned long i;
-	unsigned long plane_size = vb2_plane_size(&buf->vb, 0);
+	unsigned long plane_size = vb2_plane_size(&buf->vb.vb2_buf, 0);
 	s32 src_phase_step;
 	s32 mod_phase_step;
 	s32 fixp_i;
diff --git a/drivers/media/platform/vivid/vivid-vbi-cap.c b/drivers/media/platform/vivid/vivid-vbi-cap.c
index ef81b01..2993149 100644
--- a/drivers/media/platform/vivid/vivid-vbi-cap.c
+++ b/drivers/media/platform/vivid/vivid-vbi-cap.c
@@ -94,36 +94,38 @@ static void vivid_g_fmt_vbi_cap(struct vivid_dev *dev, struct v4l2_vbi_format *v
 void vivid_raw_vbi_cap_process(struct vivid_dev *dev, struct vivid_buffer *buf)
 {
 	struct v4l2_vbi_format vbi;
-	u8 *vbuf = vb2_plane_vaddr(&buf->vb, 0);
+	u8 *vbuf = vb2_plane_vaddr(&buf->vb.vb2_buf, 0);
 
 	vivid_g_fmt_vbi_cap(dev, &vbi);
-	buf->vb.v4l2_buf.sequence = dev->vbi_cap_seq_count;
+	buf->vb.sequence = dev->vbi_cap_seq_count;
 	if (dev->field_cap == V4L2_FIELD_ALTERNATE)
-		buf->vb.v4l2_buf.sequence /= 2;
+		buf->vb.sequence /= 2;
 
-	vivid_sliced_vbi_cap_fill(dev, buf->vb.v4l2_buf.sequence);
+	vivid_sliced_vbi_cap_fill(dev, buf->vb.sequence);
 
-	memset(vbuf, 0x10, vb2_plane_size(&buf->vb, 0));
+	memset(vbuf, 0x10, vb2_plane_size(&buf->vb.vb2_buf, 0));
 
 	if (!VIVID_INVALID_SIGNAL(dev->std_signal_mode))
 		vivid_vbi_gen_raw(&dev->vbi_gen, &vbi, vbuf);
 
-	v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
-	buf->vb.v4l2_buf.timestamp.tv_sec += dev->time_wrap_offset;
+	v4l2_get_timestamp(&buf->vb.timestamp);
+	buf->vb.timestamp.tv_sec += dev->time_wrap_offset;
 }
 
 
-void vivid_sliced_vbi_cap_process(struct vivid_dev *dev, struct vivid_buffer *buf)
+void vivid_sliced_vbi_cap_process(struct vivid_dev *dev,
+			struct vivid_buffer *buf)
 {
-	struct v4l2_sliced_vbi_data *vbuf = vb2_plane_vaddr(&buf->vb, 0);
+	struct v4l2_sliced_vbi_data *vbuf =
+			vb2_plane_vaddr(&buf->vb.vb2_buf, 0);
 
-	buf->vb.v4l2_buf.sequence = dev->vbi_cap_seq_count;
+	buf->vb.sequence = dev->vbi_cap_seq_count;
 	if (dev->field_cap == V4L2_FIELD_ALTERNATE)
-		buf->vb.v4l2_buf.sequence /= 2;
+		buf->vb.sequence /= 2;
 
-	vivid_sliced_vbi_cap_fill(dev, buf->vb.v4l2_buf.sequence);
+	vivid_sliced_vbi_cap_fill(dev, buf->vb.sequence);
 
-	memset(vbuf, 0, vb2_plane_size(&buf->vb, 0));
+	memset(vbuf, 0, vb2_plane_size(&buf->vb.vb2_buf, 0));
 	if (!VIVID_INVALID_SIGNAL(dev->std_signal_mode)) {
 		unsigned i;
 
@@ -131,13 +133,14 @@ void vivid_sliced_vbi_cap_process(struct vivid_dev *dev, struct vivid_buffer *bu
 			vbuf[i] = dev->vbi_gen.data[i];
 	}
 
-	v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
-	buf->vb.v4l2_buf.timestamp.tv_sec += dev->time_wrap_offset;
+	v4l2_get_timestamp(&buf->vb.timestamp);
+	buf->vb.timestamp.tv_sec += dev->time_wrap_offset;
 }
 
-static int vbi_cap_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
-		       unsigned *nbuffers, unsigned *nplanes,
-		       unsigned sizes[], void *alloc_ctxs[])
+static int vbi_cap_queue_setup(struct vb2_queue *vq,
+			const struct v4l2_format *fmt,
+			unsigned *nbuffers, unsigned *nplanes,
+			unsigned sizes[], void *alloc_ctxs[])
 {
 	struct vivid_dev *dev = vb2_get_drv_priv(vq);
 	bool is_60hz = dev->std_cap & V4L2_STD_525_60;
@@ -187,8 +190,9 @@ static int vbi_cap_buf_prepare(struct vb2_buffer *vb)
 
 static void vbi_cap_buf_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vivid_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
-	struct vivid_buffer *buf = container_of(vb, struct vivid_buffer, vb);
+	struct vivid_buffer *buf = container_of(vbuf, struct vivid_buffer, vb);
 
 	dprintk(dev, 1, "%s\n", __func__);
 
@@ -215,7 +219,8 @@ static int vbi_cap_start_streaming(struct vb2_queue *vq, unsigned count)
 
 		list_for_each_entry_safe(buf, tmp, &dev->vbi_cap_active, list) {
 			list_del(&buf->list);
-			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+			vb2_buffer_done(&buf->vb.vb2_buf,
+					VB2_BUF_STATE_QUEUED);
 		}
 	}
 	return err;
diff --git a/drivers/media/platform/vivid/vivid-vbi-out.c b/drivers/media/platform/vivid/vivid-vbi-out.c
index 4e4c70e..91c1688 100644
--- a/drivers/media/platform/vivid/vivid-vbi-out.c
+++ b/drivers/media/platform/vivid/vivid-vbi-out.c
@@ -79,8 +79,9 @@ static int vbi_out_buf_prepare(struct vb2_buffer *vb)
 
 static void vbi_out_buf_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vivid_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
-	struct vivid_buffer *buf = container_of(vb, struct vivid_buffer, vb);
+	struct vivid_buffer *buf = container_of(vbuf, struct vivid_buffer, vb);
 
 	dprintk(dev, 1, "%s\n", __func__);
 
@@ -107,7 +108,8 @@ static int vbi_out_start_streaming(struct vb2_queue *vq, unsigned count)
 
 		list_for_each_entry_safe(buf, tmp, &dev->vbi_out_active, list) {
 			list_del(&buf->list);
-			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+			vb2_buffer_done(&buf->vb.vb2_buf,
+					VB2_BUF_STATE_QUEUED);
 		}
 	}
 	return err;
@@ -201,7 +203,8 @@ int vidioc_try_fmt_sliced_vbi_out(struct file *file, void *fh, struct v4l2_forma
 	return 0;
 }
 
-int vidioc_s_fmt_sliced_vbi_out(struct file *file, void *fh, struct v4l2_format *fmt)
+int vidioc_s_fmt_sliced_vbi_out(struct file *file, void *fh,
+		struct v4l2_format *fmt)
 {
 	struct vivid_dev *dev = video_drvdata(file);
 	struct v4l2_sliced_vbi_format *vbi = &fmt->fmt.sliced;
@@ -217,10 +220,13 @@ int vidioc_s_fmt_sliced_vbi_out(struct file *file, void *fh, struct v4l2_format
 	return 0;
 }
 
-void vivid_sliced_vbi_out_process(struct vivid_dev *dev, struct vivid_buffer *buf)
+void vivid_sliced_vbi_out_process(struct vivid_dev *dev,
+		struct vivid_buffer *buf)
 {
-	struct v4l2_sliced_vbi_data *vbi = vb2_plane_vaddr(&buf->vb, 0);
-	unsigned elems = vb2_get_plane_payload(&buf->vb, 0) / sizeof(*vbi);
+	struct v4l2_sliced_vbi_data *vbi =
+		vb2_plane_vaddr(&buf->vb.vb2_buf, 0);
+	unsigned elems =
+		vb2_get_plane_payload(&buf->vb.vb2_buf, 0) / sizeof(*vbi);
 
 	dev->vbi_out_have_cc[0] = false;
 	dev->vbi_out_have_cc[1] = false;
diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index ed0b878..2497107 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -198,7 +198,7 @@ static int vid_cap_buf_prepare(struct vb2_buffer *vb)
 		}
 
 		vb2_set_plane_payload(vb, p, size);
-		vb->v4l2_planes[p].data_offset = dev->fmt_cap->data_offset[p];
+		vb->planes[p].data_offset = dev->fmt_cap->data_offset[p];
 	}
 
 	return 0;
@@ -206,10 +206,11 @@ static int vid_cap_buf_prepare(struct vb2_buffer *vb)
 
 static void vid_cap_buf_finish(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vivid_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
-	struct v4l2_timecode *tc = &vb->v4l2_buf.timecode;
+	struct v4l2_timecode *tc = &vbuf->timecode;
 	unsigned fps = 25;
-	unsigned seq = vb->v4l2_buf.sequence;
+	unsigned seq = vbuf->sequence;
 
 	if (!vivid_is_sdtv_cap(dev))
 		return;
@@ -218,7 +219,7 @@ static void vid_cap_buf_finish(struct vb2_buffer *vb)
 	 * Set the timecode. Rarely used, so it is interesting to
 	 * test this.
 	 */
-	vb->v4l2_buf.flags |= V4L2_BUF_FLAG_TIMECODE;
+	vbuf->flags |= V4L2_BUF_FLAG_TIMECODE;
 	if (dev->std_cap & V4L2_STD_525_60)
 		fps = 30;
 	tc->type = (fps == 30) ? V4L2_TC_TYPE_30FPS : V4L2_TC_TYPE_25FPS;
@@ -231,8 +232,9 @@ static void vid_cap_buf_finish(struct vb2_buffer *vb)
 
 static void vid_cap_buf_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vivid_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
-	struct vivid_buffer *buf = container_of(vb, struct vivid_buffer, vb);
+	struct vivid_buffer *buf = container_of(vbuf, struct vivid_buffer, vb);
 
 	dprintk(dev, 1, "%s\n", __func__);
 
@@ -268,7 +270,8 @@ static int vid_cap_start_streaming(struct vb2_queue *vq, unsigned count)
 
 		list_for_each_entry_safe(buf, tmp, &dev->vid_cap_active, list) {
 			list_del(&buf->list);
-			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+			vb2_buffer_done(&buf->vb.vb2_buf,
+					VB2_BUF_STATE_QUEUED);
 		}
 	}
 	return err;
diff --git a/drivers/media/platform/vivid/vivid-vid-out.c b/drivers/media/platform/vivid/vivid-vid-out.c
index c404e27..376f865 100644
--- a/drivers/media/platform/vivid/vivid-vid-out.c
+++ b/drivers/media/platform/vivid/vivid-vid-out.c
@@ -109,6 +109,7 @@ static int vid_out_queue_setup(struct vb2_queue *vq, const struct v4l2_format *f
 
 static int vid_out_buf_prepare(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vivid_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
 	unsigned long size;
 	unsigned planes;
@@ -131,14 +132,14 @@ static int vid_out_buf_prepare(struct vb2_buffer *vb)
 	}
 
 	if (dev->field_out != V4L2_FIELD_ALTERNATE)
-		vb->v4l2_buf.field = dev->field_out;
-	else if (vb->v4l2_buf.field != V4L2_FIELD_TOP &&
-		 vb->v4l2_buf.field != V4L2_FIELD_BOTTOM)
+		vbuf->field = dev->field_out;
+	else if (vbuf->field != V4L2_FIELD_TOP &&
+		 vbuf->field != V4L2_FIELD_BOTTOM)
 		return -EINVAL;
 
 	for (p = 0; p < planes; p++) {
 		size = dev->bytesperline_out[p] * dev->fmt_out_rect.height +
-			vb->v4l2_planes[p].data_offset;
+			vb->planes[p].data_offset;
 
 		if (vb2_get_plane_payload(vb, p) < size) {
 			dprintk(dev, 1, "%s the payload is too small for plane %u (%lu < %lu)\n",
@@ -152,8 +153,9 @@ static int vid_out_buf_prepare(struct vb2_buffer *vb)
 
 static void vid_out_buf_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vivid_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
-	struct vivid_buffer *buf = container_of(vb, struct vivid_buffer, vb);
+	struct vivid_buffer *buf = container_of(vbuf, struct vivid_buffer, vb);
 
 	dprintk(dev, 1, "%s\n", __func__);
 
@@ -186,7 +188,8 @@ static int vid_out_start_streaming(struct vb2_queue *vq, unsigned count)
 
 		list_for_each_entry_safe(buf, tmp, &dev->vid_out_active, list) {
 			list_del(&buf->list);
-			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+			vb2_buffer_done(&buf->vb.vb2_buf,
+					VB2_BUF_STATE_QUEUED);
 		}
 	}
 	return err;
diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index 3294529..cd5248a 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -200,10 +200,10 @@ static void rpf_vdev_queue(struct vsp1_video *video,
 
 	vsp1_rpf_write(rpf, VI6_RPF_SRCM_ADDR_Y,
 		       buf->addr[0] + rpf->offsets[0]);
-	if (buf->buf.num_planes > 1)
+	if (buf->buf.vb2_buf.num_planes > 1)
 		vsp1_rpf_write(rpf, VI6_RPF_SRCM_ADDR_C0,
 			       buf->addr[1] + rpf->offsets[1]);
-	if (buf->buf.num_planes > 2)
+	if (buf->buf.vb2_buf.num_planes > 2)
 		vsp1_rpf_write(rpf, VI6_RPF_SRCM_ADDR_C1,
 			       buf->addr[2] + rpf->offsets[1]);
 }
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index dfd45c7..13e4fdc 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -610,11 +610,11 @@ vsp1_video_complete_buffer(struct vsp1_video *video)
 
 	spin_unlock_irqrestore(&video->irqlock, flags);
 
-	done->buf.v4l2_buf.sequence = video->sequence++;
-	v4l2_get_timestamp(&done->buf.v4l2_buf.timestamp);
-	for (i = 0; i < done->buf.num_planes; ++i)
-		vb2_set_plane_payload(&done->buf, i, done->length[i]);
-	vb2_buffer_done(&done->buf, VB2_BUF_STATE_DONE);
+	done->buf.sequence = video->sequence++;
+	v4l2_get_timestamp(&done->buf.timestamp);
+	for (i = 0; i < done->buf.vb2_buf.num_planes; ++i)
+		vb2_set_plane_payload(&done->buf.vb2_buf, i, done->length[i]);
+	vb2_buffer_done(&done->buf.vb2_buf, VB2_BUF_STATE_DONE);
 
 	return next;
 }
@@ -820,8 +820,9 @@ vsp1_video_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 
 static int vsp1_video_buffer_prepare(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vsp1_video *video = vb2_get_drv_priv(vb->vb2_queue);
-	struct vsp1_video_buffer *buf = to_vsp1_video_buffer(vb);
+	struct vsp1_video_buffer *buf = to_vsp1_video_buffer(vbuf);
 	const struct v4l2_pix_format_mplane *format = &video->format;
 	unsigned int i;
 
@@ -841,9 +842,10 @@ static int vsp1_video_buffer_prepare(struct vb2_buffer *vb)
 
 static void vsp1_video_buffer_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vsp1_video *video = vb2_get_drv_priv(vb->vb2_queue);
 	struct vsp1_pipeline *pipe = to_vsp1_pipeline(&video->video.entity);
-	struct vsp1_video_buffer *buf = to_vsp1_video_buffer(vb);
+	struct vsp1_video_buffer *buf = to_vsp1_video_buffer(vbuf);
 	unsigned long flags;
 	bool empty;
 
@@ -954,7 +956,7 @@ static void vsp1_video_stop_streaming(struct vb2_queue *vq)
 	/* Remove all buffers from the IRQ queue. */
 	spin_lock_irqsave(&video->irqlock, flags);
 	list_for_each_entry(buffer, &video->irqqueue, queue)
-		vb2_buffer_done(&buffer->buf, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buffer->buf.vb2_buf, VB2_BUF_STATE_ERROR);
 	INIT_LIST_HEAD(&video->irqqueue);
 	spin_unlock_irqrestore(&video->irqlock, flags);
 }
diff --git a/drivers/media/platform/vsp1/vsp1_video.h b/drivers/media/platform/vsp1/vsp1_video.h
index d808301..a929aa8 100644
--- a/drivers/media/platform/vsp1/vsp1_video.h
+++ b/drivers/media/platform/vsp1/vsp1_video.h
@@ -94,7 +94,7 @@ static inline struct vsp1_pipeline *to_vsp1_pipeline(struct media_entity *e)
 }
 
 struct vsp1_video_buffer {
-	struct vb2_buffer buf;
+	struct vb2_v4l2_buffer buf;
 	struct list_head queue;
 
 	dma_addr_t addr[3];
@@ -102,9 +102,9 @@ struct vsp1_video_buffer {
 };
 
 static inline struct vsp1_video_buffer *
-to_vsp1_video_buffer(struct vb2_buffer *vb)
+to_vsp1_video_buffer(struct vb2_v4l2_buffer *vbuf)
 {
-	return container_of(vb, struct vsp1_video_buffer, buf);
+	return container_of(vbuf, struct vsp1_video_buffer, buf);
 }
 
 struct vsp1_video_operations {
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index 1d2b3a2..95b62f4 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -201,9 +201,9 @@ static void wpf_vdev_queue(struct vsp1_video *video,
 	struct vsp1_rwpf *wpf = container_of(video, struct vsp1_rwpf, video);
 
 	vsp1_wpf_write(wpf, VI6_WPF_DSTM_ADDR_Y, buf->addr[0]);
-	if (buf->buf.num_planes > 1)
+	if (buf->buf.vb2_buf.num_planes > 1)
 		vsp1_wpf_write(wpf, VI6_WPF_DSTM_ADDR_C0, buf->addr[1]);
-	if (buf->buf.num_planes > 2)
+	if (buf->buf.vb2_buf.num_planes > 2)
 		vsp1_wpf_write(wpf, VI6_WPF_DSTM_ADDR_C1, buf->addr[2]);
 }
 
diff --git a/drivers/media/platform/xilinx/xilinx-dma.c b/drivers/media/platform/xilinx/xilinx-dma.c
index d9dcd4b..5af66c2 100644
--- a/drivers/media/platform/xilinx/xilinx-dma.c
+++ b/drivers/media/platform/xilinx/xilinx-dma.c
@@ -285,7 +285,7 @@ done:
  * @dma: DMA channel that uses the buffer
  */
 struct xvip_dma_buffer {
-	struct vb2_buffer buf;
+	struct vb2_v4l2_buffer buf;
 	struct list_head queue;
 	struct xvip_dma *dma;
 };
@@ -301,11 +301,11 @@ static void xvip_dma_complete(void *param)
 	list_del(&buf->queue);
 	spin_unlock(&dma->queued_lock);
 
-	buf->buf.v4l2_buf.field = V4L2_FIELD_NONE;
-	buf->buf.v4l2_buf.sequence = dma->sequence++;
-	v4l2_get_timestamp(&buf->buf.v4l2_buf.timestamp);
-	vb2_set_plane_payload(&buf->buf, 0, dma->format.sizeimage);
-	vb2_buffer_done(&buf->buf, VB2_BUF_STATE_DONE);
+	buf->buf.field = V4L2_FIELD_NONE;
+	buf->buf.sequence = dma->sequence++;
+	v4l2_get_timestamp(&buf->buf.timestamp);
+	vb2_set_plane_payload(&buf->buf.vb2_buf, 0, dma->format.sizeimage);
+	vb2_buffer_done(&buf->buf.vb2_buf, VB2_BUF_STATE_DONE);
 }
 
 static int
@@ -329,8 +329,9 @@ xvip_dma_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 
 static int xvip_dma_buffer_prepare(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct xvip_dma *dma = vb2_get_drv_priv(vb->vb2_queue);
-	struct xvip_dma_buffer *buf = to_xvip_dma_buffer(vb);
+	struct xvip_dma_buffer *buf = to_xvip_dma_buffer(vbuf);
 
 	buf->dma = dma;
 
@@ -339,8 +340,9 @@ static int xvip_dma_buffer_prepare(struct vb2_buffer *vb)
 
 static void xvip_dma_buffer_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct xvip_dma *dma = vb2_get_drv_priv(vb->vb2_queue);
-	struct xvip_dma_buffer *buf = to_xvip_dma_buffer(vb);
+	struct xvip_dma_buffer *buf = to_xvip_dma_buffer(vbuf);
 	struct dma_async_tx_descriptor *desc;
 	dma_addr_t addr = vb2_dma_contig_plane_dma_addr(vb, 0);
 	u32 flags;
@@ -367,7 +369,7 @@ static void xvip_dma_buffer_queue(struct vb2_buffer *vb)
 	desc = dmaengine_prep_interleaved_dma(dma->dma, &dma->xt, flags);
 	if (!desc) {
 		dev_err(dma->xdev->dev, "Failed to prepare DMA transfer\n");
-		vb2_buffer_done(&buf->buf, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->buf.vb2_buf, VB2_BUF_STATE_ERROR);
 		return;
 	}
 	desc->callback = xvip_dma_complete;
@@ -434,7 +436,7 @@ error:
 	/* Give back all queued buffers to videobuf2. */
 	spin_lock_irq(&dma->queued_lock);
 	list_for_each_entry_safe(buf, nbuf, &dma->queued_bufs, queue) {
-		vb2_buffer_done(&buf->buf, VB2_BUF_STATE_QUEUED);
+		vb2_buffer_done(&buf->buf.vb2_buf, VB2_BUF_STATE_QUEUED);
 		list_del(&buf->queue);
 	}
 	spin_unlock_irq(&dma->queued_lock);
@@ -461,7 +463,7 @@ static void xvip_dma_stop_streaming(struct vb2_queue *vq)
 	/* Give back all queued buffers to videobuf2. */
 	spin_lock_irq(&dma->queued_lock);
 	list_for_each_entry_safe(buf, nbuf, &dma->queued_bufs, queue) {
-		vb2_buffer_done(&buf->buf, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->buf.vb2_buf, VB2_BUF_STATE_ERROR);
 		list_del(&buf->queue);
 	}
 	spin_unlock_irq(&dma->queued_lock);
-- 
1.7.9.5

