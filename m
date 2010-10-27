Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.1.47]:24390 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933188Ab0J0Nsu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Oct 2010 09:48:50 -0400
Message-ID: <4CC82DBC.4020907@maxwell.research.nokia.com>
Date: Wed, 27 Oct 2010 16:48:44 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Michael Jones <michael.jones@matrix-vision.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	laurent.pinchart@ideasonboard.com
Subject: Re: controls, subdevs, and media framework
References: <4CC6EEDC.20206@matrix-vision.de>
In-Reply-To: <4CC6EEDC.20206@matrix-vision.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Michael,

Michael Jones wrote:
> Having settled on a particular video device, (how) do regular
> controls (ie. VIDIOC_[S|G]_CTRL) work?  I don't see any support for
> them in ispvideo.c.  Is it just yet to be implemented?  Or is it
> expected that the application will access the subdevs individually?

The applications will access the subdevs independently. I'd expect that
regular applications won't be interested in things like
V4L2_CID_EXPOSURE (to manually set exposure value) since they'd more
likely want automatic exposure.

These interfaces (subdevs) can be used by specialised applications and
libraries, most likely a general purpose application would not access
them directly. For example, on N900 the automatic exposure algorithm is
a user space beast, so that functionality cannot be implemented in
kernel level at all.

I'd expect general purpose applications to be using libv4l which will
know how to handle the hardware, in future.

> Basically the same Q for CROPCAP:  isp_video_cropcap passes it on to
> the last link in the chain, but none of the subdevs in the ISP
> currently have a cropcap function implemented (yet).  Does this still
> need to be written?

Setting and getting crop is supported but CROPCAP ioctl isn't actually
even defined for subdevs. I don't think an ioctl similar to CROPCAP even
makes sense since crop is so much more simple for subdevs.

Every time I need to deal with CROPCAP I'll first have to go to read the
specs. ;-)

If there is hardware which has somehow limited crop capability then
there might be a need for an ioctl to query the minimum possible size
after crop. At least the OMAP 3 ISP can crop as much as you want. That
shouldn't be a problem from hardware perspective as fas as I understand.

Cheers,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
