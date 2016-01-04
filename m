Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:45718 "EHLO
	metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752624AbcADJ4z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jan 2016 04:56:55 -0500
From: Markus Pargmann <mpa@pengutronix.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	devicetree@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 3/3] [media] mt9v032: Add V4L2 controls for AEC and AGC
Date: Mon, 04 Jan 2016 10:56:44 +0100
Message-ID: <1598879.76W0kKqfX7@adelgunde>
In-Reply-To: <5194938.P3WvP9gjaZ@avalon>
References: <1450104113-6392-1-git-send-email-mpa@pengutronix.de> <2570493.HaAAxn7ErG@adelgunde> <5194938.P3WvP9gjaZ@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3218746.xMjAhSZ7hY"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--nextPart3218746.xMjAhSZ7hY
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"

Hi Laurent,

On Tuesday 29 December 2015 11:38:39 Laurent Pinchart wrote:
> Hi Markus,
>=20
> On Wednesday 16 December 2015 11:14:28 Markus Pargmann wrote:
> > On Wednesday 16 December 2015 09:47:58 Laurent Pinchart wrote:
> > > On Monday 14 December 2015 15:41:53 Markus Pargmann wrote:
> > >> This patch adds V4L2 controls for Auto Exposure Control and Auto=
 Gain
> > >> Control settings. These settings include low pass filter, update=

> > >> frequency of these settings and the update interval for those un=
its.
> > >>=20
> > >> Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
> > >=20
> > > Please see below for a few comments. If you agree about them ther=
e's no
> > > need to resubmit, I'll fix the patch when applying.
> >=20
> > Most of them are fine, I commented on the open ones.
> >=20
> > >> ---
> > >>=20
> > >>  drivers/media/i2c/mt9v032.c | 153 +++++++++++++++++++++++++++++=
+++++++-
> > >>  1 file changed, 152 insertions(+), 1 deletion(-)
> > >>=20
> > >> diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9=
v032.c
> > >> index cc16acf001de..6cbc3b87eda9 100644
> > >> --- a/drivers/media/i2c/mt9v032.c
> > >> +++ b/drivers/media/i2c/mt9v032.c
>=20
> [snip]
>=20
> > >> +static const struct v4l2_ctrl_config mt9v032_aec_max_shutter_wi=
dth =3D {
> > >> +=09.ops=09=09=3D &mt9v032_ctrl_ops,
> > >> +=09.id=09=09=3D V4L2_CID_AEC_MAX_SHUTTER_WIDTH,
> > >> +=09.type=09=09=3D V4L2_CTRL_TYPE_INTEGER,
> > >> +=09.name=09=09=3D "aec_max_shutter_width",
> > >> +=09.min=09=09=3D 1,
> > >> +=09.max=09=09=3D MT9V032_TOTAL_SHUTTER_WIDTH_MAX,
> > >=20
> > > According the the MT9V032 datasheet I have, the maximum value is =
2047
> > > while MT9V032_TOTAL_SHUTTER_WIDTH_MAX is defined as 32767. Do you=
 have any
> > > information that would hint for an error in the datasheet ?
> >=20
> > The register is defined as having 15 bits. I simply assumed that th=
e already
> > defined TOTAL_SHUTTER_WIDTH_MAX would apply for this register as we=
ll. At
> > least it should end up controlling the same property of the chip. I=
 didn't
> > test this on mt9v032 but on mt9v024.
>=20
> According to the MT9V032 datasheet=20
> (http://www.onsemi.com/pub/Collateral/MT9V032-D.PDF) the maximum shut=
ter width=20
> in AEC mode is limited to 2047. That is documented both in the Maximu=
m Total=20
> Shutter Width register legal values and in the "Automatic Gain Contro=
l and=20
> Automatic Exposure Control" section:
>=20
> "The exposure is measured in row-time by reading R0xBB. The exposure =
range is
> 1 to 2047."
>=20
> I assume that the the AEC unit limits the shutter width to 2047 lines=
 and that=20
> it's thus pointless to set the maximum total shutter width to a highe=
r value.=20
> Whether doing so could have any adverse effect I don't know, but bett=
er be=20
> same than sorry. If you agree we should limit the value to 2047 I can=
 fix=20
> this.

Yes, I agree. It would be great if you fix this.

Thanks,

Markus

>=20
> > >> +=09.step=09=09=3D 1,
> > >> +=09.def=09=09=3D MT9V032_TOTAL_SHUTTER_WIDTH_DEF,
> > >> +=09.flags=09=09=3D 0,
> > >> +};
> > >> +
> > >> +static const struct v4l2_ctrl_config mt9v034_aec_max_shutter_wi=
dth =3D {
> > >> +=09.ops=09=09=3D &mt9v032_ctrl_ops,
> > >> +=09.id=09=09=3D V4L2_CID_AEC_MAX_SHUTTER_WIDTH,
> > >> +=09.type=09=09=3D V4L2_CTRL_TYPE_INTEGER,
> > >> +=09.name=09=09=3D "aec_max_shutter_width",
> > >> +=09.min=09=09=3D 1,
> > >> +=09.max=09=09=3D MT9V034_TOTAL_SHUTTER_WIDTH_MAX,
> > >> +=09.step=09=09=3D 1,
> > >> +=09.def=09=09=3D MT9V032_TOTAL_SHUTTER_WIDTH_DEF,
> > >> +=09.flags=09=09=3D 0,
> > >> +};
> > >=20
> > > [snip]
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

--nextPart3218746.xMjAhSZ7hY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJWikHhAAoJEEpcgKtcEGQQ/pwQAKCdg5Phi7Dt564Dq0M7PvDT
g9A0sdkH/uxaTwoHJAMPaDe5L3cmnoNCQFrPDMmSsMAnyc5AEKohrgeifcxcVrgc
5gw2qRHIEz8KbqgjF8szeAC1ZFepMCu/kdH1aaZGvvN1AaqPOo4jPfrZpGrmOt7g
v8BAcJ91LI9/1h5u5Szw4hhy2YpyP9Y12m2bDCLAFr26MYnK3dD11A1YftQJfszX
WW6r6RWXtq3u48SxpJkXzMk0RKNFJSHW9jXjiS84GuIT+W8gfEVB7BSFPE6Wjy2G
VyMvYgcrlz+p3X0IvpyRxivkq7XWeI/lqjtv3DBKh5pipDBPA8n/UFYvQnim32hC
HmgqUnvG/2di7WpeefXmiDVH+3UAay9OTBX2gjj5OTMmwbwuKLmjClkjFsaI6WLC
xvsIot5CxUjbdw2urCciO9PBny927b3g+A+nNP004CAcJ5tizKHRESqudfJnS/aa
+l51G4LcHUiNHE8ven5qvG1IQbk1R0y3jQEFL6w26hnA+DacYgrelr7an8kJZXtq
MADV/A9LkHZ5rObu3AbN068y8n8Q4InmIILwUBRXwMvr9gewkBAhbxnusf0KV93z
i/BJExRiqBF8tDS25oRyom6CDioAGlXWnU5V8qbx7LvSox6kYVw1JP490fTpOIjF
P1vZ2zZlmE791M/GvUBE
=XjSD
-----END PGP SIGNATURE-----

--nextPart3218746.xMjAhSZ7hY--

