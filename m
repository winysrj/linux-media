Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:9954 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746Ab3DJKn6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Apr 2013 06:43:58 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, linux-samsung-soc@vger.kernel.org,
	shaik.samsung@gmail.com, arun.kk@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 3/7] exynos4-is: Make fimc-lite independent on struct
 fimc_sensor_info
Date: Wed, 10 Apr 2013 12:42:38 +0200
Message-id: <1365590562-5747-4-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1365590562-5747-1-git-send-email-s.nawrocki@samsung.com>
References: <1365590562-5747-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make the sensor subdevs host_data hold a pointer to struct fimc_source_info,
which is defined in the driver's public header, rather than a pointer to
struct fimc_sensor_info which is specific to exynos4-is media device driver.

The purpose of this change is to allow easier reuse of the fimc-lite module
in the exynos5-is driver, which should similarly store a pointer to struct
fimc_source_info instance in the sensor's subdev host_data.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-capture.c |    7 +-
 drivers/media/platform/exynos4-is/fimc-lite.c    |   10 ++-
 drivers/media/platform/exynos4-is/media-dev.c    |   74 +++++++++++-----------
 drivers/media/platform/exynos4-is/media-dev.h    |    6 ++
 4 files changed, 54 insertions(+), 43 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-capture.c b/drivers/media/platform/exynos4-is/fimc-capture.c
