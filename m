Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:53934 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751418AbdK1IgF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Nov 2017 03:36:05 -0500
Date: Tue, 28 Nov 2017 09:35:53 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Giulio Benetti <giulio.benetti@micronovasrl.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Andreas Baierl <list@imkreisrum.de>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        linux@armlinux.org.uk, wens@csie.org, linux-kernel@vger.kernel.org,
        thomas@vitsch.nl, linux-media@vger.kernel.org
Subject: Re: [linux-sunxi] Cedrus driver
Message-ID: <20171128083553.s3upey4ulmva7qoz@flea.home>
References: <693e8786-af83-9d77-0fd4-50fa1f6a135f@micronovasrl.com>
 <20171116110204.poakahqjz4sj7pmu@flea>
 <5fcf64db-c654-37d0-5863-20379c04f99c@micronovasrl.com>
 <20171116125310.yavjs7352nw2sm7r@flea>
 <e03cfdb5-57b3-fefd-75c3-6b97348682ff@micronovasrl.com>
 <6f94505d-69bb-6688-4b13-6a0ed2af8dd4@xs4all.nl>
 <d0b7f6e5-8758-ac92-e6a2-9ed4ff3cbc63@micronovasrl.com>
 <20171116133906.xsrpkdflgf34kkoy@flea>
 <b5c23ea7-4efa-1565-0c53-014c8a1ee37d@micronovasrl.com>
 <5d019a33-9266-1e81-cc36-6e87c22bf382@micronovasrl.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="fqm2npgrr66jkn5f"
Content-Disposition: inline
In-Reply-To: <5d019a33-9266-1e81-cc36-6e87c22bf382@micronovasrl.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--fqm2npgrr66jkn5f
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 28, 2017 at 01:03:59AM +0100, Giulio Benetti wrote:
> Hi Maxime,
>=20
> Il 16/11/2017 14:42, Giulio Benetti ha scritto:
> > Hi,
> >=20
> > Il 16/11/2017 14:39, Maxime Ripard ha scritto:
> > > On Thu, Nov 16, 2017 at 02:17:08PM +0100, Giulio Benetti wrote:
> > > > Hi Hans,
> > > >=20
> > > > Il 16/11/2017 14:12, Hans Verkuil ha scritto:
> > > > > On 16/11/17 13:57, Giulio Benetti wrote:
> > > > > > Il 16/11/2017 13:53, Maxime Ripard ha scritto:
> > > > > > > On Thu, Nov 16, 2017 at 01:30:52PM +0100, Giulio Benetti wrot=
e:
> > > > > > > > > On Thu, Nov 16, 2017 at 11:37:30AM +0100, Giulio Benetti =
wrote:
> > > > > > > > > > Il 16/11/2017 11:31, Andreas Baierl ha scritto:
> > > > > > > > > > > Am 16.11.2017 um 11:13 schrieb Giulio Benetti:
> > > > > > > > > > > > Hello,
> > > > > > > > > > > >=20
> > > > > > > > > > > Hello,
> > > > > > > > > > > > I'm wondering why cedrus
> > > > > > > > > > > > https://github.com/FlorentRevest/linux-sunxi-cedrus
> > > > > > > > > > > > has never been
> > > > > > > > > > > > merged with linux-sunxi sunxi-next.
> > > > > > > > > > > >=20
> > > > > > > > > > > Because it is not ready to be
> > > > > > > > > > > merged. It depends on the v4l2
> > > > > > > > > > > request
> > > > > > > > > > > API, which was not merged and which is re-worked atm.
> > > > > > > > > > > Also, sunxi-cedrus itself is not in
> > > > > > > > > > > a finished state and is not as
> > > > > > > > > > > feature-complete to be merged. Anyway it might be som=
ething for
> > > > > > > > > > > staging... Has there been a [RFC] on the mailing list=
 at all?
