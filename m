Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1316 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907AbZDMLGM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Apr 2009 07:06:12 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Alexey Klimov <klimov.linux@gmail.com>
Subject: Re: About the radio-si470x driver for I2C interface
Date: Mon, 13 Apr 2009 13:06:04 +0200
Cc: Tobias Lorenz <tobias.lorenz@gmx.net>,
	Joonyoung Shim <jy0922.shim@samsung.com>,
	linux-media@vger.kernel.org, kyungmin.park@samsung.com
References: <4e1455be0903051913x37562436y85eef9cba8b10ab0@mail.gmail.com> <200904122256.12305.tobias.lorenz@gmx.net> <208cbae30904121814i66e2b8b2tc4b8de30321e9617@mail.gmail.com>
In-Reply-To: <208cbae30904121814i66e2b8b2tc4b8de30321e9617@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904131306.04425.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 13 April 2009 03:14:13 Alexey Klimov wrote:
> Hello, Tobias
>
> On Mon, Apr 13, 2009 at 12:56 AM, Tobias Lorenz <tobias.lorenz@gmx.net> 
wrote:
> > Hi Joonyoung,
> >
> > Hi Alexey,
> >
> > I've split the driver into a couple of segments:
> >
> > - radio-si470x-common.c is for common functions
> >
> > - radio-si470x-usb.c are the usb support functions
> >
> > - radio-si470x-i2c.c is an untested prototyped file for your i2c
> > support functions
> >
> > - radio-si470x.h is a header file with everything required by the
> > c-files
> >
> > I hope this is a basis we can start on with i2c support. What do you
> > think?
> >
> > The URL is:
> >
> > http://linuxtv.org/hg/~tlorenz/v4l-dvb
> >
> > Bye,
> >
> > Toby
>
> Great! It's always interesting to see big changes.
> I understand i2c interface not so good and have only general questions.
>
> Many (most?) drivers in v4l tree were converted to use new v4l2-
> framework. For example, dsbr100 was converted to v4l2_device
> http://linuxtv.org/hg/v4l-dvb/rev/77f37ad5dd0c and em28xx was
> converted to v4l2_subdev
> http://linuxtv.org/hg/v4l-dvb/rev/00525b115901
> As i remember, Hans Verkuil said that all v4l drivers should be
> converted to new framework. Is it time to switch to this new interface
> ? Probably, there are a lot of code examples in current tree that can
> help..

Any new v4l2 i2c driver must use v4l2_subdev in order to be reusable by v4l2 
drivers. All 'legacy' i2c drivers are now converted and only soc-camera and 
v4l2-int-device.h based drivers remain unconverted, although I expect that 
those will also be moved to v4l2_subdev in 2.6.31.

What complicates matters here is that the si470x is a radio tuner, and as 
such should be implemented as a tuner device (common/tuners) which have 
their own framework. But if memory serves the si470x can also do RDS for 
which there is no support in the tuner framework.

I'm leaning towards implementing this i2c driver as a normal v4l2_subdev 
driver, rather than making it part of the tuner driver/framework.

Actually, I suspect that the tuner driver/framework can be substantially 
simplified with this new framework: much of the complexity there is related 
to the autoprobing crap, and that no longer applies. This is an interesting 
future research topic :-)

> And second question. About lock/unlock_kernel in open functions.
> Please, take a look at
> http://www.spinics.net/lists/linux-media/msg04057.html
> Well, is it time to do something with this?

Yes, please remove/replace these calls.

Regards,

	Hans

> Well, my questions about improving functionality, not about mistakes or
> bugs :)



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
