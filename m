Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f181.google.com ([209.85.214.181]:63877 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488Ab3GSV5e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jul 2013 17:57:34 -0400
Received: by mail-ob0-f181.google.com with SMTP id 16so5904407obc.26
        for <linux-media@vger.kernel.org>; Fri, 19 Jul 2013 14:57:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130719141603.16ef8f0b@lwn.net>
References: <1374253355-3788-1-git-send-email-ricardo.ribalda@gmail.com>
 <1374253355-3788-2-git-send-email-ricardo.ribalda@gmail.com> <20130719141603.16ef8f0b@lwn.net>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Fri, 19 Jul 2013 23:57:12 +0200
Message-ID: <CAPybu_39vky9i2tjykDkP2Q7qpF9nq4VR2MRmr1jvqLr2OTBOA@mail.gmail.com>
Subject: Re: [PATCH 1/2] videobuf2-dma-sg: Allocate pages as contiguous as possible
To: Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-media@vger.kernel.org, Andre Heider <a.heider@gmail.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Jonathan:

Thanks for your review. I am making a driver for a camera that
produces 4Mpx images with up to 10 bytes per pixel!. The camera has a
dma engine capable of moving up to 255 sg sectors.

In the original implementation of vb2-dma-sg, every page was allocated
independently, dividing the memory in more than 255 sectors.

If the memory is very segmented, then there is nothing I can do, but
if there are high order pages available I would like to use them.

The original assumption is that all the pages that compose a high
order page are contiguous in physical memory.

On Fri, Jul 19, 2013 at 10:16 PM, Jonathan Corbet <corbet@lwn.net> wrote:
> On Fri, 19 Jul 2013 19:02:33 +0200
> Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com> wrote:
>
>> Most DMA engines have limitations regarding the number of DMA segments
>> (sg-buffers) that they can handle. Videobuffers can easily spread
>> through houndreds of pages.
>>
>> In the previous aproach, the pages were allocated individually, this
>> could led to the creation houndreds of dma segments (sg-buffers) that
>> could not be handled by some DMA engines.
>>
>> This patch tries to minimize the number of DMA segments by using
>> alloc_pages. In the worst case it will behave as before, but most
>> of the times it will reduce the number of dma segments
>
> So I looked this over and I have a few questions...
>
>> diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
>> index 16ae3dc..c053605 100644
>> --- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
>> +++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
>> @@ -42,10 +42,55 @@ struct vb2_dma_sg_buf {
>>
>>  static void vb2_dma_sg_put(void *buf_priv);
>>
>> +static int vb2_dma_sg_alloc_compacted(struct vb2_dma_sg_buf *buf,
>> +             gfp_t gfp_flags)
>> +{
>> +     unsigned int last_page = 0;
>> +     int size = buf->sg_desc.size;
>> +
>> +     while (size > 0) {
>> +             struct page *pages;
>> +             int order;
>> +             int i;
>> +
>> +             order = get_order(size);
>> +             /* Dont over allocate*/
>> +             if ((PAGE_SIZE << order) > size)
>> +                     order--;
>
> Terrible things will happen if size < PAGE_SIZE.  Presumably that should
> never happen, or perhaps one could say any caller who does that will get
> what they deserve.

The caller function is vb2_dma_sg_alloc which according to its
comments is already page aligned, so that should be covered.
https://linuxtv.org/patch/18095/

>
> Have you considered alloc_pages_exact(), though?  That might result in
> fewer segments overall.

In the previous implementation I used alloc_pages_exact, but there
were two things that made me change my mind. One is that the comments
of the function says that you should free the pages with
free_pages_exact, so  should get track of the segments. The other is
that alloc_pages_exact split the highest pages into order 0, so there
could be a situation that for only one page I would split a higher
order page, and those are scarce.

>
>> +             pages = NULL;
>> +             while (!pages) {
>> +                     pages = alloc_pages(GFP_KERNEL | __GFP_ZERO |
>> +                                     __GFP_NOWARN | gfp_flags, order);
>> +                     if (pages)
>> +                             break;
>> +
>> +                     if (order == 0)
>> +                             while (last_page--) {
>> +                                     __free_page(buf->pages[last_page]);
>
> If I understand things, this is wrong; you relly need free_pages() with the
> correct order.  Or, at least, that would be the case if you kept the pages
> together, but that leads to my biggest question...

Pages are splitted, so I believe that this is right.

>
>> +                                     return -ENOMEM;
>> +                             }
>> +                     order--;
>> +             }
>> +
>> +             split_page(pages, order);
>> +             for (i = 0; i < (1<<order); i++) {
>> +                     buf->pages[last_page] = pages[i];
>> +                     sg_set_page(&buf->sg_desc.sglist[last_page],
>> +                                     buf->pages[last_page], PAGE_SIZE, 0);
>> +                     last_page++;
>> +             }
>
> You've gone to all this trouble to get a higher-order allocation so you'd
> have fewer segments, then you undo it all by splitting things apart into
> individual pages.  Why?  Clearly I'm missing something, this seems to
> defeat the purpose of the whole exercise?

I got to all this trouble to get memory as physically contiguous as
possible. I don't care if they belong to one or multiple pages, in
fact my dma controller only understand about physical addresses.

 If I don't split the pages then the calls to vm_map_ram and
vm_insert_page will fail, please take a look to:
https://lkml.org/lkml/2013/7/17/285 there I post the code that does
not split the pages and  to
http://marc.info/?l=linux-mm&m=124404111608622 where another poor guy
complains about not been able to use vm_insert_page on higher order
pages :).


Again, thank you very much for your review.

>
> Thanks,
>
> jon



--
Ricardo Ribalda
