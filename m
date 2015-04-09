Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f171.google.com ([209.85.220.171]:33715 "EHLO
	mail-qk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545AbbDIKww (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Apr 2015 06:52:52 -0400
MIME-Version: 1.0
In-Reply-To: <2185959.thXfDS86Vr@avalon>
References: <1428065887-16017-1-git-send-email-tomeu.vizoso@collabora.com>
 <1428065887-16017-5-git-send-email-tomeu.vizoso@collabora.com> <2185959.thXfDS86Vr@avalon>
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Date: Thu, 9 Apr 2015 12:52:31 +0200
Message-ID: <CAAObsKCZQrfpv61PqN18Q4285za752LJYeJPm=xswVz52YBt6Q@mail.gmail.com>
Subject: Re: [PATCH v2 4/7] [media] uvcvideo: Enable runtime PM of descendant devices
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 4 April 2015 at 14:33, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Tomeu,
>
> Thank you for the patch.
>
> Could you please CC me on the whole series for v3 ?

Sure.

> On Friday 03 April 2015 14:57:53 Tomeu Vizoso wrote:
>> So UVC devices can remain runtime-suspended when the system goes into a
>> sleep state, they and all of their descendant devices need to have
>> runtime PM enable.
>>
>> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
>> ---
>>  drivers/media/usb/uvc/uvc_driver.c | 11 +++++++++++
>>  1 file changed, 11 insertions(+)
>>
>> diff --git a/drivers/media/usb/uvc/uvc_driver.c
>> b/drivers/media/usb/uvc/uvc_driver.c index cf27006..687e5fb 100644
>> --- a/drivers/media/usb/uvc/uvc_driver.c
>> +++ b/drivers/media/usb/uvc/uvc_driver.c
>> @@ -1855,6 +1855,15 @@ static int uvc_register_chains(struct uvc_device
>> *dev) return 0;
>>  }
>>
>> +static int uvc_pm_runtime_enable(struct device *dev, void *data)
>> +{
>> +     pm_runtime_enable(dev);
>> +
>> +     device_for_each_child(dev, NULL, uvc_pm_runtime_enable);
>
> How many recursion levels do we typically have with uvcvideo ?

it has video%d -> input%d -> event%d, when USB_VIDEO_CLASS_INPUT_EVDEV
is enabled.

>> +
>> +     return 0;
>> +}
>
> The function isn't UVC-specific, how about renaming it to
> pm_runtime_enable_recursive() (or something similar) and moving it to the
> runtime PM core ?

Yeah, that would be handy when doing the same to other drivers.

>> +
>>  /* ------------------------------------------------------------------------
>> * USB probe, disconnect, suspend and resume
>>   */
>> @@ -1959,6 +1968,8 @@ static int uvc_probe(struct usb_interface *intf,
>>                       "supported.\n", ret);
>>       }
>>
>> +     device_for_each_child(&dev->intf->dev, NULL, uvc_pm_runtime_enable);
>
> You could just call uvc_pm_runtime_enable(&dev->intf->dev, NULL) here.

I will go with the above for now.

Thanks,

Tomeu

>> +
>>       uvc_trace(UVC_TRACE_PROBE, "UVC device initialized.\n");
>>       usb_enable_autosuspend(udev);
>>       return 0;
>
> --
> Regards,
>
> Laurent Pinchart
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
