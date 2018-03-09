Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:39422 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932699AbeCIWER (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Mar 2018 17:04:17 -0500
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
Cc: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 03/11] media: vsp1: Rename dl_child to dl_next
Date: Fri,  9 Mar 2018 22:04:01 +0000
Message-Id: <1ea56c7da943673569811579d823b489d4ae291e.1520632434.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.50cd35ac550b4477f13fb4f3fbd3ffb6bcccfc8a.1520632434.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.50cd35ac550b4477f13fb4f3fbd3ffb6bcccfc8a.1520632434.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.50cd35ac550b4477f13fb4f3fbd3ffb6bcccfc8a.1520632434.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.50cd35ac550b4477f13fb4f3fbd3ffb6bcccfc8a.1520632434.git-series.kieran.bingham+renesas@ideasonboard.com>
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
index 382e45c2054e..057f0f093222 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.c
+++ b/drivers/media/platform/vsp1/vsp1_dl.c
@@ -400,7 +400,7 @@ struct vsp1_dl_list *vsp1_dl_list_get(struct vsp1_dl_manager *dlm)
 /* This function must be called with the display list manager lock held.*/
 static void __vsp1_dl_list_put(struct vsp1_dl_list *dl)
 {
-	struct vsp1_dl_list *dl_child;
+	struct vsp1_dl_list *dl_next;
 
 	if (!dl)
 		return;
@@ -410,8 +410,8 @@ static void __vsp1_dl_list_put(struct vsp1_dl_list *dl)
 	 * hardware operation.
 	 */
 	if (dl->has_chain) {
-		list_for_each_entry(dl_child, &dl->chain, chain)
-			__vsp1_dl_list_put(dl_child);
+		list_for_each_entry(dl_next, &dl->chain, chain)
+			__vsp1_dl_list_put(dl_next);
 	}
 
 	dl->has_chain = false;
@@ -667,17 +667,17 @@ static void vsp1_dl_list_commit_singleshot(struct vsp1_dl_list *dl)
 void vsp1_dl_list_commit(struct vsp1_dl_list *dl)
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
