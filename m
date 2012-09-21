Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:16014 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932070Ab2IUJBi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Sep 2012 05:01:38 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 2/2] m5mols: Protect driver data with a mutex
Date: Fri, 21 Sep 2012 11:01:23 +0200
Message-id: <1348218083-32201-2-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1348218083-32201-1-git-send-email-s.nawrocki@samsung.com>
References: <1348218083-32201-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Without the locking the driver's data could get corrupted when the subdev
is accessed from user space and from host driver by multiple processes.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/m5mols/m5mols.h      | 18 +++++---
 drivers/media/video/m5mols/m5mols_core.c | 77 +++++++++++++++++++++-----------
 2 files changed, 62 insertions(+), 33 deletions(-)

diff --git a/drivers/media/video/m5mols/m5mols.h b/drivers/media/video/m5mols/m5mols.h
index bb58991..15d3a4f 100644
--- a/drivers/media/video/m5mols/m5mols.h
+++ b/drivers/media/video/m5mols/m5mols.h
@@ -155,8 +155,6 @@ struct m5mols_version {
  * @pdata: platform data
  * @sd: v4l-subdev instance
  * @pad: media pad
- * @ffmt: current fmt according to resolution type
- * @res_type: current resolution type
  * @irq_waitq: waitqueue for the capture
  * @irq_done: set to 1 in the interrupt handler
  * @handle: control handler
@@ -174,6 +172,10 @@ struct m5mols_version {
  * @wdr: wide dynamic range control
  * @stabilization: image stabilization control
  * @jpeg_quality: JPEG compression quality control
+ * @set_power: optional power callback to the board code
+ * @lock: mutex protecting the structure fields below
+ * @ffmt: current fmt according to resolution type
+ * @res_type: current resolution type
  * @ver: information of the version
  * @cap: the capture mode attributes
  * @isp_ready: 1 when the ISP controller has completed booting
@@ -181,14 +183,11 @@ struct m5mols_version {
  * @ctrl_sync: 1 when the control handler state is restored in H/W
  * @resolution:	register value for current resolution
  * @mode: register value for current operation mode
- * @set_power: optional power callback to the board code
  */
 struct m5mols_info {
 	const struct m5mols_platform_data *pdata;
 	struct v4l2_subdev sd;
 	struct media_pad pad;
-	struct v4l2_mbus_framefmt ffmt[M5MOLS_RESTYPE_MAX];
-	int res_type;
 
 	wait_queue_head_t irq_waitq;
 	atomic_t irq_done;
@@ -216,6 +215,13 @@ struct m5mols_info {
 	struct v4l2_ctrl *stabilization;
 	struct v4l2_ctrl *jpeg_quality;
 
+	int (*set_power)(struct device *dev, int on);
+
+	struct mutex lock;
+
+	struct v4l2_mbus_framefmt ffmt[M5MOLS_RESTYPE_MAX];
+	int res_type;
+
 	struct m5mols_version ver;
 	struct m5mols_capture cap;
 
@@ -225,8 +231,6 @@ struct m5mols_info {
 
 	u8 resolution;
 	u8 mode;
-
-	int (*set_power)(struct device *dev, int on);
 };
 
 #define is_available_af(__info)	(__info->ver.af)
diff --git a/drivers/media/video/m5mols/m5mols_core.c b/drivers/media/video/m5mols/m5mols_core.c
index cbb6381..5d108fe 100644
--- a/drivers/media/video/m5mols/m5mols_core.c
+++ b/drivers/media/video/m5mols/m5mols_core.c
@@ -551,13 +551,18 @@ static int m5mols_get_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 {
 	struct m5mols_info *info = to_m5mols(sd);
 	struct v4l2_mbus_framefmt *format;
+	int ret = 0;
+
+	mutex_lock(&info->lock);
 
 	format = __find_format(info, fh, fmt->which, info->res_type);
 	if (!format)
-		return -EINVAL;
+		fmt->format = *format;
+	else
+		ret = -EINVAL;
 
-	fmt->format = *format;
-	return 0;
+	mutex_unlock(&info->lock);
+	return ret;
 }
 
 static int m5mols_set_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
@@ -578,6 +583,7 @@ static int m5mols_set_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 	if (!sfmt)
 		return 0;
 
+	mutex_lock(&info->lock);
 
 	format->code = m5mols_default_ffmt[type].code;
 	format->colorspace = V4L2_COLORSPACE_JPEG;
@@ -589,7 +595,8 @@ static int m5mols_set_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 		info->res_type = type;
 	}
 
-	return 0;
+	mutex_unlock(&info->lock);
+	return ret;
 }
 
 static int m5mols_enum_mbus_code(struct v4l2_subdev *sd,
@@ -661,20 +668,25 @@ static int m5mols_start_monitor(struct m5mols_info *info)
 static int m5mols_s_stream(struct v4l2_subdev *sd, int enable)
 {
 	struct m5mols_info *info = to_m5mols(sd);
-	u32 code = info->ffmt[info->res_type].code;
+	u32 code;
+	int ret;
 
-	if (enable) {
-		int ret = -EINVAL;
+	mutex_lock(&info->lock);
+	code = info->ffmt[info->res_type].code;
 
+	if (enable) {
 		if (is_code(code, M5MOLS_RESTYPE_MONITOR))
 			ret = m5mols_start_monitor(info);
 		if (is_code(code, M5MOLS_RESTYPE_CAPTURE))
 			ret = m5mols_start_capture(info);
-
-		return ret;
+		else
+			ret = -EINVAL;
+	} else {
+		ret = m5mols_set_mode(info, REG_PARAMETER);
 	}
 
-	return m5mols_set_mode(info, REG_PARAMETER);
+	mutex_unlock(&info->lock);
+	return ret;
 }
 
 static const struct v4l2_subdev_video_ops m5mols_video_ops = {
@@ -773,6 +785,20 @@ static int m5mols_fw_start(struct v4l2_subdev *sd)
 	return ret;
 }
 
+/* Execute the lens soft-landing algorithm */
+static int m5mols_auto_focus_stop(struct m5mols_info *info)
+{
+	int ret;
+
+	ret = m5mols_write(&info->sd, AF_EXECUTE, REG_AF_STOP);
+	if (!ret)
+		ret = m5mols_write(&info->sd, AF_MODE, REG_AF_POWEROFF);
+	if (!ret)
+		ret = m5mols_busy_wait(&info->sd, SYSTEM_STATUS, REG_AF_IDLE,
+				       0xff, -1);
+	return ret;
+}
+
 /**
  * m5mols_s_power - Main sensor power control function
  *
@@ -785,29 +811,26 @@ static int m5mols_s_power(struct v4l2_subdev *sd, int on)
 	struct m5mols_info *info = to_m5mols(sd);
 	int ret;
 
+	mutex_lock(&info->lock);
+
 	if (on) {
 		ret = m5mols_sensor_power(info, true);
 		if (!ret)
 			ret = m5mols_fw_start(sd);
-		return ret;
-	}
+	} else {
+		if (is_manufacturer(info, REG_SAMSUNG_TECHWIN)) {
+			ret = m5mols_set_mode(info, REG_MONITOR);
+			if (!ret)
+				ret = m5mols_auto_focus_stop(info);
+			if (ret < 0)
+				v4l2_warn(sd, "Soft landing lens failed\n");
+		}
+		ret = m5mols_sensor_power(info, false);
 
-	if (is_manufacturer(info, REG_SAMSUNG_TECHWIN)) {
-		ret = m5mols_set_mode(info, REG_MONITOR);
-		if (!ret)
-			ret = m5mols_write(sd, AF_EXECUTE, REG_AF_STOP);
-		if (!ret)
-			ret = m5mols_write(sd, AF_MODE, REG_AF_POWEROFF);
-		if (!ret)
-			ret = m5mols_busy_wait(sd, SYSTEM_STATUS, REG_AF_IDLE,
-					       0xff, -1);
-		if (ret < 0)
-			v4l2_warn(sd, "Soft landing lens failed\n");
+		info->ctrl_sync = 0;
 	}
 
-	ret = m5mols_sensor_power(info, false);
-	info->ctrl_sync = 0;
-
+	mutex_unlock(&info->lock);
 	return ret;
 }
 
@@ -912,6 +935,8 @@ static int __devinit m5mols_probe(struct i2c_client *client,
 	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
 
 	init_waitqueue_head(&info->irq_waitq);
+	mutex_init(&info->lock);
+
 	ret = request_irq(client->irq, m5mols_irq_handler,
 			  IRQF_TRIGGER_RISING, MODULE_NAME, sd);
 	if (ret) {
-- 
1.7.11.3

