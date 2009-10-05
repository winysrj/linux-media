Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:33722 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752569AbZJESHm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Oct 2009 14:07:42 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	Tomasz Fujak <t.fujak@samsung.com>,
	Pawel Osciak <p.osciak@samsung.com>
Date: Mon, 5 Oct 2009 23:36:50 +0530
Subject: RE: Mem2Mem V4L2 devices [RFC]
Message-ID: <19F8576C6E063C45BE387C64729E73940436CF8FE6@dbde02.ent.ti.com>
References: <E4D3F24EA6C9E54F817833EAE0D912AC077151C64F@bssrvexch01.BS.local>
 <19F8576C6E063C45BE387C64729E73940436CF8DBF@dbde02.ent.ti.com>
 <001701ca45c3$90149e10$b03dda30$%szyprowski@samsung.com>
In-Reply-To: <001701ca45c3$90149e10$b03dda30$%szyprowski@samsung.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> -----Original Message-----
> From: Marek Szyprowski [mailto:m.szyprowski@samsung.com]
> Sent: Monday, October 05, 2009 7:26 PM
> To: Hiremath, Vaibhav; linux-media@vger.kernel.org
> Cc: kyungmin.park@samsung.com; Tomasz Fujak; Pawel Osciak; Marek
> Szyprowski
> Subject: RE: Mem2Mem V4L2 devices [RFC]
> 
> Hello,
> 
> On Monday, October 05, 2009 7:43 AM Hiremath, Vaibhav wrote:
> 
> > In terms of V4L2 framework such device would be both video
> > > sink
> > > and source at the same time. The main problem is how the video
> nodes
> > > (/dev/videoX) should be assigned to such a device.
> > >
> > > The simplest way of implementing mem2mem device in v4l2
> framework
> > > would
> > > use two video nodes (one for input and one for output). Such an
> idea
> > > has
> > > been already suggested on V4L2 mini-summit.
> > [Hiremath, Vaibhav] We discussed 2 options during summit,
> >
> > 1) Only one video device node, and configuring parameters using
> V4L2_BUF_TYPE_VIDEO_CAPTURE for input
> > parameter and V4L2_BUF_TYPE_VIDEO_OUTPUT for output parameter.
> >
> > 2) 2 separate video device node, one with
> V4L2_BUF_TYPE_VIDEO_CAPTURE and another with
> > V4L2_BUF_TYPE_VIDEO_OUTPUT, as mentioned by you.
> >
> > The obvious and preferred option would be 2, because with option 1
> we could not able to achieve real
> > streaming. And again we have to put constraint on application for
> fixed input buffer index.
> 
> What do you mean by real streaming?
> 
[Hiremath, Vaibhav] I meant, after streamon, there will be just sequence of queuing and de-queuing of buffers. With single node of operation, how are we deciding which is input buffer and which one is output? We have to assume or put constraint on application that the 0th index will be always input, irrespective of number of buffers requested. 

In normal scenario (for example in codecs), the application will open the device once and start pumping the buffers, driver should queue the buffers as and when it comes directly to driver.

> >
> > > This approach has a limitation however. As user applications
> would
> > > have
> > > to open 2 different file descriptors to perform the processing
> of a
> > > single image, the v4l2 driver would need to match read() calls
> done
> > > on
> > > one file descriptor with write() calls from the another. The
> same
> > > thing
> > > would happen with buffers enqueued with qbuf(). In practice,
> this
> > > would
> > > result in a driver that allows only one instance of /dev/video0
> as
> > > well
> > > as /dev/video1 opened. Otherwise, it would not be possible to
> track
> > > which opened /dev/video0 instance matches which /dev/video1 one.
> > >
> > [Hiremath, Vaibhav] Please note that we must put one limitation to
> application that, the buffers in
> > both the video nodes are mapped one-to-one. This means that,
> >
> > Video0 (input)		Video1 (output)
> > Index-0	==>		index-0
> > Index-1	==>		index-1
> > Index-2	==>		index-2
> >
> > Do you see any other option to this? I think this constraint is
> obvious from application point of view
> > in during streaming.
> 
> This is correct. Every application should queue a corresponding
> output buffer for each queued input buffer.
> NOTE that the this while discussion is how make it possible to have
> 2 different applications running at the same time, each of them
> queuing their own input and output buffers. It will look somehow
> like this:
> 
> Video0 (input)		Video1 (output)
> App1, Index-0	==>		App1, index-0
> App2, Index-0	==>		App2, index-0
> App1, Index-1	==>		App1, index-1
> App2, Index-1	==>		App2, index-1
> App1, Index-2	==>		App1, index-2
> App2, Index-2	==>		App2, index-2
> 
> Note, that the absolute order of the queue/dequeue might be
> different, but each application should get the right output buffer,
> which corresponds to the queued input buffer.
> 
[Hiremath, Vaibhav] We have to create separate queues for every device open call. It would be difficult/complex for the driver to maintain special queue for request from number of applications.

