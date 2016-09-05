Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:43977 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755301AbcIEJBM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Sep 2016 05:01:12 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Geert Uytterhoeven <geert@glider.be>,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH] v4l: rcar-fcp: Keep the coding style consistent
Date: Mon,  5 Sep 2016 12:01:30 +0300
Message-Id: <1473066090-19951-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Renesas multimedia drivers use ret to store return values, fix the
only exception in the rcar-fcp driver to keep the coding style
consistent.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/rcar-fcp.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/rcar-fcp.c b/drivers/media/platform/rcar-fcp.c
index bc50c69ee0c5..f7bcbf7677a0 100644
--- a/drivers/media/platform/rcar-fcp.c
+++ b/drivers/media/platform/rcar-fcp.c
@@ -99,14 +99,14 @@ EXPORT_SYMBOL_GPL(rcar_fcp_put);
  */
 int rcar_fcp_enable(struct rcar_fcp_device *fcp)
 {
-	int error;
+	int ret;
 
 	if (!fcp)
 		return 0;
 
-	error = pm_runtime_get_sync(fcp->dev);
-	if (error < 0)
-		return error;
+	ret = pm_runtime_get_sync(fcp->dev);
+	if (ret < 0)
+		return ret;
 
 	return 0;
 }
-- 
Regards,

Laurent Pinchart

