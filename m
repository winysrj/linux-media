Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:2497 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665AbZGMIsD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jul 2009 04:48:03 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
Subject: Re: About v4l2 subdev s_config (for core) API?
Date: Mon, 13 Jul 2009 10:47:50 +0200
Cc: v4l2_linux <linux-media@vger.kernel.org>,
	=?utf-8?q?=EA=B9=80=ED=98=95=EC=A4=80?= <riverful.kim@samsung.com>,
	Dongsoo Kim <dongsoo45.kim@samsung.com>,
	=?utf-8?q?=EB=B0=95=EA=B2=BD=EB=AF=BC?= <kyungmin.park@samsung.com>
References: <5e9665e10907110402t4b5777abu5f02a44d609405b1@mail.gmail.com> <200907112113.42883.hverkuil@xs4all.nl> <5e9665e10907130119wd9d62ahaa027e49993cdc8c@mail.gmail.com>
In-Reply-To: <5e9665e10907130119wd9d62ahaa027e49993cdc8c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200907131047.51249.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 13 July 2009 10:19:57 Dongsoo, Nathaniel Kim wrote:
> 2009/7/12 Hans Verkuil <hverkuil@xs4all.nl>:
> > On Saturday 11 July 2009 13:02:33 Dongsoo, Nathaniel Kim wrote:
> >> Hi,
> >>
> >> The thing is - Is it possible to make the subdev device not to be
> >> turned on in registering process using any of v4l2_i2c_new_subdev*** ?
> >> You can say that I can ignore the i2c errors in booting process, but I
> >> think it is not a pretty way.
> >>
> >> And for the reason I'm asking you about this, I need you to consider
> >> following conditions I carry.
> >>
> >> 1. ARM embedded platform especially mobile handset.
> >> 2. Mass production which is very concerned about power consumption.
> >> 3. Strict and automated test process in product line.
> >>
> >> So, what I want to ask you is about s_config subdev call which is
> >> called from every single I2C subdev load in some kind of probe
> >> procedure. As s_config is supposed to do, it tries to initialize
> >> subdev device. which means it needs to turn on the subdev to make that
> >> initialized.
> >
> > Actually, all s_config does is to pass the irq and platform_data
> > arguments to the subdev driver. The subdev driver can just store that
> > information somewhere and only use it when needed. It does not
> > necessarily have to turn on the sub-device.
> >
> > Whether to just store this info or turn on the sub-device is something
> > that each subdev driver writer has to decide.
> >
> > Note that this really has nothing to do with the existance of s_config:
> > s_config was only introduced in order to support legacy v4l2 drivers
> > and subdev drivers. In the (far?) future this will probably disappear
> > and this information will always be passed via struct i2c_board_info.
> >
> >> But as I mentioned above if we make the product go through the product
> >> line, it turns on the subdev device even though nobody intended to
> >> turn the subdev on. It might be an issue in product vendor's point of
> >> view, because there should be a crystal clear reason for the
> >> consumption of power the subdev made. I'm working on camera device and
> >> speaking of which, camera devices are really power consuming device
> >> and some camera devices even take ages to be initialized as well.
> >>
> >> So far I hope I made a good explanation about why I'm asking you about
> >> following question.
> >> By the way, it seems to be similar to the issue I've faced whe using
> >> old i2c driver model..I mean probing i2c devices on boot up sequence.
> >
> > That at least should no longer be a problem anymore (as long as you
> > don't use the address-probing variants).
> >
> > Regards,
> >
> >        Hans
> >
> > --
> > Hans Verkuil - video4linux developer - sponsored by TANDBERG
>
> Hello Hans,
>
>
> Actually I picked up s_config to make external camera module (subdev)
> do initialization when we open camera device, but s_config seems to be
> made for other purpose.
> As you noted in comment for the "init" API, you recommended not to use
> "init" subdev API and neither do I want to use any API to be removed.
> So, I'm figuring out how to make camera device to be initialized under
> subdev framework.
> So, I re-checked the whole subdev API list we have in v4l2-subdev and
> found s_crystal_freq.
>
> Here is a question:
> Is s_crystal_freq for let the subdev know about the given clock like
> MCLK(master clock) for external camera device?
>
> The thing is, if you are intending to get rid of the "init" subdev API
> in the future and on the other hand some device like camera still
> needs a direct way to be initialized, I think we can use one of API
> which can be used during initializing process. I figured out that if
> s_crystal_freq is for subdev to be noticed about the given clock
> frequency to itself, it might be used for initialization programming
> also.

That would be abusing that function, I don't think that's a good idea.

> Let's assume that I'm turning on the camera which is working with 24MHz
> MCLK.
>
> 1. power on
> 2. give 24MHz MCLK from host to camera and let camera know about the
> frequency given through s_crystal_freq (even though the camera device
> supports for only one frequency value)
> 3. reset device
> 4. preview on
>
> If I'm getting wrong about s_crystal_freq, I think we need to keep
> "init" for camera devices.

This is actually the first valid use-case I've seen for init.

I think that I need to do the following:

1) Remove the use of init() in all current i2c drivers. If I remember 
correctly, there aren't many that use it so it shouldn't be hard to do 
this.

2) Let the current v4l2_i2c_new_* functions call the init core op by 
default. Initializing on load is the default for all current drivers, so we 
have to keep that behavior.

3) Add a new v4l2_i2c_new_subdev_no_init() that does the same as 
v4l2_i2c_new_subdev_board, except without calling init(). It also omits the 
probe_addrs argument since probing requires power to the i2c device.

This does mean that the no_init function will only be available for kernels 
>= 2.6.26, but I don't expect that to be a problem.

These changes allow i2c drivers to be written in such a manner that they can 
be loaded with the device powered off and only be initialized when init() 
is called.

Comments?

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
