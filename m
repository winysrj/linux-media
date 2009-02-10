Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.tglx.de ([62.245.132.106]:49153 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754642AbZBJTcp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Feb 2009 14:32:45 -0500
Date: Tue, 10 Feb 2009 20:30:39 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: hvaibhav@ti.com
Cc: video4linux-list@redhat.com, mchehab@infradead.org,
	linux-media@vger.kernel.org
Subject: [PATCH v4] v4l/tvp514x: make the module aware of rich people
Message-ID: <20090210193039.GA13220@www.tglx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

because they might design two of those chips on a single board.
You never know.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
v4: fix checkpatch issues
v3: - addressed review comments
    - move tvp514x_slave into decoder struct it is used per device while
      registering / comparing
v2: Make the content of the registers (brightness, \ldots) per decoder
    and not global.
v1: Initial version

 drivers/media/video/tvp514x.c |  106 +++++++++++++++++++++++------------------
 1 files changed, 60 insertions(+), 46 deletions(-)

diff --git a/drivers/media/video/tvp514x.c b/drivers/media/video/tvp514x.c
index 8e23aa5..f8944d2 100644
--- a/drivers/media/video/tvp514x.c
+++ b/drivers/media/video/tvp514x.c
@@ -86,9 +86,12 @@ struct tvp514x_std_info {
 	struct v4l2_standard standard;
 };
 
+static struct tvp514x_reg tvp514x_reg_list_default[0x40];
 /**
- * struct tvp514x_decoded - TVP5146/47 decoder object
+ * struct tvp514x_decoder - TVP5146/47 decoder object
  * @v4l2_int_device: Slave handle
+ * @tvp514x_slave: Slave pointer which is used by @v4l2_int_device
+ * @tvp514x_regs: copy of hw's regs with preset values.
  * @pdata: Board specific
  * @client: I2C client data
  * @id: Entry from I2C table
@@ -103,7 +106,9 @@ struct tvp514x_std_info {
  * @route: input and output routing at chip level
  */
 struct tvp514x_decoder {
-	struct v4l2_int_device *v4l2_int_device;
+	struct v4l2_int_device v4l2_int_device;
+	struct v4l2_int_slave tvp514x_slave;
+	struct tvp514x_reg tvp514x_regs[ARRAY_SIZE(tvp514x_reg_list_default)];
 	const struct tvp514x_platform_data *pdata;
 	struct i2c_client *client;
 
@@ -124,7 +129,7 @@ struct tvp514x_decoder {
 };
 
 /* TVP514x default register values */
-static struct tvp514x_reg tvp514x_reg_list[] = {
+static struct tvp514x_reg tvp514x_reg_list_default[] = {
 	{TOK_WRITE, REG_INPUT_SEL, 0x05},	/* Composite selected */
 	{TOK_WRITE, REG_AFE_GAIN_CTRL, 0x0F},
 	{TOK_WRITE, REG_VIDEO_STD, 0x00},	/* Auto mode */
@@ -422,7 +427,7 @@ static int tvp514x_configure(struct tvp514x_decoder *decoder)
 
 	/* common register initialization */
 	err =
-	    tvp514x_write_regs(decoder->client, tvp514x_reg_list);
+	    tvp514x_write_regs(decoder->client, decoder->tvp514x_regs);
 	if (err)
 		return err;
 
@@ -580,7 +585,8 @@ static int ioctl_s_std(struct v4l2_int_device *s, v4l2_std_id *std_id)
 		return err;
 
 	decoder->current_std = i;
-	tvp514x_reg_list[REG_VIDEO_STD].val = decoder->std_list[i].video_std;
+	decoder->tvp514x_regs[REG_VIDEO_STD].val =
+		decoder->std_list[i].video_std;
 
 	v4l_dbg(1, debug, decoder->client, "Standard set to: %s",
 			decoder->std_list[i].standard.name);
@@ -625,8 +631,8 @@ static int ioctl_s_routing(struct v4l2_int_device *s,
 	if (err)
 		return err;
 
-	tvp514x_reg_list[REG_INPUT_SEL].val = input_sel;
-	tvp514x_reg_list[REG_OUTPUT_FORMATTER1].val = output_sel;
+	decoder->tvp514x_regs[REG_INPUT_SEL].val = input_sel;
+	decoder->tvp514x_regs[REG_OUTPUT_FORMATTER1].val = output_sel;
 
 	/* Clear status */
 	msleep(LOCK_RETRY_DELAY);
@@ -779,16 +785,16 @@ ioctl_g_ctrl(struct v4l2_int_device *s, struct v4l2_control *ctrl)
 
 	switch (ctrl->id) {
 	case V4L2_CID_BRIGHTNESS:
-		ctrl->value = tvp514x_reg_list[REG_BRIGHTNESS].val;
+		ctrl->value = decoder->tvp514x_regs[REG_BRIGHTNESS].val;
 		break;
 	case V4L2_CID_CONTRAST:
-		ctrl->value = tvp514x_reg_list[REG_CONTRAST].val;
+		ctrl->value = decoder->tvp514x_regs[REG_CONTRAST].val;
 		break;
 	case V4L2_CID_SATURATION:
-		ctrl->value = tvp514x_reg_list[REG_SATURATION].val;
+		ctrl->value = decoder->tvp514x_regs[REG_SATURATION].val;
 		break;
 	case V4L2_CID_HUE:
-		ctrl->value = tvp514x_reg_list[REG_HUE].val;
+		ctrl->value = decoder->tvp514x_regs[REG_HUE].val;
 		if (ctrl->value == 0x7F)
 			ctrl->value = 180;
 		else if (ctrl->value == 0x80)
@@ -798,7 +804,7 @@ ioctl_g_ctrl(struct v4l2_int_device *s, struct v4l2_control *ctrl)
 
 		break;
 	case V4L2_CID_AUTOGAIN:
-		ctrl->value = tvp514x_reg_list[REG_AFE_GAIN_CTRL].val;
+		ctrl->value = decoder->tvp514x_regs[REG_AFE_GAIN_CTRL].val;
 		if ((ctrl->value & 0x3) == 3)
 			ctrl->value = 1;
 		else
@@ -848,7 +854,7 @@ ioctl_s_ctrl(struct v4l2_int_device *s, struct v4l2_control *ctrl)
 				value);
 		if (err)
 			return err;
-		tvp514x_reg_list[REG_BRIGHTNESS].val = value;
+		decoder->tvp514x_regs[REG_BRIGHTNESS].val = value;
 		break;
 	case V4L2_CID_CONTRAST:
 		if (ctrl->value < 0 || ctrl->value > 255) {
@@ -861,7 +867,7 @@ ioctl_s_ctrl(struct v4l2_int_device *s, struct v4l2_control *ctrl)
 				value);
 		if (err)
 			return err;
-		tvp514x_reg_list[REG_CONTRAST].val = value;
+		decoder->tvp514x_regs[REG_CONTRAST].val = value;
 		break;
 	case V4L2_CID_SATURATION:
 		if (ctrl->value < 0 || ctrl->value > 255) {
@@ -874,7 +880,7 @@ ioctl_s_ctrl(struct v4l2_int_device *s, struct v4l2_control *ctrl)
 				value);
 		if (err)
 			return err;
-		tvp514x_reg_list[REG_SATURATION].val = value;
+		decoder->tvp514x_regs[REG_SATURATION].val = value;
 		break;
 	case V4L2_CID_HUE:
 		if (value == 180)
@@ -893,7 +899,7 @@ ioctl_s_ctrl(struct v4l2_int_device *s, struct v4l2_control *ctrl)
 				value);
 		if (err)
 			return err;
-		tvp514x_reg_list[REG_HUE].val = value;
+		decoder->tvp514x_regs[REG_HUE].val = value;
 		break;
 	case V4L2_CID_AUTOGAIN:
 		if (value == 1)
@@ -910,7 +916,7 @@ ioctl_s_ctrl(struct v4l2_int_device *s, struct v4l2_control *ctrl)
 				value);
 		if (err)
 			return err;
-		tvp514x_reg_list[REG_AFE_GAIN_CTRL].val = value;
+		decoder->tvp514x_regs[REG_AFE_GAIN_CTRL].val = value;
 		break;
 	default:
 		v4l_err(decoder->client,
@@ -1275,7 +1281,7 @@ static int ioctl_init(struct v4l2_int_device *s)
 	struct tvp514x_decoder *decoder = s->priv;
 
 	/* Set default standard to auto */
-	tvp514x_reg_list[REG_VIDEO_STD].val =
+	decoder->tvp514x_regs[REG_VIDEO_STD].val =
 	    VIDEO_STD_AUTO_SWITCH_BIT;
 
 	return tvp514x_configure(decoder);
@@ -1344,11 +1350,6 @@ static struct v4l2_int_ioctl_desc tvp514x_ioctl_desc[] = {
 		(v4l2_int_ioctl_func *) ioctl_s_routing},
 };
 
-static struct v4l2_int_slave tvp514x_slave = {
-	.ioctls = tvp514x_ioctl_desc,
-	.num_ioctls = ARRAY_SIZE(tvp514x_ioctl_desc),
-};
-
 static struct tvp514x_decoder tvp514x_dev = {
 	.state = STATE_NOT_DETECTED,
 
@@ -1369,17 +1370,15 @@ static struct tvp514x_decoder tvp514x_dev = {
 	.current_std = STD_NTSC_MJ,
 	.std_list = tvp514x_std_list,
 	.num_stds = ARRAY_SIZE(tvp514x_std_list),
-
-};
-
-static struct v4l2_int_device tvp514x_int_device = {
-	.module = THIS_MODULE,
-	.name = TVP514X_MODULE_NAME,
-	.priv = &tvp514x_dev,
-	.type = v4l2_int_type_slave,
-	.u = {
-	      .slave = &tvp514x_slave,
-	      },
+	.v4l2_int_device = {
+		.module = THIS_MODULE,
+		.name = TVP514X_MODULE_NAME,
+		.type = v4l2_int_type_slave,
+	},
+	.tvp514x_slave = {
+		.ioctls = tvp514x_ioctl_desc,
+		.num_ioctls = ARRAY_SIZE(tvp514x_ioctl_desc),
+	},
 };
 
 /**
@@ -1392,26 +1391,37 @@ static struct v4l2_int_device tvp514x_int_device = {
 static int
 tvp514x_probe(struct i2c_client *client, const struct i2c_device_id *id)
 {
-	struct tvp514x_decoder *decoder = &tvp514x_dev;
+	struct tvp514x_decoder *decoder;
 	int err;
 
 	/* Check if the adapter supports the needed features */
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
 		return -EIO;
 
-	decoder->pdata = client->dev.platform_data;
-	if (!decoder->pdata) {
+	decoder = kzalloc(sizeof(*decoder), GFP_KERNEL);
+	if (!decoder)
+		return -ENOMEM;
+
+	if (!client->dev.platform_data) {
 		v4l_err(client, "No platform data!!\n");
-		return -ENODEV;
+		err = -ENODEV;
+		goto out_free;
 	}
+
+	*decoder = tvp514x_dev;
+	decoder->v4l2_int_device.priv = decoder;
+	decoder->pdata = client->dev.platform_data;
+	decoder->v4l2_int_device.u.slave = &decoder->tvp514x_slave;
+	memcpy(decoder->tvp514x_regs, tvp514x_reg_list_default,
+			sizeof(tvp514x_reg_list_default));
 	/*
 	 * Fetch platform specific data, and configure the
 	 * tvp514x_reg_list[] accordingly. Since this is one
 	 * time configuration, no need to preserve.
 	 */
-	tvp514x_reg_list[REG_OUTPUT_FORMATTER2].val |=
+	decoder->tvp514x_regs[REG_OUTPUT_FORMATTER2].val |=
 			(decoder->pdata->clk_polarity << 1);
-	tvp514x_reg_list[REG_SYNC_CONTROL].val |=
+	decoder->tvp514x_regs[REG_SYNC_CONTROL].val |=
 			((decoder->pdata->hs_polarity << 2) |
 			(decoder->pdata->vs_polarity << 3));
 	/*
@@ -1419,23 +1429,27 @@ tvp514x_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	 */
 	decoder->id = (struct i2c_device_id *)id;
 	/* Attach to Master */
-	strcpy(tvp514x_int_device.u.slave->attach_to, decoder->pdata->master);
-	decoder->v4l2_int_device = &tvp514x_int_device;
+	strcpy(decoder->v4l2_int_device.u.slave->attach_to,
+			decoder->pdata->master);
 	decoder->client = client;
 	i2c_set_clientdata(client, decoder);
 
 	/* Register with V4L2 layer as slave device */
-	err = v4l2_int_device_register(decoder->v4l2_int_device);
+	err = v4l2_int_device_register(&decoder->v4l2_int_device);
 	if (err) {
 		i2c_set_clientdata(client, NULL);
 		v4l_err(client,
 			"Unable to register to v4l2. Err[%d]\n", err);
+		goto out_free;
 
 	} else
 		v4l_info(client, "Registered to v4l2 master %s!!\n",
 				decoder->pdata->master);
-
 	return 0;
+
+out_free:
+	kfree(decoder);
+	return err;
 }
 
 /**
@@ -1452,9 +1466,9 @@ static int __exit tvp514x_remove(struct i2c_client *client)
 	if (!client->adapter)
 		return -ENODEV;	/* our client isn't attached */
 
-	v4l2_int_device_unregister(decoder->v4l2_int_device);
+	v4l2_int_device_unregister(&decoder->v4l2_int_device);
 	i2c_set_clientdata(client, NULL);
-
+	kfree(decoder);
 	return 0;
 }
 /*
-- 
1.5.6.5

