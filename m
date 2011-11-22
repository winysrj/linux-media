Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47881 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757061Ab1KVPEK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Nov 2011 10:04:10 -0500
MIME-Version: 1.0
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 22 Nov 2011 17:02:29 +0200
Message-ID: <CAK=Wgbbt-c-PzmqWmJ-wMaWup-Jm6vzjrKkonXSMirGq+V-BJQ@mail.gmail.com>
Subject: omap3isp hangs with 3.2-rc2
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

With 3.2-rc2, omap3isp seems to silently hang in my setup (sensor-less OMAP3).

Turning on lockdep yields the below messages, care to take a quick look ?

Thanks!
Ohad.

root@zoom3:~# media-ctl -r -l '"OMAP3 ISP CCP2 input":0->"OMAP3 ISP
CCP2":0[1], "OMAP3 ISP CCP
2":1->"OMAP3 ISP CCDC":0[1], "OMAP3 ISP CCDC":1->"OMAP3 ISP CCDC output":0[1]'
media-ctl -f '"OMAP3 ISP CCP2":0[SGRBG10 1280x1024], "OMAP3 ISP CCP2":1[SGRBG10
1280x1024], "OMAP3 ISP CCDC":1[SGRBG10 1280x1024], "OMAP3 ISP CCDC":2[SGRBG10 12
80x1023]'

[   29.014221] Linux video capture interface: v2.00
[   29.423675] omap3isp omap3isp: Revision 15.0 found
[   29.429168] omap-iommu omap-iommu.0: isp: version 1.1
Resetting all links to inactive
Setting up link 2:0 -> 1:0 [1]
Setting up link 1:1 -> 5:0 [1]
Setting up link 5:1 -> 6:0 [1]
Setting up format SGRBG10 1280x1024 on pad OMAP3 ISP CCP2/0
Format set: SGRBG10 1280x1024
Setting up format SGRBG10 1280x1024 on pad OMAP3 ISP CCP2/1
Format set: SGRBG10 1280x1024
Setting up format SGRBG10 1280x1024 on pad OMAP3 ISP CCDC/0
Format set: SGRBG10 1280x1024
Setting up format SGRBG10 1280x1024 on pad OMAP3 ISP CCDC/1
Format set: SGRBG10 1280x1024
Setting up format SGRBG10 1280x1023 on pad OMAP3 ISP CCDC/2
Format set: SGRBG10 1280x1023
Setting up format SGRBG10 1280x1023 on pad OMAP3 ISP AEWB/0
Unable to set format: Invalid argument (-22)
Setting up format SGRBG10 1280x1023 on pad OMAP3 ISP AF/0
Unable to set format: Invalid argument (-22)
Setting up format SGRBG10 1280x1023 on pad OMAP3 ISP histogram/0
Unable to set format: Invalid argument (-22)

At this point, running 'yavta.sh CCP2 input' and 'yavta.sh CCDC
output' in two different terminals yields:

