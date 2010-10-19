Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:36540 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061Ab0JSOwl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Oct 2010 10:52:41 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] viafb camera controller driver
Date: Tue, 19 Oct 2010 16:52:55 +0200
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Jonathan Corbet <corbet@lwn.net>, linux-media@vger.kernel.org,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	Daniel Drake <dsd@laptop.org>
References: <20101010162313.5caa137f@bike.lwn.net> <201010191505.04436.laurent.pinchart@ideasonboard.com> <4CBDAFF5.1090509@infradead.org>
In-Reply-To: <4CBDAFF5.1090509@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Message-Id: <201010191652.56655.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

On Tuesday 19 October 2010 16:49:25 Mauro Carvalho Chehab wrote:
> Em 19-10-2010 11:05, Laurent Pinchart escreveu:
> >> It is not a "big lock": it doesn't stop other CPU's, doesn't affect
> >> other hardware, not even another V4L device. Basically, what this new
> >> lock does is to serialize access to the hardware and to the
> >> hardware-mirrored data.
> > 
> > The lock serializes all ioctls. That's much more than protecting access
> > to data (both in system memory and in the hardware).
> 
> It is not much more. What ioctl's doesn't access the hardware directly nor
> access some struct that caches the hardware data? None, at the most
> complex devices.
> 
> For simpler devices, there are very few VIDIOC*ENUM stuff that may just
> return a fixed set of values, but the userspace applications that call
> them serializes the access anyway (as they are the enum ioctls, used
> during the hardware detection phase of the userspace software).
> 
> So, in practice, it makes no difference to serialize everything or to
> remove the lock for the very few ioctls that just return a fixed set of
> info.

That's not correct. There's a difference between taking a lock around 
read/write operations and around the whole ioctl call stack.

> >> There are basically several opinions about this new schema: some that
> >> think that this is the right thing to do, others think that think that
> >> this is the wrong thing or that this is acceptable only as a transition
> >> for BKL-free drivers.
> > 
> > Indeed, and I belong to the second group.
> 
> And Hans belong to the first one.

So you're right, there are two groups :-)

> >> IMO, I think that both ways are acceptable: a core-assisted
> >> "hardware-access lock" helps to avoid having lots of lock/unlock code at
> >> the driver, making drivers cleaner and easier to review, and reducing
> >> the risk of lock degradation with time. On the other hand, some drivers
> >> may require more complex locking schemas, like, for example, devices
> >> that support several simultaneous independent video streams may have
> >> some common parts used by all streams that need to be serialized, and
> >> other parts that can (and should) not be serialized. So, a
> >> core-assisted locking for some cases may cause unneeded long waits.
> 
> I am in a position between the first and the second group.
> 
> Reviewing locks is simpler with the new schema, and, if well implemented,
> it will help to solve a big problem, but I don't believe that this schema
> is enough to solve all cases, nor that drivers with lots of independent
> streams should use it.

-- 
Regards,

Laurent Pinchart
