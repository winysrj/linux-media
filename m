Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:58927 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754511AbZGLReL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jul 2009 13:34:11 -0400
Date: Sun, 12 Jul 2009 19:34:18 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	v4l2_linux <linux-media@vger.kernel.org>,
	riverful.kim@samsung.com, Dongsoo Kim <dongsoo45.kim@samsung.com>,
	kyungmin.park@samsung.com
Subject: Re: About v4l2 subdev s_config (for core) API?
In-Reply-To: <5e9665e10907112232s32efed0eq2eb90c9f33647f6b@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0907121931480.13280@axis700.grange>
References: <5e9665e10907110402t4b5777abu5f02a44d609405b1@mail.gmail.com>
 <200907112113.42883.hverkuil@xs4all.nl> <5e9665e10907112232s32efed0eq2eb90c9f33647f6b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 12 Jul 2009, Dongsoo, Nathaniel Kim wrote:

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
> > Actually, all s_config does is to pass the irq and platform_data arguments
> > to the subdev driver. The subdev driver can just store that information
> > somewhere and only use it when needed. It does not necessarily have to turn
> > on the sub-device.
> >
> > Whether to just store this info or turn on the sub-device is something that
> > each subdev driver writer has to decide.
> >
> > Note that this really has nothing to do with the existance of s_config:
> > s_config was only introduced in order to support legacy v4l2 drivers and
> > subdev drivers. In the (far?) future this will probably disappear and this
> > information will always be passed via struct i2c_board_info.
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
> > That at least should no longer be a problem anymore (as long as you don't
> > use the address-probing variants).
> >
> > Regards,
> >
> >        Hans
> >
> > --
> > Hans Verkuil - video4linux developer - sponsored by TANDBERG
> >
> 
> Hello Hans,
> 
> I just needed an API for initializing soc camera device ;-( but after
> reading your mail, it seems to be that I'm using a wrong API.
> As you know, almost every cmos camera module needs to be programmed
> through I2C(or SPI) when it is turned on to be initialized. And I
> thought that s_config is the one which could be used.
> If I'm getting wrong, which one can I use for that initialization
> purpose? I referenced every v4l2 device driver in linuxtv repository
> and cherry-picked the API in my own way.

Hi Nate

You might want to have a look at my latest soc-camera (quilt) patch stack 
at downloads.open-technology.de. There I do the same as what soc-camera 
has been doing pretty much since the beginning - turn the device on for 
probing, and then turn it off again - until open().

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
