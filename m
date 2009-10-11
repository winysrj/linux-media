Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:54759 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452AbZJKWdG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Oct 2009 18:33:06 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 5/8] drivers/media/video/uvc: Use %pUl to print UUIDs
Date: Mon, 12 Oct 2009 00:34:58 +0200
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
References: <1254890742-28245-1-git-send-email-joe@perches.com> <ef810b1f134d8b5f07b849b13751445d7d49956b.1254884776.git.joe@perches.com>
In-Reply-To: <ef810b1f134d8b5f07b849b13751445d7d49956b.1254884776.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200910120034.58943.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Joe,

On Wednesday 07 October 2009 06:45:38 Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/media/video/uvc/uvc_ctrl.c   |   69 ++++++++++++++++------------------
>  drivers/media/video/uvc/uvc_driver.c |    7 +--
>  drivers/media/video/uvc/uvcvideo.h   |   10 -----
>  3 files changed, 35 insertions(+), 51 deletions(-)
> 
> diff --git a/drivers/media/video/uvc/uvc_ctrl.c
>  b/drivers/media/video/uvc/uvc_ctrl.c index c3225a5..4d06976 100644
> --- a/drivers/media/video/uvc/uvc_ctrl.c
> +++ b/drivers/media/video/uvc/uvc_ctrl.c
> @@ -1093,8 +1093,8 @@ int uvc_xu_ctrl_query(struct uvc_video_chain *chain,
> 
>  	if (!found) {
>  		uvc_trace(UVC_TRACE_CONTROL,
> -			"Control " UVC_GUID_FORMAT "/%u not found.\n",
> -			UVC_GUID_ARGS(entity->extension.guidExtensionCode),
> +			"Control %pUl/%u not found.\n",
> +			entity->extension.guidExtensionCode,
>  			xctrl->selector);
>  		return -EINVAL;
>  	}
> @@ -1171,9 +1171,9 @@ int uvc_ctrl_resume_device(struct uvc_device *dev)
>  			    (ctrl->info->flags & UVC_CONTROL_RESTORE) == 0)
>  				continue;
> 
> -			printk(KERN_INFO "restoring control " UVC_GUID_FORMAT
> -				"/%u/%u\n", UVC_GUID_ARGS(ctrl->info->entity),
> -				ctrl->info->index, ctrl->info->selector);
> +			printk(KERN_INFO "restoring control %pUl/%u/%u\n",
> +			       ctrl->info->entity,
> +			       ctrl->info->index, ctrl->info->selector);
>  			ctrl->dirty = 1;
>  		}
> 
> @@ -1228,46 +1228,43 @@ static void uvc_ctrl_add_ctrl(struct uvc_device
>  *dev, dev->intfnum, info->selector, (__u8 *)&size, 2);
>  		if (ret < 0) {
>  			uvc_trace(UVC_TRACE_CONTROL, "GET_LEN failed on "
> -				"control " UVC_GUID_FORMAT "/%u (%d).\n",
> -				UVC_GUID_ARGS(info->entity), info->selector,
> -				ret);
> +				  "control %pUl/%u (%d).\n",
> +				  info->entity, info->selector, ret);
>  			return;
>  		}
> 
>  		if (info->size != le16_to_cpu(size)) {
> -			uvc_trace(UVC_TRACE_CONTROL, "Control " UVC_GUID_FORMAT
> -				"/%u size doesn't match user supplied "
> -				"value.\n", UVC_GUID_ARGS(info->entity),
> -				info->selector);
> +			uvc_trace(UVC_TRACE_CONTROL,
> +				  "Control %pUl/%u size doesn't match user supplied value.\n",
> +				  info->entity, info->selector);
>  			return;
>  		}
> 
>  		ret = uvc_query_ctrl(dev, UVC_GET_INFO, ctrl->entity->id,
>  			dev->intfnum, info->selector, &inf, 1);
>  		if (ret < 0) {
> -			uvc_trace(UVC_TRACE_CONTROL, "GET_INFO failed on "
> -				"control " UVC_GUID_FORMAT "/%u (%d).\n",
> -				UVC_GUID_ARGS(info->entity), info->selector,
> -				ret);
> +			uvc_trace(UVC_TRACE_CONTROL,
> +				  "GET_INFO failed on control %pUl/%u (%d).\n",
> +				  info->entity, info->selector, ret);
>  			return;
>  		}
> 
>  		flags = info->flags;
>  		if (((flags & UVC_CONTROL_GET_CUR) && !(inf & (1 << 0))) ||
>  		    ((flags & UVC_CONTROL_SET_CUR) && !(inf & (1 << 1)))) {
> -			uvc_trace(UVC_TRACE_CONTROL, "Control "
> -				UVC_GUID_FORMAT "/%u flags don't match "
> -				"supported operations.\n",
> -				UVC_GUID_ARGS(info->entity), info->selector);
> +			uvc_trace(UVC_TRACE_CONTROL,
> +				  "Control %pUl/%u flags don't match supported operations.\n",
> +				  info->entity, info->selector);
>  			return;
>  		}
>  	}
> 
>  	ctrl->info = info;
>  	ctrl->data = kmalloc(ctrl->info->size * UVC_CTRL_NDATA, GFP_KERNEL);
> -	uvc_trace(UVC_TRACE_CONTROL, "Added control " UVC_GUID_FORMAT "/%u "
> -		"to device %s entity %u\n", UVC_GUID_ARGS(ctrl->info->entity),
> -		ctrl->info->selector, dev->udev->devpath, entity->id);
> +	uvc_trace(UVC_TRACE_CONTROL,
> +		  "Added control %pUl/%u to device %s entity %u\n",
> +		  ctrl->info->entity, ctrl->info->selector,
> +		  dev->udev->devpath, entity->id);
>  }
> 
>  /*
> @@ -1293,17 +1290,16 @@ int uvc_ctrl_add_info(struct uvc_control_info
>  *info) continue;
> 
>  		if (ctrl->selector == info->selector) {
> -			uvc_trace(UVC_TRACE_CONTROL, "Control "
> -				UVC_GUID_FORMAT "/%u is already defined.\n",
> -				UVC_GUID_ARGS(info->entity), info->selector);
> +			uvc_trace(UVC_TRACE_CONTROL,
> +				  "Control %pUl/%u is already defined.\n",
> +				  info->entity, info->selector);
>  			ret = -EEXIST;
>  			goto end;
>  		}
>  		if (ctrl->index == info->index) {
> -			uvc_trace(UVC_TRACE_CONTROL, "Control "
> -				UVC_GUID_FORMAT "/%u would overwrite index "
> -				"%d.\n", UVC_GUID_ARGS(info->entity),
> -				info->selector, info->index);
> +			uvc_trace(UVC_TRACE_CONTROL,
> +				  "Control %pUl/%u would overwrite index %d.\n",
> +				  info->entity, info->selector, info->index);
>  			ret = -EEXIST;
>  			goto end;
>  		}
> @@ -1344,10 +1340,9 @@ int uvc_ctrl_add_mapping(struct uvc_control_mapping
>  *mapping) continue;
> 
>  		if (info->size * 8 < mapping->size + mapping->offset) {
> -			uvc_trace(UVC_TRACE_CONTROL, "Mapping '%s' would "
> -				"overflow control " UVC_GUID_FORMAT "/%u\n",
> -				mapping->name, UVC_GUID_ARGS(info->entity),
> -				info->selector);
> +			uvc_trace(UVC_TRACE_CONTROL,
> +				  "Mapping '%s' would overflow control %pUl/%u\n",
> +				  mapping->name, info->entity, info->selector);
>  			ret = -EOVERFLOW;
>  			goto end;
>  		}
> @@ -1366,9 +1361,9 @@ int uvc_ctrl_add_mapping(struct uvc_control_mapping
>  *mapping)
> 
>  		mapping->ctrl = info;
>  		list_add_tail(&mapping->list, &info->mappings);
> -		uvc_trace(UVC_TRACE_CONTROL, "Adding mapping %s to control "
> -			UVC_GUID_FORMAT "/%u.\n", mapping->name,
> -			UVC_GUID_ARGS(info->entity), info->selector);
> +		uvc_trace(UVC_TRACE_CONTROL,
> +			  "Adding mapping %s to control %pUl/%u.\n",
> +			  mapping->name, info->entity, info->selector);
> 
>  		ret = 0;
>  		break;
> diff --git a/drivers/media/video/uvc/uvc_driver.c
>  b/drivers/media/video/uvc/uvc_driver.c index 8756be5..411dc63 100644
> --- a/drivers/media/video/uvc/uvc_driver.c
> +++ b/drivers/media/video/uvc/uvc_driver.c
> @@ -328,11 +328,10 @@ static int uvc_parse_format(struct uvc_device *dev,
>  				sizeof format->name);
>  			format->fcc = fmtdesc->fcc;
>  		} else {
> -			uvc_printk(KERN_INFO, "Unknown video format "
> -				UVC_GUID_FORMAT "\n",
> -				UVC_GUID_ARGS(&buffer[5]));
> +			uvc_printk(KERN_INFO, "Unknown video format %pUl\n",
> +				   &buffer[5]);
>  			snprintf(format->name, sizeof format->name,
> -				UVC_GUID_FORMAT, UVC_GUID_ARGS(&buffer[5]));
> +				 "%pUl", &Buffer[5]);

Buffer should still be written buffer.

As this will go through the linuxtv v4l-dvb tree, I'll have to add backward
compatibility code (that will not make it to mainline). If that's ok with you
it will be easier for me to test and apply that part of the patch through my
tree once the vsprintf extension gets in. 

-- 
Regards,

Laurent Pinchart
