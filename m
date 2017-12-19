Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36178 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932707AbdLSKfT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 05:35:19 -0500
Date: Tue, 19 Dec 2017 12:35:16 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-media@vger.kernel.org,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        hverkuil@xs4all.nl
Subject: Re: [PATCH] media: ov9650: support VIDIOC_DBG_G/S_REGISTER ioctls
Message-ID: <20171219103515.6eetdss4cmlbsxzk@valkosipuli.retiisi.org.uk>
References: <1513180849-7913-1-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1513180849-7913-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Akinobu,

On Thu, Dec 14, 2017 at 01:00:49AM +0900, Akinobu Mita wrote:
> This adds support VIDIOC_DBG_G/S_REGISTER ioctls.
> 
> There are many device control registers contained in the OV9650.  So
> this helps debugging the lower level issues by getting and setting the
> registers.
> 
> Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

Just wondering --- doesn't the I²C user space interface offer essentially
the same functionality?

See: Documentation/i2c/dev-interface

Cc Hans.

> ---
>  drivers/media/i2c/ov9650.c | 36 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 36 insertions(+)
> 
> diff --git a/drivers/media/i2c/ov9650.c b/drivers/media/i2c/ov9650.c
> index 69433e1..c6462cf 100644
> --- a/drivers/media/i2c/ov9650.c
> +++ b/drivers/media/i2c/ov9650.c
> @@ -1374,6 +1374,38 @@ static int ov965x_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_VIDEO_ADV_DEBUG
> +
> +static int ov965x_g_register(struct v4l2_subdev *sd,
> +			     struct v4l2_dbg_register *reg)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	u8 val = 0;
> +	int ret;
> +
> +	if (reg->reg > 0xff)
> +		return -EINVAL;
> +
> +	ret = ov965x_read(client, reg->reg, &val);
> +	reg->val = val;
> +	reg->size = 1;
> +
> +	return ret;
> +}
> +
> +static int ov965x_s_register(struct v4l2_subdev *sd,
> +			     const struct v4l2_dbg_register *reg)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +
> +	if (reg->reg > 0xff || reg->val > 0xff)
> +		return -EINVAL;
> +
> +	return ov965x_write(client, reg->reg, reg->val);
> +}
> +
> +#endif
> +
>  static const struct v4l2_subdev_pad_ops ov965x_pad_ops = {
>  	.enum_mbus_code = ov965x_enum_mbus_code,
>  	.enum_frame_size = ov965x_enum_frame_sizes,
> @@ -1397,6 +1429,10 @@ static const struct v4l2_subdev_core_ops ov965x_core_ops = {
>  	.log_status = v4l2_ctrl_subdev_log_status,
>  	.subscribe_event = v4l2_ctrl_subdev_subscribe_event,
>  	.unsubscribe_event = v4l2_event_subdev_unsubscribe,
> +#ifdef CONFIG_VIDEO_ADV_DEBUG
> +	.g_register = ov965x_g_register,
> +	.s_register = ov965x_s_register,
> +#endif
>  };
>  
>  static const struct v4l2_subdev_ops ov965x_subdev_ops = {
> -- 
> 2.7.4
> 

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
