Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:44339 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750994AbeAYGrs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 25 Jan 2018 01:47:48 -0500
Received: by mail-wm0-f65.google.com with SMTP id t74so12667163wme.3
        for <linux-media@vger.kernel.org>; Wed, 24 Jan 2018 22:47:48 -0800 (PST)
Date: Thu, 25 Jan 2018 07:47:44 +0100 (CET)
From: Enrico Mioso <mrkiko.rs@gmail.com>
To: =?ISO-8859-15?Q?Honza_Petrou=A8?= <jpetrous@gmail.com>
cc: linux-media@vger.kernel.org, Sean Young <sean@mess.org>,
        Piotr Oleszczyk <piotr.oleszczyk@gmail.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: Re: [PATCH] dib700: stop flooding system ring buffer
In-Reply-To: <CAJbz7-0hBw_j8LXU5P=xTc2DQpNuU81S5BNub_TRkN2epQDhhA@mail.gmail.com>
Message-ID: <alpine.LNX.2.21.99.1801250746120.3761@mStation.localdomain>
References: <20180124074038.13275-1-mrkiko.rs@gmail.com> <CAJbz7-0hBw_j8LXU5P=xTc2DQpNuU81S5BNub_TRkN2epQDhhA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-1579914518-1516862866=:3761"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1579914518-1516862866=:3761
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

Hello Honza,

thank you very very much for your help and hints. These things make a community what it is, and I apreciate it extremely.
You're perfectly right, I didn't think about this well and/or enough.
Apreciated your hints.....


On Wed, 24 Jan 2018, Honza Petrouš wrote:

> Date: Wed, 24 Jan 2018 14:07:52
> From: Honza Petrouš <jpetrous@gmail.com>
> To: Enrico Mioso <mrkiko.rs@gmail.com>
> Cc: linux-media@vger.kernel.org, Sean Young <sean@mess.org>,
>     Piotr Oleszczyk <piotr.oleszczyk@gmail.com>,
>     Andrey Konovalov <andreyknvl@google.com>,
>     Andrew Morton <akpm@linux-foundation.org>,
>     Alexey Dobriyan <adobriyan@gmail.com>,
>     Mauro Carvalho Chehab <mchehab@kernel.org>
> Subject: Re: [PATCH] dib700: stop flooding system ring buffer
> 
> Hi Enrico,
>
> I'm not maintener, so treat next hints as hints only :)
>
> 2018-01-24 8:40 GMT+01:00 Enrico Mioso <mrkiko.rs@gmail.com>:
>> Stop flooding system ring buffer with messages like:
>> dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0
>> while tuning an Asus My Cinema-U3000Hybrid dvb card.
>>
>> The correctness of this patch is opinable, but it's annoying me so much I
>> sent it anyway.
>>
>> CC: linux-media@vger.kernel.org
>> CC: Sean Young <sean@mess.org>
>> CC: Piotr Oleszczyk <piotr.oleszczyk@gmail.com>
>> CC: Andrey Konovalov <andreyknvl@google.com>
>> CC: Andrew Morton <akpm@linux-foundation.org>
>> CC: Alexey Dobriyan <adobriyan@gmail.com>
>> CC: Mauro Carvalho Chehab <mchehab@kernel.org>
>> Signed-off-by: Enrico Mioso <mrkiko.rs@gmail.com>
>> ---
>>  drivers/media/usb/dvb-usb/dib0700_devices.c | 3 +--
>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/drivers/media/usb/dvb-usb/dib0700_devices.c b/drivers/media/usb/dvb-usb/dib0700_devices.c
>> index 366b05529915..bc5d250ed2f2 100644
>> --- a/drivers/media/usb/dvb-usb/dib0700_devices.c
>> +++ b/drivers/media/usb/dvb-usb/dib0700_devices.c
>> @@ -432,8 +432,7 @@ static int stk7700ph_xc3028_callback(void *ptr, int component,
>>         case XC2028_RESET_CLK:
>>                 break;
>>         default:
>> -               err("%s: unknown command %d, arg %d\n", __func__,
>> -                       command, arg);
>
> May be change err() to debug() or something similar would be better?
>
>> +               break;
>>                 return -EINVAL;
>
> Anyway it looks strange to break before return.
>
> In both cases (w/ or w/o removal of message) I would stay
> with -EINVAL for unknown command here.
>
>>         }
>>         return 0;
>> --
>> 2.16.1
>>
>
> /Honza
>
--8323329-1579914518-1516862866=:3761--
