Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:37564 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755616Ab3GYNLc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jul 2013 09:11:32 -0400
Received: by mail-we0-f182.google.com with SMTP id u55so651476wes.13
        for <linux-media@vger.kernel.org>; Thu, 25 Jul 2013 06:11:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1530000.NI5gtVtkJY@avalon>
References: <201307251103.13456.hverkuil@xs4all.nl>
	<1530000.NI5gtVtkJY@avalon>
Date: Thu, 25 Jul 2013 09:11:31 -0400
Message-ID: <CAGoCfix09L5fvH=Mxpe9G4jH-DwGWLo+EZ4t=ngCFpfoAmeZEg@mail.gmail.com>
Subject: Re: UVC and V4L2_CAP_AUDIO
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	=?ISO-8859-1?Q?B=E5rd_Eirik_Winther?= <bwinther@cisco.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 25, 2013 at 5:10 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Not without dirty hacks. The UVC interfaces don't report whether the device
> has an audio function, the driver would need to look at all the interfaces of
> the parent USB device and find out whether they match one of the USB audio
> drivers. That's not something I would be inclined to merge in the uvcvideo
> driver.

We need this functionality anyway for other snd-usb-audio based tuners
like em28xx and au0828, so I think some sort of solution is
unavoidable.  I hacked something together for em28xx a few years ago
to do such an enumeration, but in reality we should probably have an
export in snd-usb-audio which would help figuring this out in a less
hacky way.

>> If not, then it looks like the only way to find the associated alsa device
>> is to use libmedia_dev (or its replacement, although I wonder if anyone is
>> still working on that).

Yup, it's 2013 and we still don't have a way for applications to ask
the kernel which ALSA device is tied to a given /dev/video node.
Hans, remember when I proposed adding a trivial ioctl() call back in
2009 that would allow this, and you rejected it saying the media
controller API was the answer?  It's hard not to feel like salt in the
wound that it's four years later and there *still* isn't a solution.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
