Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:34300 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594Ab2GBHZ2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Jul 2012 03:25:28 -0400
Received: by obbuo13 with SMTP id uo13so7818523obb.19
        for <linux-media@vger.kernel.org>; Mon, 02 Jul 2012 00:25:28 -0700 (PDT)
MIME-Version: 1.0
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Mon, 2 Jul 2012 12:55:08 +0530
Message-ID: <CA+V-a8t35XnKJkz36Auf5h5kpc0JjCAG6e57A90mEamSRfB9LQ@mail.gmail.com>
Subject: Recent update to page_alloc.c causing a crash
To: linux-media <linux-media@vger.kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Recently when I updated my driver to 3.5 from 3.3, I am observing that
my driver is failing for dma_alloc_coherent,
when I traced it, I see lots of changes for MM in 3.5 release any
Ideas why this could be happening?
Here  is the case my driver works fine for 7 runs of the application
for 8th time it crashes for MMAP buffers below is
the crash log.

Thx,
--Prabhakar Lad

vpif_mmap_loopb: page allocation failure: order:10, mode:0xd0
Backtrace:
[<c000c608>] (dump_backtrace+0x0/0x114) from [<c033cfc0>] (dump_stack+0x18/0x1c)
 r6:00000000 r5:000000d0 r4:00000001 r3:c048a060
[<c033cfa8>] (dump_stack+0x0/0x1c) from [<c0061c00>]
(warn_alloc_failed+0xf4/0x118)
[<c0061b0c>] (warn_alloc_failed+0x0/0x118) from [<c00627f4>]
(__alloc_pages_nodemask+0x544/0x590)
 r3:c2cfbb64 r2:00000000
 r7:c04b2f94 r6:c2cfa000 r5:0000000a r4:000000d0
[<c00622b0>] (__alloc_pages_nodemask+0x0/0x590) from [<c000e084>]
(arm_dma_alloc+0x138/0x358)
[<c000df4c>] (arm_dma_alloc+0x0/0x358) from [<c024ca94>]
(vb2_dma_contig_alloc+0x78/0xfc)
[<c024ca1c>] (vb2_dma_contig_alloc+0x0/0xfc) from [<c024a6cc>]
(__vb2_queue_alloc+0xd4/0x338)
 r6:c36d5400 r5:00000000 r4:c361a190
[<c024a5f8>] (__vb2_queue_alloc+0x0/0x338) from [<c024adfc>]
(vb2_reqbufs+0x22c/0x308)
[<c024abd0>] (vb2_reqbufs+0x0/0x308) from [<c025399c>]
(vpif_reqbufs+0x114/0x148)
 r7:00000001 r6:c2cfbe20 r5:c361a000 r4:c2d09400
[<c0253888>] (vpif_reqbufs+0x0/0x148) from [<c023a470>]
(__video_do_ioctl+0x1a14/0x4914)
 r8:c0145608 r7:c03601e8 r6:00000000 r5:c3563000 r4:c2cfbe20
r3:00000000
[<c0238a5c>] (__video_do_ioctl+0x0/0x4914) from [<c0238890>]
(video_usercopy+0x368/0x4b4)
[<c0238528>] (video_usercopy+0x0/0x4b4) from [<c02389f0>]
(video_ioctl2+0x14/0x1c)
[<c02389dc>] (video_ioctl2+0x0/0x1c) from [<c02367e8>] (v4l2_ioctl+0xac/0x158)
[<c023673c>] (v4l2_ioctl+0x0/0x158) from [<c009e67c>] (vfs_ioctl+0x28/0x40)
 r8:c00095a4 r7:00000003 r6:c37992b0 r5:c2c77e80 r4:bed27a24
r3:c023673c
[<c009e654>] (vfs_ioctl+0x0/0x40) from [<c009edd8>] (do_vfs_ioctl+0x52c/0x588)
[<c009e8ac>] (do_vfs_ioctl+0x0/0x588) from [<c009ee74>] (sys_ioctl+0x40/0x64)
 r9:c2cfa000 r8:c00095a4 r7:00000003 r6:c0145608 r5:bed27a24
r4:c2c77e80
[<c009ee34>] (sys_ioctl+0x0/0x64) from [<c0009420>] (ret_fast_syscall+0x0/0x2c)
 r7:00000036 r6:00008710 r5:00000000 r4:0000b308
Mem-info:
DMA per-cpu:
CPU    0: hi:   18, btch:   3 usd:   3
active_anon:315 inactive_anon:18 isolated_anon:0
 active_file:3 inactive_file:112 isolated_file:0
 unevictable:0 dirty:0 writeback:0 unstable:0
 free:12196 slab_reclaimable:236 slab_unreclaimable:569
 mapped:31 shmem:22 pagetables:34 bounce:0
DMA free:48712kB min:984kB low:1228kB high:1476kB active_anon:1260kB
inactive_anon:72kB active_file:12kB inactive_file:560kB
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:609o
lowmem_reserve[]: 0 0 0
DMA: 69*4kB 108*8kB 115*16kB 53*32kB 44*64kB 19*128kB 13*256kB 9*512kB
8*1024kB 11*2048kB 0*4096kB = 48580kB
217 total pagecache pages
0 pages in swap cache
Swap cache stats: add 0, delete 0, find 0/0
Free swap  = 0kB
Total swap = 0kB
15360 pages of RAM
12199 free pages
1335 reserved pages
669 slab pages
155 pages shared
0 pages swap cached
vpif_capture vpif_capture: dma_alloc_coherent of size 2622464 failed
cannot allocate memory
: Cannot allocate memory
