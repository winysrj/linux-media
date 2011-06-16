Return-path: <mchehab@pedra>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:28100 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865Ab1FPFn1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jun 2011 01:43:27 -0400
Received: from eu_spt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LMV00L5PBWDKL@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 16 Jun 2011 06:43:25 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LMV009MIBWCLR@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 16 Jun 2011 06:43:24 +0100 (BST)
Date: Thu, 16 Jun 2011 07:42:52 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: no mmu on videobuf2
In-reply-to: <BANLkTikKA_0QEyaeJth4FYzm61tYT+_Gow@mail.gmail.com>
To: 'Scott Jiang' <scott.jiang.linux@gmail.com>,
	hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com
Cc: linux-media@vger.kernel.org
Message-id: <000701cc2be8$3bfb1720$b3f14560$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
References: <BANLkTikKA_0QEyaeJth4FYzm61tYT+_Gow@mail.gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello Scott,

> Hi Marek and Laurent,
> 
> I am working on v4l2 drivers for blackfin which is a no mmu soc.
> I found videobuf allocate memory in mmap not reqbuf, so I turn to videobuf2.
> But __setup_offsets() use plane offset to fill m.offset, which is
> always 0 for single-planar buffer.
> So pgoff in get_unmapped_area callback equals 0.
> I only found uvc handled get_unmapped_area for no mmu system, but it
> manages buffers itself.
> I really want videobuf2 to manage buffers. Please give me some advice.

I'm not really sure if I know the differences between mmu and no-mmu
systems (from the device driver perspective). I assume that you are using
videobuf2-vmalloc allocator. Note that memory allocators/managers are well
separated from the videobuf2 logic. If it the current one doesn't serve you
well you can make your own no-mmu allocator. Later once we identify all
differences it might be merged with the standard one or left alone if the
merge is not really possible or easy.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


