Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51792 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752517AbdABHE7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 2 Jan 2017 02:04:59 -0500
Date: Mon, 2 Jan 2017 09:04:26 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: sre@kernel.org, pali.rohar@gmail.com, linux-media@vger.kernel.org,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] v4l: add support for CSI-1 bus
Message-ID: <20170102070425.GE3958@valkosipuli.retiisi.org.uk>
References: <20161228183116.GA13407@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161228183116.GA13407@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

On Wed, Dec 28, 2016 at 07:31:16PM +0100, Pavel Machek wrote:
> From: Sakari Ailus <sakari.ailus@iki.fi>
> 
> The function to parse CSI2 bus parameters was called
> v4l2_of_parse_csi_bus(), rename it as v4l2_of_parse_csi2_bus() in
> anticipation of CSI1/CCP2 support.
> 
> Obtain data bus type from bus-type property. Only try parsing bus
> specific properties in this case.
> 
> Add CSI1 and CCP2 bus type to enum v4l2_mbus_type. CCP2, or CSI-1, is
> an older single data lane serial bus.
> 
> Separate lane parsing from CSI-2 bus parameter parsing. The CSI-1 will
> need these as well, separate them into a different
> function. have_clk_lane and num_data_lanes arguments may be NULL; the
> CSI-1 bus will have no use for them.

The patch adds the CCP2 and CSI1 bus types to the enum, but it does not yet
add support for parsing either endpoints. How about separating the enum
changes to a different patch and keeping this one just for splitting lane
parsing from CSI-2 specific code?

> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> 
> diff --git a/drivers/media/v4l2-core/v4l2-of.c b/drivers/media/v4l2-core/v4l2-of.c
> index 93b3368..60bbc5f 100644
> --- a/drivers/media/v4l2-core/v4l2-of.c
> +++ b/drivers/media/v4l2-core/v4l2-of.c
> @@ -20,53 +20,88 @@
>  
>  #include <media/v4l2-of.h>
>  
> -static int v4l2_of_parse_csi_bus(const struct device_node *node,
> -				 struct v4l2_of_endpoint *endpoint)
> +enum v4l2_of_bus_type {
> +	V4L2_OF_BUS_TYPE_CSI2 = 0,
> +	V4L2_OF_BUS_TYPE_PARALLEL,
> +};
> +
> +static int v4l2_of_parse_lanes(const struct device_node *node,
> +			       unsigned char *clock_lane,
> +			       bool *have_clk_lane,
> +			       unsigned char *data_lanes,
> +			       bool *lane_polarities,
> +			       unsigned short *__num_data_lanes,
> +			       unsigned int max_data_lanes)
>  {
> -	struct v4l2_of_bus_mipi_csi2 *bus = &endpoint->bus.mipi_csi2;
>  	struct property *prop;
> -	bool have_clk_lane = false;
> -	unsigned int flags = 0;
> +	unsigned short num_data_lanes = 0;
>  	u32 v;
>  
>  	prop = of_find_property(node, "data-lanes", NULL);
>  	if (prop) {
>  		const __be32 *lane = NULL;
> -		unsigned int i;
>  
> -		for (i = 0; i < ARRAY_SIZE(bus->data_lanes); i++) {
> +		for (num_data_lanes = 0; num_data_lanes < max_data_lanes;
> +		     num_data_lanes++) {
>  			lane = of_prop_next_u32(prop, lane, &v);
>  			if (!lane)
>  				break;
> -			bus->data_lanes[i] = v;
> +			data_lanes[num_data_lanes] = v;
>  		}
> -		bus->num_data_lanes = i;
>  	}
> +	if (__num_data_lanes)
> +		*__num_data_lanes = num_data_lanes;
>  
>  	prop = of_find_property(node, "lane-polarities", NULL);
>  	if (prop) {
>  		const __be32 *polarity = NULL;
>  		unsigned int i;
>  
> -		for (i = 0; i < ARRAY_SIZE(bus->lane_polarities); i++) {
> +		for (i = 0; i < 1 + max_data_lanes; i++) {
>  			polarity = of_prop_next_u32(prop, polarity, &v);
>  			if (!polarity)
>  				break;
> -			bus->lane_polarities[i] = v;
> +			lane_polarities[i] = v;
>  		}
>  
> -		if (i < 1 + bus->num_data_lanes /* clock + data */) {
> +		if (i < 1 + num_data_lanes /* clock + data */) {
>  			pr_warn("%s: too few lane-polarities entries (need %u, got %u)\n",
> -				node->full_name, 1 + bus->num_data_lanes, i);
> +				node->full_name, 1 + num_data_lanes, i);
>  			return -EINVAL;
>  		}
>  	}
>  
> +	if (have_clk_lane)
> +		*have_clk_lane = false;
> +
>  	if (!of_property_read_u32(node, "clock-lanes", &v)) {
> -		bus->clock_lane = v;
> -		have_clk_lane = true;
> +		*clock_lane = v;
> +		if (have_clk_lane)
> +			*have_clk_lane = true;
>  	}
>  
> +	return 0;
> +}
> +
> +static int v4l2_of_parse_csi2_bus(const struct device_node *node,
> +				 struct v4l2_of_endpoint *endpoint)
> +{
> +	struct v4l2_of_bus_mipi_csi2 *bus = &endpoint->bus.mipi_csi2;
> +	bool have_clk_lane = false;
> +	unsigned int flags = 0;
> +	int rval;
> +	u32 v;
> +
> +	rval = v4l2_of_parse_lanes(node, &bus->clock_lane, &have_clk_lane,
> +				   bus->data_lanes, bus->lane_polarities,
> +				   &bus->num_data_lanes,
> +				   ARRAY_SIZE(bus->data_lanes));
> +	if (rval)
> +		return rval;
> +
> +	BUILD_BUG_ON(1 + ARRAY_SIZE(bus->data_lanes)
> +		       != ARRAY_SIZE(bus->lane_polarities));
> +
>  	if (of_get_property(node, "clock-noncontinuous", &v))
>  		flags |= V4L2_MBUS_CSI2_NONCONTINUOUS_CLOCK;
>  	else if (have_clk_lane || bus->num_data_lanes > 0)
> @@ -151,6 +186,7 @@ static void v4l2_of_parse_parallel_bus(const struct device_node *node,
>  int v4l2_of_parse_endpoint(const struct device_node *node,
>  			   struct v4l2_of_endpoint *endpoint)
>  {
> +	u32 bus_type;
>  	int rval;
>  
>  	of_graph_parse_endpoint(node, &endpoint->base);
> @@ -158,17 +194,33 @@ int v4l2_of_parse_endpoint(const struct device_node *node,
>  	memset(&endpoint->bus_type, 0, sizeof(*endpoint) -
>  	       offsetof(typeof(*endpoint), bus_type));
>  
> -	rval = v4l2_of_parse_csi_bus(node, endpoint);
> -	if (rval)
> -		return rval;
> -	/*
> -	 * Parse the parallel video bus properties only if none
> -	 * of the MIPI CSI-2 specific properties were found.
> -	 */
> -	if (endpoint->bus.mipi_csi2.flags == 0)
> -		v4l2_of_parse_parallel_bus(node, endpoint);
> +	rval = of_property_read_u32(node, "bus-type", &bus_type);
> +	if (rval < 0) {
> +		endpoint->bus_type = 0;
> +		rval = v4l2_of_parse_csi2_bus(node, endpoint);
> +		if (rval)
> +			return rval;
> +		/*
> +		 * Parse the parallel video bus properties only if none
> +		 * of the MIPI CSI-2 specific properties were found.
> +		 */
> +		if (endpoint->bus.mipi_csi2.flags == 0)
> +			v4l2_of_parse_parallel_bus(node, endpoint);
> +
> +		return 0;
> +	}
>  
> -	return 0;
> +	switch (bus_type) {
> +	case V4L2_OF_BUS_TYPE_CSI2:
> +		return v4l2_of_parse_csi2_bus(node, endpoint);
> +	case V4L2_OF_BUS_TYPE_PARALLEL:
> +		v4l2_of_parse_parallel_bus(node, endpoint);
> +		return 0;
> +	default:
> +		pr_warn("bad bus-type %u, device_node \"%s\"\n",
> +			bus_type, node->full_name);
> +		return -EINVAL;
> +	}
>  }
>  EXPORT_SYMBOL(v4l2_of_parse_endpoint);
>  
> diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-mediabus.h
> index 34cc99e..315c167 100644
> --- a/include/media/v4l2-mediabus.h
> +++ b/include/media/v4l2-mediabus.h
> @@ -69,11 +69,15 @@
>   * @V4L2_MBUS_PARALLEL:	parallel interface with hsync and vsync
>   * @V4L2_MBUS_BT656:	parallel interface with embedded synchronisation, can
>   *			also be used for BT.1120
> + * @V4L2_MBUS_CSI1:	MIPI CSI-1 serial interface
> + * @V4L2_MBUS_CCP2:	CCP2 (Compact Camera Port 2)
>   * @V4L2_MBUS_CSI2:	MIPI CSI-2 serial interface
>   */
>  enum v4l2_mbus_type {
>  	V4L2_MBUS_PARALLEL,
>  	V4L2_MBUS_BT656,
> +	V4L2_MBUS_CSI1,
> +	V4L2_MBUS_CCP2,
>  	V4L2_MBUS_CSI2,
>  };
>  
> 

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
