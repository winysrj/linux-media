Return-path: <mchehab@pedra>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:8504 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520Ab1FPIue convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jun 2011 04:50:34 -0400
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-2
Received: from eu_spt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LMV00BB0KK87G00@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 16 Jun 2011 09:50:32 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LMV00I46KK7GT@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 16 Jun 2011 09:50:31 +0100 (BST)
Date: Thu, 16 Jun 2011 10:49:56 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: no mmu on videobuf2
In-reply-to: <BANLkTiksUboG7zvja0rykeg7hpKby3xSvA@mail.gmail.com>
To: 'Scott Jiang' <scott.jiang.linux@gmail.com>,
	'Kassey Lee' <kassey1216@gmail.com>
Cc: hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com,
	linux-media@vger.kernel.org,
	uclinux-dist-devel@blackfin.uclinux.org
Message-id: <000001cc2c02$5dd8d570$198a8050$%szyprowski@samsung.com>
Content-language: pl
Content-transfer-encoding: 8BIT
References: <BANLkTikKA_0QEyaeJth4FYzm61tYT+_Gow@mail.gmail.com>
 <000701cc2be8$3bfb1720$b3f14560$%szyprowski@samsung.com>
 <BANLkTimHFomy+ioM0xgx7iMaqfRjHjvSbA@mail.gmail.com>
 <BANLkTikhqTRHmz=webBbW=pLK2o0hTcwng@mail.gmail.com>
 <BANLkTiksUboG7zvja0rykeg7hpKby3xSvA@mail.gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

On Thursday, June 16, 2011 9:57 AM Scott Jiang wrote:

(snipped)

> >> I used dma-contig allocator. I mean if offset is 0, I must get actual
> >> addr from this offset.
> > hi, Scott
> >
> > if it is single plane, surely the offset is 0 for plane 0
> yes, it is absolutely right.
> 
> > what do you mean the actual addr ?
> I should return virtual address of the buffer in get_unmapped_area callback.
> 
> >
> >
> >> __find_plane_by_offset can do this. But it is an internal function.
> >> I think there should be a function called vb2_get_unmapped_area to do
> >> this in framework side.
> > are you using soc_camera ?
> > you can add your get_unmapped_area  in soc_camera.
> > if not, you can add it in your v4l2_file_operations ops, while still
> > using videbuf2 to management your buffer.
> yes, I have added this method, just copy __find_plane_by_offset code.
> But it is ugly, it should have a vb2_get_unmapped_area like vb2_mmap.
> These two operations are called by one system call, so they should
> have a uniform looks.

If videobuf2-core and its memory allocator interface lacks some operations
that are essential for no-mmu systems, please just add them. Frankly I have
no experience with Linux no-mmu systems, so I might have missed something
that is required for no-mmu case.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


