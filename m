Return-path: <mchehab@gaivota>
Received: from moutng.kundenserver.de ([212.227.126.186]:62129 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754058Ab1DKMQv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Apr 2011 08:16:51 -0400
Date: Mon, 11 Apr 2011 14:16:49 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: javier Martin <javier.martin@vista-silicon.com>,
	linux-media@vger.kernel.org
Subject: Re: mt9t111 sensor on Beagleboard xM
In-Reply-To: <201104111330.40504.laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.1104111352420.18511@axis700.grange>
References: <BANLkTin35p+xPHWkf3WsGNPzL9aeUwsazQ@mail.gmail.com>
 <201104081907.02509.laurent.pinchart@ideasonboard.com>
 <BANLkTikXGVLG6E9TeQc1PQjiybeZxrNYdw@mail.gmail.com>
 <201104111330.40504.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Mon, 11 Apr 2011, Laurent Pinchart wrote:

> Hi Javier,
> 
> On Monday 11 April 2011 11:11:06 javier Martin wrote:
> > Hi Laurent,
> > 
> > > Adding pad-level operations will not break any existing driver, as long
> > > as you keep the existing operations functional.
> > 
> > Is it really possible to have a sensor driver supporting soc-camera,
> > v4l2-subdev and pad-level operations?
> 
> Probably. Guennadi should be able to help you some more with that, he's the 
> soc-camera expert.

I'm afraid, I'm not sufficiently familiar with the (current state of) 
pad-level ops:-)

I don't think, it is a very good idea to support two APIs in sensor 
drivers: pad-level for reuse with ISP and other compatible drivers and 
subdev / soc-camera for soc-camera hosts.

I've tried pad-level ops as I played with the beagleboard-xM and an 
mt9p031 camera module. At that time to use the OMAP3 camera framework you 
had to use MC-aware applications. Standard V4L2 applications had no 
chance. I am not sure, whether this is a limitation of the ISP 
implementation or of the MC / pad APIs themselves. If this is still the 
case and if this backwards-compatible V4L2 mode is indeed difficult to 
implement with MC / pad, then soc-camera cannot migrate to that API atm. 

So, ideally, what should happen, I think, is the following:

1. we make sure, that the new APIs seamlessly support a "classic V4L2" 
fallback mode.

2. migrate (respective parts of) soc-camera to pad-level

3. enable driver reuse, for which, I think, two more things will have to 
be done: (a) create and switch to a unified way to pass driver platform 
data to subdev drivers (soc-camera is currently using struct 
soc_camera_link for this), (b) solve the bus configuration problem.

> > I've been reviewing the code of mt9t112 and I'm not very sure soc-camera
> > code can be easily isolated.
> > 
> > What is the future of soc-camera anyway? Since it seems v4l2-subdev and
> > media-controller clearly make it deprecated.
> 
> My understanding is that soc-camera will stay, but sensor drivers will likely 
> not depend on soc-camera anymore. soc-camera will use pad-level operations, as 
> well as a bus configuration ioctl that has been proposed on the list (but not 
> finalized yet). Guennadi, can you share some information about this ?

We want to reuse sensor drivers, yes:-)

> > Wouldn't it be more suitable to just develop a separate mt9t112 driver
> > which includes v4l2-subdev and pad-level operations without soc-camera?
> 
> I don't think duplicate drivers will be accepted for mainline.

+1

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
