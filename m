Return-Path: <SRS0=4xye=PD=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEF5BC43387
	for <linux-media@archiver.kernel.org>; Wed, 26 Dec 2018 13:38:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3B04218AD
	for <linux-media@archiver.kernel.org>; Wed, 26 Dec 2018 13:38:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EzYAlMUO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727191AbeLZNi0 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 26 Dec 2018 08:38:26 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:43282 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726742AbeLZNiN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Dec 2018 08:38:13 -0500
Received: by mail-lf1-f67.google.com with SMTP id u18so10866238lff.10;
        Wed, 26 Dec 2018 05:38:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kitNRdDq9qDxhqv/cqY0Zh5BAxoT0axpEmlNVpYcbmE=;
        b=EzYAlMUOklMugVTu4yYZGxXNl4hINns0BIBJ5Nyh+SiXyQZO3k1/YmOAXpsklfPAO9
         iDjpstitfhNRBht1mAjbRylNtGX/qD7buZ6ZeNkLPTTkq+7i3RsoxtRKoxTGkPBVjWvU
         ewhbp9fp+SmSCfmGn6nODKNhk6WX3dvwgudwU6EjHkBWxXVyLzXBNAmnZCB6z35uzkPb
         Yuu3uQxriVsO8cyk40d27EsqUa+WVfd4Nl0ZtFjBqXyXizvXzewwA2Kx7e7/1/OvhDt6
         C8HXTXX4cBfndyrt6+ttMQgPjv4dEhaa9oIj2jWENm1ZqGpTtOP7wRhMtO1SGZvml2dn
         imYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kitNRdDq9qDxhqv/cqY0Zh5BAxoT0axpEmlNVpYcbmE=;
        b=GyE7QGS0uC6GsRlc1uxjSmHLjWJj4mUoTtueq+qkaQG5auyJpK7dcGemw/6HJfr6EL
         Fjk+LddJ9HmXYyL/oW5vwGpUzbyehTgWmo9nVbTF9Fn3KdVYlWpKUngIib2ROfZM8LPg
         MvgabU4BQGiMJnstOTdwLIcFdT3KXaz8ef/qEC7CtcgB/OfsFcyboWLQKoOH8D2nWQTB
         g/MCKo54YEOuM8EkkqZv7nN4KOpSgBFedg1BPX+1rfIgNMi+JupPiUygSEFv7x2/+ZN4
         IkNw1IGiF0TdAJnWYhBb6414MaUVZZim33HGZwqvFWjGA+MxtOW5PP1Etud2inAi0tX/
         Lx+A==
X-Gm-Message-State: AA+aEWakn+/8Obq6rrIhqaJ7rbn88nw3o1vPwRIz8DRlwXJH3ZumoVzX
        ajNd+xERBIXYF5ARftxD2/dNS0YRfaAT+p1LZrA=
X-Google-Smtp-Source: AFSGD/XEZnUUKwSUwh3xXDYzi3sA4iQ+mQgXPP42OF+kde+qmR73SafRNdS5zRrl3g5eSHL8MfxiCu4AX/ZyOOBLntQ=
X-Received: by 2002:a19:2906:: with SMTP id p6mr9556966lfp.17.1545831490237;
 Wed, 26 Dec 2018 05:38:10 -0800 (PST)
MIME-Version: 1.0
References: <20181224131841.GA22017@jordon-HP-15-Notebook-PC> <20181224152059.GA26090@n2100.armlinux.org.uk>
In-Reply-To: <20181224152059.GA26090@n2100.armlinux.org.uk>
From:   Souptick Joarder <jrdr.linux@gmail.com>
Date:   Wed, 26 Dec 2018 19:11:57 +0530
Message-ID: <CAFqt6za-vq4GihKbSJjF1_=_xnWvBbpCQDf8iuhF0e8XJY4JVA@mail.gmail.com>
Subject: Re: [PATCH v5 0/9] Use vm_insert_range
To:     Russell King - ARM Linux <linux@armlinux.org.uk>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Michal Hocko <mhocko@suse.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        vbabka@suse.cz, Rik van Riel <riel@surriel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        rppt@linux.vnet.ibm.com, Peter Zijlstra <peterz@infradead.org>,
        robin.murphy@arm.com, iamjoonsoo.kim@lge.com, treding@nvidia.com,
        Kees Cook <keescook@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        stefanr@s5r6.in-berlin.de, hjc@rock-chips.com,
        Heiko Stuebner <heiko@sntech.de>, airlied@linux.ie,
        oleksandr_andrushchenko@epam.com, joro@8bytes.org,
        pawel@osciak.com, Kyungmin Park <kyungmin.park@samsung.com>,
        mchehab@kernel.org, Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, xen-devel@lists.xen.org,
        Linux-MM <linux-mm@kvack.org>, iommu@lists.linux-foundation.org,
        linux1394-devel@lists.sourceforge.net,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Mon, Dec 24, 2018 at 8:51 PM Russell King - ARM Linux
