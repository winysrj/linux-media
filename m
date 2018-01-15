Return-path: <linux-media-owner@vger.kernel.org>
Received: from o1678950229.outbound-mail.sendgrid.net ([167.89.50.229]:26535
        "EHLO o1678950229.outbound-mail.sendgrid.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S966133AbeAOQin (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 15 Jan 2018 11:38:43 -0500
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v5 2/9] v4l: vsp1: Protect bodies against overflow
Date: Mon, 15 Jan 2018 16:38:42 +0000 (UTC)
Message-Id: <c843f227e694a9e94c43b2f67cdef54cc186a0ad.1516028582.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.7c5bc67e9d7032daf8ea4d7bd18cf237c61676b4.1516028582.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.7c5bc67e9d7032daf8ea4d7bd18cf237c61676b4.1516028582.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.7c5bc67e9d7032daf8ea4d7bd18cf237c61676b4.1516028582.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.7c5bc67e9d7032daf8ea4d7bd18cf237c61676b4.1516028582.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The body write function relies on the code never asking it to write more
than the entries available in the list.

Currently with each list body containing 256 entries, this is fine, but
we can reduce this number greatly saving memory. In preparation of this
add a level of protection to catch any buffer overflows.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

---

v3:
 - adapt for new 'body' terminology
 - simplify WARN_ON macro usage
---
 drivers/media/platform/vsp1/vsp1_dl.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
index 90e972a75c62..ecc3659a7884 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.c
+++ b/drivers/media/platform/vsp1/vsp1_dl.c
@@ -50,6 +50,7 @@ struct vsp1_dl_entry {
  * @dma: DMA address of the entries
  * @size: size of the DMA memory in bytes
  * @num_entries: number of stored entries
+ * @max_entries: number of entries available
  */
 struct vsp1_dl_body {
 	struct list_head list;
@@ -60,6 +61,7 @@ struct vsp1_dl_body {
 	size_t size;
 
 	unsigned int num_entries;
+	unsigned int max_entries;
 };
 
 /**
@@ -139,6 +141,7 @@ static int vsp1_dl_body_init(struct vsp1_device *vsp1,
 
 	dlb->vsp1 = vsp1;
 	dlb->size = size;
+	dlb->max_entries = num_entries;
 
 	dlb->entries = dma_alloc_wc(vsp1->bus_master, dlb->size, &dlb->dma,
 				    GFP_KERNEL);
@@ -220,6 +223,10 @@ void vsp1_dl_body_free(struct vsp1_dl_body *dlb)
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
