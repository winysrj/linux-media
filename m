Return-path: <mchehab@gaivota>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:1910 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296Ab0LNH5r (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Dec 2010 02:57:47 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH 1/8] v4l: add videobuf2 Video for Linux 2 driver framework
Date: Tue, 14 Dec 2010 08:57:35 +0100
Cc: linux-media@vger.kernel.org, pawel@osciak.com,
	kyungmin.park@samsung.com,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>
References: <1291632765-11207-1-git-send-email-m.szyprowski@samsung.com> <201012111754.37066.hverkuil@xs4all.nl> <013201cb9b5e$91195a20$b34c0e60$%szyprowski@samsung.com>
In-Reply-To: <013201cb9b5e$91195a20$b34c0e60$%szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012140857.35474.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Tuesday, December 14, 2010 08:14:32 Marek Szyprowski wrote:
> Hello,
> 
> On Saturday, December 11, 2010 5:55 PM Hans Verkuil wrote:
> 
> Big thanks for the review! I will fix all these minor issues and resend
> the patches soon. I hope we will manage to get videobuf2 merged soon! :)
> 
> > Hi Marek,
> > 
> > Here is my review. I wish I could ack it, but I found a few bugs that need
> > fixing first. Also a bunch of small stuff that's trivial to fix.
> > 
> > On Monday, December 06, 2010 11:52:38 Marek Szyprowski wrote:
> > > From: Pawel Osciak <p.osciak@samsung.com>
> > >
> > > Videobuf2 is a Video for Linux 2 API-compatible driver framework for
> > > multimedia devices. It acts as an intermediate layer between userspace
> > > applications and device drivers. It also provides low-level, modular
> > > memory management functions for drivers.
> > >
> > > Videobuf2 eases driver development, reduces drivers' code size and aids in
> > > proper and consistent implementation of V4L2 API in drivers.
> > >
> > > Videobuf2 memory management backend is fully modular. This allows custom
> > > memory management routines for devices and platforms with non-standard
> > > memory management requirements to be plugged in, without changing the
> > > high-level buffer management functions and API.
> > >
> > > The framework provides:
> > > - implementations of streaming I/O V4L2 ioctls and file operations
> > > - high-level video buffer, video queue and state management functions
> > > - video buffer memory allocation and management
> > >
> > > Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
> > > Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> > > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > > CC: Pawel Osciak <pawel@osciak.com>
> > > ---
> 
> <snip>
> 
> > > +/**
> > > + * __vb2_wait_for_done_vb() - wait for a buffer to become available
> > > + * for dequeuing
> > > + *
> > > + * Will sleep if required for nonblocking == false.
> > > + */
> > > +static int __vb2_wait_for_done_vb(struct vb2_queue *q, int nonblocking)
> > > +{
> > > +	/*
> > > +	 * All operation on vb_done_list is performed under vb_done_lock
> > > +	 * spinlock protection. However buffers may must be removed from
> > > +	 * it and returned to userspace only while holding both driver's
> > > +	 * lock and the vb_done_lock spinlock. Thus we can be sure that as
> > > +	 * long as we hold lock, the list will remain not empty if this
> > > +	 * check succeeds.
> > > +	 */
> > > +
> > > +	for (;;) {
> > > +		int ret;
> > > +
> > > +		if (!q->streaming) {
> > > +			dprintk(1, "Streaming off, will not wait for buffers\n");
> > > +			return -EINVAL;
> > > +		}
> > > +
> > > +		if (!list_empty(&q->done_list)) {
> > > +			/*
> > > +			 * Found a buffer that we were waiting for.
> > > +			 */
> > > +			break;
> > > +		} else if (nonblocking) {
> > 
> > The 'else' keyword can be removed since the 'if' above always breaks.
> > 
> > > +			dprintk(1, "Nonblocking and no buffers to dequeue, "
> > > +								"will not wait\n");
> > > +			return -EAGAIN;
> > > +		}
> > > +
> > > +		/*
> > > +		 * We are streaming and blocking, wait for another buffer to
> > > +		 * become ready or for streamoff. Driver's lock is released to
> > > +		 * allow streamoff or qbuf to be called while waiting.
> > > +		 */
> > > +		call_qop(q, wait_prepare, q);
> > > +
> > > +		/*
> > > +		 * All locks has been released, it is safe to sleep now.
> > > +		 */
> > > +		dprintk(3, "Will sleep waiting for buffers\n");
> > > +		ret = wait_event_interruptible(q->done_wq,
> > > +				!list_empty(&q->done_list) || !q->streaming);
> > > +
> > > +		/*
> > > +		 * We need to reevaluate both conditions again after reacquiring
> > > +		 * the locks or return an error if it occured. In case of error
> > > +		 * we return -EINTR, because -ERESTARTSYS should not be returned
> > > +		 * to userspace.
> > > +		 */
> > > +		call_qop(q, wait_finish, q);
> > > +		if (ret)
> > > +			return -EINTR;
> > 
> > No, this should be -ERESTARTSYS. This won't be returned to userspace, instead
> > the kernel will handle the signal and restart the system call automatically.
> 
> I thought that -ERESTARTSYS should not be returned to userspace, that's why I
> use -EINTR here. What does the comment in linux/errno.h refer to?

Actually, I looked at the wait_event_interruptible code and it already returns
-ERESTARTSYS in case of a signal. So you can just do 'return ret' here.

Anyway, the idea is that if a signal arrived then the driver can return -ERESTARTSYS
to tell the kernel that it should handle the signal and afterwards call the system
call again (restart it). The error code is never returned to userspace.

So userspace should never see this error, instead the kernel will silently handle
this.

Regards,

	Hans

> 
> > > +	}
> > > +	return 0;
> > > +}
> > > +
> 
> Thanks again for your comments!
> 
> 
> Best regards
> --
> Marek Szyprowski
> Samsung Poland R&D Center
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
