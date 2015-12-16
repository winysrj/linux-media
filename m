Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:47316 "EHLO
	metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965728AbbLPKOl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Dec 2015 05:14:41 -0500
From: Markus Pargmann <mpa@pengutronix.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	devicetree@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 3/3] [media] mt9v032: Add V4L2 controls for AEC and AGC
Date: Wed, 16 Dec 2015 11:14:28 +0100
Message-ID: <2570493.HaAAxn7ErG@adelgunde>
In-Reply-To: <290053152.GcUooHzFZY@avalon>
References: <1450104113-6392-1-git-send-email-mpa@pengutronix.de> <1450104113-6392-3-git-send-email-mpa@pengutronix.de> <290053152.GcUooHzFZY@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart43950959.ZmiIeT8nBD"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--nextPart43950959.ZmiIeT8nBD
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"

Hi Laurent,

On Wednesday 16 December 2015 09:47:58 Laurent Pinchart wrote:
> Hi Markus,
>=20
> Thank you for the patch.
>=20
> On Monday 14 December 2015 15:41:53 Markus Pargmann wrote:
> > This patch adds V4L2 controls for Auto Exposure Control and Auto Ga=
in
> > Control settings. These settings include low pass filter, update
> > frequency of these settings and the update interval for those units=
.
> >=20
> > Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
>=20
> Please see below for a few comments. If you agree about them there's =
no need=20
> to resubmit, I'll fix the patch when applying.

Most of them are fine, I commented on the open ones.

