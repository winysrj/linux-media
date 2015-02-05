Return-path: <linux-media-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:41169 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212AbbBELSM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Feb 2015 06:18:12 -0500
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: [v3.19-rc7] possible circular locking dependency in uvc_queue_streamoff
Date: Thu, 05 Feb 2015 12:17:51 +0100
Message-ID: <87a90sobds.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

FYI, in case this is of interest:

======================================================
[ INFO: possible circular locking dependency detected ]
3.19.0-rc7+ #297 Tainted: G        W     
-------------------------------------------------------
mpv/15932 is trying to acquire lock:
 (s_active#37){++++.+}, at: [<ffffffff811a1b48>] kernfs_remove_by_name_ns+0x6b/0x87

but task is already holding lock:
 (&queue->mutex){+.+.+.}, at: [<ffffffffa06b3aea>] uvc_queue_streamoff+0x24/0x48 [uvcvideo]

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&queue->mutex){+.+.+.}:
       [<ffffffff81079571>] lock_acquire+0x149/0x191
       [<ffffffff813d9f26>] mutex_lock_nested+0x6b/0x39e
       [<ffffffffa06b3b32>] uvc_queue_mmap+0x24/0x48 [uvcvideo]
       [<ffffffffa06b3f87>] uvc_v4l2_mmap+0x42/0x49 [uvcvideo]
       [<ffffffffa05f710c>] v4l2_mmap+0x43/0x83 [videodev]
       [<ffffffff81116cd9>] mmap_region+0x26f/0x44b
       [<ffffffff81117177>] do_mmap_pgoff+0x2c2/0x32b
       [<ffffffff81102115>] vm_mmap_pgoff+0x7a/0xad
       [<ffffffff8111584c>] SyS_mmap_pgoff+0x162/0x195
       [<ffffffff81007265>] SyS_mmap+0x16/0x22
       [<ffffffff813dc152>] system_call_fastpath+0x12/0x17

-> #1 (&mm->mmap_sem){++++++}:
       [<ffffffff81079571>] lock_acquire+0x149/0x191
       [<ffffffff8110e9c5>] might_fault+0x81/0xa4
       [<ffffffff811a23b3>] kernfs_fop_write+0xb7/0x149
       [<ffffffff81143b28>] vfs_write+0xa2/0x122
       [<ffffffff81143d82>] SyS_write+0x50/0x85
       [<ffffffff813dc152>] system_call_fastpath+0x12/0x17

-> #0 (s_active#37){++++.+}:
       [<ffffffff81078c1d>] __lock_acquire+0xaf0/0xe67
       [<ffffffff81079571>] lock_acquire+0x149/0x191
       [<ffffffff811a1010>] __kernfs_remove+0x14d/0x2da
       [<ffffffff811a1b48>] kernfs_remove_by_name_ns+0x6b/0x87
       [<ffffffff811a3bd7>] kernfs_remove_by_name+0xb/0xd
       [<ffffffff811a4056>] sysfs_unmerge_group+0x36/0x4c
       [<ffffffff812bf608>] rpm_sysfs_remove+0x14/0x16
       [<ffffffff812bf637>] dpm_sysfs_remove+0x2d/0x52
       [<ffffffff812b63b9>] device_del+0x42/0x1f8
       [<ffffffff812b65b3>] device_unregister+0x44/0x50
       [<ffffffffa0085d57>] usb_remove_ep_devs+0x1c/0x29 [usbcore]
       [<ffffffffa007f342>] remove_intf_ep_devs+0x2f/0x45 [usbcore]
       [<ffffffffa0081428>] usb_set_interface+0x22f/0x2f3 [usbcore]
       [<ffffffffa06b7709>] uvc_video_enable+0x31/0x14c [uvcvideo]
       [<ffffffffa06b37f7>] uvc_stop_streaming+0x24/0x50 [uvcvideo]
       [<ffffffffa061c680>] __vb2_queue_cancel+0x25/0x143 [videobuf2_core]
       [<ffffffffa061cb3d>] vb2_internal_streamoff+0x30/0x8f [videobuf2_core]
       [<ffffffffa061ccfe>] vb2_streamoff+0x3b/0x43 [videobuf2_core]
       [<ffffffffa06b3af5>] uvc_queue_streamoff+0x2f/0x48 [uvcvideo]
       [<ffffffffa06b462e>] uvc_ioctl_streamoff+0x44/0x57 [uvcvideo]
       [<ffffffffa05f84a5>] v4l_streamoff+0x15/0x17 [videodev]
       [<ffffffffa05fbd22>] __video_do_ioctl+0x170/0x246 [videodev]
       [<ffffffffa05fc0ac>] video_usercopy+0x2b4/0x589 [videodev]
       [<ffffffffa05fc391>] video_ioctl2+0x10/0x12 [videodev]
       [<ffffffffa05f7451>] v4l2_ioctl+0x78/0xf8 [videodev]
       [<ffffffff81152655>] do_vfs_ioctl+0x47f/0x4c7
       [<ffffffff811526eb>] SyS_ioctl+0x4e/0x7f
       [<ffffffff813dc152>] system_call_fastpath+0x12/0x17

