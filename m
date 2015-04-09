Return-path: <linux-media-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:14114 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755514AbbDII7F (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Apr 2015 04:59:05 -0400
From: Josh Wu <josh.wu@atmel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Nicolas Ferre <nicolas.ferre@atmel.com>,
	<linux-arm-kernel@lists.infradead.org>, Josh Wu <josh.wu@atmel.com>
Subject: [PATCH v2 1/3] media: atmel-isi: remove the useless code which disable isi
Date: Thu, 9 Apr 2015 17:01:46 +0800
Message-ID: <1428570108-4961-2-git-send-email-josh.wu@atmel.com>
In-Reply-To: <1428570108-4961-1-git-send-email-josh.wu@atmel.com>
References: <1428570108-4961-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To program ISI control register, the pixel clock should be enabled.
So without pixel clock (from sensor) enabled, disable ISI controller is
not make sense. So this patch remove those code.

Signed-off-by: Josh Wu <josh.wu@atmel.com>
---

Changes in v2:
- this file is new added.

 drivers/media/platform/soc_camera/atmel-isi.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index c125b1d..31254b4 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -131,8 +131,6 @@ static int configure_geometry(struct atmel_isi *isi, u32 width,
 		return -EINVAL;
 	}
 
-	isi_writel(isi, ISI_CTRL, ISI_CTRL_DIS);
-
 	cfg2 = isi_readl(isi, ISI_CFG2);
 	/* Set YCC swap mode */
 	cfg2 &= ~ISI_CFG2_YCC_SWAP_MODE_MASK;
@@ -843,7 +841,6 @@ static int isi_camera_set_bus_param(struct soc_camera_device *icd)
 
 	cfg1 |= ISI_CFG1_THMASK_BEATS_16;
 
-	isi_writel(isi, ISI_CTRL, ISI_CTRL_DIS);
 	isi_writel(isi, ISI_CFG1, cfg1);
 
 	return 0;
@@ -1022,8 +1019,6 @@ static int atmel_isi_probe(struct platform_device *pdev)
 	if (isi->pdata.data_width_flags & ISI_DATAWIDTH_10)
 		isi->width_flags |= 1 << 9;
 
-	isi_writel(isi, ISI_CTRL, ISI_CTRL_DIS);
-
 	irq = platform_get_irq(pdev, 0);
 	if (IS_ERR_VALUE(irq)) {
 		ret = irq;
-- 
1.9.1

