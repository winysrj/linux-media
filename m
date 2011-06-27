Return-path: <mchehab@pedra>
Received: from smtp-68.nebula.fi ([83.145.220.68]:44675 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755644Ab1F0ITS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jun 2011 04:19:18 -0400
Date: Mon, 27 Jun 2011 11:19:12 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	sakari.ailus@maxwell.research.nokia.com,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Stan <svarbanov@mm-sol.com>, Hans Verkuil <hansverk@cisco.com>,
	saaguirre@ti.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v2] V4L: add media bus configuration subdev operations
Message-ID: <20110627081912.GC12671@valkosipuli.localdomain>
References: <Pine.LNX.4.64.1106222314570.3535@axis700.grange>
 <20110623220129.GA10918@valkosipuli.localdomain>
 <Pine.LNX.4.64.1106240021540.5348@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1106240021540.5348@axis700.grange>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, Jun 24, 2011 at 12:35:03AM +0200, Guennadi Liakhovetski wrote:
> Hi Sakari

Hi Guennadi,

> On Fri, 24 Jun 2011, Sakari Ailus wrote:
> 
> > Hi Guennadi,
> > 
> > Thanks for the patch. I have a few comments below.
> > 
> > On Wed, Jun 22, 2011 at 11:26:29PM +0200, Guennadi Liakhovetski wrote:

[clip]

> > > diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> > > index 1562c4f..75919ef 100644
> > > --- a/include/media/v4l2-subdev.h
> > > +++ b/include/media/v4l2-subdev.h
> > > @@ -255,6 +255,10 @@ struct v4l2_subdev_audio_ops {
> > >     try_mbus_fmt: try to set a pixel format on a video data source
> > >  
> > >     s_mbus_fmt: set a pixel format on a video data source
> > > +
> > > +   g_mbus_config: get supported mediabus configurations
> > > +
> > > +   s_mbus_config: set a certain mediabus configuration
> > >   */
> > >  struct v4l2_subdev_video_ops {
> > >  	int (*s_routing)(struct v4l2_subdev *sd, u32 input, u32 output, u32 config);
> > > @@ -294,6 +298,8 @@ struct v4l2_subdev_video_ops {
> > >  			    struct v4l2_mbus_framefmt *fmt);
> > >  	int (*s_mbus_fmt)(struct v4l2_subdev *sd,
> > >  			  struct v4l2_mbus_framefmt *fmt);
> > > +	int (*g_mbus_config)(struct v4l2_subdev *sd, struct v4l2_mbus_config *cfg);
> > > +	int (*s_mbus_config)(struct v4l2_subdev *sd, struct v4l2_mbus_config *cfg);
> > 
> > How would the ops be used and by whom?
> 
> In the first line I want to use them to make re-use of soc-camera and 
> other subdev drivers possible. Soc-camera drivers would switch to these 
> from their specific bus-configuration methods, other drivers are free to 
> use or not to use them.
> 
> > How complete configuration for CSI2 bus is the above intend to be? Complete,
> > I suppose, and so I think we'll also need to specify how e.g. the CSI2 clock
> > and data lanes have been connected between transmitter and receiver. This is
> > less trivial to guess than clock polarity and requires further information
> > from the board and lane mapping configuration capabilities of both.
> > Shouldn't this information be also added to CSI2 configuration?
> > 
> > Do you think a single bitmask would suffice for this in the long run?
> 
> If you have certain additions to this API I would be happy to consider 
> them. Otherwise, if you just suppose, that we might need more 
> configuration options, we can always add them in the future, when we know 
> more about them and have specific use-cases, with which we can test them. 
> E.g., I am not sure what data- and clock-lane connection possibilities you 
> refer to above. Don't you _have_ to connect lane 1 to 1 etc?

You don't need to. It actually depends on the hardware: the OMAP 3 CSI-2
receiver, for example, may freely configure the order of the data and clock
lanes. And you'll actually have to do that configuration since this is
purely board dependent.

I'm not sure whether the CSI-2 specification requires this, however. I
wouldn't be surprised if there were sensors which could also do this.

For OMAP 3 ISP driver this configuration is in struct isp_csiphy_lanes_cfg
in drivers/media/video/omap3isp/ispcsiphy.h at the moment.

The OMAP 3 ISP driver currently uses all the lanes it has, as far as I
understand, so you can't disable them right now.

> > I can see some use for the information in the set operation in lane
> > configuration, for example, as you mentioned. My guess would be that the
> > number of lanes _might_ be something that the user space would want to know
> > or possibly even configure --- but we'll first need to discuss low-level
> > sensor control interface.
> > 
> > But otherwise the configuration should likely be rather static and board
> > specific. Wouldn't the subdevs get this as part of the platform data, or
> > how?
> > 
> > I would just keep the bus configuration static board dependent information
> > until we have that part working and used by drivers and extend it later on.
> 
> As I said, drivers are free to not use these methods and implement a 
> platform-provided configuration method. In which case, as, I think, Hans 
> pointed out earlier, they can also choose to use this struct in their 
> platform data.

If the structures are expected to be generic I somehow feel that a field of
flags isn't the best way to describe the configuration of CSI-2 or other
busses. Why not to just use a structure with bus type and an union for
bus-specific configuration parameters? It'd be easier to access and also to
change as needed than flags in an unsigned long field.

Also, this structure is primarily about capabilities and not configuration.
Having settings e.g. for active low vsync and the opposite isn't making this
easier for drivers. There should be just one --- more so if the matching
will be specific to SoC camera only.

What would you think of having separate structures for configuration and
capabilities of the busses? I think this way the mechanism would be more
useful outside the scope of SoC camera. The CSI-2 and parallel busses are
still quite generic.

That said, at this point I'm not exactly sure what configuration should be
board specific and what should be dynamically configurable. The lane setup I
mentioned earlier, for example, is something that would be good to be
dynamically configurable in the future. Even if there are e.g. two lanes the
user still might want to use just one. In this case you need to be able to
tell the hardware has that two lanes but you only use one of them.

Kind regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi
