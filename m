Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:3789 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122AbaBYKEp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Feb 2014 05:04:45 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, s.nawrocki@samsung.com, m.szyprowski@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 01/20] vb2: stop_streaming should return void
Date: Tue, 25 Feb 2014 11:04:06 +0100
Message-Id: <1393322665-29889-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1393322665-29889-1-git-send-email-hverkuil@xs4all.nl>
References: <1393322665-29889-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The vb2 core ignores any return code from the stop_streaming op.
And there really isn't anything it can do anyway in case of an error.
So change the return type to void and update any drivers that implement it.

The int return gave drivers the idea that this operation could actually
fail, but that's really not the case.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/sta2x11/sta2x11_vip.c                  | 3 +--
 drivers/media/platform/blackfin/bfin_capture.c           | 6 +-----
 drivers/media/platform/coda.c                            | 4 +---
 drivers/media/platform/exynos-gsc/gsc-m2m.c              | 4 +---
 drivers/media/platform/exynos4-is/fimc-capture.c         | 6 +++---
 drivers/media/platform/exynos4-is/fimc-lite.c            | 6 +++---
 drivers/media/platform/exynos4-is/fimc-m2m.c             | 3 +--
 drivers/media/platform/marvell-ccic/mcam-core.c          | 7 +++----
 drivers/media/platform/s3c-camif/camif-capture.c         | 4 ++--
 drivers/media/platform/s5p-jpeg/jpeg-core.c              | 4 +---
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c             | 3 +--
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c             | 3 +--
 drivers/media/platform/s5p-tv/mixer_video.c              | 3 +--
 drivers/media/platform/soc_camera/atmel-isi.c            | 6 ++----
 drivers/media/platform/soc_camera/mx2_camera.c           | 4 +---
 drivers/media/platform/soc_camera/mx3_camera.c           | 4 +---
 drivers/media/platform/soc_camera/rcar_vin.c             | 4 +---
 drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c | 4 ++--
 drivers/media/platform/vivi.c                            | 3 +--
 drivers/media/platform/vsp1/vsp1_video.c                 | 4 +---
 drivers/media/usb/em28xx/em28xx-v4l.h                    | 2 +-
 drivers/media/usb/em28xx/em28xx-video.c                  | 8 ++------
 drivers/media/usb/pwc/pwc-if.c                           | 6 ++----
 drivers/media/usb/stk1160/stk1160-v4l.c                  | 4 ++--
 drivers/media/usb/usbtv/usbtv-video.c                    | 9 +++------
 drivers/staging/media/davinci_vpfe/vpfe_video.c          | 3 +--
 drivers/staging/media/dt3155v4l/dt3155v4l.c              | 3 +--
 drivers/staging/media/go7007/go7007-v4l2.c               | 3 +--
 drivers/staging/media/msi3101/sdr-msi3101.c              | 6 ++----
 drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c       | 3 +--
 drivers/staging/media/solo6x10/solo6x10-v4l2.c           | 3 +--
 include/media/videobuf2-core.h                           | 2 +-
 32 files changed, 47 insertions(+), 90 deletions(-)

diff --git a/drivers/media/pci/sta2x11/sta2x11_vip.c b/drivers/media/pci/sta2x11/sta2x11_vip.c
index bb11443..7559951 100644
--- a/drivers/media/pci/sta2x11/sta2x11_vip.c
+++ b/drivers/media/pci/sta2x11/sta2x11_vip.c
@@ -357,7 +357,7 @@ static int start_streaming(struct vb2_queue *vq, unsigned int count)
 }
 
 /* abort streaming and wait for last buffer */
-static int stop_streaming(struct vb2_queue *vq)
+static void stop_streaming(struct vb2_queue *vq)
 {
 	struct sta2x11_vip *vip = vb2_get_drv_priv(vq);
 	struct vip_buffer *vip_buf, *node;
@@ -374,7 +374,6 @@ static int stop_streaming(struct vb2_queue *vq)
 		list_del(&vip_buf->list);
 	}
 	spin_unlock(&vip->lock);
