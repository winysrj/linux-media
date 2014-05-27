Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp14.mail.ru ([94.100.181.95]:37038 "EHLO smtp14.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881AbaE0HsO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 May 2014 03:48:14 -0400
From: Alexander Shiyan <shc_work@mail.ru>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Shawn Guo <shawn.guo@freescale.com>,
	Sascha Hauer <kernel@pengutronix.de>,
	Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH 1/2] media: mx2-emmaprp: Add devicetree support
Date: Tue, 27 May 2014 11:47:58 +0400
Message-Id: <1401176878-7318-1-git-send-email-shc_work@mail.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds devicetree support for the Freescale enhanced Multimedia
Accelerator (eMMA) video Pre-processor (PrP).

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 drivers/media/platform/mx2_emmaprp.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/platform/mx2_emmaprp.c b/drivers/media/platform/mx2_emmaprp.c
index fa8f7ca..0646bda 100644
--- a/drivers/media/platform/mx2_emmaprp.c
+++ b/drivers/media/platform/mx2_emmaprp.c
@@ -18,6 +18,7 @@
  */
 #include <linux/module.h>
 #include <linux/clk.h>
+#include <linux/of.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
@@ -1005,12 +1006,19 @@ static int emmaprp_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static const struct of_device_id __maybe_unused emmaprp_dt_ids[] = {
+	{ .compatible = "fsl,imx21-emmaprp", },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, emmaprp_dt_ids);
+
 static struct platform_driver emmaprp_pdrv = {
 	.probe		= emmaprp_probe,
 	.remove		= emmaprp_remove,
 	.driver		= {
 		.name	= MEM2MEM_NAME,
 		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(emmaprp_dt_ids),
 	},
 };
 module_platform_driver(emmaprp_pdrv);
-- 
1.8.5.5

