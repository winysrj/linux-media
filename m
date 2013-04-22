Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:23935 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531Ab3DVOHQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Apr 2013 10:07:16 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MLN00JMYTW396L0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Mon, 22 Apr 2013 23:07:15 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	a.hajda@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 11/12] exynos4-is: Change function call order in
 fimc_is_module_exit()
Date: Mon, 22 Apr 2013 16:03:46 +0200
Message-id: <1366639427-14253-12-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1366639427-14253-1-git-send-email-s.nawrocki@samsung.com>
References: <1366639427-14253-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to hardware dependencies (clocks/power domain) the I2C bus
controller needs to be unregistered before fimc-is.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-is.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-is.c b/drivers/media/platform/exynos4-is/fimc-is.c
index ca72b02..5e89077 100644
--- a/drivers/media/platform/exynos4-is/fimc-is.c
+++ b/drivers/media/platform/exynos4-is/fimc-is.c
@@ -995,9 +995,9 @@ err_sens:
 
 static void fimc_is_module_exit(void)
 {
-	platform_driver_unregister(&fimc_is_driver);
-	fimc_is_unregister_i2c_driver();
 	fimc_is_unregister_sensor_driver();
+	fimc_is_unregister_i2c_driver();
+	platform_driver_unregister(&fimc_is_driver);
 }
 
 module_init(fimc_is_module_init);
-- 
1.7.9.5

