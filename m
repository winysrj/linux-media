Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1774 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbZGKTNx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jul 2009 15:13:53 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
Subject: Re: About v4l2 subdev s_config (for core) API?
Date: Sat, 11 Jul 2009 21:13:42 +0200
Cc: v4l2_linux <linux-media@vger.kernel.org>,
	=?utf-8?q?=EA=B9=80=ED=98=95=EC=A4=80?= <riverful.kim@samsung.com>,
	Dongsoo Kim <dongsoo45.kim@samsung.com>,
	=?utf-8?q?=EB=B0=95=EA=B2=BD=EB=AF=BC?= <kyungmin.park@samsung.com>
References: <5e9665e10907110402t4b5777abu5f02a44d609405b1@mail.gmail.com>
In-Reply-To: <5e9665e10907110402t4b5777abu5f02a44d609405b1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907112113.42883.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 11 July 2009 13:02:33 Dongsoo, Nathaniel Kim wrote:
> Hi,
>
> The thing is - Is it possible to make the subdev device not to be
> turned on in registering process using any of v4l2_i2c_new_subdev*** ?
> You can say that I can ignore the i2c errors in booting process, but I
> think it is not a pretty way.
>
> And for the reason I'm asking you about this, I need you to consider
> following conditions I carry.
>
> 1. ARM embedded platform especially mobile handset.
> 2. Mass production which is very concerned about power consumption.
> 3. Strict and automated test process in product line.
>
> So, what I want to ask you is about s_config subdev call which is
> called from every single I2C subdev load in some kind of probe
> procedure. As s_config is supposed to do, it tries to initialize
> subdev device. which means it needs to turn on the subdev to make that
> initialized.

Actually, all s_config does is to pass the irq and platform_data arguments 
to the subdev driver. The subdev driver can just store that information 
somewhere and only use it when needed. It does not necessarily have to turn 
on the sub-device.

Whether to just store this info or turn on the sub-device is something that 
each subdev driver writer has to decide.

Note that this really has nothing to do with the existance of s_config: 
s_config was only introduced in order to support legacy v4l2 drivers and 
subdev drivers. In the (far?) future this will probably disappear and this 
information will always be passed via struct i2c_board_info.

> But as I mentioned above if we make the product go through the product
> line, it turns on the subdev device even though nobody intended to
> turn the subdev on. It might be an issue in product vendor's point of
> view, because there should be a crystal clear reason for the
> consumption of power the subdev made. I'm working on camera device and
> speaking of which, camera devices are really power consuming device
> and some camera devices even take ages to be initialized as well.
>
> So far I hope I made a good explanation about why I'm asking you about
> following question.
> By the way, it seems to be similar to the issue I've faced whe using
> old i2c driver model..I mean probing i2c devices on boot up sequence.

That at least should no longer be a problem anymore (as long as you don't 
use the address-probing variants).

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
