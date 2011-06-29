Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33063 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456Ab1F2Jvp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2011 05:51:45 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: achew@nvidia.com
Subject: Re: [PATCH 4/6 v3] [media] ov9740: Remove hardcoded resolution regs
Date: Wed, 29 Jun 2011 11:52:00 +0200
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	g.liakhovetski@gmx.de, mchehab@redhat.com, olof@lixom.net
References: <1308871184-6307-1-git-send-email-achew@nvidia.com> <1308871184-6307-4-git-send-email-achew@nvidia.com>
In-Reply-To: <1308871184-6307-4-git-send-email-achew@nvidia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106291152.00992.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Andrew,

Thanks for the patch.

On Friday 24 June 2011 01:19:42 achew@nvidia.com wrote:
> From: Andrew Chew <achew@nvidia.com>
> 
> Derive resolution-dependent register settings programmatically.
> 
> Signed-off-by: Andrew Chew <achew@nvidia.com>
> ---
>  drivers/media/video/ov9740.c |  210
> +++++++++++++++++++++++------------------- 1 files changed, 114
> insertions(+), 96 deletions(-)
> 
> diff --git a/drivers/media/video/ov9740.c b/drivers/media/video/ov9740.c
> index 72c6ac1d..decd706 100644
> --- a/drivers/media/video/ov9740.c
> +++ b/drivers/media/video/ov9740.c
> @@ -181,27 +181,8 @@
>  #define OV9740_MIPI_CTRL_3012		0x3012
>  #define OV9740_SC_CMMM_MIPI_CTR		0x3014
> 
> -/* supported resolutions */
> -enum {
> -	OV9740_VGA,
> -	OV9740_720P,
> -};
> -
> -struct ov9740_resolution {
> -	unsigned int width;
> -	unsigned int height;
> -};
> -
> -static struct ov9740_resolution ov9740_resolutions[] = {
> -	[OV9740_VGA] = {
> -		.width	= 640,
> -		.height	= 480,
> -	},
> -	[OV9740_720P] = {
> -		.width	= 1280,
> -		.height	= 720,
> -	},
> -};
> +#define OV9740_MAX_WIDTH		1280
> +#define OV9740_MAX_HEIGHT		720
> 
>  /* Misc. structures */
>  struct ov9740_reg {
> @@ -403,54 +384,6 @@ static const struct ov9740_reg ov9740_defaults[] = {
>  	{ OV9740_ISP_CTRL19,		0x02 },
>  };
> 
> -static const struct ov9740_reg ov9740_regs_vga[] = {
> -	{ OV9740_X_ADDR_START_HI,	0x00 },
> -	{ OV9740_X_ADDR_START_LO,	0xa0 },
> -	{ OV9740_Y_ADDR_START_HI,	0x00 },
> -	{ OV9740_Y_ADDR_START_LO,	0x00 },
> -	{ OV9740_X_ADDR_END_HI,		0x04 },
> -	{ OV9740_X_ADDR_END_LO,		0x63 },
> -	{ OV9740_Y_ADDR_END_HI,		0x02 },
> -	{ OV9740_Y_ADDR_END_LO,		0xd3 },
> -	{ OV9740_X_OUTPUT_SIZE_HI,	0x02 },
> -	{ OV9740_X_OUTPUT_SIZE_LO,	0x80 },
> -	{ OV9740_Y_OUTPUT_SIZE_HI,	0x01 },
> -	{ OV9740_Y_OUTPUT_SIZE_LO,	0xe0 },
> -	{ OV9740_ISP_CTRL1E,		0x03 },
> -	{ OV9740_ISP_CTRL1F,		0xc0 },
> -	{ OV9740_ISP_CTRL20,		0x02 },
> -	{ OV9740_ISP_CTRL21,		0xd0 },
> -	{ OV9740_VFIFO_READ_START_HI,	0x01 },
> -	{ OV9740_VFIFO_READ_START_LO,	0x40 },
> -	{ OV9740_ISP_CTRL00,		0xff },
> -	{ OV9740_ISP_CTRL01,		0xff },
> -	{ OV9740_ISP_CTRL03,		0xff },
> -};
> -
> -static const struct ov9740_reg ov9740_regs_720p[] = {
> -	{ OV9740_X_ADDR_START_HI,	0x00 },
> -	{ OV9740_X_ADDR_START_LO,	0x00 },
> -	{ OV9740_Y_ADDR_START_HI,	0x00 },
> -	{ OV9740_Y_ADDR_START_LO,	0x00 },
> -	{ OV9740_X_ADDR_END_HI,		0x05 },
> -	{ OV9740_X_ADDR_END_LO,		0x03 },
> -	{ OV9740_Y_ADDR_END_HI,		0x02 },
> -	{ OV9740_Y_ADDR_END_LO,		0xd3 },
> -	{ OV9740_X_OUTPUT_SIZE_HI,	0x05 },
> -	{ OV9740_X_OUTPUT_SIZE_LO,	0x00 },
> -	{ OV9740_Y_OUTPUT_SIZE_HI,	0x02 },
> -	{ OV9740_Y_OUTPUT_SIZE_LO,	0xd0 },
> -	{ OV9740_ISP_CTRL1E,		0x05 },
> -	{ OV9740_ISP_CTRL1F,		0x00 },
> -	{ OV9740_ISP_CTRL20,		0x02 },
> -	{ OV9740_ISP_CTRL21,		0xd0 },
> -	{ OV9740_VFIFO_READ_START_HI,	0x02 },
> -	{ OV9740_VFIFO_READ_START_LO,	0x30 },
> -	{ OV9740_ISP_CTRL00,		0xff },
> -	{ OV9740_ISP_CTRL01,		0xef },
> -	{ OV9740_ISP_CTRL03,		0xff },
> -};
> -
>  static enum v4l2_mbus_pixelcode ov9740_codes[] = {
>  	V4L2_MBUS_FMT_YUYV8_2X8,
>  };
> @@ -727,39 +660,124 @@ static int ov9740_set_register(struct v4l2_subdev
> *sd, /* select nearest higher resolution for capture */
>  static void ov9740_res_roundup(u32 *width, u32 *height)
>  {
> -	int i;
> +	/* Width must be a multiple of 4 pixels. */
> +	*width = ALIGN(*width, 4);
> 
> -	for (i = 0; i < ARRAY_SIZE(ov9740_resolutions); i++)
> -		if ((ov9740_resolutions[i].width >= *width) &&
> -		    (ov9740_resolutions[i].height >= *height)) {
> -			*width = ov9740_resolutions[i].width;
> -			*height = ov9740_resolutions[i].height;
> -			return;
> -		}
> +	/* Max resolution is 1280x720 (720p). */
> +	if (*width > OV9740_MAX_WIDTH)
> +		*width = OV9740_MAX_WIDTH;
> 
> -	*width = ov9740_resolutions[OV9740_720P].width;
> -	*height = ov9740_resolutions[OV9740_720P].height;
> +	if (*height > OV9740_MAX_HEIGHT)
> +		*height = OV9740_MAX_HEIGHT;
>  }
> 
>  /* Setup registers according to resolution and color encoding */
> -static int ov9740_set_res(struct i2c_client *client, u32 width)
> +static int ov9740_set_res(struct i2c_client *client, u32 width, u32
> height) {
> +	u32 x_start;
> +	u32 y_start;
> +	u32 x_end;
> +	u32 y_end;
> +	bool scaling = 0;
> +	u32 scale_input_x;
> +	u32 scale_input_y;
>  	int ret;
> 
> -	/* select register configuration for given resolution */
> -	if (width == ov9740_resolutions[OV9740_VGA].width) {
> -		dev_dbg(&client->dev, "Setting image size to 640x480\n");
> -		ret = ov9740_reg_write_array(client, ov9740_regs_vga,
> -					     ARRAY_SIZE(ov9740_regs_vga));
> -	} else if (width == ov9740_resolutions[OV9740_720P].width) {
> -		dev_dbg(&client->dev, "Setting image size to 1280x720\n");
> -		ret = ov9740_reg_write_array(client, ov9740_regs_720p,
> -					     ARRAY_SIZE(ov9740_regs_720p));
> +	if ((width != OV9740_MAX_WIDTH) || (height != OV9740_MAX_HEIGHT))
> +		scaling = 1;
> +
> +	/*
> +	 * Try to use as much of the sensor area as possible when supporting
> +	 * smaller resolutions.  Depending on the aspect ratio of the
> +	 * chosen resolution, we can either use the full width of the sensor,
> +	 * or the full height of the sensor (or both if the aspect ratio is
> +	 * the same as 1280x720.
> +	 */
> +	if ((OV9740_MAX_WIDTH * height) > (OV9740_MAX_HEIGHT * width)) {
> +		scale_input_x = (OV9740_MAX_HEIGHT * width) / height;
> +		scale_input_y = OV9740_MAX_HEIGHT;
>  	} else {
> -		dev_err(&client->dev, "Failed to select resolution!\n");
> -		return -EINVAL;
> +		scale_input_x = OV9740_MAX_WIDTH;
> +		scale_input_y = (OV9740_MAX_WIDTH * height) / width;
>  	}
> 
> +	/* These describe the area of the sensor to use. */
> +	x_start = (OV9740_MAX_WIDTH - scale_input_x) / 2;
> +	y_start = (OV9740_MAX_HEIGHT - scale_input_y) / 2;
> +	x_end = x_start + scale_input_x - 1;
> +	y_end = y_start + scale_input_y - 1;
> +
> +	ret = ov9740_reg_write(client, OV9740_X_ADDR_START_HI, x_start >> 8);
> +	if (ret)
> +		goto done;
> +	ret = ov9740_reg_write(client, OV9740_X_ADDR_START_LO, x_start & 0xff);
> +	if (ret)
> +		goto done;
> +	ret = ov9740_reg_write(client, OV9740_Y_ADDR_START_HI, y_start >> 8);
> +	if (ret)
> +		goto done;
> +	ret = ov9740_reg_write(client, OV9740_Y_ADDR_START_LO, y_start & 0xff);
> +	if (ret)
> +		goto done;
> +
> +	ret = ov9740_reg_write(client, OV9740_X_ADDR_END_HI, x_end >> 8);
> +	if (ret)
> +		goto done;
> +	ret = ov9740_reg_write(client, OV9740_X_ADDR_END_LO, x_end & 0xff);
> +	if (ret)
> +		goto done;
> +	ret = ov9740_reg_write(client, OV9740_Y_ADDR_END_HI, y_end >> 8);
> +	if (ret)
> +		goto done;
> +	ret = ov9740_reg_write(client, OV9740_Y_ADDR_END_LO, y_end & 0xff);
> +	if (ret)
> +		goto done;
> +
> +	ret = ov9740_reg_write(client, OV9740_X_OUTPUT_SIZE_HI, width >> 8);
> +	if (ret)
> +		goto done;
> +	ret = ov9740_reg_write(client, OV9740_X_OUTPUT_SIZE_LO, width & 0xff);
> +	if (ret)
> +		goto done;
> +	ret = ov9740_reg_write(client, OV9740_Y_OUTPUT_SIZE_HI, height >> 8);
> +	if (ret)
> +		goto done;
> +	ret = ov9740_reg_write(client, OV9740_Y_OUTPUT_SIZE_LO, height & 0xff);
> +	if (ret)
> +		goto done;
> +
> +	ret = ov9740_reg_write(client, OV9740_ISP_CTRL1E, scale_input_x >> 8);
> +	if (ret)
> +		goto done;
> +	ret = ov9740_reg_write(client, OV9740_ISP_CTRL1F, scale_input_x & 0xff);
> +	if (ret)
> +		goto done;
> +	ret = ov9740_reg_write(client, OV9740_ISP_CTRL20, scale_input_y >> 8);
> +	if (ret)
> +		goto done;
> +	ret = ov9740_reg_write(client, OV9740_ISP_CTRL21, scale_input_y & 0xff);
> +	if (ret)
> +		goto done;

Now that we know what control registers 1e to 21 are for, what about renaming 
them ? Are they called CTRL1E to CTRL21 in the vendor documentation ?

> +
> +	ret = ov9740_reg_write(client, OV9740_VFIFO_READ_START_HI,
> +			       (scale_input_x - width) >> 8);
> +	if (ret)
> +		goto done;
> +	ret = ov9740_reg_write(client, OV9740_VFIFO_READ_START_LO,
> +			       (scale_input_x - width) & 0xff);
> +	if (ret)
> +		goto done;
> +
> +	ret = ov9740_reg_write(client, OV9740_ISP_CTRL00, 0xff);
> +	if (ret)
> +		goto done;
> +	ret = ov9740_reg_write(client, OV9740_ISP_CTRL01, 0xef |
> +							  (scaling << 4));
> +	if (ret)
> +		goto done;
> +	ret = ov9740_reg_write(client, OV9740_ISP_CTRL03, 0xff);
> +
> +done:
>  	return ret;
>  }
> 
> @@ -787,7 +805,7 @@ static int ov9740_s_fmt(struct v4l2_subdev *sd,
>  	if (ret < 0)
>  		return ret;
> 
> -	ret = ov9740_set_res(client, mf->width);
> +	ret = ov9740_set_res(client, mf->width, mf->height);
>  	if (ret < 0)
>  		return ret;
> 
> @@ -824,8 +842,8 @@ static int ov9740_cropcap(struct v4l2_subdev *sd,
> struct v4l2_cropcap *a) {
>  	a->bounds.left		= 0;
>  	a->bounds.top		= 0;
> -	a->bounds.width		= ov9740_resolutions[OV9740_720P].width;
> -	a->bounds.height	= ov9740_resolutions[OV9740_720P].height;
> +	a->bounds.width		= OV9740_MAX_WIDTH;
> +	a->bounds.height	= OV9740_MAX_HEIGHT;
>  	a->defrect		= a->bounds;
>  	a->type			= V4L2_BUF_TYPE_VIDEO_CAPTURE;
>  	a->pixelaspect.numerator	= 1;
> @@ -838,8 +856,8 @@ static int ov9740_g_crop(struct v4l2_subdev *sd, struct
> v4l2_crop *a) {
>  	a->c.left		= 0;
>  	a->c.top		= 0;
> -	a->c.width		= ov9740_resolutions[OV9740_720P].width;
> -	a->c.height		= ov9740_resolutions[OV9740_720P].height;
> +	a->c.width		= OV9740_MAX_WIDTH;
> +	a->c.height		= OV9740_MAX_HEIGHT;
>  	a->type			= V4L2_BUF_TYPE_VIDEO_CAPTURE;
> 
>  	return 0;

-- 
Regards,

Laurent Pinchart
