Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47887 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbcEIXwO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 May 2016 19:52:14 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Oliver Neukum <oneukum@suse.com>
Cc: gregKH@linuxfoundation.org, linux-media@vger.kernel.org,
	Oliver Neukum <ONeukum@suse.com>
Subject: Re: [PATCH 2/2] uvc: correct speed testing
Date: Tue, 10 May 2016 02:52:40 +0300
Message-ID: <6532758.WYmJGVd9sB@avalon>
In-Reply-To: <1462188201-20357-1-git-send-email-oneukum@suse.com>
References: <1462188201-20357-1-git-send-email-oneukum@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Oliver,

Thank you for the patch.

On Monday 02 May 2016 13:23:21 Oliver Neukum wrote:
> Allow for SS+ USB devices
> 
> Signed-off-by: Oliver Neukum <ONeukum@suse.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

And applied to my tree.

> ---
>  drivers/media/usb/uvc/uvc_video.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/usb/uvc/uvc_video.c
> b/drivers/media/usb/uvc/uvc_video.c index 075a0fe..b5589d5 100644
> --- a/drivers/media/usb/uvc/uvc_video.c
> +++ b/drivers/media/usb/uvc/uvc_video.c
> @@ -1470,6 +1470,7 @@ static unsigned int uvc_endpoint_max_bpi(struct
> usb_device *dev,
> 
>  	switch (dev->speed) {
>  	case USB_SPEED_SUPER:
> +	case USB_SPEED_SUPER_PLUS:
>  		return le16_to_cpu(ep->ss_ep_comp.wBytesPerInterval);
>  	case USB_SPEED_HIGH:
>  		psize = usb_endpoint_maxp(&ep->desc);

-- 
Regards,

Laurent Pinchart

