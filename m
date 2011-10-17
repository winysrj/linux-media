Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:64639 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171Ab1JQPXO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Oct 2011 11:23:14 -0400
Date: Mon, 17 Oct 2011 17:23:12 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC] subdevice PM: .s_power() deprecation?
In-Reply-To: <4E9C467E.3090602@samsung.com>
Message-ID: <Pine.LNX.4.64.1110171720260.18438@axis700.grange>
References: <Pine.LNX.4.64.1110031138370.14314@axis700.grange>
 <20111008213657.GE8908@valkosipuli.localdomain> <Pine.LNX.4.64.1110170955560.18438@axis700.grange>
 <4E9C26BC.2010304@samsung.com> <Pine.LNX.4.64.1110171546340.18438@axis700.grange>
 <4E9C467E.3090602@samsung.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 17 Oct 2011, Sylwester Nawrocki wrote:

> On 10/17/2011 03:49 PM, Guennadi Liakhovetski wrote:
> > On Mon, 17 Oct 2011, Sylwester Nawrocki wrote:
> >> On 10/17/2011 10:06 AM, Guennadi Liakhovetski wrote:
> >>> On Sun, 9 Oct 2011, Sakari Ailus wrote:
> >>>> On Mon, Oct 03, 2011 at 12:57:10PM +0200, Guennadi Liakhovetski wrote:
> ...
> >>>> The bridge driver can't (nor should) know about the power management
> >>>> requirements of random subdevs. The name of the s_power op is rather
> >>>> poitless in its current state.
> >>>>
> >>>> The power state of the subdev probably even never matters to the bridge ---
> >>>
> >>> Exactly, that's the conclusion I come to in this RFC too.
> >>>
> >>>> or do we really have an example of that?
> >>>>
> >>>> In my opinion the bridge driver should instead tell the bridge drivers what
> >>>> they can expect to hear from the bridge --- for example that the bridge can
> >>>> issue set / get controls or fmt ops to the subdev. The subdev may or may not
> >>>> need to be powered for those: only the subdev driver knows.
> >>>
> >>> Hm, why should the bridge driver tell the subdev driver (I presume, that's 
> >>> a typo in your above sentence) what to _expect_? Isn't just calling those 
> >>> operations enough?
> >>>
> >>>> This is analogous to opening the subdev node from user space. Anything else
> >>>> except streaming is allowed. And streaming, which for sure requires powering
> >>>> on the subdev, is already nicely handled by the s_stream op.
> >>>>
> >>>> What do you think?
> >>>>
> >>>> In practice the name of s_power should change, as well as possible
> >>>> implementatio on subdev drivers.
> >>>
> >>> But why do we need it at all?
> >>
> >> AFAICS in some TV card drivers it is used to put the analog tuner into low
> >> power state.
> >> So core.s_power op provides the mans to suspend/resume a sub-device.
> >>
> >> If the bridge driver only implements a user space interface for the subdev,
> >> it may want to bring a subdev up in some specific moment, before video.s_stream,
> >> e.g. in some ioctl or at device open(), etc.
> >>
> >> Let's imagine bringing the sensor up takes appr. 700 ms, often we don't want 
> >> the sensor driver to be doing this before every s_stream().
> > 
> > Sorry, I still don't understand, how the bridge driver knows better, than 
> > the subdev driver, whether the user will resume streaming in 500ms or in 
> > 20s? Maybe there's some such information available with tuners, which I'm 
> > just unaware about?
> 
> What I meant was that if the bridge driver assumes in advance that enabling
> sensor's power and getting it fully operational takes long time, it can enable
> sensor's power earlier than it's really necessary, to avoid excessive latencies
> during further actions.

Where would a bridge driver get this information from? And how would it 
know in advance, when power would be "really needed" to enable it 
"earlier?"...

> The bridge driver could also choose to keep the sensor powered on, whenever it
> sees appropriate, to avoid re-enabling the sensor to often. 

On what basis would the bridge driver make these decisions? How would it 
know in advance, when it'll have to re-enable the subdev next time?

> And I'm not convinced the subdev driver has all prerequisites for implementing
> the power control policy.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
