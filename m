Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:62443 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbZJEOHK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Oct 2009 10:07:10 -0400
Received: from epmmp1 (mailout2.samsung.com [203.254.224.25])
 by mailout1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0KR100J56O11RD@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 05 Oct 2009 22:55:49 +0900 (KST)
Received: from AMDC159 ([106.116.37.153])
 by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0KR1005PTO0QN8@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 05 Oct 2009 22:55:49 +0900 (KST)
Date: Mon, 05 Oct 2009 15:54:12 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: Mem2Mem V4L2 devices [RFC]
In-reply-to: <1254500705.16625.35.camel@iivanov.int.mm-sol.com>
To: "'Ivan T. Ivanov'" <iivanov@mm-sol.com>
Cc: linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	Tomasz Fujak <t.fujak@samsung.com>,
	Pawel Osciak <p.osciak@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <001601ca45c3$54134a10$fc39de30$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
References: <E4D3F24EA6C9E54F817833EAE0D912AC077151C64F@bssrvexch01.BS.local>
 <1254500705.16625.35.camel@iivanov.int.mm-sol.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Friday, October 02, 2009 6:25 PM Ivan T. Ivanov wrote:

> On Fri, 2009-10-02 at 13:45 +0200, Marek Szyprowski wrote:
> > Hello,
> >
> > During the V4L2 mini-summit and the Media Controller RFC discussion on
> > Linux Plumbers 2009 Conference a mem2mem video device has been mentioned
> > a few times (usually in a context of a 'resizer device' which might be a
> > part of Camera interface pipeline or work as a standalone device). We
> > are doing a research how our custom video/multimedia drivers can fit
> > into the V4L2 framework. Most of our multimedia devices work in mem2mem
> > mode.
> >
> > I did a quick research and I found that currently in the V4L2 framework
> > there is no device that processes video data in a memory-to-memory
> > model. In terms of V4L2 framework such device would be both video sink
> > and source at the same time. The main problem is how the video nodes
> > (/dev/videoX) should be assigned to such a device.
> >
> > The simplest way of implementing mem2mem device in v4l2 framework would
> > use two video nodes (one for input and one for output). Such an idea has
> > been already suggested on V4L2 mini-summit. Each DMA engine (either
> > input or output) that is available in the hardware should get its own
> > video node. In this approach an application can write() source image to
> > for example /dev/video0 and then read the processed output from for
> > example /dev/video1. Source and destination format/params/other custom
> > settings also can be easily set for either source or destination node.
> > Besides a single image, user applications can also process video streams
> > by calling stream_on(), qbuf() + dqbuf(), stream_off() simultaneously on
> > both video nodes.
> >
> > This approach has a limitation however. As user applications would have
> > to open 2 different file descriptors to perform the processing of a
> > single image, the v4l2 driver would need to match read() calls done on
> > one file descriptor with write() calls from the another. The same thing
> > would happen with buffers enqueued with qbuf(). In practice, this would
> > result in a driver that allows only one instance of /dev/video0 as well
> > as /dev/video1 opened. Otherwise, it would not be possible to track
> > which opened /dev/video0 instance matches which /dev/video1 one.
> >
> > The real limitation of this approach is the fact, that it is hardly
> > possible to implement multi-instance support and application
> > multiplexing on a video device. In a typical embedded system, in
> > contrast to most video-source-only or video-sink-only devices, a mem2mem
> > device is very often used by more than one application at a time. Be it
> > either simple one-shot single video frame processing or stream
> > processing. Just consider that the 'resizer' module might be used in
> > many applications for scaling bitmaps (xserver video subsystem,
> > gstreamer, jpeglib, etc) only.
> >
> > At the first glance one might think that implementing multi-instance
> > support should be done in a userspace daemon instead of mem2mem drivers.
> > However I have run into problems designing such a user space daemon.
> > Usually, video buffers are passed to v4l2 device as a user pointer or
> > are mmaped directly from the device. The main issue that cannot be
> > easily resolved is passing video buffers from the client application to
> > the daemon. The daemon would queue a request on the device and return
> > results back to the client application after a transaction is finished.
> > Passing userspace pointers between an application and the daemon cannot
> > be done, as they are two different processes. Mmap-type buffers are
> > similar in this aspect - at least 2 buffer copy operations are required
> > (from client application to device input buffers mmaped in daemon's
> > memory and then from device output buffers to client application).
> > Buffer copying and process context switches add both latency and
> > additional cpu workload. In our custom drivers for mem2mem multimedia
> > devices we implemented a queue shared between all instances of an opened
> > mem2mem device. Each instance is assigned to an open device file
> > descriptor. The queue is serviced in the device context, thus maximizing
> > the device throughput. This is achieved by scheduling the next
> > transaction in the driver (kernel) context. This may not even require a
> > context switch at all.
> >
> > Do you have any ideas how would this solution fit into the current v4l2
> > design?
> >
> > Another solution that came into my mind that would not suffer from this
> > limitation is to use the same video node for both writing input buffers
> > and reading output buffers (or queuing both input and output buffers).
> > Such a design causes more problems with the current v4l2 design however:
> >
> > 1. How to set different color space or size for input and output buffer
> > each? It could be solved by adding a set of ioctls to get/set source
> > image format and size, while the existing v4l2 ioctls would only refer
> > to the output buffer. Frankly speaking, we don't like this idea.
> 
> I think that is not unusual one video device to define that it can
> support at the same time input and output operation.
> 
> Lets take as example resizer device. it is always possible that it
> inform user space application that
> 
> struct v4l2_capability.capabilities ==
> 		(V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OUTPUT)
> 
> User can issue S_FMT ioctl supplying
> 
> struct v4l2_format.type = V4L2_BUF_TYPE_VIDEO_CAPTURE
> 		  .pix  = width x height
> 
> which will instruct this device to prepare its output for this
> resolution. after that user can issue S_FMT ioctl supplying
> 
> struct v4l2_format.type = V4L2_BUF_TYPE_VIDEO_OUTPUT
>    		  .pix  = width x height
> 
> using only these ioctls should be enough to device driver
> to know down/up scale factor required.
> 
> regarding color space struct v4l2_pix_format have field 'pixelformat'
> which can be used to define input and output buffers content.
> so using only existing ioctl's user can have working resizer device.
> 
> also please note that there is VIDIOC_S_CROP which can add additional
> flexibility of adding cropping on input or output.

You are right, thanks for pointing this! I didn't notice that there is
a 'type' parameter in S_FMT, S_CROP, etc arguments.

> last thing which should be done is to QBUF 2 buffers and call STREAMON.

Right.

> i think this will simplify a lot buffer synchronization.

Yes, this would definitely simplify internal buffer management, as each
opened device instance can get its own buffer queue. This way more than
one application would be able to use the 'resizer' device virtually at
the same time (with simple time sharing done in the device driver).

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center


