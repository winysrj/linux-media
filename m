Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:45549 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756009AbZIRK1c (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Sep 2009 06:27:32 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-usb@vger.kernel.org
Subject: [PATCH 0/3] USB audio and video class gadget drivers
Date: Fri, 18 Sep 2009 12:25:57 +0200
Cc: linux-media@vger.kernel.org, Bryan Wu <cooloney@kernel.org>,
	Mike Frysinger <vapier@gentoo.org>
MIME-Version: 1.0
Message-Id: <200909181225.57212.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

here are two new gadget function drivers for USB audio class and USB video 
class as well as a webcam gadget driver that combines both audio and video. 
All those drivers are work in progress (though not progressing much for the 
moment, as I'm busy with other development) and should probably not be applied 
before (at least) v2, but can still be useful as-is.

The code was developed and tested on TI DM365 hardware using a MUSB 
controller. I unfortunately don't have access to the hardware anymore for the 
time being, but I got an OMAP3-based platform in the meantime. If spare time 
permits I'll test the driver on the OMAP3 platform.

The audio class driver is based on Bryan Wu's work. It requires the "USB 
gadget: Handle endpoint requests at the function level" patch that I've posted 
on the list. Only the microphone use case is supported at the moment. If 
anyone wants to implement speaker support patches are welcome :-)

The video class driver reuses some of the UVC host driver code, mostly for 
video buffers queue management. It currently has its own copy of the code, so 
there's room for improvement there.

If you look closely you will notice that the UVC driver uses the V4L2 device 
node to forward events (connection/disconnection, UVC request arrival, ...) to 
userspace. I will soon post an RFC to the linux-media list to document the 
interface.

The webcam driver combines a UAC microphone (at 16kHz) and a UVC camera (at 
360p and 720p in YUYV and MJPEG).

Comments and ideas are welcome.

-- 
Best regards,

Laurent Pinchart
