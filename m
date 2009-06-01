Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:43501 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbZFAXHy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Jun 2009 19:07:54 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Stefan Kost <ensonic@hora-obscura.de>
Subject: Re: webcam drivers and V4L2_MEMORY_USERPTR support
Date: Tue, 2 Jun 2009 01:12:37 +0200
Cc: linux-media@vger.kernel.org
References: <4A238292.6000205@hora-obscura.de>
In-Reply-To: <4A238292.6000205@hora-obscura.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906020112.37890.laurent.pinchart@skynet.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Stefan,

On Monday 01 June 2009 09:26:10 Stefan Kost wrote:
> hi,
>
> I have implemented support for V4L2_MEMORY_USERPTR buffers in gstreamers
> v4l2src [1]. This allows to request shared memory buffers from xvideo,
> capture into those and therefore save a memcpy. This works great with
> the v4l2 driver on our embedded device.
>
> When I was testing this on my desktop, I noticed that almost no driver
> seems to support it.
> I tested zc0301 and uvcvideo, but also grepped the kernel driver
> sources. It seems that gspca might support it, but I ave not confirmed
> it. Is there a technical reason for it, or is it simply not implemented?

For the uvcvideo driver it's simply not implemented. I was about to give it a 
try when I found out a mismatch between the V4L2 specification and the 
videobuf implementation (which I wanted to use as the reference 
implementation).

The V4L2 specification states, in section 3.3, that

"The driver must be switched into user pointer I/O mode by calling the 
VIDIOC_REQBUFS with the desired buffer type. No buffers are allocated 
beforehands, consequently they are not indexed and cannot be queried like 
mapped buffers with the VIDIOC_QUERYBUF ioctl."

Example 3-2 shows that v4l2_requestbuffers::count is not used when using 
USERPTR.

However, videobuf pre-allocates v4l2_requestbuffers::count kernel-side buffer 
descriptors when VIDIOC_REQBUFS is called with USERPTR.

If someone could clarify which of the V4L2 specification or the videobuf 
implementation is right I could give USERPTR a try in the uvcvideo driver.

Best regards,

Laurent Pinchart

