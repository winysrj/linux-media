Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E93FDC43612
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 22:13:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B977E20866
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 22:13:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731989AbfAOWNK (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 15 Jan 2019 17:13:10 -0500
Received: from mga06.intel.com ([134.134.136.31]:57859 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728876AbfAOWNK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Jan 2019 17:13:10 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Jan 2019 14:13:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,483,1539673200"; 
   d="scan'208";a="114945182"
Received: from markusac-mobl.ger.corp.intel.com (HELO kekkonen.fi.intel.com) ([10.252.58.202])
  by fmsmga007.fm.intel.com with ESMTP; 15 Jan 2019 14:13:06 -0800
Received: by kekkonen.fi.intel.com (Postfix, from userid 1000)
        id A6BA621E54; Wed, 16 Jan 2019 00:13:03 +0200 (EET)
Date:   Wed, 16 Jan 2019 00:13:03 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Benoit Parrot <bparrot@ti.com>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 02/30] media: entity: Use pads instead of entities in
 the media graph walk stack
Message-ID: <20190115221302.eijpkvl7ivvijdg6@kekkonen.localdomain>
References: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
 <20181101233144.31507-3-niklas.soderlund+renesas@ragnatech.se>
 <20190115220313.GB28397@pendragon.ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190115220313.GB28397@pendragon.ideasonboard.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Laurent,

On Wed, Jan 16, 2019 at 12:03:13AM +0200, Laurent Pinchart wrote:
> Hi Niklas,
> 
> Thank you for the patch.
> 
> On Fri, Nov 02, 2018 at 12:31:16AM +0100, Niklas Söderlund wrote:
> > From: Sakari Ailus <sakari.ailus@linux.intel.com>
> > 
> > Change the media graph walk stack structure to use media pads instead of
> > using media entities. In addition to the entity, the pad contains the
> > information which pad in the entity are being dealt with.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > ---
> >  drivers/media/media-entity.c | 53 ++++++++++++++++++------------------
> >  include/media/media-entity.h |  6 ++--
> >  2 files changed, 29 insertions(+), 30 deletions(-)
> > 
> > diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> > index 2bbc07de71aa5e6d..892e64a0a9d8ec42 100644
> > --- a/drivers/media/media-entity.c
> > +++ b/drivers/media/media-entity.c
> > @@ -237,40 +237,39 @@ EXPORT_SYMBOL_GPL(media_entity_pads_init);
> >   * Graph traversal
> >   */
> >  
> > -static struct media_entity *
> > -media_entity_other(struct media_entity *entity, struct media_link *link)
> > +static struct media_pad *
> > +media_entity_other(struct media_pad *pad, struct media_link *link)
> >  {
> > -	if (link->source->entity == entity)
> > -		return link->sink->entity;
> > +	if (link->source == pad)
> > +		return link->sink;
> >  	else
> > -		return link->source->entity;
> > +		return link->source;
> >  }
> >  
> >  /* push an entity to traversal stack */
> > -static void stack_push(struct media_graph *graph,
> > -		       struct media_entity *entity)
> > +static void stack_push(struct media_graph *graph, struct media_pad *pad)
> >  {
> >  	if (graph->top == MEDIA_ENTITY_ENUM_MAX_DEPTH - 1) {
> >  		WARN_ON(1);
> >  		return;
> >  	}
> >  	graph->top++;
> > -	graph->stack[graph->top].link = entity->links.next;
> > -	graph->stack[graph->top].entity = entity;
> > +	graph->stack[graph->top].link = pad->entity->links.next;
> > +	graph->stack[graph->top].pad = pad;
> >  }
> >  
> > -static struct media_entity *stack_pop(struct media_graph *graph)
> > +static struct media_pad *stack_pop(struct media_graph *graph)
> >  {
> > -	struct media_entity *entity;
> > +	struct media_pad *pad;
> >  
> > -	entity = graph->stack[graph->top].entity;
> > +	pad = graph->stack[graph->top].pad;
> >  	graph->top--;
> >  
> > -	return entity;
> > +	return pad;
> >  }
> >  
> >  #define link_top(en)	((en)->stack[(en)->top].link)
> > -#define stack_top(en)	((en)->stack[(en)->top].entity)
> > +#define stack_top(en)	((en)->stack[(en)->top].pad)
> >  
> >  /**
> >   * media_graph_walk_init - Allocate resources for graph walk
> > @@ -306,8 +305,8 @@ void media_graph_walk_start(struct media_graph *graph, struct media_pad *pad)
> >  	media_entity_enum_set(&graph->ent_enum, pad->entity);
> >  
> >  	graph->top = 0;
> > -	graph->stack[graph->top].entity = NULL;
> > -	stack_push(graph, pad->entity);
> > +	graph->stack[graph->top].pad = NULL;
> > +	stack_push(graph, pad);
> >  	dev_dbg(pad->graph_obj.mdev->dev,
> >  		"begin graph walk at '%s':%u\n", pad->entity->name, pad->index);
> >  }
> > @@ -315,16 +314,16 @@ EXPORT_SYMBOL_GPL(media_graph_walk_start);
> >  
> >  static void media_graph_walk_iter(struct media_graph *graph)
> >  {
> > -	struct media_entity *entity = stack_top(graph);
> > +	struct media_pad *pad = stack_top(graph);
> >  	struct media_link *link;
> > -	struct media_entity *next;
> > +	struct media_pad *next;
> >  
> >  	link = list_entry(link_top(graph), typeof(*link), list);
> >  
> >  	/* The link is not enabled so we do not follow. */
> >  	if (!(link->flags & MEDIA_LNK_FL_ENABLED)) {
> >  		link_top(graph) = link_top(graph)->next;
> > -		dev_dbg(entity->graph_obj.mdev->dev,
> > +		dev_dbg(pad->graph_obj.mdev->dev,
> >  			"walk: skipping disabled link '%s':%u -> '%s':%u\n",
> >  			link->source->entity->name, link->source->index,
> >  			link->sink->entity->name, link->sink->index);
> > @@ -332,22 +331,22 @@ static void media_graph_walk_iter(struct media_graph *graph)
> >  	}
> >  
> >  	/* Get the entity in the other end of the link . */
> 
> s/entity/pad/
> 
> > -	next = media_entity_other(entity, link);
> > +	next = media_entity_other(pad, link);
> >  
> >  	/* Has the entity already been visited? */
> 
> s/entity/pad's entity/
> 
> > -	if (media_entity_enum_test_and_set(&graph->ent_enum, next)) {
> > +	if (media_entity_enum_test_and_set(&graph->ent_enum, next->entity)) {
> >  		link_top(graph) = link_top(graph)->next;
> > -		dev_dbg(entity->graph_obj.mdev->dev,
> > +		dev_dbg(pad->graph_obj.mdev->dev,
> >  			"walk: skipping entity '%s' (already seen)\n",
> > -			next->name);
> > +			next->entity->name);
> >  		return;
> >  	}
> >  
> >  	/* Push the new entity to stack and start over. */
> 
> s/entity/pad/
> 
> >  	link_top(graph) = link_top(graph)->next;
> >  	stack_push(graph, next);
> > -	dev_dbg(entity->graph_obj.mdev->dev, "walk: pushing '%s' on stack\n",
> > -		next->name);
> > +	dev_dbg(next->graph_obj.mdev->dev, "walk: pushing '%s':%u on stack\n",
> > +		next->entity->name, next->index);
> >  }
> >  
> >  struct media_entity *media_graph_walk_next(struct media_graph *graph)
> > @@ -362,10 +361,10 @@ struct media_entity *media_graph_walk_next(struct media_graph *graph)
> >  	 * top of the stack until no more entities on the level can be
> >  	 * found.
> >  	 */
> > -	while (link_top(graph) != &stack_top(graph)->links)
> > +	while (link_top(graph) != &stack_top(graph)->entity->links)
> >  		media_graph_walk_iter(graph);
> >  
> > -	entity = stack_pop(graph);
> > +	entity = stack_pop(graph)->entity;
> >  	dev_dbg(entity->graph_obj.mdev->dev,
> >  		"walk: returning entity '%s'\n", entity->name);
> >  
> > diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> > index 07ab141e739ef5ff..99c7606f01317741 100644
> > --- a/include/media/media-entity.h
> > +++ b/include/media/media-entity.h
> > @@ -86,16 +86,16 @@ struct media_entity_enum {
> >   * struct media_graph - Media graph traversal state
> >   *
> >   * @stack:		Graph traversal stack; the stack contains information
> > - *			on the path the media entities to be walked and the
> > + *			on the path the media pads to be walked and the
> 
> This sentence doesn't make too much sense to me, are we missing
> something ?

I think this should have been "the stack contains information on the media
entities to be walked and the links through which they were reached". So
just replace "entities" by "pads" here.

> 
> The rest looks OK to me, so with this fixed,
> 
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> >   *			links through which they were reached.
> > - * @stack.entity:	pointer to &struct media_entity at the graph.
> > + * @stack.pad:		pointer to &struct media_pad at the graph.
> >   * @stack.link:		pointer to &struct list_head.
> >   * @ent_enum:		Visited entities
> >   * @top:		The top of the stack
> >   */
> >  struct media_graph {
> >  	struct {
> > -		struct media_entity *entity;
> > +		struct media_pad *pad;
> >  		struct list_head *link;
> >  	} stack[MEDIA_ENTITY_ENUM_MAX_DEPTH];
> >  
> 
> -- 
> Regards,
> 
> Laurent Pinchart

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
