Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:48364 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755278AbeEAMt3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 1 May 2018 08:49:29 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
Cc: mchehab@kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v8 2/8] media: vsp1: Protect bodies against overflow
Date: Tue,  1 May 2018 13:49:14 +0100
Message-Id: <23f4f857e2e311f2948f6794f793c018e3e62062.1525178613.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.bc315239d58449d3e395904b87af6c747a9f612c.1525178613.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.bc315239d58449d3e395904b87af6c747a9f612c.1525178613.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.bc315239d58449d3e395904b87af6c747a9f612c.1525178613.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.bc315239d58449d3e395904b87af6c747a9f612c.1525178613.git-series.kieran.bingham+renesas@ideasonboard.com>
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
