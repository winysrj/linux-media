Return-Path: <SRS0=I7H+=PZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21DBFC43387
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 09:30:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6CE820851
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 09:30:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728674AbfAQJaE (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 17 Jan 2019 04:30:04 -0500
Received: from verein.lst.de ([213.95.11.211]:36339 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727194AbfAQJaD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Jan 2019 04:30:03 -0500
Received: by newverein.lst.de (Postfix, from userid 2407)
        id 2C7566F9C5; Thu, 17 Jan 2019 10:30:02 +0100 (CET)
Date:   Thu, 17 Jan 2019 10:30:01 +0100
From:   "hch@lst.de" <hch@lst.de>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     "hch@lst.de" <hch@lst.de>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yong.zhi@intel.com" <yong.zhi@intel.com>,
        "daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "syeh@vmware.com" <syeh@vmware.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "bingbu.cao@intel.com" <bingbu.cao@intel.com>,
        "imre.deak@intel.com" <imre.deak@intel.com>,
        "tian.shu.qiu@intel.com" <tian.shu.qiu@intel.com>,
        "jian.xu.zheng@intel.com" <jian.xu.zheng@intel.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH] lib/scatterlist: Provide a DMA page iterator
Message-ID: <20190117093001.GB31303@lst.de>
References: <20190104223531.GA1705@ziepe.ca> <20190110234218.GM6890@ziepe.ca> <20190114094856.GB29604@lst.de> <1fb20ab4b171b281e9994b6c55734c120958530b.camel@vmware.com> <20190115212501.GE22045@ziepe.ca> <20190116161134.GA29041@lst.de> <20190116172436.GM22045@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190116172436.GM22045@ziepe.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Wed, Jan 16, 2019 at 10:24:36AM -0700, Jason Gunthorpe wrote:
> The fact is there is 0 industry interest in using RDMA on platforms
> that can't do HW DMA cache coherency - the kernel syscalls required to
> do the cache flushing on the IO path would just destroy performance to
> the point of making RDMA pointless. Better to use netdev on those
> platforms.

In general there is no syscall required for doing cache flushing, you
just issue the proper instructions directly from userspace. 

> The reality is that *all* the subsytems doing DMA kernel bypass are
> ignoring the DMA mapping rules, I think we should support this better,
> and just accept that user space DMA will not be using syncing. Block
> access in cases when this is required, otherwise let it work as is
> today.

In that case we just need to block userspace DMA access entirely.
Which given the amount of problems it creates sounds like a pretty
good idea anyway.
