Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:45608 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751940AbeEGIKX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 May 2018 04:10:23 -0400
Date: Mon, 7 May 2018 10:10:11 +0200
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Sam Bobrowicz <sam@elite-embedded.com>
Cc: Loic Poulain <loic.poulain@linaro.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hugues Fruchet <hugues.fruchet@st.com>
Subject: Re: [PATCH v2 00/12] media: ov5640: Misc cleanup and improvements
Message-ID: <20180507081011.kvo2vbtzhaxqcf4v@flea>
References: <20180416123701.15901-1-maxime.ripard@bootlin.com>
 <20180419123244.tujbrkpazbdyows6@flea>
 <CAFwsNOEV0Q2HjmaoT-m-znD-+0VSfE4tJ2vCPuNpUe2M72ErAA@mail.gmail.com>
 <3075738.A80d5ULHjc@avalon>
 <CAFwsNOECP74VKYavSo6RBzzohZ1S69=CVjSP_zYDsBXMhyxMjw@mail.gmail.com>
 <20180503151621.onuq77ph32o5euis@flea>
 <CAMZdPi-DGc4-BTyJ7Lx2tHLdGvPg__OPRsr7V1DrQwL9Cc87_A@mail.gmail.com>
 <CAFwsNOEYmcCGnBE1pLV53JxSNEzCOk0oCMw=dowaeD1ckuDuoA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="yvty2zhvrtguciro"
Content-Disposition: inline
In-Reply-To: <CAFwsNOEYmcCGnBE1pLV53JxSNEzCOk0oCMw=dowaeD1ckuDuoA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--yvty2zhvrtguciro
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 04, 2018 at 02:13:16PM -0700, Sam Bobrowicz wrote:
> > FYI, I've found the following document:
> > https://community.nxp.com/servlet/JiveServlet/downloadImage/105-32914-9=
9951/ov5640_diagram.jpg
> >
> > So it seems that clock tree is a bit different.
>=20
> So that is where the Digilent RnD team got their information. I was
> working with an ASCII representation of the same diagram, thanks for
> providing that.
>=20
> >
> > So, from my understanding we need to calculate dividers so that:
> > sclk =3D vtot * htot * fps
> > pclk =3D sclk  * byte-per-pixel
> > mipisclk =3D 8 * pclk / num-lanes
>=20
> Unfortunately there are more factors at play depending on what
> features you are using in the ISP. Easiest way for me to describe them
> is to just complete my patches, then we can discuss further.

Do we support any of those features at the moment? If not, then we
shouldn't worry about it too much for now.

Maxime

--=20
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com

--yvty2zhvrtguciro
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlrwCeIACgkQ0rTAlCFN
r3SIXw/8DGSmnFmrh6IjM0ctkL9bBhr4n8PKcCmN9p60vtB5h3MUoa4kq5CjDHnk
Qk6KM1iwQPx9neXQEblBFRiIvf602oYn45WWNrbZyEcU7hWaxFIeUeeZKzt44l+X
FmAq1rm5ETZ0gim9nvImfXK3FXYqpS7U3TdsXAP6CRgFmpE8YoTfC/xMYAs+zZsf
wLcrqmmQo4DrTovud8Kd75iBuzMbs05M8N36nFjAyIALr+u8+ZxstlySJImDUZym
ZAX3CkufexoXBk9ab7QRKZCkomh1RzOhC0De/D+IMJ4mCflS4xBiJtsj8Jq9p4hq
ASTgrIz7EfY0VcfOLyqm89xHYZ7kZURBpr9YqkUp0DNjUcIHEuFlQGxL21CQyMGx
REc70A8evEGrD89vfeMs+Be1pUqmuH7LA3zVuGcXQ6WZwmZQGIcoH3DzNkZJuXDd
OTCofBem+ND6slRZQXxgKMnty1U8cYi0RBCkFN4EODIe0LQJLQrH7ow4VkzUnh5O
aIUjkiFKGIgJhq4qwsWJxX6oFsaJqS/yXD16c+Ipr1im7WVTj5lyu7tQXpQGOFzx
b2ZQn8QZk2A5Q1M/RAd312DSENqZpJR+VlOo8Wdhq9MJ0YvXX+clir15cUdGB4N5
a1lrO7K2mYvKSt5hzdT0ueau3GubtbwSBmwDcyiQohDvbBzttqw=
=BGt1
-----END PGP SIGNATURE-----

--yvty2zhvrtguciro--
