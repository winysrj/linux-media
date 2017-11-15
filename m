Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36146 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752171AbdKOLxF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Nov 2017 06:53:05 -0500
Received: by mail-wm0-f68.google.com with SMTP id r68so2446424wmr.1
        for <linux-media@vger.kernel.org>; Wed, 15 Nov 2017 03:53:04 -0800 (PST)
Subject: Re: [PATCH] uvcvideo: Apply flags from device to actual properties
To: Edgar Thier <info@edgarthier.net>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
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
 <430ebf60-395c-08ff-5500-dedcda91e3b1@ideasonboard.com>
 <7807bf0a-a0a1-65ad-1a10-3a3234e566e9@edgarthier.net>
 <9aa56510-cb42-a905-7402-9483067d2971@edgarthier.net>
From: Kieran Bingham <kieranbingham@gmail.com>
Message-ID: <828a7c41-1309-5b19-6ff4-6e787ab5cd7a@gmail.com>
Date: Wed, 15 Nov 2017 11:53:01 +0000
MIME-Version: 1.0
In-Reply-To: <9aa56510-cb42-a905-7402-9483067d2971@edgarthier.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Edgar,

On 15/11/17 08:11, Edgar Thier wrote:
> Hi,
> 
> I was wondering if there are any problems with my latest patch or if it simply slipped through.

Slipped though in high mail volumes :)

I think it's easier to see updated patches if they are posted as a new thread,
with an increased version number. [PATCH v2], [PATCH v3] etc...

Not a problem now - but might help your updated patches get seen next time.

Looks like my concerns were addressed, so that's a Reviewed-by: tag from me.

--
Kieran

