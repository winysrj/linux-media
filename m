Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:64418 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409Ab3DLQMo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Apr 2013 12:12:44 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-sh@vger.kernel.org,
	Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Prabhakar Lad <prabhakar.lad@ti.com>
Subject: [PATCH v9 03/20] soc-camera: move common code to soc_camera.c
Date: Fri, 12 Apr 2013 17:40:23 +0200
Message-Id: <1365781240-16149-4-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1365781240-16149-1-git-send-email-g.liakhovetski@gmx.de>
References: <1365781240-16149-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All soc-camera host drivers include a pointer to an soc-camera device in
their host private struct to check, that only one client is connected.
Move this common code to soc_camera.c.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/platform/soc_camera/atmel-isi.c      |   10 +-----
 drivers/media/platform/soc_camera/mx1_camera.c     |   20 +++--------
 drivers/media/platform/soc_camera/mx2_camera.c     |   13 +------
 drivers/media/platform/soc_camera/mx3_camera.c     |    9 -----
 drivers/media/platform/soc_camera/omap1_camera.c   |   14 +------
 drivers/media/platform/soc_camera/pxa_camera.c     |   18 ++-------
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |   13 +------
 drivers/media/platform/soc_camera/soc_camera.c     |   38 ++++++++++++++++---
 include/media/soc_camera.h                         |    1 +
 9 files changed, 49 insertions(+), 87 deletions(-)

diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index 1abbb36..c9e080a 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -102,7 +102,6 @@ struct atmel_isi {
 	struct list_head		video_buffer_list;
 	struct frame_buffer		*active;
 
-	struct soc_camera_device	*icd;
 	struct soc_camera_host		soc_host;
 };
 
@@ -367,7 +366,7 @@ static void start_dma(struct atmel_isi *isi, struct frame_buffer *buffer)
 
 	/* Check if already in a frame */
 	if (isi_readl(isi, ISI_STATUS) & ISI_CTRL_CDC) {
-		dev_err(isi->icd->parent, "Already in frame handling.\n");
+		dev_err(isi->soc_host.icd->parent, "Already in frame handling.\n");
 		return;
 	}
 
@@ -753,9 +752,6 @@ static int isi_camera_add_device(struct soc_camera_device *icd)
 	struct atmel_isi *isi = ici->priv;
 	int ret;
 
-	if (isi->icd)
-		return -EBUSY;
-
 	ret = clk_enable(isi->pclk);
 	if (ret)
 		return ret;
@@ -766,7 +762,6 @@ static int isi_camera_add_device(struct soc_camera_device *icd)
 		return ret;
 	}
 
-	isi->icd = icd;
 	dev_dbg(icd->parent, "Atmel ISI Camera driver attached to camera %d\n",
 		 icd->devnum);
 	return 0;
@@ -777,11 +772,8 @@ static void isi_camera_remove_device(struct soc_camera_device *icd)
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct atmel_isi *isi = ici->priv;
 
-	BUG_ON(icd != isi->icd);
-
 	clk_disable(isi->mck);
 	clk_disable(isi->pclk);
-	isi->icd = NULL;
 
 	dev_dbg(icd->parent, "Atmel ISI Camera driver detached from camera %d\n",
 		 icd->devnum);
