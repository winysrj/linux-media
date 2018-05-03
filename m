Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:3444 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750993AbeECLXc (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 3 May 2018 07:23:32 -0400
Date: Thu, 3 May 2018 14:23:28 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Andy Yeh <andy.yeh@intel.com>
Cc: linux-media@vger.kernel.org, tfiga@chromium.org,
        Jason Chen <jasonx.z.chen@intel.com>,
        Alan Chiang <alanx.chiang@intel.com>
Subject: Re: [PATCH v11] media: imx258: Add imx258 camera sensor driver
Message-ID: <20180503112328.fdvltrswztp42d6v@paasikivi.fi.intel.com>
References: <1525275968-17207-1-git-send-email-andy.yeh@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1525275968-17207-1-git-send-email-andy.yeh@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

On Wed, May 02, 2018 at 11:46:08PM +0800, Andy Yeh wrote:
> From: Jason Chen <jasonx.z.chen@intel.com>
> 
> Add a V4L2 sub-device driver for the Sony IMX258 image sensor.
> This is a camera sensor using the I2C bus for control and the
> CSI-2 bus for data.
> 
> Signed-off-by: Andy Yeh <andy.yeh@intel.com>
> Signed-off-by: Alan Chiang <alanx.chiang@intel.com>
> Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Reviewed-by: Tomasz Figa <tfiga@chromium.org>

Applied with the following diff, i.e. align to opening parenthesis and use
tabs for indentation:

diff --git b/drivers/media/i2c/imx258.c a/drivers/media/i2c/imx258.c
index 40ab4a616103..fad3012f4fe5 100644
--- b/drivers/media/i2c/imx258.c
+++ a/drivers/media/i2c/imx258.c
@@ -56,9 +56,9 @@
 #define IMX258_REG_B_DIGITAL_GAIN	0x0212
 #define IMX258_REG_GB_DIGITAL_GAIN	0x0214
 #define IMX258_DGTL_GAIN_MIN		0
-#define IMX258_DGTL_GAIN_MAX		4096   /* Max = 0xFFF */
+#define IMX258_DGTL_GAIN_MAX		4096	/* Max = 0xFFF */
 #define IMX258_DGTL_GAIN_DEFAULT	1024
-#define IMX258_DGTL_GAIN_STEP           1
+#define IMX258_DGTL_GAIN_STEP		1
 
 /* Test Pattern Control */
 #define IMX258_REG_TEST_PATTERN		0x0600
@@ -682,7 +682,7 @@ static int imx258_write_reg(struct imx258 *imx258, u16 reg, u32 len, u32 val)
 
 /* Write a list of registers */
 static int imx258_write_regs(struct imx258 *imx258,
-			      const struct imx258_reg *regs, u32 len)
+			     const struct imx258_reg *regs, u32 len)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(&imx258->sd);
 	unsigned int i;
@@ -818,8 +818,8 @@ static int imx258_enum_mbus_code(struct v4l2_subdev *sd,
 }
 
 static int imx258_enum_frame_size(struct v4l2_subdev *sd,
-				   struct v4l2_subdev_pad_config *cfg,
-				   struct v4l2_subdev_frame_size_enum *fse)
+				  struct v4l2_subdev_pad_config *cfg,
+				  struct v4l2_subdev_frame_size_enum *fse)
 {
 	if (fse->index >= ARRAY_SIZE(supported_modes))
 		return -EINVAL;
@@ -836,7 +836,7 @@ static int imx258_enum_frame_size(struct v4l2_subdev *sd,
 }
 
 static void imx258_update_pad_format(const struct imx258_mode *mode,
-				      struct v4l2_subdev_format *fmt)
+				     struct v4l2_subdev_format *fmt)
 {
 	fmt->format.width = mode->width;
 	fmt->format.height = mode->height;
@@ -845,8 +845,8 @@ static void imx258_update_pad_format(const struct imx258_mode *mode,
 }
 
 static int __imx258_get_pad_format(struct imx258 *imx258,
-				     struct v4l2_subdev_pad_config *cfg,
-				     struct v4l2_subdev_format *fmt)
+				   struct v4l2_subdev_pad_config *cfg,
+				   struct v4l2_subdev_format *fmt)
 {
 	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY)
 		fmt->format = *v4l2_subdev_get_try_format(&imx258->sd, cfg,
@@ -858,8 +858,8 @@ static int __imx258_get_pad_format(struct imx258 *imx258,
 }
 
 static int imx258_get_pad_format(struct v4l2_subdev *sd,
-				  struct v4l2_subdev_pad_config *cfg,
-				  struct v4l2_subdev_format *fmt)
+				 struct v4l2_subdev_pad_config *cfg,
+				 struct v4l2_subdev_format *fmt)
 {
 	struct imx258 *imx258 = to_imx258(sd);
 	int ret;
@@ -872,8 +872,8 @@ static int imx258_get_pad_format(struct v4l2_subdev *sd,
 }
 
 static int imx258_set_pad_format(struct v4l2_subdev *sd,
-		       struct v4l2_subdev_pad_config *cfg,
-		       struct v4l2_subdev_format *fmt)
+				 struct v4l2_subdev_pad_config *cfg,
+				 struct v4l2_subdev_format *fmt)
 {
 	struct imx258 *imx258 = to_imx258(sd);
 	const struct imx258_mode *mode;
@@ -951,7 +951,7 @@ static int imx258_start_streaming(struct imx258 *imx258)
 
 	/* Set Orientation be 180 degree */
 	ret = imx258_write_reg(imx258, REG_MIRROR_FLIP_CONTROL,
-				IMX258_REG_VALUE_08BIT, REG_CONFIG_MIRROR_FLIP);
+			       IMX258_REG_VALUE_08BIT, REG_CONFIG_MIRROR_FLIP);
 	if (ret) {
 		dev_err(&client->dev, "%s failed to set orientation\n",
 			__func__);
@@ -1073,7 +1073,7 @@ static int imx258_identify_module(struct imx258 *imx258)
 	u32 val;
 
 	ret = imx258_read_reg(imx258, IMX258_REG_CHIP_ID,
-			       IMX258_REG_VALUE_16BIT, &val);
+			      IMX258_REG_VALUE_16BIT, &val);
 	if (ret) {
 		dev_err(&client->dev, "failed to read chip id %x\n",
 			IMX258_CHIP_ID);


-- 
Sakari Ailus
sakari.ailus@linux.intel.com