index 28c6b26..72c516a 100644
--- a/drivers/media/platform/exynos4-is/fimc-capture.c
+++ b/drivers/media/platform/exynos4-is/fimc-capture.c
@@ -1450,7 +1450,7 @@ static const struct media_entity_operations fimc_sd_media_ops = {
 void fimc_sensor_notify(struct v4l2_subdev *sd, unsigned int notification,
 			void *arg)
 {
-	struct fimc_sensor_info	*sensor;
+	struct fimc_source_info	*si;
 	struct fimc_vid_buffer *buf;
 	struct fimc_md *fmd;
 	struct fimc_dev *fimc;
@@ -1459,11 +1459,12 @@ void fimc_sensor_notify(struct v4l2_subdev *sd, unsigned int notification,
 	if (sd == NULL)
 		return;
 
-	sensor = v4l2_get_subdev_hostdata(sd);
+	si = v4l2_get_subdev_hostdata(sd);
 	fmd = entity_to_fimc_mdev(&sd->entity);
 
 	spin_lock_irqsave(&fmd->slock, flags);
-	fimc = sensor ? sensor->host : NULL;
+
+	fimc = si ? source_to_sensor_info(si)->host : NULL;
 
 	if (fimc && arg && notification == S5P_FIMC_TX_END_NOTIFY &&
 	    test_bit(ST_CAPT_PEND, &fimc->state)) {
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index 3ea4fc7..661d0d1 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -11,6 +11,7 @@
 #define pr_fmt(fmt) "%s:%d " fmt, __func__, __LINE__
 
 #include <linux/bug.h>
+#include <linux/clk.h>
 #include <linux/device.h>
 #include <linux/errno.h>
 #include <linux/interrupt.h>
@@ -31,7 +32,7 @@
 #include <media/videobuf2-dma-contig.h>
 #include <media/s5p_fimc.h>
 
-#include "media-dev.h"
+#include "fimc-core.h"
 #include "fimc-lite.h"
 #include "fimc-lite-reg.h"
 
@@ -156,7 +157,7 @@ static struct v4l2_subdev *__find_remote_sensor(struct media_entity *me)
 
 static int fimc_lite_hw_init(struct fimc_lite *fimc, bool isp_output)
 {
-	struct fimc_sensor_info *si;
+	struct fimc_source_info *si;
 	unsigned long flags;
 
 	if (fimc->sensor == NULL)
@@ -167,9 +168,12 @@ static int fimc_lite_hw_init(struct fimc_lite *fimc, bool isp_output)
 
 	/* Get sensor configuration data from the sensor subdev */
 	si = v4l2_get_subdev_hostdata(fimc->sensor);
+	if (!si)
+		return -EINVAL;
+
 	spin_lock_irqsave(&fimc->slock, flags);
 
-	flite_hw_set_camera_bus(fimc, &si->pdata);
+	flite_hw_set_camera_bus(fimc, si);
 	flite_hw_set_source_format(fimc, &fimc->inp_frame);
 	flite_hw_set_window_offset(fimc, &fimc->inp_frame);
 	flite_hw_set_output_dma(fimc, &fimc->out_frame, !isp_output);
diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index 44d6c1d..1dbd554 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -37,7 +37,7 @@
 #include "mipi-csis.h"
 
 static int __fimc_md_set_camclk(struct fimc_md *fmd,
-				struct fimc_sensor_info *s_info,
+				struct fimc_source_info *si,
 				bool on);
 /**
  * fimc_pipeline_prepare - update pipeline information with subdevice pointers
@@ -281,36 +281,36 @@ static const struct fimc_pipeline_ops fimc_pipeline_ops = {
  * Sensor subdevice helper functions
  */
 static struct v4l2_subdev *fimc_md_register_sensor(struct fimc_md *fmd,
-				   struct fimc_sensor_info *s_info)
+						struct fimc_source_info *si)
 {
 	struct i2c_adapter *adapter;
 	struct v4l2_subdev *sd = NULL;
 
-	if (!s_info || !fmd)
+	if (!si || !fmd)
 		return NULL;
 	/*
 	 * If FIMC bus type is not Writeback FIFO assume it is same
 	 * as sensor_bus_type.
 	 */
-	s_info->pdata.fimc_bus_type = s_info->pdata.sensor_bus_type;
+	si->fimc_bus_type = si->sensor_bus_type;
 
-	adapter = i2c_get_adapter(s_info->pdata.i2c_bus_num);
+	adapter = i2c_get_adapter(si->i2c_bus_num);
 	if (!adapter) {
 		v4l2_warn(&fmd->v4l2_dev,
 			  "Failed to get I2C adapter %d, deferring probe\n",
-			  s_info->pdata.i2c_bus_num);
+			  si->i2c_bus_num);
 		return ERR_PTR(-EPROBE_DEFER);
 	}
 	sd = v4l2_i2c_new_subdev_board(&fmd->v4l2_dev, adapter,
-				       s_info->pdata.board_info, NULL);
+						si->board_info, NULL);
 	if (IS_ERR_OR_NULL(sd)) {
 		i2c_put_adapter(adapter);
 		v4l2_warn(&fmd->v4l2_dev,
 			  "Failed to acquire subdev %s, deferring probe\n",
-			  s_info->pdata.board_info->type);
+			  si->board_info->type);
 		return ERR_PTR(-EPROBE_DEFER);
 	}
-	v4l2_set_subdev_hostdata(sd, s_info);
+	v4l2_set_subdev_hostdata(sd, si);
 	sd->grp_id = GRP_ID_SENSOR;
 
 	v4l2_info(&fmd->v4l2_dev, "Registered sensor subdevice %s\n",
@@ -365,17 +365,17 @@ static int fimc_md_of_add_sensor(struct fimc_md *fmd,
 	}
 
 	/* Enable sensor's master clock */
-	ret = __fimc_md_set_camclk(fmd, si, true);
+	ret = __fimc_md_set_camclk(fmd, &si->pdata, true);
 	if (ret < 0)
 		goto mod_put;
 	sd = i2c_get_clientdata(client);
 
 	ret = v4l2_device_register_subdev(&fmd->v4l2_dev, sd);
-	__fimc_md_set_camclk(fmd, si, false);
+	__fimc_md_set_camclk(fmd, &si->pdata, false);
 	if (ret < 0)
 		goto mod_put;
 
-	v4l2_set_subdev_hostdata(sd, si);
+	v4l2_set_subdev_hostdata(sd, &si->pdata);
 	if (si->pdata.fimc_bus_type == FIMC_BUS_TYPE_ISP_WRITEBACK)
 		sd->grp_id = GRP_ID_FIMC_IS_SENSOR;
 	else
@@ -559,21 +559,22 @@ static int fimc_md_register_sensor_entities(struct fimc_md *fmd)
 		fmd->num_sensors = num_clients;
 
 		for (i = 0; i < num_clients; i++) {
+			struct fimc_sensor_info *si = &fmd->sensor[i];
 			struct v4l2_subdev *sd;
 
-			fmd->sensor[i].pdata = pdata->source_info[i];
-			ret = __fimc_md_set_camclk(fmd, &fmd->sensor[i], true);
+			si->pdata = pdata->source_info[i];
+			ret = __fimc_md_set_camclk(fmd, &si->pdata, true);
 			if (ret)
 				break;
-			sd = fimc_md_register_sensor(fmd, &fmd->sensor[i]);
-			ret = __fimc_md_set_camclk(fmd, &fmd->sensor[i], false);
+			sd = fimc_md_register_sensor(fmd, &si->pdata);
+			ret = __fimc_md_set_camclk(fmd, &si->pdata, false);
 
 			if (IS_ERR(sd)) {
-				fmd->sensor[i].subdev = NULL;
+				si->subdev = NULL;
 				ret = PTR_ERR(sd);
 				break;
 			}
-			fmd->sensor[i].subdev = sd;
+			si->subdev = sd;
 			if (ret)
 				break;
 		}
@@ -838,7 +839,7 @@ static int __fimc_md_create_fimc_sink_links(struct fimc_md *fmd,
 					    struct v4l2_subdev *sensor,
 					    int pad, int link_mask)
 {
-	struct fimc_sensor_info *si = NULL;
+	struct fimc_source_info *si = NULL;
 	struct media_entity *sink;
 	unsigned int flags = 0;
 	int i, ret = 0;
@@ -846,7 +847,7 @@ static int __fimc_md_create_fimc_sink_links(struct fimc_md *fmd,
 	if (sensor) {
 		si = v4l2_get_subdev_hostdata(sensor);
 		/* Skip direct FIMC links in the logical FIMC-IS sensor path */
-		if (si && si->pdata.fimc_bus_type == FIMC_BUS_TYPE_ISP_WRITEBACK)
+		if (si && si->fimc_bus_type == FIMC_BUS_TYPE_ISP_WRITEBACK)
 			ret = 1;
 	}
 
@@ -882,8 +883,10 @@ static int __fimc_md_create_fimc_sink_links(struct fimc_md *fmd,
 
 		if (!WARN_ON(si == NULL)) {
 			unsigned long irq_flags;
+			struct fimc_sensor_info *inf = source_to_sensor_info(si);
+
 			spin_lock_irqsave(&fmd->slock, irq_flags);
-			si->host = fmd->fimc[i];
+			inf->host = fmd->fimc[i];
 			spin_unlock_irqrestore(&fmd->slock, irq_flags);
 		}
 	}
@@ -980,7 +983,6 @@ static int fimc_md_create_links(struct fimc_md *fmd)
 	struct v4l2_subdev *csi_sensors[CSIS_MAX_ENTITIES] = { NULL };
 	struct v4l2_subdev *sensor, *csis;
 	struct fimc_source_info *pdata;
-	struct fimc_sensor_info *s_info;
 	struct media_entity *source, *sink;
 	int i, pad, fimc_id = 0, ret = 0;
 	u32 flags, link_mask = 0;
@@ -990,12 +992,11 @@ static int fimc_md_create_links(struct fimc_md *fmd)
 			continue;
 
 		sensor = fmd->sensor[i].subdev;
-		s_info = v4l2_get_subdev_hostdata(sensor);
-		if (!s_info)
+		pdata = v4l2_get_subdev_hostdata(sensor);
+		if (!pdata)
 			continue;
 
 		source = NULL;
-		pdata = &s_info->pdata;
 
 		switch (pdata->sensor_bus_type) {
 		case FIMC_BUS_TYPE_MIPI_CSI2:
@@ -1164,34 +1165,33 @@ static int fimc_md_get_clocks(struct fimc_md *fmd)
 }
 
 static int __fimc_md_set_camclk(struct fimc_md *fmd,
-				struct fimc_sensor_info *s_info,
+				struct fimc_source_info *si,
 				bool on)
 {
-	struct fimc_source_info *pdata = &s_info->pdata;
 	struct fimc_camclk_info *camclk;
 	int ret = 0;
 
-	if (WARN_ON(pdata->clk_id >= FIMC_MAX_CAMCLKS) || !fmd || !fmd->pmf)
+	if (WARN_ON(si->clk_id >= FIMC_MAX_CAMCLKS) || !fmd || !fmd->pmf)
 		return -EINVAL;
 
-	camclk = &fmd->camclk[pdata->clk_id];
+	camclk = &fmd->camclk[si->clk_id];
 
 	dbg("camclk %d, f: %lu, use_count: %d, on: %d",
-	    pdata->clk_id, pdata->clk_frequency, camclk->use_count, on);
+	    si->clk_id, si->clk_frequency, camclk->use_count, on);
 
 	if (on) {
 		if (camclk->use_count > 0 &&
-		    camclk->frequency != pdata->clk_frequency)
+		    camclk->frequency != si->clk_frequency)
 			return -EINVAL;
 
 		if (camclk->use_count++ == 0) {
-			clk_set_rate(camclk->clock, pdata->clk_frequency);
-			camclk->frequency = pdata->clk_frequency;
+			clk_set_rate(camclk->clock, si->clk_frequency);
+			camclk->frequency = si->clk_frequency;
 			ret = pm_runtime_get_sync(fmd->pmf);
 			if (ret < 0)
 				return ret;
 			ret = clk_enable(camclk->clock);
-			dbg("Enabled camclk %d: f: %lu", pdata->clk_id,
+			dbg("Enabled camclk %d: f: %lu", si->clk_id,
 			    clk_get_rate(camclk->clock));
 		}
 		return ret;
@@ -1203,7 +1203,7 @@ static int __fimc_md_set_camclk(struct fimc_md *fmd,
 	if (--camclk->use_count == 0) {
 		clk_disable(camclk->clock);
 		pm_runtime_put(fmd->pmf);
-		dbg("Disabled camclk %d", pdata->clk_id);
+		dbg("Disabled camclk %d", si->clk_id);
 	}
 	return ret;
 }
@@ -1222,10 +1222,10 @@ static int __fimc_md_set_camclk(struct fimc_md *fmd,
  */
 int fimc_md_set_camclk(struct v4l2_subdev *sd, bool on)
 {
-	struct fimc_sensor_info *s_info = v4l2_get_subdev_hostdata(sd);
+	struct fimc_source_info *si = v4l2_get_subdev_hostdata(sd);
 	struct fimc_md *fmd = entity_to_fimc_mdev(&sd->entity);
 
-	return __fimc_md_set_camclk(fmd, s_info, on);
+	return __fimc_md_set_camclk(fmd, si, on);
 }
 
 static int fimc_md_link_notify(struct media_pad *source,
diff --git a/drivers/media/platform/exynos4-is/media-dev.h b/drivers/media/platform/exynos4-is/media-dev.h
index 7f126c3..44d86b6 100644
--- a/drivers/media/platform/exynos4-is/media-dev.h
+++ b/drivers/media/platform/exynos4-is/media-dev.h
@@ -115,6 +115,12 @@ struct fimc_md {
 
 #define subdev_has_devnode(__sd) (__sd->flags & V4L2_SUBDEV_FL_HAS_DEVNODE)
 
+static inline
+struct fimc_sensor_info *source_to_sensor_info(struct fimc_source_info *si)
+{
+	return container_of(si, struct fimc_sensor_info, pdata);
+}
+
 static inline struct fimc_md *entity_to_fimc_mdev(struct media_entity *me)
 {
 	return me->parent == NULL ? NULL :
-- 
1.7.9.5

