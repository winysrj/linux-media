Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:53403 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755776Ab3HFTGJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Aug 2013 15:06:09 -0400
MIME-Version: 1.0
In-Reply-To: <52013482.e107c20a.27f9.ffffa718SMTPIN_ADDED_BROKEN@mx.google.com>
References: <1374772648-19151-1-git-send-email-tom.cooksey@arm.com>
	<CAF6AEGtspnhSGNM4_QQubVfOkZ1Gh1-Z3iyHOLBPVWuqRy81ew@mail.gmail.com>
	<51f29ccd.f014b40a.34cc.ffffca2aSMTPIN_ADDED_BROKEN@mx.google.com>
	<CAF6AEGvFPGueM_LHVij9KFzM6NJySHCzmaLstuzZkK5GwP+6gQ@mail.gmail.com>
	<51ffdc7e.06b8b40a.2cc8.0fe0SMTPIN_ADDED_BROKEN@mx.google.com>
	<CAF6AEGsyKk_G-R-OX_YcgYFDgTEmCy9Vf2LV1pAOV0452QKSww@mail.gmail.com>
	<5200deb3.0b24b40a.3b26.ffffbadeSMTPIN_ADDED_BROKEN@mx.google.com>
	<CAF6AEGvXcpTKrTjhvrycLqab6F9QP5fAk0ZEWxJ-WvE==PiPsA@mail.gmail.com>
	<52010257.245fc20a.6ff8.1cfdSMTPIN_ADDED_BROKEN@mx.google.com>
	<CAF6AEGsDA8qdShWdYQRqQ0Czn4mLAe-FoADjZdRFcbeWGGe8Hg@mail.gmail.com>
	<52013482.e107c20a.27f9.ffffa718SMTPIN_ADDED_BROKEN@mx.google.com>
Date: Tue, 6 Aug 2013 15:06:05 -0400
Message-ID: <CAF6AEGtaYJfJ4WBddbtyE9P8odXOYvJXLsreMwXMLCBOsfXy7w@mail.gmail.com>
Subject: Re: [RFC 0/1] drm/pl111: Initial drm/kms driver for pl111
From: Rob Clark <robdclark@gmail.com>
To: Tom Cooksey <tom.cooksey@arm.com>
Cc: dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
	Pawel Moll <Pawel.Moll@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 6, 2013 at 1:38 PM, Tom Cooksey <tom.cooksey@arm.com> wrote:
>
>> >> ... This is the purpose of the attach step,
>> >> so you know all the devices involved in sharing up front before
>> >> allocating the backing pages. (Or in the worst case, if you have a
>> >> "late attacher" you at least know when no device is doing dma access
>> >> to a buffer and can reallocate and move the buffer.)  A long time
>> >> back, I had a patch that added a field or two to 'struct
>> >> device_dma_parameters' so that it could be known if a device
>> >> required contiguous buffers.. looks like that never got merged, so
>> >> I'd need to dig that back up and resend it.  But the idea was to
>> >> have the 'struct device' encapsulate all the information that would
>> >> be needed to do-the-right-thing when it comes to placement.
>> >
>> > As I understand it, it's up to the exporting device to allocate the
>> > memory backing the dma_buf buffer. I guess the latest possible point
>> > you can allocate the backing pages is when map_dma_buf is first
>> > called? At that point the exporter can iterate over the current set
>> > of attachments, programmatically determine the all the constraints of
>> > all the attached drivers and attempt to allocate the backing pages
>> > in such a way as to satisfy all those constraints?
>>
>> yes, this is the idea..  possibly some room for some helpers to help
>> out with this, but that is all under the hood from userspace
>> perspective
>>
>> > Didn't you say that programmatically describing device placement
>> > constraints was an unbounded problem? I guess we would have to
>> > accept that it's not possible to describe all possible constraints
>> > and instead find a way to describe the common ones?
>>
>> well, the point I'm trying to make, is by dividing your constraints
>> into two groups, one that impacts and is handled by userspace, and one
>> that is in the kernel (ie. where the pages go), you cut down the
>> number of permutations that the kernel has to care about considerably.
>>  And kernel already cares about, for example, what range of addresses
>> that a device can dma to/from.  I think really the only thing missing
>> is the max # of sglist entries (contiguous or not)
>
> I think it's more than physically contiguous or not.
>
> For example, it can be more efficient to use large page sizes on
> devices with IOMMUs to reduce TLB traffic. I think the size and even
> the availability of large pages varies between different IOMMUs.

sure.. but I suppose if we can spiff out dma_params to express "I need
contiguous", perhaps we can add some way to express "I prefer
as-contiguous-as-possible".. either way, this is about where the pages
are placed, and not about the layout of pixels within the page, so
should be in kernel.  It's something that is missing, but I believe
that it belongs in dma_params and hidden behind dma_alloc_*() for
simple drivers.

> There's also the issue of buffer stride alignment. As I say, if the
> buffer is to be written by a tile-based GPU like Mali, it's more
> efficient if the buffer's stride is aligned to the max AXI bus burst
> length. Though I guess a buffer stride only makes sense as a concept
> when interpreting the data as a linear-layout 2D image, so perhaps
> belongs in user-space along with format negotiation?
>

Yeah.. this isn't about where the pages go, but about the arrangement
within a page.

And, well, except for hw that supports the same tiling (or
compressed-fb) in display+gpu, you probably aren't sharing tiled
buffers.

