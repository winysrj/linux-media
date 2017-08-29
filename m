Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([88.99.104.3]:46274 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750909AbdH2UaI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Aug 2017 16:30:08 -0400
Date: Tue, 29 Aug 2017 22:30:06 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Bhumika Goyal <bhumirks@gmail.com>
Cc: julia.lawall@lip6.fr, jacmet@sunsite.dk, jglauber@cavium.com,
        david.daney@cavium.com, hans.verkuil@cisco.com, mchehab@kernel.org,
        awalls@md.metrocast.net, serjk@netup.ru, aospan@netup.ru,
        isely@pobox.com, ezequiel@vanguardiasur.com.ar,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 2/4] [media] media: pci: make i2c_adapter const
Message-ID: <20170829203006.xeghbqp56kwhriba@ninjato>
References: <1503138855-585-1-git-send-email-bhumirks@gmail.com>
 <1503138855-585-3-git-send-email-bhumirks@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="j76ftz66xhtsdhgo"
Content-Disposition: inline
In-Reply-To: <1503138855-585-3-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--j76ftz66xhtsdhgo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 19, 2017 at 04:04:13PM +0530, Bhumika Goyal wrote:
> Make these const as they are only used in a copy operation.
> Done using Coccinelle
>=20
> Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>

Acked-by: Wolfram Sang <wsa@the-dreams.de>


--j76ftz66xhtsdhgo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAlmlzs0ACgkQFA3kzBSg
KbZQMQ//a+QSzHsCE79UbDXtal22KvUCQ+3K73Vd33GrFBZB6vIsXtonygCxIriI
yw/t6Br5Zg/cvWnA5HB//2v5AWKbzr1dvoOU+RD5OF3yx/IT89eLITP1w1X97spb
W+49ua+xEW5KNn+7J/eKHHsQACf/D2wSpf7A7aVXUZAKYnC6EwOuMjNGsc1j7KOI
iBnrvlsaqTItGWhXpdhsRV5v7pyRBiAPtJoIVXCJ7xCJQbY8FesFZbI8fkk7s5dZ
tZS5IKZtwJYkZ7QZfO5qsbKqE99iexQb67mtGC/LHEh3Tr3yXs1CTIObRHR1JQwK
O8HAnUU+hWDruZA3hRvaRhQSWag+hX44LkGmwLCG0ciHVzVny7viFXy5pMGYdXdn
9k6J7TY0f5q0/EvgW35iB4yl+AwSiMMmDlJioEV9He/wmMl5he6rhHnJe9FhTEan
7hsVvsQX0aCOAN1jdnbCH7r6vrohCvK9j8BMaAJjdQYwLer+kltPoxplr6TfZgge
t/4/CtlP/sRGC5HV1Qrnnnjfy0KDIPf7PKUa0ah3xIxUrSstYNtHZaxzZkYueV8M
kHtATn3YfgjI9c2uTecj3ym2EjZXnVVA6pkxoiel64DZiC4zm9G4Xhh8wR9AZtag
oG3AwkrgOn/ZoNAmhGAtmePbloQJykdtIFFI70Gb/tfTEB2nZdk=
=zPA/
-----END PGP SIGNATURE-----

--j76ftz66xhtsdhgo--
