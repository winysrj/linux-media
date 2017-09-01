Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:33546 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751870AbdIALS6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Sep 2017 07:18:58 -0400
Subject: Re: [PATCH v6.1 4/5] v4l: fwnode: Support generic parsing of graph
 endpoints in a device
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
References: <20170830114946.17743-5-sakari.ailus@linux.intel.com>
 <20170830124530.26176-1-sakari.ailus@linux.intel.com>
Cc: niklas.soderlund@ragnatech.se, robh@kernel.org,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <b707062c-d8df-5fb5-8099-8460f0dd7d5d@xs4all.nl>
Date: Fri, 1 Sep 2017 13:18:55 +0200
MIME-Version: 1.0
In-Reply-To: <20170830124530.26176-1-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 30/08/17 14:45, Sakari Ailus wrote:
> The current practice is that drivers iterate over their endpoints and
> parse each endpoint separately. This is very similar in a number of
> drivers, implement a generic function for the job. Driver specific matters
> can be taken into account in the driver specific callback.
> 
> Convert the omap3isp as an example.

It would be much easier to review if the omap3isp conversion was done in a
separate patch. Ditto for the rcar conversion, and I prefer to have both
at the end of the patch series, after the core code patches.

> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
> since v6:
> 
> - Set notifier->subdevs NULL and notifier->num_subdevs 0 in
>   v4l2_async_notifier_release().
> 
>  drivers/media/platform/omap3isp/isp.c | 115 ++++++++++-------------------
>  drivers/media/platform/omap3isp/isp.h |   5 +-
>  drivers/media/v4l2-core/v4l2-async.c  |  16 +++++
>  drivers/media/v4l2-core/v4l2-fwnode.c | 131 ++++++++++++++++++++++++++++++++++
>  include/media/v4l2-async.h            |  24 ++++++-
>  include/media/v4l2-fwnode.h           |  48 +++++++++++++
>  6 files changed, 254 insertions(+), 85 deletions(-)
> 
> diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
> index 1a428fe9f070..a546cf774d40 100644
> --- a/drivers/media/platform/omap3isp/isp.c
> +++ b/drivers/media/platform/omap3isp/isp.c
> @@ -2001,6 +2001,7 @@ static int isp_remove(struct platform_device *pdev)
>  	__omap3isp_put(isp, false);
>  
>  	media_entity_enum_cleanup(&isp->crashed);
> +	v4l2_async_notifier_release(&isp->notifier);
>  
>  	return 0;
>  }
> @@ -2011,44 +2012,41 @@ enum isp_of_phy {
>  	ISP_OF_PHY_CSIPHY2,
>  };
>  
> -static int isp_fwnode_parse(struct device *dev, struct fwnode_handle *fwnode,
> -			    struct isp_async_subdev *isd)
> +static int isp_fwnode_parse(struct device *dev,
> +			    struct v4l2_fwnode_endpoint *vep,
> +			    struct v4l2_async_subdev *asd)
>  {
> +	struct isp_async_subdev *isd =
> +		container_of(asd, struct isp_async_subdev, asd);
>  	struct isp_bus_cfg *buscfg = &isd->bus;
> -	struct v4l2_fwnode_endpoint vep;
> -	unsigned int i;
> -	int ret;
>  	bool csi1 = false;
> -
> -	ret = v4l2_fwnode_endpoint_parse(fwnode, &vep);
> -	if (ret)
> -		return ret;
> +	unsigned int i;
>  
>  	dev_dbg(dev, "parsing endpoint %pOF, interface %u\n",
> -		to_of_node(fwnode), vep.base.port);
> +		to_of_node(vep->base.local_fwnode), vep->base.port);
>  
> -	switch (vep.base.port) {
> +	switch (vep->base.port) {
>  	case ISP_OF_PHY_PARALLEL:
>  		buscfg->interface = ISP_INTERFACE_PARALLEL;
>  		buscfg->bus.parallel.data_lane_shift =
> -			vep.bus.parallel.data_shift;
> +			vep->bus.parallel.data_shift;
>  		buscfg->bus.parallel.clk_pol =
> -			!!(vep.bus.parallel.flags
> +			!!(vep->bus.parallel.flags
>  			   & V4L2_MBUS_PCLK_SAMPLE_FALLING);
>  		buscfg->bus.parallel.hs_pol =
> -			!!(vep.bus.parallel.flags & V4L2_MBUS_VSYNC_ACTIVE_LOW);
> +			!!(vep->bus.parallel.flags & V4L2_MBUS_VSYNC_ACTIVE_LOW);
>  		buscfg->bus.parallel.vs_pol =
> -			!!(vep.bus.parallel.flags & V4L2_MBUS_HSYNC_ACTIVE_LOW);
> +			!!(vep->bus.parallel.flags & V4L2_MBUS_HSYNC_ACTIVE_LOW);
>  		buscfg->bus.parallel.fld_pol =
> -			!!(vep.bus.parallel.flags & V4L2_MBUS_FIELD_EVEN_LOW);
> +			!!(vep->bus.parallel.flags & V4L2_MBUS_FIELD_EVEN_LOW);
>  		buscfg->bus.parallel.data_pol =
> -			!!(vep.bus.parallel.flags & V4L2_MBUS_DATA_ACTIVE_LOW);
> -		buscfg->bus.parallel.bt656 = vep.bus_type == V4L2_MBUS_BT656;
> +			!!(vep->bus.parallel.flags & V4L2_MBUS_DATA_ACTIVE_LOW);
> +		buscfg->bus.parallel.bt656 = vep->bus_type == V4L2_MBUS_BT656;
>  		break;
>  
>  	case ISP_OF_PHY_CSIPHY1:
>  	case ISP_OF_PHY_CSIPHY2:
> -		switch (vep.bus_type) {
> +		switch (vep->bus_type) {
>  		case V4L2_MBUS_CCP2:
>  		case V4L2_MBUS_CSI1:
>  			dev_dbg(dev, "CSI-1/CCP-2 configuration\n");
> @@ -2060,11 +2058,11 @@ static int isp_fwnode_parse(struct device *dev, struct fwnode_handle *fwnode,
>  			break;
>  		default:
>  			dev_err(dev, "unsupported bus type %u\n",
> -				vep.bus_type);
> +				vep->bus_type);
>  			return -EINVAL;
>  		}
>  
> -		switch (vep.base.port) {
> +		switch (vep->base.port) {
>  		case ISP_OF_PHY_CSIPHY1:
>  			if (csi1)
>  				buscfg->interface = ISP_INTERFACE_CCP2B_PHY1;
> @@ -2080,47 +2078,47 @@ static int isp_fwnode_parse(struct device *dev, struct fwnode_handle *fwnode,
>  		}
>  		if (csi1) {
>  			buscfg->bus.ccp2.lanecfg.clk.pos =
> -				vep.bus.mipi_csi1.clock_lane;
> +				vep->bus.mipi_csi1.clock_lane;
>  			buscfg->bus.ccp2.lanecfg.clk.pol =
> -				vep.bus.mipi_csi1.lane_polarity[0];
> +				vep->bus.mipi_csi1.lane_polarity[0];
>  			dev_dbg(dev, "clock lane polarity %u, pos %u\n",
>  				buscfg->bus.ccp2.lanecfg.clk.pol,
>  				buscfg->bus.ccp2.lanecfg.clk.pos);
>  
>  			buscfg->bus.ccp2.lanecfg.data[0].pos =
> -				vep.bus.mipi_csi1.data_lane;
> +				vep->bus.mipi_csi1.data_lane;
>  			buscfg->bus.ccp2.lanecfg.data[0].pol =
> -				vep.bus.mipi_csi1.lane_polarity[1];
> +				vep->bus.mipi_csi1.lane_polarity[1];
>  
>  			dev_dbg(dev, "data lane polarity %u, pos %u\n",
>  				buscfg->bus.ccp2.lanecfg.data[0].pol,
>  				buscfg->bus.ccp2.lanecfg.data[0].pos);
>  
>  			buscfg->bus.ccp2.strobe_clk_pol =
> -				vep.bus.mipi_csi1.clock_inv;
> -			buscfg->bus.ccp2.phy_layer = vep.bus.mipi_csi1.strobe;
> +				vep->bus.mipi_csi1.clock_inv;
> +			buscfg->bus.ccp2.phy_layer = vep->bus.mipi_csi1.strobe;
>  			buscfg->bus.ccp2.ccp2_mode =
> -				vep.bus_type == V4L2_MBUS_CCP2;
> +				vep->bus_type == V4L2_MBUS_CCP2;
>  			buscfg->bus.ccp2.vp_clk_pol = 1;
>  
>  			buscfg->bus.ccp2.crc = 1;
>  		} else {
>  			buscfg->bus.csi2.lanecfg.clk.pos =
> -				vep.bus.mipi_csi2.clock_lane;
> +				vep->bus.mipi_csi2.clock_lane;
>  			buscfg->bus.csi2.lanecfg.clk.pol =
> -				vep.bus.mipi_csi2.lane_polarities[0];
> +				vep->bus.mipi_csi2.lane_polarities[0];
>  			dev_dbg(dev, "clock lane polarity %u, pos %u\n",
>  				buscfg->bus.csi2.lanecfg.clk.pol,
>  				buscfg->bus.csi2.lanecfg.clk.pos);
>  
>  			buscfg->bus.csi2.num_data_lanes =
> -				vep.bus.mipi_csi2.num_data_lanes;
> +				vep->bus.mipi_csi2.num_data_lanes;
>  
>  			for (i = 0; i < buscfg->bus.csi2.num_data_lanes; i++) {
>  				buscfg->bus.csi2.lanecfg.data[i].pos =
> -					vep.bus.mipi_csi2.data_lanes[i];
> +					vep->bus.mipi_csi2.data_lanes[i];
>  				buscfg->bus.csi2.lanecfg.data[i].pol =
> -					vep.bus.mipi_csi2.lane_polarities[i + 1];
> +					vep->bus.mipi_csi2.lane_polarities[i + 1];
>  				dev_dbg(dev,
>  					"data lane %u polarity %u, pos %u\n", i,
>  					buscfg->bus.csi2.lanecfg.data[i].pol,
> @@ -2137,57 +2135,13 @@ static int isp_fwnode_parse(struct device *dev, struct fwnode_handle *fwnode,
>  
>  	default:
>  		dev_warn(dev, "%pOF: invalid interface %u\n",
> -			 to_of_node(fwnode), vep.base.port);
> +			 to_of_node(vep->base.local_fwnode), vep->base.port);
>  		return -EINVAL;
>  	}
>  
>  	return 0;
>  }
>  
> -static int isp_fwnodes_parse(struct device *dev,
> -			     struct v4l2_async_notifier *notifier)
> -{
> -	struct fwnode_handle *fwnode = NULL;
> -
> -	notifier->subdevs = devm_kcalloc(
> -		dev, ISP_MAX_SUBDEVS, sizeof(*notifier->subdevs), GFP_KERNEL);
> -	if (!notifier->subdevs)
> -		return -ENOMEM;
> -
> -	while (notifier->num_subdevs < ISP_MAX_SUBDEVS &&
> -	       (fwnode = fwnode_graph_get_next_endpoint(
> -			of_fwnode_handle(dev->of_node), fwnode))) {
> -		struct isp_async_subdev *isd;
> -
> -		isd = devm_kzalloc(dev, sizeof(*isd), GFP_KERNEL);
> -		if (!isd)
> -			goto error;
> -
> -		if (isp_fwnode_parse(dev, fwnode, isd)) {
> -			devm_kfree(dev, isd);
> -			continue;
> -		}
> -
> -		notifier->subdevs[notifier->num_subdevs] = &isd->asd;
> -
> -		isd->asd.match.fwnode.fwnode =
> -			fwnode_graph_get_remote_port_parent(fwnode);
> -		if (!isd->asd.match.fwnode.fwnode) {
> -			dev_warn(dev, "bad remote port parent\n");
> -			goto error;
> -		}
> -
> -		isd->asd.match_type = V4L2_ASYNC_MATCH_FWNODE;
> -		notifier->num_subdevs++;
> -	}
> -
> -	return notifier->num_subdevs;
> -
> -error:
> -	fwnode_handle_put(fwnode);
> -	return -EINVAL;
> -}
> -
>  static int isp_subdev_notifier_complete(struct v4l2_async_notifier *async)
>  {
>  	struct isp_device *isp = container_of(async, struct isp_device,
> @@ -2256,7 +2210,9 @@ static int isp_probe(struct platform_device *pdev)
>  	if (ret)
>  		return ret;
>  
> -	ret = isp_fwnodes_parse(&pdev->dev, &isp->notifier);
> +	ret = v4l2_async_notifier_parse_fwnode_endpoints(
> +		&pdev->dev, &isp->notifier, sizeof(struct isp_async_subdev),
> +		isp_fwnode_parse);
>  	if (ret < 0)
>  		return ret;
>  
> @@ -2407,6 +2363,7 @@ static int isp_probe(struct platform_device *pdev)
>  	__omap3isp_put(isp, false);
>  error:
>  	mutex_destroy(&isp->isp_mutex);
> +	v4l2_async_notifier_release(&isp->notifier);
>  
>  	return ret;
>  }
> diff --git a/drivers/media/platform/omap3isp/isp.h b/drivers/media/platform/omap3isp/isp.h
> index e528df6efc09..8b9043db94b3 100644
> --- a/drivers/media/platform/omap3isp/isp.h
> +++ b/drivers/media/platform/omap3isp/isp.h
> @@ -220,14 +220,11 @@ struct isp_device {
>  
>  	unsigned int sbl_resources;
>  	unsigned int subclk_resources;
> -
> -#define ISP_MAX_SUBDEVS		8
> -	struct v4l2_subdev *subdevs[ISP_MAX_SUBDEVS];
>  };
>  
>  struct isp_async_subdev {
> -	struct isp_bus_cfg bus;
>  	struct v4l2_async_subdev asd;
> +	struct isp_bus_cfg bus;
>  };
>  
>  #define v4l2_subdev_to_bus_cfg(sd) \
> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> index 851f128eba22..6740a241d4a1 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -22,6 +22,7 @@
>  
>  #include <media/v4l2-async.h>
>  #include <media/v4l2-device.h>
> +#include <media/v4l2-fwnode.h>
>  #include <media/v4l2-subdev.h>
>  
>  static bool match_i2c(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
> @@ -278,6 +279,21 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
>  }
>  EXPORT_SYMBOL(v4l2_async_notifier_unregister);
>  
> +void v4l2_async_notifier_release(struct v4l2_async_notifier *notifier)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < notifier->num_subdevs; i++)
> +		kfree(notifier->subdevs[i]);
> +
> +	notifier->max_subdevs = 0;
> +	notifier->num_subdevs = 0;
> +
> +	kvfree(notifier->subdevs);
> +	notifier->subdevs = NULL;
> +}
> +EXPORT_SYMBOL_GPL(v4l2_async_notifier_release);
> +
>  int v4l2_async_register_subdev(struct v4l2_subdev *sd)
>  {
>  	struct v4l2_async_notifier *notifier;
> diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
> index 706f9e7b90f1..2496d76eef4b 100644
> --- a/drivers/media/v4l2-core/v4l2-fwnode.c
> +++ b/drivers/media/v4l2-core/v4l2-fwnode.c
> @@ -19,6 +19,7 @@
>   */
>  #include <linux/acpi.h>
>  #include <linux/kernel.h>
> +#include <linux/mm.h>
>  #include <linux/module.h>
>  #include <linux/of.h>
>  #include <linux/property.h>
> @@ -26,6 +27,7 @@
>  #include <linux/string.h>
>  #include <linux/types.h>
>  
> +#include <media/v4l2-async.h>
>  #include <media/v4l2-fwnode.h>
>  
>  enum v4l2_fwnode_bus_type {
> @@ -313,6 +315,135 @@ void v4l2_fwnode_put_link(struct v4l2_fwnode_link *link)
>  }
>  EXPORT_SYMBOL_GPL(v4l2_fwnode_put_link);
>  
> +static int v4l2_async_notifier_realloc(struct v4l2_async_notifier *notifier,
> +				       unsigned int max_subdevs)
> +{
> +	struct v4l2_async_subdev **subdevs;
> +
> +	if (max_subdevs <= notifier->max_subdevs)
> +		return 0;

Should probably be a WARN_ON. Or add a comment saying that this should
never happen.

> +
> +	subdevs = kvmalloc_array(
> +		max_subdevs, sizeof(*notifier->subdevs),
> +		GFP_KERNEL | __GFP_ZERO);
> +	if (!subdevs)
> +		return -ENOMEM;
> +
> +	if (notifier->subdevs) {
> +		memcpy(subdevs, notifier->subdevs,
> +		       sizeof(*subdevs) * notifier->num_subdevs);
> +
> +		kvfree(notifier->subdevs);
> +	}
> +
> +	notifier->subdevs = subdevs;
> +	notifier->max_subdevs = max_subdevs;
> +
> +	return 0;
> +}
> +
> +static int v4l2_async_notifier_fwnode_parse_endpoint(
> +	struct device *dev, struct v4l2_async_notifier *notifier,
> +	struct fwnode_handle *endpoint, unsigned int asd_struct_size,
> +	int (*parse_single)(struct device *dev,
> +			    struct v4l2_fwnode_endpoint *vep,
> +			    struct v4l2_async_subdev *asd))
> +{
> +	struct v4l2_async_subdev *asd;
> +	struct v4l2_fwnode_endpoint *vep;
> +	int ret = 0;
> +
> +	asd = kzalloc(asd_struct_size, GFP_KERNEL);
> +	if (!asd)
> +		return -ENOMEM;
> +
> +	asd->match.fwnode.fwnode =
> +		fwnode_graph_get_remote_port_parent(endpoint);
> +	if (!asd->match.fwnode.fwnode) {
> +		dev_warn(dev, "bad remote port parent\n");
> +		ret = -EINVAL;
> +		goto out_err;
> +	}
> +
> +	/* Ignore endpoints the parsing of which failed. */
> +	vep = v4l2_fwnode_endpoint_alloc_parse(endpoint);
> +	if (IS_ERR(vep)) {
> +		ret = PTR_ERR(vep);
> +		dev_warn(dev, "unable to parse V4L2 fwnode endpoint (%d)\n",
> +			 ret);
> +		goto out_err;
> +	}
> +
> +	ret = parse_single(dev, vep, asd);
> +	v4l2_fwnode_endpoint_free(vep);
> +	if (ret) {
> +		dev_warn(dev, "driver could not parse endpoint (%d)\n", ret);
> +		goto out_err;
> +	}
> +
> +	asd->match_type = V4L2_ASYNC_MATCH_FWNODE;
> +	notifier->subdevs[notifier->num_subdevs] = asd;
> +	notifier->num_subdevs++;
> +
> +	return 0;
> +
> +out_err:
> +	fwnode_handle_put(asd->match.fwnode.fwnode);

Just checking: the fwnode_handle_put argument can safely be NULL?

> +	kfree(asd);
> +
> +	return ret;
> +}
> +
> +int v4l2_async_notifier_parse_fwnode_endpoints(
> +	struct device *dev, struct v4l2_async_notifier *notifier,
> +	size_t asd_struct_size,
> +	int (*parse_single)(struct device *dev,
> +			    struct v4l2_fwnode_endpoint *vep,
> +			    struct v4l2_async_subdev *asd))
> +{
> +	struct fwnode_handle *fwnode = NULL;
> +	unsigned int max_subdevs = notifier->max_subdevs;

I thought the notifier was supposed to be zeroed?

> +	int ret;
> +
> +	if (asd_struct_size < sizeof(struct v4l2_async_subdev) ||
> +	    notifier->v4l2_dev)

This could use a comment why you check for notifier->v4l2_dev. That's not
obvious.

> +		return -EINVAL;

Since we have the requirement that the notifier should be zeroed,
why not do that here?

> +
> +	for (fwnode = NULL; (fwnode = fwnode_graph_get_next_endpoint(
> +				     dev_fwnode(dev), fwnode)); )
> +		if (fwnode_device_is_available(
> +			    fwnode_graph_get_port_parent(fwnode)))
> +			max_subdevs++;
> +
> +	/* No subdevs to add? Return here. */
> +	if (max_subdevs == notifier->max_subdevs)
> +		return 0;
> +
> +	ret = v4l2_async_notifier_realloc(notifier, max_subdevs);
> +	if (ret)
> +		return ret;

I think this is confusing. There is nothing to realloc here. Only in the
next patch (5/5) do you add support for recursively walking the graph and
adding more subdevs.

I would just call kvmalloc_array here.

> +
> +	for (fwnode = NULL; (fwnode = fwnode_graph_get_next_endpoint(
> +				     dev_fwnode(dev), fwnode)); ) {
> +		if (!fwnode_device_is_available(
> +			    fwnode_graph_get_port_parent(fwnode)))
> +			continue;
> +
> +		if (WARN_ON(notifier->num_subdevs >= notifier->max_subdevs))
> +			break;
> +
> +		ret = v4l2_async_notifier_fwnode_parse_endpoint(
> +			dev, notifier, fwnode, asd_struct_size, parse_single);
> +		if (ret < 0)
> +			break;
> +	}
> +
> +	fwnode_handle_put(fwnode);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(v4l2_async_notifier_parse_fwnode_endpoints);
> +
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Sakari Ailus <sakari.ailus@linux.intel.com>");
>  MODULE_AUTHOR("Sylwester Nawrocki <s.nawrocki@samsung.com>");
> diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
> index c69d8c8a66d0..cf13c7311a1c 100644
> --- a/include/media/v4l2-async.h
> +++ b/include/media/v4l2-async.h
> @@ -18,7 +18,6 @@ struct device;
>  struct device_node;
>  struct v4l2_device;
>  struct v4l2_subdev;
> -struct v4l2_async_notifier;
>  
>  /* A random max subdevice number, used to allocate an array on stack */
>  #define V4L2_MAX_SUBDEVS 128U
> @@ -50,6 +49,10 @@ enum v4l2_async_match_type {
>   * @match:	union of per-bus type matching data sets
>   * @list:	used to link struct v4l2_async_subdev objects, waiting to be
>   *		probed, to a notifier->waiting list
> + *
> + * When the struct is used as the first member of a driver specific

Just replace "the first member" by "part"...

> + * struct, the driver specific struct shall contain the @struct
> + * v4l2_async_subdev as its first member.

...since you mention in the second part that it has to be the first member.
No need to mention that twice.

>   */
>  struct v4l2_async_subdev {
>  	enum v4l2_async_match_type match_type;
> @@ -78,7 +81,8 @@ struct v4l2_async_subdev {
>  /**
>   * struct v4l2_async_notifier - v4l2_device notifier data
>   *
> - * @num_subdevs: number of subdevices
> + * @num_subdevs: number of subdevices used in subdevs array

in the

> + * @max_subdevs: number of subdevices allocated in subdevs array

in the

>   * @subdevs:	array of pointers to subdevice descriptors
>   * @v4l2_dev:	pointer to struct v4l2_device
>   * @waiting:	list of struct v4l2_async_subdev, waiting for their drivers
> @@ -90,6 +94,7 @@ struct v4l2_async_subdev {
>   */
>  struct v4l2_async_notifier {
>  	unsigned int num_subdevs;
> +	unsigned int max_subdevs;
>  	struct v4l2_async_subdev **subdevs;
>  	struct v4l2_device *v4l2_dev;
>  	struct list_head waiting;
> @@ -121,6 +126,21 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
>  void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier);
>  
>  /**
> + * v4l2_async_notifier_release - release notifier resources
> + * @notifier: the notifier the resources of which are to be released

Just say: @notifier: pointer to &struct v4l2_async_notifier

> + *
> + * Release memory resources related to a notifier, including the async

s/a/the/

> + * sub-devices allocated for the purposes of the notifier. The user is
> + * responsible for releasing the notifier's resources after calling
> + * @v4l2_async_notifier_parse_fwnode_endpoints.
> + *
> + * There is no harm from calling v4l2_async_notifier_release in other
> + * cases as long as its memory has been zeroed after it has been
> + * allocated.
> + */
> +void v4l2_async_notifier_release(struct v4l2_async_notifier *notifier);
> +
> +/**
>   * v4l2_async_register_subdev - registers a sub-device to the asynchronous
>   * 	subdevice framework
>   *
> diff --git a/include/media/v4l2-fwnode.h b/include/media/v4l2-fwnode.h
> index 68eb22ba571b..d063ab4ff67b 100644
> --- a/include/media/v4l2-fwnode.h
> +++ b/include/media/v4l2-fwnode.h
> @@ -25,6 +25,8 @@
>  #include <media/v4l2-mediabus.h>
>  
>  struct fwnode_handle;
> +struct v4l2_async_notifier;
> +struct v4l2_async_subdev;
>  
>  #define V4L2_FWNODE_CSI2_MAX_DATA_LANES	4
>  
> @@ -201,4 +203,50 @@ int v4l2_fwnode_parse_link(struct fwnode_handle *fwnode,
>   */
>  void v4l2_fwnode_put_link(struct v4l2_fwnode_link *link);
>  
> +/**
> + * v4l2_async_notifier_parse_fwnode_endpoints - Parse V4L2 fwnode endpoints in a
> + *						device node
> + * @dev: the device the endpoints of which are to be parsed
> + * @notifier: notifier for @dev
> + * @asd_struct_size: size of the driver's async sub-device struct, including
> + *		     sizeof(struct v4l2_async_subdev). The &struct
> + *		     v4l2_async_subdev shall be the first member of
> + *		     the driver's async sub-device struct, i.e. both
> + *		     begin at the same memory address.
> + * @parse_single: driver's callback function called on each V4L2 fwnode endpoint
> + *
> + * Parse the fwnode endpoints of the @dev device and populate the async sub-
> + * devices array of the notifier. The @parse_endpoint callback function is

parse_endpoint -> parse_single

(Actually, I like the name parse_endpoint better)

> + * called for each endpoint with the corresponding async sub-device pointer to
> + * let the caller initialize the driver-specific part of the async sub-device
> + * structure.
> + *
> + * The notifier memory shall be zeroed before this function is called on the
> + * notifier.
> + *
> + * This function may not be called on a registered notifier and may be called on
> + * a notifier only once. When using this function, the user may not access the
> + * notifier's subdevs array nor change notifier's num_subdevs field, these are
> + * reserved for the framework's internal use only.

Ditto for the max_subdevs field, I think.

> + *
> + * The @struct v4l2_fwnode_endpoint passed to the callback function
> + * @parse_single is released once the function is finished. If there is a need
> + * to retain that configuration, the user needs to allocate memory for it.
> + *
> + * Any notifier populated using this function must be released with a call to
> + * v4l2_async_notifier_release() after it has been unregistered and the async
> + * sub-devices are no longer in use.
> + *
> + * Return: %0 on success, including when no async sub-devices are found
> + *	   %-ENOMEM if memory allocation failed
> + *	   %-EINVAL if graph or endpoint parsing failed
> + *	   Other error codes as returned by @parse_single
> + */
> +int v4l2_async_notifier_parse_fwnode_endpoints(
> +	struct device *dev, struct v4l2_async_notifier *notifier,
> +	size_t asd_struct_size,
> +	int (*parse_single)(struct device *dev,
> +			    struct v4l2_fwnode_endpoint *vep,
> +			    struct v4l2_async_subdev *asd));
> +
>  #endif /* _V4L2_FWNODE_H */
> 

Regards,

	Hans
