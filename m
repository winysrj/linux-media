Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:57653 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab3AXGrX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Jan 2013 01:47:23 -0500
Received: by mail-vc0-f174.google.com with SMTP id n11so6445263vch.33
        for <linux-media@vger.kernel.org>; Wed, 23 Jan 2013 22:47:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50F81933.40809@iki.fi>
References: <CAKdnbx7Qx7z1BVxaXsDAe8mDG9jhPQeAkPbZGof++B1xK31Wsw@mail.gmail.com>
 <50F81933.40809@iki.fi>
From: Eddi De Pieri <eddi@depieri.net>
Date: Thu, 24 Jan 2013 07:47:02 +0100
Message-ID: <CAKdnbx7Ja-aN6cWWoiFNXM4m4sSXnK7MQUOtdDO8D2r2ouMurw@mail.gmail.com>
Subject: Re: [PATCH] Support Digivox Mini HD (rtl2832)
To: Antti Palosaari <crope@iki.fi>, mchehab@redhat.com
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Any chance this patch will be committed?

On Thu, Jan 17, 2013 at 4:30 PM, Antti Palosaari <crope@iki.fi> wrote:
> On 01/15/2013 12:21 AM, Eddi De Pieri wrote:
>>
>> Add support for Digivox Mini HD (rtl2832)
>>
>> The tuner works, but with worst performance then realtek linux driver,
>> due to incomplete implementation of fc2580.c
>>
>> Signed-off-by: Eddi De Pieri <eddi@depieri.net>
>> Tested-by: Lorenzo Dongarrą <lorenzo_64@katamail.com>
>>
>>
>> diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
>> b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
>> index b6f4849..c05ea16 100644
>> --- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
>> +++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
>> @@ -1368,6 +1368,8 @@ static const struct usb_device_id
>> rtl28xxu_id_table[] = {
>>                  &rtl2832u_props, "ASUS My Cinema-U3100Mini Plus V2",
>> NULL) },
>>          { DVB_USB_DEVICE(USB_VID_KWORLD_2, 0xd393,
>>                  &rtl2832u_props, "GIGABYTE U7300", NULL) },
>> +       { DVB_USB_DEVICE(USB_VID_DEXATEK, 0x1104,
>> +               &rtl2832u_props, "Digivox Micro Hd", NULL) },
>>          { }
>>   };
>>   MODULE_DEVICE_TABLE(usb, rtl28xxu_id_table);
>
>
> Acked-by: Antti Palosaari <crope@iki.fi>
> Reviewed-by: Antti Palosaari <crope@iki.fi>
>
>
> --
> http://palosaari.fi/
