Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:41638 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932244AbdKPNjJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Nov 2017 08:39:09 -0500
Date: Thu, 16 Nov 2017 14:39:06 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Giulio Benetti <giulio.benetti@micronovasrl.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Andreas Baierl <list@imkreisrum.de>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        linux@armlinux.org.uk, wens@csie.org, linux-kernel@vger.kernel.org,
        thomas@vitsch.nl, linux-media@vger.kernel.org
Subject: Re: [linux-sunxi] Cedrus driver
Message-ID: <20171116133906.xsrpkdflgf34kkoy@flea>
References: <1510059543-7064-1-git-send-email-giulio.benetti@micronovasrl.com>
 <1b12fa21-bfe6-9ba7-ae1d-8131ac6f4668@micronovasrl.com>
 <6fcdc0d9-d0f8-785a-bb00-b1b41c684e59@imkreisrum.de>
 <693e8786-af83-9d77-0fd4-50fa1f6a135f@micronovasrl.com>
 <20171116110204.poakahqjz4sj7pmu@flea>
 <5fcf64db-c654-37d0-5863-20379c04f99c@micronovasrl.com>
 <20171116125310.yavjs7352nw2sm7r@flea>
 <e03cfdb5-57b3-fefd-75c3-6b97348682ff@micronovasrl.com>
 <6f94505d-69bb-6688-4b13-6a0ed2af8dd4@xs4all.nl>
 <d0b7f6e5-8758-ac92-e6a2-9ed4ff3cbc63@micronovasrl.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="tlowwgvkbkxut4gn"
Content-Disposition: inline
In-Reply-To: <d0b7f6e5-8758-ac92-e6a2-9ed4ff3cbc63@micronovasrl.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--tlowwgvkbkxut4gn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 16, 2017 at 02:17:08PM +0100, Giulio Benetti wrote:
> Hi Hans,
>=20
> Il 16/11/2017 14:12, Hans Verkuil ha scritto:
> > On 16/11/17 13:57, Giulio Benetti wrote:
> > > Il 16/11/2017 13:53, Maxime Ripard ha scritto:
> > > > On Thu, Nov 16, 2017 at 01:30:52PM +0100, Giulio Benetti wrote:
> > > > > > On Thu, Nov 16, 2017 at 11:37:30AM +0100, Giulio Benetti wrote:
> > > > > > > Il 16/11/2017 11:31, Andreas Baierl ha scritto:
> > > > > > > > Am 16.11.2017 um 11:13 schrieb Giulio Benetti:
> > > > > > > > > Hello,
> > > > > > > > >=20
> > > > > > > > Hello,
> > > > > > > > > I'm wondering why cedrus
> > > > > > > > > https://github.com/FlorentRevest/linux-sunxi-cedrus has n=
ever been
> > > > > > > > > merged with linux-sunxi sunxi-next.
> > > > > > > > >=20
> > > > > > > > Because it is not ready to be merged. It depends on the v4l=
2 request
> > > > > > > > API, which was not merged and which is re-worked atm.
> > > > > > > > Also, sunxi-cedrus itself is not in a finished state and is=
 not as
> > > > > > > > feature-complete to be merged. Anyway it might be something=
 for
> > > > > > > > staging... Has there been a [RFC] on the mailing list at al=
l?
> > > > > > >=20
> > > > > > > Where can I find a list of TODOs to get it ready to be merged?
> > > > > >=20
> > > > > > Assuming that the request API is in, we'd need to:
> > > > > >      - Finish the MPEG4 support
> > > > > >      - Work on more useful codecs (H264 comes to my mind)
> > > > > >      - Implement the DRM planes support for the custom frame fo=
rmat
> > > > > >      - Implement the DRM planes support for scaling
> > > > > >      - Test it on more SoCs
> > > > > >=20
> > > > > > Or something along those lines.
> > > > >=20
> > > > > Lot of work to do
> > > >=20
> > > > Well... If it was fast and easy it would have been done already :)
> > >=20
> > > :))
> > >=20
> > > >=20
> > > > > > > > > I see it seems to be dead, no commit in 1 year.
> > > > > > > >=20
> > > > > > > > Yes, because the author did this during an internship, whic=
h ended ...
> > > > > > > > Afaik nobody picked up his work yet.
> > > > > >=20
> > > > > > That's not entirely true. Some work has been done by Thomas (in=
 CC),
