Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:60562 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754893Ab0BOKKu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2010 05:10:50 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v4 7/7] V4L: Events: Support all events
Date: Mon, 15 Feb 2010 11:11:03 +0100
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	linux-media@vger.kernel.org, iivanov@mm-sol.com,
	gururaj.nagendra@intel.com, david.cohen@nokia.com
References: <4B72C965.7040204@maxwell.research.nokia.com> <1265813889-17847-7-git-send-email-sakari.ailus@maxwell.research.nokia.com> <201002131542.20916.hverkuil@xs4all.nl>
In-Reply-To: <201002131542.20916.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201002151111.09151.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Saturday 13 February 2010 15:42:20 Hans Verkuil wrote:
> On Wednesday 10 February 2010 15:58:09 Sakari Ailus wrote:
> > Add support for subscribing all events with a special id V4L2_EVENT_ALL.
> > If V4L2_EVENT_ALL is subscribed, no other events may be subscribed.
> > Otherwise V4L2_EVENT_ALL is considered just as any other event.
> 
> We should do this differently. I think that EVENT_ALL should not be used
> internally (i.e. in the actual list of subscribed events), but just as a
> special value for the subscribe and unsubscribe ioctls. So when used with
> unsubscribe you can just unsubscribe all subscribed events and when used
> with subscribe, then you just subscribe all valid events (valid for that
> device node).
> 
> So in v4l2-event.c you will have a v4l2_event_unsubscribe_all() to quickly
> unsubscribe all events.
> 
> In order to easily add all events from the driver it would help if the
> v4l2_event_subscribe and v4l2_event_unsubscribe just take the event type
> as argument rather than the whole v4l2_event_subscription struct.
> 
> You will then get something like this in the driver:
> 
> 	if (sub->type == V4L2_EVENT_ALL) {
> 		int ret = v4l2_event_alloc(fh, 60);
> 
> 		ret = ret ? ret : v4l2_event_subscribe(fh, V4L2_EVENT_EOS);
> 		ret = ret ? ret : v4l2_event_subscribe(fh, V4L2_EVENT_VSYNC);
> 		return ret;
> 	}
> 
> An alternative might be to add a v4l2_event_subscribe_all(fh, const u32
> *events) where 'events' is a 0 terminated list of events that need to be
> subscribed.

Then don't call it v4l2_event_subscribe_all if it only subscribes to a set of 
event :-)

> For each event this function would then call:
> 
> fh->vdev->ioctl_ops->vidioc_subscribe_event(fh, sub);
> 
> The nice thing about that is that in the driver you have a minimum of fuss.
> 
> I'm leaning towards this second solution due to the simple driver
> implementation.
> 
> Handling EVENT_ALL will simplify things substantially IMHO.

I'm wondering if subscribing to all events should be allowed. Do we have use 
cases for that ? I'm always a bit cautious when adding APIs with no users, as 
that means the API has often not been properly tested against possible use 
cases and mistakes will need to be supported forever (or at least for a long 
time).

-- 
Regards,

Laurent Pinchart
