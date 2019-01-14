Return-Path: <SRS0=CLae=PW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_PASS,USER_AGENT_MUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEC08C43387
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 22:17:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C21920657
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 22:17:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="cJHckXEt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbfANWQ5 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 14 Jan 2019 17:16:57 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:43460 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726696AbfANWQ5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Jan 2019 17:16:57 -0500
Received: by mail-pf1-f195.google.com with SMTP id w73so261636pfk.10
        for <linux-media@vger.kernel.org>; Mon, 14 Jan 2019 14:16:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=kmhjZK5mRNchXvBdcB0fkbXb96cvlvZwjT2+5bWrsaE=;
        b=cJHckXEtwM/1cjx+aLuiesMvysoLqvJG29OSWhLqJmywQtcE717tzhqVhbNmB8GBfk
         VfFMVx3pkfLFhNMy6Vyqtp/kCi4BcWkDScuR98Zkoy/exrWEd342qXDgvfD/killyoE6
         h1LUSl3F+xTAh1zggZlTZhRaCKxZYLgyTUAWse1B7gSvDpCHg+8ymLfkWi30xsQT3+5V
         Kcl+GHqQgBgaRlTGRygnYVkYYrl4kRsE8sIsOR61X4nX5oqFcr7RqvTKXrNZ7grVeAjP
         mhhbljLcY73Au5pcaQYqwNzZ1evgIzRcx8C+jFL+20H9G7jfyUVtUEPH/ZowNIGo2SyX
         SnlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=kmhjZK5mRNchXvBdcB0fkbXb96cvlvZwjT2+5bWrsaE=;
        b=Z1nK+97p6CyiZoIjWoPyzsICMi9OySlSfDEcy7P+SA9DaNmsx1+WDQiLzQMgDeZFZL
         j3zYfWYbLyPFX7PX5iV2MDBWnAl1jepx8T/9w5llW5x+J4tewY+yC0LKpviKSc29XFyF
         u98Jse2l+F1dLTEfk+xufR2kjyIUt3omappNE5U8xA1prQES4ZR5IZ1qdzyph87a3OJ3
         yEECxhh/RLWbpykQTMuzzHokabjAmky3khKXWGlrcu1lOQ6QWoFL7O2I9dBHIjOmgH14
         cnc60fb+qaUMHORNkuxg9ruFl1XA8oiuqcTsiRBX9MjvvlPvsWVaXuwCdVRU2r+8oIaB
         /uKQ==
X-Gm-Message-State: AJcUukcLD6n9UKw+BoAEuYnLDWHVJJC3j+OUzL3vvSCGxDvM4IVZVZTI
        mJh5MDvcCYZLgdEaNVc8oDBpiw==
X-Google-Smtp-Source: ALg8bN6rX0XT0UyOxLHd5HvY5eqwF7ViiLWlZwxAKffiAGkGQp2TwwaZt0syfAG1ehYxz0lFEnyCpw==
X-Received: by 2002:a62:e201:: with SMTP id a1mr663560pfi.75.1547504216384;
        Mon, 14 Jan 2019 14:16:56 -0800 (PST)
Received: from ziepe.ca (S010614cc2056d97f.ed.shawcable.net. [174.3.196.123])
        by smtp.gmail.com with ESMTPSA id o8sm1741943pfa.42.2019.01.14.14.16.55
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 14 Jan 2019 14:16:55 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1gjAXO-00059T-Ma; Mon, 14 Jan 2019 15:16:54 -0700
Date:   Mon, 14 Jan 2019 15:16:54 -0700
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Shiraz Saleem <shiraz.saleem@intel.com>
Cc:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Imre Deak <imre.deak@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Yong Zhi <yong.zhi@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Bingbu Cao <bingbu.cao@intel.com>,
        Tian Shu Qiu <tian.shu.qiu@intel.com>,
        Jian Xu Zheng <jian.xu.zheng@intel.com>,
        Sinclair Yeh <syeh@vmware.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH] lib/scatterlist: Provide a DMA page iterator
Message-ID: <20190114221654.GE1208@ziepe.ca>
References: <20190104223531.GA1705@ziepe.ca>
 <20190112182704.GA15320@ssaleem-MOBL4.amr.corp.intel.com>
 <20190112183752.GC16457@mellanox.com>
 <20190112190305.GA19436@ssaleem-MOBL4.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190112190305.GA19436@ssaleem-MOBL4.amr.corp.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Sat, Jan 12, 2019 at 01:03:05PM -0600, Shiraz Saleem wrote:
