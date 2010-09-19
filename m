Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:13815 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749Ab0ISTKR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Sep 2010 15:10:17 -0400
Message-ID: <4C96600E.8090905@redhat.com>
Date: Sun, 19 Sep 2010 16:10:06 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Arnd Bergmann <arnd@arndb.de>
Subject: Re: RFC: BKL, locking and ioctls
References: <fm127xqs7xbmiabppyr1ifai.1284910330767@email.android.com>	 <201009191810.34189.hverkuil@xs4all.nl> <1284921482.2079.57.camel@morgan.silverblock.net>
In-Reply-To: <1284921482.2079.57.camel@morgan.silverblock.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 19-09-2010 15:38, Andy Walls escreveu:
> On Sun, 2010-09-19 at 18:10 +0200, Hans Verkuil wrote:
>> On Sunday, September 19, 2010 17:38:18 Andy Walls wrote:
>>> The device node isn't even the right place for drivers that provide
>> multiple device nodes that can possibly access the same underlying
>> data or register sets.
>>>
>>> Any core/infrastructure approach is likely doomed in the general
>> case.  It's trying to protect data and registers in a driver it knows
>> nothing about, by protecting the *code paths* that take essentially
>> unknown actions on that data and registers. :{
>>
>> Just to clarify: struct video_device gets a *pointer* to a mutex. The mutex
>> itself can be either at the top-level device or associated with the actual
>> video device, depending on the requirements of the driver.
> 
> OK.  Or the mutex can be NULL, where the driver does everything for
> itself.

Yes. If you don't like it, or have a better idea, you can just pass NULL
and do whatever you want on your driver.
> 
> Locking at the device node level for ioctl()'s is better than the
> v4l2_fh proposal, which serializes too much in some contexts and not
> enough for others.

The per-fh allows fine graining when needed. As it is a pointer, you can opt
to have per-device or per-fh locks (or even per-driver lock).
Open/close/mmap/read/poll need to be serialized anyway, as they generally
touch at the same data that you need to protect on ioctl.

By having a global locking schema like that, it is better to over-protect than
to leave some race conditions.

> <obvious>
> Any driver that creates ALSA, dvb, or fb device nodes, or another video
> device node, with access to the same underlying data structures or
> registers, will still need to perform proper locking.  The lock for the
> ioctl() code paths will have to apply at a higher level than the device
> node in these cases.
> </obvious>

Yes. Drivers will need to take care of it. If you look at the em28xx driver I ported,
it preserves the lock at dvb and alsa.

> We're still preserving one of the main headaches of the BKL: "What
> exactly is this lock protecting in this driver?".  We're just adding a
> smaller scoped version to our own infrastructure.  At least maybe for
> ioctl()'s in v4l2 the answer to the question is simpler: we're generally
> protecting against concurrent access to the many and varied
> v4l2_subdev's.
> (Although that doesn't apply to VIDIOC_QUERYCAP and similar ioctl()'s.)

Even querycap might need to be protected on a few drivers, where some info are detected
at runtime.

On the other hand, there's no practical impact on serializing querycap, as the userspace
applications already serialize the access to those enumeration ioctls.

The performance impact for serializing will happen at QBUF/DQBUF and read()/poll() for
both vbi and video, and at alsa and dvb streaming logic.

I agree with Hans that the additional penalty to serialize what's outside the streaming 
syscalls are not relevant and that it is better to sacrifice it in favor to a simpler 
locking schema.

>>> Videobuf is the right place to protect videobuf data.
>>
>> vb_lock is AFAIK there to protect the streaming of data. And that's definitely
>> per device node since only one filehandle per device node can do streaming.
>>
>> Also remember that we are trying to get rid of the BKL, so staying bug-compatible
>> is enough for a first version :-)
> 
> Sure.
> 
> Regards,
> Andy
> 

