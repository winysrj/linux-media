Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:49004 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758025Ab3GZMoh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jul 2013 08:44:37 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>, <kyungmin.park@samsung.com>,
	<balbi@ti.com>, <kishon@ti.com>, <jg1.han@samsung.com>,
	<s.nawrocki@samsung.com>, <kgene.kim@samsung.com>,
	<stern@rowland.harvard.edu>, <broonie@kernel.org>,
	<tomasz.figa@gmail.com>, <arnd@arndb.de>
CC: <grant.likely@linaro.org>, <tony@atomide.com>,
	<swarren@nvidia.com>, <devicetree-discuss@lists.ozlabs.org>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-samsung-soc@vger.kernel.org>, <linux-omap@vger.kernel.org>,
	<linux-usb@vger.kernel.org>, <linux-media@vger.kernel.org>,
	<linux-fbdev@vger.kernel.org>, <akpm@linux-foundation.org>,
	<balajitk@ti.com>, <george.cherian@ti.com>, <nsekhar@ti.com>
Subject: [PATCH v10 7/8] usb: phy: omap-usb2: remove *set_suspend* callback from omap-usb2
Date: Fri, 26 Jul 2013 18:13:01 +0530
Message-ID: <1374842582-13242-8-git-send-email-kishon@ti.com>
In-Reply-To: <1374842582-13242-1-git-send-email-kishon@ti.com>
References: <1374842582-13242-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that omap-usb2 is adapted to the new generic PHY framework,
*set_suspend* ops can be removed from omap-usb2 driver.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Acked-by: Felipe Balbi <balbi@ti.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/phy/phy-omap-usb2.c |   25 -------------------------
 1 file changed, 25 deletions(-)

diff --git a/drivers/phy/phy-omap-usb2.c b/drivers/phy/phy-omap-usb2.c
index 25e0f3c..dec3fab 100644
--- a/drivers/phy/phy-omap-usb2.c
+++ b/drivers/phy/phy-omap-usb2.c
@@ -97,29 +97,6 @@ static int omap_usb_set_peripheral(struct usb_otg *otg,
 	return 0;
 }
 
-static int omap_usb2_suspend(struct usb_phy *x, int suspend)
-{
-	u32 ret;
-	struct omap_usb *phy = phy_to_omapusb(x);
-
-	if (suspend && !phy->is_suspended) {
-		omap_control_usb_phy_power(phy->control_dev, 0);
-		pm_runtime_put_sync(phy->dev);
-		phy->is_suspended = 1;
-	} else if (!suspend && phy->is_suspended) {
-		ret = pm_runtime_get_sync(phy->dev);
-		if (ret < 0) {
-			dev_err(phy->dev, "get_sync failed with err %d\n",
-									ret);
-			return ret;
-		}
-		omap_control_usb_phy_power(phy->control_dev, 1);
-		phy->is_suspended = 0;
-	}
-
-	return 0;
-}
-
 static int omap_usb_power_off(struct phy *x)
 {
 	struct omap_usb *phy = phy_get_drvdata(x);
@@ -167,7 +144,6 @@ static int omap_usb2_probe(struct platform_device *pdev)
 
 	phy->phy.dev		= phy->dev;
 	phy->phy.label		= "omap-usb2";
-	phy->phy.set_suspend	= omap_usb2_suspend;
 	phy->phy.otg		= otg;
 	phy->phy.type		= USB_PHY_TYPE_USB2;
 
@@ -182,7 +158,6 @@ static int omap_usb2_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	phy->is_suspended	= 1;
 	omap_control_usb_phy_power(phy->control_dev, 0);
 
 	otg->set_host		= omap_usb_set_host;
-- 
1.7.10.4

