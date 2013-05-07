Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f43.google.com ([209.85.214.43]:61637 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756225Ab3EGLvW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 May 2013 07:51:22 -0400
Received: by mail-bk0-f43.google.com with SMTP id jm19so240951bkc.30
        for <linux-media@vger.kernel.org>; Tue, 07 May 2013 04:51:21 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 7 May 2013 19:51:21 +0800
Message-ID: <CAPgLHd_nr=X9JsE3w7BYg3GtbCFzMuvgoNAQPAGgM2h0g0injg@mail.gmail.com>
Subject: [PATCH] [media] davinci: vpfe: fix error return code in vpfe_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: mchehab@redhat.com, gregkh@linuxfoundation.org,
	prabhakar.csengg@gmail.com, sakari.ailus@iki.fi,
	yongjun_wei@trendmicro.com.cn, manjunath.hadli@ti.com
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c b/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
index b88e1dd..d8ce20d 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
@@ -639,7 +639,8 @@ static int vpfe_probe(struct platform_device *pdev)
 	if (ret)
 		goto probe_free_dev_mem;
 
-	if (vpfe_initialize_modules(vpfe_dev, pdev))
+	ret = vpfe_initialize_modules(vpfe_dev, pdev);
+	if (ret)
 		goto probe_disable_clock;
 
 	vpfe_dev->media_dev.dev = vpfe_dev->pdev;
@@ -663,7 +664,8 @@ static int vpfe_probe(struct platform_device *pdev)
 	/* set the driver data in platform device */
 	platform_set_drvdata(pdev, vpfe_dev);
 	/* register subdevs/entities */
-	if (vpfe_register_entities(vpfe_dev))
+	ret = vpfe_register_entities(vpfe_dev);
+	if (ret)
 		goto probe_out_v4l2_unregister;
 
 	ret = vpfe_attach_irq(vpfe_dev);

