Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:53937 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755929Ab2EGLxU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 May 2012 07:53:20 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [ 3960.758784] 1 lock held by motion/7776: [ 3960.758788]  #0:  (&queue->mutex){......}, at: [<ffffffff815c62d2>] uvc_queue_enable+0x32/0xc0
Date: Mon, 7 May 2012 13:52:57 +0200
Cc: Sander Eikelenboom <linux@eikelenboom.it>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, hans.verkuil@cisco.com
References: <4410483770.20120428220246@eikelenboom.it> <201205071344.59861.hverkuil@xs4all.nl> <190915616.lpsK6E9b1z@avalon>
In-Reply-To: <190915616.lpsK6E9b1z@avalon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205071352.57292.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 07 May 2012 13:47:45 Laurent Pinchart wrote:
> Hi Hans,
> 
> On Monday 07 May 2012 13:44:59 Hans Verkuil wrote:
> > On Monday 07 May 2012 13:06:01 Laurent Pinchart wrote:
> > > On Sunday 06 May 2012 16:54:40 Sander Eikelenboom wrote:
> > > > Hello Laurent / Mauro,
> > > > 
> > > > I have updated to latest 3.4-rc5-tip, running multiple video grabbers.
> > > > I don't see anything specific to uvcvideo anymore, but i do get the
> > > > possible circular locking dependency below.
> > > 
> > > Thanks for the report.
> > > 
> > > We indeed have a serious issue there (CC'ing Hans Verkuil).
> > > 
> > > Hans, serializing both ioctl handling an mmap with a single device lock as
> > > we currently do in V4L2 is prone to AB-BA deadlocks (uvcvideo shouldn't
> > > be affected as it has no device-wide lock).
> > > 
> > > If we want to keep a device-wide lock we need to take it after the mm-
> > > 
> > > >mmap_sem lock in all code paths, as there's no way we can change the lock
> > > 
> > > ordering for mmap(). The copy_from_user/copy_to_user issue could be solved
> > > by moving locking from v4l2_ioctl to __video_do_ioctl (device-wide locks
> > > would then require using video_ioctl2), but I'm not sure whether that
> > > will play nicely with the QBUF implementation in videobuf2 (which already
> > > includes a workaround for this particular AB-BA deadlock issue).
> > 
> > I've seen the same thing. It was on my TODO list of things to look into. I
> > think mmap shouldn't take the device wide lock at all. But it will mean
> > reviewing affected drivers before I can remove it.
> > 
> > To be honest, I wasn't sure whether or not to take the device lock for mmap
> > when I first wrote that code.
> >
> > If you look at irc I had a discussion today with HdG about adding flags to
> > selectively disable locks for fops. It may be an idea to implement this soon
> > so we can start updating drivers one-by-one.
> > 
> > Frankly, I do not believe this 'possible circular locking' thing to be a
> > real bug as I am not aware of drivers that use the device lock *and* lock
> > mmap_sem. If I understand Sander correctly 'motion' no longer locks up
> > after moving to 3.4-rc5-tip, right?
> 
> copy_from_user()/copy_to_user() perform a down_read(&mm->mmap_sem) when a page 
> fault occurs. All drivers thus potentially take mm->mmap_sem when an ioctl is 
> performed.

Ah, I didn't know that. Interesting.

Regards,

	Hans

>  
> > I have to look into a bit more to see what the best approach it so we can
> > prevent this message from appearing.
> 
> 
