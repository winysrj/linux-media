Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44021 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbaBZOfD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Feb 2014 09:35:03 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sarah Sharp <sarah.a.sharp@intel.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, "Ryan, Mark D" <mark.d.ryan@intel.com>
Subject: Re: Dell XPS 12 USB camera bulk mode issues
Date: Wed, 26 Feb 2014 15:36:22 +0100
Message-ID: <2437951.gNx7vUrxFR@avalon>
In-Reply-To: <20140225214956.GC4035@xanatos>
References: <20140225214956.GC4035@xanatos>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sarah,

On Tuesday 25 February 2014 13:49:56 Sarah Sharp wrote:
> Hi Laurent and Mauro,
> 
> Mark has running into issues with the Realtek integrated webcam on a Dell
> XPS 12 system that uses bulk endpoints.  The webcam shows visible glitches
> with certain resolutions (stripes of frame missing, distorted images, purple
> and green colors, blank image, or missing the bottom half of the image).

How frequent are those issues, do they occur every frame (or nearly every 
frame), or are they transient ?

> The webcam works fine in Windows. The webcam works fine in Linux if we
> upgrade the firmware to make the camera use isochronous endpoints rather
> than bulk endpoints. This makes us suspect an issue with bulk mode.
> 
> How is the Linux support for bulk mode cameras? If it's supposed to work,
> could we be dealing with a camera that doesn't conform to the bulk mode USB
> video class spec?

It's supposed to work, I'm running a test with a bulk device right now using 
the latest linuxtv/master branch (or, to be accurate, the V4L subsystem from 
that branch compiled for a 3.10 kernel).

We might be dealing with a device that doesn't conform to the spec, with a bug 
in the uvcvideo driver that happened to remain unnoticed until now, or just 
with a gray area in the spec that has been understood differently by the 
device manufacturer, Microsoft and me.

> Details:
> --------
> 
> I tested using Ubuntu with a 3.14-rc4 kernel with guvcview.
> 
> Resolutions that work:
> 
> YUYV, resolutions:
> 640x480
> 160x120
> 352x288
> 848x480
> 960x540
> MJPG, resolutions:
> 160x120
> 320x240
> 352x288
> 
> Resolutions that fail:
> 
> YUYV, resolutions:
> 320x180
> 320x240
> 424x240
> 640x360
> MJPG, resolutions:
> 640x480
> 320x180
> 424x240
> 640x360
> 848x480
> 960x540
> RGB3, any resolution. (In fact, this seems to hang guvcview with
> messages like "VIDIOC_DQBUF - Unable to dequeue buffer")
> 
> Didn't thoroughly test BGR3, YU12, YV12.  Those capture modes also
> sometimes hang guvcview.
> 
> Attached is the lsusb output for the device, along with two usbmon
> captures.  One shows the device working as MJPG at a 320x240 resolution,
> and the other shows the device failing as MJPG at a 320x180 resolution.

I'm looking at that, I'll reply to Mark's e-mail.

> Please let me know if anything jumps out at you.  For further debugging,
> please work with Mark.

-- 
Regards,

Laurent Pinchart

