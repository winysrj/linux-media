Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:49737 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754298Ab1JRViV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Oct 2011 17:38:21 -0400
Date: Tue, 18 Oct 2011 23:38:11 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sylwester Nawrocki <snjw23@gmail.com>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFC] subdevice PM: .s_power() deprecation?
In-Reply-To: <4E9DEB4A.4050001@gmail.com>
Message-ID: <Pine.LNX.4.64.1110182315180.7139@axis700.grange>
References: <Pine.LNX.4.64.1110031138370.14314@axis700.grange>
 <Pine.LNX.4.64.1110171720260.18438@axis700.grange> <4E9C9D84.5020905@gmail.com>
 <201110180107.20494.laurent.pinchart@ideasonboard.com> <4E9DEB4A.4050001@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 18 Oct 2011, Sylwester Nawrocki wrote:

> Hi Laurent,
> 
> On 10/18/2011 01:07 AM, Laurent Pinchart wrote:
> > On Monday 17 October 2011 23:26:28 Sylwester Nawrocki wrote:
> >> On 10/17/2011 05:23 PM, Guennadi Liakhovetski wrote:
> >>> On Mon, 17 Oct 2011, Sylwester Nawrocki wrote:

[snip]

> >>>> The bridge driver could also choose to keep the sensor powered on,
> >>>> whenever it sees appropriate, to avoid re-enabling the sensor to often.
> >>>
> >>> On what basis would the bridge driver make these decisions? How would it
> >>> know in advance, when it'll have to re-enable the subdev next time?
> >>
> >> Re-enabling by allowing a subdev driver to entirely control the power
> >> state. The sensor might implement "lowest power consumption" policy, while
> >> the user might want "highest performance".
> > 
> > Exactly, that's a policy decision. Would PM QoS help here ?
> 
> Thanks for reminding about PM QoS. I didn't pay much attention to it but it
> indeed appears to be a good fit for this sort of tasks.

But you anyway have to decide - who will implement those PM QoS callbacks? 
The bridge and then decide whether or not to call subdev's .s_power(), or 
the subdev driver itself? I think, the latter, in which case .s_power() 
remain unused.

> We would possibly just need to think of parameters which could be associated with
> video, e.g. video_latency, etc. ?...
> 
> I'm curious whether the whole power handling could be contained within a subdev 
> driver, most likely it could be done for subdevs exposing a devnode.
> 
> > 
> >> I'm referring only to camera sensor subdevs, as I don't have much experience
> >> with other ones.
> >>
> >> Also there are some devices where you want to model power control
> >> explicitly, and it is critical to overall system operation. The s5p-tv
> >> driver is one example of these. The host driver knows exactly how the
> >> power state of its subdevs should be handled.
> > 
> > The host probably knows about how to handle the power state of its internal
> > subdevs, but what about external ones ?
> 
> In this particular example there is no external subdevs associated with the host. 
> 
> But we don't seem to have separate callbacks for internal and external subdevs..
> So removing s_power() puts the above described sort of drivers in trouble.

I understand what you're saying, but can you give us a specific example, 
when a subdev driver (your SoC internal subdev, that is) doesn't have a 
way to react to an event itself and only the bridge driver gets called 
into at that time? Something like an interrupt or an internal timer or 
some other internal event?

> I guess we all agree the power requirements of external subdevs are generally 
> unknown to the hosts.
> 
> For these it might make lot of sense to let the subdev driver handle the device
> power supplies on basis of requests like, s_ctrl, s_stream, etc.  

Yes, right, so, most "external" (sensor, decoder,...) subdev drivers 
should never need to implement .s_power(), regardless of whether we decide 
to keep it or not. Well, ok, no, put it differently - in those drivers 
.s_power() should only really be called during system-wide suspend / 
resume.

> With PM QoS it could be easier to decide in the driver when a device should be
> put in a low power state. 

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
