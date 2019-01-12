Return-Path: <SRS0=PrKG=PU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E532CC43387
	for <linux-media@archiver.kernel.org>; Sat, 12 Jan 2019 18:27:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C282E2084C
	for <linux-media@archiver.kernel.org>; Sat, 12 Jan 2019 18:27:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbfALS1N (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 12 Jan 2019 13:27:13 -0500
Received: from mga17.intel.com ([192.55.52.151]:63518 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725847AbfALS1M (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 12 Jan 2019 13:27:12 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Jan 2019 10:27:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,470,1539673200"; 
   d="scan'208";a="137709199"
Received: from ssaleem-mobl4.amr.corp.intel.com (HELO ssaleem-mobl1) ([10.254.44.111])
  by fmsmga001.fm.intel.com with SMTP; 12 Jan 2019 10:27:10 -0800
Received: by ssaleem-mobl1 (sSMTP sendmail emulation); Sat, 12 Jan 2019 12:27:06 -0600
Date:   Sat, 12 Jan 2019 12:27:05 -0600
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
Message-ID: <20190112182704.GA15320@ssaleem-MOBL4.amr.corp.intel.com>
References: <20190104223531.GA1705@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190104223531.GA1705@ziepe.ca>
User-Agent: Mutt/1.7.2 (2016-11-26)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Fri, Jan 04, 2019 at 10:35:43PM +0000, Jason Gunthorpe wrote:
> Commit 2db76d7c3c6d ("lib/scatterlist: sg_page_iter: support sg lists w/o
> backing pages") introduced the sg_page_iter_dma_address() function without
> providing a way to use it in the general case. If the sg_dma_len is not
> equal to the dma_length callers cannot safely use the
> for_each_sg_page/sg_page_iter_dma_address combination.
> 
> Resolve this API mistake by providing a DMA specific iterator,
> for_each_sg_dma_page(), that uses the right length so
> sg_page_iter_dma_address() works as expected with all sglists. A new
> iterator type is introduced to provide compile-time safety against wrongly
> mixing accessors and iterators.
[..]

>  
> +/*
> + * sg page iterator for DMA addresses
> + *
> + * This is the same as sg_page_iter however you can call
> + * sg_page_iter_dma_address(@dma_iter) to get the page's DMA
> + * address. sg_page_iter_page() cannot be called on this iterator.
> + */
Does it make sense to have a variant of sg_page_iter_page() to get the
page descriptor with this dma_iter? This can be used when walking DMA-mapped
SG lists with for_each_sg_dma_page.

> +struct sg_dma_page_iter {
> +	struct sg_page_iter base;
> +};
> +
> 
