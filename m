Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-da0-f44.google.com ([209.85.210.44]:59748 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755457Ab3CDIZr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Mar 2013 03:25:47 -0500
Received: by mail-da0-f44.google.com with SMTP id z20so2434135dae.17
        for <linux-media@vger.kernel.org>; Mon, 04 Mar 2013 00:25:47 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, sachin.kamat@linaro.org,
	thierry.reding@avionic-design.de
Subject: [PATCH 1/4] [media] sh_veu.c: Convert to devm_ioremap_resource()
Date: Mon,  4 Mar 2013 13:45:18 +0530
Message-Id: <1362384921-7344-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the newly introduced devm_ioremap_resource() instead of
devm_request_and_ioremap() which provides more consistent error handling.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/platform/sh_veu.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/sh_veu.c b/drivers/media/platform/sh_veu.c
index cb54c69..362d88e 100644
--- a/drivers/media/platform/sh_veu.c
+++ b/drivers/media/platform/sh_veu.c
@@ -10,6 +10,7 @@
  * published by the Free Software Foundation
  */
 
+#include <linux/err.h>
 #include <linux/fs.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -1164,9 +1165,9 @@ static int sh_veu_probe(struct platform_device *pdev)
 
 	veu->is_2h = resource_size(reg_res) == 0x22c;
 
-	veu->base = devm_request_and_ioremap(&pdev->dev, reg_res);
-	if (!veu->base)
-		return -ENOMEM;
+	veu->base = devm_ioremap_resource(&pdev->dev, reg_res);
+	if (IS_ERR(veu->base))
+		return PTR_ERR(veu->base);
 
 	ret = devm_request_threaded_irq(&pdev->dev, irq, sh_veu_isr, sh_veu_bh,
 					0, "veu", veu);
-- 
1.7.4.1

