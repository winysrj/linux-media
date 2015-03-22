Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51020 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbbCVIqX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Mar 2015 04:46:23 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	tony@atomide.com, sre@kernel.org, pali.rohar@gmail.com
Subject: Re: [PATCH v1.1 13/15] v4l: of: Read lane-polarities endpoint property
Date: Sun, 22 Mar 2015 10:46:36 +0200
Message-ID: <3152371.Am9HJ1ktiF@avalon>
In-Reply-To: <1426889295-18182-1-git-send-email-sakari.ailus@iki.fi>
References: <1426465570-30295-14-git-send-email-sakari.ailus@iki.fi> <1426889295-18182-1-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.
On Saturday 21 March 2015 00:08:15 Sakari Ailus wrote:
> Add lane_polarities field to struct v4l2_of_bus_mipi_csi2 and write the
> contents of the lane-polarities property to it. The field tells the polarity
> of the physical lanes starting from the first one. Any unused lanes are
> ignored, i.e. only the polarity of the used lanes is specified.
> 
> Also rework reading the "data-lanes" property a little.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
> since v1:
> 
> - Rename lane-polarity property as lane-polarities.
> 
>  drivers/media/v4l2-core/v4l2-of.c |   41 ++++++++++++++++++++++++++--------
>  include/media/v4l2-of.h           |    3 +++
>  2 files changed, 35 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-of.c
> b/drivers/media/v4l2-core/v4l2-of.c index b4ed9a9..58e401f 100644
> --- a/drivers/media/v4l2-core/v4l2-of.c
> +++ b/drivers/media/v4l2-core/v4l2-of.c
> @@ -19,11 +19,10 @@
> 
>  #include <media/v4l2-of.h>
> 
> -static void v4l2_of_parse_csi_bus(const struct device_node *node,
> -				  struct v4l2_of_endpoint *endpoint)
> +static int v4l2_of_parse_csi_bus(const struct device_node *node,
> +				 struct v4l2_of_endpoint *endpoint)
>  {
>  	struct v4l2_of_bus_mipi_csi2 *bus = &endpoint->bus.mipi_csi2;
> -	u32 data_lanes[ARRAY_SIZE(bus->data_lanes)];
>  	struct property *prop;
>  	bool have_clk_lane = false;
>  	unsigned int flags = 0;
> @@ -32,16 +31,34 @@ static void v4l2_of_parse_csi_bus(const struct
> device_node *node, prop = of_find_property(node, "data-lanes", NULL);
>  	if (prop) {
>  		const __be32 *lane = NULL;
> -		int i;
> +		unsigned int i;
> 
> -		for (i = 0; i < ARRAY_SIZE(data_lanes); i++) {
> -			lane = of_prop_next_u32(prop, lane, &data_lanes[i]);
> +		for (i = 0; i < ARRAY_SIZE(bus->data_lanes); i++) {
> +			lane = of_prop_next_u32(prop, lane, &v);
>  			if (!lane)
>  				break;
> +			bus->data_lanes[i] = v;
>  		}
>  		bus->num_data_lanes = i;
> -		while (i--)
> -			bus->data_lanes[i] = data_lanes[i];
> +	}
> +
> +	prop = of_find_property(node, "lane-polarities", NULL);
> +	if (prop) {
> +		const __be32 *polarity = NULL;
> +		unsigned int i;
> +
> +		for (i = 0; i < ARRAY_SIZE(bus->lane_polarities); i++) {
> +			polarity = of_prop_next_u32(prop, polarity, &v);
> +			if (!polarity)
> +				break;
> +			bus->lane_polarities[i] = v;
> +		}
> +
> +		if (i < 1 + bus->num_data_lanes /* clock + data */) {
> +			pr_warn("%s: too few lane-polarities entries (need %u, got 
%u)\n",
> +				node->full_name, 1 + bus->num_data_lanes, i);
> +			return -EINVAL;
> +		}
>  	}
> 
>  	if (!of_property_read_u32(node, "clock-lanes", &v)) {
> @@ -56,6 +73,8 @@ static void v4l2_of_parse_csi_bus(const struct device_node
> *node,
> 
>  	bus->flags = flags;
>  	endpoint->bus_type = V4L2_MBUS_CSI2;
> +
> +	return 0;
>  }
> 
>  static void v4l2_of_parse_parallel_bus(const struct device_node *node,
> @@ -127,11 +146,15 @@ static void v4l2_of_parse_parallel_bus(const struct
> device_node *node, int v4l2_of_parse_endpoint(const struct device_node
> *node,
>  			   struct v4l2_of_endpoint *endpoint)
>  {
> +	int rval;
> +
>  	of_graph_parse_endpoint(node, &endpoint->base);
>  	endpoint->bus_type = 0;
>  	memset(&endpoint->bus, 0, sizeof(endpoint->bus));
> 
> -	v4l2_of_parse_csi_bus(node, endpoint);
> +	rval = v4l2_of_parse_csi_bus(node, endpoint);
> +	if (rval)
> +		return rval;
>  	/*
>  	 * Parse the parallel video bus properties only if none
>  	 * of the MIPI CSI-2 specific properties were found.
> diff --git a/include/media/v4l2-of.h b/include/media/v4l2-of.h
> index 70fa7b7..2de42c5 100644
> --- a/include/media/v4l2-of.h
> +++ b/include/media/v4l2-of.h
> @@ -29,12 +29,15 @@ struct device_node;
>   * @data_lanes: an array of physical data lane indexes
>   * @clock_lane: physical lane index of the clock lane
>   * @num_data_lanes: number of data lanes
> + * @lane_polarities: polarity of the lanes. The order is the same of
> + *		   the physical lanes.
>   */
>  struct v4l2_of_bus_mipi_csi2 {
>  	unsigned int flags;
>  	unsigned char data_lanes[4];
>  	unsigned char clock_lane;
>  	unsigned short num_data_lanes;
> +	bool lane_polarities[5];
>  };
> 
>  /**

-- 
Regards,

Laurent Pinchart

