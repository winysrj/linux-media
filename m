Return-path: <linux-media-owner@vger.kernel.org>
Received: from hqemgate16.nvidia.com ([216.228.121.65]:12448 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbbEGOlm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 May 2015 10:41:42 -0400
Date: Thu, 7 May 2015 16:41:30 +0200
From: Thierry Reding <treding@nvidia.com>
To: Rob Clark <robdclark@gmail.com>
CC: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"Laurent Pinchart" <laurent.pinchart@ideasonboard.com>,
	Dave Airlie <airlied@redhat.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Tom Gall <tom.gall@linaro.org>,
	Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [RFC] How implement Secure Data Path ?
Message-ID: <20150507144128.GA26094@ulmo.nvidia.com>
References: <CA+M3ks7=3sfRiUdUiyq03jCbp08FdZ9ESMgDwE5rgb-0+No3uA@mail.gmail.com>
 <20150505175405.2787db4b@lxorguk.ukuu.org.uk>
 <20150506083552.GF30184@phenom.ffwll.local>
 <CAF6AEGsXYZy7_wON0gHRYYpxXCH5LfxCvWfFAp-rRj5TbGU0Jg@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAF6AEGsXYZy7_wON0gHRYYpxXCH5LfxCvWfFAp-rRj5TbGU0Jg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="n8g4imXOkfNTN/H1"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 06, 2015 at 07:29:56AM -0400, Rob Clark wrote:
> On Wed, May 6, 2015 at 4:35 AM, Daniel Vetter <daniel@ffwll.ch> wrote:
> > On Tue, May 05, 2015 at 05:54:05PM +0100, One Thousand Gnomes wrote:
> >> > First what is Secure Data Path ? SDP is a set of hardware features t=
o garanty
> >> > that some memories regions could only be read and/or write by specif=
ic hardware
> >> > IPs. You can imagine it as a kind of memory firewall which grant/rev=
oke
> >> > accesses to memory per devices. Firewall configuration must be done =
in a trusted
> >> > environment: for ARM architecture we plan to use OP-TEE + a trusted
> >> > application to do that.
> >>
> >> It's not just an ARM feature so any basis for this in the core code
> >> should be generic, whether its being enforced by ARM SDP, various Intel
> >> feature sets or even via a hypervisor.
> >>
> >> > I have try 2 "hacky" approachs with dma_buf:
> >> > - add a secure field in dma_buf structure and configure firewall in
> >> >   dma_buf_{map/unmap}_attachment() functions.
> >>
> >> How is SDP not just another IOMMU. The only oddity here is that it
> >> happens to configure buffers the CPU can't touch and it has a control
> >> mechanism that is designed to cover big media corp type uses where the
> >> threat model is that the system owner is the enemy. Why does anything =
care
> >> about it being SDP, there are also generic cases this might be a useful
> >> optimisation (eg knowing the buffer isn't CPU touched so you can optim=
ise
> >> cache flushing).
> >>
> >> The control mechanism is a device/platform detail as with any IOMMU. It
> >> doesn't matter who configures it or how, providing it happens.
> >>
> >> We do presumably need some small core DMA changes - anyone trying to m=
ap
> >> such a buffer into CPU space needs to get a warning or error but what
> >> else ?
> >>
> >> > >From buffer allocation point of view I also facing a problem becaus=
e when v4l2
> >> > or drm/kms are exporting buffers by using dma_buf they don't attachi=
ng
> >> > themself on it and never call dma_buf_{map/unmap}_attachment(). This=
 is not
> >> > an issue in those framework while it is how dma_buf exporters are
> >> > supposed to work.
> >>
> >> Which could be addressed if need be.
> >>
> >> So if "SDP" is just another IOMMU feature, just as stuff like IMR is on
> >> some x86 devices, and hypervisor enforced protection is on assorted
> >> platforms why do we need a special way to do it ? Is there anything
> >> actually needed beyond being able to tell the existing DMA code that t=
his
> >> buffer won't be CPU touched and wiring it into the DMA operations for =
the
> >> platform ?
> >
> > Iirc most of the dma api stuff gets unhappy when memory isn't struct pa=
ge
> > backed. In i915 we do use sg tables everywhere though (even for memory =
not
> > backed by struct page, e.g. the "stolen" range the bios prereserves), b=
ut
> > we fill those out manually.
> >
> > A possible generic design I see is to have a secure memory allocator
> > device which doesn nothing else but hand out dma-bufs. With that we can
> > hide the platform-specific allocation methods in there (some need to
> > allocate from carveouts, other just need to mark the pages specifically=
).
> > Also dma-buf has explicit methods for cpu access, which are allowed to
> > fail. And using the dma-buf attach tracking we can also reject dma to
> > devices which cannot access the secure memory. Given all that I think
> > going through the dma-buf interface but with a special-purpose allocator
> > seems to fit.
> >
> > I'm not sure whether a special iommu is a good idea otoh: I'd expect th=
at
> > for most devices the driver would need to decide about which iommu to p=
ick
> > (or maybe keep track of some special flags for an extended dma_map
> > interface). At least looking at gpu drivers using iommus would require
> > special code, whereas fully hiding all this behind the dma-buf interface
> > should fit in much better.
>=20
>=20
> jfwiw, I'd fully expect devices to be dealing with a mix of secure and
> insecure buffers, so I'm also not really sure how the 'special iommu'
> plan would play out..
>=20
> I think 'secure' allocator device sounds attractive from PoV of
> separating out platform nonsense.. not sure if it is exactly that
> easy, since importing device probably needs to set some special bits
> here and there..

I would expect there to be a central entity handing out the secure
buffers and that the entity would have the ability to grant access to
the buffers to devices. So I'm thinking that the exporter would deal
with this in the ->attach() operation. That's passed a struct device,
so we should be able to retrieve the information necessary somehow.

Then again, maybe things will be more involved than that. I think the
way this typically works in consumer devices is that you need to jump
into secure firmware to get access granted. For example on Tegra most
registers that control this are TrustZone-protected, so if you don't
happen to be lucky enough to be running the kernel in secure mode you
can't enable access to secure memory from the kernel.

As Alan mentioned before this is designed with the assumption that the
user is not to be trusted, so the OEM must make sure that the chain of
trust is upheld. In practice that means that consumer devices will run
some secure firmware that can't be replaced and which boots the kernel
in non-secure mode, thereby disallowing the kernel from touching these
registers that could potentially expose protected content to untrusted
consumers.

In practice I think the result is that secure firmware sets up secure
memory (VPR on Tegra) and then lets the kernel know its geometry. The
kernel is then free to manage the VPR as it sees fit. If the devices
need to deal with both secure and non-secure memory, I'm not exactly
sure how the above security model is supposed to hold. If the kernel
is free to program any address into the device, then it would be easy
to trick it into writing to some region that the CPU can access. I'm
fairly sure that there's some mechanism to disallow that, but I don't
know exactly how it's implemented.

Thierry

--n8g4imXOkfNTN/H1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVS3mVAAoJEN0jrNd/PrOhMOEP/09D51Lyzqw3lxuAWMbKmjbY
s908jazh1ssx/38UYri2jhSdW5ANcndV90In94f9VuRlndCM8t1bR1R8onYGXPEn
EHy6jB1NxkejtrINdyf0yr97tO+y01leC/Ao84xTyQQlgW1YSA/OrII3FtkORrQ0
ZOuwTEhnJKhO1uFKEuiD4ZQ6p1ks1ry0k5QHNUsjNF0C3/NJmFfSJ0z2iwtCoK8G
u8mBlZuXlZzlMkrUaX6rxB+mFyRwMwcq1eE/WPcVXsjVlPFAwJMhhstdHakVZgil
rft6cUHyQRLRRO6fkelqTrVYh6AVh2GAmtrM7YUHER8WG8Kdk3gBbKsnLgQ+ZOTX
PuyLzxW0o+HX5gsxpuMpoh+32hLRnuuB/T51cW1yJHMZHmUrAySCbg3zZKeBDhPg
8heKao4CiGbysFg5MN7XCYLO8XnGfe0s8tvXHztqNuMECGLun0vkeBmaC+a6uoda
ygHdm1AjXsVmmReMQcfUUPyLbEhF0xoHdLX51Q+GNYHS4yeqZyfEzqPAPmA08HB6
DixLXZxS0FeFAPSnER32c5GHV2G8+0CxH5bs2PLEtKfps805+Wqhltt0uTpNr5pU
YDujWwbGzhWed81B0taAphvwNZUGfHzgNRvZWdVkxrVGgR2xmCq8E+9AQrP87P0w
aHwBz7PsBjkbAaQmBNS/
=dhXK
-----END PGP SIGNATURE-----

--n8g4imXOkfNTN/H1--
