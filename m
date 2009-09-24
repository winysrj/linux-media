Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:44238 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671AbZIXGTk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Sep 2009 02:19:40 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Roel Kluin <roel.kluin@gmail.com>
Subject: Re: [PATCH] uvc: kmalloc failure ignored in uvc_ctrl_add_ctrl()
Date: Thu, 24 Sep 2009 08:20:54 +0200
Cc: linux-uvc-devel@lists.berlios.de, linux-media@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
References: <4AB43041.6050001@gmail.com>
In-Reply-To: <4AB43041.6050001@gmail.com>
MIME-Version: 1.0
Message-Id: <200909240820.54291.laurent.pinchart@ideasonboard.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Roel,

thanks for noticing the problem and providing a patch. Some comments inlined.

On Saturday 19 September 2009 03:13:37 Roel Kluin wrote:
> Produce an error if kmalloc() fails.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> Found with sed: http://kernelnewbies.org/roelkluin
> 
> Build tested. Please review
> 
> diff --git a/drivers/media/video/uvc/uvc_ctrl.c
>  b/drivers/media/video/uvc/uvc_ctrl.c index c3225a5..dda80b5 100644
> --- a/drivers/media/video/uvc/uvc_ctrl.c
> +++ b/drivers/media/video/uvc/uvc_ctrl.c
> @@ -1189,7 +1189,7 @@ int uvc_ctrl_resume_device(struct uvc_device *dev)
>   * Control and mapping handling
>   */
> 
> -static void uvc_ctrl_add_ctrl(struct uvc_device *dev,
> +static int uvc_ctrl_add_ctrl(struct uvc_device *dev,
>  	struct uvc_control_info *info)
>  {
>  	struct uvc_entity *entity;
> @@ -1214,7 +1214,7 @@ static void uvc_ctrl_add_ctrl(struct uvc_device *dev,
>  	}
> 
>  	if (!found)
> -		return;
> +		return 0;
> 
>  	if (UVC_ENTITY_TYPE(entity) == UVC_VC_EXTENSION_UNIT) {
>  		/* Check if the device control information and length match
> @@ -1231,7 +1231,7 @@ static void uvc_ctrl_add_ctrl(struct uvc_device *dev,
>  				"control " UVC_GUID_FORMAT "/%u (%d).\n",
>  				UVC_GUID_ARGS(info->entity), info->selector,
>  				ret);
> -			return;
> +			return -EINVAL;

uvc_query_ctrl returns an error code on failure, so

return ret;

might be more appropriate.

>  		}
> 
>  		if (info->size != le16_to_cpu(size)) {
> @@ -1239,7 +1239,7 @@ static void uvc_ctrl_add_ctrl(struct uvc_device *dev,
>  				"/%u size doesn't match user supplied "
>  				"value.\n", UVC_GUID_ARGS(info->entity),
>  				info->selector);
> -			return;
> +			return -EINVAL;
>  		}
> 
>  		ret = uvc_query_ctrl(dev, UVC_GET_INFO, ctrl->entity->id,
> @@ -1249,7 +1249,7 @@ static void uvc_ctrl_add_ctrl(struct uvc_device *dev,
>  				"control " UVC_GUID_FORMAT "/%u (%d).\n",
>  				UVC_GUID_ARGS(info->entity), info->selector,
>  				ret);
> -			return;
> +			return -EINVAL;
>  		}

Ditto,

return ret;
 
>  		flags = info->flags;
> @@ -1259,15 +1259,18 @@ static void uvc_ctrl_add_ctrl(struct uvc_device
>  *dev, UVC_GUID_FORMAT "/%u flags don't match "
>  				"supported operations.\n",
>  				UVC_GUID_ARGS(info->entity), info->selector);
> -			return;
> +			return -EINVAL;
>  		}
>  	}
> 
>  	ctrl->info = info;
>  	ctrl->data = kmalloc(ctrl->info->size * UVC_CTRL_NDATA, GFP_KERNEL);
> +	if (ctrl->data == NULL)
> +		return -ENOMEM;

That's not enough to prevent a kernel crash. The driver can try to dereference 
ctrl->data if ctrl->info isn't NULL. You should only set ctrl->info if 
allocationg succeeds. Something like

  	ctrl->data = kmalloc(ctrl->info->size * UVC_CTRL_NDATA, GFP_KERNEL);
	if (ctrl->data == NULL)
		return -ENOMEM;

  	ctrl->info = info;

>  	uvc_trace(UVC_TRACE_CONTROL, "Added control " UVC_GUID_FORMAT "/%u "
>  		"to device %s entity %u\n", UVC_GUID_ARGS(ctrl->info->entity),
>  		ctrl->info->selector, dev->udev->devpath, entity->id);
> +	return 0;
>  }
> 
>  /*
> @@ -1309,8 +1312,11 @@ int uvc_ctrl_add_info(struct uvc_control_info *info)
>  		}
>  	}
> 
> -	list_for_each_entry(dev, &uvc_driver.devices, list)
> -		uvc_ctrl_add_ctrl(dev, info);
> +	list_for_each_entry(dev, &uvc_driver.devices, list) {
> +		ret = uvc_ctrl_add_ctrl(dev, info);
> +		if (ret == -ENOMEM)
> +			goto end;
> +	}

This could lead to a memory leak.

Let's suppose you have two connected devices and try to add a control that 
both devices support. Let's also suppose the call to uvc_ctrl_add_ctrl() 
succeeds for the first device, but fails with -ENOMEM for the second. 
UVCIOC_CTRL_ADD will then return with an error without adding the control 
information to the uvc_driver.controls list.

The userspace application receives an -ENOMEM error an retries the call. 
uvc_ctrl_add_ctrl() will then overwrite ctrl->data with newly kmalloc'ed 
memory, leaking the previously allocated instance.

I'm not sure if we should really bail out here. The current situation is 
clearly not optimal, in the sense that UVCIOC_CTRL_ADD will succeed even if 
allocation fails for some control instances. On the other hand, your patch 
introduces a memory leak, which is not good either.

If we decide to bail out with an error we probably need to free ctrl->data 
memory allocated by the UVCIOC_CTRL_ADD call (and reset ctrl->info to NULL), 
or at least make sure we properly kfree ctrl->data on the next call if it's 
not NULL. We would also need to handle other errors, I don't see why -ENOMEM 
should get a special treatment.

This might be a bit too complex. It would be simpler just to keep on looping 
over devices and adding controls even if an error occurs.

>  	INIT_LIST_HEAD(&info->mappings);
>  	list_add_tail(&info->list, &uvc_driver.controls);
> 

uvc_ctrl_add_ctrl() is also called in uvc_ctrl_init_device(). If we're going 
to handle errors in uvc_ctrl_add_info(), they should be handled in 
uvc_ctrl_init_device() as well.

My opinion is that we should probably not care about uvc_ctrl_add_ctrl() 
errors, but we certainly need to prevent ctrl->info from being modified if 
ctrl->data allocation fails. In that case uvc_ctrl_add_ctrl() can still be a 
void function, all we would need to do would be

-  	ctrl->info = info;
  	ctrl->data = kmalloc(ctrl->info->size * UVC_CTRL_NDATA, GFP_KERNEL);
+	if (ctrl->data == NULL)
+		return -ENOMEM;
+
+  	ctrl->info = info;

-- 
Regards,

Laurent Pinchart
