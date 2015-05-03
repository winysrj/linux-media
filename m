Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:55923 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686AbbECUa3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 3 May 2015 16:30:29 -0400
Date: Sun, 3 May 2015 22:30:19 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 6/9] ov772x: avoid calling ov772x_select_params() twice
In-Reply-To: <1430646876-19594-7-git-send-email-hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.1505032229550.6055@axis700.grange>
References: <1430646876-19594-1-git-send-email-hverkuil@xs4all.nl>
 <1430646876-19594-7-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 3 May 2015, Hans Verkuil wrote:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Merge ov772x_s_fmt into ov772x_set_fmt.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Reported-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Thanks
Guennadi

> ---
>  drivers/media/i2c/soc_camera/ov772x.c | 41 +++++++++++------------------------
>  1 file changed, 13 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/media/i2c/soc_camera/ov772x.c b/drivers/media/i2c/soc_camera/ov772x.c
> index f150a8b..aa32bc5 100644
> --- a/drivers/media/i2c/soc_camera/ov772x.c
> +++ b/drivers/media/i2c/soc_camera/ov772x.c
> @@ -895,38 +895,15 @@ static int ov772x_get_fmt(struct v4l2_subdev *sd,
>  	return 0;
>  }
>  
> -static int ov772x_s_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *mf)
> -{
> -	struct ov772x_priv *priv = to_ov772x(sd);
> -	const struct ov772x_color_format *cfmt;
> -	const struct ov772x_win_size *win;
> -	int ret;
> -
> -	ov772x_select_params(mf, &cfmt, &win);
> -
> -	ret = ov772x_set_params(priv, cfmt, win);
> -	if (ret < 0)
> -		return ret;
> -
> -	priv->win = win;
> -	priv->cfmt = cfmt;
> -
> -	mf->code = cfmt->code;
> -	mf->width = win->rect.width;
> -	mf->height = win->rect.height;
> -	mf->field = V4L2_FIELD_NONE;
> -	mf->colorspace = cfmt->colorspace;
> -
> -	return 0;
> -}
> -
>  static int ov772x_set_fmt(struct v4l2_subdev *sd,
>  		struct v4l2_subdev_pad_config *cfg,
>  		struct v4l2_subdev_format *format)
>  {
> +	struct ov772x_priv *priv = to_ov772x(sd);
>  	struct v4l2_mbus_framefmt *mf = &format->format;
>  	const struct ov772x_color_format *cfmt;
>  	const struct ov772x_win_size *win;
> +	int ret;
>  
>  	if (format->pad)
>  		return -EINVAL;
> @@ -939,9 +916,17 @@ static int ov772x_set_fmt(struct v4l2_subdev *sd,
>  	mf->field = V4L2_FIELD_NONE;
>  	mf->colorspace = cfmt->colorspace;
>  
> -	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
> -		return ov772x_s_fmt(sd, mf);
> -	cfg->try_fmt = *mf;
> +	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
> +		cfg->try_fmt = *mf;
> +		return 0;
> +	}
> +
> +	ret = ov772x_set_params(priv, cfmt, win);
> +	if (ret < 0)
> +		return ret;
> +
> +	priv->win = win;
> +	priv->cfmt = cfmt;
>  	return 0;
>  }
>  
> -- 
> 2.1.4
> 