-	return 0;
 }
 
 static struct vb2_ops vip_video_qops = {
diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index 2819165..cf7ceec 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -427,15 +427,12 @@ static int bcap_start_streaming(struct vb2_queue *vq, unsigned int count)
 	return 0;
 }
 
-static int bcap_stop_streaming(struct vb2_queue *vq)
+static void bcap_stop_streaming(struct vb2_queue *vq)
 {
 	struct bcap_device *bcap_dev = vb2_get_drv_priv(vq);
 	struct ppi_if *ppi = bcap_dev->ppi;
 	int ret;
 
-	if (!vb2_is_streaming(vq))
-		return 0;
-
 	bcap_dev->stop = true;
 	wait_for_completion(&bcap_dev->comp);
 	ppi->ops->stop(ppi);
@@ -452,7 +449,6 @@ static int bcap_stop_streaming(struct vb2_queue *vq)
 		list_del(&bcap_dev->cur_frm->list);
 		vb2_buffer_done(&bcap_dev->cur_frm->vb, VB2_BUF_STATE_ERROR);
 	}
-	return 0;
 }
 
 static struct vb2_ops bcap_video_qops = {
diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 61f3dbc..9e6cf97 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -2269,7 +2269,7 @@ out:
 	return ret;
 }
 
-static int coda_stop_streaming(struct vb2_queue *q)
+static void coda_stop_streaming(struct vb2_queue *q)
 {
 	struct coda_ctx *ctx = vb2_get_drv_priv(q);
 	struct coda_dev *dev = ctx->dev;
@@ -2295,8 +2295,6 @@ static int coda_stop_streaming(struct vb2_queue *q)
 			ctx->bitstream.vaddr, ctx->bitstream.size);
 		ctx->runcounter = 0;
 	}
-
-	return 0;
 }
 
 static struct vb2_ops coda_qops = {
diff --git a/drivers/media/platform/exynos-gsc/gsc-m2m.c b/drivers/media/platform/exynos-gsc/gsc-m2m.c
index 810c3e1..6dbf0ad 100644
--- a/drivers/media/platform/exynos-gsc/gsc-m2m.c
+++ b/drivers/media/platform/exynos-gsc/gsc-m2m.c
@@ -66,15 +66,13 @@ static int gsc_m2m_start_streaming(struct vb2_queue *q, unsigned int count)
 	return ret > 0 ? 0 : ret;
 }
 
-static int gsc_m2m_stop_streaming(struct vb2_queue *q)
+static void gsc_m2m_stop_streaming(struct vb2_queue *q)
 {
 	struct gsc_ctx *ctx = q->drv_priv;
 
 	__gsc_m2m_job_abort(ctx);
 
 	pm_runtime_put(&ctx->gsc_dev->pdev->dev);
-
-	return 0;
 }
 
 void gsc_m2m_job_finish(struct gsc_ctx *ctx, int vb_state)
diff --git a/drivers/media/platform/exynos4-is/fimc-capture.c b/drivers/media/platform/exynos4-is/fimc-capture.c
index 8a712ca..6bfacd0 100644
--- a/drivers/media/platform/exynos4-is/fimc-capture.c
+++ b/drivers/media/platform/exynos4-is/fimc-capture.c
@@ -294,15 +294,15 @@ static int start_streaming(struct vb2_queue *q, unsigned int count)
 	return 0;
 }
 
-static int stop_streaming(struct vb2_queue *q)
+static void stop_streaming(struct vb2_queue *q)
 {
 	struct fimc_ctx *ctx = q->drv_priv;
 	struct fimc_dev *fimc = ctx->fimc_dev;
 
 	if (!fimc_capture_active(fimc))
-		return -EINVAL;
+		return;
 
-	return fimc_stop_capture(fimc, false);
+	fimc_stop_capture(fimc, false);
 }
 
 int fimc_capture_suspend(struct fimc_dev *fimc)
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index 1234734..d4b0856 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -350,14 +350,14 @@ static int start_streaming(struct vb2_queue *q, unsigned int count)
 	return 0;
 }
 
