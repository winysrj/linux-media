Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:34892 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751544AbeECNgb (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 3 May 2018 09:36:31 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v4 05/11] media: vsp1: Clean up DLM objects on error
Date: Thu,  3 May 2018 14:36:16 +0100
Message-Id: <b7cebaf1f970e25e32a211c4a352baaa7e026fc6.1525354194.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.bd2eb66d11f8094114941107dbc78dc02c9c7fdd.1525354194.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.bd2eb66d11f8094114941107dbc78dc02c9c7fdd.1525354194.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.bd2eb66d11f8094114941107dbc78dc02c9c7fdd.1525354194.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.bd2eb66d11f8094114941107dbc78dc02c9c7fdd.1525354194.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If there is an error allocating a display list within a DLM object
the existing display lists are not free'd, and neither is the DL body
pool.

Use the existing vsp1_dlm_destroy() function to clean up on error.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_dl.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
index b23e88cda49f..fbffbd407b29 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.c
+++ b/drivers/media/platform/vsp1/vsp1_dl.c
@@ -851,8 +851,10 @@ struct vsp1_dl_manager *vsp1_dlm_create(struct vsp1_device *vsp1,
 		struct vsp1_dl_list *dl;
 
 		dl = vsp1_dl_list_alloc(dlm);
-		if (!dl)
+		if (!dl) {
+			vsp1_dlm_destroy(dlm);
 			return NULL;
+		}
 
 		list_add_tail(&dl->list, &dlm->free);
 	}
-- 
git-series 0.9.1
