Return-path: <linux-media-owner@vger.kernel.org>
Received: from hqemgate15.nvidia.com ([216.228.121.64]:12576 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbbEFJTc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 May 2015 05:19:32 -0400
Date: Wed, 6 May 2015 11:19:21 +0200
From: Thierry Reding <treding@nvidia.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"Laurent Pinchart" <laurent.pinchart@ideasonboard.com>,
	Rob Clark <robdclark@gmail.com>,
	Dave Airlie <airlied@redhat.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Tom Gall <tom.gall@linaro.org>
Subject: Re: [RFC] How implement Secure Data Path ?
Message-ID: <20150506091919.GC16325@ulmo.nvidia.com>
References: <CA+M3ks7=3sfRiUdUiyq03jCbp08FdZ9ESMgDwE5rgb-0+No3uA@mail.gmail.com>
 <20150505175405.2787db4b@lxorguk.ukuu.org.uk>
 <20150506083552.GF30184@phenom.ffwll.local>
MIME-Version: 1.0
In-Reply-To: <20150506083552.GF30184@phenom.ffwll.local>
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="hYooF8G/hrfVAmum"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--hYooF8G/hrfVAmum
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 06, 2015 at 10:35:52AM +0200, Daniel Vetter wrote:
> On Tue, May 05, 2015 at 05:54:05PM +0100, One Thousand Gnomes wrote:
> > > First what is Secure Data Path ? SDP is a set of hardware features to=
 garanty
> > > that some memories regions could only be read and/or write by specifi=
c hardware
> > > IPs. You can imagine it as a kind of memory firewall which grant/revo=
ke
> > > accesses to memory per devices. Firewall configuration must be done i=
n a trusted
> > > environment: for ARM architecture we plan to use OP-TEE + a trusted
> > > application to do that.
> >=20
> > It's not just an ARM feature so any basis for this in the core code
> > should be generic, whether its being enforced by ARM SDP, various Intel
> > feature sets or even via a hypervisor.
> >=20
> > > I have try 2 "hacky" approachs with dma_buf:
> > > - add a secure field in dma_buf structure and configure firewall in
> > >   dma_buf_{map/unmap}_attachment() functions.
> >=20
> > How is SDP not just another IOMMU. The only oddity here is that it
> > happens to configure buffers the CPU can't touch and it has a control
> > mechanism that is designed to cover big media corp type uses where the
> > threat model is that the system owner is the enemy. Why does anything c=
are
> > about it being SDP, there are also generic cases this might be a useful
> > optimisation (eg knowing the buffer isn't CPU touched so you can optimi=
se
> > cache flushing).
> >=20
> > The control mechanism is a device/platform detail as with any IOMMU. It
> > doesn't matter who configures it or how, providing it happens.
> >=20
> > We do presumably need some small core DMA changes - anyone trying to map
> > such a buffer into CPU space needs to get a warning or error but what
> > else ?
> >=20
> > > >From buffer allocation point of view I also facing a problem because=
 when v4l2
> > > or drm/kms are exporting buffers by using dma_buf they don't attaching
> > > themself on it and never call dma_buf_{map/unmap}_attachment(). This =
is not
> > > an issue in those framework while it is how dma_buf exporters are
> > > supposed to work.
> >=20
> > Which could be addressed if need be.
> >=20
> > So if "SDP" is just another IOMMU feature, just as stuff like IMR is on
> > some x86 devices, and hypervisor enforced protection is on assorted
> > platforms why do we need a special way to do it ? Is there anything
> > actually needed beyond being able to tell the existing DMA code that th=
is
> > buffer won't be CPU touched and wiring it into the DMA operations for t=
he
> > platform ?
>=20
> Iirc most of the dma api stuff gets unhappy when memory isn't struct page
> backed. In i915 we do use sg tables everywhere though (even for memory not
> backed by struct page, e.g. the "stolen" range the bios prereserves), but
> we fill those out manually.
>=20
> A possible generic design I see is to have a secure memory allocator
> device which doesn nothing else but hand out dma-bufs.

Are you suggesting a device file with a custom set of IOCTLs for this?
Or some in-kernel API that would perform the secure allocations? I
suspect the former would be better suited, because it gives applications
the control over whether they need secure buffers or not. The latter
would require custom extensions in every driver to make them allocate
=66rom a secure memory pool.

For my understanding, would the secure memory allocator be responsible
for setting up the permissions to access the memory at attachment time?

>                                                        With that we can
> hide the platform-specific allocation methods in there (some need to
> allocate from carveouts, other just need to mark the pages specifically).
> Also dma-buf has explicit methods for cpu access, which are allowed to
> fail. And using the dma-buf attach tracking we can also reject dma to
> devices which cannot access the secure memory. Given all that I think
> going through the dma-buf interface but with a special-purpose allocator
> seems to fit.

That sounds like a flexible enough design to me. I think it's something
that we could easily implement on Tegra. The memory controller on Tegra
implements this using a special video-protect aperture (VPR) and memory
clients can individually be allowed access to this aperture. That means
VPR is a carveout that is typically set up by some secure firmware, and
that in turn, as I understand it, would imply we won't have struct page
pointers for the backing memory in this case either.

I suspect that it should work out fine to not require struct page backed
memory for this infrastructure since by definition the CPU won't be
allowed to access it anyway.

> I'm not sure whether a special iommu is a good idea otoh: I'd expect that
> for most devices the driver would need to decide about which iommu to pick
> (or maybe keep track of some special flags for an extended dma_map
> interface). At least looking at gpu drivers using iommus would require
> special code, whereas fully hiding all this behind the dma-buf interface
> should fit in much better.

As I understand it, even though the VPR on Tegra is a carveout it still
is subject to IOMMU translation. So if IOMMU translation is enabled for
a device (say the display controller), then all accesses to memory will
be translated, whether they are to VPR or non-protected memory. Again I
think this should work out fine with a special secure allocator. If the
SG tables are filled in properly drivers should be able to cope.

It's possible that existing IOMMU drivers would require modification to
make this work, though. For example, the default_iommu_map_sg() function
currently uses sg_page(), so that wouldn't be able to map secure buffers
to I/O virtual addresses. That said, drivers could reimplement this on
top of iommu_map(), though that may imply suboptimal performance on the
mapping operation.

Similarly some backing implementations of the DMA API rely on struct
page pointers being present. But it seems more like you wouldn't want to
use the DMA API at all if you want to use this kind of protected memory.

Thierry

--hYooF8G/hrfVAmum
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVSdyUAAoJEN0jrNd/PrOhCqQQAIbxyIe+HSyOwtTGO5wjf+2W
MjlPrB9aZb0RGOJrW8IxsAttwnMaKHZ9q8Qregsv0yy9p3gJNheEig35wCevQY0f
JdXQFceSWU78W43jhrezGhd9DK2V0B26HC0TYfaGIbbal9pSjvSpukAeUbzLMMEM
Bjx8k+hb/ZEN3BYjU4WGaMk60RkmD3ElVGEc/u+NmAZ2pKDDYwupS3iSPvDCjMrY
VLQnkgKWdkv/J4FuBeEuj65ASCvtlxOZyu2RcWpuqPgzdN8Fleruosj/YTgoA5HU
BdKyZC5zkFEpR1pCNBlT/uqxTBv/GdUKo1bXX9wG5+B3KNnsOsnFdagRyfIfdtMh
9duODq4tIDG1ZVvpYH0xDdvFc44rQqGciHQm1iG3WF/XfJbevd43dUunKnshLpLv
3854jiC+gYkAQUI362AQ91fKWeMnOkC3f6fEvPKS2zbWs9oslBW8cTa/tf0wN+GH
KgPu27YTx1pfkAmxuXmmqgCawtQOamHOYdG6l/Yel5G1P+2aekxs+HCa02IWPjwv
Lup1/oxiEAgO9/kZUXIqkl5vlsZ7k93MCzRQfKr4X+1ntZSeas56miuEuDeIEgOJ
WRhHeD8y/SDR3rPxm26X0pTuqqXHGrSGEE217GfTolBjw8Trr+tB0i68pkc1JzDH
ifry7FzNZTQ+uz7qd/uO
=mPX5
-----END PGP SIGNATURE-----

--hYooF8G/hrfVAmum--
