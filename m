Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA0E7C43387
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 18:31:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7943620859
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 18:31:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729331AbfAOSbf (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 15 Jan 2019 13:31:35 -0500
Received: from verein.lst.de ([213.95.11.211]:54742 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727088AbfAOSbf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Jan 2019 13:31:35 -0500
Received: by newverein.lst.de (Postfix, from userid 2407)
        id 3C74667358; Tue, 15 Jan 2019 19:31:33 +0100 (CET)
Date:   Tue, 15 Jan 2019 19:31:33 +0100
From:   "hch@lst.de" <hch@lst.de>
To:     Thomas Hellstrom <thellstrom@vmware.com>
Cc:     "hch@lst.de" <hch@lst.de>,
        "christian.koenig@amd.com" <christian.koenig@amd.com>,
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
Message-ID: <20190115183133.GA12350@lst.de>
References: <20190104223531.GA1705@ziepe.ca> <20190110234218.GM6890@ziepe.ca> <20190114094856.GB29604@lst.de> <1fb20ab4b171b281e9994b6c55734c120958530b.camel@vmware.com> <2b440a3b-ed2f-8fd6-a21e-97ca0b2f5db9@gmail.com> <20190115152029.GB2325@lst.de> <41d0616e95fb48942404fb54d82249f5700affb1.camel@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <41d0616e95fb48942404fb54d82249f5700affb1.camel@vmware.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, Jan 15, 2019 at 06:03:39PM +0000, Thomas Hellstrom wrote:
> In the graphics case, it's probably because it doesn't fit the graphics
> use-cases:
> 
> 1) Memory typically needs to be mappable by another device. (the "dma-
> buf" interface)

And there is nothing preventing dma-buf sharing of these buffers.
Unlike the get_sgtable mess it can actually work reliably on
architectures that have virtually tagged caches and/or don't
guarantee cache coherency with mixed attribute mappings.

> 2) DMA buffers are exported to user-space and is sub-allocated by it.
> Mostly there are no GPU user-space kernel interfaces to sync / flush
> subregions and these syncs may happen on a smaller-than-cache-line
> granularity.

I know of no architectures that can do cache maintainance on a less
than cache line basis.  Either the instructions require you to
specifcy cache lines, or they do sometimes more, sometimes less
intelligent rounding up.

Note that as long dma non-coherent buffers are devices owned it
is up to the device and the user space driver to take care of
coherency, the kernel very much is out of the picture.
