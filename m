Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f53.google.com ([209.85.219.53]:38532 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665Ab3KYQXF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Nov 2013 11:23:05 -0500
Received: by mail-oa0-f53.google.com with SMTP id m1so4502320oag.26
        for <linux-media@vger.kernel.org>; Mon, 25 Nov 2013 08:23:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52936FB7.9030307@samsung.com>
References: <1383767329-29985-1-git-send-email-ricardo.ribalda@gmail.com>
 <3377d5e29bf6444086575515325b3555@TTTEX01.ds1.internal> <52936FB7.9030307@samsung.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Mon, 25 Nov 2013 17:22:44 +0100
Message-ID: <CAPybu_3_82jT7xR9C5_3bAG5d4TE+e5Hu04xzWxGVdgLu67DYw@mail.gmail.com>
Subject: Re: [PATCH] videobuf2-dma-sg: Support io userptr operations on io memory
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: =?ISO-8859-1?Q?Matthias_W=E4chter?= <matthias.waechter@tttech.com>,
	Pawel Osciak <pawel@osciak.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	"open list:VIDEOBUF2 FRAMEWORK" <linux-media@vger.kernel.org>,
	"sylvester.nawrocki@gmail.com" <sylvester.nawrocki@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Marek

Could you review the patch? Is there something that needs to be fixed?

Thanks!

On Mon, Nov 25, 2013 at 4:41 PM, Marek Szyprowski
<m.szyprowski@samsung.com> wrote:
> Hello,
>
>
> On 2013-11-11 12:36, Matthias Wächter wrote:
>>
>> > @@ -180,7 +186,26 @@ static void *vb2_dma_sg_get_userptr(void
>> > *alloc_ctx, unsigned long vaddr,
>> >       if (!buf->pages)
>> >               return NULL;
>> >
>> > -     num_pages_from_user = get_user_pages(current, current->mm,
>> > +     buf->vma = find_vma(current->mm, vaddr);
>> > +     if (!buf->vma) {
>> > +             dprintk(1, "no vma for address %lu\n", vaddr);
>> > +             return NULL;
>> > +     }
>> > +
>> > +     if (vma_is_io(buf->vma)) {
>> > +             for (num_pages_from_user = 0;
>> > +                  num_pages_from_user < buf->num_pages;
>> > +                  ++num_pages_from_user, vaddr += PAGE_SIZE) {
>> > +                     unsigned long pfn;
>> > +
>> > +                     if (follow_pfn(buf->vma, vaddr, &pfn)) {
>> > +                             dprintk(1, "no page for address %lu\n",
>> > vaddr);
>> > +                             break;
>> > +                     }
>> > +                     buf->pages[num_pages_from_user] =
>> > pfn_to_page(pfn);
>> > +             }
>> > +     } else
>> > +             num_pages_from_user = get_user_pages(current, current->mm,
>> >                                            vaddr & PAGE_MASK,
>> >                                            buf->num_pages,
>> >                                            write,
>>
>> Can you safely assume that your userptr will cover only one vma? At least,
>> get_user_pages (calling __get_user_pages) does not assume that and calls
>> find_vma() whenever vma->vm_end is reached.
>
>
> We care only about io mappings which cover only one vma. Such mappings
> are created by other device drivers and can be used mainly for
> zero-copy buffer sharing between multimedia devices. Although it is
> technically possible to provide code for multiple vma, there will be
> no real use case for it.
>
> Best regards
> --
> Marek Szyprowski
> Samsung R&D Institute Poland
>



-- 
Ricardo Ribalda