> 
> Regards,
> 
> Edgar
> 
> On 10/12/2017 09:54 AM, Edgar Thier wrote:
>>
>> Use flags the device exposes for UVC controls.
>> This allows the device to define which property flags are set.
>>
>> Since some cameras offer auto-adjustments for properties (e.g. auto-gain),
>> the values of other properties (e.g. gain) can change in the camera.
>> Examining the flags ensures that the driver is aware of such properties.
>>
>> Signed-off-by: Edgar Thier <info@edgarthier.net>
>> ---
>>  drivers/media/usb/uvc/uvc_ctrl.c | 64 ++++++++++++++++++++++++++++++----------
>>  1 file changed, 49 insertions(+), 15 deletions(-)
>>
>> diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
>> index 20397aba..8f902a41 100644
>> --- a/drivers/media/usb/uvc/uvc_ctrl.c
>> +++ b/drivers/media/usb/uvc/uvc_ctrl.c
>> @@ -1629,6 +1629,40 @@ static void uvc_ctrl_fixup_xu_info(struct uvc_device *dev,
>>  	}
>>  }
>>
>> +/*
>> + * Retrieve flags for a given control
>> + */
>> +static int uvc_ctrl_get_flags(struct uvc_device *dev, const struct uvc_control *ctrl,
>> +	const struct uvc_control_info *info)
>> +{
>> +	u8 *data;
>> +	int ret = 0;
>> +	int flags = 0;
>> +
>> +	data = kmalloc(2, GFP_KERNEL);
>> +	if (data == NULL)
>> +		return -ENOMEM;
>> +
>> +	ret = uvc_query_ctrl(dev, UVC_GET_INFO, ctrl->entity->id, dev->intfnum,
>> +						 info->selector, data, 1);
>> +	if (ret < 0) {
>> +		uvc_trace(UVC_TRACE_CONTROL,
>> +				  "GET_INFO failed on control %pUl/%u (%d).\n",
>> +				  info->entity, info->selector, ret);
>> +	} else {
>> +		flags = UVC_CTRL_FLAG_GET_MIN | UVC_CTRL_FLAG_GET_MAX
>> +			| UVC_CTRL_FLAG_GET_RES | UVC_CTRL_FLAG_GET_DEF
>> +			| (data[0] & UVC_CONTROL_CAP_GET ?
>> +			   UVC_CTRL_FLAG_GET_CUR : 0)
>> +			| (data[0] & UVC_CONTROL_CAP_SET ?
>> +			   UVC_CTRL_FLAG_SET_CUR : 0)
>> +			| (data[0] & UVC_CONTROL_CAP_AUTOUPDATE ?
>> +			   UVC_CTRL_FLAG_AUTO_UPDATE : 0);
>> +	}
>> +	kfree(data);
>> +	return flags;
>> +}
>> +
>>  /*
>>   * Query control information (size and flags) for XU controls.
>>   */
>> @@ -1636,6 +1670,7 @@ static int uvc_ctrl_fill_xu_info(struct uvc_device *dev,
>>  	const struct uvc_control *ctrl, struct uvc_control_info *info)
>>  {
>>  	u8 *data;
>> +	int flags;
>>  	int ret;
>>
>>  	data = kmalloc(2, GFP_KERNEL);
>> @@ -1659,24 +1694,15 @@ static int uvc_ctrl_fill_xu_info(struct uvc_device *dev,
>>
>>  	info->size = le16_to_cpup((__le16 *)data);
>>
>> -	/* Query the control information (GET_INFO) */
>> -	ret = uvc_query_ctrl(dev, UVC_GET_INFO, ctrl->entity->id, dev->intfnum,
>> -			     info->selector, data, 1);
>> -	if (ret < 0) {
>> +	flags = uvc_ctrl_get_flags(dev, ctrl, info);
>> +
>> +	if (flags < 0) {
>>  		uvc_trace(UVC_TRACE_CONTROL,
>> -			  "GET_INFO failed on control %pUl/%u (%d).\n",
>> -			  info->entity, info->selector, ret);
>> +			  "Failed to retrieve flags (%d).\n", ret);
>> + 		ret = flags;
>>  		goto done;
>>  	}
>> -
>> -	info->flags = UVC_CTRL_FLAG_GET_MIN | UVC_CTRL_FLAG_GET_MAX
>> -		    | UVC_CTRL_FLAG_GET_RES | UVC_CTRL_FLAG_GET_DEF
>> -		    | (data[0] & UVC_CONTROL_CAP_GET ?
>> -		       UVC_CTRL_FLAG_GET_CUR : 0)
>> -		    | (data[0] & UVC_CONTROL_CAP_SET ?
>> -		       UVC_CTRL_FLAG_SET_CUR : 0)
>> -		    | (data[0] & UVC_CONTROL_CAP_AUTOUPDATE ?
>> -		       UVC_CTRL_FLAG_AUTO_UPDATE : 0);
>> +	info->flags = flags;
>>
>>  	uvc_ctrl_fixup_xu_info(dev, ctrl, info);
>>
>> @@ -1890,6 +1916,7 @@ static int uvc_ctrl_add_info(struct uvc_device *dev, struct uvc_control *ctrl,
>>  	const struct uvc_control_info *info)
>>  {
>>  	int ret = 0;
>> +	int flags = 0;
>>
>>  	ctrl->info = *info;
>>  	INIT_LIST_HEAD(&ctrl->info.mappings);
>> @@ -1902,6 +1929,13 @@ static int uvc_ctrl_add_info(struct uvc_device *dev, struct uvc_control *ctrl,
>>  		goto done;
>>  	}
>>
>> +	flags = uvc_ctrl_get_flags(dev, ctrl, info);
>> +	if (flags < 0)
>> +		uvc_trace(UVC_TRACE_CONTROL,
>> +			  "Failed to retrieve flags (%d).\n", ret);
>> +	else
>> +		ctrl->info.flags = flags;
>> +
>>  	ctrl->initialized = 1;
>>
>>  	uvc_trace(UVC_TRACE_CONTROL, "Added control %pUl/%u to device %s "
>>
