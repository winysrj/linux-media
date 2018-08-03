Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:50436 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727193AbeHCNde (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Aug 2018 09:33:34 -0400
From: Kieran Bingham <kieran@ksquared.org.uk>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v6 03/11] media: vsp1: Rename dl_child to dl_next
Date: Fri,  3 Aug 2018 12:37:22 +0100
Message-Id: <0444a36cb182f268eb7dfadd8ccab626cf033850.1533295631.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.7e4241408f077710d96e0cc06e039d1022fb0c8c.1533295631.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.7e4241408f077710d96e0cc06e039d1022fb0c8c.1533295631.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.7e4241408f077710d96e0cc06e039d1022fb0c8c.1533295631.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.7e4241408f077710d96e0cc06e039d1022fb0c8c.1533295631.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

Both vsp1_dl_list_commit() and __vsp1_dl_list_put() walk the display
list chain referencing the nodes as children, when in reality they are
siblings.

Update the terminology to 'dl_next' to be consistent with the
vsp1_video_pipeline_run() usage.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_dl.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
index e4aae334f047..202bc0c6e484 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.c
+++ b/drivers/media/platform/vsp1/vsp1_dl.c
@@ -399,7 +399,7 @@ struct vsp1_dl_list *vsp1_dl_list_get(struct vsp1_dl_manager *dlm)
 /* This function must be called with the display list manager lock held.*/
 static void __vsp1_dl_list_put(struct vsp1_dl_list *dl)
 {
-	struct vsp1_dl_list *dl_child;
+	struct vsp1_dl_list *dl_next;
 
 	if (!dl)
 		return;
@@ -409,8 +409,8 @@ static void __vsp1_dl_list_put(struct vsp1_dl_list *dl)
 	 * hardware operation.
 	 */
 	if (dl->has_chain) {
-		list_for_each_entry(dl_child, &dl->chain, chain)
-			__vsp1_dl_list_put(dl_child);
+		list_for_each_entry(dl_next, &dl->chain, chain)
+			__vsp1_dl_list_put(dl_next);
 	}
 
 	dl->has_chain = false;
@@ -674,17 +674,17 @@ static void vsp1_dl_list_commit_singleshot(struct vsp1_dl_list *dl)
 void vsp1_dl_list_commit(struct vsp1_dl_list *dl, bool internal)
 {
 	struct vsp1_dl_manager *dlm = dl->dlm;
-	struct vsp1_dl_list *dl_child;
+	struct vsp1_dl_list *dl_next;
 	unsigned long flags;
 
 	if (dlm->mode == VSP1_DL_MODE_HEADER) {
 		/* Fill the header for the head and chained display lists. */
 		vsp1_dl_list_fill_header(dl, list_empty(&dl->chain));
 
-		list_for_each_entry(dl_child, &dl->chain, chain) {
-			bool last = list_is_last(&dl_child->chain, &dl->chain);
+		list_for_each_entry(dl_next, &dl->chain, chain) {
+			bool last = list_is_last(&dl_next->chain, &dl->chain);
 
-			vsp1_dl_list_fill_header(dl_child, last);
+			vsp1_dl_list_fill_header(dl_next, last);
 		}
 	}
 
-- 
git-series 0.9.1
