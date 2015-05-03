Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:59838 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708AbbECUYP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 3 May 2015 16:24:15 -0400
Date: Sun, 3 May 2015 22:24:10 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 5/9] ov5642: avoid calling ov5642_find_datafmt() twice
In-Reply-To: <1430646876-19594-6-git-send-email-hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.1505032223340.6055@axis700.grange>
References: <1430646876-19594-1-git-send-email-hverkuil@xs4all.nl>
 <1430646876-19594-6-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Sun, 3 May 2015, Hans Verkuil wrote:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Simplify ov5642_set_fmt().
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Reported-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
>  drivers/media/i2c/soc_camera/ov5642.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/i2c/soc_camera/ov5642.c b/drivers/media/i2c/soc_camera/ov5642.c
> index bab9ac0..061fca3 100644
> --- a/drivers/media/i2c/soc_camera/ov5642.c
> +++ b/drivers/media/i2c/soc_camera/ov5642.c
> @@ -804,14 +804,15 @@ static int ov5642_set_fmt(struct v4l2_subdev *sd,
>  	if (!fmt) {
>  		if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
>  			return -EINVAL;
> -		mf->code	= ov5642_colour_fmts[0].code;
> -		mf->colorspace	= ov5642_colour_fmts[0].colorspace;
> +		fmt = ov5642_colour_fmts;
> +		mf->code = fmt->code;
> +		mf->colorspace = fmt->colorspace;

Again - I still don't see why this is needed.

Thanks
Guennadi

>  	}
>  
>  	mf->field	= V4L2_FIELD_NONE;
>  
>  	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
> -		priv->fmt = ov5642_find_datafmt(mf->code);
> +		priv->fmt = fmt;
>  	else
>  		cfg->try_fmt = *mf;
>  	return 0;
> -- 
> 2.1.4
> 
