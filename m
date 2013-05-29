Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:4759 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965680Ab3E2LA6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 May 2013 07:00:58 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCHv1 17/38] soc_camera sensors: remove g_chip_ident op.
Date: Wed, 29 May 2013 12:59:50 +0200
Message-Id: <1369825211-29770-18-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369825211-29770-1-git-send-email-hverkuil@xs4all.nl>
References: <1369825211-29770-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This is no longer needed since the core now handles this through DBG_G_CHIP_INFO.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/i2c/soc_camera/imx074.c     |   19 ------------
 drivers/media/i2c/soc_camera/mt9m001.c    |   33 ++------------------
 drivers/media/i2c/soc_camera/mt9m111.c    |   33 ++------------------
 drivers/media/i2c/soc_camera/mt9t031.c    |   32 ++------------------
 drivers/media/i2c/soc_camera/mt9t112.c    |   16 ----------
 drivers/media/i2c/soc_camera/mt9v022.c    |   47 ++++++++---------------------
 drivers/media/i2c/soc_camera/ov2640.c     |   16 ----------
 drivers/media/i2c/soc_camera/ov5642.c     |   19 ------------
 drivers/media/i2c/soc_camera/ov6650.c     |   12 --------
 drivers/media/i2c/soc_camera/ov772x.c     |   16 ----------
 drivers/media/i2c/soc_camera/ov9640.c     |   16 ----------
 drivers/media/i2c/soc_camera/ov9740.c     |   17 -----------
 drivers/media/i2c/soc_camera/rj54n1cb0c.c |   31 ++-----------------
 drivers/media/i2c/soc_camera/tw9910.c     |   14 ---------
 14 files changed, 21 insertions(+), 300 deletions(-)

diff --git a/drivers/media/i2c/soc_camera/imx074.c b/drivers/media/i2c/soc_camera/imx074.c
index a2a5cbb..a315d43 100644
--- a/drivers/media/i2c/soc_camera/imx074.c
+++ b/drivers/media/i2c/soc_camera/imx074.c
@@ -19,7 +19,6 @@
 
 #include <media/soc_camera.h>
 #include <media/v4l2-subdev.h>
-#include <media/v4l2-chip-ident.h>
 
 /* IMX074 registers */
 
@@ -251,23 +250,6 @@ static int imx074_s_stream(struct v4l2_subdev *sd, int enable)
 	return reg_write(client, MODE_SELECT, !!enable);
 }
 
-static int imx074_g_chip_ident(struct v4l2_subdev *sd,
-			       struct v4l2_dbg_chip_ident *id)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	if (id->match.type != V4L2_CHIP_MATCH_I2C_ADDR)
-		return -EINVAL;
-
-	if (id->match.addr != client->addr)
-		return -ENODEV;
-
-	id->ident	= V4L2_IDENT_IMX074;
-	id->revision	= 0;
-
-	return 0;
-}
-
 static int imx074_s_power(struct v4l2_subdev *sd, int on)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
@@ -299,7 +281,6 @@ static struct v4l2_subdev_video_ops imx074_subdev_video_ops = {
 };
 
 static struct v4l2_subdev_core_ops imx074_subdev_core_ops = {
-	.g_chip_ident	= imx074_g_chip_ident,
 	.s_power	= imx074_s_power,
 };
 
diff --git a/drivers/media/i2c/soc_camera/mt9m001.c b/drivers/media/i2c/soc_camera/mt9m001.c
index dd90898..3f1f437 100644
--- a/drivers/media/i2c/soc_camera/mt9m001.c
+++ b/drivers/media/i2c/soc_camera/mt9m001.c
@@ -17,7 +17,6 @@
 #include <media/soc_camera.h>
 #include <media/soc_mediabus.h>
 #include <media/v4l2-subdev.h>
-#include <media/v4l2-chip-ident.h>
 #include <media/v4l2-ctrls.h>
 
 /*
@@ -97,7 +96,6 @@ struct mt9m001 {
 	const struct mt9m001_datafmt *fmt;
 	const struct mt9m001_datafmt *fmts;
 	int num_fmts;
-	int model;	/* V4L2_IDENT_MT9M001* codes from v4l2-chip-ident.h */
 	unsigned int total_h;
 	unsigned short y_skip_top;	/* Lines to skip at the top */
 };
