Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f41.google.com ([209.85.215.41]:36585 "EHLO
        mail-lf0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757366AbdEXOKA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 24 May 2017 10:10:00 -0400
Received: by mail-lf0-f41.google.com with SMTP id h4so68278381lfj.3
        for <linux-media@vger.kernel.org>; Wed, 24 May 2017 07:09:59 -0700 (PDT)
Date: Wed, 24 May 2017 16:09:55 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH v2 2/2] media: entity: Add media_entity_pad_from_fwnode()
 function
Message-ID: <20170524140955.GC7346@bigcity.dyn.berto.se>
References: <20170524000907.13061-1-niklas.soderlund@ragnatech.se>
 <20170524000907.13061-3-niklas.soderlund@ragnatech.se>
 <20170524132741.GL29527@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170524132741.GL29527@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for your feedback.

On 2017-05-24 16:27:42 +0300, Sakari Ailus wrote:
> Hi Niklas,
> 
> On Wed, May 24, 2017 at 02:09:07AM +0200, Niklas Söderlund wrote:
> > From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > 
> > This is a wrapper around the media entity pad_from_fwnode operation.
> > 
> > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > ---
> >  drivers/media/media-entity.c | 39 +++++++++++++++++++++++++++++++++++++++
> >  include/media/media-entity.h | 22 ++++++++++++++++++++++
> >  2 files changed, 61 insertions(+)
> > 
> > diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> > index bc44193efa4798b4..c124754f739a8b94 100644
> > --- a/drivers/media/media-entity.c
> > +++ b/drivers/media/media-entity.c
> > @@ -18,6 +18,7 @@
> >  
> >  #include <linux/bitmap.h>
> >  #include <linux/module.h>
> > +#include <linux/property.h>
> >  #include <linux/slab.h>
> >  #include <media/media-entity.h>
> >  #include <media/media-device.h>
> > @@ -386,6 +387,44 @@ struct media_entity *media_graph_walk_next(struct media_graph *graph)
> >  }
> >  EXPORT_SYMBOL_GPL(media_graph_walk_next);
> >  
> > +int media_entity_pad_from_fwnode(struct media_entity *entity,
> > +				 struct fwnode_handle *fwnode,
> > +				 int direction, unsigned int *pad)
> > +{
> > +	struct fwnode_endpoint endpoint;
> > +	int i, tmp, ret;
> > +
> > +	if (!entity->ops || !entity->ops->pad_from_fwnode) {
> > +		for (i = 0; i < entity->num_pads; i++) {
> > +			if (entity->pads[i].flags & direction) {
> > +				*pad = i;
> > +				return 0;
> > +			}
> > +		}
> > +
> > +		return -ENXIO;
> > +	}
> > +
> > +	ret = fwnode_graph_parse_endpoint(fwnode, &endpoint);
> > +	if (ret)
> > +		return ret;
> > +
> > +	ret = entity->ops->pad_from_fwnode(&endpoint, &tmp);
> > +	if (ret)
> > +		return ret;
> > +
> > +	if (tmp >= entity->num_pads)
> > +		return -ENXIO;
> > +
> > +	if (!(entity->pads[tmp].flags & direction))
> > +		return -ENXIO;
> > +
> > +	*pad = tmp;
> > +
> > +	return 0;
> 
> I'd just return the pad number to the caller.

Depending on if there is any comments about this in the previous patch I 
switch to returning an int from this function, where a negative value 
would signal an error.

> 
> > +}
> > +EXPORT_SYMBOL_GPL(media_entity_pad_from_fwnode);
> > +
> >  /* -----------------------------------------------------------------------------
> >   * Pipeline management
> >   */
> > diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> > index 2aea22b0409d1070..7507181609bec43c 100644
> > --- a/include/media/media-entity.h
> > +++ b/include/media/media-entity.h
> > @@ -822,6 +822,28 @@ struct media_pad *media_entity_remote_pad(struct media_pad *pad);
> >  struct media_entity *media_entity_get(struct media_entity *entity);
> >  
> >  /**
> > + * media_entity_pad_from_fwnode - Get pad number from fwnode
> > + *
> > + * @entity: The entity
> > + * @fwnode: Pointer to fwnode_handle which should be used to find pad
> > + * @direction: Expected direction of the pad
> 
> You should document the possible values for this. What would you think about
> using a bool called e.g. is_sink? I don't have a strong opinion either way
> though.

Thanks, I think it is better to add documentation about possible values 
here. If no one else disagrees whit this I will do so in the next 
version.

> 
> > + * @pad: Pointer to pad which will should be filled in
> > + *
> > + * This function can be used to resolve the media pad number from
> > + * a fwnode. This is useful for devices which uses more complex
> > + * mappings of media pads.
> > + *
> > + * If the entity do not implement the pad_from_fwnode() operation
> > + * this function searches the entity for the first pad that matches
> > + * the @direction.
> > + *
> > + * Return: return 0 on success.
> > + */
> > +int media_entity_pad_from_fwnode(struct media_entity *entity,
> > +				 struct fwnode_handle *fwnode,
> > +				 int direction, unsigned int *pad);
> > +
> > +/**
> >   * media_graph_walk_init - Allocate resources used by graph walk.
> >   *
> >   * @graph: Media graph structure that will be used to walk the graph
> 
> -- 
> Regards,
> 
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk

-- 
Regards,
Niklas Söderlund
