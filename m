Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f192.google.com ([209.85.221.192]:41028 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690AbZGOAnl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jul 2009 20:43:41 -0400
Received: by qyk30 with SMTP id 30so1729299qyk.33
        for <linux-media@vger.kernel.org>; Tue, 14 Jul 2009 17:43:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200907112113.42883.hverkuil@xs4all.nl>
References: <5e9665e10907110402t4b5777abu5f02a44d609405b1@mail.gmail.com>
	<200907112113.42883.hverkuil@xs4all.nl>
From: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
Date: Wed, 15 Jul 2009 09:43:20 +0900
Message-ID: <5e9665e10907141743k8d202bbga0b8858fd365af87@mail.gmail.com>
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

Hi,

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

Implementing my own driver, I came to conclusion like this.

1. For camera interface and external isp/sensor driver, we need
s_config but don't do initializing job with that but just fetch
platform data through this.
=> we also good with getting platform data and also no waste of doing
initializing job in boot time. If sensor/isp version detect is
necessray, configure proper setting parameters during s_config is
called and can possibly use those setting parameters until sensor/isp
device is removed. And then no need to make a new
v4l2_i2c_new_subdev_no_init() as well.

2. Keep init subdev ops and do not deprecate it.
=> In camera sensor driver we still need this.camera interface issues
init subdev ops on device opening time, and sensor device gets
initialized through this. At every single time we open the camera
device, we will need to re-initialize the sensor device as far as I
know. (because the sensor device will be completely turned off after
the device has been released)

Only those couple of conditions will be ok.
Cheers,

Nate

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



-- 
=
DongSoo, Nathaniel Kim
Engineer
Mobile S/W Platform Lab.
Digital Media & Communications R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com
          dongsoo45.kim@samsung.com