-static int stop_streaming(struct vb2_queue *q)
+static void stop_streaming(struct vb2_queue *q)
 {
 	struct fimc_lite *fimc = q->drv_priv;
 
 	if (!fimc_lite_active(fimc))
-		return -EINVAL;
+		return;
 
-	return fimc_lite_stop_capture(fimc, false);
+	fimc_lite_stop_capture(fimc, false);
 }
 
 static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *pfmt,
diff --git a/drivers/media/platform/exynos4-is/fimc-m2m.c b/drivers/media/platform/exynos4-is/fimc-m2m.c
index 9da95bd..c78c744 100644
--- a/drivers/media/platform/exynos4-is/fimc-m2m.c
+++ b/drivers/media/platform/exynos4-is/fimc-m2m.c
@@ -85,7 +85,7 @@ static int start_streaming(struct vb2_queue *q, unsigned int count)
 	return ret > 0 ? 0 : ret;
 }
 
-static int stop_streaming(struct vb2_queue *q)
+static void stop_streaming(struct vb2_queue *q)
 {
 	struct fimc_ctx *ctx = q->drv_priv;
 	int ret;
@@ -95,7 +95,6 @@ static int stop_streaming(struct vb2_queue *q)
 		fimc_m2m_job_finish(ctx, VB2_BUF_STATE_ERROR);
 
 	pm_runtime_put(&ctx->fimc_dev->pdev->dev);
-	return 0;
 }
 
 static void fimc_device_run(void *priv)
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index 8b34c48..be4b512 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -1156,7 +1156,7 @@ static int mcam_vb_start_streaming(struct vb2_queue *vq, unsigned int count)
 	return mcam_read_setup(cam);
 }
 
