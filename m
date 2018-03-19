Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:55114 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932793AbeCSNpR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Mar 2018 09:45:17 -0400
Date: Mon, 19 Mar 2018 10:45:10 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        pali.rohar@gmail.com, sre@kernel.org,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, hans.verkuil@cisco.com
Subject: Re: [RFC, libv4l]: Make libv4l2 usable on devices with complex
 pipeline
Message-ID: <20180319104206.23019201@vento.lan>
In-Reply-To: <20180319124855.GA18886@amd>
References: <c4f61bc5-6650-9468-5fbf-8041403a0ef2@xs4all.nl>
        <20170516124519.GA25650@amd>
        <76e09f45-8f04-1149-a744-ccb19f36871a@xs4all.nl>
        <20180316205512.GA6069@amd>
        <c2a7e1f3-589d-7186-2a85-545bfa1c4536@xs4all.nl>
        <20180319102354.GA12557@amd>
        <20180319074715.5b700405@vento.lan>
        <c0fa64ac-4185-0e15-c938-0414e9f07c42@xs4all.nl>
        <20180319120043.GA20451@amd>
        <ac65858f-7bf3-4faf-6ebd-c898b6107791@xs4all.nl>
        <20180319124855.GA18886@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 19 Mar 2018 13:48:55 +0100
Pavel Machek <pavel@ucw.cz> escreveu:

> Hi!
> 
> > >> I really want to work with you on this, but I am not looking for partial
> > >> solutions.  
> > > 
> > > Well, expecting design to be done for opensource development is a bit
> > > unusual :-).  
> > 
> > Why? We have done that quite often in the past. Media is complex and you need
> > to decide on a design up front.  
> 
> 
> 
> > > I really see two separate tasks
> > > 
> > > 1) support for configuring pipeline. I believe this is best done out
> > > of libv4l2. It outputs description file, format below. Currently I
> > > have implemented this is in Python. File format is below.  
> > 
> > You do need this, but why outside of libv4l2? I'm not saying I disagree
> > with you, but you need to give reasons for that.  
> 
> I'd prefer to do this in Python. There's a lot to configure there, and
> I'm not sure if libv4l2 is is right place for it. Anyway, design of 2)
> does not depend on this.

Yes, the functionality of parsing the pipeline can be done later,
but, IMO, it should be integrated at the library.

> > > 2) support for running libv4l2 on mc-based devices. I'd like to do
> > > that.
> > > 
> > > Description file would look like. (# comments would not be not part of file).
> > > 
> > > V4L2MEDIADESC
> > > 3 # number of files to open
> > > /dev/video2
> > > /dev/video6
> > > /dev/video3  
> > 
> > This won't work. The video nodes numbers (or even names) can change.
> > Instead these should be entity names from the media controller.  
> 
> Yes, it will work. 1) will configure the pipeline, and prepare
> V4L2MEDIADESC file. The device names/numbers are stable after the
> system is booted.

No, it doensn't. On more complex SoC chips (like Exynos) with multiple
drivers for video capture, mpeg encoding/decoding, etc, the device node
numbers change on every reboot, as they're probed by different drivers.
So, it depends on what device driver is probed first.

That's a list of such devices on an Exynos 5 hardware:

 $ v4l2-ctl --list-devices
 s5p-mfc-dec (platform:11000000.codec):
 	/dev/video4
 	/dev/video5
 
 s5p-jpeg encoder (platform:11f50000.jpeg):
 	/dev/video0
 	/dev/video1
 
 s5p-jpeg encoder (platform:11f60000.jpeg):
 	/dev/video2
 	/dev/video3
 
 exynos-gsc gscaler (platform:13e00000.video-scaler):
 	/dev/video6
 
 exynos-gsc gscaler (platform:13e10000.video-scaler):
 	/dev/video7
 

(on every boot, the /dev/video? numbe changes).

We need to use something using sysfs in order to get it right.
That's what I did on some test scripts here:

	#!/bin/bash
	NEEDED=platform-11000000.codec-video-index0
	DEV=$(ls -l /dev/v4l/by-path/$NEEDED|perl -ne ' print $1 if (m,/video(\d+),)')
	echo "jpeg scaler ($NEEDED) at: /dev/video$DEV"
	gst-launch-1.0 filesrc location=~/test.mov ! qtdemux ! h264parse ! v4l2video${DEV}dec ! videoconvert ! kmssink

But that's because I was just too lazy to do the right thing (and this was
for a test machine - so no real need for it to be stable enough).


> If these were entity names, v4l2_open() would have to go to /sys and
> search for corresponding files... which would be rather complex and
> slow.

It has to, but speed here is not the problem, as this happens only
at open() time, and sysfs parsing is fast, as it is not stored on
disk.

> 
> > > We can parse that easily without requiring external libraries. Sorted
> > > data allow us to do binary search.  
> > 
> > But none of this addresses setting up the initial video pipeline or
> > changing formats. We probably want to support that as well.  
> 
> Well, maybe one day. But I don't believe we should attempt to support
> that today.
> 
> Currently, there's no way to test that camera works on N900 with
> mainline v4l2... which is rather sad. Advanced use cases can come later.
> 
> > For that matter: what is it exactly that we want to support? I.e. where do
> > we draw the line?  
> 
> I'd start with fixed format first. Python prepares pipeline, and
> provides V4L2MEDIADESC file libv4l2 can use. You can have that this
> week.

I don't see any problems with starting implementing it for controls,
but we need to have a broad view when designing, in order to avoid
breaking APIs and file formats.

> I guess it would make sense to support "application says preffered
> resolution, libv4l2 attempts to set up some kind of pipeline to get
> that resolution", but yes, interface there will likely be quite
> complex.

I don't it will be that complex. A simple pipeline setting like what
I proposed on the previous email:

	[pipeline pipe1]
		link0 = SGRBG10 640x480: entity1:0 -> entity2:0[1]
		link1 = SGRBG10 640x480: entity2:2-> entity3:0[1]
		link2 = UYVY 640x480: entity3:1-> entity4:0[1]
		link3 = UYVY 640x480: entity4:1-> entity5:0[1]

		sink0 = UYVY 320x200: entity5:0[1]
		sink1 = UYVY 640x480: entity3:0[1]

Seems enough to let the library to know what to do if an app wants to
get a pipeline with UYVY output at 320x200 or at 640x480 resolutions.

Thanks,
Mauro
