Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53210 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1425880AbdD1NKo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Apr 2017 09:10:44 -0400
Date: Fri, 28 Apr 2017 16:10:10 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 2/2] media: entity: Add media_entity_pad_from_dt_regs()
 function
Message-ID: <20170428131010.GJ7456@valkosipuli.retiisi.org.uk>
References: <20170427223323.13861-1-niklas.soderlund+renesas@ragnatech.se>
 <20170427223323.13861-3-niklas.soderlund+renesas@ragnatech.se>
 <20170428104339.GH7456@valkosipuli.retiisi.org.uk>
 <20170428120414.GE1532@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170428120414.GE1532@bigcity.dyn.berto.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hej, Niklas!

On Fri, Apr 28, 2017 at 02:04:15PM +0200, Niklas Söderlund wrote:
> Hej,
> 
> Thanks for your feedback.
> 
> On 2017-04-28 13:43:39 +0300, Sakari Ailus wrote:
> > Hejssan!!!
> > 
> > On Fri, Apr 28, 2017 at 12:33:23AM +0200, Niklas Söderlund wrote:
> > > This is a wrapper around the media entity pad_from_dt_regs operation.
> > > 
> > > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > > ---
> > >  drivers/media/media-entity.c | 21 +++++++++++++++++++++
> > >  include/media/media-entity.h | 22 ++++++++++++++++++++++
> > >  2 files changed, 43 insertions(+)
> > > 
> > > diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> > > index 5640ca29da8c9bbc..6ef76186d552724e 100644
> > > --- a/drivers/media/media-entity.c
> > > +++ b/drivers/media/media-entity.c
> > > @@ -386,6 +386,27 @@ struct media_entity *media_graph_walk_next(struct media_graph *graph)
> > >  }
> > >  EXPORT_SYMBOL_GPL(media_graph_walk_next);
> > >  
> > > +int media_entity_pad_from_dt_regs(struct media_entity *entity,
> > > +				  int port_reg, int reg, unsigned int *pad)
> > > +{
> > > +	int ret;
> > > +
> > > +	if (!entity->ops || !entity->ops->pad_from_dt_regs) {
> > > +		*pad = port_reg;
> > 
> > I don't think we should bind the port number in firmware to a pad in V4L2
> > sub-device interface.
> > 
> > How about looking for a source pad in the entity instead? That's what some
> > drivers do.
> 
> Sure that sounds like a nice approach, will do this for next version.
> 
> Would it make sens to extend this operation with a 'direction' parameter 
> which could take either MEDIA_PAD_FL_SOURCE or MEDIA_PAD_FL_SINK and if 
> !entity->ops->pad_from_dt_regs find the first pad that matches this 
> 'direction' and if it do exist add a check to make sure the pad that is 
> return matches that 'direction'?

If you had a transmitter in the graph it'd obviously be needed. I'm not sure
if we have any now. I'm fine with direction though, it's logical to have it.

> 
> > 
> > > +		return 0;
> > > +	}
> > > +
> > > +	ret = entity->ops->pad_from_dt_regs(port_reg, reg, pad);
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	if (*pad >= entity->num_pads)
> > > +		return -EINVAL;
> > > +
> > > +	return 0;
> > > +}
> > > +EXPORT_SYMBOL_GPL(media_entity_pad_from_dt_regs);
> > > +
> > >  /* -----------------------------------------------------------------------------
> > >   * Pipeline management
> > >   */
> > > diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> > > index 47efaf4d825e671b..c60a3713d0a21baf 100644
> > > --- a/include/media/media-entity.h
> > > +++ b/include/media/media-entity.h
> > > @@ -820,6 +820,28 @@ struct media_pad *media_entity_remote_pad(struct media_pad *pad);
> > >  struct media_entity *media_entity_get(struct media_entity *entity);
> > >  
> > >  /**
> > > + * media_entity_pad_from_dt_regs - Get pad number from DT regs
> > > + *
> > > + * @entity: The entity
> > > + * @port_reg: DT port
> > > + * @reg: DT reg
> > > + * @pad: Pointer to pad which will be filled in
> > > + *
> > > + * This function can be used to resolve the media pad number from
> > > + * DT port and reg numbers. This is useful for devices which
> > > + * uses more complex mappings of media pads then that the
> > > + * DT port number is equivalent to the media pad number.
> > > + *
> > > + * If the entity do not implement the pad_from_dt_regs() operation
> > > + * this function assumes DT port is equivalent to media pad number
> > > + * and sets @pad to @port_reg.
> > > + *
> > > + * Return: 0 on success else -EINVAL.
> > 
> > -EINVAL suggests the user provided bad parameters, but this isn't the case
> > here. How about e.g. -ENXIO?
> 
> 
> I reasoned that if a port_reg and reg supplied did result in a  pad 
> match the user would have given pad parameters. But sure there might be 
> cases where that assumtion might not be true. So I see no problem of 
> changing this to -ENXIO in next version.

The only case -EINVAL is returned is when the driver specific function
returns a non-existent pad number. That's a driver bug, isn't it? We don't
have a specific error code for that though. :-)

> 
> > 
> > > + */
> > > +int media_entity_pad_from_dt_regs(struct media_entity *entity,
> > > +				  int port_reg, int reg, unsigned int *pad);
> > > +
> > > +/**
> > >   * media_graph_walk_init - Allocate resources used by graph walk.
> > >   *
> > >   * @graph: Media graph structure that will be used to walk the graph
> > 

-- 
Terveisin,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
