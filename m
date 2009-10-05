Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:55018 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751255AbZJEFoC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Oct 2009 01:44:02 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	Tomasz Fujak <t.fujak@samsung.com>,
	Pawel Osciak <p.osciak@samsung.com>
Date: Mon, 5 Oct 2009 11:13:16 +0530
Subject: RE: Mem2Mem V4L2 devices [RFC]
Message-ID: <19F8576C6E063C45BE387C64729E73940436CF8DBF@dbde02.ent.ti.com>
References: <E4D3F24EA6C9E54F817833EAE0D912AC077151C64F@bssrvexch01.BS.local>
In-Reply-To: <E4D3F24EA6C9E54F817833EAE0D912AC077151C64F@bssrvexch01.BS.local>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Marek Szyprowski
> Sent: Friday, October 02, 2009 5:15 PM
> To: linux-media@vger.kernel.org
> Cc: kyungmin.park@samsung.com; Tomasz Fujak; Pawel Osciak; Marek
> Szyprowski
> Subject: Mem2Mem V4L2 devices [RFC]
> 
> Hello,
> 
> During the V4L2 mini-summit and the Media Controller RFC discussion
> on
> Linux Plumbers 2009 Conference a mem2mem video device has been
> mentioned
> a few times (usually in a context of a 'resizer device' which might
> be a
> part of Camera interface pipeline or work as a standalone device).
> We
> are doing a research how our custom video/multimedia drivers can fit
> into the V4L2 framework. Most of our multimedia devices work in
> mem2mem
> mode.
> 
> I did a quick research and I found that currently in the V4L2
> framework
> there is no device that processes video data in a memory-to-memory
> model. 
[Hiremath, Vaibhav] yes you are right; we do not have readily support available in V4L2 framework.

In terms of V4L2 framework such device would be both video
> sink
> and source at the same time. The main problem is how the video nodes
> (/dev/videoX) should be assigned to such a device.
> 
> The simplest way of implementing mem2mem device in v4l2 framework
> would
> use two video nodes (one for input and one for output). Such an idea
> has
> been already suggested on V4L2 mini-summit. 
[Hiremath, Vaibhav] We discussed 2 options during summit, 

1) Only one video device node, and configuring parameters using V4L2_BUF_TYPE_VIDEO_CAPTURE for input parameter and V4L2_BUF_TYPE_VIDEO_OUTPUT for output parameter.

2) 2 separate video device node, one with V4L2_BUF_TYPE_VIDEO_CAPTURE and another with V4L2_BUF_TYPE_VIDEO_OUTPUT, as mentioned by you.

The obvious and preferred option would be 2, because with option 1 we could not able to achieve real streaming. And again we have to put constraint on application for fixed input buffer index.

> Each DMA engine (either
> input or output) that is available in the hardware should get its
> own
> video node. In this approach an application can write() source image
> to
> for example /dev/video0 and then read the processed output from for
> example /dev/video1. Source and destination format/params/other
> custom
> settings also can be easily set for either source or destination
> node.
> Besides a single image, user applications can also process video
> streams
> by calling stream_on(), qbuf() + dqbuf(), stream_off()
> simultaneously on
> both video nodes.
> 
[Hiremath, Vaibhav] Correct.

> This approach has a limitation however. As user applications would
> have
> to open 2 different file descriptors to perform the processing of a
> single image, the v4l2 driver would need to match read() calls done
> on
> one file descriptor with write() calls from the another. The same
> thing
> would happen with buffers enqueued with qbuf(). In practice, this
> would
> result in a driver that allows only one instance of /dev/video0 as
> well
> as /dev/video1 opened. Otherwise, it would not be possible to track
> which opened /dev/video0 instance matches which /dev/video1 one.
> 
[Hiremath, Vaibhav] Please note that we must put one limitation to application that, the buffers in both the video nodes are mapped one-to-one. This means that, 

Video0 (input)		Video1 (output)
Index-0	==>		index-0
Index-1	==>		index-1
Index-2	==>		index-2

Do you see any other option to this? I think this constraint is obvious from application point of view in during streaming.

