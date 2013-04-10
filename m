Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:23170 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746Ab3DJKnh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Apr 2013 06:43:37 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, linux-samsung-soc@vger.kernel.org,
	shaik.samsung@gmail.com, arun.kk@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 1/7] exynos4-is: Move the subdev group ID definitions to public
 header
Date: Wed, 10 Apr 2013 12:42:36 +0200
Message-id: <1365590562-5747-2-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1365590562-5747-1-git-send-email-s.nawrocki@samsung.com>
References: <1365590562-5747-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move the sub-device group ID definitions to the driver's public header
so they are available to other media drivers that need to share modules
found in exynos4-is.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/media-dev.h |    9 ---------
 include/media/s5p_fimc.h                      |   11 +++++++++++
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/media-dev.h b/drivers/media/platform/exynos4-is/media-dev.h
index 0b14cd5..7f126c3 100644
--- a/drivers/media/platform/exynos4-is/media-dev.h
+++ b/drivers/media/platform/exynos4-is/media-dev.h
@@ -30,15 +30,6 @@
 
 #define PINCTRL_STATE_IDLE	"idle"
 
-/* Group IDs of sensor, MIPI-CSIS, FIMC-LITE and the writeback subdevs. */
-#define GRP_ID_SENSOR		(1 << 8)
-#define GRP_ID_FIMC_IS_SENSOR	(1 << 9)
-#define GRP_ID_WRITEBACK	(1 << 10)
-#define GRP_ID_CSIS		(1 << 11)
-#define GRP_ID_FIMC		(1 << 12)
-#define GRP_ID_FLITE		(1 << 13)
-#define GRP_ID_FIMC_IS		(1 << 14)
-
 #define FIMC_MAX_SENSORS	8
 #define FIMC_MAX_CAMCLKS	2
 
diff --git a/include/media/s5p_fimc.h b/include/media/s5p_fimc.h
index e316d15..f509690 100644
--- a/include/media/s5p_fimc.h
+++ b/include/media/s5p_fimc.h
@@ -49,6 +49,17 @@ enum fimc_bus_type {
 #define fimc_input_is_parallel(x) ((x) == 1 || (x) == 2)
 #define fimc_input_is_mipi_csi(x) ((x) == 3 || (x) == 4)
 
+/*
+ * The subdevices' group IDs.
+ */
+#define GRP_ID_SENSOR		(1 << 8)
+#define GRP_ID_FIMC_IS_SENSOR	(1 << 9)
+#define GRP_ID_WRITEBACK	(1 << 10)
+#define GRP_ID_CSIS		(1 << 11)
+#define GRP_ID_FIMC		(1 << 12)
+#define GRP_ID_FLITE		(1 << 13)
+#define GRP_ID_FIMC_IS		(1 << 14)
+
 struct i2c_board_info;
 
 /**
-- 
1.7.9.5

