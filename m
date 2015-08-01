Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:59712 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbbHAJWW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 Aug 2015 05:22:22 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Josh Wu <josh.wu@atmel.com>
Subject: [PATCH 4/4] v4l: atmel-isi: Remove unused platform data fields
Date: Sat,  1 Aug 2015 12:22:56 +0300
Message-Id: <1438420976-7899-5-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1438420976-7899-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1438420976-7899-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The emb_crc_sync, mck_hz, asd and asd_sizes platform data fields are
unused, remove them.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/soc_camera/atmel-isi.c | 5 -----
 drivers/media/platform/soc_camera/atmel-isi.h | 5 -----
 2 files changed, 10 deletions(-)

diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index de9237e56f84..e6ff2a75ea42 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -999,11 +999,6 @@ static int atmel_isi_probe(struct platform_device *pdev)
 	pm_suspend_ignore_children(&pdev->dev, true);
 	pm_runtime_enable(&pdev->dev);
 
-	if (isi->pdata.asd_sizes) {
-		soc_host->asd = isi->pdata.asd;
-		soc_host->asd_sizes = isi->pdata.asd_sizes;
-	}
-
 	ret = soc_camera_host_register(soc_host);
 	if (ret) {
 		dev_err(&pdev->dev, "Unable to register soc camera host\n");
diff --git a/drivers/media/platform/soc_camera/atmel-isi.h b/drivers/media/platform/soc_camera/atmel-isi.h
index 6008b0985b7b..83493abd1fa2 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.h
+++ b/drivers/media/platform/soc_camera/atmel-isi.h
@@ -114,7 +114,6 @@ struct v4l2_async_subdev;
 
 struct isi_platform_data {
 	u8 has_emb_sync;
-	u8 emb_crc_sync;
 	u8 hsync_act_low;
 	u8 vsync_act_low;
 	u8 pclk_act_falling;
@@ -122,10 +121,6 @@ struct isi_platform_data {
 	u32 data_width_flags;
 	/* Using for ISI_CFG1 */
 	u32 frate;
-	/* Using for ISI_MCK */
-	u32 mck_hz;
-	struct v4l2_async_subdev **asd;	/* Flat array, arranged in groups */
-	int *asd_sizes;		/* 0-terminated array of asd group sizes */
 };
 
 #endif /* __ATMEL_ISI_H__ */
-- 
2.3.6

