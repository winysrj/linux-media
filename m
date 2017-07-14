Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753510AbdGNQOV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Jul 2017 12:14:21 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH 1/6] v4l: vsp1: Protect fragments against overflow
Date: Fri, 14 Jul 2017 17:14:10 +0100
Message-Id: <950a1680506ee05bbe0b974d10c938a4e5e2acd0.1500047489.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.6756808fb978882ae2db0cde7745c7e12b177713.1500047489.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.6756808fb978882ae2db0cde7745c7e12b177713.1500047489.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.6756808fb978882ae2db0cde7745c7e12b177713.1500047489.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.6756808fb978882ae2db0cde7745c7e12b177713.1500047489.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The fragment write function relies on the code never asking it to
write more than the entries available in the list.

Currently with each list body containing 256 entries, this is fine,
but we can reduce this number greatly saving memory.

In preparation of this - add a level of protection to catch any
buffer overflows

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_dl.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
index 8b5cbb6b7a70..1311e7cf2733 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.c
+++ b/drivers/media/platform/vsp1/vsp1_dl.c
@@ -60,6 +60,7 @@ struct vsp1_dl_body {
 	size_t size;
 
 	unsigned int num_entries;
+	unsigned int max_entries;
 };
 
 /**
@@ -138,6 +139,7 @@ static int vsp1_dl_body_init(struct vsp1_device *vsp1,
 
 	dlb->vsp1 = vsp1;
 	dlb->size = size;
+	dlb->max_entries = num_entries;
 
 	dlb->entries = dma_alloc_wc(vsp1->bus_master, dlb->size, &dlb->dma,
 				    GFP_KERNEL);
@@ -220,6 +222,11 @@ void vsp1_dl_fragment_free(struct vsp1_dl_body *dlb)
  */
 void vsp1_dl_fragment_write(struct vsp1_dl_body *dlb, u32 reg, u32 data)
 {
+	if (unlikely(dlb->num_entries >= dlb->max_entries)) {
+		WARN_ONCE(true, "DLB size exceeded");
+		return;
+	}
+
 	dlb->entries[dlb->num_entries].addr = reg;
 	dlb->entries[dlb->num_entries].data = data;
 	dlb->num_entries++;
-- 
git-series 0.9.1
