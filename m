Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46304 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965020AbcDYWHy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Apr 2016 18:07:54 -0400
Date: Tue, 26 Apr 2016 00:07:51 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: sakari.ailus@iki.fi, sre@kernel.org, pali.rohar@gmail.com,
	linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 00/24] Make Nokia N900 cameras working
Message-ID: <20160425220751.GA26350@amd>
References: <20160420081427.GZ32125@valkosipuli.retiisi.org.uk>
 <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <20160425165848.GA10443@amd>
 <571E5134.10607@gmail.com>
 <20160425184016.GC10443@amd>
 <571E6D38.9050009@gmail.com>
 <20160425204110.GA2689@amd>
 <571E83B0.8020208@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <571E83B0.8020208@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

> >Hi!
> >
> >>All my testing so far was performed using modules, though it shouldn't make
> >>difference.
> >>
> >>>https://lkml.org/lkml/2016/4/16/14
> >>>https://lkml.org/lkml/2016/4/16/33
> >>>
> >>
> >>More stuff is needed, all those twl4030 regulator patches (already in
> >>linux-next) + DTS initial-mode patch
> >>(https://lkml.org/lkml/2016/4/17/78).
> >
> >Aha, that explains a lot. Dealing with -next would be tricky, I guess;
> >can I just pull from your camera branch?
> >
> >https://github.com/freemangordon/linux-n900/tree/camera
> 
> I guess yes, though I am not sure all the patches there are compatible with
> userland different from maemo, so be careful. Also, the correct branch is
> v4.6-rc4-n900-camera.

I tried v4.6-rc4-n900-camera, but got the same results: green mplayer
window, if I try to use front or back camera. Assuming
v4.6-rc4-n900-camera works for you, could I get your .config and list
of modules loaded during the test?

Thanks a lot,
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
