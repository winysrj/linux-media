Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:61828 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754320AbcH3Izn (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Aug 2016 04:55:43 -0400
Date: Tue, 30 Aug 2016 10:55:31 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jiri Kosina <trivial@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v5 01/13] media: mt9m111: make a standalone v4l2 subdevice
In-Reply-To: <1472493358-24618-2-git-send-email-robert.jarzmik@free.fr>
Message-ID: <Pine.LNX.4.64.1608301048460.10858@axis700.grange>
References: <1472493358-24618-1-git-send-email-robert.jarzmik@free.fr>
 <1472493358-24618-2-git-send-email-robert.jarzmik@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Robert,

On Mon, 29 Aug 2016, Robert Jarzmik wrote:

> Remove the soc_camera adherence. Mostly the change removes the power
> manipulation provided by soc_camera, and instead :
>  - powers on the sensor when the s_power control is activated
>  - powers on the sensor in initial probe
>  - enables and disables the MCLK provided to it in power on/off

Your patch also drops support for inverters on synchronisation and clock 
lines, I guess, your board doesn't use any. I assume, if any board ever 
needs such inverters, support for them can be added in the future. Also, 
as I mentioned in my reply to your other patch, maybe good to join this 
with #3. Otherwise and with that in mind

> Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>

Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Thanks
Guennadi

