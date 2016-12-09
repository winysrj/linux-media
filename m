Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wj0-f196.google.com ([209.85.210.196]:34458 "EHLO
        mail-wj0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933553AbcLIMfa (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Dec 2016 07:35:30 -0500
From: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
To: linux-renesas-soc@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org, magnus.damm@gmail.com,
        Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Subject: [PATCH v1.5 5/6] v4l: vsp1: Provide display list and VB2 queue with FCP device
Date: Fri,  9 Dec 2016 13:35:11 +0100
Message-Id: <1481286912-16555-6-git-send-email-ulrich.hecht+renesas@gmail.com>
In-Reply-To: <1481286912-16555-1-git-send-email-ulrich.hecht+renesas@gmail.com>
References: <1481286912-16555-1-git-send-email-ulrich.hecht+renesas@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Prevents IPMMU trap during boot on r8a7795/6 Salvator-X boards:
ipmmu-vmsa febd0000.mmu: Unhandled faut: status 0x00000101 iova 0x7f09a000

Code by Magnus Damm.

Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
---
 drivers/media/platform/vsp1/vsp1_dl.c    | 12 +++++++++---
 drivers/media/platform/vsp1/vsp1_video.c |  6 +++++-
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
index ad545af..f610c88 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.c
+++ b/drivers/media/platform/vsp1/vsp1_dl.c
@@ -17,6 +17,8 @@
 #include <linux/slab.h>
 #include <linux/workqueue.h>
 
+#include <media/rcar-fcp.h>
+
 #include "vsp1.h"
 #include "vsp1_dl.h"
 
@@ -133,12 +135,13 @@ static int vsp1_dl_body_init(struct vsp1_device *vsp1,
 			     size_t extra_size)
 {
 	size_t size = num_entries * sizeof(*dlb->entries) + extra_size;
+	struct device *fcp = rcar_fcp_get_device(vsp1->fcp);
 
 	dlb->vsp1 = vsp1;
 	dlb->size = size;
 
-	dlb->entries = dma_alloc_wc(vsp1->dev, dlb->size, &dlb->dma,
-				    GFP_KERNEL);
+	dlb->entries = dma_alloc_wc(fcp ? fcp : vsp1->dev,
+				    dlb->size, &dlb->dma, GFP_KERNEL);
 	if (!dlb->entries)
 		return -ENOMEM;
 
@@ -150,7 +153,10 @@ static int vsp1_dl_body_init(struct vsp1_device *vsp1,
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
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 41e8b09..8f8e57e 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -27,6 +27,8 @@
 #include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-dma-contig.h>
 
+#include <media/rcar-fcp.h>
+
 #include "vsp1.h"
 #include "vsp1_bru.h"
 #include "vsp1_dl.h"
@@ -1094,6 +1096,7 @@ struct vsp1_video *vsp1_video_create(struct vsp1_device *vsp1,
 {
 	struct vsp1_video *video;
 	const char *direction;
+	struct device *fcp;
 	int ret;
 
 	video = devm_kzalloc(vsp1->dev, sizeof(*video), GFP_KERNEL);
@@ -1151,7 +1154,8 @@ struct vsp1_video *vsp1_video_create(struct vsp1_device *vsp1,
 	video->queue.ops = &vsp1_video_queue_qops;
 	video->queue.mem_ops = &vb2_dma_contig_memops;
 	video->queue.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
-	video->queue.dev = video->vsp1->dev;
+	fcp = rcar_fcp_get_device(vsp1->fcp);
+	video->queue.dev = fcp ? fcp : video->vsp1->dev;
 	ret = vb2_queue_init(&video->queue);
 	if (ret < 0) {
 		dev_err(video->vsp1->dev, "failed to initialize vb2 queue\n");
-- 
2.7.4

