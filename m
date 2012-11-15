Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38730 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751219Ab2KOWGb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Nov 2012 17:06:31 -0500
Date: Fri, 16 Nov 2012 00:06:27 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com
Subject: [PATCH 0/4] Monotonic timestamps
Message-ID: <20121115220627.GB29863@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

Here's my first monotonic timestamps patch series. Since the RFC series,
I've corrected a warning in drivers/media/usb/s2255/s2255drv.c that was
caused by an unused variable.

All affected drivers compile without warnings. I've tested this on the OMAP
3 ISP:

02:11:34 sailus@peruna [~]yavta -c1 -f SGBRG10 -F/tmp/foo -s 2864x2048 /dev/video1
Device /dev/video1 opened.
Device `OMAP3 ISP CSI2a output' on `media' is a video capture device.
Video format set: SGBRG10 (30314247) 2864x2048 (stride 5728) buffer size 11730944
Video format: SGBRG10 (30314247) 2864x2048 (stride 5728) buffer size 11730944
4 buffers requested.
length: 11730944 offset: 0 timestamp type: monotonic
Buffer 0 mapped at address 0xb62cb000.
length: 11730944 offset: 11730944 timestamp type: monotonic
Buffer 1 mapped at address 0xb579b000.
length: 11730944 offset: 23461888 timestamp type: monotonic
Buffer 2 mapped at address 0xb4c6b000.
length: 11730944 offset: 35192832 timestamp type: monotonic
Buffer 3 mapped at address 0xb413b000.
0 (0) [-] 0 11730944 bytes 310.791595 310.792083 13.331 fps
Captured 1 frames in 0.075500 seconds (13.244948 fps, 155375737.438942 B/s).
4 buffers released.

What the patches do is that they

1. Add new buffer flags for timestamp type, and a mask,
2. convert all the drivers to use monotonic timestamps and
3. tell that all drivers are using monotonic timestamps.

The assumption is that all drivers will use monotonic timestamps, especially
the timestamp type is set in videobuf(2) in drivers that use it. This could
be changed later on if we wish to make it selectable; in this case videobuf2
would need to be told, and the helper function v4l2_get_timestamp() would
need to be put to videobuf2 instead.

Comments and questions are very welcome!

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
