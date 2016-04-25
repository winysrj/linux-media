Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:37243 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754670AbcDYOOp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Apr 2016 10:14:45 -0400
Received: by mail-wm0-f50.google.com with SMTP id n3so130126661wmn.0
        for <linux-media@vger.kernel.org>; Mon, 25 Apr 2016 07:14:44 -0700 (PDT)
Date: Mon, 25 Apr 2016 16:14:41 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-media@vger.kernel.org,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	sakari.ailus@iki.fi, sre@kernel.org
Subject: Re: [RFC PATCH 00/24] Make Nokia N900 cameras working
Message-ID: <20160425141441.GE25465@pali>
References: <571DBA2E.9020305@gmail.com>
 <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <20160425104037.GA20362@pali>
 <20160425140612.GA19175@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20160425140612.GA19175@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 25 April 2016 16:06:12 Pavel Machek wrote:
> Hi!
> 
> > On Monday 25 April 2016 00:08:00 Ivaylo Dimitrov wrote:
> > > The needed pipeline could be made with:
> > > 
> > > media-ctl -r
> > > media-ctl -l '"vs6555 binner 2-0010":1 -> "video-bus-switch":2
> ...
> > On Monday 25 April 2016 09:33:18 Ivaylo Dimitrov wrote:
> > > Try with:
> > > 
> > > media-ctl -r
> > > media-ctl -l '"et8ek8 3-003e":0 -> "video-bus-switch":1 [1]'
> ...
> > > mplayer -tv driver=v4l2:width=800:height=600:outfmt=uyvy:device=/dev/video6 -vo xv -vf screenshot tv://
> > 
> > Hey!!! That is crazy! Who created such retard API?? In both cases you
> > are going to show video from /dev/video6 device. But in real I have two
> > independent camera devices: front and back.
> 
> Because Nokia, and because the hardware is complex, I'm afraid.

In Nokia kernel, there are just /dev/video0 and /dev/video1. When I open
first I see back camera, second front camera. No media-ctl nor any other
reconfiguration is needed. So not Nokia nor hw complexity is reason...

> First we need to get it to work, than we can improve v4l... 

Ok, I agree. But I really would like to see just two video devices and
all those route configuration in kernel...

> Anyway, does anyone know where to get the media-ctl tool?

Looks like it is part of v4l-utils package. At least in git:
https://git.linuxtv.org/v4l-utils.git/tree/utils/media-ctl

> It does not seem to be in debian 7 or debian 8...

I do not see it in debian too, but there is some version in ubuntu:
http://packages.ubuntu.com/trusty/media-ctl

So you can compile ubuntu dsc package, should work on debian.

-- 
Pali Rohár
pali.rohar@gmail.com
