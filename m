Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:58716 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbbKIPZH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Nov 2015 10:25:07 -0500
From: Markus Pargmann <mpa@pengutronix.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	devicetree@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 3/3] [media] mt9v032: Add V4L2 controls for AEC and AGC
Date: Mon, 09 Nov 2015 16:25:02 +0100
Message-ID: <1989986.1Gm0BIcqZh@adelgunde>
In-Reply-To: <2275245.3FVoKjERuu@avalon>
References: <1446815625-18413-1-git-send-email-mpa@pengutronix.de> <1446815625-18413-3-git-send-email-mpa@pengutronix.de> <2275245.3FVoKjERuu@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart15407594.kZAmgy15iS"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--nextPart15407594.kZAmgy15iS
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"

Hi,

On Monday 09 November 2015 15:22:06 Laurent Pinchart wrote:
> Hi Markus,
>=20
> Thank you for the patch.
>=20
> On Friday 06 November 2015 14:13:45 Markus Pargmann wrote:
> > This patch adds V4L2 controls for Auto Exposure Control and Auto Ga=
in
> > Control settings. These settings include low pass filter, update
> > frequency of these settings and the update interval for those units=
.
> >=20
> > Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
> > ---
> >  drivers/media/i2c/mt9v032.c | 153 ++++++++++++++++++++++++++++++++=
+++++++++
> >  1 file changed, 153 insertions(+)
> >=20
> > diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v03=
2.c
> > index 943c3f39ea73..978ae8cbb0cc 100644
> > --- a/drivers/media/i2c/mt9v032.c
> > +++ b/drivers/media/i2c/mt9v032.c
> > @@ -133,9 +133,16 @@
> >  #define=09=09MT9V032_TEST_PATTERN_GRAY_DIAGONAL=09(3 << 11)
> >  #define=09=09MT9V032_TEST_PATTERN_ENABLE=09=09(1 << 13)
> >  #define=09=09MT9V032_TEST_PATTERN_FLIP=09=09(1 << 14)
> > +#define MT9V032_AEC_LPF=09=09=09=09=090xa8
> > +#define MT9V032_AGC_LPF=09=09=09=09=090xaa
> > +#define MT9V032_DESIRED_BIN=09=09=09=090xa5
>=20
> To better match the datasheet, could you call this MT9V032_AEGC_DESIR=
ED_BIN ?=20
> Same comment for the related control name.

Ok, fixed for next version.

>=20
> > +#define MT9V032_AEC_UPDATE_INTERVAL=09=09=090xa6
> > +#define MT9V032_AGC_UPDATE_INTERVAL=09=09=090xa9
>=20
> Simalarly I'd call these two registers MT9V032_AEC_UPDATE_FREQUENCY a=
nd=20
> MT9V032_AGC_UPDATE_FREQUENCY as that's how they're named in the datas=
heet (at=20
> least the version I have). It makes sense to keep using interval in t=
he=20
> control names though, as that's how they operate.

Yes they are called differently, fixed.

>=20
> Could you please keep the registers sorted numerically ?

Yes sorry.

>=20
> >  #define MT9V032_AEC_AGC_ENABLE=09=09=09=090xaf
> >  #define=09=09MT9V032_AEC_ENABLE=09=09=09(1 << 0)
> >  #define=09=09MT9V032_AGC_ENABLE=09=09=09(1 << 1)
> > +#define MT9V024_AEC_MAX_SHUTTER_WIDTH=09=09=090xad
>=20
> As other registers specific to the MT9V024 and MT9V034 use the MT9V03=
4 prefix,=20
> could you do so here as well ?

Yes, fixed.

>=20
> Would it make sense to add the minimum shutter width too ?

Yes perhaps, I personally just needed the extra exposure to get the ima=
ge
brighter. However I don't have any information about the minimum regist=
er. For
mt9v032 this seems to be hardwired to 1 and for mt9v024 this is just me=
ntioned
in text without further information.

