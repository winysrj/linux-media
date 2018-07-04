Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:39215 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933862AbeGDIfr (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Jul 2018 04:35:47 -0400
Date: Wed, 4 Jul 2018 10:35:36 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
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
Message-ID: <20180704082544.GA4463@w540>
References: <1528796612-7387-1-git-send-email-jacopo+renesas@jmondi.org>
 <1528796612-7387-11-git-send-email-jacopo+renesas@jmondi.org>
 <1fc42981-2269-d6f5-921d-6730661542c7@xs4all.nl>
 <20180704074946.GA1240@w540>
 <CAMuHMdWK-1q-gkCMRkWJPMoeYgn1RoJC=Xjey3TA+ipiQzmFpQ@mail.gmail.com>
 <20180704080822.GB1240@w540>
 <f7ea38e9-26b0-465c-6392-c55009e7e562@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="yNb1oOkm5a9FJOVX"
Content-Disposition: inline
In-Reply-To: <f7ea38e9-26b0-465c-6392-c55009e7e562@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--yNb1oOkm5a9FJOVX
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Hans,

On Wed, Jul 04, 2018 at 10:15:54AM +0200, Hans Verkuil wrote:
> On 04/07/18 10:08, jacopo mondi wrote:
> > Hi Geert,
> >
> > On Wed, Jul 04, 2018 at 10:00:56AM +0200, Geert Uytterhoeven wrote:
> >> Hi Jacopo,
> >>
> >> On Wed, Jul 4, 2018 at 9:49 AM jacopo mondi <jacopo@jmondi.org> wrote:
> >>> On Wed, Jul 04, 2018 at 09:36:34AM +0200, Hans Verkuil wrote:
> >>>> On 12/06/18 11:43, Jacopo Mondi wrote:
> >>>>> Add R-Car R8A77995 SoC to the rcar-vin supported ones.
> >>>>>
> >>>>> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> >>>>> Reviewed-by: Niklas S=C3=B6derlund <niklas.soderlund+renesas@ragnat=
ech.se>
> >>>>> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> >>>>
> >>>> Checkpatch reports:
> >>>>
> >>>> WARNING: DT compatible string "renesas,vin-r8a77995" appears un-docu=
mented -- check ./Documentation/devicetree/bindings/
> >>>> #29: FILE: drivers/media/platform/rcar-vin/rcar-core.c:1150:
> >>>> +               .compatible =3D "renesas,vin-r8a77995",
> >>>>
> >>>> I'll still accept this series since this compatible string is alread=
y used in
> >>>> a dtsi, but if someone can document this for the bindings?
> >>>
> >>> A patch has been sent on May 21st for this
> >>> https://patchwork.kernel.org/patch/10415587/
> >>>
> >>> Bindings documentation usually gets in a release later than bindings
> >>> users, to give time to bindings to be changed eventually before
> >>> being documented.
> >>>
> >>> Simon, Geert, is this correct?
> >>
> >> Hmm, not 100% ;-)
> >>
> >> Usually the binding update for a trivial one like this goes in _in par=
allel_
> >> with its user in a .dtsi.  So it happens from time to time that the bi=
nding
> >> update is delayed by one kernel release (or more).
> >>
> >
> > Thanks for clarifying
> >
> >> This one is a bit special, as it seems a driver update is needed, too?
> >> So I'd expect the binding update would be part of this series.
> >> But that may be a bit too naive on my side, as I don't follow multimed=
ia
> >> development that closely.
> >
> > I sent dts and driver updates in two different series, and this last
> > patch is the only one that was not collected.
> > https://patchwork.kernel.org/patch/10415587/
>
> Weird, this patch does not appear to have been posted to the linux-media
> mailinglist, but it should since we are typically responsible for applying
> patches in bindings/media.

My bad, I haven't copied the media list as that patch was part of a
renesas board dts update and I thought it was going in through Simon
(and I felt 'bad' spamming the media list with that series too, even
if it involved a VIN update)

>
> Why don't you post a v5, this time including linux-media and I'll pick it
> up in my pull request.

That's easier, yes. Will do now.

Thanks, sorry for the mess
   j

