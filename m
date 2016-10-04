Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-co1nam03on0084.outbound.protection.outlook.com ([104.47.40.84]:53600
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753237AbcJDP4l (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 4 Oct 2016 11:56:41 -0400
From: Fabio Estevam <fabio.estevam@nxp.com>
To: <p.zabel@pengutronix.de>
CC: <linux-media@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>
Subject: [PATCH] [media] coda: fix the error path in coda_probe()
Date: Tue, 4 Oct 2016 12:41:37 -0300
Message-ID: <1475595697-32680-1-git-send-email-fabio.estevam@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In the case of coda_firmware_request() failure, we should release the
prevously acquired resources.

Signed-off-by: Fabio Estevam <fabio.estevam@nxp.com>
---
 drivers/media/platform/coda/coda-common.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index c39718a..9e6bdaf 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -2295,8 +2295,13 @@ static int coda_probe(struct platform_device *pdev)
 	pm_runtime_set_active(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);
 
-	return coda_firmware_request(dev);
+	ret = coda_firmware_request(dev);
+	if (ret)
+		goto err_alloc_workqueue;
+	return 0;
 
+err_alloc_workqueue:
+	destroy_workqueue(dev->workqueue);
 err_v4l2_register:
 	v4l2_device_unregister(&dev->v4l2_dev);
 	return ret;
-- 
2.7.4

