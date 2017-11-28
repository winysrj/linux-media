Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:36232 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753141AbdK1PRm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Nov 2017 10:17:42 -0500
Date: Tue, 28 Nov 2017 16:17:40 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Giulio Benetti <giulio.benetti@micronovasrl.com>
Cc: Thomas van Kleef <thomas@vitsch.nl>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Andreas Baierl <list@imkreisrum.de>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        linux@armlinux.org.uk, wens@csie.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [linux-sunxi] Cedrus driver
Message-ID: <20171128151740.eyke3i4nuprconwf@flea.home>
References: <1511868558-1962148761.366cc20c7e@prakkezator.vehosting.nl>
 <d8135c3d-7ba8-2b88-11cb-5b81dfa04be2@vitsch.nl>
 <f8cc0633-8c29-e3b0-0216-f8f5c69ebb34@micronovasrl.com>
 <20171128125203.h7cnu3gkfmogqhxu@flea.home>
 <6A617A27-DBE8-4537-A122-6ACA98B8A6B4@micronovasrl.com>
 <20171128130737.cpohndeskuczcpa7@flea.home>
 <d2f659ed-1750-2859-7b43-0a4780bd3343@micronovasrl.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="f5hs7o5dm66367ro"
Content-Disposition: inline
In-Reply-To: <d2f659ed-1750-2859-7b43-0a4780bd3343@micronovasrl.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--f5hs7o5dm66367ro
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 28, 2017 at 02:12:31PM +0100, Giulio Benetti wrote:
> > > > And really, just develop against 4.14. sunxi-next is rebased, and i=
t's
> > > > just not something you can base some work on.
> > >=20
> > > Where do we can work on then?
> > > Should Thomas setup his own github repo?
> > > What about the one you=E2=80=99ve set up @free-electrons?
> >=20
> > I already said that, please make pull requests to that repo.
>=20
> Sorry I can't understand which repo,
> do you mean https://github.com/free-electrons/linux-cedrus?

Yes.

> And sorry for dumb question,
> but which branch do I have to use if I want to develop a project with sun=
xi?
> Directly mainline patched with sunxi-next branch,
> or another branch @linux-sunxi?

Use 4.14.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--f5hs7o5dm66367ro
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlodfhAACgkQ0rTAlCFN
r3S4XRAAhg4kNRvjfhtO4I11+p+IjzwFsF63xRoW5oXAzYc0xPEjkzrh77GqLgcJ
hh+vnn0Z6g/GnK1OB8gv//1/Bl9Z2cCpLUyoxxdRq1mhyo4MFrnm4C0VmSIVLiuA
y27lrGbpUxX20qn9/pO75neYUtleRHJsABTYc66i9DCr7U0a/xO6JEcFFM7v9I+3
zHRORDiPfntvj/6jxy+G5h8hF/P6p73PQpVIE04Y/Zxmn3Mvnnt/0EDuN5mW2WoP
mxSMYgxb9iE2K4AyYnm+NBJ5bFiQnMZPzp7SSuFZddU7xgcAV7KiVy5qRtb/W4Ff
QD9PlRF4S3/mtO7XwhxUvxMxbRDkUs4EuY4GYDah52YEoTP9Ayzd8B/R8htK+76t
T9tsqaoyG+3BVRVRrghcoIQ8napw/SxZwr3QfwIjStJWXb04n2pQp7AO00LqVifF
/IXfUAqu4m6/UX5fcQwQuTj3Ilb993v20/MQhg+igDKbfynsHnPnavdTGa6B5fCM
3x9qneRqauwM9tvkaYHVzENhfZHlOVZbxZ3BI9PBpO1UWzhj14Idl/K3T/53Xsjx
GMlqFsYNfJp4JvYf2XRH/26eApdXID/RUj+Dp/jYwDr5WPZZq1sn1b/CXH0XHynO
9sfaxHiOci/WrDYnSN1HucZHLHziKRICXwgq9WAw3ZRHk8fPvTo=
=yewu
-----END PGP SIGNATURE-----

--f5hs7o5dm66367ro--
