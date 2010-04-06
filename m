Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752951Ab0DFOme (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Apr 2010 10:42:34 -0400
Message-ID: <4BBB4843.7030109@redhat.com>
Date: Tue, 06 Apr 2010 11:42:11 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	David Ellingsworth <david@identd.dyndns.org>,
	hermann-pitton@arcor.de, awalls@md.metrocast.net,
	dheitmueller@kernellabs.com, abraham.manu@gmail.com,
	linux-media@vger.kernel.org
Subject: Re: [RFC] Serialization flag example
References: <32832848.1270295705043.JavaMail.ngmail@webmail10.arcor-online.net>    <201004060046.12997.laurent.pinchart@ideasonboard.com>    <201004060058.54050.hverkuil@xs4all.nl>    <201004060830.54375.hverkuil@xs4all.nl> <4BBB3022.6080406@redhat.com> <45a097098cc45db25ddbd05334b8be3e.squirrel@webmail.xs4all.nl>
In-Reply-To: <45a097098cc45db25ddbd05334b8be3e.squirrel@webmail.xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
>> Hans Verkuil wrote:

>> 	- performance is important only for the ioctl's that directly handles
>> the streaming (dbuf/dqbuf & friends);
> 
> What performance? These calls just block waiting for a frame. How the hell
> am I suppose to test performance anyway on something like that?

They are called on the main loop for receiving buffers. As the userspace may be
doing some video processing, by introducing latency here, you may affect the
applications. By using perf subsystem, you should be able to test how much
time is spent by an ioctl.

> 
>> 	- videobuf has its own lock implementation;
>>
>> 	- a trivial mutex-based approach won't protect the stream to have
>> some parameters modified by a VIDIOC_S_* ioctl (such protection should be
>> provided by a resource locking);
> 
> Generally once streaming starts drivers should return -EBUSY for such
> calls. Nothing to do with locking in general.

Yes, that's exactly what I said. This is a resource locking: you cannot
change several stream properties while streaming (yet, you can change a
few ones, like bright, contrast, etc).

>> then, maybe the better would be to not call the hooks for those ioctls.
>> It may be useful to do some perf tests and measure the real penalty before
>> adding
>> any extra code to exclude the buffer ioctls from the hook logic.
> 
> Yuck. We want something easy to understand. Like: 'the hook is called for
> every ioctl'. Not: 'the hook is called for every ioctl except this one and
> this one and this one'. Then the driver might have to do different things
> for different ioctls just because some behind-the-scene logic dictated
> that the hook isn't called in some situations.
> 
> I have said it before and I'll say it again: the problem with V4L2 drivers
> has never been performance since all the heavy lifting is done with DMA,
> the problem is complexity. Remember: premature optimization is the root of
> all evil. If a driver really needs the last drop of performance (for what,
> I wonder?) then it can choose to just not implement those hooks and do
> everything itself.

I tend to agree with you. All I'm saying is that it is valuable to double
check the impacts before committing it.

-- 

Cheers,
Mauro
