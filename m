Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37294 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725749AbeIUF3z (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Sep 2018 01:29:55 -0400
Date: Fri, 21 Sep 2018 02:43:53 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: kieran.bingham@ideasonboard.com,
        Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Jacopo Mondi <jacopo@jmondi.org>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 1/3] i2c: adv748x: store number of CSI-2 lanes described
 in device tree
Message-ID: <20180920234353.azhi55avqkaff4h7@valkosipuli.retiisi.org.uk>
References: <20180918014509.6394-1-niklas.soderlund+renesas@ragnatech.se>
 <1715235.WJqBHKOvrx@avalon>
 <21b8a885-48c5-70c8-8866-1830c45c27a9@ideasonboard.com>
 <1658112.YQ0khu1noY@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1658112.YQ0khu1noY@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent, Kieran,

On Tue, Sep 18, 2018 at 02:13:29PM +0300, Laurent Pinchart wrote:
> Hi Kieran,
> 
> On Tuesday, 18 September 2018 13:51:34 EEST Kieran Bingham wrote:
> > On 18/09/18 11:46, Laurent Pinchart wrote:
> > > On Tuesday, 18 September 2018 13:37:55 EEST Kieran Bingham wrote:
> > >> On 18/09/18 11:28, Laurent Pinchart wrote:
> > >>> On Tuesday, 18 September 2018 13:19:39 EEST Kieran Bingham wrote:
> > >>>> On 18/09/18 02:45, Niklas Söderlund wrote:
> > >>>>> The adv748x CSI-2 transmitters TXA and TXB can use different number of
> > >>>>> lines to transmit data on. In order to be able configure the device
> > >>>>> correctly this information need to be parsed from device tree and
> > >>>>> stored in each TX private data structure.
> > >>>>> 
> > >>>>> TXA supports 1, 2 and 4 lanes while TXB supports 1 lane.
> > >>>> 
> > >>>> Am I right in assuming that it is the CSI device which specifies the
> > >>>> number of lanes in their DT?
> > >>> 
> > >>> Do you mean the CSI-2 receiver ? Both the receiver and the transmitter
> > >>> should specify the data lanes in their DT node.
> > >> 
> > >> Yes, I should have said CSI-2 receiver.
> > >> 
> > >> Aha - so *both* sides of the link have to specify the lanes and
> > >> presumably match with each other?
> > > 
> > > Yes, they should certainly match :-)
> > 
> > I assumed so :) - do we need to validate that at a framework level?
> > (or perhaps it already is, all I've only looked at this morning is
> > e-mails :D )
> 
> It's not done yet as far as I know. CC'ing Sakari who may have a comment 
> regarding whether this should be added.

There's no validation done currently. The endpoints are parsed separately
at the moment, initiated by the respective device driver.

The latest fwnode set brings a concept of default configuration that also
allows support for setting the default for the number of lanes. This is
known by the driver, but could not be known by the framework checking the
configuration across the endpoints. I guess this could be done at the time
both endpoints have been parsed, as in stored to the async sub-device.

Some checks could indeed be done, but what to do when those checks fail?

That said, I don't think this has really been an issue so far --- if you
get this wrong the devices just won't work. The last fwnode set greatly
improves the quality of the debug information printed, so debugging should
be easier when things go wrong already. And this is already more than we've
had so far.