root@zoom2:~# [   55.867156] INFO: trying to register non-static key.
[   55.872161] the code is fine but needs lockdep annotation.
[   55.877624] turning off the locking correctness validator.
[   55.883178] [<c001c8f0>] (unwind_backtrace+0x0/0x134) from
[<c009304c>] (__lock_acquire+0x79c/0xb54)
[   55.892333] [<c009304c>] (__lock_acquire+0x79c/0xb54) from
[<c0093a44>] (lock_acquire+0x98/0x118)
[   55.901214] [<c0093a44>] (lock_acquire+0x98/0x118) from
[<c0498bb0>] (_raw_spin_lock_irqsave+0x5c/0x70)
[   55.910675] [<c0498bb0>] (_raw_spin_lock_irqsave+0x5c/0x70) from
[<bf0393c4>] (v4l2_event_queue+0x28/0x6c [videodev])
[   55.921417] [<bf0393c4>] (v4l2_event_queue+0x28/0x6c [videodev])
from [<bf0612b0>] (ccdc_hs_vs_isr+0x3c/0x44 [omap3_isp])
[   55.932464] [<bf0612b0>] (ccdc_hs_vs_isr+0x3c/0x44 [omap3_isp])
from [<bf0614a8>] (omap3isp_ccdc_isr+0x1f0/0x430 [omap3_isp])
[   55.943847] [<bf0614a8>] (omap3isp_ccdc_isr+0x1f0/0x430
[omap3_isp]) from [<bf057514>] (isp_isr+0x174/0x284 [omap3_isp])
[   55.954742] [<bf057514>] (isp_isr+0x174/0x284 [omap3_isp]) from
[<c00a41d4>] (handle_irq_event_percpu+0x64/0x268)
[   55.965026] [<c00a41d4>] (handle_irq_event_percpu+0x64/0x268) from
[<c00a4414>] (handle_irq_event+0x3c/0x5c)
[   55.974884] [<c00a4414>] (handle_irq_event+0x3c/0x5c) from
[<c00a7264>] (handle_level_irq+0xac/0x118)
[   55.984130] [<c00a7264>] (handle_level_irq+0xac/0x118) from
[<c00a3c78>] (generic_handle_irq+0x34/0x44)
[   55.993530] [<c00a3c78>] (generic_handle_irq+0x34/0x44) from
[<c0015c38>] (handle_IRQ+0x4c/0xac)
[   56.002349] [<c0015c38>] (handle_IRQ+0x4c/0xac) from [<c049961c>]
(__irq_svc+0x3c/0xe0)
[   56.010375] [<c049961c>] (__irq_svc+0x3c/0xe0) from [<c005fe80>]
(__do_softirq+0x64/0x244)
[   56.018646] [<c005fe80>] (__do_softirq+0x64/0x244) from
[<c00602b8>] (irq_exit+0xa0/0xa8)
[   56.026824] [<c00602b8>] (irq_exit+0xa0/0xa8) from [<c0015c3c>]
(handle_IRQ+0x50/0xac)
[   56.034759] [<c0015c3c>] (handle_IRQ+0x50/0xac) from [<c049961c>]
(__irq_svc+0x3c/0xe0)
[   56.042785] [<c049961c>] (__irq_svc+0x3c/0xe0) from [<c0499340>]
(_raw_spin_unlock_irqrestore+0x34/0x5c)
[   56.052307] [<c0499340>] (_raw_spin_unlock_irqrestore+0x34/0x5c)
from [<bf059284>] (omap3isp_video_queue_streamon+0x8c/0x9c
[omap3_isp])
[   56.064636] [<bf059284>] (omap3isp_video_queue_streamon+0x8c/0x9c
[omap3_isp]) from [<bf05b2b8>] (isp_video_streamon+0x158/0x23c
[omap3_isp])
[   56.077392] [<bf05b2b8>] (isp_video_streamon+0x158/0x23c
[omap3_isp]) from [<bf034f28>] (__video_do_ioctl+0x271c/0x5bb8
[videodev])
[   56.089263] [<bf034f28>] (__video_do_ioctl+0x271c/0x5bb8
[videodev]) from [<bf0323c4>] (video_usercopy+0x138/0x50c [videodev])
[   56.100708] [<bf0323c4>] (video_usercopy+0x138/0x50c [videodev])
from [<bf031464>] (v4l2_ioctl+0x88/0x150 [videodev])
[   56.111358] [<bf031464>] (v4l2_ioctl+0x88/0x150 [videodev]) from
[<c011b3b0>] (do_vfs_ioctl+0x7c/0x5b4)
[   56.120758] [<c011b3b0>] (do_vfs_ioctl+0x7c/0x5b4) from
[<c011b95c>] (sys_ioctl+0x74/0x7c)
[   56.129028] [<c011b95c>] (sys_ioctl+0x74/0x7c) from [<c0014b80>]
(ret_fast_syscall+0x0/0x3c)

