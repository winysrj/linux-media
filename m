Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:58074 "EHLO
	metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753314AbbLOJNX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Dec 2015 04:13:23 -0500
From: Markus Pargmann <mpa@pengutronix.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	devicetree@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 1/3] [media] mt9v032: Add reset and standby gpios
Date: Tue, 15 Dec 2015 10:13:18 +0100
Message-ID: <2909716.jMugkd1BEg@adelgunde>
In-Reply-To: <1538607.GEJzzOouog@avalon>
References: <1450104113-6392-1-git-send-email-mpa@pengutronix.de> <1538607.GEJzzOouog@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart11710089.RDNQYzyMTx"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--nextPart11710089.RDNQYzyMTx
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

Hi,

On Monday 14 December 2015 21:26:25 Laurent Pinchart wrote:
> Hi Markus,
>=20
> Thank you for the patch.
>=20
> On Monday 14 December 2015 15:41:51 Markus Pargmann wrote:
> > Add optional reset and standby gpios. The reset gpio is used to res=
et
> > the chip in power_on().
> >=20
> > The standby gpio is not used currently. It is just unset, so the ch=
ip is
> > not in standby.
> >=20
> > Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
> > Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
> > Acked-by: Rob Herring <robh@kernel.org>
> > ---
> >  .../devicetree/bindings/media/i2c/mt9v032.txt      |  2 ++
> >  drivers/media/i2c/mt9v032.c                        | 28 ++++++++++=
+++++++++
> >  2 files changed, 30 insertions(+)
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
> > index a68ce94ee097..c1bc564a0979 100644
> > --- a/drivers/media/i2c/mt9v032.c
> > +++ b/drivers/media/i2c/mt9v032.c
> > @@ -14,6 +14,7 @@
> >=20
> >  #include <linux/clk.h>
> >  #include <linux/delay.h>
> > +#include <linux/gpio/consumer.h>
> >  #include <linux/i2c.h>
> >  #include <linux/log2.h>
> >  #include <linux/mutex.h>
> > @@ -251,6 +252,8 @@ struct mt9v032 {
> >=20
> >  =09struct regmap *regmap;
> >  =09struct clk *clk;
> > +=09struct gpio_desc *reset_gpio;
> > +=09struct gpio_desc *standby_gpio;
> >=20
> >  =09struct mt9v032_platform_data *pdata;
> >  =09const struct mt9v032_model_info *model;
> > @@ -312,16 +315,31 @@ static int mt9v032_power_on(struct mt9v032 *m=
t9v032)
> >  =09struct regmap *map =3D mt9v032->regmap;
> >  =09int ret;
> >=20
> > +=09if (mt9v032->reset_gpio)
> > +=09=09gpiod_set_value_cansleep(mt9v032->reset_gpio, 1);
> > +
>=20
> gpiod_set_value_cansleep() already checks whether the gpiod is NULL, =
you don't=20
> need to duplicate the check here.
>=20
> Apart from that,
>=20
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>=20
> No need to resubmit I'll fix this when applying.

Ok, thank you.

Best Regards,

Markus

>=20
> >  =09ret =3D clk_set_rate(mt9v032->clk, mt9v032->sysclk);
> >  =09if (ret < 0)
> >  =09=09return ret;
> >=20
> > +=09/* System clock has to be enabled before releasing the reset */=

> >  =09ret =3D clk_prepare_enable(mt9v032->clk);
> >  =09if (ret)
> >  =09=09return ret;
> >=20
> >  =09udelay(1);
> >=20
> > +=09if (mt9v032->reset_gpio) {
> > +=09=09gpiod_set_value_cansleep(mt9v032->reset_gpio, 0);
> > +
> > +=09=09/* After releasing reset we need to wait 10 clock cycles
> > +=09=09 * before accessing the sensor over I2C. As the minimum SYSC=
LK
> > +=09=09 * frequency is 13MHz, waiting 1=B5s will be enough in the w=
orst
> > +=09=09 * case.
> > +=09=09 */
> > +=09=09udelay(1);
> > +=09}
> > +
> >  =09/* Reset the chip and stop data read out */
> >  =09ret =3D regmap_write(map, MT9V032_RESET, 1);
> >  =09if (ret < 0)
> > @@ -954,6 +972,16 @@ static int mt9v032_probe(struct i2c_client *cl=
ient,
> >  =09if (IS_ERR(mt9v032->clk))
> >  =09=09return PTR_ERR(mt9v032->clk);
> >=20
> > +=09mt9v032->reset_gpio =3D devm_gpiod_get_optional(&client->dev, "=
reset",
> > +=09=09=09=09=09=09      GPIOD_OUT_HIGH);
> > +=09if (IS_ERR(mt9v032->reset_gpio))
> > +=09=09return PTR_ERR(mt9v032->reset_gpio);
> > +
> > +=09mt9v032->standby_gpio =3D devm_gpiod_get_optional(&client->dev,=
 "standby",
> > +=09=09=09=09=09=09=09GPIOD_OUT_LOW);
> > +=09if (IS_ERR(mt9v032->standby_gpio))
> > +=09=09return PTR_ERR(mt9v032->standby_gpio);
> > +
> >  =09mutex_init(&mt9v032->power_lock);
> >  =09mt9v032->pdata =3D pdata;
> >  =09mt9v032->model =3D (const void *)did->driver_data;
>=20
>=20

=2D-=20
Pengutronix e.K.                           |                           =
  |
Industrial Linux Solutions                 | http://www.pengutronix.de/=
  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0  =
  |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-555=
5 |

--nextPart11710089.RDNQYzyMTx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJWb9muAAoJEEpcgKtcEGQQDJgP/1ULE7n71LIYlqWtDibLJzit
T6rhl5DZpKRttqKLnDOZpYi1C4w61BMjwecrurP2Oe4ctSIOldG+vNt1Rry0Md8G
zhAIRYkAAEt3l3+8XUgZl48QAvjoazQpQocwvU1ant2K5tetwoCvZ3Szd1ui4miL
b6R5dlYzVMdzPLRhBgq3P6HXmzdyK5f+4BHtwC9ikBrjHja/ZCI5TPelDFSy5zJP
cx7PNEnejzJOu67UXBGOV2mjM6VbAuoIRCXCUbDIYxUnAlnWxeNBtC9y1SlFpCUB
0JVAs5GCH8ogi9Bx71nLnot2XUFvv2io7+/CAzIXLW2+8EhKXOyHspM1LCc2sUPz
+qQVtrzQc/UqCHfJE1aHki3Duuq/HxdDNCDD/TY8toKura9CEddMsumi9BC6vgZb
pfNv5pBYBdeyV7M5Xr4l6cfj8pmI2qfoZB4TP3HiiyhrULDkYeuStCeAvZFQ8rrw
qbDD5ndHO0KNlyq31OGRq4vBsBCSnxzfLL9VL0GJ4M/6t393mM27/sMZmsVB5fhO
9Gn1vpPf4Lk71+a7/JQmCBGwdJMIbUrwYYneGI9X6BZbIct9kffXv0/adsJD2lL7
mACNj/HyeCdgZcpNhIVGFc+sYYNPvlJ/nBauZPOVbB8RvgJemaXVJkc7TUXqa2P7
oMkZYHdcVse78EcZb02J
=j2v9
-----END PGP SIGNATURE-----

--nextPart11710089.RDNQYzyMTx--

