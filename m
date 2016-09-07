Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:54028 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751166AbcIGWYp (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Sep 2016 18:24:45 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran@ksquared.org.uk>
Subject: [PATCH v3 03/10] v4l: Extend FCP compatible list to support the FDP
Date: Thu,  8 Sep 2016 01:25:03 +0300
Message-Id: <1473287110-780-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1473287110-780-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1473287110-780-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran@ksquared.org.uk>

The FCP must be powered up for the FDP1 to function, even when the FDP1
does not make use of the FCNL features. Extend the compatible list
to allow us to use the power domain and runtime-pm support.

Signed-off-by: Kieran Bingham <kieran@bingham.xyz>
Acked-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/rcar-fcp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/rcar-fcp.c b/drivers/media/platform/rcar-fcp.c
index bc50c69ee0c5..7e944479205d 100644
--- a/drivers/media/platform/rcar-fcp.c
+++ b/drivers/media/platform/rcar-fcp.c
@@ -166,6 +166,7 @@ static int rcar_fcp_remove(struct platform_device *pdev)
 
 static const struct of_device_id rcar_fcp_of_match[] = {
 	{ .compatible = "renesas,fcpv" },
+	{ .compatible = "renesas,fcpf" },
 	{ },
 };
 
-- 
Regards,

Laurent Pinchart

