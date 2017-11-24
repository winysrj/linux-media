Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34058 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750801AbdKXOJT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Nov 2017 09:09:19 -0500
Date: Fri, 24 Nov 2017 16:09:16 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hugues Fruchet <hugues.fruchet@st.com>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: Re: [PATCH v1 4/4] media: ov5640: add support of RGB565 and YUYV
 formats
Message-ID: <20171124140916.kwjfsq5yfzchb2il@valkosipuli.retiisi.org.uk>
References: <1510839702-2454-1-git-send-email-hugues.fruchet@st.com>
 <1510839702-2454-5-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1510839702-2454-5-git-send-email-hugues.fruchet@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hugues,

On Thu, Nov 16, 2017 at 02:41:42PM +0100, Hugues Fruchet wrote:
> Add RGB565 (LE & BE) and YUV422 YUYV format in addition
> to existing YUV422 UYVY format.
> 
> Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
> ---
>  drivers/media/i2c/ov5640.c | 79 +++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 71 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
> index fb519ad..086a451 100644
> --- a/drivers/media/i2c/ov5640.c
> +++ b/drivers/media/i2c/ov5640.c
> @@ -77,8 +77,10 @@
>  #define OV5640_REG_HZ5060_CTRL01	0x3c01
>  #define OV5640_REG_SIGMADELTA_CTRL0C	0x3c0c
>  #define OV5640_REG_FRAME_CTRL01		0x4202
> +#define OV5640_REG_FORMAT_CONTROL00	0x4300
>  #define OV5640_REG_MIPI_CTRL00		0x4800
>  #define OV5640_REG_DEBUG_MODE		0x4814
> +#define OV5640_REG_ISP_FORMAT_MUX_CTRL	0x501f
>  #define OV5640_REG_PRE_ISP_TEST_SET1	0x503d
>  #define OV5640_REG_SDE_CTRL0		0x5580
>  #define OV5640_REG_SDE_CTRL1		0x5581
> @@ -106,6 +108,18 @@ enum ov5640_frame_rate {
>  	OV5640_NUM_FRAMERATES,
>  };
>  
> +struct ov5640_pixfmt {
> +	u32 code;
> +	u32 colorspace;
> +};
> +
> +static const struct ov5640_pixfmt ov5640_formats[] = {
> +	{ MEDIA_BUS_FMT_UYVY8_2X8, V4L2_COLORSPACE_SRGB, },
> +	{ MEDIA_BUS_FMT_YUYV8_2X8, V4L2_COLORSPACE_SRGB, },
> +	{ MEDIA_BUS_FMT_RGB565_2X8_LE, V4L2_COLORSPACE_SRGB, },
> +	{ MEDIA_BUS_FMT_RGB565_2X8_BE, V4L2_COLORSPACE_SRGB, },
> +};
> +
>  /*
>   * FIXME: remove this when a subdev API becomes available
>   * to set the MIPI CSI-2 virtual channel.
> @@ -1798,17 +1812,23 @@ static int ov5640_try_fmt_internal(struct v4l2_subdev *sd,
>  {
>  	struct ov5640_dev *sensor = to_ov5640_dev(sd);
>  	const struct ov5640_mode_info *mode;
> +	int i;
>  
>  	mode = ov5640_find_mode(sensor, fr, fmt->width, fmt->height, true);
>  	if (!mode)
>  		return -EINVAL;
> -
>  	fmt->width = mode->width;
>  	fmt->height = mode->height;
> -	fmt->code = sensor->fmt.code;
>  
>  	if (new_mode)
>  		*new_mode = mode;
> +
> +	for (i = 0; i < ARRAY_SIZE(ov5640_formats); i++)
> +		if (ov5640_formats[i].code == fmt->code)
> +			break;
> +	if (i >= ARRAY_SIZE(ov5640_formats))
> +		fmt->code = ov5640_formats[0].code;
> +
>  	return 0;
>  }
>  
> @@ -1851,6 +1871,49 @@ static int ov5640_set_fmt(struct v4l2_subdev *sd,
>  	return ret;
>  }
>  
> +static int ov5640_set_framefmt(struct ov5640_dev *sensor,
> +			       struct v4l2_mbus_framefmt *format)
> +{
> +	int ret = 0;
> +	bool is_rgb = false;
> +	u8 val;
> +
> +	switch (format->code) {
> +	case MEDIA_BUS_FMT_UYVY8_2X8:
> +		/* YUV422, UYVY */
> +		val = 0x3f;
> +		break;
> +	case MEDIA_BUS_FMT_YUYV8_2X8:
> +		/* YUV422, YUYV */
> +		val = 0x30;
> +		break;
> +	case MEDIA_BUS_FMT_RGB565_2X8_LE:
> +		/* RGB565 {g[2:0],b[4:0]},{r[4:0],g[5:3]} */
> +		val = 0x6F;
> +		is_rgb = true;
> +		break;
> +	case MEDIA_BUS_FMT_RGB565_2X8_BE:
> +		/* RGB565 {r[4:0],g[5:3]},{g[2:0],b[4:0]} */
> +		val = 0x61;
> +		is_rgb = true;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	/* FORMAT CONTROL00: YUV and RGB formatting */
> +	ret = ov5640_write_reg(sensor, OV5640_REG_FORMAT_CONTROL00, val);
> +	if (ret)
> +		return ret;
> +
> +	/* FORMAT MUX CONTROL: ISP YUV or RGB */
> +	ret = ov5640_write_reg(sensor, OV5640_REG_ISP_FORMAT_MUX_CTRL,
> +			       is_rgb ? 0x01 : 0x00);

return ov5640...;

> +	if (ret)
> +		return ret;
> +
> +	return ret;
> +}
>  
>  /*
>   * Sensor Controls.
> @@ -2236,15 +2299,12 @@ static int ov5640_enum_mbus_code(struct v4l2_subdev *sd,
>  				  struct v4l2_subdev_pad_config *cfg,
>  				  struct v4l2_subdev_mbus_code_enum *code)
>  {
> -	struct ov5640_dev *sensor = to_ov5640_dev(sd);
> -
>  	if (code->pad != 0)
>  		return -EINVAL;
> -	if (code->index != 0)
> +	if (code->index >= ARRAY_SIZE(ov5640_formats))
>  		return -EINVAL;
>  
> -	code->code = sensor->fmt.code;
> -
> +	code->code = ov5640_formats[code->index].code;
>  	return 0;
>  }
>  
> @@ -2254,12 +2314,15 @@ static int ov5640_s_stream(struct v4l2_subdev *sd, int enable)
>  	int ret = 0;
>  
>  	mutex_lock(&sensor->lock);
> -

I rather liked this newline!

>  	if (sensor->streaming == !enable) {
>  		if (enable && sensor->pending_mode_change) {
>  			ret = ov5640_set_mode(sensor, sensor->current_mode);
>  			if (ret)
>  				goto out;
> +
> +			ret = ov5640_set_framefmt(sensor, &sensor->fmt);
> +			if (ret)
> +				goto out;
>  		}
>  
>  		if (sensor->ep.bus_type == V4L2_MBUS_CSI2)

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
