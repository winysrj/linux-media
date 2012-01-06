Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([88.190.12.23]:38361 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947Ab2AFVml (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jan 2012 16:42:41 -0500
Received: from skate (humanoidz.org [82.247.183.72])
	by mail.free-electrons.com (Postfix) with ESMTPA id 335AC132
	for <linux-media@vger.kernel.org>; Fri,  6 Jan 2012 22:37:35 +0100 (CET)
Date: Fri, 6 Jan 2012 22:42:31 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: linux-media@vger.kernel.org
Subject: cx231xx: possible circular locking dependency detected on 3.2
Message-ID: <20120106224231.455a9896@skate>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I'm running the Hauppauge USB-Live 2 device on an ARM OMAP3 platform.
After loading the cx231xx driver and launching v4l2grab, I immediately
get:

[  407.087158] cx231xx #0:  setPowerMode::mode = 48, No Change req.
[  407.145477] 
[  407.147064] ======================================================
[  407.153533] [ INFO: possible circular locking dependency detected ]
[  407.160095] 3.2.0-00007-gb928298 #18
[  407.163848] -------------------------------------------------------
[  407.170410] v4l2grab/680 is trying to acquire lock:
[  407.175537]  (&mm->mmap_sem){++++++}, at: [<bf03e10c>] videobuf_qbuf+0x298/0x48c [videobuf_core]
[  407.184783] 
[  407.184783] but task is already holding lock:
[  407.190887]  (&dev->lock#2){+.+.+.}, at: [<bf00e47c>] v4l2_ioctl+0xec/0x150 [videodev]
[  407.199249] 
[  407.199249] which lock already depends on the new lock.
[  407.199249] 
[  407.207824] 
[  407.207824] the existing dependency chain (in reverse order) is:
[  407.215667] 
[  407.215667] -> #1 (&dev->lock#2){+.+.+.}:
[  407.221435]        [<c008bac8>] lock_acquire+0x98/0x100
[  407.226928]        [<c0471594>] mutex_lock_interruptible_nested+0x4c/0x37c
[  407.234161]        [<bf00e378>] v4l2_mmap+0x94/0xac [videodev]
[  407.240295]        [<c00eee5c>] mmap_region+0x2d4/0x468
[  407.245788]        [<c00ef3a0>] sys_mmap_pgoff+0x78/0xc0
[  407.251342]        [<c0013b00>] ret_fast_syscall+0x0/0x3c
[  407.257019] 
[  407.257019] -> #0 (&mm->mmap_sem){++++++}:
[  407.262878]        [<c008b3f0>] __lock_acquire+0x1d04/0x1d94
[  407.268829]        [<c008bac8>] lock_acquire+0x98/0x100
[  407.274291]        [<c04726cc>] down_read+0x2c/0x3c
[  407.279418]        [<bf03e10c>] videobuf_qbuf+0x298/0x48c [videobuf_core]
[  407.286529]        [<bf00fbf4>] __video_do_ioctl+0x500/0x55a8 [videodev]
[  407.293579]        [<bf00f2d0>] video_usercopy+0x128/0x4d8 [videodev]
[  407.300354]        [<bf00e418>] v4l2_ioctl+0x88/0x150 [videodev]
[  407.306671]        [<c0112cd4>] do_vfs_ioctl+0x7c/0x584
[  407.312164]        [<c0113250>] sys_ioctl+0x74/0x7c
[  407.317260]        [<c0013b00>] ret_fast_syscall+0x0/0x3c
[  407.322937] 
[  407.322937] other info that might help us debug this:
[  407.322937] 
[  407.331329]  Possible unsafe locking scenario:
[  407.331329] 
[  407.337524]        CPU0                    CPU1
[  407.342285]        ----                    ----
[  407.347015]   lock(&dev->lock);
[  407.350311]                                lock(&mm->mmap_sem);
[  407.356536]                                lock(&dev->lock);
[  407.362457]   lock(&mm->mmap_sem);
[  407.366027] 
[  407.366027]  *** DEADLOCK ***
[  407.366027] 
[  407.372253] 1 lock held by v4l2grab/680:
[  407.376342]  #0:  (&dev->lock#2){+.+.+.}, at: [<bf00e47c>] v4l2_ioctl+0xec/0x150 [videodev]
[  407.385162] 
[  407.385162] stack backtrace:
[  407.389739] [<c001b3b0>] (unwind_backtrace+0x0/0xf0) from [<c0087c04>] (print_circular_bug+0x1d4/0x2f0)
[  407.399597] [<c0087c04>] (print_circular_bug+0x1d4/0x2f0) from [<c008b3f0>] (__lock_acquire+0x1d04/0x1d94)
[  407.409729] [<c008b3f0>] (__lock_acquire+0x1d04/0x1d94) from [<c008bac8>] (lock_acquire+0x98/0x100)
[  407.419219] [<c008bac8>] (lock_acquire+0x98/0x100) from [<c04726cc>] (down_read+0x2c/0x3c)
[  407.427886] [<c04726cc>] (down_read+0x2c/0x3c) from [<bf03e10c>] (videobuf_qbuf+0x298/0x48c [videobuf_core])
[  407.438201] [<bf03e10c>] (videobuf_qbuf+0x298/0x48c [videobuf_core]) from [<bf00fbf4>] (__video_do_ioctl+0x500/0x55a8 [videodev])
[  407.450469] [<bf00fbf4>] (__video_do_ioctl+0x500/0x55a8 [videodev]) from [<bf00f2d0>] (video_usercopy+0x128/0x4d8 [videodev])
[  407.462341] [<bf00f2d0>] (video_usercopy+0x128/0x4d8 [videodev]) from [<bf00e418>] (v4l2_ioctl+0x88/0x150 [videodev])
[  407.473480] [<bf00e418>] (v4l2_ioctl+0x88/0x150 [videodev]) from [<c0112cd4>] (do_vfs_ioctl+0x7c/0x584)
[  407.483337] [<c0112cd4>] (do_vfs_ioctl+0x7c/0x584) from [<c0113250>] (sys_ioctl+0x74/0x7c)
[  407.492004] [<c0113250>] (sys_ioctl+0x74/0x7c) from [<c0013b00>] (ret_fast_syscall+0x0/0x3c)
[  407.500915] cx231xx #0: cx231xx_stop_stream():: ep_mask = 8

Best regards,

Thomas Petazzoni
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
