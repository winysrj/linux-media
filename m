Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:56122 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753556AbcKYNsI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Nov 2016 08:48:08 -0500
Subject: Re: [patch] [media] uvcvideo: freeing an error pointer
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <20161125102835.GA5856@mwanda>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <3d5d23d6-14ab-5c22-978a-15b5546fdca9@users.sourceforge.net>
Date: Fri, 25 Nov 2016 14:40:32 +0100
MIME-Version: 1.0
In-Reply-To: <20161125102835.GA5856@mwanda>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> A recent cleanup introduced a potential dereference of -EFAULT when we
> call kfree(map->menu_info).
> 
> Fixes: 4cc5bed1caeb ("[media] uvcvideo: Use memdup_user() rather than duplicating its implementation")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks for your information.


> diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
> index a7e12fd..3e7e283 100644
> --- a/drivers/media/usb/uvc/uvc_v4l2.c
> +++ b/drivers/media/usb/uvc/uvc_v4l2.c
> @@ -66,14 +66,14 @@ static int uvc_ioctl_ctrl_map(struct uvc_video_chain *chain,
>  		if (xmap->menu_count == 0 ||
>  		    xmap->menu_count > UVC_MAX_CONTROL_MENU_ENTRIES) {
>  			ret = -EINVAL;
> -			goto done;
> +			goto free_map;
>  		}
>  
>  		size = xmap->menu_count * sizeof(*map->menu_info);
>  		map->menu_info = memdup_user(xmap->menu_info, size);
>  		if (IS_ERR(map->menu_info)) {
>  			ret = PTR_ERR(map->menu_info);
> -			goto done;
> +			goto free_map;
>  		}
>  
>  		map->menu_count = xmap->menu_count;
> @@ -83,13 +83,13 @@ static int uvc_ioctl_ctrl_map(struct uvc_video_chain *chain,
>  		uvc_trace(UVC_TRACE_CONTROL, "Unsupported V4L2 control type "
>  			  "%u.\n", xmap->v4l2_type);
>  		ret = -ENOTTY;
> -		goto done;
> +		goto free_map;
>  	}
>  
>  	ret = uvc_ctrl_add_mapping(chain, map);
>  
> -done:
>  	kfree(map->menu_info);
> +free_map:
>  	kfree(map);
>  
>  	return ret;
> 

Did your update suggestion become also relevant just because the corresponding
update step “[PATCH 2/2] uvc_v4l2: One function call less in uvc_ioctl_ctrl_map()
after error detection” which I offered as another change possibility on 2016-08-19
was rejected on 2016-11-22?

https://patchwork.linuxtv.org/patch/36528/
https://patchwork.kernel.org/patch/9289897/
https://lkml.kernel.org/r/<8f89ec37-1556-4c09-f0b7-df87b4169320@users.sourceforge.net>

Regards,
Markus
