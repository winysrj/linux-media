Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:43538 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933617AbeBMH6k (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Feb 2018 02:58:40 -0500
Date: Tue, 13 Feb 2018 08:58:28 +0100
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Philipp Rossak <embed3d@gmail.com>
Cc: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        wens@csie.org, linux@armlinux.org.uk, sean@mess.org,
        p.zabel@pengutronix.de, andi.shyti@samsung.com,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH v5 0/6] IR support for A83T
Message-ID: <20180213075828.zkm2p67dsr7f6bde@flea.lan>
References: <20180130174656.10657-1-embed3d@gmail.com>
 <a1ce4422-33d7-1214-6527-0d299e97fe8b@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ohxi67qpvujdeuay"
Content-Disposition: inline
In-Reply-To: <a1ce4422-33d7-1214-6527-0d299e97fe8b@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--ohxi67qpvujdeuay
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Philipp,

On Mon, Feb 12, 2018 at 12:00:02PM +0100, Philipp Rossak wrote:
> On 30.01.2018 18:46, Philipp Rossak wrote:
> > This patch series adds support for the sunxi A83T ir module and enhances
> > the sunxi-ir driver. Right now the base clock frequency for the ir driv=
er
> > is a hard coded define and is set to 8 MHz.
> > This works for the most common ir receivers. On the Sinovoip Bananapi M3
> > the ir receiver needs, a 3 MHz base clock frequency to work without
> > problems with this driver.
> >=20
> > This patch series adds support for an optinal property that makes it ab=
le
> > to override the default base clock frequency and enables the ir interfa=
ce
> > on the a83t and the Bananapi M3.
> >=20
> > changes since v4:
> > * rename cir pin from cir_pins to r_cir_pin
> > * drop unit-adress from r_cir_pin
> > * add a83t compatible to the cir node
> > * move muxing options to dtsi
> > * rename cir label and reorder it in the bananpim3.dts file
> >=20
> > changes since v3:
> > * collecting all acks & reviewd by
> > * fixed typos
> >=20
> > changes since v2:
> > * reorder cir pin (alphabetical)
> > * fix typo in documentation
> >=20
> > changes since v1:
> > * fix typos, reword Documentation
> > * initialize 'b_clk_freq' to 'SUNXI_IR_BASE_CLK' & remove if statement
> > * change dev_info() to dev_dbg()
> > * change naming to cir* in dts/dtsi
> > * Added acked Ackedi-by to related patch
> > * use whole memory block instead of registers needed + fix for h3/h5
> >=20
> > changes since rfc:
> > * The property is now optinal. If the property is not available in
> >    the dtb the driver uses the default base clock frequency.
> > * the driver prints out the the selected base clock frequency.
> > * changed devicetree property from base-clk-frequency to clock-frequency
> >=20
> > Regards,
> > Philipp
> >=20
> > Philipp Rossak (6):
> >    media: rc: update sunxi-ir driver to get base clock frequency from
> >      devicetree
> >    media: dt: bindings: Update binding documentation for sunxi IR
> >      controller
> >    arm: dts: sun8i: a83t: Add the cir pin for the A83T
> >    arm: dts: sun8i: a83t: Add support for the cir interface
> >    arm: dts: sun8i: a83t: bananapi-m3: Enable IR controller
> >    arm: dts: sun8i: h3-h5: ir register size should be the whole memory
> >      block
> >=20
> >   Documentation/devicetree/bindings/media/sunxi-ir.txt |  3 +++
> >   arch/arm/boot/dts/sun8i-a83t-bananapi-m3.dts         |  5 +++++
> >   arch/arm/boot/dts/sun8i-a83t.dtsi                    | 18 +++++++++++=
+++++++
> >   arch/arm/boot/dts/sunxi-h3-h5.dtsi                   |  2 +-
> >   drivers/media/rc/sunxi-cir.c                         | 19 +++++++++++=
--------
> >   5 files changed, 38 insertions(+), 9 deletions(-)
> >=20
>=20
> RC1 is now out, thus I would like to ask you to have a look at this patch
> series again. Some patches still miss an acked-by. It would be nice if we
> could schedule this for v4.17.

Just resend it, this will send pretty much the same signal :)

Maxime

--=20
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
http://bootlin.com

--ohxi67qpvujdeuay
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlqCmqMACgkQ0rTAlCFN
r3R62A/9H1I/KC/YWrb3UIHd/cjK9FZ54h/zg99M4hRS6wfle52lNL1ugh7pFqFN
oNZh2ry7abSBJKM4XvmcTjmOOSF0MfMVL6ipCUHmU0hVn1mrsc9wMGwi8z19SM56
EYoSr204adKf5TpMZBOdWvAqJKARucfH1Rhswh2HEaAyf48/h4Pw5g/iI74uq4MD
K/dAbu2kshrVunHWKpmECe7A4CxC+i96TUJg+8x8dsQ0TYdN1C7wSq+lElf83eMD
dWOQZVDrYoKyrg4IqoUb51V+moecbrrGJzt7gk2sP3esukVG2FohgzIHhNOrZKU4
6qQoC5VsRQcQvufK303HCFiMbUSys4iBYkKW57yQkNGlTRvrrKrCj37Cal0xPi1v
XMKwDqBqk4XcmrKuupDlvxdQkTgDoQz7ec0fT5vM11mpQSt0u1vrMMrsupGNK5bg
1lIGTBKK3MNckpdnAO2T9NrATyjGic7ZopZaEbx03ykbQZTS++/xySiY3BHqpjGp
nJvpKgrbA1N/+3T4tyT9ze2mVy2Et1pBICp+JQCEgkhFXrJMbXq6AhXFxdlr0Vcj
pI/ngiR5cJRgpDDnZGSB4JzF3N8J7m6/FIKloRESkwbFIRkVyWRKAH0Wn+skEDrJ
DVvi4j6+42DHF0xjB5pGCO2Lh7F7eh3J8RPZ+02RbQVY4DyYye4=
=aABV
-----END PGP SIGNATURE-----

--ohxi67qpvujdeuay--