>=20
> > +#define MT9V032_AEC_MAX_SHUTTER_WIDTH=09=09=090xbd
> >  #define MT9V032_THERMAL_INFO=09=09=09=090xc1
> >=20
> >  enum mt9v032_model {
> > @@ -162,6 +169,7 @@ struct mt9v032_model_data {
> >  =09unsigned int min_shutter;
> >  =09unsigned int max_shutter;
> >  =09unsigned int pclk_reg;
> > +=09unsigned int aec_max_shutter_reg;
> >  };
> >=20
> >  struct mt9v032_model_info {
> > @@ -185,6 +193,7 @@ static const struct mt9v032_model_data
> > mt9v032_model_data[] =3D { .min_shutter =3D MT9V032_TOTAL_SHUTTER_W=
IDTH_MIN,
> >  =09=09.max_shutter =3D MT9V032_TOTAL_SHUTTER_WIDTH_MAX,
> >  =09=09.pclk_reg =3D MT9V032_PIXEL_CLOCK,
> > +=09=09.aec_max_shutter_reg =3D MT9V032_AEC_MAX_SHUTTER_WIDTH,
> >  =09}, {
> >  =09=09/* MT9V024, MT9V034 */
> >  =09=09.min_row_time =3D 690,
> > @@ -194,6 +203,7 @@ static const struct mt9v032_model_data
> > mt9v032_model_data[] =3D { .min_shutter =3D MT9V034_TOTAL_SHUTTER_W=
IDTH_MIN,
> >  =09=09.max_shutter =3D MT9V034_TOTAL_SHUTTER_WIDTH_MAX,
> >  =09=09.pclk_reg =3D MT9V034_PIXEL_CLOCK,
> > +=09=09.aec_max_shutter_reg =3D MT9V024_AEC_MAX_SHUTTER_WIDTH,
> >  =09},
> >  };
> >=20
> > @@ -265,6 +275,12 @@ struct mt9v032 {
> >  =09struct {
> >  =09=09struct v4l2_ctrl *test_pattern;
> >  =09=09struct v4l2_ctrl *test_pattern_color;
> > +=09=09struct v4l2_ctrl *desired_bin;
> > +=09=09struct v4l2_ctrl *aec_lpf;
> > +=09=09struct v4l2_ctrl *agc_lpf;
> > +=09=09struct v4l2_ctrl *aec_update_interval;
> > +=09=09struct v4l2_ctrl *agc_update_interval;
> > +=09=09struct v4l2_ctrl *aec_max_shutter_width;
>=20
> You don't need to store all those controls in the mt9v032 structure a=
s you=20
> don't use the pointers anywhere. The reason why the test_pattern and=20=

> test_pattern_color controls are stored there is that they both affect=
 the same=20
> register and are thus grouped into a control cluster.

Thanks, indeed, removed.

>=20
> >  =09};
> >  };
> >=20
> > @@ -643,6 +659,33 @@ static int mt9v032_set_selection(struct v4l2_s=
ubdev
> > *subdev, */
> >=20
> >  #define V4L2_CID_TEST_PATTERN_COLOR=09(V4L2_CID_USER_BASE | 0x1001=
)
> > +/*
> > + * Value between 1 and 64 to set the desired bin. This is effectiv=
ely a
> > measure
> > + * of how bright the image is supposed to be. Both AGC and AEC try=
 to reach
> > + * this.
> > + */
>=20
> Do you know what the value represents exactly ? Does it have a linear=
=20
> relationship with the overall image luminance ? Is it related to imag=
e binning=20
> at all ?

It seems to be the 'row-time'. So it should be a linear relationship to=
 the
overall exposure time.

>=20
> > +#define V4L2_CID_DESIRED_BIN=09=09(V4L2_CID_USER_BASE | 0x1002)
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
> > + * =09=09next exp =3D Current exp +- (Calculated new exp / 2^LPF)
>=20
> I know this comes directly from the datasheet, but it doesn't make to=
o much=20
> sense to me. I wonder whether the correct formula wouldn't be
>=20
> next exp =3D current exp + ((calculated new exp - current exp) / 2^LP=
F)

Yes exactly, thanks.

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
> >=20
> >  static int mt9v032_s_ctrl(struct v4l2_ctrl *ctrl)
> >  {
> > @@ -712,6 +755,28 @@ static int mt9v032_s_ctrl(struct v4l2_ctrl *ct=
rl)
> >  =09=09=09break;
> >  =09=09}
> >  =09=09return regmap_write(map, MT9V032_TEST_PATTERN, data);
> > +
> > +=09case V4L2_CID_DESIRED_BIN:
> > +=09=09return regmap_write(map, MT9V032_DESIRED_BIN, ctrl->val);
> > +
> > +=09case V4L2_CID_AEC_LPF:
> > +=09=09return regmap_write(map, MT9V032_AEC_LPF, ctrl->val);
> > +
> > +=09case V4L2_CID_AGC_LPF:
> > +=09=09return regmap_write(map, MT9V032_AGC_LPF, ctrl->val);
> > +
> > +=09case V4L2_CID_AEC_UPDATE_INTERVAL:
> > +=09=09return regmap_write(map, MT9V032_AEC_UPDATE_INTERVAL,
> > +=09=09=09=09    ctrl->val);
> > +
> > +=09case V4L2_CID_AGC_UPDATE_INTERVAL:
> > +=09=09return regmap_write(map, MT9V032_AGC_UPDATE_INTERVAL,
> > +=09=09=09=09    ctrl->val);
> > +
> > +=09case V4L2_CID_AEC_MAX_SHUTTER_WIDTH:
> > +=09=09return regmap_write(map,
> > +=09=09=09=09    mt9v032->model->data->aec_max_shutter_reg,
> > +=09=09=09=09    ctrl->val);
> >  =09}
> >=20
> >  =09return 0;
> > @@ -741,6 +806,78 @@ static const struct v4l2_ctrl_config
> > mt9v032_test_pattern_color =3D { .flags=09=09=3D 0,
> >  };
> >=20
> > +static const struct v4l2_ctrl_config mt9v032_desired_bin =3D {
> > +=09.ops=09=09=3D &mt9v032_ctrl_ops,
> > +=09.id=09=09=3D V4L2_CID_DESIRED_BIN,
> > +=09.type=09=09=3D V4L2_CTRL_TYPE_INTEGER,
> > +=09.name=09=09=3D "aec_agc_desired_bin",
>=20
> Please use proper controls names.

Sorry I don't really know what you mean? For me these are proper names.=


>=20
> > +=09.min=09=09=3D 1,
> > +=09.max=09=09=3D 64,
> > +=09.step=09=09=3D 1,
> > +=09.def=09=09=3D 58,
> > +=09.flags=09=09=3D 0,
> > +};
> > +
> > +static const struct v4l2_ctrl_config mt9v032_aec_lpf =3D {
> > +=09.ops=09=09=3D &mt9v032_ctrl_ops,
> > +=09.id=09=09=3D V4L2_CID_AEC_LPF,
> > +=09.type=09=09=3D V4L2_CTRL_TYPE_INTEGER,
> > +=09.name=09=09=3D "aec_lpf",
> > +=09.min=09=09=3D 0,
> > +=09.max=09=09=3D 2,
> > +=09.step=09=09=3D 1,
> > +=09.def=09=09=3D 0,
> > +=09.flags=09=09=3D 0,
> > +};
> > +
> > +static const struct v4l2_ctrl_config mt9v032_agc_lpf =3D {
> > +=09.ops=09=09=3D &mt9v032_ctrl_ops,
> > +=09.id=09=09=3D V4L2_CID_AGC_LPF,
> > +=09.type=09=09=3D V4L2_CTRL_TYPE_INTEGER,
> > +=09.name=09=09=3D "agc_lpf",
> > +=09.min=09=09=3D 0,
> > +=09.max=09=09=3D 2,
> > +=09.step=09=09=3D 1,
> > +=09.def=09=09=3D 2,
> > +=09.flags=09=09=3D 0,
> > +};
> > +
> > +static const struct v4l2_ctrl_config mt9v032_aec_update_interval =3D=
 {
> > +=09.ops=09=09=3D &mt9v032_ctrl_ops,
> > +=09.id=09=09=3D V4L2_CID_AEC_UPDATE_INTERVAL,
> > +=09.type=09=09=3D V4L2_CTRL_TYPE_INTEGER,
> > +=09.name=09=09=3D "aec_update_interval",
> > +=09.min=09=09=3D 0,
> > +=09.max=09=09=3D 16,
> > +=09.step=09=09=3D 1,
> > +=09.def=09=09=3D 2,
> > +=09.flags=09=09=3D 0,
> > +};
> > +
> > +static const struct v4l2_ctrl_config mt9v032_agc_update_interval =3D=
 {
> > +=09.ops=09=09=3D &mt9v032_ctrl_ops,
> > +=09.id=09=09=3D V4L2_CID_AGC_UPDATE_INTERVAL,
> > +=09.type=09=09=3D V4L2_CTRL_TYPE_INTEGER,
> > +=09.name=09=09=3D "agc_update_interval",
> > +=09.min=09=09=3D 0,
> > +=09.max=09=09=3D 16,
> > +=09.step=09=09=3D 1,
> > +=09.def=09=09=3D 2,
> > +=09.flags=09=09=3D 0,
> > +};
> > +
> > +static const struct v4l2_ctrl_config mt9v032_aec_max_shutter_width=
 =3D {
> > +=09.ops=09=09=3D &mt9v032_ctrl_ops,
> > +=09.id=09=09=3D V4L2_CID_AEC_MAX_SHUTTER_WIDTH,
> > +=09.type=09=09=3D V4L2_CTRL_TYPE_INTEGER,
> > +=09.name=09=09=3D "aec_max_shutter_width",
> > +=09.min=09=09=3D 1,
> > +=09.max=09=09=3D MT9V034_TOTAL_SHUTTER_WIDTH_MAX,
>=20
> Isn't the maximum value 2047 for the MT9V0[23]2 ?

Oh right, these differ by 2. Not really much but will fix it.

>=20
> > +=09.step=09=09=3D 1,
> > +=09.def=09=09=3D MT9V032_TOTAL_SHUTTER_WIDTH_DEF,
> > +=09.flags=09=09=3D 0,
> > +};
> > +
> >  /*
> > -------------------------------------------------------------------=
=2D-------
> > -- * V4L2 subdev core operations
> >   */
> > @@ -1010,6 +1147,22 @@ static int mt9v032_probe(struct i2c_client *=
client,
> >  =09=09=09=09mt9v032_test_pattern_menu);
> >  =09mt9v032->test_pattern_color =3D v4l2_ctrl_new_custom(&mt9v032->=
ctrls,
> >  =09=09=09=09      &mt9v032_test_pattern_color, NULL);
> > +=09mt9v032->desired_bin =3D v4l2_ctrl_new_custom(&mt9v032->ctrls,
> > +=09=09=09=09=09=09    &mt9v032_desired_bin,
> > +=09=09=09=09=09=09    NULL);
> > +=09mt9v032->aec_lpf =3D v4l2_ctrl_new_custom(&mt9v032->ctrls,
> > +=09=09=09=09=09=09&mt9v032_aec_lpf, NULL);
> > +=09mt9v032->agc_lpf =3D v4l2_ctrl_new_custom(&mt9v032->ctrls,
> > +=09=09=09=09=09=09&mt9v032_agc_lpf, NULL);
> > +=09mt9v032->aec_update_interval =3D v4l2_ctrl_new_custom(&mt9v032-=
>ctrls,
> > +=09=09=09=09=09=09&mt9v032_aec_update_interval,
> > +=09=09=09=09=09=09NULL);
> > +=09mt9v032->agc_update_interval =3D v4l2_ctrl_new_custom(&mt9v032-=
>ctrls,
> > +=09=09=09=09=09=09&mt9v032_agc_update_interval,
> > +=09=09=09=09=09=09NULL);
> > +=09mt9v032->aec_max_shutter_width =3D v4l2_ctrl_new_custom(&mt9v03=
2->ctrls,
> > +=09=09=09=09=09=09&mt9v032_aec_max_shutter_width,
> > +=09=09=09=09=09=09NULL);
>=20
> As there's no need to store the control pointers I would create an ar=
ray of=20
> struct v4l2_ctrl_config above instead of defining one variable per co=
ntrol,=20
> and then loop over the array here.
>=20
>         for (i =3D 0; i < ARRAY_SIZE(mt9v032_aegc_controls); ++i)
>                 v4l2_ctrl_new_custom(&mt9v032->ctrls,
>                                      &mt9v032_aegc_controls[i]);
>=20
> You should also update the above v4l2_ctrl_handler_init() call to tak=
e the new=20
> controls into account, as that will improve performances of the contr=
ol=20
> framework.
>=20
>         v4l2_ctrl_handler_init(&mt9v032->ctrls,
>                                10 + ARRAY_SIZE(mt9v032_aegc_controls)=
);

Fixed as well. Will send a new version as soon as the proper naming is =
clear to
me.

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

--nextPart15407594.kZAmgy15iS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJWQLrOAAoJEEpcgKtcEGQQ0GYP/2af5MIS+rgTpGYe6MO+ZOK8
8WSWSIFy7GxJgfSyuq83UoHY3UaTu7m+MmCFQ+G6LYbPOAV2HARi4We24EXtGfZO
8omiJj1xH9j7GztOmFa8+4cvlYwPZFHteulzB/mFzYDeQFzGx6MmKFcq0P7Y+95g
ZZJJ9FDeY5ZALDCxFU1UcpSH+lPC/Z7Kb3hYKQsZHDOYj1f3SgsS+LPM20yfikVJ
364curJdhR461x9IwVxcUn1yxshI2Z8KRWgyFScnNMc1fXGlZodpKpd6zqGNDIz2
DTVLvq1JA1PgiIn6ZCjOlnJ9ZWVzR3X22JEn+mUnqSu5h5FFpswipuSGzCZPBk6+
oy6ZLtc3SzBRCYrPOzj1cLtCR1Ny7CwpbDP3zwp1Y1Z6FhcPU3rUOqN0/4l1zwEL
OFKHEkknpVMjYlYUGSASOq2YO92jDkkAD2+R0zk+O/Urc/Cw1BLrEZ6fDXG6APuP
FLh+MuUqwM20rICy9cdMm/zdCQiva/o8lVfoqGZcxLlrtxBWaJO2fpSM5qKb3ork
OmKU7kzBwowknP/CT/TCoIypiW6BAo66dJ5WXF3wM9iZW/cvEgcL1/SF7ClUDqNn
nu0kfyjEfWaAXgApJnTuQMe4M3rC7HhN9aIjeHEguD+bY2tEtbBN0VdoSHO0spBe
HqwW3K4qtbXpYRNW+QHD
=XChE
-----END PGP SIGNATURE-----

--nextPart15407594.kZAmgy15iS--

