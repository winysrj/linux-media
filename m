Return-path: <linux-media-owner@vger.kernel.org>
Received: from hermes.mlbassoc.com ([64.234.241.98]:47793 "EHLO
	mail.chez-thomas.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab2A3Rab (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Jan 2012 12:30:31 -0500
Message-ID: <4F26D3A4.6010907@mlbassoc.com>
Date: Mon, 30 Jan 2012 10:30:12 -0700
From: Gary Thomas <gary@mlbassoc.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Javier Martinez Canillas <martinez.javier@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Enrico <ebutera@users.berlios.de>
Subject: Re: [PATCH] Adding YUV input support for OMAP3ISP driver
References: <EBE38CF866F2F94F95FA9A8CB3EF2284069CAE@singex1.aptina.com> <4F182013.90401@mlbassoc.com> <CA+2YH7vMFgzwrdBsXzBdYKG5kb8bTwtPnAnp8z_zjFFQenzzFQ@mail.gmail.com> <201201201319.45490.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201201201319.45490.laurent.pinchart@ideasonboard.com>
Content-Type: multipart/mixed;
 boundary="------------000506060405070808070100"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000506060405070808070100
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 2012-01-20 05:19, Laurent Pinchart wrote:
> Hi Enrico,
>
> On Thursday 19 January 2012 15:17:57 Enrico wrote:
>> On Thu, Jan 19, 2012 at 2:52 PM, Gary Thomas<gary@mlbassoc.com>  wrote:
>>> On 2012-01-19 06:35, Gary Thomas wrote:
>>>> My camera init code is attached. In the previous kernel, the I2C bus was
>>>> probed implicitly when I initialized the OMAP3ISP. I thought I
>>>> remembered some discussion about how that worked (maybe changing), so
>>>> this is probably
>>>> where the problem starts.
>>>>
>>>> If you have an example, I can check my setup against it.
>>>
>>> Note: I reworked how the sensor+I2C was initialized to be
>>>         omap3_init_camera(&cobra3530p73_isp_platform_data);
>>>
>>>   omap_register_i2c_bus(cobra3530p73_isp_platform_data.subdevs->subdevs[0]
>>> .i2c_adapter_id, 400,
>>>
>>>   cobra3530p73_isp_platform_data.subdevs->subdevs[0].board_info, 1);
>>>
>>> The TVP5150 is now found, but 'media-ctl -p' still dies :-(
>>
>> Have a look at [1] (the linux_3.2.bb file to see the list of
>> patches,inside linux-3.2 directory for the actual patches), it's based
>> on mainline kernel 3.2 and the bt656 patches i submitted months ago,
>> it should be easy to adapt it for you board.
>>
>> <rant>
>> Really, there are patches for all these problems since months (from
>> me, Javier, TI), but because no maintainer cared (apart from Laurent)
>> they were never reviewed/applied and there is always someone who comes
>> back with all the usual problems (additional yuv format, bt656 mode,
>> tvp5150 that doesn't work...).
>> </rant>
>
> I totally understand your feeling.
>
> I'd like to get YUV support integrated in the OMAP3 ISP driver. However, I
> have no YUV image source hardware, so I can only review the patches but not
> test them.
>
> If someone can rebase the existing patches on top of
> http://git.linuxtv.org/pinchartl/media.git/shortlog/refs/heads/omap3isp-
> omap3isp-yuv and test them, then I'll review the result.
>

The attached patches produce a working setup against Laurent's tree above.
That said, I don't recall exactly where which changes came from (I'm old
school and not very git savvy, sorry).  I've CC'd all the folks I think
provided at least part of these changes.  Perhaps we can all work together
to come up with a proper set of patches which can be pushed upstream
for this, once and for all?

Thanks

-- 
------------------------------------------------------------
Gary Thomas                 |  Consulting for the
MLB Associates              |    Embedded world
------------------------------------------------------------

--------------000506060405070808070100
Content-Type: text/x-patch;
 name="0001-Merge-working-driver-for-TVP5150.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-Merge-working-driver-for-TVP5150.patch"

>From 2ab6c0c7b481d116c9d7faf120efcff1ef2a732f Mon Sep 17 00:00:00 2001
From: Gary Thomas <gary@mlbassoc.com>
Date: Wed, 25 Jan 2012 07:57:21 -0700
Subject: [PATCH 1/2] Merge working driver for TVP5150

---
 drivers/media/video/tvp5150.c |  419 ++++++++++++++++++++++++++++++++++++-----
 include/media/tvp5150.h       |    6 +
 2 files changed, 375 insertions(+), 50 deletions(-)

diff --git a/drivers/media/video/tvp5150.c b/drivers/media/video/tvp5150.c
index 6be9910..a472ebe 100644
--- a/drivers/media/video/tvp5150.c
+++ b/drivers/media/video/tvp5150.c
@@ -5,15 +5,17 @@
  * This code is placed under the terms of the GNU General Public License v2
  */
 
+#include <linux/module.h>
 #include <linux/i2c.h>
 #include <linux/slab.h>
 #include <linux/videodev2.h>
 #include <linux/delay.h>
-#include <linux/module.h>
 #include <media/v4l2-device.h>
 #include <media/tvp5150.h>
 #include <media/v4l2-chip-ident.h>
 #include <media/v4l2-ctrls.h>
+#include <media/v4l2-subdev.h>
+#include <media/v4l2-mediabus.h>
 
 #include "tvp5150_reg.h"
 
@@ -26,11 +28,79 @@ static int debug;
 module_param(debug, int, 0);
 MODULE_PARM_DESC(debug, "Debug level (0-2)");
 
+/* enum tvp515x_std - enum for supported standards */
+enum tvp515x_std {
+	STD_PAL_BDGHIN = 0,
+	STD_NTSC_MJ,
+	STD_INVALID
+};
+
+/**
+ * struct tvp515x_std_info - Structure to store standard informations
+ * @width: Line width in pixels
+ * @height:Number of active lines
+ * @video_std: Value to write in REG_VIDEO_STD register
+ * @standard: v4l2 standard structure information
+ */
+struct tvp515x_std_info {
+	u8 video_std;
+	struct v4l2_standard standard;
+	struct v4l2_mbus_framefmt format;
+};
+
+/**
+ * Supported standards -
+ *
+ * Currently supports two standards only, need to add support for rest of the
+ * modes, like SECAM, etc...
+ */
+static struct tvp515x_std_info tvp515x_std_list[] = {
+	/* Standard: STD_NTSC_MJ */
+	/* Standard: STD_PAL_BDGHIN */
+	[STD_PAL_BDGHIN] = {
+		.video_std = VIDEO_STD_PAL_BDGHIN_BIT,
+		.standard = {
+			.index = 1,
+			.id = V4L2_STD_PAL,
+			.name = "PAL",
+			.frameperiod = {1, 25},
+			.framelines = 625
+		},
+		.format = {
+			.width = PAL_NUM_ACTIVE_PIXELS,
+			.height = PAL_NUM_ACTIVE_LINES,
+			.code = V4L2_MBUS_FMT_UYVY8_2X8,
+			.field = V4L2_FIELD_INTERLACED,
+			.colorspace = V4L2_COLORSPACE_SMPTE170M,
+		},
+	},
+	[STD_NTSC_MJ] = {
+		.video_std = VIDEO_STD_NTSC_MJ_BIT,
+		.standard = {
+			.index = 0,
+			.id = V4L2_STD_NTSC,
+			.name = "NTSC",
+			.frameperiod = {1001, 30000},
+			.framelines = 525
+		},
+		.format = {
+			.width = NTSC_NUM_ACTIVE_PIXELS,
+			.height = NTSC_NUM_ACTIVE_LINES,
+			.code = V4L2_MBUS_FMT_UYVY8_2X8,
+			.field = V4L2_FIELD_INTERLACED,
+			.colorspace = V4L2_COLORSPACE_SMPTE170M,
+		},
+	},
+	/* Standard: need to add for additional standard */
+};
+
 struct tvp5150 {
 	struct v4l2_subdev sd;
 	struct v4l2_ctrl_handler hdl;
-
-	v4l2_std_id norm;	/* Current set standard */
+	struct media_pad pad;
+	struct v4l2_mbus_framefmt *format;
+	v4l2_std_id std_idx;
+	int norm;
 	u32 input;
 	u32 output;
 	int enable;
@@ -693,6 +763,45 @@ static int tvp5150_get_vbi(struct v4l2_subdev *sd,
 	return type;
 }
 
+/**
+ * tvp515x_query_current_std() : Query the current standard detected by TVP5151
+ * @sd: ptr to v4l2_subdev struct
+ *
+ * Returns the current standard detected by TVP5151, STD_INVALID if there is no
+ * standard detected.
+ */
+static int tvp515x_query_current_std(struct v4l2_subdev *sd)
+{
+	u8 std, std_status;
+
+	std = tvp5150_read(sd, TVP5150_VIDEO_STD);
+	if ((std & VIDEO_STD_MASK) == VIDEO_STD_AUTO_SWITCH_BIT)
+		/* use the standard status register */
+		std_status = tvp5150_read(sd, TVP5150_STATUS_REG_5);
+	else
+		/* use the standard register itself */
+		std_status = std;
+
+	switch (std_status & VIDEO_STD_MASK) {
+	case VIDEO_STD_NTSC_MJ_BIT:
+	case VIDEO_STD_NTSC_MJ_BIT_AS:
+		return STD_NTSC_MJ;
+
+	case VIDEO_STD_PAL_BDGHIN_BIT:
+	case VIDEO_STD_PAL_BDGHIN_BIT_AS:
+		return STD_PAL_BDGHIN;
+
+	default:
+		return STD_INVALID;
+	}
+
+	return STD_INVALID;
+}
+
+/****************************************************************************
+			V4L2 subdev video operations
+ ****************************************************************************/
+
 static int tvp5150_set_std(struct v4l2_subdev *sd, v4l2_std_id std)
 {
 	struct tvp5150 *decoder = to_tvp5150(sd);
@@ -703,7 +812,7 @@ static int tvp5150_set_std(struct v4l2_subdev *sd, v4l2_std_id std)
 	/* First tests should be against specific std */
 
 	if (std == V4L2_STD_ALL) {
-		fmt = VIDEO_STD_AUTO_SWITCH_BIT;	/* Autodetect mode */
+		fmt = 0;	/* Autodetect mode */
 	} else if (std & V4L2_STD_NTSC_443) {
 		fmt = VIDEO_STD_NTSC_4_43_BIT;
 	} else if (std & V4L2_STD_PAL_M) {
@@ -728,11 +837,26 @@ static int tvp5150_set_std(struct v4l2_subdev *sd, v4l2_std_id std)
 static int tvp5150_s_std(struct v4l2_subdev *sd, v4l2_std_id std)
 {
 	struct tvp5150 *decoder = to_tvp5150(sd);
+	int i;
+	int num_stds = ARRAY_SIZE(tvp515x_std_list);
 
 	if (decoder->norm == std)
 		return 0;
 
-	return tvp5150_set_std(sd, std);
+	for (i = 0; i < num_stds; i++)
+		if (std & tvp515x_std_list[i].standard.id)
+			break;
+
+	if ((i == num_stds) || (i == STD_INVALID))
+		return -EINVAL;
+
+	tvp5150_write(sd, TVP5150_VIDEO_STD, tvp515x_std_list[i].video_std);
+
+	decoder->norm = i;
+	decoder->norm = std;
+
+/*	return tvp5150_set_std(sd, std); */
+	return 0;
 }
 
 static int tvp5150_reset(struct v4l2_subdev *sd, u32 val)
@@ -779,70 +903,177 @@ static int tvp5150_s_ctrl(struct v4l2_ctrl *ctrl)
 	return -EINVAL;
 }
 
-static v4l2_std_id tvp5150_read_std(struct v4l2_subdev *sd)
+static struct v4l2_mbus_framefmt *
+__tvp5150_get_pad_format(struct tvp5150 *tvp5150, struct v4l2_subdev_fh *fh,
+			 unsigned int pad, enum v4l2_subdev_format_whence which)
 {
-	int val = tvp5150_read(sd, TVP5150_STATUS_REG_5);
-
-	switch (val & 0x0F) {
-	case 0x01:
-		return V4L2_STD_NTSC;
-	case 0x03:
-		return V4L2_STD_PAL;
-	case 0x05:
-		return V4L2_STD_PAL_M;
-	case 0x07:
-		return V4L2_STD_PAL_N | V4L2_STD_PAL_Nc;
-	case 0x09:
-		return V4L2_STD_NTSC_443;
-	case 0xb:
-		return V4L2_STD_SECAM;
+	switch (which) {
+	case V4L2_SUBDEV_FORMAT_TRY:
+		return v4l2_subdev_get_try_format(fh, pad);
+	case V4L2_SUBDEV_FORMAT_ACTIVE:
+		return tvp5150->format;
 	default:
-		return V4L2_STD_UNKNOWN;
+		return NULL;
 	}
 }
 
-static int tvp5150_enum_mbus_fmt(struct v4l2_subdev *sd, unsigned index,
-						enum v4l2_mbus_pixelcode *code)
+static int tvp5150_get_pad_format(struct v4l2_subdev *subdev,
+			      struct v4l2_subdev_fh *fh,
+			      struct v4l2_subdev_format *format)
 {
-	if (index)
-		return -EINVAL;
+	struct tvp5150 *tvp5150 = to_tvp5150(subdev);
+
+	format->format = *__tvp5150_get_pad_format(tvp5150, fh, format->pad,
+						   format->which);
+
+	return 0;
+}
+
+static int tvp5150_set_pad_format(struct v4l2_subdev *subdev,
+			      struct v4l2_subdev_fh *fh,
+			      struct v4l2_subdev_format *format)
+{
+	struct tvp5150 *tvp5150 = to_tvp5150(subdev);
+	tvp5150->std_idx = STD_INVALID;
+
+	tvp5150->std_idx = tvp515x_query_current_std(subdev);
+	if (tvp5150->std_idx == STD_INVALID) {
+		v4l2_err(subdev, "Unable to query std\n");
+		return 0;
+	}
+
+	tvp5150->norm = tvp515x_std_list[tvp5150->std_idx].standard.id;
+
+	tvp5150->format = &tvp515x_std_list[tvp5150->std_idx].format;
+
+	format->format = *__tvp5150_get_pad_format(tvp5150, fh, format->pad,
+	format->which);
+
+	v4l2_info(subdev, "code=x%x width=%u height=%u colorspace=0x%x\n",
+			format->format.code, format->format.width,
+			format->format.height, format->format.colorspace);
 
-	*code = V4L2_MBUS_FMT_YUYV8_2X8;
 	return 0;
 }
 
-static int tvp5150_mbus_fmt(struct v4l2_subdev *sd,
-			    struct v4l2_mbus_framefmt *f)
+/**
+ * tvp515x_mbus_fmt_cap() - V4L2 decoder interface handler for try/s/g_mbus_fmt
+ * @sd: pointer to standard V4L2 sub-device structure
+ * @f: pointer to the mediabus format structure
+ *
+ * Negotiates the image capture size and mediabus format.
+ */
+static int
+tvp515x_mbus_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *f)
 {
 	struct tvp5150 *decoder = to_tvp5150(sd);
-	v4l2_std_id std;
 
 	if (f == NULL)
 		return -EINVAL;
 
-	tvp5150_reset(sd, 0);
+	f = decoder->format;
 
-	/* Calculate height and width based on current standard */
-	if (decoder->norm == V4L2_STD_ALL)
-		std = tvp5150_read_std(sd);
-	else
-		std = decoder->norm;
+	v4l2_dbg(1, debug, sd, "MBUS_FMT: Width - %d, Height - %d\n",
+			f->width, f->height);
+	return 0;
+}
+
+/*
+ * tvp515x_s_stream() - V4L2 decoder i/f handler for s_stream
+ * @sd: pointer to standard V4L2 sub-device structure
+ * @enable: streaming enable or disable
+ *
+ * Sets streaming to enable or disable, if possible.
+ */
+static int tvp515x_s_stream(struct v4l2_subdev *subdev, int enable)
+{
+
+	/* Initializes TVP5150 to its default values */
+	/* # set PCLK (27MHz) */
+	tvp5150_write(subdev, TVP5150_CONF_SHARED_PIN, 0x00);
 
-	f->width = 720;
-	if (std & V4L2_STD_525_60)
-		f->height = 480;
+	/* Output format: 8-bit ITU-R BT.656 with embedded syncs */
+	if (enable)
+		tvp5150_write(subdev, TVP5150_MISC_CTL, 0x09);
 	else
-		f->height = 576;
+		tvp5150_write(subdev, TVP5150_MISC_CTL, 0x00);
+
+	return 0;
+}
+
+
+/**
+ * tvp515x_enum_mbus_fmt() - V4L2 decoder interface handler for enum_mbus_fmt
+ * @sd: pointer to standard V4L2 sub-device structure
+ * @index: index of pixelcode to retrieve
+ * @code: receives the pixelcode
+ *
+ * Enumerates supported mediabus formats
+ */
+static int
+tvp515x_enum_mbus_fmt(struct v4l2_subdev *sd, unsigned index,
+					enum v4l2_mbus_pixelcode *code)
+{
+	if (index)
+		return -EINVAL;
+
+	*code = V4L2_MBUS_FMT_UYVY8_2X8;
+	return 0;
+}
+
+/**
+ * tvp515x_g_parm() - V4L2 decoder interface handler for g_parm
+ * @sd: pointer to standard V4L2 sub-device structure
+ * @a: pointer to standard V4L2 VIDIOC_G_PARM ioctl structure
+ *
+ * Returns the decoder's video CAPTURE parameters.
+ */
+static int
+tvp515x_g_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *a)
+{
+	struct v4l2_captureparm *cparm;
+
+	if (a == NULL)
+		return -EINVAL;
+
+	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		/* only capture is supported */
+		return -EINVAL;
+
+	cparm = &a->parm.capture;
+	cparm->capability = V4L2_CAP_TIMEPERFRAME;
+	cparm->timeperframe = a->parm.capture.timeperframe;
+
+	return 0;
+}
+
+/**
+ * tvp515x_s_parm() - V4L2 decoder interface handler for s_parm
+ * @sd: pointer to standard V4L2 sub-device structure
+ * @a: pointer to standard V4L2 VIDIOC_S_PARM ioctl structure
+ *
+ * Configures the decoder to use the input parameters, if possible. If
+ * not possible, returns the appropriate error code.
+ */
+static int
+tvp515x_s_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *a)
+{
+	struct v4l2_fract *timeperframe;
+
+	if (a == NULL)
+		return -EINVAL;
+
+	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		/* only capture is supported */
+		return -EINVAL;
 
-	f->code = V4L2_MBUS_FMT_YUYV8_2X8;
-	f->field = V4L2_FIELD_SEQ_TB;
-	f->colorspace = V4L2_COLORSPACE_SMPTE170M;
+	timeperframe = &a->parm.capture.timeperframe;
 
-	v4l2_dbg(1, debug, sd, "width = %d, height = %d\n", f->width,
-			f->height);
 	return 0;
 }
 
+
+
 /****************************************************************************
 			I2C Command
  ****************************************************************************/
@@ -965,7 +1196,33 @@ static int tvp5150_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
 	return 0;
 }
 
-/* ----------------------------------------------------------------------- */
+/****************************************************************************
+		    V4L2 subdev core operations
+ ****************************************************************************/
+
+static int tvp5150_open(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh)
+{
+	struct tvp5150 *decoder = to_tvp5150(subdev);
+
+	decoder->std_idx = STD_INVALID;
+
+	decoder->std_idx = tvp515x_query_current_std(subdev);
+
+	if (decoder->std_idx == STD_INVALID) {
+		v4l2_err(subdev, "Unable to query std\n");
+		return 0;
+	}
+
+	decoder->format = (&(tvp515x_std_list[decoder->std_idx].format));
+	decoder->norm = tvp515x_std_list[decoder->std_idx].standard.id;
+
+	return 0;
+}
+
+static int tvp5150_close(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh)
+{
+	return 0;
+}
 
 static const struct v4l2_ctrl_ops tvp5150_ctrl_ops = {
 	.s_ctrl = tvp5150_s_ctrl,
@@ -989,15 +1246,25 @@ static const struct v4l2_subdev_core_ops tvp5150_core_ops = {
 #endif
 };
 
+static struct v4l2_subdev_internal_ops tvp5150_subdev_internal_ops = {
+	.open		= tvp5150_open,
+	.close		= tvp5150_close,
+};
+
 static const struct v4l2_subdev_tuner_ops tvp5150_tuner_ops = {
 	.g_tuner = tvp5150_g_tuner,
 };
 
 static const struct v4l2_subdev_video_ops tvp5150_video_ops = {
 	.s_routing = tvp5150_s_routing,
-	.enum_mbus_fmt = tvp5150_enum_mbus_fmt,
-	.s_mbus_fmt = tvp5150_mbus_fmt,
-	.try_mbus_fmt = tvp5150_mbus_fmt,
+	.s_stream = tvp515x_s_stream,
+	.enum_mbus_fmt = tvp515x_enum_mbus_fmt,
+	.g_mbus_fmt = tvp515x_mbus_fmt,
+	.try_mbus_fmt = tvp515x_mbus_fmt,
+	.s_mbus_fmt = tvp515x_mbus_fmt,
+	.g_parm = tvp515x_g_parm,
+	.s_parm = tvp515x_s_parm,
+	.s_std_output = tvp5150_s_std,
 };
 
 static const struct v4l2_subdev_vbi_ops tvp5150_vbi_ops = {
@@ -1007,14 +1274,56 @@ static const struct v4l2_subdev_vbi_ops tvp5150_vbi_ops = {
 	.s_raw_fmt = tvp5150_s_raw_fmt,
 };
 
+static int tvp515x_enum_mbus_code(struct v4l2_subdev *subdev,
+				  struct v4l2_subdev_fh *fh,
+				  struct v4l2_subdev_mbus_code_enum *code)
+{
+	if (code->index >= ARRAY_SIZE(tvp515x_std_list))
+		return -EINVAL;
+
+	code->code = V4L2_MBUS_FMT_UYVY8_2X8;
+
+	return 0;
+}
+
+static int tvp515x_enum_frame_size(struct v4l2_subdev *subdev,
+				   struct v4l2_subdev_fh *fh,
+				   struct v4l2_subdev_frame_size_enum *fse)
+{
+	int current_std = STD_INVALID;
+
+	if (fse->code != V4L2_MBUS_FMT_UYVY8_2X8)
+		return -EINVAL;
+
+	/* query the current standard */
+	current_std = tvp515x_query_current_std(subdev);
+	if (current_std == STD_INVALID) {
+		v4l2_err(subdev, "Unable to query std\n");
+		return 0;
+	}
+
+	fse->min_width = tvp515x_std_list[current_std].format.width;
+	fse->min_height = tvp515x_std_list[current_std].format.height;
+	fse->max_width = fse->min_width;
+	fse->max_height = fse->min_height;
+	return 0;
+}
+
+static struct v4l2_subdev_pad_ops tvp5150_pad_ops = {
+	.enum_mbus_code = tvp515x_enum_mbus_code,
+	.enum_frame_size = tvp515x_enum_frame_size,
+	.get_fmt = tvp5150_get_pad_format,
+	.set_fmt = tvp5150_set_pad_format,
+};
+
 static const struct v4l2_subdev_ops tvp5150_ops = {
 	.core = &tvp5150_core_ops,
 	.tuner = &tvp5150_tuner_ops,
 	.video = &tvp5150_video_ops,
 	.vbi = &tvp5150_vbi_ops,
+	.pad = &tvp5150_pad_ops,
 };
 
-
 /****************************************************************************
 			I2C Client & Driver
  ****************************************************************************/
@@ -1025,6 +1334,7 @@ static int tvp5150_probe(struct i2c_client *c,
 	struct tvp5150 *core;
 	struct v4l2_subdev *sd;
 	u8 msb_id, lsb_id, msb_rom, lsb_rom;
+	int ret;
 
 	/* Check if the adapter supports the needed features */
 	if (!i2c_check_functionality(c->adapter,
@@ -1060,6 +1370,8 @@ static int tvp5150_probe(struct i2c_client *c,
 		}
 	}
 
+	core->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+	core->sd.internal_ops = &tvp5150_subdev_internal_ops;
 	core->norm = V4L2_STD_ALL;	/* Default is autodetect */
 	core->input = TVP5150_COMPOSITE1;
 	core->enable = 1;
@@ -1085,6 +1397,12 @@ static int tvp5150_probe(struct i2c_client *c,
 
 	if (debug > 1)
 		tvp5150_log_status(sd);
+
+	core->pad.flags = MEDIA_PAD_FL_SOURCE;
+	ret = media_entity_init(&core->sd.entity, 1, &core->pad, 0);
+	if (ret < 0)
+		kfree(core);
+
 	return 0;
 }
 
@@ -1099,6 +1417,7 @@ static int tvp5150_remove(struct i2c_client *c)
 
 	v4l2_device_unregister_subdev(sd);
 	v4l2_ctrl_handler_free(&decoder->hdl);
+	media_entity_cleanup(&sd->entity);
 	kfree(to_tvp5150(sd));
 	return 0;
 }
diff --git a/include/media/tvp5150.h b/include/media/tvp5150.h
index 72bd2a2..ccd4ed0 100644
--- a/include/media/tvp5150.h
+++ b/include/media/tvp5150.h
@@ -30,5 +30,11 @@
 #define TVP5150_NORMAL       0
 #define TVP5150_BLACK_SCREEN 1
 
+/* Number of pixels and number of lines per frame for different standards */
+#define NTSC_NUM_ACTIVE_PIXELS		(720)
+#define NTSC_NUM_ACTIVE_LINES		(480)
+#define PAL_NUM_ACTIVE_PIXELS		(720)
+#define PAL_NUM_ACTIVE_LINES		(576)
+
 #endif
 
-- 
1.7.7.5


--------------000506060405070808070100
Content-Type: text/x-patch;
 name="0002-Merge-working-BT-656-support.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0002-Merge-working-BT-656-support.patch"

>From 0eeacda5e878183315df14e9e55055bbf7a2271d Mon Sep 17 00:00:00 2001
From: Gary Thomas <gary@mlbassoc.com>
Date: Wed, 25 Jan 2012 07:57:48 -0700
Subject: [PATCH 2/2] Merge working BT-656 support

---
 drivers/media/video/omap3isp/ispccdc.c  |  142 +++++++++++++++++++++++++------
 drivers/media/video/omap3isp/ispccdc.h  |    1 +
 drivers/media/video/omap3isp/ispreg.h   |    1 +
 drivers/media/video/omap3isp/ispvideo.c |    6 +-
 drivers/media/video/omap3isp/ispvideo.h |    3 +
 include/media/omap3isp.h                |    3 +
 6 files changed, 128 insertions(+), 28 deletions(-)

diff --git a/drivers/media/video/omap3isp/ispccdc.c b/drivers/media/video/omap3isp/ispccdc.c
index 4327025..6bb29ce 100644
--- a/drivers/media/video/omap3isp/ispccdc.c
+++ b/drivers/media/video/omap3isp/ispccdc.c
@@ -62,6 +62,8 @@ static const unsigned int ccdc_fmts[] = {
 	V4L2_MBUS_FMT_UYVY8_2X8,
 };
 
+static bool ccdc_input_is_bt656(struct isp_ccdc_device *ccdc);
+
 /*
  * ccdc_print_status - Print current CCDC Module register values.
  * @ccdc: Pointer to ISP CCDC device.
@@ -794,11 +796,16 @@ static void ccdc_apply_controls(struct isp_ccdc_device *ccdc)
 void omap3isp_ccdc_restore_context(struct isp_device *isp)
 {
 	struct isp_ccdc_device *ccdc = &isp->isp_ccdc;
+	struct v4l2_mbus_framefmt *format;
 
 	isp_reg_set(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_CFG, ISPCCDC_CFG_VDLC);
 
-	ccdc->update = OMAP3ISP_CCDC_ALAW | OMAP3ISP_CCDC_LPF
-		     | OMAP3ISP_CCDC_BLCLAMP | OMAP3ISP_CCDC_BCOMP;
+	/* CCDC_PAD_SINK */
+	format = &ccdc->formats[CCDC_PAD_SINK];
+	if ((format->code != V4L2_MBUS_FMT_UYVY8_2X8) &&
+            (format->code != V4L2_MBUS_FMT_UYVY8_2X8))
+		ccdc->update = OMAP3ISP_CCDC_ALAW | OMAP3ISP_CCDC_LPF |
+			       OMAP3ISP_CCDC_BLCLAMP | OMAP3ISP_CCDC_BCOMP;
 	ccdc_apply_controls(ccdc);
 	ccdc_configure_fpc(ccdc);
 }
@@ -1012,6 +1019,9 @@ static void ccdc_config_sync_if(struct isp_ccdc_device *ccdc,
 	if (pdata && pdata->vs_pol)
 		syn_mode |= ISPCCDC_SYN_MODE_VDPOL;
 
+	if (pdata && pdata->fldmode)
+		syn_mode |= ISPCCDC_SYN_MODE_FLDMODE;
+
 	isp_reg_writel(isp, syn_mode, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SYN_MODE);
 
 	if (format->code == V4L2_MBUS_FMT_UYVY8_2X8)
@@ -1023,10 +1033,10 @@ static void ccdc_config_sync_if(struct isp_ccdc_device *ccdc,
 
 	if (pdata && pdata->bt656)
 		isp_reg_set(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_REC656IF,
-			    ISPCCDC_REC656IF_R656ON);
+			    ISPCCDC_REC656IF_R656ON | ISPCCDC_REC656IF_ECCFVH);
 	else
 		isp_reg_clr(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_REC656IF,
-			    ISPCCDC_REC656IF_R656ON);
+			    ISPCCDC_REC656IF_R656ON | ISPCCDC_REC656IF_ECCFVH);
 }
 
 /* CCDC formats descriptions */
@@ -1108,6 +1118,7 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 	struct isp_parallel_platform_data *pdata = NULL;
 	struct v4l2_subdev *sensor;
 	struct v4l2_mbus_framefmt *format;
+	struct v4l2_pix_format pix;
 	const struct isp_format_info *fmt_info;
 	struct v4l2_subdev_format fmt_src;
 	unsigned int depth_out;
@@ -1166,6 +1177,10 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 	/* CCDC_PAD_SINK */
 	format = &ccdc->formats[CCDC_PAD_SINK];
 
+	if (format->code == V4L2_MBUS_FMT_UYVY8_2X8)
+		isp_reg_set(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_CFG,
+			    ISPCCDC_CFG_Y8POS);
+
 	/* Mosaic filter */
 	switch (format->code) {
 	case V4L2_MBUS_FMT_SRGGB10_1X10:
@@ -1185,28 +1200,70 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 		ccdc_pattern = ccdc_sgrbg_pattern;
 		break;
 	}
-	ccdc_config_imgattr(ccdc, ccdc_pattern);
 
-	/* Generate VD0 on the last line of the image and VD1 on the
-	 * 2/3 height line.
-	 */
-	isp_reg_writel(isp, ((format->height - 2) << ISPCCDC_VDINT_0_SHIFT) |
-		       ((format->height * 2 / 3) << ISPCCDC_VDINT_1_SHIFT),
-		       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_VDINT);
+	if ((format->code != V4L2_MBUS_FMT_YUYV8_2X8) &&
+			(format->code != V4L2_MBUS_FMT_UYVY8_2X8))
+		ccdc_config_imgattr(ccdc, ccdc_pattern);
+
+	/* BT656: Generate VD0 on the last line of each field, and we
+	* don't use VD1.
+	* Non BT656: Generate VD0 on the last line of the image and VD1 on the
+	* 2/3 height line.
+	*/
+	if (pdata->bt656)
+		isp_reg_writel(isp,
+			(format->height/2 - 2) << ISPCCDC_VDINT_0_SHIFT,
+			OMAP3_ISP_IOMEM_CCDC, ISPCCDC_VDINT);
+	else
+		isp_reg_writel(isp,
+			((format->height - 2) << ISPCCDC_VDINT_0_SHIFT) |
+			((format->height * 2 / 3) << ISPCCDC_VDINT_1_SHIFT),
+			OMAP3_ISP_IOMEM_CCDC, ISPCCDC_VDINT);
 
 	/* CCDC_PAD_SOURCE_OF */
 	format = &ccdc->formats[CCDC_PAD_SOURCE_OF];
 
-	isp_reg_writel(isp, (0 << ISPCCDC_HORZ_INFO_SPH_SHIFT) |
-		       ((format->width - 1) << ISPCCDC_HORZ_INFO_NPH_SHIFT),
-		       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_HORZ_INFO);
+	isp_video_mbus_to_pix(&ccdc->video_out, format, &pix);
+
+	/* For BT656 the number of bytes would be width*2 */
+	if (pdata->bt656)
+		isp_reg_writel(isp, (0 << ISPCCDC_HORZ_INFO_SPH_SHIFT) |
+                               ((pix.bytesperline - 1) << ISPCCDC_HORZ_INFO_NPH_SHIFT),
+                               OMAP3_ISP_IOMEM_CCDC, ISPCCDC_HORZ_INFO);
+	else
+		isp_reg_writel(isp, (0 << ISPCCDC_HORZ_INFO_SPH_SHIFT) |
+                               ((format->width - 1) << ISPCCDC_HORZ_INFO_NPH_SHIFT),
+                               OMAP3_ISP_IOMEM_CCDC, ISPCCDC_HORZ_INFO);
 	isp_reg_writel(isp, 0 << ISPCCDC_VERT_START_SLV0_SHIFT,
 		       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_VERT_START);
-	isp_reg_writel(isp, (format->height - 1)
-			<< ISPCCDC_VERT_LINES_NLV_SHIFT,
-		       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_VERT_LINES);
 
-	ccdc_config_outlineoffset(ccdc, ccdc->video_out.bpl_value, 0, 0);
+	if (pdata->bt656)
+		isp_reg_writel(isp, ((format->height >> 1) - 1) << ISPCCDC_VERT_LINES_NLV_SHIFT,
+                               OMAP3_ISP_IOMEM_CCDC, ISPCCDC_VERT_LINES);
+	else
+		isp_reg_writel(isp, (format->height - 1) << ISPCCDC_VERT_LINES_NLV_SHIFT,
+                               OMAP3_ISP_IOMEM_CCDC, ISPCCDC_VERT_LINES);
+
+	isp_reg_clr(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SDOFST,
+		    ISPCCDC_SDOFST_LOFST_MASK << ISPCCDC_SDOFST_LOFST0_SHIFT);
+	isp_reg_clr(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SDOFST,
+		    ISPCCDC_SDOFST_LOFST_MASK << ISPCCDC_SDOFST_LOFST1_SHIFT);
+	isp_reg_clr(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SDOFST,
+		    ISPCCDC_SDOFST_LOFST_MASK << ISPCCDC_SDOFST_LOFST2_SHIFT);
+	isp_reg_clr(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SDOFST,
+		    ISPCCDC_SDOFST_LOFST_MASK << ISPCCDC_SDOFST_LOFST3_SHIFT);
+
+	/* In case of BT656 each alternate line must be stored into memory */
+	if (pdata->bt656) {
+		ccdc_config_outlineoffset(ccdc, pix.bytesperline, EVENEVEN, 1);
+		ccdc_config_outlineoffset(ccdc, pix.bytesperline, EVENODD, 1);
+		ccdc_config_outlineoffset(ccdc, pix.bytesperline, ODDEVEN, 1);
+		ccdc_config_outlineoffset(ccdc, pix.bytesperline, ODDODD, 1);
+                isp_reg_set(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SDOFST,
+                            ISPCCDC_SDOFST_FINV);
+	} else {
+		ccdc_config_outlineoffset(ccdc, ccdc->video_out.bpl_value, 0, 0);
+	}
 
 	/* CCDC_PAD_SOURCE_VP */
 	format = &ccdc->formats[CCDC_PAD_SOURCE_VP];
@@ -1253,6 +1310,11 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 unlock:
 	spin_unlock_irqrestore(&ccdc->lsc.req_lock, flags);
 
+	if (pdata->bt656)
+		ccdc->update = OMAP3ISP_CCDC_BLCLAMP;
+	else
+		ccdc->update = 0;
+
 	ccdc_apply_controls(ccdc);
 }
 
@@ -1264,6 +1326,7 @@ static void __ccdc_enable(struct isp_ccdc_device *ccdc, int enable)
 			ISPCCDC_PCR_EN, enable ? ISPCCDC_PCR_EN : 0);
 }
 
