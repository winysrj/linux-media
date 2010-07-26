Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:56402 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485Ab0GZQ3o (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Jul 2010 12:29:44 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Pete Eberlein <pete@sensoray.com>
Subject: Re: [RFC/PATCH v2 06/10] media: Entities, pads and links enumeration
Date: Mon, 26 Jul 2010 18:30:15 +0200
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <1279722935-28493-1-git-send-email-laurent.pinchart@ideasonboard.com> <201007221720.04555.laurent.pinchart@ideasonboard.com> <1279816611.2443.111.camel@pete-desktop>
In-Reply-To: <1279816611.2443.111.camel@pete-desktop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201007261830.16705.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pete,

On Thursday 22 July 2010 18:36:51 Pete Eberlein wrote:
> On Thu, 2010-07-22 at 17:20 +0200, Laurent Pinchart wrote:
> > > Laurent Pinchart wrote:
> > > 
> > > ...
> > > 
> > > > diff --git a/Documentation/media-framework.txt
> > > > b/Documentation/media-framework.txt index 3acc62b..16c0177 100644
> > > > --- a/Documentation/media-framework.txt
> > > > +++ b/Documentation/media-framework.txt
> > > > @@ -270,3 +270,137 @@ required, drivers don't need to provide a
> > > > set_power
> > 
> > [snip]
> > 
> > > > +The media_user_pad, media_user_link and media_user_links structure
> > > > are defined
> > > > +as
> > > 
> > > I have a comment on naming. These are user space structures, sure, but
> > > do we want that fact to be visible in the names of the structures? I
> > > would just drop the user_ out and make the naming as good as possible
> > > in user space. That is much harder to change later than naming inside
> > > the kernel.
> > 
> > I agree.
> > 
> > > That change causes a lot of clashes in naming since the equivalent
> > > kernel structure is there as well. Those could have _k postfix, for
> > > example, to differentiate them from user space names. I don't really
> > > have a good suggestion how they should be called.
> > 
> > Maybe media_k_* ? I'm not very happy with that name either though.
> 
> What do you think about a single underscore prefix for the kernel
> structures, used commonly to indicate that a declaration is limited?

The underscore is usually used for internal functions/variables. I'd rather go 
for _k, I think it's more obvious.

-- 
Regards,

Laurent Pinchart
