Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:36651 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170Ab0JSPnC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Oct 2010 11:43:02 -0400
Message-ID: <4CBDBC7C.8010000@infradead.org>
Date: Tue, 19 Oct 2010 13:42:52 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Jonathan Corbet <corbet@lwn.net>, linux-media@vger.kernel.org,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	Daniel Drake <dsd@laptop.org>
Subject: Re: [PATCH] viafb camera controller driver
References: <20101010162313.5caa137f@bike.lwn.net> <201010191505.04436.laurent.pinchart@ideasonboard.com> <4CBDAFF5.1090509@infradead.org> <201010191652.56655.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201010191652.56655.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 19-10-2010 12:52, Laurent Pinchart escreveu:
> Hi Mauro,
> 
> On Tuesday 19 October 2010 16:49:25 Mauro Carvalho Chehab wrote:
>> Em 19-10-2010 11:05, Laurent Pinchart escreveu:
>>>> It is not a "big lock": it doesn't stop other CPU's, doesn't affect
>>>> other hardware, not even another V4L device. Basically, what this new
>>>> lock does is to serialize access to the hardware and to the
>>>> hardware-mirrored data.
>>>
>>> The lock serializes all ioctls. That's much more than protecting access
>>> to data (both in system memory and in the hardware).
>>
>> It is not much more. What ioctl's doesn't access the hardware directly nor
>> access some struct that caches the hardware data? None, at the most
>> complex devices.
>>
>> For simpler devices, there are very few VIDIOC*ENUM stuff that may just
>> return a fixed set of values, but the userspace applications that call
>> them serializes the access anyway (as they are the enum ioctls, used
>> during the hardware detection phase of the userspace software).
>>
>> So, in practice, it makes no difference to serialize everything or to
>> remove the lock for the very few ioctls that just return a fixed set of
>> info.
> 
> That's not correct. There's a difference between taking a lock around 
> read/write operations and around the whole ioctl call stack.

Huh?

Even on simpler hardware, there are very few ioctls that don't access hardware.
Hardly, this would cause any performance impact.

What I said is that, if the userspace does:

open()
/* Serialized ioctls */
ioctl (...)
ioctl (...)
ioctl (...)
ioctl (...)
ioctl (...)
ioctl (...)
ioctl (...)
...

It doesn't matter if kernel is forcing serialization or not.

The difference only happens if userspace does things like:

fork()	/* Or some thread creation function */
...
/* proccess/thread 1 */
ioctl()
...
/* proccess/thread 2 */
ioctl()
...
/* proccess/thread 3 */
ioctl()
...

However, it doesn't make sense to do parallel access to *ENUM ioctls, so I don't know
any application doing that during the "hardware discover phase", whe.

The usage of different process/threads may make sense, from userspace POV, while streaming.
There are a few reasons for that, like:
	- users may want to adjust the bright/contrast (or other video/audio control)
	  while streaming;
	- if the dqbuf logic is complex (for example, it may have some software processing
	  logic - like de interlacing);
	- a separate process may be recording the video.

On all the above valid use-cases, the ioctl is really accessing the hardware and/or some
hardware-cached data. So, a lock is needed anyway.

Cheers,
Mauro
