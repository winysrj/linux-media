Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:1120 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657Ab0BWHQ6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2010 02:16:58 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [PATCH 6/6] V4L: Events: Add documentation
Date: Tue, 23 Feb 2010 08:19:24 +0100
Cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	david.cohen@nokia.com
References: <4B82A7FB.50505@maxwell.research.nokia.com> <201002230020.27454.hverkuil@xs4all.nl> <4B8312E2.4000201@maxwell.research.nokia.com>
In-Reply-To: <4B8312E2.4000201@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002230819.24988.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 23 February 2010 00:27:30 Sakari Ailus wrote:
> Hans Verkuil wrote:
> > On Monday 22 February 2010 23:47:49 Sakari Ailus wrote:
> >>>> +Drivers do not initialise events directly. The events are initialised
> >>>> +through v4l2_fh_init() if video_device->ioctl_ops->vidioc_subscribe_event is
> >>>> +non-NULL. This *MUST* be performed in the driver's
> >>>> +v4l2_file_operations->open() handler.
> >>>> +
> >>>> +Events are delivered to user space through the poll system call. The driver
> >>>> +can use v4l2_fh->events->wait wait_queue_head_t as the argument for
> >>>> +poll_wait().
> >>>> +
> >>>> +There are standard and private events. New standard events must use the
> >>>> +smallest available event type. The drivers must allocate their events
> >>>> +starting from base (V4L2_EVENT_PRIVATE_START + n * 1024) while individual
> >>>> +events start from base + 1.
> >>>
> >>> What do you mean with 'while individual events start from base + 1'? I still
> >>> don't understand that phrase.
> >>
> >> Will be "There are standard and private events. New standard events must
> >> use the smallest available event type. The drivers must allocate their
> >> events starting from base (V4L2_EVENT_PRIVATE_START + n * 1024) + 1." in
> >> the next one.
> > 
> > Ah, OK. But why '+ 1'? I don't really see a reason for that to be honest.
> > Am I missing something?
> 
> Many V4L2 control classes do that. No other reason really. :-) Can be
> removed on my behalf.

Then this can be removed. There are reasons for doing that with controls, but
those reasons do not apply to events (mostly to do with the CTRL_NEXT flag).

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
