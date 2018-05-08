Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:35912 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751209AbeEHKpf (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 May 2018 06:45:35 -0400
Date: Tue, 8 May 2018 07:45:28 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv13 06/28] v4l2-dev: lock req_queue_mutex
Message-ID: <20180508074528.10e5c8cd@vento.lan>
In-Reply-To: <f33821d6-3105-4ac0-ca86-36024463bec9@xs4all.nl>
References: <20180503145318.128315-1-hverkuil@xs4all.nl>
        <20180503145318.128315-7-hverkuil@xs4all.nl>
        <20180507142037.1a49d58b@vento.lan>
        <f33821d6-3105-4ac0-ca86-36024463bec9@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 8 May 2018 09:45:27 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 05/07/2018 07:20 PM, Mauro Carvalho Chehab wrote:
> > Em Thu,  3 May 2018 16:52:56 +0200
> > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> >   
> >> From: Hans Verkuil <hans.verkuil@cisco.com>
> >>
> >> We need to serialize streamon/off with queueing new requests.
> >> These ioctls may trigger the cancellation of a streaming
> >> operation, and that should not be mixed with queuing a new
> >> request at the same time.
> >>
> >> Also TRY/S_EXT_CTRLS needs this lock to correctly serialize
> >> with MEDIA_REQUEST_IOC_QUEUE.
> >>
> >> Finally close() needs this lock since that too can trigger the
> >> cancellation of a streaming operation.
> >>
> >> We take the req_queue_mutex here before any other locks since
> >> it is a very high-level lock.
> >>
> >> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> >> ---
> >>  drivers/media/v4l2-core/v4l2-dev.c | 37 +++++++++++++++++++++++++++++-
> >>  1 file changed, 36 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
> >> index 1d0b2208e8fb..b1c9efc0ecc4 100644
> >> --- a/drivers/media/v4l2-core/v4l2-dev.c
> >> +++ b/drivers/media/v4l2-core/v4l2-dev.c
> >> @@ -353,13 +353,36 @@ static long v4l2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
> >>  
> >>  	if (vdev->fops->unlocked_ioctl) {
> >>  		struct mutex *lock = v4l2_ioctl_get_lock(vdev, cmd);
> >> +		struct mutex *queue_lock = NULL;
> >>  
> >> -		if (lock && mutex_lock_interruptible(lock))
> >> +		/*
> >> +		 * We need to serialize streamon/off with queueing new requests.
> >> +		 * These ioctls may trigger the cancellation of a streaming
> >> +		 * operation, and that should not be mixed with queueing a new
> >> +		 * request at the same time.
> >> +		 *
> >> +		 * Also TRY/S_EXT_CTRLS needs this lock to correctly serialize
> >> +		 * with MEDIA_REQUEST_IOC_QUEUE.
> >> +		 */
> >> +		if (vdev->v4l2_dev->mdev &&
> >> +		    (cmd == VIDIOC_STREAMON || cmd == VIDIOC_STREAMOFF ||
> >> +		     cmd == VIDIOC_S_EXT_CTRLS || cmd == VIDIOC_TRY_EXT_CTRLS))
> >> +			queue_lock = &vdev->v4l2_dev->mdev->req_queue_mutex;
> >> +
> >> +		if (queue_lock && mutex_lock_interruptible(queue_lock))
> >> +			return -ERESTARTSYS;  
> > 
> > Taking both locks seems risky. Here you're taking first v4l2 lock, returned
> > by v4l2_ioctl_get_lock(vdev, cmd), and then you're taking the req_queue lock.  
> 
> No,  v4l2_ioctl_get_lock() only returns a pointer to a mutex, it doesn't lock
> anything. I think you got confused there. I'll reorganize the code a bit so
> the call to  v4l2_ioctl_get_lock() happens after the queue_lock has been taken.

Yeah, I didn't actually look at the implementation of v4l2_ioctl_get_lock().

As we're using "_get" along this patch series to increment krefs (with is
a sort of locking), the name here confused me. IMHO, we should rename it
to v4l2_ioctl_return_lock() (or similar) on some future, in order to avoid
confusion.

> I'll also rename queue_lock to req_queue_lock (it's a bit more descriptive).

Agreed.

> 
> So we first take the high-level media_device req_queue_mutex if needed, and
> then the ioctl serialization lock. Doing it the other way around will indeed
> promptly deadlock (as I very quickly discovered after my initial implementation!).
> 
> So the order is:
> 
> 	req_queue_mutex (serialize request state changes from/to IDLE)
> 	ioctl lock (serialize ioctls)
> 	request->lock (spinlock)
> 
> The last is only held for short periods when updating the media_request struct.
> 
> > 
> > It is possible to call parts of the code that only handles req_queue
> > or v4l2 lock (for example, by mixing request API calls with non-requests
> > one). Worse than that, there are parts of the code where the request API
> > patches get both a mutex and a spin lock.
> > 
> > I didn't look too closely (nor ran any test), but I'm almost sure that
> > there are paths where it will end by leading into dead locks.  
> 
> I've done extensive testing with this and actually been very careful about
> the lock handling. It's also been tested with the cedrus driver.

I don't doubt it works using your apps, but real life can be messier:
people could be issuing ioctls at different orders, programs can abort
any time, closing file descriptors at random times, threads can be
used to paralelize ioctls, etc.

That not discarding the possibility of someone coming with some
ingenious code meant to cause machine hangups or to exposure some
other security flaws.



Thanks,
Mauro
