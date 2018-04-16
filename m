Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:51800 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753745AbeDPMjj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Apr 2018 08:39:39 -0400
Date: Mon, 16 Apr 2018 05:39:37 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jerome Glisse <jglisse@redhat.com>, christian.koenig@amd.com,
        linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/8] dma-buf: add peer2peer flag
Message-ID: <20180416123937.GA9073@infradead.org>
References: <20180325110000.2238-1-christian.koenig@amd.com>
 <20180325110000.2238-4-christian.koenig@amd.com>
 <20180329065753.GD3881@phenom.ffwll.local>
 <8b823458-8bdc-3217-572b-509a28aae742@gmail.com>
 <20180403090909.GN3881@phenom.ffwll.local>
 <20180403170645.GB5935@redhat.com>
 <20180403180832.GZ3881@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180403180832.GZ3881@phenom.ffwll.local>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 03, 2018 at 08:08:32PM +0200, Daniel Vetter wrote:
> I did not mean you should dma_map_sg/page. I just meant that using
> dma_map_resource to fill only the dma address part of the sg table seems
> perfectly sufficient.

But that is not how the interface work, especially facing sg_dma_len.

> Assuming you get an sg table that's been mapping by calling dma_map_sg was
> always a bit a case of bending the abstraction to avoid typing code. The
> only thing an importer ever should have done is look at the dma addresses
> in that sg table, nothing else.

The scatterlist is not a very good abstraction unfortunately, but it
it is spread all over the kernel.  And we do expect that anyone who
gets passed a scatterlist can use sg_page() or sg_virt() (which calls
sg_page()) on it.  Your changes would break that, and will cause major
trouble because of that.

If you want to expose p2p memory returned from dma_map_resource in
dmabuf do not use scatterlists for this please, but with a new interface
that explicitly passes a virtual address, a dma address and a length
and make it very clear that virt_to_page will not work on the virtual
address.
