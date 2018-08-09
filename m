Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:52882 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730634AbeHISaG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 9 Aug 2018 14:30:06 -0400
Date: Thu, 9 Aug 2018 13:04:21 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Marco Felsch <m.felsch@pengutronix.de>
Cc: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        p.zabel@pengutronix.de, afshin.nasser@gmail.com,
        javierm@redhat.com, sakari.ailus@linux.intel.com,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH 19/22] [media] tvp5150: add input source selection
 of_graph support
Message-ID: <20180809130421.5fdac04d@coco.lan>
In-Reply-To: <20180809143520.e2fwsuztfazmyl7e@pengutronix.de>
References: <20180628162054.25613-1-m.felsch@pengutronix.de>
        <20180628162054.25613-20-m.felsch@pengutronix.de>
        <20180730152938.50e69143@coco.lan>
        <20180808152949.h7mpqb7evnvqiy5n@pengutronix.de>
        <20180808155251.4062ff1f@coco.lan>
        <20180809125507.4mxopx4yowjd3zgw@pengutronix.de>
        <20180809103653.0f81de01@coco.lan>
        <20180809143520.e2fwsuztfazmyl7e@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 9 Aug 2018 16:35:20 +0200
Marco Felsch <m.felsch@pengutronix.de> escreveu:

> Hi Mauro,
> 
> Thanks for your feedback.

> > > > > +	dev_dbg(sd->dev, "link setup '%s':%d->'%s':%d[%d]",
> > > > > +		remote->entity->name, remote->index, local->entity->name,
> > > > > +		local->index, flags & MEDIA_LNK_FL_ENABLED);    
> > > > 
> > > > Hmm... the remote is the connector, right? I would switch the
> > > > print message to point from the connector to tvp5150, as this is
> > > > the signal flow.    
> > > 
> > > I don't know what you mean, I tought that's what I'm already do. If I
> > > change it it will print something like: tvp5150 2-005d :0 -> Comp0 :0[1]  
> > 
> > Hmm... then "local" actually means the connector and "remote"
> > is the tvp5150?  
> 
> Nope, local is the tvp and remote is the connector. Actual the output
> looks as follows
> 
> [   26.339939] tvp5150 2-005d: link setup 'Comp0':0->'tvp5150 2-005d':0[1]
> [   26.346606] tvp5150 2-005d: Setting 0 active [composite]
> 
> I think this is what you mean with '... point from the connector to
> tvp5150 ...'.

Yes.

> 
> >   
> > >   
> > > > 
> > > > Btw, it would likely be better to call it "connector" or "conn_entity",
> > > > to make it clearer.    
> > > 
> > > I tought remote is the common nomenclature. Also the remote mustn't be a
> > > connector. In my case it's a soldered camera. With this in mind, you think
> > > it should be still changed?  
> > 
> > I see your point.
> > 
> > Yeah, remote is a common nomenclature. Yet, as it can be seen from
> > the above comment (and your answer), common nomenclature may lead
> > in to mistakes :-)  
> 
> Yeah, I know what you mean ^^
> 
> > 
> > It would be good to have either one of sides better named (either
> > the connectors side or the tvp5150 side - or both), in order to be
> > clearer and avoid confusion of someone else touches that part of
> > the code.  
> 
> Yes, I'm with you. Since the local always points to the tvp5150, I will
> change the local to tvp5150 or tvp5150_pad. Renaming the remote isn't
> that good since it can be anything.

OK!

> 
> > 
> > In this specific case, both connectors and tvp5150 are created by
> > the tvp5150, so both are "local" in the sense that both are
> > created by this driver.
> >  
> 
> I know.. Maybe there should be a 'common' svideo-/composite-connector
> code and some helpers to create and link those. Then we can drop the
> 'local' connectors.

Yeah, that could be a good idea.

