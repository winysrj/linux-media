Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51624 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753356AbdLHTaW (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Dec 2017 14:30:22 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v9 13/28] rcar-vin: fix handling of single field frames (top, bottom and alternate fields)
Date: Fri, 08 Dec 2017 21:30:20 +0200
Message-ID: <1586141.S8o2anPbt6@avalon>
In-Reply-To: <20171208140658.GP31989@bigcity.dyn.berto.se>
References: <20171208010842.20047-1-niklas.soderlund+renesas@ragnatech.se> <1830403.Cn442MVTMc@avalon> <20171208140658.GP31989@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

On Friday, 8 December 2017 16:06:58 EET Niklas S=F6derlund wrote:
> On 2017-12-08 11:35:18 +0200, Laurent Pinchart wrote:
> > On Friday, 8 December 2017 03:08:27 EET Niklas S=F6derlund wrote:
> >> There was never proper support in the VIN driver to deliver ALTERNATING
> >> field format to user-space, remove this field option. For sources using
> >> this field format instead use the VIN hardware feature of combining the
> >> fields to an interlaced format. This mode of operation was previously
> >> the default behavior and ALTERNATING was only delivered to user-space =
if
> >> explicitly requested. Allowing this to be explicitly requested was a
> >> mistake and was never properly tested and never worked due to the
> >> constraints put on the field format when it comes to sequence numbers
> >> and timestamps etc.
> >=20
> > I'm puzzled, why can't we support V4L2_FIELD_ALTERNATE if we can support
> > V4L2_FIELD_TOP and V4L2_FIELD_BOTTOM ? I don't dispute the fact that the
> > currently implemented logic might be wrong (although I haven't
> > double-checked that), but what prevents us from implementing it correct=
ly
> > ?
>=20
> Maybe my commit message is fuzzy. We can support V4L2_FIELD_ALTERNATE as
> a source to the VIN but we can't (yet) support delivering it to
> user-space in a good way. So if we have a video source which outputs
> V4L2_FIELD_ALTERNATE we are fine as we can use the hardware to interlace
> that or only capture the TOP or BOTTOM fields.
>=20
> But the driver logic to capture frames (the whole dance with single and
> continues capture modes) to be able to deal with situations where
> buffers are not queued fast enough currently prevents us from delivering
> V4L2_FIELD_ALTERNATE to user-space. The problem is we can only capture
> (correctly) ALTERNATE if we run in continues mode, if the driver is feed
> buffers to slow and switches to single capture mode we can't live up to
> the specification of the field order from the documentation:
>=20
> "If fields are successive, without any dropped fields between them
> (fields can drop individually), can be determined from the struct
> v4l2_buffer sequence field."
>=20
> So even if in single capture mode we switch between TOP and BOTTOM for
> each capture the sequence number would always be sequential but the
> fields would in temporal time potentially be far apparat (depending on
> how fast user-space queues buffers + the time it takes to shutdown and
> startup the VIN capture).
>=20
> So instead of badly supporting this field order now I feel it's better
> to not support it and once we tackle the issue of trying to remove
> single capture mode (if at all possible) add support for it. But this is
> a task for a different patch-set as this one is quiet large already and
> it's focus is to add Gen3 support.

OK, so we could support capturing alternating fields, but in that case we=20
wouldn't be able to provide accurate sequence numbers. I'm fine with droppi=
ng=20
support for ALTERNATE, but I would capture that information in the commit=20
message, and probably as well in a comment in the code.

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
> >>  drivers/media/platform/rcar-vin/rcar-dma.c  | 15 +--------
> >>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 48 +++++++++-----------=
=2D--
> >>  2 files changed, 19 insertions(+), 44 deletions(-)

[snip]

> >> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> >> b/drivers/media/platform/rcar-vin/rcar-v4l2.c index
> >> 9cf9ff48ac1e2f4f..37fe1f6c646b0ea3 100644
> >> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> >> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> >> @@ -102,6 +102,24 @@ static int rvin_get_sd_format(struct rvin_dev *vi=
n,
> >> struct v4l2_pix_format *pix)
> >> 	if (ret)
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
> >> +		/* Use VIN hardware to combine the two fields */
> >> +		fmt.format.field =3D V4L2_FIELD_INTERLACED;
> >> +		fmt.format.height *=3D 2;
> >> +		break;
> >=20
> > I don't think this is right. If V4L2_FIELD_ALTERNATE isn't supported it
> > should be rejected in the set format handler, or rather this logic shou=
ld
> > be moved there. It doesn't belong here, rvin_get_sd_format() should only
> > be called with a validated and supported field.
>=20
> I might misunderstand you here, fmt.format.field comes from a the
> subdevice, just above this:
>=20
>     struct v4l2_subdev_format fmt =3D {
> 	    .which =3D V4L2_SUBDEV_FORMAT_ACTIVE,
> 	    .pad =3D vin->digital->source_pad,
>     };
>     int ret;
>=20
>     ret =3D v4l2_subdev_call(vin_to_source(vin), pad, get_fmt, NULL, &fmt=
);
>     if (ret)
> 	    return ret;
>=20
>     switch (fmt.format.field) {
>         ...
>     }
>=20
> So the format acted on here is the one from the subdevice, and if it is
> V4L2_FIELD_ALTERNATE it is supported as a source format, just not for
> output to user-space.
>=20
> > Furthermore treating the pix parameter of this function as both input a=
nd
> > output seems very confusing to me. If you want to extend
> > rvin_get_sd_format() beyond just getting the format from the subdev then
> > please document the function with kerneldoc, and let's try to make its
> > API clear.
>=20
> This comment confuses me, are we looking at the same change? The only
> reference I have to the pix parameter in rvin_get_sd_format() is just
> before the function returns and it's:
>=20
>    v4l2_fill_pix_format(pix, &fmt.format);
>=20
> So it's only used as an output for this function.

I had mistakenly read the switch statement as operating on the pix function=
=20
parameter. My bad, sorry about the noise.

However, V4L2_FIELD_ALTERNATE should still be rejected in the set format=20
handler, and I don't think you do so in this patch.

It looks like the field handling logic needs a rewrite :-)

> >> +	default:
> >> +		vin->format.field =3D V4L2_FIELD_NONE;
> >> +		break;
> >> +	}
> >> +
> >>  	v4l2_fill_pix_format(pix, &fmt.format);
> >>  =09
> >>  	return 0;

[snip]

=2D-=20
Regards,

Laurent Pinchart
