Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:59995 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbaJKMCt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Oct 2014 08:02:49 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: John Crispin <blogic@openwrt.org>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] [media] uvcvideo: add a new quirk UVC_QUIRK_SINGLE_ISO
Date: Sat, 11 Oct 2014 15:03:01 +0300
Message-ID: <12847942.ZB1FmjiI8c@avalon>
In-Reply-To: <1412966473-5407-1-git-send-email-blogic@openwrt.org>
References: <1412966473-5407-1-git-send-email-blogic@openwrt.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi John,

On Friday 10 October 2014 20:41:12 John Crispin wrote:
> The following patch adds the usb ids for the iPassion chip. This chip is
> found on D-Link DIR-930 IP cameras. For them to work this patch needs to be
> applied. I am almost certain that this is the incorrect fix. Could someone
> shed a bit of light on how i should really implement the fix ?

First of all, could you explain how the camera misbehaves without this patch 
set ?

> Signed-off-by: John Crispin <blogic@openwrt.org>
> ---
>  drivers/media/usb/uvc/uvc_video.c |    2 ++
>  drivers/media/usb/uvc/uvcvideo.h  |    1 +
>  2 files changed, 3 insertions(+)
> 
> diff --git a/drivers/media/usb/uvc/uvc_video.c
> b/drivers/media/usb/uvc/uvc_video.c index 9144a2f..61381fd 100644
> --- a/drivers/media/usb/uvc/uvc_video.c
> +++ b/drivers/media/usb/uvc/uvc_video.c
> @@ -1495,6 +1495,8 @@ static int uvc_init_video_isoc(struct uvc_streaming
> *stream, if (npackets == 0)
>  		return -ENOMEM;
> 
> +	if (stream->dev->quirks & UVC_QUIRK_SINGLE_ISO)
> +		npackets = 1;
>  	size = npackets * psize;
> 
>  	for (i = 0; i < UVC_URBS; ++i) {
> diff --git a/drivers/media/usb/uvc/uvcvideo.h
> b/drivers/media/usb/uvc/uvcvideo.h index b1f69a6..b6df4f8 100644
> --- a/drivers/media/usb/uvc/uvcvideo.h
> +++ b/drivers/media/usb/uvc/uvcvideo.h
> @@ -147,6 +147,7 @@
>  #define UVC_QUIRK_FIX_BANDWIDTH		0x00000080
>  #define UVC_QUIRK_PROBE_DEF		0x00000100
>  #define UVC_QUIRK_RESTRICT_FRAME_RATE	0x00000200
> +#define UVC_QUIRK_SINGLE_ISO		0x00000400
> 
>  /* Format flags */
>  #define UVC_FMT_FLAG_COMPRESSED		0x00000001

-- 
Regards,

Laurent Pinchart

