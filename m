Return-Path: <SRS0=JQ9q=P6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50C33C282C3
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 07:01:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 137F120854
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 07:01:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ju/wbRai"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbfAVHBD (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 22 Jan 2019 02:01:03 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:43498 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbfAVHBC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Jan 2019 02:01:02 -0500
Received: by mail-lf1-f68.google.com with SMTP id u18so17229293lff.10;
        Mon, 21 Jan 2019 23:01:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gELQudhz58q+DJDV372aKur4b52yXBFHqo3p/1/epX0=;
        b=ju/wbRaiQK+PGoIe980i73IkWyZOcGgLds1X6yS8+dyW2hPJ8EeY/cV9ZcT22L8d8B
         +nSeIHrfxHIMTQ0bV2q8Hzpa/44AF5RnMNUpz0UbbE+rS0sQiwaPg2yjDJcmQJ0rzUuA
         /+F47UbAsvMdhm5VySdUBQ7qVjsOHKgTIY/89sokdQvZx35D3lDoU5w4NLGiNPi8VyM6
         ePJ6XrppTBsHJ3Tzh5yibTUv8khy7WXIrAI0Rs2IIzr9uu/LUs3oOSdlA190uU6y1KpI
         Tp0jmkzDO1o4Cm3DFtXcZxiclWU96S0Lbgu4Bk0jlh51yl85gNEbbk5IxMve+rn2btyE
         vmaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gELQudhz58q+DJDV372aKur4b52yXBFHqo3p/1/epX0=;
        b=ZD1EH4bcW7DzbbNyo1AWhMtaskoRE5fxsI0we/+ztWCoDfUJmwhsmWej8cPgEHNwqI
         tHb+MCh9dtxHo7qAAuMW0+hzQQJqev5YLOLsCkiYkhWRN7oWMzBB+bwYNOl6XxFOY/0T
         6A8XNTf7+NBNeQTROk7yewzDb9hOrY2iGtCCtEPNlYAWA7IDlChzqMUmy9i+ZRELSd6S
         idCokiDn4CyUSTAQfM1ZBKQ2H+2F14fd9HLjX5PsW8jCegy4Gw2pN1G/fvehzkWEAZR1
         pvshLJnxW+Eo8NjjULY/ndoawpC6+qlRCiH5l1zB8yZfIOWTup5KN5M2NlhcDMlYaK+h
         Pd6g==
X-Gm-Message-State: AJcUukc+QFHJ917Adp4pb0DPB9+kDi+RHb420kttjREwiW1EtVh+dmWo
        cmmGe3qRZOVSHV47UGuH0RO7+xkM0nk/7+9YTYQ=
X-Google-Smtp-Source: ALg8bN5gT5OYIsNf6kzYRoKkBJpu3w73otKRaRsQX3tTXfLn+Hvz7kpoUCVQ3KKhPY1rbMQ/DQw1jB+C/ru5U9faLaI=
X-Received: by 2002:a19:6514:: with SMTP id z20mr18984719lfb.31.1548140459614;
 Mon, 21 Jan 2019 23:00:59 -0800 (PST)
MIME-Version: 1.0
References: <20190111150712.GA2696@jordon-HP-15-Notebook-PC>
In-Reply-To: <20190111150712.GA2696@jordon-HP-15-Notebook-PC>
From:   Souptick Joarder <jrdr.linux@gmail.com>
Date:   Tue, 22 Jan 2019 12:30:47 +0530
Message-ID: <CAFqt6zYOpbwc8518f27W8_YOkuprdJJLyJg1fFB==wrFZLdEYQ@mail.gmail.com>
Subject: Re: [PATCH 1/9] mm: Introduce new vm_insert_range and
 vm_insert_range_buggy API
To:     Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Michal Hocko <mhocko@suse.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        vbabka@suse.cz, Rik van Riel <riel@surriel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        rppt@linux.vnet.ibm.com, Peter Zijlstra <peterz@infradead.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        robin.murphy@arm.com, iamjoonsoo.kim@lge.com, treding@nvidia.com,
        Kees Cook <keescook@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        stefanr@s5r6.in-berlin.de, hjc@rock-chips.com,
        Heiko Stuebner <heiko@sntech.de>, airlied@linux.ie,
        oleksandr_andrushchenko@epam.com, joro@8bytes.org,
        pawel@osciak.com, Kyungmin Park <kyungmin.park@samsung.com>,
        mchehab@kernel.org, Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>
Cc:     linux-kernel@vger.kernel.org, Linux-MM <linux-mm@kvack.org>,
        linux-arm-kernel@lists.infradead.org,
        linux1394-devel@lists.sourceforge.net,
        dri-devel@lists.freedesktop.org,
        linux-rockchip@lists.infradead.org, xen-devel@lists.xen.org,
        iommu@lists.linux-foundation.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Fri, Jan 11, 2019 at 8:33 PM Souptick Joarder <jrdr.linux@gmail.com> wrote:
>
> Previouly drivers have their own way of mapping range of
> kernel pages/memory into user vma and this was done by
> invoking vm_insert_page() within a loop.
>
> As this pattern is common across different drivers, it can
> be generalized by creating new functions and use it across
> the drivers.
>
> vm_insert_range() is the API which could be used to mapped
> kernel memory/pages in drivers which has considered vm_pgoff
>
> vm_insert_range_buggy() is the API which could be used to map
> range of kernel memory/pages in drivers which has not considered
> vm_pgoff. vm_pgoff is passed default as 0 for those drivers.
>
> We _could_ then at a later "fix" these drivers which are using
> vm_insert_range_buggy() to behave according to the normal vm_pgoff
> offsetting simply by removing the _buggy suffix on the function
> name and if that causes regressions, it gives us an easy way to revert.
>
> Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
> Suggested-by: Russell King <linux@armlinux.org.uk>
> Suggested-by: Matthew Wilcox <willy@infradead.org>

