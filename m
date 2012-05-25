Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:46844 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932263Ab2EYTxL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 May 2012 15:53:11 -0400
Date: Fri, 25 May 2012 21:52:50 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [RFC/PATCH 11/13] media: s5p-fimc: Keep local copy of sensors platform
 data
In-reply-to: <1337975573-27117-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	s.nawrocki@samsung.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org, b.zolnierkie@samsung.com
Message-id: <1337975573-27117-11-git-send-email-s.nawrocki@samsung.com>
Content-transfer-encoding: 7BIT
References: <4FBFE1EC.9060209@samsung.com>
 <1337975573-27117-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use a copy of sensor platform data structure, rather than referencing
external platform data from the driver. This allows to fill the local
copy with values parsed from device tree when needed.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |    6 +++---
 drivers/media/video/s5p-fimc/fimc-lite.c    |    2 +-
 drivers/media/video/s5p-fimc/fimc-mdevice.c |   18 +++++++++---------
 drivers/media/video/s5p-fimc/fimc-mdevice.h |    2 +-
 4 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 7585b2f..ec259fb 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -50,9 +50,9 @@ static int fimc_capture_hw_init(struct fimc_dev *fimc)
 	fimc_prepare_dma_offset(ctx, &ctx->d_frame);
 	fimc_set_yuv_order(ctx);
 
-	fimc_hw_set_camera_polarity(fimc, sensor->pdata);
-	fimc_hw_set_camera_type(fimc, sensor->pdata);
-	fimc_hw_set_camera_source(fimc, sensor->pdata);
+	fimc_hw_set_camera_polarity(fimc, &sensor->pdata);
+	fimc_hw_set_camera_type(fimc, &sensor->pdata);
+	fimc_hw_set_camera_source(fimc, &sensor->pdata);
 	fimc_hw_set_camera_offset(fimc, &ctx->s_frame);
 
 	ret = fimc_set_scaler_info(ctx);
diff --git a/drivers/media/video/s5p-fimc/fimc-lite.c b/drivers/media/video/s5p-fimc/fimc-lite.c
index a7ae149..4ee5b70 100644
--- a/drivers/media/video/s5p-fimc/fimc-lite.c
+++ b/drivers/media/video/s5p-fimc/fimc-lite.c
@@ -165,7 +165,7 @@ static int fimc_lite_hw_init(struct fimc_lite *fimc)
 	sensor = v4l2_get_subdev_hostdata(pipeline->subdevs[IDX_SENSOR]);
 	spin_lock_irqsave(&fimc->slock, flags);
 
-	flite_hw_set_camera_bus(fimc, sensor->pdata);
+	flite_hw_set_camera_bus(fimc, &sensor->pdata);
 	flite_hw_set_source_format(fimc, &fimc->inp_frame);
 	flite_hw_set_window_offset(fimc, &fimc->inp_frame);
 	flite_hw_set_output_dma(fimc, &fimc->out_frame, true);
diff --git a/drivers/media/video/s5p-fimc/fimc-mdevice.c b/drivers/media/video/s5p-fimc/fimc-mdevice.c
index 92c9887..1b3b13c 100644
--- a/drivers/media/video/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/video/s5p-fimc/fimc-mdevice.c
@@ -244,27 +244,27 @@ static struct v4l2_subdev *fimc_md_register_sensor(struct fimc_md *fmd,
 	if (!s_info || !fmd)
 		return NULL;
 
-	adapter = i2c_get_adapter(s_info->pdata->i2c_bus_num);
+	adapter = i2c_get_adapter(s_info->pdata.i2c_bus_num);
 	if (!adapter) {
 		v4l2_warn(&fmd->v4l2_dev,
 			  "Failed to get I2C adapter %d, deferring probe\n",
-			  s_info->pdata->i2c_bus_num);
+			  s_info->pdata.i2c_bus_num);
 		return ERR_PTR(-EPROBE_DEFER);
 	}
 	sd = v4l2_i2c_new_subdev_board(&fmd->v4l2_dev, adapter,
-				       s_info->pdata->board_info, NULL);
+				       s_info->pdata.board_info, NULL);
 	if (IS_ERR_OR_NULL(sd)) {
 		i2c_put_adapter(adapter);
 		v4l2_warn(&fmd->v4l2_dev,
 			  "Failed to acquire subdev %s, deferring probe\n",
-			  s_info->pdata->board_info->type);
+			  s_info->pdata.board_info->type);
 		return ERR_PTR(-EPROBE_DEFER);
 	}
 	v4l2_set_subdev_hostdata(sd, s_info);
 	sd->grp_id = SENSOR_GROUP_ID;
 
 	v4l2_info(&fmd->v4l2_dev, "Registered sensor subdevice %s\n",
-		  s_info->pdata->board_info->type);
+		  s_info->pdata.board_info->type);
 	return sd;
 }
 
@@ -308,7 +308,7 @@ static int fimc_md_register_sensor_entities(struct fimc_md *fmd)
 	for (i = 0; i < num_clients; i++) {
 		struct v4l2_subdev *sd;
 
-		fmd->sensor[i].pdata = &pdata->isp_info[i];
+		fmd->sensor[i].pdata = pdata->isp_info[i];
 		ret = __fimc_md_set_camclk(fmd, &fmd->sensor[i], true);
 		if (ret)
 			break;
@@ -713,11 +713,11 @@ static int fimc_md_create_links(struct fimc_md *fmd)
 
 		sensor = fmd->sensor[i].subdev;
 		s_info = v4l2_get_subdev_hostdata(sensor);
-		if (!s_info || !s_info->pdata)
+		if (!s_info)
 			continue;
 
 		source = NULL;
-		pdata = s_info->pdata;
+		pdata = &s_info->pdata;
 
 		switch (pdata->bus_type) {
 		case FIMC_MIPI_CSI2:
@@ -827,7 +827,7 @@ static int __fimc_md_set_camclk(struct fimc_md *fmd,
 					 struct fimc_sensor_info *s_info,
 					 bool on)
 {
-	struct s5p_fimc_isp_info *pdata = s_info->pdata;
+	struct s5p_fimc_isp_info *pdata = &s_info->pdata;
 	struct fimc_camclk_info *camclk;
 	int ret = 0;
 
diff --git a/drivers/media/video/s5p-fimc/fimc-mdevice.h b/drivers/media/video/s5p-fimc/fimc-mdevice.h
index 3b8a349..bba85bf 100644
--- a/drivers/media/video/s5p-fimc/fimc-mdevice.h
+++ b/drivers/media/video/s5p-fimc/fimc-mdevice.h
@@ -52,7 +52,7 @@ struct fimc_camclk_info {
  * This data structure applies to image sensor and the writeback subdevs.
  */
 struct fimc_sensor_info {
-	struct s5p_fimc_isp_info *pdata;
+	struct s5p_fimc_isp_info pdata;
 	struct v4l2_subdev *subdev;
 	struct fimc_dev *host;
 	bool clk_on;
-- 
1.7.10