>=20
> > ---
> >  drivers/media/i2c/mt9v032.c | 153 ++++++++++++++++++++++++++++++++=
++++++++-
> >  1 file changed, 152 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v03=
2.c
> > index cc16acf001de..6cbc3b87eda9 100644
> > --- a/drivers/media/i2c/mt9v032.c
> > +++ b/drivers/media/i2c/mt9v032.c
>=20
> [snip]
>=20
> >  enum mt9v032_model {
> > @@ -162,6 +169,8 @@ struct mt9v032_model_data {
> >  =09unsigned int min_shutter;
> >  =09unsigned int max_shutter;
> >  =09unsigned int pclk_reg;
> > +=09unsigned int aec_max_shutter_reg;
> > +=09const struct v4l2_ctrl_config * const aec_max_shutter_v4l2_ctrl=
;
> >  };
> >=20
> >  struct mt9v032_model_info {
> > @@ -175,6 +184,9 @@ static const struct mt9v032_model_version
> > mt9v032_versions[] =3D { { MT9V034_CHIP_ID_REV1, "MT9V024/MT9V034 r=
ev1" },
> >  };
> >=20
> > +static const struct v4l2_ctrl_config mt9v032_aec_max_shutter_width=
;
> > +static const struct v4l2_ctrl_config mt9v034_aec_max_shutter_width=
;
>=20
> We can avoid forward declarations by moving the mt9v032_model_data ar=
ray=20
> further down in the driver.
>=20
> >  static const struct mt9v032_model_data mt9v032_model_data[] =3D {
> >  =09{
> >  =09=09/* MT9V022, MT9V032 revisions 1/2/3 */
>=20
> [snip]
>=20
> > @@ 647,6 +663,33 @@ static int mt9v032_set_selection(struct v4l2_su=
bdev
> > *subdev, */
> >=20
> >  #define V4L2_CID_TEST_PATTERN_COLOR=09(V4L2_CID_USER_BASE | 0x1001=
)
> > +/*
> > + * Value between 1 and 64 to set the desired bin. This is effectiv=
ely a
> > measure + * of how bright the image is supposed to be. Both AGC and=
 AEC try
> > to reach + * this.
> > + */
> > +#define V4L2_CID_AEGC_DESIRED_BIN=09=09(V4L2_CID_USER_BASE | 0x100=
2)
> > +/*
> > + * LPF is the low pass filter capability of the chip. Both AEC and=
 AGC have
> > + * this setting. This limits the speed in which AGC/AEC adjust the=
ir
> > settings.
> > + * Possible values are 0-2. 0 means no LPF. For 1 and 2 this equat=
ion is
> > used:
> > + * =09if |(Calculated new exp - current exp)| > (current exp / 4)
> > + * =09=09next exp =3D Calculated new exp
> > + * =09else
> > + * =09=09next exp =3D Current exp + ((Calculated new exp - current=
 exp) /=20
> 2^LPF)
>=20
> Over 80 columns, you can fix it by just reducing the indentation by o=
ne tab.
>=20
> > + */
> > +#define V4L2_CID_AEC_LPF=09=09(V4L2_CID_USER_BASE | 0x1003)
> > +#define V4L2_CID_AGC_LPF=09=09(V4L2_CID_USER_BASE | 0x1004)
> > +/*
> > + * Value between 0 and 15. This is the number of frames being skip=
ped
> > before
> > + * updating the auto exposure/gain.
> > + */
> > +#define V4L2_CID_AEC_UPDATE_INTERVAL=09(V4L2_CID_USER_BASE | 0x100=
5)
> > +#define V4L2_CID_AGC_UPDATE_INTERVAL=09(V4L2_CID_USER_BASE | 0x100=
6)
> > +/*
> > + * Maximum shutter width used for AEC.
> > + */
> > +#define V4L2_CID_AEC_MAX_SHUTTER_WIDTH=09(V4L2_CID_USER_BASE | 0x1=
007)
>=20
> [snip]
>=20
> > @@ -745,6 +810,84 @@ static const struct v4l2_ctrl_config
> > mt9v032_test_pattern_color =3D { .flags=09=09=3D 0,
> >  };
> >=20
> > +static const struct v4l2_ctrl_config mt9v032_aegc_controls[] =3D {=

> > +=09{
> > +=09=09.ops=09=09=3D &mt9v032_ctrl_ops,
> > +=09=09.id=09=09=3D V4L2_CID_AEGC_DESIRED_BIN,
> > +=09=09.type=09=09=3D V4L2_CTRL_TYPE_INTEGER,
> > +=09=09.name=09=09=3D "aec_agc_desired_bin",
>=20
> I forgot to reply to your e-mail asking what proper controls names wo=
uld be,=20
> sorry.
>=20
> V4L2 control names contain spaces and use uppercase as needed. This o=
ne could=20
> be "AEC/AGC Desired Bin" for instance.

Ah I see. I was just wondering as v4l2-ctl showed everything with lower=
case
letters and underscores. But with a closer look it seems something betw=
een
driver and v4l2-ctl translates them from uppercase/spaces to
lowercase/underscores. So yes that's fine then and makes sense.

>=20
> > +=09=09.min=09=09=3D 1,
> > +=09=09.max=09=09=3D 64,
> > +=09=09.step=09=09=3D 1,
> > +=09=09.def=09=09=3D 58,
> > +=09=09.flags=09=09=3D 0,
> > +=09}, {
> > +=09=09.ops=09=09=3D &mt9v032_ctrl_ops,
> > +=09=09.id=09=09=3D V4L2_CID_AEC_LPF,
> > +=09=09.type=09=09=3D V4L2_CTRL_TYPE_INTEGER,
> > +=09=09.name=09=09=3D "aec_lpf",
> > +=09=09.min=09=09=3D 0,
> > +=09=09.max=09=09=3D 2,
> > +=09=09.step=09=09=3D 1,
> > +=09=09.def=09=09=3D 0,
> > +=09=09.flags=09=09=3D 0,
> > +=09}, {
> > +=09=09.ops=09=09=3D &mt9v032_ctrl_ops,
> > +=09=09.id=09=09=3D V4L2_CID_AGC_LPF,
> > +=09=09.type=09=09=3D V4L2_CTRL_TYPE_INTEGER,
> > +=09=09.name=09=09=3D "agc_lpf",
> > +=09=09.min=09=09=3D 0,
> > +=09=09.max=09=09=3D 2,
> > +=09=09.step=09=09=3D 1,
> > +=09=09.def=09=09=3D 2,
> > +=09=09.flags=09=09=3D 0,
> > +=09}, {
> > +=09=09.ops=09=09=3D &mt9v032_ctrl_ops,
> > +=09=09.id=09=09=3D V4L2_CID_AEC_UPDATE_INTERVAL,
> > +=09=09.type=09=09=3D V4L2_CTRL_TYPE_INTEGER,
> > +=09=09.name=09=09=3D "aec_update_interval",
> > +=09=09.min=09=09=3D 0,
> > +=09=09.max=09=09=3D 16,
> > +=09=09.step=09=09=3D 1,
> > +=09=09.def=09=09=3D 2,
> > +=09=09.flags=09=09=3D 0,
> > +=09}, {
> > +=09=09.ops=09=09=3D &mt9v032_ctrl_ops,
> > +=09=09.id=09=09=3D V4L2_CID_AGC_UPDATE_INTERVAL,
> > +=09=09.type=09=09=3D V4L2_CTRL_TYPE_INTEGER,
> > +=09=09.name=09=09=3D "agc_update_interval",
> > +=09=09.min=09=09=3D 0,
> > +=09=09.max=09=09=3D 16,
> > +=09=09.step=09=09=3D 1,
> > +=09=09.def=09=09=3D 2,
> > +=09=09.flags=09=09=3D 0,
> > +=09}
> > +};
> > +
> > +static const struct v4l2_ctrl_config mt9v032_aec_max_shutter_width=
 =3D {
> > +=09.ops=09=09=3D &mt9v032_ctrl_ops,
> > +=09.id=09=09=3D V4L2_CID_AEC_MAX_SHUTTER_WIDTH,
> > +=09.type=09=09=3D V4L2_CTRL_TYPE_INTEGER,
> > +=09.name=09=09=3D "aec_max_shutter_width",
> > +=09.min=09=09=3D 1,
> > +=09.max=09=09=3D MT9V032_TOTAL_SHUTTER_WIDTH_MAX,
>=20
> According the the MT9V032 datasheet I have, the maximum value is 2047=
 while=20
> MT9V032_TOTAL_SHUTTER_WIDTH_MAX is defined as 32767. Do you have any=20=

> information that would hint for an error in the datasheet ?

The register is defined as having 15 bits. I simply assumed that the al=
ready
defined TOTAL_SHUTTER_WIDTH_MAX would apply for this register as well. =
At least
it should end up controlling the same property of the chip. I didn't te=
st this
on mt9v032 but on mt9v024.

Thanks,

Markus

>=20
> > +=09.step=09=09=3D 1,
> > +=09.def=09=09=3D MT9V032_TOTAL_SHUTTER_WIDTH_DEF,
> > +=09.flags=09=09=3D 0,
> > +};
> > +
> > +static const struct v4l2_ctrl_config mt9v034_aec_max_shutter_width=
 =3D {
> > +=09.ops=09=09=3D &mt9v032_ctrl_ops,
> > +=09.id=09=09=3D V4L2_CID_AEC_MAX_SHUTTER_WIDTH,
> > +=09.type=09=09=3D V4L2_CTRL_TYPE_INTEGER,
> > +=09.name=09=09=3D "aec_max_shutter_width",
> > +=09.min=09=09=3D 1,
> > +=09.max=09=09=3D MT9V034_TOTAL_SHUTTER_WIDTH_MAX,
> > +=09.step=09=09=3D 1,
> > +=09.def=09=09=3D MT9V032_TOTAL_SHUTTER_WIDTH_DEF,
> > +=09.flags=09=09=3D 0,
> > +};
>=20
> [snip]
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

--nextPart43950959.ZmiIeT8nBD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJWcTmJAAoJEEpcgKtcEGQQCiIQAJk3UNAvSB2SVTTSCPtBMn6h
mjNnGQY5DejCisEb8PdUsdwhyDc/QyNbnuE6K9MnmmHMXt6vKB8ebmoDr4HRBePj
knnaegSpE+B7EwlDlyDjNAY9KRJQNIK81BTo+UTdnAOmf0ywILXvyZ9+3Kp8Szqe
opShZFKDpBIYWmWZ9Y8fTm1wIUtqt/bOYEigxfnMleHqOu/ft3r94LHQLct6kt4w
hA7GJ4yszGRVOjQg5Vy6iPR2InEFyu3az4PX+x2lH6QoTEWiMjEL8+wgkOc6xk0i
FcmepWwlRnhCjTLRIsKtBdDPO1p2r0w5WoL/UpQc1TQy86gtQxtCqPhzRaOTX8np
NwxBc882JmTzTT6Buo4vyf7G9z3YNbXq5st8F8CUnFnu3XfdCcBxyg6orQpNyJkJ
GfkQk9BjMzep0BOGMJhlPx2ZfGI738fkWIZXOBRWareAQWmgFmqTDTwB6x1cE3n5
KlqPdiCSFx50HhhwuydEVhjVx3ryyuEbipMUITMqnF0shx4wK10t44nt617nNg72
Ow5bQTC+JlwPrjI5sTZ40DMgeRzLY1wESg68etLLTGSHhFuJLKhztzWJ9eKqu67q
9bwQlGr19tNIy0o2RE1nFwtZITMQqJaX8b3U3RWsCqlGQBdz5y0AahLlJq1OVrB9
KgQtuRQN0MTZKX8QXPuq
=kkUp
-----END PGP SIGNATURE-----

--nextPart43950959.ZmiIeT8nBD--

