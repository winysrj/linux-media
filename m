Return-Path: <SRS0=IHIA=PY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDEFCC43387
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 16:11:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5753205C9
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 16:11:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405240AbfAPQLh (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 16 Jan 2019 11:11:37 -0500
Received: from verein.lst.de ([213.95.11.211]:60328 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405272AbfAPQLg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Jan 2019 11:11:36 -0500
Received: by newverein.lst.de (Postfix, from userid 2407)
        id 01C9368CEB; Wed, 16 Jan 2019 17:11:35 +0100 (CET)
Date:   Wed, 16 Jan 2019 17:11:34 +0100
From:   "hch@lst.de" <hch@lst.de>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Thomas Hellstrom <thellstrom@vmware.com>,
        "hch@lst.de" <hch@lst.de>,
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
Message-ID: <20190116161134.GA29041@lst.de>
References: <20190104223531.GA1705@ziepe.ca> <20190110234218.GM6890@ziepe.ca> <20190114094856.GB29604@lst.de> <1fb20ab4b171b281e9994b6c55734c120958530b.camel@vmware.com> <20190115212501.GE22045@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190115212501.GE22045@ziepe.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, Jan 15, 2019 at 02:25:01PM -0700, Jason Gunthorpe wrote:
> RDMA needs something similar as well, in this case drivers take a
> struct page * from get_user_pages() and need to have the DMA map fail
> if the platform can't DMA map in a way that does not require any
> additional DMA API calls to ensure coherence. (think Userspace RDMA
> MR's)

Any time you dma map pages you need to do further DMA API calls to
ensure coherent, that is the way it is implemented.  These calls
just happen to be no-ops sometimes.

> Today we just do the normal DMA map and when it randomly doesn't work
> and corrupts data tell those people their platforms don't support RDMA
> - it would be nice to have a safer API base solution..

Now that all these drivers are consolidated in rdma-core you can fix
the code to actually do the right thing.  It isn't that userspace DMA
coherent is any harder than in-kernel DMA coherenence.  It just is
that no one bothered to do it properly.
