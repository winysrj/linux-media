Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:23687 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809Ab3KYPlq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Nov 2013 10:41:46 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MWT00BQHSXJMU70@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 25 Nov 2013 15:41:44 +0000 (GMT)
Content-transfer-encoding: 8BIT
Message-id: <52936FB7.9030307@samsung.com>
Date: Mon, 25 Nov 2013 16:41:43 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: =?UTF-8?B?TWF0dGhpYXMgV8OkY2h0ZXI=?= <matthias.waechter@tttech.com>,
	Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Pawel Osciak <pawel@osciak.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	"open list:VIDEOBUF2 FRAMEWORK" <linux-media@vger.kernel.org>,
	"sylvester.nawrocki@gmail.com" <sylvester.nawrocki@gmail.com>
Subject: Re: [PATCH] videobuf2-dma-sg: Support io userptr operations on io
 memory
References: <1383767329-29985-1-git-send-email-ricardo.ribalda@gmail.com>
 <3377d5e29bf6444086575515325b3555@TTTEX01.ds1.internal>
In-reply-to: <3377d5e29bf6444086575515325b3555@TTTEX01.ds1.internal>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 2013-11-11 12:36, Matthias Wächter wrote:
> > @@ -180,7 +186,26 @@ static void *vb2_dma_sg_get_userptr(void
> > *alloc_ctx, unsigned long vaddr,
> >       if (!buf->pages)
> >               return NULL;
> >
> > -     num_pages_from_user = get_user_pages(current, current->mm,
> > +     buf->vma = find_vma(current->mm, vaddr);
> > +     if (!buf->vma) {
> > +             dprintk(1, "no vma for address %lu\n", vaddr);
> > +             return NULL;
> > +     }
> > +
> > +     if (vma_is_io(buf->vma)) {
> > +             for (num_pages_from_user = 0;
> > +                  num_pages_from_user < buf->num_pages;
> > +                  ++num_pages_from_user, vaddr += PAGE_SIZE) {
> > +                     unsigned long pfn;
> > +
> > +                     if (follow_pfn(buf->vma, vaddr, &pfn)) {
> > +                             dprintk(1, "no page for address %lu\n", vaddr);
> > +                             break;
> > +                     }
> > +                     buf->pages[num_pages_from_user] = pfn_to_page(pfn);
> > +             }
> > +     } else
> > +             num_pages_from_user = get_user_pages(current, current->mm,
> >                                            vaddr & PAGE_MASK,
> >                                            buf->num_pages,
> >                                            write,
>
> Can you safely assume that your userptr will cover only one vma? At least, get_user_pages (calling __get_user_pages) does not assume that and calls find_vma() whenever vma->vm_end is reached.

We care only about io mappings which cover only one vma. Such mappings
are created by other device drivers and can be used mainly for
zero-copy buffer sharing between multimedia devices. Although it is
technically possible to provide code for multiple vma, there will be
no real use case for it.

Best regards
-- 
Marek Szyprowski
Samsung R&D Institute Poland

