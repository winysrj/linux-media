Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:39444 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932832AbZJ3Se2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Oct 2009 14:34:28 -0400
Date: Fri, 30 Oct 2009 19:34:45 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Muralidharan Karicheri <m-karicheri2@ti.com>
Subject: [PATCH/RFC 8b/9 v3] rj54n1cb0c: Add cropping, auto white balance,
 restrict sizes, add platform data
In-Reply-To: <Pine.LNX.4.64.0910301439560.4378@axis700.grange>
Message-ID: <Pine.LNX.4.64.0910301931250.4378@axis700.grange>
References: <Pine.LNX.4.64.0910301338140.4378@axis700.grange>
 <Pine.LNX.4.64.0910301439560.4378@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It has been experimentally found out, that the sensor only supports up to
512x384 video output and also has some restrictions on minimum scale. We
disable non-working size ranges until, maybe, someone finds out how to properly
set them up. Also add cropping support, an auto white balance control, platform
data to specify master clock frequency and polarity of the IOCTL pin. Add 
this data to the kfr2r09 board.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

...and part "b". I also incremented the version, because I also swapped 
functions to reduce the diff, but the content is exactly the same.

 arch/sh/boards/mach-kfr2r09/setup.c |   13 ++-
 drivers/media/video/rj54n1cb0c.c    |  282 ++++++++++++++++++++++++++++-------
 include/media/rj54n1cb0c.h          |   19 +++
 3 files changed, 260 insertions(+), 54 deletions(-)
 create mode 100644 include/media/rj54n1cb0c.h

diff --git a/arch/sh/boards/mach-kfr2r09/setup.c b/arch/sh/boards/mach-kfr2r09/setup.c
index ce01d6a..18df641 100644
--- a/arch/sh/boards/mach-kfr2r09/setup.c
+++ b/arch/sh/boards/mach-kfr2r09/setup.c
@@ -18,6 +18,7 @@
 #include <linux/input.h>
 #include <linux/i2c.h>
 #include <linux/usb/r8a66597.h>
+#include <media/rj54n1cb0c.h>
 #include <media/soc_camera.h>
 #include <media/sh_mobile_ceu.h>
 #include <video/sh_mobile_lcdc.h>
