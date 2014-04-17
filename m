Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38448 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164AbaDQMpW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Apr 2014 08:45:22 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH v2 48/48] adv7604: Add endpoint properties to DT bindings
Date: Thu, 17 Apr 2014 14:45:25 +0200
Message-ID: <1791575.2krcfHqYT1@avalon>
In-Reply-To: <534FB855.1020702@samsung.com>
References: <1394493359-14115-1-git-send-email-laurent.pinchart@ideasonboard.com> <1394493359-14115-49-git-send-email-laurent.pinchart@ideasonboard.com> <534FB855.1020702@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Thursday 17 April 2014 13:17:41 Sylwester Nawrocki wrote:
> On 11/03/14 00:15, Laurent Pinchart wrote:
> > Add support for the hsync-active, vsync-active and pclk-sample
> > properties to the DT bindings and control BT.656 mode implicitly.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> > 
> >  .../devicetree/bindings/media/i2c/adv7604.txt      | 13 +++++++++
> >  drivers/media/i2c/adv7604.c                        | 31
> >  ++++++++++++++++++++-- 2 files changed, 42 insertions(+), 2 deletions(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/media/i2c/adv7604.txt
> > b/Documentation/devicetree/bindings/media/i2c/adv7604.txt index
> > 0845c50..2b62c06 100644
> > --- a/Documentation/devicetree/bindings/media/i2c/adv7604.txt
> > +++ b/Documentation/devicetree/bindings/media/i2c/adv7604.txt
> > 
> > @@ -30,6 +30,19 @@ Optional Properties:
> >    - adi,disable-cable-reset: Boolean property. When set disables the HDMI
> >    
> >      receiver automatic reset when the HDMI cable is unplugged.
> > 
> > +Optional Endpoint Properties:
> > +
> > +  The following three properties are defined in video-interfaces.txt and
> > are +  valid for source endpoints only.
> > +
> > +  - hsync-active: Horizontal synchronization polarity. Defaults to active
> > low. +  - vsync-active: Vertical synchronization polarity. Defaults to
> > active low. +  - pclk-sample: Pixel clock polarity. Defaults to output on
> > the falling edge. +
> > +  If none of hsync-active, vsync-active and pclk-sample is specified the
> > +  endpoint will use embedded BT.656 synchronization.
> > +
> > +
> > 
> >  Example:
> >  	hdmi_receiver@4c {
> > 
> > diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
> > index 95cc911..2a92099 100644
> > --- a/drivers/media/i2c/adv7604.c
> > +++ b/drivers/media/i2c/adv7604.c
> > @@ -41,6 +41,7 @@
> > 
> >  #include <media/v4l2-ctrls.h>
> >  #include <media/v4l2-device.h>
> >  #include <media/v4l2-dv-timings.h>
> > 
> > +#include <media/v4l2-of.h>
> > 
> >  static int debug;
> >  module_param(debug, int, 0644);
> > 
> > @@ -2643,11 +2644,39 @@ MODULE_DEVICE_TABLE(of, adv7604_of_id);
> > 
> >  static int adv7604_parse_dt(struct adv7604_state *state)
> >  {
> > 
> > +	struct v4l2_of_endpoint bus_cfg;
> > +	struct device_node *endpoint;
> > 
> >  	struct device_node *np;
> > 
> > +	unsigned int flags;
> > 
> >  	int ret;
> >  	
> >  	np = state->i2c_clients[ADV7604_PAGE_IO]->dev.of_node;
> > 
> > +	/* Parse the endpoint. */
> > +	endpoint = v4l2_of_get_next_endpoint(np, NULL);
> > +	if (!endpoint)
> > +		return -EINVAL;
> 
> Perhaps we should document this binding requires at least one endpoint
> node ? I guess there is no point in not having any endpoint node ?

I think that's pretty much implied, otherwise the device will not be connected 
to anything and will be unusable. I will document ports node usage though, 
that's currently missing in the DT bindings documentation.

> > +	v4l2_of_parse_endpoint(endpoint, &bus_cfg);
> > +	of_node_put(endpoint);
> > +
> > +	flags = bus_cfg.bus.parallel.flags;
> > +
> > +	if (flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH)
> > +		state->pdata.inv_hs_pol = 1;
> > +
> > +	if (flags & V4L2_MBUS_VSYNC_ACTIVE_HIGH)
> > +		state->pdata.inv_vs_pol = 1;
> > +
> > +	if (flags & V4L2_MBUS_PCLK_SAMPLE_RISING)
> > +		state->pdata.inv_llc_pol = 1;
> > +
> > +	if (bus_cfg.bus_type == V4L2_MBUS_BT656) {
> > +		state->pdata.insert_av_codes = 1;
> > +		state->pdata.op_656_range = 1;
> > +	}
> > +
> > +	/* Parse device-specific properties. */
> > 
> >  	state->pdata.disable_pwrdnb =
> >  	
> >  		of_property_read_bool(np, "adi,disable-power-down");
> >  	
> >  	state->pdata.disable_cable_det_rst =
> > 
> > @@ -2677,9 +2706,7 @@ static int adv7604_parse_dt(struct adv7604_state
> > *state)> 
> >  	/* HACK: Hardcode the remaining platform data fields. */
> >  	state->pdata.blank_data = 1;
> > 
> > -	state->pdata.op_656_range = 1;
> > 
> >  	state->pdata.alt_data_sat = 1;
> > 
> > -	state->pdata.insert_av_codes = 1;
> > 
> >  	state->pdata.op_format_mode_sel = ADV7604_OP_FORMAT_MODE0;
> >  	
> >  	return 0;

-- 
Regards,

Laurent Pinchart

