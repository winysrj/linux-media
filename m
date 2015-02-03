Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:45307 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725AbbBCOhY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Feb 2015 09:37:24 -0500
Date: Tue, 3 Feb 2015 14:37:15 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Rob Clark <robdclark@gmail.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	DRI mailing list <dri-devel@lists.freedesktop.org>,
	Linaro MM SIG Mailman List <linaro-mm-sig@lists.linaro.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	Linaro Kernel Mailman List <linaro-kernel@lists.linaro.org>,
	Tomasz Stanislawski <stanislawski.tomasz@googlemail.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [RFCv3 2/2] dma-buf: add helpers for sharing attacher
 constraints with dma-parms
Message-ID: <20150203143715.GQ8656@n2100.arm.linux.org.uk>
References: <20150129143908.GA26493@n2100.arm.linux.org.uk>
 <CAO_48GEOQ1pBwirgEWeVVXW-iOmaC=Xerr2VyYYz9t1QDXgVsw@mail.gmail.com>
 <20150129154718.GB26493@n2100.arm.linux.org.uk>
 <CAF6AEGtTmFg66TK_AFkQ-xp7Nd9Evk3nqe6xCBp7K=77OmXTxA@mail.gmail.com>
 <20150129192610.GE26493@n2100.arm.linux.org.uk>
 <CAF6AEGujk8UC4X6T=yhTrz1s+SyZUQ=m05h_WcxLDGZU6bydbw@mail.gmail.com>
 <20150202165405.GX14009@phenom.ffwll.local>
 <CAF6AEGuESM+e3HSRGM6zLqrp8kqRLGUYvA3KKECdm7m-nt0M=Q@mail.gmail.com>
 <20150203074856.GF14009@phenom.ffwll.local>
 <CAF6AEGu0-TgyE4BjiaSWXQCSk31VU7dogq=6xDRUhi79rGgbxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF6AEGu0-TgyE4BjiaSWXQCSk31VU7dogq=6xDRUhi79rGgbxg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 03, 2015 at 09:04:03AM -0500, Rob Clark wrote:
> Since I'm stuck w/ an iommu, instead of built in mmu, my plan was to
> drop use of dma-mapping entirely (incl the current call to dma_map_sg,
> which I just need until we can use drm_cflush on arm), and
> attach/detach iommu domains directly to implement context switches.
> At that point, dma_addr_t really has no sensible meaning for me.

So how do you intend to import from a subsystem which only gives you
the dma_addr_t?

If you aren't passing system memory, you have no struct page.  You can't
fake up a struct page.  What this means is that struct scatterlist can't
represent it any other way.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