> The real limitation of this approach is the fact, that it is hardly
> possible to implement multi-instance support and application
> multiplexing on a video device. In a typical embedded system, in
> contrast to most video-source-only or video-sink-only devices, a
> mem2mem
> device is very often used by more than one application at a time. Be
> it
> either simple one-shot single video frame processing or stream
> processing. Just consider that the 'resizer' module might be used in
> many applications for scaling bitmaps (xserver video subsystem,
> gstreamer, jpeglib, etc) only.
> 
[Hiremath, Vaibhav] Correct.

> At the first glance one might think that implementing multi-instance
> support should be done in a userspace daemon instead of mem2mem
> drivers.
> However I have run into problems designing such a user space daemon.
> Usually, video buffers are passed to v4l2 device as a user pointer
> or
> are mmaped directly from the device. The main issue that cannot be
> easily resolved is passing video buffers from the client application
> to
> the daemon. The daemon would queue a request on the device and
> return
> results back to the client application after a transaction is
> finished.
> Passing userspace pointers between an application and the daemon
> cannot
> be done, as they are two different processes. Mmap-type buffers are
> similar in this aspect - at least 2 buffer copy operations are
> required
> (from client application to device input buffers mmaped in daemon's
> memory and then from device output buffers to client application).
> Buffer copying and process context switches add both latency and
> additional cpu workload. In our custom drivers for mem2mem
> multimedia
> devices we implemented a queue shared between all instances of an
> opened
> mem2mem device. Each instance is assigned to an open device file
> descriptor. The queue is serviced in the device context, thus
> maximizing
> the device throughput. This is achieved by scheduling the next
> transaction in the driver (kernel) context. This may not even
> require a
> context switch at all.
> 
> Do you have any ideas how would this solution fit into the current
> v4l2
> design?
> 
[Hiremath, Vaibhav] Initially I thought of having separate queue in driver which tries to make maximum usage of underneath hardware. Application just will queue the buffers and call streamon, driver internally queues it in his own queue and issues a resize operation (in this case) for all the queued buffers, releasing one-by-one to application. We have similar implementation internally, but not with standard V4L2 framework, it uses custom IOCTL's for everything.

But when we decided to provide User Space library with media controller, I thought of moving this burden to application layer. Application library will create an interface and queue and call streamon for all the buffers queued.

Do you see any loopholes here? Am I missing any use-case scenario?

> Another solution that came into my mind that would not suffer from
> this
> limitation is to use the same video node for both writing input
> buffers
> and reading output buffers (or queuing both input and output
> buffers).
[Hiremath, Vaibhav] We have similar implementation for Display driver, where application works or configures the params with V4L2_BUF_TYPE_VIDEO_OVERLAY and V4L2_BUF_TYPE_VIDEO_OUTPUT. We can have V4L2_BUF_TYPE_VIDEO_OUTPUT and V4L2_BUF_TYPE_VIDEO_CAPTURE in case of resizer.

Infact, I remember when I had started porting resizer driver (before media controller) to V4L2 framework I did the same thing.

> Such a design causes more problems with the current v4l2 design
> however:
> 
> 1. How to set different color space or size for input and output
> buffer
> each? It could be solved by adding a set of ioctls to get/set source
> image format and size, while the existing v4l2 ioctls would only
> refer
> to the output buffer. Frankly speaking, we don't like this idea.
> 
> 2. Input and output in the same video node would not be compatible
> with
> the upcoming media controller, with which we will get an ability to
> arrange devices into a custom pipeline. Piping together two separate
> input-output nodes to create a new mem2mem device would be difficult
> and
> unintuitive. And that not even considering multi-output devices.
> 
[Hiremath, Vaibhav] irrespective of the 2 options I mentioned before the media controller will come into picture, either for custom parameter configuration or creating/deleting links.

We are only discussing about buffer queue/de-queue and input output params configuration and this has to happen through video nodes (either 1 or 2).

Thanks,
Vaibhav

> My idea is to get back to the "2 video nodes per device" approach
> and
> introduce a new ioctl for matching input and output instances of the
> same device. When such an ioctl could be called is another question.
> I
> like the idea of restricting such a call to be issued after opening
> video nodes and before using them. Using this ioctl, a user
> application
> would be able to match output instance to an input one, by matching
> their corresponding file descriptors.
> 
> What do you think of such a solution?
> 
> Best regards
> --
> Marek Szyprowski
> Samsung Poland R&D Center
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-
> media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

