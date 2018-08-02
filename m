Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga17.intel.com ([192.55.52.151]:35904 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387418AbeHBOav (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 2 Aug 2018 10:30:51 -0400
Date: Thu, 2 Aug 2018 15:39:48 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: jasonx.z.chen@intel.com
Cc: linux-media@vger.kernel.org, andy.yeh@intel.com, tfiga@chromium.org
Subject: Re: [PATCH] media: imx258: remove test pattern map from driver
Message-ID: <20180802123948.uvcgwaxsfxwbovzn@paasikivi.fi.intel.com>
References: <1533197820-19176-1-git-send-email-jasonx.z.chen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1533197820-19176-1-git-send-email-jasonx.z.chen@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jason,

On Thu, Aug 02, 2018 at 04:17:00PM +0800, jasonx.z.chen@intel.com wrote:
> From: "Chen, JasonX Z" <jasonx.z.chen@intel.com>
> 
> Test Pattern mode be picked at HAL instead of driver.
> do a FLIP when userspace use test pattern mode.
> add entity_ops for validating imx258 link.

Hmm. I think this would be changed based on my comments anyway, but please
explain what you're doing and *why*. HAL is not relevant in this context
I'd say.

> 
> Signed-off-by: Chen, JasonX Z <jasonx.z.chen@intel.com>
> ---
>  drivers/media/i2c/imx258.c | 28 ++++++++--------------------
>  1 file changed, 8 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/media/i2c/imx258.c b/drivers/media/i2c/imx258.c
> index 31a1e22..71f9875 100644
> --- a/drivers/media/i2c/imx258.c
> +++ b/drivers/media/i2c/imx258.c
> @@ -62,11 +62,6 @@
>  
>  /* Test Pattern Control */
>  #define IMX258_REG_TEST_PATTERN		0x0600
> -#define IMX258_TEST_PATTERN_DISABLE	0
> -#define IMX258_TEST_PATTERN_SOLID_COLOR	1
> -#define IMX258_TEST_PATTERN_COLOR_BARS	2
> -#define IMX258_TEST_PATTERN_GREY_COLOR	3
> -#define IMX258_TEST_PATTERN_PN9		4
>  
>  /* Orientation */
>  #define REG_MIRROR_FLIP_CONTROL		0x0101
> @@ -504,20 +499,12 @@ struct imx258_mode {
>  
>  static const char * const imx258_test_pattern_menu[] = {
>  	"Disabled",
> -	"Color Bars",
>  	"Solid Color",
> +	"Color Bars",
>  	"Grey Color Bars",
>  	"PN9"
>  };
>  
> -static const int imx258_test_pattern_val[] = {
> -	IMX258_TEST_PATTERN_DISABLE,
> -	IMX258_TEST_PATTERN_COLOR_BARS,
> -	IMX258_TEST_PATTERN_SOLID_COLOR,
> -	IMX258_TEST_PATTERN_GREY_COLOR,
> -	IMX258_TEST_PATTERN_PN9,
> -};
> -
>  /* Configurations for supported link frequencies */
>  #define IMX258_LINK_FREQ_634MHZ	633600000ULL
>  #define IMX258_LINK_FREQ_320MHZ	320000000ULL
> @@ -752,7 +739,6 @@ static int imx258_set_ctrl(struct v4l2_ctrl *ctrl)
>  		container_of(ctrl->handler, struct imx258, ctrl_handler);
>  	struct i2c_client *client = v4l2_get_subdevdata(&imx258->sd);
>  	int ret = 0;
> -

I think this newline is where it should be.

>  	/*
>  	 * Applying V4L2 control value only happens
>  	 * when power is up for streaming
> @@ -778,13 +764,10 @@ static int imx258_set_ctrl(struct v4l2_ctrl *ctrl)
>  	case V4L2_CID_TEST_PATTERN:
>  		ret = imx258_write_reg(imx258, IMX258_REG_TEST_PATTERN,
>  				IMX258_REG_VALUE_16BIT,
> -				imx258_test_pattern_val[ctrl->val]);
> -
> +				ctrl->val);
>  		ret = imx258_write_reg(imx258, REG_MIRROR_FLIP_CONTROL,
>  				IMX258_REG_VALUE_08BIT,
> -				ctrl->val == imx258_test_pattern_val
> -				[IMX258_TEST_PATTERN_DISABLE] ?
> -				REG_CONFIG_MIRROR_FLIP :
> +				!ctrl->val?REG_CONFIG_MIRROR_FLIP :

Spaces around "?".

>  				REG_CONFIG_FLIP_TEST_PATTERN);
>  		break;
>  	default:
> @@ -1105,6 +1088,10 @@ static int imx258_identify_module(struct imx258 *imx258)
>  	.pad = &imx258_pad_ops,
>  };
>  
> +static const struct media_entity_operations imx258_subdev_entity_ops = {
> +	.link_validate = v4l2_subdev_link_validate,

The sensor only has a source pad while the link validate is only needed for
sink pads.

> +};
> +
>  static const struct v4l2_subdev_internal_ops imx258_internal_ops = {
>  	.open = imx258_open,
>  };
> @@ -1250,6 +1237,7 @@ static int imx258_probe(struct i2c_client *client)
>  
>  	/* Initialize subdev */
>  	imx258->sd.internal_ops = &imx258_internal_ops;
> +	imx258->sd.entity.ops  = &imx258_subdev_entity_ops;
>  	imx258->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
>  	imx258->sd.entity.function = MEDIA_ENT_F_CAM_SENSOR;
>  

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
