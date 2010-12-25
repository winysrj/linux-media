Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:8133 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775Ab0LYJaZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Dec 2010 04:30:25 -0500
Message-ID: <4D15BB14.3010601@redhat.com>
Date: Sat, 25 Dec 2010 10:36:20 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Theodore Kilgore <kilgota@banach.math.auburn.edu>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Adds the Lego Bionicle to existing sq905c
References: <4D11E170.6050500@redhat.com> <4D14ABEE.40206@redhat.com> <alpine.LNX.2.00.1012241358210.29054@banach.math.auburn.edu> <4D14FAB2.2090907@redhat.com> <4D15B75C.80405@redhat.com>
In-Reply-To: <4D15B75C.80405@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi,

On 12/25/2010 10:20 AM, Mauro Carvalho Chehab wrote:
> Em 24-12-2010 17:55, Hans de Goede escreveu:
>> Mauro,
>>
>> Will you pick up this patch directly or should I put it in my tree ?
>
> Either way works for me (but I prefer if one of the gspca maintainers/sub-mainainers
> pick). If you don't pick it, please reply with your ack.

Given that nothing else is going into my tree at the moment I would
prefer for you to pick it up directly, so:

Acked-by: Hans de Goede <hdegoede@redhat.com>

Thanks & Regards,

Hans


>>
>> Regards,
>>
>> Hans
>>
>>
>> On 12/24/2010 09:06 PM, Theodore Kilgore wrote:
>>> This patch adds the Vendor:Product number of the Lego Bionicle camera to
>>> the existing gspca/sq905c.c and also a line for the camera in gspca.txt.
>>> The camera works "out of the box" with these small changes. So this is
>>> just in time for Christmas. Think of the children.
>>>
>>> Signed-off-by: Theodore Kilgore<kilgota@auburn.edu>
>>>
>>> ---------------------------------------------
>>> diff --git a/Documentation/video4linux/gspca.txt b/Documentation/video4linux/gspca.txt
>>> index 6a562ee..261776e 100644
>>> --- a/Documentation/video4linux/gspca.txt
>>> +++ b/Documentation/video4linux/gspca.txt
>>> @@ -366,6 +366,7 @@ t613        17a1:0128    TASCORP JPEG Webcam, NGS Cyclops
>>>    vc032x        17ef:4802    Lenovo Vc0323+MI1310_SOC
>>>    pac207        2001:f115    D-Link DSB-C120
>>>    sq905c        2770:9050    Disney pix micro (CIF)
>>> +sq905c        2770:9051    Lego Bionicle
>>>    sq905c        2770:9052    Disney pix micro 2 (VGA)
>>>    sq905c        2770:905c    All 11 known cameras with this ID
>>>    sq905        2770:9120    All 24 known cameras with this ID
>>> diff --git a/drivers/media/video/gspca/sq905c.c b/drivers/media/video/gspca/sq905c.c
>>> index c2e88b5..8ba1995 100644
>>> --- a/drivers/media/video/gspca/sq905c.c
>>> +++ b/drivers/media/video/gspca/sq905c.c
>>> @@ -301,6 +301,7 @@ static int sd_start(struct gspca_dev *gspca_dev)
>>>    static const __devinitdata struct usb_device_id device_table[] = {
>>>        {USB_DEVICE(0x2770, 0x905c)},
>>>        {USB_DEVICE(0x2770, 0x9050)},
>>> +    {USB_DEVICE(0x2770, 0x9051)},
>>>        {USB_DEVICE(0x2770, 0x9052)},
>>>        {USB_DEVICE(0x2770, 0x913d)},
>>>        {}
>>>
>
