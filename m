Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:36069 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222AbbEAPvS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 May 2015 11:51:18 -0400
From: Krzysztof Kozlowski <k.kozlowski.k@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Jeongtae Park <jtp.park@samsung.com>,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski.k@gmail.com>
Subject: [PATCH 2/4] media: platform: exynos4-is: Constify platform_device_id
Date: Sat,  2 May 2015 00:51:01 +0900
Message-Id: <1430495463-31633-2-git-send-email-k.kozlowski.k@gmail.com>
In-Reply-To: <1430495463-31633-1-git-send-email-k.kozlowski.k@gmail.com>
References: <1430495463-31633-1-git-send-email-k.kozlowski.k@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The platform_device_id is not modified by the driver and core uses it as
const.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski.k@gmail.com>
---
 drivers/media/platform/exynos4-is/media-dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index f315ef946cd4..4f5586a4cbff 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -1451,7 +1451,7 @@ static int fimc_md_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static struct platform_device_id fimc_driver_ids[] __always_unused = {
+static const struct platform_device_id fimc_driver_ids[] __always_unused = {
 	{ .name = "s5p-fimc-md" },
 	{ },
 };
-- 
2.1.4

