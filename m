Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:60139 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789Ab1EaM66 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 31 May 2011 08:58:58 -0400
Message-ID: <4DE4E60A.5090600@redhat.com>
Date: Tue, 31 May 2011 09:58:50 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Martin Strubel <hackfin@section5.ch>
CC: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: v4l2 device property framework in userspace
References: <4DE244F4.90203@section5.ch> <201105311001.40826.hverkuil@xs4all.nl> <4DE4A67A.9070007@section5.ch> <201105311255.02481.hverkuil@xs4all.nl> <4DE4D20C.1090206@section5.ch>
In-Reply-To: <4DE4D20C.1090206@section5.ch>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Martin,

Em 31-05-2011 08:33, Martin Strubel escreveu:
> Hi,
> 
>>
>> Not religion, it's experience. I understand what you want to do and it is
>> just a bad idea in the long term. Mind you, it's great for prototyping and
>> experimentation. But if you want to get stable sensor support in the kernel,
>> then it has to conform to the rules. Having some sensor drivers in the kernel
>> and some in userspace will be a maintenance disaster.
> 
> Sorry, from our perspective the current v4l2 system *has* already been a
> maintenance disaster. No offense, but that is exactly the reason why we
> had to internally circumvent it.
> You're free to use the system for early prototyping stage as well as for
> a stable release (the framework is in fact running since 2006 in medical
> imaging devices). 

It seems that you're completely lost about why it is good for you to upstream
a driver. First of all, by using and contributing with Linux (and other open source 
projects), you end by not needing of doing all work by yourself: a team of
experienced developers from several different companies work together to bring
the better solutions to address a problem. This is not academic. You'll see very
few contributions from academy at the Linux Kernel. Most of the contributions come
from people working and solving real problems. The direction taken on Linux come from
those experiences.

If you take a look at the discussions at the mailing list, you'll see that patches
made by one company receive lots of contributions from other companies, in order
to improve it. This warrants that such driver will perform better, have less bug fixes
(as others pair of eyes are looking on it) and can be used by other drivers.

Also, once a driver is merged, if someone needs to change some API, the one that
made the change should also send fixes for the drivers that use that calls. That
means that there's no maintainance effort at long term. We have very good examples
on how this work at the V4L subsystem: you'll find there drivers written in 1999, where
the original maintainer stopped working on it a long time ago, and they still work with
real hardware. Such drivers even got userspace API improvements, like porting from V4L1
into V4L2.

So, if you're upstreaming your drivers, you get such benefits.

On the other hand, if you're working with out-of-tree drivers, it is a maintainance
nightmare, as we're always bringing improvements to the Linux core API's, and to the
V4L core subsystem. So, it costs a lot of time and money to keep an out-of-tree
driver working at the long term.

There's one major requirement for you to upstream your code: you need to understand
the concepts used by the subsystem you're upstreaming and adhere to the upstream
rules.

One of such rules is that a kernel driver should provide the desired functionality
without needing an userspace driver. In other words, we don't want to have a kernel
driver wrapper for a real driver at userspace.

> It certainly cost us less maintenance so far than
> syncing up to the changing v4l2 APIs.

You're increasing your maintainance costs by not upstreaming.

>>
>> Besides, how is your sensor driver supposed to work when used in a USB webcam?
>> Such a USB bridge driver expects a subdevice sensor driver. Since you use a
>> different API the two can't communicate. Hence no code reuse.
>>
> 
> I don't see a problem there either. Because you just put your register
> access code into the kernel. That's merely a matter of two functions.
> The sensor daemon doesn't really care *how* you access registers.

The problem is that it violates the rule of the game: to share the developed code
with the others. If you're using non-standard interfaces to communicate between
the sensors and the bridge driver, only you're benefiting from it. At the end, someone
else will write a different code for that sensor, and we'll end by having several
drivers to do the same thing. By having just one driver, the TCO (Total Cost of Ownership)
will decrease, as the costs for writing and maintaining such driver decreases.

>>>
>>> Not sure if you understand: I do not have to implement or generate ioctl
>>> handlers and call them. This is definitely less expensive in terms of
>>> coding. All the register access is handled *automatically* using the HW
>>> description layer.
>>
>> Using what? /dev/i2c-X? That's using ioctls (I2C_RDWR).
>>
> 
> Yes. But I have to write exactly two wrappers for access. Not create
> tables with ioctl reqcodes.

V4L2 controls also have just 2 ioctl's for reading/writing values on it.

>>
>> Well, you clearly want *your* solution. I've been working in the v4l subsystem
>> for many years now ensuring that we can support the widest range of very
>> practical and non-academic hardware, both consumer hardware and embedded system
>> hardware, and working together with companies like TI, Samsung, Nokia, etc.
> 
> Nope. I want any solution that does the job for our requirements. So far
> it hasn't been doing it. It's not just getting an image from a sensor
> and supporting v4l2 modes, but I think I've been mentioning the dirty
> stuff already.

I haven't seen yet any use case where V4L2 won't fit as-is, or with a few API
additions.

>> You (or your company/organization) designed a system without as far as I am aware
>> consulating the people responsible for the relevant kernel subsystem (V4L in this
>> case). And now you want to get your code in with a minimum of change. Sorry, that's
>> not the way it works.
>>
> 
> Just that you understand: I'm not wanting to get our code into
> somewhere. I'd rather avoid it, one reason being lengthy discussions :-)

It is up to you if you want to increase your costs.

> Bottomline again: I'm trying to find a solution to avoid bloated and
> potentially unstable kernel drivers. Why do you think we (and our
> customers) spent the money to develop alternative solutions?

If you're doing the driver ports by yourself, without the help of the ones
that has deep understanding on how things work at the Kernel (because they
wrote the Kernel code), you'll end by having unstable kernel/userspace
drivers. Probably not a wise way to spend your money.

>From the experience I have by analysing thousands of patches for drivers/media
that comes from all sorts of different sources, is that companies that don't
have much experience upstreaming his work frequently do bad things that cause
driver's instability. Several of those troubles are detected during the review
process. Eventually, a few of them go to the main trees, and the Kernel janitor's
and the security teams catch them. So, at the end, the driver becomes much
more reliable than the original one.

Thanks,
Mauro.
