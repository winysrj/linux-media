Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:55769 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755385Ab0ASIW4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jan 2010 03:22:56 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC v2 0/7] V4L2 file handles and event interface
Date: Tue, 19 Jan 2010 09:23:06 +0100
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Ivan T. Ivanov" <iivanov@mm-sol.com>,
	Guru Raj <gururaj.nagendra@intel.com>
References: <4B30F713.8070004@maxwell.research.nokia.com> <alpine.LNX.2.01.1001181359590.31857@alastor>
In-Reply-To: <alpine.LNX.2.01.1001181359590.31857@alastor>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001190923.06430.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Monday 18 January 2010 14:07:33 Hans Verkuil wrote:
> On Tue, 22 Dec 2009, Sakari Ailus wrote:
> > Hi,
> >
> > Here's the second version of the V4L2 file handle and event interface
> > patchset. Still RFC since I'd like to get more feedback on it.
> >
> > The first patch adds the V4L2 file handle support and the rest are for
> > V4L2 events.
> >
> > The patchset works with the OMAP 3 ISP driver. Patches for OMAP 3 ISP are
> > not part of this patchset but are available in Gitorious (branch is
> > called events):
> >
> > 	git://gitorious.org/omap3camera/mainline.git event
> >
> > The major change since the last one v4l2_fh structure is now part of
> > driver's own file handle. It's used as file->private_data as well. I did
> > this based on Hans Verkuil's suggestion. Sequence numbers and event queue
> > length limitation is there as well. There are countless of smaller
> > changes, too.
> >
> > A few notes on the patches:
> >
> > - I don't like the locking too much. Perhaps the file handle specific
> > lock (events->lock) could be dropped in favour of the lock for
> > v4l2_file_handle in video_device?
> >
> > - Poll. The V4L2 specifiction says:
> >
> > 	"When the application did not call VIDIOC_QBUF or
> > 	VIDIOC_STREAMON yet the poll() function succeeds, but sets the
> > 	POLLERR flag in the revents field."
> >
> >  The current events for OMAP 3 ISP are related to streaming but not all
> > might be in future. For example there might be some radio or DVB related
> > events.
> 
> I know for sure that we will have to be able to handle events when not
> streaming. E.g. events that tell when a HDMI connector was plugged in
> or when the EDID was read will need to arrive whether streaming is on
> or off.

I agree with you. The V4L2 specification will then need to be changed, 
otherwise we won't be able to poll() for events. poll() wouldn't return 
immediately anymore if no buffer is queued or if the device isn't streaming. 
That might break existing applications (although we could argue that some of 
those applications are somehow broken already if they rely on such a weird 
feature).

If we want to avoid disturbing existing applications we could still return 
POLLERR immediately when not streaming if no event has been subscribed to.

> > - Sequence numbers are local to file handles.
> 
> That is how it should be.
> 
> > - Subscribing V4L2_EVENT_ALL causes any other events to be unsubscribed.
> >
> > - If V4L2_EVENT_ALL has been subscribed, unsubscribing any one of the
> > events leads to V4L2_EVENT_ALL to be unsubscribed. This problem would be
> > difficult to work around since this would require the event system to be
> > aware of the driver private events as well.
> 
> Good point. Perhaps attempting to unsubscribe a single event when EVENT_ALL
> has been subscribed should result in an error? I.e., you can only
> unsubscribe ALL when you subscribed to ALL in the first place.

-- 
Regards,

Laurent Pinchart
