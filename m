Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:41302 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab1K1QBR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Nov 2011 11:01:17 -0500
Date: Mon, 28 Nov 2011 18:01:12 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] omap3isp: video: Don't WARN() on unknown pixel formats
Message-ID: <20111128160112.GE29805@valkosipuli.localdomain>
References: <1322480254-10461-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322480254-10461-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks for the patch, Laurent!

On Mon, Nov 28, 2011 at 12:37:34PM +0100, Laurent Pinchart wrote:
> When mapping from a V4L2 pixel format to a media bus format in the
> VIDIOC_TRY_FMT and VIDIOC_S_FMT handlers, the requested format may be
> unsupported by the driver. Return a hardcoded format instead of
> WARN()ing in that case.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/video/omap3isp/ispvideo.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/video/omap3isp/ispvideo.c b/drivers/media/video/omap3isp/ispvideo.c
> index d100072..ffe7ce9 100644
> --- a/drivers/media/video/omap3isp/ispvideo.c
> +++ b/drivers/media/video/omap3isp/ispvideo.c
> @@ -210,14 +210,14 @@ static void isp_video_pix_to_mbus(const struct v4l2_pix_format *pix,
>  	mbus->width = pix->width;
>  	mbus->height = pix->height;
>  
> -	for (i = 0; i < ARRAY_SIZE(formats); ++i) {
> +	/* Skip the last format in the loop so that it will be selected if no
> +	 * match is found.
> +	 */
> +	for (i = 0; i < ARRAY_SIZE(formats) - 1; ++i) {
>  		if (formats[i].pixelformat == pix->pixelformat)
>  			break;
>  	}
>  
> -	if (WARN_ON(i == ARRAY_SIZE(formats)))
> -		return;
> -
>  	mbus->code = formats[i].code;
>  	mbus->colorspace = pix->colorspace;
>  	mbus->field = pix->field;

In case of setting or trying an invalid format, instead of selecting a
default format, shouldn't we leave the format unchanced --- the current
setting is valid after all.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
