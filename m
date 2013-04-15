Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35045 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717Ab3DOKcs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Apr 2013 06:32:48 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Prabhakar Lad <prabhakar.lad@ti.com>
Subject: Re: [PATCH v8 0/7] V4L2 clock and async patches and soc-camera example
Date: Mon, 15 Apr 2013 12:32:52 +0200
Message-ID: <1962227.hTcMcUbvyo@avalon>
In-Reply-To: <51680291.3080303@samsung.com>
References: <1365433538-15975-1-git-send-email-g.liakhovetski@gmx.de> <Pine.LNX.4.64.1304120733030.1727@axis700.grange> <51680291.3080303@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Friday 12 April 2013 14:48:17 Sylwester Nawrocki wrote:
> On 04/12/2013 08:13 AM, Guennadi Liakhovetski wrote:
> > On Thu, 11 Apr 2013, Sylwester Nawrocki wrote:
> >> On 04/11/2013 11:59 AM, Guennadi Liakhovetski wrote:
> >>> On Mon, 8 Apr 2013, Guennadi Liakhovetski wrote:

[snip]

> >> A significant blocking point IMHO is that this API is bound to the
> >> circular dependency issue between a sub-device and the host driver. I
> >> think we should have at least some specific ideas on how to resolve it
> >> before pushing the API upstream. Or are there any already ?
> > 
> > Of course there is at least one. I wouldn't propose (soc-camera) patches,
> > that lock modules hard into memory, once probing is complete.
> 
> Alright then, maybe I should have more carefully analysed you last patch
> series.
> 
> >> One of the ideas I had was to make a sub-device driver drop the reference
> >> it has to the clock provider module (the host) as soon as it gets
> >> registered to it. But it doesn't seem straightforward with the common
> >> clock API.
> > 
> > It isn't.
> > 
> >> Other option is a sysfs attribute at a host driver that would allow to
> >> release its sub-device(s). But it sounds a bit strange to me to require
> >> userspace to touch some sysfs attributes before being able to remove some
> >> modules.
> >> 
> >> Something probably needs to be changed at the high level design to avoid
> >> this circular dependency.
> > 
> > Here's what I do in my soc-camera patches atm: holding a reference to a
> > (V4L2) clock doesn't increment bridge driver's use-count (for this
> > discussion I describe the combined soc-camera host and soc-camera core
> > functionality as a bridge driver, because that's what most non soc-camera
> > drivers will look like). So, it can be unloaded. Once unloaded, it
> > unregisters its V4L2 async notifier. Inside that the v4l2-async framework
> > first detaches the subdevice driver, then calls the notifier's .unbind()
> > method, which should now unregister the clock. Then, back in
> > v4l2_async_notifier_unregister() the subdevice driver is re-probed, this
> > time with no clock available, so, it re-enters the deferred probing state.
> 
> Ok, it looks better than I thought initially.. :)
> 
> Still, aren't there races possible, when the host driver gets unregistered
> while subdev holds a reference to the clock, and before it gets registered
> to the host ? The likelihood of that seems very low, but I fail to find
> any prove it can't happen either.

That was the concern I was about to raise as well, before reading your e-mail. 
Holding a reference to an object that can disappear at any time is asking for 
trouble. The method currently implemented should work, but is racy in my 
opinion. The bridge module could be unloaded after the subdev gets a reference 
to the clock but before it registers itself with v4l2_async_register_subdev(). 
The clock would then be freed by the bridge, resulting in a crash.

I'm not sure if the circular dependency problem can be solved without an 
explicit way to break the dependency, possibly from userspace (although I'm 
not sure if that's the best solution).

-- 
Regards,

Laurent Pinchart

