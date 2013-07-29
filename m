Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:9043 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab3G2L1R (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jul 2013 07:27:17 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MQP00HJV3PMRX80@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 29 Jul 2013 12:27:15 +0100 (BST)
Message-id: <51F65190.9080601@samsung.com>
Date: Mon, 29 Jul 2013 13:27:12 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
MIME-version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Pawel Osciak <pawel@osciak.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-media@vger.kernel.org, Andre Heider <a.heider@gmail.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH 1/2] videobuf2-dma-sg: Allocate pages as contiguous as
 possible
References: <1374253355-3788-1-git-send-email-ricardo.ribalda@gmail.com>
 <1374253355-3788-2-git-send-email-ricardo.ribalda@gmail.com>
 <20130719141603.16ef8f0b@lwn.net>
In-reply-to: <20130719141603.16ef8f0b@lwn.net>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 7/19/2013 10:16 PM, Jonathan Corbet wrote:
> On Fri, 19 Jul 2013 19:02:33 +0200
> Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com> wrote:
>
> > Most DMA engines have limitations regarding the number of DMA segments
> > (sg-buffers) that they can handle. Videobuffers can easily spread
> > through houndreds of pages.
> >
> > In the previous aproach, the pages were allocated individually, this
> > could led to the creation houndreds of dma segments (sg-buffers) that
> > could not be handled by some DMA engines.
> >
> > This patch tries to minimize the number of DMA segments by using
> > alloc_pages. In the worst case it will behave as before, but most
> > of the times it will reduce the number of dma segments
>
> So I looked this over and I have a few questions...
>
> > diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
> > index 16ae3dc..c053605 100644
> > --- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
> > +++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
> > @@ -42,10 +42,55 @@ struct vb2_dma_sg_buf {
> >
> >  static void vb2_dma_sg_put(void *buf_priv);
> >
> > +static int vb2_dma_sg_alloc_compacted(struct vb2_dma_sg_buf *buf,
> > +		gfp_t gfp_flags)
> > +{
> > +	unsigned int last_page = 0;
> > +	int size = buf->sg_desc.size;
> > +
> > +	while (size > 0) {
> > +		struct page *pages;
> > +		int order;
> > +		int i;
> > +
> > +		order = get_order(size);
> > +		/* Dont over allocate*/
> > +		if ((PAGE_SIZE << order) > size)
> > +			order--;
>
> Terrible things will happen if size < PAGE_SIZE.  Presumably that should
> never happen, or perhaps one could say any caller who does that will get
> what they deserve.

I think that page size alignment for requested buffer size should be added
at vb2 core. V4L2 buffer API is page oriented and it really makes no sense
to allocate buffers which are not a multiple of page size.


> Have you considered alloc_pages_exact(), though?  That might result in
> fewer segments overall.
>
> > +		pages = NULL;
> > +		while (!pages) {
> > +			pages = alloc_pages(GFP_KERNEL | __GFP_ZERO |
> > +					__GFP_NOWARN | gfp_flags, order);
> > +			if (pages)
> > +				break;
> > +
> > +			if (order == 0)
> > +				while (last_page--) {
> > +					__free_page(buf->pages[last_page]);
>
> If I understand things, this is wrong; you relly need free_pages() with the
> correct order.  Or, at least, that would be the case if you kept the pages
> together, but that leads to my biggest question...
>
> > +					return -ENOMEM;
> > +				}
> > +			order--;
> > +		}
> > +
> > +		split_page(pages, order);
> > +		for (i = 0; i < (1<<order); i++) {
> > +			buf->pages[last_page] = pages[i];
> > +			sg_set_page(&buf->sg_desc.sglist[last_page],
> > +					buf->pages[last_page], PAGE_SIZE, 0);
> > +			last_page++;
> > +		}
>
> You've gone to all this trouble to get a higher-order allocation so you'd
> have fewer segments, then you undo it all by splitting things apart into
> individual pages.  Why?  Clearly I'm missing something, this seems to
> defeat the purpose of the whole exercise?

Individual zero-order pages are required to get them mapped to userspace in
mmap callback.

Best regards
-- 
Marek Szyprowski
Samsung R&D Institute Poland


