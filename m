Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:37228 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731276AbeKMUec (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Nov 2018 15:34:32 -0500
Date: Tue, 13 Nov 2018 12:36:54 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: Re: [PATCH 3/7] media: ov2640: add V4L2_CID_TEST_PATTERN control
Message-ID: <20181113103653.hl7ukiiy4lcphoxj@kekkonen.localdomain>
References: <1542038454-20066-1-git-send-email-akinobu.mita@gmail.com>
 <1542038454-20066-4-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1542038454-20066-4-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 13, 2018 at 01:00:50AM +0900, Akinobu Mita wrote:
> The ov2640 has the test pattern generator features.  This makes use of
> it through V4L2_CID_TEST_PATTERN control.
> 
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> ---
>  drivers/media/i2c/ov2640.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/ov2640.c b/drivers/media/i2c/ov2640.c
> index 20a8853..4992d77 100644
> --- a/drivers/media/i2c/ov2640.c
> +++ b/drivers/media/i2c/ov2640.c
> @@ -705,6 +705,11 @@ static int ov2640_reset(struct i2c_client *client)
>  	return ret;
>  }
>  
> +static const char * const ov2640_test_pattern_menu[] = {
> +	"Disabled",
> +	"Color bar",

s/b/B/

The smiapp driver uses "Eight Vertical Colour Bars", not sure if that'd fit
here or not. FYI.

> +};
> +
>  /*
>   * functions
>   */
> @@ -740,6 +745,9 @@ static int ov2640_s_ctrl(struct v4l2_ctrl *ctrl)
>  	case V4L2_CID_HFLIP:
>  		val = ctrl->val ? REG04_HFLIP_IMG : 0x00;
>  		return ov2640_mask_set(client, REG04, REG04_HFLIP_IMG, val);
> +	case V4L2_CID_TEST_PATTERN:
> +		val = ctrl->val ? COM7_COLOR_BAR_TEST : 0x00;
> +		return ov2640_mask_set(client, COM7, COM7_COLOR_BAR_TEST, val);
>  	}
>  
>  	return -EINVAL;
> @@ -1184,12 +1192,16 @@ static int ov2640_probe(struct i2c_client *client,
>  	v4l2_i2c_subdev_init(&priv->subdev, client, &ov2640_subdev_ops);
>  	priv->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
>  	mutex_init(&priv->lock);
> -	v4l2_ctrl_handler_init(&priv->hdl, 2);
> +	v4l2_ctrl_handler_init(&priv->hdl, 3);
>  	priv->hdl.lock = &priv->lock;
>  	v4l2_ctrl_new_std(&priv->hdl, &ov2640_ctrl_ops,
>  			V4L2_CID_VFLIP, 0, 1, 1, 0);
>  	v4l2_ctrl_new_std(&priv->hdl, &ov2640_ctrl_ops,
>  			V4L2_CID_HFLIP, 0, 1, 1, 0);
> +	v4l2_ctrl_new_std_menu_items(&priv->hdl, &ov2640_ctrl_ops,
> +			V4L2_CID_TEST_PATTERN,
> +			ARRAY_SIZE(ov2640_test_pattern_menu) - 1, 0, 0,
> +			ov2640_test_pattern_menu);
>  	priv->subdev.ctrl_handler = &priv->hdl;
>  	if (priv->hdl.error) {
>  		ret = priv->hdl.error;
> -- 
> 2.7.4
> 

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
