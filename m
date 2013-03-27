Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:51010 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172Ab3C0Tcr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Mar 2013 15:32:47 -0400
Received: by mail-wi0-f179.google.com with SMTP id hn17so2582983wib.0
        for <linux-media@vger.kernel.org>; Wed, 27 Mar 2013 12:32:46 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 27 Mar 2013 20:32:45 +0100
Message-ID: <CAFqH_52au34eAztGc64JWxEYmKgr_QUvVswD-ugGvB1=LsWcdA@mail.gmail.com>
Subject: omap3isp: possible circular locking dependency
From: Enric Balletbo Serra <eballetbo@gmail.com>
To: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I've a problem running OMAP3 ISP with current 3.9-rc4. I tried to run
the Laurent's live application to capture data from my mt9v034 sensor
but kernel shows a  possible circular locking dependency. Also the
captured images are wrong and I see garbage. The same environment
worked for me with kernel 3.7. Anyone knows any issue related to this
? Anyone experimented something similar with other sensors ? I tried
to find something in ML and Laurent's git repository but I don't see
anything. Thanks in advance.

Here is the log:

~# live
No compatible input device found, disabling digital zoom
32 bpp
Device /dev/video7 opened: omap_vout ().
/dev/video7: 3 buffers requested.
/dev/video7: buffer 0 mapped at address 0xb6df1000.
/dev/video7: buffer 1 mapped at address 0xb6c71000.
/dev/video7: buffer 2 mapped at address 0xb6af1000.
Device /dev/video6 opened: OMAP3 ISP resizer output (media).
viewfinder configured for 2011 1024x768
/dev/video6: 3 buffers requested.
/dev/video6: buffer 0 valid.
/dev/video6: buffer 1 valid.
/dev/video6: buffer 2 valid.
Device /dev/video6 opened: OMAP3 ISP resizer output (media).
/dev/video6: 2 buffers requested.
/dev/video6: buffer 0 mapped at address 0xb64f1000.
/dev/video6: buffer 1 mapped at address 0xb5ef1000.
snapshot configured for 2011 2048x1536
Device /[   63.557861]
[   63.560577] ======================================================
[   63.567077] [ INFO: possible circular locking dependency detected ]
[   63.573669] 3.9.0-rc4-00152-gba9ce12 #4 Not tainted
[   63.578796] -------------------------------------------------------
[   63.585388] live/1273 is trying to acquire lock:
[   63.590209]  (&mm->mmap_sem){++++++}, at: [<bf06fb24>]
omap3isp_video_queue_qbuf+0x280/0x7a4 [omap3_isp]
[   63.600280]
[   63.600280] but task is already holding lock:
[   63.606414]  (&queue->lock){+.+.+.}, at: [<bf06f8d4>]
omap3isp_video_queue_qbuf+0x30/0x7a4 [omap3_isp]
[   63.616271]
[   63.616271] which lock already depends on the new lock.
[   63.616271]
[   63.624877]
[   63.624877] the existing dependency chain (in reverse order) is:
[   63.632751]
-> #1 (&queue->lock){+.+.+.}:
[   63.637207]        [<c0081948>] lock_acquire+0x94/0x100
[   63.642700]        [<c04f02b0>] mutex_lock_nested+0x40/0x298
[   63.648681]        [<bf0703a0>] omap3isp_video_queue_mmap+0x1c/0xe8
[omap3_isp]
[   63.656372]        [<bf02117c>] v4l2_mmap+0x54/0x88 [videodev]
[   63.662597]        [<c00dc740>] mmap_region+0x2e0/0x520
[   63.668090]        [<c00dcc38>] do_mmap_pgoff+0x2b8/0x340
[   63.673767]        [<c00cdd1c>] vm_mmap_pgoff+0x84/0xac
[   63.679260]        [<c00db4a8>] sys_mmap_pgoff+0x54/0xb0
[   63.684875]        [<c0013660>] ret_fast_syscall+0x0/0x3c
[   63.690551]
-> #0 (&mm->mmap_sem){++++++}:
[   63.695068]        [<c0080e28>] __lock_acquire+0x14bc/0x1ae8
[   63.701019]        [<c0081948>] lock_acquire+0x94/0x100
[   63.706512]        [<c04f095c>] down_read+0x30/0x40
[   63.711639]        [<bf06fb24>]
omap3isp_video_queue_qbuf+0x280/0x7a4 [omap3_isp]
[   63.719543]        [<bf025ca4>] v4l_qbuf+0x3c/0x40 [videodev]
[   63.725646]        [<bf024ba8>] __video_do_ioctl+0x240/0x33c [videodev]
[   63.732635]        [<bf025668>] video_usercopy+0x114/0x40c [videodev]
[   63.739440]        [<bf0215c0>] v4l2_ioctl+0xfc/0x144 [videodev]
[   63.745758]        [<c00fe954>] do_vfs_ioctl+0x7c/0x5ac
[   63.751281]        [<c00feee8>] sys_ioctl+0x64/0x84
[   63.756408]        [<c0013660>] ret_fast_syscall+0x0/0x3c
[   63.762084]
[   63.762084] other info that might help us debug this:
[   63.762084]
[   63.770507]  Possible unsafe locking scenario:
[   63.770507]
[   63.776702]        CPU0                    CPU1
[   63.781463]        ----                    ----
[   63.786224]   lock(&queue->lock);
[   63.789733]                                lock(&mm->mmap_sem);
[   63.795959]                                lock(&queue->lock);
[   63.802124]   lock(&mm->mmap_sem);
[   63.805694]
[   63.805694]  *** DEADLOCK ***
[   63.805694]
[   63.811950] 1 lock held by live/1273:
[   63.815795]  #0:  (&queue->lock){+.+.+.}, at: [<bf06f8d4>]
omap3isp_video_queue_qbuf+0x30/0x7a4 [omap3_isp]
[   63.826141]
[   63.826141] stack backtrace:
[   63.830749] [<c00196d4>] (unwind_backtrace+0x0/0xf0) from
[<c04eb478>] (print_circular_bug+0x25c/0x2a8)
[   63.840637] [<c04eb478>] (print_circular_bug+0x25c/0x2a8) from
[<c0080e28>] (__lock_acquire+0x14bc/0x1ae8)
[   63.850769] [<c0080e28>] (__lock_acquire+0x14bc/0x1ae8) from
[<c0081948>] (lock_acquire+0x94/0x100)
[   63.860290] [<c0081948>] (lock_acquire+0x94/0x100) from
[<c04f095c>] (down_read+0x30/0x40)
[   63.869018] [<c04f095c>] (down_read+0x30/0x40) from [<bf06fb24>]
(omap3isp_video_queue_qbuf+0x280/0x7a4 [omap3_isp])
[   63.880126] [<bf06fb24>] (omap3isp_video_queue_qbuf+0x280/0x7a4
[omap3_isp]) from [<bf025ca4>] (v4l_qbuf+0x3c/0x40 [videodev])
[   63.892181] [<bf025ca4>] (v4l_qbuf+0x3c/0x40 [videodev]) from
[<bf024ba8>] (__video_do_ioctl+0x240/0x33c [videodev])
[   63.903289] [<bf024ba8>] (__video_do_ioctl+0x240/0x33c [videodev])
from [<bf025668>] (video_usercopy+0x114/0x40c [videodev])
[   63.915161] [<bf025668>] (video_usercopy+0x114/0x40c [videodev])
from [<bf0215c0>] (v4l2_ioctl+0xfc/0x144 [videodev])
[   63.926330] [<bf0215c0>] (v4l2_ioctl+0xfc/0x144 [videodev]) from
[<c00fe954>] (do_vfs_ioctl+0x7c/0x5ac)
[   63.936218] [<c00fe954>] (do_vfs_ioctl+0x7c/0x5ac) from
[<c00feee8>] (sys_ioctl+0x64/0x84)
[   63.944915] [<c00feee8>] (sys_ioctl+0x64/0x84) from [<c0013660>]
(ret_fast_syscall+0x0/0x3c)
dev/video5 opened: OMAP3 ISP resizer input (media).
Device /dev/video6 opened: OMAP3 ISP resizer output (media).
/dev/video6: 3 buffers requested.
/dev/video6: buffer 0 valid.
/dev/video6: buffer 1 valid.
/dev/video6: buffer 2 valid.
AEWB: #win 10x7 start 6x0 size 74x68 inc 10x8
AE: factor 1.7799 exposure 1779 sensor gain 8
AEWB: stats error, skipping buffer.
AEWB: stats error, skipping buffer.
AE: factor 0.3495 exposure 621 sensor gain 8
AE: factor 0.3642 exposure 226 sensor gain 8
AEWB: stats error, skipping buffer.
AEWB: stats error, skipping buffer.
