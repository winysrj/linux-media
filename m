Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:55016 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728828AbeIRQpY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Sep 2018 12:45:24 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: kieran.bingham@ideasonboard.com
Cc: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Jacopo Mondi <jacopo@jmondi.org>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, sakari.ailus@iki.fi
Subject: Re: [PATCH 1/3] i2c: adv748x: store number of CSI-2 lanes described in device tree
Date: Tue, 18 Sep 2018 14:13:29 +0300
Message-ID: <1658112.YQ0khu1noY@avalon>
In-Reply-To: <21b8a885-48c5-70c8-8866-1830c45c27a9@ideasonboard.com>
References: <20180918014509.6394-1-niklas.soderlund+renesas@ragnatech.se> <1715235.WJqBHKOvrx@avalon> <21b8a885-48c5-70c8-8866-1830c45c27a9@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On Tuesday, 18 September 2018 13:51:34 EEST Kieran Bingham wrote:
> On 18/09/18 11:46, Laurent Pinchart wrote:
> > On Tuesday, 18 September 2018 13:37:55 EEST Kieran Bingham wrote:
> >> On 18/09/18 11:28, Laurent Pinchart wrote:
> >>> On Tuesday, 18 September 2018 13:19:39 EEST Kieran Bingham wrote:
> >>>> On 18/09/18 02:45, Niklas S=F6derlund wrote:
> >>>>> The adv748x CSI-2 transmitters TXA and TXB can use different number=
 of
> >>>>> lines to transmit data on. In order to be able configure the device
> >>>>> correctly this information need to be parsed from device tree and
> >>>>> stored in each TX private data structure.
> >>>>>=20
> >>>>> TXA supports 1, 2 and 4 lanes while TXB supports 1 lane.
> >>>>=20
> >>>> Am I right in assuming that it is the CSI device which specifies the
> >>>> number of lanes in their DT?
> >>>=20
> >>> Do you mean the CSI-2 receiver ? Both the receiver and the transmitter
> >>> should specify the data lanes in their DT node.
> >>=20
> >> Yes, I should have said CSI-2 receiver.
> >>=20
> >> Aha - so *both* sides of the link have to specify the lanes and
> >> presumably match with each other?
> >=20
> > Yes, they should certainly match :-)
>=20
> I assumed so :) - do we need to validate that at a framework level?
> (or perhaps it already is, all I've only looked at this morning is
> e-mails :D )

It's not done yet as far as I know. CC'ing Sakari who may have a comment=20
regarding whether this should be added.

> >>>> Could we make this clear in the commit log (and possibly an extra
> >>>> comment in the code). At first I was assuming we would have to decla=
re
> >>>> the number of lanes in the ADV748x TX DT node, but I don't think tha=
t's
> >>>> the case.
> >>>>=20
> >>>>> Signed-off-by: Niklas S=F6derlund
> >>>>> <niklas.soderlund+renesas@ragnatech.se>
> >>>>> ---
> >>>>>=20
> >>>>>  drivers/media/i2c/adv748x/adv748x-core.c | 49 ++++++++++++++++++++=
+++
> >>>>>  drivers/media/i2c/adv748x/adv748x.h      |  1 +
> >>>>>  2 files changed, 50 insertions(+)
> >>>>>=20
> >>>>> diff --git a/drivers/media/i2c/adv748x/adv748x-core.c
> >>>>> b/drivers/media/i2c/adv748x/adv748x-core.c index
> >>>>> 85c027bdcd56748d..a93f8ea89a228474 100644
> >>>>> --- a/drivers/media/i2c/adv748x/adv748x-core.c
> >>>>> +++ b/drivers/media/i2c/adv748x/adv748x-core.c
> >=20
> > [snip]
> >=20
> >>>>> +static int adv748x_parse_csi2_lanes(struct adv748x_state *state,
> >>>>> +				    unsigned int port,
> >>>>> +				    struct device_node *ep)
> >>>>> +{
> >>>>> +	struct v4l2_fwnode_endpoint vep;
> >>>>> +	unsigned int num_lanes;
> >>>>> +	int ret;
> >>>>> +
> >>>>> +	if (port !=3D ADV748X_PORT_TXA && port !=3D ADV748X_PORT_TXB)
> >>>>> +		return 0;
> >>>>> +
> >>>>> +	ret =3D v4l2_fwnode_endpoint_parse(of_fwnode_handle(ep), &vep);
> >>>>> +	if (ret)
> >>>>> +		return ret;
> >>>>> +
> >>>>> +	num_lanes =3D vep.bus.mipi_csi2.num_data_lanes;
> >>>>> +
> >>>>=20
> >>>> If I'm not mistaken we are parsing /someone elses/ DT node here (the
> >>>> CSI receiver or such).
> >>>=20
> >>> Aren't we parsing our own endpoint ? The ep argument comes from ep_np=
 in
