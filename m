Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:62113 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035Ab3FNSqz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Jun 2013 14:46:55 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, kyungmin.park@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH] exynos4-is: Change fimc-is firmware file names
Date: Fri, 14 Jun 2013 20:46:37 +0200
Message-id: <1371235597-7584-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch changes the firmware file names of the FIMC-IS subsystem.
It is needed since there are different firmwares used across various
SoC series, e.g. Exynos4 and Exynos5.

Also the sensor specific "setfile" name is changed, to account for
it depends on an image sensor and is also specific to the FIMC-IS
and the SoC.

This is a change for a driver merged in 3.10.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-is.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-is.h b/drivers/media/platform/exynos4-is/fimc-is.h
index 68d4daa..4ae13b1 100644
--- a/drivers/media/platform/exynos4-is/fimc-is.h
+++ b/drivers/media/platform/exynos4-is/fimc-is.h
@@ -33,8 +33,8 @@
 
 #define FIMC_IS_DRV_NAME		"exynos4-fimc-is"
 
-#define FIMC_IS_FW_FILENAME		"fimc_is_fw.bin"
-#define FIMC_IS_SETFILE_6A3		"setfile.bin"
+#define FIMC_IS_FW_FILENAME		"exynos4_fimc_is_fw.bin"
+#define FIMC_IS_SETFILE_6A3		"exynos4_s5k6a3_setfile.bin"
 
 #define FIMC_IS_FW_LOAD_TIMEOUT		1000 /* ms */
 #define FIMC_IS_POWER_ON_TIMEOUT	1000 /* us */
-- 
1.7.9.5

