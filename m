Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59389 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497Ab2D2XFG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Apr 2012 19:05:06 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sander Eikelenboom <linux@eikelenboom.it>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Subject: Re: [ 3960.758784] 1 lock held by motion/7776: [ 3960.758788]  #0:  (&queue->mutex){......}, at: [<ffffffff815c62d2>] uvc_queue_enable+0x32/0xc0
Date: Mon, 30 Apr 2012 01:05:27 +0200
Message-ID: <2518039.lgsMPaBqUJ@avalon>
In-Reply-To: <4410483770.20120428220246@eikelenboom.it>
References: <4410483770.20120428220246@eikelenboom.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sander,

On Saturday 28 April 2012 22:02:46 Sander Eikelenboom wrote:
> Hi,
> 
> I'm using a webcam (logitech) supported by the uvcvideo module to capture
> video. Previously once in a while I would get the "uvcvideo: Failed to
> resubmit video URB (-27).", but the grabbing continued without a problem.
> Now the video grabbing program (motion) seems to lock due to some nested
> lock if i interpret it right.

The uvcvideo driver doesn't use nested locks, this is "just" a normal locking 
issue. The mutex_lock_nested() call in the backtrace comes from lock debugging 
support in your kernel.

A quick look at the code doesn't reveal any obvious locking issue. Do you have 
multiple threads accessing the device at the same time ?

> Additional problem is that i don't really know what kernel version was still
> OK, so can't help with that info.
> 
> This is on a vanilla 3.4 RC kernel latest commit:
> c629eaf8392b676b4f83c3dc344e66402bfeec92
>
> [ 3696.753490] ehci_hcd 0000:09:00.1: request ffff880016091400 would
> overflow (3923+31 >= 3936) [ 3696.753494] uvcvideo: Failed to resubmit
> video URB (-27).
> [ 3696.753563] ehci_hcd 0000:09:00.1: request ffff880016091800 would
> overflow (3922+31 >= 3936) [ 3696.753566] uvcvideo: Failed to resubmit
> video URB (-27).
> [ 3696.753609] ehci_hcd 0000:09:00.1: request ffff880016090800 would
> overflow (3922+31 >= 3936) [ 3696.753611] uvcvideo: Failed to resubmit
> video URB (-27).
> [ 3696.753645] ehci_hcd 0000:09:00.1: request ffff880016090c00 would
> overflow (3922+31 >= 3936) [ 3696.753647] uvcvideo: Failed to resubmit
> video URB (-27).
> [ 3696.753656] ehci_hcd 0000:09:00.1: request ffff880016091000 would
> overflow (3922+31 >= 3936) [ 3696.753657] uvcvideo: Failed to resubmit
> video URB (-27).
> [ 3960.758154] INFO: task motion:7776 blocked for more than 120 seconds.
> [ 3960.758168] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
> this message. [ 3960.758174] motion          D 0000000000000201     0  7776
>      1 0x00000000 [ 3960.758183]  ffff8800239d9b68 0000000000000216
> ffffea0000a50018 ffffffff810a451b [ 3960.758192]  ffff88002392cf60
> 0000000000012600 ffff8800239d9fd8 ffff8800239d8010 [ 3960.758200] 
> 0000000000012600 0000000000012600 ffff8800239d9fd8 0000000000012600 [
> 3960.758209] Call Trace:
> [ 3960.758219]  [<ffffffff810a451b>] ? __lock_acquire+0x5b/0xc00
> [ 3960.758226]  [<ffffffff814e0048>] ? hub_suspend+0xf8/0x130
> [ 3960.758232]  [<ffffffff814f0024>] ? usbdev_do_ioctl+0x194/0x1000
> [ 3960.758238]  [<ffffffff810a451b>] ? __lock_acquire+0x5b/0xc00
> [ 3960.758244]  [<ffffffff8108ba01>] ? get_parent_ip+0x11/0x50
> [ 3960.758250]  [<ffffffff8108d6cd>] ? sub_preempt_count+0x9d/0xd0
> [ 3960.758257]  [<ffffffff815c02d2>] ? hdpvr_probe+0x6c2/0xa30

The backtrace isn't valid, making this a bit harder to debug. Making compiling 
the kernel with debug symbols would help here. Could you also please enable 
lockdep (CONFIG_LOCKDEP=y) if not done already ?

> [ 3960.758264]  [<ffffffff817f8e84>] schedule+0x24/0x70
> [ 3960.758269]  [<ffffffff817f9363>] schedule_preempt_disabled+0x13/0x20
> [ 3960.758275]  [<ffffffff817f77c7>] mutex_lock_nested+0x1a7/0x420
> [ 3960.758281]  [<ffffffff815c62d2>] ? uvc_queue_enable+0x32/0xc0
> [ 3960.758287]  [<ffffffff815c62d2>] uvc_queue_enable+0x32/0xc0
> [ 3960.758292]  [<ffffffff815c941f>] uvc_video_enable+0x12f/0x180
> [ 3960.758298]  [<ffffffff815c7b55>] uvc_v4l2_do_ioctl+0x555/0x1190
> [ 3960.758304]  [<ffffffff816c5668>] ? sock_update_classid+0xa8/0x120
> [ 3960.758310]  [<ffffffff816c1d7e>] ? sock_sendmsg+0xee/0x120
> [ 3960.758316]  [<ffffffff81561996>] video_usercopy+0x186/0x4c0
> [ 3960.758322]  [<ffffffff815c7600>] ? uvc_v4l2_set_streamparm+0x190/0x190
> [ 3960.758327]  [<ffffffff810a451b>] ? __lock_acquire+0x5b/0xc00
> [ 3960.758333]  [<ffffffff810a559f>] ? lock_release+0xff/0x210
> [ 3960.758338]  [<ffffffff8108ba01>] ? get_parent_ip+0x11/0x50
> [ 3960.758344]  [<ffffffff815c6bc4>] uvc_v4l2_ioctl+0x24/0x70
> [ 3960.758349]  [<ffffffff810a451b>] ? __lock_acquire+0x5b/0xc00
> [ 3960.758740]  [<ffffffff8116e474>] ? fsnotify+0x84/0x360
> [ 3960.758745]  [<ffffffff81560850>] v4l2_ioctl+0xb0/0x180
> [ 3960.758751]  [<ffffffff81145213>] do_vfs_ioctl+0x93/0x500
> [ 3960.758756]  [<ffffffff810a559f>] ? lock_release+0xff/0x210
> [ 3960.758762]  [<ffffffff81134ba7>] ? fget_light+0xd7/0x140
> [ 3960.758768]  [<ffffffff81134b0b>] ? fget_light+0x3b/0x140
> [ 3960.758773]  [<ffffffff811456ca>] sys_ioctl+0x4a/0x80
> [ 3960.758778]  [<ffffffff817fb0f9>] system_call_fastpath+0x16/0x1b
> [ 3960.758784] 1 lock held by motion/7776:
> [ 3960.758788]  #0:  (&queue->mutex){......}, at: [<ffffffff815c62d2>]

It looks like the driver tries to take the lock queue->mutex lock a second 
time. I don't see any code path that could lead to that.

-- 
Regards,

Laurent Pinchart

