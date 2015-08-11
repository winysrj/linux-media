Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:57134 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755088AbbHKLMt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Aug 2015 07:12:49 -0400
Date: Tue, 11 Aug 2015 08:12:43 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH RFC v2 08/16] media: convert links from array to list
Message-ID: <20150811081243.39bddfbf@recife.lan>
In-Reply-To: <55C9D344.8090905@xs4all.nl>
References: <cover.1438954897.git.mchehab@osg.samsung.com>
	<65340c7d01bdfcadbb82f92d63a3571871d07930.1438954897.git.mchehab@osg.samsung.com>
	<55C9D344.8090905@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 11 Aug 2015 12:49:40 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 08/07/15 16:20, Mauro Carvalho Chehab wrote:
> > Using memory realloc to increase the size of an array
> > is complex and makes harder to remove links. Also, by
> > embedding the link inside an array at the entity makes harder
> > to change the code to add interfaces, as interfaces will
> > also need to use links.
> > 
> > So, convert the links from arrays to lists.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > 
> > diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> > index 9fb3f8958265..a95ca981aabb 100644
> > --- a/drivers/media/media-device.c
> > +++ b/drivers/media/media-device.c
> 
> <snip>
> 
> > @@ -452,27 +445,21 @@ EXPORT_SYMBOL_GPL(media_entity_put);
> >  
> >  static struct media_link *media_entity_add_link(struct media_entity *entity)
> >  {
> > -	if (entity->num_links >= entity->max_links) {
> > -		struct media_link *links = entity->links;
> > -		unsigned int max_links = entity->max_links + 2;
> > -		unsigned int i;
> > +	struct media_link *link;
> >  
> > -		links = krealloc(links, max_links * sizeof(*links), GFP_KERNEL);
> > -		if (links == NULL)
> > -			return NULL;
> > +	link = kzalloc(sizeof(*link), GFP_KERNEL);
> > +	if (link == NULL)
> > +		return NULL;
> >  
> > -		for (i = 0; i < entity->num_links; i++)
> > -			links[i].reverse->reverse = &links[i];
> > -
> > -		entity->max_links = max_links;
> > -		entity->links = links;
> > -	}
> > +	link->reverse->reverse = link;
> 
> Huh? link points to a zeroed struct, so link->reverse will be NULL.
> This can't work.
> 
> Are you sure this line should be here? The original code doesn't set it
> either for the new link, it just updates the reverse links for the
> realloced links.

You're right. I think I can just remove that line.

I had to confess that I didn't understand well that the reverse links
stuff. I mean, IMHO, the entire concept of storing a second copy of
the link, calling it as "reverse" on some places and as "backlink"
on others is messy, and I guess we should get rid of duplicating the
number of links for no good reason.

It is easy to just add the same link to a list at the other entity,
and keep the link just once in the memory.

> 
> > +	INIT_LIST_HEAD(&link->list);
> > +	list_add(&entity->links, &link->list);
> >  
> >  	/* Initialize graph object embedded at the new link */
> >  	graph_obj_init(entity->parent, MEDIA_GRAPH_LINK,
> > -			&entity->links[entity->num_links].graph_obj);
> > +			&link->graph_obj);
> >  
> > -	return &entity->links[entity->num_links++];
> > +	return link;
> >  }
> >  
> >  int
> 
> Regards,
> 
> 	Hans
