Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56587 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751660AbbCPXMr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2015 19:12:47 -0400
Date: Tue, 17 Mar 2015 01:12:40 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	tony@atomide.com, sre@kernel.org, pali.rohar@gmail.com
Subject: Re: [PATCH 13/15] v4l: of: Read lane-polarity endpoint property
Message-ID: <20150316231240.GE11954@valkosipuli.retiisi.org.uk>
References: <1426465570-30295-1-git-send-email-sakari.ailus@iki.fi>
 <1426465570-30295-14-git-send-email-sakari.ailus@iki.fi>
 <2045850.eQKZGjon2a@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2045850.eQKZGjon2a@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Mon, Mar 16, 2015 at 11:05:38AM +0200, Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thank you for the patch.
> 
> On Monday 16 March 2015 02:26:08 Sakari Ailus wrote:
> > Add lane_polarity field to struct v4l2_of_bus_mipi_csi2 and write the
> > contents of the lane polarity property to it. The field tells the polarity
> > of the physical lanes starting from the first one. Any unused lanes are
> > ignored, i.e. only the polarity of the used lanes is specified.
> > 
> > Also rework reading the "data-lanes" property a little.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > ---
> >  drivers/media/v4l2-core/v4l2-of.c |   41 ++++++++++++++++++++++++++--------
> >  include/media/v4l2-of.h           |    3 +++
> >  2 files changed, 35 insertions(+), 9 deletions(-)
> > 
> > diff --git a/drivers/media/v4l2-core/v4l2-of.c
> > b/drivers/media/v4l2-core/v4l2-of.c index b4ed9a9..e44cc15 100644
> > --- a/drivers/media/v4l2-core/v4l2-of.c
> > +++ b/drivers/media/v4l2-core/v4l2-of.c
> > @@ -19,11 +19,10 @@
> > 
> >  #include <media/v4l2-of.h>
> > 
> > -static void v4l2_of_parse_csi_bus(const struct device_node *node,
> > -				  struct v4l2_of_endpoint *endpoint)
> > +static int v4l2_of_parse_csi_bus(const struct device_node *node,
> > +				 struct v4l2_of_endpoint *endpoint)
> >  {
> >  	struct v4l2_of_bus_mipi_csi2 *bus = &endpoint->bus.mipi_csi2;
> > -	u32 data_lanes[ARRAY_SIZE(bus->data_lanes)];
> >  	struct property *prop;
> >  	bool have_clk_lane = false;
> >  	unsigned int flags = 0;
> > @@ -32,16 +31,34 @@ static void v4l2_of_parse_csi_bus(const struct
> > device_node *node, prop = of_find_property(node, "data-lanes", NULL);
> >  	if (prop) {
> >  		const __be32 *lane = NULL;
> > -		int i;
> > +		unsigned int i;
> > 
> > -		for (i = 0; i < ARRAY_SIZE(data_lanes); i++) {
> > -			lane = of_prop_next_u32(prop, lane, &data_lanes[i]);
> > +		for (i = 0; i < ARRAY_SIZE(bus->data_lanes); i++) {
> > +			lane = of_prop_next_u32(prop, lane, &v);
> >  			if (!lane)
> >  				break;
> > +			bus->data_lanes[i] = v;
> >  		}
> >  		bus->num_data_lanes = i;
> > -		while (i--)
> > -			bus->data_lanes[i] = data_lanes[i];
> > +	}
> > +
> > +	prop = of_find_property(node, "lane-polarity", NULL);
> > +	if (prop) {
> > +		const __be32 *polarity = NULL;
> > +		unsigned int i;
> > +
> > +		for (i = 0; i < ARRAY_SIZE(bus->lane_polarity); i++) {
> > +			polarity = of_prop_next_u32(prop, polarity, &v);
> > +			if (!polarity)
> > +				break;
> > +			bus->lane_polarity[i] = v;
> > +		}
> > +
> > +		if (i < 1 + bus->num_data_lanes /* clock + data */) {
> > +			pr_warn("bad size of lane-polarity array in node %s, was %u, 
> should be
> > %u\n",
> 
> How about
> 
> 		pr_warn("%s: too few lane-polarity entries (need %u, got %u)\n",
> 			node->full_name, 1 + bus->num_data_lanes, i);

Fixed.

> > +				node->full_name, i, 1 + bus->num_data_lanes);
> > +			return -EINVAL;
> > +		}
> >  	}
> > 
> >  	if (!of_property_read_u32(node, "clock-lanes", &v)) {
> > @@ -56,6 +73,8 @@ static void v4l2_of_parse_csi_bus(const struct device_node
> > *node,
> > 
> >  	bus->flags = flags;
> >  	endpoint->bus_type = V4L2_MBUS_CSI2;
> > +
> > +	return 0;
> >  }
> > 
> >  static void v4l2_of_parse_parallel_bus(const struct device_node *node,
> > @@ -127,11 +146,15 @@ static void v4l2_of_parse_parallel_bus(const struct
> > device_node *node, int v4l2_of_parse_endpoint(const struct device_node
> > *node,
> >  			   struct v4l2_of_endpoint *endpoint)
> >  {
> > +	int rval;
> > +
> >  	of_graph_parse_endpoint(node, &endpoint->base);
> >  	endpoint->bus_type = 0;
> >  	memset(&endpoint->bus, 0, sizeof(endpoint->bus));
> > 
> > -	v4l2_of_parse_csi_bus(node, endpoint);
> > +	rval = v4l2_of_parse_csi_bus(node, endpoint);
> > +	if (rval)
> > +		return rval;
> >  	/*
> >  	 * Parse the parallel video bus properties only if none
> >  	 * of the MIPI CSI-2 specific properties were found.
> > diff --git a/include/media/v4l2-of.h b/include/media/v4l2-of.h
> > index 70fa7b7..a70eb52 100644
> > --- a/include/media/v4l2-of.h
> > +++ b/include/media/v4l2-of.h
> > @@ -29,12 +29,15 @@ struct device_node;
> >   * @data_lanes: an array of physical data lane indexes
> >   * @clock_lane: physical lane index of the clock lane
> >   * @num_data_lanes: number of data lanes
> > + * @lane_polarity: polarity of the lanes. The order is the same of
> > + *		   the physical lanes.
> >   */
> >  struct v4l2_of_bus_mipi_csi2 {
> >  	unsigned int flags;
> >  	unsigned char data_lanes[4];
> >  	unsigned char clock_lane;
> >  	unsigned short num_data_lanes;
> > +	bool lane_polarity[5];
> 
> A bit of bike-shedding here, should this be lane_polarities ? And, thinking 
> about it, should the DT property be renamed to "lane-polarities" as well ? 
> This would match "data-lanes".

Good idea. I'll take that into account before reposting the sets.

-- 
Cheers,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
