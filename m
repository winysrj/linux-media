Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:40845 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755898AbcAMTvg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jan 2016 14:51:36 -0500
Message-ID: <1452714690.28001.2.camel@collabora.com>
Subject: Re: V4L2 encoder APIs
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reply-To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
To: Sebastien LEDUC <sebastien.leduc@st.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Wed, 13 Jan 2016 14:51:30 -0500
In-Reply-To: <DF597D17D2F66F40A76F27D4E5D6E1A48B0F5418@SAFEX1MAIL1.st.com>
References: <DF597D17D2F66F40A76F27D4E5D6E1A48B0F53E0@SAFEX1MAIL1.st.com>
	 <1452700121.3605.18.camel@collabora.com>
	 <DF597D17D2F66F40A76F27D4E5D6E1A48B0F5418@SAFEX1MAIL1.st.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-1tpG3QerpvtvQmK1cd8B"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-1tpG3QerpvtvQmK1cd8B
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le mercredi 13 janvier 2016 =C3=A0 17:46 +0100, Sebastien LEDUC a =C3=A9cri=
t=C2=A0:
> So I don=E2=80=99t think there is a lot of specification work needed . We
> just need a way to output several buffers instead of one, and to
> specify which one is the header buffer, and which one contains slice
> data.

Ah, ok, I believe you needed to expose metadata per slice to allow
reordering to happen, that might be CODEC specific. In this case, this
could be signalled the same way we signal I-Frames.

cheers,
Nicolas
--=-1tpG3QerpvtvQmK1cd8B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEABECAAYFAlaWqsIACgkQcVMCLawGqBwjJwCg1220jkld8AcGvuPouqWHdlCd
B04AnR5F5yPPOymzBlLfl9zgKZgtzdZK
=D7JX
-----END PGP SIGNATURE-----

--=-1tpG3QerpvtvQmK1cd8B--

