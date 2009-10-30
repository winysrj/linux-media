Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:59598 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932225AbZJ3OnC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Oct 2009 10:43:02 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Date: Fri, 30 Oct 2009 09:43:01 -0500
Subject: RE: [PATCH 2/9] v4l: add new v4l2-subdev sensor operations, use
 g_skip_top_lines in soc-camera
Message-ID: <A69FA2915331DC488A831521EAE36FE40155798784@dlee06.ent.ti.com>
References: <Pine.LNX.4.64.0910301338140.4378@axis700.grange>
 <Pine.LNX.4.64.0910301403550.4378@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0910301403550.4378@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi,


> 	mt9m111->rect.left	= MT9M111_MIN_DARK_COLS;
> 	mt9m111->rect.top	= MT9M111_MIN_DARK_ROWS;
>diff --git a/drivers/media/video/mt9t031.c b/drivers/media/video/mt9t031.c
>index 6966f64..57e04e9 100644
>--- a/drivers/media/video/mt9t031.c
>+++ b/drivers/media/video/mt9t031.c
>@@ -301,9 +301,9 @@ static int mt9t031_set_params(struct soc_camera_device
>*icd,
> 		ret = reg_write(client, MT9T031_WINDOW_WIDTH, rect->width - 1);
> 	if (ret >= 0)
> 		ret = reg_write(client, MT9T031_WINDOW_HEIGHT,
>-				rect->height + icd->y_skip_top - 1);
>+				rect->height - 1);
Why y_skip_top is removed? When I connect the sensor output to our SOC input and do format conversion and resize on the fly (frame by frame conversion before writing to SDRAM) I have found that the frame completion interrupt fails to get generated with zero value for y_skip_top. I have used a value
of 10 and it worked fine for me. So I would like to have a s_skip_top_lines() in the sensor operations which can be called to update
this value from the host/bridge driver. 

