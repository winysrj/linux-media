Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:47740 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728187AbeHGCJQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 6 Aug 2018 22:09:16 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Nadav Amit <namit@vmware.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: fix uvc_alloc_entity() allocation alignment
Date: Tue, 07 Aug 2018 02:58:27 +0300
Message-ID: <15813968.YrTFj7ZbY9@avalon>
In-Reply-To: <20180604134713.101064-1-namit@vmware.com>
References: <20180604134713.101064-1-namit@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Nadav,

Thank you for the patch.

On Monday, 4 June 2018 16:47:13 EEST Nadav Amit wrote:
> The use of ALIGN() in uvc_alloc_entity() is incorrect, since the size of
> (entity->pads) is not a power of two. As a stop-gap, until a better
> solution is adapted, use roundup() instead.
> 
> Found by a static assertion. Compile-tested only.
> 
> Fixes: 4ffc2d89f38a ("uvcvideo: Register subdevices for each entity")
> 
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: linux-media@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> 
> Signed-off-by: Nadav Amit <namit@vmware.com>
> ---
>  drivers/media/usb/uvc/uvc_driver.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_driver.c
> b/drivers/media/usb/uvc/uvc_driver.c index 2469b49b2b30..6b989d41c034
> 100644
> --- a/drivers/media/usb/uvc/uvc_driver.c
> +++ b/drivers/media/usb/uvc/uvc_driver.c
> @@ -909,7 +909,7 @@ static struct uvc_entity *uvc_alloc_entity(u16 type, u8
> id, unsigned int size;
>  	unsigned int i;
> 
> -	extra_size = ALIGN(extra_size, sizeof(*entity->pads));
> +	extra_size = roundup(extra_size, sizeof(*entity->pads));
>  	num_inputs = (type & UVC_TERM_OUTPUT) ? num_pads : num_pads - 1;
>  	size = sizeof(*entity) + extra_size + sizeof(*entity->pads) * num_pads
>  	     + num_inputs;

The purpose of this alignment is to make sure that entity->pads will be 
properly aligned. In theory the size of uvc_entity should be taken into 
account too, but the structure contains pointers, so its size should already 
be properly aligned. This patch thus looks good to me. What made you say it's 
a stop-gap measure ?

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and applied to my tree.

-- 
Regards,

Laurent Pinchart
