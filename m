Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:43693 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758814AbZDOMSC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Apr 2009 08:18:02 -0400
Date: Wed, 15 Apr 2009 14:18:05 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH 3/5] soc-camera: remove an extra device generation from struct
 soc_camera_host
In-Reply-To: <Pine.LNX.4.64.0904151356480.4729@axis700.grange>
Message-ID: <Pine.LNX.4.64.0904151401340.4729@axis700.grange>
References: <Pine.LNX.4.64.0904151356480.4729@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make camera devices direct children of host platform devices, move the
inheritance management into the soc_camera.c core driver.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/mx1_camera.c           |   35 +++++-----
 drivers/media/video/mx3_camera.c           |   40 ++++++------
 drivers/media/video/pxa_camera.c           |   97 ++++++++++++++--------------
 drivers/media/video/sh_mobile_ceu_camera.c |   21 +++---
 drivers/media/video/soc_camera.c           |   35 +++-------
 include/media/soc_camera.h                 |    4 +-
 6 files changed, 107 insertions(+), 125 deletions(-)

diff --git a/drivers/media/video/mx1_camera.c b/drivers/media/video/mx1_camera.c
index 48dd984..2d07520 100644
--- a/drivers/media/video/mx1_camera.c
+++ b/drivers/media/video/mx1_camera.c
@@ -106,7 +106,6 @@ struct mx1_camera_dev {
 	struct soc_camera_device	*icd;
 	struct mx1_camera_pdata		*pdata;
 	struct mx1_buffer		*active;
-	struct device			*dev;
 	struct resource			*res;
 	struct clk			*clk;
 	struct list_head		capture;
@@ -220,7 +219,7 @@ static int mx1_camera_setup_dma(struct mx1_camera_dev *pcdev)
 	int ret;
 
 	if (unlikely(!pcdev->active)) {
-		dev_err(pcdev->dev, "DMA End IRQ with no active buffer\n");
+		dev_err(pcdev->soc_host.dev, "DMA End IRQ with no active buffer\n");
 		return -EFAULT;
 	}
 
@@ -230,7 +229,7 @@ static int mx1_camera_setup_dma(struct mx1_camera_dev *pcdev)
 		vbuf->size, pcdev->res->start +
 		CSIRXR, DMA_MODE_READ);
 	if (unlikely(ret))
-		dev_err(pcdev->dev, "Failed to setup DMA sg list\n");
+		dev_err(pcdev->soc_host.dev, "Failed to setup DMA sg list\n");
 
 	return ret;
 }
@@ -339,14 +338,14 @@ static void mx1_camera_dma_irq(int channel, void *data)
 	imx_dma_disable(channel);
 
 	if (unlikely(!pcdev->active)) {
-		dev_err(pcdev->dev, "DMA End IRQ with no active buffer\n");
+		dev_err(pcdev->soc_host.dev, "DMA End IRQ with no active buffer\n");
 		goto out;
 	}
 
 	vb = &pcdev->active->vb;
 	buf = container_of(vb, struct mx1_buffer, vb);
 	WARN_ON(buf->inwork || list_empty(&vb->queue));
