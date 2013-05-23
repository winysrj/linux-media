Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:35600 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124Ab3EWFFH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 May 2013 01:05:07 -0400
Received: by mail-pa0-f45.google.com with SMTP id lj1so2560705pab.4
        for <linux-media@vger.kernel.org>; Wed, 22 May 2013 22:05:07 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, sylvester.nawrocki@gmail.com,
	sachin.kamat@linaro.org, patches@linaro.org,
	Kamil Debski <k.debski@samsung.com>
Subject: [PATCH 2/2] [media] s5p-mfc: Remove redundant use of of_match_ptr macro
Date: Thu, 23 May 2013 10:21:19 +0530
Message-Id: <1369284679-14716-2-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1369284679-14716-1-git-send-email-sachin.kamat@linaro.org>
References: <1369284679-14716-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

'exynos_mfc_match' is always compiled in. Hence of_match_ptr
is unnecessary.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Kamil Debski <k.debski@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 01f9ae0..5d0419b 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1426,7 +1426,7 @@ static void *mfc_get_drv_data(struct platform_device *pdev)
 
 	if (pdev->dev.of_node) {
 		const struct of_device_id *match;
-		match = of_match_node(of_match_ptr(exynos_mfc_match),
+		match = of_match_node(exynos_mfc_match,
 				pdev->dev.of_node);
 		if (match)
 			driver_data = (struct s5p_mfc_variant *)match->data;
-- 
1.7.9.5

