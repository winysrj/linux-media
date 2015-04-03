Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:33804 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878AbbDCRNe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Apr 2015 13:13:34 -0400
In-Reply-To: <20150403171149.GC13898@n2100.arm.linux.org.uk>
References: <20150403171149.GC13898@n2100.arm.linux.org.uk>
From: Russell King <rmk+kernel@arm.linux.org.uk>
To: alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-sh@vger.kernel.org
Cc: Tony Lindgren <tony@atomide.com>
Subject: [PATCH 12/14] ARM: omap2: use clkdev_add_alias()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1Ye59o-0001Bh-3u@rmk-PC.arm.linux.org.uk>
Date: Fri, 03 Apr 2015 18:13:24 +0100
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When creating aliases of existing clkdev clocks, use clkdev_add_alias()
isntead of open coding the lookup and clk_lookup creation.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 arch/arm/mach-omap2/omap_device.c | 24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_device.c b/arch/arm/mach-omap2/omap_device.c
index be9541e18650..521c32e7778e 100644
--- a/arch/arm/mach-omap2/omap_device.c
+++ b/arch/arm/mach-omap2/omap_device.c
@@ -47,7 +47,7 @@ static void _add_clkdev(struct omap_device *od, const char *clk_alias,
 		       const char *clk_name)
 {
 	struct clk *r;
-	struct clk_lookup *l;
+	int rc;
 
 	if (!clk_alias || !clk_name)
 		return;
@@ -62,21 +62,15 @@ static void _add_clkdev(struct omap_device *od, const char *clk_alias,
 		return;
 	}
 
-	r = clk_get(NULL, clk_name);
-	if (IS_ERR(r)) {
-		dev_err(&od->pdev->dev,
-			"clk_get for %s failed\n", clk_name);
-		return;
+	rc = clk_add_alias(clk_alias, dev_name(&od->pdev->dev), clk_name, NULL);
+	if (rc) {
+		if (rc == -ENODEV || rc == -ENOMEM)
+			dev_err(&od->pdev->dev,
+				"clkdev_alloc for %s failed\n", clk_alias);
+		else
+			dev_err(&od->pdev->dev,
+				"clk_get for %s failed\n", clk_name);
 	}
-
-	l = clkdev_alloc(r, clk_alias, dev_name(&od->pdev->dev));
-	if (!l) {
-		dev_err(&od->pdev->dev,
-			"clkdev_alloc for %s failed\n", clk_alias);
-		return;
-	}
-
-	clkdev_add(l);
 }
 
 /**
-- 
1.8.3.1

