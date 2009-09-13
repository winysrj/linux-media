Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:58115 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbZIMUif (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Sep 2009 16:38:35 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH 2/8] drivers/media/video/uvc: introduce missing kfree
Date: Sun, 13 Sep 2009 22:39:21 +0200
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
References: <Pine.LNX.4.64.0909111821010.10552@pc-004.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0909111821010.10552@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909132239.21806.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 11 September 2009 18:21:18 Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Error handling code following kmalloc should free the allocated data.
> 
> The semantic match that finds the problem is as follows:
> (http://www.emn.fr/x-info/coccinelle/)
> 
> // <smpl>
> @r exists@
> local idexpression x;
> statement S;
> expression E;
> identifier f,f1,l;
> position p1,p2;
> expression *ptr != NULL;
> @@
> 
> x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...);
> ...
> if (x == NULL) S
> <... when != x
>      when != if (...) { <+...x...+> }
> (
> x->f1 = E
> 
>  (x->f1 == NULL || ...)
> 
>  f(...,x->f1,...)
> )
> ...>
> (
>  return \(0\|<+...x...+>\|ptr\);
> 
>  return@p2 ...;
> )
> 
> @script:python@
> p1 << r.p1;
> p2 << r.p2;
> @@
> 
> print "* file: %s kmalloc %s return %s" %
>  (p1[0].file,p1[0].line,p2[0].line) // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> ---
>  drivers/media/video/uvc/uvc_video.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/video/uvc/uvc_video.c
>  b/drivers/media/video/uvc/uvc_video.c index 5b757f3..ce2c484 100644
> --- a/drivers/media/video/uvc/uvc_video.c
> +++ b/drivers/media/video/uvc/uvc_video.c
> @@ -128,8 +128,11 @@ static int uvc_get_video_ctrl(struct uvc_streaming
>  *stream, if (data == NULL)
>  		return -ENOMEM;
> 
> -	if ((stream->dev->quirks & UVC_QUIRK_PROBE_DEF) && query == UVC_GET_DEF)
> -		return -EIO;
> +	if ((stream->dev->quirks & UVC_QUIRK_PROBE_DEF) &&
> +			query == UVC_GET_DEF) {
> +		ret = -EIO;
> +		goto out;
> +	}

This check can be moved before kmalloc(), removing the need to free memory in 
case of error.

Julia, do you want to submit a modified patch or should I do it myself ?
 
>  	ret = __uvc_query_ctrl(stream->dev, query, 0, stream->intfnum,
>  		probe ? UVC_VS_PROBE_CONTROL : UVC_VS_COMMIT_CONTROL, data,
> 

-- 
Regards,

Laurent Pinchart
