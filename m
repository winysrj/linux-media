Return-Path: <SRS0=7C2H=RS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5853C10F00
	for <linux-media@archiver.kernel.org>; Fri, 15 Mar 2019 09:22:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E02E2184C
	for <linux-media@archiver.kernel.org>; Fri, 15 Mar 2019 09:22:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728627AbfCOJWA (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 15 Mar 2019 05:22:00 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:60553 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727455AbfCOJWA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Mar 2019 05:22:00 -0400
X-Originating-IP: 2.224.242.101
Received: from uno.localdomain (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id 3F9F1240006;
        Fri, 15 Mar 2019 09:21:38 +0000 (UTC)
Date:   Fri, 15 Mar 2019 10:22:15 +0100
From:   Jacopo Mondi <jacopo@jmondi.org>
To:     Luca Ceresoli <luca@lucaceresoli.net>
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Michal Simek <michal.simek@xilinx.com>
Subject: Re: [PATCH v3 09/31] media: entity: Add media_has_route() function
Message-ID: <20190315092215.5mhrqnz5oqa4j2iu@uno.localdomain>
References: <20190305185150.20776-1-jacopo+renesas@jmondi.org>
 <20190305185150.20776-10-jacopo+renesas@jmondi.org>
 <d297c850-8af5-f435-861a-644fb64933e3@lucaceresoli.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="qbkhm5bsxkyai4pk"
Content-Disposition: inline
In-Reply-To: <d297c850-8af5-f435-861a-644fb64933e3@lucaceresoli.net>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--qbkhm5bsxkyai4pk
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Luca,
   thanks for the comments

On Thu, Mar 14, 2019 at 03:45:00PM +0100, Luca Ceresoli wrote:
> Hi,
>
> in the Subject line:
> s/media_has_route/media_entity_has_route/

Ah! Thanks for noticing this.

>
> On 05/03/19 19:51, Jacopo Mondi wrote:
> > From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> >
> > This is a wrapper around the media entity has_route operation.
> >
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > ---
> >  drivers/media/media-entity.c | 19 +++++++++++++++++++
> >  include/media/media-entity.h | 17 +++++++++++++++++
> >  2 files changed, 36 insertions(+)
> >
> > diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> > index 6f5196d05894..8e0ca8b1cfa2 100644
> > --- a/drivers/media/media-entity.c
> > +++ b/drivers/media/media-entity.c
> > @@ -238,6 +238,25 @@ EXPORT_SYMBOL_GPL(media_entity_pads_init);
> >   * Graph traversal
> >   */
> >
> > +bool media_entity_has_route(struct media_entity *entity, unsigned int pad0,
> > +			    unsigned int pad1)
> > +{
> > +	if (pad0 >= entity->num_pads || pad1 >= entity->num_pads)
> > +		return false;
> > +
> > +	if (pad0 == pad1)
> > +		return true;
> > +
> > +	if (!entity->ops || !entity->ops->has_route)
> > +		return true;
>
> Entities that implement has_route in following patches return false if
> called with two sink pads or two source pads. This code behaves
> differently. Which behavior is correct? IOW, how do you define "two
> entity pads are connected internally"?

The handling of "indirect routes" (aka routes that connects two
sources or two sinks) is totally up to the device driver and we
decided not to make any assumption (nor introduce helpers, as it was
in v2) to support that in the framework.

Have a look at:
[PATCH v2 15/30] media: entity: Look for indirect routes
where Sakari implemented an helper to support the most common use case
of two source pads connected to the same sink pad. In this case the
two sources are reported as connected, but we decided for now to let
the drivers handle this, and more complex indirect routes, internaly.

The devices for which "has_route" has been implemented in this series
do not support indirect routes, for now, but the framework does not
make assumptions on this.

Thanks
   j

>
> > +	if (entity->pads[pad1].index < entity->pads[pad0].index)
> > +		swap(pad0, pad1);
> > +
> > +	return entity->ops->has_route(entity, pad0, pad1);
> > +}
> > +EXPORT_SYMBOL_GPL(media_entity_has_route);
> > +
> >  static struct media_pad *
> >  media_pad_other(struct media_pad *pad, struct media_link *link)
> >  {
> > diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> > index 675bc27b8b3c..205561545d7e 100644
> > --- a/include/media/media-entity.h
> > +++ b/include/media/media-entity.h
> > @@ -919,6 +919,23 @@ int media_entity_get_fwnode_pad(struct media_entity *entity,
> >  __must_check int media_graph_walk_init(
> >  	struct media_graph *graph, struct media_device *mdev);
> >
> > +/**
> > + * media_entity_has_route - Check if two entity pads are connected internally
> > + *
> > + * @entity: The entity
> > + * @pad0: The first pad index
> > + * @pad1: The second pad index
> > + *
> > + * This function can be used to check whether two pads of an entity are
> > + * connected internally in the entity.
> > + *
> > + * The caller must hold entity->graph_obj.mdev->mutex.
> > + *
> > + * Return: true if the pads are connected internally and false otherwise.
> > + */
> > +bool media_entity_has_route(struct media_entity *entity, unsigned int pad0,
> > +			    unsigned int pad1);
> > +
> >  /**
> >   * media_graph_walk_cleanup - Release resources used by graph walk.
> >   *
> >
>
> --
> Luca

--qbkhm5bsxkyai4pk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEtcQ9SICaIIqPWDjAcjQGjxahVjwFAlyLbscACgkQcjQGjxah
Vjzwlw//b5zNTHPcyUdtJpElwYFpRWcYFvvx/L/2YuKWXlzVyNMPy+vU6dWfifUa
lPKkkQGDFG5TGBNUE+KhPL6ecS9jore+Fr76uXcPKx5bMMG22oB2OXeDBusyY60r
MTpyG+fCLPOYIpr9wLSl3Jge+s63o9btmD0F9Q97lb5IooYh79rUhLJDZ2BBNxol
CeHsDla3uQKqj5AIDOrAcAeUKHyoY/h2njVjt+ApBAVDB0SRWUBj5rFPjNnAW2dy
kHbTDvGOMHTY+LCk7kcsgCnz1d80ZAy/OVDcxXyLAgHxoIPWxK9m792rj+b25sof
NRJrUInApupVS6jB+5a5hNCHXkZwJ6GCSbulEjXd9CyEOVlOthzEtL6y2G2ZU4l5
Dx1Z2jH/cVjFcbZ0B+8WncJJBJGK0U+oxfcQxkpTnGwx5JKJWqTy1WjZpzBbtJNZ
MEfOEXq7/TUIA2aKhiWTpQ0/N0/WoBkanQ3WBeTcop00wRFf6HWpXUanfUMWrCv/
fqYGO5EY0bm+v9GyhCbgvZ6aiIPiK0GFBzuLCm/kPSpVCPn6NNTlBjKvFvKGT8C3
TT3kJP33sMNgLRl6nC+hjJzYjFBD8U+fFRtdchlYtimFkYybKZE26nBM1IQ60Ewa
/HAC7VUFbW07vbmZNvsUnrXz4blYZ33w1zLd/VSM4xA3wv71q3s=
=Mcxh
-----END PGP SIGNATURE-----

--qbkhm5bsxkyai4pk--
