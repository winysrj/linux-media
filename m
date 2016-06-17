Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60696 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbcFQRMS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jun 2016 13:12:18 -0400
Date: Fri, 17 Jun 2016 19:12:14 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sebastian Reichel <sre@kernel.org>
Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>, sakari.ailus@iki.fi,
	pali.rohar@gmail.com, linux-media@vger.kernel.org
Subject: Re: Nokia N900 cameras -- pipeline setup in python (was Re: [RFC
 PATCH 00/24] Make Nokia N900 cameras working)
Message-ID: <20160617171214.GA5830@amd>
References: <20160420081427.GZ32125@valkosipuli.retiisi.org.uk>
 <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <20160427030850.GA17034@earth>
 <20160617164226.GA27876@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160617164226.GA27876@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

> First, I re-did pipeline setup in python, it seems slightly less hacky
> then in shell.
> 
> I tried to modify fcam-dev to work with the new interface, but was not
> successful so far. I can post patches if someone is interested
> (mplayer works for me, but that's not too suitable for taking photos).
> 
> I tried to get gstreamer to work, with something like:

While trying to debug gstreamer, I ran v4l2-compliance, and it seems
to suggest that QUERYCAP is required... but it is not present on
/dev/video2 or video6.

Any ideas? (Kernel is based on Ivaylo 's github tree, IIRC).

Thanks,
									Pavel

pavel@n900:/my/v4l-utils/utils$ ./v4l2-compliance/v4l2-compliance -d /dev/video6
Driver Info:
	Driver name   : ispvideo
	Card type     : OMAP3 ISP resizer output
	Bus info      : media
	Driver version: 4.6.0
	Capabilities  : 0x84200003
		Video Capture
		Video Output
		Streaming
		Extended Pix Format
		Device Capabilities
	Device Caps   : 0x04200001
		Video Capture
		Streaming
		Extended Pix Format

Compliance test for device /dev/video6 (not using libv4l2):

Required ioctls:
		fail: v4l2-compliance.cpp(537): missing bus_info prefix ('media')
	test VIDIOC_QUERYCAP: FAIL

Allow for multiple opens:
	test second video open: OK
		fail: v4l2-compliance.cpp(537): missing bus_info prefix ('media')
	test VIDIOC_QUERYCAP: FAIL
	test VIDIOC_G/S_PRIORITY: OK

pavel@n900:/my/v4l-utils/utils$ sudo ./v4l2-compliance/v4l2-compliance -d /dev/video2
Driver Info:
	Driver name   : ispvideo
	Card type     : OMAP3 ISP CCDC output
...
Compliance test for device /dev/video2 (not using libv4l2):

Required ioctls:
		fail: v4l2-compliance.cpp(537): missing bus_info prefix ('media')
	test VIDIOC_QUERYCAP: FAIL

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
