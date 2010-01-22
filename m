Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:4207 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754711Ab0AVQmp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jan 2010 11:42:45 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andy Walls <awalls@radix.net>
Subject: Re: About MPEG decoder interface
Date: Fri, 22 Jan 2010 17:42:33 +0100
Cc: Michael Qiu <fallwind@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
References: <f74f98341001211842y6dabbe97s1d7c362bac2d87b8@mail.gmail.com> <1264129253.3094.5.camel@palomino.walls.org>
In-Reply-To: <1264129253.3094.5.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001221742.33679.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 22 January 2010 04:00:53 Andy Walls wrote:
> On Fri, 2010-01-22 at 10:42 +0800, Michael Qiu wrote:
> > Hi all,
> > 
> >   How can I export my MPEG decoder control interface to user space?
> >   Or in other words, which device file(/dev/xxx) should a proper
> > driver for mpeg decoder provide?
> 
> The MPEG decoder on a PVR-350 PCI card provides a /dev/video interface
> (normally /dev/video16).
> 
> The interface specification to userspace is the V4L2 API:
> 
> http://www.linuxtv.org/downloads/video4linux/API/V4L2_API/spec-single/v4l2.html

Not really. The v4l2 API specifies the MPEG encoder part, but not the decode
part.

The decoder part is (unfortunately) part of the DVB API.

Some ioctls are documented here:

http://www.linuxtv.org/downloads/v4l-dvb-apis/ch11s02.html

However, that documentation is very out of date and you are better off looking
in the include/linux/dvb/video.h header.

In particular the new struct video_command and associated ioctls provides
you with more control than the older VIDEO_CMD_ ioctls.

Note that the V4L2 API will get a new event API soon that should supercede the
event implementation in this video.h. The video.h implementation is pretty
crappy (most of what is in there is crappy: poorly designed without much thought
for extendability).

> >   And, in linux dvb documents, all the frontend interface looks like
> > /dev/dvb/adapter/xxx, it looks just for PCI based tv card.
> >   If it's not a TV card, but a frontend for a embedded system without
> > PCI, which interface should I use?

V4L2, but with the ioctls defined in dvb/video.h. See for example the ivtv
driver (ivtv-ioctl.c).

If the video.h API is not powerful enough, then please discuss that on this
list. Frankly, that might give me a good excuse to create a better API that
is properly integrated with V4L2.

Regards,

	Hans
 
> The V4L2 specification should be OK for basic functionality.  Hans
> might be able to talk about more advanced interfaces that are in work
> for embedded platforms, if the V4L2 API is not good enough for you as
> is.


> 
> Regards,
> Andy
> 
> > Best regards
> > Michael Qiu
> 
> 
> 



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
