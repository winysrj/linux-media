Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53232 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751562AbdH2ObZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Aug 2017 10:31:25 -0400
Date: Tue, 29 Aug 2017 17:31:21 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        robh@kernel.org, hverkuil@xs4all.nl, devicetree@vger.kernel.org
Subject: Re: [PATCH v5 4/5] v4l: fwnode: Support generic parsing of graph
 endpoints in a device
Message-ID: <20170829143121.6sjdx3lgcoxm6mva@valkosipuli.retiisi.org.uk>
References: <20170829110313.19538-1-sakari.ailus@linux.intel.com>
 <20170829110313.19538-5-sakari.ailus@linux.intel.com>
 <2739432.dQ1BSg1MPy@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2739432.dQ1BSg1MPy@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Tue, Aug 29, 2017 at 05:02:54PM +0300, Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thank you for the patch.

Thanks for the review!

> 
> On Tuesday, 29 August 2017 14:03:12 EEST Sakari Ailus wrote:
> > The current practice is that drivers iterate over their endpoints and
> > parse each endpoint separately. This is very similar in a number of
> > drivers, implement a generic function for the job. Driver specific matters
> > can be taken into account in the driver specific callback.
> > 
> > Convert the omap3isp as an example.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > ---
> >  drivers/media/platform/omap3isp/isp.c | 115 ++++++++++-------------------
> >  drivers/media/platform/omap3isp/isp.h |   5 +-
> >  drivers/media/v4l2-core/v4l2-async.c  |  16 +++++
> >  drivers/media/v4l2-core/v4l2-fwnode.c | 132
> > ++++++++++++++++++++++++++++++++++ include/media/v4l2-async.h            | 
> > 20 +++++-
> >  include/media/v4l2-fwnode.h           |  39 ++++++++++
> >  6 files changed, 242 insertions(+), 85 deletions(-)
> > 
> > diff --git a/drivers/media/platform/omap3isp/isp.c
> > b/drivers/media/platform/omap3isp/isp.c index 1a428fe9f070..a546cf774d40
> > 100644
> > --- a/drivers/media/platform/omap3isp/isp.c
> > +++ b/drivers/media/platform/omap3isp/isp.c
> > @@ -2001,6 +2001,7 @@ static int isp_remove(struct platform_device *pdev)
> >  	__omap3isp_put(isp, false);
> > 
> >  	media_entity_enum_cleanup(&isp->crashed);
> > +	v4l2_async_notifier_release(&isp->notifier);
> > 
> >  	return 0;
> >  }
> > @@ -2011,44 +2012,41 @@ enum isp_of_phy {
> >  	ISP_OF_PHY_CSIPHY2,
> >  };
> > 
> > -static int isp_fwnode_parse(struct device *dev, struct fwnode_handle
> > *fwnode, -			    struct isp_async_subdev *isd)
> > +static int isp_fwnode_parse(struct device *dev,
> > +			    struct v4l2_fwnode_endpoint *vep,
> > +			    struct v4l2_async_subdev *asd)
> >  {
> > +	struct isp_async_subdev *isd =
> > +		container_of(asd, struct isp_async_subdev, asd);
> >  	struct isp_bus_cfg *buscfg = &isd->bus;
> > -	struct v4l2_fwnode_endpoint vep;
> > -	unsigned int i;
> > -	int ret;
> >  	bool csi1 = false;
> > -
> > -	ret = v4l2_fwnode_endpoint_parse(fwnode, &vep);
> > -	if (ret)
> > -		return ret;
> > +	unsigned int i;
> > 
> >  	dev_dbg(dev, "parsing endpoint %pOF, interface %u\n",
> > -		to_of_node(fwnode), vep.base.port);
> > +		to_of_node(vep->base.local_fwnode), vep->base.port);
> > 
> > -	switch (vep.base.port) {
> > +	switch (vep->base.port) {
> >  	case ISP_OF_PHY_PARALLEL:
> >  		buscfg->interface = ISP_INTERFACE_PARALLEL;
> >  		buscfg->bus.parallel.data_lane_shift =
> > -			vep.bus.parallel.data_shift;
> > +			vep->bus.parallel.data_shift;
> >  		buscfg->bus.parallel.clk_pol =
> > -			!!(vep.bus.parallel.flags
> > +			!!(vep->bus.parallel.flags
> >  			   & V4L2_MBUS_PCLK_SAMPLE_FALLING);
> >  		buscfg->bus.parallel.hs_pol =
> > -			!!(vep.bus.parallel.flags & V4L2_MBUS_VSYNC_ACTIVE_LOW);
> > +			!!(vep->bus.parallel.flags & V4L2_MBUS_VSYNC_ACTIVE_LOW);
> >  		buscfg->bus.parallel.vs_pol =
> > -			!!(vep.bus.parallel.flags & V4L2_MBUS_HSYNC_ACTIVE_LOW);
> > +			!!(vep->bus.parallel.flags & V4L2_MBUS_HSYNC_ACTIVE_LOW);
> >  		buscfg->bus.parallel.fld_pol =
> > -			!!(vep.bus.parallel.flags & V4L2_MBUS_FIELD_EVEN_LOW);
> > +			!!(vep->bus.parallel.flags & V4L2_MBUS_FIELD_EVEN_LOW);
> >  		buscfg->bus.parallel.data_pol =
> > -			!!(vep.bus.parallel.flags & V4L2_MBUS_DATA_ACTIVE_LOW);
> > -		buscfg->bus.parallel.bt656 = vep.bus_type == V4L2_MBUS_BT656;
> > +			!!(vep->bus.parallel.flags & V4L2_MBUS_DATA_ACTIVE_LOW);
> > +		buscfg->bus.parallel.bt656 = vep->bus_type == V4L2_MBUS_BT656;
> >  		break;
> > 
> >  	case ISP_OF_PHY_CSIPHY1:
> >  	case ISP_OF_PHY_CSIPHY2:
> > -		switch (vep.bus_type) {
> > +		switch (vep->bus_type) {
> >  		case V4L2_MBUS_CCP2:
> >  		case V4L2_MBUS_CSI1:
> >  			dev_dbg(dev, "CSI-1/CCP-2 configuration\n");
> > @@ -2060,11 +2058,11 @@ static int isp_fwnode_parse(struct device *dev,
> > struct fwnode_handle *fwnode, break;
> >  		default:
> >  			dev_err(dev, "unsupported bus type %u\n",
> > -				vep.bus_type);
> > +				vep->bus_type);
> >  			return -EINVAL;
> >  		}
> > 
> > -		switch (vep.base.port) {
> > +		switch (vep->base.port) {
> >  		case ISP_OF_PHY_CSIPHY1:
> >  			if (csi1)
> >  				buscfg->interface = ISP_INTERFACE_CCP2B_PHY1;
> > @@ -2080,47 +2078,47 @@ static int isp_fwnode_parse(struct device *dev,
> > struct fwnode_handle *fwnode, }
> >  		if (csi1) {
> >  			buscfg->bus.ccp2.lanecfg.clk.pos =
> > -				vep.bus.mipi_csi1.clock_lane;
> > +				vep->bus.mipi_csi1.clock_lane;
> >  			buscfg->bus.ccp2.lanecfg.clk.pol =
> > -				vep.bus.mipi_csi1.lane_polarity[0];
> > +				vep->bus.mipi_csi1.lane_polarity[0];
> >  			dev_dbg(dev, "clock lane polarity %u, pos %u\n",
> >  				buscfg->bus.ccp2.lanecfg.clk.pol,
> >  				buscfg->bus.ccp2.lanecfg.clk.pos);
> > 
> >  			buscfg->bus.ccp2.lanecfg.data[0].pos =
> > -				vep.bus.mipi_csi1.data_lane;
> > +				vep->bus.mipi_csi1.data_lane;
> >  			buscfg->bus.ccp2.lanecfg.data[0].pol =
> > -				vep.bus.mipi_csi1.lane_polarity[1];
> > +				vep->bus.mipi_csi1.lane_polarity[1];
> > 
> >  			dev_dbg(dev, "data lane polarity %u, pos %u\n",
> >  				buscfg->bus.ccp2.lanecfg.data[0].pol,
> >  				buscfg->bus.ccp2.lanecfg.data[0].pos);
> > 
> >  			buscfg->bus.ccp2.strobe_clk_pol =
> > -				vep.bus.mipi_csi1.clock_inv;
> > -			buscfg->bus.ccp2.phy_layer = vep.bus.mipi_csi1.strobe;
> > +				vep->bus.mipi_csi1.clock_inv;
> > +			buscfg->bus.ccp2.phy_layer = vep->bus.mipi_csi1.strobe;
> >  			buscfg->bus.ccp2.ccp2_mode =
> > -				vep.bus_type == V4L2_MBUS_CCP2;
> > +				vep->bus_type == V4L2_MBUS_CCP2;
> >  			buscfg->bus.ccp2.vp_clk_pol = 1;
> > 
> >  			buscfg->bus.ccp2.crc = 1;
> >  		} else {
> >  			buscfg->bus.csi2.lanecfg.clk.pos =
> > -				vep.bus.mipi_csi2.clock_lane;
> > +				vep->bus.mipi_csi2.clock_lane;
> >  			buscfg->bus.csi2.lanecfg.clk.pol =
> > -				vep.bus.mipi_csi2.lane_polarities[0];
> > +				vep->bus.mipi_csi2.lane_polarities[0];
> >  			dev_dbg(dev, "clock lane polarity %u, pos %u\n",
> >  				buscfg->bus.csi2.lanecfg.clk.pol,
> >  				buscfg->bus.csi2.lanecfg.clk.pos);
> > 
> >  			buscfg->bus.csi2.num_data_lanes =
> > -				vep.bus.mipi_csi2.num_data_lanes;
> > +				vep->bus.mipi_csi2.num_data_lanes;
> > 
> >  			for (i = 0; i < buscfg->bus.csi2.num_data_lanes; i++) {
> >  				buscfg->bus.csi2.lanecfg.data[i].pos =
> > -					vep.bus.mipi_csi2.data_lanes[i];
> > +					vep->bus.mipi_csi2.data_lanes[i];
> >  				buscfg->bus.csi2.lanecfg.data[i].pol =
> > -					vep.bus.mipi_csi2.lane_polarities[i + 1];
> > +					vep->bus.mipi_csi2.lane_polarities[i + 1];
> >  				dev_dbg(dev,
> >  					"data lane %u polarity %u, pos %u\n", i,
> >  					buscfg->bus.csi2.lanecfg.data[i].pol,
> > @@ -2137,57 +2135,13 @@ static int isp_fwnode_parse(struct device *dev,
> > struct fwnode_handle *fwnode,
> > 
> >  	default:
> >  		dev_warn(dev, "%pOF: invalid interface %u\n",
> > -			 to_of_node(fwnode), vep.base.port);
> > +			 to_of_node(vep->base.local_fwnode), vep->base.port);
> >  		return -EINVAL;
> >  	}
> > 
> >  	return 0;
> >  }
> > 
> > -static int isp_fwnodes_parse(struct device *dev,
> > -			     struct v4l2_async_notifier *notifier)
> > -{
> > -	struct fwnode_handle *fwnode = NULL;
> > -
> > -	notifier->subdevs = devm_kcalloc(
> > -		dev, ISP_MAX_SUBDEVS, sizeof(*notifier->subdevs), GFP_KERNEL);
> > -	if (!notifier->subdevs)
> > -		return -ENOMEM;
> > -
> > -	while (notifier->num_subdevs < ISP_MAX_SUBDEVS &&
> > -	       (fwnode = fwnode_graph_get_next_endpoint(
> > -			of_fwnode_handle(dev->of_node), fwnode))) {
> > -		struct isp_async_subdev *isd;
> > -
> > -		isd = devm_kzalloc(dev, sizeof(*isd), GFP_KERNEL);
> > -		if (!isd)
> > -			goto error;
> > -
> > -		if (isp_fwnode_parse(dev, fwnode, isd)) {
> > -			devm_kfree(dev, isd);
> > -			continue;
> > -		}
> > -
> > -		notifier->subdevs[notifier->num_subdevs] = &isd->asd;
> > -
> > -		isd->asd.match.fwnode.fwnode =
> > -			fwnode_graph_get_remote_port_parent(fwnode);
> > -		if (!isd->asd.match.fwnode.fwnode) {
> > -			dev_warn(dev, "bad remote port parent\n");
> > -			goto error;
> > -		}
> > -
> > -		isd->asd.match_type = V4L2_ASYNC_MATCH_FWNODE;
> > -		notifier->num_subdevs++;
> > -	}
> > -
> > -	return notifier->num_subdevs;
> > -
> > -error:
> > -	fwnode_handle_put(fwnode);
> > -	return -EINVAL;
> > -}
> > -
> >  static int isp_subdev_notifier_complete(struct v4l2_async_notifier *async)
> >  {
> >  	struct isp_device *isp = container_of(async, struct isp_device,
> > @@ -2256,7 +2210,9 @@ static int isp_probe(struct platform_device *pdev)
> >  	if (ret)
> >  		return ret;
> > 
> > -	ret = isp_fwnodes_parse(&pdev->dev, &isp->notifier);
> > +	ret = v4l2_async_notifier_parse_fwnode_endpoints(
> > +		&pdev->dev, &isp->notifier, sizeof(struct isp_async_subdev),
> > +		isp_fwnode_parse);
> >  	if (ret < 0)
> >  		return ret;
> > 
> > @@ -2407,6 +2363,7 @@ static int isp_probe(struct platform_device *pdev)
> >  	__omap3isp_put(isp, false);
> >  error:
> >  	mutex_destroy(&isp->isp_mutex);
> > +	v4l2_async_notifier_release(&isp->notifier);
> > 
> >  	return ret;
> >  }
> > diff --git a/drivers/media/platform/omap3isp/isp.h
> > b/drivers/media/platform/omap3isp/isp.h index e528df6efc09..8b9043db94b3
> > 100644
> > --- a/drivers/media/platform/omap3isp/isp.h
> > +++ b/drivers/media/platform/omap3isp/isp.h
> > @@ -220,14 +220,11 @@ struct isp_device {
> > 
> >  	unsigned int sbl_resources;
> >  	unsigned int subclk_resources;
> > -
> > -#define ISP_MAX_SUBDEVS		8
> > -	struct v4l2_subdev *subdevs[ISP_MAX_SUBDEVS];
> >  };
> > 
> >  struct isp_async_subdev {
> > -	struct isp_bus_cfg bus;
> >  	struct v4l2_async_subdev asd;
> > +	struct isp_bus_cfg bus;
> >  };
> > 
> >  #define v4l2_subdev_to_bus_cfg(sd) \
> > diff --git a/drivers/media/v4l2-core/v4l2-async.c
> > b/drivers/media/v4l2-core/v4l2-async.c index 851f128eba22..c490acf5ae82
> > 100644
> > --- a/drivers/media/v4l2-core/v4l2-async.c
> > +++ b/drivers/media/v4l2-core/v4l2-async.c
> > @@ -22,6 +22,7 @@
> > 
> >  #include <media/v4l2-async.h>
> >  #include <media/v4l2-device.h>
> > +#include <media/v4l2-fwnode.h>
> >  #include <media/v4l2-subdev.h>
> > 
> >  static bool match_i2c(struct v4l2_subdev *sd, struct v4l2_async_subdev
> > *asd) @@ -278,6 +279,21 @@ void v4l2_async_notifier_unregister(struct
> > v4l2_async_notifier *notifier) }
> >  EXPORT_SYMBOL(v4l2_async_notifier_unregister);
> > 
> > +void v4l2_async_notifier_release(struct v4l2_async_notifier *notifier)
> > +{
> > +	unsigned int i;
> > +
> > +	if (!notifier->max_subdevs)
> > +		return;
> > +
> > +	for (i = 0; i < notifier->num_subdevs; i++)
> > +		kfree(notifier->subdevs[i]);
> > +
> > +	kvfree(notifier->subdevs);
> > +	notifier->max_subdevs = 0;
> > +}
> > +EXPORT_SYMBOL_GPL(v4l2_async_notifier_release);
> > +
> >  int v4l2_async_register_subdev(struct v4l2_subdev *sd)
> >  {
> >  	struct v4l2_async_notifier *notifier;
> > diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c
> > b/drivers/media/v4l2-core/v4l2-fwnode.c index 706f9e7b90f1..39a587c6992a
> > 100644
> > --- a/drivers/media/v4l2-core/v4l2-fwnode.c
> > +++ b/drivers/media/v4l2-core/v4l2-fwnode.c
> > @@ -19,6 +19,7 @@
> >   */
> >  #include <linux/acpi.h>
> >  #include <linux/kernel.h>
> > +#include <linux/mm.h>
> >  #include <linux/module.h>
> >  #include <linux/of.h>
> >  #include <linux/property.h>
> > @@ -26,6 +27,7 @@
> >  #include <linux/string.h>
> >  #include <linux/types.h>
> > 
> > +#include <media/v4l2-async.h>
> >  #include <media/v4l2-fwnode.h>
> > 
> >  enum v4l2_fwnode_bus_type {
> > @@ -313,6 +315,136 @@ void v4l2_fwnode_put_link(struct v4l2_fwnode_link
> > *link) }
> >  EXPORT_SYMBOL_GPL(v4l2_fwnode_put_link);
> > 
> > +static int notifier_realloc(struct v4l2_async_notifier *notifier,
> > +			    unsigned int max_subdevs)
> 
> I'd prefix static functions with v4l2_async_ to avoid namespace clashes.

I can add that.

> 
> > +{
> > +	struct v4l2_async_subdev **subdevs;
> > +	unsigned int i;
> > +
> > +	if (max_subdevs <= notifier->max_subdevs)
> > +		return 0;
> > +
> > +	subdevs = kvmalloc_array(
> > +		max_subdevs, sizeof(*notifier->subdevs),
> > +		GFP_KERNEL | __GFP_ZERO);
> 
> Should it be mentioned in the documentation that the address of the subdevs 
> array will change during parsing and should not be stored by drivers ? It 
> might be overkill.

It won't hurt. I'll add that.

> 
> > +	if (!subdevs)
> > +		return -ENOMEM;
> > +
> > +	if (notifier->subdevs) {
> > +		for (i = 0; i < notifier->num_subdevs; i++)
> > +			subdevs[i] = notifier->subdevs[i];
> 
> To answer your previous question, yes, I would find
> 
> 	memcpy(subdevs, notifier->subdevs, sizeof(*subdevs) * num_subdevs);
> 
> easier to read :-)

I don't agree but I don't have a strong opinion about this, I can change
it.

> 
> > +		kvfree(notifier->subdevs);
> > +	}
> > +
> > +	notifier->subdevs = subdevs;
> > +	notifier->max_subdevs = max_subdevs;
> > +
> > +	return 0;
> > +}
> > +
> > +static int parse_endpoint(
> > +	struct device *dev, struct v4l2_async_notifier *notifier,
> > +	struct fwnode_handle *endpoint, unsigned int asd_struct_size,
> > +	int (*parse_single)(struct device *dev,
> > +			    struct v4l2_fwnode_endpoint *vep,
> > +			    struct v4l2_async_subdev *asd))
> > +{
> > +	struct v4l2_async_subdev *asd;
> > +	struct v4l2_fwnode_endpoint *vep;
> > +	int ret = 0;
> > +
> > +	asd = kzalloc(asd_struct_size, GFP_KERNEL);
> > +	if (!asd)
> > +		return -ENOMEM;
> > +
> > +	asd->match.fwnode.fwnode =
> > +		fwnode_graph_get_remote_port_parent(endpoint);
> > +	if (!asd->match.fwnode.fwnode) {
> > +		dev_warn(dev, "bad remote port parent\n");
> > +		ret = -EINVAL;
> > +		goto out_err;
> > +	}
> > +
> > +	/* Ignore endpoints the parsing of which failed. */
> 
> You don't ignore them anymore, the comment should be updated.

Hmm. I actually intended to do something else about this. :-) As there's a
single error code, handling that would need to be done a little bit
differently right now.

I'd print a warning and proceed. What do you think?

Even if there's a bad DT endpoint, that shouldn't prevent the rest from
working, right?

> 
> > +	vep = v4l2_fwnode_endpoint_alloc_parse(endpoint);
> > +	if (IS_ERR(vep)) {
> > +		ret = PTR_ERR(vep);
> > +		dev_warn(dev, "unable to parse V4L2 fwnode endpoint (%d)\n",
> > +			 ret);
> > +		goto out_err;
> > +	}
> > +
> > +	ret = parse_single(dev, vep, asd);
> > +	v4l2_fwnode_endpoint_free(vep);
> > +	if (ret) {
> > +		dev_warn(dev, "driver could not parse endpoint (%d)\n", ret);
> > +		goto out_err;
> > +	}
> > +
> > +	asd->match_type = V4L2_ASYNC_MATCH_FWNODE;
> > +	notifier->subdevs[notifier->num_subdevs] = asd;
> > +	notifier->num_subdevs++;
> > +
> > +	return 0;
> > +
> > +out_err:
> > +	fwnode_handle_put(asd->match.fwnode.fwnode);
> > +	kfree(asd);
> > +
> > +	return ret;
> > +}
> > +
> > +int v4l2_async_notifier_parse_fwnode_endpoints(
> > +	struct device *dev, struct v4l2_async_notifier *notifier,
> > +	size_t asd_struct_size,
> > +	int (*parse_single)(struct device *dev,
> > +			    struct v4l2_fwnode_endpoint *vep,
> > +			    struct v4l2_async_subdev *asd))
> > +{
> > +	struct fwnode_handle *fwnode = NULL;
> > +	unsigned int max_subdevs = notifier->max_subdevs;
> > +	int ret;
> > +
> > +	if (asd_struct_size < sizeof(struct v4l2_async_subdev) ||
> > +	    notifier->v4l2_dev)
> > +		return -EINVAL;
> > +
> > +	for (fwnode = NULL; (fwnode = fwnode_graph_get_next_endpoint(
> > +				     dev_fwnode(dev), fwnode)); )
> > +		if (fwnode_device_is_available(
> > +			    fwnode_graph_get_port_parent(fwnode)))
> > +			max_subdevs++;
> > +
> > +	/* No subdevs to add? Return here. */
> > +	if (max_subdevs == notifier->max_subdevs)
> > +		return 0;
> > +
> > +	ret = notifier_realloc(notifier, max_subdevs);
> > +	if (ret)
> > +		return ret;
> > +
> > +	for (fwnode = NULL; (fwnode = fwnode_graph_get_next_endpoint(
> > +				     dev_fwnode(dev), fwnode)); ) {
> > +		if (!fwnode_device_is_available(
> > +			    fwnode_graph_get_port_parent(fwnode)))
> > +			continue;
> > +
> > +		if (WARN_ON(notifier->num_subdevs >= notifier->max_subdevs))
> > +			break;
> > +
> > +		ret = parse_endpoint(dev, notifier, fwnode, asd_struct_size,
> > +				     parse_single);
> > +		if (ret < 0)
> > +			break;
> > +	}
> > +
> > +	fwnode_handle_put(fwnode);
> > +
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(v4l2_async_notifier_parse_fwnode_endpoints);
> > +
> >  MODULE_LICENSE("GPL");
> >  MODULE_AUTHOR("Sakari Ailus <sakari.ailus@linux.intel.com>");
> >  MODULE_AUTHOR("Sylwester Nawrocki <s.nawrocki@samsung.com>");
> > diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
> > index c69d8c8a66d0..4a44ab47ab04 100644
> > --- a/include/media/v4l2-async.h
> > +++ b/include/media/v4l2-async.h
> > @@ -18,7 +18,6 @@ struct device;
> >  struct device_node;
> >  struct v4l2_device;
> >  struct v4l2_subdev;
> > -struct v4l2_async_notifier;
> > 
> >  /* A random max subdevice number, used to allocate an array on stack */
> >  #define V4L2_MAX_SUBDEVS 128U
> > @@ -78,7 +77,8 @@ struct v4l2_async_subdev {
> >  /**
> >   * struct v4l2_async_notifier - v4l2_device notifier data
> >   *
> > - * @num_subdevs: number of subdevices
> > + * @num_subdevs: number of subdevices used in subdevs array
> > + * @max_subdevs: number of subdevices allocated in subdevs array
> >   * @subdevs:	array of pointers to subdevice descriptors
> >   * @v4l2_dev:	pointer to struct v4l2_device
> >   * @waiting:	list of struct v4l2_async_subdev, waiting for their drivers
> > @@ -90,6 +90,7 @@ struct v4l2_async_subdev {
> >   */
> >  struct v4l2_async_notifier {
> >  	unsigned int num_subdevs;
> > +	unsigned int max_subdevs;
> >  	struct v4l2_async_subdev **subdevs;
> >  	struct v4l2_device *v4l2_dev;
> >  	struct list_head waiting;
> > @@ -121,6 +122,21 @@ int v4l2_async_notifier_register(struct v4l2_device
> > *v4l2_dev, void v4l2_async_notifier_unregister(struct v4l2_async_notifier
> > *notifier);
> > 
> >  /**
> > + * v4l2_async_notifier_release - release notifier resources
> > + * @notifier: pointer to &struct v4l2_async_notifier
> 
> That's quite obvious given the type of the argument. It would be much more 
> useful to tell which notifier pointer this function expects (although in this 
> case it should be obvious too): "(pointer to )?the notifier whose resources 
> will be released".

This fully matches to the documentation elsewhere in the same file. :-)

I'll replace the text with yours.

> 
> > + *
> > + * Release memory resources related to a notifier, including the async
> > + * sub-devices allocated for the purposes of the notifier. The user is
> > + * responsible for releasing the notifier's resources after calling
> > + * @v4l2_async_notifier_parse_fwnode_endpoints.
> > + *
> > + * There is no harm from calling v4l2_async_notifier_release in other
> > + * cases as long as its memory has been zeroed after it has been
> > + * allocated.
> 
> Zeroing the memory is pretty much a requirement, as 
> v4l2_async_notifier_parse_fwnode_endpoints() won't operate correctly if memory 
> contains random data anyway. Maybe we should introduce 
> v4l2_async_notifier_init() and make v4l2_async_notifier_release() mandatory, 
> but that's out of scope for this patch.

Notifiers are typically allocated as part of a driver specific struct which
is zeroed by the driver.

Registering the notifier won't work either if the rest of the struct wasn't
zeroed.

> 
> > + */
> > +void v4l2_async_notifier_release(struct v4l2_async_notifier *notifier);
> > +
> > +/**
> >   * v4l2_async_register_subdev - registers a sub-device to the asynchronous
> >   * 	subdevice framework
> >   *
> > diff --git a/include/media/v4l2-fwnode.h b/include/media/v4l2-fwnode.h
> > index 68eb22ba571b..46521e8c8872 100644
> > --- a/include/media/v4l2-fwnode.h
> > +++ b/include/media/v4l2-fwnode.h
> > @@ -25,6 +25,8 @@
> >  #include <media/v4l2-mediabus.h>
> > 
> >  struct fwnode_handle;
> > +struct v4l2_async_notifier;
> > +struct v4l2_async_subdev;
> > 
> >  #define V4L2_FWNODE_CSI2_MAX_DATA_LANES	4
> > 
> > @@ -201,4 +203,41 @@ int v4l2_fwnode_parse_link(struct fwnode_handle
> > *fwnode, */
> >  void v4l2_fwnode_put_link(struct v4l2_fwnode_link *link);
> > 
> > +/**
> > + * v4l2_async_notifier_parse_fwnode_endpoints - Parse V4L2 fwnode endpoints
> > in a
> > + *						device node
> > + * @dev: @struct device pointer
> 
> Similarly to my previous comment (and my comments to v3), you should tell 
> which device the function expects.

Will fix for the next version.

> 
> > + * @notifier: pointer to &struct v4l2_async_notifier
> > + * @asd_struct_size: size of the driver's async sub-device struct,
> > including
> > + *		     sizeof(struct v4l2_async_subdev). The &struct
> > + *		     v4l2_async_subdev shall be the first member of
> > + *		     the driver's async sub-device struct, i.e. both
> > + *		     begin at the same memory address.
> 
> Should this be documented in the kerneldoc of the v4l2_async_subdev structure 
> ?

Yes, I'll add that. It won't hurt to make it a requirement even if the
helper functions weren't used.

> 
> > + * @parse_single: driver's callback function called on each V4L2 fwnode
> > endpoint
> > + *
> > + * Allocate async sub-device array and sub-devices for each fwnode
> > endpoint,
> > + * parse the related fwnode endpoints and finally call driver's callback
> > + * function to that V4L2 fwnode endpoint.
> 
> I'd document this from the notifier point of view.
> 
> "Parse the fwnode endpoints of the @dev device and populate the async sub-
> devices array of the notifier. The @parse_endpoint callback function is called 
> for each endpoint with the corresponding async sub-device pointer to let the 
> caller initialize the driver-specific part of the async sub-device structure."

Works for me.

> 
> > + * The function may not be called on a registered notifier.
> 
> You should mention that the function may be called multiple times on an 
> unregistered notifier.

There's no point in calling it more than once as the endpoints wouldn't end
up being different from the previous time. Actually it'd make sense to
document this.

> 
> "The function can be called multiple times to populate the same notifier from 
> endpoints of different @dev devices before registering the notifier. It can't 
> be called anymore once the notifier has been registered."

I don't think there's really a use case for calling this for more than one
device, is there?

> 
> > + *
> > + * Once the user has called this function, the resources released by it
> > need to
> > + * be released by callin v4l2_async_notifier_release after the notifier has
> > been
> > + * unregistered and the sub-devices are no longer in use.
> 
> "Any notifier populated using this function must be released with a call to 
> v4l2_async_notifier_release() after it has been unregistered and the async 
> sub-devices are no longer in use."

Agreed.

> 
> > + *
> > + * A driver supporting fwnode (currently Devicetree and ACPI) should call
> > this
> > + * function as part of its probe function before it registers the notifier.
> > + *
> > + * Return: %0 on success, including when no async sub-devices are found
> > + *	   %-ENOMEM if memory allocation failed
> > + *	   %-EINVAL if graph or endpoint parsing failed
> > + *	   Other error codes as returned by @parse_single
> > + */
> > +int v4l2_async_notifier_parse_fwnode_endpoints(
> > +	struct device *dev, struct v4l2_async_notifier *notifier,
> > +	size_t asd_struct_size,
> > +	int (*parse_single)(struct device *dev,
> > +			    struct v4l2_fwnode_endpoint *vep,
> > +			    struct v4l2_async_subdev *asd));
> > +
> >  #endif /* _V4L2_FWNODE_H */
> 
> 

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
