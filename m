Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:33747 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965421Ab3GSH76 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jul 2013 03:59:58 -0400
Received: by mail-la0-f52.google.com with SMTP id fo12so3208032lab.11
        for <linux-media@vger.kernel.org>; Fri, 19 Jul 2013 00:59:56 -0700 (PDT)
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>,
	=?UTF-8?q?=C2=A0Mauro=20Carvalho=20Chehab?= <mchehab@redhat.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	=?UTF-8?q?=C2=A0Ismael=20Luceno?=
	<ismael.luceno@corp.bluecherry.net>,
	=?UTF-8?q?=C2=A0Greg=20Kroah-Hartman?= <gregkh@linuxfoundation.org>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 3/4] media/marvell-ccic: Changes on the vb2-dma-sg API
Date: Fri, 19 Jul 2013 09:58:48 +0200
Message-Id: <1374220729-8304-4-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1374220729-8304-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1374220729-8304-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The struct vb2_dma_sg_desc has been replaced with the generic sg_table
to describe the location of the video buffers.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/media/platform/marvell-ccic/mcam-core.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index 64ab91e..b3d504a 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -1040,16 +1040,16 @@ static int mcam_vb_sg_buf_prepare(struct vb2_buffer *vb)
 {
 	struct mcam_vb_buffer *mvb = vb_to_mvb(vb);
 	struct mcam_camera *cam = vb2_get_drv_priv(vb->vb2_queue);
-	struct vb2_dma_sg_desc *sgd = vb2_dma_sg_plane_desc(vb, 0);
+	struct sg_table *sg_table = vb2_dma_sg_plane_desc(vb, 0);
 	struct mcam_dma_desc *desc = mvb->dma_desc;
 	struct scatterlist *sg;
 	int i;
 
-	mvb->dma_desc_nent = dma_map_sg(cam->dev, sgd->sglist, sgd->num_pages,
-			DMA_FROM_DEVICE);
+	mvb->dma_desc_nent = dma_map_sg(cam->dev, sg_table->sgl,
+			sg_table->nents, DMA_FROM_DEVICE);
 	if (mvb->dma_desc_nent <= 0)
 		return -EIO;  /* Not sure what's right here */
-	for_each_sg(sgd->sglist, sg, mvb->dma_desc_nent, i) {
+	for_each_sg(sg_table->sgl, sg, mvb->dma_desc_nent, i) {
 		desc->dma_addr = sg_dma_address(sg);
 		desc->segment_len = sg_dma_len(sg);
 		desc++;
@@ -1060,9 +1060,9 @@ static int mcam_vb_sg_buf_prepare(struct vb2_buffer *vb)
 static int mcam_vb_sg_buf_finish(struct vb2_buffer *vb)
 {
 	struct mcam_camera *cam = vb2_get_drv_priv(vb->vb2_queue);
-	struct vb2_dma_sg_desc *sgd = vb2_dma_sg_plane_desc(vb, 0);
+	struct sg_table *sg_table = vb2_dma_sg_plane_desc(vb, 0);
 
-	dma_unmap_sg(cam->dev, sgd->sglist, sgd->num_pages, DMA_FROM_DEVICE);
+	dma_unmap_sg(cam->dev, sg_table->sgl, sg_table->nents, DMA_FROM_DEVICE);
 	return 0;
 }
 
-- 
1.7.10.4