>
>> > One problem with this is it duplicates a lot of logic in each
>> > driver which can export a dma_buf buffer. Each exporter will need to
>> > do pretty much the same thing: iterate over all the attachments,
>> > determine of all the constraints (assuming that can be done) and
>> > allocate pages such that the lowest-common-denominator is satisfied.
>> >
>> > Perhaps rather than duplicating that logic in every driver, we could
>> > Instead move allocation of the backing pages into dma_buf itself?
>> >
>>
>> I tend to think it is better to add helpers as we see common patterns
>> emerge, which drivers can opt-in to using.  I don't think that we
>> should move allocation into dma_buf itself, but it would perhaps be
>> useful to have dma_alloc_*() variants that could allocate for multiple
>> devices.
>
> A helper could work I guess, though I quite like the idea of having
> dma_alloc_*() variants which take a list of devices to allocate memory
> for.
>
>
>> That would help for simple stuff, although I'd suspect
>> eventually a GPU driver will move away from that.  (Since you probably
>> want to play tricks w/ pools of pages that are pre-zero'd and in the
>> correct cache state, use spare cycles on the gpu or dma engine to
>> pre-zero uncached pages, and games like that.)
>
> So presumably you're talking about a GPU driver being the exporter
> here? If so, how could the GPU driver do these kind of tricks on
> memory shared with another device?
>

Yes, that is gpu-as-exporter.  If someone else is allocating buffers,
it is up to them to do these tricks or not.  Probably there is a
pretty good chance that if you aren't a GPU you don't need those sort
of tricks for fast allocation of transient upload buffers, staging
textures, temporary pixmaps, etc.  Ie. I don't really think a v4l
camera or video decoder would benefit from that sort of optimization.

>
>> >> > Anyway, assuming user-space can figure out how a buffer should be
>> >> > stored in memory, how does it indicate this to a kernel driver and
>> >> > actually allocate it? Which ioctl on which device does user-space
>> >> > call, with what parameters? Are you suggesting using something
>> >> > like ION which exposes the low-level details of how buffers are
>> > >> laid out in physical memory to userspace? If not, what?
>> >> >
>> >>
>> >> no, userspace should not need to know this.  And having a central
>> >> driver that knows this for all the other drivers in the system
>> >> doesn't really solve anything and isn't really scalable.  At best
>> >> you might want, in some cases, a flag you can pass when allocating.
>> >> For example, some of the drivers have a 'SCANOUT' flag that can be
>> >> passed when allocating a GEM buffer, as a hint to the kernel that
>> >> 'if this hw requires contig memory for scanout, allocate this
>> >> buffer contig'. But really, when it comes to sharing buffers
>> >> between devices, we want this sort of information in dev->dma_params
>> >> of the importing device(s).
>> >
>> > If you had a single driver which knew the constraints of all devices
>> > on that particular SoC and the interface allowed user-space to
>> > specify which devices a buffer is intended to be used with, I guess
>> > it could pretty trivially allocate pages which satisfy those
> constraints?
>>
>> keep in mind, even a number of SoC's come with pcie these days.  You
>> already have things like
>>
>>   https://developer.nvidia.com/content/kayla-platform
>>
>> You probably want to get out of the SoC mindset, otherwise you are
>> going to make bad assumptions that come back to bite you later on.
>
> Sure - there are always going to be PC-like devices where the
> hardware configuration isn't fixed like it is on a traditional SoC.
> But I'd rather have a simple solution which works on traditional SoCs
> than no solution at all. Today our solution is to over-load the dumb
> buffer alloc functions of the display's DRM driver - For now I'm just
> looking for the next step up from that! ;-)
>

True.. the original intention, which is perhaps a bit desktop-centric,
really was for there to be a userspace component talking to the drm
driver for allocation, ie. xf86-video-foo and/or
src/gallium/drivers/foo (for example) ;-)

Which means for x11 having a SoC vendor specific xf86-video-foo for
x11..  or vendor specific gbm implementation for wayland.  (Although
at least in the latter case it is a pretty small piece of code.)  But
that is probably what you are trying to avoid.

At any rate, for both xorg and wayland/gbm, you know when a buffer is
going to be a scanout buffer.  What I'd recommend is define a small
userspace API that your customers (the SoC vendors) implement to
allocate a scanout buffer and hand you back a dmabuf fd.  That could
be used both for x11 and for gbm.  Inputs should be requested
width/height and format.  And outputs pitch plus dmabuf fd.

(Actually you might even just want to use gbm as your starting point.
You could probably just use gbm from xf86-video-armsoc for allocation,
to have one thing that works for both wayland and x11.  Scanout and
cursor buffers should go to vendor/SoC specific fxn, rest can be
allocated from mali kernel driver.)

>
>> > wouldn't need a way to programmatically describe the constraints
>> > either: As you say, if userspace sets the "SCANOUT" flag, it would
>> > just "know" that on this SoC, that buffer needs to be physically
>> > contiguous for example.
>>
>> not really.. it just knows it wants to scanout the buffer, and tells
>> this as a hint to the kernel.
>>
>> For example, on omapdrm, the SCANOUT flag does nothing on omap4+
>> (where phys contig is not required for scanout), but causes CMA
>> (dma_alloc_*()) to be used on omap3.  Userspace doesn't care.  It just
>> knows that it wants to be able to scanout that particular buffer.
>
> I think that's the idea? The omap3's allocator driver would use
> contiguous memory when it detects the SCANOUT flag whereas the omap4
> allocator driver wouldn't have to. No complex negotiation of
> constraints - it just "knows".
>

well, it is same allocating driver in both cases (although maybe that
is unimportant).  The "it" that just knows it wants to scanout is
userspace.  The "it" that just knows that scanout translates to
contiguous (or not) is the kernel.  Perhaps we are saying the same
thing ;-)

BR,
-R

>
> Cheers,
>
> Tom
>
>
>
>
