Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52872 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965900AbeBMWau (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Feb 2018 17:30:50 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v10 10/30] rcar-vin: fix handling of single field frames (top, bottom and alternate fields)
Date: Wed, 14 Feb 2018 00:31:21 +0200
Message-ID: <3791727.mLP5MD9T4p@avalon>
In-Reply-To: <20180213164704.GD18618@bigcity.dyn.berto.se>
References: <20180129163435.24936-1-niklas.soderlund+renesas@ragnatech.se> <1615346.M5jUZRACzr@avalon> <20180213164704.GD18618@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

On Tuesday, 13 February 2018 18:47:04 EET Niklas S=F6derlund wrote:
> On 2018-02-13 18:26:34 +0200, Laurent Pinchart wrote:
> > On Monday, 29 January 2018 18:34:15 EET Niklas S=F6derlund wrote:
> >> There was never proper support in the VIN driver to deliver ALTERNATING
> >> field format to user-space, remove this field option. The problem is
> >> that ALTERNATING filed order requires the sequence numbers of buffers
> >> returned to userspace to reflect if fields where dropped or not,
> >> something which is not possible with the VIN drivers capture logic.
> >>=20
> >> The VIN driver can still capture from a video source which delivers
> >> frames in ALTERNATING field order, but needs to combine them using the
> >> VIN hardware into INTERLACED field order. Before this change if a sour=
ce
> >> was delivering fields using ALTERNATE the driver would default to
> >> combining them using this hardware feature. Only if the user explicitly
> >> requested ALTERNATE filed order would incorrect frames be delivered.
> >>=20
> >> The height should not be cut in half for the format for TOP or BOTTOM
> >> fields settings. This was a mistake and it was made visible by the
> >> scaling refactoring. Correct behavior is that the user should request a
> >> frame size that fits the half height frame reflected in the field
> >> setting. If not the VIN will do its best to scale the top or bottom to
> >> the requested format and cropping and scaling do not work as expected.
> >>=20
> >> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.=
se>
> >> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
> >> ---
> >>=20
> >>  drivers/media/platform/rcar-vin/rcar-dma.c  | 15 +-------
> >>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 53 +++++++++++---------=
=2D--
> >>  2 files changed, 24 insertions(+), 44 deletions(-)

[snip]

