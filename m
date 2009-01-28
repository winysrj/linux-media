Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.tglx.de ([62.245.132.106]:51289 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888AbZA1P3v (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jan 2009 10:29:51 -0500
Date: Wed, 28 Jan 2009 16:29:37 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	"video4linux-list@redhat.com" <video4linux-list@redhat.com>
Subject: [PATCH v2] v4l/tvp514x: make the module aware of rich people
Message-ID: <20090128152937.GA5063@www.tglx.de>
References: <20090112182440.GA24931@www.tglx.de> <19F8576C6E063C45BE387C64729E739403ECF709E2@dbde02.ent.ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <19F8576C6E063C45BE387C64729E739403ECF709E2@dbde02.ent.ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

because they might design two of those chips on a single board.
You never know.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
v2: Make the content of the registers (brightness, \ldots) per decoder
    and not global.
v1: Initial version

 drivers/media/video/tvp514x.c |  166 ++++++++++++++++++++++-------------------
 1 files changed, 90 insertions(+), 76 deletions(-)

diff --git a/drivers/media/video/tvp514x.c b/drivers/media/video/tvp514x.c
index 8e23aa5..99cfc40 100644
--- a/drivers/media/video/tvp514x.c
+++ b/drivers/media/video/tvp514x.c
@@ -86,45 +86,8 @@ struct tvp514x_std_info {
 	struct v4l2_standard standard;
 };
 
-/**
- * struct tvp514x_decoded - TVP5146/47 decoder object
- * @v4l2_int_device: Slave handle
- * @pdata: Board specific
- * @client: I2C client data
- * @id: Entry from I2C table
- * @ver: Chip version
- * @state: TVP5146/47 decoder state - detected or not-detected
- * @pix: Current pixel format
- * @num_fmts: Number of formats
- * @fmt_list: Format list
- * @current_std: Current standard
- * @num_stds: Number of standards
- * @std_list: Standards list
- * @route: input and output routing at chip level
- */
-struct tvp514x_decoder {
-	struct v4l2_int_device *v4l2_int_device;
-	const struct tvp514x_platform_data *pdata;
-	struct i2c_client *client;
-
-	struct i2c_device_id *id;
-
-	int ver;
-	enum tvp514x_state state;
-
-	struct v4l2_pix_format pix;
-	int num_fmts;
-	const struct v4l2_fmtdesc *fmt_list;
-
-	enum tvp514x_std current_std;
-	int num_stds;
-	struct tvp514x_std_info *std_list;
-
-	struct v4l2_routing route;
-};
-
 /* TVP514x default register values */
-static struct tvp514x_reg tvp514x_reg_list[] = {
+static struct tvp514x_reg tvp514x_reg_list_default[] = {
 	{TOK_WRITE, REG_INPUT_SEL, 0x05},	/* Composite selected */
 	{TOK_WRITE, REG_AFE_GAIN_CTRL, 0x0F},
 	{TOK_WRITE, REG_VIDEO_STD, 0x00},	/* Auto mode */
@@ -186,6 +149,44 @@ static struct tvp514x_reg tvp514x_reg_list[] = {
 	{TOK_TERM, 0, 0},
 };
 
+/**
+ * struct tvp514x_decoded - TVP5146/47 decoder object
+ * @v4l2_int_device: Slave handle
+ * @pdata: Board specific
+ * @client: I2C client data
+ * @id: Entry from I2C table
+ * @ver: Chip version
+ * @state: TVP5146/47 decoder state - detected or not-detected
+ * @pix: Current pixel format
+ * @num_fmts: Number of formats
+ * @fmt_list: Format list
+ * @current_std: Current standard
+ * @num_stds: Number of standards
+ * @std_list: Standards list
+ * @route: input and output routing at chip level
+ */
+struct tvp514x_decoder {
+	struct v4l2_int_device v4l2_int_device;
+	const struct tvp514x_platform_data *pdata;
+	struct i2c_client *client;
+
+	struct i2c_device_id *id;
+
+	int ver;
+	enum tvp514x_state state;
+
+	struct v4l2_pix_format pix;
+	int num_fmts;
+	const struct v4l2_fmtdesc *fmt_list;
+
+	enum tvp514x_std current_std;
+	int num_stds;
+	struct tvp514x_std_info *std_list;
+
+	struct v4l2_routing route;
+	struct tvp514x_reg tvp514x_regs[ARRAY_SIZE(tvp514x_reg_list_default)];
+};
+
 /* List of image formats supported by TVP5146/47 decoder
  * Currently we are using 8 bit mode only, but can be
  * extended to 10/20 bit mode.
@@ -422,7 +423,7 @@ static int tvp514x_configure(struct tvp514x_decoder *decoder)
 
 	/* common register initialization */
 	err =
-	    tvp514x_write_regs(decoder->client, tvp514x_reg_list);
+	    tvp514x_write_regs(decoder->client, decoder->tvp514x_regs);
 	if (err)
 		return err;
 
@@ -580,7 +581,7 @@ static int ioctl_s_std(struct v4l2_int_device *s, v4l2_std_id *std_id)
 		return err;
 
 	decoder->current_std = i;
-	tvp514x_reg_list[REG_VIDEO_STD].val = decoder->std_list[i].video_std;
+	decoder->tvp514x_regs[REG_VIDEO_STD].val = decoder->std_list[i].video_std;
 
 	v4l_dbg(1, debug, decoder->client, "Standard set to: %s",
 			decoder->std_list[i].standard.name);
@@ -625,8 +626,8 @@ static int ioctl_s_routing(struct v4l2_int_device *s,
 	if (err)
 		return err;
 
-	tvp514x_reg_list[REG_INPUT_SEL].val = input_sel;
-	tvp514x_reg_list[REG_OUTPUT_FORMATTER1].val = output_sel;
+	decoder->tvp514x_regs[REG_INPUT_SEL].val = input_sel;
+	decoder->tvp514x_regs[REG_OUTPUT_FORMATTER1].val = output_sel;
 
 	/* Clear status */
 	msleep(LOCK_RETRY_DELAY);
@@ -779,16 +780,16 @@ ioctl_g_ctrl(struct v4l2_int_device *s, struct v4l2_control *ctrl)
 
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
@@ -798,7 +799,7 @@ ioctl_g_ctrl(struct v4l2_int_device *s, struct v4l2_control *ctrl)
 
 		break;
 	case V4L2_CID_AUTOGAIN:
-		ctrl->value = tvp514x_reg_list[REG_AFE_GAIN_CTRL].val;
+		ctrl->value = decoder->tvp514x_regs[REG_AFE_GAIN_CTRL].val;
 		if ((ctrl->value & 0x3) == 3)
 			ctrl->value = 1;
 		else
@@ -848,7 +849,7 @@ ioctl_s_ctrl(struct v4l2_int_device *s, struct v4l2_control *ctrl)
 				value);
 		if (err)
 			return err;
-		tvp514x_reg_list[REG_BRIGHTNESS].val = value;
+		decoder->tvp514x_regs[REG_BRIGHTNESS].val = value;
 		break;
 	case V4L2_CID_CONTRAST:
 		if (ctrl->value < 0 || ctrl->value > 255) {
@@ -861,7 +862,7 @@ ioctl_s_ctrl(struct v4l2_int_device *s, struct v4l2_control *ctrl)
 				value);
 		if (err)
 			return err;
-		tvp514x_reg_list[REG_CONTRAST].val = value;
+		decoder->tvp514x_regs[REG_CONTRAST].val = value;
 		break;
 	case V4L2_CID_SATURATION:
 		if (ctrl->value < 0 || ctrl->value > 255) {
@@ -874,7 +875,7 @@ ioctl_s_ctrl(struct v4l2_int_device *s, struct v4l2_control *ctrl)
 				value);
 		if (err)
 			return err;
-		tvp514x_reg_list[REG_SATURATION].val = value;
+		decoder->tvp514x_regs[REG_SATURATION].val = value;
 		break;
 	case V4L2_CID_HUE:
 		if (value == 180)
@@ -893,7 +894,7 @@ ioctl_s_ctrl(struct v4l2_int_device *s, struct v4l2_control *ctrl)
 				value);
 		if (err)
 			return err;
-		tvp514x_reg_list[REG_HUE].val = value;
+		decoder->tvp514x_regs[REG_HUE].val = value;
 		break;
 	case V4L2_CID_AUTOGAIN:
 		if (value == 1)
@@ -910,7 +911,7 @@ ioctl_s_ctrl(struct v4l2_int_device *s, struct v4l2_control *ctrl)
 				value);
 		if (err)
 			return err;
-		tvp514x_reg_list[REG_AFE_GAIN_CTRL].val = value;
+		decoder->tvp514x_regs[REG_AFE_GAIN_CTRL].val = value;
 		break;
 	default:
 		v4l_err(decoder->client,
@@ -1275,7 +1276,7 @@ static int ioctl_init(struct v4l2_int_device *s)
 	struct tvp514x_decoder *decoder = s->priv;
 
 	/* Set default standard to auto */
-	tvp514x_reg_list[REG_VIDEO_STD].val =
+	decoder->tvp514x_regs[REG_VIDEO_STD].val =
 	    VIDEO_STD_AUTO_SWITCH_BIT;
 
 	return tvp514x_configure(decoder);
@@ -1369,17 +1370,14 @@ static struct tvp514x_decoder tvp514x_dev = {
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
+		.u = {
+			.slave = &tvp514x_slave,
+		},
+	},
 };
 
 /**
@@ -1392,26 +1390,39 @@ static struct v4l2_int_device tvp514x_int_device = {
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
+
+	BUILD_BUG_ON(sizeof(decoder->tvp514x_regs) !=
+			sizeof(tvp514x_reg_list_default));
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
@@ -1419,23 +1430,26 @@ tvp514x_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	 */
 	decoder->id = (struct i2c_device_id *)id;
 	/* Attach to Master */
-	strcpy(tvp514x_int_device.u.slave->attach_to, decoder->pdata->master);
-	decoder->v4l2_int_device = &tvp514x_int_device;
+	strcpy(decoder->v4l2_int_device.u.slave->attach_to, decoder->pdata->master);
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

