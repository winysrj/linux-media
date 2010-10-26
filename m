Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:37598 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760559Ab0JZWMX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Oct 2010 18:12:23 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Michael Jones <michael.jones@matrix-vision.de>
Subject: Re: controls, subdevs, and media framework
Date: Wed, 27 Oct 2010 00:12:56 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	"sakari.ailus@maxwell.research.nokia.com"
	<sakari.ailus@maxwell.research.nokia.com>
References: <4CC6EEDC.20206@matrix-vision.de>
In-Reply-To: <4CC6EEDC.20206@matrix-vision.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010270012.56909.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Michael,

On Tuesday 26 October 2010 17:08:12 Michael Jones wrote:
> I'm trying to understand how the media framework and V4L2 share the
> responsibility of configuring a video device.  Referring to the ISP code
> on Laurent's media-0004-omap3isp branch, the video device is now split up
> into several devices... suppose you have a sensor delivering raw bayer
> data to the CCDC.  I could get this raw data from the /dev/video2 device
> (named "OMAP3 ISP CCDC output") or I could get YUV data from the previewer
> or resizer.  But I would no longer have a single device where I could
> ENUM_FMT and see that I could get either.  Correct?

That's correct. With the OMAP3 ISP driver the video device nodes (/dev/video*) 
are used for video streaming but not for device configuration.

> Having settled on a particular video device, (how) do regular controls (ie.
> VIDIOC_[S|G]_CTRL) work?  I don't see any support for them in ispvideo.c. 
> Is it just yet to be implemented?  Or is it expected that the application
> will access the subdevs individually?

Applications should access the controls on the subdev device nodes directly. 
We might expose some controls on the video device nodes in the future as well, 
but there's no such plan right now.

> Basically the same Q for CROPCAP:  isp_video_cropcap passes it on to the
> last link in the chain, but none of the subdevs in the ISP currently have
> a cropcap function implemented (yet).  Does this still need to be written?

Correct as well, cropcap isn't implemented yet. It's still unclear how exactly 
it will be implemented in the future.

-- 
Regards,

Laurent Pinchart
