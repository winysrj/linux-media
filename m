Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:34457 "EHLO
        mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966105AbcJ0Om2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Oct 2016 10:42:28 -0400
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>,
        laurent.pinchart+renesas@ideasonboard.com, mchehab@osg.samsung.com
Date: Thu, 27 Oct 2016 20:28:36 +0900
Message-Id: <20161027112836.11613.13334.sendpatchset@little-apple>
Subject: [PATCH/RFC] v4l: vsp1: Use FCP device for DisplayList and VB2 queue
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Magnus Damm <damm+renesas@opensource.se>

Incrementally fix up parts of the code not yet covered by the
IOMMU patches by Laurent:

[PATCH 0/6] R-Car DU: Fix IOMMU operation when connected to VSP

This patch simply uses the recently introduced function
rcar_fcp_get_device() on the VSP device to retrieve the
FCP device that needs to be used with the DMA MAP API
when IOMMU is enabled.

Without this patch the DU/VSP/FCP devices on R-Car Gen3 will
generate traps during boot when IOMMU is enabled.

Signed-off-by: Magnus Damm <damm+renesas@opensource.se>
---

 drivers/media/platform/vsp1/vsp1_dl.c    |   13 +++++++++----
 drivers/media/platform/vsp1/vsp1_video.c |    6 +++++-
 2 files changed, 14 insertions(+), 5 deletions(-)

--- 0001/drivers/media/platform/vsp1/vsp1_dl.c
+++ work/drivers/media/platform/vsp1/vsp1_dl.c	2016-09-01 06:18:17.140607110 +0900
@@ -17,6 +17,8 @@
 #include <linux/slab.h>
 #include <linux/workqueue.h>
 
+#include <media/rcar-fcp.h>
+
 #include "vsp1.h"
 #include "vsp1_dl.h"
 
@@ -130,12 +132,12 @@ static int vsp1_dl_body_init(struct vsp1
 			     size_t extra_size)
 {
 	size_t size = num_entries * sizeof(*dlb->entries) + extra_size;
+	struct device *fcp = rcar_fcp_get_device(vsp1->fcp);
 
 	dlb->vsp1 = vsp1;
 	dlb->size = size;
-
-	dlb->entries = dma_alloc_wc(vsp1->dev, dlb->size, &dlb->dma,
-				    GFP_KERNEL);
+	dlb->entries = dma_alloc_wc(fcp ? fcp : vsp1->dev,
+				    dlb->size, &dlb->dma, GFP_KERNEL);
 	if (!dlb->entries)
 		return -ENOMEM;
 
@@ -147,7 +149,10 @@ static int vsp1_dl_body_init(struct vsp1
  */
 static void vsp1_dl_body_cleanup(struct vsp1_dl_body *dlb)
 {
-	dma_free_wc(dlb->vsp1->dev, dlb->size, dlb->entries, dlb->dma);
+	struct device *fcp = rcar_fcp_get_device(dlb->vsp1->fcp);
+
+	dma_free_wc(fcp ? fcp : dlb->vsp1->dev,
+		    dlb->size, dlb->entries, dlb->dma);
 }
 
 /**
--- 0001/drivers/media/platform/vsp1/vsp1_video.c
+++ work/drivers/media/platform/vsp1/vsp1_video.c	2016-09-01 06:20:02.940607110 +0900
@@ -27,6 +27,8 @@
 #include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-dma-contig.h>
 
+#include <media/rcar-fcp.h>
+
 #include "vsp1.h"
 #include "vsp1_bru.h"
 #include "vsp1_dl.h"
@@ -939,6 +941,7 @@ struct vsp1_video *vsp1_video_create(str
 {
 	struct vsp1_video *video;
 	const char *direction;
+	struct device *fcp;
 	int ret;
 
 	video = devm_kzalloc(vsp1->dev, sizeof(*video), GFP_KERNEL);
@@ -996,7 +999,8 @@ struct vsp1_video *vsp1_video_create(str
 	video->queue.ops = &vsp1_video_queue_qops;
 	video->queue.mem_ops = &vb2_dma_contig_memops;
 	video->queue.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
-	video->queue.dev = video->vsp1->dev;
+	fcp = rcar_fcp_get_device(vsp1->fcp);
+	video->queue.dev = fcp ? fcp : video->vsp1->dev;
 	ret = vb2_queue_init(&video->queue);
 	if (ret < 0) {
 		dev_err(video->vsp1->dev, "failed to initialize vb2 queue\n");
