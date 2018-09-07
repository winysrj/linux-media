Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:42421 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727752AbeIGSEW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Sep 2018 14:04:22 -0400
Date: Fri, 7 Sep 2018 15:23:11 +0200
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Yong Deng <yong.deng@magewell.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Jacob Chen <jacob-chen@iotwrt.com>,
        Yannick Fertre <yannick.fertre@st.com>,
        Thierry Reding <treding@nvidia.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Todor Tomov <todor.tomov@linaro.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>
Subject: Re: [PATCH v10 0/2] Initial Allwinner V3s CSI Support
Message-ID: <20180907132311.g7q3zzziiagqecae@flea>
References: <20180517090224.u3ygdzjr77im2mmp@flea>
 <20180529095757.qkz7jyuxza7movbc@flea.home>
 <20180530091934.tbd6xbyr5s3ipn3v@paasikivi.fi.intel.com>
 <CAGb2v67RP8bjObBJu_1JsREUo64hnEzptG_n-aYMn4Dcd_Zo-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="76ixmv7qtsguwevu"
Content-Disposition: inline
In-Reply-To: <CAGb2v67RP8bjObBJu_1JsREUo64hnEzptG_n-aYMn4Dcd_Zo-g@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--76ixmv7qtsguwevu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Yong,

On Wed, Jun 20, 2018 at 12:45:03PM +0800, Chen-Yu Tsai wrote:
> On Wed, May 30, 2018 at 5:19 PM, Sakari Ailus
> <sakari.ailus@linux.intel.com> wrote:
> > On Tue, May 29, 2018 at 11:57:57AM +0200, Maxime Ripard wrote:
> >> On Thu, May 17, 2018 at 11:02:24AM +0200, Maxime Ripard wrote:
> >> > On Fri, May 04, 2018 at 02:44:08PM +0800, Yong Deng wrote:
> >> > > This patchset add initial support for Allwinner V3s CSI.
> >> > >
> >> > > Allwinner V3s SoC features two CSI module. CSI0 is used for MIPI C=
SI-2
> >> > > interface and CSI1 is used for parallel interface. This is not
> >> > > documented in datasheet but by test and guess.
> >> > >
> >> > > This patchset implement a v4l2 framework driver and add a binding
> >> > > documentation for it.
> >> > >
> >> > > Currently, the driver only support the parallel interface. And has=
 been
> >> > > tested with a BT1120 signal which generating from FPGA. The follow=
ing
> >> > > fetures are not support with this patchset:
> >> > >   - ISP
> >> > >   - MIPI-CSI2
> >> > >   - Master clock for camera sensor
> >> > >   - Power regulator for the front end IC
> >> >
> >> > I tested it on my H3 with a parallel camera, and it still works. Tha=
nks!
> >> >
> >> > Hans, Sakari, any chance this might land in 4.18?
> >>
> >> Ping?
> >
> > I'll try to look into this soonish but it seems to be too late for 4.18.
> > Sorry about that.
>=20
> Can we get this into 4.19?

Did you have some time to make the changes Sakari asked for? That
would be great to have it in 4.20.

Thanks!
Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--76ixmv7qtsguwevu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAluSe78ACgkQ0rTAlCFN
r3QLTQ//cPVrtXJ+bCSWc2Y96Chm2fymit3kl60M173YzsG+JlPwp5/in1ZMGzTr
U6aAuc6Tzd1zz6p33ZqDLAzGIjssfzdBnmUGCG41n7Gq4ktV95HUeX8p++9HEXTE
425+hNFkOdOqBMC9FscWyDqh2Fc6uPyWLAk6JFxgPIrcnpjFsfRGmkELc69B2YXa
7MKYEBEnFLGW70AtYtWPxasnF7uz2oMh1JGjyZ2c5dSyibnrL3xZhsc7JCXPLHPw
wtvkdUDVaigGZn074Je4tFqpPTwjq7DdhbXi3VQ2Q7i4sH0P4uzaDPKM0laqQJmL
E8CDsB1MCNTs+lpq3RqC9cAwHz9AmysnTv3sDkcO49RXXh7OF5Witl7syHk7ORje
oIQytG9CsNU91AAZjeOp4MHLC43rG/vZWq6HRonqCBzhwlyWTW1z5wJ1dTeja01Y
I/fUD+OBZcdykXwZcVYCEkxbfu71ro41lwonBn0qW6xM2+9PQGIEz6V5iS81YeLe
Uv8oyfzv/fSQvsOESgyJ4UEFpGDEC8CWX9JfVHjHwQUJClEk46aSh6i2PqjikdqY
rBEx2TB1EJ+aWDXYcxtCx8PQT/MsKQTxgdeMBKu96Ruc9H4vymKzMNYxYC//2pnY
pKGjFyvCaXm6XLKntdDgm5PeYs9rKB2dYgH5KzZlBwZo6tj8zsU=
=3pmh
-----END PGP SIGNATURE-----

--76ixmv7qtsguwevu--
