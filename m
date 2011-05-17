Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:32051 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754129Ab1EQMtF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 May 2011 08:49:05 -0400
Message-ID: <4DD26EBC.9040804@redhat.com>
Date: Tue, 17 May 2011 09:49:00 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	Jesse Barker <jesse.barker@linaro.org>
Subject: Re: Summary of the V4L2 discussions during LDS - was: Re: Embedded
 Linux memory management interest group list
References: <BANLkTimoKzWrAyCBM2B9oTEKstPJjpG_MA@mail.gmail.com> <201105141302.55100.hverkuil@xs4all.nl> <4DCE6B7B.1080907@redhat.com> <201105152310.31678.hverkuil@xs4all.nl>
In-Reply-To: <201105152310.31678.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 15-05-2011 18:10, Hans Verkuil escreveu:
> On Saturday, May 14, 2011 13:46:03 Mauro Carvalho Chehab wrote:
>> Em 14-05-2011 13:02, Hans Verkuil escreveu:
>>> On Saturday, May 14, 2011 12:19:18 Mauro Carvalho Chehab wrote:
>>
>>>> So, based at all I've seen, I'm pretty much convinced that the normal MMAP
>>>> way of streaming (VIDIOC_[REQBUF|STREAMON|STREAMOFF|QBUF|DQBUF ioctl's)
>>>> are not the best way to share data with framebuffers.
>>>
>>> I agree with that, but it is a different story between two V4L2 devices. There
>>> you obviously want to use the streaming ioctls and still share buffers.
>>
>> I don't think so. the requirement for syncing the framebuffer between the two
>> V4L2 devices is pretty much the same as we have with one V4L2 device and one GPU.
>>
>> On both cases, the requirement is to pass a framebuffer between two entities, 
>> and not a video stream.
>>
>> For example, imagine something like:
>>
>> 	V4L2 camera =====> V4L2 encoder t MPEG2
>> 		     ||
>> 		     LL==> GPU

For the sake of clarity on my next comments, I'm naming the "V4L2 camera" buffer
write endpoint as "producer" and the 2 buffer read endpoints as "consumers". 
>>
>> Both GPU and the V4L2 encoder should use the same logic to be sure that they will
>> use a buffer that were filled already by the camera. Also, the V4L2 camera
>> driver can't re-use such framebuffer before being sure that both consumers 
>> has already stopped using it.
> 
> No. A camera whose output is sent to a resizer and then to a SW/FW/HW encoder
> is a typical example where you want to queue/dequeue buffers.

Why? On a framebuffer-oriented set of ioctl's, some kernel internal calls will
need to take care of the buffer usage, in order to be sure when a buffer can
be rewritten, as userspace has no way to know when a buffer needs to be queued/dequeued.

In other words, the framebuffer kernel API will probably be using a kernel structure like:

struct v4l2_fb_handler {
	bool has_finished;				/* Marks when a handler finishes to handle the buffer */
	bool is_producer;				/* Used by the handler that writes data into the buffer */

	struct list_head *handlers;			/* List with all handlers */

	void (*qbuf)(struct v4l2_fb_handler *handler);	/* qbuf-like callback, called after having a buffer filled */

	v4l2_buffer_ID	buf;				/* Buffer ID (or filehandler?) - In practice, it will probably be a list with the available buffers */

	void *priv;					/* handler priv data */
}

While stream is on, a kernel logic will run a loop, doing basically the steps bellow:

	1) Wait for the producer to rise the has_finished flag;

	2) call qbuf() for all consumers. The qbuf() call shouldn't block; it just calls 
	   a per-handler logic to start using that buffer;

	3) When each fb handler finishes using its buffer, it will rise has_finished flag;

	4) After having all buffer handlers marked as has_finished, cleans the has_finished
	  flags and re-queue the buffer.

Step (2) is equivalent to VIDIOC_QBUF, and step (4) is equivalent to VIDIOC_DQBUF.

PS.: The above is just a simplified view of such handler. We'll probably need more steps. For
example, between (1) and (2) it may probably need some logic to check if is there an available
empty buffer. If not, create a new one and use it.

What happens with REQBUF/QBUF/DQBUF is that:
	- with those calls, there's just one buffer consumer, and just one buffer producer;
	- either the producer or the consumer is on userspace, and the other pair is
	  at kernelspace;
	- buffers are allocated before the start of a process, via an explicit call;
	- buffers need to be mmapped, in order to be visible at userspace.

None of the above applies to a framebuffer-oriented API:
	- more than one buffer consumer is allowed;
	- consumers and producers are on kernelspace (it might be needed to have an
an API for handling such buffers also on userspace, although it doesn't sound a good
idea to me, IMHO);
	- buffers can be dynamically allocated/de-allocated;
	- buffers don't need to be mmapped to userspace.

> Especially since
> the various parts of the pipeline may stall for a bit so you don't want to lose
> frames. That's not what the overlay API is for, that's what our streaming API
> gives us.
> 
> The use case above isn't even possible without copying. At least, I don't see a
> way, unless the GPU buffer is non-destructive. In that case you can give the
> frame to the GPU, and when the GPU is finished you can give it to the encoder.
> I suspect that might become quite complex though.

Well, if some fb consumers would also be rewriting the buffers, serializing them is
needed, as you can't allow another process to access a memory that CPU is destroying 
at the same time, as you'll have unpredicted images being produced. The easiest
way is to make qbuf() callback block until the end of buffer rewrite, but I
don't think that this is a good idea.

On such situations, it is probably faster and cleaner to just copy data into a
second buffer, keeping the original one preserved.

> Note that many video receivers cannot stall. You can't tell them to wait until
> the last buffer finished processing. This is different from some/most? sensors.
> 
> So if you try to send the input of a video receiver to some device that requires
> syncing which can cause stalls, then that will not work without losing frames.
> Which especially for video encoding is not desirable.

If you're sharing a buffer, kernel should be sure that the shared buffer won't
be rewritten before every shared-buffer consumer doesn't finish handling it.

So, assuming that the producer is generating frames at a rate of, let's say, 30
fps, the slowest consumer should be faster than 1/30 s, otherwise, it will loose
frames.

Yet, if, under certain circumstances (like, for example, input switch from one
source to another, requiring an mpeg2 encoder to re-encode the new scena),
one of the consumer is needing more than 1/30 s, but, at most of the time it runs
bellow the 1/30 s, by using dynamic buffer allocation it is still possible of
using shared buffers without loosing frames, if the machine has enough memory
to handle the worse case.

There's one problem with dynamic buffers, however: audio and video sync becomes 
a more complex task. So, we'll end by needing to add audio timestamps at 
kernelspace, at the alsa driver.

Cheers,
Mauro.
