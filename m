Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934381AbdEVOT3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 May 2017 10:19:29 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, kieran.bingham@ideasonboard.com
Subject: [PATCH v3 3/5] v4l: vsp1: Map the DL and video buffers through the proper bus master
Date: Mon, 22 May 2017 15:19:20 +0100
Message-Id: <79c3bf9799c7d652e80efee473bf3178d8b6e428.1495461942.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.d1f5942e1a0b688b3527bb7998b184d3c0b0e9b1.1495461942.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.d1f5942e1a0b688b3527bb7998b184d3c0b0e9b1.1495461942.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.d1f5942e1a0b688b3527bb7998b184d3c0b0e9b1.1495461942.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.d1f5942e1a0b688b3527bb7998b184d3c0b0e9b1.1495461942.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Magnus Damm <magnus.damm@gmail.com>

On Gen2 hardware the VSP1 is a bus master and accesses the display list
and video buffers through DMA directly. On Gen3 hardware, however,
memory accesses go through a separate IP core called FCP.

The VSP1 driver unconditionally maps DMA buffers through the VSP device.
While this doesn't cause any practical issue so far, DMA mappings will
be incorrect as soon as we will enable IOMMU support for the FCP on Gen3
platforms, resulting in IOMMU faults.

Fix this by mapping all buffers through the FCP device if present, and
through the VSP1 device as usual otherwise.

Suggested-by: Magnus Damm <magnus.damm@gmail.com>
[Cache the bus master device]
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1.h       |  1 +
 drivers/media/platform/vsp1/vsp1_dl.c    |  4 ++--
 drivers/media/platform/vsp1/vsp1_drv.c   |  9 +++++++++
 drivers/media/platform/vsp1/vsp1_video.c |  2 +-
 4 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1.h b/drivers/media/platform/vsp1/vsp1.h
index 85387a64179a..847963b6e9eb 100644
--- a/drivers/media/platform/vsp1/vsp1.h
+++ b/drivers/media/platform/vsp1/vsp1.h
@@ -74,6 +74,7 @@ struct vsp1_device {
 
 	void __iomem *mmio;
 	struct rcar_fcp_device *fcp;
+	struct device *bus_master;
 
 	struct vsp1_bru *bru;
 	struct vsp1_clu *clu;
diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
index 7d8f37772b56..445d1c31fff3 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.c
+++ b/drivers/media/platform/vsp1/vsp1_dl.c
@@ -137,7 +137,7 @@ static int vsp1_dl_body_init(struct vsp1_device *vsp1,
 	dlb->vsp1 = vsp1;
 	dlb->size = size;
 
-	dlb->entries = dma_alloc_wc(vsp1->dev, dlb->size, &dlb->dma,
+	dlb->entries = dma_alloc_wc(vsp1->bus_master, dlb->size, &dlb->dma,
 				    GFP_KERNEL);
 	if (!dlb->entries)
 		return -ENOMEM;
@@ -150,7 +150,7 @@ static int vsp1_dl_body_init(struct vsp1_device *vsp1,
  */
 static void vsp1_dl_body_cleanup(struct vsp1_dl_body *dlb)
 {
-	dma_free_wc(dlb->vsp1->dev, dlb->size, dlb->entries, dlb->dma);
+	dma_free_wc(dlb->vsp1->bus_master, dlb->size, dlb->entries, dlb->dma);
 }
 
 /**
diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index 048446af5ae7..95c26edead85 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -764,6 +764,15 @@ static int vsp1_probe(struct platform_device *pdev)
 				PTR_ERR(vsp1->fcp));
 			return PTR_ERR(vsp1->fcp);
 		}
+
+		/*
+		 * When the FCP is present, it handles all bus master accesses
+		 * for the VSP and must thus be used in place of the VSP device
+		 * to map DMA buffers.
+		 */
+		vsp1->bus_master = rcar_fcp_get_device(vsp1->fcp);
+	} else {
+		vsp1->bus_master = vsp1->dev;
 	}
 
 	/* Configure device parameters based on the version register. */
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index eab3c3ea85d7..5af3486afe07 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -1197,7 +1197,7 @@ struct vsp1_video *vsp1_video_create(struct vsp1_device *vsp1,
 	video->queue.ops = &vsp1_video_queue_qops;
 	video->queue.mem_ops = &vb2_dma_contig_memops;
 	video->queue.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
-	video->queue.dev = video->vsp1->dev;
+	video->queue.dev = video->vsp1->bus_master;
 	ret = vb2_queue_init(&video->queue);
 	if (ret < 0) {
 		dev_err(video->vsp1->dev, "failed to initialize vb2 queue\n");
-- 
git-series 0.9.1
