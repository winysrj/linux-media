Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48636 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932641Ab3LDP2f (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Dec 2013 10:28:35 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Josh Wu <josh.wu@atmel.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org
Subject: [PATCH 3/5] v4l: atmel-isi: Defer clock (un)preparation to enable/disable time
Date: Wed,  4 Dec 2013 16:28:34 +0100
Message-Id: <1386170916-13723-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1386170916-13723-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1386170916-13723-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The PCLK and MCK clocks are prepared and unprepared at probe and remove
time. Clock (un)preparation isn't needed before enabling/disabling the
clocks, and the enable/disable operation happen in non-atomic context.
We can thus defer (un)preparation to enable/disable time.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Josh Wu <josh.wu@atmel.com>
---
 drivers/media/platform/soc_camera/atmel-isi.c | 35 ++++++---------------------
 1 file changed, 8 insertions(+), 27 deletions(-)

diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index faa7f8d..ea8816c 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -721,13 +721,13 @@ static int isi_camera_clock_start(struct soc_camera_host *ici)
 	struct atmel_isi *isi = ici->priv;
 	int ret;
 
-	ret = clk_enable(isi->pclk);
+	ret = clk_prepare_enable(isi->pclk);
 	if (ret)
 		return ret;
 
-	ret = clk_enable(isi->mck);
+	ret = clk_prepare_enable(isi->mck);
 	if (ret) {
-		clk_disable(isi->pclk);
+		clk_disable_unprepare(isi->pclk);
 		return ret;
 	}
 
@@ -739,8 +739,8 @@ static void isi_camera_clock_stop(struct soc_camera_host *ici)
 {
 	struct atmel_isi *isi = ici->priv;
 
-	clk_disable(isi->mck);
-	clk_disable(isi->pclk);
+	clk_disable_unprepare(isi->mck);
+	clk_disable_unprepare(isi->pclk);
 }
 
 static unsigned int isi_camera_poll(struct file *file, poll_table *pt)
@@ -869,9 +869,6 @@ static int atmel_isi_remove(struct platform_device *pdev)
 			isi->p_fb_descriptors,
 			isi->fb_descriptors_phys);
 
-	clk_unprepare(isi->mck);
-	clk_unprepare(isi->pclk);
-
 	return 0;
 }
 
@@ -902,10 +899,6 @@ static int atmel_isi_probe(struct platform_device *pdev)
 	if (IS_ERR(isi->pclk))
 		return PTR_ERR(isi->pclk);
 
-	ret = clk_prepare(isi->pclk);
-	if (ret)
-		return ret;
-
 	isi->pdata = pdata;
 	isi->active = NULL;
 	spin_lock_init(&isi->lock);
@@ -916,27 +909,21 @@ static int atmel_isi_probe(struct platform_device *pdev)
 	isi->mck = devm_clk_get(dev, "isi_mck");
 	if (IS_ERR(isi->mck)) {
 		dev_err(dev, "Failed to get isi_mck\n");
-		ret = PTR_ERR(isi->mck);
-		goto err_clk_get_mck;
+		return PTR_ERR(isi->mck);
 	}
 
-	ret = clk_prepare(isi->mck);
-	if (ret)
-		goto err_clk_prepare_mck;
-
 	/* Set ISI_MCK's frequency, it should be faster than pixel clock */
 	ret = clk_set_rate(isi->mck, pdata->mck_hz);
 	if (ret < 0)
-		goto err_set_mck_rate;
+		return ret;
 
 	isi->p_fb_descriptors = dma_alloc_coherent(&pdev->dev,
 				sizeof(struct fbd) * MAX_BUFFER_NUM,
 				&isi->fb_descriptors_phys,
 				GFP_KERNEL);
 	if (!isi->p_fb_descriptors) {
-		ret = -ENOMEM;
 		dev_err(&pdev->dev, "Can't allocate descriptors!\n");
-		goto err_alloc_descriptors;
+		return -ENOMEM;
 	}
 
 	for (i = 0; i < MAX_BUFFER_NUM; i++) {
@@ -1002,12 +989,6 @@ err_alloc_ctx:
 			sizeof(struct fbd) * MAX_BUFFER_NUM,
 			isi->p_fb_descriptors,
 			isi->fb_descriptors_phys);
-err_alloc_descriptors:
-err_set_mck_rate:
-	clk_unprepare(isi->mck);
-err_clk_prepare_mck:
-err_clk_get_mck:
-	clk_unprepare(isi->pclk);
 
 	return ret;
 }
-- 
1.8.3.2

