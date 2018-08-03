Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:50430 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727323AbeHCNdf (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Aug 2018 09:33:35 -0400
From: Kieran Bingham <kieran@ksquared.org.uk>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v6 04/11] media: vsp1: Remove unused display list structure field
Date: Fri,  3 Aug 2018 12:37:23 +0100
Message-Id: <8eef78f4faf05ed07d0c99d51a4e1e335927d105.1533295631.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.7e4241408f077710d96e0cc06e039d1022fb0c8c.1533295631.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.7e4241408f077710d96e0cc06e039d1022fb0c8c.1533295631.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.7e4241408f077710d96e0cc06e039d1022fb0c8c.1533295631.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.7e4241408f077710d96e0cc06e039d1022fb0c8c.1533295631.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

The vsp1 reference in the vsp1_dl_body structure is not used.
Remove it.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_dl.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
index 202bc0c6e484..199843a73df1 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.c
+++ b/drivers/media/platform/vsp1/vsp1_dl.c
@@ -45,7 +45,6 @@ struct vsp1_dl_entry {
  * @free: entry in the pool free body list
  * @refcnt: reference tracking for the body
  * @pool: pool to which this body belongs
- * @vsp1: the VSP1 device
  * @entries: array of entries
  * @dma: DMA address of the entries
  * @size: size of the DMA memory in bytes
@@ -59,7 +58,6 @@ struct vsp1_dl_body {
 	refcount_t refcnt;
 
 	struct vsp1_dl_body_pool *pool;
-	struct vsp1_device *vsp1;
 
 	struct vsp1_dl_entry *entries;
 	dma_addr_t dma;
-- 
git-series 0.9.1
