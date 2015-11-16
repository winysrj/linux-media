Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:59071 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbbKPKgg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Nov 2015 05:36:36 -0500
From: Markus Pargmann <mpa@pengutronix.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	devicetree@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 3/3] [media] mt9v032: Add V4L2 controls for AEC and AGC
Date: Mon, 16 Nov 2015 11:36:23 +0100
Message-ID: <19589208.nEgjVWPbYp@adelgunde>
In-Reply-To: <1989986.1Gm0BIcqZh@adelgunde>
References: <1446815625-18413-1-git-send-email-mpa@pengutronix.de> <2275245.3FVoKjERuu@avalon> <1989986.1Gm0BIcqZh@adelgunde>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart26834805.VCFbzQrExB"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--nextPart26834805.VCFbzQrExB
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"

Hi Laurent,

On Monday 09 November 2015 16:25:02 Markus Pargmann wrote:
> On Monday 09 November 2015 15:22:06 Laurent Pinchart wrote:
[...]
> >=20
> > Please use proper controls names.
>=20
> Sorry I don't really know what you mean? For me these are proper name=
s.

Could you give me a hint how these names should look like?

Thanks,

Markus

>=20
> >=20
> > > +=09.min=09=09=3D 1,
> > > +=09.max=09=09=3D 64,
> > > +=09.step=09=09=3D 1,
> > > +=09.def=09=09=3D 58,
> > > +=09.flags=09=09=3D 0,
> > > +};
> > > +
> > > +static const struct v4l2_ctrl_config mt9v032_aec_lpf =3D {
> > > +=09.ops=09=09=3D &mt9v032_ctrl_ops,
> > > +=09.id=09=09=3D V4L2_CID_AEC_LPF,
> > > +=09.type=09=09=3D V4L2_CTRL_TYPE_INTEGER,
> > > +=09.name=09=09=3D "aec_lpf",
> > > +=09.min=09=09=3D 0,
> > > +=09.max=09=09=3D 2,
> > > +=09.step=09=09=3D 1,
> > > +=09.def=09=09=3D 0,
> > > +=09.flags=09=09=3D 0,
> > > +};
> > > +
> > > +static const struct v4l2_ctrl_config mt9v032_agc_lpf =3D {
> > > +=09.ops=09=09=3D &mt9v032_ctrl_ops,
> > > +=09.id=09=09=3D V4L2_CID_AGC_LPF,
> > > +=09.type=09=09=3D V4L2_CTRL_TYPE_INTEGER,
> > > +=09.name=09=09=3D "agc_lpf",
> > > +=09.min=09=09=3D 0,
> > > +=09.max=09=09=3D 2,
> > > +=09.step=09=09=3D 1,
> > > +=09.def=09=09=3D 2,
> > > +=09.flags=09=09=3D 0,
> > > +};
> > > +
> > > +static const struct v4l2_ctrl_config mt9v032_aec_update_interval=
 =3D {
> > > +=09.ops=09=09=3D &mt9v032_ctrl_ops,
> > > +=09.id=09=09=3D V4L2_CID_AEC_UPDATE_INTERVAL,
> > > +=09.type=09=09=3D V4L2_CTRL_TYPE_INTEGER,
> > > +=09.name=09=09=3D "aec_update_interval",
> > > +=09.min=09=09=3D 0,
> > > +=09.max=09=09=3D 16,
> > > +=09.step=09=09=3D 1,
> > > +=09.def=09=09=3D 2,
> > > +=09.flags=09=09=3D 0,
> > > +};
> > > +
> > > +static const struct v4l2_ctrl_config mt9v032_agc_update_interval=
 =3D {
> > > +=09.ops=09=09=3D &mt9v032_ctrl_ops,
> > > +=09.id=09=09=3D V4L2_CID_AGC_UPDATE_INTERVAL,
> > > +=09.type=09=09=3D V4L2_CTRL_TYPE_INTEGER,
> > > +=09.name=09=09=3D "agc_update_interval",
> > > +=09.min=09=09=3D 0,
> > > +=09.max=09=09=3D 16,
> > > +=09.step=09=09=3D 1,
> > > +=09.def=09=09=3D 2,
> > > +=09.flags=09=09=3D 0,
> > > +};
> > > +
> > > +static const struct v4l2_ctrl_config mt9v032_aec_max_shutter_wid=
th =3D {
> > > +=09.ops=09=09=3D &mt9v032_ctrl_ops,
> > > +=09.id=09=09=3D V4L2_CID_AEC_MAX_SHUTTER_WIDTH,
> > > +=09.type=09=09=3D V4L2_CTRL_TYPE_INTEGER,
> > > +=09.name=09=09=3D "aec_max_shutter_width",
> > > +=09.min=09=09=3D 1,
> > > +=09.max=09=09=3D MT9V034_TOTAL_SHUTTER_WIDTH_MAX,
> >=20
> > Isn't the maximum value 2047 for the MT9V0[23]2 ?
>=20
> Oh right, these differ by 2. Not really much but will fix it.
>=20
> >=20
> > > +=09.step=09=09=3D 1,
> > > +=09.def=09=09=3D MT9V032_TOTAL_SHUTTER_WIDTH_DEF,
> > > +=09.flags=09=09=3D 0,
> > > +};
> > > +
> > >  /*
> > > -----------------------------------------------------------------=
=2D---------
> > > -- * V4L2 subdev core operations
> > >   */
> > > @@ -1010,6 +1147,22 @@ static int mt9v032_probe(struct i2c_client=
 *client,
> > >  =09=09=09=09mt9v032_test_pattern_menu);
> > >  =09mt9v032->test_pattern_color =3D v4l2_ctrl_new_custom(&mt9v032=
=2D>ctrls,
> > >  =09=09=09=09      &mt9v032_test_pattern_color, NULL);
> > > +=09mt9v032->desired_bin =3D v4l2_ctrl_new_custom(&mt9v032->ctrls=
,
> > > +=09=09=09=09=09=09    &mt9v032_desired_bin,
> > > +=09=09=09=09=09=09    NULL);
> > > +=09mt9v032->aec_lpf =3D v4l2_ctrl_new_custom(&mt9v032->ctrls,
> > > +=09=09=09=09=09=09&mt9v032_aec_lpf, NULL);
> > > +=09mt9v032->agc_lpf =3D v4l2_ctrl_new_custom(&mt9v032->ctrls,
> > > +=09=09=09=09=09=09&mt9v032_agc_lpf, NULL);
> > > +=09mt9v032->aec_update_interval =3D v4l2_ctrl_new_custom(&mt9v03=
2->ctrls,
> > > +=09=09=09=09=09=09&mt9v032_aec_update_interval,
> > > +=09=09=09=09=09=09NULL);
> > > +=09mt9v032->agc_update_interval =3D v4l2_ctrl_new_custom(&mt9v03=
2->ctrls,
> > > +=09=09=09=09=09=09&mt9v032_agc_update_interval,
> > > +=09=09=09=09=09=09NULL);
> > > +=09mt9v032->aec_max_shutter_width =3D v4l2_ctrl_new_custom(&mt9v=
032->ctrls,
> > > +=09=09=09=09=09=09&mt9v032_aec_max_shutter_width,
> > > +=09=09=09=09=09=09NULL);
> >=20
> > As there's no need to store the control pointers I would create an =
array of=20
> > struct v4l2_ctrl_config above instead of defining one variable per =
control,=20
> > and then loop over the array here.
> >=20
> >         for (i =3D 0; i < ARRAY_SIZE(mt9v032_aegc_controls); ++i)
> >                 v4l2_ctrl_new_custom(&mt9v032->ctrls,
> >                                      &mt9v032_aegc_controls[i]);
> >=20
> > You should also update the above v4l2_ctrl_handler_init() call to t=
ake the new=20
> > controls into account, as that will improve performances of the con=
trol=20
> > framework.
> >=20
> >         v4l2_ctrl_handler_init(&mt9v032->ctrls,
> >                                10 + ARRAY_SIZE(mt9v032_aegc_control=
s));
>=20
> Fixed as well. Will send a new version as soon as the proper naming i=
s clear to
> me.
>=20
> Thanks,
>=20
> Markus
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

