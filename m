Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f46.google.com ([209.85.213.46]:46717 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752Ab2JJEIJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Oct 2012 00:08:09 -0400
Received: by mail-yh0-f46.google.com with SMTP id m54so21613yhm.19
        for <linux-media@vger.kernel.org>; Tue, 09 Oct 2012 21:08:08 -0700 (PDT)
From: Fabio Estevam <festevam@gmail.com>
To: mchehab@infradead.org
Cc: p.zabel@pengutronix.de, javier.martin@vista-silicon.com,
	kernel@pengutronix.de, linux-media@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] [media] coda: Fix 'driver_data' for mx53
Date: Wed, 10 Oct 2012 01:07:38 -0300
Message-Id: <1349842058-16458-1-git-send-email-festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@freescale.com>

CODA_7541 is the coda_product type for mx53.

The 'driver_data' for mx53 is CODA_IMX53 instead.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/media/platform/coda.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 7640505..7b8b547 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -1877,7 +1877,7 @@ static const struct coda_devtype coda_devdata[] = {
 
 static struct platform_device_id coda_platform_ids[] = {
 	{ .name = "coda-imx27", .driver_data = CODA_IMX27 },
-	{ .name = "coda-imx53", .driver_data = CODA_7541 },
+	{ .name = "coda-imx53", .driver_data = CODA_IMX53 },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(platform, coda_platform_ids);
-- 
1.7.9.5