@@ -320,36 +318,15 @@ static int mt9m001_try_fmt(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int mt9m001_g_chip_ident(struct v4l2_subdev *sd,
-				struct v4l2_dbg_chip_ident *id)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct mt9m001 *mt9m001 = to_mt9m001(client);
-
-	if (id->match.type != V4L2_CHIP_MATCH_I2C_ADDR)
-		return -EINVAL;
-
-	if (id->match.addr != client->addr)
-		return -ENODEV;
-
-	id->ident	= mt9m001->model;
-	id->revision	= 0;
-
-	return 0;
-}
-
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 static int mt9m001_g_register(struct v4l2_subdev *sd,
 			      struct v4l2_dbg_register *reg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
-	if (reg->match.type != V4L2_CHIP_MATCH_I2C_ADDR || reg->reg > 0xff)
+	if (reg->reg > 0xff)
 		return -EINVAL;
 
-	if (reg->match.addr != client->addr)
-		return -ENODEV;
-
 	reg->size = 2;
 	reg->val = reg_read(client, reg->reg);
 
@@ -364,12 +341,9 @@ static int mt9m001_s_register(struct v4l2_subdev *sd,
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
-	if (reg->match.type != V4L2_CHIP_MATCH_I2C_ADDR || reg->reg > 0xff)
+	if (reg->reg > 0xff)
 		return -EINVAL;
 
-	if (reg->match.addr != client->addr)
-		return -ENODEV;
-
 	if (reg_write(client, reg->reg, reg->val) < 0)
 		return -EIO;
 
@@ -505,11 +479,9 @@ static int mt9m001_video_probe(struct soc_camera_subdev_desc *ssdd,
 	switch (data) {
 	case 0x8411:
 	case 0x8421:
-		mt9m001->model = V4L2_IDENT_MT9M001C12ST;
 		mt9m001->fmts = mt9m001_colour_fmts;
 		break;
 	case 0x8431:
-		mt9m001->model = V4L2_IDENT_MT9M001C12STM;
 		mt9m001->fmts = mt9m001_monochrome_fmts;
 		break;
 	default:
@@ -580,7 +552,6 @@ static const struct v4l2_ctrl_ops mt9m001_ctrl_ops = {
 };
 
 static struct v4l2_subdev_core_ops mt9m001_subdev_core_ops = {
-	.g_chip_ident	= mt9m001_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register	= mt9m001_g_register,
 	.s_register	= mt9m001_s_register,
diff --git a/drivers/media/i2c/soc_camera/mt9m111.c b/drivers/media/i2c/soc_camera/mt9m111.c
index 8bd4e0d..1aaca04 100644
--- a/drivers/media/i2c/soc_camera/mt9m111.c
+++ b/drivers/media/i2c/soc_camera/mt9m111.c
@@ -19,7 +19,6 @@
 #include <media/soc_camera.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ctrls.h>
-#include <media/v4l2-chip-ident.h>
 
 /*
  * MT9M111, MT9M112 and MT9M131:
@@ -205,8 +204,6 @@ struct mt9m111 {
 	struct v4l2_subdev subdev;
 	struct v4l2_ctrl_handler hdl;
 	struct v4l2_ctrl *gain;
-	int model;	/* V4L2_IDENT_MT9M111 or V4L2_IDENT_MT9M112 code
-			 * from v4l2-chip-ident.h */
 	struct mt9m111_context *ctx;
 	struct v4l2_rect rect;	/* cropping rectangle */
 	int width;		/* output */
@@ -600,24 +597,6 @@ static int mt9m111_s_fmt(struct v4l2_subdev *sd,
 	return ret;
 }
 
-static int mt9m111_g_chip_ident(struct v4l2_subdev *sd,
-				struct v4l2_dbg_chip_ident *id)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct mt9m111 *mt9m111 = container_of(sd, struct mt9m111, subdev);
-
-	if (id->match.type != V4L2_CHIP_MATCH_I2C_ADDR)
-		return -EINVAL;
-
-	if (id->match.addr != client->addr)
-		return -ENODEV;
-
-	id->ident	= mt9m111->model;
-	id->revision	= 0;
-
-	return 0;
-}
-
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 static int mt9m111_g_register(struct v4l2_subdev *sd,
 			      struct v4l2_dbg_register *reg)
@@ -625,10 +604,8 @@ static int mt9m111_g_register(struct v4l2_subdev *sd,
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	int val;
 
-	if (reg->match.type != V4L2_CHIP_MATCH_I2C_ADDR || reg->reg > 0x2ff)
+	if (reg->reg > 0x2ff)
 		return -EINVAL;
-	if (reg->match.addr != client->addr)
-		return -ENODEV;
 
 	val = mt9m111_reg_read(client, reg->reg);
 	reg->size = 2;
@@ -645,12 +622,9 @@ static int mt9m111_s_register(struct v4l2_subdev *sd,
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
-	if (reg->match.type != V4L2_CHIP_MATCH_I2C_ADDR || reg->reg > 0x2ff)
+	if (reg->reg > 0x2ff)
 		return -EINVAL;
 
-	if (reg->match.addr != client->addr)
-		return -ENODEV;
-
 	if (mt9m111_reg_write(client, reg->reg, reg->val) < 0)
 		return -EIO;
 
@@ -856,7 +830,6 @@ static const struct v4l2_ctrl_ops mt9m111_ctrl_ops = {
 };
 
 static struct v4l2_subdev_core_ops mt9m111_subdev_core_ops = {
-	.g_chip_ident	= mt9m111_g_chip_ident,
 	.s_power	= mt9m111_s_power,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register	= mt9m111_g_register,
@@ -923,12 +896,10 @@ static int mt9m111_video_probe(struct i2c_client *client)
 
 	switch (data) {
 	case 0x143a: /* MT9M111 or MT9M131 */
-		mt9m111->model = V4L2_IDENT_MT9M111;
 		dev_info(&client->dev,
 			"Detected a MT9M111/MT9M131 chip ID %x\n", data);
 		break;
 	case 0x148c: /* MT9M112 */
-		mt9m111->model = V4L2_IDENT_MT9M112;
 		dev_info(&client->dev, "Detected a MT9M112 chip ID %x\n", data);
 		break;
 	default:
diff --git a/drivers/media/i2c/soc_camera/mt9t031.c b/drivers/media/i2c/soc_camera/mt9t031.c
index 26a15b8..1d2cc27 100644
--- a/drivers/media/i2c/soc_camera/mt9t031.c
+++ b/drivers/media/i2c/soc_camera/mt9t031.c
@@ -18,7 +18,6 @@
 #include <linux/module.h>
 
 #include <media/soc_camera.h>
-#include <media/v4l2-chip-ident.h>
 #include <media/v4l2-subdev.h>
 #include <media/v4l2-ctrls.h>
 
@@ -76,7 +75,6 @@ struct mt9t031 {
 		struct v4l2_ctrl *exposure;
 	};
 	struct v4l2_rect rect;	/* Sensor window */
-	int model;	/* V4L2_IDENT_MT9T031* codes from v4l2-chip-ident.h */
 	u16 xskip;
 	u16 yskip;
 	unsigned int total_h;
@@ -391,36 +389,15 @@ static int mt9t031_try_fmt(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int mt9t031_g_chip_ident(struct v4l2_subdev *sd,
-				struct v4l2_dbg_chip_ident *id)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct mt9t031 *mt9t031 = to_mt9t031(client);
-
-	if (id->match.type != V4L2_CHIP_MATCH_I2C_ADDR)
-		return -EINVAL;
-
-	if (id->match.addr != client->addr)
-		return -ENODEV;
-
-	id->ident	= mt9t031->model;
-	id->revision	= 0;
-
-	return 0;
-}
-
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 static int mt9t031_g_register(struct v4l2_subdev *sd,
 			      struct v4l2_dbg_register *reg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
-	if (reg->match.type != V4L2_CHIP_MATCH_I2C_ADDR || reg->reg > 0xff)
+	if (reg->reg > 0xff)
 		return -EINVAL;
 
-	if (reg->match.addr != client->addr)
-		return -ENODEV;
-
 	reg->val = reg_read(client, reg->reg);
 
 	if (reg->val > 0xffff)
@@ -434,12 +411,9 @@ static int mt9t031_s_register(struct v4l2_subdev *sd,
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
-	if (reg->match.type != V4L2_CHIP_MATCH_I2C_ADDR || reg->reg > 0xff)
+	if (reg->reg > 0xff)
 		return -EINVAL;
 
-	if (reg->match.addr != client->addr)
-		return -ENODEV;
-
 	if (reg_write(client, reg->reg, reg->val) < 0)
 		return -EIO;
 
@@ -650,7 +624,6 @@ static int mt9t031_video_probe(struct i2c_client *client)
 
 	switch (data) {
 	case 0x1621:
-		mt9t031->model = V4L2_IDENT_MT9T031;
 		break;
 	default:
 		dev_err(&client->dev,
@@ -685,7 +658,6 @@ static const struct v4l2_ctrl_ops mt9t031_ctrl_ops = {
 };
 
 static struct v4l2_subdev_core_ops mt9t031_subdev_core_ops = {
-	.g_chip_ident	= mt9t031_g_chip_ident,
 	.s_power	= mt9t031_s_power,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register	= mt9t031_g_register,
diff --git a/drivers/media/i2c/soc_camera/mt9t112.c b/drivers/media/i2c/soc_camera/mt9t112.c
index a7256b7..0391d01 100644
--- a/drivers/media/i2c/soc_camera/mt9t112.c
+++ b/drivers/media/i2c/soc_camera/mt9t112.c
@@ -27,7 +27,6 @@
 
 #include <media/mt9t112.h>
 #include <media/soc_camera.h>
-#include <media/v4l2-chip-ident.h>
 #include <media/v4l2-common.h>
 
 /* you can check PLL/clock info */
@@ -91,7 +90,6 @@ struct mt9t112_priv {
 	struct i2c_client		*client;
 	struct v4l2_rect		 frame;
 	const struct mt9t112_format	*format;
-	int				 model;
 	int				 num_formats;
 	u32				 flags;
 /* for flags */
@@ -738,17 +736,6 @@ static int mt9t112_init_camera(const struct i2c_client *client)
 /************************************************************************
 			v4l2_subdev_core_ops
 ************************************************************************/
-static int mt9t112_g_chip_ident(struct v4l2_subdev *sd,
-				struct v4l2_dbg_chip_ident *id)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct mt9t112_priv *priv = to_mt9t112(client);
-
-	id->ident    = priv->model;
-	id->revision = 0;
-
-	return 0;
-}
 
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 static int mt9t112_g_register(struct v4l2_subdev *sd,
@@ -786,7 +773,6 @@ static int mt9t112_s_power(struct v4l2_subdev *sd, int on)
 }
 
 static struct v4l2_subdev_core_ops mt9t112_subdev_core_ops = {
-	.g_chip_ident	= mt9t112_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register	= mt9t112_g_register,
 	.s_register	= mt9t112_s_register,
@@ -1061,12 +1047,10 @@ static int mt9t112_camera_probe(struct i2c_client *client)
 	switch (chipid) {
 	case 0x2680:
 		devname = "mt9t111";
-		priv->model = V4L2_IDENT_MT9T111;
 		priv->num_formats = 1;
 		break;
 	case 0x2682:
 		devname = "mt9t112";
-		priv->model = V4L2_IDENT_MT9T112;
 		priv->num_formats = ARRAY_SIZE(mt9t112_cfmts);
 		break;
 	default:
diff --git a/drivers/media/i2c/soc_camera/mt9v022.c b/drivers/media/i2c/soc_camera/mt9v022.c
index a295e59..41ff453 100644
--- a/drivers/media/i2c/soc_camera/mt9v022.c
+++ b/drivers/media/i2c/soc_camera/mt9v022.c
@@ -19,7 +19,6 @@
 #include <media/soc_camera.h>
 #include <media/soc_mediabus.h>
 #include <media/v4l2-subdev.h>
-#include <media/v4l2-chip-ident.h>
 #include <media/v4l2-ctrls.h>
 
 /*
@@ -133,6 +132,11 @@ static const struct mt9v02x_register mt9v024_register = {
 	.pixclk_fv_lv			= MT9V024_PIXCLK_FV_LV,
 };
 
+enum mt9v022_model {
+	MT9V022IX7ATM,
+	MT9V022IX7ATC,
+};
+
 struct mt9v022 {
 	struct v4l2_subdev subdev;
 	struct v4l2_ctrl_handler hdl;
@@ -153,7 +157,7 @@ struct mt9v022 {
 	const struct mt9v022_datafmt *fmts;
 	const struct mt9v02x_register *reg;
 	int num_fmts;
-	int model;	/* V4L2_IDENT_MT9V022* codes from v4l2-chip-ident.h */
+	enum mt9v022_model model;
 	u16 chip_control;
 	u16 chip_version;
 	unsigned short y_skip_top;	/* Lines to skip at the top */
@@ -406,12 +410,12 @@ static int mt9v022_s_fmt(struct v4l2_subdev *sd,
 	switch (mf->code) {
 	case V4L2_MBUS_FMT_Y8_1X8:
 	case V4L2_MBUS_FMT_Y10_1X10:
-		if (mt9v022->model != V4L2_IDENT_MT9V022IX7ATM)
+		if (mt9v022->model != MT9V022IX7ATM)
 			return -EINVAL;
 		break;
 	case V4L2_MBUS_FMT_SBGGR8_1X8:
 	case V4L2_MBUS_FMT_SBGGR10_1X10:
-		if (mt9v022->model != V4L2_IDENT_MT9V022IX7ATC)
+		if (mt9v022->model != MT9V022IX7ATC)
 			return -EINVAL;
 		break;
 	default:
@@ -457,36 +461,15 @@ static int mt9v022_try_fmt(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int mt9v022_g_chip_ident(struct v4l2_subdev *sd,
-				struct v4l2_dbg_chip_ident *id)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct mt9v022 *mt9v022 = to_mt9v022(client);
-
-	if (id->match.type != V4L2_CHIP_MATCH_I2C_ADDR)
-		return -EINVAL;
-
-	if (id->match.addr != client->addr)
-		return -ENODEV;
-
-	id->ident	= mt9v022->model;
-	id->revision	= 0;
-
-	return 0;
-}
-
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 static int mt9v022_g_register(struct v4l2_subdev *sd,
 			      struct v4l2_dbg_register *reg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
-	if (reg->match.type != V4L2_CHIP_MATCH_I2C_ADDR || reg->reg > 0xff)
+	if (reg->reg > 0xff)
 		return -EINVAL;
 
-	if (reg->match.addr != client->addr)
-		return -ENODEV;
-
 	reg->size = 2;
 	reg->val = reg_read(client, reg->reg);
 
@@ -501,12 +484,9 @@ static int mt9v022_s_register(struct v4l2_subdev *sd,
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
-	if (reg->match.type != V4L2_CHIP_MATCH_I2C_ADDR || reg->reg > 0xff)
+	if (reg->reg > 0xff)
 		return -EINVAL;
 
-	if (reg->match.addr != client->addr)
-		return -ENODEV;
-
 	if (reg_write(client, reg->reg, reg->val) < 0)
 		return -EIO;
 
@@ -706,11 +686,11 @@ static int mt9v022_video_probe(struct i2c_client *client)
 	if (sensor_type && (!strcmp("colour", sensor_type) ||
 			    !strcmp("color", sensor_type))) {
 		ret = reg_write(client, MT9V022_PIXEL_OPERATION_MODE, 4 | 0x11);
-		mt9v022->model = V4L2_IDENT_MT9V022IX7ATC;
+		mt9v022->model = MT9V022IX7ATC;
 		mt9v022->fmts = mt9v022_colour_fmts;
 	} else {
 		ret = reg_write(client, MT9V022_PIXEL_OPERATION_MODE, 0x11);
-		mt9v022->model = V4L2_IDENT_MT9V022IX7ATM;
+		mt9v022->model = MT9V022IX7ATM;
 		mt9v022->fmts = mt9v022_monochrome_fmts;
 	}
 
@@ -740,7 +720,7 @@ static int mt9v022_video_probe(struct i2c_client *client)
 	mt9v022->fmt = &mt9v022->fmts[0];
 
 	dev_info(&client->dev, "Detected a MT9V022 chip ID %x, %s sensor\n",
-		 data, mt9v022->model == V4L2_IDENT_MT9V022IX7ATM ?
+		 data, mt9v022->model == MT9V022IX7ATM ?
 		 "monochrome" : "colour");
 
 	ret = mt9v022_init(client);
@@ -768,7 +748,6 @@ static const struct v4l2_ctrl_ops mt9v022_ctrl_ops = {
 };
 
 static struct v4l2_subdev_core_ops mt9v022_subdev_core_ops = {
-	.g_chip_ident	= mt9v022_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register	= mt9v022_g_register,
 	.s_register	= mt9v022_s_register,
diff --git a/drivers/media/i2c/soc_camera/ov2640.c b/drivers/media/i2c/soc_camera/ov2640.c
index e316842..7961cba 100644
--- a/drivers/media/i2c/soc_camera/ov2640.c
+++ b/drivers/media/i2c/soc_camera/ov2640.c
@@ -22,7 +22,6 @@
 #include <linux/videodev2.h>
 
 #include <media/soc_camera.h>
-#include <media/v4l2-chip-ident.h>
 #include <media/v4l2-subdev.h>
 #include <media/v4l2-ctrls.h>
 
@@ -304,7 +303,6 @@ struct ov2640_priv {
 	struct v4l2_ctrl_handler	hdl;
 	enum v4l2_mbus_pixelcode	cfmt_code;
 	const struct ov2640_win_size	*win;
-	int				model;
 };
 
 /*
@@ -723,18 +721,6 @@ static int ov2640_s_ctrl(struct v4l2_ctrl *ctrl)
 	return -EINVAL;
 }
 
-static int ov2640_g_chip_ident(struct v4l2_subdev *sd,
-			       struct v4l2_dbg_chip_ident *id)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct ov2640_priv *priv = to_ov2640(client);
-
-	id->ident    = priv->model;
-	id->revision = 0;
-
-	return 0;
-}
-
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 static int ov2640_g_register(struct v4l2_subdev *sd,
 			     struct v4l2_dbg_register *reg)
@@ -1009,7 +995,6 @@ static int ov2640_video_probe(struct i2c_client *client)
 	switch (VERSION(pid, ver)) {
 	case PID_OV2640:
 		devname     = "ov2640";
-		priv->model = V4L2_IDENT_OV2640;
 		break;
 	default:
 		dev_err(&client->dev,
@@ -1034,7 +1019,6 @@ static const struct v4l2_ctrl_ops ov2640_ctrl_ops = {
 };
 
 static struct v4l2_subdev_core_ops ov2640_subdev_core_ops = {
-	.g_chip_ident	= ov2640_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register	= ov2640_g_register,
 	.s_register	= ov2640_s_register,
diff --git a/drivers/media/i2c/soc_camera/ov5642.c b/drivers/media/i2c/soc_camera/ov5642.c
index 9aa56de..c93a157 100644
--- a/drivers/media/i2c/soc_camera/ov5642.c
+++ b/drivers/media/i2c/soc_camera/ov5642.c
@@ -24,7 +24,6 @@
 #include <linux/v4l2-mediabus.h>
 
 #include <media/soc_camera.h>
-#include <media/v4l2-chip-ident.h>
 #include <media/v4l2-subdev.h>
 
 /* OV5642 registers */
@@ -848,23 +847,6 @@ static int ov5642_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
 	return 0;
 }
 
-static int ov5642_g_chip_ident(struct v4l2_subdev *sd,
-			       struct v4l2_dbg_chip_ident *id)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	if (id->match.type != V4L2_CHIP_MATCH_I2C_ADDR)
-		return -EINVAL;
-
-	if (id->match.addr != client->addr)
-		return -ENODEV;
-
-	id->ident	= V4L2_IDENT_OV5642;
-	id->revision	= 0;
-
-	return 0;
-}
-
 static int ov5642_s_crop(struct v4l2_subdev *sd, const struct v4l2_crop *a)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
@@ -966,7 +948,6 @@ static struct v4l2_subdev_video_ops ov5642_subdev_video_ops = {
 
 static struct v4l2_subdev_core_ops ov5642_subdev_core_ops = {
 	.s_power	= ov5642_s_power,
-	.g_chip_ident	= ov5642_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register	= ov5642_get_register,
 	.s_register	= ov5642_set_register,
diff --git a/drivers/media/i2c/soc_camera/ov6650.c b/drivers/media/i2c/soc_camera/ov6650.c
index 991202d..d2869d8 100644
--- a/drivers/media/i2c/soc_camera/ov6650.c
+++ b/drivers/media/i2c/soc_camera/ov6650.c
@@ -32,7 +32,6 @@
 #include <linux/module.h>
 
 #include <media/soc_camera.h>
-#include <media/v4l2-chip-ident.h>
 #include <media/v4l2-ctrls.h>
 
 /* Register definitions */
@@ -390,16 +389,6 @@ static int ov6550_s_ctrl(struct v4l2_ctrl *ctrl)
 	return -EINVAL;
 }
 
-/* Get chip identification */
-static int ov6650_g_chip_ident(struct v4l2_subdev *sd,
-				struct v4l2_dbg_chip_ident *id)
-{
-	id->ident	= V4L2_IDENT_OV6650;
-	id->revision	= 0;
-
-	return 0;
-}
-
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 static int ov6650_get_register(struct v4l2_subdev *sd,
 				struct v4l2_dbg_register *reg)
@@ -879,7 +868,6 @@ static const struct v4l2_ctrl_ops ov6550_ctrl_ops = {
 };
 
 static struct v4l2_subdev_core_ops ov6650_core_ops = {
-	.g_chip_ident		= ov6650_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register		= ov6650_get_register,
 	.s_register		= ov6650_set_register,
diff --git a/drivers/media/i2c/soc_camera/ov772x.c b/drivers/media/i2c/soc_camera/ov772x.c
index 713d62e..b2f6236 100644
--- a/drivers/media/i2c/soc_camera/ov772x.c
+++ b/drivers/media/i2c/soc_camera/ov772x.c
@@ -27,7 +27,6 @@
 #include <media/ov772x.h>
 #include <media/soc_camera.h>
 #include <media/v4l2-ctrls.h>
-#include <media/v4l2-chip-ident.h>
 #include <media/v4l2-subdev.h>
 
 /*
@@ -399,7 +398,6 @@ struct ov772x_priv {
 	struct ov772x_camera_info        *info;
 	const struct ov772x_color_format *cfmt;
 	const struct ov772x_win_size     *win;
-	int                               model;
 	unsigned short                    flag_vflip:1;
 	unsigned short                    flag_hflip:1;
 	/* band_filter = COM8[5] ? 256 - BDBASE : 0 */
@@ -620,17 +618,6 @@ static int ov772x_s_ctrl(struct v4l2_ctrl *ctrl)
 	return -EINVAL;
 }
 
-static int ov772x_g_chip_ident(struct v4l2_subdev *sd,
-			       struct v4l2_dbg_chip_ident *id)
-{
-	struct ov772x_priv *priv = to_ov772x(sd);
-
-	id->ident    = priv->model;
-	id->revision = 0;
-
-	return 0;
-}
-
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 static int ov772x_g_register(struct v4l2_subdev *sd,
 			     struct v4l2_dbg_register *reg)
@@ -965,11 +952,9 @@ static int ov772x_video_probe(struct ov772x_priv *priv)
 	switch (VERSION(pid, ver)) {
 	case OV7720:
 		devname     = "ov7720";
-		priv->model = V4L2_IDENT_OV7720;
 		break;
 	case OV7725:
 		devname     = "ov7725";
-		priv->model = V4L2_IDENT_OV7725;
 		break;
 	default:
 		dev_err(&client->dev,
@@ -997,7 +982,6 @@ static const struct v4l2_ctrl_ops ov772x_ctrl_ops = {
 };
 
 static struct v4l2_subdev_core_ops ov772x_subdev_core_ops = {
-	.g_chip_ident	= ov772x_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register	= ov772x_g_register,
 	.s_register	= ov772x_s_register,
diff --git a/drivers/media/i2c/soc_camera/ov9640.c b/drivers/media/i2c/soc_camera/ov9640.c
index 20ca62d..6817be3 100644
--- a/drivers/media/i2c/soc_camera/ov9640.c
+++ b/drivers/media/i2c/soc_camera/ov9640.c
@@ -28,7 +28,6 @@
 #include <linux/videodev2.h>
 
 #include <media/soc_camera.h>
-#include <media/v4l2-chip-ident.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ctrls.h>
 
@@ -287,18 +286,6 @@ static int ov9640_s_ctrl(struct v4l2_ctrl *ctrl)
 	return -EINVAL;
 }
 
-/* Get chip identification */
-static int ov9640_g_chip_ident(struct v4l2_subdev *sd,
-				struct v4l2_dbg_chip_ident *id)
-{
-	struct ov9640_priv *priv = to_ov9640_sensor(sd);
-
-	id->ident	= priv->model;
-	id->revision	= priv->revision;
-
-	return 0;
-}
-
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 static int ov9640_get_register(struct v4l2_subdev *sd,
 				struct v4l2_dbg_register *reg)
@@ -615,12 +602,10 @@ static int ov9640_video_probe(struct i2c_client *client)
 	switch (VERSION(pid, ver)) {
 	case OV9640_V2:
 		devname		= "ov9640";
-		priv->model	= V4L2_IDENT_OV9640;
 		priv->revision	= 2;
 		break;
 	case OV9640_V3:
 		devname		= "ov9640";
-		priv->model	= V4L2_IDENT_OV9640;
 		priv->revision	= 3;
 		break;
 	default:
@@ -644,7 +629,6 @@ static const struct v4l2_ctrl_ops ov9640_ctrl_ops = {
 };
 
 static struct v4l2_subdev_core_ops ov9640_core_ops = {
-	.g_chip_ident		= ov9640_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register		= ov9640_get_register,
 	.s_register		= ov9640_set_register,
diff --git a/drivers/media/i2c/soc_camera/ov9740.c b/drivers/media/i2c/soc_camera/ov9740.c
index 012bd62..0bc21a6 100644
--- a/drivers/media/i2c/soc_camera/ov9740.c
+++ b/drivers/media/i2c/soc_camera/ov9740.c
@@ -17,7 +17,6 @@
 #include <linux/v4l2-mediabus.h>
 
 #include <media/soc_camera.h>
-#include <media/v4l2-chip-ident.h>
 #include <media/v4l2-ctrls.h>
 
 #define to_ov9740(sd)		container_of(sd, struct ov9740_priv, subdev)
@@ -197,7 +196,6 @@ struct ov9740_priv {
 	struct v4l2_subdev		subdev;
 	struct v4l2_ctrl_handler	hdl;
 
-	int				ident;
 	u16				model;
 	u8				revision;
 	u8				manid;
@@ -772,18 +770,6 @@ static int ov9740_s_ctrl(struct v4l2_ctrl *ctrl)
 	return 0;
 }
 
-/* Get chip identification */
-static int ov9740_g_chip_ident(struct v4l2_subdev *sd,
-			       struct v4l2_dbg_chip_ident *id)
-{
-	struct ov9740_priv *priv = to_ov9740(sd);
-
-	id->ident = priv->ident;
-	id->revision = priv->revision;
-
-	return 0;
-}
-
 static int ov9740_s_power(struct v4l2_subdev *sd, int on)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
@@ -887,8 +873,6 @@ static int ov9740_video_probe(struct i2c_client *client)
 		goto done;
 	}
 
-	priv->ident = V4L2_IDENT_OV9740;
-
 	dev_info(&client->dev, "ov9740 Model ID 0x%04x, Revision 0x%02x, "
 		 "Manufacturer 0x%02x, SMIA Version 0x%02x\n",
 		 priv->model, priv->revision, priv->manid, priv->smiaver);
@@ -927,7 +911,6 @@ static struct v4l2_subdev_video_ops ov9740_video_ops = {
 };
 
 static struct v4l2_subdev_core_ops ov9740_core_ops = {
-	.g_chip_ident		= ov9740_g_chip_ident,
 	.s_power		= ov9740_s_power,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register		= ov9740_get_register,
diff --git a/drivers/media/i2c/soc_camera/rj54n1cb0c.c b/drivers/media/i2c/soc_camera/rj54n1cb0c.c
index 1f9ec3b..81b515c 100644
--- a/drivers/media/i2c/soc_camera/rj54n1cb0c.c
+++ b/drivers/media/i2c/soc_camera/rj54n1cb0c.c
@@ -18,7 +18,6 @@
 #include <media/rj54n1cb0c.h>
 #include <media/soc_camera.h>
 #include <media/v4l2-subdev.h>
-#include <media/v4l2-chip-ident.h>
 #include <media/v4l2-ctrls.h>
 
 #define RJ54N1_DEV_CODE			0x0400
@@ -1120,37 +1119,16 @@ static int rj54n1_s_fmt(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int rj54n1_g_chip_ident(struct v4l2_subdev *sd,
-			       struct v4l2_dbg_chip_ident *id)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	if (id->match.type != V4L2_CHIP_MATCH_I2C_ADDR)
-		return -EINVAL;
-
-	if (id->match.addr != client->addr)
-		return -ENODEV;
-
-	id->ident	= V4L2_IDENT_RJ54N1CB0C;
-	id->revision	= 0;
-
-	return 0;
-}
-
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 static int rj54n1_g_register(struct v4l2_subdev *sd,
 			     struct v4l2_dbg_register *reg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
-	if (reg->match.type != V4L2_CHIP_MATCH_I2C_ADDR ||
-	    reg->reg < 0x400 || reg->reg > 0x1fff)
+	if (reg->reg < 0x400 || reg->reg > 0x1fff)
 		/* Registers > 0x0800 are only available from Sharp support */
 		return -EINVAL;
 
-	if (reg->match.addr != client->addr)
-		return -ENODEV;
-
 	reg->size = 1;
 	reg->val = reg_read(client, reg->reg);
 
@@ -1165,14 +1143,10 @@ static int rj54n1_s_register(struct v4l2_subdev *sd,
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
-	if (reg->match.type != V4L2_CHIP_MATCH_I2C_ADDR ||
-	    reg->reg < 0x400 || reg->reg > 0x1fff)
+	if (reg->reg < 0x400 || reg->reg > 0x1fff)
 		/* Registers >= 0x0800 are only available from Sharp support */
 		return -EINVAL;
 
-	if (reg->match.addr != client->addr)
-		return -ENODEV;
-
 	if (reg_write(client, reg->reg, reg->val) < 0)
 		return -EIO;
 
@@ -1233,7 +1207,6 @@ static const struct v4l2_ctrl_ops rj54n1_ctrl_ops = {
 };
 
 static struct v4l2_subdev_core_ops rj54n1_subdev_core_ops = {
-	.g_chip_ident	= rj54n1_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register	= rj54n1_g_register,
 	.s_register	= rj54n1_s_register,
diff --git a/drivers/media/i2c/soc_camera/tw9910.c b/drivers/media/i2c/soc_camera/tw9910.c
index bad90b1..8a2ac24 100644
--- a/drivers/media/i2c/soc_camera/tw9910.c
+++ b/drivers/media/i2c/soc_camera/tw9910.c
@@ -27,7 +27,6 @@
 
 #include <media/soc_camera.h>
 #include <media/tw9910.h>
-#include <media/v4l2-chip-ident.h>
 #include <media/v4l2-subdev.h>
 
 #define GET_ID(val)  ((val & 0xF8) >> 3)
@@ -518,18 +517,6 @@ static int tw9910_s_std(struct v4l2_subdev *sd, v4l2_std_id norm)
 	return 0;
 }
 
-static int tw9910_g_chip_ident(struct v4l2_subdev *sd,
-			       struct v4l2_dbg_chip_ident *id)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct tw9910_priv *priv = to_tw9910(client);
-
-	id->ident = V4L2_IDENT_TW9910;
-	id->revision = priv->revision;
-
-	return 0;
-}
-
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 static int tw9910_g_register(struct v4l2_subdev *sd,
 			     struct v4l2_dbg_register *reg)
@@ -823,7 +810,6 @@ done:
 }
 
 static struct v4l2_subdev_core_ops tw9910_subdev_core_ops = {
-	.g_chip_ident	= tw9910_g_chip_ident,
 	.s_std		= tw9910_s_std,
 	.g_std		= tw9910_g_std,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
-- 
1.7.10.4

