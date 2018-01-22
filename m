Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47900 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751108AbeAVMwx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Jan 2018 07:52:53 -0500
Date: Mon, 22 Jan 2018 14:52:51 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hugues Fruchet <hugues.fruchet@st.com>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: Re: [PATCH] media: ov5640: add JPEG support
Message-ID: <20180122125250.znhs334o2irkey2h@valkosipuli.retiisi.org.uk>
References: <1516617996-29499-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1516617996-29499-1-git-send-email-hugues.fruchet@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hugues,

On Mon, Jan 22, 2018 at 11:46:36AM +0100, Hugues Fruchet wrote:
> Add YUV422 encoded JPEG support.
> 
> Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
> ---
>  drivers/media/i2c/ov5640.c | 82 ++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 80 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
> index e2dd352..db9aeeb 100644
> --- a/drivers/media/i2c/ov5640.c
> +++ b/drivers/media/i2c/ov5640.c
> @@ -18,6 +18,7 @@
>  #include <linux/init.h>
>  #include <linux/module.h>
>  #include <linux/of_device.h>
> +#include <linux/sizes.h>
>  #include <linux/slab.h>
>  #include <linux/types.h>
>  #include <linux/gpio/consumer.h>
> @@ -34,6 +35,10 @@
>  
>  #define OV5640_DEFAULT_SLAVE_ID 0x3c
>  
> +#define OV5640_JPEG_SIZE_MAX (5 * SZ_1M)
> +
> +#define OV5640_REG_SYS_RESET02		0x3002
> +#define OV5640_REG_SYS_CLOCK_ENABLE02	0x3006
>  #define OV5640_REG_SYS_CTRL0		0x3008
>  #define OV5640_REG_CHIP_ID		0x300a
>  #define OV5640_REG_IO_MIPI_CTRL00	0x300e
> @@ -114,6 +119,7 @@ struct ov5640_pixfmt {
>  };
>  
>  static const struct ov5640_pixfmt ov5640_formats[] = {
> +	{ MEDIA_BUS_FMT_JPEG_1X8, V4L2_COLORSPACE_JPEG, },
>  	{ MEDIA_BUS_FMT_UYVY8_2X8, V4L2_COLORSPACE_SRGB, },
>  	{ MEDIA_BUS_FMT_YUYV8_2X8, V4L2_COLORSPACE_SRGB, },
>  	{ MEDIA_BUS_FMT_RGB565_2X8_LE, V4L2_COLORSPACE_SRGB, },
> @@ -220,6 +226,8 @@ struct ov5640_dev {
>  
>  	bool pending_mode_change;
>  	bool streaming;
> +
> +	unsigned int jpeg_size;
>  };
>  
>  static inline struct ov5640_dev *to_ov5640_dev(struct v4l2_subdev *sd)
> @@ -1910,11 +1918,51 @@ static int ov5640_set_fmt(struct v4l2_subdev *sd,
>  	return ret;
>  }
>  
> +static int ov5640_get_frame_desc(struct v4l2_subdev *sd, unsigned int pad,
> +				 struct v4l2_mbus_frame_desc *fd)
> +{
> +	struct ov5640_dev *sensor = to_ov5640_dev(sd);
> +
> +	if (pad != 0 || !fd)
> +		return -EINVAL;
> +
> +	mutex_lock(&sensor->lock);
> +	fd->entry[0].length = sensor->jpeg_size;
> +	fd->entry[0].pixelcode = MEDIA_BUS_FMT_JPEG_1X8;

This doesn't need to be serialised i.e. can be moved below where the flags
are assigned.

> +	mutex_unlock(&sensor->lock);
> +
> +	fd->entry[0].flags = V4L2_MBUS_FRAME_DESC_FL_LEN_MAX;
> +	fd->num_entries = 1;
> +
> +	return 0;
> +}
> +
> +static int ov5640_set_frame_desc(struct v4l2_subdev *sd, unsigned int pad,
> +				 struct v4l2_mbus_frame_desc *fd)
> +{
> +	struct ov5640_dev *sensor = to_ov5640_dev(sd);
> +
> +	if (pad != 0 || !fd)
> +		return -EINVAL;
> +
> +	fd->entry[0].flags = V4L2_MBUS_FRAME_DESC_FL_LEN_MAX;
> +	fd->num_entries = 1;
> +	fd->entry[0].length = clamp_t(u32, fd->entry[0].length,
> +				      sensor->fmt.width * sensor->fmt.height,
> +				      OV5640_JPEG_SIZE_MAX);

Access to sensor->fmt.width and .height needs to be serialised; acquire
mutex first?

> +	mutex_lock(&sensor->lock);
> +	sensor->jpeg_size = fd->entry[0].length;
> +	mutex_unlock(&sensor->lock);
> +
> +	return 0;
> +}
> +
>  static int ov5640_set_framefmt(struct ov5640_dev *sensor,
>  			       struct v4l2_mbus_framefmt *format)
>  {
>  	int ret = 0;
>  	bool is_rgb = false;
> +	bool is_jpeg = false;
>  	u8 val;
>  
>  	switch (format->code) {
> @@ -1936,6 +1984,11 @@ static int ov5640_set_framefmt(struct ov5640_dev *sensor,
>  		val = 0x61;
>  		is_rgb = true;
>  		break;
> +	case MEDIA_BUS_FMT_JPEG_1X8:
> +		/* YUV422, YUYV */
> +		val = 0x30;
> +		is_jpeg = true;
> +		break;
>  	default:
>  		return -EINVAL;
>  	}
> @@ -1946,8 +1999,31 @@ static int ov5640_set_framefmt(struct ov5640_dev *sensor,
>  		return ret;
>  
>  	/* FORMAT MUX CONTROL: ISP YUV or RGB */
> -	return ov5640_write_reg(sensor, OV5640_REG_ISP_FORMAT_MUX_CTRL,
> -				is_rgb ? 0x01 : 0x00);
> +	ret = ov5640_write_reg(sensor, OV5640_REG_ISP_FORMAT_MUX_CTRL,
> +			       is_rgb ? 0x01 : 0x00);
> +	if (ret)
> +		return ret;
> +
> +	if (is_jpeg) {
> +		/* Enable jpeg */
> +		ret = ov5640_mod_reg(sensor, OV5640_REG_TIMING_TC_REG21,
> +				     BIT(5), BIT(5));
> +		if (ret)
> +			return ret;
> +
> +		/* Relax reset of all blocks */
> +		ret = ov5640_write_reg(sensor, OV5640_REG_SYS_RESET02, 0x00);
> +		if (ret)
> +			return ret;
> +
> +		/* Clock all blocks */
> +		ret = ov5640_write_reg(sensor, OV5640_REG_SYS_CLOCK_ENABLE02,
> +				       0xFF);
> +		if (ret)
> +			return ret;

What if you switch back to non-JPEG output while the sensor remains powered
on? Don't you need to revert the settings to what they were previously?

> +	}
> +
> +	return ret;
>  }
>  
>  /*
> @@ -2391,6 +2467,8 @@ static int ov5640_s_stream(struct v4l2_subdev *sd, int enable)
>  	.set_fmt = ov5640_set_fmt,
>  	.enum_frame_size = ov5640_enum_frame_size,
>  	.enum_frame_interval = ov5640_enum_frame_interval,
> +	.get_frame_desc	= ov5640_get_frame_desc,
> +	.set_frame_desc	= ov5640_set_frame_desc,
>  };
>  
>  static const struct v4l2_subdev_ops ov5640_subdev_ops = {

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
