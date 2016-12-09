Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34181 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933423AbcLIMfX (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Dec 2016 07:35:23 -0500
From: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
To: linux-renesas-soc@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org, magnus.damm@gmail.com,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: [PATCH v1.5 1/6] v4l: rcar-fcp: Don't get/put module reference
Date: Fri,  9 Dec 2016 13:35:07 +0100
Message-Id: <1481286912-16555-2-git-send-email-ulrich.hecht+renesas@gmail.com>
In-Reply-To: <1481286912-16555-1-git-send-email-ulrich.hecht+renesas@gmail.com>
References: <1481286912-16555-1-git-send-email-ulrich.hecht+renesas@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Direct callers of the FCP API hold a reference to the FCP module due to
module linkage, there's no need to take another one manually. Take a
reference to the device instead to ensure that it won't disappear behind
the caller's back.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/rcar-fcp.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/rcar-fcp.c b/drivers/media/platform/rcar-fcp.c
index 7146fc5..e9f609e 100644
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
2.7.4

