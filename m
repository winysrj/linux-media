Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33246 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756284AbcE0RTb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 May 2016 13:19:31 -0400
Received: by mail-wm0-f66.google.com with SMTP id a136so268339wme.0
        for <linux-media@vger.kernel.org>; Fri, 27 May 2016 10:19:30 -0700 (PDT)
From: Kieran Bingham <kieran@ksquared.org.uk>
To: laurent.pinchart@ideasonboard.com,
	linux-renesas-soc@vger.kernel.org, kieran@ksquared.org.uk
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org
Subject: [PATCH 1/4] fcp: Extend FCP compatible list to support the FDP
Date: Fri, 27 May 2016 18:19:21 +0100
Message-Id: <1464369565-12259-2-git-send-email-kieran@bingham.xyz>
In-Reply-To: <1464369565-12259-1-git-send-email-kieran@bingham.xyz>
References: <1464369565-12259-1-git-send-email-kieran@bingham.xyz>
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
2.5.0

