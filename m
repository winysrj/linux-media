Return-path: <mchehab@pedra>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1723 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948Ab1CMMbZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Mar 2011 08:31:25 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [ANN] Agenda for the Warsaw meeting.
Date: Sun, 13 Mar 2011 13:31:16 +0100
Cc: Kamil Debski <k.debski@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Martin Bugge <marbugge@cisco.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Willy Poisson <willy.poisson@stericsson.com>,
	Jonghun Han <jonghun.han@samsung.com>,
	Jaeryul Oh <jaeryul.oh@samsung.com>,
	"Seung-Woo Kim" <sw0312.kim@samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201103131331.16338.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Agenda for V4L2 brainstorm meeting in Warsaw, March 16-18 2011.

Purpose of the meeting: to brainstorm about current V4L2 API limitations
with regards to required functionality. Ideally the results of the meeting
are actual solutions to these problems, but at the very least we should
have a concensus of what direction to take and who will continue working
on each problem. The hope is that this meeting will save us endless email
and irc discussions.

It is *not* a summit meeting, so any conclusions need to be discussed and
approved on the mailinglist.

The basic outline is the same as during previous meetings: the first day we
go through all the agenda points and make sure everyone understands the
problem. Smaller issues will be discussed and decided, more complex issues
are just discussed.

The second day we go in depth into the complex issues and try to come up with
ideas that might work. The last day we translate the all agenda items into
actions.

This approach worked well in the past and it ensures that we end up with
something concrete.

Those who have a vested interest in an agenda item should be prepared to
explain their take on it and if necessary have a presentation ready.

Besides the main agenda I also added a few items falling under the category
'if time permits'.

Attendees:

Samsung Poland R&D Center:
  Kamil Debski <k.debski@samsung.com>
  Sylwester Nawrocki <s.nawrocki@samsung.com>
  Tomasz Stanislawski <t.stanislaws@samsung.com>
  Marek Szyprowski (Organizer) <m.szyprowski@samsung.com>

Cisco Systems Norway:
  Martin Bugge <marbugge@cisco.com>
  Hans Verkuil (Chair) <hverkuil@xs4all.nl>

Nokia:
  Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>

Ideas On Board:
  Laurent Pinchart <laurent.pinchart@ideasonboard.com>

ST-Ericsson:
  Willy Poisson <willy.poisson@stericsson.com>

Samsung System.LSI Korea
  Jonghun Han <jonghun.han@samsung.com>
  Jaeryul Oh <jaeryul.oh@samsung.com>

Samsung DMC Korea:
   Seung-Woo Kim <sw0312.kim@samsung.com>

Freelance:
  Guennadi Liakhovetski <g.liakhovetski@gmx.de>


Agenda:

1) Compressed format API for MPEG, H.264, etc. Also need to discuss what to
   do with weird 'H.264 inside MJPEG' muxed formats.
   (Hans, Laurent, Samsung)

2) Small architecture enhancements:
	- Acquiring subdevs from other devices using subdev pool
	  http://www.mail-archive.com/linux-media@vger.kernel.org/msg21831.html
	  (Tomasz)
	- Introducing subdev hierarchy. Below there is a link to driver using it:
	  http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/28885/focus=28890
	  (Tomasz)
	- Allow per-filehandle control handlers.
	  http://www.spinics.net/lists/linux-media/msg27975.html
	  (Jaeryul)
	- How to control FrameBuffer device as v4l2 sub-device?
	  http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/29442/focus=29570
	  (Jaeryul)
	- Which interface is better for Mixer of Exynos, frame buffer or V4l2?
	  http://www.mail-archive.com/linux-media@vger.kernel.org/msg28549.html
	  (Jaeryul)
	- Entity information ioctl
	  Some drivers (namely the uvcvideo driver) will need to report driver-specific
	  information about each entity (the UVC entity GUID, the UVC controls it
	  supports, ...). We need an API for that.
	  (Laurent)

3) Pipeline configuration, cropping and scaling:

   http://www.mail-archive.com/linux-media@vger.kernel.org/msg27956.html
   http://www.mail-archive.com/linux-media@vger.kernel.org/msg26630.html

   (Everyone)

4) HDMI receiver/transmitter API support

   Some hotplug/CEC code can be found here:

   http://www.mail-archive.com/linux-media@vger.kernel.org/msg28549.html

   CEC RFC from Cisco Systems Norway:

   http://www.mail-archive.com/linux-media@vger.kernel.org/msg29241.html

   Hopefully we can post an initial HDMI RFC as well on Monday.

   (Martin, Hans, Samsung, ST-Ericsson)

5) Sensor/Flash/Snapshot functionality.

   http://www.mail-archive.com/linux-media@vger.kernel.org/msg28192.html
   http://www.mail-archive.com/linux-media@vger.kernel.org/msg28490.html

   - Sensor blanking/pixel-clock/frame-rate settings (including 
     enumeration/discovery)

   - Multiple video buffer queues per device (currently implemented in the
     OMAP 3 ISP driver in non-standard way).

   - Synchronising parameters (e.g. exposure time and gain) on given
     frames. Some sensors support this on hardware. There are many use cases
     which benefit from this, for example this one:

     <URL:http://fcam.garage.maemo.org/>

   - Flash synchronisation (might fall under the above topic).

   - Frame metadata. It is important for the control algorithms (exposure,
     white balance, for example), to know which sensor settings have been
     used to expose a given frame. Many sensors do support this. Do we want
     to parse this in the kernel or does it belong to user space? The
     metadata formats are mostly sensor dependent.
   (Everyone)


Items 3 and 5 are 'the big ones'. Past experience indicates that we can't go
through all items on the first day and so I expect that item 5 (and perhaps
even 4) will have to move to the second day.


If time permits, then we can also look at these items:

A) Buffer Pool (HWMEM, GEM, CMA)
   (ST-Ericsson, Samsung)

B) Use of V4L2 as a frontend for SW/DSP codecs
   (Laurent)

C) Userspace drivers (OMX)
   This is a follow-up of the "v4l2 vs omx for camera" discussion. I'd like to 
   discuss whether we need an API for userspace drivers, like OMX has.
   (Laurent)

D) GL/ES in V4L2 devices
   Devices are becoming hybrid. GPUs are supported through DRM and OpenGL 
   (OpenGL/ES is embedded devices), and video output with V4L2. What about a 
   video output device with OpenGL/ES capabilities ? We'll need to think about it 
   at some point.
   (Laurent)

The reason I put these items here is that I think that these are not quite as
urgent as the others, and given that we only have three days we have to make
a choice. I also think that these items are probably worth a full three-day
meeting all by themselves.

I do want to discuss at the end of the last day how we should proceed with the
buffer pool et al. Do we need additional meetings? Who is going to guide this
work? What resources are available? Etc.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