> ---
>  drivers/media/i2c/soc_camera/mt9m111.c | 51 ++++++++++------------------------
>  1 file changed, 15 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/media/i2c/soc_camera/mt9m111.c b/drivers/media/i2c/soc_camera/mt9m111.c
> index 6dfaead6aaa8..a7efaa5964d1 100644
> --- a/drivers/media/i2c/soc_camera/mt9m111.c
> +++ b/drivers/media/i2c/soc_camera/mt9m111.c
> @@ -16,10 +16,11 @@
>  #include <linux/v4l2-mediabus.h>
>  #include <linux/module.h>
>  
> -#include <media/soc_camera.h>
> +#include <media/v4l2-async.h>
>  #include <media/v4l2-clk.h>
>  #include <media/v4l2-common.h>
>  #include <media/v4l2-ctrls.h>
> +#include <media/v4l2-device.h>
>  
>  /*
>   * MT9M111, MT9M112 and MT9M131:
> @@ -388,7 +389,7 @@ static int mt9m111_s_crop(struct v4l2_subdev *sd, const struct v4l2_crop *a)
>  	struct v4l2_rect rect = a->c;
>  	struct mt9m111 *mt9m111 = container_of(sd, struct mt9m111, subdev);
>  	int width, height;
> -	int ret;
> +	int ret, align = 0;
>  
>  	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
>  		return -EINVAL;
> @@ -396,17 +397,19 @@ static int mt9m111_s_crop(struct v4l2_subdev *sd, const struct v4l2_crop *a)
>  	if (mt9m111->fmt->code == MEDIA_BUS_FMT_SBGGR8_1X8 ||
>  	    mt9m111->fmt->code == MEDIA_BUS_FMT_SBGGR10_2X8_PADHI_LE) {
>  		/* Bayer format - even size lengths */
> -		rect.width	= ALIGN(rect.width, 2);
> -		rect.height	= ALIGN(rect.height, 2);
> +		align = 1;
>  		/* Let the user play with the starting pixel */
>  	}
>  
>  	/* FIXME: the datasheet doesn't specify minimum sizes */
> -	soc_camera_limit_side(&rect.left, &rect.width,
> -		     MT9M111_MIN_DARK_COLS, 2, MT9M111_MAX_WIDTH);
> -
> -	soc_camera_limit_side(&rect.top, &rect.height,
> -		     MT9M111_MIN_DARK_ROWS, 2, MT9M111_MAX_HEIGHT);
> +	v4l_bound_align_image(&rect.width, 2, MT9M111_MAX_WIDTH, align,
> +			      &rect.height, 2, MT9M111_MAX_HEIGHT, align, 0);
> +	rect.left = clamp(rect.left, MT9M111_MIN_DARK_COLS,
> +			  MT9M111_MIN_DARK_COLS + MT9M111_MAX_WIDTH -
> +			  (__s32)rect.width);
> +	rect.top = clamp(rect.top, MT9M111_MIN_DARK_ROWS,
> +			 MT9M111_MIN_DARK_ROWS + MT9M111_MAX_HEIGHT -
> +			 (__s32)rect.height);
>  
>  	width = min(mt9m111->width, rect.width);
>  	height = min(mt9m111->height, rect.height);
> @@ -775,17 +778,16 @@ static int mt9m111_init(struct mt9m111 *mt9m111)
>  static int mt9m111_power_on(struct mt9m111 *mt9m111)
>  {
>  	struct i2c_client *client = v4l2_get_subdevdata(&mt9m111->subdev);
> -	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
>  	int ret;
>  
> -	ret = soc_camera_power_on(&client->dev, ssdd, mt9m111->clk);
> +	ret = v4l2_clk_enable(mt9m111->clk);
>  	if (ret < 0)
>  		return ret;
>  
>  	ret = mt9m111_resume(mt9m111);
>  	if (ret < 0) {
>  		dev_err(&client->dev, "Failed to resume the sensor: %d\n", ret);
> -		soc_camera_power_off(&client->dev, ssdd, mt9m111->clk);
> +		v4l2_clk_disable(mt9m111->clk);
>  	}
>  
>  	return ret;
> @@ -793,11 +795,8 @@ static int mt9m111_power_on(struct mt9m111 *mt9m111)
>  
>  static void mt9m111_power_off(struct mt9m111 *mt9m111)
>  {
> -	struct i2c_client *client = v4l2_get_subdevdata(&mt9m111->subdev);
> -	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
> -
>  	mt9m111_suspend(mt9m111);
> -	soc_camera_power_off(&client->dev, ssdd, mt9m111->clk);
> +	v4l2_clk_disable(mt9m111->clk);
>  }
>  
>  static int mt9m111_s_power(struct v4l2_subdev *sd, int on)
> @@ -854,14 +853,10 @@ static int mt9m111_enum_mbus_code(struct v4l2_subdev *sd,
>  static int mt9m111_g_mbus_config(struct v4l2_subdev *sd,
>  				struct v4l2_mbus_config *cfg)
>  {
> -	struct i2c_client *client = v4l2_get_subdevdata(sd);
> -	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
> -
>  	cfg->flags = V4L2_MBUS_MASTER | V4L2_MBUS_PCLK_SAMPLE_RISING |
>  		V4L2_MBUS_HSYNC_ACTIVE_HIGH | V4L2_MBUS_VSYNC_ACTIVE_HIGH |
>  		V4L2_MBUS_DATA_ACTIVE_HIGH;
>  	cfg->type = V4L2_MBUS_PARALLEL;
> -	cfg->flags = soc_camera_apply_board_flags(ssdd, cfg);
>  
>  	return 0;
>  }
> @@ -933,20 +928,8 @@ static int mt9m111_probe(struct i2c_client *client,
>  {
>  	struct mt9m111 *mt9m111;
>  	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
> -	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
>  	int ret;
>  
> -	if (client->dev.of_node) {
> -		ssdd = devm_kzalloc(&client->dev, sizeof(*ssdd), GFP_KERNEL);
> -		if (!ssdd)
> -			return -ENOMEM;
> -		client->dev.platform_data = ssdd;
> -	}
> -	if (!ssdd) {
> -		dev_err(&client->dev, "mt9m111: driver needs platform data\n");
> -		return -EINVAL;
> -	}
> -
>  	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_WORD_DATA)) {
>  		dev_warn(&adapter->dev,
>  			 "I2C-Adapter doesn't support I2C_FUNC_SMBUS_WORD\n");
> @@ -992,10 +975,6 @@ static int mt9m111_probe(struct i2c_client *client,
>  	mt9m111->lastpage	= -1;
>  	mutex_init(&mt9m111->power_lock);
>  
> -	ret = soc_camera_power_init(&client->dev, ssdd);
> -	if (ret < 0)
> -		goto out_hdlfree;
> -
>  	ret = mt9m111_video_probe(client);
>  	if (ret < 0)
>  		goto out_hdlfree;
> -- 
> 2.1.4
> 
