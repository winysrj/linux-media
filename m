Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:60847 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755977Ab0GVPTq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Jul 2010 11:19:46 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [RFC/PATCH v2 06/10] media: Entities, pads and links enumeration
Date: Thu, 22 Jul 2010 17:20:01 +0200
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
References: <1279722935-28493-1-git-send-email-laurent.pinchart@ideasonboard.com> <1279722935-28493-7-git-send-email-laurent.pinchart@ideasonboard.com> <4C485F49.2000703@maxwell.research.nokia.com>
In-Reply-To: <4C485F49.2000703@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007221720.04555.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Thursday 22 July 2010 17:10:01 Sakari Ailus wrote:
> Heippa,
> 
> What a nice patch! :-)

Thanks :-)

> Laurent Pinchart wrote:
> 
> ...
> 
> > diff --git a/Documentation/media-framework.txt
> > b/Documentation/media-framework.txt index 3acc62b..16c0177 100644
> > --- a/Documentation/media-framework.txt
> > +++ b/Documentation/media-framework.txt
> > @@ -270,3 +270,137 @@ required, drivers don't need to provide a set_power

[snip]

> > +The media_user_pad, media_user_link and media_user_links structure are 
> > defined
> > +as
> 
> I have a comment on naming. These are user space structures, sure, but
> do we want that fact to be visible in the names of the structures? I
> would just drop the user_ out and make the naming as good as possible in
> user space. That is much harder to change later than naming inside the
> kernel.

I agree.

> That change causes a lot of clashes in naming since the equivalent
> kernel structure is there as well. Those could have _k postfix, for
> example, to differentiate them from user space names. I don't really
> have a good suggestion how they should be called.

Maybe media_k_* ? I'm not very happy with that name either though.

> > +- struct media_user_pad
> > +
> > +__u32		entity		ID of the entity this pad belongs to.
> > +__8		index		0-based pad index.
> 
> It's possible that 8 bits is enough (I think Hans commented this
> already). The compiler will use 4 bytes in any case and I think it's a
> good practice not to create holes in the structures, especially not to
> the interface ones.

The direction could become a 8-bit integer, and a 16-bit attributes/properties 
bitfield would be added to fill the hole (it would be used to store pad 
properties such as a busy flag). I'd rather make that field 32-bits wide 
instead of 16 though.

> The OMAP 4 has a tiler, could it be that this kind of functionality
> might introduce large numbers of pads in the future?

-- 
Regards,

Laurent Pinchart
