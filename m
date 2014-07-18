Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48565 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933281AbaGRKBh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Jul 2014 06:01:37 -0400
Message-ID: <53C8F07E.9080805@redhat.com>
Date: Fri, 18 Jul 2014 12:01:34 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] libv4lconvert: add support for new pixelformats
References: <53C84DDE.4000701@xs4all.nl>
In-Reply-To: <53C84DDE.4000701@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 07/18/2014 12:27 AM, Hans Verkuil wrote:
> Support for alpha-channel aware pixelformats was added. Recognize those formats
> in libv4lconvert.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Looks good:

Acked-by: Hans de Goede <hdegoede@redhat.com>

Feel free to push.

Regards,

Hans

> 
> diff --git a/lib/libv4lconvert/libv4lconvert.c b/lib/libv4lconvert/libv4lconvert.c
> index 7ee7c19..cea65aa 100644
> --- a/lib/libv4lconvert/libv4lconvert.c
> +++ b/lib/libv4lconvert/libv4lconvert.c
> @@ -86,6 +86,10 @@ static const struct v4lconvert_pixfmt supported_src_pixfmts[] = {
>  	{ V4L2_PIX_FMT_RGB565,		16,	 4,	 6,	0 },
>  	{ V4L2_PIX_FMT_BGR32,		32,	 4,	 6,	0 },
>  	{ V4L2_PIX_FMT_RGB32,		32,	 4,	 6,	0 },
> +	{ V4L2_PIX_FMT_XBGR32,		32,	 4,	 6,	0 },
> +	{ V4L2_PIX_FMT_XRGB32,		32,	 4,	 6,	0 },
> +	{ V4L2_PIX_FMT_ABGR32,		32,	 4,	 6,	0 },
> +	{ V4L2_PIX_FMT_ARGB32,		32,	 4,	 6,	0 },
>  	/* yuv 4:2:2 formats */
>  	{ V4L2_PIX_FMT_YUYV,		16,	 5,	 4,	0 },
>  	{ V4L2_PIX_FMT_YVYU,		16,	 5,	 4,	0 },
> @@ -1121,6 +1125,8 @@ static int v4lconvert_convert_pixfmt(struct v4lconvert_data *data,
>  		break;
>  
>  	case V4L2_PIX_FMT_RGB32:
> +	case V4L2_PIX_FMT_XRGB32:
> +	case V4L2_PIX_FMT_ARGB32:
>  		if (src_size < (width * height * 4)) {
>  			V4LCONVERT_ERR("short rgb32 data frame\n");
>  			errno = EPIPE;
> @@ -1143,6 +1149,8 @@ static int v4lconvert_convert_pixfmt(struct v4lconvert_data *data,
>  		break;
>  
>  	case V4L2_PIX_FMT_BGR32:
> +	case V4L2_PIX_FMT_XBGR32:
> +	case V4L2_PIX_FMT_ABGR32:
>  		if (src_size < (width * height * 4)) {
>  			V4LCONVERT_ERR("short bgr32 data frame\n");
>  			errno = EPIPE;
> 
