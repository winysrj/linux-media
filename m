Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:32812 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932466AbcDYOGR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Apr 2016 10:06:17 -0400
Date: Mon, 25 Apr 2016 16:06:12 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: linux-media@vger.kernel.org,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	sakari.ailus@iki.fi, sre@kernel.org
Subject: Re: [RFC PATCH 00/24] Make Nokia N900 cameras working
Message-ID: <20160425140612.GA19175@amd>
References: <571DBA2E.9020305@gmail.com>
 <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <20160425104037.GA20362@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160425104037.GA20362@pali>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

> On Monday 25 April 2016 00:08:00 Ivaylo Dimitrov wrote:
> > The needed pipeline could be made with:
> > 
> > media-ctl -r
> > media-ctl -l '"vs6555 binner 2-0010":1 -> "video-bus-switch":2
...
> On Monday 25 April 2016 09:33:18 Ivaylo Dimitrov wrote:
> > Try with:
> > 
> > media-ctl -r
> > media-ctl -l '"et8ek8 3-003e":0 -> "video-bus-switch":1 [1]'
...
> > mplayer -tv driver=v4l2:width=800:height=600:outfmt=uyvy:device=/dev/video6 -vo xv -vf screenshot tv://
> 
> Hey!!! That is crazy! Who created such retard API?? In both cases you
> are going to show video from /dev/video6 device. But in real I have two
> independent camera devices: front and back.

Because Nokia, and because the hardware is complex, I'm afraid. First
we need to get it to work, than we can improve v4l... 

Anyway, does anyone know where to get the media-ctl tool? It does not
seem to be in debian 7 or debian 8...
									pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
