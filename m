Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39548 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222Ab0DBQGt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Apr 2010 12:06:49 -0400
Message-ID: <4BB61614.3080702@redhat.com>
Date: Fri, 02 Apr 2010 13:06:44 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org
Subject: Re: [RFC] Serialization flag example
References: <201004011937.39331.hverkuil@xs4all.nl> <201004012257.08684.hverkuil@xs4all.nl> <4BB510F1.7090504@redhat.com> <201004021057.42044.hverkuil@xs4all.nl>
In-Reply-To: <201004021057.42044.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
> On Thursday 01 April 2010 23:32:33 Mauro Carvalho Chehab wrote:
>> Hans Verkuil wrote:
>>>> Maybe a better alternative would be to pass to the V4L2 core, optionally, some lock,
>>>> used internally on the driver. This approach will still be pedantic, as all ioctls will
>>>> keep being serialized, but at least the driver will need to explicitly handle the lock,
>>>> and the same lock can be used on other parts of the driver.
>>> Well, I guess you could add a 'struct mutex *serialize;' field to v4l2_device
>>> that drivers can set. But I don't see much of a difference in practice.
>> It makes easier to implement more complex approaches, where you may need to use more
>> locks. Also, It makes no sense to make a DVB code or an alsa code dependent on a V4L
>> header, just because it needs to see a mutex.
> 
> What's in a name. v4l2_device is meant to be a top-level object in a driver.
> There is nothing particularly v4l about it and it would be trivial to rename
> it to media_device.

This has nothing to do with a name. The point is that such mutex need to be used by
other systems (for example, some drivers have alsa provided by snd-usb-audio).

>> Also, a mutex at the driver need to be initialized inside the driver. It is not just one
>> flag that someone writing a new driver will clone without really understanding what
>> it is doing.
> 
> Having a driver do mutex_init() really does not improve understanding. But
> good documentation will. Creating a simple, easy to understand and well
> documented locking scheme will go a long way to making our drivers better.

Documentation is for sure needed. Having the mutex inside of the driver helps
people to understand, as I doubt that most of the developers take a deep look
inside V4L and Linux core implementations before writing a driver. 

I'm all for porting things that are common to the core, but things that
depends on the driver internal logic, like the mutexes that protect the driver
data structs, should be more visible (or be fully implemented) outside the core.

> Now, having said all this, I do think upon reflection that using a pointer
> to a mutex might be better. The main reason being that while I do think that
> renaming v4l2_device to media_device is a good idea and that more code sharing
> between v4l and dvb would benefit both (heck, perhaps there should be more
> integration between v4l-dvb and alsa as well), the political reality is
> different.

With respect to v4l2_device:

The reason should be technical, not political. A proper module/subsystem decoupling is
interesting, to easy maintainership. As I said, back on LPC/2007, the core functions
provided by v4l2_device makes sense and should also be used on DVB. That's my 2 cents.

The reality is that migrating existing drivers to it will be very time consuming,
and maybe not valuable enough, at least for those dvb drivers that are almost
unmaintained nowadays, but I think that using it for new drivers and for the drivers
where we have a constant pattern of maintainability would be a good thing.

I think we should evolute to have a more integrated core for both V4L and DVB,
that will provide the proper locking between the two subsystems. 

>>> Basically the CAP (capability) ioctls and all ENUM ioctls do not have to be
>>> serialized. I am not sure whether the streaming ioctls should also be included
>>> here. I can't really grasp the consequences of whatever choice we make. If we
>>> want to be compatible with what happens today with ioctl and the BKL, then we
>>> need to lock and have videobuf unlock whenever it has to wait for an event.
>> I suspect that the list of "must have" is driver-dependent.
> 
> If needed one could allow drivers to override this function. But again, start
> simple and only make it more complex if we really need to. Overengineering is
> one of the worst mistakes one can make. I have seen too many projects fail
> because of that.

Ok.

-- 

Cheers,
Mauro