> 	if (ret >= 0 && mt9t031->autoexposure) {
>-		unsigned int total_h = rect->height + icd->y_skip_top + vblank;
>+		unsigned int total_h = rect->height + vblank;
> 		ret = set_shutter(client, total_h);
> 		if (ret >= 0) {
> 			const u32 shutter_max = MT9T031_MAX_HEIGHT + vblank;
>@@ -656,8 +656,7 @@ static int mt9t031_s_ctrl(struct v4l2_subdev *sd,
>struct v4l2_control *ctrl)
> 		if (ctrl->value) {
> 			const u16 vblank = MT9T031_VERTICAL_BLANK;
> 			const u32 shutter_max = MT9T031_MAX_HEIGHT + vblank;
>-			unsigned int total_h = mt9t031->rect.height +
>-				icd->y_skip_top + vblank;
>+			unsigned int total_h = mt9t031->rect.height + vblank;
>
> 			if (set_shutter(client, total_h) < 0)
> 				return -EIO;
>@@ -773,7 +772,6 @@ static int mt9t031_probe(struct i2c_client *client,
>
> 	/* Second stage probe - when a capture adapter is there */
> 	icd->ops		= &mt9t031_ops;
>-	icd->y_skip_top		= 0;
>
> 	mt9t031->rect.left	= MT9T031_COLUMN_SKIP;
> 	mt9t031->rect.top	= MT9T031_ROW_SKIP;
>diff --git a/drivers/media/video/mt9v022.c b/drivers/media/video/mt9v022.c
>index 995607f..b71898f 100644
>--- a/drivers/media/video/mt9v022.c
>+++ b/drivers/media/video/mt9v022.c
>@@ -97,6 +97,7 @@ struct mt9v022 {
> 	__u32 fourcc;
> 	int model;	/* V4L2_IDENT_MT9V022* codes from v4l2-chip-ident.h */
> 	u16 chip_control;
>+	unsigned short y_skip_top;	/* Lines to skip at the top */
> };
>
> static struct mt9v022 *to_mt9v022(const struct i2c_client *client)
>@@ -265,7 +266,6 @@ static int mt9v022_s_crop(struct v4l2_subdev *sd,
>struct v4l2_crop *a)
> 	struct i2c_client *client = sd->priv;
> 	struct mt9v022 *mt9v022 = to_mt9v022(client);
> 	struct v4l2_rect rect = a->c;
>-	struct soc_camera_device *icd = client->dev.platform_data;
> 	int ret;
>
> 	/* Bayer format - even size lengths */
>@@ -287,10 +287,10 @@ static int mt9v022_s_crop(struct v4l2_subdev *sd,
>struct v4l2_crop *a)
> 	if (ret >= 0) {
> 		if (ret & 1) /* Autoexposure */
> 			ret = reg_write(client, MT9V022_MAX_TOTAL_SHUTTER_WIDTH,
>-					rect.height + icd->y_skip_top + 43);
>+					rect.height + mt9v022->y_skip_top + 43);
> 		else
> 			ret = reg_write(client, MT9V022_TOTAL_SHUTTER_WIDTH,
>-					rect.height + icd->y_skip_top + 43);
>+					rect.height + mt9v022->y_skip_top + 43);
> 	}
> 	/* Setup frame format: defaults apart from width and height */
> 	if (!ret)
>@@ -309,7 +309,7 @@ static int mt9v022_s_crop(struct v4l2_subdev *sd,
>struct v4l2_crop *a)
> 		ret = reg_write(client, MT9V022_WINDOW_WIDTH, rect.width);
> 	if (!ret)
> 		ret = reg_write(client, MT9V022_WINDOW_HEIGHT,
>-				rect.height + icd->y_skip_top);
>+				rect.height + mt9v022->y_skip_top);
>
> 	if (ret < 0)
> 		return ret;
>@@ -410,15 +410,15 @@ static int mt9v022_s_fmt(struct v4l2_subdev *sd,
>struct v4l2_format *f)
> static int mt9v022_try_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
> {
> 	struct i2c_client *client = sd->priv;
>-	struct soc_camera_device *icd = client->dev.platform_data;
>+	struct mt9v022 *mt9v022 = to_mt9v022(client);
> 	struct v4l2_pix_format *pix = &f->fmt.pix;
> 	int align = pix->pixelformat == V4L2_PIX_FMT_SBGGR8 ||
> 		pix->pixelformat == V4L2_PIX_FMT_SBGGR16;
>
> 	v4l_bound_align_image(&pix->width, MT9V022_MIN_WIDTH,
> 		MT9V022_MAX_WIDTH, align,
>-		&pix->height, MT9V022_MIN_HEIGHT + icd->y_skip_top,
>-		MT9V022_MAX_HEIGHT + icd->y_skip_top, align, 0);
>+		&pix->height, MT9V022_MIN_HEIGHT + mt9v022->y_skip_top,
>+		MT9V022_MAX_HEIGHT + mt9v022->y_skip_top, align, 0);
>
> 	return 0;
> }
>@@ -787,6 +787,16 @@ static void mt9v022_video_remove(struct
>soc_camera_device *icd)
> 		icl->free_bus(icl);
> }
>
>+static int mt9v022_g_skip_top_lines(struct v4l2_subdev *sd, u32 *lines)
>+{
>+	struct i2c_client *client = sd->priv;
>+	struct mt9v022 *mt9v022 = to_mt9v022(client);
>+
>+	*lines = mt9v022->y_skip_top;
>+
>+	return 0;
>+}
>+
> static struct v4l2_subdev_core_ops mt9v022_subdev_core_ops = {
> 	.g_ctrl		= mt9v022_g_ctrl,
> 	.s_ctrl		= mt9v022_s_ctrl,
>@@ -807,9 +817,14 @@ static struct v4l2_subdev_video_ops
>mt9v022_subdev_video_ops = {
> 	.cropcap	= mt9v022_cropcap,
> };
>
>+static struct v4l2_subdev_sensor_ops mt9v022_subdev_sensor_ops = {
>+	.g_skip_top_lines	= mt9v022_g_skip_top_lines,
>+};
>+
> static struct v4l2_subdev_ops mt9v022_subdev_ops = {
> 	.core	= &mt9v022_subdev_core_ops,
> 	.video	= &mt9v022_subdev_video_ops,
>+	.sensor	= &mt9v022_subdev_sensor_ops,
> };
>
> static int mt9v022_probe(struct i2c_client *client,
>@@ -851,8 +866,7 @@ static int mt9v022_probe(struct i2c_client *client,
> 	 * MT9V022 _really_ corrupts the first read out line.
> 	 * TODO: verify on i.MX31
> 	 */
>-	icd->y_skip_top		= 1;
>-
>+	mt9v022->y_skip_top	= 1;
> 	mt9v022->rect.left	= MT9V022_COLUMN_SKIP;
> 	mt9v022->rect.top	= MT9V022_ROW_SKIP;
> 	mt9v022->rect.width	= MT9V022_MAX_WIDTH;
>diff --git a/drivers/media/video/pxa_camera.c
>b/drivers/media/video/pxa_camera.c
>index 51b683c..4df09a6 100644
>--- a/drivers/media/video/pxa_camera.c
>+++ b/drivers/media/video/pxa_camera.c
>@@ -1051,8 +1051,13 @@ static void pxa_camera_setup_cicr(struct
>soc_camera_device *icd,
> {
> 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> 	struct pxa_camera_dev *pcdev = ici->priv;
>+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
> 	unsigned long dw, bpp;
>-	u32 cicr0, cicr1, cicr2, cicr3, cicr4 = 0;
>+	u32 cicr0, cicr1, cicr2, cicr3, cicr4 = 0, y_skip_top;
>+	int ret = v4l2_subdev_call(sd, sensor, g_skip_top_lines,
>&y_skip_top);
>+
>+	if (ret < 0)
>+		y_skip_top = 0;
>
> 	/* Datawidth is now guaranteed to be equal to one of the three values.
> 	 * We fix bit-per-pixel equal to data-width... */
>@@ -1118,7 +1123,7 @@ static void pxa_camera_setup_cicr(struct
>soc_camera_device *icd,
>
> 	cicr2 = 0;
> 	cicr3 = CICR3_LPF_VAL(icd->user_height - 1) |
>-		CICR3_BFW_VAL(min((unsigned short)255, icd->y_skip_top));
>+		CICR3_BFW_VAL(min((u32)255, y_skip_top));
> 	cicr4 |= pcdev->mclk_divisor;
>
> 	__raw_writel(cicr1, pcdev->base + CICR1);
>diff --git a/drivers/media/video/soc_camera_platform.c
>b/drivers/media/video/soc_camera_platform.c
>index b6a575c..c7c9151 100644
>--- a/drivers/media/video/soc_camera_platform.c
>+++ b/drivers/media/video/soc_camera_platform.c
>@@ -128,7 +128,6 @@ static int soc_camera_platform_probe(struct
>platform_device *pdev)
> 	/* Set the control device reference */
> 	dev_set_drvdata(&icd->dev, &pdev->dev);
>
>-	icd->y_skip_top		= 0;
> 	icd->ops		= &soc_camera_platform_ops;
>
> 	ici = to_soc_camera_host(icd->dev.parent);
>diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
>index c5afc8c..218639f 100644
>--- a/include/media/soc_camera.h
>+++ b/include/media/soc_camera.h
>@@ -24,7 +24,6 @@ struct soc_camera_device {
> 	struct device *pdev;		/* Platform device */
> 	s32 user_width;
> 	s32 user_height;
>-	unsigned short y_skip_top;	/* Lines to skip at the top */
> 	unsigned char iface;		/* Host number */
> 	unsigned char devnum;		/* Device number per host */
> 	unsigned char buswidth;		/* See comment in .c */
>diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
>index d411345..04193eb 100644
>--- a/include/media/v4l2-subdev.h
>+++ b/include/media/v4l2-subdev.h
>@@ -227,8 +227,20 @@ struct v4l2_subdev_video_ops {
> 	int (*s_crop)(struct v4l2_subdev *sd, struct v4l2_crop *crop);
> 	int (*g_parm)(struct v4l2_subdev *sd, struct v4l2_streamparm *param);
> 	int (*s_parm)(struct v4l2_subdev *sd, struct v4l2_streamparm *param);
>+};
>+
>+/**
>+ * struct v4l2_subdev_sensor_ops - v4l2-subdev sensor operations
>+ * @enum_framesizes: enumerate supported framesizes
>+ * @enum_frameintervals: enumerate supported frame format intervals
>+ * @g_skip_top_lines: number of lines at the top of the image to be
>skipped.
>+ *		      This is needed for some sensors, that always corrupt
>+ *		      several top lines of the output image.
>+ */
>+struct v4l2_subdev_sensor_ops {
> 	int (*enum_framesizes)(struct v4l2_subdev *sd, struct
>v4l2_frmsizeenum *fsize);
> 	int (*enum_frameintervals)(struct v4l2_subdev *sd, struct
>v4l2_frmivalenum *fival);
>+	int (*g_skip_top_lines)(struct v4l2_subdev *sd, u32 *lines);
> };
>
> struct v4l2_subdev_ops {
>@@ -236,6 +248,7 @@ struct v4l2_subdev_ops {
> 	const struct v4l2_subdev_tuner_ops *tuner;
> 	const struct v4l2_subdev_audio_ops *audio;
> 	const struct v4l2_subdev_video_ops *video;
>+	const struct v4l2_subdev_sensor_ops *sensor;
> };
>
> #define V4L2_SUBDEV_NAME_SIZE 32
>--
>1.6.2.4
>

