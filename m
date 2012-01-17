Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:45871 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086Ab2AQUKD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Jan 2012 15:10:03 -0500
Date: Tue, 17 Jan 2012 22:09:58 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	teturtia@gmail.com, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@gmail.com, riverful@gmail.com
Subject: Re: [PATCH 16/23] media: Add link_validate op to check links to
 the sink pad
Message-ID: <20120117200958.GE13236@valkosipuli.localdomain>
References: <4F0DFE92.80102@iki.fi>
 <1326317220-15339-16-git-send-email-sakari.ailus@iki.fi>
 <201201161535.08191.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201201161535.08191.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the review.

On Mon, Jan 16, 2012 at 03:35:07PM +0100, Laurent Pinchart wrote:
> On Wednesday 11 January 2012 22:26:53 Sakari Ailus wrote:
> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > ---
> >  drivers/media/media-entity.c |   73
> > ++++++++++++++++++++++++++++++++++++++++- include/media/media-entity.h |  
> >  5 ++-
> >  2 files changed, 74 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> > index 056138f..62ef4b8 100644
> > --- a/drivers/media/media-entity.c
> > +++ b/drivers/media/media-entity.c
> > @@ -196,6 +196,35 @@ media_entity_graph_walk_next(struct media_entity_graph
> > *graph) }
> >  EXPORT_SYMBOL_GPL(media_entity_graph_walk_next);
> > 
> > +struct media_link_enum {
> > +	int i;
> > +	struct media_entity *entity;
> > +	unsigned long flags, mask;
> > +};
> > +
> > +static struct media_link
> > +*media_link_walk_next(struct media_link_enum *link_enum)
> > +{
> > +	do {
> > +		link_enum->i++;
> > +		if (link_enum->i >= link_enum->entity->num_links)
> > +			return NULL;
> > +	} while ((link_enum->entity->links[link_enum->i].flags
> > +		  & link_enum->mask) != link_enum->flags);
> > +
> > +	return &link_enum->entity->links[link_enum->i];
> > +}
> > +
> > +static void media_link_walk_start(struct media_link_enum *link_enum,
> > +				  struct media_entity *entity,
> > +				  unsigned long flags, unsigned long mask)
> > +{
> > +	link_enum->i = -1;
> > +	link_enum->entity = entity;
> > +	link_enum->flags = flags;
> > +	link_enum->mask = mask;
> > +}
> 
> Do we really need a generic link walking code for a single user ? Merging this 
> in the function below would result in much simpler code.

It's a single funcition but it's being used from two locations in it. I
would keep it as-is, since performing the same in the function itself would
much complicate it.

> > +
> >  /*
> > --------------------------------------------------------------------------
> > --- * Pipeline management
> >   */
> > @@ -214,23 +243,63 @@ EXPORT_SYMBOL_GPL(media_entity_graph_walk_next);
> >   * pipeline pointer must be identical for all nested calls to
> >   * media_entity_pipeline_start().
> >   */
> > -void media_entity_pipeline_start(struct media_entity *entity,
> > -				 struct media_pipeline *pipe)
> > +__must_check int media_entity_pipeline_start(struct media_entity *entity,
> > +					     struct media_pipeline *pipe)
> >  {
> >  	struct media_device *mdev = entity->parent;
> >  	struct media_entity_graph graph;
> > +	struct media_entity *tmp = entity;
> > +	int ret = 0;
> > 
> >  	mutex_lock(&mdev->graph_mutex);
> > 
> >  	media_entity_graph_walk_start(&graph, entity);
> > 
> >  	while ((entity = media_entity_graph_walk_next(&graph))) {
> > +		struct media_entity_graph tmp_graph;
> > +		struct media_link_enum link_enum;
> > +		struct media_link *link;
> > +
> >  		entity->stream_count++;
> >  		WARN_ON(entity->pipe && entity->pipe != pipe);
> >  		entity->pipe = pipe;
> > +
> > +		if (!entity->ops || !entity->ops->link_validate)
> > +			continue;
> > +
> > +		media_link_walk_start(&link_enum, entity,
> > +				      MEDIA_LNK_FL_ENABLED,
> > +				      MEDIA_LNK_FL_ENABLED);
> > +
> > +		while ((link = media_link_walk_next(&link_enum))) {
> > +			if (link->sink->entity != entity)
> > +				continue;
> > +
> > +			ret = entity->ops->link_validate(link);
> > +			if (ret < 0 && ret != -ENOIOCTLCMD)
> > +				break;
> > +		}
> > +		if (!ret || ret == -ENOIOCTLCMD)
> > +			continue;
> 
> What about a goto error instead ? That would keep the error code out of the 
> loop.

Fixed.

> > +
> > +		/*
> > +		 * Link validation on graph failed. We revert what we
> > +		 * did and return the error.
> > +		 */
> > +		media_entity_graph_walk_start(&tmp_graph, tmp);
> 
> I've never liked tmp as a variable name. As the graph variable isn't used 
> anymore from this point on, you can reuse it. tmp can then be renamed to 
> something more descriptive.

I re-use graph, and tmp is called entity_err now.

> > +		do {
> > +			tmp = media_entity_graph_walk_next(&tmp_graph);
> > +			tmp->stream_count--;
> > +			if (entity->stream_count == 0)
> > +				entity->pipe = NULL;
> > +		} while (tmp != entity);
> > +
> > +		break;
> >  	}
> > 
> >  	mutex_unlock(&mdev->graph_mutex);
> > +
> > +	return ret == 0 || ret == -ENOIOCTLCMD ? 0 : ret;
> >  }
> >  EXPORT_SYMBOL_GPL(media_entity_pipeline_start);
> > 
> > diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> > index cd8bca6..f7ba80a 100644
> > --- a/include/media/media-entity.h
> > +++ b/include/media/media-entity.h
> > @@ -46,6 +46,7 @@ struct media_entity_operations {
> >  	int (*link_setup)(struct media_entity *entity,
> >  			  const struct media_pad *local,
> >  			  const struct media_pad *remote, u32 flags);
> > +	int (*link_validate)(struct media_link *link);
> 
> What about documenting the operation in Documentation/media-framework.txt ?

Yup.

---
Link validation
---------------

Link validation is performed from media_entity_pipeline_start() for any
entity which has sink pads in the pipeline. The
media_entity::link_validate() callback is used for that purpose. In
link_validate() callback, the entity driver should check that the properties
of the source pad of the connected entity and its own sink pad match.
---

> >  };
> > 
> >  struct media_entity {
> > @@ -140,8 +141,8 @@ void media_entity_graph_walk_start(struct
> > media_entity_graph *graph, struct media_entity *entity);
> >  struct media_entity *
> >  media_entity_graph_walk_next(struct media_entity_graph *graph);
> > -void media_entity_pipeline_start(struct media_entity *entity,
> > -		struct media_pipeline *pipe);
> > +__must_check int media_entity_pipeline_start(struct media_entity *entity,
> > +					     struct media_pipeline *pipe);
> 
> As well as keeping the media_entity_pipeline_start() documentation up-to-date 
> in the same file :-)

Added a note it may return an error.

Cheers,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
