Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51092 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755042AbcHSIj3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Aug 2016 04:39:29 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 3/6] v4l: rcar-fcp: Don't get/put module reference
Date: Fri, 19 Aug 2016 11:39:31 +0300
Message-Id: <1471595974-28960-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1471595974-28960-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1471595974-28960-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Direct callers of the FCP API hold a reference to the FCP module due to
module linkage, there's no need to take another one manually. Take a
reference to the device instead to ensure that it won't disappear being
the caller's back.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/rcar-fcp.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/rcar-fcp.c b/drivers/media/platform/rcar-fcp.c
index f7bcbf7677a0..7427be1c3741 100644
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
Regards,

Laurent Pinchart

