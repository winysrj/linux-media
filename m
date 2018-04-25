Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:51198 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750882AbeDYGnh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Apr 2018 02:43:37 -0400
Date: Tue, 24 Apr 2018 23:43:35 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Christoph Hellwig <hch@infradead.org>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK"
        <linaro-mm-sig@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        Jerome Glisse <jglisse@redhat.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        "open list:DMA BUFFER SHARING FRAMEWORK"
        <linux-media@vger.kernel.org>, Thierry Reding <treding@nvidia.com>
Subject: Re: [Linaro-mm-sig] [PATCH 4/8] dma-buf: add peer2peer flag
Message-ID: <20180425064335.GB28100@infradead.org>
References: <3e17afc5-7d6c-5795-07bd-f23e34cf8d4b@gmail.com>
 <20180420101755.GA11400@infradead.org>
 <f1100bd6-dd98-55a9-a92f-1cad919f235f@amd.com>
 <20180420124625.GA31078@infradead.org>
 <20180420152111.GR31310@phenom.ffwll.local>
 <20180424184847.GA3247@infradead.org>
 <CAKMK7uFL68pu+-9LODTgz+GQYvxpnXOGhxfz9zorJ_JKsPVw2g@mail.gmail.com>
 <20180425054855.GA17038@infradead.org>
 <CAKMK7uEFitkNQrD6cLX5Txe11XhVO=LC4YKJXH=VNdq+CY=DjQ@mail.gmail.com>
 <CAKMK7uFx=KB1vup=WhPCyfUFairKQcRR4BEd7aXaX1Pj-vj3Cw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uFx=KB1vup=WhPCyfUFairKQcRR4BEd7aXaX1Pj-vj3Cw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 25, 2018 at 08:23:15AM +0200, Daniel Vetter wrote:
> For more fun:
> 
> https://www.spinics.net/lists/dri-devel/msg173630.html
> 
> Yeah, sometimes we want to disable the iommu because the on-gpu
> pagetables are faster ...

I am not on this list, but remote NAK from here.  This needs an
API from the iommu/dma-mapping code.  Drivers have no business poking
into these details.

Thierry, please resend this with at least the iommu list and
linux-arm-kernel in Cc to have a proper discussion on the right API.
