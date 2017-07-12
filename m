Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:60241 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753681AbdGLA6N (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Jul 2017 20:58:13 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Richard Simmons <rssimmo@amazon.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Robb Glasser <rglasser@google.com>
Subject: Re: [PATCH v2] [media] uvcvideo: Prevent heap overflow in uvc driver
Date: Wed, 12 Jul 2017 03:58:15 +0300
Message-ID: <2146699.kzif97nFig@avalon>
In-Reply-To: <1498839716-31918-1-git-send-email-linux@roeck-us.net>
References: <1498839716-31918-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guenter,

Thank you for the patch and sorry for the late reply.

On Friday 30 Jun 2017 09:21:56 Guenter Roeck wrote:
> The size of uvc_control_mapping is user controlled leading to a
> potential heap overflow in the uvc driver. This adds a check to verify
> the user provided size fits within the bounds of the defined buffer
> size.
> 
> Originally-from: Richard Simmons <rssimmo@amazon.com>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

This looks good to me.

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and taken in my tree for v4.14 with a Cc: stable@vger.kernel.org tag to get it 
backported to stable kernels.

> ---
> Fixes CVE-2017-0627.
> 
> v2: Combination of v1 with the fix suggested by Richard Simmons
>     Perform validation after uvc_ctrl_fill_xu_info()
>     Take into account that ctrl->info.size is in bytes
>     Also validate mapping->size
> 
>  drivers/media/usb/uvc/uvc_ctrl.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/media/usb/uvc/uvc_ctrl.c
> b/drivers/media/usb/uvc/uvc_ctrl.c index c2ee6e39fd0c..d3e3164f43fd 100644
> --- a/drivers/media/usb/uvc/uvc_ctrl.c
> +++ b/drivers/media/usb/uvc/uvc_ctrl.c
> @@ -2002,6 +2002,13 @@ int uvc_ctrl_add_mapping(struct uvc_video_chain
> *chain, goto done;
>  	}
> 
> +	/* validate that the user provided bit-size and offset is valid */
> +	if (mapping->size > 32 ||
> +	    mapping->offset + mapping->size > ctrl->info.size * 8) {
> +		ret = -EINVAL;
> +		goto done;
> +	}
> +
>  	list_for_each_entry(map, &ctrl->info.mappings, list) {
>  		if (mapping->id == map->id) {
>  			uvc_trace(UVC_TRACE_CONTROL, "Can't add mapping '%s', 
"

-- 
Regards,

Laurent Pinchart