-static int mcam_vb_stop_streaming(struct vb2_queue *vq)
+static void mcam_vb_stop_streaming(struct vb2_queue *vq)
 {
 	struct mcam_camera *cam = vb2_get_drv_priv(vq);
 	unsigned long flags;
@@ -1164,10 +1164,10 @@ static int mcam_vb_stop_streaming(struct vb2_queue *vq)
 	if (cam->state == S_BUFWAIT) {
 		/* They never gave us buffers */
 		cam->state = S_IDLE;
-		return 0;
+		return;
 	}
 	if (cam->state != S_STREAMING)
-		return -EINVAL;
+		return;
 	mcam_ctlr_stop_dma(cam);
 	/*
 	 * Reset the CCIC PHY after stopping streaming,
@@ -1182,7 +1182,6 @@ static int mcam_vb_stop_streaming(struct vb2_queue *vq)
 	spin_lock_irqsave(&cam->dev_lock, flags);
 	INIT_LIST_HEAD(&cam->buffers);
 	spin_unlock_irqrestore(&cam->dev_lock, flags);
-	return 0;
 }
 
 
diff --git a/drivers/media/platform/s3c-camif/camif-capture.c b/drivers/media/platform/s3c-camif/camif-capture.c
index 5372111..9989491 100644
--- a/drivers/media/platform/s3c-camif/camif-capture.c
+++ b/drivers/media/platform/s3c-camif/camif-capture.c
@@ -435,10 +435,10 @@ static int start_streaming(struct vb2_queue *vq, unsigned int count)
 	return 0;
 }
 
-static int stop_streaming(struct vb2_queue *vq)
+static void stop_streaming(struct vb2_queue *vq)
 {
 	struct camif_vp *vp = vb2_get_drv_priv(vq);
-	return camif_stop_capture(vp);
+	camif_stop_capture(vp);
 }
 
 static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *pfmt,
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index a1c78c8..3722852 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -1670,13 +1670,11 @@ static int s5p_jpeg_start_streaming(struct vb2_queue *q, unsigned int count)
 	return ret > 0 ? 0 : ret;
 }
 
-static int s5p_jpeg_stop_streaming(struct vb2_queue *q)
+static void s5p_jpeg_stop_streaming(struct vb2_queue *q)
 {
 	struct s5p_jpeg_ctx *ctx = vb2_get_drv_priv(q);
 
 	pm_runtime_put(ctx->jpeg->dev);
-
-	return 0;
 }
 
 static struct vb2_ops s5p_jpeg_qops = {
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index 8faf969..58b7bba 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -1027,7 +1027,7 @@ static int s5p_mfc_start_streaming(struct vb2_queue *q, unsigned int count)
 	return 0;
 }
 
-static int s5p_mfc_stop_streaming(struct vb2_queue *q)
+static void s5p_mfc_stop_streaming(struct vb2_queue *q)
 {
 	unsigned long flags;
 	struct s5p_mfc_ctx *ctx = fh_to_ctx(q->drv_priv);
@@ -1071,7 +1071,6 @@ static int s5p_mfc_stop_streaming(struct vb2_queue *q)
 	}
 	if (aborted)
 		ctx->state = MFCINST_RUNNING;
-	return 0;
 }
 
 
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index 91b6e02..7efd45d 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -1930,7 +1930,7 @@ static int s5p_mfc_start_streaming(struct vb2_queue *q, unsigned int count)
 	return 0;
 }
 
-static int s5p_mfc_stop_streaming(struct vb2_queue *q)
+static void s5p_mfc_stop_streaming(struct vb2_queue *q)
 {
 	unsigned long flags;
 	struct s5p_mfc_ctx *ctx = fh_to_ctx(q->drv_priv);
@@ -1959,7 +1959,6 @@ static int s5p_mfc_stop_streaming(struct vb2_queue *q)
 		ctx->src_queue_cnt = 0;
 	}
 	spin_unlock_irqrestore(&dev->irqlock, flags);
-	return 0;
 }
 
 static void s5p_mfc_buf_queue(struct vb2_buffer *vb)
diff --git a/drivers/media/platform/s5p-tv/mixer_video.c b/drivers/media/platform/s5p-tv/mixer_video.c
index a1ce55f..9f1e52f 100644
--- a/drivers/media/platform/s5p-tv/mixer_video.c
+++ b/drivers/media/platform/s5p-tv/mixer_video.c
@@ -985,7 +985,7 @@ static void mxr_watchdog(unsigned long arg)
 	spin_unlock_irqrestore(&layer->enq_slock, flags);
 }
 
-static int stop_streaming(struct vb2_queue *vq)
+static void stop_streaming(struct vb2_queue *vq)
 {
 	struct mxr_layer *layer = vb2_get_drv_priv(vq);
 	struct mxr_device *mdev = layer->mdev;
@@ -1031,7 +1031,6 @@ static int stop_streaming(struct vb2_queue *vq)
 	mxr_streamer_put(mdev);
 	/* allow changes in output configuration */
 	mxr_output_put(mdev);
-	return 0;
 }
 
 static struct vb2_ops mxr_video_qops = {
diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index 4835173..1d7f60e 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -406,7 +406,7 @@ static int start_streaming(struct vb2_queue *vq, unsigned int count)
 }
 
 /* abort streaming and wait for last buffer */
-static int stop_streaming(struct vb2_queue *vq)
+static void stop_streaming(struct vb2_queue *vq)
 {
 	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
@@ -433,7 +433,7 @@ static int stop_streaming(struct vb2_queue *vq)
 	if (time_after(jiffies, timeout)) {
 		dev_err(icd->parent,
 			"Timeout waiting for finishing codec request\n");
-		return -ETIMEDOUT;
+		return;
 	}
 
 	/* Disable interrupts */
@@ -444,8 +444,6 @@ static int stop_streaming(struct vb2_queue *vq)
 	ret = atmel_isi_wait_status(isi, WAIT_ISI_DISABLE);
 	if (ret < 0)
 		dev_err(icd->parent, "Disable ISI timed out\n");
-
-	return ret;
 }
 
 static struct vb2_ops isi_video_qops = {
diff --git a/drivers/media/platform/soc_camera/mx2_camera.c b/drivers/media/platform/soc_camera/mx2_camera.c
index d73abca..d88c2d4 100644
--- a/drivers/media/platform/soc_camera/mx2_camera.c
+++ b/drivers/media/platform/soc_camera/mx2_camera.c
@@ -741,7 +741,7 @@ static int mx2_start_streaming(struct vb2_queue *q, unsigned int count)
 	return 0;
 }
 
