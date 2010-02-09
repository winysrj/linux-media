Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:34105 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752822Ab0BIMnl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Feb 2010 07:43:41 -0500
Date: Tue, 9 Feb 2010 13:44:18 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-pm@lists.linux-foundation.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Valentin Longchamp <valentin.longchamp@epfl.ch>
Subject: Re: [PATCH/RESEND] soc-camera: add runtime pm support for   subdevices
In-Reply-To: <2aa8130b9fd7fe9f9fb2cf626ff58831.squirrel@webmail.xs4all.nl>
Message-ID: <Pine.LNX.4.64.1002091329500.4585@axis700.grange>
References: <Pine.LNX.4.64.1002081044150.4936@axis700.grange>   
 <4B7012D1.40605@redhat.com>    <Pine.LNX.4.64.1002081447020.4936@axis700.grange>
    <4B705216.7040907@redhat.com>    <Pine.LNX.4.64.1002091053470.4585@axis700.grange>
    <26fe28e3dda70da4d133a9dbc3f2bc74.squirrel@webmail.xs4all.nl>   
 <Pine.LNX.4.64.1002091252530.4585@axis700.grange>
 <2aa8130b9fd7fe9f9fb2cf626ff58831.squirrel@webmail.xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 9 Feb 2010, Hans Verkuil wrote:

> > Of course you're right, and it concerns not only multiple streaming modes,
> > but simple cases of multiple openings of one node. I was too fast to
> > transfer the implementation from soc-camera to v4l2 - in soc-camera I'm
> > counting opens and closes and only calling pm hooks on first open and last
> > close. So, if we want to put it in v4l-core, we'd have to do something
> > similar, I presume.
> 
> I wouldn't mind having such counters. There are more situations where
> knowing whether it is the first open or last close comes in handy.
> 
> However, in general I think that pm shouldn't be done in the core. It is
> just too hardware dependent. E.g. there may both capture and display video
> nodes in the driver. And when the last capture stops you can for example
> power down the receiver chips.

In this example, don't you have two struct video_device instances, so, 
last close of one of them will call pm_runtime_suspend() for _that_ 
device, without affecting the other?

> The same with display and transmitter
> chips. But if both are controlled by the same driver, then a general open
> counter will not work either.

Well, first, you'd get a counter per video_device, not per driver, but 
you, probably mean cases with multiple "entities" attached to one device 
node. But even in this case, your suspend is called, and you can decide, 
whether you actually can suspend and suspend all children, or fail and 
return -EBUSY... I was expecting to implement these pm callbacks in bridge 
drivers, where you might have an overview of your components.

Otherwise, I can happily carry this in soc-camera for now, I'd just 
request to officially reserve vdev->dev.type for these purposes.

> But if you have ideas to improve the core to make it easier to add pm
> support to the drivers that need it, then I am all for it.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
