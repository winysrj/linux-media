Return-path: <linux-media-owner@vger.kernel.org>
Received: from fallback1.mail.ru ([94.100.181.184]:33239 "EHLO
	fallback1.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbcFRPN5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Jun 2016 11:13:57 -0400
From: Alexander Shiyan <shc_work@mail.ru>
To: linux-media@vger.kernel.org
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH] media: coda: Fix probe() if reset controller is missing
Date: Sat, 18 Jun 2016 17:45:15 +0300
Message-Id: <1466261116-9212-1-git-send-email-shc_work@mail.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit 39b4da71ca334354f30941067f214ea2f2b92f3e (reset: use ENOTSUPP
instead of ENOSYS) changed return value for reset controller if it missing.
This patch changes the CODA driver to handle this value.

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 drivers/media/platform/coda/coda-common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 133ab9f..098653d 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -2226,7 +2226,7 @@ static int coda_probe(struct platform_device *pdev)
 	dev->rstc = devm_reset_control_get_optional(&pdev->dev, NULL);
 	if (IS_ERR(dev->rstc)) {
 		ret = PTR_ERR(dev->rstc);
-		if (ret == -ENOENT || ret == -ENOSYS) {
+		if (ret == -ENOENT || ret == -ENOTSUPP) {
 			dev->rstc = NULL;
 		} else {
 			dev_err(&pdev->dev, "failed get reset control: %d\n",
-- 
2.4.9

