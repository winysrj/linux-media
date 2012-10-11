Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53675 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751927Ab2JKTsw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Oct 2012 15:48:52 -0400
Date: Thu, 11 Oct 2012 22:48:46 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 05/14] media: add a V4L2 OF parser
Message-ID: <20121011194845.GQ14107@valkosipuli.retiisi.org.uk>
References: <1348754853-28619-1-git-send-email-g.liakhovetski@gmx.de>
 <201210051241.52205.hverkuil@xs4all.nl>
 <Pine.LNX.4.64.1210051250210.13761@axis700.grange>
 <201210051323.45571.hverkuil@xs4all.nl>
 <Pine.LNX.4.64.1210081306240.12203@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1210081306240.12203@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Mon, Oct 08, 2012 at 02:23:25PM +0200, Guennadi Liakhovetski wrote:
...
> If we do it from the bridge driver, we could install an I2C bus-notifier, 
> _before_ the subdevice driver is probed, i.e. upon the 
> BUS_NOTIFY_BIND_DRIVER event we could turn on the clock. If subdevice 
> probing was successful, we can then wait for the BUS_NOTIFY_BOUND_DRIVER 
> event to switch the clock back off. BUT - if the subdevice fails probing? 
> How do we find out about that and turn the clock back off? There is no 
> notification event for that... Possible solutions:
> 
> 1. timer - ugly and unreliable.
> 2. add a "probing failed" notifier event to the device core - would this 
>    be accepted?
> 3. let the subdevice turn the master clock on and off for the duration of 
>    probing.
> 
> My vote goes for (3). Ideally this should be done using the generic clock 
> framework. But can we really expect all drivers and platforms to switch to 
> it quickly enough? If not, we need a V4L2-specific callback from subdevice 
> drivers to bridge drivers to turn the clock on and off. That's what I've 
> done "temporarily" in this patch series for soc-camera.

I'd say the clock has to be controlled by the sub-device driver. Sensors
also have a power-up (and power-down) sequences that should be followed.
Usually they also involve switching the external clock on (and off) at a
given point of time.

Also the OMAP 3 provides that clock through ISP so it, too, requires the
generic clock framework to function with DT.

> Suppose we decide to do the same for V4L2 centrally - add call-backs. Then 

I'd prefer to use the generic clock framework, albeit I admit it may take
some time till all the relevant platforms support it. Nevertheless, if
there's going to be a temporary solution it should be removed once the
clock framework support is there.

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
