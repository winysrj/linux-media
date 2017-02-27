Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:34307 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751649AbdB0J6u (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Feb 2017 04:58:50 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Koji Matsuoka <koji.matsuoka.xm@renesas.com>,
        Yoshihiro Kaneko <ykaneko0929@gmail.com>,
        Simon Horman <horms+renesas@verge.net.au>
Subject: Re: [PATCH] soc-camera: fix rectangle adjustment in cropping
Date: Mon, 27 Feb 2017 10:42:31 +0200
Message-ID: <1908551.GjAGnFoZ8e@avalon>
In-Reply-To: <Pine.LNX.4.64.1702262150090.17018@axis700.grange>
References: <Pine.LNX.4.64.1702262150090.17018@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Thank you for the patch.

On Sunday 26 Feb 2017 21:58:16 Guennadi Liakhovetski wrote:
> From: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
> 
> update_subrect() adjusts the sub-rectangle to be inside a base area.
> It checks width and height to not exceed those of the area, then it
> checks the low border (left or top) to lie within the area, then the
> high border (right or bottom) to lie there too. This latter check has
> a bug, which is fixed by this patch.
> 
> Signed-off-by: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
> Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>
> [g.liakhovetski@gmx.de: dropped supposedly wrong hunks]
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
> 
> This is a part of the https://patchwork.linuxtv.org/patch/26441/ submitted
> almost 2.5 years ago. Back then I commented to the patch but never got a
> reply or an update. I preserved original authorship and Sob tags, although
> this version only uses a small portion of the original patch. This version
> is of course completely untested, any testing (at least regression) would
> be highly appreciated! This code is only used by the SH CEU driver and
> only in cropping / zooming scenarios.
> 
>  drivers/media/platform/soc_camera/soc_scale_crop.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/soc_camera/soc_scale_crop.c
> b/drivers/media/platform/soc_camera/soc_scale_crop.c index f77252d..4bfc1bf
> 100644
> --- a/drivers/media/platform/soc_camera/soc_scale_crop.c
> +++ b/drivers/media/platform/soc_camera/soc_scale_crop.c
> @@ -70,14 +70,14 @@ static void update_subrect(struct v4l2_rect *rect,
> struct v4l2_rect *subrect) if (rect->height < subrect->height)
>  		subrect->height = rect->height;
> 
> -	if (rect->left > subrect->left)
> +	if (rect->left < subrect->left)

This looks wrong to me. If the purpose of the function is indeed to adjust 
subrect to stay within rect, the condition doesn't need to be changed.

>  		subrect->left = rect->left;
>  	else if (rect->left + rect->width >
>  		 subrect->left + subrect->width)

This condition, however, is wrong.

>  		subrect->left = rect->left + rect->width -
>  			subrect->width;

More than that, adjusting the width first and then the left coordinate can 
result in an incorrect width. It looks to me like you should drop the width 
check at the beginning of this function, and turn the "else if" here into an 
"if" with the right condition. Or, even better in my opinion, use the 
min/max/clamp macros.

Same comments for the vertical checks.

> -	if (rect->top > subrect->top)
> +	if (rect->top < subrect->top)
>  		subrect->top = rect->top;
>  	else if (rect->top + rect->height >
>  		 subrect->top + subrect->height)

-- 
Regards,

Laurent Pinchart
