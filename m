Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:46942 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbeJaOey (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Oct 2018 10:34:54 -0400
Date: Tue, 30 Oct 2018 22:38:08 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: "Matwey V. Kornilov" <matwey@sai.msu.ru>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        matwey.kornilov@gmail.com, tfiga@chromium.org,
        stern@rowland.harvard.edu, ezequiel@collabora.com,
        hdegoede@redhat.com, hverkuil@xs4all.nl, mchehab@kernel.org,
        rostedt@goodmis.org, mingo@redhat.com, isely@pobox.com,
        bhumirks@gmail.com, colin.king@canonical.com,
        kieran.bingham@ideasonboard.com, keiichiw@chromium.org,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v5 2/2] media: usb: pwc: Don't use coherent DMA buffers
 for ISO transfer
Message-ID: <20181031053808.GB22504@infradead.org>
References: <20180821170629.18408-1-matwey@sai.msu.ru>
 <20180821170629.18408-3-matwey@sai.msu.ru>
 <2213616.rQm4DhIJ7U@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2213616.rQm4DhIJ7U@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 31, 2018 at 12:00:12AM +0200, Laurent Pinchart wrote:
> As discussed before, we're clearly missing a proper non-coherent memory 
> allocation API. As much as I would like to see a volunteer for this, I don't 
> think it's a reason to block the performance improvement we get from this 
> patch.
> 
> This being said, I'm a bit concerned about the allocation of 16kB blocks from 
> kmalloc(), and believe that the priority of the non-coherent memory allocation 
> API implementation should be increased. Christoph, you mentioned in a recent 
> discussion on this topic that you are working on removing the existing non-
> coherent DMA allocation API, what is your opinion on how we should gllobally 
> solve the problem that this patch addresses ?

I hope to address this on the dma-mapping side for this merge window.
My current idea is to add (back) add dma_alloc_noncoherent-like API
(name to be determindes).  This would be very similar to to the
DMA_ATTR_NON_CONSISTENT to dma_alloc_attrs with the following
differences:

 - it must actually be implemented by every dma_map_ops instance, no
   falling back to dma_alloc_coherent like semantics.  For all actually
   coherent ops this is trivial as there is no difference in semantics
   and we can fall back to the 'coherent' semantics, for non-coherent
   direct mappings it also is mostly trivial as we generally can use
   dma_direct_alloc.  The only instances that will need real work are
   IOMMUs that support non-coherent access, but there is only about
   a handfull of those.
 - instead of using the only vaguely defined dma_cache_sync for
   ownership transfers we'll use dma_sync_single_* which are well
   defined and available everywhere

I'll try to prioritise this to get done early in the merge window,
but I'll need someone else do the USB side.

> > +	dma_sync_single_for_cpu(&urb->dev->dev,
> > +				urb->transfer_dma,
> > +				urb->transfer_buffer_length,
> > +				DMA_FROM_DEVICE);
> > +
> 
> As explained before as well, I think we need dma_sync_single_for_device() 
> calls, and I know they would degrade performances until we fix the problem on 
> the DMA mapping API side. This is not a reason to block the patch either. I 
> would appreciate, however, if a comment could be added to the place where 
> dma_sync_single_for_device() should be called, to explain the problem.

Yes, as a rule of thumb every dma_sync_single_for_cpu call needs to pair
with a previous dma_sync_single_for_device call.  (Exceptions like
selective use of DMA_ATTR_SKIP_CPU_SYNC proove the rule)
