Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:53827 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754152AbdGJTr0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Jul 2017 15:47:26 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jim Lin <jilin@nvidia.com>
Cc: mchehab@kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1 V2] media: usb: uvc: Fix incorrect timeout for Get Request
Date: Mon, 10 Jul 2017 22:47:28 +0300
Message-ID: <3026364.oSOK2ZPSm0@avalon>
In-Reply-To: <1499669029-3412-1-git-send-email-jilin@nvidia.com>
References: <1499669029-3412-1-git-send-email-jilin@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jim,

Thank you for the patch.

On Monday 10 Jul 2017 14:43:49 Jim Lin wrote:
> Section 9.2.6.4 of USB 2.0/3.x specification describes that
> "device must be able to return the first data packet to host within
> 500 ms of receipt of the request. For subsequent data packet, if any,
> the device must be able to return them within 500 ms".
> 
> This is to fix incorrect timeout and change it from 300 ms to 500 ms
> to meet the timing specified by specification for Get Request.
> 
> Signed-off-by: Jim Lin <jilin@nvidia.com>

The patch looks good to me, so

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

but I'm curious, have you noticed issues with some devices in practice ?

> ---
> V2: Change patch description
> 
>  drivers/media/usb/uvc/uvcvideo.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/usb/uvc/uvcvideo.h
> b/drivers/media/usb/uvc/uvcvideo.h index 15e415e..296b69b 100644
> --- a/drivers/media/usb/uvc/uvcvideo.h
> +++ b/drivers/media/usb/uvc/uvcvideo.h
> @@ -166,7 +166,7 @@
>  /* Maximum status buffer size in bytes of interrupt URB. */
>  #define UVC_MAX_STATUS_SIZE	16
> 
> -#define UVC_CTRL_CONTROL_TIMEOUT	300
> +#define UVC_CTRL_CONTROL_TIMEOUT	500
>  #define UVC_CTRL_STREAMING_TIMEOUT	5000
> 
>  /* Maximum allowed number of control mappings per device */

-- 
Regards,

Laurent Pinchart
