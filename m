Return-Path: <SRS0=xMd0=QZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2336C43381
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 09:20:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B91F92184E
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 09:20:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728705AbfBRJUr (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Feb 2019 04:20:47 -0500
Received: from relay12.mail.gandi.net ([217.70.178.232]:39709 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728592AbfBRJUq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Feb 2019 04:20:46 -0500
Received: from uno.localdomain (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 8A153200012;
        Mon, 18 Feb 2019 09:20:42 +0000 (UTC)
Date:   Mon, 18 Feb 2019 10:21:07 +0100
From:   Jacopo Mondi <jacopo@jmondi.org>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Niklas =?utf-8?Q?S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Benoit Parrot <bparrot@ti.com>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 09/30] media: entity: Swap pads if route is checked
 from source to sink
Message-ID: <20190218092107.omddljghnv3l2ss6@uno.localdomain>
References: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
 <20181101233144.31507-10-niklas.soderlund+renesas@ragnatech.se>
 <20190115225743.GH28397@pendragon.ideasonboard.com>
 <20190122151506.fnlfvwtoq7qunz45@paasikivi.fi.intel.com>
 <20190122152030.GB11461@pendragon.ideasonboard.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="cynd3sxjjzirrrlt"
Content-Disposition: inline
In-Reply-To: <20190122152030.GB11461@pendragon.ideasonboard.com>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--cynd3sxjjzirrrlt
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Laurent, Sakari,

On Tue, Jan 22, 2019 at 05:20:30PM +0200, Laurent Pinchart wrote:
> Hi Sakari,
>
> On Tue, Jan 22, 2019 at 05:15:06PM +0200, Sakari Ailus wrote:
> > On Wed, Jan 16, 2019 at 12:57:43AM +0200, Laurent Pinchart wrote:
> > >>
> > >> This way the pads are always passed to the has_route() op sink pad f=
irst.
> > >> Makes sense.
> > >
> > > Is there anything in the API that mandates one pad to be a sink and t=
he
> > > other pad to the a source ? I had designed the operation to allow
> > > sink-sink and source-source connections to be checked too.
> >
> > Do you have a use case in mind for sink--sink or source--source routes?=
 The
> > routes are about flows of data, so I'd presume only source--sink or
> > sink--source routes are meaningful.
> >
> > If you did, then the driver would have to handle that by itself. This s=
till
> > simplifies the implementation for drivers that do not.
>
> I don't have use cases for such routes, but we use the has_route
> operation when traversing pipelines, and at that point we need to get
> all the internally connected pads. In another patch in this series you
> implement a helper function that handles this, but its implementation
> isn't complete. I explained in my review of that patch that I fear a
> correct generic implementation would become quite complex, while the
> complexity should be easy to handle on the driver side as the code can
> then be specialized for the case at hand.
>

As a compromise, in v3 I'm thinking of maintaining support for the
most common case of two sources connected to the same sink, as
Sakari's patch does, but let more complex cases be handled by the
driver implementation of has_route().

Ack?

> > > If your goal is to simplify the implementation of the .has_route()
> > > operation in drivers, I would instead sort pad0 and pad1 by value.
> >
> > That'd be another option to make the order deterministic for the driver.
> > I'm fine with that as well.
> >

In v3 I have taken both suggestions in: try the "sink then source" order
first, then order by index in case the pads are of the same time. This
needs to be documented in has_route() operation definition though.

Would that be fine with you?

Thanks
   j

> > >> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > >> Reviewed-by: Niklas S=C3=B6derlund <niklas.soderlund+renesas@ragnate=
ch.se>
> > >> ---
> > >>  drivers/media/media-entity.c | 4 ++++
> > >>  1 file changed, 4 insertions(+)
> > >>
> > >> diff --git a/drivers/media/media-entity.c b/drivers/media/media-enti=
ty.c
> > >> index 3c0e7425c8983b45..33f00e35ccd92c6f 100644
> > >> --- a/drivers/media/media-entity.c
> > >> +++ b/drivers/media/media-entity.c
> > >> @@ -249,6 +249,10 @@ bool media_entity_has_route(struct media_entity=
 *entity, unsigned int pad0,
> > >>  	if (!entity->ops || !entity->ops->has_route)
> > >>  		return true;
> > >>
> > >> +	if (entity->pads[pad0].flags & MEDIA_PAD_FL_SOURCE
> > >> +	    && entity->pads[pad1].flags & MEDIA_PAD_FL_SINK)
> > >> +		swap(pad0, pad1);
> > >> +
> > >>  	return entity->ops->has_route(entity, pad0, pad1);
> > >>  }
> > >>  EXPORT_SYMBOL_GPL(media_entity_has_route);
>
> --
> Regards,
>
> Laurent Pinchart

--cynd3sxjjzirrrlt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEtcQ9SICaIIqPWDjAcjQGjxahVjwFAlxqeQMACgkQcjQGjxah
VjwDGg//dOq5CHZ07nr8XM7CsSi03rBsnh08Ihfd6tIgMF8E0xgdEOxqEIFHnHDf
i54ApZBQ5PC03iNU57AT/s2atMwfhKQLPKiPIwdVRJaRwXogb3XCzn80swdLY/qy
6ATTOqyWtklyVFGM5fsXiK/68PvTsj8xh17GryvFbFL60OfwT3QMIABC/2iw1BbL
q57jYT3anQAhxkfdM9hHfk0l5ZSiH+iEx+HpTIEUbj0fBhg5xFErdWaXVXRP+r2H
UNvt7TrIXibVJ7Z7rs0/mI7bivULXzrK4H0x5ehuRtHfy/aaIb1cT2nN2V9TGu9t
pdqe/tUvDEDAiOrTkr8lN96JxTzxJO3JlfQtVTZW/J2AawFGNyGrqJkE1qv4hD+w
CA+SjQk8o8NWfEHvLQjQhY5uuS5uZ/ooFeMPz/HkRSNCAde8T7xt1+d5/japhoo9
t2mdUjN0xVHKG6XNxxmjv44B34aQbQe/lMxrtIFv2udXIICP+V8oZv6HeNTCNFbT
jo8it82DrsxRpInbjXTBFaTWXaD2EBFPQnUt+d1hIB3u/8CIMb11sZ1jw8eA3ngQ
I9F8fxHMgMkcBsTSzEVOXp6VEuj4Ld/DCVraCkFmqR3vXQGi/NVk2RKU+VEYAd4y
t6PNtgSWNxNz8duLUBXScpYWTGuQXvoQeYWOXmx8vP0MP0Al/G8=
=sEFy
-----END PGP SIGNATURE-----

--cynd3sxjjzirrrlt--
