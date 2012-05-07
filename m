Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58974 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155Ab2EGLGC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 May 2012 07:06:02 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sander Eikelenboom <linux@eikelenboom.it>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, hans.verkuil@cisco.com
Subject: Re: [ 3960.758784] 1 lock held by motion/7776: [ 3960.758788]  #0:  (&queue->mutex){......}, at: [<ffffffff815c62d2>] uvc_queue_enable+0x32/0xc0
Date: Mon, 07 May 2012 13:06:01 +0200
Message-ID: <1363463.HQ7LJLv1Qi@avalon>
In-Reply-To: <21221178.20120506165440@eikelenboom.it>
References: <4410483770.20120428220246@eikelenboom.it> <2518039.lgsMPaBqUJ@avalon> <21221178.20120506165440@eikelenboom.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sanser,

On Sunday 06 May 2012 16:54:40 Sander Eikelenboom wrote:
> Hello Laurent / Mauro,
> 
> I have updated to latest 3.4-rc5-tip, running multiple video grabbers.
> I don't see anything specific to uvcvideo anymore, but i do get the possible
> circular locking dependency below.

Thanks for the report.

We indeed have a serious issue there (CC'ing Hans Verkuil).

Hans, serializing both ioctl handling an mmap with a single device lock as we 
currently do in V4L2 is prone to AB-BA deadlocks (uvcvideo shouldn't be 
affected as it has no device-wide lock).

If we want to keep a device-wide lock we need to take it after the mm-
>mmap_sem lock in all code paths, as there's no way we can change the lock 
ordering for mmap(). The copy_from_user/copy_to_user issue could be solved by 
moving locking from v4l2_ioctl to __video_do_ioctl (device-wide locks would 
then require using video_ioctl2), but I'm not sure whether that will play 
nicely with the QBUF implementation in videobuf2 (which already includes a 
workaround for this particular AB-BA deadlock issue).

> [   96.257129] ======================================================
> [   96.257129] [ INFO: possible circular locking dependency detected ]
> [   96.257129] 3.4.0-rc5-20120506+ #4 Not tainted
> [   96.257129] -------------------------------------------------------
> [   96.257129] motion/2289 is trying to acquire lock:
> [   96.257129]  (&dev->lock){+.+.+.}, at: [<ffffffff8156c04c>]
> v4l2_mmap+0xbc/0xd0
> [   96.257129]
> [   96.257129] but task is already holding lock:
> [   96.257129]  (&mm->mmap_sem){++++++}, at: [<ffffffff81113cca>]
> sys_mmap_pgoff+0x1ca/0x220
> [   96.257129]
> [   96.257129] which lock already depends on the new lock.
> [   96.257129]
> [   96.257129]
> [   96.257129] the existing dependency chain (in reverse order) is:
> [   96.257129]
> [   96.257129] -> #1 (&mm->mmap_sem){++++++}:
> [   96.257129]        [<ffffffff810aa972>] __lock_acquire+0x3a2/0xc50
> [   96.257129]        [<ffffffff810ab2e8>] lock_acquire+0xc8/0x110
> [   96.257129]        [<ffffffff81108cb8>] might_fault+0x68/0x90
> [   96.257129]        [<ffffffff8156d2a1>] video_usercopy+0x1d1/0x4e0
> [   96.257129]        [<ffffffff8156d5c0>] video_ioctl2+0x10/0x20
> [   96.257129]        [<ffffffff8156c110>] v4l2_ioctl+0xb0/0x180
> [   96.257129]        [<ffffffff8114dc3c>] do_vfs_ioctl+0x9c/0x580
> [   96.257129]        [<ffffffff8114e16a>] sys_ioctl+0x4a/0x80
> [   96.257129]        [<ffffffff81813039>] system_call_fastpath+0x16/0x1b
> [   96.257129]
> [   96.257129] -> #0 (&dev->lock){+.+.+.}:
> [   96.257129]        [<ffffffff810aa529>] validate_chain+0x1259/0x1300
> [   96.257129]        [<ffffffff810aa972>] __lock_acquire+0x3a2/0xc50
> [   96.257129]        [<ffffffff810ab2e8>] lock_acquire+0xc8/0x110
> [   96.257129]        [<ffffffff8180e58c>]
> mutex_lock_interruptible_nested+0x5c/0x550
> [   96.257129]        [<ffffffff8156c04c>] v4l2_mmap+0xbc/0xd0
> [   96.257129]        [<ffffffff8111359a>] mmap_region+0x3da/0x5a0
> [   96.257129]        [<ffffffff81113ab4>] do_mmap_pgoff+0x354/0x3a0
> [   96.257129]        [<ffffffff81113ce9>] sys_mmap_pgoff+0x1e9/0x220
> [   96.257129]        [<ffffffff81011ee9>] sys_mmap+0x29/0x30
> [   96.257129]        [<ffffffff81813039>] system_call_fastpath+0x16/0x1b
> [   96.257129]
> [   96.257129] other info that might help us debug this:
> [   96.257129]
> [   96.257129]  Possible unsafe locking scenario:
> [   96.257129]
> [   96.257129]        CPU0                    CPU1
> [   96.257129]        ----                    ----
> [   96.257129]   lock(&mm->mmap_sem);
> [   96.257129]                                lock(&dev->lock);
> [   96.257129]                                lock(&mm->mmap_sem);
> [   96.257129]   lock(&dev->lock);
> [   96.257129]
> [   96.257129]  *** DEADLOCK ***
> [   96.257129]
> [   96.257129] 1 lock held by motion/2289:
> [   96.257129]  #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff81113cca>]
> sys_mmap_pgoff+0x1ca/0x220
> [   96.257129]
> [   96.257129] stack backtrace:
> [   96.257129] Pid: 2289, comm: motion Not tainted 3.4.0-rc5-20120506+ #4
> [   96.257129] Call Trace:
> [   96.257129]  [<ffffffff810a8fb6>] print_circular_bug+0x206/0x300
> [   96.257129]  [<ffffffff810aa529>] validate_chain+0x1259/0x1300
> [   96.257129]  [<ffffffff810a9417>] ? validate_chain+0x147/0x1300
> [   96.257129]  [<ffffffff810ab773>] ? lock_release+0x113/0x260
> [   96.257129]  [<ffffffff810aa972>] __lock_acquire+0x3a2/0xc50
> [   96.257129]  [<ffffffff810aa993>] ? __lock_acquire+0x3c3/0xc50
> [   96.257129]  [<ffffffff8156024c>] ? tda18271_tune+0x71c/0x9c0
> [   96.257129]  [<ffffffff810ab2e8>] lock_acquire+0xc8/0x110
> [   96.257129]  [<ffffffff8156c04c>] ? v4l2_mmap+0xbc/0xd0
> [   96.257129]  [<ffffffff8180e58c>]
> mutex_lock_interruptible_nested+0x5c/0x550
> [   96.257129]  [<ffffffff8156c04c>] ? v4l2_mmap+0xbc/0xd0
> [   96.257129]  [<ffffffff810a77ce>] ? mark_held_locks+0x9e/0x130
> [   96.257129]  [<ffffffff8156c04c>] ? v4l2_mmap+0xbc/0xd0
> [   96.257129]  [<ffffffff811134de>] ? mmap_region+0x31e/0x5a0
> [   96.257129]  [<ffffffff810a7900>] ? lockdep_trace_alloc+0xa0/0x130
> [   96.257129]  [<ffffffff8156c04c>] v4l2_mmap+0xbc/0xd0
> [   96.257129]  [<ffffffff8111359a>] mmap_region+0x3da/0x5a0
> [   96.257129]  [<ffffffff81113ab4>] do_mmap_pgoff+0x354/0x3a0
> [   96.257129]  [<ffffffff81113ce9>] sys_mmap_pgoff+0x1e9/0x220
> [   96.257129]  [<ffffffff8132554e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> [   96.257129]  [<ffffffff81011ee9>] sys_mmap+0x29/0x30

-- 
Regards,

Laurent Pinchart

