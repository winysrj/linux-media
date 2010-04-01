Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50745 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755333Ab0DASYQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Apr 2010 14:24:16 -0400
Message-ID: <4BB4E4CC.3020100@redhat.com>
Date: Thu, 01 Apr 2010 15:24:12 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org
Subject: Re: [RFC] Serialization flag example
References: <201004011937.39331.hverkuil@xs4all.nl>
In-Reply-To: <201004011937.39331.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans,


Hans Verkuil wrote:
> I made a quick implementation which is available here:
> 
> http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-serialize
> 
> It's pretty easy to use and it also gives you a very simple way to block
> access to the video device nodes until all have been allocated by simply
> taking the serialization lock and holding it until we are done with the
> initialization.
> 
> I converted radio-mr800.c and ivtv.
> 
> That said, almost all drivers that register multiple device nodes probably
> suffer from a race condition when one of the device node registrations
> returns an error and all devices have to be unregistered and the driver
> needs to release all resources.
> 
> Currently most if not all drivers just release resources and free the memory.
> But if an application managed to open one device before the driver removes it
> again, then we have almost certainly a crash.
> 
> It is possible to do this correctly in the driver, but it really needs core
> support where a release callback can be installed in v4l2_device that is
> called when the last video_device is closed by the application.
> 
> We already can cleanup correctly after the last close of a video_device, but
> there is no top-level release yet.
> 
> 
> Anyway, I tried to use the serialization flag in bttv as well, but I ran into
> problems with videobuf. Basically when you need to wait for some event you
> should release the serialization lock and grab it after the event arrives.
> 
> Unfortunately videobuf has no access to v4l2_device at the moment. If we would
> have that, then videobuf can just release the serialization lock while waiting
> for something to happen.


While this code works like a charm with the radio devices, it probably
won't work fine with complex devices.

You'll have issues also with -alsa and -dvb parts that are present on the drivers.

Also, drivers like cx88 have another PCI device for mpeg-encoded streams. It behaves
like two separate drivers (each with its own bind code at V4L core), but, as there's
just one PCI bridge, and just one analog video decoder/analog audio decoder, the lock
should cross between the different drivers.

So, binding videobuf to v4l2_device won't solve the issue with most videobuf-aware drivers,
nor the lock will work as expected, at least with most of the devices.

Also, although this is not a real problem, your lock is too pedantic: it is 
blocking access to several ioctl's that don't need to be locked. For example, there are
several ioctl's that just returns static: information: capabilities, supported video standards,
etc. There are even some cases where dynamic ioctl's are welcome, like accepting QBUF/DQBUF
without locking (or with a minimum lock), to allow different threads to handle the buffers.

The big issue I see with this approach is that developers will become lazy on checking
the locks inside the drivers: they'll just apply the flag and trust that all of their
locking troubles were magically solved by the core. 

Maybe a better alternative would be to pass to the V4L2 core, optionally, some lock,
used internally on the driver. This approach will still be pedantic, as all ioctls will
keep being serialized, but at least the driver will need to explicitly handle the lock,
and the same lock can be used on other parts of the driver.

-- 

Cheers,
Mauro