-static int mx2_stop_streaming(struct vb2_queue *q)
+static void mx2_stop_streaming(struct vb2_queue *q)
 {
 	struct soc_camera_device *icd = soc_camera_from_vb2q(q);
 	struct soc_camera_host *ici =
@@ -773,8 +773,6 @@ static int mx2_stop_streaming(struct vb2_queue *q)
 
 	dma_free_coherent(ici->v4l2_dev.dev,
 			  pcdev->discard_size, b, pcdev->discard_buffer_dma);
-
-	return 0;
 }
 
 static struct vb2_ops mx2_videobuf_ops = {
diff --git a/drivers/media/platform/soc_camera/mx3_camera.c b/drivers/media/platform/soc_camera/mx3_camera.c
index f975b70..4f6d5b67 100644
--- a/drivers/media/platform/soc_camera/mx3_camera.c
+++ b/drivers/media/platform/soc_camera/mx3_camera.c
@@ -406,7 +406,7 @@ static int mx3_videobuf_init(struct vb2_buffer *vb)
 	return 0;
 }
 
-static int mx3_stop_streaming(struct vb2_queue *q)
+static void mx3_stop_streaming(struct vb2_queue *q)
 {
 	struct soc_camera_device *icd = soc_camera_from_vb2q(q);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
@@ -605,8 +605,6 @@ static int mx3_camera_try_bus_param(struct soc_camera_device *icd,
 	} else if (ret != -ENOIOCTLCMD) {
 		return ret;
 	}
-
-	return 0;
 }
 
 static bool chan_filter(struct dma_chan *chan, void *arg)
diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index 3b1c05a..16eae33 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -505,7 +505,7 @@ static int rcar_vin_videobuf_init(struct vb2_buffer *vb)
 	return 0;
 }
 
-static int rcar_vin_stop_streaming(struct vb2_queue *vq)
+static void rcar_vin_stop_streaming(struct vb2_queue *vq)
 {
 	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
@@ -516,8 +516,6 @@ static int rcar_vin_stop_streaming(struct vb2_queue *vq)
 	list_for_each_safe(buf_head, tmp, &priv->capture)
 		list_del_init(buf_head);
 	spin_unlock_irq(&priv->lock);
-
-	return 0;
 }
 
 static struct vb2_ops rcar_vin_vb2_ops = {
diff --git a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
index 150bd4d..abaf736 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
@@ -471,7 +471,7 @@ static int sh_mobile_ceu_videobuf_init(struct vb2_buffer *vb)
 	return 0;
 }
 
-static int sh_mobile_ceu_stop_streaming(struct vb2_queue *q)
+static void sh_mobile_ceu_stop_streaming(struct vb2_queue *q)
 {
 	struct soc_camera_device *icd = container_of(q, struct soc_camera_device, vb2_vidq);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
@@ -487,7 +487,7 @@ static int sh_mobile_ceu_stop_streaming(struct vb2_queue *q)
 
 	spin_unlock_irq(&pcdev->lock);
 
-	return sh_mobile_ceu_soft_reset(pcdev);
+	sh_mobile_ceu_soft_reset(pcdev);
 }
 
 static struct vb2_ops sh_mobile_ceu_videobuf_ops = {
diff --git a/drivers/media/platform/vivi.c b/drivers/media/platform/vivi.c
index 643937b..f4ac1f9 100644
--- a/drivers/media/platform/vivi.c
+++ b/drivers/media/platform/vivi.c
@@ -906,12 +906,11 @@ static int start_streaming(struct vb2_queue *vq, unsigned int count)
 }
 
 /* abort streaming and wait for last buffer */
-static int stop_streaming(struct vb2_queue *vq)
+static void stop_streaming(struct vb2_queue *vq)
 {
 	struct vivi_dev *dev = vb2_get_drv_priv(vq);
 	dprintk(dev, 1, "%s\n", __func__);
 	vivi_stop_generating(dev);
-	return 0;
 }
 
 static void vivi_lock(struct vb2_queue *vq)
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index b4687a8..f86c270 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -720,7 +720,7 @@ static int vsp1_video_start_streaming(struct vb2_queue *vq, unsigned int count)
 	return 0;
 }
 
