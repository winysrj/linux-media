Return-path: <linux-media-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:51565 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089AbZFEHHU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Jun 2009 03:07:20 -0400
Received: by wf-out-1314.google.com with SMTP id 26so601722wfd.4
        for <linux-media@vger.kernel.org>; Fri, 05 Jun 2009 00:07:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <63455.62.70.2.252.1244114783.squirrel@webmail.xs4all.nl>
References: <63455.62.70.2.252.1244114783.squirrel@webmail.xs4all.nl>
Date: Fri, 5 Jun 2009 16:07:22 +0900
Message-ID: <5e9665e10906050007m19cf4524u18031512c1d74ee@mail.gmail.com>
Subject: Re: What alternative way could be possible for initializing sensor
	rigistors?
From: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Dongsoo Kim <dongsoo45.kim@samsung.com>,
	=?ISO-8859-1?B?sejH/MHY?= <riverful.kim@samsung.com>,
	=?ISO-8859-1?B?uc66tMij?= <bhmin@samsung.com>,
	=?ISO-8859-1?B?udqw5rnO?= <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 4, 2009 at 8:26 PM, Hans Verkuil<hverkuil@xs4all.nl> wrote:
>
>> Hello everyone,
>>
>> In subdev framework, we already have "init" API  but not recommended
>> for new drivers to use this. But I'm so frustrated for the absence of
>> that kind of API.
>
> What I want to do is that you can pass such data through the board_info.
> Patch for that have been posted but I still haven't had the chance to sit
> down and review them :-(

Hmm... I tried to find the patch you mentioned, but still not popping
up. Can you give me some hint?

>
> This method is the common method for existing i2c drivers and should (I
> think) be used for all new i2c drivers.
>
>> I'm working on camera driver which needs to programme registors
>> through I2C bus and just stuck figuring out how to make it programmed
>> in device open (in this case, camera interface should be opened)
>> procedure.
>
> You're not trying to pass register/value pairs to the i2c driver, are you?
> You should tell the i2c driver what you want and let the i2c driver do the
> register programming for you. Only the i2c driver should know about the
> registers of the i2c device.

Actually I'm trying to do a very ordinary I2C programming job through
i2c_transfer() like any of sensor device. There are so many registers
to be programmed..like hundreds? I suppose..One single register is
consisted of 2bytes for address and 2bytes for values or multiple
bytes for some cases.

>
>> So, if I have no chance to use "init" API with implementing
>> my driver, which API should be used? Actually without "init" API, I
>> should make my driver to programme initializing registors in s_fmt or
>> s_parm sort of APIs.
>
> Use init as long as the new functions passing the board_info to the i2c
> core are not yet available. You can convert once we have the new API in
> place.
>

OK, I'll try to use if I can't find the patch using board_info you
have mentioned.

>> Any other alternative API is served in subdev framework? Please let me
>> know if there is something I missed.
>
> It's work in progress and I'm the bottleneck here :-(
>

I really wanna give you a hand! If I could..
Cheers,

Nate

>> BTW, subdev framework is really
>> cool. Totally arranged and easy to use.
>
> Thanks!
>
> Regards,
>
>         Hans
>
>> Cheers,
>>
>> Nate
>>
>>
>> --
>> =
>> DongSoo, Nathaniel Kim
>> Engineer
>> Mobile S/W Platform Lab.
>> Digital Media & Communications R&D Centre
>> Samsung Electronics CO., LTD.
>> e-mail : dongsoo.kim@gmail.com
>>           dongsoo45.kim@samsung.com
>>
>
>
> --
> Hans Verkuil - video4linux developer - sponsored by TANDBERG
>
>



-- 
=
DongSoo, Nathaniel Kim
Engineer
Mobile S/W Platform Lab.
Digital Media & Communications R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com
          dongsoo45.kim@samsung.com