> >>> adv748x_parse_dt(), and that's the endpoint iterator used with
> >>>=20
> >>> 	for_each_endpoint_of_node(state->dev->of_node, ep_np)
> >>=20
> >> Bah - my head was polluted with the async subdevice stuff where we were
> >> getting the endpoint of the other device, but of course that's
> >> completely unrelated here.
> >>=20
> >>>> Is it now guaranteed on the mipi_csi2 bus to have the (correct) lanes
> >>>> defined?
> >>>>=20
> >>>> Do we need to fall back to some safe defaults at all (1 lane?) ?
> >>>> Actually - perhaps there is no safe default. I guess if the lanes
> >>>> aren't configured correctly we're not going to get a good signal at =
the
> >>>> other end.
> >>>=20
> >>> The endpoints should contain a data-lanes property. That's the case in
> >>> the mainline DT sources, but it's not explicitly stated as a mandatory
> >>> property. I think we should update the bindings.
> >>=20
> >> Yes, - as this code change is making the property mandatory - we should
> >> certainly state that in the bindings, unless we can fall back to a
> >> sensible default (perhaps the max supported on that component?)
> >=20
> > I'm not sure there's a sensible default, I'd rather specify it explicit=
ly.
> > Note that the data-lanes property doesn't just specify the number of
> > lanes, but also how they are remapped, when that feature is supported by
> > the CSI-2 transmitter or receiver.
>=20
> Ok understood. As I feared - we can't really default - because it has to
> match and be defined.
>=20
> So making the DT property mandatory really is the way to go then.
>=20
> >>>>> +	if (vep.base.port =3D=3D ADV748X_PORT_TXA) {
> >>>>> +		if (num_lanes !=3D 1 && num_lanes !=3D 2 && num_lanes !=3D 4) {
> >>>>> +			adv_err(state, "TXA: Invalid number (%d) of lanes\n",
> >>>>> +				num_lanes);
> >>>>> +			return -EINVAL;
> >>>>> +		}
> >>>>> +
> >>>>> +		state->txa.num_lanes =3D num_lanes;
> >>>>> +		adv_dbg(state, "TXA: using %d lanes\n", state->txa.num_lanes);
> >>>>> +	}
> >>>>> +
> >>>>> +	if (vep.base.port =3D=3D ADV748X_PORT_TXB) {
> >>>>> +		if (num_lanes !=3D 1) {
> >>>>> +			adv_err(state, "TXB: Invalid number (%d) of lanes\n",
> >>>>> +				num_lanes);
> >>>>> +			return -EINVAL;
> >>>>> +		}
> >>>>> +
> >>>>> +		state->txb.num_lanes =3D num_lanes;
> >>>>> +		adv_dbg(state, "TXB: using %d lanes\n", state->txb.num_lanes);
> >>>>> +	}
> >>>>> +
> >>>>> +	return 0;
> >>>>> +}
> >=20
> > [snip]

=2D-=20
Regards,

Laurent Pinchart
