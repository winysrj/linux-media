Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:6698 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755363Ab0ITBwl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Sep 2010 21:52:41 -0400
Message-ID: <4C96BE5E.5050003@redhat.com>
Date: Sun, 19 Sep 2010 22:52:30 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Andy Walls <awalls@md.metrocast.net>, linux-media@vger.kernel.org,
	Arnd Bergmann <arnd@arndb.de>
Subject: Re: RFC: BKL, locking and ioctls
References: <fm127xqs7xbmiabppyr1ifai.1284910330767@email.android.com> <1284921482.2079.57.camel@morgan.silverblock.net> <4C96600E.8090905@redhat.com> <201009192138.08412.hverkuil@xs4all.nl>
In-Reply-To: <201009192138.08412.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 19-09-2010 16:38, Hans Verkuil escreveu:
> On Sunday, September 19, 2010 21:10:06 Mauro Carvalho Chehab wrote:
>> Em 19-09-2010 15:38, Andy Walls escreveu:
>>> On Sun, 2010-09-19 at 18:10 +0200, Hans Verkuil wrote:
>>>> On Sunday, September 19, 2010 17:38:18 Andy Walls wrote:
>>>>> The device node isn't even the right place for drivers that provide
>>>> multiple device nodes that can possibly access the same underlying
>>>> data or register sets.
>>>>>
>>>>> Any core/infrastructure approach is likely doomed in the general
>>>> case.  It's trying to protect data and registers in a driver it knows
>>>> nothing about, by protecting the *code paths* that take essentially
>>>> unknown actions on that data and registers. :{
>>>>
>>>> Just to clarify: struct video_device gets a *pointer* to a mutex. The mutex
>>>> itself can be either at the top-level device or associated with the actual
>>>> video device, depending on the requirements of the driver.
>>>
>>> OK.  Or the mutex can be NULL, where the driver does everything for
>>> itself.
>>
>> Yes. If you don't like it, or have a better idea, you can just pass NULL
>> and do whatever you want on your driver.
>>>
>>> Locking at the device node level for ioctl()'s is better than the
>>> v4l2_fh proposal, which serializes too much in some contexts and not
>>> enough for others.
>>
>> The per-fh allows fine graining when needed. As it is a pointer, you can opt
>> to have per-device or per-fh locks (or even per-driver lock).
>> Open/close/mmap/read/poll need to be serialized anyway, as they generally
>> touch at the same data that you need to protect on ioctl.
>>
>> By having a global locking schema like that, it is better to over-protect than
>> to leave some race conditions.
> 
> That makes no sense. It is overly fine-grained locking schemes that lead to
> race conditions. Overly course-grained schemes can lead to performance issues.
> The problem is finding the right balance. Which to me is at the device node
> level. AFAIK there is not a single driver that does locking at the file handle
> level. It's either at the top level or at the device node level (usually through
> videobuf's vb_lock).

The discussion here is not related of being at per-device or per-fh. Andy is arguing
that the V4L2 core should not be locking poll() and read(), but both operations need
to be locked in order for it to warrant no race conditions for mmap(). The only 
exception is that this is not needed is for the three drivers that (still)
don't implement mmap().

> And as I said before the v4l2_fh changes are fairly major and going in a
> direction that I really don't like. Whereas putting the mutex pointer in struct
> video_device is a very minor change that's easy to review and easy to understand.
> A pointer to the video_device is also available almost everywhere. Whereas v4l2_fh
> is not needed at all by many drivers.
> 
> If a driver really wants to do locking at the file handle level, then that
> driver can always override the core locking and handle everything manually.
> 
> If you have unusual requirements, then that requires unusual amounts of work.
> No need to let all the other drivers suffer.

Ok, this is a good point. Could you please write a patch against the devel branch?

Yet, we need to keep read() and poll() locked, otherwise most drivers will break.

>>> <obvious>
>>> Any driver that creates ALSA, dvb, or fb device nodes, or another video
>>> device node, with access to the same underlying data structures or
>>> registers, will still need to perform proper locking.  The lock for the
>>> ioctl() code paths will have to apply at a higher level than the device
>>> node in these cases.
>>> </obvious>
>>
>> Yes. Drivers will need to take care of it. If you look at the em28xx driver I ported,
>> it preserves the lock at dvb and alsa.
>>
>>> We're still preserving one of the main headaches of the BKL: "What
>>> exactly is this lock protecting in this driver?".  We're just adding a
>>> smaller scoped version to our own infrastructure.  At least maybe for
>>> ioctl()'s in v4l2 the answer to the question is simpler: we're generally
>>> protecting against concurrent access to the many and varied
>>> v4l2_subdev's.
>>> (Although that doesn't apply to VIDIOC_QUERYCAP and similar ioctl()'s.)
>>
>> Even querycap might need to be protected on a few drivers, where some info are detected
>> at runtime.
>>
>> On the other hand, there's no practical impact on serializing querycap, as the userspace
>> applications already serialize the access to those enumeration ioctls.
>>
>> The performance impact for serializing will happen at QBUF/DQBUF and read()/poll() for
>> both vbi and video, and at alsa and dvb streaming logic.
>>
>> I agree with Hans that the additional penalty to serialize what's outside the streaming 
>> syscalls are not relevant and that it is better to sacrifice it in favor to a simpler 
>> locking schema.
> 
> And may I add to that that I think that attempting to optimize performance for
> apps doing really weird things (like read and streaming i/o from the same source at
> the same time) also falls under the header 'not relevant'?

This is relevant, since reverting this behavior is clearly a regression, as userspace apps
will break.

> Requirements I can think of:
> 
> 1) The basic capture and output streaming (either read/write or streaming I/O) must
> perform well. There is no need to go to extreme measures here, since the typical
> control flow is to prepare a buffer, setup the DMA and then wait for the DMA to
> finish. So this is not terribly time sensitive and it is perfectly OK to have to
> wait (within reason) for another ioctl from another thread to finish first.

On all USB devices, you also need to do double-buffering, to remove the USB headers from
the video and audio information. They generally spend a considerable amount of time doing
it on some drivers, in order to get the beginning of the frames.

> 2) While capturing/displaying other threads must be able to control the device at the
> same time and gather status information. This also means that such a thread should
> not be blocked from controlling the device because a dqbuf ioctl happens to be waiting
> for the DMA to finish in the main thread.

True.

> 3) We must also make sure that the mem-to-mem drivers keep working. That might be a
> special case that will become more important in the future. These are the only device
> nodes that can do capture and output streaming at the same time.

Agreed.

Mauro.
