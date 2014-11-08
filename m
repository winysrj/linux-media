Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f47.google.com ([209.85.192.47]:40603 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbaKHWNA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Nov 2014 17:13:00 -0500
Received: by mail-qg0-f47.google.com with SMTP id j107so3988219qga.34
        for <linux-media@vger.kernel.org>; Sat, 08 Nov 2014 14:12:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAL+AA1nUAgOYUeWxrgeHiWaDSkHvh0yXuwA-gjdUomn-s_HVyA@mail.gmail.com>
References: <CAL+AA1ntfVxkaHhY8qNciBkHRw0SXOAzBJgV+A9Y7oYtbD38mQ@mail.gmail.com>
	<CALF0-+VpPttePKF-VTLJ5Y29_EZtSz96PwN9av1SOkkc414CRA@mail.gmail.com>
	<CAL+AA1nUAgOYUeWxrgeHiWaDSkHvh0yXuwA-gjdUomn-s_HVyA@mail.gmail.com>
Date: Sat, 8 Nov 2014 19:12:59 -0300
Message-ID: <CALF0-+WuVtk3SpwCNfJB88jvgXEujVPmT9ute6Ohdhi=0VsOSw@mail.gmail.com>
Subject: Re: STK1160 Sharpness
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: =?UTF-8?B?0JHQsNGA0YIg0JPQvtC/0L3QuNC6?= <bart.gopnik@gmail.com>
Cc: Mike Thomas <rmthomas@sciolus.org>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Барт,

If at all possible, remember to avoid top-posting, because it makes
the discussion harder to follow.

On Sat, Nov 8, 2014 at 1:42 PM, Барт Гопник <bart.gopnik@gmail.com> wrote:
> Looks like the problem is not in the v4l. The sharpness controlled for
> my webcam is perfectly, but I can't conrol sharpness for my EasyCap
> STK1160 device and I think the problem is in STK1160 driver. I
> carefully looked through all the source codes of the driver and found
> no references of sharpness. I can control brightness, saturation,
> etc., but I can't control sharpness. Why do you advise me asking this
> question on the video4linux mailing list? Do you think they can help?
>

Sure, they can help. I've just Cced the list.

The video4linux mailing list is the place to ask this question,
because it supports *all* the media drivers (not only v4l core). Any driver
in drivers/media, including saa7115 and stk1160 drivers, are supported there.

On the other side, this has nothing to do with the stk1160 driver,
which is only in
charge of the STK1160 chip (the USB chipset). You are looking at the
video decoder's
datasheet, so this must be implemented in the driver.

Regarding your question, subaddress 09h seems to be used in the saa7115 driver
(grep 09_LUMA) but I'm not sure how it works.

Hope it helps!

> 2014-11-07 19:33 GMT+03:00 Ezequiel Garcia <elezegarcia@gmail.com>:
>> How about asking this upstream on the video4linux mailing list?
>>
>> On Fri, Nov 7, 2014 at 5:42 AM, Барт Гопник <bart.gopnik@gmail.com> wrote:
>>> Hi!
>>>
>>> I have 05e1:0408 USB ID STK1160 chip GM7113 (SAA7113 clone) video
>>> processor device.
>>>
>>> Is there way to control for sharpness improvement via STK1160 driver?
>>> SAA7113 Data Sheet says that control for sharpness via I2C-bus
>>> subaddress 09H. Brightness, saturation, contrast, hue, etc. work
>>> perfectly. Is it implemented control for sharpness in the diver? Or at
>>> least, is it possible to implement it?
>>>
>>> Thanks in advance!
>>
>>
>>
>> --
>>     Ezequiel



-- 
    Ezequiel
