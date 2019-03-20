Return-Path: <SRS0=I/aX=RX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA875C10F05
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 17:13:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C9C521873
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 17:13:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbfCTRNc (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Mar 2019 13:13:32 -0400
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:43175 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726449AbfCTRNc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Mar 2019 13:13:32 -0400
X-Originating-IP: 2.224.242.101
Received: from uno.localdomain (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id DF0414000C;
        Wed, 20 Mar 2019 17:13:27 +0000 (UTC)
Date:   Wed, 20 Mar 2019 18:14:06 +0100
From:   Jacopo Mondi <jacopo@jmondi.org>
To:     Luca Ceresoli <luca@lucaceresoli.net>
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v3 26/31] adv748x: csi2: add internal routing
 configuration
Message-ID: <20190320171406.s462267lssaxkqo4@uno.localdomain>
References: <20190305185150.20776-1-jacopo+renesas@jmondi.org>
 <20190305185150.20776-27-jacopo+renesas@jmondi.org>
 <4f5b5763-be90-4040-7d55-986471168de1@lucaceresoli.net>
 <20190315094538.bs5ecsdzndrxjdbb@uno.localdomain>
 <20190315100613.avmsmavdraxetkzl@kekkonen.localdomain>
 <28dbf2c7-2834-2bae-d56e-43e50d763c9f@lucaceresoli.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="lwydrgcy7zbadacc"
Content-Disposition: inline
In-Reply-To: <28dbf2c7-2834-2bae-d56e-43e50d763c9f@lucaceresoli.net>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--lwydrgcy7zbadacc
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Luca,
   thanks for the input

On Sat, Mar 16, 2019 at 11:23:42AM +0100, Luca Ceresoli wrote:
> Hi Jacopo, Sakari,
>
> On 15/03/19 11:06, Sakari Ailus wrote:
> > Hi Luca, Jacopo,
> >
> > On Fri, Mar 15, 2019 at 10:45:38AM +0100, Jacopo Mondi wrote:
> >> Hi Luca,
> >>
> >> On Thu, Mar 14, 2019 at 03:45:27PM +0100, Luca Ceresoli wrote:
> >>> Hi,
> >>>
> >>> begging your pardon for the noob question below...
> >>>
> >>
> >> Let a noob help another noob then
> >>
> >>> On 05/03/19 19:51, Jacopo Mondi wrote:
> >>>> From: Niklas S=C3=B6derlund <niklas.soderlund+renesas@ragnatech.se>
> >>>>
> >>>> Add support to get and set the internal routing between the adv748x
> >>>> CSI-2 transmitters sink pad and its multiplexed source pad. This rou=
ting
> >>>> includes which stream of the multiplexed pad to use, allowing the us=
er
> >>>> to select which CSI-2 virtual channel to use when transmitting the
> >>>> stream.
> >>>>
> >>>> Signed-off-by: Niklas S=C3=B6derlund <niklas.soderlund+renesas@ragna=
tech.se>
> >>>> Reviewed-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> >>>> ---
> >>>>  drivers/media/i2c/adv748x/adv748x-csi2.c | 65 +++++++++++++++++++++=
+++
> >>>>  1 file changed, 65 insertions(+)
> >>>>
> >>>> diff --git a/drivers/media/i2c/adv748x/adv748x-csi2.c b/drivers/medi=
a/i2c/adv748x/adv748x-csi2.c
> >>>> index d8f7cbee86e7..13454af72c6e 100644
> >>>> --- a/drivers/media/i2c/adv748x/adv748x-csi2.c
> >>>> +++ b/drivers/media/i2c/adv748x/adv748x-csi2.c
> >>>> @@ -14,6 +14,8 @@
> >>>>
> >>>>  #include "adv748x.h"
> >>>>
> >>>> +#define ADV748X_CSI2_ROUTES_MAX 4
> >>>> +
> >>>>  struct adv748x_csi2_format {
> >>>>  	unsigned int code;
> >>>>  	unsigned int datatype;
> >>>> @@ -253,10 +255,73 @@ static int adv748x_csi2_get_frame_desc(struct =
v4l2_subdev *sd, unsigned int pad,
> >>>>  	return 0;
> >>>>  }
> >>>>
> >>>> +static int adv748x_csi2_get_routing(struct v4l2_subdev *sd,
> >>>> +				    struct v4l2_subdev_krouting *routing)
> >>>> +{
> >>>> +	struct adv748x_csi2 *tx =3D adv748x_sd_to_csi2(sd);
> >>>> +	struct v4l2_subdev_route *r =3D routing->routes;
> >>>> +	unsigned int vc;
> >>>> +
> >>>> +	if (routing->num_routes < ADV748X_CSI2_ROUTES_MAX) {
> >>>> +		routing->num_routes =3D ADV748X_CSI2_ROUTES_MAX;
> >>>> +		return -ENOSPC;
> >>>> +	}
> >>>> +
> >>>> +	routing->num_routes =3D ADV748X_CSI2_ROUTES_MAX;
> >>>> +
> >>>> +	for (vc =3D 0; vc < ADV748X_CSI2_ROUTES_MAX; vc++) {
> >>>> +		r->sink_pad =3D ADV748X_CSI2_SINK;
> >>>> +		r->sink_stream =3D 0;
> >>>> +		r->source_pad =3D ADV748X_CSI2_SOURCE;
> >>>> +		r->source_stream =3D vc;
> >>>> +		r->flags =3D vc =3D=3D tx->vc ? V4L2_SUBDEV_ROUTE_FL_ACTIVE : 0;
> >>>> +		r++;
> >>>> +	}
> >>>> +
> >>>> +	return 0;
> >>>> +}
> >>>> +
> >>>> +static int adv748x_csi2_set_routing(struct v4l2_subdev *sd,
> >>>> +				    struct v4l2_subdev_krouting *routing)
> >>>> +{
> >>>> +	struct adv748x_csi2 *tx =3D adv748x_sd_to_csi2(sd);
> >>>> +	struct v4l2_subdev_route *r =3D routing->routes;
> >>>> +	unsigned int i;
> >>>> +	int vc =3D -1;
> >>>> +
> >>>> +	if (routing->num_routes > ADV748X_CSI2_ROUTES_MAX)
> >>>> +		return -ENOSPC;
> >>>> +
> >>>> +	for (i =3D 0; i < routing->num_routes; i++) {
> >>>> +		if (r->sink_pad !=3D ADV748X_CSI2_SINK ||
> >>>> +		    r->sink_stream !=3D 0 ||
> >>>> +		    r->source_pad !=3D ADV748X_CSI2_SOURCE ||
> >>>> +		    r->source_stream >=3D ADV748X_CSI2_ROUTES_MAX)
> >>>> +			return -EINVAL;
> >>>> +
> >>>> +		if (r->flags & V4L2_SUBDEV_ROUTE_FL_ACTIVE) {
> >>>> +			if (vc !=3D -1)
> >>>> +				return -EMLINK;
> >>>> +
> >>>> +			vc =3D r->source_stream;
> >>>> +		}
> >>>> +		r++;
> >>>> +	}
> >>>> +
> >>>> +	if (vc !=3D -1)
> >>>> +		tx->vc =3D vc;
> >>>> +
> >>>> +	adv748x_csi2_set_virtual_channel(tx, tx->vc);
> >>>> +
> >>>> +	return 0;
> >>>> +}
> >>>
> >>> Not specific to this patch but rather to the set_routing idea as a
> >>> whole: can the set_routing ioctl be called while the stream is runnin=
g?
> >>>
> >>> If it cannot, I find it a limiting factor for nowadays use cases. I a=
lso
> >>> didn't find where the ioctl is rejected.
> >>>
> >>
> >> The framework does not make assumptions about that at the moment.
> >>
> >>> If it can, then shouldn't this function call s_stream(stop) through t=
he
> >>> sink pad whose route becomes disabled, and a s_stream(start) through =
the
> >>> one that gets enabled?
> >>>
> >>
> >> If I got this right, you're here rightfully pointing out that changing
> >> the routing between pads in an entity migh impact the pipeline as a
> >> whole, and this would require, to activate/deactivate devices that
> >> where not part of the pipeline.
> >
> > I'd say that ultimately this depends on the devices themselves, whether
> > they support this or not. In practice I don't think we have any such ca=
ses
> > at the moment, but it's possible in principle. Changes on the framework=
 may
> > well be needed but likely the biggest complications will still be in
> > drivers supporting that.
>
> I understand V4L2 currently does not support changing a pipeline that is
> running. However there are many use cases that would require it.
>
> Most of the use cases that come to my mind involve a multiplexer with
> multiple inputs, one of which can be selected to be forwarded. In those
> cases s_routing deselects an input and selects another one. How the can
> we handle such cases without sending a s_stream on the two upstreams?
> Having all possible inputs always running is not a real solution.

This seems a very specific use case, I might surely be wrong, but if
such a muxing device allows you to switch from one source to another
without interruption, its driver should also take care of several
other things, such as controlling power and format validations. I
don't think that's something that should be considered at framework
level, but again without a real use case I can't tell for real.

>
> > The media links have a dynamic flag for this purpose but I don't think =
it's
> > ever been used.
> >
> >>
> >> This is probably the wrong patch to use an example, as this one is for
> >> a multiplexed interface, where there is no need to go through an
> >> s_stream() for the two CSI-2 endpoints, but as you pointed out in our
> >> brief offline chat, the AFE->TX routing example for this very device
> >> is a good one: if we change the analogue source that is internally
> >> routed to the CSI-2 output of the adv748x, do we need to s_stream(1)
> >> the now routed entity and s_stream(0) on the not not-anymore-routed
> >> one?
> >>
> >> My gut feeling is that this is up to userspace, as it should know
> >> what are the requirements of the devices in the system, but this mean
> >> going through an s_stream(0)/s_stream(1) sequence on the video device,
> >> and that would interrupt the streaming for sure.
> >>
> >> At the same time, I don't feel too much at ease with the idea of
> >> s_routing calling s_stream on the entity' remote subdevices, as this
> >> would skip the link format validation that media_pipeline_start()
> >> performs.
> >
> > The link validation must be done in this case as well, it may not be
> > simply skipped.
>
> Agreed.
>
> The routing VS pipeline validation point is a very important one. The
> current proposed workflow is:
>
>  1. the pipeline is validated as a whole, having knowledge of all the
>     entities

let me specify this to avoid confusions:
     "all the entities -with an active route in the pipeline-"

>  2. streaming is started
>  3. s_routing is called on an entity (not on the pipeline!)
>
> Now the s_routing function in the entity driver is not in a good
> position to validate the candidate future pipeline as a whole.
>
> Naively I'd say there are two possible solutions:
>
>  1. the s_routing reaches the pipeline first, then the new pipeline is
>     computed and verified, and if verification succeeds it is applied
>  2. a partial pipeline verification mechanism is added, so the entity
>     receiving a s_routing request to e.g. change the sink pad can invoke
>     a verification on the part of pipeline that is about to be
>     activated, and if verification succeeds it is applied
>
> Somehow I suspect neither is trivial...

I would say it is not, but if you have such a device that does not
require going through a s_stream(0)/s_stream(1) cycle and all the
associated re-negotiation and validations, it seems to me nothing
prevents you from handling this in the driver implementation. Maybe it
won't look that great, but this seems to be quite a custom design that
requires all input sources to be linked to your sink pads, their
format validated all at the same time, power, stream activation and
internal mux configuration controlled by s_routing. Am I wrong or
nothing in this series would prevent your from doing this?

tl;dr: I would not make this something the framework should be
concerned about, as there's nothing preventing you from
implementing support for such a use case. But again, without a real
example we can only guess, and I might be overlooking the issue or
missing some relevant detail for sure.

Thanks
   j

>
> --
> Luca
>
>

--lwydrgcy7zbadacc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEtcQ9SICaIIqPWDjAcjQGjxahVjwFAlySdN4ACgkQcjQGjxah
VjxlhA//Zs2y49/m4WoiHSrurlrXlR5VtEC5+a/0kyWahbbxuTJZiWkhrROV+Odb
55rl1g8rqVy2fg+8raSPyqdR5Cy0YUCwO8Ne6khEuE0D7ht72d+icekw12JFsClN
qwfjmxY4+kHPj4XqZcqNnBBXjlvz2TEAxXYl75sD7Q6wRcPIx0TGn7bq6y8Q5Mu3
C1IXgUQkiihgIBwZM21LJWsz3tw9x6Fr2FoXrTQgGLC0lEeC7YaLN09QWa32rIGe
aUShYAdH0sJv6u2e3TWMmWmey/4dZIP/klG1Ob1ar+Bpa0ZnsYZo/IhW5xZxoAfZ
5ZV2wDTAy6NBChQ1eqdOn16wY0+I9C46sXwvIl82cHSO6vP82VB3BqAfiMOgRWc9
VkyAb6vvHxDHva7LoxLmd6cYoTP2IZUYbJgT5VDs2XfKvShtx3Sh9BwpalNFtZN/
J0TtVUaBDenIxDgYlFu/HW96gFk35M/pm0mfIUS1syjCDjVjl5LOTvGiUCB4kR+V
JgPHoYxDu94PGUS4MYb0BQeP9Ef7XHp5DNou9PirjqbtSS3ZZC+OzjksznZeRrJo
iv/BkgG7KyXCxCKWzWXKkTzFpmgdu7yHZ8guMZQS5XfC6C/zIXhKk7RgOdZWafLi
07M0adI286iaYk4l3bqyHpnXoq1bvY7CVEjFOZ5kJmII+U05hrY=
=o7pX
-----END PGP SIGNATURE-----

--lwydrgcy7zbadacc--
