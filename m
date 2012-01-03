Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50303 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab2ACHsN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Jan 2012 02:48:13 -0500
Received: by wgbdr13 with SMTP id dr13so27394333wgb.1
        for <linux-media@vger.kernel.org>; Mon, 02 Jan 2012 23:48:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201201022000.30078.laurent.pinchart@ideasonboard.com>
References: <1325513543-17299-1-git-send-email-javier.martin@vista-silicon.com>
	<201201022000.30078.laurent.pinchart@ideasonboard.com>
Date: Tue, 3 Jan 2012 08:48:10 +0100
Message-ID: <CACKLOr01K_j0EKGQ4EL8v1cHcH0Q2xZ0nd6AmSreG1vYckGq9A@mail.gmail.com>
Subject: Re: [PATCH 1/2] media: vb2: support userptr for PFN mappings.
From: javier Martin <javier.martin@vista-silicon.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	pawel@osciak.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,
thank you for your review.

On 2 January 2012 20:00, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Javier,
>
> Thanks for the patch.
>
> On Monday 02 January 2012 15:12:22 Javier Martin wrote:
>> Some video devices need to use contiguous memory
>> which is not backed by pages as it happens with
>> vmalloc. This patch provides userptr handling for
>> those devices.
>
> What's your main use case ? Capturing to the frame buffer ?

My main use case is capturing to my mx2_emmaprp mem2mem driver which
converts from YUV422 to YUV420 format in HW.

>> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
>> ---
>>  drivers/media/video/videobuf2-vmalloc.c |   66
>> +++++++++++++++++++----------- 1 files changed, 42 insertions(+), 24
>> deletions(-)
>>
>> diff --git a/drivers/media/video/videobuf2-vmalloc.c
>> b/drivers/media/video/videobuf2-vmalloc.c index 03aa62f..5bc7cec 100644
>> --- a/drivers/media/video/videobuf2-vmalloc.c
>> +++ b/drivers/media/video/videobuf2-vmalloc.c
>> @@ -15,6 +15,7 @@
>>  #include <linux/sched.h>
>>  #include <linux/slab.h>
>>  #include <linux/vmalloc.h>
>> +#include <linux/io.h>
>
> Please keep headers sorted alphabetically.

OK. I didn't know that was the rule.

>>  #include <media/videobuf2-core.h>
>>  #include <media/videobuf2-memops.h>
>> @@ -71,6 +72,8 @@ static void *vb2_vmalloc_get_userptr(void *alloc_ctx,
>> unsigned long vaddr, struct vb2_vmalloc_buf *buf;
>>       unsigned long first, last;
>>       int n_pages, offset;
>> +     struct vm_area_struct *vma;
>> +     unsigned long int physp;
>>
>>       buf = kzalloc(sizeof(*buf), GFP_KERNEL);
>>       if (!buf)
>> @@ -80,23 +83,34 @@ static void *vb2_vmalloc_get_userptr(void *alloc_ctx,
>> unsigned long vaddr, offset = vaddr & ~PAGE_MASK;
>>       buf->size = size;
>>
>> -     first = vaddr >> PAGE_SHIFT;
>> -     last  = (vaddr + size - 1) >> PAGE_SHIFT;
>> -     buf->n_pages = last - first + 1;
>> -     buf->pages = kzalloc(buf->n_pages * sizeof(struct page *), GFP_KERNEL);
>> -     if (!buf->pages)
>> -             goto fail_pages_array_alloc;
>> -
>> -     /* current->mm->mmap_sem is taken by videobuf2 core */
>> -     n_pages = get_user_pages(current, current->mm, vaddr & PAGE_MASK,
>> -                                     buf->n_pages, write, 1, /* force */
>> -                                     buf->pages, NULL);
>> -     if (n_pages != buf->n_pages)
>> -             goto fail_get_user_pages;
>> -
>> -     buf->vaddr = vm_map_ram(buf->pages, buf->n_pages, -1, PAGE_KERNEL);
>> -     if (!buf->vaddr)
>> -             goto fail_get_user_pages;
>> +     vma = find_vma(current->mm, vaddr);
>> +     if (vma && (vma->vm_flags & VM_IO) && (vma->vm_pgoff)) {
>> +             physp = (vma->vm_pgoff << PAGE_SHIFT) + (vaddr - vma->vm_start);
>> +             buf->vaddr = ioremap_nocache(physp, size);
>> +             if (!buf->vaddr)
>> +                     goto fail_pages_array_alloc;
>
> What if the region spans multiple VMAs ? Shouldn't you at least verify that
> the region is physically contiguous, and that all VMAs share the same flags ?
> That's what the OMAP3 ISP driver does (in ispqueue.c). Maybe it's overkill
> though.
>
> If you do that, the could might be cleaner if you split this function in two,
> as in the OMAP3 ISP driver.

Yes, I suspected this could probably be troublesome. I'll take a look
at OMAP3 ISP and see what I can do.

>> +     } else {
>> +             first = vaddr >> PAGE_SHIFT;
>> +             last  = (vaddr + size - 1) >> PAGE_SHIFT;
>> +             buf->n_pages = last - first + 1;
>> +             buf->pages = kzalloc(buf->n_pages * sizeof(struct page *),
>> +                                  GFP_KERNEL);
>> +             if (!buf->pages)
>> +                     goto fail_pages_array_alloc;
>> +
>> +             /* current->mm->mmap_sem is taken by videobuf2 core */
>> +             n_pages = get_user_pages(current, current->mm,
>> +                                      vaddr & PAGE_MASK, buf->n_pages,
>> +                                      write,1, /* force */
>> +                                      buf->pages, NULL);
>> +             if (n_pages != buf->n_pages)
>> +                     goto fail_get_user_pages;
>> +
>> +             buf->vaddr = vm_map_ram(buf->pages, buf->n_pages, -1,
>> +                                     PAGE_KERNEL);
>> +             if (!buf->vaddr)
>> +                     goto fail_get_user_pages;
>> +     }
>>
>>       buf->vaddr += offset;
>>       return buf;
>> @@ -120,14 +134,18 @@ static void vb2_vmalloc_put_userptr(void *buf_priv)
>>       unsigned long vaddr = (unsigned long)buf->vaddr & PAGE_MASK;
>>       unsigned int i;
>>
>> -     if (vaddr)
>> -             vm_unmap_ram((void *)vaddr, buf->n_pages);
>> -     for (i = 0; i < buf->n_pages; ++i) {
>> -             if (buf->write)
>> -                     set_page_dirty_lock(buf->pages[i]);
>> -             put_page(buf->pages[i]);
>> +     if (buf->pages) {
>> +             if (vaddr)
>> +                     vm_unmap_ram((void *)vaddr, buf->n_pages);
>> +             for (i = 0; i < buf->n_pages; ++i) {
>> +                     if (buf->write)
>> +                             set_page_dirty_lock(buf->pages[i]);
>> +                     put_page(buf->pages[i]);
>> +             }
>> +             kfree(buf->pages);
>> +     } else {
>> +             iounmap(buf->vaddr);
>>       }
>> -     kfree(buf->pages);
>>       kfree(buf);
>>  }
>
> --
> Regards,
>
> Laurent Pinchart



-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
