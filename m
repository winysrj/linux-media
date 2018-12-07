Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	T_DKIMWL_WL_HIGH,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 450F6C07E85
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 14:48:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0187E20882
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 14:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544194126;
	bh=jaaQ8PVFRAAxpq4bMdUgkhUOIJ1F0jmOwGZNTQPv99k=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=og+NxqR4x8ooOtgH36NzzsDbw3ZA/tJUnqc0tHCCC73G3PW8GzH/XDAqHJ6ic/kr6
	 0ycdLsZRTqKDQrSXmd8qowb7LgK8ZYyiFtnkd/8EG+eK7L6xiYN0iJatPTOtALpKML
	 9v9umgVcuS3ufyx5kERRTsIEYptVBPQNClPch9V8=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0187E20882
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726059AbeLGOsj (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 09:48:39 -0500
Received: from casper.infradead.org ([85.118.1.10]:36492 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725998AbeLGOsj (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Dec 2018 09:48:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=oNrFVpEvwM5tm4S1RtkTXeWDU/RF+Ze1Ir2ZnY6+CAM=; b=PdUOL7VdOW5866PdBzfBdxOEHd
        iCvBJtzhh5fYvtfStmDGKOlwap1S9kw9mNeuOQfFzSVTDiDvwoO2lJFAsEQ+8ma+PwNZWVXScW2HH
        dkRZuw8a0j8Dgy5b07XcRlP2glp7+1pXyqbjPv8Gk6a7RrnAE2qjfsSTDGg3TCGMLBp/Z/ZdXNanW
        4DYmXstsURNOfpAHGmtEZHgcW1/EuVtDybYQP67bcf26+gZfK6aevsY7k4gsCvgoSthYmhlHgBGRp
        nwAcc+VigY0SuXh/1PyMSr62AO6CNym/uj3HYtBxe5fsHxnYMOrNYK4vp9OCKNDJYbsaYi7U4PNHF
        LQ07fngQ==;
Received: from [179.95.33.236] (helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gVHPx-0005b8-57; Fri, 07 Dec 2018 14:47:49 +0000
Date:   Fri, 7 Dec 2018 12:47:37 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Souptick Joarder <jrdr.linux@gmail.com>
Cc:     akpm@linux-foundation.org, willy@infradead.org, mhocko@suse.com,
        kirill.shutemov@linux.intel.com, vbabka@suse.cz, riel@surriel.com,
        sfr@canb.auug.org.au, rppt@linux.vnet.ibm.com,
        peterz@infradead.org, linux@armlinux.org.uk, robin.murphy@arm.com,
        iamjoonsoo.kim@lge.com, treding@nvidia.com, keescook@chromium.org,
        m.szyprowski@samsung.com, stefanr@s5r6.in-berlin.de,
        hjc@rock-chips.com, heiko@sntech.de, airlied@linux.ie,
        oleksandr_andrushchenko@epam.com, joro@8bytes.org,
        pawel@osciak.com, kyungmin.park@samsung.com,
        boris.ostrovsky@oracle.com, jgross@suse.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org,
        linux1394-devel@lists.sourceforge.net,
        dri-devel@lists.freedesktop.org,
        linux-rockchip@lists.infradead.org, xen-devel@lists.xen.org,
        iommu@lists.linux-foundation.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v3 1/9] mm: Introduce new vm_insert_range API
Message-ID: <20181207124737.123cb2e1@coco.lan>
In-Reply-To: <20181206183945.GA20932@jordon-HP-15-Notebook-PC>
References: <20181206183945.GA20932@jordon-HP-15-Notebook-PC>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Fri, 7 Dec 2018 00:09:45 +0530
Souptick Joarder <jrdr.linux@gmail.com> escreveu:

> Previouly drivers have their own way of mapping range of
> kernel pages/memory into user vma and this was done by
> invoking vm_insert_page() within a loop.
> 
> As this pattern is common across different drivers, it can
> be generalized by creating a new function and use it across
> the drivers.
> 
> vm_insert_range is the new API which will be used to map a
> range of kernel memory/pages to user vma.
> 
> This API is tested by Heiko for Rockchip drm driver, on rk3188,
> rk3288, rk3328 and rk3399 with graphics.
> 
> Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
> Reviewed-by: Matthew Wilcox <willy@infradead.org>
> Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
> Tested-by: Heiko Stuebner <heiko@sntech.de>

Looks good to me.

Reviewed-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

> ---
>  include/linux/mm.h |  2 ++
>  mm/memory.c        | 38 ++++++++++++++++++++++++++++++++++++++
>  mm/nommu.c         |  7 +++++++
>  3 files changed, 47 insertions(+)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index fcf9cc9..2bc399f 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2506,6 +2506,8 @@ unsigned long change_prot_numa(struct vm_area_struct *vma,
>  int remap_pfn_range(struct vm_area_struct *, unsigned long addr,
>  			unsigned long pfn, unsigned long size, pgprot_t);
>  int vm_insert_page(struct vm_area_struct *, unsigned long addr, struct page *);
> +int vm_insert_range(struct vm_area_struct *vma, unsigned long addr,
> +			struct page **pages, unsigned long page_count);
>  vm_fault_t vmf_insert_pfn(struct vm_area_struct *vma, unsigned long addr,
>  			unsigned long pfn);
>  vm_fault_t vmf_insert_pfn_prot(struct vm_area_struct *vma, unsigned long addr,
> diff --git a/mm/memory.c b/mm/memory.c
> index 15c417e..84ea46c 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -1478,6 +1478,44 @@ static int insert_page(struct vm_area_struct *vma, unsigned long addr,
>  }
>  
>  /**
> + * vm_insert_range - insert range of kernel pages into user vma
> + * @vma: user vma to map to
> + * @addr: target user address of this page
> + * @pages: pointer to array of source kernel pages
> + * @page_count: number of pages need to insert into user vma
> + *
> + * This allows drivers to insert range of kernel pages they've allocated
> + * into a user vma. This is a generic function which drivers can use
> + * rather than using their own way of mapping range of kernel pages into
> + * user vma.
> + *
> + * If we fail to insert any page into the vma, the function will return
> + * immediately leaving any previously-inserted pages present.  Callers
> + * from the mmap handler may immediately return the error as their caller
> + * will destroy the vma, removing any successfully-inserted pages. Other
> + * callers should make their own arrangements for calling unmap_region().
> + *
> + * Context: Process context. Called by mmap handlers.
> + * Return: 0 on success and error code otherwise
> + */
> +int vm_insert_range(struct vm_area_struct *vma, unsigned long addr,
> +			struct page **pages, unsigned long page_count)
> +{
> +	unsigned long uaddr = addr;
> +	int ret = 0, i;
> +
> +	for (i = 0; i < page_count; i++) {
> +		ret = vm_insert_page(vma, uaddr, pages[i]);
> +		if (ret < 0)
> +			return ret;
> +		uaddr += PAGE_SIZE;
> +	}
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(vm_insert_range);
> +
> +/**
>   * vm_insert_page - insert single page into user vma
>   * @vma: user vma to map to
>   * @addr: target user address of this page
> diff --git a/mm/nommu.c b/mm/nommu.c
> index 749276b..d6ef5c7 100644
> --- a/mm/nommu.c
> +++ b/mm/nommu.c
> @@ -473,6 +473,13 @@ int vm_insert_page(struct vm_area_struct *vma, unsigned long addr,
>  }
>  EXPORT_SYMBOL(vm_insert_page);
>  
> +int vm_insert_range(struct vm_area_struct *vma, unsigned long addr,
> +			struct page **pages, unsigned long page_count)
> +{
> +	return -EINVAL;
> +}
> +EXPORT_SYMBOL(vm_insert_range);
> +
>  /*
>   *  sys_brk() for the most part doesn't need the global kernel
>   *  lock, except when an application is doing something nasty



Thanks,
Mauro