-static int vsp1_video_stop_streaming(struct vb2_queue *vq)
+static void vsp1_video_stop_streaming(struct vb2_queue *vq)
 {
 	struct vsp1_video *video = vb2_get_drv_priv(vq);
 	struct vsp1_pipeline *pipe = to_vsp1_pipeline(&video->video.entity);
@@ -743,8 +743,6 @@ static int vsp1_video_stop_streaming(struct vb2_queue *vq)
 	spin_lock_irqsave(&video->irqlock, flags);
 	INIT_LIST_HEAD(&video->irqqueue);
 	spin_unlock_irqrestore(&video->irqlock, flags);
-
-	return 0;
 }
 
 static struct vb2_ops vsp1_video_queue_qops = {
diff --git a/drivers/media/usb/em28xx/em28xx-v4l.h b/drivers/media/usb/em28xx/em28xx-v4l.h
index bce4386..432862c 100644
--- a/drivers/media/usb/em28xx/em28xx-v4l.h
+++ b/drivers/media/usb/em28xx/em28xx-v4l.h
@@ -16,5 +16,5 @@
 
 
 int em28xx_start_analog_streaming(struct vb2_queue *vq, unsigned int count);
-int em28xx_stop_vbi_streaming(struct vb2_queue *vq);
+void em28xx_stop_vbi_streaming(struct vb2_queue *vq);
 extern struct vb2_ops em28xx_vbi_qops;
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 2775c90..7f91d13 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -937,7 +937,7 @@ int em28xx_start_analog_streaming(struct vb2_queue *vq, unsigned int count)
 	return rc;
 }
 
-static int em28xx_stop_streaming(struct vb2_queue *vq)
+static void em28xx_stop_streaming(struct vb2_queue *vq)
 {
 	struct em28xx *dev = vb2_get_drv_priv(vq);
 	struct em28xx_dmaqueue *vidq = &dev->vidq;
@@ -961,11 +961,9 @@ static int em28xx_stop_streaming(struct vb2_queue *vq)
 	}
 	dev->usb_ctl.vid_buf = NULL;
 	spin_unlock_irqrestore(&dev->slock, flags);
-
-	return 0;
 }
 
-int em28xx_stop_vbi_streaming(struct vb2_queue *vq)
+void em28xx_stop_vbi_streaming(struct vb2_queue *vq)
 {
 	struct em28xx *dev = vb2_get_drv_priv(vq);
 	struct em28xx_dmaqueue *vbiq = &dev->vbiq;
@@ -989,8 +987,6 @@ int em28xx_stop_vbi_streaming(struct vb2_queue *vq)
 	}
 	dev->usb_ctl.vbi_buf = NULL;
 	spin_unlock_irqrestore(&dev->slock, flags);
-
-	return 0;
 }
 
 static void
diff --git a/drivers/media/usb/pwc/pwc-if.c b/drivers/media/usb/pwc/pwc-if.c
index b9c9f10..ed25007 100644
--- a/drivers/media/usb/pwc/pwc-if.c
+++ b/drivers/media/usb/pwc/pwc-if.c
@@ -680,12 +680,12 @@ static int start_streaming(struct vb2_queue *vq, unsigned int count)
 	return r;
 }
 