>
> Regards,
>
> 	Hans
>
> >
> > Hans is taking care of taking the driver updates, should I notify you
> > and Simon once those patches land on the media master branch ?
> >
> > Thanks
> >   j
> >
> >>
> >>>>> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> >>>>> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> >>>>> @@ -1045,6 +1045,18 @@ static const struct rvin_info rcar_info_r8a7=
7970 =3D {
> >>>>>     .routes =3D rcar_info_r8a77970_routes,
> >>>>>  };
> >>>>>
> >>>>> +static const struct rvin_group_route rcar_info_r8a77995_routes[] =
=3D {
> >>>>> +   { /* Sentinel */ }
> >>>>> +};
> >>>>> +
> >>>>> +static const struct rvin_info rcar_info_r8a77995 =3D {
> >>>>> +   .model =3D RCAR_GEN3,
> >>>>> +   .use_mc =3D true,
> >>>>> +   .max_width =3D 4096,
> >>>>> +   .max_height =3D 4096,
> >>>>> +   .routes =3D rcar_info_r8a77995_routes,
> >>>>> +};
> >>>>> +
> >>>>>  static const struct of_device_id rvin_of_id_table[] =3D {
> >>>>>     {
> >>>>>             .compatible =3D "renesas,vin-r8a7778",
> >>>>> @@ -1086,6 +1098,10 @@ static const struct of_device_id rvin_of_id_=
table[] =3D {
> >>>>>             .compatible =3D "renesas,vin-r8a77970",
> >>>>>             .data =3D &rcar_info_r8a77970,
> >>>>>     },
> >>>>> +   {
> >>>>> +           .compatible =3D "renesas,vin-r8a77995",
> >>>>> +           .data =3D &rcar_info_r8a77995,
> >>>>> +   },
> >>>>>     { /* Sentinel */ },
> >>>>>  };
> >>>>>  MODULE_DEVICE_TABLE(of, rvin_of_id_table);
> >>
> >> Gr{oetje,eeting}s,
> >>
> >>                         Geert
> >>
> >> --
> >> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux=
-m68k.org
> >>
> >> In personal conversations with technical people, I call myself a hacke=
r. But
> >> when I'm talking to journalists I just say "programmer" or something l=
ike that.
> >>                                 -- Linus Torvalds
>

--yNb1oOkm5a9FJOVX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbPIbYAAoJEHI0Bo8WoVY8gCcP/j9n7Xw4SZo0XqtOodtrv8li
gzQqSJFXH5zcO9LtuzPQHaAEwRLe3teOfM3J0AnfkqUrHcYLntewFqo6nnwvm9H2
O8wA5oRMcH8DlX7YLb6DOPIY5+ekHamUBTPtvMeVuTTf/FGXHC1FNCVn6R3b4ZAJ
TylJaeHzXd3b3e5GL3p40Ie+iIaNj5d/NBvq4h64ToNWOrdMz+n2Ld17j+pRytxB
bGKch777swb+yveKw9moT9gp7+AKtlsHf3CNxEp50ynIEMX3GbA7hPjIlfptdyi1
pXKBV0Bg7Jq96L+ZTt8Lpqxty1H+z33nLf+sF5P2OJ525e1ixz7u/TuAgYgv9UoQ
oCVNitp0Ubw8CWaEP3ZLAg3uYeOTAXrxpyivlfZd/ctEvZbqztahlEzNfQh0lWYh
LAgWT3DTChPoitWa8meNps2lyRZvZyXE/LMYzvxcMgZ9OVPv+zwvavbQ33jjmNpT
x08uVTMMMqhxaDYxqyAVI6ETYdl7CZyegfz0Ebb1zfS/NynWqGtKWBEOsAQvz5YD
CJgYE4YJfg+wPNchTk1LCMJaEF26K85Av9uaT2JU42Yc9wsw9txWaBkjyUeylyxO
Sk0pAVG4stzXnYdj8cyHjCgMg0UMl1c73ehUob3ZNc1CpaheOM9We4IvqYaDT7mT
/y8TiwFLkYjwHhgBQ2yH
=uzjA
-----END PGP SIGNATURE-----

--yNb1oOkm5a9FJOVX--