@@ -254,6 +255,9 @@ static struct i2c_board_info kfr2r09_i2c_camera = {
 
 static struct clk *camera_clk;
 
+/* set VIO_CKO clock to 25MHz */
+#define CEU_MCLK_FREQ 25000000
+
 #define DRVCRB 0xA405018C
 static int camera_power(struct device *dev, int mode)
 {
@@ -266,8 +270,7 @@ static int camera_power(struct device *dev, int mode)
 		if (IS_ERR(camera_clk))
 			return PTR_ERR(camera_clk);
 
-		/* set VIO_CKO clock to 25MHz */
-		rate = clk_round_rate(camera_clk, 25000000);
+		rate = clk_round_rate(camera_clk, CEU_MCLK_FREQ);
 		ret = clk_set_rate(camera_clk, rate);
 		if (ret < 0)
 			goto eclkrate;
@@ -317,11 +320,17 @@ eclkrate:
 	return ret;
 }
 
+static struct rj54n1_pdata rj54n1_priv = {
+	.mclk_freq	= CEU_MCLK_FREQ,
+	.ioctl_high	= false,
+};
+
 static struct soc_camera_link rj54n1_link = {
 	.power		= camera_power,
 	.board_info	= &kfr2r09_i2c_camera,
 	.i2c_adapter_id	= 1,
 	.module_name	= "rj54n1cb0c",
+	.priv		= &rj54n1_priv,
 };
 
 static struct platform_device kfr2r09_camera = {
diff --git a/drivers/media/video/rj54n1cb0c.c b/drivers/media/video/rj54n1cb0c.c
index 0c998e8..6c4cba2 100644
--- a/drivers/media/video/rj54n1cb0c.c
+++ b/drivers/media/video/rj54n1cb0c.c
@@ -16,6 +16,7 @@
 #include <media/v4l2-subdev.h>
 #include <media/v4l2-chip-ident.h>
 #include <media/soc_camera.h>
+#include <media/rj54n1cb0c.h>
 
 #define RJ54N1_DEV_CODE			0x0400
 #define RJ54N1_DEV_CODE2		0x0401
@@ -38,6 +39,7 @@
 #define RJ54N1_H_OBEN_OFS		0x0413
 #define RJ54N1_V_OBEN_OFS		0x0414
 #define RJ54N1_RESIZE_CONTROL		0x0415
+#define RJ54N1_STILL_CONTROL		0x0417
 #define RJ54N1_INC_USE_SEL_H		0x0425
 #define RJ54N1_INC_USE_SEL_L		0x0426
 #define RJ54N1_MIRROR_STILL_MODE	0x0427
@@ -49,10 +51,21 @@
 #define RJ54N1_RA_SEL_UL		0x0530
 #define RJ54N1_BYTE_SWAP		0x0531
 #define RJ54N1_OUT_SIGPO		0x053b
+#define RJ54N1_WB_SEL_WEIGHT_I		0x054e
+#define RJ54N1_BIT8_WB			0x0569
+#define RJ54N1_HCAPS_WB			0x056a
+#define RJ54N1_VCAPS_WB			0x056b
+#define RJ54N1_HCAPE_WB			0x056c
+#define RJ54N1_VCAPE_WB			0x056d
+#define RJ54N1_EXPOSURE_CONTROL		0x058c
 #define RJ54N1_FRAME_LENGTH_S_H		0x0595
 #define RJ54N1_FRAME_LENGTH_S_L		0x0596
 #define RJ54N1_FRAME_LENGTH_P_H		0x0597
 #define RJ54N1_FRAME_LENGTH_P_L		0x0598
+#define RJ54N1_PEAK_H			0x05b7
+#define RJ54N1_PEAK_50			0x05b8
+#define RJ54N1_PEAK_60			0x05b9
+#define RJ54N1_PEAK_DIFF		0x05ba
 #define RJ54N1_IOC			0x05ef
 #define RJ54N1_TG_BYPASS		0x0700
 #define RJ54N1_PLL_L			0x0701
@@ -68,6 +81,7 @@
 #define RJ54N1_OCLK_SEL_EN		0x0713
 #define RJ54N1_CLK_RST			0x0717
 #define RJ54N1_RESET_STANDBY		0x0718
+#define RJ54N1_FWFLG			0x07fe
 
 #define E_EXCLK				(1 << 7)
 #define SOFT_STDBY			(1 << 4)
@@ -78,11 +92,18 @@
 #define RESIZE_HOLD_SEL			(1 << 2)
 #define RESIZE_GO			(1 << 1)
 
+/*
+ * When cropping, the camera automatically centers the cropped region, there
+ * doesn't seem to be a way to specify an explicit location of the rectangle.
+ */
 #define RJ54N1_COLUMN_SKIP		0
 #define RJ54N1_ROW_SKIP			0
 #define RJ54N1_MAX_WIDTH		1600
 #define RJ54N1_MAX_HEIGHT		1200
 
+#define PLL_L				2
+#define PLL_N				0x31
+
 /* I2C addresses: 0x50, 0x51, 0x60, 0x61 */
 
 static const enum v4l2_imgbus_pixelcode rj54n1_colour_codes[] = {
@@ -98,7 +119,7 @@ static const enum v4l2_imgbus_pixelcode rj54n1_colour_codes[] = {
 };
 
 struct rj54n1_clock_div {
-	u8 ratio_tg;
+	u8 ratio_tg;	/* can be 0 or an odd number */
 	u8 ratio_t;
 	u8 ratio_r;
 	u8 ratio_op;
@@ -107,12 +128,14 @@ struct rj54n1_clock_div {
 
 struct rj54n1 {
 	struct v4l2_subdev subdev;
+	struct rj54n1_clock_div clk_div;
 	enum v4l2_imgbus_pixelcode code;
 	struct v4l2_rect rect;	/* Sensor window */
+	unsigned int tgclk_mhz;
+	bool auto_wb;
 	unsigned short width;	/* Output window */
 	unsigned short height;
 	unsigned short resize;	/* Sensor * 1024 / resize = Output */
-	struct rj54n1_clock_div clk_div;
 	unsigned short scale;
 	u8 bank;
 };
@@ -169,7 +192,7 @@ const static struct rj54n1_reg_val bank_7[] = {
 	{0x714, 0xff},
 	{0x715, 0xff},
 	{0x716, 0x1f},
-	{0x7FE, 0x02},
+	{0x7FE, 2},
 };
 
 const static struct rj54n1_reg_val bank_8[] = {
@@ -357,7 +380,7 @@ const static struct rj54n1_reg_val bank_8[] = {
 	{0x8BB, 0x00},
 	{0x8BC, 0xFF},
 	{0x8BD, 0x00},
-	{0x8FE, 0x02},
+	{0x8FE, 2},
 };
 
 const static struct rj54n1_reg_val bank_10[] = {
@@ -450,8 +473,10 @@ static int rj54n1_enum_fmt(struct v4l2_subdev *sd, int index,
 
 static int rj54n1_s_stream(struct v4l2_subdev *sd, int enable)
 {
-	/* TODO: start / stop streaming */
-	return 0;
+	struct i2c_client *client = sd->priv;
+
+	/* Switch between preview and still shot modes */
+	return reg_set(client, RJ54N1_STILL_CONTROL, (!enable) << 7, 0x80);
 }
 
 static int rj54n1_set_bus_param(struct soc_camera_device *icd,
@@ -510,6 +535,44 @@ static int rj54n1_commit(struct i2c_client *client)
 	return ret;
 }
 
+static int rj54n1_sensor_scale(struct v4l2_subdev *sd, u32 *in_w, u32 *in_h,
+			       u32 *out_w, u32 *out_h);
+
+static int rj54n1_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
+{
+	struct i2c_client *client = sd->priv;
+	struct rj54n1 *rj54n1 = to_rj54n1(client);
+	struct v4l2_rect *rect = &a->c;
+	unsigned int dummy, output_w, output_h,
+		input_w = rect->width, input_h = rect->height;
+	int ret;
+
+	/* arbitrary minimum width and height, edges unimportant */
+	soc_camera_limit_side(&dummy, &input_w,
+		     RJ54N1_COLUMN_SKIP, 8, RJ54N1_MAX_WIDTH);
+
+	soc_camera_limit_side(&dummy, &input_h,
+		     RJ54N1_ROW_SKIP, 8, RJ54N1_MAX_HEIGHT);
+
+	output_w = (input_w * 1024 + rj54n1->resize / 2) / rj54n1->resize;
+	output_h = (input_h * 1024 + rj54n1->resize / 2) / rj54n1->resize;
+
+	dev_dbg(&client->dev, "Scaling for %ux%u : %u = %ux%u\n",
+		input_w, input_h, rj54n1->resize, output_w, output_h);
+
+	ret = rj54n1_sensor_scale(sd, &input_w, &input_h, &output_w, &output_h);
+	if (ret < 0)
+		return ret;
+
+	rj54n1->width		= output_w;
+	rj54n1->height		= output_h;
+	rj54n1->resize		= ret;
+	rj54n1->rect.width	= input_w;
+	rj54n1->rect.height	= input_h;
+
+	return 0;
+}
+
 static int rj54n1_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 {
 	struct i2c_client *client = sd->priv;
@@ -558,11 +621,44 @@ static int rj54n1_sensor_scale(struct v4l2_subdev *sd, u32 *in_w, u32 *in_h,
 			       u32 *out_w, u32 *out_h)
 {
 	struct i2c_client *client = sd->priv;
+	struct rj54n1 *rj54n1 = to_rj54n1(client);
 	unsigned int skip, resize, input_w = *in_w, input_h = *in_h,
 		output_w = *out_w, output_h = *out_h;
-	u16 inc_sel;
+	u16 inc_sel, wb_bit8, wb_left, wb_right, wb_top, wb_bottom;
+	unsigned int peak, peak_50, peak_60;
 	int ret;
 
+	/*
+	 * We have a problem with crops, where the window is larger than 512x384
+	 * and output window is larger than a half of the input one. In this
+	 * case we have to either reduce the input window to equal or below
+	 * 512x384 or the output window to equal or below 1/2 of the input.
+	 */
+	if (output_w > max(512U, input_w / 2)) {
+		if (2 * output_w > RJ54N1_MAX_WIDTH) {
+			input_w = RJ54N1_MAX_WIDTH;
+			output_w = RJ54N1_MAX_WIDTH / 2;
+		} else {
+			input_w = output_w * 2;
+		}
+
+		dev_dbg(&client->dev, "Adjusted output width: in %u, out %u\n",
+			input_w, output_w);
+	}
+
+	if (output_h > max(384U, input_h / 2)) {
+		if (2 * output_h > RJ54N1_MAX_HEIGHT) {
+			input_h = RJ54N1_MAX_HEIGHT;
+			output_h = RJ54N1_MAX_HEIGHT / 2;
+		} else {
+			input_h = output_h * 2;
+		}
+
+		dev_dbg(&client->dev, "Adjusted output height: in %u, out %u\n",
+			input_h, output_h);
+	}
+
+	/* Idea: use the read mode for snapshots, handle separate geometries */
 	ret = rj54n1_set_rect(client, RJ54N1_X_OUTPUT_SIZE_S_L,
 			      RJ54N1_Y_OUTPUT_SIZE_S_L,
 			      RJ54N1_XY_OUTPUT_SIZE_S_H, output_w, output_h);
@@ -574,17 +670,27 @@ static int rj54n1_sensor_scale(struct v4l2_subdev *sd, u32 *in_w, u32 *in_h,
 	if (ret < 0)
 		return ret;
 
-	if (output_w > input_w || output_h > input_h) {
+	if (output_w > input_w && output_h > input_h) {
 		input_w = output_w;
 		input_h = output_h;
 
 		resize = 1024;
 	} else {
 		unsigned int resize_x, resize_y;
-		resize_x = input_w * 1024 / output_w;
-		resize_y = input_h * 1024 / output_h;
-
-		resize = min(resize_x, resize_y);
+		resize_x = (input_w * 1024 + output_w / 2) / output_w;
+		resize_y = (input_h * 1024 + output_h / 2) / output_h;
+
+		/* We want max(resize_x, resize_y), check if it still fits */
+		if (resize_x > resize_y &&
+		    (output_h * resize_x + 512) / 1024 > RJ54N1_MAX_HEIGHT)
+			resize = (RJ54N1_MAX_HEIGHT * 1024 + output_h / 2) /
+				output_h;
+		else if (resize_y > resize_x &&
+			 (output_w * resize_y + 512) / 1024 > RJ54N1_MAX_WIDTH)
+			resize = (RJ54N1_MAX_WIDTH * 1024 + output_w / 2) /
+				output_w;
+		else
+			resize = max(resize_x, resize_y);
 
 		/* Prohibited value ranges */
 		switch (resize) {
@@ -597,12 +703,9 @@ static int rj54n1_sensor_scale(struct v4l2_subdev *sd, u32 *in_w, u32 *in_h,
 		case 8160 ... 8191:
 			resize = 8159;
 			break;
-		case 16320 ... 16383:
+		case 16320 ... 16384:
 			resize = 16319;
 		}
-
-		input_w = output_w * resize / 1024;
-		input_h = output_h * resize / 1024;
 	}
 
 	/* Set scaling */
@@ -615,9 +718,18 @@ static int rj54n1_sensor_scale(struct v4l2_subdev *sd, u32 *in_w, u32 *in_h,
 
 	/*
 	 * Configure a skipping bitmask. The sensor will select a skipping value
-	 * among set bits automatically.
+	 * among set bits automatically. This is very unclear in the datasheet
+	 * too. I was told, in this register one enables all skipping values,
+	 * that are required for a specific resize, and the camera selects
+	 * automatically, which ones to use. But it is unclear how to identify,
+	 * which cropping values are needed. Secondly, why don't we just set all
+	 * bits and let the camera choose? Would it increase processing time and
+	 * reduce the framerate? Using 0xfffc for INC_USE_SEL doesn't seem to
+	 * improve the image quality or stability for larger frames (see comment
+	 * above), but I didn't check the framerate.
 	 */
 	skip = min(resize / 1024, (unsigned)15);
+
 	inc_sel = 1 << skip;
 
 	if (inc_sel <= 2)
@@ -629,6 +741,43 @@ static int rj54n1_sensor_scale(struct v4l2_subdev *sd, u32 *in_w, u32 *in_h,
 	if (!ret)
 		ret = reg_write(client, RJ54N1_INC_USE_SEL_H, inc_sel >> 8);
 
+	if (!rj54n1->auto_wb) {
+		/* Auto white balance window */
+		wb_left	  = output_w / 16;
+		wb_right  = (3 * output_w / 4 - 3) / 4;
+		wb_top	  = output_h / 16;
+		wb_bottom = (3 * output_h / 4 - 3) / 4;
+		wb_bit8	  = ((wb_left >> 2) & 0x40) | ((wb_top >> 4) & 0x10) |
+			((wb_right >> 6) & 4) | ((wb_bottom >> 8) & 1);
+
+		if (!ret)
+			ret = reg_write(client, RJ54N1_BIT8_WB, wb_bit8);
+		if (!ret)
+			ret = reg_write(client, RJ54N1_HCAPS_WB, wb_left);
+		if (!ret)
+			ret = reg_write(client, RJ54N1_VCAPS_WB, wb_top);
+		if (!ret)
+			ret = reg_write(client, RJ54N1_HCAPE_WB, wb_right);
+		if (!ret)
+			ret = reg_write(client, RJ54N1_VCAPE_WB, wb_bottom);
+	}
+
+	/* Antiflicker */
+	peak = 12 * RJ54N1_MAX_WIDTH * (1 << 14) * resize / rj54n1->tgclk_mhz /
+		10000;
+	peak_50 = peak / 6;
+	peak_60 = peak / 5;
+
+	if (!ret)
+		ret = reg_write(client, RJ54N1_PEAK_H,
+				((peak_50 >> 4) & 0xf0) | (peak_60 >> 8));
+	if (!ret)
+		ret = reg_write(client, RJ54N1_PEAK_50, peak_50);
+	if (!ret)
+		ret = reg_write(client, RJ54N1_PEAK_60, peak_60);
+	if (!ret)
+		ret = reg_write(client, RJ54N1_PEAK_DIFF, peak / 150);
+
 	/* Start resizing */
 	if (!ret)
 		ret = reg_write(client, RJ54N1_RESIZE_CONTROL,
@@ -637,8 +786,6 @@ static int rj54n1_sensor_scale(struct v4l2_subdev *sd, u32 *in_w, u32 *in_h,
 	if (ret < 0)
 		return ret;
 
-	dev_dbg(&client->dev, "resize %u, skip %u\n", resize, skip);
-
 	/* Constant taken from manufacturer's example */
 	msleep(230);
 
@@ -646,11 +793,14 @@ static int rj54n1_sensor_scale(struct v4l2_subdev *sd, u32 *in_w, u32 *in_h,
 	if (ret < 0)
 		return ret;
 
-	*in_w = input_w;
-	*in_h = input_h;
+	*in_w = (output_w * resize + 512) / 1024;
+	*in_h = (output_h * resize + 512) / 1024;
 	*out_w = output_w;
 	*out_h = output_h;
 
+	dev_dbg(&client->dev, "Scaled for %ux%u : %u = %ux%u, skip %u\n",
+		*in_w, *in_h, resize, output_w, output_h, skip);
+
 	return resize;
 }
 
@@ -661,14 +811,14 @@ static int rj54n1_set_clock(struct i2c_client *client)
 
 	/* Enable external clock */
 	ret = reg_write(client, RJ54N1_RESET_STANDBY, E_EXCLK | SOFT_STDBY);
-	/* Leave stand-by */
+	/* Leave stand-by. Note: use this when implementing suspend / resume */
 	if (!ret)
 		ret = reg_write(client, RJ54N1_RESET_STANDBY, E_EXCLK);
 
 	if (!ret)
-		ret = reg_write(client, RJ54N1_PLL_L, 2);
+		ret = reg_write(client, RJ54N1_PLL_L, PLL_L);
 	if (!ret)
-		ret = reg_write(client, RJ54N1_PLL_N, 0x31);
+		ret = reg_write(client, RJ54N1_PLL_N, PLL_N);
 
 	/* TGCLK dividers */
 	if (!ret)
@@ -727,6 +877,7 @@ static int rj54n1_set_clock(struct i2c_client *client)
 			"Resetting RJ54N1CB0C clock failed: %d!\n", ret);
 		return -EIO;
 	}
+
 	/* Start the PLL */
 	ret = reg_set(client, RJ54N1_OCLK_DSP, 1, 1);
 
@@ -739,6 +890,7 @@ static int rj54n1_set_clock(struct i2c_client *client)
 
 static int rj54n1_reg_init(struct i2c_client *client)
 {
+	struct rj54n1 *rj54n1 = to_rj54n1(client);
 	int ret = rj54n1_set_clock(client);
 
 	if (!ret)
@@ -761,14 +913,26 @@ static int rj54n1_reg_init(struct i2c_client *client)
 	if (!ret)
 		ret = reg_write(client, RJ54N1_Y_GAIN, 0x84);
 
-	/* Mirror the image back: default is upside down and left-to-right... */
+	/*
+	 * Mirror the image back: default is upside down and left-to-right...
+	 * Set manual preview / still shot switching
+	 */
 	if (!ret)
-		ret = reg_set(client, RJ54N1_MIRROR_STILL_MODE, 3, 3);
+		ret = reg_write(client, RJ54N1_MIRROR_STILL_MODE, 0x27);
 
 	if (!ret)
 		ret = reg_write_multiple(client, bank_4, ARRAY_SIZE(bank_4));
+
+	/* Auto exposure area */
+	if (!ret)
+		ret = reg_write(client, RJ54N1_EXPOSURE_CONTROL, 0x80);
+	/* Check current auto WB config */
 	if (!ret)
+		ret = reg_read(client, RJ54N1_WB_SEL_WEIGHT_I);
+	if (ret >= 0) {
+		rj54n1->auto_wb = ret & 0x80;
 		ret = reg_write_multiple(client, bank_5, ARRAY_SIZE(bank_5));
+	}
 	if (!ret)
 		ret = reg_write_multiple(client, bank_8, ARRAY_SIZE(bank_8));
 
@@ -785,8 +949,9 @@ static int rj54n1_reg_init(struct i2c_client *client)
 		ret = reg_write(client, RJ54N1_RESET_STANDBY,
 				E_EXCLK | DSP_RSTX | TG_RSTX | SEN_RSTX);
 
+	/* Start register update? Same register as 0x?FE in many bank_* sets */
 	if (!ret)
-		ret = reg_write(client, 0x7fe, 2);
+		ret = reg_write(client, RJ54N1_FWFLG, 2);
 
 	/* Constant taken from manufacturer's example */
 	msleep(700);
@@ -794,7 +959,6 @@ static int rj54n1_reg_init(struct i2c_client *client)
 	return ret;
 }
 
-/* FIXME: streaming output only up to 800x600 is functional */
 static int rj54n1_try_fmt(struct v4l2_subdev *sd,
 			  struct v4l2_imgbus_framefmt *imgf)
 {
@@ -825,18 +989,13 @@ static int rj54n1_s_fmt(struct v4l2_subdev *sd,
 		input_w = rj54n1->rect.width, input_h = rj54n1->rect.height;
 	int ret;
 
-	/*
-	 * The host driver can call us without .try_fmt(), so, we have to take
-	 * care ourseleves
-	 */
-	ret = rj54n1_try_fmt(sd, imgf);
+	rj54n1_try_fmt(sd, imgf);
 
 	/*
 	 * Verify if the sensor has just been powered on. TODO: replace this
 	 * with proper PM, when a suitable API is available.
 	 */
-	if (!ret)
-		ret = reg_read(client, RJ54N1_RESET_STANDBY);
+	ret = reg_read(client, RJ54N1_RESET_STANDBY);
 	if (ret < 0)
 		return ret;
 
@@ -846,6 +1005,9 @@ static int rj54n1_s_fmt(struct v4l2_subdev *sd,
 			return ret;
 	}
 
+	dev_dbg(&client->dev, "%s: code = %d, width = %u, height = %u\n",
+		__func__, imgf->code, imgf->width, imgf->height);
+
 	/* RA_SEL_UL is only relevant for raw modes, ignored otherwise. */
 	switch (imgf->code) {
 	case V4L2_IMGBUS_FMT_YUYV:
@@ -1026,6 +1188,14 @@ static const struct v4l2_queryctrl rj54n1_controls[] = {
 		.step		= 1,
 		.default_value	= 66,
 		.flags		= V4L2_CTRL_FLAG_SLIDER,
+	}, {
+		.id		= V4L2_CID_AUTO_WHITE_BALANCE,
+		.type		= V4L2_CTRL_TYPE_BOOLEAN,
+		.name		= "Auto white balance",
+		.minimum	= 0,
+		.maximum	= 1,
+		.step		= 1,
+		.default_value	= 1,
 	},
 };
 
@@ -1039,6 +1209,7 @@ static struct soc_camera_ops rj54n1_ops = {
 static int rj54n1_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 {
 	struct i2c_client *client = sd->priv;
+	struct rj54n1 *rj54n1 = to_rj54n1(client);
 	int data;
 
 	switch (ctrl->id) {
@@ -1061,6 +1232,9 @@ static int rj54n1_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 
 		ctrl->value = data / 2;
 		break;
+	case V4L2_CID_AUTO_WHITE_BALANCE:
+		ctrl->value = rj54n1->auto_wb;
+		break;
 	}
 
 	return 0;
@@ -1070,6 +1244,7 @@ static int rj54n1_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 {
 	int data;
 	struct i2c_client *client = sd->priv;
+	struct rj54n1 *rj54n1 = to_rj54n1(client);
 	const struct v4l2_queryctrl *qctrl;
 
 	qctrl = soc_camera_find_qctrl(&rj54n1_ops, ctrl->id);
@@ -1100,6 +1275,13 @@ static int rj54n1_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 		else if (reg_write(client, RJ54N1_Y_GAIN, ctrl->value * 2) < 0)
 			return -EIO;
 		break;
+	case V4L2_CID_AUTO_WHITE_BALANCE:
+		/* Auto WB area - whole image */
+		if (reg_set(client, RJ54N1_WB_SEL_WEIGHT_I, ctrl->value << 7,
+			    0x80) < 0)
+			return -EIO;
+		rj54n1->auto_wb = ctrl->value;
+		break;
 	}
 
 	return 0;
@@ -1120,12 +1302,10 @@ static struct v4l2_subdev_video_ops rj54n1_subdev_video_ops = {
 	.s_imgbus_fmt		= rj54n1_s_fmt,
 	.g_imgbus_fmt		= rj54n1_g_fmt,
 	.try_imgbus_fmt		= rj54n1_try_fmt,
-	.enum_imgbus_fmt	= rj54n1_enum_fmt,
-	.s_imgbus_fmt		= rj54n1_s_fmt,
-	.g_imgbus_fmt		= rj54n1_g_fmt,
-	.try_imgbus_fmt		= rj54n1_try_fmt,
+	.s_crop			= rj54n1_s_crop,
 	.g_crop			= rj54n1_g_crop,
 	.cropcap		= rj54n1_cropcap,
+	.enum_imgbus_fmt	= rj54n1_enum_fmt,
 };
 
 static struct v4l2_subdev_ops rj54n1_subdev_ops = {
@@ -1133,21 +1313,13 @@ static struct v4l2_subdev_ops rj54n1_subdev_ops = {
 	.video	= &rj54n1_subdev_video_ops,
 };
 
-static int rj54n1_pin_config(struct i2c_client *client)
-{
-	/*
-	 * Experimentally found out IOCTRL wired to 0. TODO: add to platform
-	 * data: 0 or 1 << 7.
-	 */
-	return reg_write(client, RJ54N1_IOC, 0);
-}
-
 /*
  * Interface active, can use i2c. If it fails, it can indeed mean, that
  * this wasn't our capture interface, so, we wait for the right one
  */
 static int rj54n1_video_probe(struct soc_camera_device *icd,
-			      struct i2c_client *client)
+			      struct i2c_client *client,
+			      struct rj54n1_pdata *priv)
 {
 	int data1, data2;
 	int ret;
@@ -1168,7 +1340,8 @@ static int rj54n1_video_probe(struct soc_camera_device *icd,
 		goto ei2c;
 	}
 
-	ret = rj54n1_pin_config(client);
+	/* Configure IOCTL polarity from the platform data: 0 or 1 << 7. */
+	ret = reg_write(client, RJ54N1_IOC, priv->ioctl_high << 7);
 	if (ret < 0)
 		goto ei2c;
 
@@ -1186,6 +1359,7 @@ static int rj54n1_probe(struct i2c_client *client,
 	struct soc_camera_device *icd = client->dev.platform_data;
 	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
 	struct soc_camera_link *icl;
+	struct rj54n1_pdata *rj54n1_priv;
 	int ret;
 
 	if (!icd) {
@@ -1194,11 +1368,13 @@ static int rj54n1_probe(struct i2c_client *client,
 	}
 
 	icl = to_soc_camera_link(icd);
-	if (!icl) {
+	if (!icl || !icl->priv) {
 		dev_err(&client->dev, "RJ54N1CB0C: missing platform data!\n");
 		return -EINVAL;
 	}
 
+	rj54n1_priv = icl->priv;
+
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA)) {
 		dev_warn(&adapter->dev,
 			 "I2C-Adapter doesn't support I2C_FUNC_SMBUS_BYTE\n");
@@ -1222,8 +1398,10 @@ static int rj54n1_probe(struct i2c_client *client,
 	rj54n1->height		= RJ54N1_MAX_HEIGHT;
 	rj54n1->code		= rj54n1_colour_codes[0];
 	rj54n1->resize		= 1024;
+	rj54n1->tgclk_mhz	= (rj54n1_priv->mclk_freq / PLL_L * PLL_N) /
+		(clk_div.ratio_tg + 1) / (clk_div.ratio_t + 1);
 
-	ret = rj54n1_video_probe(icd, client);
+	ret = rj54n1_video_probe(icd, client, rj54n1_priv);
 	if (ret < 0) {
 		icd->ops = NULL;
 		i2c_set_clientdata(client, NULL);
diff --git a/include/media/rj54n1cb0c.h b/include/media/rj54n1cb0c.h
new file mode 100644
index 0000000..8ae3288
--- /dev/null
+++ b/include/media/rj54n1cb0c.h
@@ -0,0 +1,19 @@
+/*
+ * RJ54N1CB0C Private data
+ *
+ * Copyright (C) 2009, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __RJ54N1CB0C_H__
+#define __RJ54N1CB0C_H__
+
+struct rj54n1_pdata {
+	unsigned int	mclk_freq;
+	bool		ioctl_high;
+};
+
+#endif
-- 
1.6.2.4