[   71.577758] BUG: spinlock lockup on CPU#0, yavta/1302
[   71.582824]  lock: cf345e0c, .magic: 00000000, .owner: <none>/-1,
.owner_cpu: 0
[   71.590148] [<c001c8f0>] (unwind_backtrace+0x0/0x134) from
[<c0265034>] (do_raw_spin_lock+0xb8/0x150)
[   71.599395] [<c0265034>] (do_raw_spin_lock+0xb8/0x150) from
[<c0498bb8>] (_raw_spin_lock_irqsave+0x64/0x70)
[   71.609161] [<c0498bb8>] (_raw_spin_lock_irqsave+0x64/0x70) from
[<bf0393c4>] (v4l2_event_queue+0x28/0x6c [videodev])
[   71.619842] [<bf0393c4>] (v4l2_event_queue+0x28/0x6c [videodev])
from [<bf0612b0>] (ccdc_hs_vs_isr+0x3c/0x44 [omap3_isp])
[   71.630889] [<bf0612b0>] (ccdc_hs_vs_isr+0x3c/0x44 [omap3_isp])
from [<bf0614a8>] (omap3isp_ccdc_isr+0x1f0/0x430 [omap3_isp])
[   71.642272] [<bf0614a8>] (omap3isp_ccdc_isr+0x1f0/0x430
[omap3_isp]) from [<bf057514>] (isp_isr+0x174/0x284 [omap3_isp])
[   71.653198] [<bf057514>] (isp_isr+0x174/0x284 [omap3_isp]) from
[<c00a41d4>] (handle_irq_event_percpu+0x64/0x268)
[   71.663482] [<c00a41d4>] (handle_irq_event_percpu+0x64/0x268) from
[<c00a4414>] (handle_irq_event+0x3c/0x5c)
[   71.673309] [<c00a4414>] (handle_irq_event+0x3c/0x5c) from
[<c00a7264>] (handle_level_irq+0xac/0x118)
[   71.682556] [<c00a7264>] (handle_level_irq+0xac/0x118) from
[<c00a3c78>] (generic_handle_irq+0x34/0x44)
[   71.691955] [<c00a3c78>] (generic_handle_irq+0x34/0x44) from
[<c0015c38>] (handle_IRQ+0x4c/0xac)
[   71.700775] [<c0015c38>] (handle_IRQ+0x4c/0xac) from [<c049961c>]
(__irq_svc+0x3c/0xe0)
[   71.708770] [<c049961c>] (__irq_svc+0x3c/0xe0) from [<c005fe80>]
(__do_softirq+0x64/0x244)
[   71.717071] [<c005fe80>] (__do_softirq+0x64/0x244) from
[<c00602b8>] (irq_exit+0xa0/0xa8)
[   71.725250] [<c00602b8>] (irq_exit+0xa0/0xa8) from [<c0015c3c>]
(handle_IRQ+0x50/0xac)
[   71.733184] [<c0015c3c>] (handle_IRQ+0x50/0xac) from [<c049961c>]
(__irq_svc+0x3c/0xe0)
[   71.741210] [<c049961c>] (__irq_svc+0x3c/0xe0) from [<c0499340>]
(_raw_spin_unlock_irqrestore+0x34/0x5c)
[   71.750732] [<c0499340>] (_raw_spin_unlock_irqrestore+0x34/0x5c)
from [<bf059284>] (omap3isp_video_queue_streamon+0x8c/0x9c
[omap3_isp])
[   71.763061] [<bf059284>] (omap3isp_video_queue_streamon+0x8c/0x9c
[omap3_isp]) from [<bf05b2b8>] (isp_video_streamon+0x158/0x23c
[omap3_isp])
[   71.775817] [<bf05b2b8>] (isp_video_streamon+0x158/0x23c
[omap3_isp]) from [<bf034f28>] (__video_do_ioctl+0x271c/0x5bb8
[videodev])
[   71.787689] [<bf034f28>] (__video_do_ioctl+0x271c/0x5bb8
[videodev]) from [<bf0323c4>] (video_usercopy+0x138/0x50c [videodev])
[   71.799133] [<bf0323c4>] (video_usercopy+0x138/0x50c [videodev])
from [<bf031464>] (v4l2_ioctl+0x88/0x150 [videodev])
[   71.809753] [<bf031464>] (v4l2_ioctl+0x88/0x150 [videodev]) from
[<c011b3b0>] (do_vfs_ioctl+0x7c/0x5b4)
[   71.819183] [<c011b3b0>] (do_vfs_ioctl+0x7c/0x5b4) from
[<c011b95c>] (sys_ioctl+0x74/0x7c)
[   71.827453] [<c011b95c>] (sys_ioctl+0x74/0x7c) from [<c0014b80>]
(ret_fast_syscall+0x0/0x3c)
