Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54612 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755328AbdBNVUa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Feb 2017 16:20:30 -0500
Date: Tue, 14 Feb 2017 23:20:22 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: sre@kernel.org, pali.rohar@gmail.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        mchehab@kernel.org, ivo.g.dimitrov.75@gmail.com
Subject: Re: [RFC 03/13] v4l: split lane parsing code
Message-ID: <20170214212021.GK16975@valkosipuli.retiisi.org.uk>
References: <20170214133941.GA8469@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170214133941.GA8469@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

On Tue, Feb 14, 2017 at 02:39:41PM +0100, Pavel Machek wrote:
> From: Sakari Ailus <sakari.ailus@iki.fi>
> 
> The function to parse CSI2 bus parameters was called
> v4l2_of_parse_csi_bus(), rename it as v4l2_of_parse_csi2_bus() in
> anticipation of CSI1/CCP2 support.
> 
> Obtain data bus type from bus-type property. Only try parsing bus
> specific properties in this case.
> 
> Separate lane parsing from CSI-2 bus parameter parsing. The CSI-1 will
> need these as well, separate them into a different
> function. have_clk_lane and num_data_lanes arguments may be NULL; the
> CSI-1 bus will have no use for them.
> 
> Add support for parsing of CSI-1 and CCP2 bus related properties
> documented in video-interfaces.txt.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> ---
>  drivers/media/v4l2-core/v4l2-of.c | 141 ++++++++++++++++++++++++++++++--------
>  1 file changed, 114 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-of.c b/drivers/media/v4l2-core/v4l2-of.c
> index 4f59f44..9ffe2d3 100644
> --- a/drivers/media/v4l2-core/v4l2-of.c
> +++ b/drivers/media/v4l2-core/v4l2-of.c
> @@ -20,64 +20,101 @@
>  
>  #include <media/v4l2-of.h>
>  
> -static int v4l2_of_parse_csi_bus(const struct device_node *node,
> -				 struct v4l2_of_endpoint *endpoint)
> +enum v4l2_of_bus_type {
> +	V4L2_OF_BUS_TYPE_CSI2 = 0,
> +	V4L2_OF_BUS_TYPE_PARALLEL,
> +	V4L2_OF_BUS_TYPE_CSI1,
> +	V4L2_OF_BUS_TYPE_CCP2,
> +};

This no longer matches the bus-type values in DT bindings. How about:

V4L2_OF_BUS_TYPE_GUESS, /* CSI-2 D-PHY, parallel or Bt.656 */
V4L2_OF_BUS_TYPE_CSI2_CPHY,
V4L2_OF_BUS_TYPE_CSI1,
V4L2_OF_BUS_TYPE_CCP2

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
> -	unsigned int flags = 0, lanes_used = 0;
> +	unsigned int lanes_used = 0;
> +	short num_data_lanes = 0;
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
> +			data_lanes[num_data_lanes] = v;
>  
>  			if (lanes_used & BIT(v))
>  				pr_warn("%s: duplicated lane %u in data-lanes\n",
>  					node->full_name, v);
>  			lanes_used |= BIT(v);
> -
> -			bus->data_lanes[i] = v;
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
> +		*clock_lane = v;
> +		if (have_clk_lane)
> +			*have_clk_lane = true;
> +
>  		if (lanes_used & BIT(v))
>  			pr_warn("%s: duplicated lane %u in clock-lanes\n",
>  				node->full_name, v);
>  		lanes_used |= BIT(v);
> -
> -		bus->clock_lane = v;
> -		have_clk_lane = true;
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
> @@ -139,6 +176,35 @@ static void v4l2_of_parse_parallel_bus(const struct device_node *node,
>  
>  }
>  
> +void v4l2_of_parse_csi1_bus(const struct device_node *node,
> +			    struct v4l2_of_endpoint *endpoint,
> +			    enum v4l2_of_bus_type bus_type)
> +{
> +	struct v4l2_of_bus_mipi_csi1 *bus = &endpoint->bus.mipi_csi1;
> +	u32 v;
> +
> +	v4l2_of_parse_lanes(node, &bus->clock_lane, NULL,
> +			    &bus->data_lane, bus->lane_polarity,
> +			    NULL, 1);
> +
> +	if (!of_property_read_u32(node, "clock-inv", &v))
> +		bus->clock_inv = v;
> +
> +	if (!of_property_read_u32(node, "strobe", &v))
> +		bus->strobe = v;
> +
> +	if (!of_property_read_u32(node, "data-lane", &v))
> +		bus->data_lane = v;
> +
> +	if (!of_property_read_u32(node, "clock-lane", &v))
> +		bus->clock_lane = v;
> +
> +	if (bus_type == V4L2_OF_BUS_TYPE_CSI1)
> +		endpoint->bus_type = V4L2_MBUS_CSI1;
> +	else
> +		endpoint->bus_type = V4L2_MBUS_CCP2;
> +}
> +
>  /**
>   * v4l2_of_parse_endpoint() - parse all endpoint node properties
>   * @node: pointer to endpoint device_node
> @@ -162,6 +228,7 @@ static void v4l2_of_parse_parallel_bus(const struct device_node *node,
>  int v4l2_of_parse_endpoint(const struct device_node *node,
>  			   struct v4l2_of_endpoint *endpoint)
>  {
> +	u32 bus_type;

You could assign bus_type as 0 here...

>  	int rval;
>  
>  	of_graph_parse_endpoint(node, &endpoint->base);
> @@ -169,17 +236,37 @@ int v4l2_of_parse_endpoint(const struct device_node *node,
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

...and remove the check. What's below would be done in the _GUESS case.

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

And you can remove CSI2 and PARALLEL cases.

> +	case V4L2_OF_BUS_TYPE_CSI1:
> +	case V4L2_OF_BUS_TYPE_CCP2:
> +		v4l2_of_parse_csi1_bus(node, endpoint, bus_type);
> +		return 0;
> +	default:
> +		pr_warn("bad bus-type %u, device_node \"%s\"\n",
> +			bus_type, node->full_name);
> +		return -EINVAL;
> +	}
>  }
>  EXPORT_SYMBOL(v4l2_of_parse_endpoint);
>  

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
