Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49765 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707Ab3IKNPB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Sep 2013 09:15:01 -0400
Message-ID: <1378905295.3966.62.camel@pizza.hi.pengutronix.de>
Subject: Re: [PATCH/RFC v3 06/19] video: display: OF support
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
	linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	sylvester.nawrocki@gmail.com, sakari.ailus@iki.fi
Date: Wed, 11 Sep 2013 15:14:55 +0200
In-Reply-To: <2263372.8nCBHctlWT@avalon>
References: <1376089398-13322-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
	 <1376089398-13322-7-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
	 <1378304498.5721.42.camel@pizza.hi.pengutronix.de>
	 <2263372.8nCBHctlWT@avalon>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Mittwoch, den 11.09.2013, 13:33 +0200 schrieb Laurent Pinchart:
> Hi Philipp,
> 
> On Wednesday 04 September 2013 16:21:38 Philipp Zabel wrote:
> > Am Samstag, den 10.08.2013, 01:03 +0200 schrieb Laurent Pinchart:
> > > Extend the notifier with DT node matching support, and add helper
> > > functions to build the notifier and link entities based on a graph
> > > representation in DT.
> > > 
> > > Signed-off-by: Laurent Pinchart
> > > <laurent.pinchart+renesas@ideasonboard.com>
> > > ---
> > > 
> > >  drivers/video/display/display-core.c     | 334 ++++++++++++++++++++++++++
> > >  drivers/video/display/display-notifier.c | 187 +++++++++++++++++
> > >  include/video/display.h                  |  45 +++++
> > >  3 files changed, 566 insertions(+)
> > > 
> > > diff --git a/drivers/video/display/display-core.c
> > > b/drivers/video/display/display-core.c index c3b47d3..328ead7 100644
> > > --- a/drivers/video/display/display-core.c
> > > +++ b/drivers/video/display/display-core.c
> > 
> > [...]
> > 
> > > @@ -420,6 +599,161 @@ int display_entity_link_graph(struct device *dev,
> > > struct list_head *entities)> 
> > >  }
> > >  EXPORT_SYMBOL_GPL(display_entity_link_graph);
> > > 
> > > +#ifdef CONFIG_OF
> > > +
> > > +static int display_of_entity_link_entity(struct device *dev,
> > > +					 struct display_entity *entity,
> > > +					 struct list_head *entities,
> > > +					 struct display_entity *root)
> > > +{
> > > +	u32 link_flags = MEDIA_LNK_FL_IMMUTABLE | MEDIA_LNK_FL_ENABLED;
> > > +	const struct device_node *node = entity->dev->of_node;
> > 
> > the current device tree matching implementation only allows one display
> > entity per linux device. How about adding an of_node pointer to struct
> > display_entity directly and allow multiple display entity nodes below in a
> > single device node in the device tree?
> 
> That's a very good point. We had a similar issues in V4L2, with sensors that 
> would create several entities. However, in those cases, the sensors would be 
> connected to the rest of the pipeline through a single entity :
> 
> Sensor Entity 1 -> ... -> Sensor Entity N -> V4L2 pipeline ...
> 
> The core code thus had to care about a single sensor entity when building the 
> pipeline. We could solve the problem in a similar way for panels, but encoders 
> need a more elaborate solution.
> 
> I see (at least) two possibilities here, either explicitly describing all 
> entities that make the device in DT (as you have proposed below), or creating 
> a hierarchy of entities, with parent entities that can contain several child 
> entities. I've CC'ed Guennadi, Hans, Sylwester and Sakari to get their opinion 
> on the matter.

When you say hierarchy of entities, I imagine something like GStreamer
bins? I suspect hierarchically encapsulated entities would complicate
the pipeline/graph traversal code quite a bit, although it would
probably help to organise the graph and reduce the amount of boilerplate
needed in the device tree.

> > lvds-encoder {
> > 	channel@0 {
> 
> If I understand this correctly, your LVDS encoder has two independent 
> channels.

In this example, yes. In reality the i.MX LDB has a mux in each path, so
both inputs can be routed to both outputs. With an entity hierarchy this
could be described as a single entity with two inputs and two outputs,
containing two multiplexer entites and two encoder entities.

LDB entity with two input pads, four internal entities, and two output
pads:
  ,----------------------------------------.
  |-----.  LDB   ,------.  ,------.  ,-----|
--| pad |--------| mux0 |--| enc0 |--| pad |--
  |  0  |--.  ,--|      |  |      |  |  2  |
  |-----´   \/   `------´  `------´  `-----|
  |-----.   /\   ,------.  ,------.  .-----|
--| pad |--´  `--| mux1 |  | enc1 |--| pad |--
  |  1  |--------|      |--|      |  |  3  |
  |-----´        `------´  `------´  `-----|
  `----------------------------------------´
(In guess the mux and enc entities could each be combined into one)

> In the general case a device made of multiple entities might have 
> those entities chained, so "channel" might not be the best term.
> "entity" might be a better choice.

On the other hand, when describing subdevice entities in the device
tree, maybe the generic type of entity (sensor, scaler, encoder, mux,
etc.) would be useful information?

Another module where I'd like to describe the (outward facing) contained
entities in the device tree is the i.MX Image Processing Unit, which has
two capture interfaces and two display interfaces (all parallel). Those
can't be combined into a single entity because there are other internal
entities connected to them, and because the capture interfaces are v4l2
subdevices, whereas the display interfaces will be display entites.
Alternatively, this could also be described as a single entity
containing an internal structure.

IPU entity with two input pads, two internal capture entities (csi), two
display entities (di), and two output pads:
  ,----------------------------------------.
  |-----.  ,------.  IPU   ,------.  ,-----|
--| pad |--| csi0 |        | di0  |--| pad |--
  |  0  |  |      |...     |      |  |  2  |
  |-----´  `------´        `------´  `-----|
  |-----.  ,------.        ,------.  .-----|
--| pad |--| csi1 |        | di1  |--| pad |--
  |  1  |  |      |...     |      |  |  3  |
  |-----´  `------´        `------´  `-----|
  `----------------------------------------´

regards
Philipp

