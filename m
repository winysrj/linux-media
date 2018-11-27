Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:41165 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726964AbeK1BLV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Nov 2018 20:11:21 -0500
Message-ID: <1543327949.8212.4.camel@pengutronix.de>
Subject: Re: [PATCH v3 6/6] media: mt9m111: allow to setup pixclk polarity
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Marco Felsch <m.felsch@pengutronix.de>, mark.rutland@arm.com,
        devicetree@vger.kernel.org,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        enrico.scholz@sigma-chemnitz.de, akinobu.mita@gmail.com,
        robh+dt@kernel.org, mchehab@kernel.org, graphics@pengutronix.de,
        linux-media@vger.kernel.org
Date: Tue, 27 Nov 2018 15:12:29 +0100
In-Reply-To: <20181127135056.whzulohnohkguk5d@paasikivi.fi.intel.com>
References: <20181127100253.30845-1-m.felsch@pengutronix.de>
         <20181127100253.30845-7-m.felsch@pengutronix.de>
         <20181127131948.maqwyqmlnwowf4ng@paasikivi.fi.intel.com>
         <1543325967.8212.1.camel@pengutronix.de>
         <20181127135056.whzulohnohkguk5d@paasikivi.fi.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Tue, 2018-11-27 at 15:50 +0200, Sakari Ailus wrote:
> Hi Philipp,
> 
> On Tue, Nov 27, 2018 at 02:39:27PM +0100, Philipp Zabel wrote:
> > Hi Sakari,
> > 
> > On Tue, 2018-11-27 at 15:19 +0200, Sakari Ailus wrote:
> > > Hi Marco,
> > > 
> > > On Tue, Nov 27, 2018 at 11:02:53AM +0100, Marco Felsch wrote:
> > > > From: Enrico Scholz <enrico.scholz@sigma-chemnitz.de>
> > > > 
> > > > The chip can be configured to output data transitions on the
> > > > rising or falling edge of PIXCLK (Datasheet R58:1[9]), default is on the
> > > > falling edge.
> > > > 
> > > > Parsing the fw-node is made in a subfunction to bundle all (future)
> > > > dt-parsing / fw-parsing stuff.
> > > > 
> > > > Signed-off-by: Enrico Scholz <enrico.scholz@sigma-chemnitz.de>
> > > > (m.grzeschik@pengutronix.de: Fix inverting clock. INV_PIX_CLOCK bit is set
> > > > per default. Set bit to 0 (enable mask bit without value) to enable
> > > > falling edge sampling.)
> > > > Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> > > > (m.felsch@pengutronix.de: use fwnode helpers)
> > > > (m.felsch@pengutronix.de: mv fw parsing into own function)
> > > > (m.felsch@pengutronix.de: adapt commit msg)
> > > > Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
> > > 
> > > Applied with the following diff:
> > > 
> > > diff --git a/drivers/media/i2c/mt9m111.c b/drivers/media/i2c/mt9m111.c
> > > index 2ef332b9b914..b6011bfddde8 100644
> > > --- a/drivers/media/i2c/mt9m111.c
> > > +++ b/drivers/media/i2c/mt9m111.c
> > > @@ -1172,24 +1172,24 @@ static int mt9m111_video_probe(struct i2c_client *client)
> > >  
> > >  static int mt9m111_probe_fw(struct i2c_client *client, struct mt9m111 *mt9m111)
> > >  {
> > > -	struct v4l2_fwnode_endpoint *bus_cfg;
> > > +	struct v4l2_fwnode_endpoint bus_cfg = {
> > > +		.bus_type = V4L2_MBUS_PARALLEL
> > > +	};
> > >  	struct fwnode_handle *np;
> > > -	int ret = 0;
> > > +	int ret;
> > >  
> > >  	np = fwnode_graph_get_next_endpoint(dev_fwnode(&client->dev), NULL);
> > >  	if (!np)
> > >  		return -EINVAL;
> > >  
> > > -	bus_cfg = v4l2_fwnode_endpoint_alloc_parse(np);
> > > -	if (IS_ERR(bus_cfg)) {
> > > -		ret = PTR_ERR(bus_cfg);
> > > +	ret = v4l2_fwnode_endpoint_alloc_parse(np, &bus_cfg);
> > 
> > Should that be
> > 
> > +	ret = v4l2_fwnode_endpoint_parse(np, &bus_cfg);
> > 
> > intead?
> 
> Could be. I'd expect the driver to need the link frequency at some point
> after which you'd need the variable size properties anyway. But that's not
> the case now.

I don't think the link-frequencies property will be used, this is just a
parallel device. But Marco chose to use _alloc_parse because of what the
v4l2_fwnode_endpoint_parse() documentation says:

/*
 * NOTE: This function does not parse properties the size of which is variable
 * without a low fixed limit. Please use v4l2_fwnode_endpoint_alloc_parse() in                                                                
 * new drivers instead.
 */

So maybe we want to use v4l2_fwnode_endpoint_alloc_parse() always. There
is no unnecessary allocation, just a lookup of the non-existing link-
frequencies property.

regards
Philipp
