Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:55845 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752136AbeENIG5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 May 2018 04:06:57 -0400
Date: Mon, 14 May 2018 10:06:46 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Niklas =?utf-8?Q?S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 2/5] media: rcar-vin: Add digital input subdevice parsing
Message-ID: <20180514080646.GB5956@w540>
References: <1526032781-14319-1-git-send-email-jacopo+renesas@jmondi.org>
 <1526032781-14319-3-git-send-email-jacopo+renesas@jmondi.org>
 <20180511110124.GC18974@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="+nBD6E3TurpgldQp"
Content-Disposition: inline
In-Reply-To: <20180511110124.GC18974@bigcity.dyn.berto.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--+nBD6E3TurpgldQp
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Niklas,

On Fri, May 11, 2018 at 01:01:24PM +0200, Niklas S=C3=B6derlund wrote:
> Hi Jacopo,
>
> Thanks for your work!
>
> The comments here apply to both 2/5 and 3/5.
>
> On 2018-05-11 11:59:38 +0200, Jacopo Mondi wrote:
> > Add support for digital input subdevices to Gen-3 rcar-vin.
> > The Gen-3, media-controller compliant, version has so far only accepted
> > CSI-2 input subdevices. Remove assumptions on the supported bus_type and
> > accepted number of subdevices, and allow digital input connections on p=
ort@0.
>
> I feel this much more complex then it has to be. You defer parsing the
> DT graph until all VIN's are probed just like it's done for the port@1
> parsing. For the CSI-2 endpoints in port@1 this is needed as they are
> shared for all VIN's in the group. While for the parallel input this is
> local for each VIN and could be parsed at probe time for each individual
> VIN. As a bonus for doing that I think you could reuse the parallel
> parsing functions from the Gen2 code whit small additions.
>
> Maybe something like this can be done:
>
> - At each VIN probe() rework the block
>
>     if (vin->info->use_mc)
> 	    ret =3D rvin_mc_init(vin);
>     else
> 	    ret =3D rvin_digital_graph_init(vin);
>
>   To:
>     ret =3D rvin_digital_graph_init(vin);
>     ...
>     ret =3D rvin_mc_init(vin);
>     ...
>
> - Then in rvin_digital_graph_init() don't call
>   v4l2_async_notifier_register() if vin->info->use_mc is set.
>
>   And instead as a last step in rvin_mc_init() call
>   v4l2_async_notifier_register() for each vin->notifier that contains a
>   subdevice.
>
> - As a last step add a check for vin->info->use_mc in
>   rvin_digital_notify_complete() and handle the case for Gen2 behavior
>   (what it does now) and Gen3 behavior (adding the MC link).
>
>
> I think my doing this you could greatly simplify the process of handling
> the parallel subdevice.
>
> Please see bellow for one additional comment.

Thanks for the suggestion.
My understanding was that the 'Gen2' was planned for removal in the
long term, and we should have paved the road for a
media-controller-only version of the driver. But I admit I didn't even
try to re-use that code part, I'll give your suggestions a spin, if
this won't prevent future removal of the non-mc part of the driver.
>
> >
> > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > ---
> >  drivers/media/platform/rcar-vin/rcar-core.c | 166 ++++++++++++++++++++=
+++-----
> >  drivers/media/platform/rcar-vin/rcar-vin.h  |  13 +++
> >  2 files changed, 153 insertions(+), 26 deletions(-)
> >
> > diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/medi=
a/platform/rcar-vin/rcar-core.c
> > index e547ef7..105b6b6 100644
> > --- a/drivers/media/platform/rcar-vin/rcar-core.c
> > +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> > @@ -697,29 +697,21 @@ static const struct v4l2_async_notifier_operation=
s rvin_group_notify_ops =3D {
> >  	.complete =3D rvin_group_notify_complete,

[snip]

> > +
> > +	switch (vep->base.port) {
> > +	case RVIN_PORT_DIGITAL:
> > +		ret =3D rvin_mc_parse_of_digital(vin, vep, asd);
> > +		break;
> > +	case RVIN_PORT_CSI2:
> > +	default:
> > +		ret =3D rvin_mc_parse_of_csi2(vin, vep, asd);
> > +		break;
> > +	}
> > +		/*

[snip]

> > +
> > +		switch (ep.port) {
> > +		case RVIN_PORT_DIGITAL:
> > +			asd_struct_size =3D sizeof(struct rvin_graph_entity);
> > +			break;
> > +		case RVIN_PORT_CSI2:
> > +			asd_struct_size =3D sizeof(struct v4l2_async_subdev);
> > +			break;
> > +		default:
> >  };

[snip]

> >
> >  /**
> > + * enum rvin_port_id
> > + *
> > + * List the available VIN port functions.
> > + *
> > + * RVIN_PORT_DIGITAL	- Input port for digital video connection
> > + * RVIN_PORT_CSI2	- Input port for CSI-2 video connection
> > + */
> > +enum rvin_port_id {
> > +	RVIN_PORT_DIGITAL,
> > +	RVIN_PORT_CSI2
> > +};
>
> This enum is never used in the patch-set is it used later by a different
> patch-set or a left over from refactoring?

I see two occurencies each of this enumeration members in this patch.
I left them un-cut above.

Thanks
   j

--+nBD6E3TurpgldQp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJa+UOWAAoJEHI0Bo8WoVY8LEEP/3h5vaAteTQcy1qtEaY291/R
CsAjd+WapFrdIlWxRLOjUN+v6r4O/+T8FGlvc4Iht3o323GMtFn3BJkFL/RXpUdc
DKFuQJTSpsJcJgPyW0P/LvtuiI5W3WR0dIxUV5BqRdBV4CMtIKlIxSPD9F6s1Sm6
nPJv+zwAIOdSqs5AltHOCFdeUHUvH51e66yRx5hQdOMTuAWeBL0sTv6V4YyfzgYT
fZXUP+cJaNeSJVITaHbWCOipH5la2nK3AiJZauWOZd3eApbeRjc2+B+DwWhDs+mi
JcIZXqg/O2U5WFL+118kcM/KnXwWxeyu5VGNGeh+Ags7+eI39dq1JZp4sqR1ppHk
uktRkR1iUAhdD+DImLxLzX84BMe+Ix76UW7fZGSRjElrNZ5KfrWhQDACUNuErGYE
Xwo23IvLyaorU4o6eo3qdsleyBs2QsOiiRoxCDtzvFzk+T6NIDIxBe0+hjrbLbCG
Yq5Hx0OuexugpgxOzKFLxHWD6igQJiN3lOqQ0xSe0tCJRA2cgrbFO8cb5iRxFYJ2
waCpKjnZX+vLIYlcYTxdE58aigLDEgLZ1tczu0avRb17iLjy0FFMNidQGjNdQ7z9
fQd0iJ2lnFP2poiUfewfokfIV0SFUSQFtTjWslreRZZ0VhxRwAAHOe8ern5kE4oG
FgoidgeImC/dVCIxpAxw
=VUs5
-----END PGP SIGNATURE-----

--+nBD6E3TurpgldQp--
