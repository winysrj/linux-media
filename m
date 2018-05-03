Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:34888 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751257AbeECNga (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 3 May 2018 09:36:30 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v4 04/11] media: vsp1: Remove unused display list structure field
Date: Thu,  3 May 2018 14:36:15 +0100
Message-Id: <9266418a78e00b185bb5ff131b54f289c7d8b016.1525354194.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.bd2eb66d11f8094114941107dbc78dc02c9c7fdd.1525354194.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.bd2eb66d11f8094114941107dbc78dc02c9c7fdd.1525354194.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.bd2eb66d11f8094114941107dbc78dc02c9c7fdd.1525354194.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.bd2eb66d11f8094114941107dbc78dc02c9c7fdd.1525354194.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The vsp1 reference in the vsp1_dl_body structure is not used.
Remove it.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_dl.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
index ec6fc21fabe0..b23e88cda49f 100644
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
