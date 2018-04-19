Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([88.99.104.3]:45272 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753386AbeDSOHA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Apr 2018 10:07:00 -0400
From: Wolfram Sang <wsa+renesas@sang-engineering.com>
To: linux-kernel@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Subject: [PATCH 25/61] media: platform: am437x: simplify getting .drvdata
Date: Thu, 19 Apr 2018 16:05:55 +0200
Message-Id: <20180419140641.27926-26-wsa+renesas@sang-engineering.com>
In-Reply-To: <20180419140641.27926-1-wsa+renesas@sang-engineering.com>
References: <20180419140641.27926-1-wsa+renesas@sang-engineering.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We should get drvdata from struct device directly. Going via
platform_device is an unneeded step back and forth.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
---

Build tested only. buildbot is happy. Please apply individually.

 drivers/media/platform/am437x/am437x-vpfe.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/am437x/am437x-vpfe.c b/drivers/media/platform/am437x/am437x-vpfe.c
index 601ae6487617..58ebc2220d0e 100644
--- a/drivers/media/platform/am437x/am437x-vpfe.c
+++ b/drivers/media/platform/am437x/am437x-vpfe.c
@@ -2662,8 +2662,7 @@ static void vpfe_save_context(struct vpfe_ccdc *ccdc)
 
 static int vpfe_suspend(struct device *dev)
 {
-	struct platform_device *pdev = to_platform_device(dev);
-	struct vpfe_device *vpfe = platform_get_drvdata(pdev);
+	struct vpfe_device *vpfe = dev_get_drvdata(dev);
 	struct vpfe_ccdc *ccdc = &vpfe->ccdc;
 
 	/* if streaming has not started we don't care */
@@ -2720,8 +2719,7 @@ static void vpfe_restore_context(struct vpfe_ccdc *ccdc)
 
 static int vpfe_resume(struct device *dev)
 {
-	struct platform_device *pdev = to_platform_device(dev);
-	struct vpfe_device *vpfe = platform_get_drvdata(pdev);
+	struct vpfe_device *vpfe = dev_get_drvdata(dev);
 	struct vpfe_ccdc *ccdc = &vpfe->ccdc;
 
 	/* if streaming has not started we don't care */
-- 
2.11.0
