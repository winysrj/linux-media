Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33776 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756114AbcFTRJQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2016 13:09:16 -0400
Date: Mon, 20 Jun 2016 19:00:36 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sebastian Reichel <sre@kernel.org>
Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>, sakari.ailus@iki.fi,
	pali.rohar@gmail.com, linux-media@vger.kernel.org
Subject: Re: Nokia N900 cameras -- pipeline setup in python (was Re: [RFC
 PATCH 00/24] Make Nokia N900 cameras working)
Message-ID: <20160620170036.GA17228@amd>
References: <20160420081427.GZ32125@valkosipuli.retiisi.org.uk>
 <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <20160427030850.GA17034@earth>
 <20160617164226.GA27876@amd>
 <20160617171214.GA5830@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160617171214.GA5830@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri 2016-06-17 19:12:14, Pavel Machek wrote:
> Hi!
> 
> > First, I re-did pipeline setup in python, it seems slightly less hacky
> > then in shell.
> > 
> > I tried to modify fcam-dev to work with the new interface, but was not
> > successful so far. I can post patches if someone is interested
> > (mplayer works for me, but that's not too suitable for taking photos).
> > 
> > I tried to get gstreamer to work, with something like:
> 
> While trying to debug gstreamer, I ran v4l2-compliance, and it seems
> to suggest that QUERYCAP is required... but it is not present on
> /dev/video2 or video6.
> 
> Any ideas? (Kernel is based on Ivaylo 's github tree, IIRC).

I got fcam-dev to grab jpeg-s from the camera. Unfortunately, 800x600,
no autogain, no autofocus. But lot of fun with memory management :-).

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