+static int __ccdc_handle_stopping(struct isp_ccdc_device *ccdc, u32 event);
 static int ccdc_disable(struct isp_ccdc_device *ccdc)
 {
 	unsigned long flags;
@@ -1274,6 +1337,11 @@ static int ccdc_disable(struct isp_ccdc_device *ccdc)
 		ccdc->stopping = CCDC_STOP_REQUEST;
 	spin_unlock_irqrestore(&ccdc->lock, flags);
 
+	__ccdc_lsc_enable(ccdc, 0);
+	__ccdc_enable(ccdc, 0);
+	ccdc->stopping = CCDC_STOP_EXECUTED;
+	__ccdc_handle_stopping(ccdc, CCDC_STOP_FINISHED);
+
 	ret = wait_event_timeout(ccdc->wait,
 				 ccdc->stopping == CCDC_STOP_FINISHED,
 				 msecs_to_jiffies(2000));
@@ -1526,9 +1594,31 @@ static void ccdc_vd0_isr(struct isp_ccdc_device *ccdc)
 {
 	unsigned long flags;
 	int restart = 0;
-
-	if (ccdc->output & CCDC_OUTPUT_MEMORY)
-		restart = ccdc_isr_buffer(ccdc);
+	struct isp_device *isp = to_isp_device(ccdc);
+ 
+	if (ccdc->output & CCDC_OUTPUT_MEMORY) {
+		if (ccdc_input_is_bt656(ccdc)) {
+			u32 fid;
+			u32 syn_mode = isp_reg_readl(isp, OMAP3_ISP_IOMEM_CCDC,
+					ISPCCDC_SYN_MODE);
+
+			fid = (syn_mode & ISPCCDC_SYN_MODE_FLDSTAT) == 0;
+			/* toggle the software maintained fid */
+			ccdc->fldstat ^= 1;
+
+			if (fid == ccdc->fldstat) {
+				if (fid == 0) {
+					restart = ccdc_isr_buffer(ccdc);
+					goto done;
+				}
+			} else if (fid == 0) {
+				ccdc->fldstat = fid;
+			}
+		} else {
+			restart = ccdc_isr_buffer(ccdc);
+		}
+	}
+done:
 
 	spin_lock_irqsave(&ccdc->lock, flags);
 	if (__ccdc_handle_stopping(ccdc, CCDC_EVENT_VD0)) {
@@ -1615,7 +1705,8 @@ int omap3isp_ccdc_isr(struct isp_ccdc_device *ccdc, u32 events)
 	if (ccdc->state == ISP_PIPELINE_STREAM_STOPPED)
 		return 0;
 
-	if (events & IRQ0STATUS_CCDC_VD1_IRQ)
+	if (!ccdc_input_is_bt656(ccdc) &&
+            (events & IRQ0STATUS_CCDC_VD1_IRQ))
 		ccdc_vd1_isr(ccdc);
 
 	ccdc_lsc_isr(ccdc, events);
@@ -1623,7 +1714,8 @@ int omap3isp_ccdc_isr(struct isp_ccdc_device *ccdc, u32 events)
 	if (events & IRQ0STATUS_CCDC_VD0_IRQ)
 		ccdc_vd0_isr(ccdc);
 
-	if (events & IRQ0STATUS_HS_VS_IRQ)
+	if (!ccdc_input_is_bt656(ccdc) &&
+            (events & IRQ0STATUS_HS_VS_IRQ))
 		ccdc_hs_vs_isr(ccdc);
 
 	return 0;
@@ -1737,7 +1829,7 @@ static int ccdc_set_stream(struct v4l2_subdev *sd, int enable)
 		 * links are inactive.
 		 */
 		ccdc_config_vp(ccdc);
-		ccdc_enable_vp(ccdc, 1);
+		ccdc_enable_vp(ccdc, 0);
 		ccdc_print_status(ccdc);
 	}
 
@@ -2286,7 +2378,7 @@ int omap3isp_ccdc_init(struct isp_device *isp)
 
 	ccdc->vpcfg.pixelclk = 0;
 
-	ccdc->update = OMAP3ISP_CCDC_BLCLAMP;
+	ccdc->update = 0;
 	ccdc_apply_controls(ccdc);
 
 	ret = ccdc_init_entities(ccdc);
diff --git a/drivers/media/video/omap3isp/ispccdc.h b/drivers/media/video/omap3isp/ispccdc.h
index 836439a..2d31250 100644
--- a/drivers/media/video/omap3isp/ispccdc.h
+++ b/drivers/media/video/omap3isp/ispccdc.h
@@ -157,6 +157,7 @@ struct isp_ccdc_device {
 	struct ispccdc_vp vpcfg;
 
 	unsigned int underrun:1;
+	unsigned int fldstat:1;
 	enum isp_pipeline_stream_state state;
 	spinlock_t lock;
 	wait_queue_head_t wait;
diff --git a/drivers/media/video/omap3isp/ispreg.h b/drivers/media/video/omap3isp/ispreg.h
index 084ea77..f9c2e47 100644
--- a/drivers/media/video/omap3isp/ispreg.h
+++ b/drivers/media/video/omap3isp/ispreg.h
@@ -824,6 +824,7 @@
 #define ISPCCDC_SDOFST_LOFST2_SHIFT		3
 #define ISPCCDC_SDOFST_LOFST1_SHIFT		6
 #define ISPCCDC_SDOFST_LOFST0_SHIFT		9
+#define ISPCCDC_SDOFST_LOFST_MASK               0x7
 #define EVENEVEN				1
 #define ODDEVEN					2
 #define EVENODD					3
diff --git a/drivers/media/video/omap3isp/ispvideo.c b/drivers/media/video/omap3isp/ispvideo.c
index 9107106..fd7be8d 100644
--- a/drivers/media/video/omap3isp/ispvideo.c
+++ b/drivers/media/video/omap3isp/ispvideo.c
@@ -165,9 +165,9 @@ static bool isp_video_is_shiftable(enum v4l2_mbus_pixelcode in,
  *
  * Return the number of padding bytes at end of line.
  */
-static unsigned int isp_video_mbus_to_pix(const struct isp_video *video,
-					  const struct v4l2_mbus_framefmt *mbus,
-					  struct v4l2_pix_format *pix)
+unsigned int isp_video_mbus_to_pix(const struct isp_video *video,
+                                   const struct v4l2_mbus_framefmt *mbus,
+                                   struct v4l2_pix_format *pix)
 {
 	unsigned int bpl = pix->bytesperline;
 	unsigned int min_bpl;
diff --git a/drivers/media/video/omap3isp/ispvideo.h b/drivers/media/video/omap3isp/ispvideo.h
index d52c508..e6e0a96 100644
--- a/drivers/media/video/omap3isp/ispvideo.h
+++ b/drivers/media/video/omap3isp/ispvideo.h
@@ -204,6 +204,9 @@ void omap3isp_video_unregister(struct isp_video *video);
 struct isp_buffer *omap3isp_video_buffer_next(struct isp_video *video);
 void omap3isp_video_resume(struct isp_video *video, int continuous);
 struct media_pad *omap3isp_video_remote_pad(struct isp_video *video);
+extern unsigned int isp_video_mbus_to_pix(const struct isp_video *video,
+                                          const struct v4l2_mbus_framefmt *mbus,
+                                          struct v4l2_pix_format *pix);
 
 const struct isp_format_info *
 omap3isp_video_format_info(enum v4l2_mbus_pixelcode code);
diff --git a/include/media/omap3isp.h b/include/media/omap3isp.h
index f67b8c1..e1feb13 100644
--- a/include/media/omap3isp.h
+++ b/include/media/omap3isp.h
@@ -61,6 +61,8 @@ enum {
  *		0 - Normal, 1 - One's complement
  * @bt656: ITU-R BT656 embedded synchronization
  *		0 - HS/VS sync, 1 - BT656 sync
+ * @fldmode: Field mode
+ *             0 - progressive, 1 - Interlaced
  */
 struct isp_parallel_platform_data {
 	unsigned int data_lane_shift:2;
@@ -69,6 +71,7 @@ struct isp_parallel_platform_data {
 	unsigned int vs_pol:1;
 	unsigned int data_pol:1;
 	unsigned int bt656:1;
+	unsigned int fldmode:1;
 };
 
 enum {
-- 
1.7.7.5


--------------000506060405070808070100--
