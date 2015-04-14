Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-by2on0106.outbound.protection.outlook.com ([207.46.100.106]:32517
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933086AbbDNSWE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Apr 2015 14:22:04 -0400
From: Fabio Estevam <fabio.estevam@freescale.com>
To: <mchehab@osg.samsung.com>
CC: <linux-media@vger.kernel.org>,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] [media] ir-hix5hd2: Fix build warning
Date: Tue, 14 Apr 2015 15:21:39 -0300
Message-ID: <1429035699-7718-1-git-send-email-fabio.estevam@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Building for avr32 leads the following build warning:

drivers/media/rc/ir-hix5hd2.c:221: warning: passing argument 1 of 'IS_ERR' discards qualifiers from pointer target type
drivers/media/rc/ir-hix5hd2.c:222: warning: passing argument 1 of 'PTR_ERR' discards qualifiers from pointer target type

devm_ioremap_resource() returns void __iomem *, so change 'base' definition 
accordingly.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/media/rc/ir-hix5hd2.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/rc/ir-hix5hd2.c b/drivers/media/rc/ir-hix5hd2.c
index 58ec598..3385148 100644
--- a/drivers/media/rc/ir-hix5hd2.c
+++ b/drivers/media/rc/ir-hix5hd2.c
@@ -63,7 +63,7 @@
 
 struct hix5hd2_ir_priv {
 	int			irq;
-	void volatile __iomem	*base;
+	void __iomem		*base;
 	struct device		*dev;
 	struct rc_dev		*rdev;
 	struct regmap		*regmap;
@@ -213,8 +213,8 @@ static int hix5hd2_ir_probe(struct platform_device *pdev)
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	priv->base = devm_ioremap_resource(dev, res);
-	if (IS_ERR((__force void *)priv->base))
-		return PTR_ERR((__force void *)priv->base);
+	if (IS_ERR(priv->base))
+		return PTR_ERR(priv->base);
 
 	priv->irq = platform_get_irq(pdev, 0);
 	if (priv->irq < 0) {
-- 
1.9.1

