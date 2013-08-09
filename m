Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:38517 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030789Ab3HITZf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Aug 2013 15:25:35 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: a.hajda@samsung.com, arun.kk@samsung.com,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 05/10] exynos4-is: Add missing MODULE_LICENSE for
 exynos-fimc-is.ko
Date: Fri, 09 Aug 2013 21:24:07 +0200
Message-id: <1376076252-30150-5-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1376076252-30150-1-git-send-email-s.nawrocki@samsung.com>
References: <1376076122-29963-1-git-send-email-s.nawrocki@samsung.com>
 <1376076252-30150-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This fixes compilation warning:
WARNING: modpost: missing MODULE_LICENSE() in
drivers/media/platform/exynos4-is/exynos-fimc-is.o

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-is.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/exynos4-is/fimc-is.c b/drivers/media/platform/exynos4-is/fimc-is.c
index 967f6a9..9b7fd1c 100644
--- a/drivers/media/platform/exynos4-is/fimc-is.c
+++ b/drivers/media/platform/exynos4-is/fimc-is.c
@@ -993,3 +993,4 @@ module_exit(fimc_is_module_exit);
 MODULE_ALIAS("platform:" FIMC_IS_DRV_NAME);
 MODULE_AUTHOR("Younghwan Joo <yhwan.joo@samsung.com>");
 MODULE_AUTHOR("Sylwester Nawrocki <s.nawrocki@samsung.com>");
+MODULE_LICENSE("GPL v2");
-- 
1.7.9.5

