Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:4890 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951Ab0BVQD3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2010 11:03:29 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [PATCH v5 4/6] V4L: Events: Add backend
Date: Mon, 22 Feb 2010 08:56:35 +0100
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	iivanov@mm-sol.com, gururaj.nagendra@intel.com,
	david.cohen@nokia.com
References: <4B7EE4A4.3080202@maxwell.research.nokia.com> <201002201045.03756.hverkuil@xs4all.nl> <4B819E4B.5010804@maxwell.research.nokia.com>
In-Reply-To: <4B819E4B.5010804@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002220856.35534.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 21 February 2010 21:57:47 Sakari Ailus wrote:
> Hans Verkuil wrote:
> > Hi Sakari,
> 
> Hi Hans,
> 
> And many thanks for the comments again!
> 
> > Here are some more comments.
> > 
> ...

> >> +
> >> +static void v4l2_event_unsubscribe_all(struct v4l2_fh *fh)
> >> +{
> >> +	struct v4l2_events *events = fh->events;
> >> +	unsigned long flags;
> >> +
> >> +	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
> >> +
> >> +	while (!list_empty(&events->subscribed)) {
> >> +		struct v4l2_subscribed_event *sev;
> >> +
> >> +		sev = list_first_entry(&events->subscribed,
> >> +				       struct v4l2_subscribed_event, list);
> >> +
> >> +		list_del(&sev->list);
> >> +		spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
> >> +		kfree(sev);
> >> +		spin_lock_irqsave(&fh->vdev->fh_lock, flags);
> >> +	}
> >> +
> >> +	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
> >> +}
> > 
> > What about this:
> > 
> > static void v4l2_event_unsubscribe_all(struct v4l2_fh *fh)
> > {
> > 	struct v4l2_events *events = fh->events;
> > 	struct v4l2_subscribed_event *sev;
> > 	unsigned long flags;
> > 
> > 	do {
> > 		sev = NULL;
> > 
> > 		spin_lock_irqsave(&fh->vdev->fh_lock, flags);
> > 		if (!list_empty(&events->subscribed)) {
> > 			sev = list_first_entry(&events->subscribed,
> > 				       struct v4l2_subscribed_event, list);
> > 			list_del(&sev->list);
> > 		}
> > 		spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
> > 		kfree(sev);
> > 	} while (sev);
> > }
> > 
> > This avoids the 'interleaved' locking which I never like.
> 
> Can do. I don't see anything bad in that kind of locking, though. ;-)

Locking is hard to get right. So it is important to keep the locking code as
straightforward as possible. In the original code you really have to look
closely at the code to check that the locking is correct. In the rewritten
code it is much more obvious because of the simplified control flow.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
