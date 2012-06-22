Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1680 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761562Ab2FVJ0M (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jun 2012 05:26:12 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Subject: Re: Recent patch for videobuf causing a crash to my driver
Date: Fri, 22 Jun 2012 11:25:30 +0200
Cc: linux-media@vger.kernel.org,
	Federico Vaga <federico.vaga@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <CA+V-a8uDgmiy52wEs0rR5B08aAmSk=Wyf+e3mMzazeGykdMA4w@mail.gmail.com> <4FE423D4.9010609@xs4all.nl> <CA+V-a8tt5wyVjS3XXV_wVq_5eC5z7G+5Hzt-xx1xqv1eGn08Dg@mail.gmail.com>
In-Reply-To: <CA+V-a8tt5wyVjS3XXV_wVq_5eC5z7G+5Hzt-xx1xqv1eGn08Dg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201206221125.30406.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri June 22 2012 11:09:22 Prabhakar Lad wrote:
> Hi Hans,
> 
> On Fri, Jun 22, 2012 at 1:20 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > On 22/06/12 05:39, Prabhakar Lad wrote:
> >>
> >> Hi Federico,
> >>
> >> Recent patch from you (commit id a8f3c203e19b702fa5e8e83a9b6fb3c5a6d1cce4)
> >> which
> >> added cached buffer support to videobuf dma contig, is causing my
> >> driver to crash.
> >> Has this patch being tested for 'uncached' buffers ? If I replace this
> >> mapping logic with
> >> remap_pfn_range() my driver works without any crash.
> >>
> >> Or is that I am missing somewhere ?
> >
> >
> > No, I had the same problem this week with vpif_capture. Since I was running
> > an
> > unusual setup (a 3.0 kernel with the media subsystem patched to 3.5-rc1) I
> > didn't
> > know whether it was caused by a mismatch between 3.0 and a 3.5 media
> > subsystem.
> >
> > I intended to investigate this next week, but now it is clear that it is
> > this patch
> > that is causing the problem.
> >
> > Here is our trace:
> >
> >    Unable to handle kernel paging request at virtual address d5ffdf51
> > pgd = c2ae8000
> > [d5ffdf51] *pgd=00000000
> >
> > Internal error: Oops: 1 [#1] PREEMPT
> > CPU: 0    Not tainted  (3.0.31-jqiang #1)
> > PC is at vm_insert_page+0x34/0x5c
> > LR is at __videobuf_mmap_mapper+0xf0/0x1f4
> > pc : [<c00c1494>]    lr : [<c0215d2c>]    psr: 00000013
> > sp : c5589ed0  ip : 00000000  fp : c5587628
> > r10: c046bc54  r9 : c2a44dc0  r8 : 0011e000
> > r7 : bfc01000  r6 : c5591fc4  r5 : c2afbee8  r4 : 424d5000
> > r3 : c2afbee8  r2 : c0c6f000  r1 : 424d5000  r0 : d5ffdf4d
> > Flags: nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
> > Control: 0005317f  Table: 82ae8000  DAC: 00000015
> > Process Video (pid: 1230, stack limit = 0xc5588270)
> > Stack: (0xc5589ed0 to 0xc558a000)
> > 9ec0:                                     c0215c3c c5587628 c2afbee8
> > 424d5000
> > 9ee0: c564a200 0011e000 0000011e c2afbee8 c5588000 c0213620 c55bf400
> > c2b416e0
> > 9f00: 424d5000 c02020f4 c2b44a90 424d5000 c564a200 c2b44a8c c2b44a90
> > c00c6524
> > 9f20: 000000ff 00000000 c2b416e0 00000000 00000000 c5588000 0011e000
> > c2b44a70
> > 9f40: c2b416e0 00000000 c759fa70 00000001 00000000 425f3000 c7960000
> > 00000001
> > 9f60: c5588000 c2b416e0 00000003 0011df00 c5588000 00000000 00592d2c
> > c00c6ad4
> > 9f80: 000000ff 00000000 00592d2c 00000021 00000000 00000021 000000c0
> > c002bc48
> > 9fa0: 00000000 c002baa0 00000021 00000000 00000000 0011df00 00000003
> > 00000001
> > 9fc0: 00000021 00000000 00000021 000000c0 00000001 00592ca4 000a2aa0
> > 00592d2c
> > 9fe0: 00000000 00592b68 00023ce8 403318d8 40000010 00000000 00000000
> > 00000000
> > [<c00c1494>] (vm_insert_page+0x34/0x5c) from [<c0215d2c>]
> > (__videobuf_mmap_mapper+0xf0/0x1f4)
> > [<c0215d2c>] (__videobuf_mmap_mapper+0xf0/0x1f4) from [<c0213620>]
> > (videobuf_mmap_mapper+0xa0/0x128)
> > [<c0213620>] (videobuf_mmap_mapper+0xa0/0x128) from [<c02020f4>]
> > (v4l2_mmap+0x88/0xb8)
> > [<c02020f4>] (v4l2_mmap+0x88/0xb8) from [<c00c6524>]
> > (mmap_region+0x340/0x530)
> > [<c00c6524>] (mmap_region+0x340/0x530) from [<c00c6ad4>]
> > (sys_mmap_pgoff+0x7c/0xbc)
> > [<c00c6ad4>] (sys_mmap_pgoff+0x7c/0xbc) from [<c002baa0>]
> > (ret_fast_syscall+0x0/0x2c)
> > Code: e5920000 e3100902 1592000c 01a00002 (e5900004)
> > ---[ end trace 907d90a82cfa0ada ]---
> >
> > I've traced the bug to the fact that the page returned by:
> >
> >        page = virt_to_page((void *)pos);
> >
> > does not have a valid page->first_page pointer, causing page_count() to
> > fail.
> >
> > As far as I can tell from reading the diff the remap_pfn_range() was just
> > dropped,
> > presumably by accident.
> >
> > This (untested!) patch restores it:
> >
> > diff --git a/drivers/media/video/videobuf-dma-contig.c
> > b/drivers/media/video/videobuf-dma-contig.c
> > index b6b5cc1..75efd8f 100644
> > --- a/drivers/media/video/videobuf-dma-contig.c
> > +++ b/drivers/media/video/videobuf-dma-contig.c
> > @@ -359,8 +359,17 @@ static int __videobuf_mmap_mapper(struct videobuf_queue
> > *q,
> >        size = vma->vm_end - vma->vm_start;
> >        size = (size < mem->size) ? size : mem->size;
> >  -      if (!mem->cached)
> > +       if (!mem->cached) {
> >                vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> > +               retval = remap_pfn_range(vma, vma->vm_start,
> > +                               mem->dma_handle >> PAGE_SHIFT,
> > +                               size, vma->vm_page_prot);
> > +               if (retval) {
> > +                       dev_err(q->dev, "mmap: remap failed with error
> > %d.\n", retval);
> > +                       __videobuf_dc_free(q->dev, mem);
> > +                       goto error;
> > +               }
> > +       }
> >        pos = (unsigned long)mem->vaddr;
> >
> > I'll test this next week.
> >
> 
>   I have also created a same patch, shall I post It ? I have tested it
> is working for VPIF capture and display.

Yes, please!

Regards,

	Hans

> 
> Thx,
> --Prabhakar Lad
> 
> > Regards,
> >
> >        Hans
> >
> >>
> >> ------
> >> Thx,
> >> --Prabhakar
> >>
> >> Following is the crash log:
> >>
> >> Unable to handle kernel paging request at virtual address e1a0201a
> >> pgd = c372c000
> >> [e1a0201a] *pgd=00000000
> >> Internal error: Oops: 1 [#1] PREEMPT ARM
> >> Modules linked in:
> >> CPU: 0    Not tainted  (3.5.0-rc3+ #32)
> >> PC is at flush_dcache_page+0x4c/0x1b8
> >> LR is at insert_page+0x38/0x158
> >> pc : [<c000f028>]    lr : [<c0075b58>]    psr: a0000013
> >> sp : c36d5d90  ip : c36d5dd8  fp : c36d5dd4
> >> r10: c5000000  r9 : 00000000  r8 : 00281000
> >> r7 : 00000103  r6 : c2d60780  r5 : e1a02006  r4 : c056f000
> >> r3 : 00000000  r2 : e1a02006  r1 : b6bb8000  r0 : c056f000
> >> Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
> >> Control: 0005317f  Table: c372c000  DAC: 00000015
> >> Process vpif_display (pid: 1167, stack limit = 0xc36d4270)
> >> Stack: (0xc36d5d90 to 0xc36d6000)
> >> 5d80:                                     00000000 00000000 c36d5de4
> >> c36d5da8
> >> 5da0: c0019da8 c00194d0 c04b1fc0 0000000d c056f000 b6bb8000 c2d60780
> >> 00000103
> >> 5dc0: 00281000 c5000000 c36d5e04 c36d5dd8 c0075b58 c000efec c36d5e04
> >> c36d5de8
> >> 5de0: c033c164 c2c349a0 c365e264 c364a20c c37abd60 00281000 c36d5e14
> >> c36d5e08
> >> 5e00: c0075cd8 c0075b30 c36d5e4c c36d5e18 c0248ca0 c0075c88 00000003
> >> b6bb8000
> >> 5e20: 00000000 c364a20c c2c349a0 c365ed80 c2d60780 b6bb8000 00000281
> >> c37a6688
> >> 5e40: c36d5e64 c36d5e50 c0246608 c0248b58 c2c349a0 c364a000 c36d5e7c
> >> c36d5e68
> >> 5e60: c0250364 c0246548 c3611a00 c2c349a0 c36d5e9c c36d5e80 c0235c90
> >> c0250334
> >> 5e80: c035c608 c2c349a0 000000ff c365ed80 c36d5f04 c36d5ea0 c007ab78
> >> c0235c2c
> >> 5ea0: 000000ff 00000000 c365ed80 00000000 00000000 c365ed80 00000001
> >> 00281000
> >> 5ec0: b6e39000 00000000 00000007 c374bcd4 c374bcdc c374b8f0 c36d5f04
> >> c365ed80
> >> 5ee0: 000000ff 00281000 00000007 00000001 00000000 c2d60780 c36d5f44
> >> c36d5f08
> >> 5f00: c007b034 c007a950 000000ff 00000000 c365ed80 00000281 c36d5f34
> >> c2d607b4
> >> 5f20: c365ed80 00000003 00280400 00000000 c36d4000 00000000 c36d5f74
> >> c36d5f48
> >> 5f40: c006efd0 c007adbc 00000001 00000000 c36d5f74 c365ed80 00000001
> >> 00000003
> >> 5f60: 00280400 00000000 c36d5fa4 c36d5f78 c0079364 c006ef7c 00000001
> >> 00000000
> >> 5f80: 00001000 00000003 00000000 00008598 000000c0 c00095a4 00000000
> >> c36d5fa8
> >> 5fa0: c0009420 c00792f8 00000003 00000000 00000000 00280400 00000003
> >> 00000001
> >> 5fc0: 00000003 00000000 00008598 000000c0 00000000 00000000 b6f9c000
> >> bef89c94
> >> 5fe0: 00000000 bef89b58 00008b54 b6ef8908 40000010 00000000 00000000
> >> 00000000
> >> Backtrace:
> >> [<c000efdc>] (flush_dcache_page+0x0/0x1b8) from [<c0075b58>]
> >> (insert_page+0x38/0x158)
> >> [<c0075b20>] (insert_page+0x0/0x158) from [<c0075cd8>]
> >> (vm_insert_page+0x60/0x6c)
> >>  r8:00281000 r7:c37abd60 r6:c364a20c r5:c365e264 r4:c2c349a0
> >> [<c0075c78>] (vm_insert_page+0x0/0x6c) from [<c0248ca0>]
> >> (__videobuf_mmap_mapper+0x158/0x1f4)
> >> [<c0248b48>] (__videobuf_mmap_mapper+0x0/0x1f4) from [<c0246608>]
> >> (videobuf_mmap_mapper+0xd0/0x114)
> >> [<c0246538>] (videobuf_mmap_mapper+0x0/0x114) from [<c0250364>]
> >> (vpif_mmap+0x40/0x50)
> >>  r5:c364a000 r4:c2c349a0
> >> [<c0250324>] (vpif_mmap+0x0/0x50) from [<c0235c90>] (v4l2_mmap+0x74/0x98)
> >>  r5:c2c349a0 r4:c3611a00
> >> [<c0235c1c>] (v4l2_mmap+0x0/0x98) from [<c007ab78>]
> >> (mmap_region+0x238/0x46c)
> >>  r6:c365ed80 r5:000000ff r4:c2c349a0 r3:c035c608
> >> [<c007a940>] (mmap_region+0x0/0x46c) from [<c007b034>]
> >> (do_mmap_pgoff+0x288/0x2e8)
> >> [<c007adac>] (do_mmap_pgoff+0x0/0x2e8) from [<c006efd0>]
> >> (vm_mmap_pgoff+0x64/0x7c)
> >> [<c006ef6c>] (vm_mmap_pgoff+0x0/0x7c) from [<c0079364>]
> >> (sys_mmap_pgoff+0x7c/0x9c)
> >>  r8:00000000 r7:00280400 r6:00000003 r5:00000001 r4:c365ed80
> >> [<c00792e8>] (sys_mmap_pgoff+0x0/0x9c) from [<c0009420>]
> >> (ret_fast_syscall+0x0/0x2c)
> >>  r8:c00095a4 r7:000000c0 r6:00008598 r5:00000000 r4:00000003
> >> Code: 11a05003 1a000008 e3550000 0a000006 (e5953014)
> >> ---[ end trace 57f3e388e320b7e4 ]--
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> >
> 
