Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:62484 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332Ab3CZRaW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Mar 2013 13:30:22 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
	dh09.lee@samsung.com, shaik.samsung@gmail.com, arun.kk@samsung.com,
	a.hajda@samsung.com, linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v2 04/10] s5p-fimc: Add support for PIXELASYNCMx clocks
Date: Tue, 26 Mar 2013 18:29:46 +0100
Message-id: <1364318992-20562-5-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1364318992-20562-1-git-send-email-s.nawrocki@samsung.com>
References: <1364318992-20562-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch ads handling of clocks for the CAMBLK subsystem which
is a glue logic for FIMC-IS or LCD controller and FIMC IP.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---

Changes since v1:

 - Do not keep PXLASYNC clocks always enabled. Enable PXLASYNC0
   clock only if video pipeline including FIMC-IS was opened.
   Enabling this clock only when it is actually used decreases
   power consumption a bit.
---
 drivers/media/platform/s5p-fimc/fimc-mdevice.c |   83 ++++++++++++++++++++----
 drivers/media/platform/s5p-fimc/fimc-mdevice.h |   10 +++
 2 files changed, 82 insertions(+), 11 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-mdevice.c b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
index abd3ad3..c5bc0d1 100644
--- a/drivers/media/platform/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
@@ -151,26 +151,48 @@ static int fimc_pipeline_s_power(struct fimc_pipeline *p, bool state)
  * __fimc_pipeline_open - update the pipeline information, enable power
  *                        of all pipeline subdevs and the sensor clock
  * @me: media entity to start graph walk with
- * @prep: true to acquire sensor (and csis) subdevs
+ * @prepare: true to walk the current pipeline and acquire all subdevs
  *
  * Called with the graph mutex held.
  */
 static int __fimc_pipeline_open(struct fimc_pipeline *p,
-				struct media_entity *me, bool prep)
+				struct media_entity *me, bool prepare)
 {
+	struct fimc_md *fmd = entity_to_fimc_mdev(me);
+	struct v4l2_subdev *sd;
 	int ret;
 
-	if (prep)
+	if (WARN_ON(p == NULL || me == NULL))
+		return -EINVAL;
+
+	if (prepare)
 		fimc_pipeline_prepare(p, me);
 
-	if (p->subdevs[IDX_SENSOR] == NULL)
+	sd = p->subdevs[IDX_SENSOR];
+	if (sd == NULL)
 		return -EINVAL;
 
-	ret = fimc_md_set_camclk(p->subdevs[IDX_SENSOR], true);
-	if (ret)
-		return ret;
+	/* Disable PXLASYNC clock if this pipeline includes FIMC-IS */
+	if (!IS_ERR(fmd->wbclk[CLK_IDX_WB_B]) && p->subdevs[IDX_IS_ISP]) {
+		ret = clk_prepare_enable(fmd->wbclk[CLK_IDX_WB_B]);
+		if (ret < 0)
+			return ret;
+	}
+	ret = fimc_md_set_camclk(sd, true);
+	if (ret < 0)
+		goto err_wbclk;
+
+	ret = fimc_pipeline_s_power(p, 1);
+	if (!ret)
+		return 0;
+
+	fimc_md_set_camclk(sd, false);
 
-	return fimc_pipeline_s_power(p, 1);
+err_wbclk:
+	if (!IS_ERR(fmd->wbclk[CLK_IDX_WB_B]) && p->subdevs[IDX_IS_ISP])
+		clk_disable_unprepare(fmd->wbclk[CLK_IDX_WB_B]);
+
+	return ret;
 }
 
 /**
@@ -181,15 +203,24 @@ static int __fimc_pipeline_open(struct fimc_pipeline *p,
  */
 static int __fimc_pipeline_close(struct fimc_pipeline *p)
 {
+	struct v4l2_subdev *sd = p ? p->subdevs[IDX_SENSOR] : NULL;
+	struct fimc_md *fmd;
 	int ret = 0;
 
-	if (!p || !p->subdevs[IDX_SENSOR])
+	if (WARN_ON(sd == NULL))
 		return -EINVAL;
 
 	if (p->subdevs[IDX_SENSOR]) {
 		ret = fimc_pipeline_s_power(p, 0);
-		fimc_md_set_camclk(p->subdevs[IDX_SENSOR], false);
+		fimc_md_set_camclk(sd, false);
 	}
+
+	fmd = entity_to_fimc_mdev(&sd->entity);
+
+	/* Disable PXLASYNC clock if this pipeline includes FIMC-IS */
+	if (!IS_ERR(fmd->wbclk[CLK_IDX_WB_B]) && p->subdevs[IDX_IS_ISP])
+		clk_disable_unprepare(fmd->wbclk[CLK_IDX_WB_B]);
+
 	return ret == -ENXIO ? 0 : ret;
 }
 
