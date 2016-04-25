Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38180 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933114AbcDYQ6v (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Apr 2016 12:58:51 -0400
Date: Mon, 25 Apr 2016 18:58:48 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: sakari.ailus@iki.fi, sre@kernel.org, pali.rohar@gmail.com,
	linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 00/24] Make Nokia N900 cameras working
Message-ID: <20160425165848.GA10443@amd>
References: <20160420081427.GZ32125@valkosipuli.retiisi.org.uk>
 <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

Ok, let me try:

> The needed pipeline could be made with:
> 
> media-ctl -r
> media-ctl -l '"vs6555 binner 2-0010":1 -> "video-bus-switch":2 [1]'
> media-ctl -l '"video-bus-switch":0 -> "OMAP3 ISP CCP2":0 [1]'
> media-ctl -l '"OMAP3 ISP CCP2":1 -> "OMAP3 ISP CCDC":0 [1]'
> media-ctl -l '"OMAP3 ISP CCDC":2 -> "OMAP3 ISP preview":0 [1]'
> media-ctl -l '"OMAP3 ISP preview":1 -> "OMAP3 ISP resizer":0 [1]'
> media-ctl -l '"OMAP3 ISP resizer":1 -> "OMAP3 ISP resizer output":0 [1]'
> media-ctl -V '"vs6555 pixel array 2-0010":0 [SGRBG10/648x488 (0,0)/648x488 (0,0)/648x488]'
> media-ctl -V '"vs6555 binner 2-0010":1 [SGRBG10/648x488 (0,0)/648x488 (0,0)/648x488]'
> media-ctl -V '"OMAP3 ISP CCP2":0 [SGRBG10 648x488]'
> media-ctl -V '"OMAP3 ISP CCP2":1 [SGRBG10 648x488]'
> media-ctl -V '"OMAP3 ISP CCDC":2 [SGRBG10 648x488]'
> media-ctl -V '"OMAP3 ISP preview":1 [UYVY 648x488]'
> media-ctl -V '"OMAP3 ISP resizer":1 [UYVY 656x488]'

pavel@n900:/my/tui/ofone/camera$ sudo ./front.sh
MPlayer svn r34540 (Debian), built with gcc-4.6 (C) 2000-2012 MPlayer
Team

Linux n900 4.6.0-rc5-176733-g8b658a3-dirty
media-ctl from today's git.

> and tested with:
> 
> mplayer -tv driver=v4l2:width=656:height=488:outfmt=uyvy:device=/dev/video6 -vo xv -vf screenshot tv://
>

I can't do -vo xv ... fails for me, probably due to X
configuration. Does it work with -vo x11 for you?

For me it shows window with green interior. And complains about v4l2:
select timeouts. (I enabled these in .config):

+CONFIG_VIDEO_BUS_SWITCH=y
+CONFIG_VIDEO_SMIAREGS=y
+CONFIG_VIDEO_ET8EK8=y
+CONFIG_VIDEOBUF2_CORE=y
+CONFIG_VIDEOBUF2_MEMOPS=y
+CONFIG_VIDEOBUF2_DMA_CONTIG=y
+CONFIG_VIDEO_OMAP3=y
+CONFIG_VIDEO_SMIAPP_PLL=y
+CONFIG_VIDEO_SMIAPP=y

Any ideas?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
