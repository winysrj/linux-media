Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60146 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751990AbbJGLZv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Oct 2015 07:25:51 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: tiffany.lin@mediatek.com
Subject: [PATCH v3 1/2] media: vb2 dma-contig: Fully cache synchronise buffers in prepare and finish
Date: Wed,  7 Oct 2015 14:23:32 +0300
Message-Id: <1444217013-21156-2-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1444217013-21156-1-git-send-email-sakari.ailus@iki.fi>
References: <1444217013-21156-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Tiffany Lin <tiffany.lin@mediatek.com>

In videobuf2 dma-contig memory type the prepare and finish ops, instead of
passing the number of entries in the original scatterlist as the "nents"
parameter to dma_sync_sg_for_device() and dma_sync_sg_for_cpu(), the value
returned by dma_map_sg() was used. Albeit this has been suggested in
comments of some implementations (which have since been corrected), this
is wrong.

Cc: stable@vger.kernel.org # for v3.8 and up
Fixes: 199d101efdba ("v4l: vb2-dma-contig: add prepare/finish to dma-contig allocator")
Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/videobuf2-dma-contig.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index ea33d69..c331272 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -100,7 +100,8 @@ static void vb2_dc_prepare(void *buf_priv)
 	if (!sgt || buf->db_attach)
 		return;
 
-	dma_sync_sg_for_device(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
+	dma_sync_sg_for_device(buf->dev, sgt->sgl, sgt->orig_nents,
+			       buf->dma_dir);
 }
 
 static void vb2_dc_finish(void *buf_priv)
@@ -112,7 +113,7 @@ static void vb2_dc_finish(void *buf_priv)
 	if (!sgt || buf->db_attach)
 		return;
 
-	dma_sync_sg_for_cpu(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
+	dma_sync_sg_for_cpu(buf->dev, sgt->sgl, sgt->orig_nents, buf->dma_dir);
 }
 
 /*********************************************/
-- 
2.1.4

