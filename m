Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35359 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751676Ab3IRIh4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Sep 2013 04:37:56 -0400
Date: Wed, 18 Sep 2013 11:37:21 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	sylwester.nawrocki@gmail.com
Cc: linux-media@vger.kernel.org
Subject: Re: [RFC v1.2 2/4] media: Check for active links on pads with
 MEDIA_PAD_FL_MUST_CONNECT flag
Message-ID: <20130918083721.GE2285@valkosipuli.retiisi.org.uk>
References: <1806796.1hWpdenVOE@avalon>
 <1378253382-23174-1-git-send-email-sakari.ailus@iki.fi>
 <2776033.HLZrjxzBOj@avalon>
 <20130906171012.GH4493@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130906171012.GH4493@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ping.

On Fri, Sep 06, 2013 at 08:10:12PM +0300, Sakari Ailus wrote:
> Hi Laurent,
> 
> Thanks for the reply.
> 
> On Fri, Sep 06, 2013 at 06:30:47PM +0200, Laurent Pinchart wrote:
> > Hi Sakari,
> > 
> > Thank you for the patch.
> > 
> > On Wednesday 04 September 2013 03:09:42 Sakari Ailus wrote:
> > > Do not allow streaming if a pad with MEDIA_PAD_FL_MUST_CONNECT flag is
> > > connected by links that are all inactive.
> > > 
> > > This patch makes it possible to avoid drivers having to check for the most
> > > common case of link state validation: a sink pad that must be connected.
> > > 
> > > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > > ---
> > >  drivers/media/media-entity.c |   41 > +++++++++++++++++++++++++++++++------
> > >  1 file changed, 34 insertions(+), 7 deletions(-)
> > > 
> > > diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> > > index 2c286c3..567a171 100644
> > > --- a/drivers/media/media-entity.c
> > > +++ b/drivers/media/media-entity.c
> > > @@ -235,6 +235,8 @@ __must_check int media_entity_pipeline_start(struct
> > > media_entity *entity, media_entity_graph_walk_start(&graph, entity);
> > > 
> > >  	while ((entity = media_entity_graph_walk_next(&graph))) {
> > > +		DECLARE_BITMAP(active, entity->num_pads);
> > > +		DECLARE_BITMAP(has_no_links, entity->num_pads);
> > >  		unsigned int i;
> > > 
> > >  		entity->stream_count++;
> > > @@ -248,21 +250,46 @@ __must_check int media_entity_pipeline_start(struct
> > > media_entity *entity, if (!entity->ops || !entity->ops->link_validate)
> > >  			continue;
> > > 
> > > +		bitmap_zero(active, entity->num_pads);
> > > +		bitmap_fill(has_no_links, entity->num_pads);
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
> > > +			/* Mark that a pad is connected by a link. */
> > > +			bitmap_clear(has_no_links, pad->index, 1);
> > > +
> > > +			/*
> > > +			 * Pads that either do not need to connect or
> > > +			 * are connected through an enabled link are
> > > +			 * fine.
> > > +			 */
> > > +			if (!(pad->flags & MEDIA_PAD_FL_MUST_CONNECT)
> > > +			    || link->flags & MEDIA_LNK_FL_ENABLED)
> > 
> > With the || moved on the previous line (here and below),
> 
> I'd like to claim the above is more clear and conforms to GNU coding
> standards whereas the kernel CodingStyle doesn't suggest either way:
> 
> <URL:http://www.gnu.org/prep/standards/standards.html#Formatting>
> 
> I feel we've had this discussion before. :-)
> 
> I have to admit I disagree with Stallman's liberal use of parentheses and a
> funny habit of having a space between a function name and the parentheses
> enclosing its arguments. ;-)
> 
> > Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > 
> > If that's fine with you there's no need to resent, I'll take the patch in my 
> > tree with that modification.
> 
> I won't say no, but I would prefer getting an ack from someone else, too,
> for the two first patches. A less permissive variant of this was dismissed
> around a year ago, potentially perhaps there was no pressing need for that
> kind of a change. The earlier set required all sink pads must have a
> connected link (which indeed was too restrictive, I agree).
> 
> <URL:https://linuxtv.org/patch/15205/>
> 
> As seen in the fourth patch of this set, this makes it possible to avoid
> another loop (done in the driver) over the pipeline, which was my motivation
> for this patch --- so I think this is the right thing to do.
> 
> Other drivers could be changed the same way but I think this is up to the
> driver authors. There could be other reasons for the pad to need connecting;
> tha absence of the flag won't say there aren't.
> 
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
> > > +		/* Either no links or validated links are fine. */
> > > +		bitmap_or(active, active, has_no_links, entity->num_pads);
> > > +
> > > +		if (!bitmap_full(active, entity->num_pads)) {
> > > +			ret = -EPIPE;
> > > +			goto error;
> > > +		}
> > >  	}
> > > 
> > >  	mutex_unlock(&mdev->graph_mutex);
> 
> -- 
> Kind regards,
> 
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
