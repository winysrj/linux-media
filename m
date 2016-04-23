Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:37983 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751884AbcDWLEL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Apr 2016 07:04:11 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Ludovic Desroches <ludovic.desroches@atmel.com>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: [PATCHv4 10/13] media/.../soc-camera: convert drivers to use the new vb2_queue dev field
Date: Sat, 23 Apr 2016 13:03:46 +0200
Message-Id: <1461409429-24995-11-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1461409429-24995-1-git-send-email-hverkuil@xs4all.nl>
References: <1461409429-24995-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Stop using alloc_ctx and just fill in the device pointer.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Ludovic Desroches <ludovic.desroches@atmel.com>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
---
 drivers/media/platform/soc_camera/atmel-isi.c           | 13 +------------
 drivers/media/platform/soc_camera/rcar_vin.c            | 12 +-----------
 .../media/platform/soc_camera/sh_mobile_ceu_camera.c    | 15 ++-------------
 drivers/staging/media/mx2/mx2_camera.c                  | 17 +++--------------
 drivers/staging/media/mx3/mx3_camera.c                  | 16 ++--------------
 5 files changed, 9 insertions(+), 64 deletions(-)

diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index ab2d9b9..899b93a 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -72,8 +72,6 @@ struct atmel_isi {
 
 	int				sequence;
 
-	struct vb2_alloc_ctx		*alloc_ctx;
-
 	/* Allocate descriptors for dma buffer use */
 	struct fbd			*p_fb_descriptors;
 	dma_addr_t			fb_descriptors_phys;
@@ -322,7 +320,6 @@ static int queue_setup(struct vb2_queue *vq,
 
 	*nplanes = 1;
 	sizes[0] = size;
-	alloc_ctxs[0] = isi->alloc_ctx;
 
 	isi->sequence = 0;
 	isi->active = NULL;
@@ -567,6 +564,7 @@ static int isi_camera_init_videobuf(struct vb2_queue *q,
 	q->mem_ops = &vb2_dma_contig_memops;
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	q->lock = &ici->host_lock;
+	q->dev = ici->v4l2_dev.dev;
 
 	return vb2_queue_init(q);
 }
@@ -963,7 +961,6 @@ static int atmel_isi_remove(struct platform_device *pdev)
 					struct atmel_isi, soc_host);
 
 	soc_camera_host_unregister(soc_host);
-	vb2_dma_contig_cleanup_ctx(isi->alloc_ctx);
 	dma_free_coherent(&pdev->dev,
 			sizeof(struct fbd) * MAX_BUFFER_NUM,
 			isi->p_fb_descriptors,
@@ -1067,12 +1064,6 @@ static int atmel_isi_probe(struct platform_device *pdev)
 		list_add(&isi->dma_desc[i].list, &isi->dma_desc_head);
 	}
 
-	isi->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
-	if (IS_ERR(isi->alloc_ctx)) {
-		ret = PTR_ERR(isi->alloc_ctx);
-		goto err_alloc_ctx;
-	}
-
 	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	isi->regs = devm_ioremap_resource(&pdev->dev, regs);
 	if (IS_ERR(isi->regs)) {
@@ -1119,8 +1110,6 @@ err_register_soc_camera_host:
 	pm_runtime_disable(&pdev->dev);
 err_req_irq:
 err_ioremap:
-	vb2_dma_contig_cleanup_ctx(isi->alloc_ctx);
-err_alloc_ctx:
 	dma_free_coherent(&pdev->dev,
 			sizeof(struct fbd) * MAX_BUFFER_NUM,
 			isi->p_fb_descriptors,
diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index 3f9c1b8..dadc5b3 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -484,7 +484,6 @@ struct rcar_vin_priv {
 	struct list_head		capture;
 #define MAX_BUFFER_NUM			3
 	struct vb2_v4l2_buffer		*queue_buf[MAX_BUFFER_NUM];
-	struct vb2_alloc_ctx		*alloc_ctx;
 	enum v4l2_field			field;
 	unsigned int			pdata_flags;
 	unsigned int			vb_count;
@@ -540,8 +539,6 @@ static int rcar_vin_videobuf_setup(struct vb2_queue *vq,
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct rcar_vin_priv *priv = ici->priv;
 
-	alloc_ctxs[0] = priv->alloc_ctx;
-
 	if (!vq->num_buffers)
 		priv->sequence = 0;
 
@@ -1816,6 +1813,7 @@ static int rcar_vin_init_videobuf2(struct vb2_queue *vq,
 	vq->buf_struct_size = sizeof(struct rcar_vin_buffer);
 	vq->timestamp_flags  = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	vq->lock = &ici->host_lock;
+	vq->dev = ici->v4l2_dev.dev;
 
 	return vb2_queue_init(vq);
 }
@@ -1912,10 +1910,6 @@ static int rcar_vin_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	priv->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
-	if (IS_ERR(priv->alloc_ctx))
-		return PTR_ERR(priv->alloc_ctx);
-
 	priv->ici.priv = priv;
 	priv->ici.v4l2_dev.dev = &pdev->dev;
 	priv->ici.drv_name = dev_name(&pdev->dev);
@@ -1946,7 +1940,6 @@ static int rcar_vin_probe(struct platform_device *pdev)
 
 cleanup:
 	pm_runtime_disable(&pdev->dev);
-	vb2_dma_contig_cleanup_ctx(priv->alloc_ctx);
 
 	return ret;
 }
@@ -1954,12 +1947,9 @@ cleanup:
 static int rcar_vin_remove(struct platform_device *pdev)
 {
 	struct soc_camera_host *soc_host = to_soc_camera_host(&pdev->dev);
-	struct rcar_vin_priv *priv = container_of(soc_host,
-						  struct rcar_vin_priv, ici);
 
 	soc_camera_host_unregister(soc_host);
 	pm_runtime_disable(&pdev->dev);
-	vb2_dma_contig_cleanup_ctx(priv->alloc_ctx);
 
 	return 0;
 }
diff --git a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
index b9f369c..8f87fbe 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
@@ -113,7 +113,6 @@ struct sh_mobile_ceu_dev {
 	spinlock_t lock;		/* Protects video buffer lists */
 	struct list_head capture;
 	struct vb2_v4l2_buffer *active;
-	struct vb2_alloc_ctx *alloc_ctx;
 
 	struct sh_mobile_ceu_info *pdata;
 	struct completion complete;
@@ -217,8 +216,6 @@ static int sh_mobile_ceu_videobuf_setup(struct vb2_queue *vq,
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
 
-	alloc_ctxs[0] = pcdev->alloc_ctx;
-
 	if (!vq->num_buffers)
 		pcdev->sequence = 0;
 
@@ -1670,6 +1667,7 @@ static int sh_mobile_ceu_init_videobuf(struct vb2_queue *q,
 	q->buf_struct_size = sizeof(struct sh_mobile_ceu_buffer);
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	q->lock = &ici->host_lock;
+	q->dev = ici->v4l2_dev.dev;
 
 	return vb2_queue_init(q);
 }
@@ -1822,12 +1820,6 @@ static int sh_mobile_ceu_probe(struct platform_device *pdev)
 	pcdev->ici.ops = &sh_mobile_ceu_host_ops;
 	pcdev->ici.capabilities = SOCAM_HOST_CAP_STRIDE;
 
-	pcdev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
-	if (IS_ERR(pcdev->alloc_ctx)) {
-		err = PTR_ERR(pcdev->alloc_ctx);
-		goto exit_free_clk;
-	}
-
 	if (pcdev->pdata && pcdev->pdata->asd_sizes) {
 		struct v4l2_async_subdev **asd;
 		char name[] = "sh-mobile-csi2";
@@ -1872,7 +1864,7 @@ static int sh_mobile_ceu_probe(struct platform_device *pdev)
 
 		if (!csi2_pdev) {
 			err = -ENOMEM;
-			goto exit_free_ctx;
+			goto exit_free_clk;
 		}
 
 		pcdev->csi2_pdev		= csi2_pdev;
@@ -1955,8 +1947,6 @@ exit_pdev_put:
 		pcdev->csi2_pdev->resource = NULL;
 		platform_device_put(pcdev->csi2_pdev);
 	}
-exit_free_ctx:
-	vb2_dma_contig_cleanup_ctx(pcdev->alloc_ctx);
 exit_free_clk:
 	pm_runtime_disable(&pdev->dev);
 exit_release_mem:
@@ -1976,7 +1966,6 @@ static int sh_mobile_ceu_remove(struct platform_device *pdev)
 	pm_runtime_disable(&pdev->dev);
 	if (platform_get_resource(pdev, IORESOURCE_MEM, 1))
 		dma_release_declared_memory(&pdev->dev);
-	vb2_dma_contig_cleanup_ctx(pcdev->alloc_ctx);
 	if (csi2_pdev && csi2_pdev->dev.driver) {
 		struct module *csi2_drv = csi2_pdev->dev.driver->owner;
 		platform_device_del(csi2_pdev);
diff --git a/drivers/staging/media/mx2/mx2_camera.c b/drivers/staging/media/mx2/mx2_camera.c
index 48dd5b7..b5d0e60 100644
--- a/drivers/staging/media/mx2/mx2_camera.c
+++ b/drivers/staging/media/mx2/mx2_camera.c
@@ -266,7 +266,6 @@ struct mx2_camera_dev {
 	struct emma_prp_resize	resizing[2];
 	unsigned int		s_width, s_height;
 	u32			frame_count;
-	struct vb2_alloc_ctx	*alloc_ctx;
 };
 
 static struct platform_device_id mx2_camera_devtype[] = {
@@ -473,13 +472,9 @@ static int mx2_videobuf_setup(struct vb2_queue *vq,
 			unsigned int sizes[], void *alloc_ctxs[])
 {
 	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
-	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
-	struct mx2_camera_dev *pcdev = ici->priv;
 
 	dev_dbg(icd->parent, "count=%d, size=%d\n", *count, sizes[0]);
 
-	alloc_ctxs[0] = pcdev->alloc_ctx;
-
 	sizes[0] = icd->sizeimage;
 
 	if (0 == *count)
@@ -780,6 +775,8 @@ static struct vb2_ops mx2_videobuf_ops = {
 static int mx2_camera_init_videobuf(struct vb2_queue *q,
 			      struct soc_camera_device *icd)
 {
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+
 	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	q->io_modes = VB2_MMAP | VB2_USERPTR;
 	q->drv_priv = icd;
@@ -787,6 +784,7 @@ static int mx2_camera_init_videobuf(struct vb2_queue *q,
 	q->mem_ops = &vb2_dma_contig_memops;
 	q->buf_struct_size = sizeof(struct mx2_buffer);
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+	q->dev = ici->v4l2_dev.dev;
 
 	return vb2_queue_init(q);
 }
@@ -1579,11 +1577,6 @@ static int mx2_camera_probe(struct platform_device *pdev)
 	pcdev->soc_host.v4l2_dev.dev	= &pdev->dev;
 	pcdev->soc_host.nr		= pdev->id;
 
-	pcdev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
-	if (IS_ERR(pcdev->alloc_ctx)) {
-		err = PTR_ERR(pcdev->alloc_ctx);
-		goto eallocctx;
-	}
 	err = soc_camera_host_register(&pcdev->soc_host);
 	if (err)
 		goto exit_free_emma;
@@ -1594,8 +1587,6 @@ static int mx2_camera_probe(struct platform_device *pdev)
 	return 0;
 
 exit_free_emma:
-	vb2_dma_contig_cleanup_ctx(pcdev->alloc_ctx);
-eallocctx:
 	clk_disable_unprepare(pcdev->clk_emma_ipg);
 	clk_disable_unprepare(pcdev->clk_emma_ahb);
 exit:
@@ -1610,8 +1601,6 @@ static int mx2_camera_remove(struct platform_device *pdev)
 
 	soc_camera_host_unregister(&pcdev->soc_host);
 
-	vb2_dma_contig_cleanup_ctx(pcdev->alloc_ctx);
-
 	clk_disable_unprepare(pcdev->clk_emma_ipg);
 	clk_disable_unprepare(pcdev->clk_emma_ahb);
 
diff --git a/drivers/staging/media/mx3/mx3_camera.c b/drivers/staging/media/mx3/mx3_camera.c
index aa39e95..9f5343c 100644
--- a/drivers/staging/media/mx3/mx3_camera.c
+++ b/drivers/staging/media/mx3/mx3_camera.c
@@ -108,7 +108,6 @@ struct mx3_camera_dev {
 	spinlock_t		lock;		/* Protects video buffer lists */
 	struct mx3_camera_buffer *active;
 	size_t			buf_total;
-	struct vb2_alloc_ctx	*alloc_ctx;
 	enum v4l2_field		field;
 	int			sequence;
 
@@ -195,8 +194,6 @@ static int mx3_videobuf_setup(struct vb2_queue *vq,
 	if (!mx3_cam->idmac_channel[0])
 		return -EINVAL;
 
-	alloc_ctxs[0] = mx3_cam->alloc_ctx;
-
 	if (!vq->num_buffers)
 		mx3_cam->sequence = 0;
 
@@ -433,6 +430,7 @@ static int mx3_camera_init_videobuf(struct vb2_queue *q,
 	q->buf_struct_size = sizeof(struct mx3_camera_buffer);
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	q->lock = &ici->host_lock;
+	q->dev = ici->v4l2_dev.dev;
 
 	return vb2_queue_init(q);
 }
@@ -1202,10 +1200,6 @@ static int mx3_camera_probe(struct platform_device *pdev)
 	soc_host->v4l2_dev.dev	= &pdev->dev;
 	soc_host->nr		= pdev->id;
 
-	mx3_cam->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
-	if (IS_ERR(mx3_cam->alloc_ctx))
-		return PTR_ERR(mx3_cam->alloc_ctx);
-
 	if (pdata->asd_sizes) {
 		soc_host->asd = pdata->asd;
 		soc_host->asd_sizes = pdata->asd_sizes;
@@ -1213,16 +1207,12 @@ static int mx3_camera_probe(struct platform_device *pdev)
 
 	err = soc_camera_host_register(soc_host);
 	if (err)
-		goto ecamhostreg;
+		return err;
 
 	/* IDMAC interface */
 	dmaengine_get();
 
 	return 0;
-
-ecamhostreg:
-	vb2_dma_contig_cleanup_ctx(mx3_cam->alloc_ctx);
-	return err;
 }
 
 static int mx3_camera_remove(struct platform_device *pdev)
@@ -1240,8 +1230,6 @@ static int mx3_camera_remove(struct platform_device *pdev)
 	if (WARN_ON(mx3_cam->idmac_channel[0]))
 		dma_release_channel(&mx3_cam->idmac_channel[0]->dma_chan);
 
-	vb2_dma_contig_cleanup_ctx(mx3_cam->alloc_ctx);
-
 	dmaengine_put();
 
 	return 0;
-- 
2.8.0.rc3

