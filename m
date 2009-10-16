Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:48372 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759014AbZJPMjK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Oct 2009 08:39:10 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [RFC] Video events, version 2
Date: Fri, 16 Oct 2009 14:41:18 +0200
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Zutshi Vimarsh (Nokia-D-MSW/Helsinki)" <vimarsh.zutshi@nokia.com>,
	Ivan Ivanov <iivanov@mm-sol.com>,
	Cohen David Abraham <david.cohen@nokia.com>,
	Guru Raj <gururaj.nagendra@intel.com>
References: <4AD5CBD6.4030800@maxwell.research.nokia.com> <200910161024.13340.laurent.pinchart@ideasonboard.com> <4AD86854.8060803@maxwell.research.nokia.com>
In-Reply-To: <4AD86854.8060803@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910161441.18415.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 16 October 2009 14:34:28 Sakari Ailus wrote:
> Laurent Pinchart wrote:
> > On Friday 16 October 2009 09:36:51 Sakari Ailus wrote:
> >> Hans Verkuil wrote:
> >>> On Thursday 15 October 2009 23:11:33 Laurent Pinchart wrote:
> >>>> For efficiency reasons a V4L2_G_EVENTS ioctl could also be provided to
> >>>> retrieve multiple events.
> >>>>
> >>>> struct v4l2_events {
> >>>> 	__u32 count;
> >>>> 	struct v4l2_event __user *events;
> >>>> };
> >>>>
> >>>> #define VIDIOC_G_EVENTS _IOW('V', xx, struct v4l2_events)
> >>>
> >>> Hmm. Premature optimization. Perhaps as a future extension.
> >>
> >> That *could* save one ioctl sometimes --- then you'd no there are no
> >> more events coming right now. But just one should be supported IMO,
> >> VIDIOC_G_EVENT or VIDIOC_G_EVENTS.
> >
> > I forgot to mention in my last mail that we should add a flag to the
> > v4l2_event structure to report if more events are pending (or even
> > possible a pending event count).
> 
> Then the V4L (or driver) would have to check the queue for that type of
> events. OTOH, the queue size could be quite small and it'd never
> overflow since the maximum size is number of different event types.
> 
> Can there be situations when the first or last event timestamp of
> certain event would be necessary? If we put count there, then we need to
> make a decision which one is useful for the userspace. The last one is
> obviously useful for the AF/AEWB algorightms. I currently see no use for
> the first one, but that doesn't mean there couldn't be use for it.

That's not what I meant. The idea of a count field is to report the number of 
events still pending after that one, type aside. If v4l2_event::count equals 0 
the userspace application will know there is no need to call VIDIOC_G_EVENT 
just to get a -EAGAIN. 

-- 
Laurent Pinchart
