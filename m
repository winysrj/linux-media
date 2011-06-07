Return-path: <mchehab@pedra>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:2820 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761Ab1FGMUu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jun 2011 08:20:50 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: David Cohen <dacohen@gmail.com>
Subject: Re: RFC: Proposal to change the way pending events are handled
Date: Tue, 7 Jun 2011 14:20:45 +0200
Cc: linux-media@vger.kernel.org,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <201106071329.42447.hverkuil@xs4all.nl> <BANLkTineZ1ucUXhBYXXSDYO_AYWoQ1hEbw@mail.gmail.com>
In-Reply-To: <BANLkTineZ1ucUXhBYXXSDYO_AYWoQ1hEbw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201106071420.45863.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday, June 07, 2011 13:51:38 David Cohen wrote:
> Hi Hans,
> 
> On Tue, Jun 7, 2011 at 2:29 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > While working on the control events I realized that the way we handle pending
> > events is rather complicated.
> >
> > What currently happens internally is that you have to allocate a fixed sized
> > list of events. New events are queued on the 'available' list and when they
> > are processed by the application they are queued on the 'free' list.
> >
> > If the 'free' list is empty, then no new events can be queued and you will
> > drop events.
> >
> > Dropping events can be nasty and in the case of control events can cause a
> > control panel to contain stale control values if it missed a value change
> > event.
> 
> I remember it was a topic I discussed with Sakari.
> 
> >
> > One option is to allocate enough events, but what is 'enough' events? That
> > depends on many factors. And allocating more events than is necessary wastes
> > memory.
> 
> Cases where events are lost are exception and IMO "enough" events
> would be almost always waste of memory.

The problem with exceptions is that they *do* happen and you need a way to
deal with them sensibly. One way of doing that is to ensure that for each
subscribed event you can get at least the latest raised event of that type.

> >
> > But what might be a better option is this: for each event a filehandle
> > subscribes to there is only one internal v4l2_kevent allocated.
> >
> > This struct is either marked empty (no event was raised) or contains the
> > latest state of this event. When the event is dequeued by the application
> > the struct is marked empty again.
> >
> > So you never get duplicate events, instead, if a 'duplicate' event is raised
> > it will just overwrite the 'old' event and move it to the end of the list of
> > pending events. In other words, the old event is removed and the new event is
> > inserted instead.
> 
> That's an interesting proposal. Currently it will have impact at least
> on statistics collection OMAP3ISP driver. It brings to my mind 2
> points:
>  - OMAP3ISP triggers one event for each statistic buffers produced. If
> we avoid events "duplication", userapp will miss a statistic buffer.
> It's possible to bypass this problem, but the OMAP3 ISP statistics'
> private interface should be updated as well.

Two thoughts: first of all given the current internal event architecture
there are no guarantees that the event can even be raised (e.g. if another
event flooded the system with events). Secondly, perhaps we should allocate
events per event type. So for the statistics collection event would might
want to reserve X events. And if the app doesn't read events fast enough,
then the oldest event would be lost.

BTW, isn't statistics associated with a frame? So if you read too slow,
then does it matter that you lose the older statistics?

>  - To define a standard for statistics collection is something we need
> to do to avoid new ISP's to always create custom interfaces.
> 
> >
> > The nice thing about this is that for each subscribed event type you will
> > never lose a raised event completely. You may lose intermediate events, but
> > the latest event for that type will always be available.
> 
> I may have a suggestion. If some event is affected by the number of
> times it was triggered (like the statistic ones mentioned above),
> instead of a bool "empty flag", it may contain a counter. Then a
> "duplicated" event will be raised and will still inform how many
> intermediate events were "lost". After event is dequeued once, the
> counter could be reset.

I'm not sure what you mean. If you mean that we can report the number of
lost events in struct v4l2_event, then I agree with that.

Regards,

	Hans

> 
> Regards,
> 
> David Cohen
> 
> >
> > E.g. supposed you subscribed to a control containing the status of the HDMI
> > hotplug. Connecting an HDMI cable can cause a bounce condition where the HDMI
> > hotplug toggles many times in quick succession. This could currently flood
> > the event queue and you may lose the last event. With the proposed change the
> > last event will always arrive, although the intermediate events will be lost.
> >
> > Comments?
> >
> > Regards,
> >
> >        Hans
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