-static int stop_streaming(struct vb2_queue *vq)
+static void stop_streaming(struct vb2_queue *vq)
 {
 	struct pwc_device *pdev = vb2_get_drv_priv(vq);
 
 	if (mutex_lock_interruptible(&pdev->v4l2_lock))
-		return -ERESTARTSYS;
+		return;
 	if (pdev->udev) {
 		pwc_set_leds(pdev, 0, 0);
 		pwc_camera_power(pdev, 0);
@@ -694,8 +694,6 @@ static int stop_streaming(struct vb2_queue *vq)
 
 	pwc_cleanup_queued_bufs(pdev);
 	mutex_unlock(&pdev->v4l2_lock);
-
-	return 0;
 }
 
 static struct vb2_ops pwc_vb_queue_ops = {
diff --git a/drivers/media/usb/stk1160/stk1160-v4l.c b/drivers/media/usb/stk1160/stk1160-v4l.c
index c45c988..40029e0 100644
--- a/drivers/media/usb/stk1160/stk1160-v4l.c
+++ b/drivers/media/usb/stk1160/stk1160-v4l.c
@@ -583,10 +583,10 @@ static int start_streaming(struct vb2_queue *vq, unsigned int count)
 }
 
 /* abort streaming and wait for last buffer */
-static int stop_streaming(struct vb2_queue *vq)
+static void stop_streaming(struct vb2_queue *vq)
 {
 	struct stk1160 *dev = vb2_get_drv_priv(vq);
-	return stk1160_stop_streaming(dev);
+	stk1160_stop_streaming(dev);
 }
 
 static struct vb2_ops stk1160_video_qops = {
diff --git a/drivers/media/usb/usbtv/usbtv-video.c b/drivers/media/usb/usbtv/usbtv-video.c
index 496bc2e..bc75f42 100644
--- a/drivers/media/usb/usbtv/usbtv-video.c
+++ b/drivers/media/usb/usbtv/usbtv-video.c
@@ -634,15 +634,12 @@ static int usbtv_start_streaming(struct vb2_queue *vq, unsigned int count)
 	return usbtv_start(usbtv);
 }
 
-static int usbtv_stop_streaming(struct vb2_queue *vq)
+static void usbtv_stop_streaming(struct vb2_queue *vq)
 {
 	struct usbtv *usbtv = vb2_get_drv_priv(vq);
 
-	if (usbtv->udev == NULL)
-		return -ENODEV;
-
-	usbtv_stop(usbtv);
-	return 0;
+	if (usbtv->udev)
+		usbtv_stop(usbtv);
 }
 
 struct vb2_ops usbtv_vb2_ops = {
diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
index 8c101cb..baeceee 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
@@ -1242,7 +1242,7 @@ static int vpfe_buffer_init(struct vb2_buffer *vb)
 }
 
 /* abort streaming and wait for last buffer */
-static int vpfe_stop_streaming(struct vb2_queue *vq)
+static void vpfe_stop_streaming(struct vb2_queue *vq)
 {
 	struct vpfe_fh *fh = vb2_get_drv_priv(vq);
 	struct vpfe_video_device *video = fh->video;
@@ -1256,7 +1256,6 @@ static int vpfe_stop_streaming(struct vb2_queue *vq)
 		list_del(&video->next_frm->list);
 		vb2_buffer_done(&video->next_frm->vb, VB2_BUF_STATE_ERROR);
 	}
-	return 0;
 }
 
 static void vpfe_buf_cleanup(struct vb2_buffer *vb)
diff --git a/drivers/staging/media/dt3155v4l/dt3155v4l.c b/drivers/staging/media/dt3155v4l/dt3155v4l.c
index e729e52..a57f706 100644
--- a/drivers/staging/media/dt3155v4l/dt3155v4l.c
+++ b/drivers/staging/media/dt3155v4l/dt3155v4l.c
@@ -263,7 +263,7 @@ dt3155_buf_prepare(struct vb2_buffer *vb)
 	return 0;
 }
 
-static int
+static void
 dt3155_stop_streaming(struct vb2_queue *q)
 {
 	struct dt3155_priv *pd = vb2_get_drv_priv(q);
@@ -277,7 +277,6 @@ dt3155_stop_streaming(struct vb2_queue *q)
 	}
 	spin_unlock_irq(&pd->lock);
 	msleep(45); /* irq hendler will stop the hardware */
-	return 0;
 }
 
 static void
diff --git a/drivers/staging/media/go7007/go7007-v4l2.c b/drivers/staging/media/go7007/go7007-v4l2.c
index 3a01576..3965723 100644
--- a/drivers/staging/media/go7007/go7007-v4l2.c
+++ b/drivers/staging/media/go7007/go7007-v4l2.c
@@ -515,7 +515,7 @@ static int go7007_start_streaming(struct vb2_queue *q, unsigned int count)
 	return ret;
 }
 
