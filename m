Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:58011 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753308AbcIIL6l (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Sep 2016 07:58:41 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran+renesas@ksquared.org.uk>
Subject: [PATCH] v4l: rcar-fcp: Extend compatible list to support the FDP
Date: Fri,  9 Sep 2016 14:59:08 +0300
Message-Id: <1473422348-24268-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran+renesas@bingham.xyz>

The FCP must be powered up for the FDP1 to function, even when the FDP1
does not make use of the FCNL features. Extend the compatible list
to allow us to use the power domain and runtime-pm support.

Signed-off-by: Kieran Bingham <kieran+renesas@bingham.xyz>
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/rcar-fcp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/rcar-fcp.c b/drivers/media/platform/rcar-fcp.c
index f7bcbf7677a0..f3a3f31cdfa9 100644
--- a/drivers/media/platform/rcar-fcp.c
+++ b/drivers/media/platform/rcar-fcp.c
@@ -165,6 +165,7 @@ static int rcar_fcp_remove(struct platform_device *pdev)
 }
 
 static const struct of_device_id rcar_fcp_of_match[] = {
+	{ .compatible = "renesas,fcpf" },
 	{ .compatible = "renesas,fcpv" },
 	{ },
 };
-- 
Regards,

Laurent Pinchart

