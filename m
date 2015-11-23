Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:45651 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752287AbbKWPmH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2015 10:42:07 -0500
Date: Mon, 23 Nov 2015 13:41:54 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Akihiro Tsukada <tskd08@gmail.com>,
	Antti Palosaari <crope@iki.fi>,
	Jonathan Corbet <corbet@lwn.net>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Tina Ruchandani <ruchandani.tina@gmail.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Rafael =?UTF-8?B?TG91cmVuw6dv?= de Lima Chehab
	<chehabrafael@gmail.com>, Hans Verkuil <hans.verkuil@cisco.com>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	Julia Lawall <Julia.Lawall@lip6.fr>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH v8.2 19/55] [media] media: convert links from array to
 list
Message-ID: <20151123134154.653aed51@recife.lan>
In-Reply-To: <5056555.41pfqro2xG@avalon>
References: <ec40936d7349f390dd8b73b90fa0e0708de596a9.1441540862.git.mchehab@osg.samsung.com>
	<ba0462d54436f101880bd43fe217f47533bcbcf3.1441540862.git.mchehab@osg.samsung.com>
	<5056555.41pfqro2xG@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 23 Nov 2015 17:37:54 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> (Resending as I've replied by mistake to the version of the patch you had sent 
> to the media workshop list only)

(resending my answer to your previously sent review to the WS only ML.
 The e-mail contents is the same as the previously sent one)

> 
> Thank you for the patch.
> 

Hi Laurent,

I'll be addressing the points below on separate patches, to avoid rebasing
it and causing the need for we all (me, Shuah, Javier, Sakari) to re-test
everything after patch 24 again. This way, if a regression happens, we know
what change to blame ;)

Regards,
Mauro

Em Mon, 23 Nov 2015 15:30:36 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> Thank you for the patch.
> 
> On Monday 12 October 2015 13:43:13 Mauro Carvalho Chehab wrote:  
> > The entire logic that represent graph links were developed on a
> > time where there were no needs to dynamic remove links. So,
> > although links are created/removed one by one via some
> > functions, they're stored as an array inside the entity struct.
> > 
> > As the array may grow, there's a logic inside the code that
> > checks if the amount of space is not enough to store
> > the needed links. If it isn't the core uses krealloc()
> > to change the size of the link, with is bad, as it
> > leaves the memory fragmented.  
> 
> I agree with the change made in this patch, but I'm not sure if fragmentation 
> is really the issue. I wouldn't be surprised if we ended up with more 
> fragmented memory.  

That would actually depend on how things get allocated/deallocated.

If we discover that fragmentation is actually increasing, we could
change the code later to use a lookaside cache.

>   
> > So, convert links into a list.
> > 
> > Also, currently,  both source and sink entities need the link
> > at the graph traversal logic inside media_entity. So there's
> > a logic duplicating all links. That makes it to spend
> > twice the memory needed. This is not a big deal for today's
> > usage, where the number of links are not big.
> > 
> > Yet, if during the MC workshop discussions, it was said that
> > IIO graphs could have up to 4,000 entities. So, we may
> > want to remove the duplication on some future. The problem
> > is that it would require a separate linked list to store
> > the backlinks inside the entity, or to use a more complex
> > algorithm to do graph backlink traversal, with is something
> > that the current graph traversal inside the core can't cope
> > with. So, let's postpone a such change if/when it is actually
> > needed.  
> 
> The media_link structure uses 44 bytes on 32-bit architectures and 84 bytes on 
> 64-bit architecture. It will thus be allocated out of the 64-bytes and 96-
> bytes pools respectively. That's a 12.5% memory waste on 64-bit architectures 
> and 31.25% on 32-bit architecture. If you're concerned about memory usage (and 
> I think we all should) a linked list is less efficient than an array in this 
> case (and even more so if you take the struct list_head into account).  

