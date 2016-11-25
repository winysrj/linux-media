Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40406 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754284AbcKYN53 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Nov 2016 08:57:29 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Markus Elfring <elfring@users.sourceforge.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] [media] uvcvideo: freeing an error pointer
Date: Fri, 25 Nov 2016 15:57:51 +0200
Message-ID: <2064794.XNX8XhaLMu@avalon>
In-Reply-To: <20161125102835.GA5856@mwanda>
References: <20161125102835.GA5856@mwanda>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dan,

Thank you for the patch.

On Friday 25 Nov 2016 13:28:35 Dan Carpenter wrote:
> A recent cleanup introduced a potential dereference of -EFAULT when we
> call kfree(map->menu_info).

I should have caught that, my apologies :-(

Thinking a bit more about this class of problems, would the following patch 
make sense ?

commit 034b71306510643f9f059249a0c14418099eb436
Author: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Date:   Fri Nov 25 15:54:22 2016 +0200

    mm/slab: WARN_ON error pointers passed to kfree()
    
    Passing an error pointer to kfree() is invalid and can lead to crashes
    or memory corruption. Reject those pointers and WARN in order to catch
    the problems and fix them in the callers.
    
    Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

diff --git a/mm/slab.c b/mm/slab.c
index 0b0550ca85b4..a7eb830c6684 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3819,6 +3819,8 @@ void kfree(const void *objp)
 
 	if (unlikely(ZERO_OR_NULL_PTR(objp)))
 		return;
+	if (WARN_ON(IS_ERR(objp)))
+		return;
 	local_irq_save(flags);
 	kfree_debugcheck(objp);
 	c = virt_to_cache(objp);

> Fixes: 4cc5bed1caeb ("[media] uvcvideo: Use memdup_user() rather than
> duplicating its implementation")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Mauro, the bug is present in your branch only at the moment and queued for 
v4.10. Could you please pick this patch up as well ?

> diff --git a/drivers/media/usb/uvc/uvc_v4l2.c
> b/drivers/media/usb/uvc/uvc_v4l2.c index a7e12fd..3e7e283 100644
> --- a/drivers/media/usb/uvc/uvc_v4l2.c
> +++ b/drivers/media/usb/uvc/uvc_v4l2.c
> @@ -66,14 +66,14 @@ static int uvc_ioctl_ctrl_map(struct uvc_video_chain
> *chain, if (xmap->menu_count == 0 ||
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
> @@ -83,13 +83,13 @@ static int uvc_ioctl_ctrl_map(struct uvc_video_chain
> *chain, uvc_trace(UVC_TRACE_CONTROL, "Unsupported V4L2 control type "
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

-- 
Regards,

Laurent Pinchart