diff --git a/drivers/media/platform/soc_camera/mx1_camera.c b/drivers/media/platform/soc_camera/mx1_camera.c
index a3fd8d6..5f9ec8e 100644
--- a/drivers/media/platform/soc_camera/mx1_camera.c
+++ b/drivers/media/platform/soc_camera/mx1_camera.c
@@ -104,7 +104,6 @@ struct mx1_buffer {
  */
 struct mx1_camera_dev {
 	struct soc_camera_host		soc_host;
-	struct soc_camera_device	*icd;
 	struct mx1_camera_pdata		*pdata;
 	struct mx1_buffer		*active;
 	struct resource			*res;
@@ -220,7 +219,7 @@ out:
 static int mx1_camera_setup_dma(struct mx1_camera_dev *pcdev)
 {
 	struct videobuf_buffer *vbuf = &pcdev->active->vb;
-	struct device *dev = pcdev->icd->parent;
+	struct device *dev = pcdev->soc_host.icd->parent;
 	int ret;
 
 	if (unlikely(!pcdev->active)) {
@@ -331,7 +330,7 @@ static void mx1_camera_wakeup(struct mx1_camera_dev *pcdev,
 static void mx1_camera_dma_irq(int channel, void *data)
 {
 	struct mx1_camera_dev *pcdev = data;
-	struct device *dev = pcdev->icd->parent;
+	struct device *dev = pcdev->soc_host.icd->parent;
 	struct mx1_buffer *buf;
 	struct videobuf_buffer *vb;
 	unsigned long flags;
@@ -389,7 +388,7 @@ static int mclk_get_divisor(struct mx1_camera_dev *pcdev)
 	 */
 	div = (lcdclk + 2 * mclk - 1) / (2 * mclk) - 1;
 
-	dev_dbg(pcdev->icd->parent,
+	dev_dbg(pcdev->soc_host.icd->parent,
 		"System clock %lukHz, target freq %dkHz, divisor %lu\n",
 		lcdclk / 1000, mclk / 1000, div);
 
@@ -400,7 +399,7 @@ static void mx1_camera_activate(struct mx1_camera_dev *pcdev)
 {
 	unsigned int csicr1 = CSICR1_EN;
 
-	dev_dbg(pcdev->icd->parent, "Activate device\n");
+	dev_dbg(pcdev->soc_host.icd->parent, "Activate device\n");
 
 	clk_prepare_enable(pcdev->clk);
 
@@ -416,7 +415,7 @@ static void mx1_camera_activate(struct mx1_camera_dev *pcdev)
 
 static void mx1_camera_deactivate(struct mx1_camera_dev *pcdev)
 {
-	dev_dbg(pcdev->icd->parent, "Deactivate device\n");
+	dev_dbg(pcdev->soc_host.icd->parent, "Deactivate device\n");
 
 	/* Disable all CSI interface */
 	__raw_writel(0x00, pcdev->base + CSICR1);
@@ -433,16 +432,11 @@ static int mx1_camera_add_device(struct soc_camera_device *icd)
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct mx1_camera_dev *pcdev = ici->priv;
 
-	if (pcdev->icd)
-		return -EBUSY;
-
 	dev_info(icd->parent, "MX1 Camera driver attached to camera %d\n",
 		 icd->devnum);
 
 	mx1_camera_activate(pcdev);
 
-	pcdev->icd = icd;
-
 	return 0;
 }
 
@@ -452,8 +446,6 @@ static void mx1_camera_remove_device(struct soc_camera_device *icd)
 	struct mx1_camera_dev *pcdev = ici->priv;
 	unsigned int csicr1;
 
-	BUG_ON(icd != pcdev->icd);
-
 	/* disable interrupts */
 	csicr1 = __raw_readl(pcdev->base + CSICR1) & ~CSI_IRQ_MASK;
 	__raw_writel(csicr1, pcdev->base + CSICR1);
@@ -465,8 +457,6 @@ static void mx1_camera_remove_device(struct soc_camera_device *icd)
 		 icd->devnum);
 
 	mx1_camera_deactivate(pcdev);
-
-	pcdev->icd = NULL;
 }
 
 static int mx1_camera_set_bus_param(struct soc_camera_device *icd)
diff --git a/drivers/media/platform/soc_camera/mx2_camera.c b/drivers/media/platform/soc_camera/mx2_camera.c
index 5bbeb43..772e071 100644
--- a/drivers/media/platform/soc_camera/mx2_camera.c
+++ b/drivers/media/platform/soc_camera/mx2_camera.c
@@ -236,7 +236,6 @@ enum mx2_camera_type {
 struct mx2_camera_dev {
 	struct device		*dev;
 	struct soc_camera_host	soc_host;
-	struct soc_camera_device *icd;
 	struct clk		*clk_emma_ahb, *clk_emma_ipg;
 	struct clk		*clk_csi_ahb, *clk_csi_per;
 
@@ -394,8 +393,8 @@ static void mx27_update_emma_buf(struct mx2_camera_dev *pcdev,
 		writel(phys, pcdev->base_emma +
 			PRP_DEST_Y_PTR - 0x14 * bufnum);
 		if (prp->out_fmt == V4L2_PIX_FMT_YUV420) {
-			u32 imgsize = pcdev->icd->user_height *
-					pcdev->icd->user_width;
+			u32 imgsize = pcdev->soc_host.icd->user_height *
+					pcdev->soc_host.icd->user_width;
 
 			writel(phys + imgsize, pcdev->base_emma +
 				PRP_DEST_CB_PTR - 0x14 * bufnum);
@@ -424,9 +423,6 @@ static int mx2_camera_add_device(struct soc_camera_device *icd)
 	int ret;
 	u32 csicr1;
 
-	if (pcdev->icd)
-		return -EBUSY;
-
 	ret = clk_prepare_enable(pcdev->clk_csi_ahb);
 	if (ret < 0)
 		return ret;
@@ -441,7 +437,6 @@ static int mx2_camera_add_device(struct soc_camera_device *icd)
 	pcdev->csicr1 = csicr1;
 	writel(pcdev->csicr1, pcdev->base_csi + CSICR1);
 
-	pcdev->icd = icd;
 	pcdev->frame_count = 0;
 
 	dev_info(icd->parent, "Camera driver attached to camera %d\n",
@@ -460,14 +455,10 @@ static void mx2_camera_remove_device(struct soc_camera_device *icd)
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct mx2_camera_dev *pcdev = ici->priv;
 
-	BUG_ON(icd != pcdev->icd);
-
 	dev_info(icd->parent, "Camera driver detached from camera %d\n",
 		 icd->devnum);
 
 	mx2_camera_deactivate(pcdev);
-
-	pcdev->icd = NULL;
 }
 
 /*
diff --git a/drivers/media/platform/soc_camera/mx3_camera.c b/drivers/media/platform/soc_camera/mx3_camera.c
index 5da3377..71b9b19 100644
--- a/drivers/media/platform/soc_camera/mx3_camera.c
+++ b/drivers/media/platform/soc_camera/mx3_camera.c
@@ -94,7 +94,6 @@ struct mx3_camera_dev {
 	 * Interface. If anyone ever builds hardware to enable more than one
 	 * camera _simultaneously_, they will have to modify this driver too
 	 */
-	struct soc_camera_device *icd;
 	struct clk		*clk;
 
 	void __iomem		*base;
@@ -517,13 +516,9 @@ static int mx3_camera_add_device(struct soc_camera_device *icd)
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct mx3_camera_dev *mx3_cam = ici->priv;
 
-	if (mx3_cam->icd)
-		return -EBUSY;
-
 	mx3_camera_activate(mx3_cam, icd);
 
 	mx3_cam->buf_total = 0;
-	mx3_cam->icd = icd;
 
 	dev_info(icd->parent, "MX3 Camera driver attached to camera %d\n",
 		 icd->devnum);
@@ -538,8 +533,6 @@ static void mx3_camera_remove_device(struct soc_camera_device *icd)
 	struct mx3_camera_dev *mx3_cam = ici->priv;
 	struct idmac_channel **ichan = &mx3_cam->idmac_channel[0];
 
-	BUG_ON(icd != mx3_cam->icd);
-
 	if (*ichan) {
 		dma_release_channel(&(*ichan)->dma_chan);
 		*ichan = NULL;
@@ -547,8 +540,6 @@ static void mx3_camera_remove_device(struct soc_camera_device *icd)
 
 	clk_disable_unprepare(mx3_cam->clk);
 
-	mx3_cam->icd = NULL;
-
 	dev_info(icd->parent, "MX3 Camera driver detached from camera %d\n",
 		 icd->devnum);
 }
diff --git a/drivers/media/platform/soc_camera/omap1_camera.c b/drivers/media/platform/soc_camera/omap1_camera.c
index 9689a6e..c42c23e 100644
--- a/drivers/media/platform/soc_camera/omap1_camera.c
+++ b/drivers/media/platform/soc_camera/omap1_camera.c
@@ -150,7 +150,6 @@ struct omap1_cam_buf {
 
 struct omap1_cam_dev {
 	struct soc_camera_host		soc_host;
-	struct soc_camera_device	*icd;
 	struct clk			*clk;
 
 	unsigned int			irq;
@@ -564,7 +563,7 @@ static void videobuf_done(struct omap1_cam_dev *pcdev,
 {
 	struct omap1_cam_buf *buf = pcdev->active;
 	struct videobuf_buffer *vb;
-	struct device *dev = pcdev->icd->parent;
+	struct device *dev = pcdev->soc_host.icd->parent;
 
 	if (WARN_ON(!buf)) {
 		suspend_capture(pcdev);
@@ -790,7 +789,7 @@ out:
 static irqreturn_t cam_isr(int irq, void *data)
 {
 	struct omap1_cam_dev *pcdev = data;
-	struct device *dev = pcdev->icd->parent;
+	struct device *dev = pcdev->soc_host.icd->parent;
 	struct omap1_cam_buf *buf = pcdev->active;
 	u32 it_status;
 	unsigned long flags;
@@ -904,9 +903,6 @@ static int omap1_cam_add_device(struct soc_camera_device *icd)
 	struct omap1_cam_dev *pcdev = ici->priv;
 	u32 ctrlclock;
 
-	if (pcdev->icd)
-		return -EBUSY;
-
 	clk_enable(pcdev->clk);
 
 	/* setup sensor clock */
@@ -941,8 +937,6 @@ static int omap1_cam_add_device(struct soc_camera_device *icd)
 
 	sensor_reset(pcdev, false);
 
-	pcdev->icd = icd;
-
 	dev_dbg(icd->parent, "OMAP1 Camera driver attached to camera %d\n",
 			icd->devnum);
 	return 0;
@@ -954,8 +948,6 @@ static void omap1_cam_remove_device(struct soc_camera_device *icd)
 	struct omap1_cam_dev *pcdev = ici->priv;
 	u32 ctrlclock;
 
-	BUG_ON(icd != pcdev->icd);
-
 	suspend_capture(pcdev);
 	disable_capture(pcdev);
 
@@ -974,8 +966,6 @@ static void omap1_cam_remove_device(struct soc_camera_device *icd)
 
 	clk_disable(pcdev->clk);
 
-	pcdev->icd = NULL;
-
 	dev_dbg(icd->parent,
 		"OMAP1 Camera driver detached from camera %d\n", icd->devnum);
 }
diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
index d665242..686edf7 100644
--- a/drivers/media/platform/soc_camera/pxa_camera.c
+++ b/drivers/media/platform/soc_camera/pxa_camera.c
@@ -200,7 +200,6 @@ struct pxa_camera_dev {
 	 * interface. If anyone ever builds hardware to enable more than
 	 * one camera, they will have to modify this driver too
 	 */
-	struct soc_camera_device *icd;
 	struct clk		*clk;
 
 	unsigned int		irq;
@@ -966,13 +965,8 @@ static int pxa_camera_add_device(struct soc_camera_device *icd)
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct pxa_camera_dev *pcdev = ici->priv;
 
-	if (pcdev->icd)
-		return -EBUSY;
-
 	pxa_camera_activate(pcdev);
 
-	pcdev->icd = icd;
-
 	dev_info(icd->parent, "PXA Camera driver attached to camera %d\n",
 		 icd->devnum);
 
@@ -985,8 +979,6 @@ static void pxa_camera_remove_device(struct soc_camera_device *icd)
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct pxa_camera_dev *pcdev = ici->priv;
 
-	BUG_ON(icd != pcdev->icd);
-
 	dev_info(icd->parent, "PXA Camera driver detached from camera %d\n",
 		 icd->devnum);
 
@@ -999,8 +991,6 @@ static void pxa_camera_remove_device(struct soc_camera_device *icd)
 	DCSR(pcdev->dma_chans[2]) = 0;
 
 	pxa_camera_deactivate(pcdev);
-
-	pcdev->icd = NULL;
 }
 
 static int test_platform_param(struct pxa_camera_dev *pcdev,
@@ -1596,8 +1586,8 @@ static int pxa_camera_suspend(struct device *dev)
 	pcdev->save_cicr[i++] = __raw_readl(pcdev->base + CICR3);
 	pcdev->save_cicr[i++] = __raw_readl(pcdev->base + CICR4);
 
-	if (pcdev->icd) {
-		struct v4l2_subdev *sd = soc_camera_to_subdev(pcdev->icd);
+	if (pcdev->soc_host.icd) {
+		struct v4l2_subdev *sd = soc_camera_to_subdev(pcdev->soc_host.icd);
 		ret = v4l2_subdev_call(sd, core, s_power, 0);
 		if (ret == -ENOIOCTLCMD)
 			ret = 0;
@@ -1622,8 +1612,8 @@ static int pxa_camera_resume(struct device *dev)
 	__raw_writel(pcdev->save_cicr[i++], pcdev->base + CICR3);
 	__raw_writel(pcdev->save_cicr[i++], pcdev->base + CICR4);
 
-	if (pcdev->icd) {
-		struct v4l2_subdev *sd = soc_camera_to_subdev(pcdev->icd);
+	if (pcdev->soc_host.icd) {
+		struct v4l2_subdev *sd = soc_camera_to_subdev(pcdev->soc_host.icd);
 		ret = v4l2_subdev_call(sd, core, s_power, 1);
 		if (ret == -ENOIOCTLCMD)
 			ret = 0;
diff --git a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
index 143d29fe..5b7d8e1 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
@@ -95,7 +95,6 @@ struct sh_mobile_ceu_buffer {
 
 struct sh_mobile_ceu_dev {
 	struct soc_camera_host ici;
-	struct soc_camera_device *icd;
 	struct platform_device *csi2_pdev;
 
 	unsigned int irq;
@@ -163,7 +162,7 @@ static u32 ceu_read(struct sh_mobile_ceu_dev *priv, unsigned long reg_offs)
 static int sh_mobile_ceu_soft_reset(struct sh_mobile_ceu_dev *pcdev)
 {
 	int i, success = 0;
-	struct soc_camera_device *icd = pcdev->icd;
+	struct soc_camera_device *icd = pcdev->ici.icd;
 
 	ceu_write(pcdev, CAPSR, 1 << 16); /* reset */
 
@@ -277,7 +276,7 @@ static int sh_mobile_ceu_videobuf_setup(struct vb2_queue *vq,
  */
 static int sh_mobile_ceu_capture(struct sh_mobile_ceu_dev *pcdev)
 {
-	struct soc_camera_device *icd = pcdev->icd;
+	struct soc_camera_device *icd = pcdev->ici.icd;
 	dma_addr_t phys_addr_top, phys_addr_bottom;
 	unsigned long top1, top2;
 	unsigned long bottom1, bottom2;
@@ -552,9 +551,6 @@ static int sh_mobile_ceu_add_device(struct soc_camera_device *icd)
 	struct v4l2_subdev *csi2_sd;
 	int ret;
 
-	if (pcdev->icd)
-		return -EBUSY;
-
 	dev_info(icd->parent,
 		 "SuperH Mobile CEU driver attached to camera %d\n",
 		 icd->devnum);
@@ -583,7 +579,6 @@ static int sh_mobile_ceu_add_device(struct soc_camera_device *icd)
 	 */
 	if (ret == -ENODEV && csi2_sd)
 		csi2_sd->grp_id = 0;
-	pcdev->icd = icd;
 
 	return 0;
 }
@@ -595,8 +590,6 @@ static void sh_mobile_ceu_remove_device(struct soc_camera_device *icd)
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
 	struct v4l2_subdev *csi2_sd = find_csi2(pcdev);
 
-	BUG_ON(icd != pcdev->icd);
-
 	v4l2_subdev_call(csi2_sd, core, s_power, 0);
 	if (csi2_sd)
 		csi2_sd->grp_id = 0;
@@ -618,8 +611,6 @@ static void sh_mobile_ceu_remove_device(struct soc_camera_device *icd)
 	dev_info(icd->parent,
 		 "SuperH Mobile CEU driver detached from camera %d\n",
 		 icd->devnum);
-
-	pcdev->icd = NULL;
 }
 
 /*
diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index eea832c..e32e4e2 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -505,6 +505,32 @@ static int soc_camera_set_fmt(struct soc_camera_device *icd,
 	return ici->ops->set_bus_param(icd);
 }
 
+static int soc_camera_add_device(struct soc_camera_device *icd)
+{
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+	int ret;
+
+	if (ici->icd)
+		return -EBUSY;
+
+	ret = ici->ops->add(icd);
+	if (!ret)
+		ici->icd = icd;
+
+	return ret;
+}
+
+static void soc_camera_remove_device(struct soc_camera_device *icd)
+{
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+
+	if (WARN_ON(icd != ici->icd))
+		return;
+
+	ici->ops->remove(icd);
+	ici->icd = NULL;
+}
+
 static int soc_camera_open(struct file *file)
 {
 	struct video_device *vdev = video_devdata(file);
@@ -568,7 +594,7 @@ static int soc_camera_open(struct file *file)
 		if (sdesc->subdev_desc.reset)
 			sdesc->subdev_desc.reset(icd->pdev);
 
-		ret = ici->ops->add(icd);
+		ret = soc_camera_add_device(icd);
 		if (ret < 0) {
 			dev_err(icd->pdev, "Couldn't activate the camera: %d\n", ret);
 			goto eiciadd;
@@ -619,7 +645,7 @@ esfmt:
 eresume:
 	__soc_camera_power_off(icd);
 epower:
-	ici->ops->remove(icd);
+	soc_camera_remove_device(icd);
 eiciadd:
 	icd->use_count--;
 	mutex_unlock(&ici->host_lock);
@@ -643,7 +669,7 @@ static int soc_camera_close(struct file *file)
 
 		if (ici->ops->init_videobuf2)
 			vb2_queue_release(&icd->vb2_vidq);
-		ici->ops->remove(icd);
+		soc_camera_remove_device(icd);
 
 		__soc_camera_power_off(icd);
 	}
@@ -1167,7 +1193,7 @@ static int soc_camera_probe(struct soc_camera_device *icd)
 		ssdd->reset(icd->pdev);
 
 	mutex_lock(&ici->host_lock);
-	ret = ici->ops->add(icd);
+	ret = soc_camera_add_device(icd);
 	mutex_unlock(&ici->host_lock);
 	if (ret < 0)
 		goto eadd;
@@ -1240,7 +1266,7 @@ static int soc_camera_probe(struct soc_camera_device *icd)
 		icd->field		= mf.field;
 	}
 
-	ici->ops->remove(icd);
+	soc_camera_remove_device(icd);
 
 	mutex_unlock(&ici->host_lock);
 
@@ -1263,7 +1289,7 @@ eadddev:
 	icd->vdev = NULL;
 evdc:
 	mutex_lock(&ici->host_lock);
-	ici->ops->remove(icd);
+	soc_camera_remove_device(icd);
 	mutex_unlock(&ici->host_lock);
 eadd:
 	v4l2_ctrl_handler_free(&icd->ctrl_handler);
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index ff77d08..5a46ce2 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -64,6 +64,7 @@ struct soc_camera_host {
 	struct mutex host_lock;		/* Protect pipeline modifications */
 	unsigned char nr;		/* Host number */
 	u32 capabilities;
+	struct soc_camera_device *icd;	/* Currently attached client */
 	void *priv;
 	const char *drv_name;
 	struct soc_camera_host_ops *ops;
-- 
1.7.2.5

