Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([88.99.104.3]:38556 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751396AbdITRSn (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 13:18:43 -0400
Date: Wed, 20 Sep 2017 19:18:40 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Wolfram Sang <wsa+renesas@sang-engineering.com>,
        linux-i2c@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [RFC PATCH v4 3/6] i2c: add docs to clarify DMA handling
Message-ID: <20170920171840.nrzyiasezxisvg5m@ninjato>
References: <20170817141449.23958-1-wsa+renesas@sang-engineering.com>
 <20170817141449.23958-4-wsa+renesas@sang-engineering.com>
 <20170827083748.248e2430@vento.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="kfeduj5bsm57jf7d"
Content-Disposition: inline
In-Reply-To: <20170827083748.248e2430@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--kfeduj5bsm57jf7d
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

> > +Linux I2C and DMA
> > +-----------------
>=20
> I would use, instead:
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> Linux I2C and DMA
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> As this is the way we're starting document titles, after converted to
> ReST. So, better to have it already using the right format, as one day

I did this.

> There are also a couple of things here that Sphinx would complain.

The only complaint I got was

	WARNING: document isn't included in any toctree

which makes sense because I renamed it only temporarily to *.rst

> So, it could be worth to rename it to *.rst, while you're writing
> it, and see what:
> 	make htmldocs
> will complain and how it will look in html.

So, no complaints from Sphinx and the HTML output looks good IMO. Was
there anything specific you had in mind when saying that Sphinx would
complain?

Regards,

   Wolfram


--kfeduj5bsm57jf7d
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAlnCouwACgkQFA3kzBSg
KbbtHQ/8DWWirM1jOYSNEG8imNNd8t+h58mEXnl0kElz3P2KB1OhSKLLaa7v6fIS
bPWfk2US6oAseSMWgdHjsLBL2/jir1pdKZVoNG3c8f/+rJ+lpSx6yT0HJVVrwv9A
Jbgs7traQdoXlpw/ge0FtNKZcuHR86tN8tMSL6Na8o20cT6JilgGeEtTpNgfFuZj
8nZ+V1mQNQR1z7WP/4fGnMm5LxyQIDFvUkroaY+DV2T+CXqCEGSvHhg1I4Iw+aM/
Dn9DD9CuLlI/i6pqnGjRg9uszfncPXcI86Qqf39KiV/jGMfBS/mCtFqlYLOCFjbz
jKjSnJyNaayaaXUJ/ODRQO3Nx51SswM+5HZzsaeM/8jH5wHk/ea36zKGC+qHLDKA
6PFjCArdHx+e/TxDr6SpZUzkuiE25E9LJ6yH5FPv/6DYuajO1DDpRH7QPCaZfMw4
L7UFQOGC3gzQLBeevSEmESQ2cUDCBkYOfSL9nSpfnAwJINUWfJCK0SCD2Ysjl3S7
j1mflmPznRxW9wTaS1h+sY+GKrZgeZuHXZ7qkkFDEVSdle1kh8RprE7cLRuq++jU
eLfG7zZhjlrgT6WB8xRFjXxUCXCIlHLRg/HA1CbS1ln7kg7Pl+7FplZlr1oWPsRS
3OXCv5reMOOKXDaskiCTk/w2b3n2JzBJoaoFNXrfufDqQ4A0TTE=
=gPvy
-----END PGP SIGNATURE-----

--kfeduj5bsm57jf7d--
