Return-Path: <SRS0=0You=RH=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 750F5C43381
	for <linux-media@archiver.kernel.org>; Mon,  4 Mar 2019 12:35:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 502032070B
	for <linux-media@archiver.kernel.org>; Mon,  4 Mar 2019 12:35:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbfCDMfM (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 4 Mar 2019 07:35:12 -0500
Received: from relay11.mail.gandi.net ([217.70.178.231]:59125 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726095AbfCDMfM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Mar 2019 07:35:12 -0500
Received: from uno.localdomain (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id 2DA0810000A;
        Mon,  4 Mar 2019 12:35:08 +0000 (UTC)
Date:   Mon, 4 Mar 2019 13:35:36 +0100
From:   Jacopo Mondi <jacopo@jmondi.org>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Niklas =?utf-8?Q?S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Benoit Parrot <bparrot@ti.com>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 09/30] media: entity: Swap pads if route is checked
 from source to sink
Message-ID: <20190304123520.et24vsesfulyzybs@uno.localdomain>
References: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
 <20181101233144.31507-10-niklas.soderlund+renesas@ragnatech.se>
 <20190115225743.GH28397@pendragon.ideasonboard.com>
 <20190122151506.fnlfvwtoq7qunz45@paasikivi.fi.intel.com>
 <20190122152030.GB11461@pendragon.ideasonboard.com>
 <20190218092107.omddljghnv3l2ss6@uno.localdomain>
 <20190222121811.GU3522@pendragon.ideasonboard.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="d5f4xeuz34cicmdj"
Content-Disposition: inline
In-Reply-To: <20190222121811.GU3522@pendragon.ideasonboard.com>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--d5f4xeuz34cicmdj
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Laurent,

On Fri, Feb 22, 2019 at 02:18:11PM +0200, Laurent Pinchart wrote:
> Hi Jacopo,
>
> On Mon, Feb 18, 2019 at 10:21:07AM +0100, Jacopo Mondi wrote:
> > On Tue, Jan 22, 2019 at 05:20:30PM +0200, Laurent Pinchart wrote:
> > > On Tue, Jan 22, 2019 at 05:15:06PM +0200, Sakari Ailus wrote:
> > >> On Wed, Jan 16, 2019 at 12:57:43AM +0200, Laurent Pinchart wrote:
> > >>>>
> > >>>> This way the pads are always passed to the has_route() op sink pad=
 first.
> > >>>> Makes sense.
> > >>>
> > >>> Is there anything in the API that mandates one pad to be a sink and=
 the
> > >>> other pad to the a source ? I had designed the operation to allow
> > >>> sink-sink and source-source connections to be checked too.
> > >>
> > >> Do you have a use case in mind for sink--sink or source--source rout=
es? The
> > >> routes are about flows of data, so I'd presume only source--sink or
> > >> sink--source routes are meaningful.
> > >>
> > >> If you did, then the driver would have to handle that by itself. Thi=
s still
> > >> simplifies the implementation for drivers that do not.
> > >
> > > I don't have use cases for such routes, but we use the has_route
> > > operation when traversing pipelines, and at that point we need to get
> > > all the internally connected pads. In another patch in this series you
> > > implement a helper function that handles this, but its implementation
> > > isn't complete. I explained in my review of that patch that I fear a
> > > correct generic implementation would become quite complex, while the
> > > complexity should be easy to handle on the driver side as the code can
> > > then be specialized for the case at hand.
> > >
> >
> > As a compromise, in v3 I'm thinking of maintaining support for the
> > most common case of two sources connected to the same sink, as
> > Sakari's patch does, but let more complex cases be handled by the
> > driver implementation of has_route().
> >
> > Ack?
>
> I fear this will be confusing for subdevs, as they would have to
> implement part of the operation.
>
> Could it be that the subdev has_route operation isn't the best API for
> the job, if it gets that complex ? I wonder if it would be easier to
> create another operation that takes a pad index as argument, and returns
> the list of pads (possibly as a bitmask ?) or connected pads.
> media_entity_has_route() could easily be implemented on top of that, and
> these new semantics may be easier for subdevs to implement.
>

I see, but if subdevs can easily elaborate that list, they could as
well easily check if the pad provided as argument is on that list.

> > >>> If your goal is to simplify the implementation of the .has_route()
> > >>> operation in drivers, I would instead sort pad0 and pad1 by value.
> > >>
> > >> That'd be another option to make the order deterministic for the dri=
ver.
> > >> I'm fine with that as well.
> >
> > In v3 I have taken both suggestions in: try the "sink then source" order
> > first, then order by index in case the pads are of the same time. This
> > needs to be documented in has_route() operation definition though.
> >
> > Would that be fine with you?
>
> I think that's the worst of both worlds from a subdev point of view :-)
>

Possibly :)

Should we drop completely the sink-source ordering in favour of
ordering by value, and drop [15/30] that adds support for trivial
indirect routes?

Let's reach consensus so I could send v3.

Thanks
   j

> > >>>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > >>>> Reviewed-by: Niklas S=C3=B6derlund <niklas.soderlund+renesas@ragna=
tech.se>
> > >>>> ---
> > >>>>  drivers/media/media-entity.c | 4 ++++
> > >>>>  1 file changed, 4 insertions(+)
> > >>>>
> > >>>> diff --git a/drivers/media/media-entity.c b/drivers/media/media-en=
tity.c
> > >>>> index 3c0e7425c8983b45..33f00e35ccd92c6f 100644
> > >>>> --- a/drivers/media/media-entity.c
> > >>>> +++ b/drivers/media/media-entity.c
> > >>>> @@ -249,6 +249,10 @@ bool media_entity_has_route(struct media_enti=
ty *entity, unsigned int pad0,
> > >>>>  	if (!entity->ops || !entity->ops->has_route)
> > >>>>  		return true;
> > >>>>
> > >>>> +	if (entity->pads[pad0].flags & MEDIA_PAD_FL_SOURCE
> > >>>> +	    && entity->pads[pad1].flags & MEDIA_PAD_FL_SINK)
> > >>>> +		swap(pad0, pad1);
> > >>>> +
> > >>>>  	return entity->ops->has_route(entity, pad0, pad1);
> > >>>>  }
> > >>>>  EXPORT_SYMBOL_GPL(media_entity_has_route);
>
> --
> Regards,
>
> Laurent Pinchart

--d5f4xeuz34cicmdj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEtcQ9SICaIIqPWDjAcjQGjxahVjwFAlx9G5gACgkQcjQGjxah
VjxLLw//ejXwfmvprHk3gxtWoNUVLCrA/yfwwKAHJJ/sV5d8MsNTbgg9Wxp4XuDo
5O41j+ibrjErGeRnAtfaZxQHrF5r/lH53xiVSpJRVdg3ENo+LOyxfMMpG4JVC3m8
gj6bXmIXF72oLCaC4aMh3WHUU77UQJxfeRaLYQeO+AjRGltzBBAyTSFN2vPif2QM
6l4czV7Nt5zLfNtL5QZYKsPaDPNcMts3fD5i94EcS+SNBr1onYc9G7JEPuX+9RbB
sKF4b3BPUkIBfh9sTShVQsPqqkyaQOV6LJfu8sVwh/A/ZjAHwbzRhIQWAgWWa36Z
k4WA3LbKzBQ4KDDqABcBk3NFXcupRFw+HcFBuUJKx3ccfpT90K65b0Jj2121TXR/
vCSEP5NWvN5j9Hkx2uWSXLEyZ1nbA4Q+/Ey9dOtBaQU1FPd/XXLdq5Qdp0WM3pcT
sHDmiceDOl2xdImGR8ragV9f1Db612GOdg4g7Z/W6xLXGRA3QgWhbbpytZFT22rb
LJo0YVY4uftltRVAgo63RqYT9XTu0zpVzWsxxEFcCZaDSBtjb+sgq6Bi6WCp1eSy
Bpbkz65i7TcuHF5ngac3YuzZ0stTC+hcFFl6BnVveaRqsX722FcIXSmTy5z0wep8
0OMo4fAZN9+bfnJajaqLWScqGp86LVSwg1QujC5hBZ59kzqtLnM=
=Wo+J
-----END PGP SIGNATURE-----

--d5f4xeuz34cicmdj--
