Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:35073 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753932AbcDYKks (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Apr 2016 06:40:48 -0400
Received: by mail-wm0-f47.google.com with SMTP id e201so80754211wme.0
        for <linux-media@vger.kernel.org>; Mon, 25 Apr 2016 03:40:47 -0700 (PDT)
Date: Mon, 25 Apr 2016 12:40:37 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
To: linux-media@vger.kernel.org,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	sakari.ailus@iki.fi, sre@kernel.org, pavel@ucw.cz
Subject: Re: [RFC PATCH 00/24] Make Nokia N900 cameras working
Message-ID: <20160425104037.GA20362@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <571DBA2E.9020305@gmail.com>
 <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

front camera:

On Monday 25 April 2016 00:08:00 Ivaylo Dimitrov wrote:
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
> 
> and tested with:
> 
> mplayer -tv driver=v4l2:width=656:height=488:outfmt=uyvy:device=/dev/video6 -vo xv -vf screenshot tv://

back camera:

On Monday 25 April 2016 09:33:18 Ivaylo Dimitrov wrote:
> Try with:
> 
> media-ctl -r
> media-ctl -l '"et8ek8 3-003e":0 -> "video-bus-switch":1 [1]'
> media-ctl -l '"video-bus-switch":0 -> "OMAP3 ISP CCP2":0 [1]'
> media-ctl -l '"OMAP3 ISP CCP2":1 -> "OMAP3 ISP CCDC":0 [1]'
> media-ctl -l '"OMAP3 ISP CCDC":2 -> "OMAP3 ISP preview":0 [1]'
> media-ctl -l '"OMAP3 ISP preview":1 -> "OMAP3 ISP resizer":0 [1]'
> media-ctl -l '"OMAP3 ISP resizer":1 -> "OMAP3 ISP resizer output":0 [1]'
> 
> media-ctl -V '"et8ek8 3-003e":0 [SGRBG10 864x656]'
> media-ctl -V '"OMAP3 ISP CCP2":0 [SGRBG10 864x656]'
> media-ctl -V '"OMAP3 ISP CCP2":1 [SGRBG10 864x656]'
> media-ctl -V '"OMAP3 ISP CCDC":2 [SGRBG10 864x656]'
> media-ctl -V '"OMAP3 ISP preview":1 [UYVY 864x656]'
> media-ctl -V '"OMAP3 ISP resizer":1 [UYVY 800x600]'
> 
> 
> mplayer -tv driver=v4l2:width=800:height=600:outfmt=uyvy:device=/dev/video6 -vo xv -vf screenshot tv://

Hey!!! That is crazy! Who created such retard API?? In both cases you
are going to show video from /dev/video6 device. But in real I have two
independent camera devices: front and back.

Why on the earth I cannot have /dev/video0 for back camera and
/dev/video1 for front camera? And need to call such huge commands which
re-route pictures from correct camera to /dev/video6 device? I'm really
not interested in some hw details how are cameras connected, I just want
to show pictures in userspace...

And what are those others /dev/video[0-5] devices?

-- 
Pali Rohár
pali.rohar@gmail.com
