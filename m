Return-path: <linux-media-owner@vger.kernel.org>
Received: from static.121.164.40.188.clients.your-server.de ([188.40.164.121]:38296
	"EHLO smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904Ab2EFOyo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 May 2012 10:54:44 -0400
Date: Sun, 6 May 2012 16:54:40 +0200
From: Sander Eikelenboom <linux@eikelenboom.it>
Message-ID: <21221178.20120506165440@eikelenboom.it>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Subject: Re: [ 3960.758784] 1 lock held by motion/7776: [ 3960.758788]  #0:  (&queue->mutex){......}, at: [<ffffffff815c62d2>] uvc_queue_enable+0x32/0xc0
In-Reply-To: <2518039.lgsMPaBqUJ@avalon>
References: <4410483770.20120428220246@eikelenboom.it> <2518039.lgsMPaBqUJ@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Laurent / Mauro,

I have updated to latest 3.4-rc5-tip, running multiple video grabbers.
I don't see anything specific to uvcvideo anymore, but i do get the possible circular locking dependency below.


--
Sander


[   96.257129] ======================================================
[   96.257129] [ INFO: possible circular locking dependency detected ]
[   96.257129] 3.4.0-rc5-20120506+ #4 Not tainted
[   96.257129] -------------------------------------------------------
[   96.257129] motion/2289 is trying to acquire lock:
[   96.257129]  (&dev->lock){+.+.+.}, at: [<ffffffff8156c04c>] v4l2_mmap+0xbc/0xd0
[   96.257129]
[   96.257129] but task is already holding lock:
[   96.257129]  (&mm->mmap_sem){++++++}, at: [<ffffffff81113cca>] sys_mmap_pgoff+0x1ca/0x220
[   96.257129]
[   96.257129] which lock already depends on the new lock.
[   96.257129]
[   96.257129]
[   96.257129] the existing dependency chain (in reverse order) is:
[   96.257129]
[   96.257129] -> #1 (&mm->mmap_sem){++++++}:
[   96.257129]        [<ffffffff810aa972>] __lock_acquire+0x3a2/0xc50
[   96.257129]        [<ffffffff810ab2e8>] lock_acquire+0xc8/0x110
[   96.257129]        [<ffffffff81108cb8>] might_fault+0x68/0x90
[   96.257129]        [<ffffffff8156d2a1>] video_usercopy+0x1d1/0x4e0
[   96.257129]        [<ffffffff8156d5c0>] video_ioctl2+0x10/0x20
[   96.257129]        [<ffffffff8156c110>] v4l2_ioctl+0xb0/0x180
[   96.257129]        [<ffffffff8114dc3c>] do_vfs_ioctl+0x9c/0x580
[   96.257129]        [<ffffffff8114e16a>] sys_ioctl+0x4a/0x80
[   96.257129]        [<ffffffff81813039>] system_call_fastpath+0x16/0x1b
[   96.257129]
[   96.257129] -> #0 (&dev->lock){+.+.+.}:
[   96.257129]        [<ffffffff810aa529>] validate_chain+0x1259/0x1300
[   96.257129]        [<ffffffff810aa972>] __lock_acquire+0x3a2/0xc50
[   96.257129]        [<ffffffff810ab2e8>] lock_acquire+0xc8/0x110
[   96.257129]        [<ffffffff8180e58c>] mutex_lock_interruptible_nested+0x5c/0x550
[   96.257129]        [<ffffffff8156c04c>] v4l2_mmap+0xbc/0xd0
[   96.257129]        [<ffffffff8111359a>] mmap_region+0x3da/0x5a0
[   96.257129]        [<ffffffff81113ab4>] do_mmap_pgoff+0x354/0x3a0
[   96.257129]        [<ffffffff81113ce9>] sys_mmap_pgoff+0x1e9/0x220
[   96.257129]        [<ffffffff81011ee9>] sys_mmap+0x29/0x30
[   96.257129]        [<ffffffff81813039>] system_call_fastpath+0x16/0x1b
[   96.257129]
[   96.257129] other info that might help us debug this:
[   96.257129]
[   96.257129]  Possible unsafe locking scenario:
[   96.257129]
[   96.257129]        CPU0                    CPU1
[   96.257129]        ----                    ----
[   96.257129]   lock(&mm->mmap_sem);
[   96.257129]                                lock(&dev->lock);
[   96.257129]                                lock(&mm->mmap_sem);
[   96.257129]   lock(&dev->lock);
[   96.257129]
[   96.257129]  *** DEADLOCK ***
[   96.257129]
[   96.257129] 1 lock held by motion/2289:
[   96.257129]  #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff81113cca>] sys_mmap_pgoff+0x1ca/0x220
[   96.257129]
[   96.257129] stack backtrace:
[   96.257129] Pid: 2289, comm: motion Not tainted 3.4.0-rc5-20120506+ #4
[   96.257129] Call Trace:
[   96.257129]  [<ffffffff810a8fb6>] print_circular_bug+0x206/0x300
[   96.257129]  [<ffffffff810aa529>] validate_chain+0x1259/0x1300
[   96.257129]  [<ffffffff810a9417>] ? validate_chain+0x147/0x1300
[   96.257129]  [<ffffffff810ab773>] ? lock_release+0x113/0x260
[   96.257129]  [<ffffffff810aa972>] __lock_acquire+0x3a2/0xc50
[   96.257129]  [<ffffffff810aa993>] ? __lock_acquire+0x3c3/0xc50
[   96.257129]  [<ffffffff8156024c>] ? tda18271_tune+0x71c/0x9c0
[   96.257129]  [<ffffffff810ab2e8>] lock_acquire+0xc8/0x110
[   96.257129]  [<ffffffff8156c04c>] ? v4l2_mmap+0xbc/0xd0
[   96.257129]  [<ffffffff8180e58c>] mutex_lock_interruptible_nested+0x5c/0x550
[   96.257129]  [<ffffffff8156c04c>] ? v4l2_mmap+0xbc/0xd0
[   96.257129]  [<ffffffff810a77ce>] ? mark_held_locks+0x9e/0x130
[   96.257129]  [<ffffffff8156c04c>] ? v4l2_mmap+0xbc/0xd0
[   96.257129]  [<ffffffff811134de>] ? mmap_region+0x31e/0x5a0
[   96.257129]  [<ffffffff810a7900>] ? lockdep_trace_alloc+0xa0/0x130
[   96.257129]  [<ffffffff8156c04c>] v4l2_mmap+0xbc/0xd0
[   96.257129]  [<ffffffff8111359a>] mmap_region+0x3da/0x5a0
[   96.257129]  [<ffffffff81113ab4>] do_mmap_pgoff+0x354/0x3a0
[   96.257129]  [<ffffffff81113ce9>] sys_mmap_pgoff+0x1e9/0x220
[   96.257129]  [<ffffffff8132554e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   96.257129]  [<ffffffff81011ee9>] sys_mmap+0x29/0x30








Monday, April 30, 2012, 1:05:27 AM, you wrote:

> Hi Sander,

> On Saturday 28 April 2012 22:02:46 Sander Eikelenboom wrote:
>> Hi,
>> 
>> I'm using a webcam (logitech) supported by the uvcvideo module to capture
>> video. Previously once in a while I would get the "uvcvideo: Failed to
>> resubmit video URB (-27).", but the grabbing continued without a problem.
>> Now the video grabbing program (motion) seems to lock due to some nested
>> lock if i interpret it right.

> The uvcvideo driver doesn't use nested locks, this is "just" a normal locking 
> issue. The mutex_lock_nested() call in the backtrace comes from lock debugging 
> support in your kernel.

> A quick look at the code doesn't reveal any obvious locking issue. Do you have 
> multiple threads accessing the device at the same time ?

>> Additional problem is that i don't really know what kernel version was still
>> OK, so can't help with that info.
>> 
>> This is on a vanilla 3.4 RC kernel latest commit:
>> c629eaf8392b676b4f83c3dc344e66402bfeec92
>>
>> [ 3696.753490] ehci_hcd 0000:09:00.1: request ffff880016091400 would
>> overflow (3923+31 >= 3936) [ 3696.753494] uvcvideo: Failed to resubmit
>> video URB (-27).
>> [ 3696.753563] ehci_hcd 0000:09:00.1: request ffff880016091800 would
>> overflow (3922+31 >= 3936) [ 3696.753566] uvcvideo: Failed to resubmit
>> video URB (-27).
>> [ 3696.753609] ehci_hcd 0000:09:00.1: request ffff880016090800 would
>> overflow (3922+31 >= 3936) [ 3696.753611] uvcvideo: Failed to resubmit
>> video URB (-27).
>> [ 3696.753645] ehci_hcd 0000:09:00.1: request ffff880016090c00 would
>> overflow (3922+31 >= 3936) [ 3696.753647] uvcvideo: Failed to resubmit
>> video URB (-27).
>> [ 3696.753656] ehci_hcd 0000:09:00.1: request ffff880016091000 would
>> overflow (3922+31 >= 3936) [ 3696.753657] uvcvideo: Failed to resubmit
>> video URB (-27).
>> [ 3960.758154] INFO: task motion:7776 blocked for more than 120 seconds.
>> [ 3960.758168] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
>> this message. [ 3960.758174] motion          D 0000000000000201     0  7776
>>      1 0x00000000 [ 3960.758183]  ffff8800239d9b68 0000000000000216
>> ffffea0000a50018 ffffffff810a451b [ 3960.758192]  ffff88002392cf60
>> 0000000000012600 ffff8800239d9fd8 ffff8800239d8010 [ 3960.758200] 
>> 0000000000012600 0000000000012600 ffff8800239d9fd8 0000000000012600 [
>> 3960.758209] Call Trace:
>> [ 3960.758219]  [<ffffffff810a451b>] ? __lock_acquire+0x5b/0xc00
>> [ 3960.758226]  [<ffffffff814e0048>] ? hub_suspend+0xf8/0x130
>> [ 3960.758232]  [<ffffffff814f0024>] ? usbdev_do_ioctl+0x194/0x1000
>> [ 3960.758238]  [<ffffffff810a451b>] ? __lock_acquire+0x5b/0xc00
>> [ 3960.758244]  [<ffffffff8108ba01>] ? get_parent_ip+0x11/0x50
>> [ 3960.758250]  [<ffffffff8108d6cd>] ? sub_preempt_count+0x9d/0xd0
>> [ 3960.758257]  [<ffffffff815c02d2>] ? hdpvr_probe+0x6c2/0xa30

> The backtrace isn't valid, making this a bit harder to debug. Making compiling 
> the kernel with debug symbols would help here. Could you also please enable 
> lockdep (CONFIG_LOCKDEP=y) if not done already ?

>> [ 3960.758264]  [<ffffffff817f8e84>] schedule+0x24/0x70
>> [ 3960.758269]  [<ffffffff817f9363>] schedule_preempt_disabled+0x13/0x20
>> [ 3960.758275]  [<ffffffff817f77c7>] mutex_lock_nested+0x1a7/0x420
>> [ 3960.758281]  [<ffffffff815c62d2>] ? uvc_queue_enable+0x32/0xc0
>> [ 3960.758287]  [<ffffffff815c62d2>] uvc_queue_enable+0x32/0xc0
>> [ 3960.758292]  [<ffffffff815c941f>] uvc_video_enable+0x12f/0x180
>> [ 3960.758298]  [<ffffffff815c7b55>] uvc_v4l2_do_ioctl+0x555/0x1190
>> [ 3960.758304]  [<ffffffff816c5668>] ? sock_update_classid+0xa8/0x120
>> [ 3960.758310]  [<ffffffff816c1d7e>] ? sock_sendmsg+0xee/0x120
>> [ 3960.758316]  [<ffffffff81561996>] video_usercopy+0x186/0x4c0
>> [ 3960.758322]  [<ffffffff815c7600>] ? uvc_v4l2_set_streamparm+0x190/0x190
>> [ 3960.758327]  [<ffffffff810a451b>] ? __lock_acquire+0x5b/0xc00
>> [ 3960.758333]  [<ffffffff810a559f>] ? lock_release+0xff/0x210
>> [ 3960.758338]  [<ffffffff8108ba01>] ? get_parent_ip+0x11/0x50
>> [ 3960.758344]  [<ffffffff815c6bc4>] uvc_v4l2_ioctl+0x24/0x70
>> [ 3960.758349]  [<ffffffff810a451b>] ? __lock_acquire+0x5b/0xc00
>> [ 3960.758740]  [<ffffffff8116e474>] ? fsnotify+0x84/0x360
>> [ 3960.758745]  [<ffffffff81560850>] v4l2_ioctl+0xb0/0x180
>> [ 3960.758751]  [<ffffffff81145213>] do_vfs_ioctl+0x93/0x500
>> [ 3960.758756]  [<ffffffff810a559f>] ? lock_release+0xff/0x210
>> [ 3960.758762]  [<ffffffff81134ba7>] ? fget_light+0xd7/0x140
>> [ 3960.758768]  [<ffffffff81134b0b>] ? fget_light+0x3b/0x140
>> [ 3960.758773]  [<ffffffff811456ca>] sys_ioctl+0x4a/0x80
>> [ 3960.758778]  [<ffffffff817fb0f9>] system_call_fastpath+0x16/0x1b
>> [ 3960.758784] 1 lock held by motion/7776:
>> [ 3960.758788]  #0:  (&queue->mutex){......}, at: [<ffffffff815c62d2>]

> It looks like the driver tries to take the lock queue->mutex lock a second 
> time. I don't see any code path that could lead to that.




-- 
Best regards,
 Sander                            mailto:linux@eikelenboom.it

