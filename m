Return-Path: <SRS0=IHIA=PY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56D8CC43387
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 10:14:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1CAA720840
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 10:14:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=ffwll.ch header.i=@ffwll.ch header.b="VxRliN+b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389401AbfAPKOq (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 16 Jan 2019 05:14:46 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:46375 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389393AbfAPKOq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Jan 2019 05:14:46 -0500
Received: by mail-ed1-f67.google.com with SMTP id o10so4914005edt.13
        for <linux-media@vger.kernel.org>; Wed, 16 Jan 2019 02:14:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=sender:date:from:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=Xm7lOdagTUXWoApQjAoLmUIdhJ9/+q+p1K8q4ZJihQ8=;
        b=VxRliN+b9E3BT9RqERr2ukFR4ZI4YtP/vqqB84wtUBbRdAYQuFBrf+e9UVWZt/Q+o4
         0N0uG+K69dmgWuDpw3zDcN+K+1cjVMbSyplP0GTurO3HATg9MBoHOus8zTE/zqPvvjah
         +1zmiujDtCOtM01TqtJbkw3+CJiAZxjf6UkQU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=Xm7lOdagTUXWoApQjAoLmUIdhJ9/+q+p1K8q4ZJihQ8=;
        b=kWhZ6J3TWd8wSxqNTobR+tDjaRyEKFpQFOApG2+ngNryHJvTkVUd6tTs6RlxI6As/f
         XFQp6V1DK3HvjtbhbTRtSCl5etV5Y1W+RERVVPdZ73Jo+cE3MLDOmwVYp9JJb38+NIKR
         RScwMji5VC1ZmJsQ2koS1vr6jY0s1iW4hy3p0ZYgCcm8GfvJJlsHYlWaaiTVV0QkIp4a
         ZPYgnMLrBxoYsUad3K/4SRi75SQ0IzZeFR8NDiyD9+6oWphXgDuRIcrmmWLT7PbxQM/9
         cTY3lIN+LZDf4K7kehP0fiptnz4wqKeHgIQ55cVN74hvw6Mo7vS+Umt1zKsG4mvkLRYF
         EXtA==
X-Gm-Message-State: AJcUukdQHBbKvSWQ/LPRBd9xDR8PWHxNZIm1xxGIEPHj5rnOt2+Jy/5s
        O3KPNUYz4g24XviIjFupW3GxOQ==
X-Google-Smtp-Source: ALg8bN4itZZdI9JsmXYz9fwzYgNBC4Lbicat1rbUn2pDz0dBEv28JL1BZF7TRQuVyU2Ntj1cUzWjIg==
X-Received: by 2002:a17:906:3712:: with SMTP id d18-v6mr6445225ejc.126.1547633683976;
        Wed, 16 Jan 2019 02:14:43 -0800 (PST)
Received: from phenom.ffwll.local ([2a02:168:569e:0:3106:d637:d723:e855])
        by smtp.gmail.com with ESMTPSA id v11sm5356616edy.49.2019.01.16.02.14.42
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 16 Jan 2019 02:14:42 -0800 (PST)
Date:   Wed, 16 Jan 2019 11:14:40 +0100
From:   Daniel Vetter <daniel@ffwll.ch>
To:     "Koenig, Christian" <Christian.Koenig@amd.com>
Cc:     Thomas Hellstrom <thellstrom@vmware.com>,
        "hch@lst.de" <hch@lst.de>,
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
Message-ID: <20190116101440.GR10517@phenom.ffwll.local>
Mail-Followup-To: "Koenig, Christian" <Christian.Koenig@amd.com>,
        Thomas Hellstrom <thellstrom@vmware.com>, "hch@lst.de" <hch@lst.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yong.zhi@intel.com" <yong.zhi@intel.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "bingbu.cao@intel.com" <bingbu.cao@intel.com>,
        "jian.xu.zheng@intel.com" <jian.xu.zheng@intel.com>,
        "tian.shu.qiu@intel.com" <tian.shu.qiu@intel.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>
References: <20190114094856.GB29604@lst.de>
 <1fb20ab4b171b281e9994b6c55734c120958530b.camel@vmware.com>
 <2b440a3b-ed2f-8fd6-a21e-97ca0b2f5db9@gmail.com>
 <20190115152029.GB2325@lst.de>
 <41d0616e95fb48942404fb54d82249f5700affb1.camel@vmware.com>
 <20190115183133.GA12350@lst.de>
 <c82076aa-a6ee-5ba2-a8d8-935fdbb7d5ca@amd.com>
 <20190115205801.GA15432@lst.de>
 <01e5522bf88549bfdaea1430fece23cb3d1a1a55.camel@vmware.com>
 <8aadac80-da9b-b52a-a4bf-066406127117@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8aadac80-da9b-b52a-a4bf-066406127117@amd.com>
