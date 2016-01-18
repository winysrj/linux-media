Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:56478 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755455AbcARQKp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jan 2016 11:10:45 -0500
Received: from epcpsbgm2new.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0O1500VVDOXSN310@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Tue, 19 Jan 2016 01:10:44 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: Jacek Anaszewski <j.anaszewski@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 2/3] exynos4-is: Open shouldn't fail when sensor entity is not
 linked
Date: Mon, 18 Jan 2016 17:10:26 +0100
Message-id: <1453133427-20793-3-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1453133427-20793-1-git-send-email-j.anaszewski@samsung.com>
References: <1453133427-20793-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In order to allow for automatic media device entities linking
from the level of libv4l plugin the open system call shouldn't
fail, as the libv4l plugins can begin their job not until it
succeeds.
This patch allows for leaving the  pipeline not linked on
open and postpones verifying it to the moment when streamon
callback is called.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/platform/exynos4-is/media-dev.c |   95 ++++++++++++++++++++-----
 1 file changed, 76 insertions(+), 19 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index 4f5586a..f4d822c 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -187,6 +187,37 @@ error:
 }
 
 /**
+ * __fimc_pipeline_enable - enable power of all pipeline subdevs
+ *			    and the sensor clock
+ * @ep: video pipeline structure
+ * @fmd: fimc media device
+ *
+ * Called with the graph mutex held.
+ */
+static int __fimc_pipeline_enable(struct exynos_media_pipeline *ep,
+				  struct fimc_md *fmd)
+{
+	struct fimc_pipeline *p = to_fimc_pipeline(ep);
+	int ret;
+
+	/* Enable PXLASYNC clock if this pipeline includes FIMC-IS */
+	if (!IS_ERR(fmd->wbclk[CLK_IDX_WB_B]) && p->subdevs[IDX_IS_ISP]) {
+		ret = clk_prepare_enable(fmd->wbclk[CLK_IDX_WB_B]);
+		if (ret < 0)
+			return ret;
+	}
+
+	ret = fimc_pipeline_s_power(p, 1);
+	if (!ret)
+		return 0;
+
+	if (!IS_ERR(fmd->wbclk[CLK_IDX_WB_B]) && p->subdevs[IDX_IS_ISP])
+		clk_disable_unprepare(fmd->wbclk[CLK_IDX_WB_B]);
+
+	return ret;
+}
+
+/**
  * __fimc_pipeline_open - update the pipeline information, enable power
  *                        of all pipeline subdevs and the sensor clock
  * @me: media entity to start graph walk with
@@ -200,7 +231,6 @@ static int __fimc_pipeline_open(struct exynos_media_pipeline *ep,
 	struct fimc_md *fmd = entity_to_fimc_mdev(me);
 	struct fimc_pipeline *p = to_fimc_pipeline(ep);
 	struct v4l2_subdev *sd;
-	int ret;
 
 	if (WARN_ON(p == NULL || me == NULL))
 		return -EINVAL;
@@ -209,24 +239,16 @@ static int __fimc_pipeline_open(struct exynos_media_pipeline *ep,
 		fimc_pipeline_prepare(p, me);
 
 	sd = p->subdevs[IDX_SENSOR];
-	if (sd == NULL)
-		return -EINVAL;
-
-	/* Disable PXLASYNC clock if this pipeline includes FIMC-IS */
-	if (!IS_ERR(fmd->wbclk[CLK_IDX_WB_B]) && p->subdevs[IDX_IS_ISP]) {
-		ret = clk_prepare_enable(fmd->wbclk[CLK_IDX_WB_B]);
-		if (ret < 0)
-			return ret;
-	}
-
-	ret = fimc_pipeline_s_power(p, 1);
-	if (!ret)
+	if (sd == NULL) {
+		pr_warn("%s(): No sensor subdev\n", __func__);
+		/*
+		 * Pipeline open cannot fail so as to make it possible
+		 * for the user space to configure the pipeline.
+		 */
 		return 0;
+	}
 
-	if (!IS_ERR(fmd->wbclk[CLK_IDX_WB_B]) && p->subdevs[IDX_IS_ISP])
-		clk_disable_unprepare(fmd->wbclk[CLK_IDX_WB_B]);
-
-	return ret;
+	return __fimc_pipeline_enable(ep, fmd);
 }
 
 /**
@@ -270,10 +292,43 @@ static int __fimc_pipeline_s_stream(struct exynos_media_pipeline *ep, bool on)
 		{ IDX_CSIS, IDX_FLITE, IDX_FIMC, IDX_SENSOR, IDX_IS_ISP },
 	};
 	struct fimc_pipeline *p = to_fimc_pipeline(ep);
+	struct fimc_md *fmd = entity_to_fimc_mdev(&p->subdevs[IDX_CSIS]->entity);
+	enum fimc_subdev_index sd_id;
 	int i, ret = 0;
 
-	if (p->subdevs[IDX_SENSOR] == NULL)
-		return -ENODEV;
+	if (p->subdevs[IDX_SENSOR] == NULL) {
+		if (!fmd->user_subdev_api) {
+			/*
+			 * Sensor must be already discovered if we
+			 * aren't in the user_subdev_api mode
+			 */
+			return -ENODEV;
+		}
+
+		/* Get pipeline sink entity */
+		if (p->subdevs[IDX_FIMC])
+			sd_id = IDX_FIMC;
+		else if (p->subdevs[IDX_IS_ISP])
+			sd_id = IDX_IS_ISP;
+		else if (p->subdevs[IDX_FLITE])
+			sd_id = IDX_FLITE;
+		else
+			return -ENODEV;
+
+		/*
+		 * Sensor could have been linked between open and STREAMON -
+		 * check if this is the case.
+		 */
+		fimc_pipeline_prepare(p, &p->subdevs[sd_id]->entity);
+
+		if (p->subdevs[IDX_SENSOR] == NULL)
+			return -ENODEV;
+
+		ret = __fimc_pipeline_enable(ep, fmd);
+		if (ret < 0)
+			return ret;
+
+	}
 
 	for (i = 0; i < IDX_MAX; i++) {
 		unsigned int idx = seq[on][i];
@@ -283,8 +338,10 @@ static int __fimc_pipeline_s_stream(struct exynos_media_pipeline *ep, bool on)
 		if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
 			goto error;
 	}
+
 	return 0;
 error:
+	fimc_pipeline_s_power(p, !on);
 	for (; i >= 0; i--) {
 		unsigned int idx = seq[on][i];
 		v4l2_subdev_call(p->subdevs[idx], video, s_stream, !on);
-- 
1.7.9.5

