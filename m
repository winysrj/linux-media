Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:54571 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666Ab1LLRpL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Dec 2011 12:45:11 -0500
Received: from euspt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LW3000C7QN3JX@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 12 Dec 2011 17:45:03 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LW3003LEQN2H0@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 12 Dec 2011 17:45:03 +0000 (GMT)
Date: Mon, 12 Dec 2011 18:44:54 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 10/14] m5mols: Move the control handler initialization to
 probe()
In-reply-to: <1323711898-17162-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, s.nawrocki@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1323711898-17162-11-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1323711898-17162-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is prerequisite for enabling the sub-device node.

The control handler is now initialized in driver's probe callback
in order to allow the user space access controls before the device
power is enabled with s_power. This is needed due to s_power being
currently called only by the host driver.

It also adds the subdev internal operations, only open() for now
for the TRY format initialization.

Acked-by: HeungJun Kim <riverful.kim@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/m5mols/m5mols_core.c |   61 ++++++++++++++++++++++-------
 1 files changed, 46 insertions(+), 15 deletions(-)

diff --git a/drivers/media/video/m5mols/m5mols_core.c b/drivers/media/video/m5mols/m5mols_core.c
index 99a096de..8a935a3 100644
--- a/drivers/media/video/m5mols/m5mols_core.c
+++ b/drivers/media/video/m5mols/m5mols_core.c
@@ -699,16 +699,25 @@ static int m5mols_s_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct v4l2_subdev *sd = to_sd(ctrl);
 	struct m5mols_info *info = to_m5mols(sd);
-	int isp_state = info->mode;
-	int ret = 0;
+	int ispstate = info->mode;
+	int ret;
 
-	ret = m5mols_mode(info, REG_PARAMETER);
-	if (!ret)
-		ret = m5mols_set_ctrl(ctrl);
-	if (!ret)
-		ret = m5mols_mode(info, isp_state);
+	/*
+	 * If needed, defer restoring the controls until
+	 * the device is fully initialized.
+	 */
+	if (!info->isp_ready) {
+		info->ctrl_sync = 0;
+		return 0;
+	}
 
-	return ret;
+	ret = m5mols_mode(info, REG_PARAMETER);
+	if (ret < 0)
+		return ret;
+	ret = m5mols_set_ctrl(ctrl);
+	if (ret < 0)
+		return ret;
+	return m5mols_mode(info, ispstate);
 }
 
 static const struct v4l2_ctrl_ops m5mols_ctrl_ops = {
@@ -868,8 +877,6 @@ static int m5mols_s_power(struct v4l2_subdev *sd, int on)
 		ret = m5mols_sensor_power(info, true);
 		if (!ret)
 			ret = m5mols_fw_start(sd);
-		if (!ret)
-			ret = m5mols_init_controls(info);
 		if (ret)
 			return ret;
 
@@ -894,10 +901,7 @@ static int m5mols_s_power(struct v4l2_subdev *sd, int on)
 	}
 
 	ret = m5mols_sensor_power(info, false);
-	if (!ret) {
-		v4l2_ctrl_handler_free(&info->handle);
-		info->ctrl_sync = 0;
-	}
+	info->ctrl_sync = 0;
 
 	return ret;
 }
@@ -923,6 +927,21 @@ static const struct v4l2_subdev_core_ops m5mols_core_ops = {
 	.log_status	= m5mols_log_status,
 };
 
+/*
+ * V4L2 subdev internal operations
+ */
+static int m5mols_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
+{
+	struct v4l2_mbus_framefmt *format = v4l2_subdev_get_try_format(fh, 0);
+
+	*format = m5mols_default_ffmt[0];
+	return 0;
+}
+
+static const struct v4l2_subdev_internal_ops m5mols_subdev_internal_ops = {
+	.open		= m5mols_open,
+};
+
 static const struct v4l2_subdev_ops m5mols_ops = {
 	.core		= &m5mols_core_ops,
 	.pad		= &m5mols_pad_ops,
@@ -986,6 +1005,7 @@ static int __devinit m5mols_probe(struct i2c_client *client,
 	strlcpy(sd->name, MODULE_NAME, sizeof(sd->name));
 	v4l2_i2c_subdev_init(sd, client, &m5mols_ops);
 
+	sd->internal_ops = &m5mols_subdev_internal_ops;
 	info->pad.flags = MEDIA_PAD_FL_SOURCE;
 	ret = media_entity_init(&sd->entity, 1, &info->pad, 0);
 	if (ret < 0)
@@ -1002,7 +1022,17 @@ static int __devinit m5mols_probe(struct i2c_client *client,
 	info->res_type = M5MOLS_RESTYPE_MONITOR;
 	atomic_set(&info->irq_done, 0);
 
-	return 0;
+	ret = m5mols_sensor_power(info, true);
+	if (ret)
+		goto out_me;
+
+	ret = m5mols_fw_start(sd);
+	if (!ret)
+		ret = m5mols_init_controls(info);
+
+	m5mols_sensor_power(info, false);
+	if (!ret)
+		return 0;
 out_me:
 	media_entity_cleanup(&sd->entity);
 out_reg:
@@ -1020,6 +1050,7 @@ static int __devexit m5mols_remove(struct i2c_client *client)
 	struct m5mols_info *info = to_m5mols(sd);
 
 	v4l2_device_unregister_subdev(sd);
+	v4l2_ctrl_handler_free(sd->ctrl_handler);
 	free_irq(client->irq, sd);
 
 	regulator_bulk_free(ARRAY_SIZE(supplies), supplies);
-- 
1.7.8

