Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34127 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbaIXW1y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Sep 2014 18:27:54 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Guoxiong Yan <yanguoxiong@huawei.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH 01/18] [media] ir-hix5hd2: fix address space casting
Date: Wed, 24 Sep 2014 19:27:01 -0300
Message-Id: <c8634fac0c56cfaa9bdad29d541e95b17c049c0a.1411597610.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/rc/ir-hix5hd2.c:99:41: warning: incorrect type in argument 2 (different address spaces)
drivers/media/rc/ir-hix5hd2.c:99:41:    expected void volatile [noderef] <asn:2>*addr
drivers/media/rc/ir-hix5hd2.c:99:41:    got void *
drivers/media/rc/ir-hix5hd2.c:100:16: warning: incorrect type in argument 1 (different address spaces)
drivers/media/rc/ir-hix5hd2.c:100:16:    expected void const volatile [noderef] <asn:2>*addr
drivers/media/rc/ir-hix5hd2.c:100:16:    got void *
drivers/media/rc/ir-hix5hd2.c:117:40: warning: incorrect type in argument 2 (different address spaces)
drivers/media/rc/ir-hix5hd2.c:117:40:    expected void volatile [noderef] <asn:2>*addr
drivers/media/rc/ir-hix5hd2.c:117:40:    got void *
drivers/media/rc/ir-hix5hd2.c:119:41: warning: incorrect type in argument 2 (different address spaces)
drivers/media/rc/ir-hix5hd2.c:119:41:    expected void volatile [noderef] <asn:2>*addr
drivers/media/rc/ir-hix5hd2.c:119:41:    got void *
drivers/media/rc/ir-hix5hd2.c:121:41: warning: incorrect type in argument 2 (different address spaces)
drivers/media/rc/ir-hix5hd2.c:121:41:    expected void volatile [noderef] <asn:2>*addr
drivers/media/rc/ir-hix5hd2.c:121:41:    got void *
drivers/media/rc/ir-hix5hd2.c:147:18: warning: incorrect type in argument 1 (different address spaces)
drivers/media/rc/ir-hix5hd2.c:147:18:    expected void const volatile [noderef] <asn:2>*addr
drivers/media/rc/ir-hix5hd2.c:147:18:    got void *
drivers/media/rc/ir-hix5hd2.c:155:28: warning: incorrect type in argument 1 (different address spaces)
drivers/media/rc/ir-hix5hd2.c:155:28:    expected void const volatile [noderef] <asn:2>*addr
drivers/media/rc/ir-hix5hd2.c:155:28:    got void *
drivers/media/rc/ir-hix5hd2.c:157:25: warning: incorrect type in argument 1 (different address spaces)
drivers/media/rc/ir-hix5hd2.c:157:25:    expected void const volatile [noderef] <asn:2>*addr
drivers/media/rc/ir-hix5hd2.c:157:25:    got void *
drivers/media/rc/ir-hix5hd2.c:159:61: warning: incorrect type in argument 2 (different address spaces)
drivers/media/rc/ir-hix5hd2.c:159:61:    expected void volatile [noderef] <asn:2>*addr
drivers/media/rc/ir-hix5hd2.c:159:61:    got void *
drivers/media/rc/ir-hix5hd2.c:167:28: warning: incorrect type in argument 1 (different address spaces)
drivers/media/rc/ir-hix5hd2.c:167:28:    expected void const volatile [noderef] <asn:2>*addr
drivers/media/rc/ir-hix5hd2.c:167:28:    got void *
drivers/media/rc/ir-hix5hd2.c:169:36: warning: incorrect type in argument 1 (different address spaces)
drivers/media/rc/ir-hix5hd2.c:169:36:    expected void const volatile [noderef] <asn:2>*addr
drivers/media/rc/ir-hix5hd2.c:169:36:    got void *
drivers/media/rc/ir-hix5hd2.c:188:64: warning: incorrect type in argument 2 (different address spaces)
drivers/media/rc/ir-hix5hd2.c:188:64:    expected void volatile [noderef] <asn:2>*addr
drivers/media/rc/ir-hix5hd2.c:188:64:    got void *
drivers/media/rc/ir-hix5hd2.c:190:68: warning: incorrect type in argument 2 (different address spaces)
drivers/media/rc/ir-hix5hd2.c:190:68:    expected void volatile [noderef] <asn:2>*addr
drivers/media/rc/ir-hix5hd2.c:190:68:    got void *
drivers/media/rc/ir-hix5hd2.c:220:20: warning: incorrect type in assignment (different address spaces)
drivers/media/rc/ir-hix5hd2.c:220:20:    expected void *base
drivers/media/rc/ir-hix5hd2.c:220:20:    got void [noderef] <asn:2>*
drivers/media/rc/ir-hix5hd2.c:315:41: warning: incorrect type in argument 2 (different address spaces)
drivers/media/rc/ir-hix5hd2.c:315:41:    expected void volatile [noderef] <asn:2>*addr
drivers/media/rc/ir-hix5hd2.c:315:41:    got void *
drivers/media/rc/ir-hix5hd2.c:316:41: warning: incorrect type in argument 2 (different address spaces)
drivers/media/rc/ir-hix5hd2.c:316:41:    expected void volatile [noderef] <asn:2>*addr
drivers/media/rc/ir-hix5hd2.c:316:41:    got void *
drivers/media/rc/ir-hix5hd2.c:317:41: warning: incorrect type in argument 2 (different address spaces)
drivers/media/rc/ir-hix5hd2.c:317:41:    expected void volatile [noderef] <asn:2>*addr
drivers/media/rc/ir-hix5hd2.c:317:41:    got void *
drivers/media/rc/ir-hix5hd2.c:318:41: warning: incorrect type in argument 2 (different address spaces)
drivers/media/rc/ir-hix5hd2.c:318:41:    expected void volatile [noderef] <asn:2>*addr
drivers/media/rc/ir-hix5hd2.c:318:41:    got void *

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/rc/ir-hix5hd2.c b/drivers/media/rc/ir-hix5hd2.c
index 94967d0e0478..c555ca2aed0e 100644
--- a/drivers/media/rc/ir-hix5hd2.c
+++ b/drivers/media/rc/ir-hix5hd2.c
@@ -68,7 +68,7 @@
 
 struct hix5hd2_ir_priv {
 	int			irq;
-	void			*base;
+	void volatile __iomem	*base;
 	struct device		*dev;
 	struct rc_dev		*rdev;
 	struct regmap		*regmap;
@@ -218,8 +218,8 @@ static int hix5hd2_ir_probe(struct platform_device *pdev)
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	priv->base = devm_ioremap_resource(dev, res);
-	if (IS_ERR(priv->base))
-		return PTR_ERR(priv->base);
+	if (IS_ERR((__force void *)priv->base))
+		return PTR_ERR((__force void *)priv->base);
 
 	priv->irq = platform_get_irq(pdev, 0);
 	if (priv->irq < 0) {
-- 
1.9.3

