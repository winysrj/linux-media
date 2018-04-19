Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:59916 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750972AbeDSIRD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Apr 2018 04:17:03 -0400
Date: Thu, 19 Apr 2018 01:16:57 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Christoph Hellwig <hch@infradead.org>,
        Jerome Glisse <jglisse@redhat.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK"
        <linaro-mm-sig@lists.linaro.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK"
        <linux-media@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Logan Gunthorpe <logang@deltatee.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 4/8] dma-buf: add peer2peer flag
Message-ID: <20180419081657.GA16735@infradead.org>
References: <20180325110000.2238-1-christian.koenig@amd.com>
 <20180325110000.2238-4-christian.koenig@amd.com>
 <20180329065753.GD3881@phenom.ffwll.local>
 <8b823458-8bdc-3217-572b-509a28aae742@gmail.com>
 <20180403090909.GN3881@phenom.ffwll.local>
 <20180403170645.GB5935@redhat.com>
 <20180403180832.GZ3881@phenom.ffwll.local>
 <20180416123937.GA9073@infradead.org>
 <CAKMK7uEFVOh-R2_4vs1M22_wDau0oNTgmCcTWDE+ScxL=92+2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uEFVOh-R2_4vs1M22_wDau0oNTgmCcTWDE+ScxL=92+2g@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 16, 2018 at 03:38:56PM +0200, Daniel Vetter wrote:
> We've broken that assumption in i915 years ago. Not struct page backed
> gpu memory is very real.
> 
> Of course we'll never feed such a strange sg table to a driver which
> doesn't understand it, but allowing sg_page == NULL works perfectly
> fine. At least for gpu drivers.

For GPU drivers on x86 with no dma coherency problems, sure.  But not
all the world is x86.  We already have problems due to dmabugs use
of the awkward get_sgtable interface (see the common on
arm_dma_get_sgtable that I fully agree with), and doing this for memory
that doesn't have a struct page at all will make things even worse.

> If that's not acceptable then I guess we could go over the entire tree
> and frob all the gpu related code to switch over to a new struct
> sg_table_might_not_be_struct_page_backed, including all the other
> functions we added over the past few years to iterate over sg tables.
> But seems slightly silly, given that sg tables seem to do exactly what
> we need.

It isn't silly.  We will have to do some surgery like that anyway
because the current APIs don't work.  So relax, sit back and come up
with an API that solves the existing issues and serves us well in
the future.
