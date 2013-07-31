Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46322 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759675Ab3GaPGY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Jul 2013 11:06:24 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Katsuya MATSUBARA <matsu@igel.co.jp>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: [PATCH v3 1/5] media: Add support for circular graph traversal
Date: Wed, 31 Jul 2013 17:07:26 +0200
Message-ID: <4169977.nJNdNMYhKG@avalon>
In-Reply-To: <20130725135446.GI12281@valkosipuli.retiisi.org.uk>
References: <1374757213-20194-1-git-send-email-laurent.pinchart@ideasonboard.com> <1374757213-20194-2-git-send-email-laurent.pinchart@ideasonboard.com> <20130725135446.GI12281@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the review.

On Thursday 25 July 2013 16:54:46 Sakari Ailus wrote:
> On Thu, Jul 25, 2013 at 03:00:09PM +0200, Laurent Pinchart wrote:
> > From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> > 
> > The graph traversal API (media_entity_graph_walk_*) doesn't support
> > cyclic graphs and will fail to correctly walk a graph when circular
> > links exist. Support circular graph traversal by checking whether an
> > entity has already been visited before pushing it to the stack.
> > 
> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>
> > ---
> > 
> >  drivers/media/media-entity.c | 14 +++++++++++---
> >  include/media/media-entity.h |  3 +++
> >  2 files changed, 14 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> > index cb30ffb..2c286c3 100644
> > --- a/drivers/media/media-entity.c
> > +++ b/drivers/media/media-entity.c
> > @@ -20,6 +20,7 @@
> >   * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 
> >   USA
> >   */
> > +#include <linux/bitmap.h>
> >  #include <linux/module.h>
> >  #include <linux/slab.h>
> >  #include <media/media-entity.h>
> > @@ -121,7 +122,6 @@ static struct media_entity *stack_pop(struct
> > media_entity_graph *graph)> 
> >  	return entity;
> >  }
> > 
> > -#define stack_peek(en)	((en)->stack[(en)->top - 1].entity)
> >  #define link_top(en)	((en)->stack[(en)->top].link)
> >  #define stack_top(en)	((en)->stack[(en)->top].entity)
> > 
> > @@ -140,6 +140,12 @@ void media_entity_graph_walk_start(struct
> > media_entity_graph *graph,> 
> >  {
> >  	graph->top = 0;
> >  	graph->stack[graph->top].entity = NULL;
> > +	bitmap_zero(graph->entities, MEDIA_ENTITY_ENUM_MAX_ID);
> > +
> > +	if (WARN_ON(entity->id >= MEDIA_ENTITY_ENUM_MAX_ID))
> > +		return;
> > +
> > +	__set_bit(entity->id, graph->entities);
> >  	stack_push(graph, entity);
> >  }
> >  EXPORT_SYMBOL_GPL(media_entity_graph_walk_start);
> > @@ -180,9 +186,11 @@ media_entity_graph_walk_next(struct
> > media_entity_graph *graph)> 
> >  		/* Get the entity in the other end of the link . */
> >  		next = media_entity_other(entity, link);
> > 
> > +		if (WARN_ON(next->id >= MEDIA_ENTITY_ENUM_MAX_ID))
> > +			return NULL;
> 
> Walking the graph will take the mutex anyway, so I don't think this can
> happen.

Can't it happen if a driver registers more than MEDIA_ENTITY_ENUM_MAX_ID 
entities ?

> > -		/* Was it the entity we came here from? */
> > -		if (next == stack_peek(graph)) {
> > +		/* Has the entity already been visited? */
> > +		if (__test_and_set_bit(next->id, graph->entities)) {
> >  			link_top(graph)++;
> >  			continue;
> >  		}
> > diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> > index 06bacf9..0b39662 100644
> > --- a/include/media/media-entity.h
> > +++ b/include/media/media-entity.h
> > @@ -23,6 +23,7 @@
> >  #ifndef _MEDIA_ENTITY_H
> >  #define _MEDIA_ENTITY_H
> > 
> > +#include <linux/bitops.h>
> >  #include <linux/list.h>
> >  #include <linux/media.h>
> > 
> > @@ -113,12 +114,14 @@ static inline u32 media_entity_subtype(struct
> > media_entity *entity)> 
> >  }
> >  
> >  #define MEDIA_ENTITY_ENUM_MAX_DEPTH	16
> > +#define MEDIA_ENTITY_ENUM_MAX_ID	64
> > 
> >  struct media_entity_graph {
> >  	struct {
> >  		struct media_entity *entity;
> >  		int link;
> >  	} stack[MEDIA_ENTITY_ENUM_MAX_DEPTH];
> > 
> > +	unsigned long entities[BITS_TO_LONGS(MEDIA_ENTITY_ENUM_MAX_ID)];
> 
> How about using DECLARE_BITMAP() instead?

Good idea, I'll fix that.

> >  	int top;
> >  
> >  };
-- 
Regards,

Laurent Pinchart

