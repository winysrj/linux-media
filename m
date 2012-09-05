Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:52061 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab2IEMCT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Sep 2012 08:02:19 -0400
Date: Wed, 5 Sep 2012 14:02:16 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] soc-camera: Use new selection target definitions
In-Reply-To: <1345669410-31836-1-git-send-email-sylvester.nawrocki@gmail.com>
Message-ID: <Pine.LNX.4.64.1209051401580.16676@axis700.grange>
References: <1345669410-31836-1-git-send-email-sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 22 Aug 2012, Sylwester Nawrocki wrote:

> Replace the deprecated V4L2_SEL_TGT_*_ACTIVE selection target
> names with their new unified counterparts.
> Compatibility definitions are already in linux/v4l2-common.h.
> 
> Signed-off-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>

Thanks, queued.

Guennadi

> ---
>  drivers/media/platform/soc_camera/soc_camera.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
> index 10b57f8..ba62960 100644
> --- a/drivers/media/platform/soc_camera/soc_camera.c
> +++ b/drivers/media/platform/soc_camera/soc_camera.c
> @@ -950,11 +950,11 @@ static int soc_camera_s_selection(struct file *file, void *fh,
>  
>  	/* In all these cases cropping emulation will not help */
>  	if (s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE ||
> -	    (s->target != V4L2_SEL_TGT_COMPOSE_ACTIVE &&
> -	     s->target != V4L2_SEL_TGT_CROP_ACTIVE))
> +	    (s->target != V4L2_SEL_TGT_COMPOSE &&
> +	     s->target != V4L2_SEL_TGT_CROP))
>  		return -EINVAL;
>  
> -	if (s->target == V4L2_SEL_TGT_COMPOSE_ACTIVE) {
> +	if (s->target == V4L2_SEL_TGT_COMPOSE) {
>  		/* No output size change during a running capture! */
>  		if (is_streaming(ici, icd) &&
>  		    (icd->user_width != s->r.width ||
> @@ -974,7 +974,7 @@ static int soc_camera_s_selection(struct file *file, void *fh,
>  
>  	ret = ici->ops->set_selection(icd, s);
>  	if (!ret &&
> -	    s->target == V4L2_SEL_TGT_COMPOSE_ACTIVE) {
> +	    s->target == V4L2_SEL_TGT_COMPOSE) {
>  		icd->user_width = s->r.width;
>  		icd->user_height = s->r.height;
>  		if (!icd->streamer)
> -- 
> 1.7.4.1
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
