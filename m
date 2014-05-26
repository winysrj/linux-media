Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50835 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbaEZWiJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 May 2014 18:38:09 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	linux-media@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>,
	Katsuya MATSUBARA <matsu@igel.co.jp>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-sh@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Dave Jones <davej@redhat.com>
Subject: Re: [PATCH v7] media: vb2: Take queue or device lock in mmap-related vb2 ioctl handlers
Date: Tue, 27 May 2014 00:38:28 +0200
Message-ID: <2615961.FSN4tf4yDh@avalon>
In-Reply-To: <537F5315.8030705@xs4all.nl>
References: <201308061239.27188.hverkuil@xs4all.nl> <1375819848-2658-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <537F5315.8030705@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Friday 23 May 2014 15:54:29 Hans Verkuil wrote:
> Hi Laurent,
> 
> This patch caused a circular locking dependency as reported by Sasha Levin:
> 
> https://lkml.org/lkml/2014/5/5/366
> 
> The reason is that copy_to/from_user is called in video_usercopy() with the
> core lock held. The copy functions can fault which takes the mmap_sem. If it
> was just video_usercopy() then it would be fairly easy to solve this, but
> the copy_to_/from_user functions are also called from read and write and
> they can be used in other unexpected places.
> 
> I'm not sure if vb2_fop_get_unmapped_area() is a problem. I suspect (but I'm
> not sure) that when that one is called the mmap_sem isn't taken, in which
> case taking the lock is fine.
> 
> But taking the lock in vb2_fop_mmap() does cause lockdep problems.
> 
> Ideally I would like to drop taking that lock in vb2_fop_mmap and resolve
> the race condition that it intended to fix in a different way.

I'm of course fine with a different way to solve the race condition, if we can 
find a good one. Do you already know how you would like to solve this ?

> On 08/06/2013 10:10 PM, Laurent Pinchart wrote:
> > The vb2_fop_mmap() and vb2_fop_get_unmapped_area() functions are plug-in
> > implementation of the mmap() and get_unmapped_area() file operations
> > that calls vb2_mmap() and vb2_get_unmapped_area() on the queue
> > associated with the video device. Neither the
> > vb2_fop_mmap/vb2_fop_get_unmapped_area nor the
> > v4l2_mmap/vb2_get_unmapped_area functions in the V4L2 core take any
> > lock, leading to race conditions between mmap/get_unmapped_area and
> > other buffer-related ioctls such as VIDIOC_REQBUFS.
> > 
> > Fix it by taking the queue or device lock around the vb2_mmap() and
> > vb2_get_unmapped_area() calls.
> > 
> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>
> > ---
> > 
> >  drivers/media/v4l2-core/videobuf2-core.c | 18 ++++++++++++++++--
> >  1 file changed, 16 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/media/v4l2-core/videobuf2-core.c
> > b/drivers/media/v4l2-core/videobuf2-core.c index 9fc4bab..c9b50c7 100644
> > --- a/drivers/media/v4l2-core/videobuf2-core.c
> > +++ b/drivers/media/v4l2-core/videobuf2-core.c
> > @@ -2578,8 +2578,15 @@ EXPORT_SYMBOL_GPL(vb2_ioctl_expbuf);
> > 
> >  int vb2_fop_mmap(struct file *file, struct vm_area_struct *vma)
> >  {
> >  
> >  	struct video_device *vdev = video_devdata(file);
> > 
> > +	struct mutex *lock = vdev->queue->lock ? vdev->queue->lock : vdev-
>lock;
> > +	int err;
> > 
> > -	return vb2_mmap(vdev->queue, vma);
> > +	if (lock && mutex_lock_interruptible(lock))
> > +		return -ERESTARTSYS;
> > +	err = vb2_mmap(vdev->queue, vma);
> > +	if (lock)
> > +		mutex_unlock(lock);
> > +	return err;
> > 
> >  }
> >  EXPORT_SYMBOL_GPL(vb2_fop_mmap);
> > 
> > @@ -2685,8 +2692,15 @@ unsigned long vb2_fop_get_unmapped_area(struct file
> > *file, unsigned long addr,> 
> >  		unsigned long len, unsigned long pgoff, unsigned long flags)
> >  
> >  {
> >  
> >  	struct video_device *vdev = video_devdata(file);
> > 
> > +	struct mutex *lock = vdev->queue->lock ? vdev->queue->lock : vdev-
>lock;
> > +	int ret;
> > 
> > -	return vb2_get_unmapped_area(vdev->queue, addr, len, pgoff, flags);
> > +	if (lock && mutex_lock_interruptible(lock))
> > +		return -ERESTARTSYS;
> > +	ret = vb2_get_unmapped_area(vdev->queue, addr, len, pgoff, flags);
> > +	if (lock)
> > +		mutex_unlock(lock);
> > +	return ret;
> > 
> >  }
> >  EXPORT_SYMBOL_GPL(vb2_fop_get_unmapped_area);
> >  #endif

-- 
Regards,

Laurent Pinchart

