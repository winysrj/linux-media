Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3949 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754510Ab0DZHec (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Apr 2010 03:34:32 -0400
Message-Id: <4c6d499bd8745f397e2a6433f52f8b95b49fe04f.1272267137.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1272267136.git.hverkuil@xs4all.nl>
References: <cover.1272267136.git.hverkuil@xs4all.nl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Mon, 26 Apr 2010 09:34:17 +0200
Subject: [PATCH 14/15] [RFC] ivtv: convert gpio subdev to new control framework.
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/ivtv/ivtv-driver.c |    1 +
 drivers/media/video/ivtv/ivtv-driver.h |    1 +
 drivers/media/video/ivtv/ivtv-gpio.c   |   77 +++++++++++++++-----------------
 3 files changed, 38 insertions(+), 41 deletions(-)

diff --git a/drivers/media/video/ivtv/ivtv-driver.c b/drivers/media/video/ivtv/ivtv-driver.c
index 85aab0e..1232d92 100644
--- a/drivers/media/video/ivtv/ivtv-driver.c
+++ b/drivers/media/video/ivtv/ivtv-driver.c
@@ -1370,6 +1370,7 @@ static void ivtv_remove(struct pci_dev *pdev)
 	printk(KERN_INFO "ivtv: Removed %s\n", itv->card_name);
 
 	v4l2_device_unregister(&itv->v4l2_dev);
+	v4l2_ctrl_handler_free(&itv->hdl_gpio);
 	kfree(itv);
 }
 
