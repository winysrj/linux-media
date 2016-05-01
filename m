Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52339 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbcEATVf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 May 2016 15:21:35 -0400
Date: Sun, 1 May 2016 21:21:31 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, pali.rohar@gmail.com,
	sre@kernel.org, kernel list <linux-kernel@vger.kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
	aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com,
	patrikbachan@gmail.com, serge@hallyn.com, tuukkat76@gmail.com,
	mchehab@osg.samsung.com, linux-media@vger.kernel.org,
	laurent.pinchart@ideasonboard.com
Subject: Re: camera application for testing (was Re: v4l subdevs without big
 device)
Message-ID: <20160501192131.GH14243@amd>
References: <20160428084546.GA9957@amd>
 <20160429071525.GA4823@amd>
 <57230DE7.3020701@xs4all.nl>
 <20160429221359.GA29297@amd>
 <20160501140831.GH26360@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160501140831.GH26360@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!
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

I knew it existed, but I'd prefer not to touch proprietary code.

> > In particular, who is going to do computation neccessary for
> > autofocus, whitebalance and exposure/gain?
> 
> I think libv4l itself has algorithms to control at least some of these. It
> relies on the image data so the CPU time consumption will be high.
> 
> AFAIR Laurent has also worked on implementing some algorithms that use the
> histogram and some of the statistics. Add him to cc list.

Aha, good, let me know.

> > There's http://fcam.garage.maemo.org/gettingStarted.html that should
> > work on maemo, but a) it is not in Debian, b) it has non-trivial
> > dependencies and c) will be a lot of fun to get working...
> > 
> > (and d), will not be too useful, anyway, due to 1sec shutter lag:
> 
> I believe this will be shorter nowadays. I don't remember the exact
> technical solution which the text below refers to but I'm pretty sure it'll
> be better with the current upstream. API-wise, there's work to be done there
> (to port FCAM to upsteram APIs) but it's a possibility.

I took a look at fcam-dev in the meantime... and it does not look too
bad. It is quite n900-specific -- it needs hardware support for
histograms and sharpness maps -- but it should not be too hard to
modify.

Relying on hardware support without having fallback software
implementation feels wrong, but... it should actually be ok as I
already have the hardware...

(Is there accepted "upstream" for it?)
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
