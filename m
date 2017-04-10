Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.andi.de1.cc ([85.214.239.24]:54209 "EHLO
        h2641619.stratoserver.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751064AbdDJTil (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Apr 2017 15:38:41 -0400
Date: Mon, 10 Apr 2017 21:38:22 +0200
From: Andreas Kemnade <andreas@kemnade.info>
To: crope@iki.fi, mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] support for Logilink VG0022a DVB-T2 stick
Message-ID: <20170410213822.53b37b2d@aktux>
In-Reply-To: <1489616530-4025-1-git-send-email-andreas@kemnade.info>
References: <1489616530-4025-1-git-send-email-andreas@kemnade.info>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/ga=oZIqXD.ehMV2Z9o89g9d"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/ga=oZIqXD.ehMV2Z9o89g9d
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

ping

On Wed, 15 Mar 2017 23:22:07 +0100
Andreas Kemnade <andreas@kemnade.info> wrote:

> Hi all,
> here are some patches needed for supporting the
> Logilink VG0022A DVB-T2 stick.
> As the combination of chips in that stick is not
> uncommon, the first two patches might also fix problems
> for similar hardware.
>=20
> Andreas Kemnade (3):
>   [media] si2157: get chip id during probing
>   [media] af9035: init i2c already in it930x_frontend_attach
>   [media] af9035: add Logilink vg0022a to device id table
>=20
>  drivers/media/tuners/si2157.c         | 54 +++++++++++++++++++++--------=
------
>  drivers/media/tuners/si2157_priv.h    |  7 +++++
>  drivers/media/usb/dvb-usb-v2/af9035.c | 45 ++++++++++++++++++++++++++++-
>  3 files changed, 83 insertions(+), 23 deletions(-)
>=20


--Sig_/ga=oZIqXD.ehMV2Z9o89g9d
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJY6981AAoJEInxNTv1CwY0PiIP/RpQ7Z4ASc3I3ooQkBQ8cZVo
XovNsHZM4HL72RGJzo7fQQ2mNvSwmzfLUUlD0tffT64QhH8gca1iKZt2e/wG6+AL
9Vqg/XOTNBA+9A7z9Un4bLIoCDiAaLFnykTPMRChlIjQ3DucWdcYE/W0s+lwCsQc
0Kf6SKZ3T6zzBEPY5BS4KiXQXm4jmysL3H8cYBi7Z5XoFoBZDyue2JyrD0SyrASB
muEjonC5K5W0ADxY0FFQe+vzFEWobtztulO9H5hPHBGGSTRkMBdZds7FmsO3LYc7
avvjjnWnpWqvRJcDE+cn6pKI4gX2Dhprx9/TKKCudYKTaCUl5xDnv3qv+kXAIh65
1BIwiZikDw/Td/BOuJR73aSwoQVHfZfBXyLSvsjyVtcZIRteEqBQtojY8iD51L9w
da6g8PFdo30VDMgqCa5v8Q4KaJeczqcCp/efzfTDWBW19xAlg0YSpynqZAx2jPwP
YB+v1Tywrq3KtQ40VlQzO6PMNPta2HtB5PnrbWUAy6YEg+MZKstegbQgF2rIDsjf
4rHcjG79+ETxzlEyNaF0UTcdnAg3G8GVYTIzHu1UiXaoPhBWGPVgWaBkJ5mTd5tv
JUaWew8fUTFFlZCNpVzv2UFk/uw+RSVe2AjKQ+Rvvpj6H/QNAvRM2GjGX+UXoz8T
XQWTUbUwQInJX4jB+L2e
=AZ8z
-----END PGP SIGNATURE-----

--Sig_/ga=oZIqXD.ehMV2Z9o89g9d--
