Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39063 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261Ab1FGLvk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jun 2011 07:51:40 -0400
Received: by wya21 with SMTP id 21so3488110wya.19
        for <linux-media@vger.kernel.org>; Tue, 07 Jun 2011 04:51:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201106071329.42447.hverkuil@xs4all.nl>
References: <201106071329.42447.hverkuil@xs4all.nl>
Date: Tue, 7 Jun 2011 14:51:38 +0300
Message-ID: <BANLkTineZ1ucUXhBYXXSDYO_AYWoQ1hEbw@mail.gmail.com>
Subject: Re: RFC: Proposal to change the way pending events are handled
From: David Cohen <dacohen@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

On Tue, Jun 7, 2011 at 2:29 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> While working on the control events I realized that the way we handle pending
> events is rather complicated.
>
> What currently happens internally is that you have to allocate a fixed sized
> list of events. New events are queued on the 'available' list and when they
> are processed by the application they are queued on the 'free' list.
>
> If the 'free' list is empty, then no new events can be queued and you will
> drop events.
>
> Dropping events can be nasty and in the case of control events can cause a
> control panel to contain stale control values if it missed a value change
> event.

I remember it was a topic I discussed with Sakari.

>
> One option is to allocate enough events, but what is 'enough' events? That
> depends on many factors. And allocating more events than is necessary wastes
> memory.

Cases where events are lost are exception and IMO "enough" events
would be almost always waste of memory.

>
> But what might be a better option is this: for each event a filehandle
> subscribes to there is only one internal v4l2_kevent allocated.
>
> This struct is either marked empty (no event was raised) or contains the
> latest state of this event. When the event is dequeued by the application
> the struct is marked empty again.
>
> So you never get duplicate events, instead, if a 'duplicate' event is raised
> it will just overwrite the 'old' event and move it to the end of the list of
> pending events. In other words, the old event is removed and the new event is
> inserted instead.

That's an interesting proposal. Currently it will have impact at least
on statistics collection OMAP3ISP driver. It brings to my mind 2
points:
 - OMAP3ISP triggers one event for each statistic buffers produced. If
we avoid events "duplication", userapp will miss a statistic buffer.
It's possible to bypass this problem, but the OMAP3 ISP statistics'
private interface should be updated as well.
 - To define a standard for statistics collection is something we need
to do to avoid new ISP's to always create custom interfaces.

>
> The nice thing about this is that for each subscribed event type you will
> never lose a raised event completely. You may lose intermediate events, but
> the latest event for that type will always be available.

I may have a suggestion. If some event is affected by the number of
times it was triggered (like the statistic ones mentioned above),
instead of a bool "empty flag", it may contain a counter. Then a
"duplicated" event will be raised and will still inform how many
intermediate events were "lost". After event is dequeued once, the
counter could be reset.

Regards,

David Cohen

>
> E.g. supposed you subscribed to a control containing the status of the HDMI
> hotplug. Connecting an HDMI cable can cause a bounce condition where the HDMI
> hotplug toggles many times in quick succession. This could currently flood
> the event queue and you may lose the last event. With the proposed change the
> last event will always arrive, although the intermediate events will be lost.
>
> Comments?
>
> Regards,
>
>        Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
