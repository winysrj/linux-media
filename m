Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55680 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241AbcD0VJa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Apr 2016 17:09:30 -0400
Date: Wed, 27 Apr 2016 23:09:28 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: linux-media@vger.kernel.org,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	sakari.ailus@iki.fi, sre@kernel.org
Subject: Re: [RFC PATCH 00/24] Make Nokia N900 cameras working
Message-ID: <20160427210928.GC19070@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201604251914.52944@pali>
 <571E250D.6080702@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

> It's part of the v4l-utils git repo:
> 
> https://git.linuxtv.org/v4l-utils.git/
...

> > > Anyway, does anyone know where to get the media-ctl tool?
> > 
> > Looks like it is part of v4l-utils package. At least in git:
> > https://git.linuxtv.org/v4l-utils.git/tree/utils/media-ctl
> > 
> > > It does not seem to be in debian 7 or debian 8...
> > 
> > I do not see it in debian too, but there is some version in ubuntu:
> > http://packages.ubuntu.com/trusty/media-ctl
> > 
> > So you can compile ubuntu dsc package, should work on debian.
> 
> Finally, it is also in debian, see:
> 
> https://packages.debian.org/search?suite=sid&arch=any&mode=path&searchon=contents&keywords=media-ctl
> https://packages.debian.org/sid/amd64/v4l-utils/filelist

Thanks for the pointers. It seems that new debian contains media-ctl,
but I'm using older one, so I compiled it from source. Could not find
yavta, either, but that was very easy to pull from git and compile.

Best regards,
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
