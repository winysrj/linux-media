Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f44.google.com ([209.85.192.44]:65423 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757782AbaLKTxk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Dec 2014 14:53:40 -0500
Received: by mail-qg0-f44.google.com with SMTP id q107so2335134qgd.3
        for <linux-media@vger.kernel.org>; Thu, 11 Dec 2014 11:53:39 -0800 (PST)
From: Fabio Estevam <festevam@gmail.com>
To: p.zabel@pengutronix.de
Cc: mchehab@osg.samsung.com, linux-media@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] coda: coda-common: Remove mx53 entry from coda_platform_ids
Date: Thu, 11 Dec 2014 17:53:17 -0200
Message-Id: <1418327597-17874-1-git-send-email-festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@freescale.com>

As mx53 is a dt-only architecture we can safely remove its entry from the 
coda_platform_ids[] structure. 

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/media/platform/coda/coda-common.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 39330a7..efed0b8 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -2001,7 +2001,6 @@ static const struct coda_devtype coda_devdata[] = {
 
 static struct platform_device_id coda_platform_ids[] = {
 	{ .name = "coda-imx27", .driver_data = CODA_IMX27 },
-	{ .name = "coda-imx53", .driver_data = CODA_IMX53 },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(platform, coda_platform_ids);
-- 
1.9.1

