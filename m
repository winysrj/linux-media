Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36829 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbcFIRGr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Jun 2016 13:06:47 -0400
Received: by mail-wm0-f65.google.com with SMTP id m124so12176279wme.3
        for <linux-media@vger.kernel.org>; Thu, 09 Jun 2016 10:06:46 -0700 (PDT)
From: Kieran Bingham <kieran@ksquared.org.uk>
To: laurent.pinchart@ideasonboard.com, mchehab@osg.samsung.com,
	linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
	Kieran Bingham <kieran@ksquared.org.uk>
Subject: [PATCH] v4l: Extend FCP compatible list to support the FDP
Date: Thu,  9 Jun 2016 18:06:43 +0100
Message-Id: <1465492003-1554-2-git-send-email-kieran@bingham.xyz>
In-Reply-To: <1465492003-1554-1-git-send-email-kieran@bingham.xyz>
References: <1465492003-1554-1-git-send-email-kieran@bingham.xyz>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The FCP must be powered up for the FDP1 to function, even when the FDP1
does not make use of the FCNL features. Extend the compatible list
to allow us to use the power domain and runtime-pm support.

Signed-off-by: Kieran Bingham <kieran@bingham.xyz>
---
 drivers/media/platform/rcar-fcp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/rcar-fcp.c b/drivers/media/platform/rcar-fcp.c
index 6a7bcc3028b1..0ff6b1edf1db 100644
--- a/drivers/media/platform/rcar-fcp.c
+++ b/drivers/media/platform/rcar-fcp.c
@@ -160,6 +160,7 @@ static int rcar_fcp_remove(struct platform_device *pdev)
 
 static const struct of_device_id rcar_fcp_of_match[] = {
 	{ .compatible = "renesas,fcpv" },
+	{ .compatible = "renesas,fcpf" },
 	{ },
 };
 
-- 
2.7.4

