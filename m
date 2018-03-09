Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:39422 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932748AbeCIWES (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Mar 2018 17:04:18 -0500
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
Cc: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 05/11] media: vsp1: Clean up DLM objects on error
Date: Fri,  9 Mar 2018 22:04:03 +0000
Message-Id: <7f67954b2305c4807e4c19b9fec10fd7a6c60f16.1520632434.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.50cd35ac550b4477f13fb4f3fbd3ffb6bcccfc8a.1520632434.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.50cd35ac550b4477f13fb4f3fbd3ffb6bcccfc8a.1520632434.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.50cd35ac550b4477f13fb4f3fbd3ffb6bcccfc8a.1520632434.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.50cd35ac550b4477f13fb4f3fbd3ffb6bcccfc8a.1520632434.git-series.kieran.bingham+renesas@ideasonboard.com>
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
index 16a2d3c93655..6271bea5e831 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.c
+++ b/drivers/media/platform/vsp1/vsp1_dl.c
@@ -831,8 +831,10 @@ struct vsp1_dl_manager *vsp1_dlm_create(struct vsp1_device *vsp1,
 		struct vsp1_dl_list *dl;
 
 		dl = vsp1_dl_list_alloc(dlm, dlm->pool);
-		if (!dl)
+		if (!dl) {
+			vsp1_dlm_destroy(dlm);
 			return NULL;
+		}
 
 		list_add_tail(&dl->list, &dlm->free);
 	}
-- 
git-series 0.9.1
