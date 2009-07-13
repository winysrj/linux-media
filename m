Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f192.google.com ([209.85.221.192]:37789 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbZGMIUS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jul 2009 04:20:18 -0400
Received: by qyk30 with SMTP id 30so551244qyk.33
        for <linux-media@vger.kernel.org>; Mon, 13 Jul 2009 01:20:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200907112113.42883.hverkuil@xs4all.nl>
References: <5e9665e10907110402t4b5777abu5f02a44d609405b1@mail.gmail.com>
	<200907112113.42883.hverkuil@xs4all.nl>
From: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
Date: Mon, 13 Jul 2009 17:19:57 +0900
Message-ID: <5e9665e10907130119wd9d62ahaa027e49993cdc8c@mail.gmail.com>
Subject: Re: About v4l2 subdev s_config (for core) API?
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: v4l2_linux <linux-media@vger.kernel.org>,
	=?UTF-8?B?6rmA7ZiV7KSA?= <riverful.kim@samsung.com>,
	Dongsoo Kim <dongsoo45.kim@samsung.com>,
	=?UTF-8?B?67CV6rK966+8?= <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/7/12 Hans Verkuil <hverkuil@xs4all.nl>:
> On Saturday 11 July 2009 13:02:33 Dongsoo, Nathaniel Kim wrote:
>> Hi,
>>
>> The thing is - Is it possible to make the subdev device not to be
>> turned on in registering process using any of v4l2_i2c_new_subdev*** ?
>> You can say that I can ignore the i2c errors in booting process, but I
>> think it is not a pretty way.
>>
>> And for the reason I'm asking you about this, I need you to consider
>> following conditions I carry.
>>
>> 1. ARM embedded platform especially mobile handset.
>> 2. Mass production which is very concerned about power consumption.
>> 3. Strict and automated test process in product line.
>>
>> So, what I want to ask you is about s_config subdev call which is
>> called from every single I2C subdev load in some kind of probe
>> procedure. As s_config is supposed to do, it tries to initialize
>> subdev device. which means it needs to turn on the subdev to make that
>> initialized.
>
> Actually, all s_config does is to pass the irq and platform_data arguments
> to the subdev driver. The subdev driver can just store that information
> somewhere and only use it when needed. It does not necessarily have to turn
> on the sub-device.
>
> Whether to just store this info or turn on the sub-device is something that
> each subdev driver writer has to decide.
>
> Note that this really has nothing to do with the existance of s_config:
> s_config was only introduced in order to support legacy v4l2 drivers and
> subdev drivers. In the (far?) future this will probably disappear and this
> information will always be passed via struct i2c_board_info.
>
>> But as I mentioned above if we make the product go through the product
>> line, it turns on the subdev device even though nobody intended to
>> turn the subdev on. It might be an issue in product vendor's point of
>> view, because there should be a crystal clear reason for the
>> consumption of power the subdev made. I'm working on camera device and
>> speaking of which, camera devices are really power consuming device
>> and some camera devices even take ages to be initialized as well.
>>
>> So far I hope I made a good explanation about why I'm asking you about
>> following question.
>> By the way, it seems to be similar to the issue I've faced whe using
>> old i2c driver model..I mean probing i2c devices on boot up sequence.
>
> That at least should no longer be a problem anymore (as long as you don't
> use the address-probing variants).
>
> Regards,
>
>        Hans
>
> --
> Hans Verkuil - video4linux developer - sponsored by TANDBERG
>

Hello Hans,


Actually I picked up s_config to make external camera module (subdev)
do initialization when we open camera device, but s_config seems to be
made for other purpose.
As you noted in comment for the "init" API, you recommended not to use
"init" subdev API and neither do I want to use any API to be removed.
So, I'm figuring out how to make camera device to be initialized under
subdev framework.
So, I re-checked the whole subdev API list we have in v4l2-subdev and
found s_crystal_freq.

Here is a question:
Is s_crystal_freq for let the subdev know about the given clock like
MCLK(master clock) for external camera device?

The thing is, if you are intending to get rid of the "init" subdev API
in the future and on the other hand some device like camera still
needs a direct way to be initialized, I think we can use one of API
which can be used during initializing process. I figured out that if
s_crystal_freq is for subdev to be noticed about the given clock
frequency to itself, it might be used for initialization programming
also.

Let's assume that I'm turning on the camera which is working with 24MHz MCLK.

1. power on
2. give 24MHz MCLK from host to camera and let camera know about the
frequency given through s_crystal_freq (even though the camera device
supports for only one frequency value)
3. reset device
4. preview on

If I'm getting wrong about s_crystal_freq, I think we need to keep
"init" for camera devices.
Cheers,

Nate



-- 
=
DongSoo, Nathaniel Kim
Engineer
Mobile S/W Platform Lab.
Digital Media & Communications R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com
          dongsoo45.kim@samsung.com
