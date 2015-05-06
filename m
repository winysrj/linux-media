Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:36233 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbbEFNNP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 May 2015 09:13:15 -0400
Received: by wizk4 with SMTP id k4so201791493wiz.1
        for <linux-media@vger.kernel.org>; Wed, 06 May 2015 06:13:13 -0700 (PDT)
Date: Wed, 6 May 2015 15:15:32 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Thierry Reding <treding@nvidia.com>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Rob Clark <robdclark@gmail.com>,
	Dave Airlie <airlied@redhat.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Tom Gall <tom.gall@linaro.org>
Subject: Re: [RFC] How implement Secure Data Path ?
Message-ID: <20150506131532.GC30184@phenom.ffwll.local>
References: <CA+M3ks7=3sfRiUdUiyq03jCbp08FdZ9ESMgDwE5rgb-0+No3uA@mail.gmail.com>
 <20150505175405.2787db4b@lxorguk.ukuu.org.uk>
 <20150506083552.GF30184@phenom.ffwll.local>
 <20150506091919.GC16325@ulmo.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150506091919.GC16325@ulmo.nvidia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 06, 2015 at 11:19:21AM +0200, Thierry Reding wrote:
> On Wed, May 06, 2015 at 10:35:52AM +0200, Daniel Vetter wrote:
> > On Tue, May 05, 2015 at 05:54:05PM +0100, One Thousand Gnomes wrote:
> > > > First what is Secure Data Path ? SDP is a set of hardware features to garanty
> > > > that some memories regions could only be read and/or write by specific hardware
> > > > IPs. You can imagine it as a kind of memory firewall which grant/revoke
> > > > accesses to memory per devices. Firewall configuration must be done in a trusted
> > > > environment: for ARM architecture we plan to use OP-TEE + a trusted
> > > > application to do that.
> > > 
> > > It's not just an ARM feature so any basis for this in the core code
> > > should be generic, whether its being enforced by ARM SDP, various Intel
> > > feature sets or even via a hypervisor.
> > > 
> > > > I have try 2 "hacky" approachs with dma_buf:
> > > > - add a secure field in dma_buf structure and configure firewall in
> > > >   dma_buf_{map/unmap}_attachment() functions.
> > > 
> > > How is SDP not just another IOMMU. The only oddity here is that it
> > > happens to configure buffers the CPU can't touch and it has a control
> > > mechanism that is designed to cover big media corp type uses where the
> > > threat model is that the system owner is the enemy. Why does anything care
> > > about it being SDP, there are also generic cases this might be a useful
> > > optimisation (eg knowing the buffer isn't CPU touched so you can optimise
> > > cache flushing).
> > > 
> > > The control mechanism is a device/platform detail as with any IOMMU. It
> > > doesn't matter who configures it or how, providing it happens.
> > > 
> > > We do presumably need some small core DMA changes - anyone trying to map
> > > such a buffer into CPU space needs to get a warning or error but what
> > > else ?
> > > 
> > > > >From buffer allocation point of view I also facing a problem because when v4l2
> > > > or drm/kms are exporting buffers by using dma_buf they don't attaching
> > > > themself on it and never call dma_buf_{map/unmap}_attachment(). This is not
> > > > an issue in those framework while it is how dma_buf exporters are
> > > > supposed to work.
> > > 
> > > Which could be addressed if need be.
> > > 
> > > So if "SDP" is just another IOMMU feature, just as stuff like IMR is on
> > > some x86 devices, and hypervisor enforced protection is on assorted
> > > platforms why do we need a special way to do it ? Is there anything
> > > actually needed beyond being able to tell the existing DMA code that this
> > > buffer won't be CPU touched and wiring it into the DMA operations for the
> > > platform ?
> > 
> > Iirc most of the dma api stuff gets unhappy when memory isn't struct page
> > backed. In i915 we do use sg tables everywhere though (even for memory not
> > backed by struct page, e.g. the "stolen" range the bios prereserves), but
> > we fill those out manually.
> > 
> > A possible generic design I see is to have a secure memory allocator
> > device which doesn nothing else but hand out dma-bufs.
> 
> Are you suggesting a device file with a custom set of IOCTLs for this?
> Or some in-kernel API that would perform the secure allocations? I
> suspect the former would be better suited, because it gives applications
> the control over whether they need secure buffers or not. The latter
> would require custom extensions in every driver to make them allocate
> from a secure memory pool.

Yes the idea would be a special-purpose allocater thing like ion. Might
even want that to be a syscall to do it properly.

> For my understanding, would the secure memory allocator be responsible
> for setting up the permissions to access the memory at attachment time?

Well not permission checks, but hw capability checks. The allocator should
have platform knowledge about which devices can access such secure memory
(since some will definitely not be able to do that for fear of just plain
sending it out to the world).

> >                                                        With that we can
> > hide the platform-specific allocation methods in there (some need to
> > allocate from carveouts, other just need to mark the pages specifically).
> > Also dma-buf has explicit methods for cpu access, which are allowed to
> > fail. And using the dma-buf attach tracking we can also reject dma to
> > devices which cannot access the secure memory. Given all that I think
> > going through the dma-buf interface but with a special-purpose allocator
> > seems to fit.
> 
> That sounds like a flexible enough design to me. I think it's something
> that we could easily implement on Tegra. The memory controller on Tegra
> implements this using a special video-protect aperture (VPR) and memory
> clients can individually be allowed access to this aperture. That means
> VPR is a carveout that is typically set up by some secure firmware, and
> that in turn, as I understand it, would imply we won't have struct page
> pointers for the backing memory in this case either.
> 
> I suspect that it should work out fine to not require struct page backed
> memory for this infrastructure since by definition the CPU won't be
> allowed to access it anyway.

At least in the cases I know (carveout on i915, apparently also on tegra)
there's no way we can have struct page around. Which means we cant rely
upon its presence in the generic parts.

> > I'm not sure whether a special iommu is a good idea otoh: I'd expect that
> > for most devices the driver would need to decide about which iommu to pick
> > (or maybe keep track of some special flags for an extended dma_map
> > interface). At least looking at gpu drivers using iommus would require
> > special code, whereas fully hiding all this behind the dma-buf interface
> > should fit in much better.
> 
> As I understand it, even though the VPR on Tegra is a carveout it still
> is subject to IOMMU translation. So if IOMMU translation is enabled for
> a device (say the display controller), then all accesses to memory will
> be translated, whether they are to VPR or non-protected memory. Again I
> think this should work out fine with a special secure allocator. If the
> SG tables are filled in properly drivers should be able to cope.
> 
> It's possible that existing IOMMU drivers would require modification to
> make this work, though. For example, the default_iommu_map_sg() function
> currently uses sg_page(), so that wouldn't be able to map secure buffers
> to I/O virtual addresses. That said, drivers could reimplement this on
> top of iommu_map(), though that may imply suboptimal performance on the
> mapping operation.
> 
> Similarly some backing implementations of the DMA API rely on struct
> page pointers being present. But it seems more like you wouldn't want to
> use the DMA API at all if you want to use this kind of protected memory.

Hm yeah if you still need to go through the iommu even for the secure
carveout then the lack of struct page is annoying. Otoh you have that
problem no matter what.

Another isssue is that at least for some consumer devices we need to set
special bits to make sure the hw goes into secure mode (and makes sure
nothing ever leaves that box). I think in some cases (video encode) that
knowledge would even need to be accessible to userspace. And in-kernel
dma_buf_is_secure_memory plus ioctl might be needed for that.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
