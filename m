Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway01.websitewelcome.com ([69.93.136.19]:54154 "HELO
	gateway01.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751555Ab0GVQna (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Jul 2010 12:43:30 -0400
Subject: Re: [RFC/PATCH v2 06/10] media: Entities, pads and links
 enumeration
From: Pete Eberlein <pete@sensoray.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <201007221720.04555.laurent.pinchart@ideasonboard.com>
References: <1279722935-28493-1-git-send-email-laurent.pinchart@ideasonboard.com>
	 <1279722935-28493-7-git-send-email-laurent.pinchart@ideasonboard.com>
	 <4C485F49.2000703@maxwell.research.nokia.com>
	 <201007221720.04555.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Jul 2010 09:36:51 -0700
Message-ID: <1279816611.2443.111.camel@pete-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2010-07-22 at 17:20 +0200, Laurent Pinchart wrote:
> > Laurent Pinchart wrote:
> > 
> > ...
> > 
> > > diff --git a/Documentation/media-framework.txt
> > > b/Documentation/media-framework.txt index 3acc62b..16c0177 100644
> > > --- a/Documentation/media-framework.txt
> > > +++ b/Documentation/media-framework.txt
> > > @@ -270,3 +270,137 @@ required, drivers don't need to provide a set_power
> 
> [snip]
> 
> > > +The media_user_pad, media_user_link and media_user_links structure are 
> > > defined
> > > +as
> > 
> > I have a comment on naming. These are user space structures, sure, but
> > do we want that fact to be visible in the names of the structures? I
> > would just drop the user_ out and make the naming as good as possible in
> > user space. That is much harder to change later than naming inside the
> > kernel.
> 
> I agree.
> 
> > That change causes a lot of clashes in naming since the equivalent
> > kernel structure is there as well. Those could have _k postfix, for
> > example, to differentiate them from user space names. I don't really
> > have a good suggestion how they should be called.
> 
> Maybe media_k_* ? I'm not very happy with that name either though.

What do you think about a single underscore prefix for the kernel
structures, used commonly to indicate that a declaration is limited?