> 
> > >>>> Could we make this clear in the commit log (and possibly an extra
> > >>>> comment in the code). At first I was assuming we would have to declare
> > >>>> the number of lanes in the ADV748x TX DT node, but I don't think that's
> > >>>> the case.
> > >>>> 
> > >>>>> Signed-off-by: Niklas Söderlund
> > >>>>> <niklas.soderlund+renesas@ragnatech.se>
> > >>>>> ---
> > >>>>> 
> > >>>>>  drivers/media/i2c/adv748x/adv748x-core.c | 49 +++++++++++++++++++++++
> > >>>>>  drivers/media/i2c/adv748x/adv748x.h      |  1 +
> > >>>>>  2 files changed, 50 insertions(+)
> > >>>>> 
> > >>>>> diff --git a/drivers/media/i2c/adv748x/adv748x-core.c
> > >>>>> b/drivers/media/i2c/adv748x/adv748x-core.c index
> > >>>>> 85c027bdcd56748d..a93f8ea89a228474 100644
> > >>>>> --- a/drivers/media/i2c/adv748x/adv748x-core.c
> > >>>>> +++ b/drivers/media/i2c/adv748x/adv748x-core.c
> > > 
> > > [snip]
> > > 
> > >>>>> +static int adv748x_parse_csi2_lanes(struct adv748x_state *state,
> > >>>>> +				    unsigned int port,
> > >>>>> +				    struct device_node *ep)
> > >>>>> +{
> > >>>>> +	struct v4l2_fwnode_endpoint vep;
> > >>>>> +	unsigned int num_lanes;
> > >>>>> +	int ret;
> > >>>>> +
> > >>>>> +	if (port != ADV748X_PORT_TXA && port != ADV748X_PORT_TXB)
> > >>>>> +		return 0;
> > >>>>> +
> > >>>>> +	ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(ep), &vep);
> > >>>>> +	if (ret)
> > >>>>> +		return ret;
> > >>>>> +
> > >>>>> +	num_lanes = vep.bus.mipi_csi2.num_data_lanes;
> > >>>>> +
> > >>>> 
> > >>>> If I'm not mistaken we are parsing /someone elses/ DT node here (the
> > >>>> CSI receiver or such).
> > >>> 
> > >>> Aren't we parsing our own endpoint ? The ep argument comes from ep_np in
> > >>> adv748x_parse_dt(), and that's the endpoint iterator used with
> > >>> 
> > >>> 	for_each_endpoint_of_node(state->dev->of_node, ep_np)
> > >> 
> > >> Bah - my head was polluted with the async subdevice stuff where we were
> > >> getting the endpoint of the other device, but of course that's
> > >> completely unrelated here.
> > >> 
> > >>>> Is it now guaranteed on the mipi_csi2 bus to have the (correct) lanes
> > >>>> defined?
> > >>>> 
> > >>>> Do we need to fall back to some safe defaults at all (1 lane?) ?
> > >>>> Actually - perhaps there is no safe default. I guess if the lanes
> > >>>> aren't configured correctly we're not going to get a good signal at the
> > >>>> other end.
> > >>> 
> > >>> The endpoints should contain a data-lanes property. That's the case in
> > >>> the mainline DT sources, but it's not explicitly stated as a mandatory
> > >>> property. I think we should update the bindings.

Many devices have just a single lane. Do you think this should be mandatory
in that case as well?

Lane mapping is not a very common feature nowadays; to be fair, I don't
know other hardware than omap3isp that supports it. The numbers are still
needed as many devices nowadays support choosing how the lanes are
distributed across the PHYs.

> > >> 
> > >> Yes, - as this code change is making the property mandatory - we should
> > >> certainly state that in the bindings, unless we can fall back to a
> > >> sensible default (perhaps the max supported on that component?)
> > > 
> > > I'm not sure there's a sensible default, I'd rather specify it explicitly.
> > > Note that the data-lanes property doesn't just specify the number of
> > > lanes, but also how they are remapped, when that feature is supported by
> > > the CSI-2 transmitter or receiver.
> > 
> > Ok understood. As I feared - we can't really default - because it has to
> > match and be defined.
> > 
> > So making the DT property mandatory really is the way to go then.

I certainly have no objections to making this mandatory for some devices as
long as it makes sense --- and for devices with just a single data lane
without remapping with the clock lane it does not.

In that case, the driver would just set the number of lanes in the default
configuration to zero, and check the configuration it gets back is valid
--- as usual.

For what it's worth, quite a few parallel interface devices explicitly
state default configurations in their DT bindings. I admit the data-lanes
property is not a great candidate for setting a default for (if a device
has more than a single data lane).

> > 
> > >>>>> +	if (vep.base.port == ADV748X_PORT_TXA) {
> > >>>>> +		if (num_lanes != 1 && num_lanes != 2 && num_lanes != 4) {
> > >>>>> +			adv_err(state, "TXA: Invalid number (%d) of lanes\n",
> > >>>>> +				num_lanes);
> > >>>>> +			return -EINVAL;
> > >>>>> +		}
> > >>>>> +
> > >>>>> +		state->txa.num_lanes = num_lanes;
> > >>>>> +		adv_dbg(state, "TXA: using %d lanes\n", state->txa.num_lanes);
> > >>>>> +	}
> > >>>>> +
> > >>>>> +	if (vep.base.port == ADV748X_PORT_TXB) {
> > >>>>> +		if (num_lanes != 1) {
> > >>>>> +			adv_err(state, "TXB: Invalid number (%d) of lanes\n",
> > >>>>> +				num_lanes);
> > >>>>> +			return -EINVAL;
> > >>>>> +		}
> > >>>>> +
> > >>>>> +		state->txb.num_lanes = num_lanes;
> > >>>>> +		adv_dbg(state, "TXB: using %d lanes\n", state->txb.num_lanes);
> > >>>>> +	}
> > >>>>> +
> > >>>>> +	return 0;
> > >>>>> +}
> > > 
> > > [snip]
> 

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
