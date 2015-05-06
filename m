Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f182.google.com ([209.85.160.182]:35435 "EHLO
	mail-yk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbbEFL35 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 May 2015 07:29:57 -0400
MIME-Version: 1.0
In-Reply-To: <20150506083552.GF30184@phenom.ffwll.local>
References: <CA+M3ks7=3sfRiUdUiyq03jCbp08FdZ9ESMgDwE5rgb-0+No3uA@mail.gmail.com>
	<20150505175405.2787db4b@lxorguk.ukuu.org.uk>
	<20150506083552.GF30184@phenom.ffwll.local>
Date: Wed, 6 May 2015 07:29:56 -0400
Message-ID: <CAF6AEGsXYZy7_wON0gHRYYpxXCH5LfxCvWfFAp-rRj5TbGU0Jg@mail.gmail.com>
Subject: Re: [RFC] How implement Secure Data Path ?
From: Rob Clark <robdclark@gmail.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Rob Clark <robdclark@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	Dave Airlie <airlied@redhat.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Tom Gall <tom.gall@linaro.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 6, 2015 at 4:35 AM, Daniel Vetter <daniel@ffwll.ch> wrote:
> On Tue, May 05, 2015 at 05:54:05PM +0100, One Thousand Gnomes wrote:
>> > First what is Secure Data Path ? SDP is a set of hardware features to garanty
>> > that some memories regions could only be read and/or write by specific hardware
>> > IPs. You can imagine it as a kind of memory firewall which grant/revoke
>> > accesses to memory per devices. Firewall configuration must be done in a trusted
>> > environment: for ARM architecture we plan to use OP-TEE + a trusted
>> > application to do that.
>>
>> It's not just an ARM feature so any basis for this in the core code
>> should be generic, whether its being enforced by ARM SDP, various Intel
>> feature sets or even via a hypervisor.
>>
>> > I have try 2 "hacky" approachs with dma_buf:
>> > - add a secure field in dma_buf structure and configure firewall in
>> >   dma_buf_{map/unmap}_attachment() functions.
>>
>> How is SDP not just another IOMMU. The only oddity here is that it
>> happens to configure buffers the CPU can't touch and it has a control
>> mechanism that is designed to cover big media corp type uses where the
>> threat model is that the system owner is the enemy. Why does anything care
>> about it being SDP, there are also generic cases this might be a useful
>> optimisation (eg knowing the buffer isn't CPU touched so you can optimise
>> cache flushing).
>>
>> The control mechanism is a device/platform detail as with any IOMMU. It
>> doesn't matter who configures it or how, providing it happens.
>>
>> We do presumably need some small core DMA changes - anyone trying to map
>> such a buffer into CPU space needs to get a warning or error but what
>> else ?
>>
>> > >From buffer allocation point of view I also facing a problem because when v4l2
>> > or drm/kms are exporting buffers by using dma_buf they don't attaching
>> > themself on it and never call dma_buf_{map/unmap}_attachment(). This is not
>> > an issue in those framework while it is how dma_buf exporters are
>> > supposed to work.
>>
>> Which could be addressed if need be.
>>
>> So if "SDP" is just another IOMMU feature, just as stuff like IMR is on
>> some x86 devices, and hypervisor enforced protection is on assorted
>> platforms why do we need a special way to do it ? Is there anything
>> actually needed beyond being able to tell the existing DMA code that this
>> buffer won't be CPU touched and wiring it into the DMA operations for the
>> platform ?
>
> Iirc most of the dma api stuff gets unhappy when memory isn't struct page
> backed. In i915 we do use sg tables everywhere though (even for memory not
> backed by struct page, e.g. the "stolen" range the bios prereserves), but
> we fill those out manually.
>
> A possible generic design I see is to have a secure memory allocator
> device which doesn nothing else but hand out dma-bufs. With that we can
> hide the platform-specific allocation methods in there (some need to
> allocate from carveouts, other just need to mark the pages specifically).
> Also dma-buf has explicit methods for cpu access, which are allowed to
> fail. And using the dma-buf attach tracking we can also reject dma to
> devices which cannot access the secure memory. Given all that I think
> going through the dma-buf interface but with a special-purpose allocator
> seems to fit.
>
> I'm not sure whether a special iommu is a good idea otoh: I'd expect that
> for most devices the driver would need to decide about which iommu to pick
> (or maybe keep track of some special flags for an extended dma_map
> interface). At least looking at gpu drivers using iommus would require
> special code, whereas fully hiding all this behind the dma-buf interface
> should fit in much better.


jfwiw, I'd fully expect devices to be dealing with a mix of secure and
insecure buffers, so I'm also not really sure how the 'special iommu'
plan would play out..

I think 'secure' allocator device sounds attractive from PoV of
separating out platform nonsense.. not sure if it is exactly that
easy, since importing device probably needs to set some special bits
here and there..

BR,
-R


> -Daniel
> --
> Daniel Vetter
> Software Engineer, Intel Corporation
> http://blog.ffwll.ch