> > > > > > especially on the display engine side, but last time we talked =
his
> > > > > > work was not really upstreamable.
> > > > > >=20
> > > > > > We will also resume that effort starting next march.
> > > > >=20
> > > > > Is it possible a preview on a separate Reporitory to start workin=
g on now?
> > > > > Expecially to start porting everything done by FlorentRevest to m=
ainline,
> > > > > admitted you've not already done.
> > > >=20
> > > > I'm not sure what you're asking for. Florent's work *was* on mainli=
ne.
> > >=20
> > > and then they took it off because it was unmantained?
> > > You've spoken about Thomas(in CC) not ready,
> > > maybe I could help on that if it's public to accelerate.
> > > If I'm able to of course, this is my primary concern.
> > >=20
> > > Otherwise, in which way can I help improving it to make it accept to =
linux-sunxi?
> > > Starting from Florent's work and porting it to sunxi-next to begin?
> > > And after that adding all features you've listed?
> > > Tell me what I can do(I repeat, if I'm able to).
> >=20
> > The bottleneck is that the Request API is not mainlined. We restarted w=
ork
> > on it after a meeting a few weeks back where we all agreed on the roadm=
ap
> > so hopefully it will go into mainline Q1 or Q2 next year.
> >=20
> > That said, you can use Florent's patch series for further development.
> > It should be relatively easy to convert it to the final version of the
> > Request API. Just note that the public API of the final Request API will
> > be somewhat different from the old version Florent's patch series is us=
ing.
>=20
> So I'm going to try soon to :
> 1) adapt that patchset to sunxi-next
> 2) add A20 support
> 3) add A33 support
> 4) after mainlined APIs, merge

That sounds good. Thomas already has the support for the A20, and as I
was saying, there is someone that is going to work full time on this
in a couple monthes on our side.

I'll set up a git repo on github so that we can collaborate until the
request API is ready.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--tlowwgvkbkxut4gn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJaDZT6AAoJEBx+YmzsjxAgx9IP/0NQ+kyIaRpLlWr2NicgfSYg
zFBpCQRc0N7hCGpGrgySSiIMLEXdYlGLezj1K8BDAWBc9HuKVKpD8Rwx9Y27tgHw
4K9TPD6Ksj7butsYoUK5Af7EP3ZV8SCGJUrk8Oxq5/kongs/hmNHicogwBFm+639
oinll9hn9hG+LUpwCt3NKSKTrCDMuopxZeWeWsCLSPif8hhWfLPviWVOA4EckHM2
qHFdE473f5Nga04AZTGDJvwPacm1zDZxmeixGyygEJ3cBV00XnkQbpRXsuFvQ8xM
LxlrlQChNbdDSR6lhtYU+pARqvVBAt5fRBH1JAHhkICKGbera7h01j/mPF5OCFZ3
/yHk6VCGB3ZaLsgKoXw3JszbVmoJv4ppWzm/yOKQSmFA38SYW1XBKafe5e0bvxvJ
1Bn81fNYS3koshtmL5cxGFdWUpXTd0RWr0cA6BtaFLitGVFKCjW0/OTpPCZIUExl
sB5Ni4LlyajmX9hh3qe+9mcsj6NiwLYZD/eS9UjboDq4TN6w3ROaMS8hhxw27iwp
OEtMdsFKD8yQiraONT1tPTltD1eukj3R4cosFtTAyYVl9sPqPA7oZEjiszQspgxB
IhyTrmjeBIQamQfl19UOHbMIhdjcQ6u5myX/BUU7wMjYZdO871wmljWP1Bv+W7LJ
/xauUuaUXg84x//EVF+P
=yirU
-----END PGP SIGNATURE-----

--tlowwgvkbkxut4gn--