<linux@armlinux.org.uk> wrote:
>
> Having discussed with Matthew offlist, I think we've come to the
> following conclusion - there's a number of drivers that buggily
> ignore vm_pgoff.
>
> So, what I proposed is:
>
> static int __vm_insert_range(struct vm_struct *vma, struct page *pages,
>                              size_t num, unsigned long offset)
> {
>         unsigned long count = vma_pages(vma);
>         unsigned long uaddr = vma->vm_start;
>         int ret;
>
>         /* Fail if the user requested offset is beyond the end of the object */
>         if (offset > num)
>                 return -ENXIO;
>
>         /* Fail if the user requested size exceeds available object size */
>         if (count > num - offset)
>                 return -ENXIO;
>
>         /* Never exceed the number of pages that the user requested */
>         for (i = 0; i < count; i++) {
>                 ret = vm_insert_page(vma, uaddr, pages[offset + i]);
>                 if (ret < 0)
>                         return ret;
>                 uaddr += PAGE_SIZE;
>         }
>
>         return 0;
> }
>
> /*
>  * Maps an object consisting of `num' `pages', catering for the user's
>  * requested vm_pgoff
>  */
> int vm_insert_range(struct vm_struct *vma, struct page *pages, size_t num)
> {
>         return __vm_insert_range(vma, pages, num, vma->vm_pgoff);
> }
>
> /*
>  * Maps a set of pages, always starting at page[0]
>  */
> int vm_insert_range_buggy(struct vm_struct *vma, struct page *pages, size_t num)
> {
>         return __vm_insert_range(vma, pages, num, 0);
> }
>
> With this, drivers such as iommu/dma-iommu.c can be converted thusly:
>
>  int iommu_dma_mmap(struct page **pages, size_t size, struct vm_area_struct *vma+)
>  {
> -       unsigned long uaddr = vma->vm_start;
> -       unsigned int i, count = PAGE_ALIGN(size) >> PAGE_SHIFT;
> -       int ret = -ENXIO;
> -
> -       for (i = vma->vm_pgoff; i < count && uaddr < vma->vm_end; i++) {
> -               ret = vm_insert_page(vma, uaddr, pages[i]);
> -               if (ret)
> -                       break;
> -               uaddr += PAGE_SIZE;
> -       }
> -       return ret;
> +       return vm_insert_range(vma, pages, PAGE_ALIGN(size) >> PAGE_SHIFT);
> }
>
> and drivers such as firewire/core-iso.c:
>
>  int fw_iso_buffer_map_vma(struct fw_iso_buffer *buffer,
>                           struct vm_area_struct *vma)
>  {
> -       unsigned long uaddr;
> -       int i, err;
> -
> -       uaddr = vma->vm_start;
> -       for (i = 0; i < buffer->page_count; i++) {
> -               err = vm_insert_page(vma, uaddr, buffer->pages[i]);
> -               if (err)
> -                       return err;
> -
> -               uaddr += PAGE_SIZE;
> -       }
> -
> -       return 0;
> +       return vm_insert_range_buggy(vma, buffer->pages, buffer->page_count);
> }
>
> and this gives us something to grep for to find these buggy drivers.
>
> Now, this may not look exactly equivalent, but if you look at
> fw_device_op_mmap(), buffer->page_count is basically vma_pages(vma)
> at this point, which means this should be equivalent.
>
> We _could_ then at a later date "fix" these drivers to behave according
> to the normal vm_pgoff offsetting simply by removing the _buggy suffix
> on the function name... and if that causes regressions, it gives us an
> easy way to revert (as long as vm_insert_range_buggy() remains
> available.)
>
> In the case of firewire/core-iso.c, it currently ignores the mmap offset
> entirely, so making the above suggested change would be tantamount to
> causing it to return -ENXIO for any non-zero mmap offset.
>
> IMHO, this approach is way simpler, and easier to get it correct at
> each call site, rather than the current approach which seems to be
> error-prone.

Thanks Russell.
I will drop this patch series and rework on it as suggested.
