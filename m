Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:45061 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727283AbeJDVOE (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2018 17:14:04 -0400
From: Colin King <colin.king@canonical.com>
To: Kyungmin Park <kyungmin.park@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: exynos4-is: make const array config_ids static
Date: Thu,  4 Oct 2018 15:20:27 +0100
Message-Id: <20181004142027.21009-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

The const array config_ids can be made static, saves populating it on
the stack and will make it read-only.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/platform/exynos4-is/fimc-is.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-is.c b/drivers/media/platform/exynos4-is/fimc-is.c
index 5ddb2321e9e4..f5fc54de19da 100644
--- a/drivers/media/platform/exynos4-is/fimc-is.c
+++ b/drivers/media/platform/exynos4-is/fimc-is.c
@@ -656,7 +656,7 @@ static int fimc_is_hw_open_sensor(struct fimc_is *is,
 
 int fimc_is_hw_initialize(struct fimc_is *is)
 {
-	const int config_ids[] = {
+	static const int config_ids[] = {
 		IS_SC_PREVIEW_STILL, IS_SC_PREVIEW_VIDEO,
 		IS_SC_CAPTURE_STILL, IS_SC_CAPTURE_VIDEO
 	};
-- 
2.17.1
