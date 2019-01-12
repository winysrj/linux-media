Return-Path: <SRS0=PrKG=PU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CE49C43387
	for <linux-media@archiver.kernel.org>; Sat, 12 Jan 2019 19:03:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 20E3020835
	for <linux-media@archiver.kernel.org>; Sat, 12 Jan 2019 19:03:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbfALTDK (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 12 Jan 2019 14:03:10 -0500
Received: from mga04.intel.com ([192.55.52.120]:25020 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725851AbfALTDK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 12 Jan 2019 14:03:10 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Jan 2019 11:03:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,470,1539673200"; 
   d="scan'208";a="127180259"
Received: from ssaleem-mobl4.amr.corp.intel.com (HELO ssaleem-mobl1) ([10.254.44.111])
  by orsmga001.jf.intel.com with SMTP; 12 Jan 2019 11:03:07 -0800
Received: by ssaleem-mobl1 (sSMTP sendmail emulation); Sat, 12 Jan 2019 13:03:06 -0600
Date:   Sat, 12 Jan 2019 13:03:05 -0600
From:   Shiraz Saleem <shiraz.saleem@intel.com>
To:     Jason Gunthorpe <jgg@mellanox.com>
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
Message-ID: <20190112190305.GA19436@ssaleem-MOBL4.amr.corp.intel.com>
References: <20190104223531.GA1705@ziepe.ca>
 <20190112182704.GA15320@ssaleem-MOBL4.amr.corp.intel.com>
 <20190112183752.GC16457@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190112183752.GC16457@mellanox.com>
User-Agent: Mutt/1.7.2 (2016-11-26)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Sat, Jan 12, 2019 at 06:37:58PM +0000, Jason Gunthorpe wrote:
> On Sat, Jan 12, 2019 at 12:27:05PM -0600, Shiraz Saleem wrote:
> > On Fri, Jan 04, 2019 at 10:35:43PM +0000, Jason Gunthorpe wrote:
> > > Commit 2db76d7c3c6d ("lib/scatterlist: sg_page_iter: support sg lists w/o
> > > backing pages") introduced the sg_page_iter_dma_address() function without
> > > providing a way to use it in the general case. If the sg_dma_len is not
> > > equal to the dma_length callers cannot safely use the
> > > for_each_sg_page/sg_page_iter_dma_address combination.
> > > 
> > > Resolve this API mistake by providing a DMA specific iterator,
> > > for_each_sg_dma_page(), that uses the right length so
> > > sg_page_iter_dma_address() works as expected with all sglists. A new
> > > iterator type is introduced to provide compile-time safety against wrongly
> > > mixing accessors and iterators.
> > [..]
> > 
> > >  
> > > +/*
> > > + * sg page iterator for DMA addresses
> > > + *
> > > + * This is the same as sg_page_iter however you can call
> > > + * sg_page_iter_dma_address(@dma_iter) to get the page's DMA
> > > + * address. sg_page_iter_page() cannot be called on this iterator.
> > > + */
> > Does it make sense to have a variant of sg_page_iter_page() to get the
> > page descriptor with this dma_iter? This can be used when walking DMA-mapped
> > SG lists with for_each_sg_dma_page.
> 
> I think that would be a complicated cacluation to find the right
> offset into the page sg list to get the page pointer back. We can't
> just naively use the existing iterator location.
> 
> Probably places that need this are better to run with two iterators,
> less computationally expensive.
> 
> Did you find a need for this? 
> 

Well I was trying convert the RDMA drivers to use your new iterator variant
and saw the need for it in locations where we need virtual address of the pages
contained in the SGEs.

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_res.c b/drivers/infiniband/hw/bnxt_re/qplib_res.c
index 59eeac5..7d26903 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_res.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_res.c
@@ -85,7 +85,7 @@ static void __free_pbl(struct pci_dev *pdev, struct bnxt_qplib_pbl *pbl,
 static int __alloc_pbl(struct pci_dev *pdev, struct bnxt_qplib_pbl *pbl,
                       struct scatterlist *sghead, u32 pages, u32 pg_size)
 {
-       struct scatterlist *sg;
+       struct sg_dma_page_iter sg_iter;
        bool is_umem = false;
        int i;

@@ -116,12 +116,13 @@ static int __alloc_pbl(struct pci_dev *pdev, struct bnxt_qplib_pbl *pbl,
        } else {
                i = 0;
                is_umem = true;
-               for_each_sg(sghead, sg, pages, i) {
-                       pbl->pg_map_arr[i] = sg_dma_address(sg);
-                       pbl->pg_arr[i] = sg_virt(sg);
+               for_each_sg_dma_page(sghead, &sg_iter, pages, 0) {
+                       pbl->pg_map_arr[i] = sg_page_iter_dma_address(&sg_iter);
+                       pbl->pg_arr[i] = page_address(sg_page_iter_page(&sg_iter.base)); ???
					^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

                        if (!pbl->pg_arr[i])
                                goto fail;

+                       i++;
                        pbl->pg_count++;
                }
        }
--

@@ -191,16 +190,16 @@ int rxe_mem_init_user(struct rxe_pd *pd, u64 start,
                goto err1;
        }

-       mem->page_shift         = umem->page_shift;
-       mem->page_mask          = BIT(umem->page_shift) - 1;
+       mem->page_shift         = PAGE_SHIFT;
+       mem->page_mask          = PAGE_SIZE - 1;

        num_buf                 = 0;
        map                     = mem->map;
        if (length > 0) {
                buf = map[0]->buf;

-               for_each_sg(umem->sg_head.sgl, sg, umem->nmap, entry) {
-                       vaddr = page_address(sg_page(sg));
+               for_each_sg_dma_page(umem->sg_head.sgl, &sg_iter, umem->nmap, 0) {
+                       vaddr = page_address(sg_page_iter_page(&sg_iter.base));   ?????
				^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


                        if (!vaddr) {
                                pr_warn("null vaddr\n");
                                err = -ENOMEM;
@@ -208,7 +207,7 @@ int rxe_mem_init_user(struct rxe_pd *pd, u64 start,
                        }

                        buf->addr = (uintptr_t)vaddr;
-                       buf->size = BIT(umem->page_shift);
+                       buf->size = PAGE_SIZE;

1.8.3.1
