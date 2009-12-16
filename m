Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f221.google.com ([209.85.220.221]:38112 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759929AbZLOXeS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Dec 2009 18:34:18 -0500
Received: by fxm21 with SMTP id 21so437647fxm.21
        for <linux-media@vger.kernel.org>; Tue, 15 Dec 2009 15:34:16 -0800 (PST)
Message-ID: <4B282B04.20708@royalhat.org>
Date: Wed, 16 Dec 2009 00:34:12 +0000
From: Luis Maia <lmaia@royalhat.org>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: leandro Costantino <lcostantino@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: PATCH- gspca: added chipset revision sensor
References: <4B27063C.6020200@royalhat.org>	<20091215085445.093ebfd8@tele>	<c2fe070d0912150525m623dbc48hff9e3ac5c1227db0@mail.gmail.com> <20091215174706.5d5cbd5b@tele>
In-Reply-To: <20091215174706.5d5cbd5b@tele>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I found an email that discussed the similar problem that my camera had, 
showing up just a black screen, it's dated but  i think maybe it wasn't 
fully solved because there's no answer.

http://osdir.com/ml/drivers.spca50x.devel/2006-11/msg00036.html

Note the : ">/ > /Vimicro/zc3xx.h: [zcxx_probeSensor:307] sensor 3w Vga 
??? 0xC400"

/Do you know if this was solved?!
Because i suspect that maybe there are more 0x?400 revision of the chipset.
Btw, if this is a pattern could we consider to mask the bits in retword 
(retword &= 0x0FFF)?
Because looking at the current table it seems to make more sense.

Best regards,
Luis Maia.
Jean-Francois Moine wrote:
> On Tue, 15 Dec 2009 10:25:29 -0300
> leandro Costantino <lcostantino@gmail.com> wrote:
>
>   
>> Jean,
>> let me know , if you need to the test this patch, since i added the
>> tas1530k long time ago, and still have the webcam :)
>> Best Regards
>>
>> On Tue, Dec 15, 2009 at 4:54 AM, Jean-Francois Moine
>> <moinejf@free.fr> wrote:
>>     
>>> On Tue, 15 Dec 2009 03:45:00 +0000
>>> Luis Maia <lmaia@royalhat.org> wrote:
>>>
>>>       
>>>> Added extra chipset revision (sensor) to fix camera zc0301 with
>>>>  ID: 0ac8:301b .
>>>> Since i own one of this cameras fixed and tested it.
>>>>         
>>>> -------------
>>>>
>>>> diff -uNr linux-2.6.32.1/drivers/media/video/gspca/zc3xx.c
>>>> linux-2.6.32.1-patch/drivers/media/video/gspca/zc3xx.c
>>>> --- linux-2.6.32.1/drivers/media/video/gspca/zc3xx.c    2009-12-14
>>>> 17:47:25.000000000 +0000
>>>> +++ linux-2.6.32.1-patch/drivers/media/video/gspca/zc3xx.c
>>>> 2009-12-15 02:42:13.000000000 +0000
>>>> @@ -6868,6 +6868,7 @@
>>>>      {0x8001, 0x13},
>>>>      {0x8000, 0x14},        /* CS2102K */
>>>>      {0x8400, 0x15},        /* TAS5130K */
>>>> +    {0xe400, 0x15},
>>>>  };
>>>>
>>>>  static int vga_3wr_probe(struct gspca_dev *gspca_dev)
>>>> @@ -7634,7 +7635,7 @@
>>>>      {USB_DEVICE(0x0698, 0x2003)},
>>>>      {USB_DEVICE(0x0ac8, 0x0301), .driver_info = SENSOR_PAS106},
>>>>      {USB_DEVICE(0x0ac8, 0x0302), .driver_info = SENSOR_PAS106},
>>>> -    {USB_DEVICE(0x0ac8, 0x301b)},
>>>> +    {USB_DEVICE(0x0ac8, 0x301b), .driver_info = SENSOR_PB0330},
>>>>      {USB_DEVICE(0x0ac8, 0x303b)},
>>>>      {USB_DEVICE(0x0ac8, 0x305b), .driver_info =
>>>> SENSOR_TAS5130C_VF0250}, {USB_DEVICE(0x0ac8, 0x307b)},
>>>>         
>
> Hello Luis and Leandro,
>
> Thanks for the patch. Luis said his sensor is the tas5130K, so the 2nd
> part of the patch is useless. But, maybe, Leandro, have you heard about
> other chipset revision IDs?
>
> Best regards.
>
>   

