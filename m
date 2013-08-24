Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55939 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754675Ab3HXOvp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Aug 2013 10:51:45 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] [media] vsp1: Fix a sparse warning
Date: Sat, 24 Aug 2013 08:50:58 -0300
Message-Id: <1377345058-22177-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by: kbuild test robot <fengguang.wu@intel.com>:
	 drivers/media/platform/vsp1/vsp1_drv.c:434:21: sparse: cast removes address space of expression

	   433		vsp1->mmio = devm_ioremap_resource(&pdev->dev, io);
	 > 434		if (IS_ERR((void *)vsp1->mmio))
	 > 435			return PTR_ERR((void *)vsp1->mmio);

There's no need to convert it to void *.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/platform/vsp1/vsp1_drv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index 8700842..ff8cd2d 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -434,8 +434,8 @@ static int vsp1_probe(struct platform_device *pdev)
 	/* I/O, IRQ and clock resources */
 	io = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	vsp1->mmio = devm_ioremap_resource(&pdev->dev, io);
-	if (IS_ERR((void *)vsp1->mmio))
-		return PTR_ERR((void *)vsp1->mmio);
+	if (IS_ERR(vsp1->mmio))
+		return PTR_ERR(vsp1->mmio);
 
 	vsp1->clock = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(vsp1->clock)) {
-- 
1.8.3.1

