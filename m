Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:40507 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbcAMPsq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jan 2016 10:48:46 -0500
Message-ID: <1452700121.3605.18.camel@collabora.com>
Subject: Re: V4L2 encoder APIs
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reply-To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
To: Sebastien LEDUC <sebastien.leduc@st.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Wed, 13 Jan 2016 10:48:41 -0500
In-Reply-To: <DF597D17D2F66F40A76F27D4E5D6E1A48B0F53E0@SAFEX1MAIL1.st.com>
References: <DF597D17D2F66F40A76F27D4E5D6E1A48B0F53E0@SAFEX1MAIL1.st.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-KD7ZRGPGPtIXletdCDWe"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-KD7ZRGPGPtIXletdCDWe
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le mercredi 13 janvier 2016 =C3=A0 16:04 +0100, Sebastien LEDUC a =C3=A9cri=
t=C2=A0:
> Hi all
> I have seen on the linuxTV web site that there were some on-going
> discussions related to the Codec API.
>=20
> In our SoCs, it is the HW encoder that is outputting both the slice
> data and the headers/metadata, but it does it using separate buffers.
>=20
> So we are looking at how to expose that using V4L2 APIs.
>=20
> We were thinking that we could use the MPLANE apis to achieve that,
> where one plane would contain=C2=A0=C2=A0the header/metadata and another =
one
> for the slice data.
>=20
> Any opinion on this ?=C2=A0

Discussion I had regarding this kind of integration, whether it was
about non-parsing decoder or slice encoder, is that two planes shall be
used (mplane API will allow seperate allocation of those planes). About
slice encoder, a lot of specification work is needed. I believe the
hardest part and what no one could agree on, is the data structure
standard that would be used to represent the required metadata and
headers. In the end, libv4l should probably have some new feature to
transform slice encoded data into byte-stream so existing software can
use those encoder without porting.

cheers,
Nicolas
--=-KD7ZRGPGPtIXletdCDWe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEABECAAYFAlaWcdkACgkQcVMCLawGqBwdIACghRCltsGfKC/tXCq5ZRBMDwD6
6lwAoKA90S3LpExl0wcP4p+iDlLNA3Cc
=Luzr
-----END PGP SIGNATURE-----

--=-KD7ZRGPGPtIXletdCDWe--