I doubt that the amount of memory spent at the media controller
would actually cause impact, as the size of those structs are a
way smaller than the size of video buffers. Anyway, if we found
later that this would cause troubles, we can redesign it.

>   
> > Change-Id: I558e8f87f200fe5f83ddaafe5560f91f0d906b63  
> 
> No need to infect mainline with gerrit nonsense :-)  

I'm not using gerrit ;) I'm just adding this crap because the change ID
is a good way to detect if a patch is new or not. I have some scripts
that use those IDs to detect it, when working with this 80+ patch series.

In any case, the scripts I use to pull patches at the main tree will
remove those stuff.

>   
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > ---
> >  drivers/media/dvb-core/dvb_frontend.c     |   9 +--
> >  drivers/media/media-device.c              |  25 +++---
> >  drivers/media/media-entity.c              | 128 ++++++++++++---------------
> >  drivers/media/usb/au0828/au0828-core.c    |  12 ++-
> >  drivers/media/usb/au0828/au0828-video.c   |   8 +-
> >  drivers/media/usb/cx231xx/cx231xx-video.c |   8 +-
> >  include/media/media-entity.h              |  10 +--
> >  7 files changed, 97 insertions(+), 103 deletions(-)  
> 
> [snip]
>   
> > diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> > index 0d85c6c28004..3e649cacfc07 100644
> > --- a/drivers/media/media-device.c
> > +++ b/drivers/media/media-device.c
> > @@ -25,6 +25,7 @@
> >  #include <linux/ioctl.h>
> >  #include <linux/media.h>
> >  #include <linux/types.h>
> > +#include <linux/slab.h>  
> 
> Could you please keep headers sorted alphabetically ?  

Ok, I'll reorder on a later patch.

>   
> >  #include <media/media-device.h>
> >  #include <media/media-devnode.h>  
> 
> [snip]
>   
> > @@ -150,22 +151,21 @@ static long __media_device_enum_links(struct
> > media_device *mdev, }
> > 
> >  	if (links->links) {
> > -		struct media_link_desc __user *ulink;
> > -		unsigned int l;
> > +		struct media_link *ent_link;
> > +		struct media_link_desc __user *ulink = links->links;  
> 
> Might be slightly nitpicking, but I think variables would be more coherent if 
> they were called
> 
> 		struct media_link_desc __user *ulink = links->links;
> 		struct media_link *link;  

Nomenclatures tend to generate endless discussions ;)

IMO, calling it as "link" here is confusing, as it is not clear if
this is a Kernel or an Userspace "link"...

