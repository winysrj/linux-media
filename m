Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51936 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534Ab3HIN5Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Aug 2013 09:57:25 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: oliver@neukum.org
Cc: linux-media@vger.kernel.org, Oliver Neukum <oneukum@suse.de>
Subject: Re: [PATCH] uvc: more buffers
Date: Fri, 09 Aug 2013 15:58:31 +0200
Message-ID: <2017146.oxz2IcHa3F@avalon>
In-Reply-To: <1376053896-8931-1-git-send-email-oliver@neukum.org>
References: <1376053896-8931-1-git-send-email-oliver@neukum.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Oliver,

Thank you for the patch.

On Friday 09 August 2013 15:11:36 oliver@neukum.org wrote:
> From: Oliver Neukum <oneukum@suse.de>
> 
> This is necessary to let the new generation of cameras from LiteOn used in
> Haswell ULT notebook operate. Otherwise the images will be truncated.

Could you please post the lsusb -v output for the device ?

Why does it need more buffers, is it a superspeed webcam ?

> Signed-off-by: Oliver Neukum <oneukum@suse.de>
> ---
>  drivers/media/usb/uvc/uvcvideo.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/usb/uvc/uvcvideo.h
> b/drivers/media/usb/uvc/uvcvideo.h index 9e35982..9f1930b 100644
> --- a/drivers/media/usb/uvc/uvcvideo.h
> +++ b/drivers/media/usb/uvc/uvcvideo.h
> @@ -114,9 +114,9 @@
>  /* Number of isochronous URBs. */
>  #define UVC_URBS		5
>  /* Maximum number of packets per URB. */
> -#define UVC_MAX_PACKETS		32
> +#define UVC_MAX_PACKETS		128

That would mean up to 384KiB per URB. While not unreasonable, I'd like to know 
how much data your camera produces to require this.

>  /* Maximum number of video buffers. */
> -#define UVC_MAX_VIDEO_BUFFERS	32
> +#define UVC_MAX_VIDEO_BUFFERS	128

I don't think your camera really needs more than 32 V4L2 (full frame) buffers 
:-)

>  /* Maximum status buffer size in bytes of interrupt URB. */
>  #define UVC_MAX_STATUS_SIZE	16
-- 
Regards,

Laurent Pinchart

