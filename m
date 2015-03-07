Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33311 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752910AbbCGVmT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Mar 2015 16:42:19 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, pali.rohar@gmail.com
Subject: [RFC 18/18] omap3isp: Deprecate platform data support
Date: Sat,  7 Mar 2015 23:41:15 +0200
Message-Id: <1425764475-27691-19-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1425764475-27691-1-git-send-email-sakari.ailus@iki.fi>
References: <1425764475-27691-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Print a warning when the driver is used with platform data. Existing
platform data user should move to DT now.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/platform/omap3isp/isp.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 2c9bc0d..e4a78bb 100644
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