diff --git a/drivers/media/video/ivtv/ivtv-driver.h b/drivers/media/video/ivtv/ivtv-driver.h
index bf05c34..0a85705 100644
--- a/drivers/media/video/ivtv/ivtv-driver.h
+++ b/drivers/media/video/ivtv/ivtv-driver.h
@@ -622,6 +622,7 @@ struct ivtv {
 
 	struct v4l2_device v4l2_dev;
 	struct v4l2_subdev sd_gpio;	/* GPIO sub-device */
+	struct v4l2_ctrl_handler hdl_gpio;
 	u16 instance;
 
 	/* High-level state info */
diff --git a/drivers/media/video/ivtv/ivtv-gpio.c b/drivers/media/video/ivtv/ivtv-gpio.c
index aede061..463d58f 100644
--- a/drivers/media/video/ivtv/ivtv-gpio.c
+++ b/drivers/media/video/ivtv/ivtv-gpio.c
@@ -24,6 +24,7 @@
 #include "ivtv-gpio.h"
 #include "tuner-xc2028.h"
 #include <media/tuner.h>
+#include <media/v4l2-ctrls.h>
 
 /*
  * GPIO assignment of Yuan MPG600/MPG160
@@ -149,16 +150,10 @@ static inline struct ivtv *sd_to_ivtv(struct v4l2_subdev *sd)
 	return container_of(sd, struct ivtv, sd_gpio);
 }
 
-static struct v4l2_queryctrl gpio_ctrl_mute = {
-	.id            = V4L2_CID_AUDIO_MUTE,
-	.type          = V4L2_CTRL_TYPE_BOOLEAN,
-	.name          = "Mute",
-	.minimum       = 0,
-	.maximum       = 1,
-	.step          = 1,
-	.default_value = 1,
-	.flags         = 0,
-};
+static inline struct v4l2_subdev *to_sd(struct v4l2_ctrl *ctrl)
+{
+	return &container_of(ctrl->handler, struct ivtv, hdl_gpio)->sd_gpio;
+}
 
 static int subdev_s_clock_freq(struct v4l2_subdev *sd, u32 freq)
 {
@@ -262,40 +257,24 @@ static int subdev_s_audio_routing(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int subdev_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
+static int subdev_s_ctrl(struct v4l2_ctrl *ctrl)
 {
+	struct v4l2_subdev *sd = to_sd(ctrl);
 	struct ivtv *itv = sd_to_ivtv(sd);
 	u16 mask, data;
 
-	if (ctrl->id != V4L2_CID_AUDIO_MUTE)
-		return -EINVAL;
-	mask = itv->card->gpio_audio_mute.mask;
-	data = itv->card->gpio_audio_mute.mute;
-	ctrl->value = (read_reg(IVTV_REG_GPIO_OUT) & mask) == data;
-	return 0;
-}
-
-static int subdev_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
-{
-	struct ivtv *itv = sd_to_ivtv(sd);
-	u16 mask, data;
-
-	if (ctrl->id != V4L2_CID_AUDIO_MUTE)
-		return -EINVAL;
-	mask = itv->card->gpio_audio_mute.mask;
-	data = ctrl->value ? itv->card->gpio_audio_mute.mute : 0;
-	if (mask)
-		write_reg((read_reg(IVTV_REG_GPIO_OUT) & ~mask) | (data & mask), IVTV_REG_GPIO_OUT);
-	return 0;
+	switch (ctrl->id) {
+	case V4L2_CID_AUDIO_MUTE:
+		mask = itv->card->gpio_audio_mute.mask;
+		data = ctrl->val ? itv->card->gpio_audio_mute.mute : 0;
+		if (mask)
+			write_reg((read_reg(IVTV_REG_GPIO_OUT) & ~mask) |
+					(data & mask), IVTV_REG_GPIO_OUT);
+		return 0;
+	}
+	return -EINVAL;
 }
 
-static int subdev_queryctrl(struct v4l2_subdev *sd, struct v4l2_queryctrl *qc)
-{
-	if (qc->id != V4L2_CID_AUDIO_MUTE)
-		return -EINVAL;
-	*qc = gpio_ctrl_mute;
-	return 0;
-}
 
 static int subdev_log_status(struct v4l2_subdev *sd)
 {
@@ -304,6 +283,7 @@ static int subdev_log_status(struct v4l2_subdev *sd)
 	IVTV_INFO("GPIO status: DIR=0x%04x OUT=0x%04x IN=0x%04x\n",
 			read_reg(IVTV_REG_GPIO_DIR), read_reg(IVTV_REG_GPIO_OUT),
 			read_reg(IVTV_REG_GPIO_IN));
+	v4l2_ctrl_handler_log_status(&itv->hdl_gpio, sd->name);
 	return 0;
 }
 
@@ -327,11 +307,19 @@ static int subdev_s_video_routing(struct v4l2_subdev *sd,
 	return 0;
 }
 
+static const struct v4l2_ctrl_ops gpio_ctrl_ops = {
+	.s_ctrl = subdev_s_ctrl,
+};
+
 static const struct v4l2_subdev_core_ops subdev_core_ops = {
 	.log_status = subdev_log_status,
-	.g_ctrl = subdev_g_ctrl,
-	.s_ctrl = subdev_s_ctrl,
-	.queryctrl = subdev_queryctrl,
+	.g_ext_ctrls = v4l2_sd_g_ext_ctrls,
+	.try_ext_ctrls = v4l2_sd_try_ext_ctrls,
+	.s_ext_ctrls = v4l2_sd_s_ext_ctrls,
+	.g_ctrl = v4l2_sd_g_ctrl,
+	.s_ctrl = v4l2_sd_s_ctrl,
+	.queryctrl = v4l2_sd_queryctrl,
+	.querymenu = v4l2_sd_querymenu,
 };
 
 static const struct v4l2_subdev_tuner_ops subdev_tuner_ops = {
@@ -375,5 +363,12 @@ int ivtv_gpio_init(struct ivtv *itv)
 	v4l2_subdev_init(&itv->sd_gpio, &subdev_ops);
 	snprintf(itv->sd_gpio.name, sizeof(itv->sd_gpio.name), "%s-gpio", itv->v4l2_dev.name);
 	itv->sd_gpio.grp_id = IVTV_HW_GPIO;
+	v4l2_ctrl_handler_init(&itv->hdl_gpio, 1);
+	v4l2_ctrl_new_std(&itv->hdl_gpio, &gpio_ctrl_ops,
+			V4L2_CID_AUDIO_MUTE, 0, 1, 1, 0);
+	if (itv->hdl_gpio.error)
+		return itv->hdl_gpio.error;
+	itv->sd_gpio.ctrl_handler = &itv->hdl_gpio;
+	v4l2_ctrl_handler_setup(&itv->hdl_gpio);
 	return v4l2_device_register_subdev(&itv->v4l2_dev, &itv->sd_gpio);
 }
-- 
1.6.4.2

