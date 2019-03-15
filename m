Return-Path: <SRS0=7C2H=RS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0CAFC4360F
	for <linux-media@archiver.kernel.org>; Fri, 15 Mar 2019 09:45:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8BD6218AC
	for <linux-media@archiver.kernel.org>; Fri, 15 Mar 2019 09:45:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728675AbfCOJpH (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 15 Mar 2019 05:45:07 -0400
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:41507 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726886AbfCOJpG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Mar 2019 05:45:06 -0400
X-Originating-IP: 2.224.242.101
Received: from uno.localdomain (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id 9E9F540013;
        Fri, 15 Mar 2019 09:45:02 +0000 (UTC)
Date:   Fri, 15 Mar 2019 10:45:38 +0100
From:   Jacopo Mondi <jacopo@jmondi.org>
To:     Luca Ceresoli <luca@lucaceresoli.net>
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v3 26/31] adv748x: csi2: add internal routing
 configuration
Message-ID: <20190315094538.bs5ecsdzndrxjdbb@uno.localdomain>
References: <20190305185150.20776-1-jacopo+renesas@jmondi.org>
 <20190305185150.20776-27-jacopo+renesas@jmondi.org>
 <4f5b5763-be90-4040-7d55-986471168de1@lucaceresoli.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="bqma2ubyzmeircxs"
Content-Disposition: inline
In-Reply-To: <4f5b5763-be90-4040-7d55-986471168de1@lucaceresoli.net>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--bqma2ubyzmeircxs
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Luca,

On Thu, Mar 14, 2019 at 03:45:27PM +0100, Luca Ceresoli wrote:
> Hi,
>
> begging your pardon for the noob question below...
>

Let a noob help another noob then

> On 05/03/19 19:51, Jacopo Mondi wrote:
> > From: Niklas S=C3=B6derlund <niklas.soderlund+renesas@ragnatech.se>
> >
> > Add support to get and set the internal routing between the adv748x
> > CSI-2 transmitters sink pad and its multiplexed source pad. This routing
> > includes which stream of the multiplexed pad to use, allowing the user
> > to select which CSI-2 virtual channel to use when transmitting the
> > stream.
> >
> > Signed-off-by: Niklas S=C3=B6derlund <niklas.soderlund+renesas@ragnatec=
h.se>
> > Reviewed-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > ---
> >  drivers/media/i2c/adv748x/adv748x-csi2.c | 65 ++++++++++++++++++++++++
> >  1 file changed, 65 insertions(+)
> >
> > diff --git a/drivers/media/i2c/adv748x/adv748x-csi2.c b/drivers/media/i=
2c/adv748x/adv748x-csi2.c
> > index d8f7cbee86e7..13454af72c6e 100644
> > --- a/drivers/media/i2c/adv748x/adv748x-csi2.c
> > +++ b/drivers/media/i2c/adv748x/adv748x-csi2.c
> > @@ -14,6 +14,8 @@
> >
> >  #include "adv748x.h"
> >
> > +#define ADV748X_CSI2_ROUTES_MAX 4
> > +
> >  struct adv748x_csi2_format {
> >  	unsigned int code;
> >  	unsigned int datatype;
> > @@ -253,10 +255,73 @@ static int adv748x_csi2_get_frame_desc(struct v4l=
2_subdev *sd, unsigned int pad,
> >  	return 0;
> >  }
> >
> > +static int adv748x_csi2_get_routing(struct v4l2_subdev *sd,
> > +				    struct v4l2_subdev_krouting *routing)
> > +{
> > +	struct adv748x_csi2 *tx =3D adv748x_sd_to_csi2(sd);
> > +	struct v4l2_subdev_route *r =3D routing->routes;
> > +	unsigned int vc;
> > +
> > +	if (routing->num_routes < ADV748X_CSI2_ROUTES_MAX) {
> > +		routing->num_routes =3D ADV748X_CSI2_ROUTES_MAX;
> > +		return -ENOSPC;
> > +	}
> > +
> > +	routing->num_routes =3D ADV748X_CSI2_ROUTES_MAX;
> > +
> > +	for (vc =3D 0; vc < ADV748X_CSI2_ROUTES_MAX; vc++) {
> > +		r->sink_pad =3D ADV748X_CSI2_SINK;
> > +		r->sink_stream =3D 0;
> > +		r->source_pad =3D ADV748X_CSI2_SOURCE;
> > +		r->source_stream =3D vc;
> > +		r->flags =3D vc =3D=3D tx->vc ? V4L2_SUBDEV_ROUTE_FL_ACTIVE : 0;
> > +		r++;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int adv748x_csi2_set_routing(struct v4l2_subdev *sd,
> > +				    struct v4l2_subdev_krouting *routing)
> > +{
> > +	struct adv748x_csi2 *tx =3D adv748x_sd_to_csi2(sd);
> > +	struct v4l2_subdev_route *r =3D routing->routes;
> > +	unsigned int i;
> > +	int vc =3D -1;
> > +
> > +	if (routing->num_routes > ADV748X_CSI2_ROUTES_MAX)
> > +		return -ENOSPC;
> > +
> > +	for (i =3D 0; i < routing->num_routes; i++) {
> > +		if (r->sink_pad !=3D ADV748X_CSI2_SINK ||
> > +		    r->sink_stream !=3D 0 ||
> > +		    r->source_pad !=3D ADV748X_CSI2_SOURCE ||
> > +		    r->source_stream >=3D ADV748X_CSI2_ROUTES_MAX)
> > +			return -EINVAL;
> > +
> > +		if (r->flags & V4L2_SUBDEV_ROUTE_FL_ACTIVE) {
> > +			if (vc !=3D -1)
> > +				return -EMLINK;
> > +
> > +			vc =3D r->source_stream;
> > +		}
> > +		r++;
> > +	}
> > +
> > +	if (vc !=3D -1)
> > +		tx->vc =3D vc;
> > +
> > +	adv748x_csi2_set_virtual_channel(tx, tx->vc);
> > +
> > +	return 0;
> > +}
>
> Not specific to this patch but rather to the set_routing idea as a
> whole: can the set_routing ioctl be called while the stream is running?
>
> If it cannot, I find it a limiting factor for nowadays use cases. I also
> didn't find where the ioctl is rejected.
>

The framework does not make assumptions about that at the moment.

> If it can, then shouldn't this function call s_stream(stop) through the
> sink pad whose route becomes disabled, and a s_stream(start) through the
> one that gets enabled?
>

If I got this right, you're here rightfully pointing out that changing
the routing between pads in an entity migh impact the pipeline as a
whole, and this would require, to activate/deactivate devices that
where not part of the pipeline.

This is probably the wrong patch to use an example, as this one is for
a multiplexed interface, where there is no need to go through an
s_stream() for the two CSI-2 endpoints, but as you pointed out in our
brief offline chat, the AFE->TX routing example for this very device
is a good one: if we change the analogue source that is internally
routed to the CSI-2 output of the adv748x, do we need to s_stream(1)
the now routed entity and s_stream(0) on the not not-anymore-routed
one?

My gut feeling is that this is up to userspace, as it should know
what are the requirements of the devices in the system, but this mean
going through an s_stream(0)/s_stream(1) sequence on the video device,
and that would interrupt the streaming for sure.

At the same time, I don't feel too much at ease with the idea of
s_routing calling s_stream on the entity' remote subdevices, as this
would skip the link format validation that media_pipeline_start()
performs.

So yeah, I understand your point, but I don't have a real answer,
maybe someone else does and want to share his mind?

Thanks
   j

> Thanks,
> --
> Luca

--bqma2ubyzmeircxs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEtcQ9SICaIIqPWDjAcjQGjxahVjwFAlyLdEIACgkQcjQGjxah
VjwZMQ//X3ZnsEhNWzcjk8Zf/KbWJSqbnkviLbHbAMkw11P1JH4ZNiDp7z5WCevO
lbb5mawwYynNKumWOsEVkzvvAnMTyO9rnkaqG6N4unwXM9rw8JABR1aOIdhwF88I
16Uj+4PITwk8wdRMfu1whk8F/4o3gn8sSiRUcs2ZmjHQf5T1xqcI8/9Wp7J38RlE
94RfbBuPGXRBL1Wz88S+sAB5ot9xpuPX3wnnpft5rn6ky6p28zogl5/+aV3rUH/d
Qafr4OBES2IWr033TEGx7Uift4MRHBCes0VFcS8IdZL16lb7MAQ0lPQBKa1XpxLY
3tSKT+98Y+0RpN1FuO0m4Fbj5TAxP0MnQmHtGwMK64WBkJ1l2d/9syhJOUJ5JFkj
lKz/FoPEYRbvJDLbsaKV0TcsdOhE/RSVX9JDmzK3oIHH4/TUMQqDp0iV8AC8msNX
BhxRBZdGchve2Fb1NIov2OQxkBjx8GgX2yse+5q+jAvuQ6dqVQ3SCJ2O8G40g9N2
yMjV3fcgp98mz98pQjkgufNneRNmmefBiY4czXRrXCxswxGtbSM3bjv6eDkLej1y
q5cykdRAgJkDizvusTjMPRJLlXCiPqs+bIdbfTM2FfgqU17xqWhj7zJ66vTwkpQg
A9zkeAdLa+s+FaKApacrxATFMEIodSJni0iBHZ7TXtk2WcSDkv8=
=3r0R
-----END PGP SIGNATURE-----

--bqma2ubyzmeircxs--
