Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44845 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934388AbeBMRCH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Feb 2018 12:02:07 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v10 13/30] rcar-vin: add function to manipulate Gen3 chsel value
Date: Tue, 13 Feb 2018 19:02:38 +0200
Message-ID: <5978650.TJRMUHOLl6@avalon>
In-Reply-To: <20180213165809.GE18618@bigcity.dyn.berto.se>
References: <20180129163435.24936-1-niklas.soderlund+renesas@ragnatech.se> <6540925.qhrue9hUJl@avalon> <20180213165809.GE18618@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

On Tuesday, 13 February 2018 18:58:09 EET Niklas S=F6derlund wrote:
> On 2018-02-13 18:41:33 +0200, Laurent Pinchart wrote:
> > On Monday, 29 January 2018 18:34:18 EET Niklas S=F6derlund wrote:
> > > On Gen3 the CSI-2 routing is controlled by the VnCSI_IFMD register. O=
ne
> > > feature of this register is that it's only present in the VIN0 and VI=
N4
> > > instances. The register in VIN0 controls the routing for VIN0-3 and t=
he
> > > register in VIN4 controls routing for VIN4-7.
> > >=20
> > > To be able to control routing from a media device this function is ne=
ed
> > > to control runtime PM for the subgroup master (VIN0 and VIN4). The
> > > subgroup master must be switched on before the register is manipulate=
d,
> > > once the operation is complete it's safe to switch the master off and
> > > the new routing will still be in effect.
> > >=20
> > > Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech=
=2Ese>
> > > ---
> >>=20
> >>  drivers/media/platform/rcar-vin/rcar-dma.c | 28++++++++++++++++++++++=
+++
> >>  drivers/media/platform/rcar-vin/rcar-vin.h |  2 ++
> >>  2 files changed, 30 insertions(+)
> >>=20
> >> diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c
> >> b/drivers/media/platform/rcar-vin/rcar-dma.c index
> >> 2f9ad1bec1c8a92f..ae286742f15a3ab5 100644
> >> --- a/drivers/media/platform/rcar-vin/rcar-dma.c
> >> +++ b/drivers/media/platform/rcar-vin/rcar-dma.c
> >> @@ -16,6 +16,7 @@
> >>=20
> >>  #include <linux/delay.h>
> >>  #include <linux/interrupt.h>
> >> +#include <linux/pm_runtime.h>
> >>=20
> >>  #include <media/videobuf2-dma-contig.h>
> >>=20
> >> @@ -1228,3 +1229,30 @@ int rvin_dma_register(struct rvin_dev *vin, int
> >> irq)
> >>  	return ret;
> >>  }
> >>=20
> >> +
> >> +/* ------------------------------------------------------------------=
=2D--
> >> + * Gen3 CHSEL manipulation
> >> + */
> >> +
> >> +void rvin_set_channel_routing(struct rvin_dev *vin, u8 chsel)
> >> +{
> >> +	u32 ifmd, vnmc;
> >> +
> >> +	pm_runtime_get_sync(vin->dev);
> >=20
> > No need to check for errors ?
>=20
> You asked the samething for v9 so I will copy paste the same reply :-)

Oh so you expect me to remember what happened with previous versions ? :-)

>     Sakari asked the same thing in v4 :-)
>=20
>     In short no its not needed please see Geert's response [1]. If I
>     recall correctly this was also discussed in more detail in another
>     thread for some other driver whit a bit longer answer saying that it
>     pm_runtime_get_sync() fails you have big problems but I can't find
>     that thread now :-(
>=20
>     1. https://www.spinics.net/lists/linux-media/msg115241.html

If kmalloc() fails we also have big problems, but we nonetheless check ever=
y=20
memory allocation.

> >> +
> >> +	/* Make register writes take effect immediately */
> >> +	vnmc =3D rvin_read(vin, VNMC_REG);
> >> +	rvin_write(vin, vnmc & ~VNMC_VUP, VNMC_REG);
> >> +
> >> +	ifmd =3D VNCSI_IFMD_DES2 | VNCSI_IFMD_DES1 | VNCSI_IFMD_DES0 |
> >> +		VNCSI_IFMD_CSI_CHSEL(chsel);
> >> +
> >> +	rvin_write(vin, ifmd, VNCSI_IFMD_REG);
> >> +
> >> +	vin_dbg(vin, "Set IFMD 0x%x\n", ifmd);
> >> +
> >> +	/* Restore VNMC */
> >> +	rvin_write(vin, vnmc, VNMC_REG);
> >=20
> > No need for locking around all this ? What happens if this VIN instance
> > decides to write to another VIN register (for instance due to a userpace
> > call) when this function has disabled VNMC_VUP ?
>=20
> You also asked a related question to this in v9 as a start I will copy
> in that reply.
>=20
>     Media link changes are not allowed when any VIN in the group are
>     streaming so this should not be an issue.
>=20
> And to compliment that. This function is only valid for a VIN which has
> the CHSEL register which currently is VIN0 and VIN4. It can only be
> modified when a media link is enabled. Catching media links are only
> allowed when all VIN in the system are _not_ streaming. And VNMC_VUP is
> only enabled when a VIN is streaming so there is no need for locking
> here.

This seems a bit fragile to me, could you please capture the explanation in=
 a=20
comment ?

> >> +	pm_runtime_put(vin->dev);
> >> +}
> >> diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h
> >> b/drivers/media/platform/rcar-vin/rcar-vin.h index
> >> 146683142e6533fa..a5dae5b5e9cb704b 100644
> >> --- a/drivers/media/platform/rcar-vin/rcar-vin.h
> >> +++ b/drivers/media/platform/rcar-vin/rcar-vin.h
> >> @@ -165,4 +165,6 @@ const struct rvin_video_format
> >> *rvin_format_from_pixel(u32 pixelformat); /* Cropping, composing and
> >> scaling */
> >>=20
> >>  void rvin_crop_scale_comp(struct rvin_dev *vin);
> >>=20
> >> +void rvin_set_channel_routing(struct rvin_dev *vin, u8 chsel);
> >> +
> >>  #endif

=2D-=20
Regards,

Laurent Pinchart
