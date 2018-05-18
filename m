Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:43780 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752225AbeERUmN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 16:42:13 -0400
From: Kieran Bingham <kieran@ksquared.org.uk>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: [PATCH v11 04/10] media: vsp1: Protect bodies against overflow
Date: Fri, 18 May 2018 21:41:57 +0100
Message-Id: <4b35530281bb2d821905718b8e3022f1c8e4f365.1526675940.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.4fb0850a617881b465a66140fdf06941777212ae.1526675940.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.4fb0850a617881b465a66140fdf06941777212ae.1526675940.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.4fb0850a617881b465a66140fdf06941777212ae.1526675940.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.4fb0850a617881b465a66140fdf06941777212ae.1526675940.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

The body write function relies on the code never asking it to write more
than the entries available in the list.

Currently with each list body containing 256 entries, this is fine, but
we can reduce this number greatly saving memory. In preparation of this
add a level of protection to catch any buffer overflows.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_dl.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
index 083da4f05c20..51965c30dec2 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.c
+++ b/drivers/media/platform/vsp1/vsp1_dl.c
@@ -46,6 +46,7 @@ struct vsp1_dl_entry {
  * @dma: DMA address of the entries
  * @size: size of the DMA memory in bytes
  * @num_entries: number of stored entries
+ * @max_entries: number of entries available
  */
 struct vsp1_dl_body {
 	struct list_head list;
@@ -56,6 +57,7 @@ struct vsp1_dl_body {
 	size_t size;
 
 	unsigned int num_entries;
+	unsigned int max_entries;
 };
 
 /**
@@ -138,6 +140,7 @@ static int vsp1_dl_body_init(struct vsp1_device *vsp1,
 
 	dlb->vsp1 = vsp1;
 	dlb->size = size;
+	dlb->max_entries = num_entries;
 
 	dlb->entries = dma_alloc_wc(vsp1->bus_master, dlb->size, &dlb->dma,
 				    GFP_KERNEL);
@@ -219,6 +222,10 @@ void vsp1_dl_body_free(struct vsp1_dl_body *dlb)
  */
 void vsp1_dl_body_write(struct vsp1_dl_body *dlb, u32 reg, u32 data)
 {
+	if (WARN_ONCE(dlb->num_entries >= dlb->max_entries,
+		      "DLB size exceeded (max %u)", dlb->max_entries))
+		return;
+
 	dlb->entries[dlb->num_entries].addr = reg;
 	dlb->entries[dlb->num_entries].data = data;
 	dlb->num_entries++;
-- 
git-series 0.9.1
