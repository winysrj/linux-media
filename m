Return-path: <linux-media-owner@vger.kernel.org>
Received: from fallback3.mail.ru ([94.100.176.58]:41540 "EHLO
	fallback3.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161025Ab3FTQrW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Jun 2013 12:47:22 -0400
Received: from smtp44.i.mail.ru (smtp44.i.mail.ru [94.100.177.104])
	by fallback3.mail.ru (mPOP.Fallback_MX) with ESMTP id 6EB5FE8D6FF6
	for <linux-media@vger.kernel.org>; Thu, 20 Jun 2013 20:47:20 +0400 (MSK)
From: Alexander Shiyan <shc_work@mail.ru>
To: linux-media@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Sascha Hauer <kernel@pengutronix.de>,
	Shawn Guo <shawn.guo@linaro.org>,
	Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH RESEND] media: coda: Fix DT-driver data pointer for i.MX27
Date: Thu, 20 Jun 2013 20:46:36 +0400
Message-Id: <1371746796-16123-1-git-send-email-shc_work@mail.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 drivers/media/platform/coda.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 48b8d7a..1c77781 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -1924,7 +1924,7 @@ MODULE_DEVICE_TABLE(platform, coda_platform_ids);
 
 #ifdef CONFIG_OF
 static const struct of_device_id coda_dt_ids[] = {
-	{ .compatible = "fsl,imx27-vpu", .data = &coda_platform_ids[CODA_IMX27] },
+	{ .compatible = "fsl,imx27-vpu", .data = &coda_devdata[CODA_IMX27] },
 	{ .compatible = "fsl,imx53-vpu", .data = &coda_devdata[CODA_IMX53] },
 	{ /* sentinel */ }
 };
-- 
1.8.1.5

