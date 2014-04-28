Return-path: <linux-media-owner@vger.kernel.org>
Received: from vserver.eikelenboom.it ([84.200.39.61]:39969 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851AbaD1TLe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Apr 2014 15:11:34 -0400
Date: Mon, 28 Apr 2014 20:45:27 +0200
From: Sander Eikelenboom <linux@eikelenboom.it>
Message-ID: <61399916.20140428204527@eikelenboom.it>
To: Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
CC: linux-media@vger.kernel.org
Subject: WARNING: CPU: 0 PID: 3918 at drivers/media/v4l2-core/videobuf2-core.c:2094 __vb2_queue_cancel+0x11d/0x180()
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

With a 3.15-rc3 kernel i seem to reliably trigger these warnings (which don't 
trigger on 3.14.2) when stopping a video stream. They don't seem to cause to 
much havoc because the devices are still usable after this.

It seems to happen with both this syntek device as with em28xx devices.

--
Sander

[  264.705467] stk1160: queue_setup: buffer count 8, each 691200 bytes
[  264.728032] stk1160: queue_setup: buffer count 8, each 691200 bytes
[  264.736159] stk1160: queue_setup: buffer count 8, each 691200 bytes
[  264.744373] stk1160: setting alternate 5
[  264.748274] stk1160: minimum isoc packet size: 3072 (alt=5)
[  264.753377] stk1160: setting alt 5 with wMaxPacketSize=3072
[  264.758958] stk1160: allocating urbs...
[  264.765254] stk1160: 16 urbs allocated
[  264.772243] stk1160: streaming started
[  270.523114] stk1160: killing 16 urbs...
[  270.656992] stk1160: all urbs killed
[  270.660639] stk1160: freeing 16 urb buffers...
[  270.664925] stk1160: all urb buffers freed
[  270.668891] stk1160: setting alternate 0
[  270.675200] stk1160: buffer [ffff88003b865000/7] aborted
[  270.678496] stk1160: buffer [ffff88003b866400/0] aborted
[  270.678496] stk1160: buffer [ffff88003b864400/1] aborted
[  270.678496] stk1160: buffer [ffff88003b861000/2] aborted
[  270.678496] stk1160: buffer [ffff88003b863800/3] aborted
[  270.678496] stk1160: buffer [ffff88003b861c00/4] aborted
[  270.700760] stk1160: streaming stopped
[  270.703414] ------------[ cut here ]------------
[  270.706603] WARNING: CPU: 0 PID: 3918 at drivers/media/v4l2-core/videobuf2-core.c:2094 __vb2_queue_cancel+0x11d/0x180()
[  270.713272] Modules linked in:
[  270.715907] CPU: 0 PID: 3918 Comm: videograbber.py Not tainted 3.15.0-rc3-security-20140428-v4lall-stkpatch+ #1
[  270.721578] Hardware name: Xen HVM domU, BIOS 4.5-unstable 04/21/2014
[  270.725238]  0000000000000009 ffff88003d589c48 ffffffff81c5277e 0000000000000000
[  270.731505]  ffff88003d589c80 ffffffff810e4aa3 0000000000000000 0000000000000001
[  270.737774]  0000000000000000 ffff88003c3b13e0 0000000000000000 ffff88003d589c90
[  270.744021] Call Trace:
[  270.746022]  [<ffffffff81c5277e>] dump_stack+0x45/0x56
[  270.749420]  [<ffffffff810e4aa3>] warn_slowpath_common+0x73/0x90
[  270.753934]  [<ffffffff810e4b75>] warn_slowpath_null+0x15/0x20
[  270.758987]  [<ffffffff8185067d>] __vb2_queue_cancel+0x11d/0x180
[  270.764168]  [<ffffffff81850766>] vb2_ioctl_streamoff+0x56/0x60
[  270.769276]  [<ffffffff81838785>] v4l_streamoff+0x15/0x20
[  270.774037]  [<ffffffff8183c2c4>] __video_do_ioctl+0x294/0x310
[  270.779124]  [<ffffffff81bdd2f6>] ? unix_stream_sendmsg+0x3a6/0x3e0
[  270.784460]  [<ffffffff8183bd50>] video_usercopy+0x1f0/0x4b0
[  270.789411]  [<ffffffff8183c030>] ? video_ioctl2+0x20/0x20
[  270.794193]  [<ffffffff81ae0e1f>] ? sock_aio_write+0xcf/0xe0
[  270.799136]  [<ffffffff811771eb>] ? free_pages.part.69+0x3b/0x40
[  270.804299]  [<ffffffff8118fe6d>] ? tlb_finish_mmu+0x2d/0x40
[  270.809194]  [<ffffffff8183c020>] video_ioctl2+0x10/0x20
[  270.813879]  [<ffffffff818375ff>] v4l2_ioctl+0x10f/0x150
[  270.818407]  [<ffffffff811d62e0>] do_vfs_ioctl+0x2e0/0x4c0
[  270.822878]  [<ffffffff811c4b1c>] ? vfs_write+0x17c/0x1e0
[  270.827387]  [<ffffffff811d64fc>] SyS_ioctl+0x3c/0x80
[  270.831927]  [<ffffffff81c687b9>] system_call_fastpath+0x16/0x1b
[  270.837545] ---[ end trace 8d6b91c80125b9e2 ]---
[  270.842103] ------------[ cut here ]------------
[  270.846562] WARNING: CPU: 0 PID: 3918 at drivers/media/v4l2-core/videobuf2-core.c:1165 vb2_buffer_done+0x163/0x170()
[  270.856204] Modules linked in:
[  270.859787] CPU: 0 PID: 3918 Comm: videograbber.py Tainted: G        W     3.15.0-rc3-security-20140428-v4lall-stkpatch+ #1
[  270.868591] Hardware name: Xen HVM domU, BIOS 4.5-unstable 04/21/2014
[  270.873886]  0000000000000009 ffff88003d589c10 ffffffff81c5277e 0000000000000000
[  270.882386]  ffff88003d589c48 ffffffff810e4aa3 ffff88003b863000 ffff88003c3b1460
[  270.890943]  0000000000000000 ffff88003c3b13e0 0000000000000003 ffff88003d589c58
[  270.899446] Call Trace:
[  270.902102]  [<ffffffff81c5277e>] dump_stack+0x45/0x56
[  270.906634]  [<ffffffff810e4aa3>] warn_slowpath_common+0x73/0x90
[  270.911926]  [<ffffffff810e4b75>] warn_slowpath_null+0x15/0x20
[  270.916783]  [<ffffffff8184f493>] vb2_buffer_done+0x163/0x170
[  270.921378]  [<ffffffff818506b7>] __vb2_queue_cancel+0x157/0x180
[  270.926030]  [<ffffffff81850766>] vb2_ioctl_streamoff+0x56/0x60
[  270.931019]  [<ffffffff81838785>] v4l_streamoff+0x15/0x20
[  270.935648]  [<ffffffff8183c2c4>] __video_do_ioctl+0x294/0x310
[  270.940571]  [<ffffffff81bdd2f6>] ? unix_stream_sendmsg+0x3a6/0x3e0
[  270.945806]  [<ffffffff8183bd50>] video_usercopy+0x1f0/0x4b0
[  270.950581]  [<ffffffff8183c030>] ? video_ioctl2+0x20/0x20
[  270.955479]  [<ffffffff81ae0e1f>] ? sock_aio_write+0xcf/0xe0
[  270.960517]  [<ffffffff811771eb>] ? free_pages.part.69+0x3b/0x40
[  270.965703]  [<ffffffff8118fe6d>] ? tlb_finish_mmu+0x2d/0x40
[  270.970702]  [<ffffffff8183c020>] video_ioctl2+0x10/0x20
[  270.975462]  [<ffffffff818375ff>] v4l2_ioctl+0x10f/0x150
[  270.980200]  [<ffffffff811d62e0>] do_vfs_ioctl+0x2e0/0x4c0
[  270.985080]  [<ffffffff811c4b1c>] ? vfs_write+0x17c/0x1e0
[  270.989909]  [<ffffffff811d64fc>] SyS_ioctl+0x3c/0x80
[  270.994470]  [<ffffffff81c687b9>] system_call_fastpath+0x16/0x1b
[  270.999670] ---[ end trace 8d6b91c80125b9e3 ]---

