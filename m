Return-path: <linux-media-owner@vger.kernel.org>
Received: from newsmtp5.atmel.com ([204.2.163.5]:51348 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107Ab2H2KqW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Aug 2012 06:46:22 -0400
From: Josh Wu <josh.wu@atmel.com>
To: g.liakhovetski@gmx.de, linux-media@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, nicolas.ferre@atmel.com,
	mchehab@redhat.com, Josh Wu <josh.wu@atmel.com>
Subject: [PATCH] [media] atmel_isi: allocate memory to store the isi platform data.
Date: Wed, 29 Aug 2012 18:11:33 +0800
Message-Id: <1346235093-28613-1-git-send-email-josh.wu@atmel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fix the bug: ISI driver's platform data became invalid when isi platform data's attribution is __initdata.

If the isi platform data is passed as __initdata. Then we need store it in driver allocated memory. otherwise when we use it out of the probe() function, then the isi platform data is invalid.

Signed-off-by: Josh Wu <josh.wu@atmel.com>
---
 drivers/media/platform/soc_camera/atmel-isi.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index ec3f6a0..dc0fdec 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -926,6 +926,7 @@ static int __devexit atmel_isi_remove(struct platform_device *pdev)
 	clk_put(isi->mck);
 	clk_unprepare(isi->pclk);
 	clk_put(isi->pclk);
+	kfree(isi->pdata);
 	kfree(isi);
 
 	return 0;
@@ -968,8 +969,15 @@ static int __devinit atmel_isi_probe(struct platform_device *pdev)
 		goto err_alloc_isi;
 	}
 
+	isi->pdata = kzalloc(sizeof(struct isi_platform_data), GFP_KERNEL);
+	if (!isi->pdata) {
+		ret = -ENOMEM;
+		dev_err(&pdev->dev, "Can't allocate isi platform data!\n");
+		goto err_alloc_isi_pdata;
+	}
+	memcpy(isi->pdata, pdata, sizeof(struct isi_platform_data));
+
 	isi->pclk = pclk;
-	isi->pdata = pdata;
 	isi->active = NULL;
 	spin_lock_init(&isi->lock);
 	init_waitqueue_head(&isi->vsync_wq);
@@ -1073,6 +1081,8 @@ err_set_mck_rate:
 err_clk_prepare_mck:
 	clk_put(isi->mck);
 err_clk_get:
+	kfree(isi->pdata);
+err_alloc_isi_pdata:
 	kfree(isi);
 err_alloc_isi:
 	clk_unprepare(pclk);
-- 
1.7.9.5

