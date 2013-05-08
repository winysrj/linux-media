Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.skyhub.de ([78.46.96.112]:41491 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900Ab3EHUJb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 May 2013 16:09:31 -0400
Date: Wed, 8 May 2013 22:11:18 +0200
From: Borislav Petkov <bp@alien8.de>
To: linux-media@vger.kernel.org
Subject: WARNING: at drivers/media/v4l2-core/videobuf2-core.c:2065
 vb2_queue_init+0x74/0x142()
Message-ID: <20130508201118.GH30955@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This one looks legit: bw-qcam.c doesn't set q->timestamp_type.

[  146.989016] Colour QuickCam for Video4Linux v0.06
[  147.713065] ------------[ cut here ]------------
[  147.928854] WARNING: at drivers/media/v4l2-core/videobuf2-core.c:2065 vb2_queue_init+0x74/0x142()
[  148.364433] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.9.0-12947-g0f99ebe5052a #1
[  148.799135] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[  149.017598]  ffffffff8239cab3 ffff88007b789d48 ffffffff81d81cb0 ffff88007b789d88
[  149.465524]  ffffffff810943a8 ffff88007b789d88 0000000000000000 ffff880079a7a700
[  149.909985]  ffff880079a7a068 ffff880079a7a608 ffff8800798d1c00 ffff88007b789d98
[  150.345653] Call Trace:
[  150.550444]  [<ffffffff81d81cb0>] dump_stack+0x19/0x1b
[  150.756860]  [<ffffffff810943a8>] warn_slowpath_common+0x62/0x7b
[  150.962012]  [<ffffffff8109448c>] warn_slowpath_null+0x1a/0x1e
[  151.160574]  [<ffffffff818e914a>] vb2_queue_init+0x74/0x142
[  151.354795]  [<ffffffff818ff072>] bwqcam_attach+0x1e0/0x54a
[  151.543644]  [<ffffffff815cdeb1>] parport_register_driver+0x2e/0x6d
[  151.727651]  [<ffffffff82a8ddf5>] ? cqcam_init+0x20/0x20
[  151.906958]  [<ffffffff82a8de05>] init_bw_qcams+0x10/0x12
[  152.084031]  [<ffffffff82a3cdb9>] do_one_initcall+0x7b/0x116
[  152.262088]  [<ffffffff82a3cfb4>] kernel_init_freeable+0x160/0x1f2
[  152.441466]  [<ffffffff82a3c73a>] ? do_early_param+0x8c/0x8c
[  152.619998]  [<ffffffff81d6874b>] ? rest_init+0xdf/0xdf
[  152.797458]  [<ffffffff81d68759>] kernel_init+0xe/0xdb
[  152.970650]  [<ffffffff81d9663c>] ret_from_fork+0x7c/0xb0
[  153.140434]  [<ffffffff81d6874b>] ? rest_init+0xdf/0xdf
[  153.305520] ---[ end trace a72f2983de4c60b5 ]---
[  154.459479] No Quickcam found on port parport0
[  154.613448] Quickcam detection counter: 0

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
