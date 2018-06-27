Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:45148 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750942AbeF0Flw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Jun 2018 01:41:52 -0400
Subject: Re: [PATCH] media: video-i2c: add hwmon support for amg88xx
To: Matt Ranostay <matt.ranostay@konsulko.com>
Cc: linux-media@vger.kernel.org, linux-hwmon@vger.kernel.org
References: <20180626063025.7778-1-matt.ranostay@konsulko.com>
 <50948d52-3dcd-79b6-52e8-cf6651393449@roeck-us.net>
 <CAJCx=g=ownrgsmx6UXrTEn98JhV6_1arnj4xP2Ly_OszEeCkUA@mail.gmail.com>
From: Guenter Roeck <linux@roeck-us.net>
Message-ID: <e59eb352-4d3a-868f-503d-018ba4dc1362@roeck-us.net>
Date: Tue, 26 Jun 2018 22:41:49 -0700
MIME-Version: 1.0
In-Reply-To: <CAJCx=g=ownrgsmx6UXrTEn98JhV6_1arnj4xP2Ly_OszEeCkUA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/26/2018 08:20 PM, Matt Ranostay wrote:
> On Tue, Jun 26, 2018 at 6:47 AM, Guenter Roeck <linux@roeck-us.net> wrote:
>> On 06/25/2018 11:30 PM, Matt Ranostay wrote:
>>>
>>> AMG88xx has an on-board thermistor which is used for more accurate
>>> processing of its temperature readings from the 8x8 thermopile array
>>>
>>> Cc: linux-hwmon@vger.kernel.org
>>> Signed-off-by: Matt Ranostay <matt.ranostay@konsulko.com>
>>> ---
>>>    drivers/media/i2c/video-i2c.c | 73 +++++++++++++++++++++++++++++++++++
>>>    1 file changed, 73 insertions(+)
>>>
...
> 
>>
>>> +               tmp = -(tmp & 0x7ff);
>>
>>
>> 0x800 => 0x0 -> -0x0 -> 0x0
>>
>> seems wrong. Maybe consider using sign_extend32() instead ?
>>
> 
> Heh yes I knew someone was going to see this and scratch their head on this..
> 
> So the sign bit just says if the value is positive or negative, and
> the value isn't two's (or even one's) complement value.
> If it is negative you have to basically have to  invert the absolute
> value (tested this with a freezer to be sure it wasn't a datasheet
> mistake).
> 
> Datasheet: https://cdn-learn.adafruit.com/assets/assets/000/043/261/original/Grid-EYE_SPECIFICATIONS%28Reference%29.pdf
> 

Outch, that hurts. Please add a comment into the code explaining this.
Also, to be on the safe side, it might make sense to mask tmp with
0x0fff - the upper bits seem to be undefined.

Thanks,
Guenter
