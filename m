Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:38983 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932973AbcFBWhP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Jun 2016 18:37:15 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Bastien Nocera <hadess@hadess.net>
Cc: linux-media@vger.kernel.org
Subject: Re: NTSC/PAL resolution support for "EasyCap" device
Date: Fri, 03 Jun 2016 01:37:18 +0300
Message-ID: <2081548.sYXtIeXGjI@avalon>
In-Reply-To: <1464691129.3878.59.camel@hadess.net>
References: <1464691129.3878.59.camel@hadess.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bastien,

(CC'ing the linux-media mailing list)

On Tuesday 31 May 2016 12:38:49 Bastien Nocera wrote:
> Hey,
> 
> I saw your commits to add quirks for Arkmicro "webcams". I recently
> bought a dirt cheap "EasyCap" device on eBay, but it only seems to
> support 640x480 instead of the native "NRSC" resolution as mentioned on
> the device's box.
> 
> $ v4l2-ctl --list-formats-ext -d /dev/video0 
> ioctl: VIDIOC_ENUM_FMT
> 	Index       : 0
> 	Type        : Video Capture
> 	Pixel Format: 'MJPG' (compressed)
> 	Name        : Motion-JPEG
> 		Size: Discrete 640x480
> 			Interval: Discrete 0.017s (60.000 fps)
> 			Interval: Discrete 0.033s (30.000 fps)
> 			Interval: Discrete 0.067s (15.000 fps)
> 			Interval: Discrete 0.200s (5.000 fps)
> 		Size: Discrete 352x288
> 			Interval: Discrete 0.017s (60.000 fps)
> 			Interval: Discrete 0.033s (30.000 fps)
> 			Interval: Discrete 0.067s (15.000 fps)
> 			Interval: Discrete 0.200s (5.000 fps)
> 
> Device is:
> Bus 003 Device 066: ID 18ec:5850 Arkmicro Technologies Inc. 
> 
> In your professional opinion, should I try using UVC_QUIRK_PROBE_DEF
> or UVC_QUIRK_PROBE_MINMAX as a quirk for this device? Is there a stand-
> alone driver somewhere that I can use for testing (rather than
> recompiling a whole kernel)?

Those quirks will not affect the available resolutions.

UVC devices expose a list of resolutions they support through the USB 
descriptors, and the uvcvideo device merely uses that list to expose supported 
resolutions to userspace.

If the device doesn't expose resolutions other than the above two, the box 
could be lying, or the device could use non-standard extensions to UVC to 
support additional resolutions. The first step would be to try the camera in a 
Windows machine to see if additional resolutions are available (without 
installing any additional device-specific software).

> Let me know if you prefer that I send this to the media list.

Done :-)

-- 
Regards,

Laurent Pinchart

