Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53315 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053Ab3GXOIR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jul 2013 10:08:17 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v2 1/5] media: Fix circular graph traversal
Date: Wed, 24 Jul 2013 16:09:09 +0200
Message-ID: <2101153.GOPGx1zmjS@avalon>
In-Reply-To: <20130718102209.GA11823@valkosipuli.retiisi.org.uk>
References: <1374072882-14598-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1592849.BGn9Ftusvr@avalon> <20130718102209.GA11823@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Thursday 18 July 2013 13:22:09 Sakari Ailus wrote:
> On Thu, Jul 18, 2013 at 01:06:40AM +0200, Laurent Pinchart wrote:
> > On Wednesday 17 July 2013 22:47:03 Sakari Ailus wrote:
> > > On Wed, Jul 17, 2013 at 04:54:38PM +0200, Laurent Pinchart wrote:
> > > > The graph traversal API (media_entity_graph_walk_*) will fail to
> > > > correctly walk the graph when circular links exist. Fix it by checking
> > > > whether an entity is already present in the stack before pushing it.
> > > 
> > > We never had any multiply connected graphs (ignoring direction, nor
> > > supported them) before. So this is rather a patch that adds support for
> > > those instead of fixing it. :-)
> > 
> > Good point, I'll add support for your comment to the commit message :-D
> > 
> > > > Signed-off-by: Laurent Pinchart
> > > > <laurent.pinchart+renesas@ideasonboard.com>
> > > > ---
> > > > 
> > > >  drivers/media/media-entity.c | 17 ++++++++++++-----
> > > >  1 file changed, 12 insertions(+), 5 deletions(-)
> > > > 
> > > > diff --git a/drivers/media/media-entity.c
> > > > b/drivers/media/media-entity.c
> > > > index cb30ffb..c8aba5e 100644
> > > > --- a/drivers/media/media-entity.c
> > > > +++ b/drivers/media/media-entity.c
> > > > @@ -121,9 +121,9 @@ static struct media_entity *stack_pop(struct
> > > > media_entity_graph *graph)
> > > > 
> > > >  	return entity;
> > > >  
> > > >  }
> > > > 
> > > > -#define stack_peek(en)	((en)->stack[(en)->top - 1].entity)
> > > > -#define link_top(en)	((en)->stack[(en)->top].link)
> > > > -#define stack_top(en)	((en)->stack[(en)->top].entity)
> > > > +#define stack_peek(en, i)	((en)->stack[i].entity)
> > > > +#define link_top(en)		((en)->stack[(en)->top].link)
> > > > +#define stack_top(en)		((en)->stack[(en)->top].entity)
> > > > 
> > > >  /**
> > > >  
> > > >   * media_entity_graph_walk_start - Start walking the media graph at a
> > > >   given entity>
> > > > 
> > > > @@ -159,6 +159,8 @@ EXPORT_SYMBOL_GPL(media_entity_graph_walk_start);
> > > > 
> > > >  struct media_entity *
> > > >  media_entity_graph_walk_next(struct media_entity_graph *graph)
> > > >  {
> > > > 
> > > > +	unsigned int i;
> > > > +
> > > > 
> > > >  	if (stack_top(graph) == NULL)
> > > >  	
> > > >  		return NULL;
> > > > 
> > > > @@ -181,8 +183,13 @@ media_entity_graph_walk_next(struct
> > > > media_entity_graph *graph)>
> > > > 
> > > >  		/* Get the entity in the other end of the link . */
> > > >  		next = media_entity_other(entity, link);
> > > > 
> > > > -		/* Was it the entity we came here from? */
> > > > -		if (next == stack_peek(graph)) {
> > > > +		/* Is the entity already in the path? */
> > > > +		for (i = 1; i < graph->top; ++i) {
> > > > +			if (next == stack_peek(graph, i))
> > > > +				break;
> > > > +		}
> > > > +
> > > > +		if (i < graph->top) {
> > > > 
> > > >  			link_top(graph)++;
> > > >  			continue;
> > > >  		
> > > >  		}
> > > 
> > > I think you should also ensure a node in the graph hasn't been
> > > enumerated in the past; otherwise it's possible to do that multiple
> > > times in a multiply connected graph.
> > 
> > I'm not sure to follow you here, could you please elaborate ?
> 
> Depth-first search in a multiply connected graph must avoid finding again
> the same nodes. As we didn't have multiply connected graphs, the only thing
> that was necessary was to avoid going back exactly the same route that the
> search came from.
> 
> In a multiply connected graph a node can be reached through multiple paths.
> This means that instead of avoiding to go back where we came from (either
> the previous node or the full stack), we must avoid finding again the same
> nodes we've found previously.

Indeed, I somehow managed to overlook the issue. That's not really a problem 
in my case, as circular graphs are not supported by my hardware, but a generic 
solution is indeed needed.

> > > How about using a bit field that contained as many bits as there were
> > > entities? It's also faster to check for a single bit than loop over the
> > > whole path for each entity, which certainly will start showing in
> > > execution time with these link numbres.
> > 
> > That's possible, yes. We would then need to dynamically allocate the bit
> > field in the start function, and add a new media_entity_graph_walk_end()
> > function (I would then rename media_entity_graph_walk_start() to
> > media_entity_graph_walk_begin()) to free the bit field. If you think
> > that's worth it I can give it a try.
> 
> Do you think we could define a maximum number of entities? It can be
> increased if any driver happens to need more. I'd be more comfortable in
> doing the allocation in the stack that way: the number will be relatively
> small in any case, say, 32 or 64 bits for which kzalloc() would be overkill.

This should work for now, but I'm a bit concerned that it would break in the 
future if we introduce dynamic entity (un)registration. In that case the 
maximum number of entities could be capped, but the IDs will increase.

-- 
Regards,

Laurent Pinchart