> > > > > > > > > >=20
> > > > > > > > > > Where can I find a list of TODOs to get it ready to be =
merged?
> > > > > > > > >=20
> > > > > > > > > Assuming that the request API is in, we'd need to:
> > > > > > > > > =A0=A0=A0=A0=A0 - Finish the MPEG4 support
> > > > > > > > > =A0=A0=A0=A0=A0 - Work on more useful codecs (H264 comes =
to my mind)
> > > > > > > > > =A0=A0=A0=A0=A0 - Implement the DRM planes support for
> > > > > > > > > the custom frame format
> > > > > > > > > =A0=A0=A0=A0=A0 - Implement the DRM planes support for sc=
aling
> > > > > > > > > =A0=A0=A0=A0=A0 - Test it on more SoCs
> > > > > > > > >=20
> > > > > > > > > Or something along those lines.
> > > > > > > >=20
> > > > > > > > Lot of work to do
> > > > > > >=20
> > > > > > > Well... If it was fast and easy it would have been done alrea=
dy :)
> > > > > >=20
> > > > > > :))
> > > > > >=20
> > > > > > >=20
> > > > > > > > > > > > I see it seems to be dead, no commit in 1 year.
> > > > > > > > > > >=20
> > > > > > > > > > > Yes, because the author did this
> > > > > > > > > > > during an internship, which ended
> > > > > > > > > > > ...
> > > > > > > > > > > Afaik nobody picked up his work yet.
> > > > > > > > >=20
> > > > > > > > > That's not entirely true. Some work has been
> > > > > > > > > done by Thomas (in CC),
> > > > > > > > > especially on the display engine side, but last time we t=
alked his
> > > > > > > > > work was not really upstreamable.
> > > > > > > > >=20
> > > > > > > > > We will also resume that effort starting next march.
> > > > > > > >=20
> > > > > > > > Is it possible a preview on a separate
> > > > > > > > Reporitory to start working on now?
> > > > > > > > Expecially to start porting everything done by
> > > > > > > > FlorentRevest to mainline,
> > > > > > > > admitted you've not already done.
> > > > > > >=20
> > > > > > > I'm not sure what you're asking for. Florent's work
> > > > > > > *was* on mainline.
> > > > > >=20
> > > > > > and then they took it off because it was unmantained?
> > > > > > You've spoken about Thomas(in CC) not ready,
> > > > > > maybe I could help on that if it's public to accelerate.
> > > > > > If I'm able to of course, this is my primary concern.
> > > > > >=20
> > > > > > Otherwise, in which way can I help improving it to make
> > > > > > it accept to linux-sunxi?
> > > > > > Starting from Florent's work and porting it to sunxi-next to be=
gin?
> > > > > > And after that adding all features you've listed?
> > > > > > Tell me what I can do(I repeat, if I'm able to).
> > > > >=20
> > > > > The bottleneck is that the Request API is not mainlined. We
> > > > > restarted work
> > > > > on it after a meeting a few weeks back where we all agreed
> > > > > on the roadmap
> > > > > so hopefully it will go into mainline Q1 or Q2 next year.
> > > > >=20
> > > > > That said, you can use Florent's patch series for further develop=
ment.
> > > > > It should be relatively easy to convert it to the final version o=
f the
> > > > > Request API. Just note that the public API of the final
> > > > > Request API will
> > > > > be somewhat different from the old version Florent's patch
> > > > > series is using.
> > > >=20
> > > > So I'm going to try soon to :
> > > > 1) adapt that patchset to sunxi-next
> > > > 2) add A20 support
> > > > 3) add A33 support
> > > > 4) after mainlined APIs, merge
> > >=20
> > > That sounds good. Thomas already has the support for the A20, and as I
> > > was saying, there is someone that is going to work full time on this
> > > in a couple monthes on our side.
> > >=20
> > > I'll set up a git repo on github so that we can collaborate until the
> > > request API is ready.
>=20
> Any news about git repo?
> When do you plan to do it more or less?

I started to do it yesterday.

https://github.com/free-electrons/linux-cedrus
https://github.com/free-electrons/libva-cedrus

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--fqm2npgrr66jkn5f
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlodH+YACgkQ0rTAlCFN
r3QXdg/+JBi4C+LDlP8JA729tV3J9T0o81mBVdEr5m44n83eiwvOQzut2G7xAJZc
7zEPlKm230/+D09+Zap6O+mxq+4NH4CpJ+kZ+Cw1y1Sg/tEHsZ6JUluOUU73GtmJ
9PI1qCgoCErhLJ9jY2VYCy4JOWFfJxVZ8HOhfqkySLf52PfJYgaLqVIlZ/+7jNer
RrrZZQw4QhSA5IJFLPWXnZ5ebdlnuuLSlBkuFsXfLupdj5EQAD4sz0765nunJDv2
kPISzfDHSZMNeYguQWZbc1bol/xPrXlpcoO0vf5mJ2TOlXAqG8P66Zg2VujI6pH/
89H1jfag3xg3icd45UFmilf9bWFjEACbKNmfeeFXbZtbc9gFV4f3BkTwIdQ2GsMx
W+iOvbNti+s7ZRrGxQqP0KxNwp0hMaHCEuAUMOj2PV+UQYTG92HSgJkKHDFRu6lQ
CPj7UWwoZctkwIqRG8OxLXSh3D0aMIu/ud/hC+yttnGK63PEW1V8Tgd5anAh7unq
YiNk+XhGRy18DFfXOlnSMLtX/XG45PaWp8F0xN5lLFGwyxg1dWHPxtgkxi4ofzPr
sAt9r2R730cRpJIHt0Pe7q+FF0KMfW6ntlg6r+10ke8TwijDv8R2lCze34HuP46a
HKowwJzL7bVgyQpjWPfixMJTXZEelXMwTRWrBt3hJzGeNWmII5w=
=qUCz
-----END PGP SIGNATURE-----

--fqm2npgrr66jkn5f--
