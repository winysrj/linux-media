Return-Path: <SRS0=IHIA=PY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06813C43387
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 17:24:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9E9820578
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 17:24:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="pYcm+5gD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391300AbfAPRYj (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 16 Jan 2019 12:24:39 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:44384 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728828AbfAPRYj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Jan 2019 12:24:39 -0500
Received: by mail-pf1-f196.google.com with SMTP id u6so3360952pfh.11
        for <linux-media@vger.kernel.org>; Wed, 16 Jan 2019 09:24:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=53gplsLprQpA+D4at2sEDjQat4FsTNpx+lEgkZg6Hko=;
        b=pYcm+5gDO//dME8UYshYttaRSQbppOmTnxOtK3irYkbYq4HF6N30GVBGvACX8uQzm3
         RRCF9H+Ix0roK7DxoD+3LgYpWl2+9L1IWt65bd1SkiWZcVKWXh3OL7O2EndEq5i/REmn
         h2/QZ/jQDFgafaNFt24hb7+X5JxAuiE0EQl0fn9VvS3zSNtnVytUUGxlq/JXYejZNsgf
         1hVjv7D2CdU6NMoKss7DdBP5iHevRZpzl36NrPC5H8mKwNcsgbz+GK6y2fGMZMpch9Dd
         KL8jBL8auVJQR4Ome4TP/NB810uOMkM4K9SnOO5BKhK5ChjivI3rWhg80733Xf31tcQO
         5dnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=53gplsLprQpA+D4at2sEDjQat4FsTNpx+lEgkZg6Hko=;
        b=MLxrvcR51f+J4yxLVTVr7DADhrdMc8mdtHyrFBC5VYjjOsKH2W1U4gOFzie+IY69wa
         1/Kg2+voxxt+zeL+ZDmrPHE0eCLwkStBGlcalzDiufUAg9BNJt3Jz3+iIzHK8c13QFXM
         070Zd+W/o5WGgKjIu8TjupoddB8Yzryre7cKRQuhYRztaPMUrUYgUF4Qdu0mnfYJH1jX
         HeFUmJcK9/Iva0Dv3Rzyb95+WH9sbAnMVCiD8pV4JhM2w7MoMRyA8VLTLfHmqSmN6kK9
         x6/NOtJ0y6oNNKO6At9UH5bO+feORYQYXGvF6ST8O6nkympdQ2o3s+BVWEpjmJzcAY7v
         C6VQ==
X-Gm-Message-State: AJcUukfJLRGop316R2HLIW+N0Y8ToMxO17JveF6dhR6W5QzNtiF8HRah
        9lNoLlrNVXDh7ZKZIAr8Kr3Ehw==
X-Google-Smtp-Source: ALg8bN7FMHzRduq1WQKGloDGGfpV0q+BO/y29rrincS29v3s3lJCeS4w3qV23j3XpJbe01pcWPcZ4w==
X-Received: by 2002:a62:1b50:: with SMTP id b77mr10920234pfb.36.1547659477846;
        Wed, 16 Jan 2019 09:24:37 -0800 (PST)
Received: from ziepe.ca (S010614cc2056d97f.ed.shawcable.net. [174.3.196.123])
        by smtp.gmail.com with ESMTPSA id e23sm9459511pfh.68.2019.01.16.09.24.36
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 16 Jan 2019 09:24:36 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1gjovc-0001KE-2A; Wed, 16 Jan 2019 10:24:36 -0700
Date:   Wed, 16 Jan 2019 10:24:36 -0700
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     "hch@lst.de" <hch@lst.de>
Cc:     Thomas Hellstrom <thellstrom@vmware.com>,
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
Message-ID: <20190116172436.GM22045@ziepe.ca>
References: <20190104223531.GA1705@ziepe.ca>
 <20190110234218.GM6890@ziepe.ca>
 <20190114094856.GB29604@lst.de>
 <1fb20ab4b171b281e9994b6c55734c120958530b.camel@vmware.com>
 <20190115212501.GE22045@ziepe.ca>
 <20190116161134.GA29041@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190116161134.GA29041@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Wed, Jan 16, 2019 at 05:11:34PM +0100, hch@lst.de wrote:
> On Tue, Jan 15, 2019 at 02:25:01PM -0700, Jason Gunthorpe wrote:
> > RDMA needs something similar as well, in this case drivers take a
> > struct page * from get_user_pages() and need to have the DMA map fail
> > if the platform can't DMA map in a way that does not require any
> > additional DMA API calls to ensure coherence. (think Userspace RDMA
> > MR's)
> 
> Any time you dma map pages you need to do further DMA API calls to
> ensure coherent, that is the way it is implemented.  These calls
> just happen to be no-ops sometimes.
> 
> > Today we just do the normal DMA map and when it randomly doesn't work
> > and corrupts data tell those people their platforms don't support RDMA
> > - it would be nice to have a safer API base solution..
> 
> Now that all these drivers are consolidated in rdma-core you can fix
> the code to actually do the right thing.  It isn't that userspace DMA
> coherent is any harder than in-kernel DMA coherenence.  It just is
> that no one bothered to do it properly.

If I recall we actually can't.. libverbs presents an API to the user
that does not consider this possibility. 

ie consider post_recv - the driver has no idea what user buffers
received data and can't possibly flush them transparently. The user
would have to call some special DMA syncing API, which we don't have.

It is the same reason the kernel API makes the ULP handle dma sync,
not the driver.

The fact is there is 0 industry interest in using RDMA on platforms
that can't do HW DMA cache coherency - the kernel syscalls required to
do the cache flushing on the IO path would just destroy performance to
the point of making RDMA pointless. Better to use netdev on those
platforms.

VFIO is in a similar boat. Their user API can't handle cache syncing
either, so they would use the same API too.

.. and the GPU-compute systems (ie OpenCL/CUDA) are like verbs, they
were never designed with incoherent DMA in mind, and don't have the
API design to support it.

The reality is that *all* the subsytems doing DMA kernel bypass are
ignoring the DMA mapping rules, I think we should support this better,
and just accept that user space DMA will not be using syncing. Block
access in cases when this is required, otherwise let it work as is
today.

Jason
