Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:57330 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754427Ab3CKTBF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 15:01:05 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
	shaik.samsung@gmail.com, arun.kk@samsung.com, a.hajda@samsung.com,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC 05/11] s5p-fimc: Add support for PIXELASYNCMx clocks
Date: Mon, 11 Mar 2013 20:00:20 +0100
Message-id: <1363028426-2771-6-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1363028426-2771-1-git-send-email-s.nawrocki@samsung.com>
References: <1363028426-2771-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch ads handling of clocks for the CAMBLK subsystem which
is a glue logic for FIMC-IS or LCD controller and FIMC IP.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-fimc/fimc-mdevice.c |   41 +++++++++++++++++++++++-
 drivers/media/platform/s5p-fimc/fimc-mdevice.h |    8 +++++
 2 files changed, 48 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-mdevice.c b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
index 0a7c95b..b9f9976 100644
--- a/drivers/media/platform/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
@@ -944,7 +944,7 @@ static int fimc_md_create_links(struct fimc_md *fmd)
 }
 
 /*
- * The peripheral sensor clock management.
+ * The peripheral sensor and CAM_BLK (PIXELASYNCMx) clocks management.
  */
 static void fimc_md_put_clocks(struct fimc_md *fmd)
 {
@@ -957,6 +957,17 @@ static void fimc_md_put_clocks(struct fimc_md *fmd)
 		clk_put(fmd->camclk[i].clock);
 		fmd->camclk[i].clock = ERR_PTR(-EINVAL);
 	}
+
+	/* Writeback (PIXELASYNCMx) clocks */
+	for (i = 0; i < FIMC_MAX_WBCLKS; i++) {
+		if (IS_ERR(fmd->wbclk[i]))
+			continue;
+		/* FIXME: find better place to disable this clock! */
+		clk_disable(fmd->wbclk[i]);
+		clk_unprepare(fmd->wbclk[i]);
+		clk_put(fmd->wbclk[i]);
+		fmd->wbclk[i] = ERR_PTR(-EINVAL);
+	}
 }
 
 static int fimc_md_get_clocks(struct fimc_md *fmd)
@@ -993,6 +1004,34 @@ static int fimc_md_get_clocks(struct fimc_md *fmd)
 	if (ret)
 		fimc_md_put_clocks(fmd);
 
+	if (!fmd->use_isp)
+		return 0;
+	/*
+	 * For now get only PIXELASYNCM1 clock (Writeback B/ISP),
+	 * leave PIXELASYNCM0 out for the display driver.
+	 */
+	for (i = CLK_IDX_WB_B; i < FIMC_MAX_WBCLKS; i++) {
+		snprintf(clk_name, sizeof(clk_name), "pxl_async%u", i);
+		clock = clk_get(dev, clk_name);
+		if (IS_ERR(clock)) {
+			v4l2_err(&fmd->v4l2_dev, "Failed to get clock: %s\n",
+				  clk_name);
+			ret = PTR_ERR(clock);
+			break;
+		}
+		ret = clk_prepare(clock);
+		if (ret < 0) {
+			clk_put(clock);
+			fmd->wbclk[i] = ERR_PTR(-EINVAL);
+			break;
+		}
+		fmd->wbclk[i] = clock;
+		/* FIXME: find better place to enable this clock! */
+		clk_enable(clock);
+	}
+	if (ret)
+		fimc_md_put_clocks(fmd);
+
 	return ret;
 }
 
diff --git a/drivers/media/platform/s5p-fimc/fimc-mdevice.h b/drivers/media/platform/s5p-fimc/fimc-mdevice.h
index 5d6146e..91be5db 100644
--- a/drivers/media/platform/s5p-fimc/fimc-mdevice.h
+++ b/drivers/media/platform/s5p-fimc/fimc-mdevice.h
@@ -41,6 +41,13 @@
 #define FIMC_MAX_SENSORS	8
 #define FIMC_MAX_CAMCLKS	2
 
+/* LCD/ISP Writeback clocks (PIXELASYNCMx) */
+enum {
+	CLK_IDX_WB_A,
+	CLK_IDX_WB_B,
+	FIMC_MAX_WBCLKS
+};
+
 struct fimc_csis_info {
 	struct v4l2_subdev *sd;
 	int id;
@@ -87,6 +94,7 @@ struct fimc_md {
 	struct fimc_sensor_info sensor[FIMC_MAX_SENSORS];
 	int num_sensors;
 	struct fimc_camclk_info camclk[FIMC_MAX_CAMCLKS];
+	struct clk *wbclk[FIMC_MAX_WBCLKS];
 	struct fimc_lite *fimc_lite[FIMC_LITE_MAX_DEVS];
 	struct fimc_dev *fimc[FIMC_MAX_DEVS];
 	struct media_device media_dev;
-- 
1.7.9.5

