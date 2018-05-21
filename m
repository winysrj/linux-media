Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:37331 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750867AbeEUH1Y (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 May 2018 03:27:24 -0400
Date: Mon, 21 May 2018 09:27:12 +0200
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Daniel Mack <daniel@zonque.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Samuel Bobrowicz <sam@elite-embedded.com>,
        Steve Longerbeam <slongerbeam@gmail.com>
Subject: Re: [PATCH v3 01/12] media: ov5640: Fix timings setup code
Message-ID: <20180521072712.ejf2pkmavveilji6@flea>
References: <20180517085405.10104-1-maxime.ripard@bootlin.com>
 <20180517085405.10104-2-maxime.ripard@bootlin.com>
 <78510086-f59b-516a-1b51-02f938d41cbb@zonque.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="bjupt4x6d4faxo2z"
Content-Disposition: inline
In-Reply-To: <78510086-f59b-516a-1b51-02f938d41cbb@zonque.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--bjupt4x6d4faxo2z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Daniel,

On Fri, May 18, 2018 at 10:32:43AM +0200, Daniel Mack wrote:
> On Thursday, May 17, 2018 10:53 AM, Maxime Ripard wrote:
> > From: Samuel Bobrowicz <sam@elite-embedded.com>
> >=20
> > The current code, when changing the mode and changing the scaling or
> > sampling parameters, will look at the horizontal and vertical total siz=
e,
> > which, since 5999f381e023 ("media: ov5640: Add horizontal and vertical
> > totals") has been moved from the static register initialization to after
> > the mode change.
> >=20
> > That means that the values are no longer set up before the code retriev=
es
> > them, which is obviously a bug.
>=20
> I tried 'for-4.18-5' before your patch set now and noticed it didn't work=
=2E I
> then bisected the regression down to the same commit that you mentioned
> above.
>=20
> The old code (before 5999f381e023) used to have the timing registers
> embedded in a large register blob. Omitting them during the bulk upload a=
nd
> writing them later doesn't work here, even if the values are the same. It
> seems that the order in which registers are written matters.
>=20
> Hence your patch in this email doesn't fix it for me either. I have to mo=
ve
> ov5640_set_timings() before ov5640_load_regs() to revive my platform.

That's kind of weird, it definitely works for parallel. Do you have a
bit more details on what doesn't work? What commands / apps are you
running?

Maxime

--=20
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com

--bjupt4x6d4faxo2z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlsCdM8ACgkQ0rTAlCFN
r3SVdw/+JBZq1yVhXwSFpcMABItezoftMUySKA5yxPSkhCPJIXaoGFFnkb/fSbGZ
ewcYqJ5z7i2uhlKR5nj+XRXgOEZqtC+7pDmghr3k3hAOhHvWKJ7uTEfs49b76x8d
P3PGhQMC1m8fn5YjN7vPKxGCIg1QVxHJ3jztcH2J9q1LB4jDFjTONA/arLWODHGG
gw78mVfB3/K5i2lZbfPZgCj5BmS19/4BRkDC7/6CNRs7ktIxohc9KLQlVz1G864/
xgaJbIsPB9FLGLwXQpf5J847W9JYACjiKG2iSspfriZKxa+GrYP2be3Q7Bog3IXv
kLIGo5l9mQo+Ndk42cE3R5IerHZ2iSE5WadZWeQ64ET1lh5No7hTF3rj9jS4PgMX
4eW1R/jUdY1dOl+/QFfxLV7UjiDWU7kVNp0I2Z4wF9fKZYhgscuWXqt+alfIcweA
6wwpyF4V+dtubBkIItJRuiyLLU42wR4/ZCwrldl3RF2J6Q40FGi5DqS04/WjwD38
2oJvmtvE3v9v5r1XUDGJy6glX3MLqLGAD+xQHytWWtFCKMmBfRsBcny0Tkps4ekp
X5/4HvLofIq4TYDxE3Y+czlcNYbjwujk4VB+Ag/gOjtwJTjqnXqHRW+VPpuCQQ0k
ImePPvKopYd88vIk7dXPTIYZLTHAsqqBd8CN60FHC97vChaAG68=
=BPwl
-----END PGP SIGNATURE-----

--bjupt4x6d4faxo2z--
