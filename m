Return-path: <linux-media-owner@vger.kernel.org>
Received: from static.121.164.40.188.clients.your-server.de ([188.40.164.121]:46854
	"EHLO smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424Ab2D1UJF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Apr 2012 16:09:05 -0400
Date: Sat, 28 Apr 2012 22:02:46 +0200
From: Sander Eikelenboom <linux@eikelenboom.it>
Message-ID: <4410483770.20120428220246@eikelenboom.it>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Subject: [ 3960.758784] 1 lock held by motion/7776: [ 3960.758788]  #0:  (&queue->mutex){......}, at: [<ffffffff815c62d2>] uvc_queue_enable+0x32/0xc0
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm using a webcam (logitech) supported by the uvcvideo module to capture video.
Previously once in a while I would get the "uvcvideo: Failed to resubmit video URB (-27).", but the grabbing continued without a problem.
Now the video grabbing program (motion) seems to lock due to some nested lock if i interpret it right.
Additional problem is that i don't really know what kernel version was still OK, so can't help with that info.

This is on a vanilla 3.4 RC kernel latest commit: c629eaf8392b676b4f83c3dc344e66402bfeec92

--
Sander







[ 3696.753490] ehci_hcd 0000:09:00.1: request ffff880016091400 would overflow (3923+31 >= 3936)
[ 3696.753494] uvcvideo: Failed to resubmit video URB (-27).
[ 3696.753563] ehci_hcd 0000:09:00.1: request ffff880016091800 would overflow (3922+31 >= 3936)
[ 3696.753566] uvcvideo: Failed to resubmit video URB (-27).
[ 3696.753609] ehci_hcd 0000:09:00.1: request ffff880016090800 would overflow (3922+31 >= 3936)
[ 3696.753611] uvcvideo: Failed to resubmit video URB (-27).
[ 3696.753645] ehci_hcd 0000:09:00.1: request ffff880016090c00 would overflow (3922+31 >= 3936)
[ 3696.753647] uvcvideo: Failed to resubmit video URB (-27).
[ 3696.753656] ehci_hcd 0000:09:00.1: request ffff880016091000 would overflow (3922+31 >= 3936)
[ 3696.753657] uvcvideo: Failed to resubmit video URB (-27).
[ 3960.758154] INFO: task motion:7776 blocked for more than 120 seconds.
[ 3960.758168] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 3960.758174] motion          D 0000000000000201     0  7776      1 0x00000000
[ 3960.758183]  ffff8800239d9b68 0000000000000216 ffffea0000a50018 ffffffff810a451b
[ 3960.758192]  ffff88002392cf60 0000000000012600 ffff8800239d9fd8 ffff8800239d8010
[ 3960.758200]  0000000000012600 0000000000012600 ffff8800239d9fd8 0000000000012600
[ 3960.758209] Call Trace:
[ 3960.758219]  [<ffffffff810a451b>] ? __lock_acquire+0x5b/0xc00
[ 3960.758226]  [<ffffffff814e0048>] ? hub_suspend+0xf8/0x130
[ 3960.758232]  [<ffffffff814f0024>] ? usbdev_do_ioctl+0x194/0x1000
[ 3960.758238]  [<ffffffff810a451b>] ? __lock_acquire+0x5b/0xc00
[ 3960.758244]  [<ffffffff8108ba01>] ? get_parent_ip+0x11/0x50
[ 3960.758250]  [<ffffffff8108d6cd>] ? sub_preempt_count+0x9d/0xd0
[ 3960.758257]  [<ffffffff815c02d2>] ? hdpvr_probe+0x6c2/0xa30
[ 3960.758264]  [<ffffffff817f8e84>] schedule+0x24/0x70
[ 3960.758269]  [<ffffffff817f9363>] schedule_preempt_disabled+0x13/0x20
[ 3960.758275]  [<ffffffff817f77c7>] mutex_lock_nested+0x1a7/0x420
[ 3960.758281]  [<ffffffff815c62d2>] ? uvc_queue_enable+0x32/0xc0
[ 3960.758287]  [<ffffffff815c62d2>] uvc_queue_enable+0x32/0xc0
[ 3960.758292]  [<ffffffff815c941f>] uvc_video_enable+0x12f/0x180
[ 3960.758298]  [<ffffffff815c7b55>] uvc_v4l2_do_ioctl+0x555/0x1190
[ 3960.758304]  [<ffffffff816c5668>] ? sock_update_classid+0xa8/0x120
[ 3960.758310]  [<ffffffff816c1d7e>] ? sock_sendmsg+0xee/0x120
[ 3960.758316]  [<ffffffff81561996>] video_usercopy+0x186/0x4c0
[ 3960.758322]  [<ffffffff815c7600>] ? uvc_v4l2_set_streamparm+0x190/0x190
[ 3960.758327]  [<ffffffff810a451b>] ? __lock_acquire+0x5b/0xc00
[ 3960.758333]  [<ffffffff810a559f>] ? lock_release+0xff/0x210
[ 3960.758338]  [<ffffffff8108ba01>] ? get_parent_ip+0x11/0x50
[ 3960.758344]  [<ffffffff815c6bc4>] uvc_v4l2_ioctl+0x24/0x70
[ 3960.758349]  [<ffffffff810a451b>] ? __lock_acquire+0x5b/0xc00
[ 3960.758740]  [<ffffffff8116e474>] ? fsnotify+0x84/0x360
[ 3960.758745]  [<ffffffff81560850>] v4l2_ioctl+0xb0/0x180
[ 3960.758751]  [<ffffffff81145213>] do_vfs_ioctl+0x93/0x500
[ 3960.758756]  [<ffffffff810a559f>] ? lock_release+0xff/0x210
[ 3960.758762]  [<ffffffff81134ba7>] ? fget_light+0xd7/0x140
[ 3960.758768]  [<ffffffff81134b0b>] ? fget_light+0x3b/0x140
[ 3960.758773]  [<ffffffff811456ca>] sys_ioctl+0x4a/0x80
[ 3960.758778]  [<ffffffff817fb0f9>] system_call_fastpath+0x16/0x1b
[ 3960.758784] 1 lock held by motion/7776:
[ 3960.758788]  #0:  (&queue->mutex){......}, at: [<ffffffff815c62d2>] uvc_queue_enable+0x32/0xc0
[ 4080.758504] INFO: task motion:7776 blocked for more than 120 seconds.
[ 4080.758518] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 4080.758524] motion          D 0000000000000201     0  7776      1 0x00000000
[ 4080.758532]  ffff8800239d9b68 0000000000000216 ffffea0000a50018 ffffffff810a451b
[ 4080.758540]  ffff88002392cf60 0000000000012600 ffff8800239d9fd8 ffff8800239d8010
[ 4080.758547]  0000000000012600 0000000000012600 ffff8800239d9fd8 0000000000012600
[ 4080.758555] Call Trace:
[ 4080.758564]  [<ffffffff810a451b>] ? __lock_acquire+0x5b/0xc00
[ 4080.758570]  [<ffffffff814e0048>] ? hub_suspend+0xf8/0x130
[ 4080.758576]  [<ffffffff814f0024>] ? usbdev_do_ioctl+0x194/0x1000
[ 4080.758581]  [<ffffffff810a451b>] ? __lock_acquire+0x5b/0xc00
[ 4080.758587]  [<ffffffff8108ba01>] ? get_parent_ip+0x11/0x50
[ 4080.758592]  [<ffffffff8108d6cd>] ? sub_preempt_count+0x9d/0xd0
[ 4080.758597]  [<ffffffff815c02d2>] ? hdpvr_probe+0x6c2/0xa30
[ 4080.758603]  [<ffffffff817f8e84>] schedule+0x24/0x70
[ 4080.758608]  [<ffffffff817f9363>] schedule_preempt_disabled+0x13/0x20
[ 4080.758613]  [<ffffffff817f77c7>] mutex_lock_nested+0x1a7/0x420
[ 4080.758618]  [<ffffffff815c62d2>] ? uvc_queue_enable+0x32/0xc0
[ 4080.758624]  [<ffffffff815c62d2>] uvc_queue_enable+0x32/0xc0
[ 4080.758629]  [<ffffffff815c941f>] uvc_video_enable+0x12f/0x180
[ 4080.758633]  [<ffffffff815c7b55>] uvc_v4l2_do_ioctl+0x555/0x1190
[ 4080.758640]  [<ffffffff816c5668>] ? sock_update_classid+0xa8/0x120
[ 4080.758645]  [<ffffffff816c1d7e>] ? sock_sendmsg+0xee/0x120
[ 4080.758651]  [<ffffffff81561996>] video_usercopy+0x186/0x4c0
[ 4080.758655]  [<ffffffff815c7600>] ? uvc_v4l2_set_streamparm+0x190/0x190
[ 4080.758661]  [<ffffffff810a451b>] ? __lock_acquire+0x5b/0xc00
[ 4080.758666]  [<ffffffff810a559f>] ? lock_release+0xff/0x210
[ 4080.758670]  [<ffffffff8108ba01>] ? get_parent_ip+0x11/0x50
[ 4080.758675]  [<ffffffff815c6bc4>] uvc_v4l2_ioctl+0x24/0x70
[ 4080.758680]  [<ffffffff810a451b>] ? __lock_acquire+0x5b/0xc00
[ 4080.759167]  [<ffffffff8116e474>] ? fsnotify+0x84/0x360
[ 4080.759173]  [<ffffffff81560850>] v4l2_ioctl+0xb0/0x180
[ 4080.759179]  [<ffffffff81145213>] do_vfs_ioctl+0x93/0x500
[ 4080.759184]  [<ffffffff810a559f>] ? lock_release+0xff/0x210
[ 4080.759191]  [<ffffffff81134ba7>] ? fget_light+0xd7/0x140
[ 4080.759196]  [<ffffffff81134b0b>] ? fget_light+0x3b/0x140
[ 4080.759201]  [<ffffffff811456ca>] sys_ioctl+0x4a/0x80
[ 4080.759208]  [<ffffffff817fb0f9>] system_call_fastpath+0x16/0x1b
[ 4080.759214] 1 lock held by motion/7776:
[ 4080.759217]  #0:  (&queue->mutex){......}, at: [<ffffffff815c62d2>] uvc_queue_enable+0x32/0xc0
[ 4200.759699] INFO: task motion:7776 blocked for more than 120 seconds.
[ 4200.759713] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 4200.759720] motion          D 0000000000000201     0  7776      1 0x00000000
[ 4200.759729]  ffff8800239d9b68 0000000000000216 ffffea0000a50018 ffffffff810a451b
[ 4200.759738]  ffff88002392cf60 0000000000012600 ffff8800239d9fd8 ffff8800239d8010
[ 4200.759746]  0000000000012600 0000000000012600 ffff8800239d9fd8 0000000000012600
[ 4200.759754] Call Trace:
[ 4200.759764]  [<ffffffff810a451b>] ? __lock_acquire+0x5b/0xc00
[ 4200.759771]  [<ffffffff814e0048>] ? hub_suspend+0xf8/0x130
[ 4200.759777]  [<ffffffff814f0024>] ? usbdev_do_ioctl+0x194/0x1000
[ 4200.759783]  [<ffffffff810a451b>] ? __lock_acquire+0x5b/0xc00
[ 4200.759789]  [<ffffffff8108ba01>] ? get_parent_ip+0x11/0x50
[ 4200.759795]  [<ffffffff8108d6cd>] ? sub_preempt_count+0x9d/0xd0
[ 4200.759801]  [<ffffffff815c02d2>] ? hdpvr_probe+0x6c2/0xa30
[ 4200.759808]  [<ffffffff817f8e84>] schedule+0x24/0x70
[ 4200.759813]  [<ffffffff817f9363>] schedule_preempt_disabled+0x13/0x20
[ 4200.759819]  [<ffffffff817f77c7>] mutex_lock_nested+0x1a7/0x420
[ 4200.759825]  [<ffffffff815c62d2>] ? uvc_queue_enable+0x32/0xc0
[ 4200.759831]  [<ffffffff815c62d2>] uvc_queue_enable+0x32/0xc0
[ 4200.759837]  [<ffffffff815c941f>] uvc_video_enable+0x12f/0x180
[ 4200.759842]  [<ffffffff815c7b55>] uvc_v4l2_do_ioctl+0x555/0x1190
[ 4200.759848]  [<ffffffff816c5668>] ? sock_update_classid+0xa8/0x120
[ 4200.759855]  [<ffffffff816c1d7e>] ? sock_sendmsg+0xee/0x120
[ 4200.759862]  [<ffffffff81561996>] video_usercopy+0x186/0x4c0
[ 4200.759868]  [<ffffffff815c7600>] ? uvc_v4l2_set_streamparm+0x190/0x190
[ 4200.759873]  [<ffffffff810a451b>] ? __lock_acquire+0x5b/0xc00
[ 4200.759879]  [<ffffffff810a559f>] ? lock_release+0xff/0x210
[ 4200.759884]  [<ffffffff8108ba01>] ? get_parent_ip+0x11/0x50
[ 4200.759890]  [<ffffffff815c6bc4>] uvc_v4l2_ioctl+0x24/0x70
[ 4200.759895]  [<ffffffff810a451b>] ? __lock_acquire+0x5b/0xc00
[ 4200.760376]  [<ffffffff8116e474>] ? fsnotify+0x84/0x360
[ 4200.760382]  [<ffffffff81560850>] v4l2_ioctl+0xb0/0x180
[ 4200.760389]  [<ffffffff81145213>] do_vfs_ioctl+0x93/0x500
[ 4200.760394]  [<ffffffff810a559f>] ? lock_release+0xff/0x210
[ 4200.760401]  [<ffffffff81134ba7>] ? fget_light+0xd7/0x140
[ 4200.760407]  [<ffffffff81134b0b>] ? fget_light+0x3b/0x140
[ 4200.760412]  [<ffffffff811456ca>] sys_ioctl+0x4a/0x80
[ 4200.760417]  [<ffffffff817fb0f9>] system_call_fastpath+0x16/0x1b
[ 4200.760423] 1 lock held by motion/7776:
[ 4200.760427]  #0:  (&queue->mutex){......}, at: [<ffffffff815c62d2>] uvc_queue_enable+0x32/0xc0
[ 4320.761186] INFO: task motion:7776 blocked for more than 120 seconds.
[ 4320.761199] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 4320.761206] motion          D 0000000000000201     0  7776      1 0x00000000
[ 4320.761215]  ffff8800239d9b68 0000000000000216 ffffea0000a50018 ffffffff810a451b
[ 4320.761224]  ffff88002392cf60 0000000000012600 ffff8800239d9fd8 ffff8800239d8010
[ 4320.761232]  0000000000012600 0000000000012600 ffff8800239d9fd8 0000000000012600
[ 4320.761241] Call Trace:
[ 4320.761250]  [<ffffffff810a451b>] ? __lock_acquire+0x5b/0xc00
[ 4320.761258]  [<ffffffff814e0048>] ? hub_suspend+0xf8/0x130
[ 4320.761264]  [<ffffffff814f0024>] ? usbdev_do_ioctl+0x194/0x1000
[ 4320.761269]  [<ffffffff810a451b>] ? __lock_acquire+0x5b/0xc00
[ 4320.761276]  [<ffffffff8108ba01>] ? get_parent_ip+0x11/0x50
[ 4320.761281]  [<ffffffff8108d6cd>] ? sub_preempt_count+0x9d/0xd0
[ 4320.761288]  [<ffffffff815c02d2>] ? hdpvr_probe+0x6c2/0xa30
[ 4320.761295]  [<ffffffff817f8e84>] schedule+0x24/0x70
[ 4320.761300]  [<ffffffff817f9363>] schedule_preempt_disabled+0x13/0x20
[ 4320.761306]  [<ffffffff817f77c7>] mutex_lock_nested+0x1a7/0x420
[ 4320.761312]  [<ffffffff815c62d2>] ? uvc_queue_enable+0x32/0xc0
[ 4320.761318]  [<ffffffff815c62d2>] uvc_queue_enable+0x32/0xc0
[ 4320.761323]  [<ffffffff815c941f>] uvc_video_enable+0x12f/0x180
[ 4320.761329]  [<ffffffff815c7b55>] uvc_v4l2_do_ioctl+0x555/0x1190
[ 4320.761335]  [<ffffffff816c5668>] ? sock_update_classid+0xa8/0x120
[ 4320.761342]  [<ffffffff816c1d7e>] ? sock_sendmsg+0xee/0x120
[ 4320.761348]  [<ffffffff81561996>] video_usercopy+0x186/0x4c0
[ 4320.761353]  [<ffffffff815c7600>] ? uvc_v4l2_set_streamparm+0x190/0x190
[ 4320.761359]  [<ffffffff810a451b>] ? __lock_acquire+0x5b/0xc00
[ 4320.761365]  [<ffffffff810a559f>] ? lock_release+0xff/0x210
[ 4320.761370]  [<ffffffff8108ba01>] ? get_parent_ip+0x11/0x50
[ 4320.761375]  [<ffffffff815c6bc4>] uvc_v4l2_ioctl+0x24/0x70
[ 4320.761380]  [<ffffffff810a451b>] ? __lock_acquire+0x5b/0xc00
[ 4320.761880]  [<ffffffff8116e474>] ? fsnotify+0x84/0x360
[ 4320.761885]  [<ffffffff81560850>] v4l2_ioctl+0xb0/0x180
[ 4320.761893]  [<ffffffff81145213>] do_vfs_ioctl+0x93/0x500
[ 4320.761898]  [<ffffffff810a559f>] ? lock_release+0xff/0x210
[ 4320.761905]  [<ffffffff81134ba7>] ? fget_light+0xd7/0x140
[ 4320.761910]  [<ffffffff81134b0b>] ? fget_light+0x3b/0x140
[ 4320.761915]  [<ffffffff811456ca>] sys_ioctl+0x4a/0x80
[ 4320.761921]  [<ffffffff817fb0f9>] system_call_fastpath+0x16/0x1b
[ 4320.761926] 1 lock held by motion/7776:
[ 4320.761930]  #0:  (&queue->mutex){......}, at: [<ffffffff815c62d2>] uvc_queue_enable+0x32/0xc0
[ 4440.761549] INFO: task motion:7776 blocked for more than 120 seconds.
[ 4440.761563] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 4440.761570] motion          D 0000000000000201     0  7776      1 0x00000000
[ 4440.761579]  ffff8800239d9b68 0000000000000216 ffffea0000a50018 ffffffff810a451b
[ 4440.761587]  ffff88002392cf60 0000000000012600 ffff8800239d9fd8 ffff8800239d8010
[ 4440.761596]  0000000000012600 0000000000012600 ffff8800239d9fd8 0000000000012600
[ 4440.761604] Call Trace:
[ 4440.761618]  [<ffffffff810a451b>] ? __lock_acquire+0x5b/0xc00
[ 4440.761626]  [<ffffffff814e0048>] ? hub_suspend+0xf8/0x130
[ 4440.761633]  [<ffffffff814f0024>] ? usbdev_do_ioctl+0x194/0x1000
[ 4440.761639]  [<ffffffff810a451b>] ? __lock_acquire+0x5b/0xc00
[ 4440.761645]  [<ffffffff8108ba01>] ? get_parent_ip+0x11/0x50
[ 4440.761651]  [<ffffffff8108d6cd>] ? sub_preempt_count+0x9d/0xd0
[ 4440.761657]  [<ffffffff815c02d2>] ? hdpvr_probe+0x6c2/0xa30
[ 4440.761665]  [<ffffffff817f8e84>] schedule+0x24/0x70
[ 4440.761670]  [<ffffffff817f9363>] schedule_preempt_disabled+0x13/0x20
[ 4440.761676]  [<ffffffff817f77c7>] mutex_lock_nested+0x1a7/0x420
[ 4440.761682]  [<ffffffff815c62d2>] ? uvc_queue_enable+0x32/0xc0
[ 4440.761688]  [<ffffffff815c62d2>] uvc_queue_enable+0x32/0xc0
[ 4440.761693]  [<ffffffff815c941f>] uvc_video_enable+0x12f/0x180
[ 4440.761699]  [<ffffffff815c7b55>] uvc_v4l2_do_ioctl+0x555/0x1190
[ 4440.761705]  [<ffffffff816c5668>] ? sock_update_classid+0xa8/0x120
[ 4440.761711]  [<ffffffff816c1d7e>] ? sock_sendmsg+0xee/0x120
[ 4440.761717]  [<ffffffff81561996>] video_usercopy+0x186/0x4c0
[ 4440.761722]  [<ffffffff815c7600>] ? uvc_v4l2_set_streamparm+0x190/0x190
[ 4440.761728]  [<ffffffff810a451b>] ? __lock_acquire+0x5b/0xc00
[ 4440.761734]  [<ffffffff810a559f>] ? lock_release+0xff/0x210
[ 4440.761739]  [<ffffffff8108ba01>] ? get_parent_ip+0x11/0x50
[ 4440.761745]  [<ffffffff815c6bc4>] uvc_v4l2_ioctl+0x24/0x70
[ 4440.761750]  [<ffffffff810a451b>] ? __lock_acquire+0x5b/0xc00
[ 4440.761984]  [<ffffffff8116e474>] ? fsnotify+0x84/0x360
[ 4440.761990]  [<ffffffff81560850>] v4l2_ioctl+0xb0/0x180
[ 4440.761996]  [<ffffffff81145213>] do_vfs_ioctl+0x93/0x500
[ 4440.762001]  [<ffffffff810a559f>] ? lock_release+0xff/0x210
[ 4440.762007]  [<ffffffff81134ba7>] ? fget_light+0xd7/0x140
[ 4440.762013]  [<ffffffff81134b0b>] ? fget_light+0x3b/0x140
[ 4440.762018]  [<ffffffff811456ca>] sys_ioctl+0x4a/0x80
[ 4440.762023]  [<ffffffff817fb0f9>] system_call_fastpath+0x16/0x1b
[ 4440.762029] 1 lock held by motion/7776:
[ 4440.762032]  #0:  (&queue->mutex){......}, at: [<ffffffff815c62d2>] uvc_queue_enable+0x32/0xc0

