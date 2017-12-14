Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout5.zih.tu-dresden.de ([141.30.67.74]:59770 "EHLO
        mailout5.zih.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750844AbdLNJwC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Dec 2017 04:52:02 -0500
From: Oleksandr Ostrenko <oleksandr.ostrenko@tu-dresden.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mike Isely <isely@pobox.com>
Subject: Re: [PATCH] pvrusb2: correctly return V4L2_PIX_FMT_MPEG in enum_fmt
Date: Thu, 14 Dec 2017 10:52:53 +0100
Message-ID: <2333216.hBMPJUJjxL@optiplex-980-apb-1025>
In-Reply-To: <3c98b33d-c92d-6fd1-ac69-215fa70de1b7@xs4all.nl>
References: <3c98b33d-c92d-6fd1-ac69-215fa70de1b7@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday, December 14, 2017 12:44:42 AM CET Hans Verkuil wrote:
> The pvrusb2 code appears to have a some old workaround code for xawtv that
> causes a WARN() due to an unrecognized pixelformat 0 in v4l2_ioctl.c.
> 
> Since all other MPEG drivers fill this in correctly, it is a safe assumption
> that this particular problem no longer exists.
> 
> While I'm at it, clean up the code a bit.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
> I'll try to give this a spin in the morning with xawtv and my ivtv card
> (that also uses V4L2_PIX_FMT_MPEG), just to make sure xawtv no longer
> breaks if it sees it.
> 
> Oleksandr, are you able to test this as well on your pvrusb2?

Thanks, Hans, this fixes the original issue on Linux Mint with kernel 
4.8.17. Haven't tried it on openSUSE yet. Still, in xawtv I get no TV 
reception but just a black screen and error messages like:

no way to get: 128x96 32 bit TrueColor (LE: bgr-)
no way to get: 128x96 32 bit TrueColor (LE: bgr-)
no way to get: 128x96 32 bit TrueColor (LE: bgr-)
no way to get: 128x96 32 bit TrueColor (LE: bgr-)
no way to get: 384x288 32 bit TrueColor (LE: bgr-)

Is this another bug?

Best,
Oleksandr

> 
> Regards,
> 
> 	Hans
> ---
> diff --git a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
> b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c index 4320bda9352d..cc90be364a30
> 100644
> --- a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
> +++ b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
> @@ -78,18 +78,6 @@ static int vbi_nr[PVR_NUM] = {[0 ... PVR_NUM-1] = -1};
>  module_param_array(vbi_nr, int, NULL, 0444);
>  MODULE_PARM_DESC(vbi_nr, "Offset for device's vbi dev minor");
> 
> -static struct v4l2_fmtdesc pvr_fmtdesc [] = {
> -	{
> -		.index          = 0,
> -		.type           = V4L2_BUF_TYPE_VIDEO_CAPTURE,
> -		.flags          = V4L2_FMT_FLAG_COMPRESSED,
> -		.description    = "MPEG1/2",
> -		// This should really be V4L2_PIX_FMT_MPEG, but xawtv
> -		// breaks when I do that.
> -		.pixelformat    = 0, // V4L2_PIX_FMT_MPEG,
> -	}
> -};
> -
>  #define PVR_FORMAT_PIX  0
>  #define PVR_FORMAT_VBI  1
> 
> @@ -99,17 +87,11 @@ static struct v4l2_format pvr_format [] = {
>  		.fmt    = {
>  			.pix        = {
>  				.width          = 720,
> -				.height             = 576,
> -				// This should really be V4L2_PIX_FMT_MPEG,
> -				// but xawtv breaks when I do that.
> -				.pixelformat    = 0, // V4L2_PIX_FMT_MPEG,
> +				.height         = 576,
> +				.pixelformat    = V4L2_PIX_FMT_MPEG,
>  				.field          = V4L2_FIELD_INTERLACED,
> -				.bytesperline   = 0,  // doesn't make sense
> -						      // here
> -				//FIXME : Don't know what to put here...
> -				.sizeimage          = (32*1024),
> -				.colorspace     = 0, // doesn't make sense here
> -				.priv           = 0
> +				/* FIXME : Don't know what to put here... */
> +				.sizeimage      = 32 * 1024,
>  			}
>  		}
>  	},
> @@ -407,11 +389,11 @@ static int pvr2_g_frequency(struct file *file, void
> *priv, struct v4l2_frequency
> 
>  static int pvr2_enum_fmt_vid_cap(struct file *file, void *priv, struct
> v4l2_fmtdesc *fd) {
> -	/* Only one format is supported : mpeg.*/
> -	if (fd->index != 0)
> +	/* Only one format is supported: MPEG. */
> +	if (fd->index)
>  		return -EINVAL;
> 
> -	memcpy(fd, pvr_fmtdesc, sizeof(struct v4l2_fmtdesc));
> +	fd->pixelformat = V4L2_PIX_FMT_MPEG;
>  	return 0;
>  }


-- 
Oleksandr Ostrenko, MSc.

Technische Universität Dresden
Center for Information Services and High Performance Computing (ZIH)
Department for Innovative Methods of Computing (IMC)
01062 Dresden, Germany

Phone: (+49) 351/463-38777
WWW:  http://imc.zih.tu-dresden.de/imc/
