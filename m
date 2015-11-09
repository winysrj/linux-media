Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:38536 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbbKIPdJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Nov 2015 10:33:09 -0500
From: Markus Pargmann <mpa@pengutronix.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	devicetree@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/3] [media] mt9v032: Add reset and standby gpios
Date: Mon, 09 Nov 2015 16:33:03 +0100
Message-ID: <5144598.EqybrDukyg@adelgunde>
In-Reply-To: <1763974.WDKlRvPG0G@avalon>
References: <1446815625-18413-1-git-send-email-mpa@pengutronix.de> <1763974.WDKlRvPG0G@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart4112483.ku7ggmV4iX"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--nextPart4112483.ku7ggmV4iX
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

Hi,

On Monday 09 November 2015 14:28:56 Laurent Pinchart wrote:
> Hi Markus,
>=20
> Thank you for the patch.
>=20
> On Friday 06 November 2015 14:13:43 Markus Pargmann wrote:
> > Add optional reset and standby gpios. The reset gpio is used to res=
et
> > the chip in power_on().
> >=20
> > The standby gpio is not used currently. It is just unset, so the ch=
ip is
> > not in standby.
>=20
> We could use a gpio hog for this, but given that the standby signal s=
hould=20
> eventually get used, and given that specifying it in DT is a good har=
dware=20
> description, that looks good to me.
>=20
> > Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
> > Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
> > ---
> >  .../devicetree/bindings/media/i2c/mt9v032.txt      |  2 ++
> >  drivers/media/i2c/mt9v032.c                        | 23 ++++++++++=
+++++++++
> >  2 files changed, 25 insertions(+)
> >=20
> > diff --git a/Documentation/devicetree/bindings/media/i2c/mt9v032.tx=
t
> > b/Documentation/devicetree/bindings/media/i2c/mt9v032.txt index
> > 202565313e82..100f0ae43269 100644
> > --- a/Documentation/devicetree/bindings/media/i2c/mt9v032.txt
> > +++ b/Documentation/devicetree/bindings/media/i2c/mt9v032.txt
> > @@ -20,6 +20,8 @@ Optional Properties:
> >=20
> >  - link-frequencies: List of allowed link frequencies in Hz. Each f=
requency
> > is expressed as a 64-bit big-endian integer.
> > +- reset-gpios: GPIO handle which is connected to the reset pin of =
the chip.
> > +- standby-gpios: GPIO handle which is connected to the standby pin=
 of the
