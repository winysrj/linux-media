Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:19387 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075AbZJBLql (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Oct 2009 07:46:41 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Received: from eu_spt2 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0KQV00DOGY1VL760@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 02 Oct 2009 12:46:43 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0KQV001XQY1PRD@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 02 Oct 2009 12:46:43 +0100 (BST)
Date: Fri, 02 Oct 2009 13:45:13 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Mem2Mem V4L2 devices [RFC]
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	Tomasz Fujak <t.fujak@samsung.com>,
	Pawel Osciak <p.osciak@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <E4D3F24EA6C9E54F817833EAE0D912AC077151C64F@bssrvexch01.BS.local>
Content-language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

During the V4L2 mini-summit and the Media Controller RFC discussion on 
Linux Plumbers 2009 Conference a mem2mem video device has been mentioned 
a few times (usually in a context of a 'resizer device' which might be a 
part of Camera interface pipeline or work as a standalone device). We 
are doing a research how our custom video/multimedia drivers can fit 
into the V4L2 framework. Most of our multimedia devices work in mem2mem 
mode. 

I did a quick research and I found that currently in the V4L2 framework 
there is no device that processes video data in a memory-to-memory 
model. In terms of V4L2 framework such device would be both video sink 
and source at the same time. The main problem is how the video nodes 
(/dev/videoX) should be assigned to such a device. 

The simplest way of implementing mem2mem device in v4l2 framework would 
use two video nodes (one for input and one for output). Such an idea has 
been already suggested on V4L2 mini-summit. Each DMA engine (either 
input or output) that is available in the hardware should get its own 
video node. In this approach an application can write() source image to 
for example /dev/video0 and then read the processed output from for 
example /dev/video1. Source and destination format/params/other custom 
settings also can be easily set for either source or destination node. 
Besides a single image, user applications can also process video streams 
by calling stream_on(), qbuf() + dqbuf(), stream_off() simultaneously on 
both video nodes. 

This approach has a limitation however. As user applications would have 
to open 2 different file descriptors to perform the processing of a 
single image, the v4l2 driver would need to match read() calls done on 
one file descriptor with write() calls from the another. The same thing 
would happen with buffers enqueued with qbuf(). In practice, this would 
result in a driver that allows only one instance of /dev/video0 as well 
as /dev/video1 opened. Otherwise, it would not be possible to track 
which opened /dev/video0 instance matches which /dev/video1 one. 

The real limitation of this approach is the fact, that it is hardly 
possible to implement multi-instance support and application 
multiplexing on a video device. In a typical embedded system, in 
contrast to most video-source-only or video-sink-only devices, a mem2mem 
device is very often used by more than one application at a time. Be it 
either simple one-shot single video frame processing or stream 
processing. Just consider that the 'resizer' module might be used in 
many applications for scaling bitmaps (xserver video subsystem, 
gstreamer, jpeglib, etc) only. 

At the first glance one might think that implementing multi-instance 
support should be done in a userspace daemon instead of mem2mem drivers. 
However I have run into problems designing such a user space daemon. 
Usually, video buffers are passed to v4l2 device as a user pointer or 
are mmaped directly from the device. The main issue that cannot be 
easily resolved is passing video buffers from the client application to 
the daemon. The daemon would queue a request on the device and return 
results back to the client application after a transaction is finished. 
Passing userspace pointers between an application and the daemon cannot 
be done, as they are two different processes. Mmap-type buffers are 
similar in this aspect - at least 2 buffer copy operations are required 
(from client application to device input buffers mmaped in daemon's 
memory and then from device output buffers to client application). 
Buffer copying and process context switches add both latency and 
additional cpu workload. In our custom drivers for mem2mem multimedia 
devices we implemented a queue shared between all instances of an opened 
mem2mem device. Each instance is assigned to an open device file 
descriptor. The queue is serviced in the device context, thus maximizing 
the device throughput. This is achieved by scheduling the next 
transaction in the driver (kernel) context. This may not even require a 
context switch at all. 

Do you have any ideas how would this solution fit into the current v4l2 
design? 

Another solution that came into my mind that would not suffer from this 
limitation is to use the same video node for both writing input buffers 
and reading output buffers (or queuing both input and output buffers). 
Such a design causes more problems with the current v4l2 design however: 

1. How to set different color space or size for input and output buffer 
each? It could be solved by adding a set of ioctls to get/set source 
image format and size, while the existing v4l2 ioctls would only refer 
to the output buffer. Frankly speaking, we don't like this idea. 

2. Input and output in the same video node would not be compatible with 
the upcoming media controller, with which we will get an ability to 
arrange devices into a custom pipeline. Piping together two separate 
input-output nodes to create a new mem2mem device would be difficult and 
unintuitive. And that not even considering multi-output devices. 

My idea is to get back to the "2 video nodes per device" approach and 
introduce a new ioctl for matching input and output instances of the 
same device. When such an ioctl could be called is another question. I 
like the idea of restricting such a call to be issued after opening 
video nodes and before using them. Using this ioctl, a user application 
would be able to match output instance to an input one, by matching 
their corresponding file descriptors. 

What do you think of such a solution? 

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center


