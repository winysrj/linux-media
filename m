Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04792C43387
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 20:58:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C64A520657
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 20:58:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390072AbfAOU6E (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 15 Jan 2019 15:58:04 -0500
Received: from verein.lst.de ([213.95.11.211]:55467 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730050AbfAOU6E (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Jan 2019 15:58:04 -0500
Received: by newverein.lst.de (Postfix, from userid 2407)
        id A098467358; Tue, 15 Jan 2019 21:58:01 +0100 (CET)
Date:   Tue, 15 Jan 2019 21:58:01 +0100
From:   "hch@lst.de" <hch@lst.de>
To:     "Koenig, Christian" <Christian.Koenig@amd.com>
Cc:     "hch@lst.de" <hch@lst.de>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yong.zhi@intel.com" <yong.zhi@intel.com>,
        "daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "bingbu.cao@intel.com" <bingbu.cao@intel.com>,
        "jian.xu.zheng@intel.com" <jian.xu.zheng@intel.com>,
        "tian.shu.qiu@intel.com" <tian.shu.qiu@intel.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>
Subject: Re: [PATCH] lib/scatterlist: Provide a DMA page iterator
Message-ID: <20190115205801.GA15432@lst.de>
References: <20190104223531.GA1705@ziepe.ca> <20190110234218.GM6890@ziepe.ca> <20190114094856.GB29604@lst.de> <1fb20ab4b171b281e9994b6c55734c120958530b.camel@vmware.com> <2b440a3b-ed2f-8fd6-a21e-97ca0b2f5db9@gmail.com> <20190115152029.GB2325@lst.de> <41d0616e95fb48942404fb54d82249f5700affb1.camel@vmware.com> <20190115183133.GA12350@lst.de> <c82076aa-a6ee-5ba2-a8d8-935fdbb7d5ca@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c82076aa-a6ee-5ba2-a8d8-935fdbb7d5ca@amd.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, Jan 15, 2019 at 07:13:11PM +0000, Koenig, Christian wrote:
> Thomas is correct that the interface you propose here doesn't work at 
> all for GPUs.
> 
> The kernel driver is not informed of flush/sync, but rather just setups 
> coherent mappings between system memory and devices.
> 
> In other words you have an array of struct pages and need to map that to 
> a specific device and so create dma_addresses for the mappings.

If you want a coherent mapping you need to use dma_alloc_coherent
and dma_mmap_coherent and you are done, that is not the problem.
That actually is one of the vmgfx modes, so I don't understand what
problem we are trying to solve if you don't actually want a non-coherent
mapping.  Although last time I had that discussion with Daniel Vetter
I was under the impressions that GPUs really wanted non-coherent
mappings.

But if you want a coherent mapping you can't go to a struct page,
because on many systems you can't just map arbitrary memory as
uncachable.  It might either come from very special limited pools,
or might need other magic applied to it so that it is not visible
in the normal direct mapping, or at least not access through it.
