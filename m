Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:63336 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944Ab2JQPKP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Oct 2012 11:10:15 -0400
Date: Wed, 17 Oct 2012 17:10:12 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: linux-kernel@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [Q] reprobe deferred-probing drivers
In-Reply-To: <20121017150217.GA29424@kroah.com>
Message-ID: <Pine.LNX.4.64.1210171707250.7402@axis700.grange>
References: <Pine.LNX.4.64.1210171021060.7402@axis700.grange>
 <20121017150217.GA29424@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 17 Oct 2012, Greg Kroah-Hartman wrote:

> On Wed, Oct 17, 2012 at 10:27:36AM +0200, Guennadi Liakhovetski wrote:
> > Hi
> > 
> > I've got a situation, for which I currently don't have a (good) solution.
> > 
> > Let's say device A depends on device B and as long as B hasn't probed, A 
> > requests deferred probing. Now B probes, which causes A to also succeed 
> > its probing. Next we want to remove B, say, by unloading its driver. A has 
> > to go back into "deferred-probing" state. How do we do it? This can be 
> > achieved by unloading B's driver and loading again. Essentially, we have 
> > to use the sysfs "unbind" and then the "bind" attributes. But how do we do 
> > this from the kernel? Shall we export driver_bind() and driver_unbind()?
> 
> No, no driver should ever have to mess with that at all, it is up to the
> bus to do this.  Do you have a pointer to the code you are concerned
> about?

No, not yet. I'm currently working on it. I'll do it using the

		device_release_driver(sd->dev);
		device_attach(sd->dev);

trick and post to linux-media. I'll (try to remember to) add you to cc, 
then we can see how to properly implement it.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
