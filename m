Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:47266 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751385AbZIZJcJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Sep 2009 05:32:09 -0400
Date: Sat, 26 Sep 2009 11:32:14 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: V4L-DVB Summit Day 1
In-Reply-To: <5e9665e10909260140v2030ab5bvb7c1bed5e358319b@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0909261103310.4273@axis700.grange>
References: <200909232239.20105.hverkuil@xs4all.nl>
 <Pine.LNX.4.64.0909242000240.4913@axis700.grange>
 <5e9665e10909260140v2030ab5bvb7c1bed5e358319b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 26 Sep 2009, Dongsoo, Nathaniel Kim wrote:

> On Fri, Sep 25, 2009 at 3:07 AM, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
> > Hi Hans
> >
> > Thanks for keeping us updated. One comment:
> >
> > On Wed, 23 Sep 2009, Hans Verkuil wrote:
> >
> >> In the afternoon we discussed the proposed timings API. There was no
> >> opposition to this API. The idea I had to also use this for sensor setup
> >> turned out to be based on a misconception on how the S_FMT relates to sensors.
> >> ENUM_FRAMESIZES basically gives you the possible resolutions that the scaler
> >> hidden inside the bridge can scale the native sensor resolution. It does not
> >> enumerate the various native sensor resolutions, since there is only one. So
> >> S_FMT really sets up the scaler.
> >
> > Just as Jinlu Yu noticed in his email, this doesn't reflect the real
> > situation, I am afraid. You can use binning and skipping on the sensor to
> > scale the image, and you can also use the bridge to do the scaling, as you
> > say. Worth than that, there's also a case, where there _several_ ways to
> > perform scaling on the sensor, among which one can freely choose, and the
> > host can scale too. And indeed it makes sense to scale on the source to
> > save the bandwidth and thus increase the framerate. So, what I'm currently
> > doing on sh-mobile, I try to scale on the client - in the best possible
> > way. And then use bridge scaling to provide the exact result.
> >
> 
> Yes I do agree with you. And it is highly necessary to provide a clear
> method which obviously indicates which device to use in scaling job.
> When I use some application processors which provide camera
> peripherals with scaler inside and external ISP attached, there is no
> way to use both scaler features inside them. I just need to choose one
> of them.

Well, I don't necessarily agree, in fact, I do use both scaling engines in 
my sh setup. The argument is as mentioned above - bus usage and framerate 
optimisation. So, what I am doing is: I try to scale on the sensor as 
close as possible, and then scale further on the host (SoC). This works 
well, only calculations are not very trivial. But you only have to perform 
them once during setup, so, it's not time-critical. Might be worth 
implementing such calculations somewhere centrally to reduce error chances 
in specific drivers. Same with cropping.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