other info that might help us debug this:

Chain exists of:
  s_active#37 --> &mm->mmap_sem --> &queue->mutex

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&queue->mutex);
                               lock(&mm->mmap_sem);
                               lock(&queue->mutex);
  lock(s_active#37);

 *** DEADLOCK ***

2 locks held by mpv/15932:
 #0:  (&streaming->mutex){+.+.+.}, at: [<ffffffffa06b461e>] uvc_ioctl_streamoff+0x34/0x57 [uvcvideo]
 #1:  (&queue->mutex){+.+.+.}, at: [<ffffffffa06b3aea>] uvc_queue_streamoff+0x24/0x48 [uvcvideo]

stack backtrace:
CPU: 1 PID: 15932 Comm: mpv Tainted: G        W      3.19.0-rc7+ #297
Hardware name: LENOVO 2776LEG/2776LEG, BIOS 6EET55WW (3.15 ) 12/19/2011
 ffffffff81df0580 ffff8801be25f7c8 ffffffff813d6111 0000000000000000
 ffffffff81e16010 ffff8801be25f818 ffffffff813d3e26 ffff8801be25f808
 ffff8801be16c990 ffff8801be16d148 ffff8801be16c990 ffff8801be16d148
Call Trace:
 [<ffffffff813d6111>] dump_stack+0x4c/0x65
 [<ffffffff813d3e26>] print_circular_bug+0x1f8/0x209
 [<ffffffff81078c1d>] __lock_acquire+0xaf0/0xe67
 [<ffffffff81077f48>] ? mark_lock+0x2d/0x212
 [<ffffffff81079571>] lock_acquire+0x149/0x191
 [<ffffffff811a1b48>] ? kernfs_remove_by_name_ns+0x6b/0x87
 [<ffffffff811a1010>] __kernfs_remove+0x14d/0x2da
 [<ffffffff811a1b48>] ? kernfs_remove_by_name_ns+0x6b/0x87
 [<ffffffff811a08cc>] ? kernfs_find_ns+0xbe/0x100
 [<ffffffff811a1b48>] kernfs_remove_by_name_ns+0x6b/0x87
 [<ffffffff811a3bd7>] kernfs_remove_by_name+0xb/0xd
 [<ffffffff811a4056>] sysfs_unmerge_group+0x36/0x4c
 [<ffffffff812bf608>] rpm_sysfs_remove+0x14/0x16
 [<ffffffff812bf637>] dpm_sysfs_remove+0x2d/0x52
 [<ffffffff812b63b9>] device_del+0x42/0x1f8
 [<ffffffff81079885>] ? mark_held_locks+0x54/0x76
 [<ffffffff812b65b3>] device_unregister+0x44/0x50
 [<ffffffffa0085d57>] usb_remove_ep_devs+0x1c/0x29 [usbcore]
 [<ffffffffa007f342>] remove_intf_ep_devs+0x2f/0x45 [usbcore]
 [<ffffffffa0081428>] usb_set_interface+0x22f/0x2f3 [usbcore]
 [<ffffffffa06b7709>] uvc_video_enable+0x31/0x14c [uvcvideo]
 [<ffffffffa06b37f7>] uvc_stop_streaming+0x24/0x50 [uvcvideo]
 [<ffffffffa061c680>] __vb2_queue_cancel+0x25/0x143 [videobuf2_core]
 [<ffffffffa061cb3d>] vb2_internal_streamoff+0x30/0x8f [videobuf2_core]
 [<ffffffffa061ccfe>] vb2_streamoff+0x3b/0x43 [videobuf2_core]
 [<ffffffffa06b3af5>] uvc_queue_streamoff+0x2f/0x48 [uvcvideo]
 [<ffffffffa06b462e>] uvc_ioctl_streamoff+0x44/0x57 [uvcvideo]
 [<ffffffffa05f84a5>] v4l_streamoff+0x15/0x17 [videodev]
 [<ffffffffa05fbd22>] __video_do_ioctl+0x170/0x246 [videodev]
 [<ffffffffa05fc0ac>] video_usercopy+0x2b4/0x589 [videodev]
 [<ffffffffa05fbbb2>] ? v4l2_is_known_ioctl+0x20/0x20 [videodev]
 [<ffffffff8100a389>] ? native_sched_clock+0x35/0x37
 [<ffffffff81067f6f>] ? sched_clock_local+0x12/0x75
 [<ffffffff8106818f>] ? sched_clock_cpu+0x9d/0xb6
 [<ffffffffa05fc391>] video_ioctl2+0x10/0x12 [videodev]
 [<ffffffffa05f7451>] v4l2_ioctl+0x78/0xf8 [videodev]
 [<ffffffff81152655>] do_vfs_ioctl+0x47f/0x4c7
 [<ffffffff8115ac71>] ? rcu_read_unlock+0x56/0x5f
 [<ffffffff8115ad55>] ? __fget+0x6d/0x78
 [<ffffffff8115ada5>] ? __fget_light+0x45/0x52
 [<ffffffff811526eb>] SyS_ioctl+0x4e/0x7f
 [<ffffffff813dc152>] system_call_fastpath+0x12/0x17
