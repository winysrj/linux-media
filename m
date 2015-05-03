Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:49893 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308AbbECUrJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 3 May 2015 16:47:09 -0400
Date: Sun, 3 May 2015 22:47:03 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 8/9] ov9740: avoid calling ov9740_res_roundup() twice
In-Reply-To: <1430646876-19594-9-git-send-email-hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.1505032244370.6055@axis700.grange>
References: <1430646876-19594-1-git-send-email-hverkuil@xs4all.nl>
 <1430646876-19594-9-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Sun, 3 May 2015, Hans Verkuil wrote:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Simplify ov9740_s_fmt.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Reported-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
>  drivers/media/i2c/soc_camera/ov9740.c | 18 +-----------------
>  1 file changed, 1 insertion(+), 17 deletions(-)
> 
> diff --git a/drivers/media/i2c/soc_camera/ov9740.c b/drivers/media/i2c/soc_camera/ov9740.c
> index 03a7fc7..61a8e18 100644
> --- a/drivers/media/i2c/soc_camera/ov9740.c
> +++ b/drivers/media/i2c/soc_camera/ov9740.c
> @@ -673,20 +673,8 @@ static int ov9740_s_fmt(struct v4l2_subdev *sd,
>  {
>  	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct ov9740_priv *priv = to_ov9740(sd);
> -	enum v4l2_colorspace cspace;
> -	u32 code = mf->code;
>  	int ret;
>  
> -	ov9740_res_roundup(&mf->width, &mf->height);
> -
> -	switch (code) {
> -	case MEDIA_BUS_FMT_YUYV8_2X8:
> -		cspace = V4L2_COLORSPACE_SRGB;
> -		break;
> -	default:
> -		return -EINVAL;
> -	}
> -

ov9740_s_fmt() is also called from ov9740_s_power(), so, don't we have to 
do this simplification the other way round - remove redundant code from 
ov9740_set_fmt() instead?

Thanks
Guennadi

>  	ret = ov9740_reg_write_array(client, ov9740_defaults,
>  				     ARRAY_SIZE(ov9740_defaults));
>  	if (ret < 0)
> @@ -696,11 +684,7 @@ static int ov9740_s_fmt(struct v4l2_subdev *sd,
>  	if (ret < 0)
>  		return ret;
>  
> -	mf->code	= code;
> -	mf->colorspace	= cspace;
> -
> -	memcpy(&priv->current_mf, mf, sizeof(struct v4l2_mbus_framefmt));
> -
> +	priv->current_mf = *mf;
>  	return ret;
>  }
>  
> -- 
> 2.1.4
> 
