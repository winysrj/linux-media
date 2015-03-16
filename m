Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45080 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752357AbbCPA07 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2015 20:26:59 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: linux-omap@vger.kernel.org, tony@atomide.com, sre@kernel.org,
	pali.rohar@gmail.com, laurent.pinchart@ideasonboard.com
Subject: [PATCH 07/15] omap3isp: Rename regulators to better suit the Device Tree
Date: Mon, 16 Mar 2015 02:26:02 +0200
Message-Id: <1426465570-30295-8-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1426465570-30295-1-git-send-email-sakari.ailus@iki.fi>
References: <1426465570-30295-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rename VDD_CSIPHY1 as vdd-csiphy1 and VDD_CSIPHY2 as vdd-csiphy2.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/isp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 1b5c6df..c045318 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2292,8 +2292,8 @@ static int isp_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, isp);
 
 	/* Regulators */
-	isp->isp_csiphy1.vdd = devm_regulator_get(&pdev->dev, "VDD_CSIPHY1");
-	isp->isp_csiphy2.vdd = devm_regulator_get(&pdev->dev, "VDD_CSIPHY2");
+	isp->isp_csiphy1.vdd = devm_regulator_get(&pdev->dev, "vdd-csiphy1");
+	isp->isp_csiphy2.vdd = devm_regulator_get(&pdev->dev, "vdd-csiphy2");
 
 	/* Clocks
 	 *
-- 
1.7.10.4

