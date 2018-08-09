Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:50317 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732283AbeHIRAl (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 9 Aug 2018 13:00:41 -0400
Date: Thu, 9 Aug 2018 16:35:20 +0200
From: Marco Felsch <m.felsch@pengutronix.de>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        p.zabel@pengutronix.de, afshin.nasser@gmail.com,
        javierm@redhat.com, sakari.ailus@linux.intel.com,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH 19/22] [media] tvp5150: add input source selection
 of_graph support
Message-ID: <20180809143520.e2fwsuztfazmyl7e@pengutronix.de>
References: <20180628162054.25613-1-m.felsch@pengutronix.de>
 <20180628162054.25613-20-m.felsch@pengutronix.de>
 <20180730152938.50e69143@coco.lan>
 <20180808152949.h7mpqb7evnvqiy5n@pengutronix.de>
 <20180808155251.4062ff1f@coco.lan>
 <20180809125507.4mxopx4yowjd3zgw@pengutronix.de>
 <20180809103653.0f81de01@coco.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180809103653.0f81de01@coco.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thanks for your feedback.

On 18-08-09 10:36, Mauro Carvalho Chehab wrote:
> Em Thu, 9 Aug 2018 14:55:07 +0200
> Marco Felsch <m.felsch@pengutronix.de> escreveu:
> 
> > Hi Mauro,
> > 
> > On 18-08-08 15:52, Mauro Carvalho Chehab wrote:
> > > Em Wed, 8 Aug 2018 17:29:49 +0200
> > > Marco Felsch <m.felsch@pengutronix.de> escreveu:
> > >   
> > > > Hi Mauro,
> > > > 
> > > > the discussion about the correct binding was spread around some patches.
> > > > So I will try use the correct thread for that theme. I did my rework for
> > > > the of_graph support on your suggestions [1] and [2]. I attached my work
> > > > as RFC patch. Can you review it, so I can prepare a v2?
> > > > 
> > > > [1] https://www.spinics.net/lists/linux-media/msg138545.html
> > > > [2] https://www.spinics.net/lists/linux-media/msg138546.html  
> > > 
> > > Thanks for the patch.
> > > 
> > > Added my comments below.  
> > 
> > Thanks for your quick response.
> > 
> > I integrated the most of your comments and added some more comments below.
> > 
> > >   
> > > > 
> > > > On 18-07-30 15:29, Mauro Carvalho Chehab wrote:  
> > > > > Em Thu, 28 Jun 2018 18:20:51 +0200
> > > > > Marco Felsch <m.felsch@pengutronix.de> escreveu:
> > > > >   
> > > > > > The currrent driver layout had the following layout:
> > > > > >                +----------------+
> > > > > >  +-------+     |    TVP5150     |
> > > > > >  | Comp0 +--+  |                |
> > > > > >  +-------+  |  |          +-----+
> > > > > >  +-------+  |  +------+   | Src |
> > > > > >  | Comp1 +--+--|Sink  |   +-----+
> > > > > >  +-------+  |  +------+   +-----+
> > > > > > +--------+  |  |          | Src |
> > > > > > | SVideo +--+  |          +-----+
> > > > > > +--------+     +----------------+
> > > > > > 
> > > > > > Since the device tree abstracts the real hardware this layout is not
> > > > > > correct, because the TVP5150 has 3 physical ports (2 input, 1 output).
> > > > > > Furthermore this layout assumes that there is an additional external mux
> > > > > > in front of the TVP5150. This is not correct because the TVP5150 does
> > > > > > the muxing work. The corresponding of_graph layout will look like:
> > > > > > 	tvp5150 {
> > > > > > 		....
> > > > > > 		port {
> > > > > > 			reg = <0>;
> > > > > > 			endpoint@0 {...};
> > > > > > 			endpoint@1 {...};
> > > > > > 			endpoint@2 {...};
> > > > > > 		};
> > > > > > 
> > > > > > 	};
> > > > > > 
> > > > > > This patch change the layout to:
> > > > > >              +----------------+
> > > > > >              |    TVP5150     |
> > > > > >  +-------+   +------+         |
> > > > > >  | Comp0 +---+ Sink |         |
> > > > > >  +-------+   +------+         |
> > > > > >  +-------+   +------+   +-----+
> > > > > >  | Comp1 +---+ Sink |   | Src |
> > > > > >  +-------+   +------+   +-----+
> > > > > > +--------+   +------+         |
> > > > > > | SVideo +---+ Sink |         |
> > > > > > +--------+   +------+         |
> > > > > >              +----------------+
> > > > > > 
> > > > > > To keep things easy an additional 'virtual' S-Video port is added. More
> > > > > > information about the port mapping can be found in the device tree
> > > > > > binding documentation. The connector entities Comp0/1, SVideo are created
> > > > > > only if they are connected to the correct port. If more than one connector
> > > > > > is available the media_entity_operations.link_setup() callback ensures that
> > > > > > only one connector is active. To change the input src the link between
> > > > > > the TVP5150 pad and the connector must be disabled, then a new link can
> > > > > > be enabled.
> > > > > > 
> > > > > > The patch tries to reduce the '#ifdef CONFIG_MEDIA_CONTROLLER' usage to
> > > > > > a minimum.
> > > > > > 
> > > > > > Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
> > > > > > ---
> > > > > >  drivers/media/i2c/tvp5150.c | 322 ++++++++++++++++++++++++++++++++----
> > > > > >  1 file changed, 287 insertions(+), 35 deletions(-)
> > > > > > 
> > > > > > diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
> > > > > > index a6fec569a610..6ac29c62d99b 100644
> > > > > > --- a/drivers/media/i2c/tvp5150.c
> > > > > > +++ b/drivers/media/i2c/tvp5150.c
> > > > > > @@ -44,10 +44,30 @@ MODULE_PARM_DESC(debug, "Debug level (0-2)");
> > > > > >  
> > > > > >  #define dprintk0(__dev, __arg...) dev_dbg_lvl(__dev, 0, 0, __arg)
> > > > > >  
> > > > > > +enum tvp5150_ports {
> > > > > > +	TVP5150_PORT_AIP1A = TVP5150_COMPOSITE0,
> > > > > > +	TVP5150_PORT_AIP1B,
> > > > > > +	/* s-video port is a virtual port */
> > > > > > +	TVP5150_PORT_SVIDEO,
> > > > > > +	TVP5150_PORT_YOUT,
> > > > > > +	TVP5150_PORT_NUM,
> > > > > > +};
> > > > > > +
> > > > > > +#ifdef CONFIG_MEDIA_CONTROLLER
> > > > > > +struct tvp5150_connector {
> > > > > > +	struct media_entity con;
> > > > > > +	struct media_pad pad;
> > > > > > +	unsigned int port_num;
> > > > > > +};
> > > > > > +#endif
> > > > > > +
> > > > > >  struct tvp5150 {
> > > > > >  	struct v4l2_subdev sd;
> > > > > > +	struct device_node *endpoints[TVP5150_PORT_NUM];
> > > > > >  #ifdef CONFIG_MEDIA_CONTROLLER
> > > > > > -	struct media_pad pads[DEMOD_NUM_PADS];
> > > > > > +	struct media_pad pads[TVP5150_PORT_NUM];  
> > > > > 
> > > > > This will cause problems with the current code.
> > > > > 
> > > > > When we designed the MC version 2 code, the idea were to allow
> > > > > set properties to entities and to the inputs, but the code
> > > > > was never submitted upstream.
> > > > > 
> > > > > A decoder may have several different types of inputs and outputs.
> > > > > Several designs allow using different types of decoders, being
> > > > > saa711x and tvp5150 the most popular ones. Well, depending on
> > > > > the device, the number of PADs and the signals they carry can
> > > > > be different.
> > > > > 
> > > > > Without a way to "taint" a pad to the signal it contains, 
> > > > > while waiting for the properties API, we added a code that
> > > > > "fixed" the PADs to a certain number. This way, Kernelspace could
> > > > > use the pad "number" as a way to identify the type of signal a
> > > > > PAD carries.
> > > > > 
> > > > > The PC consumer drivers use those numbers in order to build the
> > > > > MC graph[1].
> > > > > 
> > > > > A change on this would require adding a property to the pad, in
> > > > > order to indicate the type of signal it provides (RF, luminance IF,
> > > > > chroma IF, audio IF, I2S audio, ...), and to change
> > > > > v4l2_mc_create_media_graph() accordingly.
> > > > > 
> > > > > 
> > > > > [1] See drivers/media/v4l2-core/v4l2-mc.c at v4l2_mc_create_media_graph() func.
> > > > > 
> > > > >   
> > > > 
> > > > [ snip ]
> > > > 
> > > > From d3eb8a7de65fe2f8dd10ced85e4baca8e7898434 Mon Sep 17 00:00:00 2001
> > > > From: Marco Felsch <m.felsch@pengutronix.de>
> > > > Date: Thu, 28 Jun 2018 18:20:51 +0200
> > > > Subject: [RFC] [media] tvp5150: add input source selection of_graph
> > > >  support
> > > > 
> > > > This patch adds the of_graph support to describe the tvp connections.
> > > > Physical the TVP5150 has three ports: AIP1A, AIP1B and YOUT. As result
> > > > of discussion [1],[2] the device-tree maps these ports 1:1 with one
> > > > deviation. The svideo connector must be conneted to port@0/endpoint@1,
> > > > look at the Documentation for more information. Since the TVP5150 is a
> > > > converter the device-tree must contain at least 1-input and 1-output port.
> > > > The mc-connectors and mc-links are only created if the device-tree
> > > > contains the corresponding connector nodes. If more than one connector is
> > > > available the media_entity_operations.link_setup() callback ensures that
> > > > only one connector is active. To change the input src the active link must
> > > > disabled first, then a new link can be established.
> > > > 
> > > > [1] https://www.spinics.net/lists/linux-media/msg138545.html
> > > > [2] https://www.spinics.net/lists/linux-media/msg138546.html
> > > > 
> > > > Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
> > > > 
> > > > ---
> > > > Changelog:
> > > > 
> > > > v2:
> > > > - adapt commit message
> > > > - mc: use 2-input and 1-output pad
> > > > - mc: enable svideo on tvp only if both tvp-input pads have a active
> > > >       link to the svideo src pad
> > > > - mc: disable svideo on tvp only if both tvp-input pads are inactive
> > > > - dt-support: drop svideo dt port
> > > > - dt-support: move svideo connector to port@0/endpoint@1
> > > > - dt-support: require at least 1-in and 1-out endpoint
> > > > ---
> > > >  drivers/media/i2c/tvp5150.c | 413 ++++++++++++++++++++++++++++++++----
> > > >  1 file changed, 377 insertions(+), 36 deletions(-)
> > > > 
> > > > diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
> > > > index b5d44c25d1da..be755c5e63a9 100644
> > > > --- a/drivers/media/i2c/tvp5150.c
> > > > +++ b/drivers/media/i2c/tvp5150.c
> > > > @@ -43,16 +43,38 @@ MODULE_PARM_DESC(debug, "Debug level (0-2)");
> > > >  
> > > >  #define dprintk0(__dev, __arg...) dev_dbg_lvl(__dev, 0, 0, __arg)
> > > >  
> > > > +#ifdef CONFIG_MEDIA_CONTROLLER
> > > >  enum tvp5150_pads {
> > > > -       TVP5150_PAD_IF_INPUT,
> > > > -       TVP5150_PAD_VID_OUT,
> > > > -       TVP5150_NUM_PADS
> > > > +	TVP5150_PAD_AIP1A = TVP5150_COMPOSITE0,
> > > > +	TVP5150_PAD_AIP1B,
> > > > +	TVP5150_PAD_VID_OUT,
> > > > +	TVP5150_NUM_PADS
> > > > +};
> > > > +
> > > > +enum tvp5150_pads_state {
> > > > +	TVP5150_PAD_INACTIVE,
> > > > +	TVP5150_PAD_ACTIVE_COMPOSITE,
> > > > +	TVP5150_PAD_ACTIVE_SVIDEO,
> > > > +};
> > > > +
> > > > +struct tvp5150_connector {
> > > > +	struct media_entity ent;
> > > > +	struct media_pad pad;
> > > > +	unsigned int port_num;
> > > > +	bool is_svideo;
> > > >  };
> > > > +#endif
> > > >  
> > > >  struct tvp5150 {
> > > >  	struct v4l2_subdev sd;
> > > > +	/* additional additional endpoint for the svideo connector */
> > > > +	struct device_node *endpoints[TVP5150_NUM_PADS + 1];
> > > > +	unsigned int endpoints_num;
> > > >  #ifdef CONFIG_MEDIA_CONTROLLER
> > > >  	struct media_pad pads[TVP5150_NUM_PADS];
> > > > +	int pads_state[TVP5150_NUM_PADS];
> > > > +	struct tvp5150_connector *connectors;
> > > > +	int connectors_num;
> > > >  #endif
> > > >  	struct v4l2_ctrl_handler hdl;
> > > >  	struct v4l2_rect rect;
> > > > @@ -1168,6 +1190,135 @@ static int tvp5150_enum_frame_size(struct v4l2_subdev *sd,
> > > >  	return 0;
> > > >  }
> > > >  
> > > > +/****************************************************************************
> > > > + *			Media entity ops
> > > > + ****************************************************************************/
> > > > +#ifdef CONFIG_MEDIA_CONTROLLER
> > > > +static int tvp5150_s_routing(struct v4l2_subdev *sd, u32 input, u32 output,
> > > > +			     u32 config);
> > > > +static int tvp5150_link_setup(struct media_entity *entity,
> > > > +			      const struct media_pad *local,
> > > > +			      const struct media_pad *remote, u32 flags)
> > > > +{
> > > > +	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
> > > > +	struct tvp5150 *decoder = to_tvp5150(sd);
> > > > +	int *pad_state = &decoder->pads_state[0];
> > > > +	int i, ret = 0, active_pad = -1;
> > > > +	bool is_svideo = false;
> > > > +
> > > > +	/*
> > > > +	 * The tvp state is determined by the enabled sink pad link.
> > > > +	 * Enabling or disabling the source pad link has no effect.
> > > > +	 */
> > > > +	if (local->flags & MEDIA_PAD_FL_SOURCE)
> > > > +		return 0;
> > > > +
> > > > +	/* check if the svideo connector should be enabled */
> > > > +	for (i = 0; i < decoder->connectors_num; i++) {
> > > > +		if (remote->entity == &decoder->connectors[i].ent) {
> > > > +			is_svideo = decoder->connectors[i].is_svideo;
> > > > +			break;
> > > > +		}
> > > > +	}
> > > > +
> > > > +	/* check if there is enabled link */
> > > > +	for (i = 0; i < TVP5150_NUM_PADS - 1; i++) {
> > > > +		if ((pad_state[i] == TVP5150_PAD_ACTIVE_COMPOSITE) ||
> > > > +		    (pad_state[i] == TVP5150_PAD_ACTIVE_SVIDEO)) {
> > > > +			active_pad = i;
> > > > +			break;
> > > > +		}
> > > > +	}
> > > > +
> > > > +	dev_dbg(sd->dev, "link setup '%s':%d->'%s':%d[%d]",
> > > > +		remote->entity->name, remote->index, local->entity->name,
> > > > +		local->index, flags & MEDIA_LNK_FL_ENABLED);  
> > > 
> > > Hmm... the remote is the connector, right? I would switch the
> > > print message to point from the connector to tvp5150, as this is
> > > the signal flow.  
> > 
> > I don't know what you mean, I tought that's what I'm already do. If I
> > change it it will print something like: tvp5150 2-005d :0 -> Comp0 :0[1]
> 
> Hmm... then "local" actually means the connector and "remote"
> is the tvp5150?

Nope, local is the tvp and remote is the connector. Actual the output
looks as follows

[   26.339939] tvp5150 2-005d: link setup 'Comp0':0->'tvp5150 2-005d':0[1]
[   26.346606] tvp5150 2-005d: Setting 0 active [composite]

I think this is what you mean with '... point from the connector to
tvp5150 ...'.

> 
> > 
> > > 
> > > Btw, it would likely be better to call it "connector" or "conn_entity",
> > > to make it clearer.  
> > 
> > I tought remote is the common nomenclature. Also the remote mustn't be a
> > connector. In my case it's a soldered camera. With this in mind, you think
> > it should be still changed?
> 
> I see your point.
> 
> Yeah, remote is a common nomenclature. Yet, as it can be seen from
> the above comment (and your answer), common nomenclature may lead
> in to mistakes :-)

Yeah, I know what you mean ^^

> 
> It would be good to have either one of sides better named (either
> the connectors side or the tvp5150 side - or both), in order to be
> clearer and avoid confusion of someone else touches that part of
> the code.

Yes, I'm with you. Since the local always points to the tvp5150, I will
change the local to tvp5150 or tvp5150_pad. Renaming the remote isn't
that good since it can be anything.

> 
> In this specific case, both connectors and tvp5150 are created by
> the tvp5150, so both are "local" in the sense that both are
> created by this driver.
>

I know.. Maybe there should be a 'common' svideo-/composite-connector
code and some helpers to create and link those. Then we can drop the
'local' connectors.

> > 
> > >   
> > > > +
> > > > +	if (flags & MEDIA_LNK_FL_ENABLED) {
> > > > +		/*
> > > > +		 * Composite activation: all links must be inactive.
> > > > +		 * Svideo activation: one link can be active if it is a svideo
> > > > +		 * link. Return error in case of a active composite link or both
> > > > +		 * svideo links are active.
> > > > +		 */
> > > > +		if (active_pad >= 0 && !is_svideo) {
> > > > +			ret = -EBUSY;
> > > > +			goto out;
> > > > +		} else if (active_pad >= 0 && is_svideo &&
> > > > +			   pad_state[active_pad] ==
> > > > +			   TVP5150_PAD_ACTIVE_COMPOSITE) {
> > > > +			ret = -EBUSY;
> > > > +			goto out;
> > > > +		} else if (active_pad >= 0) {
> > > > +			/* check if 2nd svideo link is active too */
> > > > +			for (i = 0; i < TVP5150_NUM_PADS - 1; i++) {
> > > > +				if (pad_state[i] == TVP5150_PAD_ACTIVE_SVIDEO) {
> > > > +					if (i != active_pad) {
> > > > +						ret = -EBUSY;
> > > > +						goto out;
> > > > +					}
> > > > +				}
> > > > +			}
> > > > +		}  
> > > 
> > > That may require some additional discussions.
> > > 
> > > I guess this is not the way it should be. I mean, it should be possible
> > > to change the routing while streaming, without disabling the video
> > > output. That's the behavior that TV generic applications like tvtime,
> > > xawtv, etc rely on.
> > > 
> > > So, probably, the right thing to do here is to disable the active_pad
> > > and  enable the newer one, if there is an active pad.
> > > 
> > > This way, it would work both if the userspace first disables the link
> > > and then enables a new one, or if it switches without explicitly
> > > disabling the previous one.  
> > 
> > Okay I change this behaviour.
> > 
> > >   
> > > > +
> > > > +		dev_dbg(sd->dev, "Setting %d active [%s]\n", local->index,
> > > > +			is_svideo ? "svideo": "composite");
> > > > +		pad_state[local->index] = is_svideo ?
> > > > +			TVP5150_PAD_ACTIVE_SVIDEO : TVP5150_PAD_ACTIVE_COMPOSITE;
> > > > +
> > > > +		if (is_svideo) {
> > > > +			unsigned int active_link_cnt = 0;
> > > > +
> > > > +			/* enable svideo only if we have two active links */
> > > > +			for (i = 0; i > TVP5150_NUM_PADS - 1; i++)
> > > > +				if (pad_state[i] == TVP5150_PAD_ACTIVE_SVIDEO)
> > > > +					active_link_cnt++;
> > > > +			if (active_link_cnt == 2)
> > > > +				tvp5150_s_routing(sd, TVP5150_SVIDEO,
> > > > +						  TVP5150_NORMAL, 0);
> > > > +		} else {
> > > > +			tvp5150_s_routing(sd, local->index, TVP5150_NORMAL, 0);
> > > > +		}
> > > > +	} else {
> > > > +		/*
> > > > +		 * Svideo streams on two pads and user can disable AIP1A or
> > > > +		 * AIP1B first. So check only if user wants to disable a not
> > > > +		 * enabled composite pad.
> > > > +		 */
> > > > +		if (!is_svideo && active_pad != local->index)
> > > > +				goto out;
> > > > +
> > > > +		dev_dbg(sd->dev, "going inactive\n");
> > > > +		pad_state[local->index] = TVP5150_PAD_INACTIVE;
> > > > +
> > > > +		/*
> > > > +		 * Output black screen for deselected input if TVP5150 variant
> > > > +		 * supports this.
> > > > +		 */
> > > > +		if (is_svideo) {
> > > > +			unsigned int inactive_link_cnt = 0;
> > > > +
> > > > +			/* disable svideo only if we have two inactive links */
> > > > +			for (i = 0; i > TVP5150_NUM_PADS - 1; i++)
> > > > +				if (pad_state[i] == TVP5150_PAD_INACTIVE)
> > > > +					inactive_link_cnt++;
> > > > +			if (inactive_link_cnt == 2)
> > > > +				tvp5150_s_routing(sd, TVP5150_SVIDEO,
> > > > +						  TVP5150_BLACK_SCREEN, 0);
> > > > +
> > > > +		} else {
> > > > +			tvp5150_s_routing(sd, local->index,
> > > > +					  TVP5150_BLACK_SCREEN, 0);
> > > > +		}
> > > > +	}
> > > > +out:
> > > > +	return ret;
> > > > +}
> > > > +
> > > > +static const struct media_entity_operations tvp5150_sd_media_ops = {
> > > > +	.link_setup = tvp5150_link_setup,
> > > > +};
> > > > +#endif
> > > >  /****************************************************************************
> > > >  			I2C Command
> > > >   ****************************************************************************/
> > > > @@ -1315,6 +1466,50 @@ static int tvp5150_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
> > > >  	return 0;
> > > >  }
> > > >  
> > > > +static int tvp5150_registered(struct v4l2_subdev *sd)
> > > > +{
> > > > +#ifdef CONFIG_MEDIA_CONTROLLER
> > > > +	struct tvp5150 *decoder = to_tvp5150(sd);
> > > > +	unsigned int i;
> > > > +	int ret;
> > > > +
> > > > +	for (i = 0; i < decoder->connectors_num; i++) {
> > > > +		struct media_entity *con = &decoder->connectors[i].ent;
> > > > +		struct media_pad *pad = &decoder->connectors[i].pad;
> > > > +		unsigned int port = decoder->connectors[i].port_num;
> > > > +		bool is_svideo = decoder->connectors[i].is_svideo;
> > > > +
> > > > +		pad->flags = MEDIA_PAD_FL_SOURCE;
> > > > +		ret = media_entity_pads_init(con, 1, pad);
> > > > +		if (ret < 0)
> > > > +			return ret;
> > > > +
> > > > +		ret = media_device_register_entity(sd->v4l2_dev->mdev, con);
> > > > +		if (ret < 0)
> > > > +			return ret;
> > > > +
> > > > +		ret = media_create_pad_link(con, 0, &sd->entity, port, 0);
> > > > +		if (ret < 0) {
> > > > +			media_device_unregister_entity(con);
> > > > +			return ret;
> > > > +		}
> > > > +
> > > > +		if (is_svideo) {
> > > > +			/* svideo links to both aip1a and aip1b */
> > > > +			ret = media_create_pad_link(con, 0, &sd->entity,
> > > > +						    port + 1, 0);
> > > > +			if (ret < 0) {
> > > > +				media_device_unregister_entity(con);
> > > > +				return ret;
> > > > +			}
> > > > +		}
> > > > +
> > > > +	}  
> > > 
> > > IMO, it should route to the first available connector.  
> > 
> > Did you mean to set the link status to enabled? 
> 
> Yes.
> 
> > If so I have one
> > question else can you tell me what you mean?
> > 
> > Should I use the media_entity_setup_link() helper or should I mark it as
> > enabled during media_create_pad_link()? Now I did something like:
> > 
> > if (i == 0) {
> > 	list_for_each_entry(link, &con->links, list) {
> > 		media_entity_setup_link(link, MEDIA_LNK_FL_ENABLED);
> > 	}
> > }
> 
> yeah, I guess this should work for both the cases where the first
> connector is a comp or a svideo input.
> 
> I would prefer coding it differently, e. g. something like:
> 
> 	
> 	for (i = 0; i < decoder->connectors_num; i++) {
> 		int flags = i ? 0 : MEDIA_LNK_FL_ENABLED;
> 
> and then use the flags var as the last argument for media_create_pad_link()
> calls. That would avoid an extra loop and would likely reduce a little bit
> the code size.

Sorry for the ambiguous code example. I did the 'if (i == 0)' in the same
loop, so no extra loop. I can do it your way, but than unnecessary
media_entity_setup_link() are made.

> 
> > > > +#endif
> > > > +	return 0;
> > > > +}
> > > > +
> > > > +
> > > >  /* ----------------------------------------------------------------------- */
> > > >  
> > > >  static const struct v4l2_ctrl_ops tvp5150_ctrl_ops = {
> > > > @@ -1368,6 +1563,10 @@ static const struct v4l2_subdev_ops tvp5150_ops = {
> > > >  	.pad = &tvp5150_pad_ops,
> > > >  };
> > > >  
> > > > +static const struct v4l2_subdev_internal_ops tvp5150_internal_ops = {
> > > > +	.registered = tvp5150_registered,
> > > > +};
> > > > +
> > > >  /****************************************************************************
> > > >  			I2C Client & Driver
> > > >   ****************************************************************************/
> > > > @@ -1516,38 +1715,186 @@ static int tvp5150_init(struct i2c_client *c)
> > > >  	return 0;
> > > >  }
> > > >  
> > > > -static int tvp5150_parse_dt(struct tvp5150 *decoder, struct device_node *np)
> > > > +static int tvp5150_mc_init(struct v4l2_subdev *sd)
> > > >  {
> > > > -	struct v4l2_fwnode_endpoint bus_cfg;
> > > > -	struct device_node *ep;
> > > > -	unsigned int flags;
> > > > -	int ret = 0;
> > > > +#if defined(CONFIG_MEDIA_CONTROLLER)
> > > > +	struct tvp5150 *decoder = to_tvp5150(sd);
> > > > +	struct device *dev = decoder->sd.dev;
> > > > +	unsigned int i;
> > > > +	int ret;
> > > >  
> > > > -	ep = of_graph_get_next_endpoint(np, NULL);
> > > > -	if (!ep)
> > > > -		return -EINVAL;
> > > > +	sd->entity.ops = &tvp5150_sd_media_ops;
> > > > +	sd->entity.function = MEDIA_ENT_F_ATV_DECODER;
> > > >  
> > > > -	ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(ep), &bus_cfg);
> > > > -	if (ret)
> > > > -		goto err;
> > > > +	/* Initialize all TVP5150 pads */
> > > > +	for (i = 0; i < TVP5150_NUM_PADS; i++) {
> > > > +		if (i < TVP5150_NUM_PADS - 1) {
> > > > +			decoder->pads[i].flags = MEDIA_PAD_FL_SINK;
> > > > +			decoder->pads[i].sig_type = PAD_SIGNAL_ANALOG;
> > > > +		} else {
> > > > +			decoder->pads[i].flags = MEDIA_PAD_FL_SOURCE;
> > > > +			decoder->pads[i].sig_type = PAD_SIGNAL_DV;
> > > > +		}
> > > > +	}
> > > > +	ret = media_entity_pads_init(&sd->entity, TVP5150_NUM_PADS,
> > > > +				     decoder->pads);
> > > > +	if (ret < 0)
> > > > +		return ret;
> > > > +
> > > > +	/* in case of no oftree support */
> > > > +	if (!decoder->endpoints[0])
> > > > +		return 0;  
> > > 
> > > Hmm...
> > >   
> > > > +
> > > > +	/* Allocate and initialize all available input connectors */
> > > > +	decoder->connectors = devm_kcalloc(dev, decoder->connectors_num,
> > > > +					   sizeof(*decoder->connectors),
> > > > +					   GFP_KERNEL);
> > > > +	if (!decoder->connectors)
> > > > +		return -ENOMEM;
> > > > +
> > > > +	for (i = 0; i < decoder->connectors_num; i++) {
> > > > +		struct device_node *rp;
> > > > +		struct of_endpoint ep;
> > > > +
> > > > +		rp = of_graph_get_remote_port_parent(decoder->endpoints[i]);
> > > > +		of_graph_parse_endpoint(decoder->endpoints[i], &ep);
> > > > +		decoder->connectors[i].port_num = ep.port;
> > > > +		decoder->connectors[i].is_svideo = !!of_device_is_compatible(rp,
> > > > +							    "svideo-connector");
> > > > +
> > > > +		if (decoder->connectors[i].is_svideo)
> > > > +			decoder->connectors[i].ent.function =
> > > > +						MEDIA_ENT_F_CONN_SVIDEO;
> > > > +		else
> > > > +			decoder->connectors[i].ent.function =
> > > > +						MEDIA_ENT_F_CONN_COMPOSITE;
> > > > +
> > > > +		decoder->connectors[i].ent.flags = MEDIA_ENT_FL_CONNECTOR;
> > > > +		ret = of_property_read_string(rp, "label",
> > > > +					      &decoder->connectors[i].ent.name);
> > > > +		if (ret < 0)
> > > > +			return ret;  
> > > 
> > > I would prefer, instead, to have a separate routine for OF. I'll probably
> > > use something like the above for the non-DT devices (e. g. the ones using
> > > em28xx driver).  
> > 
> > Okay, I refactored it.
> > 
> > >   
> > > > +	}
> > > > +#endif
> > > > +	return 0;
> > > > +}
> > > > +
> > > > +static bool tvp5150_valid_input(struct device_node *endpoint,
> > > > +				unsigned int port, unsigned int id)  
> > > 
> > > Please call it as tvp5150_of_valid_input(). We may need something similar
> > > for devices based on em28xx (passing info via platform_data).  
> > 
> > Okay, I changed it.
> > 
> > >   
> > > > +{
> > > > +	struct device_node *rp = of_graph_get_remote_port_parent(endpoint);
> > > > +	const char *input;
> > > > +	int ret;
> > > > +
> > > > +	/* perform some basic checks needed for later mc_init */
> > > > +	switch (port) {
> > > > +	case TVP5150_PAD_AIP1A:
> > > > +		/* svideo must be connected to endpoint@1  */
> > > > +		ret = id ? of_device_is_compatible(rp, "svideo-connector") :
> > > > +			   of_device_is_compatible(rp, "composite-video-connector");
> > > > +		if (!ret)
> > > > +			return false;
> > > > +		break;
> > > > +	case TVP5150_PAD_AIP1B:
> > > > +		ret = of_device_is_compatible(rp, "composite-video-connector");
> > > > +		if (!ret)
> > > > +			return false;
> > > > +		break;
> > > > +	}
> > > > +
> > > > +	ret = of_property_read_string(rp, "label", &input);
> > > > +	if (ret < 0)
> > > > +		return false;
> > > > +
> > > > +	return true;
> > > > +}
> > > >  
> > > > -	flags = bus_cfg.bus.parallel.flags;
> > > > +static int tvp5150_parse_dt(struct tvp5150 *decoder, struct device_node *np)
> > > > +{
> > > > +	struct device *dev = decoder->sd.dev;
> > > > +	struct v4l2_fwnode_endpoint bus_cfg;
> > > > +	struct device_node *ep_np;
> > > > +	unsigned int flags;
> > > > +	int ret, i = 0, in = 0;
> > > > +	bool found = false;
> > > >  
> > > > -	if (bus_cfg.bus_type == V4L2_MBUS_PARALLEL &&
> > > > -	    !(flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH &&
> > > > -	      flags & V4L2_MBUS_VSYNC_ACTIVE_HIGH &&
> > > > -	      flags & V4L2_MBUS_FIELD_EVEN_LOW)) {
> > > > +	/* at least 1 output and 1 input */
> > > > +	decoder->endpoints_num = of_graph_get_endpoint_count(np);
> > > > +	if (decoder->endpoints_num < 2 || decoder->endpoints_num > 4) {
> > > >  		ret = -EINVAL;
> > > >  		goto err;
> > > >  	}
> > > >  
> > > > -	decoder->mbus_type = bus_cfg.bus_type;
> > > > +	for_each_endpoint_of_node(np, ep_np) {
> > > > +		struct of_endpoint ep;
> > > >  
> > > > +		of_graph_parse_endpoint(ep_np, &ep);
> > > > +		if (decoder->endpoints[i]) {
> > > > +			/* this should never happen */
> > > > +			dev_err(dev, "Invalid endpoint %pOF on port %d\n",
> > > > +				ep.local_node, ep.port);
> > > > +				ret = -EINVAL;
> > > > +				goto err;
> > > > +		}
> > > > +
> > > > +		switch (ep.port) {
> > > > +		case TVP5150_PAD_AIP1A:
> > > > +		case TVP5150_PAD_AIP1B:
> > > > +			if (!tvp5150_valid_input(ep_np, ep.port, ep.id)) {
> > > > +				dev_err(dev,
> > > > +					"Invalid endpoint %pOF on port %d\n",
> > > > +					ep.local_node, ep.port);
> > > > +				ret = -EINVAL;
> > > > +				goto err;
> > > > +			}
> > > > +			in++;
> > > > +			break;
> > > > +		case TVP5150_PAD_VID_OUT:
> > > > +			ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(ep_np),
> > > > +							 &bus_cfg);
> > > > +			if (ret)
> > > > +				goto err;
> > > > +
> > > > +			flags = bus_cfg.bus.parallel.flags;
> > > > +
> > > > +			if (bus_cfg.bus_type == V4L2_MBUS_PARALLEL &&
> > > > +			    !(flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH &&
> > > > +			      flags & V4L2_MBUS_VSYNC_ACTIVE_HIGH &&
> > > > +			      flags & V4L2_MBUS_FIELD_EVEN_LOW)) {
> > > > +				ret = -EINVAL;
> > > > +				goto err;
> > > > +			}
> > > > +
> > > > +			decoder->mbus_type = bus_cfg.bus_type;
> > > > +			break;
> > > > +		default:
> > > > +			dev_err(dev, "Invalid port %d for endpoint %pOF\n",
> > > > +				ep.port, ep.local_node);
> > > > +			ret = -EINVAL;
> > > > +			goto err;
> > > > +		}
> > > > +
> > > > +		of_node_get(ep_np);
> > > > +		decoder->endpoints[i] = ep_np;
> > > > +		i++;
> > > > +
> > > > +		found = true;
> > > > +	}
> > > > +
> > > > +	decoder->connectors_num = in;
> > > > +	return found ? 0 : -ENODEV;
> > > >  err:
> > > > -	of_node_put(ep);
> > > >  	return ret;
> > > >  }
> > > >  
> > > > +static void tvp5150_dt_cleanup(struct tvp5150 *decoder)
> > > > +{
> > > > +	unsigned int i;
> > > > +
> > > > +	for (i = 0; i < TVP5150_NUM_PADS; i++)
> > > > +		of_node_put(decoder->endpoints[i]);
> > > > +}
> > > > +
> > > >  static const char * const tvp5150_test_patterns[2] = {
> > > >  	"Disabled",
> > > >  	"Black screen"
> > > > @@ -1586,7 +1933,7 @@ static int tvp5150_probe(struct i2c_client *c,
> > > >  		res = tvp5150_parse_dt(core, np);
> > > >  		if (res) {
> > > >  			dev_err(sd->dev, "DT parsing error: %d\n", res);
> > > > -			return res;
> > > > +			goto err_cleanup_dt;
> > > >  		}
> > > >  	} else {
> > > >  		/* Default to BT.656 embedded sync */
> > > > @@ -1594,25 +1941,16 @@ static int tvp5150_probe(struct i2c_client *c,
> > > >  	}
> > > >  
> > > >  	v4l2_i2c_subdev_init(sd, c, &tvp5150_ops);
> > > > +	sd->internal_ops = &tvp5150_internal_ops;
> > > >  	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> > > >  
> > > > -#if defined(CONFIG_MEDIA_CONTROLLER)
> > > > -	core->pads[TVP5150_PAD_IF_INPUT].flags = MEDIA_PAD_FL_SINK;
> > > > -	core->pads[TVP5150_PAD_IF_INPUT].sig_type = PAD_SIGNAL_ANALOG;
> > > > -	core->pads[TVP5150_PAD_VID_OUT].flags = MEDIA_PAD_FL_SOURCE;
> > > > -	core->pads[TVP5150_PAD_VID_OUT].sig_type = PAD_SIGNAL_DV;
> > > > -
> > > > -	sd->entity.function = MEDIA_ENT_F_ATV_DECODER;
> > > > -
> > > > -	res = media_entity_pads_init(&sd->entity, TVP5150_NUM_PADS, core->pads);
> > > > -	if (res < 0)
> > > > -		return res;
> > > > -
> > > > -#endif
> > > > +	res = tvp5150_mc_init(sd);
> > > > +	if (res)
> > > > +		goto err_cleanup_dt;
> > > >  
> > > >  	res = tvp5150_detect_version(core);
> > > >  	if (res < 0)
> > > > -		return res;
> > > > +		goto err_cleanup_dt;
> > > >  
> > > >  	core->norm = V4L2_STD_ALL;	/* Default is autodetect */
> > > >  	core->detected_norm = V4L2_STD_UNKNOWN;
> > > > @@ -1664,6 +2002,9 @@ static int tvp5150_probe(struct i2c_client *c,
> > > >  err:
> > > >  	v4l2_ctrl_handler_free(&core->hdl);
> > > >  	return res;
> > > > +err_cleanup_dt:
> > > > +	tvp5150_dt_cleanup(core);
> > > > +	return res;
> > > >  }
> > > >  
> > > >  static int tvp5150_remove(struct i2c_client *c)  
> > > 
> > > 
> > > 
> > > Thanks,
> > > Mauro  
> > 
> > Regards,
> > Marco
> 
> 
> 
> Thanks,
> Mauro

Regards,
Marco
