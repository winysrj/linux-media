Return-path: <linux-media-owner@vger.kernel.org>
Received: from hqemgate15.nvidia.com ([216.228.121.64]:18951 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbbEGNWd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 May 2015 09:22:33 -0400
Date: Thu, 7 May 2015 15:22:20 +0200
From: Thierry Reding <treding@nvidia.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
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
Message-ID: <20150507132218.GA24541@ulmo.nvidia.com>
References: <CA+M3ks7=3sfRiUdUiyq03jCbp08FdZ9ESMgDwE5rgb-0+No3uA@mail.gmail.com>
 <20150505175405.2787db4b@lxorguk.ukuu.org.uk>
 <20150506083552.GF30184@phenom.ffwll.local>
 <20150506091919.GC16325@ulmo.nvidia.com>
 <20150506131532.GC30184@phenom.ffwll.local>
MIME-Version: 1.0
In-Reply-To: <20150506131532.GC30184@phenom.ffwll.local>
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="SLDf9lqlvOQaIe6s"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 06, 2015 at 03:15:32PM +0200, Daniel Vetter wrote:
> On Wed, May 06, 2015 at 11:19:21AM +0200, Thierry Reding wrote:
> > On Wed, May 06, 2015 at 10:35:52AM +0200, Daniel Vetter wrote:
> > > On Tue, May 05, 2015 at 05:54:05PM +0100, One Thousand Gnomes wrote:
> > > > > First what is Secure Data Path ? SDP is a set of hardware feature=
s to garanty
> > > > > that some memories regions could only be read and/or write by spe=
cific hardware
> > > > > IPs. You can imagine it as a kind of memory firewall which grant/=
revoke
> > > > > accesses to memory per devices. Firewall configuration must be do=
ne in a trusted
> > > > > environment: for ARM architecture we plan to use OP-TEE + a trust=
ed
> > > > > application to do that.
> > > >=20
> > > > It's not just an ARM feature so any basis for this in the core code
> > > > should be generic, whether its being enforced by ARM SDP, various I=
ntel
> > > > feature sets or even via a hypervisor.
> > > >=20
> > > > > I have try 2 "hacky" approachs with dma_buf:
> > > > > - add a secure field in dma_buf structure and configure firewall =
in
> > > > >   dma_buf_{map/unmap}_attachment() functions.
> > > >=20
> > > > How is SDP not just another IOMMU. The only oddity here is that it
> > > > happens to configure buffers the CPU can't touch and it has a contr=
ol
> > > > mechanism that is designed to cover big media corp type uses where =
the
> > > > threat model is that the system owner is the enemy. Why does anythi=
ng care
> > > > about it being SDP, there are also generic cases this might be a us=
eful
> > > > optimisation (eg knowing the buffer isn't CPU touched so you can op=
timise
> > > > cache flushing).
> > > >=20
> > > > The control mechanism is a device/platform detail as with any IOMMU=
=2E It
> > > > doesn't matter who configures it or how, providing it happens.
> > > >=20
> > > > We do presumably need some small core DMA changes - anyone trying t=
o map
> > > > such a buffer into CPU space needs to get a warning or error but wh=
at
> > > > else ?
> > > >=20
> > > > > >From buffer allocation point of view I also facing a problem bec=
ause when v4l2
> > > > > or drm/kms are exporting buffers by using dma_buf they don't atta=
ching
> > > > > themself on it and never call dma_buf_{map/unmap}_attachment(). T=
his is not
> > > > > an issue in those framework while it is how dma_buf exporters are
> > > > > supposed to work.
> > > >=20
> > > > Which could be addressed if need be.
> > > >=20
> > > > So if "SDP" is just another IOMMU feature, just as stuff like IMR i=
s on
> > > > some x86 devices, and hypervisor enforced protection is on assorted
> > > > platforms why do we need a special way to do it ? Is there anything
> > > > actually needed beyond being able to tell the existing DMA code tha=
t this
> > > > buffer won't be CPU touched and wiring it into the DMA operations f=
or the
> > > > platform ?
> > >=20
> > > Iirc most of the dma api stuff gets unhappy when memory isn't struct =
page
> > > backed. In i915 we do use sg tables everywhere though (even for memor=
y not
> > > backed by struct page, e.g. the "stolen" range the bios prereserves),=
 but
> > > we fill those out manually.
> > >=20
> > > A possible generic design I see is to have a secure memory allocator
> > > device which doesn nothing else but hand out dma-bufs.
> >=20
> > Are you suggesting a device file with a custom set of IOCTLs for this?
> > Or some in-kernel API that would perform the secure allocations? I
> > suspect the former would be better suited, because it gives applications
> > the control over whether they need secure buffers or not. The latter
> > would require custom extensions in every driver to make them allocate
> > from a secure memory pool.
>=20
> Yes the idea would be a special-purpose allocater thing like ion. Might
> even want that to be a syscall to do it properly.

Would you care to elaborate why a syscall would be more proper? Not that
I'm objecting to it, just for my education.

> > For my understanding, would the secure memory allocator be responsible
> > for setting up the permissions to access the memory at attachment time?
>=20
> Well not permission checks, but hw capability checks. The allocator should
> have platform knowledge about which devices can access such secure memory
> (since some will definitely not be able to do that for fear of just plain
> sending it out to the world).

At least on Tegra there are controls to grant access to the VPR to a
given device, so I'd expect some driver needing to frob some registers
before the device can access a secure buffer.

Thierry

--SLDf9lqlvOQaIe6s
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVS2cGAAoJEN0jrNd/PrOh1noP/1GVVDUdAVRL7ba4nUhIR2YD
DE51DJK+YUeqKf5eSXrcINQh3QtIXiyAFz0XCE4UTelfcio0I+PG8hITPSt//Jir
c0Jic6LOsu1OZC5jCP5xCkFAzw8YBIM50pHlmNiQJXla7zpYdiwCi5tphrdfCi4l
V4aCg15rCIUem+NzwXR9xfLJ1uk8D65nhOU2QdMLdeZfgmgAXHLCC2ouBughIPlq
kkQgaQxuy4wD5drrO5+MYvUfCGgru3rKbmhit1i5V94z3weo0Ndugl4CVtRwrUG6
tvzuWBcwmprSMuMM5nrUPWd1PCxCix0ec9eMPXD7PbrlEvrhdccBu1NV8R5/ljPP
RvXuo2dVaK4+EvkhbD/PgJHreu3AIA8Lf+8RtyA8W2mlC0oxf0YAv1ayGUzNG4uh
IGugDduRq97iuQKKDta7UABlcDu+h6tppUAnMcJbhi0ekfRGpoEAR6phbNU5SXKY
eNqly8Kap3ppybEq3Ej/giFog5q2jym02qM1xrr8QOI8G2oCxbAFw2eXhh0a/FbL
wBZbB4mSl7GJ5essJ/uZkH/PURXTt9H9KzF6R3l2V7yJDc3Cj4mnKs2iSHRLG8W4
41BckDtadfIEgNOcvrtJZtsikJVyQB8cbINzC+/1LO62bBvyIE32VhqwLIceNAbq
N+J/jiPFJbfC2zqi3OwI
=Ql/M
-----END PGP SIGNATURE-----

--SLDf9lqlvOQaIe6s--
