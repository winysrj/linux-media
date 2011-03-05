Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49296 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312Ab1CEVCY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Mar 2011 16:02:24 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: V4L2 'brainstorming' meeting in Warsaw, March 2011
Date: Sat, 5 Mar 2011 22:02:42 +0100
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <ADF13DA15EB3FE4FBA487CCC7BEFDF36190F532AF3@bssrvexch01> <201102281912.01542.laurent.pinchart@ideasonboard.com> <201103051702.14048.hverkuil@xs4all.nl>
In-Reply-To: <201103051702.14048.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201103052202.42817.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

On Saturday 05 March 2011 17:02:13 Hans Verkuil wrote:
> On Monday, February 28, 2011 19:12:00 Laurent Pinchart wrote:
> > On Monday 28 February 2011 19:03:39 Hans Verkuil wrote:
> > > On Monday, February 28, 2011 18:11:47 Marek Szyprowski wrote:
> > [snip]
> > 
> > > > 4. Agenda
> > > > 
> > > >         TBD, everyone is welcomed to put his items here :)
> > > 
> > > In no particular order:
> > > 
> > > 1) pipeline configuration, cropping and scaling:
> > > 
> > > http://www.mail-archive.com/linux-media@vger.kernel.org/msg27956.html
> > > http://www.mail-archive.com/linux-media@vger.kernel.org/msg26630.html
> > > 
> > > 2) HDMI API support
> > > 
> > > Some hotplug/CEC code can be found here:
> > > 
> > > http://www.mail-archive.com/linux-media@vger.kernel.org/msg28549.html
> > > 
> > > but Cisco will soon post RFCs on this topic as well.
> > > 
> > > 3) Snapshot functionality.
> > > 
> > > http://www.mail-archive.com/linux-media@vger.kernel.org/msg28192.html
> > > http://www.mail-archive.com/linux-media@vger.kernel.org/msg28490.html
> > > 
> > > If we finish quicker than expected, then we can also look at this:
> > > 
> > > - use of V4L2 as a frontend for SW/DSP codecs
> > 
> > In still no particular order:
> >  - Muxed formats (H.264 inside MJPEG)
> >  - H.264
> >  - Buffers pool
> >  - Entity information ioctl
> 
> Can you elaborate on this one?

Some drivers (namely the uvcvideo driver) will need to report driver-specific 
information about each entity (the UVC entity GUID, the UVC controls it 
supports, ...). We need an API for that.

> >  - Userspace drivers (OMX)
> 
> And this one?

This is a follow-up of the "v4l2 vs omx for camera" discussion. I'd like to 
discuss whether we need an API for userspace drivers, like OMX has.

> >  - Sensor blanking/pixel-clock/frame-rate settings (including
> > 
> > enumeration/discovery)
> > 
> >  - GL/ES in V4L2 devices
> 
> And this one?

Devices are becoming hybrid. GPUs are supported through DRM and OpenGL 
(OpenGL/ES is embedded devices), and video output with V4L2. What about a 
video output device with OpenGL/ES capabilities ? We'll need to think about it 
at some point.

-- 
Regards,

Laurent Pinchart