> >> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> >> b/drivers/media/platform/rcar-vin/rcar-v4l2.c index
> >> 4d5be2d0c79c9c9a..9f7902d29c62e205 100644
> >> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> >> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> >> @@ -103,6 +103,28 @@ static int rvin_get_source_format(struct rvin_dev
> >> *vin,
> >>  	if (ret)
> >>  		return ret;
> >>=20
> >> +	switch (fmt.format.field) {
> >> +	case V4L2_FIELD_TOP:
> >> +	case V4L2_FIELD_BOTTOM:
> >> +	case V4L2_FIELD_NONE:
> >> +	case V4L2_FIELD_INTERLACED_TB:
> >> +	case V4L2_FIELD_INTERLACED_BT:
> >> +	case V4L2_FIELD_INTERLACED:
> >> +		break;
> >> +	case V4L2_FIELD_ALTERNATE:
> >> +		/*
> >> +		 * Driver do not (yet) support outputting ALTERNATE to a
> >> +		 * userspace. It dose support outputting INTERLACED so use
> >=20
> > s/dose/does/
> >=20
> >> +		 * the VIN hardware to combine the two fields.
> >> +		 */
> >> +		fmt.format.field =3D V4L2_FIELD_INTERLACED;
> >> +		fmt.format.height *=3D 2;
> >> +		break;
> >=20
> > I don't like this much. The rvin_get_source_format() function is suppos=
ed
> > to return the media bus format for the bus between the source and the
> > VIN. It's the caller that should take the field limitations into accoun=
t,
> > otherwise you end up with a mix of source and VIN data in the same
> > structure.
>=20
> When I read your comments I understand your argument better. And I
> understand this function is perhaps poorly named. Maybe it should be
> renamed to rvin_get_vin_format_from_source().

If you add a comment above the function I could live with that. Would it ma=
ke=20
sense to pass a v4l2_pix_format structure instead of a v4l2_mbus_framefmt ?

> The source format is fetched at s_stream() time in order to do format
> validation. At this time the field is also taken into account once more
> to validate that the VIN format (calculated here) still is valid. It
> also handles the question you ask later at s_stream() time, see bellow.
>=20
> >> +	default:
> >> +		vin->format.field =3D V4L2_FIELD_NONE;
> >> +		break;
> >> +	}
> >> +
> >>  	memcpy(mbus_fmt, &fmt.format, sizeof(*mbus_fmt));
> >>  =09
> >>  	return 0;
> >> @@ -139,33 +161,6 @@ static int rvin_reset_format(struct rvin_dev *vin)
> >>=20
> >>  	v4l2_fill_pix_format(&vin->format, &source_fmt);
> >>=20
> >> -	/*
> >> -	 * If the subdevice uses ALTERNATE field mode and G_STD is
> >> -	 * implemented use the VIN HW to combine the two fields to
> >> -	 * one INTERLACED frame. The ALTERNATE field mode can still
> >> -	 * be requested in S_FMT and be respected, this is just the
> >> -	 * default which is applied at probing or when S_STD is called.
> >> -	 */
> >> -	if (vin->format.field =3D=3D V4L2_FIELD_ALTERNATE &&
> >> -	    v4l2_subdev_has_op(vin_to_source(vin), video, g_std))
> >> -		vin->format.field =3D V4L2_FIELD_INTERLACED;
> >> -
> >> -	switch (vin->format.field) {
> >> -	case V4L2_FIELD_TOP:
> >> -	case V4L2_FIELD_BOTTOM:
> >> -	case V4L2_FIELD_ALTERNATE:
> >> -		vin->format.height /=3D 2;
> >> -		break;
> >> -	case V4L2_FIELD_NONE:
> >> -	case V4L2_FIELD_INTERLACED_TB:
> >> -	case V4L2_FIELD_INTERLACED_BT:
> >> -	case V4L2_FIELD_INTERLACED:
> >> -		break;
> >> -	default:
> >> -		vin->format.field =3D V4L2_FIELD_NONE;
> >> -		break;
> >> -	}
> >> -
> >>  	ret =3D rvin_reset_crop_compose(vin);
> >>  	if (ret)
> >>  		return ret;
> >> @@ -243,12 +238,10 @@ static int __rvin_try_format(struct rvin_dev *vi=
n,
> >>  	if (ret)
> >>  		return ret;
> >>=20
> >> +	/* Reject ALTERNATE  until support is added to the driver */
> >>  	switch (pix->field) {
> >>  	case V4L2_FIELD_TOP:
> >>  	case V4L2_FIELD_BOTTOM:
> >> -	case V4L2_FIELD_ALTERNATE:
> >> -		pix->height /=3D 2;
> >> -		break;
> >>  	case V4L2_FIELD_NONE:
> >>  	case V4L2_FIELD_INTERLACED_TB:
> >>  	case V4L2_FIELD_INTERLACED_BT:
> >=20
> > You will then set the field to V4L2_FIELD_NONE, but the source will sti=
ll
> > provide V4L2_FIELD_ALTERNATE. What will happen in the VIN, what will it
> > produce ?
>=20
> As stated above this is just the format produced from the VIN to
> user-space. The source field is validated at s_stream() time, if it is
> V4L2_FIELD_ALTERNATE the driver will handle it and possibly interlace it
> depending on how the user wants to consume it, which is what is
> specified here.

That was clearer when I read the patch that implemented .start_streaming()=
=20
support for the MC mode. Defaulting to V4L2_FIELD_NONE seems fine to me.

=2D-=20
Regards,

Laurent Pinchart
