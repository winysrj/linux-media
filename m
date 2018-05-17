Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:35255 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751396AbeEQIpJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 May 2018 04:45:09 -0400
Date: Thu, 17 May 2018 10:41:56 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Niklas =?utf-8?Q?S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com, horms@verge.net.au,
        geert@glider.be, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 4/6] media: rcar-vin: Handle CLOCKENB pin polarity
Message-ID: <20180517084156.GW5956@w540>
References: <1526488352-898-1-git-send-email-jacopo+renesas@jmondi.org>
 <1526488352-898-5-git-send-email-jacopo+renesas@jmondi.org>
 <20180516221103.GE17948@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="NXxBKFTfdeXlAk+N"
Content-Disposition: inline
In-Reply-To: <20180516221103.GE17948@bigcity.dyn.berto.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--NXxBKFTfdeXlAk+N
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Niklas,

On Thu, May 17, 2018 at 12:11:03AM +0200, Niklas S=C3=B6derlund wrote:
> Hi Jacopo,
>
> Thanks for your patch.
>
> I'm happy that you dig into this as it clearly needs doing!
>
> On 2018-05-16 18:32:30 +0200, Jacopo Mondi wrote:
> > Handle CLOCKENB pin polarity, or use HSYNC in its place if polarity is
> > not specified.
> >
> > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > ---
> >  drivers/media/platform/rcar-vin/rcar-dma.c | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> >
> > diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media=
/platform/rcar-vin/rcar-dma.c
> > index ac07f99..7a84eae 100644
> > --- a/drivers/media/platform/rcar-vin/rcar-dma.c
> > +++ b/drivers/media/platform/rcar-vin/rcar-dma.c
> > @@ -123,6 +123,8 @@
> >  /* Video n Data Mode Register 2 bits */
> >  #define VNDMR2_VPS		(1 << 30)
> >  #define VNDMR2_HPS		(1 << 29)
> > +#define VNDMR2_CES		(1 << 28)
> > +#define VNDMR2_CHS		(1 << 23)
> >  #define VNDMR2_FTEV		(1 << 17)
> >  #define VNDMR2_VLV(n)		((n & 0xf) << 12)
> >
> > @@ -691,6 +693,15 @@ static int rvin_setup(struct rvin_dev *vin)
> >  		dmr2 |=3D VNDMR2_VPS;
> >
> >  	/*
> > +	 * Clock-enable active level select.
> > +	 * Use HSYNC as enable if not specified
> > +	 */
> > +	if (vin->mbus_cfg.flags & V4L2_MBUS_DATA_ACTIVE_LOW)
> > +		dmr2 |=3D VNDMR2_CES;
> > +	else if (!(vin->mbus_cfg.flags & V4L2_MBUS_DATA_ACTIVE_HIGH))
> > +		dmr2 |=3D VNDMR2_CHS;
>
> After studying the datasheet for a while I'm getting more and more
> convinced this should be (with context leftout in this patch context)
> something like this:
>
> 	/* Hsync Signal Polarity Select */
> 	if (!(vin->mbus_cfg.flags & V4L2_MBUS_HSYNC_ACTIVE_LOW))
> 	        dmr2 |=3D VNDMR2_HPS;
>
> 	/* Vsync Signal Polarity Select */
> 	if (!(vin->mbus_cfg.flags & V4L2_MBUS_VSYNC_ACTIVE_LOW))
> 	        dmr2 |=3D VNDMR2_VPS;
>
> 	/* Clock Enable Signal Polarity Select */
> 	if (!(vin->mbus_cfg.flags & V4L2_MBUS_DATA_ACTIVE_LOW))
> 	        dmr2 |=3D VNDMR2_CES;

No, set CES if V4L2_MBUS_DATA_ACTIVE_LOW is specified, not the other
way around. See the CES bit description:

        Clock Enable Signal Polarity Select
        This bit specifies the polarity of the input clock enable signal in=
 the ITU-
        R BT.601.
        0: Active high
        1: Active low
>
> 	/* Use HSYNC as clock enable if VIn_CLKENB is not available. */
> 	if (!(vin->mbus_cfg.flags & (V4L2_MBUS_DATA_ACTIVE_LOW | V4L2_MBUS_DATA_=
ACTIVE_HIGH)))
> 		dmr2 |=3D VNDMR2_CHS;
>
> Or am I misunderstanding something?

Isn't that what my code is doing?

if (flags & LOW)
        dmr2 |=3D CES;
else if (!(flags & HIGH)) // if we get here, LOW is not set too
        dmr2 |=3D CHS;

Anyway, if you agree with my previous replies, we should set CHS only
when running with explicit syncs (V4L2_MBUS_PARALLEL).

Thanks
  j
>
> > +
> > +	/*
> >  	 * Output format
> >  	 */
> >  	switch (vin->format.pixelformat) {
> > --
> > 2.7.4
> >
>
> --
> Regards,
> Niklas S=C3=B6derlund

--NXxBKFTfdeXlAk+N
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJa/UBUAAoJEHI0Bo8WoVY8ecwP/0wuQY4tZT1uqAWTPaBEe51e
j3OYKOMT46EMPdWWE/LLdXlLusxtfVMOt2jWa6oWQxGHLP0E+Nnk+WxAved2NOHL
ds557+6C9NBM8OdJXMjeqnFHkdP/8TyOHjQ5lbgM/DCZW6Hmp1CtSxuesQvYocsG
58SE4zvMftKxvraVGQIA46x/RX5ihfCK4Bs5a8Ae+hhCn7aIFjQ2Bqdg3cIafDEO
oi7PnkUIHa0W/R/ji1LjzwaYVza22MXkntPi52PBI6NZtVlKHf9Hi/aBCE7Q58J6
agXS8WqknuY5OQqqZOJCkYpezKmZaScM19gsoFlHn2uvxSLAIuRo03oViUbZRLIE
ynVreoglDPGhMxmLr2wZaqUhds+zN8YwzByJhhjH16qOT3gR7UrToLfWpOT4u48P
ggFFIGFtFcNdBdFcRYvYkJjU+EYzc5YK7i2xJWM8AzOXmyj/4qXTnQ0YlfL/Zy3Y
r/jScORcENm7NH+syX3eqVq1zhPAmhiphoDYSG1eGuS1+ZNAvn2GSvQm6EVwjmxr
leIDb8yGJv3aBi8YkhYIgtwXNAHmZ5H77F/C19uZ6bHzgHTuKypKrSP+u1OpwL5y
Fv/2luidEn7NJG9Hip4ooaXL/g7KSHzZ7IqrY7IYo2rFvbGg2bmsfpTBZaipmapY
zQqk0rPLCQdjP48Uzqxp
=JmSW
-----END PGP SIGNATURE-----

--NXxBKFTfdeXlAk+N--
