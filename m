Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:59712 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbbHAJWV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 Aug 2015 05:22:21 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Josh Wu <josh.wu@atmel.com>
Subject: [PATCH 2/4] v4l: atmel-isi: Remove unused variable
Date: Sat,  1 Aug 2015 12:22:54 +0300
Message-Id: <1438420976-7899-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1438420976-7899-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1438420976-7899-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix a compilation warning by removing an unused local variable in the
probe function.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/soc_camera/atmel-isi.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index 9c900d9569e0..a2e50a734fa3 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -920,7 +920,6 @@ static int atmel_isi_probe(struct platform_device *pdev)
 	struct atmel_isi *isi;
 	struct resource *regs;
 	int ret, i;
-	struct device *dev = &pdev->dev;
 	struct soc_camera_host *soc_host;
 	struct isi_platform_data *pdata;
 
-- 
2.3.6

