Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:59474 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751246AbeECIoc (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 3 May 2018 04:44:32 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Cc: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v3 04/11] media: vsp1: Remove unused display list structure field
Date: Thu,  3 May 2018 09:44:15 +0100
Message-Id: <b3d27eb50202d3254836081163d83aa88f8fd967.1525336865.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.a15c17beeb074afaf226d19ff3c4fdba2f647500.1525336865.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.a15c17beeb074afaf226d19ff3c4fdba2f647500.1525336865.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.a15c17beeb074afaf226d19ff3c4fdba2f647500.1525336865.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.a15c17beeb074afaf226d19ff3c4fdba2f647500.1525336865.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The vsp1 reference in the vsp1_dl_body structure is not used.
Remove it.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_dl.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
index 09c29a4ed118..459da9f2c906 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.c
+++ b/drivers/media/platform/vsp1/vsp1_dl.c
@@ -44,7 +44,6 @@ struct vsp1_dl_entry {
  * @list: entry in the display list list of bodies
  * @free: entry in the pool free body list
  * @pool: pool to which this body belongs
- * @vsp1: the VSP1 device
  * @entries: array of entries
  * @dma: DMA address of the entries
  * @size: size of the DMA memory in bytes
@@ -58,7 +57,6 @@ struct vsp1_dl_body {
 	refcount_t refcnt;
 
 	struct vsp1_dl_body_pool *pool;
-	struct vsp1_device *vsp1;
 
 	struct vsp1_dl_entry *entries;
 	dma_addr_t dma;
-- 
git-series 0.9.1
