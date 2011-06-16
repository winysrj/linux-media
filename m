Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:37580 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757354Ab1FPIui (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jun 2011 04:50:38 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Scott Jiang <scott.jiang.linux@gmail.com>
Subject: Re: no mmu on videobuf2
Date: Thu, 16 Jun 2011 10:50:36 +0200
Cc: Kassey Lee <kassey1216@gmail.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	hans.verkuil@cisco.com, linux-media@vger.kernel.org,
	uclinux-dist-devel@blackfin.uclinux.org
References: <BANLkTikKA_0QEyaeJth4FYzm61tYT+_Gow@mail.gmail.com> <BANLkTikhqTRHmz=webBbW=pLK2o0hTcwng@mail.gmail.com> <BANLkTiksUboG7zvja0rykeg7hpKby3xSvA@mail.gmail.com>
In-Reply-To: <BANLkTiksUboG7zvja0rykeg7hpKby3xSvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106161050.37826.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Scott,

On Thursday 16 June 2011 09:57:05 Scott Jiang wrote:
> 2011/6/16 Kassey Lee <kassey1216@gmail.com>:
> > 2011/6/16 Scott Jiang <scott.jiang.linux@gmail.com>:
> >> 2011/6/16 Marek Szyprowski <m.szyprowski@samsung.com>:
> >>>> Hi Marek and Laurent,
> >>>> 
> >>>> I am working on v4l2 drivers for blackfin which is a no mmu soc.
> >>>> I found videobuf allocate memory in mmap not reqbuf, so I turn to
> >>>> videobuf2. But __setup_offsets() use plane offset to fill m.offset,
> >>>> which is always 0 for single-planar buffer.
> >>>> So pgoff in get_unmapped_area callback equals 0.
> >>>> I only found uvc handled get_unmapped_area for no mmu system, but it
> >>>> manages buffers itself.
> >>>> I really want videobuf2 to manage buffers. Please give me some advice.
> >>> 
> >>> I'm not really sure if I know the differences between mmu and no-mmu
> >>> systems (from the device driver perspective). I assume that you are
> >>> using videobuf2-vmalloc allocator. Note that memory
> >>> allocators/managers are well separated from the videobuf2 logic. If it
> >>> the current one doesn't serve you well you can make your own no-mmu
> >>> allocator. Later once we identify all differences it might be merged
> >>> with the standard one or left alone if the merge is not really
> >>> possible or easy.
> >> 
> >> I used dma-contig allocator. I mean if offset is 0, I must get actual
> >> addr from this offset.
> > 
> > if it is single plane, surely the offset is 0 for plane 0
> 
> yes, it is absolutely right.
> 
> > what do you mean the actual addr ?
> 
> I should return virtual address of the buffer in get_unmapped_area
> callback.
> 
> >> __find_plane_by_offset can do this. But it is an internal function.
> >> I think there should be a function called vb2_get_unmapped_area to do
> >> this in framework side.
> > 
> > are you using soc_camera ?
> > you can add your get_unmapped_area  in soc_camera.
> > if not, you can add it in your v4l2_file_operations ops, while still
> > using videbuf2 to management your buffer.
> 
> yes, I have added this method, just copy __find_plane_by_offset code.
> But it is ugly, it should have a vb2_get_unmapped_area like vb2_mmap.
> These two operations are called by one system call, so they should
> have a uniform looks.

I agree with that. get_unmapped_area is a file operation and should be 
implemented using a videobuf2 helper, like vb2_mmap.

-- 
Regards,

Laurent Pinchart
