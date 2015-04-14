Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vn0-f44.google.com ([209.85.216.44]:39944 "EHLO
	mail-vn0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569AbbDNTYh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Apr 2015 15:24:37 -0400
Received: by vnbg62 with SMTP id g62so7173195vnb.7
        for <linux-media@vger.kernel.org>; Tue, 14 Apr 2015 12:24:36 -0700 (PDT)
From: Fabio Estevam <festevam@gmail.com>
To: mchehab@osg.samsung.com
Cc: linux-media@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] [media] st_rc: fix build warning
Date: Tue, 14 Apr 2015 16:24:15 -0300
Message-Id: <1429039455-11422-1-git-send-email-festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@freescale.com>

Building for avr32 leads the following build warning:

drivers/media/rc/st_rc.c:270: warning: passing argument 1 of 'IS_ERR' discards qualifiers from pointer target type
drivers/media/rc/st_rc.c:271: warning: passing argument 1 of 'PTR_ERR' discards qualifiers from pointer target type

devm_ioremap_resource() returns void __iomem *, so change 'base' and 
'rx_base' definitions accordingly.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/media/rc/st_rc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/rc/st_rc.c b/drivers/media/rc/st_rc.c
index 0e758ae..fb5c3c8 100644
--- a/drivers/media/rc/st_rc.c
+++ b/drivers/media/rc/st_rc.c
@@ -22,8 +22,8 @@ struct st_rc_device {
 	int				irq;
 	int				irq_wake;
 	struct clk			*sys_clock;
-	volatile void __iomem		*base;	/* Register base address */
-	volatile void __iomem		*rx_base;/* RX Register base address */
+	void __iomem			*base;	/* Register base address */
+	void __iomem			*rx_base;/* RX Register base address */
 	struct rc_dev			*rdev;
 	bool				overclocking;
 	int				sample_mult;
@@ -267,8 +267,8 @@ static int st_rc_probe(struct platform_device *pdev)
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 
 	rc_dev->base = devm_ioremap_resource(dev, res);
-	if (IS_ERR((__force void *)rc_dev->base)) {
-		ret = PTR_ERR((__force void *)rc_dev->base);
+	if (IS_ERR(rc_dev->base)) {
+		ret = PTR_ERR(rc_dev->base);
 		goto err;
 	}
 
-- 
1.9.1

