Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:36981 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751017AbeEQIaK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 May 2018 04:30:10 -0400
Date: Thu, 17 May 2018 10:30:00 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Niklas =?utf-8?Q?S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com, horms@verge.net.au,
        geert@glider.be, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 3/6] media: rcar-vin: Handle data-active property
Message-ID: <20180517083000.GV5956@w540>
References: <1526488352-898-1-git-send-email-jacopo+renesas@jmondi.org>
 <1526488352-898-4-git-send-email-jacopo+renesas@jmondi.org>
 <20180516215847.GD17948@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="i6WX/W6h5xa4jqsd"
Content-Disposition: inline
In-Reply-To: <20180516215847.GD17948@bigcity.dyn.berto.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--i6WX/W6h5xa4jqsd
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Niklas,

On Wed, May 16, 2018 at 11:58:47PM +0200, Niklas S=C3=B6derlund wrote:
> Hi Jacopo,
>
> Thanks for your work.
>
> On 2018-05-16 18:32:29 +0200, Jacopo Mondi wrote:
> > The data-active property has to be specified when running with embedded
> > synchronization. The VIN peripheral can use HSYNC in place of CLOCKENB
> > when the CLOCKENB pin is not connected, this requires explicit
> > synchronization to be in use.
>
> Is this really the intent of the data-active property? I read the
> video-interfaces.txt document as such as if no hsync-active,
> vsync-active and data-active we should use the embedded synchronization
> else set the polarity for the requested pins. What am I not
> understanding here?

Almost correct.

The presence of hsync-active, vsync-active and field-evev-active
properties determinate the bus type we're running on. If none of the
is specified, the bus is marked 'BT656' and we assume the system is
using embedded synchronization.

data-active does not take part in the bus identification, and my
reasoning was the other way around as explained in reply to your
comment on [2/6], and as explained there my reasoning is probably
wrong, and we should set CHS -only- when running with explicit
synchronization, instead of making it mandatory when running with
embedded syncs.

Thanks and sorry for my confusion.

    j
>
> >
> > Now that the driver supports 'data-active' property, it makes not sense
> > to zero the mbus configuration flags when running with implicit synch
> > (V4L2_MBUS_BT656).
> >
> > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > ---
> >  drivers/media/platform/rcar-vin/rcar-core.c | 10 ++++++++--
> >  1 file changed, 8 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/medi=
a/platform/rcar-vin/rcar-core.c
> > index d3072e1..075d08f 100644
> > --- a/drivers/media/platform/rcar-vin/rcar-core.c
> > +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> > @@ -531,15 +531,21 @@ static int rvin_digital_parse_v4l2(struct device =
*dev,
> >  		return -ENOTCONN;
> >
> >  	vin->mbus_cfg.type =3D vep->bus_type;
> > +	vin->mbus_cfg.flags =3D vep->bus.parallel.flags;
> >
> >  	switch (vin->mbus_cfg.type) {
> >  	case V4L2_MBUS_PARALLEL:
> >  		vin_dbg(vin, "Found PARALLEL media bus\n");
> > -		vin->mbus_cfg.flags =3D vep->bus.parallel.flags;
> >  		break;
> >  	case V4L2_MBUS_BT656:
> >  		vin_dbg(vin, "Found BT656 media bus\n");
> > -		vin->mbus_cfg.flags =3D 0;
> > +
> > +		if (!(vin->mbus_cfg.flags & V4L2_MBUS_DATA_ACTIVE_HIGH) &&
> > +		    !(vin->mbus_cfg.flags & V4L2_MBUS_DATA_ACTIVE_LOW)) {
> > +			vin_err(vin,
> > +				"Missing data enable signal polarity property\n");
>
> I fear this can't be an error as that would break backward comp ability
> with existing dtb's.
>
> > +			return -EINVAL;
> > +		}
> >  		break;
> >  	default:
> >  		vin_err(vin, "Unknown media bus type\n");
> > --
> > 2.7.4
> >
>
> --
> Regards,
> Niklas S=C3=B6derlund

--i6WX/W6h5xa4jqsd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJa/T2IAAoJEHI0Bo8WoVY8ZngQALr1/wUgjDmaTuwOvF0rx6Js
1VCZdcCxTfC3hoBsSMtHGGiedcA+HbIzS+yup6zycn/fecwxYP1iO4ZyfzacOLjl
g/3ax+yKmDBHsUSVHkj0XH+z+f7xKYLFGnVIPg4GE+W0w8JLhTVrMAzPNuHUPVke
DO8720pcLMe3mn4m1DKVOPhEdZ3SUuZUwfG4EXI15jpVGu4v0NsvlmtM8bK7vZiA
vBUllfxDB9NwWte7RgnuATNQDXoHxFPFrZAZaks6hDmfxK2saFPb6QEEMjRqvF/0
OPt4QM45gW2k3uLVjd8jqjBUqCp8hzAZyuUfzw/879Z5f3ivvAZL5KCRnANmMYXK
yYDh+wy65qNlzoU8iox7h3E97ZMz9RiR7gVlk53Gydd7SJTsNJ9Q+qlTMXOFMKH5
FoPwHWo30jpwAC/sYALZEgFeq73WK3C3ISMPxCSvJbk6Ftc7L1GDyw92CqvdYszJ
wZRNkR0jDcUaG8Ykcx3f35mikldvE3P4NETLMj0NCjm9cPYBlErtHsnQ3qZuxF4A
uL9OqHmen62s8YBAgXnLSP03NKXgFlN4xaPRYYe/0dV90R6l4m8lImc1TVRVTr+a
h9FgMoPLdhT/1iRsfeQIuD1HRg7Pb0hyDRV8NEDFaW8jPKkEj5PmiY1cpuJgz2tq
qdG4ykG8OyExrIaXev/H
=9bfw
-----END PGP SIGNATURE-----

--i6WX/W6h5xa4jqsd--
