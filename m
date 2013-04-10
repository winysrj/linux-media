Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:23271 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936450Ab3DJKof (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Apr 2013 06:44:35 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, linux-samsung-soc@vger.kernel.org,
	shaik.samsung@gmail.com, arun.kk@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 7/7] exynos4-is: Disable debug trace by default in fimc-isp.c
Date: Wed, 10 Apr 2013 12:42:42 +0200
Message-id: <1365590562-5747-8-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1365590562-5747-1-git-send-email-s.nawrocki@samsung.com>
References: <1365590562-5747-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make sure the debug level is properly set initially so any debug
information is not printed to the kernel log without explicitly
enabling it.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-isp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-isp.c b/drivers/media/platform/exynos4-is/fimc-isp.c
index 7b8fbab..3b9a664 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp.c
+++ b/drivers/media/platform/exynos4-is/fimc-isp.c
@@ -30,7 +30,7 @@
 #include "fimc-is-regs.h"
 #include "fimc-is.h"
 
-static int debug = 10;
+static int debug;
 module_param_named(debug_isp, debug, int, S_IRUGO | S_IWUSR);
 
 static const struct fimc_fmt fimc_isp_formats[FIMC_ISP_NUM_FORMATS] = {
-- 
1.7.9.5

