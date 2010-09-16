Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:35304 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567Ab0IPJCF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Sep 2010 05:02:05 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC/PATCH v4 08/11] media: Links setup
Date: Thu, 16 Sep 2010 11:02:06 +0200
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1282318153-18885-1-git-send-email-laurent.pinchart@ideasonboard.com> <201009011608.30918.laurent.pinchart@ideasonboard.com> <201009061909.20882.hverkuil@xs4all.nl>
In-Reply-To: <201009061909.20882.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201009161102.07853.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

On Monday 06 September 2010 19:09:20 Hans Verkuil wrote:
> On Wednesday, September 01, 2010 16:08:29 Laurent Pinchart wrote:
> > On Saturday 28 August 2010 13:14:18 Hans Verkuil wrote:
> > > On Friday, August 20, 2010 17:29:10 Laurent Pinchart wrote:
> > [snip]
> > 
> > > > +/**
> > > > + * media_entity_remote_pad - Locate the pad at the remote end of a
> > > > link + * @entity: Local entity
> > > > + * @pad: Pad at the local end of the link
> > > > + *
> > > > + * Search for a remote pad connected to the given pad by iterating
> > > > over all
> > > > + * links originating or terminating at that pad until an active link
> > > > is found.
> > > > + *
> > > > + * Return a pointer to the pad at the remote end of the first found
> > > > active link,
> > > > + * or NULL if no active link has been found.
> > > > + */
> > > > +struct media_pad *media_entity_remote_pad(struct media_pad *pad)
> > > > +{
> > > > +	unsigned int i;
> > > > +
> > > > +	for (i = 0; i < pad->entity->num_links; i++) {
> > > > +		struct media_link *link = &pad->entity->links[i];
> > > > +
> > > > +		if (!(link->flags & MEDIA_LINK_FLAG_ACTIVE))
> > > > +			continue;
> > > > +
> > > > +		if (link->source == pad)
> > > > +			return link->sink;
> > > > +
> > > > +		if (link->sink == pad)
> > > > +			return link->source;
> > > > +	}
> > > > +
> > > > +	return NULL;
> > > > +
> > > > +}
> > > 
> > > Why is this needed? Esp. since there can be multiple active remote pads
> > > if you have multiple active outgoing links. Something this function
> > > doesn't deal with.
> > 
> > The function is meant to be used when only one of the links can be
> > active. It's most useful to find the entity connected to a given input
> > pad, as input pads can't be connected by multiple simultaneously active
> > links.
> 
> In that case I would rename it media_entity_remote_source to match the use
> case (and only look for remote sources).

OK, I'll rename the function.

> Alternatively you could add an index for the nth active link, then it would
> be truly generic.
> 
> Right now the function either does too much or too little :-)

-- 
Regards,

Laurent Pinchart
