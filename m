Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:55391 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932631AbeBUKOH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Feb 2018 05:14:07 -0500
Message-ID: <1519208044.3405.5.camel@pengutronix.de>
Subject: Re: [PATCH] media: imx: mipi csi-2: Fix set_fmt try
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Date: Wed, 21 Feb 2018 11:14:04 +0100
In-Reply-To: <1518375069-5497-1-git-send-email-steve_longerbeam@mentor.com>
References: <1518375069-5497-1-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2018-02-11 at 10:51 -0800, Steve Longerbeam wrote:
> csi2_set_fmt() was setting the try_fmt only on the first pad, and pad
> index was ignored. Fix by introducing __csi2_get_fmt().
> 
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> ---
>  drivers/staging/media/imx/imx6-mipi-csi2.c | 24 +++++++++++++++---------
>  1 file changed, 15 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/staging/media/imx/imx6-mipi-csi2.c b/drivers/staging/media/imx/imx6-mipi-csi2.c
> index 477d191..4b7135a 100644
> --- a/drivers/staging/media/imx/imx6-mipi-csi2.c
> +++ b/drivers/staging/media/imx/imx6-mipi-csi2.c
> @@ -447,6 +447,16 @@ static int csi2_link_setup(struct media_entity *entity,
>  	return ret;
>  }
>  
> +static struct v4l2_mbus_framefmt *
> +__csi2_get_fmt(struct csi2_dev *csi2, struct v4l2_subdev_pad_config *cfg,
> +	       unsigned int pad, enum v4l2_subdev_format_whence which)
> +{
> +	if (which == V4L2_SUBDEV_FORMAT_TRY)
> +		return v4l2_subdev_get_try_format(&csi2->sd, cfg, pad);
> +	else
> +		return &csi2->format_mbus;
> +}
> +
>  static int csi2_get_fmt(struct v4l2_subdev *sd,
>  			struct v4l2_subdev_pad_config *cfg,
>  			struct v4l2_subdev_format *sdformat)
> @@ -456,11 +466,7 @@ static int csi2_get_fmt(struct v4l2_subdev *sd,
>  
>  	mutex_lock(&csi2->lock);
>  
> -	if (sdformat->which == V4L2_SUBDEV_FORMAT_TRY)
> -		fmt = v4l2_subdev_get_try_format(&csi2->sd, cfg,
> -						 sdformat->pad);
> -	else
> -		fmt = &csi2->format_mbus;
> +	fmt = __csi2_get_fmt(csi2, cfg, sdformat->pad, sdformat->which);
>  
>  	sdformat->format = *fmt;
>  
> @@ -474,6 +480,7 @@ static int csi2_set_fmt(struct v4l2_subdev *sd,
>  			struct v4l2_subdev_format *sdformat)
>  {
>  	struct csi2_dev *csi2 = sd_to_dev(sd);
> +	struct v4l2_mbus_framefmt *fmt;
>  	int ret = 0;
>  
>  	if (sdformat->pad >= CSI2_NUM_PADS)
> @@ -490,10 +497,9 @@ static int csi2_set_fmt(struct v4l2_subdev *sd,
>  	if (sdformat->pad != CSI2_SINK_PAD)
>  		sdformat->format = csi2->format_mbus;
>  
> -	if (sdformat->which == V4L2_SUBDEV_FORMAT_TRY)
> -		cfg->try_fmt = sdformat->format;
> -	else
> -		csi2->format_mbus = sdformat->format;
> +	fmt = __csi2_get_fmt(csi2, cfg, sdformat->pad, sdformat->which);
> +
> +	*fmt = sdformat->format;
>  out:
>  	mutex_unlock(&csi2->lock);
>  	return ret;

Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp
