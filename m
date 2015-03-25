Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56402 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752540AbbCYW6k (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Mar 2015 18:58:40 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: linux-omap@vger.kernel.org, tony@atomide.com, sre@kernel.org,
	pali.rohar@gmail.com, laurent.pinchart@ideasonboard.com
Subject: [PATCH v2 15/15] omap3isp: Deprecate platform data support
Date: Thu, 26 Mar 2015 00:57:39 +0200
Message-Id: <1427324259-18438-16-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1427324259-18438-1-git-send-email-sakari.ailus@iki.fi>
References: <1427324259-18438-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Print a warning when the driver is used with platform data. Existing
platform data users should move to DT now.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/isp.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index e12484e..ff8f633 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2456,6 +2456,8 @@ static int isp_probe(struct platform_device *pdev)
 		isp->syscon = syscon_regmap_lookup_by_pdevname("syscon.0");
 		if (IS_ERR(isp->syscon))
 			return PTR_ERR(isp->syscon);
+		dev_warn(&pdev->dev,
+			 "Platform data support is deprecated! Please move to DT now!\n");
 	}
 
 	isp->autoidle = autoidle;
-- 
1.7.10.4

