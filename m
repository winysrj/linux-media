Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:41756 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760006Ab3GSM52 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jul 2013 08:57:28 -0400
Received: by mail-ob0-f170.google.com with SMTP id ef5so5320948obb.15
        for <linux-media@vger.kernel.org>; Fri, 19 Jul 2013 05:57:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130719121841.GB8760@gmail.com>
References: <1374220729-8304-1-git-send-email-ricardo.ribalda@gmail.com>
 <1374220729-8304-2-git-send-email-ricardo.ribalda@gmail.com> <20130719121841.GB8760@gmail.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Fri, 19 Jul 2013 14:57:07 +0200
Message-ID: <CAPybu_3JZU11uR3=0N5btZVeZG8=bY_Ld48bh_wxqYJ7jasuCA@mail.gmail.com>
Subject: Re: [PATCH 1/4] videobuf2-dma-sg: Allocate pages as contiguous as possible
To: Andre Heider <a.heider@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Andre

The underflow it is totally my fault :(, last_page is unsigned. I have fixed it.

I was not aware of the double check. I have also fixed.

I will wait for more comments and then I will post it again to avoid
spamming the list.

Thanks!

On Fri, Jul 19, 2013 at 2:18 PM, Andre Heider <a.heider@gmail.com> wrote:
> On Fri, Jul 19, 2013 at 09:58:46AM +0200, Ricardo Ribalda Delgado wrote:
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
>> of the times it will reduce the number fo dma segments
>>
>> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
>> ---
>>  drivers/media/v4l2-core/videobuf2-dma-sg.c |   60 +++++++++++++++++++++++-----
>>  1 file changed, 49 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
>> index 16ae3dc..9bf02c3 100644
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
>> +
>> +             pages = NULL;
>> +             while (!pages) {
>> +                     pages = alloc_pages(GFP_KERNEL | __GFP_ZERO |
>> +                                     __GFP_NOWARN | gfp_flags, order);
>> +                     if (pages)
>> +                             break;
>> +
>> +                     if (order == 0)
>> +                             while (--last_page >= 0) {
>> +                                     __free_page(buf->pages[last_page]);
>> +                                     return -ENOMEM;
>> +                             }
>
> Looks leaky, you probably ment:
>
>                                 while (--last_page >= 0)
>                                         __free_page(buf->pages[last_page]);
>
>                                 return -ENOMEM;
>
> But that still underflows 'last_page', so:
>
>                                 while (last_page--)
>                                         __free_page(buf->pages[last_page]);
>
>                                 return -ENOMEM;
>
>> +                     order--;
>> +             }
>> +
>> +             split_page(pages, order);
>> +             for (i = 0; i < (1<<order); i++) {
>> +                     buf->pages[last_page] = pages + i;
>
> That makes the reader double check the type of 'pages', why not:
>
>                         buf->pages[last_page] = pages[i];
>
>> +                     sg_set_page(&buf->sg_desc.sglist[last_page],
>> +                                     buf->pages[last_page], PAGE_SIZE, 0);
>> +                     last_page++;
>> +             }
>> +
>> +             size -= PAGE_SIZE << order;
>> +     }
>> +
>> +     return 0;
>> +}
>> +
>>  static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned long size, gfp_t gfp_flags)
>>  {
>>       struct vb2_dma_sg_buf *buf;
>> -     int i;
>> +     int ret;
>>
>>       buf = kzalloc(sizeof *buf, GFP_KERNEL);
>>       if (!buf)
>> @@ -69,14 +114,9 @@ static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned long size, gfp_t gfp_fla
>>       if (!buf->pages)
>>               goto fail_pages_array_alloc;
>>
>> -     for (i = 0; i < buf->sg_desc.num_pages; ++i) {
>> -             buf->pages[i] = alloc_page(GFP_KERNEL | __GFP_ZERO |
>> -                                        __GFP_NOWARN | gfp_flags);
>> -             if (NULL == buf->pages[i])
>> -                     goto fail_pages_alloc;
>> -             sg_set_page(&buf->sg_desc.sglist[i],
>> -                         buf->pages[i], PAGE_SIZE, 0);
>> -     }
>> +     ret = vb2_dma_sg_alloc_compacted(buf, gfp_flags);
>> +     if (ret)
>> +             goto fail_pages_alloc;
>>
>>       buf->handler.refcount = &buf->refcount;
>>       buf->handler.put = vb2_dma_sg_put;
>> @@ -89,8 +129,6 @@ static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned long size, gfp_t gfp_fla
>>       return buf;
>>
>>  fail_pages_alloc:
>> -     while (--i >= 0)
>> -             __free_page(buf->pages[i]);
>>       kfree(buf->pages);
>>
>>  fail_pages_array_alloc:
>> --
>> 1.7.10.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Ricardo Ribalda
