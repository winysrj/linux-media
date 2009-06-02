Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp6.welho.com ([213.243.153.40]:43350 "EHLO smtp6.welho.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753799AbZFBGR3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Jun 2009 02:17:29 -0400
Message-ID: <4A24BD0F.8070604@hora-obscura.de>
Date: Tue, 02 Jun 2009 08:47:59 +0300
From: Stefan Kost <ensonic@hora-obscura.de>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@skynet.be>
CC: linux-media@vger.kernel.org
Subject: Re: webcam drivers and V4L2_MEMORY_USERPTR support
References: <4A238292.6000205@hora-obscura.de> <200906020112.37890.laurent.pinchart@skynet.be>
In-Reply-To: <200906020112.37890.laurent.pinchart@skynet.be>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent Pinchart schrieb:
> Hi Stefan,
> 
> On Monday 01 June 2009 09:26:10 Stefan Kost wrote:
>> hi,
>>
>> I have implemented support for V4L2_MEMORY_USERPTR buffers in gstreamers
>> v4l2src [1]. This allows to request shared memory buffers from xvideo,
>> capture into those and therefore save a memcpy. This works great with
>> the v4l2 driver on our embedded device.
>>
>> When I was testing this on my desktop, I noticed that almost no driver
>> seems to support it.
>> I tested zc0301 and uvcvideo, but also grepped the kernel driver
>> sources. It seems that gspca might support it, but I ave not confirmed
>> it. Is there a technical reason for it, or is it simply not implemented?
> 
> For the uvcvideo driver it's simply not implemented. I was about to give it a 
> try when I found out a mismatch between the V4L2 specification and the 
> videobuf implementation (which I wanted to use as the reference 
> implementation).
> 
> The V4L2 specification states, in section 3.3, that
> 
> "The driver must be switched into user pointer I/O mode by calling the 
> VIDIOC_REQBUFS with the desired buffer type. No buffers are allocated 
> beforehands, consequently they are not indexed and cannot be queried like 
> mapped buffers with the VIDIOC_QUERYBUF ioctl."
> 
> Example 3-2 shows that v4l2_requestbuffers::count is not used when using 
> USERPTR.
> 
> However, videobuf pre-allocates v4l2_requestbuffers::count kernel-side buffer 
> descriptors when VIDIOC_REQBUFS is called with USERPTR.
> 
I actually noticed the same with our the omap3 camera driver. In userspace I now
call VIDIOC_REQBUFS with V4L2_MEMORY_USERPTR and count=0, if I get EINVAL, try
again with count!=0 and if EINVAL again try V4L2_MEMORY_MMAP (always with
count). I also got feedback from the driver developers, that the buffers are
still indexed and mlocked, so when I DQBUF and QBUF I should enqueue the same
buffers for the same index again.

Stefan

> If someone could clarify which of the V4L2 specification or the videobuf 
> implementation is right I could give USERPTR a try in the uvcvideo driver.
> 
> Best regards,
> 
> Laurent Pinchart
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

