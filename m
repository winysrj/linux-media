Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36780 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761027Ab2FVDkU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jun 2012 23:40:20 -0400
Received: by obbuo13 with SMTP id uo13so1327313obb.19
        for <linux-media@vger.kernel.org>; Thu, 21 Jun 2012 20:40:20 -0700 (PDT)
MIME-Version: 1.0
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Fri, 22 Jun 2012 09:09:59 +0530
Message-ID: <CA+V-a8uDgmiy52wEs0rR5B08aAmSk=Wyf+e3mMzazeGykdMA4w@mail.gmail.com>
Subject: Recent patch for videobuf causing a crash to my driver
To: linux-media@vger.kernel.org,
	Federico Vaga <federico.vaga@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Federico,

Recent patch from you (commit id a8f3c203e19b702fa5e8e83a9b6fb3c5a6d1cce4) which
added cached buffer support to videobuf dma contig, is causing my
driver to crash.
Has this patch being tested for 'uncached' buffers ? If I replace this
mapping logic with
remap_pfn_range() my driver works without any crash.

Or is that I am missing somewhere ?

------
Thx,
--Prabhakar

Following is the crash log:

Unable to handle kernel paging request at virtual address e1a0201a
pgd = c372c000
[e1a0201a] *pgd=00000000
Internal error: Oops: 1 [#1] PREEMPT ARM
Modules linked in:
CPU: 0    Not tainted  (3.5.0-rc3+ #32)
PC is at flush_dcache_page+0x4c/0x1b8
LR is at insert_page+0x38/0x158
pc : [<c000f028>]    lr : [<c0075b58>]    psr: a0000013
sp : c36d5d90  ip : c36d5dd8  fp : c36d5dd4
r10: c5000000  r9 : 00000000  r8 : 00281000
r7 : 00000103  r6 : c2d60780  r5 : e1a02006  r4 : c056f000
r3 : 00000000  r2 : e1a02006  r1 : b6bb8000  r0 : c056f000
Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 0005317f  Table: c372c000  DAC: 00000015
Process vpif_display (pid: 1167, stack limit = 0xc36d4270)
Stack: (0xc36d5d90 to 0xc36d6000)
5d80:                                     00000000 00000000 c36d5de4 c36d5da8
5da0: c0019da8 c00194d0 c04b1fc0 0000000d c056f000 b6bb8000 c2d60780 00000103
5dc0: 00281000 c5000000 c36d5e04 c36d5dd8 c0075b58 c000efec c36d5e04 c36d5de8
5de0: c033c164 c2c349a0 c365e264 c364a20c c37abd60 00281000 c36d5e14 c36d5e08
5e00: c0075cd8 c0075b30 c36d5e4c c36d5e18 c0248ca0 c0075c88 00000003 b6bb8000
5e20: 00000000 c364a20c c2c349a0 c365ed80 c2d60780 b6bb8000 00000281 c37a6688
5e40: c36d5e64 c36d5e50 c0246608 c0248b58 c2c349a0 c364a000 c36d5e7c c36d5e68
5e60: c0250364 c0246548 c3611a00 c2c349a0 c36d5e9c c36d5e80 c0235c90 c0250334
5e80: c035c608 c2c349a0 000000ff c365ed80 c36d5f04 c36d5ea0 c007ab78 c0235c2c
5ea0: 000000ff 00000000 c365ed80 00000000 00000000 c365ed80 00000001 00281000
5ec0: b6e39000 00000000 00000007 c374bcd4 c374bcdc c374b8f0 c36d5f04 c365ed80
5ee0: 000000ff 00281000 00000007 00000001 00000000 c2d60780 c36d5f44 c36d5f08
5f00: c007b034 c007a950 000000ff 00000000 c365ed80 00000281 c36d5f34 c2d607b4
5f20: c365ed80 00000003 00280400 00000000 c36d4000 00000000 c36d5f74 c36d5f48
5f40: c006efd0 c007adbc 00000001 00000000 c36d5f74 c365ed80 00000001 00000003
5f60: 00280400 00000000 c36d5fa4 c36d5f78 c0079364 c006ef7c 00000001 00000000
5f80: 00001000 00000003 00000000 00008598 000000c0 c00095a4 00000000 c36d5fa8
5fa0: c0009420 c00792f8 00000003 00000000 00000000 00280400 00000003 00000001
5fc0: 00000003 00000000 00008598 000000c0 00000000 00000000 b6f9c000 bef89c94
5fe0: 00000000 bef89b58 00008b54 b6ef8908 40000010 00000000 00000000 00000000
Backtrace:
[<c000efdc>] (flush_dcache_page+0x0/0x1b8) from [<c0075b58>]
(insert_page+0x38/0x158)
[<c0075b20>] (insert_page+0x0/0x158) from [<c0075cd8>]
(vm_insert_page+0x60/0x6c)
 r8:00281000 r7:c37abd60 r6:c364a20c r5:c365e264 r4:c2c349a0
[<c0075c78>] (vm_insert_page+0x0/0x6c) from [<c0248ca0>]
(__videobuf_mmap_mapper+0x158/0x1f4)
[<c0248b48>] (__videobuf_mmap_mapper+0x0/0x1f4) from [<c0246608>]
(videobuf_mmap_mapper+0xd0/0x114)
[<c0246538>] (videobuf_mmap_mapper+0x0/0x114) from [<c0250364>]
(vpif_mmap+0x40/0x50)
 r5:c364a000 r4:c2c349a0
[<c0250324>] (vpif_mmap+0x0/0x50) from [<c0235c90>] (v4l2_mmap+0x74/0x98)
 r5:c2c349a0 r4:c3611a00
[<c0235c1c>] (v4l2_mmap+0x0/0x98) from [<c007ab78>] (mmap_region+0x238/0x46c)
 r6:c365ed80 r5:000000ff r4:c2c349a0 r3:c035c608
[<c007a940>] (mmap_region+0x0/0x46c) from [<c007b034>]
(do_mmap_pgoff+0x288/0x2e8)
[<c007adac>] (do_mmap_pgoff+0x0/0x2e8) from [<c006efd0>]
(vm_mmap_pgoff+0x64/0x7c)
[<c006ef6c>] (vm_mmap_pgoff+0x0/0x7c) from [<c0079364>]
(sys_mmap_pgoff+0x7c/0x9c)
 r8:00000000 r7:00280400 r6:00000003 r5:00000001 r4:c365ed80
[<c00792e8>] (sys_mmap_pgoff+0x0/0x9c) from [<c0009420>]
(ret_fast_syscall+0x0/0x2c)
 r8:c00095a4 r7:000000c0 r6:00008598 r5:00000000 r4:00000003
Code: 11a05003 1a000008 e3550000 0a000006 (e5953014)
---[ end trace 57f3e388e320b7e4 ]--
