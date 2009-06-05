Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2778 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502AbZFEHwQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Jun 2009 03:52:16 -0400
Message-ID: <21435.62.70.2.252.1244188332.squirrel@webmail.xs4all.nl>
Date: Fri, 5 Jun 2009 09:52:12 +0200 (CEST)
Subject: Re: What alternative way could be possible for initializing sensor
      rigistors?
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
Cc: linux-media@vger.kernel.org,
	"Dongsoo Kim" <dongsoo45.kim@samsung.com>,
	=?iso-8859-1?Q?=B1=E8=C7=FC=C1=D8?= <riverful.kim@samsung.com>,
	=?iso-8859-1?Q?=B9=CE=BA=B4=C8=A3?= <bhmin@samsung.com>,
	=?iso-8859-1?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> On Thu, Jun 4, 2009 at 8:26 PM, Hans Verkuil<hverkuil@xs4all.nl> wrote:
>>
>>> Hello everyone,
>>>
>>> In subdev framework, we already have "init" API  but not recommended
>>> for new drivers to use this. But I'm so frustrated for the absence of
>>> that kind of API.
>>
>> What I want to do is that you can pass such data through the board_info.
>> Patch for that have been posted but I still haven't had the chance to
>> sit
>> down and review them :-(
>
> Hmm... I tried to find the patch you mentioned, but still not popping
> up. Can you give me some hint?

It's this one:

http://patchwork.kernel.org/patch/25385/

At least, I believe that's the latest version of it.

>>
>> This method is the common method for existing i2c drivers and should (I
>> think) be used for all new i2c drivers.
>>
>>> I'm working on camera driver which needs to programme registors
>>> through I2C bus and just stuck figuring out how to make it programmed
>>> in device open (in this case, camera interface should be opened)
>>> procedure.
>>
>> You're not trying to pass register/value pairs to the i2c driver, are
>> you?
>> You should tell the i2c driver what you want and let the i2c driver do
>> the
>> register programming for you. Only the i2c driver should know about the
>> registers of the i2c device.
>
> Actually I'm trying to do a very ordinary I2C programming job through
> i2c_transfer() like any of sensor device. There are so many registers
> to be programmed..like hundreds? I suppose..One single register is
> consisted of 2bytes for address and 2bytes for values or multiple
> bytes for some cases.

Yes, but such programming should only be done from the i2c device driver.
You should never attempt to set registers in an i2c device from another
driver.

Regards,

       Hans

>>> So, if I have no chance to use "init" API with implementing
>>> my driver, which API should be used? Actually without "init" API, I
>>> should make my driver to programme initializing registors in s_fmt or
>>> s_parm sort of APIs.
>>
>> Use init as long as the new functions passing the board_info to the i2c
>> core are not yet available. You can convert once we have the new API in
>> place.
>>
>
> OK, I'll try to use if I can't find the patch using board_info you
> have mentioned.
>
>>> Any other alternative API is served in subdev framework? Please let me
>>> know if there is something I missed.
>>
>> It's work in progress and I'm the bottleneck here :-(
>>
>
> I really wanna give you a hand! If I could..
> Cheers,
>
> Nate
>
>>> BTW, subdev framework is really
>>> cool. Totally arranged and easy to use.
>>
>> Thanks!
>>
>> Regards,
>>
>>         Hans
>>
>>> Cheers,
>>>
>>> Nate
>>>
>>>
>>> --
>>> =
>>> DongSoo, Nathaniel Kim
>>> Engineer
>>> Mobile S/W Platform Lab.
>>> Digital Media & Communications R&D Centre
>>> Samsung Electronics CO., LTD.
>>> e-mail : dongsoo.kim@gmail.com
>>>           dongsoo45.kim@samsung.com
>>>
>>
>>
>> --
>> Hans Verkuil - video4linux developer - sponsored by TANDBERG
>>
>>
>
>
>
> --
> =
> DongSoo, Nathaniel Kim
> Engineer
> Mobile S/W Platform Lab.
> Digital Media & Communications R&D Centre
> Samsung Electronics CO., LTD.
> e-mail : dongsoo.kim@gmail.com
>           dongsoo45.kim@samsung.com
>
>


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

