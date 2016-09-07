Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52838 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751201AbcIGKer (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Sep 2016 06:34:47 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        corbet@lwn.net, mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hans.verkuil@cisco.com
Subject: Re: [PATCHv2 2/2] v4l: vsp1: Add HGT support
Date: Wed, 07 Sep 2016 13:35:17 +0300
Message-ID: <6810110.RUoNQc9I6B@avalon>
In-Reply-To: <20160907100525.GL27014@bigcity.dyn.berto.se>
References: <20160906143856.27564-1-niklas.soderlund+renesas@ragnatech.se> <11815359.8Rr4pPQQOL@avalon> <20160907100525.GL27014@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

On Wednesday 07 Sep 2016 12:05:26 Niklas S=F6derlund wrote:
> On 2016-09-06 22:59:22 +0300, Laurent Pinchart wrote:
> > On Tuesday 06 Sep 2016 16:38:56 Niklas S=F6derlund wrote:
> >> The HGT is a Histogram Generator Two-Dimensions. It computes a wei=
ghted
> >> frequency histograms for hue and saturation areas over a configura=
ble
> >> region of the image with optional subsampling.
> >>=20
> >> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnat=
ech.se>
> >> ---
> >>=20
> >>  drivers/media/platform/vsp1/Makefile      |   2 +-
> >>  drivers/media/platform/vsp1/vsp1.h        |   3 +
> >>  drivers/media/platform/vsp1/vsp1_drv.c    |  33 ++++-
> >>  drivers/media/platform/vsp1/vsp1_entity.c |  33 +++--
> >>  drivers/media/platform/vsp1/vsp1_entity.h |   1 +
> >>  drivers/media/platform/vsp1/vsp1_hgt.c    | 217 +++++++++++++++++=
++++++
> >>  drivers/media/platform/vsp1/vsp1_hgt.h    |  42 ++++++
> >>  drivers/media/platform/vsp1/vsp1_pipe.c   |  16 +++
> >>  drivers/media/platform/vsp1/vsp1_pipe.h   |   2 +
> >>  drivers/media/platform/vsp1/vsp1_regs.h   |   9 ++
> >>  drivers/media/platform/vsp1/vsp1_video.c  |  10 +-
> >>  11 files changed, 352 insertions(+), 16 deletions(-)
> >>  create mode 100644 drivers/media/platform/vsp1/vsp1_hgt.c
> >>  create mode 100644 drivers/media/platform/vsp1/vsp1_hgt.h
> >=20
> > [snip]
> >=20
> >> diff --git a/drivers/media/platform/vsp1/vsp1_hgt.c
> >> b/drivers/media/platform/vsp1/vsp1_hgt.c new file mode 100644
> >> index 0000000..4e3f762
> >> --- /dev/null
> >> +++ b/drivers/media/platform/vsp1/vsp1_hgt.c
> >=20
> > [snip]
> >=20
> >> +/* --------------------------------------------------------------=
-------
> >> + * Controls
> >> + */
> >> +
> >> +#define V4L2_CID_VSP1_HGT_HUE_AREAS=09(V4L2_CID_USER_BASE | 0x100=
1)
> >> +
> >> +static int hgt_hue_areas_s_ctrl(struct v4l2_ctrl *ctrl)
> >> +{
> >> +=09struct vsp1_hgt *hgt =3D container_of(ctrl->handler, struct vs=
p1_hgt,
> >> +=09=09=09=09=09    ctrls);
> >> +=09u8 *value =3D ctrl->p_new.p_u8;
> >=20
> > Nitpicking, I'd call the variable values.
> >=20
> >> +=09unsigned int i;
> >> +=09bool ok =3D true;
> >> +
> >> +=09/*
> >> +=09 * Make sure values meet one of two possible hardware constrai=
ns
> >=20
> > s/constrains/constraints./
> >=20
> >> +=09 * 0L <=3D 0U <=3D 1L <=3D 1U <=3D 2L <=3D 2U <=3D 3L <=3D 3U =
<=3D 4L <=3D 4U <=3D 5L <=3D
> >> 5U
> >> +=09 * 0U <=3D 1L <=3D 1U <=3D 2L <=3D 2U <=3D 3L <=3D 3U <=3D 4L =
<=3D 4U <=3D 5L <=3D 5U <=3D
> >> 0L
> >> +=09 */
> >> +
> >> +=09if ((value[0] > value[1]) && (value[11] > value[0]))
> >> +=09=09ok =3D false;
> >> +=09for (i =3D 1; i < (HGT_NUM_HUE_AREAS * 2) - 1; ++i)
> >> +=09=09if (value[i] > value[i+1])
> >> +=09=09=09ok =3D false;
> >> +
> >> +=09/* Values do not match hardware, adjust to valid settings. */
> >> +=09if (!ok) {
> >> +=09=09for (i =3D 0; i < (HGT_NUM_HUE_AREAS * 2) - 1; ++i) {
> >> +=09=09=09if (value[i] > value[i+1])
> >> +=09=09=09=09value[i] =3D value[i+1];
> >> +=09=09}
> >> +=09}
> >=20
> > I'm afraid this won't work. Let's assume value[0] =3D 100, value[1]=
 =3D 50,
> > value[2] =3D 25. The loop will unroll to
> >=20
> > =09if (value[0] /* 100 */ > value[1] /* 50 */)
> > =09=09value[0] =3D value[1] /* 50 */;
> > =09
> > =09if (value[1] /* 50 */ > value[2] /* 25 */)
> > =09=09value[1] =3D value[2] /* 25 */;
> >=20
> > You will end up with value[0] =3D 50, value[1] =3D 25, value[2] =3D=
 25, which
> > doesn't match the hardware constraints.
> >=20
> > How about the following, which tests and fixes the values in a sing=
le
> > operation ?
> >=20
> > static int hgt_hue_areas_s_ctrl(struct v4l2_ctrl *ctrl)
> > {
> > =09struct vsp1_hgt *hgt =3D container_of(ctrl->handler, struct vsp1=
_hgt,
> > =09=09=09=09=09    ctrls);
> > =09u8 *values =3D ctrl->p_new.p_u8;
> > =09unsigned int i;
> > =09
> > =09/*
> > =09 * Adjust the values if they don't meet the hardware constraints=
:
> > =09 *
> > =09 * 0U <=3D 1L <=3D 1U <=3D 2L <=3D 2U <=3D 3L <=3D 3U <=3D 4L <=3D=
 4U <=3D 5L <=3D 5U
> > =09 */
> > =09for (i =3D 1; i < (HGT_NUM_HUE_AREAS * 2) - 1; ++i) {
> > =09=09if (values[i] > values[i+1])
> > =09=09=09values[i+1] =3D values[i];
> > =09}
> > =09
> > =09/* 0L <=3D 0U or 5U <=3D 0L */
> > =09if (values[0] > values[1] && values[11] > values[0])
> > =09=09values[0] =3D values[1];
> > =09
> > =09memcpy(hgt->hue_areas, ctrl->p_new.p_u8, sizeof(hgt->hue_areas))=
;
> > =09
> > =09return 0;
> > }
> >=20
> > I'm also beginning to wonder whether it wouldn't make sense to retu=
rn
> > -EINVAL when the values don't match the constraints instead of tryi=
ng to
> > fix them.
>
> I'm fine with either solution. I looked at a few other drivers and it=

> seems the most common way is to correct the control value. But maybe =
in
> this case it's better to just return -EINVAL.
>=20
> Let me know what you think and I will make it so and send a v3.

Given that fixed values would result in a different histogram that woul=
d=20
likely be unusable by a userspace application that doesn't expect the c=
ontrol=20
values to be changed (and if it did, it should set correct values to st=
art=20
with), I think -EINVAL is better. As Hans pointed out on IRC, this shou=
ld be=20
implemented in the .try_ctrl() handler.
=20
> > > +=09memcpy(hgt->hue_areas, ctrl->p_new.p_u8, sizeof(hgt->hue_area=
s));
> > > +
> > > +=09return 0;
> > > +}
> >=20
> > [snip]

--=20
Regards,

Laurent Pinchart

