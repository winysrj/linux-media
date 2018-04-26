Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:47548 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754781AbeDZJNO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Apr 2018 05:13:14 -0400
Date: Thu, 26 Apr 2018 02:13:10 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>,
        Thierry Reding <treding@nvidia.com>,
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
        <linux-media@vger.kernel.org>, iommu@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: noveau vs arm dma ops
Message-ID: <20180426091310.GB18811@infradead.org>
References: <CAKMK7uFL68pu+-9LODTgz+GQYvxpnXOGhxfz9zorJ_JKsPVw2g@mail.gmail.com>
 <20180425054855.GA17038@infradead.org>
 <CAKMK7uEFitkNQrD6cLX5Txe11XhVO=LC4YKJXH=VNdq+CY=DjQ@mail.gmail.com>
 <CAKMK7uFx=KB1vup=WhPCyfUFairKQcRR4BEd7aXaX1Pj-vj3Cw@mail.gmail.com>
 <20180425064335.GB28100@infradead.org>
 <20180425074151.GA2271@ulmo>
 <20180425085439.GA29996@infradead.org>
 <20180425100429.GR25142@phenom.ffwll.local>
 <20180425153312.GD27076@infradead.org>
 <20180425225443.GQ16141@n2100.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180425225443.GQ16141@n2100.armlinux.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 25, 2018 at 11:54:43PM +0100, Russell King - ARM Linux wrote:
> 
> if the memory was previously dirty (iow, CPU has written), you need to
> flush the dirty cache lines _before_ the GPU writes happen, but you
> don't know whether the CPU has speculatively prefetched, so you need
> to flush any prefetched cache lines before reading from the cacheable
> memory _after_ the GPU has finished writing.
> 
> Also note that "flush" there can be "clean the cache", "clean and
> invalidate the cache" or "invalidate the cache" as appropriate - some
> CPUs are able to perform those three operations, and the appropriate
> one depends on not only where in the above sequence it's being used,
> but also on what the operations are.

Agreed on all these counts.

> If we can agree a set of interfaces that allows _proper_ use of these
> facilities, one which can be used appropriately, then there shouldn't
> be a problem.  The DMA API does that via it's ideas about who owns a
> particular buffer (because of the above problem) and that's something
> which would need to be carried over to such a cache flushing API (it
> should be pretty obvious that having a GPU read or write memory while
> the cache for that memory is being cleaned will lead to unexpected
> results.)

I've been trying to come up with such an interface, for now only for
internal use in a generic set of noncoherent ops.  The API is basically
a variant of the existing dma_sync_single_to_device/cpu calls:

http://git.infradead.org/users/hch/misc.git/commitdiff/044dae5f94509288f4655de2f22cb0bea85778af

Review welcome!

> The next issue, which I've brought up before, is that exposing cache
> flushing to userspace on architectures where it isn't already exposed
> comes.  As has been shown by Google Project Zero, this risks exposing
> those architectures to Spectre and Meltdown exploits where they weren't
> at such a risk before.  (I've pretty much shown here that you _do_
> need to control which cache lines get flushed to make these exploits
> work, and flushing the cache by reading lots of data in liu of having
> the ability to explicitly flush bits of cache makes it very difficult
> to impossible for them to work.)

Extending dma coherence to userspace is going to be the next major
nightmare indeed.  I'm not sure how much of that actually still is
going on in the graphics world, but we'll need a coherent (pun intended)
plan how to deal with it.
