Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:38202 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751689AbaGDJyS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Jul 2014 05:54:18 -0400
Message-ID: <53B679C2.7030002@xs4all.nl>
Date: Fri, 04 Jul 2014 11:54:10 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Divneil Wadhawan <divneil@outlook.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: No audio support in struct v4l2_subdev_format
References: <BAY176-W7B3F24A204E68896226E0A9000@phx.gbl>,<53B65DCA.6010803@xs4all.nl> <BAY176-W23C9AA5FB70F17EDEB68F8A9000@phx.gbl>
In-Reply-To: <BAY176-W23C9AA5FB70F17EDEB68F8A9000@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Divneil,

On 07/04/2014 11:30 AM, Divneil Wadhawan wrote:
> Hi Hans,
> 
> 
>> To my knowledge nobody has done much if any work on this. Usually
>> the audio part is handled by alsa, but it is not clear if support
>> is also needed from the V4L2 API.
> 
> Actually, the application needs to know when to ask the capture
> device to start capturing.
> 
> Let's say, the cable is already plugged in/or plugged out.
> 
> So, any events will be missed as the driver state machine starts
> during boot up and app is not started.
> 
> App starts later, registers for (V4L2_EVENT_SOURCE_CHANGE back
> ported to 3.10) and listens, but will not receive any as they are
> already generated.

I don't understand the problem. When the application starts the first thing it should
do is to call VIDIOC_QUERY_DV_TIMINGS: that will tell it if any signal is present.

An alternative might be to extend v4l2_src_change_event_subscribe() and have it honor
the V4L2_EVENT_SUB_FL_SEND_INITIAL flag: if set, it should issue this event at once.
That might actually be a nice improvement.

> 
> 
> So, the application is in a blind spot whether to start capture or
> not.

But what has that to do with audio?

> If we get the same interface as video it's good. I mean G_FMT with a
> union for audio as well.
> 
> Otherwise, I can go with a proprietary control/ioctl indicating
> whether audio is valid or not.
> 
> ioctl seems to be an easy choice, because this subdev is not
> exposing any controls, so, registration with ctrl framework for a
> single one seems a bit of overload.

It's perfectly fine to have a single control. Nothing wrong with that.

Still not sure what you actually need in V4L2 w.r.t. the audio information.


Regards,

	Hans
