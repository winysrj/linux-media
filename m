Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f171.google.com ([209.85.128.171]:39842 "EHLO
        mail-wr0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751089AbeCMPRZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Mar 2018 11:17:25 -0400
Received: by mail-wr0-f171.google.com with SMTP id k3so4373956wrg.6
        for <linux-media@vger.kernel.org>; Tue, 13 Mar 2018 08:17:25 -0700 (PDT)
Date: Tue, 13 Mar 2018 16:17:21 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: christian.koenig@amd.com
Cc: Daniel Vetter <daniel@ffwll.ch>, linaro-mm-sig@lists.linaro.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        amd-gfx@lists.freedesktop.org
Subject: Re: [PATCH 1/4] dma-buf: add optional invalidate_mappings callback
Message-ID: <20180313151721.GH4788@phenom.ffwll.local>
References: <20180309191144.1817-1-christian.koenig@amd.com>
 <20180309191144.1817-2-christian.koenig@amd.com>
 <20180312170710.GL8589@phenom.ffwll.local>
 <f3986703-75de-4ce3-a828-1687291bb618@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f3986703-75de-4ce3-a828-1687291bb618@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 12, 2018 at 08:13:15PM +0100, Christian K??nig wrote:
> Am 12.03.2018 um 18:07 schrieb Daniel Vetter:
> > On Fri, Mar 09, 2018 at 08:11:41PM +0100, Christian K??nig wrote:
> > > [SNIP]
> > > +/**
> > > + * dma_buf_invalidate_mappings - invalidate all mappings of this dma_buf
> > > + *
> > > + * @dmabuf:	[in]	buffer which mappings should be invalidated
> > > + *
> > > + * Informs all attachmenst that they need to destroy and recreated all their
> > > + * mappings.
> > > + */
> > > +void dma_buf_invalidate_mappings(struct dma_buf *dmabuf)
> > > +{
> > > +	struct dma_buf_attachment *attach;
> > > +
> > > +	reservation_object_assert_held(dmabuf->resv);
> > > +
> > > +	list_for_each_entry(attach, &dmabuf->attachments, node)
> > > +		attach->invalidate_mappings(attach);
> > To make the locking work I think we also need to require importers to hold
> > the reservation object while attaching/detaching. Otherwise the list walk
> > above could go boom.
> 
> Oh, good point. Going, to fix this.
> 
> > [SNIP]
> > > +	/**
> > > +	 * @supports_mapping_invalidation:
> > > +	 *
> > > +	 * True for exporters which supports unpinned DMA-buf operation using
> > > +	 * the reservation lock.
> > > +	 *
> > > +	 * When attachment->invalidate_mappings is set the @map_dma_buf and
> > > +	 * @unmap_dma_buf callbacks can be called with the reservation lock
> > > +	 * held.
> > > +	 */
> > > +	bool supports_mapping_invalidation;
> > Why do we need this? Importer could simply always register with the
> > invalidate_mapping hook registered, and exporters could use it when they
> > see fit. That gives us more lockdep coverage to make sure importers use
> > their attachment callbacks correctly (aka they hold the reservation
> > object).
> 
> One sole reason: Backward compability.
> 
> I didn't wanted to audit all those different drivers if they can handle
> being called with the reservation lock held.
> 
> > 
> > > +
> > >   	/**
> > >   	 * @map_dma_buf:
> > >   	 *
> > > @@ -326,6 +338,29 @@ struct dma_buf_attachment {
> > >   	struct device *dev;
> > >   	struct list_head node;
> > >   	void *priv;
> > > +
> > > +	/**
> > > +	 * @invalidate_mappings:
> > > +	 *
> > > +	 * Optional callback provided by the importer of the attachment which
> > > +	 * must be set before mappings are created.
> > This doesn't work, it must be set before the attachment is created,
> > otherwise you race with your invalidate callback.
> 
> Another good point.
> 
> > 
> > I think the simplest option would be to add a new dma_buf_attach_dynamic
> > (well except a less crappy name).
> 
> Well how about adding an optional invalidate_mappings parameter to the
> existing dma_buf_attach?

Not sure that's best, it might confuse dumb importers and you need to
change all the callers. But up to you.

> > > +	 *
> > > +	 * If provided the exporter can avoid pinning the backing store while
> > > +	 * mappings exists.
> > > +	 *
> > > +	 * The function is called with the lock of the reservation object
> > > +	 * associated with the dma_buf held and the mapping function must be
> > > +	 * called with this lock held as well. This makes sure that no mapping
> > > +	 * is created concurrently with an ongoing invalidation.
> > > +	 *
> > > +	 * After the callback all existing mappings are still valid until all
> > > +	 * fences in the dma_bufs reservation object are signaled, but should be
> > > +	 * destroyed by the importer as soon as possible.
> > Do we guarantee that the importer will attach a fence, after which the
> > mapping will be gone? What about re-trying? Or just best effort (i.e. only
> > useful for evicting to try to make room).
> 
> The importer should attach fences for all it's operations with the DMA-buf.
> 
> > I think a helper which both unmaps _and_ waits for all the fences to clear
> > would be best, with some guarantees that it'll either fail or all the
> > mappings _will_ be gone. The locking for that one will be hilarious, since
> > we need to figure out dmabuf->lock vs. the reservation. I kinda prefer we
> > throw away the dmabuf->lock and superseed it entirely by the reservation
> > lock.
> 
> Big NAK on that. The whole API is asynchronously, e.g. we never block for
> any operation to finish.
> 
> Otherwise you run into big trouble with cross device GPU resets and stuff
> like that.

But how will the unmapping work then? You can't throw the sg list away
before the dma stopped. The dma only stops once the fence is signalled.
The importer can't call dma_buf_detach because the reservation lock is
hogged already by the exporter trying to unmap everything.

How is this supposed to work?

Re GPU might cause a deadlock: Isn't that already a problem if you hold
reservations of buffers used on other gpus, which want those reservations
to complete the gpu reset, but that gpu reset blocks some fence that the
reservation holder is waiting for?

We have tons of fun with deadlocks against GPU resets, and loooooots of
testcases, and I kinda get the impression amdgpu is throwing a lot of
issues under the rug through trylock tricks that shut up lockdep, but
don't fix much really.

btw adding cross-release lockdep annotations for fences will probably turn
up _lots_ more bugs in this area.

> > > +	 *
> > > +	 * New mappings can be created immediately, but can't be used before the
> > > +	 * exclusive fence in the dma_bufs reservation object is signaled.
> > > +	 */
> > > +	void (*invalidate_mappings)(struct dma_buf_attachment *attach);
> > Bunch of questions about exact semantics, but I very much like this. And I
> > think besides those technical details, the overall approach seems sound.
> 
> Yeah this initial implementation was buggy like hell. Just wanted to confirm
> that the idea is going in the right direction.

I wanted this 7 years ago, idea very much acked :-)

Cheers, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
