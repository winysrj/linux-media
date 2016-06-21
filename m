Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:53960 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbcFUX7W (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jun 2016 19:59:22 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Pavel Machek <pavel@ucw.cz>, Hans Verkuil <hverkuil@xs4all.nl>,
	pali.rohar@gmail.com, sre@kernel.org,
	kernel list <linux-kernel@vger.kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
	aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com,
	patrikbachan@gmail.com, serge@hallyn.com, tuukkat76@gmail.com,
	mchehab@osg.samsung.com, linux-media@vger.kernel.org
Subject: Re: camera application for testing (was Re: v4l subdevs without big device)
Date: Wed, 22 Jun 2016 02:59:40 +0300
Message-ID: <1500395.gQ70N9eqVS@avalon>
In-Reply-To: <20160501140831.GH26360@valkosipuli.retiisi.org.uk>
References: <20160428084546.GA9957@amd> <20160429221359.GA29297@amd> <20160501140831.GH26360@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Sunday 01 May 2016 17:08:31 Sakari Ailus wrote:
> On Sat, Apr 30, 2016 at 12:13:59AM +0200, Pavel Machek wrote:
> > Hi!
> > 
> > What is reasonable camera application for testing?
> > 
> > N900 looks like a low-end digital camera. I have now have the hardware
> > working (can set focus to X cm using command line), but that's not
> > going to be useful for taking photos.
> 
> I guess you already knew about omap3camd; it's proprietary but from purely
> practical point of view it'd be an option to support taking photos on the
> N900. That would not be extensible any way, the best possible functionality
> is limited what the daemon implements.
> 
> I'm just mentioning the option of implementing wrapper for the omap3camd so
> that it can work with upsteam APIs, I don't propose that however.
> 
> > In particular, who is going to do computation neccessary for
> > autofocus, whitebalance and exposure/gain?
> 
> I think libv4l itself has algorithms to control at least some of these. It
> relies on the image data so the CPU time consumption will be high.
> 
> AFAIR Laurent has also worked on implementing some algorithms that use the
> histogram and some of the statistics. Add him to cc list.

http://git.ideasonboard.org/omap3-isp-live.git

That's outdated and might not run or compile anymore. The code is more of a 
proof of concept implementation, but it could be used as a starting point. 
With an infinite amount of free time I'd love to work on an open-source 
project for computational cameras, integrating it with libv4l.

> > There's http://fcam.garage.maemo.org/gettingStarted.html that should
> > work on maemo, but a) it is not in Debian, b) it has non-trivial
> > dependencies and c) will be a lot of fun to get working...
> > (and d), will not be too useful, anyway, due to 1sec shutter lag:
>
> I believe this will be shorter nowadays. I don't remember the exact
> technical solution which the text below refers to but I'm pretty sure it'll
> be better with the current upstream. API-wise, there's work to be done there
> (to port FCAM to upsteram APIs) but it's a possibility.
> 
> > Fast resolution switching (less shutter lag)
> > FCam is built on top of V4L2, which doesn't handle rapidly varying
> > resolutions. When a Shot with a different resolution to the previous
> > one comes down the pipeline, FCam currently flushes the entire V4L2
> > pipeline, shuts down and restarts the whole camera subsystem, then
> > starts streaming at the new resolution. This takes a long time (nearly
> > a second), and is the cause of the horrible shutter lag on the N900. A
> > brave kernel hacker may be able to reduce this time by fiddling with
> > the FCam ISP kernel modules and the guts of the FCam library source
> > (primarily Daemon.cpp).
> > Anyone who solves this one will have our undying gratitude. An ideal
> > solution would be able to insert a 5MP capture into a stream of
> > 640x480 frames running at 30fps, without skipping more than the frame
> > time of the 5MP capture. That is, the viewfinder would effectively
> > stay live while taking a photograph.
> > 
> > )
> > 
> > Any other application I should look at? Thanks,

-- 
Regards,

Laurent Pinchart

