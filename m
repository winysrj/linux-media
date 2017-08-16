Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44333 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751943AbdHPO5l (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Aug 2017 10:57:41 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Edgar Thier <info@edgarthier.net>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] uvcvideo: Apply flags from device to actual properties
Date: Wed, 16 Aug 2017 17:58:04 +0300
Message-ID: <1516233.pKQSzG3xyp@avalon>
In-Reply-To: <ca483e75-4519-2bc3-eb11-db647fc60860@edgarthier.net>
References: <ca483e75-4519-2bc3-eb11-db647fc60860@edgarthier.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Edgar,

Thank you for the patch.

On Tuesday 15 Aug 2017 12:59:47 Edgar Thier wrote:
> Use flags the device exposes for UVC controls.

In addition to explaining what the patch does, the commit message should 
explain why the change is needed. What is the problem you're trying to address 
here ?

> Signed-off-by: Edgar Thier <info@edgarthier.net>
> ---
>  drivers/media/usb/uvc/uvc_ctrl.c | 26 +++++++++++++++++++++++++-
>  1 file changed, 25 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_ctrl.c
> b/drivers/media/usb/uvc/uvc_ctrl.c index c2ee6e3..bc69e92 100644
> --- a/drivers/media/usb/uvc/uvc_ctrl.c
> +++ b/drivers/media/usb/uvc/uvc_ctrl.c
> @@ -1568,7 +1568,8 @@ int uvc_ctrl_set(struct uvc_video_chain *chain,
>  				return ret;
>  		}
> 
> -		ctrl->loaded = 1;
> +		if (!(ctrl->info.flags && UVC_CTRL_FLAG_AUTO_UPDATE))
> +			ctrl->loaded = 1;

I think this change is unrelated to the subject of this patch. It should be 
split to a separate patch.

This being said, why is this change needed ? The uvc_ctrl_set() function is 
called from uvc_ctrl_s_ctrl() and uvc_ioctl_s_try_ext_ctrls(), and followed by 
a uvc_ctrl_rollback() or uvc_ctrl_commit() call that will set the loaded flag 
back to 0 in uvc_ctrl_commit_entity().

>  	}
> 
>  	/* Backup the current value in case we need to rollback later. */
> @@ -1889,8 +1890,13 @@ int uvc_ctrl_restore_values(struct uvc_device *dev)
>  static int uvc_ctrl_add_info(struct uvc_device *dev, struct uvc_control
> *ctrl, const struct uvc_control_info *info)
>  {
> +	u8 *data;
>  	int ret = 0;
> 
> +	data = kmalloc(2, GFP_KERNEL);
> +	if (data == NULL)
> +		return -ENOMEM;
> +
>  	ctrl->info = *info;
>  	INIT_LIST_HEAD(&ctrl->info.mappings);
> 
> @@ -1904,6 +1910,23 @@ static int uvc_ctrl_add_info(struct uvc_device *dev,
> struct uvc_control *ctrl,
> 
>  	ctrl->initialized = 1;
> 
> +	ret = uvc_query_ctrl(dev, UVC_GET_INFO, ctrl->entity->id, dev-
>intfnum,
> +                         info->selector, data, 1);
> +	if (ret < 0) {
> +		uvc_trace(UVC_TRACE_CONTROL,
> +			  "GET_INFO failed on control %pUl/%u (%d).\n",
> +			  info->entity, info->selector, ret);
> +	}
> +	else {
> +		ctrl->info.flags = UVC_CTRL_FLAG_GET_MIN | 
UVC_CTRL_FLAG_GET_MAX
> +		    | UVC_CTRL_FLAG_GET_RES | UVC_CTRL_FLAG_GET_DEF
> +		    | (data[0] & UVC_CONTROL_CAP_GET ?
> +		       UVC_CTRL_FLAG_GET_CUR : 0)
> +		    | (data[0] & UVC_CONTROL_CAP_SET ?
> +		       UVC_CTRL_FLAG_SET_CUR : 0)
> +		    | (data[0] & UVC_CONTROL_CAP_AUTOUPDATE ?
> +		       UVC_CTRL_FLAG_AUTO_UPDATE : 0);
> +	}

This code seems copied from uvc_ctrl_fill_xu_info(). I'd rather move it to a 
function that can be called by both instead of duplicating it.

>  	uvc_trace(UVC_TRACE_CONTROL, "Added control %pUl/%u to device %s "
>  		"entity %u\n", ctrl->info.entity, ctrl->info.selector,
>  		dev->udev->devpath, ctrl->entity->id);
> @@ -1911,6 +1934,7 @@ static int uvc_ctrl_add_info(struct uvc_device *dev,
> struct uvc_control *ctrl, done:
>  	if (ret < 0)
>  		kfree(ctrl->uvc_data);
> +	kfree(data);
>  	return ret;
>  }

-- 
Regards,

Laurent Pinchart
