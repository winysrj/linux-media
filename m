Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:51668 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751337AbdKFCHZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 5 Nov 2017 21:07:25 -0500
Received: by mail-it0-f66.google.com with SMTP id o135so3402360itb.0
        for <linux-media@vger.kernel.org>; Sun, 05 Nov 2017 18:07:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1508484328-11018-2-git-send-email-climbbb.kim@gmail.com>
References: <1508484328-11018-1-git-send-email-climbbb.kim@gmail.com> <1508484328-11018-2-git-send-email-climbbb.kim@gmail.com>
From: Jaejoong Kim <climbbb.kim@gmail.com>
Date: Mon, 6 Nov 2017 11:07:24 +0900
Message-ID: <CAL6iAa+eZzrY=PPmr2r8UM64sT9pc0vPcEXVkJNgA5XOx9UdBw@mail.gmail.com>
Subject: Re: [PATCH 1/2] media: usb: uvc: remove duplicate & operation
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, Jaejoong Kim <climbbb.kim@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Laurent

Could you please review this patch?

Thanks, jaejoong

2017-10-20 16:25 GMT+09:00 Jaejoong Kim <climbbb.kim@gmail.com>:
> usb_endpoint_maxp() has an inline keyword and searches for bits[10:0]
> by & operation with 0x7ff. So, we can remove the duplicate & operation
> with 0x7ff.
>
> Signed-off-by: Jaejoong Kim <climbbb.kim@gmail.com>
> ---
>  drivers/media/usb/uvc/uvc_video.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
> index fb86d6a..f4ace63 100644
> --- a/drivers/media/usb/uvc/uvc_video.c
> +++ b/drivers/media/usb/uvc/uvc_video.c
> @@ -1469,13 +1469,13 @@ static unsigned int uvc_endpoint_max_bpi(struct usb_device *dev,
>         case USB_SPEED_HIGH:
>                 psize = usb_endpoint_maxp(&ep->desc);
>                 mult = usb_endpoint_maxp_mult(&ep->desc);
> -               return (psize & 0x07ff) * mult;
> +               return psize * mult;
>         case USB_SPEED_WIRELESS:
>                 psize = usb_endpoint_maxp(&ep->desc);
>                 return psize;
>         default:
>                 psize = usb_endpoint_maxp(&ep->desc);
> -               return psize & 0x07ff;
> +               return psize;
>         }
>  }
>
> --
> 2.7.4
>
