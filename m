Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:16532 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755705Ab3AHKkp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2013 05:40:45 -0500
Message-id: <50EBF7A9.6070802@samsung.com>
Date: Tue, 08 Jan 2013 11:40:41 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
MIME-version: 1.0
To: Federico Vaga <federico.vaga@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Pawel Osciak <pawel@osciak.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH v4 1/3] videobuf2-dma-contig: user can specify GFP flags
References: <1357493343-13090-1-git-send-email-federico.vaga@gmail.com>
 <50EBC26E.5090803@samsung.com> <1609748.zs7bdcvuG8@harkonnen>
In-reply-to: <1609748.zs7bdcvuG8@harkonnen>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 1/8/2013 11:15 AM, Federico Vaga wrote:
> > > @@ -165,7 +161,8 @@ static void *vb2_dc_alloc(void *alloc_ctx, unsigned
> > > long size)>
> > >   	/* align image size to PAGE_SIZE */
> > >   	size = PAGE_ALIGN(size);
> > >
> > > -	buf->vaddr = dma_alloc_coherent(dev, size, &buf->dma_addr,
> GFP_KERNEL);
> > > +	buf->vaddr = dma_alloc_coherent(dev, size, &buf->dma_addr,
> > > +									
> GFP_KERNEL | conf->mem_flags);
> >
> > I think we can add GFP_DMA flag unconditionally to the vb2_dc_contig
> > allocator.
> > It won't hurt existing clients as most of nowadays platforms doesn't
> > have DMA
> > zone (GFP_DMA is ignored in such case), but it should fix the issues
> > with some
> > older and non-standard systems.
>
> I did not set GFP_DMA fixed in the allocator because I do not want to brake
> something in the future. On x86 platform GFP_DMA allocates under 16MB and this
> limit can be too strict. When many other drivers use GFP_DMA we can saturate
> this tiny zone.
> As you said, this fix the issue with _older_ and _non-standard_ (like sta2x11)
> systems. But this fix has effect on every other standard and new systems.
> That's why I preferred to set the flag optionally.

Ok, then I would simply pass the flags from the driver without any 
alternation
in the allocator itself, so drivers can pass 'GFP_KERNEL' or
'GFP_KERNEL | GFP_DMA' depending on their preference. Please also update 
all
the existing clients of vb2_dma_dc allocator.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


