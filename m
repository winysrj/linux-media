Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:34472 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727830AbeHNK4A (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Aug 2018 06:56:00 -0400
Date: Tue, 14 Aug 2018 05:09:51 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCHv17 08/34] v4l2-dev: lock req_queue_mutex
Message-ID: <20180814050951.359fb230@coco.lan>
In-Reply-To: <6809d5df-6d04-f765-f826-a0e4c0844107@xs4all.nl>
References: <20180804124526.46206-1-hverkuil@xs4all.nl>
        <20180804124526.46206-9-hverkuil@xs4all.nl>
        <20180809170311.31dec60b@coco.lan>
        <6809d5df-6d04-f765-f826-a0e4c0844107@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 10 Aug 2018 09:39:20 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 08/09/2018 10:03 PM, Mauro Carvalho Chehab wrote:
> > Em Sat,  4 Aug 2018 14:45:00 +0200
> > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> >   
> >> From: Hans Verkuil <hans.verkuil@cisco.com>
> >>
> >> We need to serialize streamon/off with queueing new requests.
> >> These ioctls may trigger the cancellation of a streaming
> >> operation, and that should not be mixed with queuing a new
> >> request at the same time.
> >>
> >> Finally close() needs this lock since that too can trigger the
> >> cancellation of a streaming operation.
> >>
> >> We take the req_queue_mutex here before any other locks since
> >> it is a very high-level lock.
> >>
> >> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> >> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> >> ---
> >>  drivers/media/v4l2-core/v4l2-dev.c   | 13 +++++++++++++
> >>  drivers/media/v4l2-core/v4l2-ioctl.c | 22 +++++++++++++++++++++-
> >>  2 files changed, 34 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
> >> index 69e775930fc4..53018e4a4c78 100644
> >> --- a/drivers/media/v4l2-core/v4l2-dev.c
> >> +++ b/drivers/media/v4l2-core/v4l2-dev.c
> >> @@ -444,8 +444,21 @@ static int v4l2_release(struct inode *inode, struct file *filp)
> >>  	struct video_device *vdev = video_devdata(filp);
> >>  	int ret = 0;
> >>  
> >> +	/*
> >> +	 * We need to serialize the release() with queueing new requests.
> >> +	 * The release() may trigger the cancellation of a streaming
> >> +	 * operation, and that should not be mixed with queueing a new
> >> +	 * request at the same time.
> >> +	 */
> >> +	if (v4l2_device_supports_requests(vdev->v4l2_dev))
> >> +		mutex_lock(&vdev->v4l2_dev->mdev->req_queue_mutex);
> >> +
> >>  	if (vdev->fops->release)
> >>  		ret = vdev->fops->release(filp);
> >> +
> >> +	if (v4l2_device_supports_requests(vdev->v4l2_dev))
> >> +		mutex_unlock(&vdev->v4l2_dev->mdev->req_queue_mutex);
> >> +  
> > 
> > This will very likely generate sparse warnings. See my discussions
> > with that regards with Linus.
> > 
> > The only way to avoid it would be to do something like:
> > 
> > 	if (v4l2_device_supports_requests(vdev->v4l2_dev)) {
> > 		mutex_lock(&vdev->v4l2_dev->mdev->req_queue_mutex);
> > 	 	if (vdev->fops->release)
> > 			ret = vdev->fops->release(filp);
> > 		mutex_unlock(&vdev->v4l2_dev->mdev->req_queue_mutex);
> > 	} else {
> > 	 	if (vdev->fops->release)
> > 			ret = vdev->fops->release(filp);
> > 	}  
> 
> I'll check what sparse says and make this change if needed (I hate
> working around sparse warnings).

For reference, see the discussions I had with Linus and Christopher
about this at sparse ML:
	https://www.spinics.net/lists/linux-sparse/msg08069.html

In particular, see this:
	https://www.spinics.net/lists/linux-sparse/msg08071.html
	

(I thought I had c/c media, but it seems that only sparse ML was
c/c).

> 
> >   
> >>  	if (vdev->dev_debug & V4L2_DEV_DEBUG_FOP)
> >>  		dprintk("%s: release\n",
> >>  			video_device_node_name(vdev));
> >> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> >> index 54afc9c7ee6e..ea475d833dd6 100644
> >> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> >> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> >> @@ -2780,6 +2780,7 @@ static long __video_do_ioctl(struct file *file,
> >>  		unsigned int cmd, void *arg)
> >>  {
> >>  	struct video_device *vfd = video_devdata(file);
> >> +	struct mutex *req_queue_lock = NULL;
> >>  	struct mutex *lock; /* ioctl serialization mutex */
> >>  	const struct v4l2_ioctl_ops *ops = vfd->ioctl_ops;
> >>  	bool write_only = false;
> >> @@ -2799,10 +2800,27 @@ static long __video_do_ioctl(struct file *file,
> >>  	if (test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags))
> >>  		vfh = file->private_data;
> >>  
> >> +	/*
> >> +	 * We need to serialize streamon/off with queueing new requests.
> >> +	 * These ioctls may trigger the cancellation of a streaming
> >> +	 * operation, and that should not be mixed with queueing a new
> >> +	 * request at the same time.
> >> +	 */
> >> +	if (v4l2_device_supports_requests(vfd->v4l2_dev) &&
> >> +	    (cmd == VIDIOC_STREAMON || cmd == VIDIOC_STREAMOFF)) {
> >> +		req_queue_lock = &vfd->v4l2_dev->mdev->req_queue_mutex;
> >> +
> >> +		if (mutex_lock_interruptible(req_queue_lock))
> >> +			return -ERESTARTSYS;
> >> +	}
> >> +
> >>  	lock = v4l2_ioctl_get_lock(vfd, vfh, cmd, arg);
> >>  
> >> -	if (lock && mutex_lock_interruptible(lock))
> >> +	if (lock && mutex_lock_interruptible(lock)) {
> >> +		if (req_queue_lock)
> >> +			mutex_unlock(req_queue_lock);
> >>  		return -ERESTARTSYS;
> >> +	}  
> > 
> > Same applies here.  
> 
> I'm not sure there is much that can be done here without making the
> code hard to read. I'll see.

You can have a lock-free routine called by another one with
would set the lock if req_queue_lock.

We ended by doing that at the ddbridge driver.

> 
> >   
> >>  
> >>  	if (!video_is_registered(vfd)) {
> >>  		ret = -ENODEV;
> >> @@ -2861,6 +2879,8 @@ static long __video_do_ioctl(struct file *file,
> >>  unlock:
> >>  	if (lock)
> >>  		mutex_unlock(lock);
> >> +	if (req_queue_lock)
> >> +		mutex_unlock(req_queue_lock);  
> > 
> > This code looks really weird! are you locking in order to get a
> > lock pointer?
> > 
> > That seems broken by design.  
> 
> I've no idea what you mean. Both 'lock' and 'req_queue_lock' are pointers to
> a struct mutex. If NULL, don't unlock, otherwise you need to unlock the mutex
> here since it was locked earlier.
> 
> Did you misread this or should the lock/req_queue_lock names be changed to e.g.
> mutex_ptr/req_queue_mutex_ptr?

Yeah, I misread it. Sorry for the noise.

IMO, it is worth to mention at the req_queue_lock field documentation that
all ioctls calls will hold the req_queue_lock.



> 
> Regards,
> 
> 	Hans
> 
> >   
> >>  	return ret;
> >>  }
> >>    
> > 
> > 
> > 
> > Thanks,
> > Mauro
> >   
> 



Thanks,
Mauro