Any comment on these APIs ?

> ---
>  include/linux/mm.h |  4 +++
>  mm/memory.c        | 81 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  mm/nommu.c         | 14 ++++++++++
>  3 files changed, 99 insertions(+)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 5411de9..9d1dff6 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2514,6 +2514,10 @@ unsigned long change_prot_numa(struct vm_area_struct *vma,
>  int remap_pfn_range(struct vm_area_struct *, unsigned long addr,
>                         unsigned long pfn, unsigned long size, pgprot_t);
>  int vm_insert_page(struct vm_area_struct *, unsigned long addr, struct page *);
> +int vm_insert_range(struct vm_area_struct *vma, struct page **pages,
> +                               unsigned long num);
> +int vm_insert_range_buggy(struct vm_area_struct *vma, struct page **pages,
> +                               unsigned long num);
>  vm_fault_t vmf_insert_pfn(struct vm_area_struct *vma, unsigned long addr,
>                         unsigned long pfn);
>  vm_fault_t vmf_insert_pfn_prot(struct vm_area_struct *vma, unsigned long addr,
> diff --git a/mm/memory.c b/mm/memory.c
> index 4ad2d29..00e66df 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -1520,6 +1520,87 @@ int vm_insert_page(struct vm_area_struct *vma, unsigned long addr,
>  }
>  EXPORT_SYMBOL(vm_insert_page);
>
> +/**
> + * __vm_insert_range - insert range of kernel pages into user vma
> + * @vma: user vma to map to
> + * @pages: pointer to array of source kernel pages
> + * @num: number of pages in page array
> + * @offset: user's requested vm_pgoff
> + *
> + * This allows drivers to insert range of kernel pages they've allocated
> + * into a user vma.
> + *
> + * If we fail to insert any page into the vma, the function will return
> + * immediately leaving any previously inserted pages present.  Callers
> + * from the mmap handler may immediately return the error as their caller
> + * will destroy the vma, removing any successfully inserted pages. Other
> + * callers should make their own arrangements for calling unmap_region().
> + *
> + * Context: Process context.
> + * Return: 0 on success and error code otherwise.
> + */
> +static int __vm_insert_range(struct vm_area_struct *vma, struct page **pages,
> +                               unsigned long num, unsigned long offset)
> +{
> +       unsigned long count = vma_pages(vma);
> +       unsigned long uaddr = vma->vm_start;
> +       int ret, i;
> +
> +       /* Fail if the user requested offset is beyond the end of the object */
> +       if (offset > num)
> +               return -ENXIO;
> +
> +       /* Fail if the user requested size exceeds available object size */
> +       if (count > num - offset)
> +               return -ENXIO;
> +
> +       for (i = 0; i < count; i++) {
> +               ret = vm_insert_page(vma, uaddr, pages[offset + i]);
> +               if (ret < 0)
> +                       return ret;
> +               uaddr += PAGE_SIZE;
> +       }
> +
> +       return 0;
> +}
> +
> +/**
> + * vm_insert_range - insert range of kernel pages starts with non zero offset
> + * @vma: user vma to map to
> + * @pages: pointer to array of source kernel pages
> + * @num: number of pages in page array
> + *
> + * Maps an object consisting of `num' `pages', catering for the user's
> + * requested vm_pgoff
> + *
> + * Context: Process context. Called by mmap handlers.
> + * Return: 0 on success and error code otherwise.
> + */
> +int vm_insert_range(struct vm_area_struct *vma, struct page **pages,
> +                               unsigned long num)
> +{
> +       return __vm_insert_range(vma, pages, num, vma->vm_pgoff);
> +}
> +EXPORT_SYMBOL(vm_insert_range);
> +
> +/**
> + * vm_insert_range_buggy - insert range of kernel pages starts with zero offset
> + * @vma: user vma to map to
> + * @pages: pointer to array of source kernel pages
> + * @num: number of pages in page array
> + *
> + * Maps a set of pages, always starting at page[0]
> + *
> + * Context: Process context. Called by mmap handlers.
> + * Return: 0 on success and error code otherwise.
> + */
> +int vm_insert_range_buggy(struct vm_area_struct *vma, struct page **pages,
> +                               unsigned long num)
> +{
> +       return __vm_insert_range(vma, pages, num, 0);
> +}
> +EXPORT_SYMBOL(vm_insert_range_buggy);
> +
>  static vm_fault_t insert_pfn(struct vm_area_struct *vma, unsigned long addr,
>                         pfn_t pfn, pgprot_t prot, bool mkwrite)
>  {
> diff --git a/mm/nommu.c b/mm/nommu.c
> index 749276b..21d101e 100644
> --- a/mm/nommu.c
> +++ b/mm/nommu.c
> @@ -473,6 +473,20 @@ int vm_insert_page(struct vm_area_struct *vma, unsigned long addr,
>  }
>  EXPORT_SYMBOL(vm_insert_page);
>
> +int vm_insert_range(struct vm_area_struct *vma, struct page **pages,
> +                       unsigned long num)
> +{
> +       return -EINVAL;
> +}
> +EXPORT_SYMBOL(vm_insert_range);
> +
> +int vm_insert_range_buggy(struct vm_area_struct *vma, struct page **pages,
> +                               unsigned long num)
> +{
> +       return -EINVAL;
> +}
> +EXPORT_SYMBOL(vm_insert_range_buggy);
> +
>  /*
>   *  sys_brk() for the most part doesn't need the global kernel
>   *  lock, except when an application is doing something nasty
> --
> 1.9.1
>
