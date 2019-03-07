Return-Path: <SRS0=yxRx=RK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B571CC10F03
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 20:18:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8CCA820851
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 20:18:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbfCGUSC (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Mar 2019 15:18:02 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:41357 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726166AbfCGUSB (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Mar 2019 15:18:01 -0500
X-Originating-IP: 2.224.242.101
Received: from uno.localdomain (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 4E3FEE0009;
        Thu,  7 Mar 2019 20:17:58 +0000 (UTC)
Date:   Thu, 7 Mar 2019 21:18:31 +0100
From:   Jacopo Mondi <jacopo@jmondi.org>
To:     Ian Arkver <ian.arkver.dev@gmail.com>
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v3 12/31] media: entity: Add an iterator helper for
 connected pads
Message-ID: <20190307201831.wpzeir5gomnpw45c@uno.localdomain>
References: <20190305185150.20776-1-jacopo+renesas@jmondi.org>
 <20190305185150.20776-13-jacopo+renesas@jmondi.org>
 <20190307100924.4iuabzet67ttgk2p@paasikivi.fi.intel.com>
 <9f07ed66-b67b-500e-1faf-7e9c31447fd1@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="4sfti44m4iv2r452"
Content-Disposition: inline
In-Reply-To: <9f07ed66-b67b-500e-1faf-7e9c31447fd1@gmail.com>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--4sfti44m4iv2r452
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ian, Sakari,

On Thu, Mar 07, 2019 at 10:27:36AM +0000, Ian Arkver wrote:
> On 07/03/2019 10:09, Sakari Ailus wrote:
> > Hi Jacopo,
> >
> > On Tue, Mar 05, 2019 at 07:51:31PM +0100, Jacopo Mondi wrote:
> > > From: Sakari Ailus <sakari.ailus@linux.intel.com>
> > >
> > > Add a helper macro for iterating over pads that are connected through
> > > enabled routes. This can be used to find all the connected pads withi=
n an
> > > entity, for instance starting from the pad which has been obtained du=
ring
> > > the graph walk.
> > >
> > > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > > Reviewed-by: Niklas S=C3=B6derlund <niklas.soderlund+renesas@ragnatec=
h.se>
> > >
> > > - Make __media_entity_next_routed_pad() return NULL and adjust the
> > >    iterator to handle that
> > > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > > ---
> > >   include/media/media-entity.h | 27 +++++++++++++++++++++++++++
> > >   1 file changed, 27 insertions(+)
> > >
> > > diff --git a/include/media/media-entity.h b/include/media/media-entit=
y.h
> > > index 205561545d7e..82f0bdf2a6d1 100644
> > > --- a/include/media/media-entity.h
> > > +++ b/include/media/media-entity.h
> > > @@ -936,6 +936,33 @@ __must_check int media_graph_walk_init(
> > >   bool media_entity_has_route(struct media_entity *entity, unsigned i=
nt pad0,
> > >   			    unsigned int pad1);
> > > +static inline struct media_pad *__media_entity_next_routed_pad(
> > > +	struct media_pad *start, struct media_pad *iter)
> > > +{
> > > +	struct media_entity *entity =3D start->entity;
> > > +
> > > +	while (iter < &entity->pads[entity->num_pads] &&
> > > +	       !media_entity_has_route(entity, start->index, iter->index))
> > > +		iter++;
> > > +
> > > +	return iter =3D=3D &entity->pads[entity->num_pads] ? NULL : iter;
> >
> > Could you use iter <=3D ...?
> >
> > It doesn't seem to matter here, but it'd seem safer to change the check.
> >
>
> How about something like...
>
> for (; iter < &entity->pads[entity->num_pads]; iter++)
>     if (media_entity_has_route(entity, start->index, iter->index))
>         return iter;
>
> return NULL;
>

Great, thank you both, I'll take this in!


> Regards,
> Ian
>
> > > +}
> > > +
> > > +/**
> > > + * media_entity_for_each_routed_pad - Iterate over entity pads conne=
cted by routes
> > > + *
> > > + * @start: The stating pad
> > > + * @iter: The iterator pad
> > > + *
> > > + * Iterate over all pads connected through routes from a given pad
> > > + * within an entity. The iteration will include the starting pad its=
elf.
> > > + */
> > > +#define media_entity_for_each_routed_pad(start, iter)			\
> > > +	for (iter =3D __media_entity_next_routed_pad(			\
> > > +		     start, (start)->entity->pads);			\
> > > +	     iter !=3D NULL;						\
> > > +	     iter =3D __media_entity_next_routed_pad(start, iter + 1))
> > > +
> > >   /**
> > >    * media_graph_walk_cleanup - Release resources used by graph walk.
> > >    *
> >

--4sfti44m4iv2r452
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEtcQ9SICaIIqPWDjAcjQGjxahVjwFAlyBfJcACgkQcjQGjxah
Vjz5BBAAt99XK0+LGiwoMkglDAHUy/wpHS5KGktQHgDGVpFZULvTRZdKLxXDjJZB
ZjRFkYqHeNYT74T1x4gdu3DBsh9ULMaWi1WiQx22GdtFjDctHijnT+imHffEnZ3A
cMukDjJDqQ4kkUnp9W6eKeYi+YQjR1txalAW6YDSYGX5idEyUDrCWOBE7+x8Wqti
cNEfPlj8M8lZafUATsp+FlYtcWtDdNr4taDOK6qOW+41dV/BlJD4s1en6kNoUpAJ
xxI0XVQ1cnMAU7faj3jseAXfZh/xV2Dx0kVIqVOkueB6KmJzsXUysItkLinQT0TN
1GQRcPV8lVq5ooGdMCx7pW4LxvC0mOMCi8PGE3LGxV1l7JMdA/jMsuykl/YseMnJ
qjCZvdTHKB15WQ5fYumKzIY0AaqwRqXynsM4Fjww67DcMZgvS4ll+zWE7buQQWWx
4FAXCbga18bHWSy7eWCXL5aYJ04a4jXvVALstoMXrvzRDvnZN4hPFTIm4bFEMxnE
yceerXqpdRsTAhLZ7dnCOwmefWF3UioQm8v8ujUTFqYKvVhLdwi2GUGk4ChZSCB5
N1FuEFtgv0B1ghulbBTQIEyEBEVXG0NaPbXgb+CjX9/Y/MU/Otz6BwbaK/QWW8ym
GOOkB7hXpgFfheeH2wfvWsNbRMOL+9wINNR6UIuLjkEjGoiaVl0=
=9iin
-----END PGP SIGNATURE-----

--4sfti44m4iv2r452--