> > [Hiremath, Vaibhav] Initially I thought of having separate queue
> in driver which tries to make maximum
> > usage of underneath hardware. Application just will queue the
> buffers and call streamon, driver
> > internally queues it in his own queue and issues a resize
> operation (in this case) for all the queued
> > buffers, releasing one-by-one to application. We have similar
> implementation internally, but not with
> > standard V4L2 framework, it uses custom IOCTL's for everything.
> 
> This is similar to what we have currently, however we want to move
> all our custom drivers into the generic kernel frameworks.
> 
> > But when we decided to provide User Space library with media
> controller, I thought of moving this
> > burden to application layer. Application library will create an
> interface and queue and call streamon
> > for all the buffers queued.
> >
> > Do you see any loopholes here? Am I missing any use-case scenario?
> 
> How do you want to pass buffers from your client applications
> through the user space library to the video nodes?
> 
[Hiremath, Vaibhav] This is just an initial thought, and may or may not require depending on how it turns out.

But still do you see any issues in implementing user space library here? This was more drivers in order to make maximum use of underneath resource to avoid multiple streamon - streamoff sequence.

Library will provide one more interface where client application will talk to, and library will take buffer from client application, maintains queue internally and then queues it to device. You can have multiple clients citing on top of library, where library will open the device once and will start streaming.

> > > Such a design causes more problems with the current v4l2 design
> > > however:
> > >
> > > 1. How to set different color space or size for input and output
> > > buffer
> > > each? It could be solved by adding a set of ioctls to get/set
> source
> > > image format and size, while the existing v4l2 ioctls would only
> > > refer
> > > to the output buffer. Frankly speaking, we don't like this idea.
> > >
> > > 2. Input and output in the same video node would not be
> compatible
> > > with
> > > the upcoming media controller, with which we will get an ability
> to
> > > arrange devices into a custom pipeline. Piping together two
> separate
> > > input-output nodes to create a new mem2mem device would be
> difficult
> > > and
> > > unintuitive. And that not even considering multi-output devices.
> > >
> > [Hiremath, Vaibhav] irrespective of the 2 options I mentioned
> before the media controller will come
> > into picture, either for custom parameter configuration or
> creating/deleting links.
> >
> > We are only discussing about buffer queue/de-queue and input
> output params configuration and this has
> > to happen through video nodes (either 1 or 2).
> 
> You are right, buffer queuing is handled only at video nodes and
> should not depend on Media Controller. The only aspect that we
> might (or not) take into account when designing mem2mem devices is
> the way we want to handle video nodes after pipeline topology
> change. This is much easier if we use 2 nodes approach (in this case
> the device might be just available at different video nodes).
> 
[Hiremath, Vaibhav] I think I am following you here, If I understand correctly, you are trying to say we may to consider the about what will happen if topology got changed? Is this right?


If yes, then there are 2 possible options - 

- Dynamic device creation: I will restrict myself here and would leave it for future. 

- Idle device node: The device will return -EBUSY if it is not available and is part of some other link where streaming is going on. Atleast for initial version I think we should restrict ourselves here.

Thanks,
Vaibhav

> Best regards
> --
> Marek Szyprowski
> Samsung Poland R&D Center
> 
> 

