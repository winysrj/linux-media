Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51589 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751213AbeABUHE (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 2 Jan 2018 15:07:04 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Edgar Thier <info@edgarthier.net>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] uvcvideo: Apply flags from device to actual properties
Date: Tue, 02 Jan 2018 22:07:24 +0200
Message-ID: <1772347.19cENqiAhc@avalon>
In-Reply-To: <7807bf0a-a0a1-65ad-1a10-3a3234e566e9@edgarthier.net>
References: <ca483e75-4519-2bc3-eb11-db647fc60860@edgarthier.net> <430ebf60-395c-08ff-5500-dedcda91e3b1@ideasonboard.com> <7807bf0a-a0a1-65ad-1a10-3a3234e566e9@edgarthier.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Edgar,

Thank you for the patch.

On Thursday, 12 October 2017 10:54:17 EET Edgar Thier wrote:
> Use flags the device exposes for UVC controls.
> This allows the device to define which property flags are set.
> 
> Since some cameras offer auto-adjustments for properties (e.g. auto-gain),
> the values of other properties (e.g. gain) can change in the camera.
> Examining the flags ensures that the driver is aware of such properties.
> 
> Signed-off-by: Edgar Thier <info@edgarthier.net>
> ---
>  drivers/media/usb/uvc/uvc_ctrl.c | 64 +++++++++++++++++++++++++++----------
>  1 file changed, 49 insertions(+), 15 deletions(-)

Running scripts/checkpatch.pl on the patch produces the following warning and 
errors.

WARNING: line over 80 characters
#83: FILE: drivers/media/usb/uvc/uvc_ctrl.c:1635:
+static int uvc_ctrl_get_flags(struct uvc_device *dev, const struct 
uvc_control *ctrl,

ERROR: code indent should use tabs where possible
#140: FILE: drivers/media/usb/uvc/uvc_ctrl.c:1702:
+ ^I^Iret = flags;$

WARNING: please, no space before tabs
#140: FILE: drivers/media/usb/uvc/uvc_ctrl.c:1702:
+ ^I^Iret = flags;$

WARNING: please, no spaces at the start of a line
#140: FILE: drivers/media/usb/uvc/uvc_ctrl.c:1702:
+ ^I^Iret = flags;$

The last three should be fixed. The first one can sometimes be considered a 
matter of taste, but in this case it's easy to fix so we should address it 
too.

> diff --git a/drivers/media/usb/uvc/uvc_ctrl.c
> b/drivers/media/usb/uvc/uvc_ctrl.c index 20397aba..8f902a41 100644
> --- a/drivers/media/usb/uvc/uvc_ctrl.c
> +++ b/drivers/media/usb/uvc/uvc_ctrl.c
> @@ -1629,6 +1629,40 @@ static void uvc_ctrl_fixup_xu_info(struct uvc_device
> *dev, }
>  }
> 
> +/*
> + * Retrieve flags for a given control
> + */
> +static int uvc_ctrl_get_flags(struct uvc_device *dev, const struct
> uvc_control *ctrl,
> +	const struct uvc_control_info *info)
> +{
> +	u8 *data;
> +	int ret = 0;

No need to initialize ret to 0.

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

So in case of failure you will return 0, and the caller will ignore the 
failure. This changes the behaviour of uvc_ctrl_fill_xu_info() which I don't 
think is a good idea. For uvc_ctrl_add_info(), on the other hand, ignoring 
errors is probably good, as otherwise we could introduce regressions with 
devices that don't implement GET_INFO properly on standard controls (the 
driver currently doesn't query information for standard controls so doesn't 
catch those devices).

> +}
> +
>  /*
>   * Query control information (size and flags) for XU controls.
>   */
> @@ -1636,6 +1670,7 @@ static int uvc_ctrl_fill_xu_info(struct uvc_device
> *dev, const struct uvc_control *ctrl, struct uvc_control_info *info)
>  {
>  	u8 *data;
> +	int flags;
>  	int ret;
> 
>  	data = kmalloc(2, GFP_KERNEL);
> @@ -1659,24 +1694,15 @@ static int uvc_ctrl_fill_xu_info(struct uvc_device
> *dev,
> 
>  	info->size = le16_to_cpup((__le16 *)data);
> 
> -	/* Query the control information (GET_INFO) */
> -	ret = uvc_query_ctrl(dev, UVC_GET_INFO, ctrl->entity->id, dev->intfnum,
> -			     info->selector, data, 1);
> -	if (ret < 0) {
> +	flags = uvc_ctrl_get_flags(dev, ctrl, info);
> +

No need for a blank line here.

> +	if (flags < 0) {
>  		uvc_trace(UVC_TRACE_CONTROL,
> -			  "GET_INFO failed on control %pUl/%u (%d).\n",
> -			  info->entity, info->selector, ret);
> +			  "Failed to retrieve flags (%d).\n", ret);
> + 		ret = flags;
>  		goto done;
>  	}
> -
> -	info->flags = UVC_CTRL_FLAG_GET_MIN | UVC_CTRL_FLAG_GET_MAX
> -		    | UVC_CTRL_FLAG_GET_RES | UVC_CTRL_FLAG_GET_DEF
> -		    | (data[0] & UVC_CONTROL_CAP_GET ?
> -		       UVC_CTRL_FLAG_GET_CUR : 0)
> -		    | (data[0] & UVC_CONTROL_CAP_SET ?
> -		       UVC_CTRL_FLAG_SET_CUR : 0)
> -		    | (data[0] & UVC_CONTROL_CAP_AUTOUPDATE ?
> -		       UVC_CTRL_FLAG_AUTO_UPDATE : 0);
> +	info->flags = flags;
> 
>  	uvc_ctrl_fixup_xu_info(dev, ctrl, info);
> 
> @@ -1890,6 +1916,7 @@ static int uvc_ctrl_add_info(struct uvc_device *dev,
> struct uvc_control *ctrl, const struct uvc_control_info *info)
>  {
>  	int ret = 0;
> +	int flags = 0;

There's no need to initialize the flags variable to 0.

> 
>  	ctrl->info = *info;
>  	INIT_LIST_HEAD(&ctrl->info.mappings);
> @@ -1902,6 +1929,13 @@ static int uvc_ctrl_add_info(struct uvc_device *dev,
> struct uvc_control *ctrl, goto done;
>  	}
> 
> +	flags = uvc_ctrl_get_flags(dev, ctrl, info);
> +	if (flags < 0)
> +		uvc_trace(UVC_TRACE_CONTROL,
> +			  "Failed to retrieve flags (%d).\n", ret);
> +	else
> +		ctrl->info.flags = flags;
> +
>  	ctrl->initialized = 1;
> 
>  	uvc_trace(UVC_TRACE_CONTROL, "Added control %pUl/%u to device %s "

All these are small issues. Let me try to address them, I'll send you an 
updated patch shortly.

-- 
Regards,

Laurent Pinchart
