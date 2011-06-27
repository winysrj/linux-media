Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.187]:55255 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757497Ab1F0M64 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jun 2011 08:58:56 -0400
Date: Mon, 27 Jun 2011 14:58:49 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sakari Ailus <sakari.ailus@iki.fi>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	sakari.ailus@maxwell.research.nokia.com,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Stan <svarbanov@mm-sol.com>, Hans Verkuil <hansverk@cisco.com>,
	saaguirre@ti.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v2] V4L: add media bus configuration subdev operations
In-Reply-To: <20110627124316.GE12671@valkosipuli.localdomain>
Message-ID: <Pine.LNX.4.64.1106271448240.9394@axis700.grange>
References: <Pine.LNX.4.64.1106222314570.3535@axis700.grange>
 <20110623220129.GA10918@valkosipuli.localdomain> <Pine.LNX.4.64.1106240021540.5348@axis700.grange>
 <20110627081912.GC12671@valkosipuli.localdomain> <Pine.LNX.4.64.1106271029240.9394@axis700.grange>
 <20110627124316.GE12671@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 27 Jun 2011, Sakari Ailus wrote:

> Hi Guennadi,
> 
> On Mon, Jun 27, 2011 at 10:54:11AM +0200, Guennadi Liakhovetski wrote:
> > Hi Sakari
> > 
> > On Mon, 27 Jun 2011, Sakari Ailus wrote:
> > 
> > > On Fri, Jun 24, 2011 at 12:35:03AM +0200, Guennadi Liakhovetski wrote:
> > > > Hi Sakari
> > > 
> > > Hi Guennadi,
> > > 
> > > > On Fri, 24 Jun 2011, Sakari Ailus wrote:
> > > > 
> > > > > Hi Guennadi,
> > > > > 
> > > > > Thanks for the patch. I have a few comments below.
> > > > > 
> > > > > On Wed, Jun 22, 2011 at 11:26:29PM +0200, Guennadi Liakhovetski wrote:
> > > 
> > > [clip]
> > > 
> > > > > > diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> > > > > > index 1562c4f..75919ef 100644
> > > > > > --- a/include/media/v4l2-subdev.h
> > > > > > +++ b/include/media/v4l2-subdev.h
> > > > > > @@ -255,6 +255,10 @@ struct v4l2_subdev_audio_ops {
> > > > > >     try_mbus_fmt: try to set a pixel format on a video data source
> > > > > >  
> > > > > >     s_mbus_fmt: set a pixel format on a video data source
> > > > > > +
> > > > > > +   g_mbus_config: get supported mediabus configurations
> > > > > > +
> > > > > > +   s_mbus_config: set a certain mediabus configuration
> > > > > >   */
> > > > > >  struct v4l2_subdev_video_ops {
> > > > > >  	int (*s_routing)(struct v4l2_subdev *sd, u32 input, u32 output, u32 config);
> > > > > > @@ -294,6 +298,8 @@ struct v4l2_subdev_video_ops {
> > > > > >  			    struct v4l2_mbus_framefmt *fmt);
> > > > > >  	int (*s_mbus_fmt)(struct v4l2_subdev *sd,
> > > > > >  			  struct v4l2_mbus_framefmt *fmt);
> > > > > > +	int (*g_mbus_config)(struct v4l2_subdev *sd, struct v4l2_mbus_config *cfg);
> > > > > > +	int (*s_mbus_config)(struct v4l2_subdev *sd, struct v4l2_mbus_config *cfg);
> > > > > 
> > > > > How would the ops be used and by whom?
> > > > 
> > > > In the first line I want to use them to make re-use of soc-camera and 
> > > > other subdev drivers possible. Soc-camera drivers would switch to these 
> > > > from their specific bus-configuration methods, other drivers are free to 
> > > > use or not to use them.
> > > > 
> > > > > How complete configuration for CSI2 bus is the above intend to be? Complete,
> > > > > I suppose, and so I think we'll also need to specify how e.g. the CSI2 clock
> > > > > and data lanes have been connected between transmitter and receiver. This is
> > > > > less trivial to guess than clock polarity and requires further information
> > > > > from the board and lane mapping configuration capabilities of both.
> > > > > Shouldn't this information be also added to CSI2 configuration?
> > > > > 
> > > > > Do you think a single bitmask would suffice for this in the long run?
> > > > 
> > > > If you have certain additions to this API I would be happy to consider 
> > > > them. Otherwise, if you just suppose, that we might need more 
> > > > configuration options, we can always add them in the future, when we know 
> > > > more about them and have specific use-cases, with which we can test them. 
> > > > E.g., I am not sure what data- and clock-lane connection possibilities you 
> > > > refer to above. Don't you _have_ to connect lane 1 to 1 etc?
> > > 
> > > You don't need to. It actually depends on the hardware: the OMAP 3 CSI-2
> > > receiver, for example, may freely configure the order of the data and clock
> > > lanes. And you'll actually have to do that configuration since this is
> > > purely board dependent.
> > 
> > Nice
> > 
> > > I'm not sure whether the CSI-2 specification requires this, however. I
> > > wouldn't be surprised if there were sensors which could also do this.
> > 
> > Ok, to be flexible and consistent, we could do the same as with other 
> > parameters. We could design a query like "to which pin can you route data 
> > lane 1?" with possible replies "I can only route lane 1 to pin 1," or "I 
> > can route lane 1 to pins 1, 2, 3, 4, or 5" (for 4 data-lanes and one clock 
> > lane. Then the configuration request could do "please, route your data 
> > lane 1 to pin 1." Or we can hard-code this routing in the platform data 
> > for now.
> > 
> > I, probably, already mentioned this before, but this is also how the 
> > present soc-camera API evolved in the past: in the beginning it also was 
> > completely static, then I noticed, that instead of hard coding the 
> > configuration, I can let drivers negotiate parameters automatically. Then 
> > gradually the number of auto-negotiated parameters grew, as more flexible 
> > hardware had to be handled.
> > 
> > We could do the same here: first hard-code this, then see, if it is 
> > becoming a burden, having to hard-code these. Notice, that 
> > auto-configuring these should not be a problem. This is not like 
> > configuring a signal polarity, of which one can work better, than the 
> > other.
> 
> I'm definitely for hard coding this kind of information. The driver may
> define a default order for the lanes, and then the mapping to the actual
> lanes may be stored in the platform data. The same for the receiver. So the
> configuration would actually be different on transmitter and receiver: it's
> not a parameter which is shared among both of them.

This would be doable, you would have to introduce some "board" lane 
numbering as a common reference for both the bridge and the sensor. But 
this seems pretty far-fetched to me too, so, I'm ok with hard-coding of 
the lane routing.

> > > For OMAP 3 ISP driver this configuration is in struct isp_csiphy_lanes_cfg
> > > in drivers/media/video/omap3isp/ispcsiphy.h at the moment.
> > > 
> > > The OMAP 3 ISP driver currently uses all the lanes it has, as far as I
> > > understand, so you can't disable them right now.
> > > 
> > > > > I can see some use for the information in the set operation in lane
> > > > > configuration, for example, as you mentioned. My guess would be that the
> > > > > number of lanes _might_ be something that the user space would want to know
> > > > > or possibly even configure --- but we'll first need to discuss low-level
> > > > > sensor control interface.
> > > > > 
> > > > > But otherwise the configuration should likely be rather static and board
> > > > > specific. Wouldn't the subdevs get this as part of the platform data, or
> > > > > how?
> > > > > 
> > > > > I would just keep the bus configuration static board dependent information
> > > > > until we have that part working and used by drivers and extend it later on.
> > > > 
> > > > As I said, drivers are free to not use these methods and implement a 
> > > > platform-provided configuration method. In which case, as, I think, Hans 
> > > > pointed out earlier, they can also choose to use this struct in their 
> > > > platform data.
> > > 
> > > If the structures are expected to be generic I somehow feel that a field of
> > > flags isn't the best way to describe the configuration of CSI-2 or other
> > > busses. Why not to just use a structure with bus type and an union for
> > > bus-specific configuration parameters? It'd be easier to access and also to
> > > change as needed than flags in an unsigned long field.
> > 
> > Well, yes, a union can be a good idea, thanks.
> > 
> > > Also, this structure is primarily about capabilities and not configuration.
> > > Having settings e.g. for active low vsync and the opposite isn't making this
> > > easier for drivers. There should be just one --- more so if the matching
> > > will be specific to SoC camera only.
> > > 
> > > What would you think of having separate structures for configuration and
> > > capabilities of the busses? I think this way the mechanism would be more
> > > useful outside the scope of SoC camera. The CSI-2 and parallel busses are
> > > still quite generic.
> > 
> > Disagree, O'm quite happy with the current flag system, used for both 
> > capabilities and configuration.
> 
> What do you think about use outside SoC camera where we don't have
> negotiation? The bus configuration should be generic and not dependent on
> SoC camera. There isn't any generic CSI-2 configuration outside SoC camera
> right now but I think it would make sense to have that some day.

I think, we have discussed this already. Other drivers do not want any 
dynamic configuration, so, they only implement the "g" method, and the 
subdevices return only one of the alternatives for each parameter. For 
example, the sensor would say "I only support HSYNC active high, PCLK 
sampled on the falling edge" etc. Don't see any problem with this.

> > > That said, at this point I'm not exactly sure what configuration should be
> > > board specific and what should be dynamically configurable. The lane setup I
> > > mentioned earlier, for example, is something that would be good to be
> > > dynamically configurable in the future. Even if there are e.g. two lanes the
> > > user still might want to use just one. In this case you need to be able to
> > > tell the hardware has that two lanes but you only use one of them.
> > 
> > Yes, but what exactly do you want to make configurable? The _number_ of 
> > lanes, or their routing?
> 
> Number of the lanes. When e.g. the sensor does binning and skipping and the
> output data rate is much lower than at the native output size, one could use
> less lanes than at the native size. For the user it doesn't matter which
> of the lanes are being used.

Ok

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
