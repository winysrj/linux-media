Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44484 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934767AbeB1Uwz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Feb 2018 15:52:55 -0500
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Cc: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v6 2/9] v4l: vsp1: Protect bodies against overflow
Date: Wed, 28 Feb 2018 20:52:36 +0000
Message-Id: <c7ad9d7cab7c3f088d27cc7ee1866e163949ff02.1519850924.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.d841c9354585c652c97473ace29c877b9395e83b.1519850924.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.d841c9354585c652c97473ace29c877b9395e83b.1519850924.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.d841c9354585c652c97473ace29c877b9395e83b.1519850924.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.d841c9354585c652c97473ace29c877b9395e83b.1519850924.git-series.kieran.bingham+renesas@ideasonboard.com>
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

 drivers/media/platform/vsp1/vsp1_dl.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
index 0c1bd17f9281..59fe80bf6e9d 100644
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
