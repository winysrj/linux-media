Return-path: <mchehab@pedra>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50640 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333Ab1FPGi1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jun 2011 02:38:27 -0400
Received: by pwj7 with SMTP id 7so106331pwj.19
        for <linux-media@vger.kernel.org>; Wed, 15 Jun 2011 23:38:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <000701cc2be8$3bfb1720$b3f14560$%szyprowski@samsung.com>
References: <BANLkTikKA_0QEyaeJth4FYzm61tYT+_Gow@mail.gmail.com>
	<000701cc2be8$3bfb1720$b3f14560$%szyprowski@samsung.com>
Date: Thu, 16 Jun 2011 14:38:27 +0800
Message-ID: <BANLkTimHFomy+ioM0xgx7iMaqfRjHjvSbA@mail.gmail.com>
Subject: Re: no mmu on videobuf2
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com,
	linux-media@vger.kernel.org,
	uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

2011/6/16 Marek Szyprowski <m.szyprowski@samsung.com>:
> Hello Scott,
>
>> Hi Marek and Laurent,
>>
>> I am working on v4l2 drivers for blackfin which is a no mmu soc.
>> I found videobuf allocate memory in mmap not reqbuf, so I turn to videobuf2.
>> But __setup_offsets() use plane offset to fill m.offset, which is
>> always 0 for single-planar buffer.
>> So pgoff in get_unmapped_area callback equals 0.
>> I only found uvc handled get_unmapped_area for no mmu system, but it
>> manages buffers itself.
>> I really want videobuf2 to manage buffers. Please give me some advice.
>
> I'm not really sure if I know the differences between mmu and no-mmu
> systems (from the device driver perspective). I assume that you are using
> videobuf2-vmalloc allocator. Note that memory allocators/managers are well
> separated from the videobuf2 logic. If it the current one doesn't serve you
> well you can make your own no-mmu allocator. Later once we identify all
> differences it might be merged with the standard one or left alone if the
> merge is not really possible or easy.
>
> Best regards
> --
> Marek Szyprowski
> Samsung Poland R&D Center
>
>
>

Hi Marek,

I used dma-contig allocator. I mean if offset is 0, I must get actual
addr from this offset.
__find_plane_by_offset can do this. But it is an internal function.
I think there should be a function called vb2_get_unmapped_area to do
this in framework side.

Regards,
Scott
