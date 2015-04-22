Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:45959 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932695AbbDVXDx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Apr 2015 19:03:53 -0400
From: Arun Ramamurthy <arun.ramamurthy@broadcom.com>
To: Jonathan Corbet <corbet@lwn.net>, Tejun Heo <tj@kernel.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Kishon Vijay Abraham I <kishon@ti.com>,
	"Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Tony Prisk <linux@prisktech.co.nz>,
	Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Arnd Bergmann <arnd@arndb.de>, Felipe Balbi <balbi@ti.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Paul Bolle <pebolle@tiscali.nl>,
	Thomas Pugliese <thomas.pugliese@gmail.com>,
	"Srinivas Kandagatla" <srinivas.kandagatla@linaro.org>,
	Masanari Iida <standby24x7@gmail.com>,
	David Mosberger <davidm@egauge.net>,
	Peter Griffin <peter.griffin@linaro.org>,
	Gregory CLEMENT <gregory.clement@free-electrons.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Kevin Hao <haokexin@gmail.com>,
	"Jean Delvare" <jdelvare@suse.de>
CC: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-ide@vger.kernel.org>, <linux-media@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-samsung-soc@vger.kernel.org>, <linux-usb@vger.kernel.org>,
	<linux-fbdev@vger.kernel.org>, Dmitry Torokhov <dtor@google.com>,
	Anatol Pomazau <anatol@google.com>,
	Jonathan Richardson <jonathar@broadcom.com>,
	Scott Branden <sbranden@broadcom.com>,
	Ray Jui <rjui@broadcom.com>,
	<bcm-kernel-feedback-list@broadcom.com>,
	Arun Ramamurthy <arun.ramamurthy@broadcom.com>
Subject: [PATCHv3 4/4] usb: ohci-platform: Use devm_of_phy_get_by_index
Date: Wed, 22 Apr 2015 16:04:13 -0700
Message-ID: <1429743853-10254-5-git-send-email-arun.ramamurthy@broadcom.com>
In-Reply-To: <1429743853-10254-1-git-send-email-arun.ramamurthy@broadcom.com>
References: <1429743853-10254-1-git-send-email-arun.ramamurthy@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Getting phys by index instead of phy names so that we do
not have to create a naming scheme when multiple phys are present

Signed-off-by: Arun Ramamurthy <arun.ramamurthy@broadcom.com>
Reviewed-by: Ray Jui <rjui@broadcom.com>
Reviewed-by: Scott Branden <sbranden@broadcom.com>
---
 drivers/usb/host/ohci-platform.c | 69 ++++++++++++++--------------------------
 1 file changed, 24 insertions(+), 45 deletions(-)

diff --git a/drivers/usb/host/ohci-platform.c b/drivers/usb/host/ohci-platform.c
index 185ceee..c2669f18 100644
--- a/drivers/usb/host/ohci-platform.c
+++ b/drivers/usb/host/ohci-platform.c
@@ -57,15 +57,13 @@ static int ohci_platform_power_on(struct platform_device *dev)
 	}
 
 	for (phy_num = 0; phy_num < priv->num_phys; phy_num++) {
-		if (priv->phys[phy_num]) {
-			ret = phy_init(priv->phys[phy_num]);
-			if (ret)
-				goto err_exit_phy;
-			ret = phy_power_on(priv->phys[phy_num]);
-			if (ret) {
-				phy_exit(priv->phys[phy_num]);
-				goto err_exit_phy;
-			}
+		ret = phy_init(priv->phys[phy_num]);
+		if (ret)
+			goto err_exit_phy;
+		ret = phy_power_on(priv->phys[phy_num]);
+		if (ret) {
+			phy_exit(priv->phys[phy_num]);
+			goto err_exit_phy;
 		}
 	}
 
@@ -73,10 +71,8 @@ static int ohci_platform_power_on(struct platform_device *dev)
 
 err_exit_phy:
 	while (--phy_num >= 0) {
-		if (priv->phys[phy_num]) {
-			phy_power_off(priv->phys[phy_num]);
-			phy_exit(priv->phys[phy_num]);
-		}
+		phy_power_off(priv->phys[phy_num]);
+		phy_exit(priv->phys[phy_num]);
 	}
 err_disable_clks:
 	while (--clk >= 0)
@@ -92,10 +88,8 @@ static void ohci_platform_power_off(struct platform_device *dev)
 	int clk, phy_num;
 
 	for (phy_num = 0; phy_num < priv->num_phys; phy_num++) {
-		if (priv->phys[phy_num]) {
-			phy_power_off(priv->phys[phy_num]);
-			phy_exit(priv->phys[phy_num]);
-		}
+		phy_power_off(priv->phys[phy_num]);
+		phy_exit(priv->phys[phy_num]);
 	}
 
 	for (clk = OHCI_MAX_CLKS - 1; clk >= 0; clk--)
@@ -123,7 +117,6 @@ static int ohci_platform_probe(struct platform_device *dev)
 	struct usb_ohci_pdata *pdata = dev_get_platdata(&dev->dev);
 	struct ohci_platform_priv *priv;
 	struct ohci_hcd *ohci;
-	const char *phy_name;
 	int err, irq, phy_num, clk = 0;
 
 	if (usb_disabled())
@@ -174,36 +167,22 @@ static int ohci_platform_probe(struct platform_device *dev)
 
 		priv->num_phys = of_count_phandle_with_args(dev->dev.of_node,
 				"phys", "#phy-cells");
-		priv->num_phys = priv->num_phys > 0 ? priv->num_phys : 1;
 
-		priv->phys = devm_kcalloc(&dev->dev, priv->num_phys,
-				sizeof(struct phy *), GFP_KERNEL);
-		if (!priv->phys)
-			return -ENOMEM;
+		if (priv->num_phys > 0) {
+			priv->phys = devm_kcalloc(&dev->dev, priv->num_phys,
+					    sizeof(struct phy *), GFP_KERNEL);
+			if (!priv->phys)
+				return -ENOMEM;
+		} else
+			priv->num_phys = 0;
 
 		for (phy_num = 0; phy_num < priv->num_phys; phy_num++) {
-				err = of_property_read_string_index(
-						dev->dev.of_node,
-						"phy-names", phy_num,
-						&phy_name);
-
-				if (err < 0) {
-					if (priv->num_phys > 1) {
-						dev_err(&dev->dev, "phy-names not provided");
-						goto err_put_hcd;
-					} else
-						phy_name = "usb";
-				}
-
-				priv->phys[phy_num] = devm_phy_get(&dev->dev,
-						phy_name);
-				if (IS_ERR(priv->phys[phy_num])) {
-					err = PTR_ERR(priv->phys[phy_num]);
-					if ((priv->num_phys > 1) ||
-					    (err == -EPROBE_DEFER))
-						goto err_put_hcd;
-					priv->phys[phy_num] = NULL;
-				}
+			priv->phys[phy_num] = devm_of_phy_get_by_index(
+					&dev->dev, dev->dev.of_node, phy_num);
+			if (IS_ERR(priv->phys[phy_num])) {
+				err = PTR_ERR(priv->phys[phy_num]);
+				goto err_put_hcd;
+			}
 		}
 
 		for (clk = 0; clk < OHCI_MAX_CLKS; clk++) {
-- 
2.3.4

