Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-190.synserver.de ([212.40.185.190]:1127 "EHLO
	smtp-out-190.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755569AbbAWPwn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jan 2015 10:52:43 -0500
From: Lars-Peter Clausen <lars@metafoo.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Vladimir Barinov <vladimir.barinov@cogentembedded.com>,
	=?UTF-8?q?Richard=20R=C3=B6jfors?=
	<richard.rojfors@mocean-labs.com>,
	Federico Vaga <federico.vaga@gmail.com>,
	linux-media@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v2 07/15] [media] adv7180: Add media controller support
Date: Fri, 23 Jan 2015 16:52:26 +0100
Message-Id: <1422028354-31891-8-git-send-email-lars@metafoo.de>
In-Reply-To: <1422028354-31891-1-git-send-email-lars@metafoo.de>
References: <1422028354-31891-1-git-send-email-lars@metafoo.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add media controller support to the adv7180 driver by registering a media
entity instance for it as well as implementing pad ops for configuring the
format.

As there currently don't seem to be any users of the video ops format
operations those are removed as well in this patch.

Also set the V4L2_SUBDEV_FL_HAS_DEVNODE flag for the subdevice so it is
possible to create a subdevice device node.

Since the driver now depends on VIDEO_V4L2_SUBDEV_API all drivers which
select the driver need to depend on that symbol as well.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/Kconfig         |  2 +-
 drivers/media/i2c/adv7180.c       | 50 +++++++++++++++++++++++++++++++--------
 drivers/media/pci/sta2x11/Kconfig |  1 +
 drivers/media/platform/Kconfig    |  2 +-
 4 files changed, 43 insertions(+), 12 deletions(-)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index ca84543..f37890a 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -177,7 +177,7 @@ comment "Video decoders"
 
 config VIDEO_ADV7180
 	tristate "Analog Devices ADV7180 decoder"
-	depends on VIDEO_V4L2 && I2C
+	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
 	---help---
 	  Support for the Analog Devices ADV7180 video decoder.
 
diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index eeb5a4a..349cae3 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -124,6 +124,7 @@
 struct adv7180_state {
 	struct v4l2_ctrl_handler ctrl_hdl;
 	struct v4l2_subdev	sd;
+	struct media_pad	pad;
 	struct mutex		mutex; /* mutual excl. when accessing chip */
 	int			irq;
 	v4l2_std_id		curr_norm;
@@ -442,13 +443,14 @@ static void adv7180_exit_controls(struct adv7180_state *state)
 	v4l2_ctrl_handler_free(&state->ctrl_hdl);
 }
 
-static int adv7180_enum_mbus_fmt(struct v4l2_subdev *sd, unsigned int index,
-				 u32 *code)
+static int adv7180_enum_mbus_code(struct v4l2_subdev *sd,
+				  struct v4l2_subdev_fh *fh,
+				  struct v4l2_subdev_mbus_code_enum *code)
 {
-	if (index > 0)
+	if (code->index != 0)
 		return -EINVAL;
 
-	*code = MEDIA_BUS_FMT_YUYV8_2X8;
+	code->code = MEDIA_BUS_FMT_YUYV8_2X8;
 
 	return 0;
 }
@@ -467,6 +469,20 @@ static int adv7180_mbus_fmt(struct v4l2_subdev *sd,
 	return 0;
 }
 