> > > > > +static int tvp5150_registered(struct v4l2_subdev *sd)
> > > > > +{
> > > > > +#ifdef CONFIG_MEDIA_CONTROLLER
> > > > > +	struct tvp5150 *decoder = to_tvp5150(sd);
> > > > > +	unsigned int i;
> > > > > +	int ret;
> > > > > +
> > > > > +	for (i = 0; i < decoder->connectors_num; i++) {
> > > > > +		struct media_entity *con = &decoder->connectors[i].ent;
> > > > > +		struct media_pad *pad = &decoder->connectors[i].pad;
> > > > > +		unsigned int port = decoder->connectors[i].port_num;
> > > > > +		bool is_svideo = decoder->connectors[i].is_svideo;
> > > > > +
> > > > > +		pad->flags = MEDIA_PAD_FL_SOURCE;
> > > > > +		ret = media_entity_pads_init(con, 1, pad);
> > > > > +		if (ret < 0)
> > > > > +			return ret;
> > > > > +
> > > > > +		ret = media_device_register_entity(sd->v4l2_dev->mdev, con);
> > > > > +		if (ret < 0)
> > > > > +			return ret;
> > > > > +
> > > > > +		ret = media_create_pad_link(con, 0, &sd->entity, port, 0);
> > > > > +		if (ret < 0) {
> > > > > +			media_device_unregister_entity(con);
> > > > > +			return ret;
> > > > > +		}
> > > > > +
> > > > > +		if (is_svideo) {
> > > > > +			/* svideo links to both aip1a and aip1b */
> > > > > +			ret = media_create_pad_link(con, 0, &sd->entity,
> > > > > +						    port + 1, 0);
> > > > > +			if (ret < 0) {
> > > > > +				media_device_unregister_entity(con);
> > > > > +				return ret;
> > > > > +			}
> > > > > +		}
> > > > > +
> > > > > +	}    
> > > > 
> > > > IMO, it should route to the first available connector.    
> > > 
> > > Did you mean to set the link status to enabled?   
> > 
> > Yes.
> >   
> > > If so I have one
> > > question else can you tell me what you mean?
> > > 
> > > Should I use the media_entity_setup_link() helper or should I mark it as
> > > enabled during media_create_pad_link()? Now I did something like:
> > > 
> > > if (i == 0) {
> > > 	list_for_each_entry(link, &con->links, list) {
> > > 		media_entity_setup_link(link, MEDIA_LNK_FL_ENABLED);
> > > 	}
> > > }  
> > 
> > yeah, I guess this should work for both the cases where the first
> > connector is a comp or a svideo input.
> > 
> > I would prefer coding it differently, e. g. something like:
> > 
> > 	
> > 	for (i = 0; i < decoder->connectors_num; i++) {
> > 		int flags = i ? 0 : MEDIA_LNK_FL_ENABLED;
> > 
> > and then use the flags var as the last argument for media_create_pad_link()
> > calls. That would avoid an extra loop and would likely reduce a little bit
> > the code size.  
> 
> Sorry for the ambiguous code example. I did the 'if (i == 0)' in the same
> loop, so no extra loop. I can do it your way, but than unnecessary
> media_entity_setup_link() are made.

I got that, but:

	list_for_each_entry(link, &con->links, list) {
		media_entity_setup_link(link, MEDIA_LNK_FL_ENABLED);
	}

would be a second loop inside it :-)

What do you mean by an unnecessary media_entity_setup_link()?

What I was thinking is something like:

	static int tvp5150_registered(struct v4l2_subdev *sd)
	{
	#ifdef CONFIG_MEDIA_CONTROLLER
		struct tvp5150 *decoder = to_tvp5150(sd);
		unsigned int i;
		int ret;

		for (i = 0; i < decoder->connectors_num; i++) {
			struct media_entity *con = &decoder->connectors[i].ent;
			struct media_pad *pad = &decoder->connectors[i].pad;
			unsigned int port = decoder->connectors[i].port_num;
			bool is_svideo = decoder->connectors[i].is_svideo;
+			int link_flags = i ? 0 : MEDIA_LNK_FL_ENABLED;

			pad->flags = MEDIA_PAD_FL_SOURCE;
			ret = media_entity_pads_init(con, 1, pad);
			if (ret < 0)
				return ret;

			ret = media_device_register_entity(sd->v4l2_dev->mdev, con);
			if (ret < 0)
				return ret;

-			ret = media_create_pad_link(con, 0, &sd->entity, port, 0);
+			ret = media_create_pad_link(con, 0, &sd->entity, port, link_flags);
			if (ret < 0) {
				media_device_unregister_entity(con);
				return ret;
			}

			if (is_svideo) {
				/* svideo links to both aip1a and aip1b */
				ret = media_create_pad_link(con, 0, &sd->entity,
-							    port + 1, 0);
+							    port + 1, link_flags);
				if (ret < 0) {
					media_device_unregister_entity(con);
					return ret;
				}
			}
		}    


Thanks,
Mauro
