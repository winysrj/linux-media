Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752461AbeBENvJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Feb 2018 08:51:09 -0500
Date: Mon, 5 Feb 2018 22:51:05 +0900
From: Masami Hiramatsu <mhiramat@kernel.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Pawel Osciak <pawel@osciak.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        orito.takao@socionext.com,
        Fumihiro ATSUMI <atsumi@infinitegra.co.jp>
Subject: Re: [PATCH] [BUGFIX] media: vb2: Fix videobuf2 to map correct area
Message-Id: <20180205225105.6eb3a8e5ed93c87bf6cfd14e@kernel.org>
In-Reply-To: <2af9a288-86e8-100a-4459-bc913f3cb99d@samsung.com>
References: <CGME20180205023108epcas5p18456b3ecc412b6709dc27fe5af14b1f6@epcas5p1.samsung.com>
        <151779784111.20697.5012233804870630070.stgit@devbox>
        <2af9a288-86e8-100a-4459-bc913f3cb99d@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 05 Feb 2018 09:47:46 +0100
Marek Szyprowski <m.szyprowski@samsung.com> wrote:

> Hi Masami,
> 
> On 2018-02-05 03:30, Masami Hiramatsu wrote:
> > Fixes vb2_vmalloc_get_userptr() to ioremap correct area.
> > Since the current code does ioremap the page address, if the offset > 0,
> > it does not do ioremap the last page and results in kernel panic.
> >
> > This fixes to pass the page address + offset to ioremap so that ioremap
> > can map correct area. Also, this uses __pfn_to_phys() to get the physical
> > address of given PFN.
> >
> > Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
> > Reported-by: Takao Orito <orito.takao@socionext.com>
> > ---
> >   drivers/media/v4l2-core/videobuf2-vmalloc.c |    2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/media/v4l2-core/videobuf2-vmalloc.c b/drivers/media/v4l2-core/videobuf2-vmalloc.c
> > index 3a7c80cd1a17..896f2f378b40 100644
> > --- a/drivers/media/v4l2-core/videobuf2-vmalloc.c
> > +++ b/drivers/media/v4l2-core/videobuf2-vmalloc.c
> > @@ -106,7 +106,7 @@ static void *vb2_vmalloc_get_userptr(struct device *dev, unsigned long vaddr,
> >   			if (nums[i-1] + 1 != nums[i])
> >   				goto fail_map;
> >   		buf->vaddr = (__force void *)
> > -				ioremap_nocache(nums[0] << PAGE_SHIFT, size);
> > +			ioremap_nocache(__pfn_to_phys(nums[0]) + offset, size);
> 
> Thanks for reporting this issue. However the above line doesn't look like
> a proper fix. Please note that at the end of that function there is already
> "buf->vaddr += offset;".

I see.

> 
> IMHO the proper fix is to create a larger mapping, which would include the
> in-page start offset:
> 
> ioremap_nocache(__pfn_to_phys(nums[0]), offset + size);

Yes, sorry it's my mistake. I misunderstood ioremap_nocache(addr, size) remaps
the PAGE of addr to PAGE of (addr+size). Yours is correct.

Thank you,

> BTW, thanks for updating "<< PAGE_SHIFT" to better __pfn_to_phys() macro!
> 
> >   	} else {
> >   		buf->vaddr = vm_map_ram(frame_vector_pages(vec), n_pages, -1,
> >   					PAGE_KERNEL);
> >
> >
> >
> >
> 
> Best regards
> -- 
> Marek Szyprowski, PhD
> Samsung R&D Institute Poland
> 


-- 
Masami Hiramatsu <mhiramat@kernel.org>
