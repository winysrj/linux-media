Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:53537 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966007AbeBMX2D (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Feb 2018 18:28:03 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v10 10/30] rcar-vin: fix handling of single field frames (top, bottom and alternate fields)
Date: Wed, 14 Feb 2018 01:28:34 +0200
Message-ID: <6569122.ZeLMKUb12N@avalon>
In-Reply-To: <20180213231250.GA23581@bigcity.dyn.berto.se>
References: <20180129163435.24936-1-niklas.soderlund+renesas@ragnatech.se> <3791727.mLP5MD9T4p@avalon> <20180213231250.GA23581@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

On Wednesday, 14 February 2018 01:12:50 EET Niklas S=F6derlund wrote:
> On 2018-02-14 00:31:21 +0200, Laurent Pinchart wrote:
> > On Tuesday, 13 February 2018 18:47:04 EET Niklas S=F6derlund wrote:
> >> On 2018-02-13 18:26:34 +0200, Laurent Pinchart wrote:
> >>> On Monday, 29 January 2018 18:34:15 EET Niklas S=F6derlund wrote:
> >>>> There was never proper support in the VIN driver to deliver
> >>>> ALTERNATING field format to user-space, remove this field option. The
> >>>> problem is that ALTERNATING filed order requires the sequence numbers
> >>>> of buffers returned to userspace to reflect if fields where dropped =
or
> >>>> not, something which is not possible with the VIN drivers capture
> >>>> logic.
> >>>>=20
> >>>> The VIN driver can still capture from a video source which delivers
> >>>> frames in ALTERNATING field order, but needs to combine them using
> >>>> the VIN hardware into INTERLACED field order. Before this change if a
> >>>> source was delivering fields using ALTERNATE the driver would default
> >>>> to combining them using this hardware feature. Only if the user
> >>>> explicitly requested ALTERNATE filed order would incorrect frames be
> >>>> delivered.
> >>>>=20
> >>>> The height should not be cut in half for the format for TOP or BOTTOM
> >>>> fields settings. This was a mistake and it was made visible by the
> >>>> scaling refactoring. Correct behavior is that the user should request
> >>>> a frame size that fits the half height frame reflected in the field
> >>>> setting. If not the VIN will do its best to scale the top or bottom
> >>>> to the requested format and cropping and scaling do not work as
> >>>> expected.
> >>>>=20
> >>>> Signed-off-by: Niklas S=F6derlund
> >>>> <niklas.soderlund+renesas@ragnatech.se>
> >>>> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
> >>>> ---
> >>>>=20
> >>>>  drivers/media/platform/rcar-vin/rcar-dma.c  | 15 +-------
> >>>>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 53
> >>>>  +++++++++++------------
> >>>>  2 files changed, 24 insertions(+), 44 deletions(-)
> >=20
> > [snip]
> >=20
> >>>> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> >>>> b/drivers/media/platform/rcar-vin/rcar-v4l2.c index
> >>>> 4d5be2d0c79c9c9a..9f7902d29c62e205 100644
> >>>> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> >>>> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> >>>> @@ -103,6 +103,28 @@ static int rvin_get_source_format(struct
> >>>> rvin_dev *vin,
> >>>>  	if (ret)
> >>>>  		return ret;
> >>>>=20
> >>>> +	switch (fmt.format.field) {
> >>>> +	case V4L2_FIELD_TOP:
> >>>> +	case V4L2_FIELD_BOTTOM:
> >>>> +	case V4L2_FIELD_NONE:
> >>>> +	case V4L2_FIELD_INTERLACED_TB:
> >>>> +	case V4L2_FIELD_INTERLACED_BT:
> >>>> +	case V4L2_FIELD_INTERLACED:
> >>>> +		break;
> >>>> +	case V4L2_FIELD_ALTERNATE:
> >>>> +		/*
> >>>> +		 * Driver do not (yet) support outputting ALTERNATE to a
> >>>> +		 * userspace. It dose support outputting INTERLACED so use
> >>>=20
> >>> s/dose/does/
> >>>=20
> >>>> +		 * the VIN hardware to combine the two fields.
> >>>> +		 */
> >>>> +		fmt.format.field =3D V4L2_FIELD_INTERLACED;
> >>>> +		fmt.format.height *=3D 2;
> >>>> +		break;
> >>>=20
> >>> I don't like this much. The rvin_get_source_format() function is
> >>> supposed to return the media bus format for the bus between the source
> >>> and the VIN. It's the caller that should take the field limitations i=
nto
> >>> account, otherwise you end up with a mix of source and VIN data in the
> >>> same structure.
> >>=20
> >> When I read your comments I understand your argument better. And I
> >> understand this function is perhaps poorly named. Maybe it should be
> >> renamed to rvin_get_vin_format_from_source().
> >=20
> > If you add a comment above the function I could live with that. Would it
> > make sense to pass a v4l2_pix_format structure instead of a
> > v4l2_mbus_framefmt ?
>=20
> I now see that the function name is misleading and I will change it as
> per above. I will also add a comment and swap to v4l2_pix_format (which
> was used before v10 but was changed due to your review comments, I'm
> happy you come around :-)

The argument type has to be consistent with the function's purpose and name=
=2E=20
Now that you propose changing the function's purpose, my previous comments=
=20
have to be updated. And I'm annoyed that you have such a good memory, it=20
forces me to invent excuses :-)

> >> The source format is fetched at s_stream() time in order to do format
> >> validation. At this time the field is also taken into account once more
> >> to validate that the VIN format (calculated here) still is valid. It
> >> also handles the question you ask later at s_stream() time, see bellow.
> >>=20
> >>>> +	default:
> >>>> +		vin->format.field =3D V4L2_FIELD_NONE;
> >>>> +		break;
> >>>> +	}
> >>>> +
> >>>>  	memcpy(mbus_fmt, &fmt.format, sizeof(*mbus_fmt));
> >>>>  =09
> >>>>  	return 0;

[snip]

=2D-=20
Regards,

Laurent Pinchart
