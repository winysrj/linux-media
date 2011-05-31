Return-path: <mchehab@pedra>
Received: from mxout006.mail.hostpoint.ch ([217.26.49.185]:53535 "EHLO
	mxout006.mail.hostpoint.ch" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752184Ab1EaLdf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 May 2011 07:33:35 -0400
Message-ID: <4DE4D20C.1090206@section5.ch>
Date: Tue, 31 May 2011 13:33:32 +0200
From: Martin Strubel <hackfin@section5.ch>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org
Subject: Re: v4l2 device property framework in userspace
References: <4DE244F4.90203@section5.ch> <201105311001.40826.hverkuil@xs4all.nl> <4DE4A67A.9070007@section5.ch> <201105311255.02481.hverkuil@xs4all.nl>
In-Reply-To: <201105311255.02481.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

> 
> Not religion, it's experience. I understand what you want to do and it is
> just a bad idea in the long term. Mind you, it's great for prototyping and
> experimentation. But if you want to get stable sensor support in the kernel,
> then it has to conform to the rules. Having some sensor drivers in the kernel
> and some in userspace will be a maintenance disaster.

Sorry, from our perspective the current v4l2 system *has* already been a
maintenance disaster. No offense, but that is exactly the reason why we
had to internally circumvent it.
You're free to use the system for early prototyping stage as well as for
a stable release (the framework is in fact running since 2006 in medical
imaging devices). It certainly cost us less maintenance so far than
syncing up to the changing v4l2 APIs.

> 
> Besides, how is your sensor driver supposed to work when used in a USB webcam?
> Such a USB bridge driver expects a subdevice sensor driver. Since you use a
> different API the two can't communicate. Hence no code reuse.
> 

I don't see a problem there either. Because you just put your register
access code into the kernel. That's merely a matter of two functions.
The sensor daemon doesn't really care *how* you access registers.


>>
>> Not sure if you understand: I do not have to implement or generate ioctl
>> handlers and call them. This is definitely less expensive in terms of
>> coding. All the register access is handled *automatically* using the HW
>> description layer.
> 
> Using what? /dev/i2c-X? That's using ioctls (I2C_RDWR).
> 

Yes. But I have to write exactly two wrappers for access. Not create
tables with ioctl reqcodes.

> 
> Well, you clearly want *your* solution. I've been working in the v4l subsystem
> for many years now ensuring that we can support the widest range of very
> practical and non-academic hardware, both consumer hardware and embedded system
> hardware, and working together with companies like TI, Samsung, Nokia, etc.

Nope. I want any solution that does the job for our requirements. So far
it hasn't been doing it. It's not just getting an image from a sensor
and supporting v4l2 modes, but I think I've been mentioning the dirty
stuff already.

> 
> You (or your company/organization) designed a system without as far as I am aware
> consulating the people responsible for the relevant kernel subsystem (V4L in this
> case). And now you want to get your code in with a minimum of change. Sorry, that's
> not the way it works.
> 

Just that you understand: I'm not wanting to get our code into
somewhere. I'd rather avoid it, one reason being lengthy discussions :-)
Bottomline again: I'm trying to find a solution to avoid bloated and
potentially unstable kernel drivers. Why do you think we (and our
customers) spent the money to develop alternative solutions?


Cheers,

- Martin
