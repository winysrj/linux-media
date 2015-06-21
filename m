Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:53270 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365AbbFUQeo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Jun 2015 12:34:44 -0400
Date: Sun, 21 Jun 2015 18:34:39 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: linux-media@vger.kernel.org, william.towle@codethink.co.uk,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 02/14] sh-veu: don't use COLORSPACE_JPEG.
In-Reply-To: <1434368021-7467-3-git-send-email-hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.1506211833520.7745@axis700.grange>
References: <1434368021-7467-1-git-send-email-hverkuil@xs4all.nl>
 <1434368021-7467-3-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

I'm not maintaining this driver, so, just

On Mon, 15 Jun 2015, Hans Verkuil wrote:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> COLORSPACE_JPEG should only be used for JPEGs. Use SMPTE170M instead,
> which is how YCbCr images are usually encoded.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Thanks
Guennadi

> ---
>  drivers/media/platform/sh_veu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/sh_veu.c b/drivers/media/platform/sh_veu.c
> index 77a74d3..f5e3eb3a 100644
> --- a/drivers/media/platform/sh_veu.c
> +++ b/drivers/media/platform/sh_veu.c
> @@ -211,7 +211,7 @@ static enum v4l2_colorspace sh_veu_4cc2cspace(u32 fourcc)
>  	case V4L2_PIX_FMT_NV12:
>  	case V4L2_PIX_FMT_NV16:
>  	case V4L2_PIX_FMT_NV24:
> -		return V4L2_COLORSPACE_JPEG;
> +		return V4L2_COLORSPACE_SMPTE170M;
>  	case V4L2_PIX_FMT_RGB332:
>  	case V4L2_PIX_FMT_RGB444:
>  	case V4L2_PIX_FMT_RGB565:
> -- 
> 2.1.4
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
