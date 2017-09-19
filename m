Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:21161 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751410AbdISMkf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Sep 2017 08:40:35 -0400
Date: Tue, 19 Sep 2017 15:39:30 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, robh@kernel.org,
        hverkuil@xs4all.nl, devicetree@vger.kernel.org, pavel@ucw.cz,
        sre@kernel.org
Subject: Re: [PATCH v13 07/25] rcar-vin: Use generic parser for parsing
 fwnode endpoints
Message-ID: <20170919123930.xtq44elhwy6vdfxv@paasikivi.fi.intel.com>
References: <20170915141724.23124-1-sakari.ailus@linux.intel.com>
 <20170915141724.23124-8-sakari.ailus@linux.intel.com>
 <3549838.F21OCYHXEu@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3549838.F21OCYHXEu@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Tue, Sep 19, 2017 at 02:53:16PM +0300, Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thank you for the patch.
> 
> On Friday, 15 September 2017 17:17:06 EEST Sakari Ailus wrote:
> > Instead of using driver implementation, use
> 
> Same comment as for patch 06/25.

Will fix.

> 
> > v4l2_async_notifier_parse_fwnode_endpoints() to parse the fwnode endpoints
> > of the device.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> > ---
> >  drivers/media/platform/rcar-vin/rcar-core.c | 112 ++++++++-----------------
> >  drivers/media/platform/rcar-vin/rcar-dma.c  |  10 +--
> >  drivers/media/platform/rcar-vin/rcar-v4l2.c |  14 ++--
> >  drivers/media/platform/rcar-vin/rcar-vin.h  |   4 +-
> >  4 files changed, 48 insertions(+), 92 deletions(-)
> > 
> > diff --git a/drivers/media/platform/rcar-vin/rcar-core.c
> > b/drivers/media/platform/rcar-vin/rcar-core.c index
> > 142de447aaaa..62b4a94f9a39 100644
> > --- a/drivers/media/platform/rcar-vin/rcar-core.c
> > +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> 
> [snip]
> 
> > @@ -120,117 +121,70 @@ static int rvin_digital_notify_bound(struct
> 
> [snip]
> 
> > -static int rvin_digitial_parse_v4l2(struct rvin_dev *vin,
> > -				    struct device_node *ep,
> > -				    struct v4l2_mbus_config *mbus_cfg)
> > +static int rvin_digital_parse_v4l2(struct device *dev,
> > +				   struct v4l2_fwnode_endpoint *vep,
> > +				   struct v4l2_async_subdev *asd)
> >  {
> > -	struct v4l2_fwnode_endpoint v4l2_ep;
> > -	int ret;
> > +	struct rvin_dev *vin = dev_get_drvdata(dev);
> 
> Doesn't this show that we miss a context argument to the callback function ? 
> Storing the context in device driver data is probably OK if the driver parsing 
> the endpoints controls the struct device, but is that always the case ?

How does a driver know the hardware other than, uh, the device?

I guess we could add a private pointer when the async notifier is
registered if there's a real need for it. The notifier could be an
alternative but it wouldn't be applicable to sub-devices.

> 
> > +	struct rvin_graph_entity *rvge =
> > +		container_of(asd, struct rvin_graph_entity, asd);
> > 
> > -	ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(ep), &v4l2_ep);
> > -	if (ret) {
> > -		vin_err(vin, "Could not parse v4l2 endpoint\n");
> > -		return -EINVAL;
> > -	}
> > +	if (vep->base.port || vep->base.id)
> > +		return -ENOTCONN;
> > 
> > -	mbus_cfg->type = v4l2_ep.bus_type;
> > +	rvge->mbus_cfg.type = vep->bus_type;
> > 
> > -	switch (mbus_cfg->type) {
> > +	switch (rvge->mbus_cfg.type) {
> >  	case V4L2_MBUS_PARALLEL:
> >  		vin_dbg(vin, "Found PARALLEL media bus\n");
> > -		mbus_cfg->flags = v4l2_ep.bus.parallel.flags;
> > +		rvge->mbus_cfg.flags = vep->bus.parallel.flags;
> >  		break;
> >  	case V4L2_MBUS_BT656:
> >  		vin_dbg(vin, "Found BT656 media bus\n");
> > -		mbus_cfg->flags = 0;
> > +		rvge->mbus_cfg.flags = 0;
> >  		break;
> >  	default:
> >  		vin_err(vin, "Unknown media bus type\n");
> >  		return -EINVAL;
> >  	}
> > 
> > -	return 0;
> > -}
> > -
> > -static int rvin_digital_graph_parse(struct rvin_dev *vin)
> > -{
> > -	struct device_node *ep, *np;
> > -	int ret;
> > -
> > -	vin->digital.asd.match.fwnode.fwnode = NULL;
> > -	vin->digital.subdev = NULL;
> > -
> > -	/*
> > -	 * Port 0 id 0 is local digital input, try to get it.
> > -	 * Not all instances can or will have this, that is OK
> > -	 */
> > -	ep = of_graph_get_endpoint_by_regs(vin->dev->of_node, 0, 0);
> > -	if (!ep)
> > -		return 0;
> > -
> > -	np = of_graph_get_remote_port_parent(ep);
> > -	if (!np) {
> > -		vin_err(vin, "No remote parent for digital input\n");
> > -		of_node_put(ep);
> > -		return -EINVAL;
> > -	}
> > -	of_node_put(np);
> > -
> > -	ret = rvin_digitial_parse_v4l2(vin, ep, &vin->digital.mbus_cfg);
> > -	of_node_put(ep);
> > -	if (ret)
> > -		return ret;
> > -
> > -	vin->digital.asd.match.fwnode.fwnode = of_fwnode_handle(np);
> > -	vin->digital.asd.match_type = V4L2_ASYNC_MATCH_FWNODE;
> > +	vin->digital = rvge;
> > 
> >  	return 0;
> >  }
> > 
> >  static int rvin_digital_graph_init(struct rvin_dev *vin)
> >  {
> > -	struct v4l2_async_subdev **subdevs = NULL;
> >  	int ret;
> > 
> > -	ret = rvin_digital_graph_parse(vin);
> > +	ret = v4l2_async_notifier_parse_fwnode_endpoints(
> > +		vin->dev, &vin->notifier,
> > +		sizeof(struct rvin_graph_entity), rvin_digital_parse_v4l2);
> >  	if (ret)
> >  		return ret;
> > 
> > -	if (!vin->digital.asd.match.fwnode.fwnode) {
> > -		vin_dbg(vin, "No digital subdevice found\n");
> > -		return -ENODEV;
> > -	}
> > -
> > -	/* Register the subdevices notifier. */
> > -	subdevs = devm_kzalloc(vin->dev, sizeof(*subdevs), GFP_KERNEL);
> > -	if (subdevs == NULL)
> > -		return -ENOMEM;
> > -
> > -	subdevs[0] = &vin->digital.asd;
> > -
> > -	vin_dbg(vin, "Found digital subdevice %pOF\n",
> > -		to_of_node(subdevs[0]->match.fwnode.fwnode));
> > +	if (vin->digital)
> > +		vin_dbg(vin, "Found digital subdevice %pOF\n",
> > +			to_of_node(
> > +				vin->digital->asd.match.fwnode.fwnode));
> 
> Isn't this is a change in behaviour ? The driver currently returns -ENODEV 
> when no digital subdev is found.

Seems so, I'll address that in v14.

> 
> > -	vin->notifier.num_subdevs = 1;
> > -	vin->notifier.subdevs = subdevs;
> >  	vin->notifier.bound = rvin_digital_notify_bound;
> >  	vin->notifier.unbind = rvin_digital_notify_unbind;
> >  	vin->notifier.complete = rvin_digital_notify_complete;
> > -
> >  	ret = v4l2_async_notifier_register(&vin->v4l2_dev, &vin->notifier);
> >  	if (ret < 0) {
> >  		vin_err(vin, "Notifier registration failed\n");
> 

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
