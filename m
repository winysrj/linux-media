Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53603 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751053AbbCLWXb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2015 18:23:31 -0400
Date: Fri, 13 Mar 2015 00:23:27 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	pali.rohar@gmail.com
Subject: Re: [RFC 13/18] v4l: of: Read lane-polarity endpoint property
Message-ID: <20150312222327.GM11954@valkosipuli.retiisi.org.uk>
References: <1425764475-27691-1-git-send-email-sakari.ailus@iki.fi>
 <1425764475-27691-14-git-send-email-sakari.ailus@iki.fi>
 <5943571.XgR4Bv1QGx@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5943571.XgR4Bv1QGx@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Sun, Mar 08, 2015 at 01:49:26AM +0200, Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thank you for the patch.
> 
> On Saturday 07 March 2015 23:41:10 Sakari Ailus wrote:
> > Add lane_polarity field to struct v4l2_of_bus_mipi_csi2 and write the
> > contents of the lane polarity property to it. The field tells the polarity
> > of the physical lanes starting from the first one. Any unused lanes are
> > ignored, i.e. only the polarity of the used lanes is specified.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > ---
> >  drivers/media/v4l2-core/v4l2-of.c |   21 ++++++++++++++++-----
> >  include/media/v4l2-of.h           |    3 +++
> >  2 files changed, 19 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/media/v4l2-core/v4l2-of.c
> > b/drivers/media/v4l2-core/v4l2-of.c index b4ed9a9..a7a855e 100644
> > --- a/drivers/media/v4l2-core/v4l2-of.c
> > +++ b/drivers/media/v4l2-core/v4l2-of.c
> > @@ -23,7 +23,6 @@ static void v4l2_of_parse_csi_bus(const struct device_node
> > *node, struct v4l2_of_endpoint *endpoint)
> >  {
> >  	struct v4l2_of_bus_mipi_csi2 *bus = &endpoint->bus.mipi_csi2;
> > -	u32 data_lanes[ARRAY_SIZE(bus->data_lanes)];
> >  	struct property *prop;
> >  	bool have_clk_lane = false;
> >  	unsigned int flags = 0;
> > @@ -34,14 +33,26 @@ static void v4l2_of_parse_csi_bus(const struct
> > device_node *node, const __be32 *lane = NULL;
> >  		int i;
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
> > +		int i;
> 
> Could you please use unsigned int instead of int as the loop index can't have 
> negative value ? Feel free to fix the index in the previous loop too :-)

Fixed both.

> > +
> > +		for (i = 0; i < ARRAY_SIZE(bus->lane_polarity); i++) {
> > +			polarity = of_prop_next_u32(prop, polarity, &v);
> > +			if (!polarity)
> > +				break;
> > +			bus->lane_polarity[i] = v;
> > +		}
> 
> Should we check that i == num_data_lines + 1 ?

Good question. I think I'd just replace this with
of_property_read_u32_array() instead, how about that? Then there would have
to be at least as many lane polarities defined as there are lanes (data and
clock). Defining more wouldn't be an error.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