--nextPart26834805.VCFbzQrExB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJWSbGtAAoJEEpcgKtcEGQQWGgQAI7DFYRAlT+mh4UkE25Ecr9M
wR/ToMSmnFYxJmOP2AtEKwomBhpRayCBlij+97g/ssSnhZw0DNNCYxkkGA1+rKpu
blLnFA4Fp4VqydWnL8+/3N4sv/tVAj0PJjgw5RLnnPyt9Y65VHbIrXQ9XCTXmULL
nUAS7AKDRWsPg+eitoBlZm3+7tUolXgk/pu9xVsDHFXn9YbC1hOU6sJfyptLukQe
5YKozkTIKD0Co8TXZWOie+MiWA55K9OapkLd/I0nTdHRx30LgKoEwExIq6SAkW/w
6oFbgVbAi44a8DvB4d3SgzpmRF0NjLYlm8LaDwIrEBYuHSDuegFOJhOD1cgg2U2I
EJjjsNgGWIYT9EqRS6l2nqrOMZe/5dcTR8dd8d7xACI6QehjQi82jaQpxKbIWUAw
OJffaIn2cocBK/+0fov36KVrjGRauQN9glg2ZyXD2bA+k5Kcbnog1ETI1Kh++upT
tE8rtX/BBgecUsIy3gUV5GUacCxgGEyDHh6eo0C+sjWFUesg564KZbKklha1Z/ya
vOOXQ9Rw1I/D+enx6XihWN/BQ9nqi4PX/OsR1SDBB87mcX7KBTwdvHVW1gCCmj9r
Pp60nng+aQSIFrBULdIDHmKlnKp0ldi39aB3WcxTFLh7tzzDyROy8QDI5uP7TUxX
QVKM2kVv7Xs1M5Hl3ilt
=0GjN
-----END PGP SIGNATURE-----

--nextPart26834805.VCFbzQrExB--

