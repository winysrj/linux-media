Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45080 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752579AbbCPA1A (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2015 20:27:00 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: linux-omap@vger.kernel.org, tony@atomide.com, sre@kernel.org,
	pali.rohar@gmail.com, laurent.pinchart@ideasonboard.com
Subject: [PATCH 15/15] omap3isp: Deprecate platform data support
Date: Mon, 16 Mar 2015 02:26:10 +0200
Message-Id: <1426465570-30295-16-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1426465570-30295-1-git-send-email-sakari.ailus@iki.fi>
References: <1426465570-30295-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Print a warning when the driver is used with platform data. Existing
platform data user should move to DT now.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/platform/omap3isp/isp.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 0d6012a..82940fe 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2447,6 +2447,8 @@ static int isp_probe(struct platform_device *pdev)
 		isp->syscon = syscon_regmap_lookup_by_pdevname("syscon.0");
 		if (IS_ERR(isp->syscon))
 			return PTR_ERR(isp->syscon);
+		dev_warn(&pdev->dev,
+			 "Platform data support is deprecated! Please move to DT now!\n");
 	}
 
 	isp->autoidle = autoidle;
-- 
1.7.10.4

