Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:33397 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751996AbdJKMVH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Oct 2017 08:21:07 -0400
Subject: Re: [PATCH] uvcvideo: Apply flags from device to actual properties
To: Edgar Thier <info@edgarthier.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
References: <ca483e75-4519-2bc3-eb11-db647fc60860@edgarthier.net>
 <1516233.pKQSzG3xyp@avalon>
 <e6c92808-82e7-05bc-28b4-370ca51aa2de@edgarthier.net>
 <bf6ced8e-6fbb-5054-bbf6-1186d52459b9@ideasonboard.com>
 <443c86f9-0973-cf52-c0c3-be662a8fee74@ideasonboard.com>
 <ae5ca43a-1ccd-b1fd-c699-f9f1d4f96dc3@edgarthier.net>
 <8b32b0f3-e442-6761-ef1c-34ac535080d0@ideasonboard.com>
 <7342af02-0158-a99e-caf1-6c394842296b@edgarthier.net>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <430ebf60-395c-08ff-5500-dedcda91e3b1@ideasonboard.com>
Date: Wed, 11 Oct 2017 13:21:02 +0100
MIME-Version: 1.0
In-Reply-To: <7342af02-0158-a99e-caf1-6c394842296b@edgarthier.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Edgar,

Sorry for not replying to you yesterday on IRC, but by the time I got to reply
to the message you weren't online..

On 11/10/17 12:56, Edgar Thier wrote:
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
>  drivers/media/usb/uvc/uvc_ctrl.c | 65 ++++++++++++++++++++++++++++++----------
>  1 file changed, 50 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
> index 20397ab..7fbfeef 100644
> --- a/drivers/media/usb/uvc/uvc_ctrl.c
> +++ b/drivers/media/usb/uvc/uvc_ctrl.c
> @@ -1630,12 +1630,47 @@ static void uvc_ctrl_fixup_xu_info(struct uvc_device *dev,
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
> +/*
>   * Query control information (size and flags) for XU controls.
>   */
>  static int uvc_ctrl_fill_xu_info(struct uvc_device *dev,
>  	const struct uvc_control *ctrl, struct uvc_control_info *info)
>  {
>  	u8 *data;
> +	int flags;
>  	int ret;
> 
>  	data = kmalloc(2, GFP_KERNEL);
> @@ -1659,24 +1694,14 @@ static int uvc_ctrl_fill_xu_info(struct uvc_device *dev,
> 
>  	info->size = le16_to_cpup((__le16 *)data);
> 
> -	/* Query the control information (GET_INFO) */
> -	ret = uvc_query_ctrl(dev, UVC_GET_INFO, ctrl->entity->id, dev->intfnum,
> -			     info->selector, data, 1);
> -	if (ret < 0) {
> +	flags = uvc_ctrl_get_flags(dev, ctrl, info);
> +
> +	if (flags < 0) {
>  		uvc_trace(UVC_TRACE_CONTROL,
> -			  "GET_INFO failed on control %pUl/%u (%d).\n",
> -			  info->entity, info->selector, ret);
> +			  "Failed to retrieve flags (%d).\n", ret);

I think we need to set 'ret' to be an error value here ?
ret = flags? or ret = -ENOMEM?

Otherwise in 'done:' ret will be the return value of the previous
uvc_query_ctrl() call.

>  		goto done;
>  	}> -
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
> @@ -1890,6 +1915,7 @@ static int uvc_ctrl_add_info(struct uvc_device *dev, struct uvc_control *ctrl,
>  	const struct uvc_control_info *info)
>  {
>  	int ret = 0;
> +	int flags = 0;
> 
>  	ctrl->info = *info;
>  	INIT_LIST_HEAD(&ctrl->info.mappings);
> @@ -1902,6 +1928,15 @@ static int uvc_ctrl_add_info(struct uvc_device *dev, struct uvc_control *ctrl,
>  		goto done;
>  	}
> 
> +	flags = uvc_ctrl_get_flags(dev, ctrl, info);
> +

I think the if could hug the call, and remove this blank line.

> +	if (flags < 0) {
> +		uvc_trace(UVC_TRACE_CONTROL,
> +			  "Failed to retrieve flags (%d).\n", ret);
> +	}

An if statement shouldn't have braces if it has only a single statement.

> +
> +	ctrl->info.flags = flags;

This is still setting an error value into ctrl->info.flags in the event of a fault.

Perhaps it should be initialised to something and set only if flags >= 0 ?

> +
>  	ctrl->initialized = 1;
> 
>  	uvc_trace(UVC_TRACE_CONTROL, "Added control %pUl/%u to device %s "

Regards

Kieran