> 
> ...
>   
> > 
> > -		for (l = 0, ulink = links->links; l < entity->num_links; l++) {
> > +		list_for_each_entry(ent_link, &entity->links, list) {
> >  			struct media_link_desc link;  
> 
> and
> 
> 			struct media_link_desc klink;  

and calling it as "klink" is confusing to me ;) as this is the struct
defined at the userspace API, and not the struct defined at the
Kernelspace ABI.

Perhaps we could call those media_link_desc as "klink_desc" and
"ulink_desc", instead.

> 
> here.
>   
> >  			/* Ignore backlinks. */
> > -			if (entity->links[l].source->entity != entity)
> > +			if (ent_link->source->entity != entity)
> >  				continue;
> > -
> >  			memset(&link, 0, sizeof(link));
> > -			media_device_kpad_to_upad(entity->links[l].source,
> > +			media_device_kpad_to_upad(ent_link->source,
> >  						  &link.source);
> > -			media_device_kpad_to_upad(entity->links[l].sink,
> > +			media_device_kpad_to_upad(ent_link->sink,
> >  						  &link.sink);
> > -			link.flags = entity->links[l].flags;
> > +			link.flags = ent_link->flags;
> >  			if (copy_to_user(ulink, &link, sizeof(*ulink)))
> >  				return -EFAULT;
> >  			ulink++;
> > @@ -437,6 +437,7 @@ int __must_check media_device_register_entity(struct
> > media_device *mdev, /* Warn if we apparently re-register an entity */
> >  	WARN_ON(entity->graph_obj.mdev != NULL);
> >  	entity->graph_obj.mdev = mdev;
> > +	INIT_LIST_HEAD(&entity->links);  
> 
> I'd move this to media_entity_init(). I've spent time wondering how the code 
> could work without crashing during testing as the list wasn't initialized in 
> media_entity_init().  

I wrote this code lots of months ago... I guess there was a reason for this
to be here, and not there, but I can't remember why.

I'll give it a try.

> 
> Speaking of testing, have you checked for memory leaks with kmemleak ? Given 
> the extent of the rework I think this should really be tested.  

No, I didn't. I'm not sure if au0828 currently passes on kmemleak
or not. What I did is I checked that all created graph objects were
removed, via enabling the dynamic_prinks at the graph object init/remove
functions.

>   
> > 
> >  	spin_lock(&mdev->lock);
> >  	/* Initialize media_gobj embedded at the entity */
> > @@ -465,13 +466,17 @@ void media_device_unregister_entity(struct
> > media_entity *entity) {
> >  	int i;
> >  	struct media_device *mdev = entity->graph_obj.mdev;
> > +	struct media_link *link, *tmp;
> > 
> >  	if (mdev == NULL)
> >  		return;
> > 
> >  	spin_lock(&mdev->lock);
> > -	for (i = 0; i < entity->num_links; i++)
> > -		media_gobj_remove(&entity->links[i].graph_obj);
> > +	list_for_each_entry_safe(link, tmp, &entity->links, list) {
> > +		media_gobj_remove(&link->graph_obj);
> > +		list_del(&link->list);
> > +		kfree(link);  
> 
> Shouldn't you remove the backlinks too ? How about calling 
> __media_entity_remove_link() to centralize the link removal code ?  

Yes. I'll use __media_entity_remove_link() here.

>   
> > +	}
> >  	for (i = 0; i < entity->num_pads; i++)
> >  		media_gobj_remove(&entity->pads[i].graph_obj);
> >  	media_gobj_remove(&entity->graph_obj);
> > diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> > index 0926f08be981..d5efa0e2c88c 100644
> > --- a/drivers/media/media-entity.c
> > +++ b/drivers/media/media-entity.c
> > @@ -221,21 +221,13 @@ int
> >  media_entity_init(struct media_entity *entity, u16 num_pads,
> >  		  struct media_pad *pads)
> >  {
> > -	struct media_link *links;
> > -	unsigned int max_links = num_pads;
> >  	unsigned int i;
> > 
> > -	links = kzalloc(max_links * sizeof(links[0]), GFP_KERNEL);
> > -	if (links == NULL)
> > -		return -ENOMEM;
> > -  
> 
> Now that the function doesn't allocate links anymore you should fix its 
> kerneldoc that still mentions preallocation.  

OK.

> >  	entity->group_id = 0;
> > -	entity->max_links = max_links;
> >  	entity->num_links = 0;
> >  	entity->num_backlinks = 0;
> >  	entity->num_pads = num_pads;
> >  	entity->pads = pads;
> > -	entity->links = links;
> > 
> >  	for (i = 0; i < num_pads; i++) {
> >  		pads[i].entity = entity;
> > @@ -249,7 +241,13 @@ EXPORT_SYMBOL_GPL(media_entity_init);
> >  void
> >  media_entity_cleanup(struct media_entity *entity)
> >  {
> > -	kfree(entity->links);
> > +	struct media_link *link, *tmp;
> > +
> > +	list_for_each_entry_safe(link, tmp, &entity->links, list) {
> > +		media_gobj_remove(&link->graph_obj);
> > +		list_del(&link->list);
> > +		kfree(link);
> > +	}
> >  }
> >  EXPORT_SYMBOL_GPL(media_entity_cleanup);
> > 
> > @@ -275,7 +273,7 @@ static void stack_push(struct media_entity_graph *graph,
> > return;
> >  	}
> >  	graph->top++;
> > -	graph->stack[graph->top].link = 0;
> > +	graph->stack[graph->top].link = (&entity->links)->next;  
> 
> Anything wrong with entity->links.next ?  

No, but I use a regex to find all the occurrences of the previous
struct ;)

I'll change it.

>   
> >  	graph->stack[graph->top].entity = entity;
> >  }
> > 
> > @@ -317,6 +315,7 @@ void media_entity_graph_walk_start(struct
> > media_entity_graph *graph, }
> >  EXPORT_SYMBOL_GPL(media_entity_graph_walk_start);
> > 
> > +  
> 
> No need for an extra blank line.  

OK.

> >  /**
> >   * media_entity_graph_walk_next - Get the next entity in the graph
> >   * @graph: Media graph structure
> > @@ -340,14 +339,16 @@ media_entity_graph_walk_next(struct media_entity_graph
> > *graph) * top of the stack until no more entities on the level can be
> >  	 * found.
> >  	 */
> > -	while (link_top(graph) < stack_top(graph)->num_links) {
> > +	while (link_top(graph) != &(stack_top(graph)->links)) {  
> 
> No need for parentheses around the second operand of !=.  

Ok, I'll remove it.

> >  		struct media_entity *entity = stack_top(graph);
> > -		struct media_link *link = &entity->links[link_top(graph)];
> > +		struct media_link *link;
> >  		struct media_entity *next;
> > 
> > +		link = list_entry(link_top(graph), typeof(*link), list);
> > +
> >  		/* The link is not enabled so we do not follow. */
> >  		if (!(link->flags & MEDIA_LNK_FL_ENABLED)) {
> > -			link_top(graph)++;
> > +			link_top(graph) = link_top(graph)->next;
> >  			continue;
> >  		}  
> 
> [snip]
>   
> > @@ -395,6 +396,7 @@ __must_check int media_entity_pipeline_start(struct
> > media_entity *entity, struct media_device *mdev = entity->graph_obj.mdev;
> >  	struct media_entity_graph graph;
> >  	struct media_entity *entity_err = entity;
> > +	struct media_link *link;  
> 
> Nitpicking, I would have placed the variable declaration inside of the while 
> loop, where i was declared.  

OK.

> >  	int ret;
> > 
> >  	mutex_lock(&mdev->graph_mutex);
> > @@ -404,7 +406,6 @@ __must_check int media_entity_pipeline_start(struct
> > media_entity *entity, while ((entity =
> > media_entity_graph_walk_next(&graph))) {
> >  		DECLARE_BITMAP(active, entity->num_pads);
> >  		DECLARE_BITMAP(has_no_links, entity->num_pads);
> > -		unsigned int i;
> > 
> >  		entity->stream_count++;
> >  		WARN_ON(entity->pipe && entity->pipe != pipe);
> > @@ -420,8 +421,7 @@ __must_check int media_entity_pipeline_start(struct
> > media_entity *entity, bitmap_zero(active, entity->num_pads);
> >  		bitmap_fill(has_no_links, entity->num_pads);
> > 
> > -		for (i = 0; i < entity->num_links; i++) {
> > -			struct media_link *link = &entity->links[i];
> > +		list_for_each_entry(link, &entity->links, list) {
> >  			struct media_pad *pad = link->sink->entity == entity
> >  						? link->sink : link->source;  
> 
> [snip]
>   
> > +static void __media_entity_remove_link(struct media_entity *entity,
> > +				       struct media_link *link);
> > +  
> 
> No forward declaration please, let's reorder functions instead.  

OK.

>   
> >  int
> >  media_create_pad_link(struct media_entity *source, u16 source_pad,
> >  			 struct media_entity *sink, u16 sink_pad, u32 flags)  
> 
> [snip]
