Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47693 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932372AbcKVRVO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Nov 2016 12:21:14 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH 1/2] uvc_v4l2: Use memdup_user() rather than duplicating its implementation
Date: Tue, 22 Nov 2016 19:21:24 +0200
Message-ID: <3466616.R2EqhFMbZP@avalon>
In-Reply-To: <4181a4b7-3527-4ddf-4c7f-42fcd47977ca@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net> <95aa5fcd-8610-debc-70b0-30b2ed3302d2@users.sourceforge.net> <4181a4b7-3527-4ddf-4c7f-42fcd47977ca@users.sourceforge.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Markus,

Thank you for the patch.

On Friday 19 Aug 2016 11:23:18 SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Fri, 19 Aug 2016 10:50:05 +0200
> 
> Reuse existing functionality from memdup_user() instead of keeping
> duplicate source code.
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and applied to my tree.

> ---
>  drivers/media/usb/uvc/uvc_v4l2.c | 11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_v4l2.c
> b/drivers/media/usb/uvc/uvc_v4l2.c index 05eed4b..a7e12fd 100644
> --- a/drivers/media/usb/uvc/uvc_v4l2.c
> +++ b/drivers/media/usb/uvc/uvc_v4l2.c
> @@ -70,14 +70,9 @@ static int uvc_ioctl_ctrl_map(struct uvc_video_chain
> *chain, }
> 
>  		size = xmap->menu_count * sizeof(*map->menu_info);
> -		map->menu_info = kmalloc(size, GFP_KERNEL);
> -		if (map->menu_info == NULL) {
> -			ret = -ENOMEM;
> -			goto done;
> -		}
> -
> -		if (copy_from_user(map->menu_info, xmap->menu_info, size)) {
> -			ret = -EFAULT;
> +		map->menu_info = memdup_user(xmap->menu_info, size);
> +		if (IS_ERR(map->menu_info)) {
> +			ret = PTR_ERR(map->menu_info);
>  			goto done;
>  		}

-- 
Regards,

Laurent Pinchart

