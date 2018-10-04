Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:51984 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727536AbeJEDqn (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2018 23:46:43 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 1/3] rcar-vin: align width before stream start
Date: Thu, 04 Oct 2018 23:51:57 +0300
Message-ID: <3499742.MHvEhtFnsl@avalon>
In-Reply-To: <20181004202950.GQ24305@bigcity.dyn.berto.se>
References: <20181004200402.15113-1-niklas.soderlund+renesas@ragnatech.se> <3937980.o2kZMfQ5OL@avalon> <20181004202950.GQ24305@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

On Thursday, 4 October 2018 23:29:51 EEST Niklas S=F6derlund wrote:
> On 2018-10-04 23:11:50 +0300, Laurent Pinchart wrote:
> > On Thursday, 4 October 2018 23:04:00 EEST Niklas S=F6derlund wrote:
> >> Instead of aligning the image width to match the image stride at stream
> >> start time do so when configuring the format. This allows the format
> >> width to strictly match the image stride which is useful when enabling
> >> scaling on Gen3.
> >=20
> > But is this required ? Aren't there use cases where an image with a wid=
th
> > not aligned with the stride requirements should be captured ? As long as
> > the stride itself matches the hardware requirements, I don't see a reas=
on
> > to disallow that.
>=20
> Yes there is a use-case for that. And the rcar-vin driver is starting to
> reaching a point where the whole format handling for buffers, source
> format, croping and scaling needs to be rewritten to enable more valid
> use-cases.
>=20
> This fix is however in my view required at this time with the current
> driver design. If we keep aligning the width at stream on and enable the
> UDS it becomes apparent that when the alignment is needed the values for
> the stride register conflicts which how the scaling coefficients are
> calculated and the captured frame is distorted.
>=20
> My hope is to add upstream to support for the UDS, support for
> sequential field captures and some more output pixel formats. And once
> the driver feature complete on Gen3 come back and simplify and if
> possible align the Gen2 and Gen3 format handling which in part adds to
> the somewhat messy current state.

I'd argue that it would be better to do it the other way around, but I won'=
t=20
block this patch series. You might however get angry e-mails from VIN users=
=20
who all of a sudden realize that their use case stopped functioning.

> > > Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech=
=2Ese>
> > > ---
> > >=20
> > >  drivers/media/platform/rcar-vin/rcar-dma.c  | 5 +----
> > >  drivers/media/platform/rcar-vin/rcar-v4l2.c | 9 +++++++++
> > >  2 files changed, 10 insertions(+), 4 deletions(-)
> > >=20
> > > diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c
> > > b/drivers/media/platform/rcar-vin/rcar-dma.c index
> > > 92323310f7352147..e752bc86e40153b1 100644
> > > --- a/drivers/media/platform/rcar-vin/rcar-dma.c
> > > +++ b/drivers/media/platform/rcar-vin/rcar-dma.c
> > > @@ -597,10 +597,7 @@ void rvin_crop_scale_comp(struct rvin_dev *vin)
> > >=20
> > >  	if (vin->info->model !=3D RCAR_GEN3)
> > >  =09
> > >  		rvin_crop_scale_comp_gen2(vin);
> > >=20
> > > -	if (vin->format.pixelformat =3D=3D V4L2_PIX_FMT_NV16)
> > > -		rvin_write(vin, ALIGN(vin->format.width, 0x20), VNIS_REG);
> > > -	else
> > > -		rvin_write(vin, ALIGN(vin->format.width, 0x10), VNIS_REG);
> > > +	rvin_write(vin, vin->format.width, VNIS_REG);
> > >=20
> > >  }
> > > =20
> > >  /*
> > >=20
> > > ---------------------------------------------------------------------=
=2D--
> > > ---
> > > -- diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> > > b/drivers/media/platform/rcar-vin/rcar-v4l2.c index
> > > dc77682b47857c97..94bc559a0cb1e47a 100644
> > > --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> > > +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> > > @@ -96,6 +96,15 @@ static void rvin_format_align(struct rvin_dev *vin,
> > > struct v4l2_pix_format *pix) pix->pixelformat =3D=3D V4L2_PIX_FMT_XBG=
R32))
> > >=20
> > >  		pix->pixelformat =3D RVIN_DEFAULT_FORMAT;
> > >=20
> > > +	switch (pix->pixelformat) {
> > > +	case V4L2_PIX_FMT_NV16:
> > > +		pix->width =3D ALIGN(pix->width, 0x20);
> > > +		break;
> > > +	default:
> > > +		pix->width =3D ALIGN(pix->width, 0x10);
> > > +		break;
> > > +	}
> > > +
> > >=20
> > >  	switch (pix->field) {
> > >  	case V4L2_FIELD_TOP:
> > >  	case V4L2_FIELD_BOTTOM:


=2D-=20
Regards,

Laurent Pinchart