-	dev_dbg(pcdev->dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
+	dev_dbg(pcdev->soc_host.dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
 		vb, vb->baddr, vb->bsize);
 
 	mx1_camera_wakeup(pcdev, vb, buf);
@@ -367,7 +366,7 @@ static void mx1_camera_init_videobuf(struct videobuf_queue *q,
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct mx1_camera_dev *pcdev = ici->priv;
 
-	videobuf_queue_dma_contig_init(q, &mx1_videobuf_ops, pcdev->dev,
+	videobuf_queue_dma_contig_init(q, &mx1_videobuf_ops, ici->dev,
 					&pcdev->lock,
 					V4L2_BUF_TYPE_VIDEO_CAPTURE,
 					V4L2_FIELD_NONE,
@@ -386,7 +385,7 @@ static int mclk_get_divisor(struct mx1_camera_dev *pcdev)
 	 * they get a nice Oops */
 	div = (lcdclk + 2 * mclk - 1) / (2 * mclk) - 1;
 
-	dev_dbg(pcdev->dev, "System clock %lukHz, target freq %dkHz, "
+	dev_dbg(pcdev->soc_host.dev, "System clock %lukHz, target freq %dkHz, "
 		"divisor %lu\n", lcdclk / 1000, mclk / 1000, div);
 
 	return div;
@@ -396,7 +395,7 @@ static void mx1_camera_activate(struct mx1_camera_dev *pcdev)
 {
 	unsigned int csicr1 = CSICR1_EN;
 
-	dev_dbg(pcdev->dev, "Activate device\n");
+	dev_dbg(pcdev->soc_host.dev, "Activate device\n");
 
 	clk_enable(pcdev->clk);
 
@@ -412,7 +411,7 @@ static void mx1_camera_activate(struct mx1_camera_dev *pcdev)
 
 static void mx1_camera_deactivate(struct mx1_camera_dev *pcdev)
 {
-	dev_dbg(pcdev->dev, "Deactivate device\n");
+	dev_dbg(pcdev->soc_host.dev, "Deactivate device\n");
 
 	/* Disable all CSI interface */
 	__raw_writel(0x00, pcdev->base + CSICR1);
@@ -551,7 +550,7 @@ static int mx1_camera_set_fmt(struct soc_camera_device *icd,
 
 	xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
 	if (!xlate) {
-		dev_warn(&ici->dev, "Format %x not found\n", pix->pixelformat);
+		dev_warn(ici->dev, "Format %x not found\n", pix->pixelformat);
 		return -EINVAL;
 	}
 
@@ -668,7 +667,6 @@ static int __init mx1_camera_probe(struct platform_device *pdev)
 		goto exit_put_clk;
 	}
 
-	platform_set_drvdata(pdev, pcdev);
 	pcdev->res = res;
 	pcdev->clk = clk;
 
@@ -702,16 +700,15 @@ static int __init mx1_camera_probe(struct platform_device *pdev)
 	}
 	pcdev->irq = irq;
 	pcdev->base = base;
-	pcdev->dev = &pdev->dev;
 
 	/* request dma */
 	pcdev->dma_chan = imx_dma_request_by_prio(DRIVER_NAME, DMA_PRIO_HIGH);
 	if (pcdev->dma_chan < 0) {
-		dev_err(pcdev->dev, "Can't request DMA for MX1 CSI\n");
+		dev_err(&pdev->dev, "Can't request DMA for MX1 CSI\n");
 		err = -EBUSY;
 		goto exit_iounmap;
 	}
-	dev_dbg(pcdev->dev, "got DMA channel %d\n", pcdev->dma_chan);
+	dev_dbg(&pdev->dev, "got DMA channel %d\n", pcdev->dma_chan);
 
 	imx_dma_setup_handlers(pcdev->dma_chan, mx1_camera_dma_irq, NULL,
 			       pcdev);
@@ -724,7 +721,7 @@ static int __init mx1_camera_probe(struct platform_device *pdev)
 	/* request irq */
 	err = claim_fiq(&fh);
 	if (err) {
-		dev_err(pcdev->dev, "Camera interrupt register failed \n");
+		dev_err(&pdev->dev, "Camera interrupt register failed \n");
 		goto exit_free_dma;
 	}
 
@@ -744,7 +741,7 @@ static int __init mx1_camera_probe(struct platform_device *pdev)
 	pcdev->soc_host.drv_name	= DRIVER_NAME;
 	pcdev->soc_host.ops		= &mx1_soc_camera_host_ops;
 	pcdev->soc_host.priv		= pcdev;
-	pcdev->soc_host.dev.parent	= &pdev->dev;
+	pcdev->soc_host.dev		= &pdev->dev;
 	pcdev->soc_host.nr		= pdev->id;
 	err = soc_camera_host_register(&pcdev->soc_host);
 	if (err)
@@ -774,7 +771,9 @@ exit:
 
 static int __exit mx1_camera_remove(struct platform_device *pdev)
 {
-	struct mx1_camera_dev *pcdev = platform_get_drvdata(pdev);
+	struct soc_camera_host *soc_host = to_soc_camera_host(&pdev->dev);
+	struct mx1_camera_dev *pcdev = container_of(soc_host,
+					struct mx1_camera_dev, soc_host);
 	struct resource *res;
 
 	imx_dma_free(pcdev->dma_chan);
@@ -784,7 +783,7 @@ static int __exit mx1_camera_remove(struct platform_device *pdev)
 
 	clk_put(pcdev->clk);
 
-	soc_camera_host_unregister(&pcdev->soc_host);
+	soc_camera_host_unregister(soc_host);
 
 	iounmap(pcdev->base);
 
diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
index 22c58dc..cb13faa 100644
--- a/drivers/media/video/mx3_camera.c
+++ b/drivers/media/video/mx3_camera.c
@@ -87,7 +87,6 @@ struct mx3_camera_buffer {
  * @soc_host:		embedded soc_host object
  */
 struct mx3_camera_dev {
-	struct device		*dev;
 	/*
 	 * i.MX3x is only supposed to handle one camera on its Camera Sensor
 	 * Interface. If anyone ever builds hardware to enable more than one
@@ -431,7 +430,7 @@ static void mx3_camera_init_videobuf(struct videobuf_queue *q,
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct mx3_camera_dev *mx3_cam = ici->priv;
 
-	videobuf_queue_dma_contig_init(q, &mx3_videobuf_ops, mx3_cam->dev,
+	videobuf_queue_dma_contig_init(q, &mx3_videobuf_ops, ici->dev,
 				       &mx3_cam->lock,
 				       V4L2_BUF_TYPE_VIDEO_CAPTURE,
 				       V4L2_FIELD_NONE,
@@ -599,7 +598,8 @@ static int test_platform_param(struct mx3_camera_dev *mx3_cam,
 		*flags |= SOCAM_DATAWIDTH_4;
 		break;
 	default:
-		dev_info(mx3_cam->dev, "Unsupported bus width %d\n", buswidth);
+		dev_info(mx3_cam->soc_host.dev, "Unsupported bus width %d\n",
+			 buswidth);
 		return -EINVAL;
 	}
 
@@ -614,7 +614,7 @@ static int mx3_camera_try_bus_param(struct soc_camera_device *icd,
 	unsigned long bus_flags, camera_flags;
 	int ret = test_platform_param(mx3_cam, depth, &bus_flags);
 
-	dev_dbg(&ici->dev, "requested bus width %d bit: %d\n", depth, ret);
+	dev_dbg(ici->dev, "requested bus width %d bit: %d\n", depth, ret);
 
 	if (ret < 0)
 		return ret;
@@ -637,7 +637,7 @@ static bool chan_filter(struct dma_chan *chan, void *arg)
 	if (!rq)
 		return false;
 
-	pdata = rq->mx3_cam->dev->platform_data;
+	pdata = rq->mx3_cam->soc_host.dev->platform_data;
 
 	return rq->id == chan->chan_id &&
 		pdata->dma_dev == chan->device->dev;
@@ -697,7 +697,7 @@ static int mx3_camera_get_formats(struct soc_camera_device *icd, int idx,
 			xlate->cam_fmt = icd->formats + idx;
 			xlate->buswidth = buswidth;
 			xlate++;
-			dev_dbg(&ici->dev, "Providing format %s using %s\n",
+			dev_dbg(ici->dev, "Providing format %s using %s\n",
 				mx3_camera_formats[0].name,
 				icd->formats[idx].name);
 		}
@@ -709,7 +709,7 @@ static int mx3_camera_get_formats(struct soc_camera_device *icd, int idx,
 			xlate->cam_fmt = icd->formats + idx;
 			xlate->buswidth = buswidth;
 			xlate++;
-			dev_dbg(&ici->dev, "Providing format %s using %s\n",
+			dev_dbg(ici->dev, "Providing format %s using %s\n",
 				mx3_camera_formats[0].name,
 				icd->formats[idx].name);
 		}
@@ -722,7 +722,7 @@ passthrough:
 			xlate->cam_fmt = icd->formats + idx;
 			xlate->buswidth = buswidth;
 			xlate++;
-			dev_dbg(&ici->dev,
+			dev_dbg(ici->dev,
 				"Providing format %s in pass-through mode\n",
 				icd->formats[idx].name);
 		}
@@ -829,7 +829,7 @@ static int mx3_camera_set_fmt(struct soc_camera_device *icd,
 
 	xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
 	if (!xlate) {
-		dev_warn(&ici->dev, "Format %x not found\n", pix->pixelformat);
+		dev_warn(ici->dev, "Format %x not found\n", pix->pixelformat);
 		return -EINVAL;
 	}
 
@@ -866,7 +866,7 @@ static int mx3_camera_try_fmt(struct soc_camera_device *icd,
 
 	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
 	if (pixfmt && !xlate) {
-		dev_warn(&ici->dev, "Format %x not found\n", pixfmt);
+		dev_warn(ici->dev, "Format %x not found\n", pixfmt);
 		return -EINVAL;
 	}
 
@@ -933,11 +933,11 @@ static int mx3_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
 
 	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
 	if (!xlate) {
-		dev_warn(&ici->dev, "Format %x not found\n", pixfmt);
+		dev_warn(ici->dev, "Format %x not found\n", pixfmt);
 		return -EINVAL;
 	}
 
-	dev_dbg(&ici->dev, "requested bus width %d bit: %d\n",
+	dev_dbg(ici->dev, "requested bus width %d bit: %d\n",
 		icd->buswidth, ret);
 
 	if (ret < 0)
@@ -947,7 +947,7 @@ static int mx3_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
 
 	common_flags = soc_camera_bus_param_compatible(camera_flags, bus_flags);
 	if (!common_flags) {
-		dev_dbg(&ici->dev, "no common flags: camera %lx, host %lx\n",
+		dev_dbg(ici->dev, "no common flags: camera %lx, host %lx\n",
 			camera_flags, bus_flags);
 		return -EINVAL;
 	}
@@ -1054,7 +1054,7 @@ static int mx3_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
 
 	csi_reg_write(mx3_cam, sens_conf | dw, CSI_SENS_CONF);
 
-	dev_dbg(&ici->dev, "Set SENS_CONF to %x\n", sens_conf | dw);
+	dev_dbg(ici->dev, "Set SENS_CONF to %x\n", sens_conf | dw);
 
 	return 0;
 }
@@ -1106,8 +1106,6 @@ static int mx3_camera_probe(struct platform_device *pdev)
 		goto eclkget;
 	}
 
-	platform_set_drvdata(pdev, mx3_cam);
-
 	mx3_cam->pdata = pdev->dev.platform_data;
 	mx3_cam->platform_flags = mx3_cam->pdata->flags;
 	if (!(mx3_cam->platform_flags & (MX3_CAMERA_DATAWIDTH_4 |
@@ -1139,14 +1137,14 @@ static int mx3_camera_probe(struct platform_device *pdev)
 	}
 
 	mx3_cam->base	= base;
-	mx3_cam->dev	= &pdev->dev;
 
 	soc_host		= &mx3_cam->soc_host;
 	soc_host->drv_name	= MX3_CAM_DRV_NAME;
 	soc_host->ops		= &mx3_soc_camera_host_ops;
 	soc_host->priv		= mx3_cam;
-	soc_host->dev.parent	= &pdev->dev;
+	soc_host->dev		= &pdev->dev;
 	soc_host->nr		= pdev->id;
+
 	err = soc_camera_host_register(soc_host);
 	if (err)
 		goto ecamhostreg;
@@ -1169,11 +1167,13 @@ egetres:
 
 static int __devexit mx3_camera_remove(struct platform_device *pdev)
 {
-	struct mx3_camera_dev *mx3_cam = platform_get_drvdata(pdev);
+	struct soc_camera_host *soc_host = to_soc_camera_host(&pdev->dev);
+	struct mx3_camera_dev *mx3_cam = container_of(soc_host,
+					struct mx3_camera_dev, soc_host);
 
 	clk_put(mx3_cam->clk);
 
-	soc_camera_host_unregister(&mx3_cam->soc_host);
+	soc_camera_host_unregister(soc_host);
 
 	iounmap(mx3_cam->base);
 
diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index ad0d58c..2da5eef 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -203,7 +203,6 @@ struct pxa_buffer {
 
 struct pxa_camera_dev {
 	struct soc_camera_host	soc_host;
-	struct device		*dev;
 	/* PXA27x is only supposed to handle one camera on its Quick Capture
 	 * interface. If anyone ever builds hardware to enable more than
 	 * one camera, they will have to modify this driver too */
@@ -262,7 +261,6 @@ static void free_buffer(struct videobuf_queue *vq, struct pxa_buffer *buf)
 {
 	struct soc_camera_device *icd = vq->priv_data;
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
-	struct pxa_camera_dev *pcdev = ici->priv;
 	struct videobuf_dmabuf *dma = videobuf_to_dma(&buf->vb);
 	int i;
 
@@ -279,7 +277,7 @@ static void free_buffer(struct videobuf_queue *vq, struct pxa_buffer *buf)
 
 	for (i = 0; i < ARRAY_SIZE(buf->dmas); i++) {
 		if (buf->dmas[i].sg_cpu)
-			dma_free_coherent(pcdev->dev, buf->dmas[i].sg_size,
+			dma_free_coherent(ici->dev, buf->dmas[i].sg_size,
 					  buf->dmas[i].sg_cpu,
 					  buf->dmas[i].sg_dma);
 		buf->dmas[i].sg_cpu = NULL;
@@ -339,14 +337,14 @@ static int pxa_init_dma_channel(struct pxa_camera_dev *pcdev,
 	int dma_len = 0, xfer_len = 0;
 
 	if (pxa_dma->sg_cpu)
-		dma_free_coherent(pcdev->dev, pxa_dma->sg_size,
+		dma_free_coherent(pcdev->soc_host.dev, pxa_dma->sg_size,
 				  pxa_dma->sg_cpu, pxa_dma->sg_dma);
 
 	sglen = calculate_dma_sglen(*sg_first, dma->sglen,
 				    *sg_first_ofs, size);
 
 	pxa_dma->sg_size = (sglen + 1) * sizeof(struct pxa_dma_desc);
-	pxa_dma->sg_cpu = dma_alloc_coherent(pcdev->dev, pxa_dma->sg_size,
+	pxa_dma->sg_cpu = dma_alloc_coherent(pcdev->soc_host.dev, pxa_dma->sg_size,
 					     &pxa_dma->sg_dma, GFP_KERNEL);
 	if (!pxa_dma->sg_cpu)
 		return -ENOMEM;
@@ -354,7 +352,7 @@ static int pxa_init_dma_channel(struct pxa_camera_dev *pcdev,
 	pxa_dma->sglen = sglen;
 	offset = *sg_first_ofs;
 
-	dev_dbg(pcdev->dev, "DMA: sg_first=%p, sglen=%d, ofs=%d, dma.desc=%x\n",
+	dev_dbg(pcdev->soc_host.dev, "DMA: sg_first=%p, sglen=%d, ofs=%d, dma.desc=%x\n",
 		*sg_first, sglen, *sg_first_ofs, pxa_dma->sg_dma);
 
 
@@ -377,7 +375,7 @@ static int pxa_init_dma_channel(struct pxa_camera_dev *pcdev,
 		pxa_dma->sg_cpu[i].ddadr =
 			pxa_dma->sg_dma + (i + 1) * sizeof(struct pxa_dma_desc);
 
-		dev_vdbg(pcdev->dev, "DMA: desc.%08x->@phys=0x%08x, len=%d\n",
+		dev_vdbg(pcdev->soc_host.dev, "DMA: desc.%08x->@phys=0x%08x, len=%d\n",
 			 pxa_dma->sg_dma + i * sizeof(struct pxa_dma_desc),
 			 sg_dma_address(sg) + offset, xfer_len);
 		offset = 0;
@@ -489,7 +487,7 @@ static int pxa_videobuf_prepare(struct videobuf_queue *vq,
 		ret = pxa_init_dma_channel(pcdev, buf, dma, 0, CIBR0, size_y,
 					   &sg, &next_ofs);
 		if (ret) {
-			dev_err(pcdev->dev,
+			dev_err(pcdev->soc_host.dev,
 				"DMA initialization for Y/RGB failed\n");
 			goto fail;
 		}
@@ -499,7 +497,7 @@ static int pxa_videobuf_prepare(struct videobuf_queue *vq,
 			ret = pxa_init_dma_channel(pcdev, buf, dma, 1, CIBR1,
 						   size_u, &sg, &next_ofs);
 		if (ret) {
-			dev_err(pcdev->dev,
+			dev_err(pcdev->soc_host.dev,
 				"DMA initialization for U failed\n");
 			goto fail_u;
 		}
@@ -509,7 +507,7 @@ static int pxa_videobuf_prepare(struct videobuf_queue *vq,
 			ret = pxa_init_dma_channel(pcdev, buf, dma, 2, CIBR2,
 						   size_v, &sg, &next_ofs);
 		if (ret) {
-			dev_err(pcdev->dev,
+			dev_err(pcdev->soc_host.dev,
 				"DMA initialization for V failed\n");
 			goto fail_v;
 		}
@@ -523,10 +521,10 @@ static int pxa_videobuf_prepare(struct videobuf_queue *vq,
 	return 0;
 
 fail_v:
-	dma_free_coherent(pcdev->dev, buf->dmas[1].sg_size,
+	dma_free_coherent(pcdev->soc_host.dev, buf->dmas[1].sg_size,
 			  buf->dmas[1].sg_cpu, buf->dmas[1].sg_dma);
 fail_u:
-	dma_free_coherent(pcdev->dev, buf->dmas[0].sg_size,
+	dma_free_coherent(pcdev->soc_host.dev, buf->dmas[0].sg_size,
 			  buf->dmas[0].sg_cpu, buf->dmas[0].sg_dma);
 fail:
 	free_buffer(vq, buf);
@@ -550,7 +548,7 @@ static void pxa_dma_start_channels(struct pxa_camera_dev *pcdev)
 	active = pcdev->active;
 
 	for (i = 0; i < pcdev->channels; i++) {
-		dev_dbg(pcdev->dev, "%s (channel=%d) ddadr=%08x\n", __func__,
+		dev_dbg(pcdev->soc_host.dev, "%s (channel=%d) ddadr=%08x\n", __func__,
 			i, active->dmas[i].sg_dma);
 		DDADR(pcdev->dma_chans[i]) = active->dmas[i].sg_dma;
 		DCSR(pcdev->dma_chans[i]) = DCSR_RUN;
@@ -562,7 +560,7 @@ static void pxa_dma_stop_channels(struct pxa_camera_dev *pcdev)
 	int i;
 
 	for (i = 0; i < pcdev->channels; i++) {
-		dev_dbg(pcdev->dev, "%s (channel=%d)\n", __func__, i);
+		dev_dbg(pcdev->soc_host.dev, "%s (channel=%d)\n", __func__, i);
 		DCSR(pcdev->dma_chans[i]) = 0;
 	}
 }
@@ -598,7 +596,7 @@ static void pxa_camera_start_capture(struct pxa_camera_dev *pcdev)
 {
 	unsigned long cicr0, cifr;
 
-	dev_dbg(pcdev->dev, "%s\n", __func__);
+	dev_dbg(pcdev->soc_host.dev, "%s\n", __func__);
 	/* Reset the FIFOs */
 	cifr = __raw_readl(pcdev->base + CIFR) | CIFR_RESET_F;
 	__raw_writel(cifr, pcdev->base + CIFR);
@@ -618,7 +616,7 @@ static void pxa_camera_stop_capture(struct pxa_camera_dev *pcdev)
 	__raw_writel(cicr0, pcdev->base + CICR0);
 
 	pcdev->active = NULL;
-	dev_dbg(pcdev->dev, "%s\n", __func__);
+	dev_dbg(pcdev->soc_host.dev, "%s\n", __func__);
 }
 
 static void pxa_videobuf_queue(struct videobuf_queue *vq,
@@ -687,7 +685,7 @@ static void pxa_camera_wakeup(struct pxa_camera_dev *pcdev,
 	do_gettimeofday(&vb->ts);
 	vb->field_count++;
 	wake_up(&vb->done);
-	dev_dbg(pcdev->dev, "%s dequeud buffer (vb=0x%p)\n", __func__, vb);
+	dev_dbg(pcdev->soc_host.dev, "%s dequeud buffer (vb=0x%p)\n", __func__, vb);
 
 	if (list_empty(&pcdev->capture)) {
 		pxa_camera_stop_capture(pcdev);
@@ -723,7 +721,7 @@ static void pxa_camera_check_link_miss(struct pxa_camera_dev *pcdev)
 	for (i = 0; i < pcdev->channels; i++)
 		if (DDADR(pcdev->dma_chans[i]) != DDADR_STOP)
 			is_dma_stopped = 0;
-	dev_dbg(pcdev->dev, "%s : top queued buffer=%p, dma_stopped=%d\n",
+	dev_dbg(pcdev->soc_host.dev, "%s : top queued buffer=%p, dma_stopped=%d\n",
 		__func__, pcdev->active, is_dma_stopped);
 	if (pcdev->active && is_dma_stopped)
 		pxa_camera_start_capture(pcdev);
@@ -748,12 +746,12 @@ static void pxa_camera_dma_irq(int channel, struct pxa_camera_dev *pcdev,
 		overrun |= CISR_IFO_1 | CISR_IFO_2;
 
 	if (status & DCSR_BUSERR) {
-		dev_err(pcdev->dev, "DMA Bus Error IRQ!\n");
+		dev_err(pcdev->soc_host.dev, "DMA Bus Error IRQ!\n");
 		goto out;
 	}
 
 	if (!(status & (DCSR_ENDINTR | DCSR_STARTINTR))) {
-		dev_err(pcdev->dev, "Unknown DMA IRQ source, "
+		dev_err(pcdev->soc_host.dev, "Unknown DMA IRQ source, "
 			"status: 0x%08x\n", status);
 		goto out;
 	}
@@ -777,7 +775,7 @@ static void pxa_camera_dma_irq(int channel, struct pxa_camera_dev *pcdev,
 	buf = container_of(vb, struct pxa_buffer, vb);
 	WARN_ON(buf->inwork || list_empty(&vb->queue));
 
-	dev_dbg(pcdev->dev, "%s channel=%d %s%s(vb=0x%p) dma.desc=%x\n",
+	dev_dbg(pcdev->soc_host.dev, "%s channel=%d %s%s(vb=0x%p) dma.desc=%x\n",
 		__func__, channel, status & DCSR_STARTINTR ? "SOF " : "",
 		status & DCSR_ENDINTR ? "EOF " : "", vb, DDADR(channel));
 
@@ -788,7 +786,7 @@ static void pxa_camera_dma_irq(int channel, struct pxa_camera_dev *pcdev,
 		 */
 		if (camera_status & overrun &&
 		    !list_is_last(pcdev->capture.next, &pcdev->capture)) {
-			dev_dbg(pcdev->dev, "FIFO overrun! CISR: %x\n",
+			dev_dbg(pcdev->soc_host.dev, "FIFO overrun! CISR: %x\n",
 				camera_status);
 			pxa_camera_stop_capture(pcdev);
 			pxa_camera_start_capture(pcdev);
@@ -855,7 +853,7 @@ static u32 mclk_get_divisor(struct pxa_camera_dev *pcdev)
 	/* mclk <= ciclk / 4 (27.4.2) */
 	if (mclk > lcdclk / 4) {
 		mclk = lcdclk / 4;
-		dev_warn(pcdev->dev, "Limiting master clock to %lu\n", mclk);
+		dev_warn(pcdev->soc_host.dev, "Limiting master clock to %lu\n", mclk);
 	}
 
 	/* We verify mclk != 0, so if anyone breaks it, here comes their Oops */
@@ -865,7 +863,7 @@ static u32 mclk_get_divisor(struct pxa_camera_dev *pcdev)
 	if (pcdev->platform_flags & PXA_CAMERA_MCLK_EN)
 		pcdev->mclk = lcdclk / (2 * (div + 1));
 
-	dev_dbg(pcdev->dev, "LCD clock %luHz, target freq %luHz, "
+	dev_dbg(pcdev->soc_host.dev, "LCD clock %luHz, target freq %luHz, "
 		"divisor %u\n", lcdclk, mclk, div);
 
 	return div;
@@ -885,12 +883,12 @@ static void pxa_camera_activate(struct pxa_camera_dev *pcdev)
 	struct pxacamera_platform_data *pdata = pcdev->pdata;
 	u32 cicr4 = 0;
 
-	dev_dbg(pcdev->dev, "Registered platform device at %p data %p\n",
+	dev_dbg(pcdev->soc_host.dev, "Registered platform device at %p data %p\n",
 		pcdev, pdata);
 
 	if (pdata && pdata->init) {
-		dev_dbg(pcdev->dev, "%s: Init gpios\n", __func__);
-		pdata->init(pcdev->dev);
+		dev_dbg(pcdev->soc_host.dev, "%s: Init gpios\n", __func__);
+		pdata->init(pcdev->soc_host.dev);
 	}
 
 	/* disable all interrupts */
@@ -932,7 +930,7 @@ static irqreturn_t pxa_camera_irq(int irq, void *data)
 	struct videobuf_buffer *vb;
 
 	status = __raw_readl(pcdev->base + CISR);
-	dev_dbg(pcdev->dev, "Camera interrupt status 0x%lx\n", status);
+	dev_dbg(pcdev->soc_host.dev, "Camera interrupt status 0x%lx\n", status);
 
 	if (!status)
 		return IRQ_NONE;
@@ -1260,7 +1258,7 @@ static int pxa_camera_get_formats(struct soc_camera_device *icd, int idx,
 			xlate->cam_fmt = icd->formats + idx;
 			xlate->buswidth = buswidth;
 			xlate++;
-			dev_dbg(&ici->dev, "Providing format %s using %s\n",
+			dev_dbg(ici->dev, "Providing format %s using %s\n",
 				pxa_camera_formats[0].name,
 				icd->formats[idx].name);
 		}
@@ -1275,7 +1273,7 @@ static int pxa_camera_get_formats(struct soc_camera_device *icd, int idx,
 			xlate->cam_fmt = icd->formats + idx;
 			xlate->buswidth = buswidth;
 			xlate++;
-			dev_dbg(&ici->dev, "Providing format %s packed\n",
+			dev_dbg(ici->dev, "Providing format %s packed\n",
 				icd->formats[idx].name);
 		}
 		break;
@@ -1287,7 +1285,7 @@ static int pxa_camera_get_formats(struct soc_camera_device *icd, int idx,
 			xlate->cam_fmt = icd->formats + idx;
 			xlate->buswidth = icd->formats[idx].depth;
 			xlate++;
-			dev_dbg(&ici->dev,
+			dev_dbg(ici->dev,
 				"Providing format %s in pass-through mode\n",
 				icd->formats[idx].name);
 		}
@@ -1316,11 +1314,11 @@ static int pxa_camera_set_crop(struct soc_camera_device *icd,
 	icd->sense = NULL;
 
 	if (ret < 0) {
-		dev_warn(&ici->dev, "Failed to crop to %ux%u@%u:%u\n",
+		dev_warn(ici->dev, "Failed to crop to %ux%u@%u:%u\n",
 			 rect->width, rect->height, rect->left, rect->top);
 	} else if (sense.flags & SOCAM_SENSE_PCLK_CHANGED) {
 		if (sense.pixel_clock > sense.pixel_clock_max) {
-			dev_err(&ici->dev,
+			dev_err(ici->dev,
 				"pixel clock %lu set by the camera too high!",
 				sense.pixel_clock);
 			return -EIO;
@@ -1348,7 +1346,7 @@ static int pxa_camera_set_fmt(struct soc_camera_device *icd,
 
 	xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
 	if (!xlate) {
-		dev_warn(&ici->dev, "Format %x not found\n", pix->pixelformat);
+		dev_warn(ici->dev, "Format %x not found\n", pix->pixelformat);
 		return -EINVAL;
 	}
 
@@ -1364,11 +1362,11 @@ static int pxa_camera_set_fmt(struct soc_camera_device *icd,
 	icd->sense = NULL;
 
 	if (ret < 0) {
-		dev_warn(&ici->dev, "Failed to configure for format %x\n",
+		dev_warn(ici->dev, "Failed to configure for format %x\n",
 			 pix->pixelformat);
 	} else if (sense.flags & SOCAM_SENSE_PCLK_CHANGED) {
 		if (sense.pixel_clock > sense.pixel_clock_max) {
-			dev_err(&ici->dev,
+			dev_err(ici->dev,
 				"pixel clock %lu set by the camera too high!",
 				sense.pixel_clock);
 			return -EIO;
@@ -1396,7 +1394,7 @@ static int pxa_camera_try_fmt(struct soc_camera_device *icd,
 
 	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
 	if (!xlate) {
-		dev_warn(&ici->dev, "Format %x not found\n", pixfmt);
+		dev_warn(ici->dev, "Format %x not found\n", pixfmt);
 		return -EINVAL;
 	}
 
@@ -1581,7 +1579,6 @@ static int pxa_camera_probe(struct platform_device *pdev)
 		goto exit_kfree;
 	}
 
-	platform_set_drvdata(pdev, pcdev);
 	pcdev->res = res;
 
 	pcdev->pdata = pdev->dev.platform_data;
@@ -1602,7 +1599,6 @@ static int pxa_camera_probe(struct platform_device *pdev)
 		pcdev->mclk = 20000000;
 	}
 
-	pcdev->dev = &pdev->dev;
 	pcdev->mclk_divisor = mclk_get_divisor(pcdev);
 
 	INIT_LIST_HEAD(&pcdev->capture);
@@ -1629,29 +1625,29 @@ static int pxa_camera_probe(struct platform_device *pdev)
 	err = pxa_request_dma("CI_Y", DMA_PRIO_HIGH,
 			      pxa_camera_dma_irq_y, pcdev);
 	if (err < 0) {
-		dev_err(pcdev->dev, "Can't request DMA for Y\n");
+		dev_err(&pdev->dev, "Can't request DMA for Y\n");
 		goto exit_iounmap;
 	}
 	pcdev->dma_chans[0] = err;
-	dev_dbg(pcdev->dev, "got DMA channel %d\n", pcdev->dma_chans[0]);
+	dev_dbg(&pdev->dev, "got DMA channel %d\n", pcdev->dma_chans[0]);
 
 	err = pxa_request_dma("CI_U", DMA_PRIO_HIGH,
 			      pxa_camera_dma_irq_u, pcdev);
 	if (err < 0) {
-		dev_err(pcdev->dev, "Can't request DMA for U\n");
+		dev_err(&pdev->dev, "Can't request DMA for U\n");
 		goto exit_free_dma_y;
 	}
 	pcdev->dma_chans[1] = err;
-	dev_dbg(pcdev->dev, "got DMA channel (U) %d\n", pcdev->dma_chans[1]);
+	dev_dbg(&pdev->dev, "got DMA channel (U) %d\n", pcdev->dma_chans[1]);
 
 	err = pxa_request_dma("CI_V", DMA_PRIO_HIGH,
 			      pxa_camera_dma_irq_v, pcdev);
 	if (err < 0) {
-		dev_err(pcdev->dev, "Can't request DMA for V\n");
+		dev_err(&pdev->dev, "Can't request DMA for V\n");
 		goto exit_free_dma_u;
 	}
 	pcdev->dma_chans[2] = err;
-	dev_dbg(pcdev->dev, "got DMA channel (V) %d\n", pcdev->dma_chans[2]);
+	dev_dbg(&pdev->dev, "got DMA channel (V) %d\n", pcdev->dma_chans[2]);
 
 	DRCMR(68) = pcdev->dma_chans[0] | DRCMR_MAPVLD;
 	DRCMR(69) = pcdev->dma_chans[1] | DRCMR_MAPVLD;
@@ -1661,15 +1657,16 @@ static int pxa_camera_probe(struct platform_device *pdev)
 	err = request_irq(pcdev->irq, pxa_camera_irq, 0, PXA_CAM_DRV_NAME,
 			  pcdev);
 	if (err) {
-		dev_err(pcdev->dev, "Camera interrupt register failed \n");
+		dev_err(&pdev->dev, "Camera interrupt register failed \n");
 		goto exit_free_dma;
 	}
 
 	pcdev->soc_host.drv_name	= PXA_CAM_DRV_NAME;
 	pcdev->soc_host.ops		= &pxa_soc_camera_host_ops;
 	pcdev->soc_host.priv		= pcdev;
-	pcdev->soc_host.dev.parent	= &pdev->dev;
+	pcdev->soc_host.dev		= &pdev->dev;
 	pcdev->soc_host.nr		= pdev->id;
+
 	err = soc_camera_host_register(&pcdev->soc_host);
 	if (err)
 		goto exit_free_irq;
@@ -1698,7 +1695,9 @@ exit:
 
 static int __devexit pxa_camera_remove(struct platform_device *pdev)
 {
-	struct pxa_camera_dev *pcdev = platform_get_drvdata(pdev);
+	struct soc_camera_host *soc_host = to_soc_camera_host(&pdev->dev);
+	struct pxa_camera_dev *pcdev = container_of(soc_host,
+					struct pxa_camera_dev, soc_host);
 	struct resource *res;
 
 	clk_put(pcdev->clk);
@@ -1708,7 +1707,7 @@ static int __devexit pxa_camera_remove(struct platform_device *pdev)
 	pxa_free_dma(pcdev->dma_chans[2]);
 	free_irq(pcdev->irq, pcdev);
 
-	soc_camera_host_unregister(&pcdev->soc_host);
+	soc_camera_host_unregister(soc_host);
 
 	iounmap(pcdev->base);
 
diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index 8e4a8fc..d369e84 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -81,7 +81,6 @@ struct sh_mobile_ceu_buffer {
 };
 
 struct sh_mobile_ceu_dev {
-	struct device *dev;
 	struct soc_camera_host ici;
 	struct soc_camera_device *icd;
 
@@ -617,7 +616,7 @@ static int sh_mobile_ceu_get_formats(struct soc_camera_device *icd, int idx,
 			xlate->cam_fmt = icd->formats + idx;
 			xlate->buswidth = icd->formats[idx].depth;
 			xlate++;
-			dev_dbg(&ici->dev, "Providing format %s using %s\n",
+			dev_dbg(ici->dev, "Providing format %s using %s\n",
 				sh_mobile_ceu_formats[k].name,
 				icd->formats[idx].name);
 		}
@@ -630,7 +629,7 @@ add_single_format:
 			xlate->cam_fmt = icd->formats + idx;
 			xlate->buswidth = icd->formats[idx].depth;
 			xlate++;
-			dev_dbg(&ici->dev,
+			dev_dbg(ici->dev,
 				"Providing format %s in pass-through mode\n",
 				icd->formats[idx].name);
 		}
@@ -657,7 +656,7 @@ static int sh_mobile_ceu_set_fmt(struct soc_camera_device *icd,
 
 	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
 	if (!xlate) {
-		dev_warn(&ici->dev, "Format %x not found\n", pixfmt);
+		dev_warn(ici->dev, "Format %x not found\n", pixfmt);
 		return -EINVAL;
 	}
 
@@ -684,7 +683,7 @@ static int sh_mobile_ceu_try_fmt(struct soc_camera_device *icd,
 
 	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
 	if (!xlate) {
-		dev_warn(&ici->dev, "Format %x not found\n", pixfmt);
+		dev_warn(ici->dev, "Format %x not found\n", pixfmt);
 		return -EINVAL;
 	}
 
@@ -782,7 +781,7 @@ static void sh_mobile_ceu_init_videobuf(struct videobuf_queue *q,
 
 	videobuf_queue_dma_contig_init(q,
 				       &sh_mobile_ceu_videobuf_ops,
-				       &ici->dev, &pcdev->lock,
+				       ici->dev, &pcdev->lock,
 				       V4L2_BUF_TYPE_VIDEO_CAPTURE,
 				       pcdev->is_interlaced ?
 				       V4L2_FIELD_INTERLACED : V4L2_FIELD_NONE,
@@ -829,7 +828,6 @@ static int sh_mobile_ceu_probe(struct platform_device *pdev)
 		goto exit;
 	}
 
-	platform_set_drvdata(pdev, pcdev);
 	INIT_LIST_HEAD(&pcdev->capture);
 	spin_lock_init(&pcdev->lock);
 
@@ -850,7 +848,6 @@ static int sh_mobile_ceu_probe(struct platform_device *pdev)
 	pcdev->irq = irq;
 	pcdev->base = base;
 	pcdev->video_limit = 0; /* only enabled if second resource exists */
-	pcdev->dev = &pdev->dev;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
 	if (res) {
@@ -885,7 +882,7 @@ static int sh_mobile_ceu_probe(struct platform_device *pdev)
 	}
 
 	pcdev->ici.priv = pcdev;
-	pcdev->ici.dev.parent = &pdev->dev;
+	pcdev->ici.dev = &pdev->dev;
 	pcdev->ici.nr = pdev->id;
 	pcdev->ici.drv_name = dev_name(&pdev->dev);
 	pcdev->ici.ops = &sh_mobile_ceu_host_ops;
@@ -913,9 +910,11 @@ exit:
 
 static int sh_mobile_ceu_remove(struct platform_device *pdev)
 {
-	struct sh_mobile_ceu_dev *pcdev = platform_get_drvdata(pdev);
+	struct soc_camera_host *soc_host = to_soc_camera_host(&pdev->dev);
+	struct sh_mobile_ceu_dev *pcdev = container_of(soc_host,
+					struct sh_mobile_ceu_dev, ici);
 
-	soc_camera_host_unregister(&pcdev->ici);
+	soc_camera_host_unregister(soc_host);
 	clk_put(pcdev->clk);
 	free_irq(pcdev->irq, pcdev);
 	if (platform_get_resource(pdev, IORESOURCE_MEM, 1))
diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 0e890cc..03a6c29 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -279,7 +279,7 @@ static int soc_camera_set_fmt(struct soc_camera_file *icf,
 		return ret;
 	} else if (!icd->current_fmt ||
 		   icd->current_fmt->fourcc != pix->pixelformat) {
-		dev_err(&ici->dev,
+		dev_err(ici->dev,
 			"Host driver hasn't set up current format correctly!\n");
 		return -EINVAL;
 	}
@@ -794,7 +794,7 @@ static void scan_add_host(struct soc_camera_host *ici)
 
 	list_for_each_entry(icd, &devices, list) {
 		if (icd->iface == ici->nr) {
-			icd->dev.parent = &ici->dev;
+			icd->dev.parent = ici->dev;
 			device_register_link(icd);
 		}
 	}
@@ -818,7 +818,7 @@ static int scan_add_device(struct soc_camera_device *icd)
 	list_for_each_entry(ici, &hosts, list) {
 		if (icd->iface == ici->nr) {
 			ret = 1;
-			icd->dev.parent = &ici->dev;
+			icd->dev.parent = ici->dev;
 			break;
 		}
 	}
@@ -952,7 +952,6 @@ static void dummy_release(struct device *dev)
 
 int soc_camera_host_register(struct soc_camera_host *ici)
 {
-	int ret;
 	struct soc_camera_host *ix;
 
 	if (!ici || !ici->ops ||
@@ -965,12 +964,10 @@ int soc_camera_host_register(struct soc_camera_host *ici)
 	    !ici->ops->reqbufs ||
 	    !ici->ops->add ||
 	    !ici->ops->remove ||
-	    !ici->ops->poll)
+	    !ici->ops->poll || 
+	    !ici->dev)
 		return -EINVAL;
 
-	/* Number might be equal to the platform device ID */
-	dev_set_name(&ici->dev, "camera_host%d", ici->nr);
-
 	mutex_lock(&list_lock);
 	list_for_each_entry(ix, &hosts, list) {
 		if (ix->nr == ici->nr) {
@@ -979,26 +976,14 @@ int soc_camera_host_register(struct soc_camera_host *ici)
 		}
 	}
 
+	dev_set_drvdata(ici->dev, ici);
+
 	list_add_tail(&ici->list, &hosts);
 	mutex_unlock(&list_lock);
 
-	ici->dev.release = dummy_release;
-
-	ret = device_register(&ici->dev);
-
-	if (ret)
-		goto edevr;
-
 	scan_add_host(ici);
 
 	return 0;
-
-edevr:
-	mutex_lock(&list_lock);
-	list_del(&ici->list);
-	mutex_unlock(&list_lock);
-
-	return ret;
 }
 EXPORT_SYMBOL(soc_camera_host_register);
 
@@ -1012,7 +997,7 @@ void soc_camera_host_unregister(struct soc_camera_host *ici)
 	list_del(&ici->list);
 
 	list_for_each_entry(icd, &devices, list) {
-		if (icd->dev.parent == &ici->dev) {
+		if (icd->dev.parent == ici->dev) {
 			device_unregister(&icd->dev);
 			/* Not before device_unregister(), .remove
 			 * needs parent to call ici->ops->remove() */
@@ -1023,7 +1008,7 @@ void soc_camera_host_unregister(struct soc_camera_host *ici)
 
 	mutex_unlock(&list_lock);
 
-	device_unregister(&ici->dev);
+	dev_set_drvdata(ici->dev, NULL);
 }
 EXPORT_SYMBOL(soc_camera_host_unregister);
 
@@ -1130,7 +1115,7 @@ int soc_camera_video_start(struct soc_camera_device *icd)
 	vdev = video_device_alloc();
 	if (!vdev)
 		goto evidallocd;
-	dev_dbg(&ici->dev, "Allocated video_device %p\n", vdev);
+	dev_dbg(ici->dev, "Allocated video_device %p\n", vdev);
 
 	strlcpy(vdev->name, ici->drv_name, sizeof(vdev->name));
 
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index 396c325..bef5e81 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -60,7 +60,7 @@ struct soc_camera_file {
 
 struct soc_camera_host {
 	struct list_head list;
-	struct device dev;
+	struct device *dev;
 	unsigned char nr;				/* Host number */
 	void *priv;
 	const char *drv_name;
@@ -117,7 +117,7 @@ static inline struct soc_camera_device *to_soc_camera_dev(struct device *dev)
 
 static inline struct soc_camera_host *to_soc_camera_host(struct device *dev)
 {
-	return container_of(dev, struct soc_camera_host, dev);
+	return dev_get_drvdata(dev);
 }
 
 extern int soc_camera_host_register(struct soc_camera_host *ici);
-- 
1.5.4