@@ -957,7 +988,7 @@ static int fimc_md_create_links(struct fimc_md *fmd)
 }
 
 /*
- * The peripheral sensor clock management.
+ * The peripheral sensor and CAM_BLK (PIXELASYNCMx) clocks management.
  */
 static void fimc_md_put_clocks(struct fimc_md *fmd)
 {
@@ -970,6 +1001,14 @@ static void fimc_md_put_clocks(struct fimc_md *fmd)
 		clk_put(fmd->camclk[i].clock);
 		fmd->camclk[i].clock = ERR_PTR(-EINVAL);
 	}
+
+	/* Writeback (PIXELASYNCMx) clocks */
+	for (i = 0; i < FIMC_MAX_WBCLKS; i++) {
+		if (IS_ERR(fmd->wbclk[i]))
+			continue;
+		clk_put(fmd->wbclk[i]);
+		fmd->wbclk[i] = ERR_PTR(-EINVAL);
+	}
 }
 
 static int fimc_md_get_clocks(struct fimc_md *fmd)
@@ -1006,6 +1045,28 @@ static int fimc_md_get_clocks(struct fimc_md *fmd)
 	if (ret)
 		fimc_md_put_clocks(fmd);
 
+	if (!fmd->use_isp)
+		return 0;
+	/*
+	 * For now get only PIXELASYNCM1 clock (Writeback B/ISP),
+	 * leave PIXELASYNCM0 out for the LCD Writeback driver.
+	 */
+	fmd->wbclk[CLK_IDX_WB_A] = ERR_PTR(-EINVAL);
+
+	for (i = CLK_IDX_WB_B; i < FIMC_MAX_WBCLKS; i++) {
+		snprintf(clk_name, sizeof(clk_name), "pxl_async%u", i);
+		clock = clk_get(dev, clk_name);
+		if (IS_ERR(clock)) {
+			v4l2_err(&fmd->v4l2_dev, "Failed to get clock: %s\n",
+				  clk_name);
+			ret = PTR_ERR(clock);
+			break;
+		}
+		fmd->wbclk[i] = clock;
+	}
+	if (ret)
+		fimc_md_put_clocks(fmd);
+
 	return ret;
 }
 
diff --git a/drivers/media/platform/s5p-fimc/fimc-mdevice.h b/drivers/media/platform/s5p-fimc/fimc-mdevice.h
index 5d6146e..46f3b82 100644
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
@@ -73,6 +80,7 @@ struct fimc_sensor_info {
  * @num_sensors: actual number of registered sensors
  * @camclk: external sensor clock information
  * @fimc: array of registered fimc devices
+ * @use_isp: set to true when FIMC-IS subsystem is used
  * @media_dev: top level media device
  * @v4l2_dev: top level v4l2_device holding up the subdevs
  * @pdev: platform device this media device is hooked up into
@@ -87,8 +95,10 @@ struct fimc_md {
 	struct fimc_sensor_info sensor[FIMC_MAX_SENSORS];
 	int num_sensors;
 	struct fimc_camclk_info camclk[FIMC_MAX_CAMCLKS];
+	struct clk *wbclk[FIMC_MAX_WBCLKS];
 	struct fimc_lite *fimc_lite[FIMC_LITE_MAX_DEVS];
 	struct fimc_dev *fimc[FIMC_MAX_DEVS];
+	bool use_isp;
 	struct media_device media_dev;
 	struct v4l2_device v4l2_dev;
 	struct platform_device *pdev;
-- 
1.7.9.5

