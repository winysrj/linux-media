Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50614 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032Ab3HUDVd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Aug 2013 23:21:33 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [RFC 2/4] media: Check for active links on pads with MEDIA_PAD_FL_MUST_CONNECT flag
Date: Wed, 21 Aug 2013 05:22:45 +0200
Message-ID: <1611138.kmhZXgyzhc@avalon>
In-Reply-To: <20130810121629.GF16719@valkosipuli.retiisi.org.uk>
References: <1374256509-7850-1-git-send-email-sakari.ailus@iki.fi> <32006650.7k13BkzS1n@avalon> <20130810121629.GF16719@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Saturday 10 August 2013 15:16:29 Sakari Ailus wrote:
> On Fri, Aug 09, 2013 at 01:34:46AM +0200, Laurent Pinchart wrote:
> > On Friday 19 July 2013 20:55:07 Sakari Ailus wrote:
> > > Do not allow streaming if a pad with MEDIA_PAD_FL_MUST_CONNECT flag is
> > > not connected by an active link.
> > > 
> > > This patch makes it possible to avoid drivers having to check for the
> > > most common case of link state validation: a sink pad that must be
> > > connected.
> > > 
> > > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > > ---
> > > 
> > >  drivers/media/media-entity.c |   34 +++++++++++++++++++++++++++-------
> > >  1 file changed, 27 insertions(+), 7 deletions(-)
> > > 
> > > diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> > > index cb30ffb..4e58f8a 100644
> > > --- a/drivers/media/media-entity.c
> > > +++ b/drivers/media/media-entity.c
> > > @@ -20,6 +20,7 @@
> > >   * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
> > > USA */
> > > 
> > > +#include <linux/bitmap.h>
> > >  #include <linux/module.h>
> > >  #include <linux/slab.h>
> > >  #include <media/media-entity.h>
> > > @@ -227,6 +228,7 @@ __must_check int media_entity_pipeline_start(struct
> > > media_entity *entity,
> > >  	media_entity_graph_walk_start(&graph, entity);
> > > 
> > >  	while ((entity = media_entity_graph_walk_next(&graph))) {
> > > +		DECLARE_BITMAP(active, entity->num_pads);
> > >  		unsigned int i;
> > >  		
> > >  		entity->stream_count++;
> > > 
> > > @@ -240,21 +242,39 @@ __must_check int
> > > media_entity_pipeline_start(struct media_entity *entity,
> > >  		if (!entity->ops || !entity->ops->link_validate)
> > >  			continue;
> > > 
> > > +		bitmap_zero(active, entity->num_pads);
> > > +
> > >  		for (i = 0; i < entity->num_links; i++) {
> > >  			struct media_link *link = &entity->links[i];
> > > -
> > > -			/* Is this pad part of an enabled link? */
> > > -			if (!(link->flags & MEDIA_LNK_FL_ENABLED))
> > > -				continue;
> > > -
> > > -			/* Are we the sink or not? */
> > > -			if (link->sink->entity != entity)
> > > +			struct media_pad *pad = link->sink->entity == entity
> > > +				? link->sink : link->source;
> > > +
> > > +			/*
> > > +			 * Pads that either do not need to connect or
> > > +			 * are connected through an enabled link are
> > > +			 * fine.
> > > +			 */
> > > +			if (!(pad->flags & MEDIA_PAD_FL_MUST_CONNECT)
> > > +			    || link->flags & MEDIA_LNK_FL_ENABLED)
> > > +				bitmap_set(active, pad->index, 1);
> > > +
> > > +			/*
> > > +			 * Link validation will only take place for
> > > +			 * sink ends of the link that are enabled.
> > > +			 */
> > > +			if (link->sink != pad
> > > +			    || !(link->flags & MEDIA_LNK_FL_ENABLED))
> > >  				continue;
> > >  			
> > >  			ret = entity->ops->link_validate(link);
> > >  			if (ret < 0 && ret != -ENOIOCTLCMD)
> > >  				goto error;
> > >  		}
> > > +
> > > +		if (!bitmap_full(active, entity->num_pads)) {
> > > +			ret = -EPIPE;
> > > +			goto error;
> > > +		}
> > 
> > I'm afraid that won't work if one of the pads has no links. In that case
> > the bitmap won't be full. I think you will have to iterate separately on
> > the links to validate them, and on the pads to check the flags.
> 
> Good point.
> 
> I could as well add another bitmap or perhaps rather keep the information in
> struct media_pad, separately from flags since this is something the user can
> find through other means --- that way we don't add practically any runtime
> overhead.
> 
> What do you think?

Given the number of pads we expect on an entity, is it really worth the micro-
optimization ? I think I would just loop over the links and pads separately, 
especially given that you need to validate pads even if the entity has no 
link_validate operation, which is checked before the for loop over the links.

-- 
Regards,

Laurent Pinchart

