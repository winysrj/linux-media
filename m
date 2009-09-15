Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:35311 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175AbZIOOcl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Sep 2009 10:32:41 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: Media controller: sysfs vs ioctl
Date: Tue, 15 Sep 2009 16:33:40 +0200
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Nathaniel Kim <dongsoo.kim@gmail.com>,
	linux-media@vger.kernel.org
References: <200909120021.48353.hverkuil@xs4all.nl> <200909131543.02990.hverkuil@xs4all.nl> <20090913110001.20976a03@caramujo.chehab.org>
In-Reply-To: <20090913110001.20976a03@caramujo.chehab.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200909151633.40370.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 13 September 2009 16:00:01 Mauro Carvalho Chehab wrote:
> Em Sun, 13 Sep 2009 15:43:02 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> > On Sunday 13 September 2009 15:27:57 Mauro Carvalho Chehab wrote:
> > > Em Sun, 13 Sep 2009 15:13:04 +0900
> > > Nathaniel Kim <dongsoo.kim@gmail.com> escreveu:

[snip]

> > > > I think this is a good approach and I also had in my mind that sysfs
> > > > might be a good method if we could control and monitor through this.
> > > > Recalling memory when we had a talk in San Francisco, I was frustrated
> > > > that there is no way to catch events from sort of sub-devices like
> > > > lens actuator (I mean pizeo motors in camera module). As you know lens
> > > > actuator is an extremely slow device in comparison with common v4l2
> > > > devices we are using and we need to know whether it has succeeded or
> > > > not in moving to expected position.
> > > > So I considered sysfs and udev as candidates for catching events from
> > > > sub-devices. events like success/failure of lens movement, change of
> > > > status of subdevices.
> > > > Does anybody experiencing same issue? I think I've seen a lens
> > > > controller driver in omap3 kernel from TI but not sure how did they
> > > > control that.
> > > >
> > > > My point is that we need a kind of framework to give and event to
> > > > user space and catching them properly just like udev does.
> > >
> > > Maybe the Kernel event interface could be used for that.
> >
> > Are you talking about the input event interface? There is no standard
> > kernel way of doing events afaik.
> 
> Yes. It is designed for low-latency report of events, like mouse movements,
> where you expect that the movement will happen as mouse moves. So, it may
> work fine also for servo movements. A closer look on it, plus some tests
> should be done to see if it will work fine for such camera events.

The interface was designed for low-latency report of input events, but it 
doesn't fit the purpose of generic event reporting we need here. Devices need 
to report events such as "statistics are ready", "the video signal is lost", 
"the USB cable has been connected", ... The input event interface wasn't meant 
for that, and using it for such purpose will probably lead to funny results 
when applications expecting button or key presses will start getting such 
events.

Another solution might be to use netlink. That's how generic (non-button) ACPI 
events are reported to userspace. The disadvantage compared to using v4l 
ioctls & select() would be that an application would need to implement netlink 
access in order to get v4l events.

-- 
Laurent Pinchart
