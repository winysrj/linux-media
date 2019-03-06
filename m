Return-Path: <SRS0=KHCC=RJ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FD2BC10F00
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 08:29:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41CAD20661
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 08:29:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728866AbfCFI3T (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Mar 2019 03:29:19 -0500
Received: from relay10.mail.gandi.net ([217.70.178.230]:54847 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726535AbfCFI3T (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2019 03:29:19 -0500
Received: from uno.localdomain (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id DB5E8240007;
        Wed,  6 Mar 2019 08:29:13 +0000 (UTC)
Date:   Wed, 6 Mar 2019 09:29:46 +0100
From:   Jacopo Mondi <jacopo@jmondi.org>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Niklas =?utf-8?Q?S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Benoit Parrot <bparrot@ti.com>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 09/30] media: entity: Swap pads if route is checked
 from source to sink
Message-ID: <20190306082946.bxcf6jnl52nrc6q3@uno.localdomain>
References: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
 <20181101233144.31507-10-niklas.soderlund+renesas@ragnatech.se>
 <20190115225743.GH28397@pendragon.ideasonboard.com>
 <20190122151506.fnlfvwtoq7qunz45@paasikivi.fi.intel.com>
 <20190122152030.GB11461@pendragon.ideasonboard.com>
 <20190218092107.omddljghnv3l2ss6@uno.localdomain>
 <20190222121811.GU3522@pendragon.ideasonboard.com>
 <20190304123520.et24vsesfulyzybs@uno.localdomain>
 <20190305200458.GK14928@pendragon.ideasonboard.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ujeqxfwldlxyvs2i"
Content-Disposition: inline
In-Reply-To: <20190305200458.GK14928@pendragon.ideasonboard.com>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--ujeqxfwldlxyvs2i
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

HI Laurent,

On Tue, Mar 05, 2019 at 10:04:58PM +0200, Laurent Pinchart wrote:
> Hi Jacopo,
>
> On Mon, Mar 04, 2019 at 01:35:36PM +0100, Jacopo Mondi wrote:
> > On Fri, Feb 22, 2019 at 02:18:11PM +0200, Laurent Pinchart wrote:
> > > On Mon, Feb 18, 2019 at 10:21:07AM +0100, Jacopo Mondi wrote:
> > >> On Tue, Jan 22, 2019 at 05:20:30PM +0200, Laurent Pinchart wrote:
> > >>> On Tue, Jan 22, 2019 at 05:15:06PM +0200, Sakari Ailus wrote:
> > >>>> On Wed, Jan 16, 2019 at 12:57:43AM +0200, Laurent Pinchart wrote:
> > >>>>>>
> > >>>>>> This way the pads are always passed to the has_route() op sink p=
ad first.
> > >>>>>> Makes sense.
> > >>>>>
> > >>>>> Is there anything in the API that mandates one pad to be a sink a=
nd the
> > >>>>> other pad to the a source ? I had designed the operation to allow
> > >>>>> sink-sink and source-source connections to be checked too.
> > >>>>
> > >>>> Do you have a use case in mind for sink--sink or source--source ro=
utes? The
> > >>>> routes are about flows of data, so I'd presume only source--sink or
> > >>>> sink--source routes are meaningful.
> > >>>>
> > >>>> If you did, then the driver would have to handle that by itself. T=
his still
> > >>>> simplifies the implementation for drivers that do not.
> > >>>
> > >>> I don't have use cases for such routes, but we use the has_route
> > >>> operation when traversing pipelines, and at that point we need to g=
et
> > >>> all the internally connected pads. In another patch in this series =
you
> > >>> implement a helper function that handles this, but its implementati=
on
> > >>> isn't complete. I explained in my review of that patch that I fear a
> > >>> correct generic implementation would become quite complex, while the
> > >>> complexity should be easy to handle on the driver side as the code =
can
> > >>> then be specialized for the case at hand.
> > >>>
> > >>
> > >> As a compromise, in v3 I'm thinking of maintaining support for the
> > >> most common case of two sources connected to the same sink, as
> > >> Sakari's patch does, but let more complex cases be handled by the
> > >> driver implementation of has_route().
> > >>
> > >> Ack?
> > >
> > > I fear this will be confusing for subdevs, as they would have to
> > > implement part of the operation.
> > >
> > > Could it be that the subdev has_route operation isn't the best API for
> > > the job, if it gets that complex ? I wonder if it would be easier to
> > > create another operation that takes a pad index as argument, and retu=
rns
> > > the list of pads (possibly as a bitmask ?) or connected pads.
> > > media_entity_has_route() could easily be implemented on top of that, =
and
> > > these new semantics may be easier for subdevs to implement.
> > >
> >
> > I see, but if subdevs can easily elaborate that list, they could as
> > well easily check if the pad provided as argument is on that list.
>
> Possibly. In any case, if we keep this operation as-is, I wouldn't try
> to split the logic between the subdev drivers and the core, that would
> be asking for trouble. If it gets too complex to implement for subdev
> drivers, then we need a different operation with a different logic in
> the subdev API, and a helper that wraps around it.

In v3 I have removed support for indirect routes from the framework
part. It's all on the subdevice driver for now.
>
> > >>>>> If your goal is to simplify the implementation of the .has_route()
> > >>>>> operation in drivers, I would instead sort pad0 and pad1 by value.
> > >>>>
> > >>>> That'd be another option to make the order deterministic for the d=
river.
> > >>>> I'm fine with that as well.
> > >>
> > >> In v3 I have taken both suggestions in: try the "sink then source" o=
rder
> > >> first, then order by index in case the pads are of the same time. Th=
is
> > >> needs to be documented in has_route() operation definition though.
> > >>
> > >> Would that be fine with you?
> > >
> > > I think that's the worst of both worlds from a subdev point of view :=
-)
> >
> > Possibly :)
> >
> > Should we drop completely the sink-source ordering in favour of
> > ordering by value, and drop [15/30] that adds support for trivial
> > indirect routes?
> >
> > Let's reach consensus so I could send v3.
>
> I would certainly drop 15/30, and I don't think ordering by value would
> help subdev drivers much.

Yes, but sorting by index makes it easier to deal with the sink-sink
and source-source use cases, if the subdevice supports indirect
routes.

I have dropped 15/30 and specified pads are passed by index in v3.

Thanks
  j

>
> > >>>>>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > >>>>>> Reviewed-by: Niklas S=C3=B6derlund <niklas.soderlund+renesas@rag=
natech.se>
> > >>>>>> ---
> > >>>>>>  drivers/media/media-entity.c | 4 ++++
> > >>>>>>  1 file changed, 4 insertions(+)
> > >>>>>>
> > >>>>>> diff --git a/drivers/media/media-entity.c b/drivers/media/media-=
entity.c
> > >>>>>> index 3c0e7425c8983b45..33f00e35ccd92c6f 100644
> > >>>>>> --- a/drivers/media/media-entity.c
> > >>>>>> +++ b/drivers/media/media-entity.c
> > >>>>>> @@ -249,6 +249,10 @@ bool media_entity_has_route(struct media_en=
tity *entity, unsigned int pad0,
> > >>>>>>  	if (!entity->ops || !entity->ops->has_route)
> > >>>>>>  		return true;
> > >>>>>>
> > >>>>>> +	if (entity->pads[pad0].flags & MEDIA_PAD_FL_SOURCE
> > >>>>>> +	    && entity->pads[pad1].flags & MEDIA_PAD_FL_SINK)
> > >>>>>> +		swap(pad0, pad1);
> > >>>>>> +
> > >>>>>>  	return entity->ops->has_route(entity, pad0, pad1);
> > >>>>>>  }
> > >>>>>>  EXPORT_SYMBOL_GPL(media_entity_has_route);
>
> --
> Regards,
>
> Laurent Pinchart

--ujeqxfwldlxyvs2i
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEtcQ9SICaIIqPWDjAcjQGjxahVjwFAlx/hPoACgkQcjQGjxah
VjwKhRAAl/CBce5OfACH8HpLqI5AkPxanpKk1bnigbjvrlC38sUTNe1EXz6Ea3Cl
tiABEhvZHd8LUi7vMOT/EvcpySo/fW4906ZQRHCv8it0ySTxfH65HLiwhrM6Bm+C
Afo5ef0+JyRGpC3mWi+1numYuyGAx5SbeCfI7VxPSF5gs/WZg2uoz2pkfcJyLftz
GbqYqGh2fnMXJr0s7R1QLNEClLOk/WwDbgY/AMqLsc05bdeSt3pvy/OmCXOVBqFd
b3J6pLZ6Xv6+3JNQcysSj+AaxxNmc6rijO+hKHOXHkiGtyIg/UO1xwtdvTT6bjTI
yLIbTuUR8yGRi/1Hu98qSAA2eAlLFwXR722wiWotQC/qQNsf57ukpxMYpIPt3WuR
Ok0icY+3U8vUKxGBQ/lCFJovjsFhI/ZUxeL8TS+qjfeT6864MsSWZfcdmRd/YkV/
krIOGoX2iOJEcnhcY8O+70EY4HVtHu37xddGidTqvhlC7rymG1ceOlKX16M8lcwB
DincX1cpoXGq8hGFBt/gA41DOI07p/RAX55ebdabKQ6WwO6w1RbrD6vjydfk3oVX
xWSzr8P2UdpXJGEtTSyaCOKRxzurhCFZSddX6e1nGw3vpULBPH1D9gc0xoKcc6bf
otKxul5HhHujagVHuI5nM9kDPRX7W8YfE+0M1n6nHaAZoiR2VLA=
=D110
-----END PGP SIGNATURE-----

--ujeqxfwldlxyvs2i--
