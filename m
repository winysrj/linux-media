Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34139 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746AbaIXW1y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Sep 2014 18:27:54 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
	Maxime Coquelin <maxime.coquelin@st.com>,
	Patrice Chotard <patrice.chotard@st.com>,
	linux-arm-kernel@lists.infradead.org, kernel@stlinux.com
Subject: [PATCH 02/18] [media] st_rc: fix address space casting
Date: Wed, 24 Sep 2014 19:27:02 -0300
Message-Id: <85bbfa5dbeda81dbef758ee1c450ed938b70ac4d.1411597610.git.mchehab@osg.samsung.com>
In-Reply-To: <c8634fac0c56cfaa9bdad29d541e95b17c049c0a.1411597610.git.mchehab@osg.samsung.com>
References: <c8634fac0c56cfaa9bdad29d541e95b17c049c0a.1411597610.git.mchehab@osg.samsung.com>
In-Reply-To: <c8634fac0c56cfaa9bdad29d541e95b17c049c0a.1411597610.git.mchehab@osg.samsung.com>
References: <c8634fac0c56cfaa9bdad29d541e95b17c049c0a.1411597610.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/rc/st_rc.c:107:38: warning: incorrect type in argument 1 (different address spaces)
drivers/media/rc/st_rc.c:107:38:    expected void const volatile [noderef] <asn:2>*addr
drivers/media/rc/st_rc.c:107:38:    got void *
drivers/media/rc/st_rc.c:110:53: warning: incorrect type in argument 1 (different address spaces)
drivers/media/rc/st_rc.c:110:53:    expected void const volatile [noderef] <asn:2>*addr
drivers/media/rc/st_rc.c:110:53:    got void *
drivers/media/rc/st_rc.c:116:54: warning: incorrect type in argument 2 (different address spaces)
drivers/media/rc/st_rc.c:116:54:    expected void volatile [noderef] <asn:2>*addr
drivers/media/rc/st_rc.c:116:54:    got void *
drivers/media/rc/st_rc.c:120:45: warning: incorrect type in argument 1 (different address spaces)
drivers/media/rc/st_rc.c:120:45:    expected void const volatile [noderef] <asn:2>*addr
drivers/media/rc/st_rc.c:120:45:    got void *
drivers/media/rc/st_rc.c:121:43: warning: incorrect type in argument 1 (different address spaces)
drivers/media/rc/st_rc.c:121:43:    expected void const volatile [noderef] <asn:2>*addr
drivers/media/rc/st_rc.c:121:43:    got void *
drivers/media/rc/st_rc.c:150:46: warning: incorrect type in argument 1 (different address spaces)
drivers/media/rc/st_rc.c:150:46:    expected void const volatile [noderef] <asn:2>*addr
drivers/media/rc/st_rc.c:150:46:    got void *
drivers/media/rc/st_rc.c:153:42: warning: incorrect type in argument 2 (different address spaces)
drivers/media/rc/st_rc.c:153:42:    expected void volatile [noderef] <asn:2>*addr
drivers/media/rc/st_rc.c:153:42:    got void *
drivers/media/rc/st_rc.c:174:32: warning: incorrect type in argument 2 (different address spaces)
drivers/media/rc/st_rc.c:174:32:    expected void volatile [noderef] <asn:2>*addr
drivers/media/rc/st_rc.c:174:32:    got void *
drivers/media/rc/st_rc.c:177:48: warning: incorrect type in argument 2 (different address spaces)
drivers/media/rc/st_rc.c:177:48:    expected void volatile [noderef] <asn:2>*addr
drivers/media/rc/st_rc.c:177:48:    got void *
drivers/media/rc/st_rc.c:187:48: warning: incorrect type in argument 2 (different address spaces)
drivers/media/rc/st_rc.c:187:48:    expected void volatile [noderef] <asn:2>*addr
drivers/media/rc/st_rc.c:187:48:    got void *
drivers/media/rc/st_rc.c:204:42: warning: incorrect type in argument 2 (different address spaces)
drivers/media/rc/st_rc.c:204:42:    expected void volatile [noderef] <asn:2>*addr
drivers/media/rc/st_rc.c:204:42:    got void *
drivers/media/rc/st_rc.c:205:35: warning: incorrect type in argument 2 (different address spaces)
drivers/media/rc/st_rc.c:205:35:    expected void volatile [noderef] <asn:2>*addr
drivers/media/rc/st_rc.c:205:35:    got void *
drivers/media/rc/st_rc.c:215:35: warning: incorrect type in argument 2 (different address spaces)
drivers/media/rc/st_rc.c:215:35:    expected void volatile [noderef] <asn:2>*addr
drivers/media/rc/st_rc.c:215:35:    got void *
drivers/media/rc/st_rc.c:216:35: warning: incorrect type in argument 2 (different address spaces)
drivers/media/rc/st_rc.c:216:35:    expected void volatile [noderef] <asn:2>*addr
drivers/media/rc/st_rc.c:216:35:    got void *
drivers/media/rc/st_rc.c:269:22: warning: incorrect type in assignment (different address spaces)
drivers/media/rc/st_rc.c:269:22:    expected void *base
drivers/media/rc/st_rc.c:269:22:    got void [noderef] <asn:2>*
drivers/media/rc/st_rc.c:349:46: warning: incorrect type in argument 2 (different address spaces)
drivers/media/rc/st_rc.c:349:46:    expected void volatile [noderef] <asn:2>*addr
drivers/media/rc/st_rc.c:349:46:    got void *
drivers/media/rc/st_rc.c:350:46: warning: incorrect type in argument 2 (different address spaces)
drivers/media/rc/st_rc.c:350:46:    expected void volatile [noderef] <asn:2>*addr
drivers/media/rc/st_rc.c:350:46:    got void *
drivers/media/rc/st_rc.c:371:61: warning: incorrect type in argument 2 (different address spaces)
drivers/media/rc/st_rc.c:371:61:    expected void volatile [noderef] <asn:2>*addr
drivers/media/rc/st_rc.c:371:61:    got void *
drivers/media/rc/st_rc.c:372:54: warning: incorrect type in argument 2 (different address spaces)
drivers/media/rc/st_rc.c:372:54:    expected void volatile [noderef] <asn:2>*addr
drivers/media/rc/st_rc.c:372:54:    got void *

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/rc/st_rc.c b/drivers/media/rc/st_rc.c
index e309441a266d..0e758ae2e529 100644
--- a/drivers/media/rc/st_rc.c
+++ b/drivers/media/rc/st_rc.c
@@ -22,8 +22,8 @@ struct st_rc_device {
 	int				irq;
 	int				irq_wake;
 	struct clk			*sys_clock;
-	void				*base;	/* Register base address */
-	void				*rx_base;/* RX Register base address */
+	volatile void __iomem		*base;	/* Register base address */
+	volatile void __iomem		*rx_base;/* RX Register base address */
 	struct rc_dev			*rdev;
 	bool				overclocking;
 	int				sample_mult;
@@ -267,8 +267,8 @@ static int st_rc_probe(struct platform_device *pdev)
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 
 	rc_dev->base = devm_ioremap_resource(dev, res);
-	if (IS_ERR(rc_dev->base)) {
-		ret = PTR_ERR(rc_dev->base);
+	if (IS_ERR((__force void *)rc_dev->base)) {
+		ret = PTR_ERR((__force void *)rc_dev->base);
 		goto err;
 	}
 
-- 
1.9.3

