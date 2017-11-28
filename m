Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:59696 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751443AbdK1NHt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Nov 2017 08:07:49 -0500
Date: Tue, 28 Nov 2017 14:07:37 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Giulio Benetti <giulio.benetti@micronovasrl.com>
Cc: Thomas van Kleef <thomas@vitsch.nl>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Andreas Baierl <list@imkreisrum.de>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        linux@armlinux.org.uk, wens@csie.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [linux-sunxi] Cedrus driver
Message-ID: <20171128130737.cpohndeskuczcpa7@flea.home>
References: <1511868558-1962148761.366cc20c7e@prakkezator.vehosting.nl>
 <d8135c3d-7ba8-2b88-11cb-5b81dfa04be2@vitsch.nl>
 <f8cc0633-8c29-e3b0-0216-f8f5c69ebb34@micronovasrl.com>
 <20171128125203.h7cnu3gkfmogqhxu@flea.home>
 <6A617A27-DBE8-4537-A122-6ACA98B8A6B4@micronovasrl.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="h63ssfpb3z5suvqn"
Content-Disposition: inline
In-Reply-To: <6A617A27-DBE8-4537-A122-6ACA98B8A6B4@micronovasrl.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--h63ssfpb3z5suvqn
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 28, 2017 at 02:03:43PM +0100, Giulio Benetti wrote:
> Hi,
>=20
> > Il giorno 28 nov 2017, alle ore 13:52, Maxime Ripard <maxime.ripard@fre=
e-electrons.com> ha scritto:
> >=20
> > On Tue, Nov 28, 2017 at 12:54:08PM +0100, Giulio Benetti wrote:
> >>>>> Should I be working in sunxi-next I wonder?
> >>>>=20
> >>>> Yes, this is the best way, cedrus is very specific to sunxi.
> >>>> So before working on mainline, I think the best is to work un sunxi-=
next branch.
> >>>=20
> >>> Is the requests2 api in sunxi-next?
> >>=20
> >> It should be there,
> >> take a look at latest commit of yesterday:
> >> https://github.com/linux-sunxi/linux-sunxi/commit/df7cacd062cd84c551d7=
e72f15b1af6d71abc198
> >=20
> > No, it shouldn't. sunxi-next is about patches that are related to
> > sunxi that have been accepted in their respective maintainers'
> > branches.
> >=20
> > While we could argue about the first criteria, the second one is not
> > respected.
> >=20
> > And really, just develop against 4.14. sunxi-next is rebased, and it's
> > just not something you can base some work on.
>=20
> Where do we can work on then?
> Should Thomas setup his own github repo?
> What about the one you=E2=80=99ve set up @free-electrons?

I already said that, please make pull requests to that repo.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--h63ssfpb3z5suvqn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlodX5UACgkQ0rTAlCFN
r3TmJA//YOMQ4e6tpU2b2/NiTyg7yevBA0d4YYGnsT5CBhV74+i+HGNW+skWt2Sq
zytGjQ8GnaY8zIQLxizSIWLqo/3Rn5ElB5KROsCq0Wq5yY/a9kktLnldIp5XDXDH
YmY9xvhhusGo3gwExKTBRpFBRiwHd2kF+zTYEKWOtSh3sftaPcqjne7r2UvBIVZ5
vKGUMQyVp7VdSKkTCtyqbhcZ2iBTyw1Uvrzhr9Kxl8DTXVpHAykORjyXhpUfjiWq
KigRIs19r/DDhnmgCRVoAH3MmyzpN5UBvbL8kYHH1Z+++xssOtaWEuZvuFHaB13K
jA2wS4fGFN9/gvS8UUeDD6Y0EoJLoVVdT90J7GOm1CNgTOxv3JPQCq5BoaKvYqEV
nq+U+XOzuItuSrsJQDbO6MyYPUrfENCuKxlvgQQlB8CKCF6cPsyk9Sph5V7BKhx9
PbExirWF/IV2dDDw8emC4Ifm0QATBvmp2s4KRwAA8EOrE8cyIrUtEBBI1SN8sBmc
HCyyXXZxVaJpZTM52OnKMT7WpYp9dyCeHxD65dPx3WKYG0bfpq3ZZdBhGarstmTt
wVt7tJ7IR8yRRd4zZJc+NDivSAENFSmWGZemqkP2KNlHdKaX9U1VpaT7amaOgf8O
792AhJBFtxcYgyGxibrkHH1RtFgUZkzpGxrxhAkiSEoZZ7ZfqlQ=
=ojPL
-----END PGP SIGNATURE-----

--h63ssfpb3z5suvqn--
