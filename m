Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60148 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751990AbbJGLZx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Oct 2015 07:25:53 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: tiffany.lin@mediatek.com
Subject: [PATCH v3 2/2] media: vb2 dma-sg: Fully cache synchronise buffers in prepare and finish
Date: Wed,  7 Oct 2015 14:23:33 +0300
Message-Id: <1444217013-21156-3-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1444217013-21156-1-git-send-email-sakari.ailus@iki.fi>
References: <1444217013-21156-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Tiffany Lin <tiffany.lin@mediatek.com>

In videobuf2 dma-sg memory types the prepare and finish ops, instead
of passing the number of entries in the original scatterlist as the
"nents" parameter to dma_sync_sg_for_device() and dma_sync_sg_for_cpu(),
the value returned by dma_map_sg() was used. Albeit this has been
suggested in comments of some implementations (which have since been
corrected), this is wrong.

Cc: stable@vger.kernel.org # for v3.19 and up
Fixes: d790b7eda953 ("vb2-dma-sg: move dma_(un)map_sg here")
Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/videobuf2-dma-sg.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
index 34b6778..9985c89 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
@@ -210,7 +210,8 @@ static void vb2_dma_sg_prepare(void *buf_priv)
 	if (buf->db_attach)
 		return;
 
-	dma_sync_sg_for_device(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
+	dma_sync_sg_for_device(buf->dev, sgt->sgl, sgt->orig_nents,
+			       buf->dma_dir);
 }
 
 static void vb2_dma_sg_finish(void *buf_priv)
@@ -222,7 +223,7 @@ static void vb2_dma_sg_finish(void *buf_priv)
 	if (buf->db_attach)
 		return;
 
-	dma_sync_sg_for_cpu(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
+	dma_sync_sg_for_cpu(buf->dev, sgt->sgl, sgt->orig_nents, buf->dma_dir);
 }
 
 static void *vb2_dma_sg_get_userptr(void *alloc_ctx, unsigned long vaddr,
-- 
2.1.4

