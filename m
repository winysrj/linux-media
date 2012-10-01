Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48535 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753557Ab2JAUBo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Oct 2012 16:01:44 -0400
Date: Mon, 1 Oct 2012 17:01:38 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org
Subject: Re: [RFCv1 API PATCH 2/4] v4l2-ctrls: add a notify callback.
Message-ID: <20121001170138.5501f4be@redhat.com>
In-Reply-To: <201209270844.25497.hverkuil@xs4all.nl>
References: <1347621336-14108-1-git-send-email-hans.verkuil@cisco.com>
	<598b270f69d510c29436b51ef5cc0034afe77101.1347620872.git.hans.verkuil@cisco.com>
	<1779382.8Ng3nlM3Km@avalon>
	<201209270844.25497.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 27 Sep 2012 08:44:25 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On Wed September 26 2012 12:50:11 Laurent Pinchart wrote:

> > > +	if (notify == NULL) {
> > > +		ctrl->call_notify = 0;
> > > +		return;
> > > +	}
> > > +	/* Only one notifier is allowed. Should we ever need to support
> > > +	   multiple notifiers, then some sort of linked list of notifiers
> > > +	   should be implemented. But I don't see any real reason to implement
> > > +	   that now. If you think you need multiple notifiers, then contact
> > > +	   the linux-media mailinglist. */

If only one notifier is allowed, then you should clearly state that at the
API documentation.

> > > +	if (WARN_ON(ctrl->handler->notify &&
> > > +			(ctrl->handler->notify != notify ||
> > > +			 ctrl->handler->notify_priv != priv)))
> > > +		return;
> > 
> > I'm not sure whether I like that. It feels a bit hackish. Wouldn't it be 
> > better to register the notifier with the handler explictly just once and then 
> > enable/disable notifications on a per-control basis ?
> 
> I thought about that, but I prefer this method because it allows me to switch
> to per-control notifiers in the future. In addition, different controls can have
> different handlers. If you have to set the notifier for handlers, then the
> driver needs to figure out which handlers are involved for the controls it wants
> to be notified on. It's much easier to do it like this.

That also sounded hackish on my eyes. If just one notifier is allowed, the
function should simply refuse any other call to it, as any other call to it
is a driver's bug. So:

	if (WARN_ON(ctrl->handler->notify))
		return;

seems to be enough.

Regards,
Mauro
