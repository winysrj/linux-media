Return-path: <linux-media-owner@vger.kernel.org>
Received: from fallback7.mail.ru ([94.100.176.135]:55736 "EHLO
	fallback7.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681Ab3FOMKi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Jun 2013 08:10:38 -0400
Received: from smtp37.i.mail.ru (smtp37.i.mail.ru [94.100.177.97])
	by fallback7.mail.ru (mPOP.Fallback_MX) with ESMTP id 264DCD3C485C
	for <linux-media@vger.kernel.org>; Sat, 15 Jun 2013 16:10:34 +0400 (MSK)
From: Alexander Shiyan <shc_work@mail.ru>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH] media: coda: Fix DT driver data pointer for i.MX27
Date: Sat, 15 Jun 2013 16:09:57 +0400
Message-Id: <1371298197-23437-1-git-send-email-shc_work@mail.ru>
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