+static int adv7180_get_pad_format(struct v4l2_subdev *sd,
+				  struct v4l2_subdev_fh *fh,
+				  struct v4l2_subdev_format *format)
+{
+	return adv7180_mbus_fmt(sd, &format->format);
+}
+
+static int adv7180_set_pad_format(struct v4l2_subdev *sd,
+				  struct v4l2_subdev_fh *fh,
+				  struct v4l2_subdev_format *format)
+{
+	return adv7180_mbus_fmt(sd, &format->format);
+}
+
 static int adv7180_g_mbus_config(struct v4l2_subdev *sd,
 				 struct v4l2_mbus_config *cfg)
 {
@@ -486,10 +502,6 @@ static const struct v4l2_subdev_video_ops adv7180_video_ops = {
 	.querystd = adv7180_querystd,
 	.g_input_status = adv7180_g_input_status,
 	.s_routing = adv7180_s_routing,
-	.enum_mbus_fmt = adv7180_enum_mbus_fmt,
-	.try_mbus_fmt = adv7180_mbus_fmt,
-	.g_mbus_fmt = adv7180_mbus_fmt,
-	.s_mbus_fmt = adv7180_mbus_fmt,
 	.g_mbus_config = adv7180_g_mbus_config,
 };
 
@@ -497,9 +509,16 @@ static const struct v4l2_subdev_core_ops adv7180_core_ops = {
 	.s_power = adv7180_s_power,
 };
 
+static const struct v4l2_subdev_pad_ops adv7180_pad_ops = {
+	.enum_mbus_code = adv7180_enum_mbus_code,
+	.set_fmt = adv7180_set_pad_format,
+	.get_fmt = adv7180_get_pad_format,
+};
+
 static const struct v4l2_subdev_ops adv7180_ops = {
 	.core = &adv7180_core_ops,
 	.video = &adv7180_video_ops,
+	.pad = &adv7180_pad_ops,
 };
 
 static irqreturn_t adv7180_irq(int irq, void *devid)
@@ -630,20 +649,28 @@ static int adv7180_probe(struct i2c_client *client,
 	state->input = 0;
 	sd = &state->sd;
 	v4l2_i2c_subdev_init(sd, client, &adv7180_ops);
+	sd->flags = V4L2_SUBDEV_FL_HAS_DEVNODE;
 
 	ret = adv7180_init_controls(state);
 	if (ret)
 		goto err_unreg_subdev;
-	ret = init_device(state);
+
+	state->pad.flags = MEDIA_PAD_FL_SOURCE;
+	sd->entity.flags |= MEDIA_ENT_T_V4L2_SUBDEV_DECODER;
+	ret = media_entity_init(&sd->entity, 1, &state->pad, 0);
 	if (ret)
 		goto err_free_ctrl;
 
+	ret = init_device(state);
+	if (ret)
+		goto err_media_entity_cleanup;
+
 	if (state->irq) {
 		ret = request_threaded_irq(client->irq, NULL, adv7180_irq,
 					   IRQF_ONESHOT | IRQF_TRIGGER_FALLING,
 					   KBUILD_MODNAME, state);
 		if (ret)
-			goto err_free_ctrl;
+			goto err_media_entity_cleanup;
 	}
 
 	ret = v4l2_async_register_subdev(sd);
@@ -655,6 +682,8 @@ static int adv7180_probe(struct i2c_client *client,
 err_free_irq:
 	if (state->irq > 0)
 		free_irq(client->irq, state);
+err_media_entity_cleanup:
+	media_entity_cleanup(&sd->entity);
 err_free_ctrl:
 	adv7180_exit_controls(state);
 err_unreg_subdev:
@@ -673,6 +702,7 @@ static int adv7180_remove(struct i2c_client *client)
 	if (state->irq > 0)
 		free_irq(client->irq, state);
 
+	media_entity_cleanup(&sd->entity);
 	adv7180_exit_controls(state);
 	mutex_destroy(&state->mutex);
 	return 0;
diff --git a/drivers/media/pci/sta2x11/Kconfig b/drivers/media/pci/sta2x11/Kconfig
index f6f30ab..e03587b 100644
--- a/drivers/media/pci/sta2x11/Kconfig
+++ b/drivers/media/pci/sta2x11/Kconfig
@@ -5,6 +5,7 @@ config STA2X11_VIP
 	select VIDEO_ADV7180 if MEDIA_SUBDRV_AUTOSELECT
 	select VIDEOBUF2_DMA_CONTIG
 	depends on PCI && VIDEO_V4L2 && VIRT_TO_BUS
+	depends on VIDEO_V4L2_SUBDEV_API
 	depends on I2C
 	help
 	  Say Y for support for STA2X11 VIP (Video Input Port) capture
diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 71e8873..d446b66 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -56,7 +56,7 @@ config VIDEO_VIU
 
 config VIDEO_TIMBERDALE
 	tristate "Support for timberdale Video In/LogiWIN"
-	depends on VIDEO_V4L2 && I2C && DMADEVICES
+	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API && DMADEVICES
 	depends on MFD_TIMBERDALE || COMPILE_TEST
 	select DMA_ENGINE
 	select TIMB_DMA
-- 
1.8.0

