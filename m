Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1513 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023Ab2JBGg0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Oct 2012 02:36:26 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFCv1 API PATCH 2/4] v4l2-ctrls: add a notify callback.
Date: Tue, 2 Oct 2012 08:36:17 +0200
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org
References: <1347621336-14108-1-git-send-email-hans.verkuil@cisco.com> <201209270844.25497.hverkuil@xs4all.nl> <20121001170138.5501f4be@redhat.com>
In-Reply-To: <20121001170138.5501f4be@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210020836.17999.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon October 1 2012 22:01:38 Mauro Carvalho Chehab wrote:
> Em Thu, 27 Sep 2012 08:44:25 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
> > On Wed September 26 2012 12:50:11 Laurent Pinchart wrote:
> 
> > > > +	if (notify == NULL) {
> > > > +		ctrl->call_notify = 0;
> > > > +		return;
> > > > +	}
> > > > +	/* Only one notifier is allowed. Should we ever need to support
> > > > +	   multiple notifiers, then some sort of linked list of notifiers
> > > > +	   should be implemented. But I don't see any real reason to implement
> > > > +	   that now. If you think you need multiple notifiers, then contact
> > > > +	   the linux-media mailinglist. */
> 
> If only one notifier is allowed, then you should clearly state that at the
> API documentation.

Well, v4l2-controls.txt says:

"There can be only one notify function per control handler. Any attempt
to set another notify function will cause a WARN_ON."

And it is documented as well in the header, so what more do you want?

> > > > +	if (WARN_ON(ctrl->handler->notify &&
> > > > +			(ctrl->handler->notify != notify ||
> > > > +			 ctrl->handler->notify_priv != priv)))
> > > > +		return;
> > > 
> > > I'm not sure whether I like that. It feels a bit hackish. Wouldn't it be 
> > > better to register the notifier with the handler explictly just once and then 
> > > enable/disable notifications on a per-control basis ?
> > 
> > I thought about that, but I prefer this method because it allows me to switch
> > to per-control notifiers in the future. In addition, different controls can have
> > different handlers. If you have to set the notifier for handlers, then the
> > driver needs to figure out which handlers are involved for the controls it wants
> > to be notified on. It's much easier to do it like this.
> 
> That also sounded hackish on my eyes. If just one notifier is allowed, the
> function should simply refuse any other call to it, as any other call to it
> is a driver's bug. So:
> 
> 	if (WARN_ON(ctrl->handler->notify))
> 		return;
> 
> seems to be enough.

No, it's not. Multiple controls share the same handler, so this would only work
for the first control and block any attempts to set the notifier for other
controls of the same handler.

The point is that in today's implementation the notifier is stored in the handler
because that was the easiest implementation and because it is all we need today.
But in the future we may have to support different notifiers and also more than
one notifier per control, and in that case the notifier would move to the control
data structure.

I want to be able to make such a change without having to change all drivers that
use today's implementation.

The API for setting a notifier should act on a control, not on a control handler.
The 'hack' above is just a check that ensures that you don't violate the constraints
of the current implementation. If anyone hits that warning and contacts the ml, then
I can see if there are good enough reasons to go the extra mile and remove this
constraint.

So I really don't want to change this patch.

Regards,

	Hans
