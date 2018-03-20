Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:34565 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751405AbeCTQHT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Mar 2018 12:07:19 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH] media: uvcvideo: Fix minor spelling
Date: Tue, 20 Mar 2018 18:08:24 +0200
Message-ID: <3558508.4xTiNFtbLm@avalon>
In-Reply-To: <1521560588-21845-1-git-send-email-kieran.bingham+renesas@ideasonboard.com>
References: <1521560588-21845-1-git-send-email-kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thank you for the patch.

On Tuesday, 20 March 2018 17:43:08 EET Kieran Bingham wrote:
> From: Kieran Bingham <kieran.bingham@ideasonboard.com>
> 
> Provide the missing 't' from straightforward.
> 
> Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and applied to my tree.

> ---
>  drivers/media/usb/uvc/uvc_ctrl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_ctrl.c
> b/drivers/media/usb/uvc/uvc_ctrl.c index 102594ec3e97..1daf444371be 100644
> --- a/drivers/media/usb/uvc/uvc_ctrl.c
> +++ b/drivers/media/usb/uvc/uvc_ctrl.c
> @@ -1125,7 +1125,7 @@ int uvc_query_v4l2_ctrl(struct uvc_video_chain *chain,
> }
> 
>  /*
> - * Mapping V4L2 controls to UVC controls can be straighforward if done
> well. + * Mapping V4L2 controls to UVC controls can be straightforward if
> done well. * Most of the UVC controls exist in V4L2, and can be mapped
> directly. Some * must be grouped (for instance the Red Balance, Blue
> Balance and Do White * Balance V4L2 controls use the White Balance
> Component UVC control) or


-- 
Regards,

Laurent Pinchart
