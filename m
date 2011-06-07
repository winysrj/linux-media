Return-path: <mchehab@pedra>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3830 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085Ab1FGL3r (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jun 2011 07:29:47 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: RFC: Proposal to change the way pending events are handled
Date: Tue, 7 Jun 2011 13:29:42 +0200
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201106071329.42447.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

While working on the control events I realized that the way we handle pending
events is rather complicated.

What currently happens internally is that you have to allocate a fixed sized
list of events. New events are queued on the 'available' list and when they
are processed by the application they are queued on the 'free' list.

If the 'free' list is empty, then no new events can be queued and you will
drop events.

Dropping events can be nasty and in the case of control events can cause a
control panel to contain stale control values if it missed a value change
event.

One option is to allocate enough events, but what is 'enough' events? That
depends on many factors. And allocating more events than is necessary wastes
memory.

But what might be a better option is this: for each event a filehandle
subscribes to there is only one internal v4l2_kevent allocated.

This struct is either marked empty (no event was raised) or contains the
latest state of this event. When the event is dequeued by the application
the struct is marked empty again.

So you never get duplicate events, instead, if a 'duplicate' event is raised
it will just overwrite the 'old' event and move it to the end of the list of
pending events. In other words, the old event is removed and the new event is
inserted instead.

The nice thing about this is that for each subscribed event type you will
never lose a raised event completely. You may lose intermediate events, but 
the latest event for that type will always be available.

E.g. supposed you subscribed to a control containing the status of the HDMI
hotplug. Connecting an HDMI cable can cause a bounce condition where the HDMI
hotplug toggles many times in quick succession. This could currently flood
the event queue and you may lose the last event. With the proposed change the
last event will always arrive, although the intermediate events will be lost.

Comments?

Regards,

	Hans
