Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f41.google.com ([209.85.219.41]:63025 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961Ab3KYJAH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Nov 2013 04:00:07 -0500
Received: by mail-oa0-f41.google.com with SMTP id j17so4029195oag.14
        for <linux-media@vger.kernel.org>; Mon, 25 Nov 2013 01:00:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <3377d5e29bf6444086575515325b3555@TTTEX01.ds1.internal>
References: <1383767329-29985-1-git-send-email-ricardo.ribalda@gmail.com> <3377d5e29bf6444086575515325b3555@TTTEX01.ds1.internal>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Mon, 25 Nov 2013 09:59:46 +0100
Message-ID: <CAPybu_3SQaMuCOnGr4PPz53J=sM2LcevLkAXbjyExqoOiMNvLA@mail.gmail.com>
Subject: Re: [PATCH] videobuf2-dma-sg: Support io userptr operations on io memory
To: =?ISO-8859-1?Q?Matthias_W=E4chter?= <matthias.waechter@tttech.com>
Cc: Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	"open list:VIDEOBUF2 FRAMEWORK" <linux-media@vger.kernel.org>,
	"sylvester.nawrocki@gmail.com" <sylvester.nawrocki@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mathias

Memory managing is definately not my topic. I have done the same as in
vb2-dmacontig, and it has worked on my driver (out of tree).

I think that if there is something wrong it will also be wrong on the
dmacontig part, and much more drivers would be affected, so please
also take a look to videobuf2-dma-contig.c and check if there is
something wrong there.

Best Regards!

On Mon, Nov 11, 2013 at 12:36 PM, Matthias Wächter
<matthias.waechter@tttech.com> wrote:
>> @@ -180,7 +186,26 @@ static void *vb2_dma_sg_get_userptr(void
>> *alloc_ctx, unsigned long vaddr,
>>       if (!buf->pages)
>>               return NULL;
>>
>> -     num_pages_from_user = get_user_pages(current, current->mm,
>> +     buf->vma = find_vma(current->mm, vaddr);
>> +     if (!buf->vma) {
>> +             dprintk(1, "no vma for address %lu\n", vaddr);
>> +             return NULL;
>> +     }
>> +
>> +     if (vma_is_io(buf->vma)) {
>> +             for (num_pages_from_user = 0;
>> +                  num_pages_from_user < buf->num_pages;
>> +                  ++num_pages_from_user, vaddr += PAGE_SIZE) {
>> +                     unsigned long pfn;
>> +
>> +                     if (follow_pfn(buf->vma, vaddr, &pfn)) {
>> +                             dprintk(1, "no page for address %lu\n", vaddr);
>> +                             break;
>> +                     }
>> +                     buf->pages[num_pages_from_user] = pfn_to_page(pfn);
>> +             }
>> +     } else
>> +             num_pages_from_user = get_user_pages(current, current->mm,
>>                                            vaddr & PAGE_MASK,
>>                                            buf->num_pages,
>>                                            write,
>
> Can you safely assume that your userptr will cover only one vma? At least, get_user_pages (calling __get_user_pages) does not assume that and calls find_vma() whenever vma->vm_end is reached.
>
> – Matthias
>
> CONFIDENTIALITY: The contents of this e-mail are confidential and intended only for the above addressee(s). If you are not the intended recipient, or the person responsible for delivering it to the intended recipient, copying or delivering it to anyone else or using it in any unauthorized manner is prohibited and may be unlawful. If you receive this e-mail by mistake, please notify the sender and the systems administrator at straymail@tttech.com immediately.



-- 
Ricardo Ribalda
