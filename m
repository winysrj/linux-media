Return-path: <mchehab@gaivota>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2250 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514Ab0IFRJ0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Sep 2010 13:09:26 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC/PATCH v4 08/11] media: Links setup
Date: Mon, 6 Sep 2010 19:09:20 +0200
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1282318153-18885-1-git-send-email-laurent.pinchart@ideasonboard.com> <201008281314.18698.hverkuil@xs4all.nl> <201009011608.30918.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201009011608.30918.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201009061909.20882.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Wednesday, September 01, 2010 16:08:29 Laurent Pinchart wrote:
> Hi Hans,
> 
> On Saturday 28 August 2010 13:14:18 Hans Verkuil wrote:
> > On Friday, August 20, 2010 17:29:10 Laurent Pinchart wrote:
> 
> [snip]
> 
> > > +/**
> > > + * media_entity_remote_pad - Locate the pad at the remote end of a link
> > > + * @entity: Local entity
> > > + * @pad: Pad at the local end of the link
> > > + *
> > > + * Search for a remote pad connected to the given pad by iterating over
> > > all
> > > + * links originating or terminating at that pad until an active link is
> > > found.
> > > + *
> > > + * Return a pointer to the pad at the remote end of the first found
> > > active link,
> > > + * or NULL if no active link has been found.
> > > + */
> > > +struct media_pad *media_entity_remote_pad(struct media_pad *pad)
> > > +{
> > > +	unsigned int i;
> > > +
> > > +	for (i = 0; i < pad->entity->num_links; i++) {
> > > +		struct media_link *link = &pad->entity->links[i];
> > > +
> > > +		if (!(link->flags & MEDIA_LINK_FLAG_ACTIVE))
> > > +			continue;
> > > +
> > > +		if (link->source == pad)
> > > +			return link->sink;
> > > +
> > > +		if (link->sink == pad)
> > > +			return link->source;
> > > +	}
> > > +
> > > +	return NULL;
> > > +
> > > +}
> > 
> > Why is this needed? Esp. since there can be multiple active remote pads if
> > you have multiple active outgoing links. Something this function doesn't
> > deal with.
> 
> The function is meant to be used when only one of the links can be active. 
> It's most useful to find the entity connected to a given input pad, as input 
> pads can't be connected by multiple simultaneously active links.

In that case I would rename it media_entity_remote_source to match the use
case (and only look for remote sources).

Alternatively you could add an index for the nth active link, then it would
be truly generic.

Right now the function either does too much or too little :-)

Regards,

	Hans


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
