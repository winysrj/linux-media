Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:50436 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727473AbeHCNdf (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Aug 2018 09:33:35 -0400
From: Kieran Bingham <kieran@ksquared.org.uk>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v6 05/11] media: vsp1: Clean up DLM objects on error
Date: Fri,  3 Aug 2018 12:37:24 +0100
Message-Id: <d6ca9ca60384cba0f021727a9bf2bcf145c55e4d.1533295631.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.7e4241408f077710d96e0cc06e039d1022fb0c8c.1533295631.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.7e4241408f077710d96e0cc06e039d1022fb0c8c.1533295631.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.7e4241408f077710d96e0cc06e039d1022fb0c8c.1533295631.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.7e4241408f077710d96e0cc06e039d1022fb0c8c.1533295631.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

If there is an error allocating a display list within a DLM object
the existing display lists are not free'd, and neither is the DL body
pool.

Use the existing vsp1_dlm_destroy() function to clean up on error.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_dl.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
index 199843a73df1..64e5b25d1123 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.c
+++ b/drivers/media/platform/vsp1/vsp1_dl.c
@@ -858,8 +858,10 @@ struct vsp1_dl_manager *vsp1_dlm_create(struct vsp1_device *vsp1,
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
