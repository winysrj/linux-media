Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34837 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726308AbeIGCWc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Sep 2018 22:22:32 -0400
Message-ID: <9cbf259e7d7109e152ce1b144070b7f97fd0c30f.camel@decadent.org.uk>
Subject: Re: [PATCH] Documentation/media: uapi: Explicitly say there are no
 Invariant Sections
From: Ben Hutchings <ben@decadent.org.uk>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: 698668@bugs.debian.org, linux-media <linux-media@vger.kernel.org>
Date: Thu, 06 Sep 2018 22:44:55 +0100
In-Reply-To: <20180803144153.GA18030@decadent.org.uk>
References: <20180803144153.GA18030@decadent.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-UObYIP7W2QqH2hODdBsK"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-UObYIP7W2QqH2hODdBsK
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Are you still waiting for agreement from any contributors, or is this
ready to apply?

Ben.

On Fri, 2018-08-03 at 15:41 +0100, Ben Hutchings wrote:
> The GNU Free Documentation License allows for a work to specify
> Invariant Sections that are not allowed to be modified.  (Debian
> considers that this makes such works non-free.)
>=20
> The Linux Media Infrastructure userspace API documentation does not
> specify any such sections, but it also doesn't say there are none (as
> is recommended by the license text).  Make it explicit that there are
> none.
>=20
> References: https://bugs.debian.org/698668
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  Documentation/media/media_uapi.rst | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/Documentation/media/media_uapi.rst b/Documentation/media/med=
ia_uapi.rst
> index 28eb35a1f965..5198ff24a094 100644
> --- a/Documentation/media/media_uapi.rst
> +++ b/Documentation/media/media_uapi.rst
> @@ -10,9 +10,9 @@ Linux Media Infrastructure userspace API
> =20
>  Permission is granted to copy, distribute and/or modify this document
>  under the terms of the GNU Free Documentation License, Version 1.1 or
> -any later version published by the Free Software Foundation. A copy of
> -the license is included in the chapter entitled "GNU Free Documentation
> -License".
> +any later version published by the Free Software Foundation, with no
> +Invariant Sections. A copy of the license is included in the chapter
> +entitled "GNU Free Documentation License".
> =20
>  .. only:: html
> =20
--=20
Ben Hutchings
I'm always amazed by the number of people who take up solipsism because
they heard someone else explain it. - E*Borg on alt.fan.pratchett



--=-UObYIP7W2QqH2hODdBsK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAluRn9cACgkQ57/I7JWG
EQl6tg/+No7hqHhvEEjURTRK0l5OF4PyTN7iEEH/7lqTkaTRF+i/zBlauNsKmQg3
gMOy3IwgY4J0/lvE1Xs3VBs5RvPvMekJV7kyuBtbQWGw6fchVK9INMMP0nxuXa6d
CZOdUTIfpvIIK0DF3IELKUyb5VLlAzML2Cd6yomLIXk+RsItUBwH0FuMXlM45jMe
BGeN3qjHQO2ku0RL1GdEu2ZpelrhoTRNyfN/mZzqI9gSWN9j2qP65ghNX6wD2p++
qd0Uo9NJanTABjRCbdMNsvwQVTyXYklvezvGPW4PZcezhuXJw7FwOAz9KurGMuxJ
s8h2F3tIWzfINYku86g3b2iCsV7zipLa1BOBD7uOkEhkRxIUeiR75geDmXGVw5F5
+V04PCNwWyxiAGyesTPTyXNB/QnhZqwzF3kmNKbgE726TYPI3UjWkUOLYADKPL//
HK0Hn+kzbDzVUDAv4JYJq/CT2iXReicuU8GFcDUJziVTOyZDLsNiFAIFeSh9QZdU
ZlqsqHypXUXirVXc2wlSWbCKLjVGViBnUjzVXa32WlVh3jN7IOreBmt+1SUmd5nW
xp57JLTSySl0Vh3BvJZNElC6Dq4JCisDTZADU/XaRod8ftm57Vwwv/Tfr7s/Xfvu
a81TZ1/IwdoUzzKJVqZZpmlniK8E6GmzP83dVRFaqfxNlOFsCRc=
=Dw1V
-----END PGP SIGNATURE-----

--=-UObYIP7W2QqH2hODdBsK--
