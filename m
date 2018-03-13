Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:41740 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752964AbeCMSFl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Mar 2018 14:05:41 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-renesas-soc@vger.kernel.org
Cc: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 03/11] media: vsp1: Rename dl_child to dl_next
Date: Tue, 13 Mar 2018 19:05:19 +0100
Message-Id: <ab0f861d4eb5fc4044d2b830a30943485754626a.1520963956.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.89a4a5175efbf31441ba717a99b0e3c31088179f.1520963956.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.89a4a5175efbf31441ba717a99b0e3c31088179f.1520963956.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.89a4a5175efbf31441ba717a99b0e3c31088179f.1520963956.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.89a4a5175efbf31441ba717a99b0e3c31088179f.1520963956.git-series.kieran.bingham+renesas@ideasonboard.com>
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
index 85795b55a357..8162f4ce66eb 100644
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
