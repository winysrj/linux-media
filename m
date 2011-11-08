Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:49833 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755210Ab1KHPO2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Nov 2011 10:14:28 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Received: from euspt2 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LUC00IMSL01P080@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 08 Nov 2011 15:14:26 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LUC00AB4L0134@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 08 Nov 2011 15:14:25 +0000 (GMT)
Date: Tue, 08 Nov 2011 16:14:25 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH] media: vb2: vmalloc-based allocator user pointer handling
In-reply-to: <201111081543.43122.laurent.pinchart@ideasonboard.com>
To: 'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	linux-media@vger.kernel.org,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	'Pawel Osciak' <pawel@osciak.com>
Message-id: <006a01cc9e29$19da33c0$4d8e9b40$%szyprowski@samsung.com>
Content-language: pl
References: <1320231122-22518-1-git-send-email-andrzej.p@samsung.com>
 <201111081501.00656.laurent.pinchart@ideasonboard.com>
 <004e01cc9e22$c1c0b390$45421ab0$%szyprowski@samsung.com>
 <201111081543.43122.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Tuesday, November 08, 2011 3:44 PM Laurent Pinchart wrote:
> On Tuesday 08 November 2011 15:29:00 Marek Szyprowski wrote:
> > On Tuesday, November 08, 2011 3:01 PM Laurent Pinchart wrote:
> > > On Tuesday 08 November 2011 14:57:40 Marek Szyprowski wrote:
> > > > On Tuesday, November 08, 2011 12:32 PM Laurent Pinchart wrote:
> > > > > On Thursday 03 November 2011 08:40:26 Marek Szyprowski wrote:
> > > > > > On Wednesday, November 02, 2011 2:54 PM Laurent Pinchart wrote:
> 
> [snip]
> 
> > > > > > > This can cause an AB-BA deadlock, and will be reported by
> > > > > > > deadlock detection if enabled.
> > > > > > >
> > > > > > > The issue is that the mmap() handler is called by the MM core
> > > > > > > with current->mm->mmap_sem held, and then takes the driver's
> > > > > > > lock before calling videobuf2's mmap handler. The VIDIOC_QBUF
> > > > > > > handler, on the other hand, will first take the driver's lock
> > > > > > > and will then try to take current->mm->mmap_sem here.
> > > > > > >
> > > > > > > This can result in a deadlock if both MMAP and USERPTR buffers
> > > > > > > are used by the same driver at the same time.
> > > > > > >
> > > > > > > If we assume that MMAP and USERPTR buffers can't be used on the
> > > > > > > same queue at the same time (VIDIOC_CREATEBUFS doesn't allow
> > > > > > > that if I'm not mistaken, so we should be safe, at least for
> > > > > > > now), this can be fixed by having a per-queue lock in the driver
> > > > > > > instead of a global device lock. However, that means that
> > > > > > > drivers that want to support USERPTR will not be allowed to
> > > > > > > delegate lock handling to the V4L2 core and
> > > > > > > video_ioctl2().
> > > > > >
> > > > > > Thanks for pointing this issue! This problem is already present in
> > > > > > the other videobuf2 memory allocators as well as the old videobuf
> > > > > > and other v4l2 drivers which implement queue handling by
> > > > > > themselves.
> > > > >
> > > > > The problem is present in most (but not all) drivers, yes. That's one
> > > > > more reason to fix it in videobuf2 :-)
> > > > >
> > > > > > The only solution that will not complicate the videobuf2 and
> > > > > > allocators code is to move taking current->mm->mmap_sem lock into
> > > > > > videobuf2 core. Before acquiring this lock, vb2 calls wait_prepare
> > > > > > to release device lock and then once mmap_sem is locked, calls
> > > > > > wait_finish to get it again. This way the deadlock is avoided and
> > > > > > allocators are free to call
> > > > > > get_user_pages() without further messing with locks. The only
> > > > > > drawback is the fact that a bit more code will be executed under
> > > > > > mmap_sem lock.
> > > > > >
> > > > > > What do you think about such solution?
> > > > >
> > > > > Won't that create a race condition ? Wouldn't an application for
> > > > > instance be able to call VIDIOC_REQBUFS(0) during the time window
> > > > > where the device lock is released ?
> > > >
> > > > Hmm... Right...
> > > >
> > > > The only solution I see now is to move acquiring mmap_sem as early as
> > > > possible to make the possible race harmless. The first operation in
> > > > vb2_qbuf will be then:
> > > >
> > > > if (b->memory == V4L2_MEMORY_USERPTR) {
> > > >
> > > >        call_qop(q, wait_prepare, q);
> > > >        down_read(&current->mm->mmap_sem);
> > > >        call_qop(q, wait_finish, q);
> > > >
> > > > }
> > > >
> > > > This should solve the race although all userptr buffers will be handled
> > > > under mmap_sem lock. Do you have any other idea?
> > >
> > > If queues don't mix MMAP and USERPTR buffers (is that something we want
> > > to allow ?), wouldn't using a per-queue lock instead of a device-wide
> > > lock be a better way to fix the problem ?
> >
> > It is not really about allowing mixing MMAP & USERPTR. Even if your
> > application use only USRPTR  buffers, a malicious task might open the video
> > node and call mmap operation what might cause a deadlock in certain rare
> > cases.
> 
> Right :-/
> 
> The mmap() call would fail, but it still takes the lock before failing.
> 
> Would there be a way to make mmap() fail on queues configured for USERPTR
> without taking the lock ?

The problem is the fact that mmap_sem is taken first by the kernel core before
calling driver's mmap method and you can do nothing about it. You also cannot
release mmap_sem lock in mmap method and take it again to avoid deadlock because
you will exchange one race (ioctl race) into another (mmap vs. other user memory
related functions).

> > I'm against adding internal locks to vb2 queue. Avoiding deadlocks will be
> > a nightmare when you will try to handle or synchronize more than one queue
> > in a single call...
> 
> I wasn't proposing adding internal locks to vb2 queue, but using per-queue
> locks inside the driver. vb2 would still not handle locking itself.

How will it solve the issue? mmap_sem is taken by the kernel core for calling
mmap method, where you need to take your driver/queue lock(s) and preform the
operation. In qbuf you usually take your driver/queue lock(s) first and then 
you would like to take mmap_sem to grab userpages...

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center

