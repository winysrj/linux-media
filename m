Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:36684 "EHLO
	mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932141AbcFOWay (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jun 2016 18:30:54 -0400
From: Janusz Krzysztofik <jmkrzyszt@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Amitoj Kaur Chawla <amitoj1606@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Lee Jones <lee.jones@linaro.org>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
	Janusz Krzysztofik <jmkrzyszt@gmail.com>
Subject: [PATCH 1/3] staging: media: omap1: fix null pointer dereference in omap1_cam_probe()
Date: Thu, 16 Jun 2016 00:29:48 +0200
Message-Id: <1466029790-31094-2-git-send-email-jmkrzyszt@gmail.com>
In-Reply-To: <1466029790-31094-1-git-send-email-jmkrzyszt@gmail.com>
References: <1466029790-31094-1-git-send-email-jmkrzyszt@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit 76e543382bd4 ("staging: media: omap1: Switch to
devm_ioremap_resource") moved assignment of struct resource *res =
platform_get_resource() several lines down. That resulted in the
following error:

[    3.793237] Unable to handle kernel NULL pointer dereference at virtual address 00000004
[    3.802198] pgd = c0004000
[    3.805202] [00000004] *pgd=00000000
[    3.809373] Internal error: Oops: c5 [#1] ARM
[    3.814070] CPU: 0 PID: 1 Comm: swapper Not tainted 4.6.0-rc1+ #70
[    3.820570] Hardware name: Amstrad E3 (Delta)
[    3.825232] task: c1819440 ti: c181e000 task.ti: c181e000
[    3.830973] PC is at omap1_cam_probe+0x48/0x2d4
[    3.835873] LR is at devres_add+0x20/0x28

Move the assignment back up where it was before - it is used to build
an argument for a subsequent devm_kzalloc(). Also, restore the check
for null value of res - it shouldn't hurt.

While being at it:
- follow the recently introduced convention of direct return
  instead of jump to return with err value assigned,
- drop no longer needed res member from the definition of struct
  omap1_cam_dev.

Created and tested on Amstrad Delta aginst Linux-4.7-rc3

Signed-off-by: Janusz Krzysztofik <jmkrzyszt@gmail.com>
---
 drivers/staging/media/omap1/omap1_camera.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/media/omap1/omap1_camera.c b/drivers/staging/media/omap1/omap1_camera.c
index 54b8dd2..dc35d30 100644
--- a/drivers/staging/media/omap1/omap1_camera.c
+++ b/drivers/staging/media/omap1/omap1_camera.c
@@ -158,7 +158,6 @@ struct omap1_cam_dev {
 	int				dma_ch;
 
 	struct omap1_cam_platform_data	*pdata;
-	struct resource			*res;
 	unsigned long			pflags;
 	unsigned long			camexclk;
 
@@ -1569,11 +1568,10 @@ static int omap1_cam_probe(struct platform_device *pdev)
 	unsigned int irq;
 	int err = 0;
 
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	irq = platform_get_irq(pdev, 0);
-	if ((int)irq <= 0) {
-		err = -ENODEV;
-		goto exit;
-	}
+	if (!res || (int)irq <= 0)
+		return -ENODEV;
 
 	clk = devm_clk_get(&pdev->dev, "armper_ck");
 	if (IS_ERR(clk))
@@ -1614,7 +1612,6 @@ static int omap1_cam_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&pcdev->capture);
 	spin_lock_init(&pcdev->lock);
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(base))
 		return PTR_ERR(base);
@@ -1663,7 +1660,6 @@ static int omap1_cam_probe(struct platform_device *pdev)
 
 exit_free_dma:
 	omap_free_dma(pcdev->dma_ch);
-exit:
 	return err;
 }
 
-- 
2.7.3

