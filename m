Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:59476 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751277AbeECIoa (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 3 May 2018 04:44:30 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Cc: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v3 03/11] media: vsp1: Rename dl_child to dl_next
Date: Thu,  3 May 2018 09:44:14 +0100
Message-Id: <84f92b0a7131bcb182a571c98f7065d4972b4953.1525336865.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.a15c17beeb074afaf226d19ff3c4fdba2f647500.1525336865.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.a15c17beeb074afaf226d19ff3c4fdba2f647500.1525336865.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.a15c17beeb074afaf226d19ff3c4fdba2f647500.1525336865.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.a15c17beeb074afaf226d19ff3c4fdba2f647500.1525336865.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Both vsp1_dl_list_commit() and __vsp1_dl_list_put() walk the display
list chain referencing the nodes as children, when in reality they are
siblings.

Update the terminology to 'dl_next' to be consistent with the
vsp1_video_pipeline_run() usage.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_dl.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
index b6288ead24ae..09c29a4ed118 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.c
+++ b/drivers/media/platform/vsp1/vsp1_dl.c
@@ -398,7 +398,7 @@ struct vsp1_dl_list *vsp1_dl_list_get(struct vsp1_dl_manager *dlm)
 /* This function must be called with the display list manager lock held.*/
 static void __vsp1_dl_list_put(struct vsp1_dl_list *dl)
 {
-	struct vsp1_dl_list *dl_child;
+	struct vsp1_dl_list *dl_next;
 
 	if (!dl)
 		return;
@@ -408,8 +408,8 @@ static void __vsp1_dl_list_put(struct vsp1_dl_list *dl)
 	 * hardware operation.
 	 */
 	if (dl->has_chain) {
-		list_for_each_entry(dl_child, &dl->chain, chain)
-			__vsp1_dl_list_put(dl_child);
+		list_for_each_entry(dl_next, &dl->chain, chain)
+			__vsp1_dl_list_put(dl_next);
 	}
 
 	dl->has_chain = false;
@@ -673,17 +673,17 @@ static void vsp1_dl_list_commit_singleshot(struct vsp1_dl_list *dl)
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
