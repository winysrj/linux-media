Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:36121 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753442AbdHQVLm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Aug 2017 17:11:42 -0400
Received: by mail-qk0-f193.google.com with SMTP id d21so5754732qke.3
        for <linux-media@vger.kernel.org>; Thu, 17 Aug 2017 14:11:42 -0700 (PDT)
From: Fabio Estevam <festevam@gmail.com>
To: mchehab@kernel.org
Cc: linux-media@vger.kernel.org, p.zabel@pengutronix.de,
        Fabio Estevam <fabio.estevam@nxp.com>
Subject: [PATCH] [media] mx2_emmaprp: Check for platform_get_irq() error
Date: Thu, 17 Aug 2017 18:12:05 -0300
Message-Id: <1503004325-23655-1-git-send-email-festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@nxp.com>

platform_get_irq() may fail, so we should better check its return
value and propagate it in the case of error.

Signed-off-by: Fabio Estevam <fabio.estevam@nxp.com>
---
 drivers/media/platform/mx2_emmaprp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/mx2_emmaprp.c b/drivers/media/platform/mx2_emmaprp.c
index 03e47e0..f90eaa0 100644
--- a/drivers/media/platform/mx2_emmaprp.c
+++ b/drivers/media/platform/mx2_emmaprp.c
@@ -942,6 +942,8 @@ static int emmaprp_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, pcdev);
 
 	irq = platform_get_irq(pdev, 0);
+	if (irq < 0)
+		return irq;
 	ret = devm_request_irq(&pdev->dev, irq, emmaprp_irq, 0,
 			       dev_name(&pdev->dev), pcdev);
 	if (ret)
-- 
2.7.4
