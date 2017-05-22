Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934381AbdEVOT1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 May 2017 10:19:27 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, kieran.bingham@ideasonboard.com
Subject: [PATCH v3 1/5] v4l: rcar-fcp: Don't get/put module reference
Date: Mon, 22 May 2017 15:19:18 +0100
Message-Id: <3fed991d0f5e9690b9972f603256601d6a898bb0.1495461942.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.d1f5942e1a0b688b3527bb7998b184d3c0b0e9b1.1495461942.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.d1f5942e1a0b688b3527bb7998b184d3c0b0e9b1.1495461942.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.d1f5942e1a0b688b3527bb7998b184d3c0b0e9b1.1495461942.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.d1f5942e1a0b688b3527bb7998b184d3c0b0e9b1.1495461942.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Direct callers of the FCP API hold a reference to the FCP module due to
module linkage, there's no need to take another one manually. Take a
reference to the device instead to ensure that it won't disappear behind
the caller's back.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/platform/rcar-fcp.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/rcar-fcp.c b/drivers/media/platform/rcar-fcp.c
index 7146fc5ef168..e9f609edf513 100644
--- a/drivers/media/platform/rcar-fcp.c
+++ b/drivers/media/platform/rcar-fcp.c
@@ -53,14 +53,7 @@ struct rcar_fcp_device *rcar_fcp_get(const struct device_node *np)
 		if (fcp->dev->of_node != np)
 			continue;
 
-		/*
-		 * Make sure the module won't be unloaded behind our back. This
-		 * is a poor man's safety net, the module should really not be
-		 * unloaded while FCP users can be active.
-		 */
-		if (!try_module_get(fcp->dev->driver->owner))
-			fcp = NULL;
-
+		get_device(fcp->dev);
 		goto done;
 	}
 
@@ -81,7 +74,7 @@ EXPORT_SYMBOL_GPL(rcar_fcp_get);
 void rcar_fcp_put(struct rcar_fcp_device *fcp)
 {
 	if (fcp)
-		module_put(fcp->dev->driver->owner);
+		put_device(fcp->dev);
 }
 EXPORT_SYMBOL_GPL(rcar_fcp_put);
 
-- 
git-series 0.9.1
