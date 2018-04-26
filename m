Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:58940 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753403AbeDZJYY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Apr 2018 05:24:24 -0400
Date: Thu, 26 Apr 2018 02:24:22 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Russell King - ARM Linux <linux@armlinux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK"
        <linaro-mm-sig@lists.linaro.org>,
        Jerome Glisse <jglisse@redhat.com>,
        iommu@lists.linux-foundation.org,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Thierry Reding <treding@nvidia.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK"
        <linux-media@vger.kernel.org>
Subject: Re: [Linaro-mm-sig] noveau vs arm dma ops
Message-ID: <20180426092422.GA26825@infradead.org>
References: <20180425054855.GA17038@infradead.org>
 <CAKMK7uEFitkNQrD6cLX5Txe11XhVO=LC4YKJXH=VNdq+CY=DjQ@mail.gmail.com>
 <CAKMK7uFx=KB1vup=WhPCyfUFairKQcRR4BEd7aXaX1Pj-vj3Cw@mail.gmail.com>
 <20180425064335.GB28100@infradead.org>
 <20180425074151.GA2271@ulmo>
 <20180425085439.GA29996@infradead.org>
 <20180425100429.GR25142@phenom.ffwll.local>
 <20180425153312.GD27076@infradead.org>
 <20180425225443.GQ16141@n2100.armlinux.org.uk>
 <CAKMK7uG9R6paoP4BmvqDVUP_4Db4Dz8MSXeLwUBMYaORa5-kVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uG9R6paoP4BmvqDVUP_4Db4Dz8MSXeLwUBMYaORa5-kVw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 26, 2018 at 11:20:44AM +0200, Daniel Vetter wrote:
> The above is already what we're implementing in i915, at least
> conceptually (it all boils down to clflush instructions because those
> both invalidate and flush).

The clwb instruction that just writes back dirty cache lines might
be very interesting for the x86 non-coherent dma case.  A lot of
architectures use their equivalent to prepare to to device transfers.

> One architectural guarantee we're exploiting is that prefetched (and
> hence non-dirty) cachelines will never get written back, but dropped
> instead.

And to make this work you'll need exactly this guarantee.
