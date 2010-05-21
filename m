Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38513 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062Ab0EUHTm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 May 2010 03:19:42 -0400
Date: Fri, 21 May 2010 09:19:34 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Baruch Siach <baruch@tkos.co.il>
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Sascha Hauer <kernel@pengutronix.de>
Subject: Re: [PATCH 1/3] mx2_camera: Add soc_camera support for
	i.MX25/i.MX27
Message-ID: <20100521071934.GC17272@pengutronix.de>
References: <cover.1273150585.git.baruch@tkos.co.il> <a029bab8fcb3273df4a1d98f779f110b127742bd.1273150585.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a029bab8fcb3273df4a1d98f779f110b127742bd.1273150585.git.baruch@tkos.co.il>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, May 06, 2010 at 04:09:39PM +0300, Baruch Siach wrote:
> This is the soc_camera support developed by Sascha Hauer for the i.MX27.  Alan
> Carvalho de Assis modified the original driver to get it working on more recent
> kernels. I modified it further to add support for i.MX25. This driver has only
> been tested on the i.MX25 platform.
> 
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> ---
>  arch/arm/plat-mxc/include/mach/memory.h  |    4 +-
>  arch/arm/plat-mxc/include/mach/mx2_cam.h |   41 +
>  drivers/media/video/Kconfig              |   14 +
>  drivers/media/video/Makefile             |    1 +
>  drivers/media/video/mx2_camera.c         | 1396 ++++++++++++++++++++++++++++++
>  5 files changed, 1454 insertions(+), 2 deletions(-)
>  create mode 100644 arch/arm/plat-mxc/include/mach/mx2_cam.h
>  create mode 100644 drivers/media/video/mx2_camera.c
> 

On i.MX27 in DMA mode you pass the kernel virtual address to the DMA
engine. Should be a physical address, so please amend the following:

>From 8a1e1ac8b2448a5c83ed933e427cccd00d470308 Mon Sep 17 00:00:00 2001
From: Sascha Hauer <s.hauer@pengutronix.de>
Date: Fri, 21 May 2010 09:15:22 +0200
Subject: [PATCH 2/2] mx2_camera: pass physical address to DMA engine

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/media/video/mx2_camera.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
index 5d6fb08..6436968 100644
--- a/drivers/media/video/mx2_camera.c
+++ b/drivers/media/video/mx2_camera.c
@@ -216,6 +216,7 @@ struct mx2_camera_dev {
 
 	unsigned int		irq_csi, irq_emma;
 	void __iomem		*base_csi, *base_emma;
+	unsigned long		base_dma;
 
 	struct mx2_camera_platform_data *pdata;
 	struct resource		*res_csi, *res_emma;
@@ -550,7 +551,7 @@ static void mx2_videobuf_queue(struct videobuf_queue *vq,
 		if (!pcdev->active) {
 			ret = imx_dma_setup_single(pcdev->dma,
 					videobuf_to_dma_contig(vb), vb->size,
-					(u32)pcdev->base_csi + 0x10,
+					(u32)pcdev->base_dma + 0x10,
 					DMA_MODE_READ);
 			if (ret) {
 				vb->state = VIDEOBUF_ERROR;
@@ -976,7 +977,8 @@ static void mx27_camera_frame_done(struct mx2_camera_dev *pcdev, int state)
 	vb->state = VIDEOBUF_ACTIVE;
 
 	ret = imx_dma_setup_single(pcdev->dma, videobuf_to_dma_contig(vb),
-			vb->size, (u32)pcdev->base_csi + 0x10, DMA_MODE_READ);
+			vb->size, (u32)pcdev->base_dma + 0x10, DMA_MODE_READ);
+
 	if (ret) {
 		vb->state = VIDEOBUF_ERROR;
 		wake_up(&vb->done);
@@ -1273,6 +1275,7 @@ static int mx2_camera_probe(struct platform_device *pdev)
 	}
 	pcdev->irq_csi = irq_csi;
 	pcdev->base_csi = base_csi;
+	pcdev->base_dma = res_csi->start;
 	pcdev->dev = &pdev->dev;
 
 	err = request_irq(pcdev->irq_csi, mx2_cam_irq_handler, 0,
-- 
1.7.0

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