X-Operating-System: Linux phenom 4.19.0-1-amd64 
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Wed, Jan 16, 2019 at 07:28:13AM +0000, Koenig, Christian wrote:
> Am 16.01.19 um 08:09 schrieb Thomas Hellstrom:
> > On Tue, 2019-01-15 at 21:58 +0100, hch@lst.de wrote:
> >> On Tue, Jan 15, 2019 at 07:13:11PM +0000, Koenig, Christian wrote:
> >>> Thomas is correct that the interface you propose here doesn't work
> >>> at
> >>> all for GPUs.
> >>>
> >>> The kernel driver is not informed of flush/sync, but rather just
> >>> setups
> >>> coherent mappings between system memory and devices.
> >>>
> >>> In other words you have an array of struct pages and need to map
> >>> that to
> >>> a specific device and so create dma_addresses for the mappings.
> >> If you want a coherent mapping you need to use dma_alloc_coherent
> >> and dma_mmap_coherent and you are done, that is not the problem.
> >> That actually is one of the vmgfx modes, so I don't understand what
> >> problem we are trying to solve if you don't actually want a non-
> >> coherent mapping.
> > For vmwgfx, not making dma_alloc_coherent default has a couple of
> > reasons:
> > 1) Memory is associated with a struct device. It has not been clear
> > that it is exportable to other devices.
> > 2) There seems to be restrictions in the system pages allowable. GPUs
> > generally prefer highmem pages but dma_alloc_coherent returns a virtual
> > address implying GFP_KERNEL? While not used by vmwgfx, TTM typically
> > prefers HIGHMEM pages to facilitate caching mode switching without
> > having to touch the kernel map.
> > 3) Historically we had APIs to allow coherent access to user-space
> > defined pages. That has gone away not but the infrastructure was built
> > around it.
> >
> > dma_mmap_coherent isn't use because as the data moves between system
> > memory, swap and VRAM, PTEs of user-space mappings are adjusted
> > accordingly, meaning user-space doesn't have to unmap when an operation
> > is initiated that might mean the data is moved.
> 
> To summarize once more: We have an array of struct pages and want to 
> coherently map that to a device.
> 
> If that is not possible because of whatever reason we want to get an 
> error code or even not load the driver from the beginning.

I guess to make this work we'd also need information about how we're
allowed to mmap this on the cpu side, both from the kernel (kmap or vmap)
and for userspace. At least for i915 we use all kinds of combinations,
e.g. cpu mmap ptes as cached w/ coherent device transactions, or
cached+clflush on the cpu side, and non-coherent device transactions (the
no-snoop thing), or wc mode in the cpu ptes and non-coherent device
transactions-

Plus some debug mode so we catch abuse, because reality is that most of
the gpu driver work happens on x86, where all of this just works. Even if
you do some really serious layering violations (which is why this isn't
that high a priority for gpu folks).
-Daniel

> 
> >
> >
> >> Although last time I had that discussion with Daniel Vetter
> >> I was under the impressions that GPUs really wanted non-coherent
> >> mappings.
> > Intel historically has done things a bit differently. And it's also
> > possible that embedded platforms and ARM prefer this mode of operation,
> > but I haven't caught up on that discussion.
> >
> >> But if you want a coherent mapping you can't go to a struct page,
> >> because on many systems you can't just map arbitrary memory as
> >> uncachable.  It might either come from very special limited pools,
> >> or might need other magic applied to it so that it is not visible
> >> in the normal direct mapping, or at least not access through it.
> >
> > The TTM subsystem has been relied on to provide coherent memory with
> > the option to switch caching mode of pages. But only on selected and
> > well tested platforms. On other platforms we simply do not load, and
> > that's fine for now.
> >
> > But as mentioned multiple times, to make GPU drivers more compliant,
> > we'd really want that
> >
> > bool dma_streaming_is_coherent(const struct device *)
> >
> > API to help us decide when to load or not.
> 
> Yes, please.
> 
> Christian.
> 
> >
> > Thanks,
> > Thomas
> >
> >
> >
> >
> >
> >
> >
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