> On Sat, Jan 12, 2019 at 06:37:58PM +0000, Jason Gunthorpe wrote:
> > On Sat, Jan 12, 2019 at 12:27:05PM -0600, Shiraz Saleem wrote:
> > > On Fri, Jan 04, 2019 at 10:35:43PM +0000, Jason Gunthorpe wrote:
> > > > Commit 2db76d7c3c6d ("lib/scatterlist: sg_page_iter: support sg lists w/o
> > > > backing pages") introduced the sg_page_iter_dma_address() function without
> > > > providing a way to use it in the general case. If the sg_dma_len is not
> > > > equal to the dma_length callers cannot safely use the
> > > > for_each_sg_page/sg_page_iter_dma_address combination.
> > > > 
> > > > Resolve this API mistake by providing a DMA specific iterator,
> > > > for_each_sg_dma_page(), that uses the right length so
> > > > sg_page_iter_dma_address() works as expected with all sglists. A new
> > > > iterator type is introduced to provide compile-time safety against wrongly
> > > > mixing accessors and iterators.
> > > [..]
> > > 
> > > >  
> > > > +/*
> > > > + * sg page iterator for DMA addresses
> > > > + *
> > > > + * This is the same as sg_page_iter however you can call
> > > > + * sg_page_iter_dma_address(@dma_iter) to get the page's DMA
> > > > + * address. sg_page_iter_page() cannot be called on this iterator.
> > > > + */
> > > Does it make sense to have a variant of sg_page_iter_page() to get the
> > > page descriptor with this dma_iter? This can be used when walking DMA-mapped
> > > SG lists with for_each_sg_dma_page.
> > 
> > I think that would be a complicated cacluation to find the right
> > offset into the page sg list to get the page pointer back. We can't
> > just naively use the existing iterator location.
> > 
> > Probably places that need this are better to run with two iterators,
> > less computationally expensive.
> > 
> > Did you find a need for this? 
> > 
> 
> Well I was trying convert the RDMA drivers to use your new iterator variant
> and saw the need for it in locations where we need virtual address of the pages
> contained in the SGEs.
> 
> diff --git a/drivers/infiniband/hw/bnxt_re/qplib_res.c b/drivers/infiniband/hw/bnxt_re/qplib_res.c
> index 59eeac5..7d26903 100644
> --- a/drivers/infiniband/hw/bnxt_re/qplib_res.c
> +++ b/drivers/infiniband/hw/bnxt_re/qplib_res.c
> @@ -85,7 +85,7 @@ static void __free_pbl(struct pci_dev *pdev, struct bnxt_qplib_pbl *pbl,
>  static int __alloc_pbl(struct pci_dev *pdev, struct bnxt_qplib_pbl *pbl,
>                        struct scatterlist *sghead, u32 pages, u32 pg_size)
>  {
> -       struct scatterlist *sg;
> +       struct sg_dma_page_iter sg_iter;
>         bool is_umem = false;
>         int i;
> 
> @@ -116,12 +116,13 @@ static int __alloc_pbl(struct pci_dev *pdev, struct bnxt_qplib_pbl *pbl,
>         } else {
>                 i = 0;
>                 is_umem = true;
> -               for_each_sg(sghead, sg, pages, i) {
> -                       pbl->pg_map_arr[i] = sg_dma_address(sg);
> -                       pbl->pg_arr[i] = sg_virt(sg);
> +               for_each_sg_dma_page(sghead, &sg_iter, pages, 0) {
> +                       pbl->pg_map_arr[i] = sg_page_iter_dma_address(&sg_iter);
> +                       pbl->pg_arr[i] = page_address(sg_page_iter_page(&sg_iter.base)); ???
> 					^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

I concur with CH, pg_arr only looks used in the !umem case, so set to
NULL here. Check with Selvin & Devesh ?

> @@ -191,16 +190,16 @@ int rxe_mem_init_user(struct rxe_pd *pd, u64 start,
>                 goto err1;
>         }
> 
> -       mem->page_shift         = umem->page_shift;
> -       mem->page_mask          = BIT(umem->page_shift) - 1;
> +       mem->page_shift         = PAGE_SHIFT;
> +       mem->page_mask          = PAGE_SIZE - 1;
> 
>         num_buf                 = 0;
>         map                     = mem->map;
>         if (length > 0) {
>                 buf = map[0]->buf;
> 
> -               for_each_sg(umem->sg_head.sgl, sg, umem->nmap, entry) {
> -                       vaddr = page_address(sg_page(sg));
> +               for_each_sg_dma_page(umem->sg_head.sgl, &sg_iter, umem->nmap, 0) {
> +                       vaddr = page_address(sg_page_iter_page(&sg_iter.base));   ?????
> 				^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

rxe doesn't use DMA addreses, so just leave as for_each_sg_page

Jason
