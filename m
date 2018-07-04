Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:35801 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932290AbeGDHt7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Jul 2018 03:49:59 -0400
Date: Wed, 4 Jul 2018 09:49:46 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Simon Horman <horms@verge.net.au>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v6 10/10] media: rcar-vin: Add support for R-Car R8A77995
 SoC
Message-ID: <20180704074946.GA1240@w540>
References: <1528796612-7387-1-git-send-email-jacopo+renesas@jmondi.org>
 <1528796612-7387-11-git-send-email-jacopo+renesas@jmondi.org>
 <1fc42981-2269-d6f5-921d-6730661542c7@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="a8Wt8u1KmwUX3Y2C"
Content-Disposition: inline
In-Reply-To: <1fc42981-2269-d6f5-921d-6730661542c7@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Hans,

On Wed, Jul 04, 2018 at 09:36:34AM +0200, Hans Verkuil wrote:
> On 12/06/18 11:43, Jacopo Mondi wrote:
> > Add R-Car R8A77995 SoC to the rcar-vin supported ones.
> >
> > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > Reviewed-by: Niklas S=C3=B6derlund <niklas.soderlund+renesas@ragnatech.=
se>
> > Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>
> Checkpatch reports:
>
> WARNING: DT compatible string "renesas,vin-r8a77995" appears un-documente=
d -- check ./Documentation/devicetree/bindings/
> #29: FILE: drivers/media/platform/rcar-vin/rcar-core.c:1150:
> +               .compatible =3D "renesas,vin-r8a77995",
>
> I'll still accept this series since this compatible string is already use=
d in
> a dtsi, but if someone can document this for the bindings?

A patch has been sent on May 21st for this
https://patchwork.kernel.org/patch/10415587/

Bindings documentation usually gets in a release later than bindings
users, to give time to bindings to be changed eventually before
being documented.

Simon, Geert, is this correct?

Thanks
  j

>
> Regards,
>
> 	Hans
>
> > ---
> >  drivers/media/platform/rcar-vin/rcar-core.c | 16 ++++++++++++++++
> >  1 file changed, 16 insertions(+)
> >
> > diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/medi=
a/platform/rcar-vin/rcar-core.c
> > index a2d166f..bd99d56 100644
> > --- a/drivers/media/platform/rcar-vin/rcar-core.c
> > +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> > @@ -1045,6 +1045,18 @@ static const struct rvin_info rcar_info_r8a77970=
 =3D {
> >  	.routes =3D rcar_info_r8a77970_routes,
> >  };
> >
> > +static const struct rvin_group_route rcar_info_r8a77995_routes[] =3D {
> > +	{ /* Sentinel */ }
> > +};
> > +
> > +static const struct rvin_info rcar_info_r8a77995 =3D {
> > +	.model =3D RCAR_GEN3,
> > +	.use_mc =3D true,
> > +	.max_width =3D 4096,
> > +	.max_height =3D 4096,
> > +	.routes =3D rcar_info_r8a77995_routes,
> > +};
> > +
> >  static const struct of_device_id rvin_of_id_table[] =3D {
> >  	{
> >  		.compatible =3D "renesas,vin-r8a7778",
> > @@ -1086,6 +1098,10 @@ static const struct of_device_id rvin_of_id_tabl=
e[] =3D {
> >  		.compatible =3D "renesas,vin-r8a77970",
> >  		.data =3D &rcar_info_r8a77970,
> >  	},
> > +	{
> > +		.compatible =3D "renesas,vin-r8a77995",
> > +		.data =3D &rcar_info_r8a77995,
> > +	},
> >  	{ /* Sentinel */ },
> >  };
> >  MODULE_DEVICE_TABLE(of, rvin_of_id_table);
> >
>

--a8Wt8u1KmwUX3Y2C
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbPHwaAAoJEHI0Bo8WoVY8jyEP+wSIYAmmb9Jj0Xok/7dqiVPT
yv3bwEmX4YZkINO1DXKjA9Y8wWyhVN7dzyM9+cXJyHZuAJRdgQAk/7nGyPX/ScUa
l451Wgnn0k+5bxQQwUCoY3pVj55PP/fYttuEDmmWkpUKFIdfa0YSdgdwLFkkFTEs
3yL1fnjz9i7lgnIPaFsNL/lIPHk166jUg52QVD06m+6veDAwesDB/DF1vNFCBTGq
LowRZDurE2etFpQUhY5EAy9OaEwqlGGOJ3m5yQjivMjJipkj86ETflwpCwa4zjq7
vAMvQpiUkkOXRJ0kQHBf1SZRejV4qSNTFIQ0TiVsnBySsKksnl+Eq7BhkLDKr9sJ
IkjUy4lr5pV2Mi07N4RDFTWR7nEWpXTbgN44awr7qZ/Wls8QOZW3hih+Hms0FU0i
gbVMuzsjAhFA5LBzFUhGbN8/WjIkvcP5NgPYYtPReCNWujZ7jBkP3+AA7HriOy9q
SGHxQGSsYw3N1nkk0KrrYOFrsDJ9w4gJxlU93fB8vjWsvZYuJbn5t1bfEvGd9xhV
LHRsnQ1iBsoC8t04XJmgWydiC704/Eb/0Nu2vFuNPYOa7paq2FK/LTxrKr/Mz1Yv
ofjcrE7aZIVx1o5m0i5zfDD+L51bIoSAmfF6YY4mnsfWDaM9SBBva6//y2fY4ZHL
1jrfbaYx8OPjTxD4i05l
=nVFE
-----END PGP SIGNATURE-----

--a8Wt8u1KmwUX3Y2C--
