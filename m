Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:49467 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933560AbeGDII1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Jul 2018 04:08:27 -0400
Date: Wed, 4 Jul 2018 10:08:22 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Simon Horman <horms@verge.net.au>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Niklas =?utf-8?Q?S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Subject: Re: [PATCH v6 10/10] media: rcar-vin: Add support for R-Car R8A77995
 SoC
Message-ID: <20180704080822.GB1240@w540>
References: <1528796612-7387-1-git-send-email-jacopo+renesas@jmondi.org>
 <1528796612-7387-11-git-send-email-jacopo+renesas@jmondi.org>
 <1fc42981-2269-d6f5-921d-6730661542c7@xs4all.nl>
 <20180704074946.GA1240@w540>
 <CAMuHMdWK-1q-gkCMRkWJPMoeYgn1RoJC=Xjey3TA+ipiQzmFpQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="v9Ux+11Zm5mwPlX6"
Content-Disposition: inline
In-Reply-To: <CAMuHMdWK-1q-gkCMRkWJPMoeYgn1RoJC=Xjey3TA+ipiQzmFpQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--v9Ux+11Zm5mwPlX6
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Geert,

On Wed, Jul 04, 2018 at 10:00:56AM +0200, Geert Uytterhoeven wrote:
> Hi Jacopo,
>
> On Wed, Jul 4, 2018 at 9:49 AM jacopo mondi <jacopo@jmondi.org> wrote:
> > On Wed, Jul 04, 2018 at 09:36:34AM +0200, Hans Verkuil wrote:
> > > On 12/06/18 11:43, Jacopo Mondi wrote:
> > > > Add R-Car R8A77995 SoC to the rcar-vin supported ones.
> > > >
> > > > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > > > Reviewed-by: Niklas S=C3=B6derlund <niklas.soderlund+renesas@ragnat=
ech.se>
> > > > Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > >
> > > Checkpatch reports:
> > >
> > > WARNING: DT compatible string "renesas,vin-r8a77995" appears un-docum=
ented -- check ./Documentation/devicetree/bindings/
> > > #29: FILE: drivers/media/platform/rcar-vin/rcar-core.c:1150:
> > > +               .compatible =3D "renesas,vin-r8a77995",
> > >
> > > I'll still accept this series since this compatible string is already=
 used in
> > > a dtsi, but if someone can document this for the bindings?
> >
> > A patch has been sent on May 21st for this
> > https://patchwork.kernel.org/patch/10415587/
> >
> > Bindings documentation usually gets in a release later than bindings
> > users, to give time to bindings to be changed eventually before
> > being documented.
> >
> > Simon, Geert, is this correct?
>
> Hmm, not 100% ;-)
>
> Usually the binding update for a trivial one like this goes in _in parall=
el_
> with its user in a .dtsi.  So it happens from time to time that the bindi=
ng
> update is delayed by one kernel release (or more).
>

Thanks for clarifying

> This one is a bit special, as it seems a driver update is needed, too?
> So I'd expect the binding update would be part of this series.
> But that may be a bit too naive on my side, as I don't follow multimedia
> development that closely.

I sent dts and driver updates in two different series, and this last
patch is the only one that was not collected.
https://patchwork.kernel.org/patch/10415587/

Hans is taking care of taking the driver updates, should I notify you
and Simon once those patches land on the media master branch ?

Thanks
  j

>
> > > > --- a/drivers/media/platform/rcar-vin/rcar-core.c
> > > > +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> > > > @@ -1045,6 +1045,18 @@ static const struct rvin_info rcar_info_r8a7=
7970 =3D {
> > > >     .routes =3D rcar_info_r8a77970_routes,
> > > >  };
> > > >
> > > > +static const struct rvin_group_route rcar_info_r8a77995_routes[] =
=3D {
> > > > +   { /* Sentinel */ }
> > > > +};
> > > > +
> > > > +static const struct rvin_info rcar_info_r8a77995 =3D {
> > > > +   .model =3D RCAR_GEN3,
> > > > +   .use_mc =3D true,
> > > > +   .max_width =3D 4096,
> > > > +   .max_height =3D 4096,
> > > > +   .routes =3D rcar_info_r8a77995_routes,
> > > > +};
> > > > +
> > > >  static const struct of_device_id rvin_of_id_table[] =3D {
> > > >     {
> > > >             .compatible =3D "renesas,vin-r8a7778",
> > > > @@ -1086,6 +1098,10 @@ static const struct of_device_id rvin_of_id_=
table[] =3D {
> > > >             .compatible =3D "renesas,vin-r8a77970",
> > > >             .data =3D &rcar_info_r8a77970,
> > > >     },
> > > > +   {
> > > > +           .compatible =3D "renesas,vin-r8a77995",
> > > > +           .data =3D &rcar_info_r8a77995,
> > > > +   },
> > > >     { /* Sentinel */ },
> > > >  };
> > > >  MODULE_DEVICE_TABLE(of, rvin_of_id_table);
>
> Gr{oetje,eeting}s,
>
>                         Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m6=
8k.org
>
> In personal conversations with technical people, I call myself a hacker. =
But
> when I'm talking to journalists I just say "programmer" or something like=
 that.
>                                 -- Linus Torvalds

--v9Ux+11Zm5mwPlX6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbPIB2AAoJEHI0Bo8WoVY86aMP+wfLNWZcMUIJI1AiXM/HuXzi
zVB7SC7iiniwLucRklmc52IFcq/fopDdkReHKdftz4VIgcofh3RP0NiC4dSbzkml
vu5iJE86soNlKG7saoa0dMfgtyLI3B7Y6Q4irxUYekClMz0AXaoCZiapl2zUA1y5
hO8M7Xjhv07rdR1VKTtxzMtQVziWuaoXxSJfl6AFqqz+OFVN6Hz+uKCIOJTaybmA
0ZEHD5rohBW0ahE7171Di54jLXwcdJcIUTzzqCa2D6xF1rxwcaimt3EW4h+CJeFo
eted95pZmyM7EBUdA8+YLmjKuZNMI6ecxi9pofdWDthXDxK7YpkPKCkw/735x9NZ
LDIWjQQpzCZFRuMoEadk7hg3e+EdXTyYo3xAtqhuyWTsvKdNZWrKNNfFuQ8s8G8O
sLV+7CjeR+IkqzNf2fXo62lnusoi38wyIDmTvPJm3PgkVK1TjGPsOpkhUUfuUsLb
TcecJTijB20elNbeVsMimsMSUXIkVaqOmE7ShCCAm8On1m5Bk3gOC9IFBZ369bfV
JBKvkDlGbiywzX+M2dyDfORrN9QzBCqW3jwccDr2RjvrKfk6vTkb1PG4yBGiyjev
LiUfL/4256U9JfoCMtaHK5mxFKrjZzA7u6fvj6AhWrOI8QevEFI9KTTFeigL8l/i
YLXVtIJBkR0GvdykN7QG
=ymoj
-----END PGP SIGNATURE-----

--v9Ux+11Zm5mwPlX6--
