Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:39128 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751375AbdGMXbE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Jul 2017 19:31:04 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 08/14] v4l: vsp1: Add support for new VSP2-BS, VSP2-DL and VSP2-D instances
Date: Fri, 14 Jul 2017 02:31:07 +0300
Message-ID: <27780346.YnnMpKiiFZ@avalon>
In-Reply-To: <22c14966-67d6-82b2-e305-d371efde0d23@ideasonboard.com>
References: <20170626181226.29575-1-laurent.pinchart+renesas@ideasonboard.com> <20170626181226.29575-9-laurent.pinchart+renesas@ideasonboard.com> <22c14966-67d6-82b2-e305-d371efde0d23@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On Thursday 13 Jul 2017 18:49:19 Kieran Bingham wrote:
> On 26/06/17 19:12, Laurent Pinchart wrote:
> > New Gen3 SoCs come with two new VSP2 variants names VSP2-BS and VSP=
2-DL,
> > as well as a new VSP2-D variant on V3M and V3H SoCs. Add new entrie=
s for
> > them in the VSP device info table.
> >=20
> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>
>=20
> Code in the patch looks OK - but I can't see where the difference bet=
ween
> the horizontal widths are supported between VSPD H3/VC
>=20
> I see this in the datasheet: (32.1.1.6 in this particular part)
>=20
> Direct connection to display module
> =E2=80=94 Supporting 4096 pixels in horizontal direction [R-Car H3/R-=
Car M3-W/ R-Car
> M3-N]
> =E2=80=94 Supporting 2048 pixels in horizontal direction [R-Car V3M/R=
-Car V3H/R-Car
> D3/R-Car E3]
>=20
> Do we have this information encoded anywhere? or are they just talkin=
g about
> maximum performance capability there?

No, we don't. It's a limit that we should have. I think we should fix t=
hat in=20
a separate patch, as the 4096 pixels limit isn't implemented either.

> Also some features that are implied as supported aren't mentioned - b=
ut
> that's not a blocker to adding in the initial devices at all.
>=20
> Therefore:
>=20
> Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>=

>=20
> > ---
> >=20
> >  drivers/media/platform/vsp1/vsp1_drv.c  | 24 +++++++++++++++++++++=
+++
> >  drivers/media/platform/vsp1/vsp1_regs.h | 15 +++++++++++++--
> >  2 files changed, 37 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/drivers/media/platform/vsp1/vsp1_drv.c
> > b/drivers/media/platform/vsp1/vsp1_drv.c index 6a9aeb71aedf..c4f2ac=
61f7d2
> > 100644
> > --- a/drivers/media/platform/vsp1/vsp1_drv.c
> > +++ b/drivers/media/platform/vsp1/vsp1_drv.c
> > @@ -710,6 +710,14 @@ static const struct vsp1_device_info
> > vsp1_device_infos[] =3D {>=20
> >  =09=09.num_bru_inputs =3D 5,
> >  =09=09.uapi =3D true,
> >  =09}, {
> > +=09=09.version =3D VI6_IP_VERSION_MODEL_VSPBS_GEN3,
> > +=09=09.model =3D "VSP2-BS",
> > +=09=09.gen =3D 3,
> > +=09=09.features =3D VSP1_HAS_BRS,
>=20
> 32.1.1.5 implies:
> | VSP1_HAS_WPF_VFLIP
>=20
> But Figure 32.5 implies that it doesn't ...

The figures only tell whether the full combination of rotation and H/V =
flip is=20
available. I think you're right, I'll add VSP1_HAS_WPF_VFLIP.

> Figure 32.5 also implies that | VSP1_HAS_CLU is there too on both RPF=
0, and
> RPF1

Note that CLUT !=3D CLU. I know it's confusing :-)

> > +=09=09.rpf_count =3D 2,
> > +=09=09.wpf_count =3D 1,
> > +=09=09.uapi =3D true,
> > +=09}, {
> >  =09=09.version =3D VI6_IP_VERSION_MODEL_VSPD_GEN3,
> >  =09=09.model =3D "VSP2-D",
> >  =09=09.gen =3D 3,
> > @@ -717,6 +725,22 @@ static const struct vsp1_device_info
> > vsp1_device_infos[] =3D {>=20
> >  =09=09.rpf_count =3D 5,
> >  =09=09.wpf_count =3D 2,
> >  =09=09.num_bru_inputs =3D 5,
> > +=09}, {
> > +=09=09.version =3D VI6_IP_VERSION_MODEL_VSPD_V3,
> > +=09=09.model =3D "VSP2-D",
> > +=09=09.gen =3D 3,
> > +=09=09.features =3D VSP1_HAS_BRS | VSP1_HAS_BRU | VSP1_HAS_LIF,
> > +=09=09.rpf_count =3D 5,
> > +=09=09.wpf_count =3D 1,
> > +=09=09.num_bru_inputs =3D 5,
> > +=09}, {
> > +=09=09.version =3D VI6_IP_VERSION_MODEL_VSPDL_GEN3,
> > +=09=09.model =3D "VSP2-DL",
> > +=09=09.gen =3D 3,
> > +=09=09.features =3D VSP1_HAS_BRS | VSP1_HAS_BRU | VSP1_HAS_LIF,
>=20
> Hrm. 32.1.1.7 says:
> =E2=80=94 Vertical flipping in case of output to memory.
> So thats some sort of a conditional : | VSP1_HAS_WPF_VFLIP
>=20
> So looking at this and the settings of the existing models, I guess i=
t looks
> like we don't support flip if we have an LIF output (as that would th=
en be
> unsupported)

On Gen3 vertical flipping seems to always be supported, unlike on Gen2 =
where=20
VSPD is specifically documented as not supporting vertical flipping. We=
 could=20
add the WFLIP on all VSP2-D* instances. This would create a correspondi=
ng=20
control, which wouldn't do much harm as the VSPD instances on Gen3 are =
not=20
exposed to userspace, but that would waste a bit of memory for no good =
purpose=20
(beside correctness I suppose). I wonder if that's worth it, what do yo=
u think=20
? If so, VSP2-D should be fixed too, so I'd prefer doing that in a sepa=
rate=20
patch.

> > +=09=09.rpf_count =3D 5,
> > +=09=09.wpf_count =3D 2,
> > +=09=09.num_bru_inputs =3D 5,
> >  =09},
> >  };
> >=20

[snip]

--=20
Regards,

Laurent Pinchart
