Return-path: <mchehab@localhost>
Received: from perceval.irobotique.be ([92.243.18.41]:50847 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754617Ab0IAOIa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Sep 2010 10:08:30 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC/PATCH v4 08/11] media: Links setup
Date: Wed, 1 Sep 2010 16:08:29 +0200
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1282318153-18885-1-git-send-email-laurent.pinchart@ideasonboard.com> <1282318153-18885-9-git-send-email-laurent.pinchart@ideasonboard.com> <201008281314.18698.hverkuil@xs4all.nl>
In-Reply-To: <201008281314.18698.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201009011608.30918.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@localhost>

Hi Hans,

On Saturday 28 August 2010 13:14:18 Hans Verkuil wrote:
> On Friday, August 20, 2010 17:29:10 Laurent Pinchart wrote:

[snip]

> > +/**
> > + * media_entity_remote_pad - Locate the pad at the remote end of a link
> > + * @entity: Local entity
> > + * @pad: Pad at the local end of the link
> > + *
> > + * Search for a remote pad connected to the given pad by iterating over
> > all
> > + * links originating or terminating at that pad until an active link is
> > found.
> > + *
> > + * Return a pointer to the pad at the remote end of the first found
> > active link,
> > + * or NULL if no active link has been found.
> > + */
> > +struct media_pad *media_entity_remote_pad(struct media_pad *pad)
> > +{
> > +	unsigned int i;
> > +
> > +	for (i = 0; i < pad->entity->num_links; i++) {
> > +		struct media_link *link = &pad->entity->links[i];
> > +
> > +		if (!(link->flags & MEDIA_LINK_FLAG_ACTIVE))
> > +			continue;
> > +
> > +		if (link->source == pad)
> > +			return link->sink;
> > +
> > +		if (link->sink == pad)
> > +			return link->source;
> > +	}
> > +
> > +	return NULL;
> > +
> > +}
> 
> Why is this needed? Esp. since there can be multiple active remote pads if
> you have multiple active outgoing links. Something this function doesn't
> deal with.

The function is meant to be used when only one of the links can be active. 
It's most useful to find the entity connected to a given input pad, as input 
pads can't be connected by multiple simultaneously active links.

[snip]

> This patch made me wonder about something else: how is power management
> handled for immutable links? They are by definition active, so they should
> be powered on automatically as well. I'm not sure whether that happens
> right now.

Links are not powered, entities are. Whether a link is immutable or not 
doesn't make much of a difference, it will just always be considered as 
active.

-- 
Regards,

Laurent Pinchart
