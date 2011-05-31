Return-path: <mchehab@pedra>
Received: from mxout006.mail.hostpoint.ch ([217.26.49.185]:64869 "EHLO
	mxout006.mail.hostpoint.ch" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752439Ab1EaI1l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 May 2011 04:27:41 -0400
Message-ID: <4DE4A67A.9070007@section5.ch>
Date: Tue, 31 May 2011 10:27:38 +0200
From: Martin Strubel <hackfin@section5.ch>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org
Subject: Re: v4l2 device property framework in userspace
References: <4DE244F4.90203@section5.ch> <bf5dd516b42805e8cb5ca0d66a4ed138.squirrel@webmail.xs4all.nl> <4DE39BEF.5080104@section5.ch> <201105311001.40826.hverkuil@xs4all.nl>
In-Reply-To: <201105311001.40826.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


> 
> Userspace tells the driver what it should do and the driver decides how to do it.
> That's how it works.

Sounds a little religious. Not sure if you've been listening..

> 
>> And for us it is even more reusable, because we can run the
>> same thing on a standalone 'OS' (no OS really) and for example RTEMS.
> 
> That is never a consideration for linux. Hardware abstraction layers are not
> allowed. Blame Linus, not me, although I completely agree with him on this.
> 

This is new to me. What should be the reason not to abstract hardware?
To give people a coding job?

>> So for the various OS specifics, we only have one video acquisition
>> driver which has no knowledge of the attached sensor. All generic v4l2
>> properties again are tunneled through userspace to the "sensor daemon".
>> I still don't see what is (technically) wrong with that.
> 
> It's the tunneling to a sensor daemon that is wrong. You can write a sensor
> driver as a V4L subdevice driver and it is reusable by any 'video acquisition;
> driver (aka V4L2 bridge/platform driver) without going through userspace and
> requiring userspace daemons.
> 

> It's the tunneling to a sensor daemon that is wrong. You can write a sensor
> driver as a V4L subdevice driver and it is reusable by any 'video acquisition;
> driver (aka V4L2 bridge/platform driver) without going through userspace and
> requiring userspace daemons.

You keep saying it is wrong, but I have so far seen no technically firm
argument. Please tell me why.

> 
>> For me, it works like a driver, plus it is way more flexible as I don't
>> have to go through ioctls for special sensor properties.
> 
> You still have to go through the kernel to set registers. That's just as
> expensive as an ioctl.
> 


Not sure if you understand: I do not have to implement or generate ioctl
handlers and call them. This is definitely less expensive in terms of
coding. All the register access is handled *automatically* using the HW
description layer.

> 
> Sure, no problem. It's open source after all. Just be aware that all the
> maintenance effort is for you as long as you remain out of tree.
> 

We have to do this anyhow. But we'd prefer to do it the way that
requires least maintenance as described.
We need to have a *solution*. Not some academic hack that is "not wrong".

I think we can end the discussion here. I was hoping for more
technically valuable input, really.
