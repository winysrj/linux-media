Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:61846 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283AbbECR4e (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 3 May 2015 13:56:34 -0400
Date: Sun, 3 May 2015 19:56:29 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 2/9] mt9m001: avoid calling mt9m001_find_datafmt() twice
In-Reply-To: <1430646876-19594-3-git-send-email-hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.1505031956170.4237@axis700.grange>
References: <1430646876-19594-1-git-send-email-hverkuil@xs4all.nl>
 <1430646876-19594-3-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 3 May 2015, Hans Verkuil wrote:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Simplify mt9m001_s_fmt and mt9m001_set_fmt.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Reported-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Thanks
Guennadi

> ---
>  drivers/media/i2c/soc_camera/mt9m001.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/i2c/soc_camera/mt9m001.c b/drivers/media/i2c/soc_camera/mt9m001.c
> index 4fbdd1e..1f49140 100644
> --- a/drivers/media/i2c/soc_camera/mt9m001.c
> +++ b/drivers/media/i2c/soc_camera/mt9m001.c
> @@ -271,6 +271,7 @@ static int mt9m001_get_fmt(struct v4l2_subdev *sd,
>  }
>  
>  static int mt9m001_s_fmt(struct v4l2_subdev *sd,
> +			 const struct mt9m001_datafmt *fmt,
>  			 struct v4l2_mbus_framefmt *mf)
>  {
>  	struct i2c_client *client = v4l2_get_subdevdata(sd);
> @@ -290,9 +291,8 @@ static int mt9m001_s_fmt(struct v4l2_subdev *sd,
>  	if (!ret) {
>  		mf->width	= mt9m001->rect.width;
>  		mf->height	= mt9m001->rect.height;
> -		mt9m001->fmt	= mt9m001_find_datafmt(mf->code,
> -					mt9m001->fmts, mt9m001->num_fmts);
> -		mf->colorspace	= mt9m001->fmt->colorspace;
> +		mt9m001->fmt	= fmt;
> +		mf->colorspace	= fmt->colorspace;
>  	}
>  
>  	return ret;
> @@ -328,7 +328,7 @@ static int mt9m001_set_fmt(struct v4l2_subdev *sd,
>  	mf->colorspace	= fmt->colorspace;
>  
>  	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
> -		return mt9m001_s_fmt(sd, mf);
> +		return mt9m001_s_fmt(sd, fmt, mf);
>  	cfg->try_fmt = *mf;
>  	return 0;
>  }
> -- 
> 2.1.4
> 