-static int go7007_stop_streaming(struct vb2_queue *q)
+static void go7007_stop_streaming(struct vb2_queue *q)
 {
 	struct go7007 *go = vb2_get_drv_priv(q);
 	unsigned long flags;
@@ -537,7 +537,6 @@ static int go7007_stop_streaming(struct vb2_queue *q)
 	/* Turn on Capture LED */
 	if (go->board_id == GO7007_BOARDID_ADS_USBAV_709)
 		go7007_write_addr(go, 0x3c82, 0x000d);
-	return 0;
 }
 
 static struct vb2_ops go7007_video_qops = {
diff --git a/drivers/staging/media/msi3101/sdr-msi3101.c b/drivers/staging/media/msi3101/sdr-msi3101.c
index 4c3bf77..e6a1a0a 100644
--- a/drivers/staging/media/msi3101/sdr-msi3101.c
+++ b/drivers/staging/media/msi3101/sdr-msi3101.c
@@ -1577,13 +1577,13 @@ static int msi3101_start_streaming(struct vb2_queue *vq, unsigned int count)
 	return ret;
 }
 
-static int msi3101_stop_streaming(struct vb2_queue *vq)
+static void msi3101_stop_streaming(struct vb2_queue *vq)
 {
 	struct msi3101_state *s = vb2_get_drv_priv(vq);
 	dev_dbg(&s->udev->dev, "%s:\n", __func__);
 
 	if (mutex_lock_interruptible(&s->v4l2_lock))
-		return -ERESTARTSYS;
+		return;
 
 	if (s->udev)
 		msi3101_isoc_cleanup(s);
@@ -1595,8 +1595,6 @@ static int msi3101_stop_streaming(struct vb2_queue *vq)
 	msi3101_ctrl_msg(s, CMD_STOP_STREAMING, 0);
 
 	mutex_unlock(&s->v4l2_lock);
-
-	return 0;
 }
 
 static struct vb2_ops msi3101_vb2_ops = {
diff --git a/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c b/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
index ce9e5aa..5008b0f 100644
--- a/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
+++ b/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
@@ -741,14 +741,13 @@ static int solo_enc_start_streaming(struct vb2_queue *q, unsigned int count)
 	return solo_ring_start(solo_enc->solo_dev);
 }
 
-static int solo_enc_stop_streaming(struct vb2_queue *q)
+static void solo_enc_stop_streaming(struct vb2_queue *q)
 {
 	struct solo_enc_dev *solo_enc = vb2_get_drv_priv(q);
 
 	solo_enc_off(solo_enc);
 	INIT_LIST_HEAD(&solo_enc->vidq_active);
 	solo_ring_stop(solo_enc->solo_dev);
-	return 0;
 }
 
 static struct vb2_ops solo_enc_video_qops = {
diff --git a/drivers/staging/media/solo6x10/solo6x10-v4l2.c b/drivers/staging/media/solo6x10/solo6x10-v4l2.c
index 47e72da..413b0ff 100644
--- a/drivers/staging/media/solo6x10/solo6x10-v4l2.c
+++ b/drivers/staging/media/solo6x10/solo6x10-v4l2.c
@@ -336,13 +336,12 @@ static int solo_start_streaming(struct vb2_queue *q, unsigned int count)
 	return solo_start_thread(solo_dev);
 }
 
-static int solo_stop_streaming(struct vb2_queue *q)
+static void solo_stop_streaming(struct vb2_queue *q)
 {
 	struct solo_dev *solo_dev = vb2_get_drv_priv(q);
 
 	solo_stop_thread(solo_dev);
 	INIT_LIST_HEAD(&solo_dev->vidq_active);
-	return 0;
 }
 
 static void solo_buf_queue(struct vb2_buffer *vb)
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 2ada71b..cb14c1a 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -317,7 +317,7 @@ struct vb2_ops {
 	void (*buf_cleanup)(struct vb2_buffer *vb);
 
 	int (*start_streaming)(struct vb2_queue *q, unsigned int count);
-	int (*stop_streaming)(struct vb2_queue *q);
+	void (*stop_streaming)(struct vb2_queue *q);
 
 	void (*buf_queue)(struct vb2_buffer *vb);
 };
-- 
1.9.0

