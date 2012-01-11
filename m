Return-path: <linux-media-owner@vger.kernel.org>
Received: from newsmtp5.atmel.com ([204.2.163.5]:1703 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756726Ab2AKD7J (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jan 2012 22:59:09 -0500
From: Josh Wu <josh.wu@atmel.com>
To: linux-media@vger.kernel.org, mchehab@redhat.com
Cc: linux-arm-kernel@lists.infradead.org, g.liakhovetski@gmx.de,
	nicolas.ferre@atmel.com, linux@arm.linux.org.uk, arnd@arndb.de,
	Josh Wu <josh.wu@atmel.com>
Subject: [PATCH v4 2/2] [media] V4L: atmel-isi: add clk_prepare()/clk_unprepare() functions
Date: Wed, 11 Jan 2012 11:58:29 +0800
Message-Id: <1326254309-6090-1-git-send-email-josh.wu@atmel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Josh Wu <josh.wu@atmel.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
v2: made the label name to be consistent.
v4: add goto for handling pclk prepare error.

 drivers/media/video/atmel-isi.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/atmel-isi.c b/drivers/media/video/atmel-isi.c
index 9fe4519..ec3f6a0 100644
--- a/drivers/media/video/atmel-isi.c
+++ b/drivers/media/video/atmel-isi.c
@@ -922,7 +922,9 @@ static int __devexit atmel_isi_remove(struct platform_device *pdev)
 			isi->fb_descriptors_phys);
 
 	iounmap(isi->regs);
+	clk_unprepare(isi->mck);
 	clk_put(isi->mck);
+	clk_unprepare(isi->pclk);
 	clk_put(isi->pclk);
 	kfree(isi);
 
@@ -955,6 +957,10 @@ static int __devinit atmel_isi_probe(struct platform_device *pdev)
 	if (IS_ERR(pclk))
 		return PTR_ERR(pclk);
 
+	ret = clk_prepare(pclk);
+	if (ret)
+		goto err_clk_prepare_pclk;
+
 	isi = kzalloc(sizeof(struct atmel_isi), GFP_KERNEL);
 	if (!isi) {
 		ret = -ENOMEM;
@@ -978,6 +984,10 @@ static int __devinit atmel_isi_probe(struct platform_device *pdev)
 		goto err_clk_get;
 	}
 
+	ret = clk_prepare(isi->mck);
+	if (ret)
+		goto err_clk_prepare_mck;
+
 	/* Set ISI_MCK's frequency, it should be faster than pixel clock */
 	ret = clk_set_rate(isi->mck, pdata->mck_hz);
 	if (ret < 0)
@@ -1059,10 +1069,14 @@ err_alloc_ctx:
 			isi->fb_descriptors_phys);
 err_alloc_descriptors:
 err_set_mck_rate:
+	clk_unprepare(isi->mck);
+err_clk_prepare_mck:
 	clk_put(isi->mck);
 err_clk_get:
 	kfree(isi);
 err_alloc_isi:
+	clk_unprepare(pclk);
+err_clk_prepare_pclk:
 	clk_put(pclk);
 
 	return ret;
-- 
1.6.3.3

