Return-path: <mchehab@pedra>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3038 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753776Ab1EaKzL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 May 2011 06:55:11 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Martin Strubel <hackfin@section5.ch>
Subject: Re: v4l2 device property framework in userspace
Date: Tue, 31 May 2011 12:55:02 +0200
Cc: linux-media@vger.kernel.org
References: <4DE244F4.90203@section5.ch> <201105311001.40826.hverkuil@xs4all.nl> <4DE4A67A.9070007@section5.ch>
In-Reply-To: <4DE4A67A.9070007@section5.ch>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105311255.02481.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday, May 31, 2011 10:27:38 Martin Strubel wrote:
> 
> > 
> > Userspace tells the driver what it should do and the driver decides how to do it.
> > That's how it works.
> 
> Sounds a little religious. Not sure if you've been listening..

Not religion, it's experience. I understand what you want to do and it is
just a bad idea in the long term. Mind you, it's great for prototyping and
experimentation. But if you want to get stable sensor support in the kernel,
then it has to conform to the rules. Having some sensor drivers in the kernel
and some in userspace will be a maintenance disaster.

> 
> > 
> >> And for us it is even more reusable, because we can run the
> >> same thing on a standalone 'OS' (no OS really) and for example RTEMS.
> > 
> > That is never a consideration for linux. Hardware abstraction layers are not
> > allowed. Blame Linus, not me, although I completely agree with him on this.
> > 
> 
> This is new to me. What should be the reason not to abstract hardware?
> To give people a coding job?

Sorry, I used the wrong name. I meant OS abstraction layers.

> 
> >> So for the various OS specifics, we only have one video acquisition
> >> driver which has no knowledge of the attached sensor. All generic v4l2
> >> properties again are tunneled through userspace to the "sensor daemon".
> >> I still don't see what is (technically) wrong with that.
> > 
> > It's the tunneling to a sensor daemon that is wrong. You can write a sensor
> > driver as a V4L subdevice driver and it is reusable by any 'video acquisition;
> > driver (aka V4L2 bridge/platform driver) without going through userspace and
> > requiring userspace daemons.
> > 
> 
> > It's the tunneling to a sensor daemon that is wrong. You can write a sensor
> > driver as a V4L subdevice driver and it is reusable by any 'video acquisition;
> > driver (aka V4L2 bridge/platform driver) without going through userspace and
> > requiring userspace daemons.
> 
> You keep saying it is wrong, but I have so far seen no technically firm
> argument. Please tell me why.

Technically both are valid approaches. But doing this in userspace just adds
extra complexity. All sensor drivers are in the kernel and we are not going
to introduce userspace sensor drivers as that leads to a maintenance disaster.

Besides, how is your sensor driver supposed to work when used in a USB webcam?
Such a USB bridge driver expects a subdevice sensor driver. Since you use a
different API the two can't communicate. Hence no code reuse.


> 
> > 
> >> For me, it works like a driver, plus it is way more flexible as I don't
> >> have to go through ioctls for special sensor properties.
> > 
> > You still have to go through the kernel to set registers. That's just as
> > expensive as an ioctl.
> > 
> 
> 
> Not sure if you understand: I do not have to implement or generate ioctl
> handlers and call them. This is definitely less expensive in terms of
> coding. All the register access is handled *automatically* using the HW
> description layer.

Using what? /dev/i2c-X? That's using ioctls (I2C_RDWR).

> 
> > 
> > Sure, no problem. It's open source after all. Just be aware that all the
> > maintenance effort is for you as long as you remain out of tree.
> > 
> 
> We have to do this anyhow. But we'd prefer to do it the way that
> requires least maintenance as described.
> We need to have a *solution*. Not some academic hack that is "not wrong".
> 
> I think we can end the discussion here. I was hoping for more
> technically valuable input, really.
> 

Well, you clearly want *your* solution. I've been working in the v4l subsystem
for many years now ensuring that we can support the widest range of very
practical and non-academic hardware, both consumer hardware and embedded system
hardware, and working together with companies like TI, Samsung, Nokia, etc.

You (or your company/organization) designed a system without as far as I am aware
consulating the people responsible for the relevant kernel subsystem (V4L in this
case). And now you want to get your code in with a minimum of change. Sorry, that's
not the way it works.

Regards,

	Hans
