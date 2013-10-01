Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47003 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752718Ab3JAMwt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Oct 2013 08:52:49 -0400
Date: Tue, 1 Oct 2013 15:52:15 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, sylwester.nawrocki@gmail.com
Subject: Re: [PATCH 2/4] media: Check for active links on pads with
 MEDIA_PAD_FL_MUST_CONNECT flag
Message-ID: <20131001125215.GK3022@valkosipuli.retiisi.org.uk>
References: <1379541668-23085-1-git-send-email-sakari.ailus@iki.fi>
 <22265733.Mjk5afGodv@avalon>
 <20130923195702.GA3022@valkosipuli.retiisi.org.uk>
 <5707510.U5dlJYRQYf@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5707510.U5dlJYRQYf@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Tue, Oct 01, 2013 at 02:39:14PM +0200, Laurent Pinchart wrote:
> On Monday 23 September 2013 22:57:02 Sakari Ailus wrote:
> > On Fri, Sep 20, 2013 at 10:54:22PM +0200, Laurent Pinchart wrote:
> > > > @@ -248,21 +250,46 @@ __must_check int
> > > > media_entity_pipeline_start(struct media_entity *entity,
> > > >  		if (!entity->ops || !entity->ops->link_validate)
> > > >  			continue;
> > > > 
> > > > +		bitmap_zero(active, entity->num_pads);
> > > > +		bitmap_fill(has_no_links, entity->num_pads);
> > > > +
> > > >  		for (i = 0; i < entity->num_links; i++) {
> > > >  			struct media_link *link = &entity->links[i];
> > > > -
> > > > -			/* Is this pad part of an enabled link? */
> > > > -			if (!(link->flags & MEDIA_LNK_FL_ENABLED))
> > > > -				continue;
> > > > -
> > > > -			/* Are we the sink or not? */
> > > > -			if (link->sink->entity != entity)
> > > > +			struct media_pad *pad = link->sink->entity == entity
> > > > +				? link->sink : link->source;
> > > 
> > > What about aligning the ? to the = ? With that change,
> > 
> > How about to the beginning of the next operand rather than "="?
> > 
> > (Think of adding parentheses around the rvalue of "=".)
> > 
> > I think it's fine as it was, but if it's to be changed then it should be
> > aligned to link->sink->entity IMHO. :-)
> 
> My preference goes for aligning the ? under the =, but I agree it's not 
> logical from an rvalue point of view :-) I would favor aligning the ? under 
> the l of link, but enough bikeshedding for now, please pick whichever solution 
> you prefer :-)

? goes under l of the link; agreed. I'll resend the set.

-- 
Cheers,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
