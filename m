Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47282 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751598AbdJII2Y (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Oct 2017 04:28:24 -0400
Subject: Re: [PATCH] uvcvideo: Apply flags from device to actual properties
To: Edgar Thier <info@edgarthier.net>, kieran.bingham@ideasonboard.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
References: <ca483e75-4519-2bc3-eb11-db647fc60860@edgarthier.net>
 <1516233.pKQSzG3xyp@avalon>
 <e6c92808-82e7-05bc-28b4-370ca51aa2de@edgarthier.net>
 <bf6ced8e-6fbb-5054-bbf6-1186d52459b9@ideasonboard.com>
 <443c86f9-0973-cf52-c0c3-be662a8fee74@ideasonboard.com>
 <ae5ca43a-1ccd-b1fd-c699-f9f1d4f96dc3@edgarthier.net>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <8b32b0f3-e442-6761-ef1c-34ac535080d0@ideasonboard.com>
Date: Mon, 9 Oct 2017 09:28:19 +0100
MIME-Version: 1.0
In-Reply-To: <ae5ca43a-1ccd-b1fd-c699-f9f1d4f96dc3@edgarthier.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Edgar,

Thank you for the patch respin.

I'm still a bit concerned about that -ENOMEM though:

On 06/10/17 11:34, Edgar Thier wrote:
> 
> Use flags the device exposes for UVC controls.
> This allows the device to define which property flags are set.
> 
> Since some cameras offer auto-adjustments for properties (e.g. auto-gain),
> the values of other properties (e.g. gain) can change in the camera.
> Examining the flags ensures that the driver is aware of such properties.
> 
> Signed-off-by: Edgar Thier <info@edgarthier.net>
> ---
>  drivers/media/usb/uvc/uvc_ctrl.c | 56 +++++++++++++++++++++++++++-------------
>  1 file changed, 38 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
> index 20397ab..5091086 100644
> --- a/drivers/media/usb/uvc/uvc_ctrl.c
> +++ b/drivers/media/usb/uvc/uvc_ctrl.c
> @@ -1630,6 +1630,41 @@ static void uvc_ctrl_fixup_xu_info(struct uvc_device *dev,
>  }
> 
>  /*
> + * Retrieve flags for a given control
> + */
> +static int uvc_ctrl_get_flags(struct uvc_device *dev, const struct uvc_control *ctrl,
> +	const struct uvc_control_info *info)
> +{
> +	u8 *data;
> +	int ret = 0;
> +	int flags = 0;
> +
> +	data = kmalloc(2, GFP_KERNEL);
> +	if (data == NULL)
> +		return -ENOMEM;
> +
> +	ret = uvc_query_ctrl(dev, UVC_GET_INFO, ctrl->entity->id, dev->intfnum,
> +						 info->selector, data, 1);
> +	if (ret < 0) {
> +		uvc_trace(UVC_TRACE_CONTROL,
> +				  "GET_INFO failed on control %pUl/%u (%d).\n",
> +				  info->entity, info->selector, ret);
> +	} else {
> +		flags = UVC_CTRL_FLAG_GET_MIN | UVC_CTRL_FLAG_GET_MAX
> +			| UVC_CTRL_FLAG_GET_RES | UVC_CTRL_FLAG_GET_DEF
> +			| (data[0] & UVC_CONTROL_CAP_GET ?
> +			   UVC_CTRL_FLAG_GET_CUR : 0)
> +			| (data[0] & UVC_CONTROL_CAP_SET ?
> +			   UVC_CTRL_FLAG_SET_CUR : 0)
> +			| (data[0] & UVC_CONTROL_CAP_AUTOUPDATE ?
> +			   UVC_CTRL_FLAG_AUTO_UPDATE : 0);
> +	}
> +	kfree(data);
> +	return flags;
> +}
> +
> +

(Minor nit) There's a double blank line there ...

> +/*
>   * Query control information (size and flags) for XU controls.
>   */
>  static int uvc_ctrl_fill_xu_info(struct uvc_device *dev,
> @@ -1659,24 +1694,7 @@ static int uvc_ctrl_fill_xu_info(struct uvc_device *dev,
> 
>  	info->size = le16_to_cpup((__le16 *)data);
> 
> -	/* Query the control information (GET_INFO) */
> -	ret = uvc_query_ctrl(dev, UVC_GET_INFO, ctrl->entity->id, dev->intfnum,
> -			     info->selector, data, 1);
> -	if (ret < 0) {
> -		uvc_trace(UVC_TRACE_CONTROL,
> -			  "GET_INFO failed on control %pUl/%u (%d).\n",
> -			  info->entity, info->selector, ret);
> -		goto done;
> -	}
> -
> -	info->flags = UVC_CTRL_FLAG_GET_MIN | UVC_CTRL_FLAG_GET_MAX
> -		    | UVC_CTRL_FLAG_GET_RES | UVC_CTRL_FLAG_GET_DEF
> -		    | (data[0] & UVC_CONTROL_CAP_GET ?
> -		       UVC_CTRL_FLAG_GET_CUR : 0)
> -		    | (data[0] & UVC_CONTROL_CAP_SET ?
> -		       UVC_CTRL_FLAG_SET_CUR : 0)
> -		    | (data[0] & UVC_CONTROL_CAP_AUTOUPDATE ?
> -		       UVC_CTRL_FLAG_AUTO_UPDATE : 0);

In this original code : info->flags is set based on the flags.
If the higher kmalloc failed, we wouldn't get here - and an error would have
already been returned to the caller.

> +	info->flags = uvc_ctrl_get_flags(dev, ctrl, info);

But now ... info->flags could be set to an error return code if
uvc_ctrl_get_flags fails.

That error code is not checked anywhere and could be mis-interpreted as 'real
(invalid) flags' in other code....

And at no point - have we presented an error message to state that these flags
are now set ... but completely invalid.


>  	uvc_ctrl_fixup_xu_info(dev, ctrl, info);
> 
> @@ -1902,6 +1920,8 @@ static int uvc_ctrl_add_info(struct uvc_device *dev, struct uvc_control *ctrl,
>  		goto done;
>  	}
> 
> +	ctrl->info.flags = uvc_ctrl_get_flags(dev, ctrl, info);
> +

And again here of course - now ctrl->info.flags could be set to -ENOMEM, or
rather -12 ... 0x(FFFFFFFF)FFFFFFF4

>  	ctrl->initialized = 1;
> 
>  	uvc_trace(UVC_TRACE_CONTROL, "Added control %pUl/%u to device %s "

Regards

Kieran
