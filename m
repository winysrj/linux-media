Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:50297 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209Ab0JSOte (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Oct 2010 10:49:34 -0400
Message-ID: <4CBDAFF5.1090509@infradead.org>
Date: Tue, 19 Oct 2010 12:49:25 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Jonathan Corbet <corbet@lwn.net>, linux-media@vger.kernel.org,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	Daniel Drake <dsd@laptop.org>
Subject: Re: [PATCH] viafb camera controller driver
References: <20101010162313.5caa137f@bike.lwn.net> <201010190952.46938.laurent.pinchart@ideasonboard.com> <4CBD76F3.5060609@infradead.org> <201010191505.04436.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201010191505.04436.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 19-10-2010 11:05, Laurent Pinchart escreveu:
> Hi Mauro,
> 
>> It is not a "big lock": it doesn't stop other CPU's, doesn't affect other
>> hardware, not even another V4L device. Basically, what this new lock does
>> is to serialize access to the hardware and to the hardware-mirrored data.
> 
> The lock serializes all ioctls. That's much more than protecting access to 
> data (both in system memory and in the hardware).

It is not much more. What ioctl's doesn't access the hardware directly nor access
some struct that caches the hardware data? None, at the most complex devices.

For simpler devices, there are very few VIDIOC*ENUM stuff that may just return
a fixed set of values, but the userspace applications that call them serializes 
the access anyway (as they are the enum ioctls, used during the hardware detection 
phase of the userspace software).

So, in practice, it makes no difference to serialize everything or to remove
the lock for the very few ioctls that just return a fixed set of info.

>> There are basically several opinions about this new schema: some that think
>> that this is the right thing to do, others think that think that this is
>> the wrong thing or that this is acceptable only as a transition for
>> BKL-free drivers.
> 
> Indeed, and I belong to the second group.

And Hans belong to the first one.

>> IMO, I think that both ways are acceptable: a core-assisted
>> "hardware-access lock" helps to avoid having lots of lock/unlock code at
>> the driver, making drivers cleaner and easier to review, and reducing the
>> risk of lock degradation with time. On the other hand, some drivers may
>> require more complex locking schemas, like, for example, devices that
>> support several simultaneous independent video streams may have some
>> common parts used by all streams that need to be serialized, and other
>> parts that can (and should) not be serialized. So, a core-assisted locking
>> for some cases may cause unneeded long waits.

I am in a position between the first and the second group.

Reviewing locks is simpler with the new schema, and, if well implemented, it
will help to solve a big problem, but I don't believe that this schema is enough
to solve all cases, nor that drivers with lots of independent streams should
use it.

Cheers,
Mauro
