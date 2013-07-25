Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60071 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755901Ab3GYNSv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jul 2013 09:18:51 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	=?ISO-8859-1?Q?B=E5rd?= Eirik Winther <bwinther@cisco.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: UVC and V4L2_CAP_AUDIO
Date: Thu, 25 Jul 2013 15:19:45 +0200
Message-ID: <1783283.TsF6JokUu8@avalon>
In-Reply-To: <CAGoCfix09L5fvH=Mxpe9G4jH-DwGWLo+EZ4t=ngCFpfoAmeZEg@mail.gmail.com>
References: <201307251103.13456.hverkuil@xs4all.nl> <1530000.NI5gtVtkJY@avalon> <CAGoCfix09L5fvH=Mxpe9G4jH-DwGWLo+EZ4t=ngCFpfoAmeZEg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Devin,

On Thursday 25 July 2013 09:11:31 Devin Heitmueller wrote:
> On Thu, Jul 25, 2013 at 5:10 AM, Laurent Pinchart wrote:
> > Not without dirty hacks. The UVC interfaces don't report whether the
> > device has an audio function, the driver would need to look at all the
> > interfaces of the parent USB device and find out whether they match one of
> > the USB audio drivers. That's not something I would be inclined to merge
> > in the uvcvideo driver.
> 
> We need this functionality anyway for other snd-usb-audio based tuners
> like em28xx and au0828, so I think some sort of solution is
> unavoidable.  I hacked something together for em28xx a few years ago
> to do such an enumeration, but in reality we should probably have an
> export in snd-usb-audio which would help figuring this out in a less
> hacky way.
> 
> >> If not, then it looks like the only way to find the associated alsa
> >> device is to use libmedia_dev (or its replacement, although I wonder if
> >> anyone is still working on that).
> 
> Yup, it's 2013 and we still don't have a way for applications to ask the
> kernel which ALSA device is tied to a given /dev/video node. Hans, remember
> when I proposed adding a trivial ioctl() call back in 2009 that would allow
> this, and you rejected it saying the media controller API was the answer? 
> It's hard not to feel like salt in the wound that it's four years later and
> there *still* isn't a solution.

It's partly my fault for not having found time to work on this.

http://git.ideasonboard.org/media-ctl.git/shortlog/refs/heads/enum
http://git.ideasonboard.org/media-enum.git

Not completely there yet, but this already allows enumerating media devices 
(audio and video) in the system. A bit of code cleanup is still needed in the 
media-ctl enum branch. I'll try to find time for that next week and finally 
submit patches.

-- 
Regards,

Laurent Pinchart

