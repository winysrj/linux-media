Return-path: <linux-media-owner@vger.kernel.org>
Received: from nasmtp01.atmel.com ([192.199.1.245]:25564 "EHLO
	DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750698AbbCEFAO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Mar 2015 00:00:14 -0500
From: Josh Wu <josh.wu@atmel.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	"Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
CC: <linux-arm-kernel@lists.infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Josh Wu <josh.wu@atmel.com>
Subject: [PATCH 3/3] media: atmel-isi: remove mck back compatiable code as we don't need it
Date: Thu, 5 Mar 2015 13:01:01 +0800
Message-ID: <1425531661-20040-4-git-send-email-josh.wu@atmel.com>
In-Reply-To: <1425531661-20040-1-git-send-email-josh.wu@atmel.com>
References: <1425531661-20040-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The master clock should handled by sensor itself.

Signed-off-by: Josh Wu <josh.wu@atmel.com>
---

 drivers/media/platform/soc_camera/atmel-isi.c | 32 ---------------------------
 1 file changed, 32 deletions(-)

diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index 4a384f1..50375ce 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -83,8 +83,6 @@ struct atmel_isi {
 	struct completion		complete;
 	/* ISI peripherial clock */
 	struct clk			*pclk;
-	/* ISI_MCK, feed to camera sensor to generate pixel clock */
-	struct clk			*mck;
 	unsigned int			irq;
 
 	struct isi_platform_data	pdata;
@@ -725,26 +723,12 @@ static void isi_camera_remove_device(struct soc_camera_device *icd)
 /* Called with .host_lock held */
 static int isi_camera_clock_start(struct soc_camera_host *ici)
 {
-	struct atmel_isi *isi = ici->priv;
-	int ret;
-
-	if (!IS_ERR(isi->mck)) {
-		ret = clk_prepare_enable(isi->mck);
-		if (ret) {
-			return ret;
-		}
-	}
-
 	return 0;
 }
 
 /* Called with .host_lock held */
 static void isi_camera_clock_stop(struct soc_camera_host *ici)
 {
-	struct atmel_isi *isi = ici->priv;
-
-	if (!IS_ERR(isi->mck))
-		clk_disable_unprepare(isi->mck);
 }
 
 static unsigned int isi_camera_poll(struct file *file, poll_table *pt)
@@ -894,7 +878,6 @@ static int atmel_isi_probe_dt(struct atmel_isi *isi,
 
 	/* Default settings for ISI */
 	isi->pdata.full_mode = 1;
-	isi->pdata.mck_hz = ISI_DEFAULT_MCLK_FREQ;
 	isi->pdata.frate = ISI_CFG1_FRATE_CAPTURE_ALL;
 
 	np = of_graph_get_next_endpoint(np, NULL);
@@ -970,21 +953,6 @@ static int atmel_isi_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&isi->video_buffer_list);
 	INIT_LIST_HEAD(&isi->dma_desc_head);
 
-	/* ISI_MCK is the sensor master clock. It should be handled by the
-	 * sensor driver directly, as the ISI has no use for that clock. Make
-	 * the clock optional here while platforms transition to the correct
-	 * model.
-	 */
-	isi->mck = devm_clk_get(dev, "isi_mck");
-	if (!IS_ERR(isi->mck)) {
-		/* Set ISI_MCK's frequency, it should be faster than pixel
-		 * clock.
-		 */
-		ret = clk_set_rate(isi->mck, isi->pdata.mck_hz);
-		if (ret < 0)
-			return ret;
-	}
-
 	isi->p_fb_descriptors = dma_alloc_coherent(&pdev->dev,
 				sizeof(struct fbd) * MAX_BUFFER_NUM,
 				&isi->fb_descriptors_phys,
-- 
1.9.1

