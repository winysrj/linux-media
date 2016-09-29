Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:34454 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933007AbcI2JTM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Sep 2016 05:19:12 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Felipe Balbi <felipe.balbi@linux.intel.com>
Cc: Linux USB <linux-usb@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Subject: Re: [RFC/PATCH 30/45] media: usb: uvc: remove unnecessary & operation
Date: Thu, 29 Sep 2016 12:19:08 +0300
Message-ID: <9458858.X6S0nte73o@avalon>
In-Reply-To: <20160928130554.29790-31-felipe.balbi@linux.intel.com>
References: <20160928130554.29790-1-felipe.balbi@linux.intel.com> <20160928130554.29790-31-felipe.balbi@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Felipe,

Thank you for the patch.

On Wednesday 28 Sep 2016 16:05:39 Felipe Balbi wrote:
> Now that usb_endpoint_maxp() only returns the lowest
> 11 bits from wMaxPacketSize, we can remove the &
> operation from this driver.
> 
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: <linux-media@vger.kernel.org>
> Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/usb/uvc/uvc_video.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_video.c
> b/drivers/media/usb/uvc/uvc_video.c index 11e0e5f4e1c2..f3c1c852e401 100644
> --- a/drivers/media/usb/uvc/uvc_video.c
> +++ b/drivers/media/usb/uvc/uvc_video.c
> @@ -1553,7 +1553,7 @@ static int uvc_init_video_bulk(struct uvc_streaming
> *stream, u16 psize;
>  	u32 size;
> 
> -	psize = usb_endpoint_maxp(&ep->desc) & 0x7ff;
> +	psize = usb_endpoint_maxp(&ep->desc);
>  	size = stream->ctrl.dwMaxPayloadTransferSize;
>  	stream->bulk.max_payload_size = size;

-- 
Regards,

Laurent Pinchart

