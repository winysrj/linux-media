Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-da0-f52.google.com ([209.85.210.52]:52922 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915Ab2L1K01 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Dec 2012 05:26:27 -0500
Received: by mail-da0-f52.google.com with SMTP id f10so4726916dak.25
        for <linux-media@vger.kernel.org>; Fri, 28 Dec 2012 02:26:26 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, s.nawrocki@samsung.com,
	sylvester.nawrocki@gmail.com, sachin.kamat@linaro.org,
	patches@linaro.org
Subject: [PATCH 3/3] [media] s5p-mfc: Use of_match_ptr and CONFIG_OF
Date: Fri, 28 Dec 2012 15:48:28 +0530
Message-Id: <1356689908-6866-3-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1356689908-6866-1-git-send-email-sachin.kamat@linaro.org>
References: <1356689908-6866-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This builds the code only if DT is enabled.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 3930177..65ed603 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1405,6 +1405,7 @@ static struct platform_device_id mfc_driver_ids[] = {
 };
 MODULE_DEVICE_TABLE(platform, mfc_driver_ids);
 
+#ifdef CONFIG_OF
 static const struct of_device_id exynos_mfc_match[] = {
 	{
 		.compatible = "samsung,mfc-v5",
@@ -1416,6 +1417,7 @@ static const struct of_device_id exynos_mfc_match[] = {
 	{},
 };
 MODULE_DEVICE_TABLE(of, exynos_mfc_match);
+#endif
 
 static void *mfc_get_drv_data(struct platform_device *pdev)
 {
@@ -1442,7 +1444,7 @@ static struct platform_driver s5p_mfc_driver = {
 		.name	= S5P_MFC_NAME,
 		.owner	= THIS_MODULE,
 		.pm	= &s5p_mfc_pm_ops,
-		.of_match_table = exynos_mfc_match,
+		.of_match_table = of_match_ptr(exynos_mfc_match),
 	},
 };
 
-- 
1.7.4.1

