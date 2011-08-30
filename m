Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36647 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754141Ab1H3UPx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Aug 2011 16:15:53 -0400
Received: by fxh19 with SMTP id 19so43686fxh.19
        for <linux-media@vger.kernel.org>; Tue, 30 Aug 2011 13:15:52 -0700 (PDT)
Message-ID: <4E5D44F6.5020805@googlemail.com>
Date: Tue, 30 Aug 2011 22:15:50 +0200
From: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] gspca_sn9c20x: device 0c45:62b3: fix status LED
References: <1309515598-14669-1-git-send-email-fschaefer.oss@googlemail.com> <4E52C9CE.3040900@googlemail.com> <4E58DB23.4070807@redhat.com>
In-Reply-To: <4E58DB23.4070807@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 27.08.2011 13:55, schrieb Hans de Goede:
> Hi,
>
> On 08/22/2011 11:27 PM, Frank Sch�fer wrote:
>> Ping ... what happened to this patch ? ;-)
>
> I think it has fallen through the cracks. I've added it
> to my tree for 3.1 / 3.2 (more likely will be 3.2)
>
> Regards,
>
> Hans
>
Thank you Hans. I will check if it has reached mainline in a few weeks. ;)

Regards,
Frank

>
>
>>
>> Am 01.07.2011 12:19, schrieb Frank Schaefer:
>>> gspca_sn9c20x: device 0c45:62b3: fix status LED
>>>
>>> Tested with webcam "SilverCrest WC2130".
>>>
>>> Signed-off-by: Frank Schaefer<fschaefer.oss@googlemail.com>
>>>
>>> Cc: stable@kernel.org
>>> ---
>>> drivers/media/video/gspca/sn9c20x.c | 2 +-
>>> 1 files changed, 1 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/drivers/media/video/gspca/sn9c20x.c 
>>> b/drivers/media/video/gspca/sn9c20x.c
>>> index c431900..af9cd50 100644
>>> --- a/drivers/media/video/gspca/sn9c20x.c
>>> +++ b/drivers/media/video/gspca/sn9c20x.c
>>> @@ -2513,7 +2513,7 @@ static const struct usb_device_id 
>>> device_table[] = {
>>> {USB_DEVICE(0x0c45, 0x628f), SN9C20X(OV9650, 0x30, 0)},
>>> {USB_DEVICE(0x0c45, 0x62a0), SN9C20X(OV7670, 0x21, 0)},
>>> {USB_DEVICE(0x0c45, 0x62b0), SN9C20X(MT9VPRB, 0x00, 0)},
>>> - {USB_DEVICE(0x0c45, 0x62b3), SN9C20X(OV9655, 0x30, 0)},
>>> + {USB_DEVICE(0x0c45, 0x62b3), SN9C20X(OV9655, 0x30, LED_REVERSE)},
>>> {USB_DEVICE(0x0c45, 0x62bb), SN9C20X(OV7660, 0x21, LED_REVERSE)},
>>> {USB_DEVICE(0x0c45, 0x62bc), SN9C20X(HV7131R, 0x11, 0)},
>>> {USB_DEVICE(0x045e, 0x00f4), SN9C20X(OV9650, 0x30, 0)},
>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe 
>> linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html