> > chip.
> >=20
> >  For further reading on port node refer to
> >  Documentation/devicetree/bindings/media/video-interfaces.txt.
> > diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v03=
2.c
> > index a68ce94ee097..4aefde9634f5 100644
> > --- a/drivers/media/i2c/mt9v032.c
> > +++ b/drivers/media/i2c/mt9v032.c
> > @@ -24,6 +24,7 @@
> >  #include <linux/videodev2.h>
> >  #include <linux/v4l2-mediabus.h>
> >  #include <linux/module.h>
> > +#include <linux/gpio/consumer.h>
>=20
> module.h escaped my vigilance, but let's try to keep headers alphabet=
ically=20
> sorted.
> >=20
> >  #include <media/mt9v032.h>
> >  #include <media/v4l2-ctrls.h>
> > @@ -251,6 +252,8 @@ struct mt9v032 {
> >=20
> >  =09struct regmap *regmap;
> >  =09struct clk *clk;
> > +=09struct gpio_desc *reset_gpio;
> > +=09struct gpio_desc *standby_gpio;
> >=20
> >  =09struct mt9v032_platform_data *pdata;
> >  =09const struct mt9v032_model_info *model;
> > @@ -312,16 +315,26 @@ static int mt9v032_power_on(struct mt9v032 *m=
t9v032)
> >  =09struct regmap *map =3D mt9v032->regmap;
> >  =09int ret;
> >=20
> > +=09gpiod_set_value_cansleep(mt9v032->reset_gpio, 1);
> > +
> >  =09ret =3D clk_set_rate(mt9v032->clk, mt9v032->sysclk);
> >  =09if (ret < 0)
> >  =09=09return ret;
> >=20
> > +=09/* system clock has to be enabled before releasing the reset */=

>=20
> Nitpicking, the driver capitalizes the first letter of comments.
>=20
> >  =09ret =3D clk_prepare_enable(mt9v032->clk);
> >  =09if (ret)
> >  =09=09return ret;
> >=20
> >  =09udelay(1);
> >=20
> > +=09gpiod_set_value_cansleep(mt9v032->reset_gpio, 0);
> > +
> > +=09/*
> > +=09 * After releasing reset, it can take up to 1us until the chip =
is done
> > +=09 */
> > +=09udelay(1);
> > +
>=20
> The delay isn't necessary if there's no reset GPIO. How about
>=20
> =09if (mt9v032->reset_gpio) {
> =09=09gpiod_set_value_cansleep(mt9v032->reset_gpio, 0);
>=20
> =09=09/* After releasing reset, it can take up to 1us until the
> =09=09 * chip is done.
> =09=09 */
> =09=09udelay(1);
> =09}
>=20
> And, according to the datasheet, the delay is 10 SYSCLK periods. 1=B5=
s should be=20
> safe as the minimum SYSCLK frequency is 13 MHz. I'd still mention it =
in a=20
> comment, maybe as
>=20
> =09=09/* After releasing reset we need to wait 10 clock cycles
> =09=09 * before accessing the sensor over I2C. As the minimum SYSCLK
> =09=09 * frequency is 13MHz, waiting 1=B5s will be enough in the wors=
t
> =09=09 * case.
> =09=09 */
> =09=09udelay(1);
>=20
> If you're fine with these changes there's no need to resubmit the pat=
ch, I can=20
> fix it when applying it to my tree.

Thanks, I am fine with all your changes. But as there will be a v2 for =
the
other two patches I could as well send an updated version if you wish.

Thanks,

Markus

=2D-=20
Pengutronix e.K.                           |                           =
  |
Industrial Linux Solutions                 | http://www.pengutronix.de/=
  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0  =
  |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-555=
5 |

--nextPart4112483.ku7ggmV4iX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJWQLyvAAoJEEpcgKtcEGQQuyYP/jIbG4uu4ZRQ4o2sedz2rIoH
/7Lr+vBBtCgUNxnitdXxPb9TTEBFtHU9bnl69ySV1K4z/6m2V2TvxQhunsS0goxr
K0rtpZfeWelLzHMB/BRWW7Qmv1wi52+jVGMC+RaeWX8kiMN9IE3sZ7lvSmmqIp2q
YzY3dZOD1tI7zd7GGrzwV7PueuczeZyFqXE9/dRDrvR1y99E56RHsa4SUvAtrnCK
H0F7A2MGEDAaZeM9dpXHnXFKFKMz/v5LdCpTHrGnIt17Usgn82sjFahZTzkcQ4C1
hNns8tTR7pmRNPpEcbEVTqC6KF/1YGizIPYFQVZr39oiIF9mgprmvnKRY68vq8uO
6p0Ey+Z8P/qFIods+X1FJnj7/29sfN41RddK5yzSIcUO0PVP883NQCkjI97QZNMa
mxoF2Y7oZIv1ISI6V8yfPGub7Anc+5+53EdEv4YmQqDTwv0zXdolKmH9B174YNww
HV1a9OuKEe046lSKZDN2LdA3pCsv16nDtAq0wf4QwznJo2a93Gvl9KFiO9PT3+DY
4eYzwb6NVKWAILHBANtDxD1geC8He4GRCu14Cgatf+7NHJIUxyEPDFlvSsOUWsQr
zm+9FuaLGT8dtSwoSXClAyD4AS1e2u3cVp7TX76mcjYy1oKENylYSHQdpfz5upV5
BsNvo0e1UtZ2B/U4aMgm
=bklL
-----END PGP SIGNATURE-----

--nextPart4112483.ku7ggmV4iX--

