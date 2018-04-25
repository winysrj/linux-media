Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:39217 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751105AbeDYHIO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Apr 2018 03:08:14 -0400
MIME-Version: 1.0
In-Reply-To: <20180425061537.GA23383@infradead.org>
References: <20180424204158.2764095-1-arnd@arndb.de> <20180425061537.GA23383@infradead.org>
From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 25 Apr 2018 09:08:13 +0200
Message-ID: <CAK8P3a06ragAPWpHGm-bGoZ8t6QyAttWJfD0jU_wcGy7FqLb5w@mail.gmail.com>
Subject: Re: [PATCH] media: zoran: move to dma-mapping interface
To: Christoph Hellwig <hch@infradead.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        mjpeg-users@lists.sourceforge.net,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 25, 2018 at 8:15 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Tue, Apr 24, 2018 at 10:40:45PM +0200, Arnd Bergmann wrote:
>> @@ -221,6 +222,7 @@ struct zoran_fh {
>>
>>       struct zoran_overlay_settings overlay_settings;
>>       u32 *overlay_mask;                      /* overlay mask */
>> +     dma_addr_t overlay_mask_dma;
>>       enum zoran_lock_activity overlay_active;/* feature currently in use? */
>>
>>       struct zoran_buffer_col buffers;        /* buffers' info */
>> @@ -307,6 +309,7 @@ struct zoran {
>>
>>       struct zoran_overlay_settings overlay_settings;
>>       u32 *overlay_mask;      /* overlay mask */
>> +     dma_addr_t overlay_mask_dma;
>>       enum zoran_lock_activity overlay_active;        /* feature currently in use? */
>>
>>       wait_queue_head_t v4l_capq;
>> @@ -346,6 +349,7 @@ struct zoran {
>>
>>       /* zr36057's code buffer table */
>>       __le32 *stat_com;               /* stat_com[i] is indexed by dma_head/tail & BUZ_MASK_STAT_COM */
>> +     dma_addr_t stat_com_dma;
>>
>>       /* (value & BUZ_MASK_FRAME) corresponds to index in pend[] queue */
>>       int jpg_pend[BUZ_MAX_FRAME];
>> diff --git a/drivers/media/pci/zoran/zoran_card.c b/drivers/media/pci/zoran/zoran_card.c
>> index a6b9ebd20263..dabd8bf77472 100644
>> --- a/drivers/media/pci/zoran/zoran_card.c
>> +++ b/drivers/media/pci/zoran/zoran_card.c
>> @@ -890,6 +890,7 @@ zoran_open_init_params (struct zoran *zr)
>>       /* User must explicitly set a window */
>>       zr->overlay_settings.is_set = 0;
>>       zr->overlay_mask = NULL;
>> +     zr->overlay_mask_dma = 0;
>
> I don't think this zeroing is required, and given that 0 is a valid
> dma address on some platforms is also is rather confusing.:w

The driver does this everywhere, which I also noticed as unnecessary,
but it felt better to be consistent with the rest of the driver here than
to follow common practice.

There are some explicit 'if (zr->overlay_mask)' checks in the driver
that require overlay_mask to be initialized. I could set it to
DMA_ERROR_CODE, but you removed that ;-)

It's easy enough to remove the re-zeroing of the number though
if you still think that's better.

>>               mask_line_size = (BUZ_MAX_WIDTH + 31) / 32;
>> -             reg = virt_to_bus(zr->overlay_mask);
>> +             reg = zr->overlay_mask_dma;
>>               btwrite(reg, ZR36057_MMTR);
>> -             reg = virt_to_bus(zr->overlay_mask + mask_line_size);
>> +             reg = zr->overlay_mask_dma + mask_line_size;
>
> I think this would be easier to read if the reg assignments got
> removed, e.g.
>
>         btwrite(zr->overlay_mask_dma, ZR36057_MMTR);
>         btwrite(zr->overlay_mask_dma + mask_line_size, ZR36057_MMBR);
>
> Same in a few other places.

Right, good idea.

>> +             virt_tab = (void *)get_zeroed_page(GFP_KERNEL);
>> +             if (!mem || !virt_tab) {
>>                       dprintk(1,
>>                               KERN_ERR
>>                               "%s: %s - get_zeroed_page (frag_tab) failed for buffer %d\n",
>>                               ZR_DEVNAME(zr), __func__, i);
>> +                     kfree(mem);
>> +                     kfree(virt_tab);
>>                       jpg_fbuffer_free(fh);
>>                       return -ENOBUFS;
>>               }
>>               fh->buffers.buffer[i].jpg.frag_tab = (__le32 *)mem;
>> -             fh->buffers.buffer[i].jpg.frag_tab_bus = virt_to_bus(mem);
>> +             fh->buffers.buffer[i].jpg.frag_virt_tab = virt_tab;
>
> From a quick look it seems like frag_tab should be a dma_alloc_coherent
> allocation, or you would need a lot of cache sync operations.

Do you mean the table or the buffers it points to? In the code you
quote, we initialize the table with static data before mapping it,
so I would expect either interface to work fine here.

For the actual buffers, I tried to retain the current behavior and
regular kernel memory, in particular because I wasn't too sure
about changing the mmap() function without understanding what
it really does. ;-)

It looks like the buffers are never accessed from the kernel but
only from hardware and user space, so we don't care about whether
we get a mapping that is coherent between the kernel and hardware,
but we probably should ensure that the page table attributes are the
same in kernel and user space (at least powerpc gets a checkstop
for unmatched cacheability flags).

> That probably also means it can use dma_mmap_coherent instead of the
> handcrafted remap_pfn_range loop and the PageReserved abuse.

I'd rather not touch that code. How about adding a comment about
the fact that it should use dma_mmap_coherent()?

     Arnd
