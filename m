Return-Path: <SRS0=uIFo=QO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4452CC282C4
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 16:48:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 13BFE218D3
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 16:48:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MgrpJ4M1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbfBGQsS (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Feb 2019 11:48:18 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:54386 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbfBGQsS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Feb 2019 11:48:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=3Crx6L2SCrC/hAezTHTZyMkEY70y9OGZyoS8mOjuiIQ=; b=MgrpJ4M1SKwbB/Yo3N593SLwA
        QNDOZMk72sEtYMlIQ2rFvlvgbFIhWnRTu0thbBjirZlJknxymzD0HlsaEH8nReOJbVVxfO458DPHx
        18yB2e7GdJ+zJKh8tL57dO6yUGJtkp6ZOctQW4gvRn8N7q103oDWHKd2S3aT32MGVDWPczZ0fLbKk
        802j/CifGuu9dRvUnhxbfXQKEAmG4f1FQ+LjKl0KMb4UJPEZSsIyATZ9pCOxvhP9w6nv9+hI3EPu9
        qv1xZyihrFaiRXH2Beb+ldPwNcCjSCXviraUqBQW8KnDrAxVFueDl/Uy9nOP9VkSNyTz0+UfhBWNV
        mRrXbihYg==;
Received: from willy by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1grmpv-00037s-JZ; Thu, 07 Feb 2019 16:47:39 +0000
Date:   Thu, 7 Feb 2019 08:47:39 -0800
From:   Matthew Wilcox <willy@infradead.org>
To:     Souptick Joarder <jrdr.linux@gmail.com>
Cc:     Mike Rapoport <rppt@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
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
        Juergen Gross <jgross@suse.com>, linux-kernel@vger.kernel.org,
        Linux-MM <linux-mm@kvack.org>,
        linux-arm-kernel@lists.infradead.org,
        linux1394-devel@lists.sourceforge.net,
        dri-devel@lists.freedesktop.org,
        linux-rockchip@lists.infradead.org, xen-devel@lists.xen.org,
        iommu@lists.linux-foundation.org, linux-media@vger.kernel.org
Subject: Re: [PATCHv2 1/9] mm: Introduce new vm_insert_range and
 vm_insert_range_buggy API
Message-ID: <20190207164739.GX21860@bombadil.infradead.org>
References: <20190131030812.GA2174@jordon-HP-15-Notebook-PC>
 <20190131083842.GE28876@rapoport-lnx>
 <CAFqt6za9xA_8OKiaaHXcO9go+RtPdjLY5Bz_fgQL+DZbermNhA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFqt6za9xA_8OKiaaHXcO9go+RtPdjLY5Bz_fgQL+DZbermNhA@mail.gmail.com>
User-Agent: Mutt/1.9.2 (2017-12-15)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, Feb 07, 2019 at 09:19:47PM +0530, Souptick Joarder wrote:
> Just thought to take opinion for documentation before placing it in v3.
> Does it looks fine ?
> 
> +/**
> + * __vm_insert_range - insert range of kernel pages into user vma
> + * @vma: user vma to map to
> + * @pages: pointer to array of source kernel pages
> + * @num: number of pages in page array
> + * @offset: user's requested vm_pgoff
> + *
> + * This allow drivers to insert range of kernel pages into a user vma.
> + *
> + * Return: 0 on success and error code otherwise.
> + */
> +static int __vm_insert_range(struct vm_area_struct *vma, struct page **pages,
> +                               unsigned long num, unsigned long offset)

For static functions, I prefer to leave off the second '*', ie make it
formatted like a docbook comment, but not be processed like a docbook
comment.  That avoids cluttering the html with descriptions of internal
functions that people can't actually call.

> +/**
> + * vm_insert_range - insert range of kernel pages starts with non zero offset
> + * @vma: user vma to map to
> + * @pages: pointer to array of source kernel pages
> + * @num: number of pages in page array
> + *
> + * Maps an object consisting of `num' `pages', catering for the user's

Rather than using `num', you should use @num.

> + * requested vm_pgoff
> + *
> + * If we fail to insert any page into the vma, the function will return
> + * immediately leaving any previously inserted pages present.  Callers
> + * from the mmap handler may immediately return the error as their caller
> + * will destroy the vma, removing any successfully inserted pages. Other
> + * callers should make their own arrangements for calling unmap_region().
> + *
> + * Context: Process context. Called by mmap handlers.
> + * Return: 0 on success and error code otherwise.
> + */
> +int vm_insert_range(struct vm_area_struct *vma, struct page **pages,
> +                               unsigned long num)
> 
> 
> +/**
> + * vm_insert_range_buggy - insert range of kernel pages starts with zero offset
> + * @vma: user vma to map to
> + * @pages: pointer to array of source kernel pages
> + * @num: number of pages in page array
> + *
> + * Similar to vm_insert_range(), except that it explicitly sets @vm_pgoff to

But vm_pgoff isn't a parameter, so it's misleading to format it as such.

> + * 0. This function is intended for the drivers that did not consider
> + * @vm_pgoff.
> + *
> + * Context: Process context. Called by mmap handlers.
> + * Return: 0 on success and error code otherwise.
> + */
> +int vm_insert_range_buggy(struct vm_area_struct *vma, struct page **pages,
> +                               unsigned long num)

I don't think we should call it 'buggy'.  'zero' would make more sense
as a suffix.

Given how this interface has evolved, I'm no longer sure than
'vm_insert_range' makes sense as the name for it.  Is it perhaps
'vm_map_object' or 'vm_map_pages'?

