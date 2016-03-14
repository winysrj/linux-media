Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:33506 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbcCNMmr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Mar 2016 08:42:47 -0400
Received: by mail-lb0-f178.google.com with SMTP id oe12so15009lbc.0
        for <linux-media@vger.kernel.org>; Mon, 14 Mar 2016 05:42:46 -0700 (PDT)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Mon, 14 Mar 2016 13:42:43 +0100
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 1/2] v4l2-ioctl: simplify code
Message-ID: <20160314124243.GA24409@bigcity.dyn.berto.se>
References: <1456741000-39069-1-git-send-email-hverkuil@xs4all.nl>
 <1456741000-39069-2-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1456741000-39069-2-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 2016-02-29 11:16:39 +0100, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Instead of a big if at the beginning, just check if g_selection == NULL
> and call the cropcap op immediately and return the result.
> 
> No functional changes in this patch.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/v4l2-core/v4l2-ioctl.c | 44 ++++++++++++++++++------------------
>  1 file changed, 22 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> index 86c4c19..67dbb03 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -2157,33 +2157,33 @@ static int v4l_cropcap(const struct v4l2_ioctl_ops *ops,
>  				struct file *file, void *fh, void *arg)
>  {
>  	struct v4l2_cropcap *p = arg;
> +	struct v4l2_selection s = { .type = p->type };
> +	int ret;
>  
> -	if (ops->vidioc_g_selection) {
> -		struct v4l2_selection s = { .type = p->type };
> -		int ret;
> +	if (ops->vidioc_g_selection == NULL)
> +		return ops->vidioc_cropcap(file, fh, p);

I might be missing something but is there a guarantee 
ops->vidioc_cropcap is not NULL here?

>  
> -		/* obtaining bounds */
> -		if (V4L2_TYPE_IS_OUTPUT(p->type))
> -			s.target = V4L2_SEL_TGT_COMPOSE_BOUNDS;
> -		else
> -			s.target = V4L2_SEL_TGT_CROP_BOUNDS;
> +	/* obtaining bounds */
> +	if (V4L2_TYPE_IS_OUTPUT(p->type))
> +		s.target = V4L2_SEL_TGT_COMPOSE_BOUNDS;
> +	else
> +		s.target = V4L2_SEL_TGT_CROP_BOUNDS;
>  
> -		ret = ops->vidioc_g_selection(file, fh, &s);
> -		if (ret)
> -			return ret;
> -		p->bounds = s.r;
> +	ret = ops->vidioc_g_selection(file, fh, &s);
> +	if (ret)
> +		return ret;
> +	p->bounds = s.r;
>  
> -		/* obtaining defrect */
> -		if (V4L2_TYPE_IS_OUTPUT(p->type))
> -			s.target = V4L2_SEL_TGT_COMPOSE_DEFAULT;
> -		else
> -			s.target = V4L2_SEL_TGT_CROP_DEFAULT;
> +	/* obtaining defrect */
> +	if (V4L2_TYPE_IS_OUTPUT(p->type))
> +		s.target = V4L2_SEL_TGT_COMPOSE_DEFAULT;
> +	else
> +		s.target = V4L2_SEL_TGT_CROP_DEFAULT;
>  
> -		ret = ops->vidioc_g_selection(file, fh, &s);
> -		if (ret)
> -			return ret;
> -		p->defrect = s.r;
> -	}
> +	ret = ops->vidioc_g_selection(file, fh, &s);
> +	if (ret)
> +		return ret;
> +	p->defrect = s.r;
>  
>  	/* setting trivial pixelaspect */
>  	p->pixelaspect.numerator = 1;
> -- 
> 2.7.0
> 

-- 
Regards,
Niklas Söderlund
