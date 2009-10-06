Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:64544 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756132AbZJFGZ0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Oct 2009 02:25:26 -0400
Received: from epmmp1 (mailout1.samsung.com [203.254.224.24])
 by mailout1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0KR200LQJXT69T@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 06 Oct 2009 15:24:42 +0900 (KST)
Received: from AMDC159 ([106.116.37.153])
 by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0KR200C1MXT1I8@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 06 Oct 2009 15:24:42 +0900 (KST)
Date: Tue, 06 Oct 2009 08:23:10 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: Mem2Mem V4L2 devices [RFC]
In-reply-to: <19F8576C6E063C45BE387C64729E73940436CF8FE6@dbde02.ent.ti.com>
To: "'Hiremath, Vaibhav'" <hvaibhav@ti.com>,
	linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, Tomasz Fujak <t.fujak@samsung.com>,
	Pawel Osciak <p.osciak@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <001c01ca464d$7c9fe440$75dfacc0$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
References: <E4D3F24EA6C9E54F817833EAE0D912AC077151C64F@bssrvexch01.BS.local>
 <19F8576C6E063C45BE387C64729E73940436CF8DBF@dbde02.ent.ti.com>
 <001701ca45c3$90149e10$b03dda30$%szyprowski@samsung.com>
 <19F8576C6E063C45BE387C64729E73940436CF8FE6@dbde02.ent.ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Monday, October 05, 2009 8:07 PM Hiremath, Vaibhav wrote:

> -----Original Message-----
> From: Hiremath, Vaibhav [mailto:hvaibhav@ti.com]
> Sent: Monday, October 05, 2009 8:07 PM
> To: Marek Szyprowski; linux-media@vger.kernel.org
> Cc: kyungmin.park@samsung.com; Tomasz Fujak; Pawel Osciak
> Subject: RE: Mem2Mem V4L2 devices [RFC]
> 
> > -----Original Message-----
> > From: Marek Szyprowski [mailto:m.szyprowski@samsung.com]
> > Sent: Monday, October 05, 2009 7:26 PM
> > To: Hiremath, Vaibhav; linux-media@vger.kernel.org
> > Cc: kyungmin.park@samsung.com; Tomasz Fujak; Pawel Osciak; Marek
> > Szyprowski
> > Subject: RE: Mem2Mem V4L2 devices [RFC]
> >
> > Hello,
> >
> > On Monday, October 05, 2009 7:43 AM Hiremath, Vaibhav wrote:
> >
> > > In terms of V4L2 framework such device would be both video
> > > > sink
> > > > and source at the same time. The main problem is how the video
> > nodes
> > > > (/dev/videoX) should be assigned to such a device.
> > > >
> > > > The simplest way of implementing mem2mem device in v4l2
> > framework
> > > > would
> > > > use two video nodes (one for input and one for output). Such an
> > idea
> > > > has
> > > > been already suggested on V4L2 mini-summit.
> > > [Hiremath, Vaibhav] We discussed 2 options during summit,
> > >
> > > 1) Only one video device node, and configuring parameters using
> > V4L2_BUF_TYPE_VIDEO_CAPTURE for input
> > > parameter and V4L2_BUF_TYPE_VIDEO_OUTPUT for output parameter.
> > >
> > > 2) 2 separate video device node, one with
> > V4L2_BUF_TYPE_VIDEO_CAPTURE and another with
> > > V4L2_BUF_TYPE_VIDEO_OUTPUT, as mentioned by you.
> > >
> > > The obvious and preferred option would be 2, because with option 1
> > we could not able to achieve real
> > > streaming. And again we have to put constraint on application for
> > fixed input buffer index.
> >
> > What do you mean by real streaming?
> >
> [Hiremath, Vaibhav] I meant, after streamon, there will be just sequence of queuing and de-queuing of
> buffers. With single node of operation, how are we deciding which is input buffer and which one is
> output?

By the buffer->type parameter. The only difference is that you will queue both buffers into the same video node.

> We have to assume or put constraint on application that the 0th index will be always input,
> irrespective of number of buffers requested.

No. The input buffers will be distinguished by the type parameter.

> > > [Hiremath, Vaibhav] Please note that we must put one limitation to
> > application that, the buffers in
> > > both the video nodes are mapped one-to-one. This means that,
> > >
> > > Video0 (input)		Video1 (output)
> > > Index-0	==>		index-0
> > > Index-1	==>		index-1
> > > Index-2	==>		index-2
> > >
> > > Do you see any other option to this? I think this constraint is
> > obvious from application point of view
> > > in during streaming.
> >
> > This is correct. Every application should queue a corresponding
> > output buffer for each queued input buffer.
> > NOTE that the this while discussion is how make it possible to have
> > 2 different applications running at the same time, each of them
> > queuing their own input and output buffers. It will look somehow
> > like this:
> >
> > Video0 (input)		Video1 (output)
> > App1, Index-0	==>		App1, index-0
> > App2, Index-0	==>		App2, index-0
> > App1, Index-1	==>		App1, index-1
> > App2, Index-1	==>		App2, index-1
> > App1, Index-2	==>		App1, index-2
> > App2, Index-2	==>		App2, index-2
> >
> > Note, that the absolute order of the queue/dequeue might be
> > different, but each application should get the right output buffer,
> > which corresponds to the queued input buffer.
> >
> [Hiremath, Vaibhav] We have to create separate queues for every device open call. It would be
> difficult/complex for the driver to maintain special queue for request from number of applications.

I know that this would be complex for every driver to maintain its special queues. But imho such an use case (multiple instance
support) is so important (especially for embedded applications) that it is worth to properly design an additional framework for
mem2mem v4l2 devices, so all the buffers handling will be hidden from the actual drivers.

> > > [Hiremath, Vaibhav] Initially I thought of having separate queue
> > in driver which tries to make maximum
> > > usage of underneath hardware. Application just will queue the
> > buffers and call streamon, driver
> > > internally queues it in his own queue and issues a resize
> > operation (in this case) for all the queued
> > > buffers, releasing one-by-one to application. We have similar
> > implementation internally, but not with
> > > standard V4L2 framework, it uses custom IOCTL's for everything.
> >
> > This is similar to what we have currently, however we want to move
> > all our custom drivers into the generic kernel frameworks.
> >
> > > But when we decided to provide User Space library with media
> > controller, I thought of moving this
> > > burden to application layer. Application library will create an
> > interface and queue and call streamon
> > > for all the buffers queued.
> > >
> > > Do you see any loopholes here? Am I missing any use-case scenario?
> >
> > How do you want to pass buffers from your client applications
> > through the user space library to the video nodes?
> >
> [Hiremath, Vaibhav] This is just an initial thought, and may or may not require depending on how it
> turns out.
> 
> But still do you see any issues in implementing user space library here? This was more drivers in
> order to make maximum use of underneath resource to avoid multiple streamon - streamoff sequence.
> 
> Library will provide one more interface where client application will talk to, and library will take
> buffer from client application, maintains queue internally and then queues it to device.

How do you want to implement this? How the library can take a buffer from the client application? Only memcpy() or use of SYSV
shared memory is possible. What about mmap()-like /dev/videoX access methods? How do you want to handle this? If we are talking
about library internal queue then it is rather a daemon with separate process, than a simple library.

> > > We are only discussing about buffer queue/de-queue and input
> > output params configuration and this has
> > > to happen through video nodes (either 1 or 2).
> >
> > You are right, buffer queuing is handled only at video nodes and
> > should not depend on Media Controller. The only aspect that we
> > might (or not) take into account when designing mem2mem devices is
> > the way we want to handle video nodes after pipeline topology
> > change. This is much easier if we use 2 nodes approach (in this case
> > the device might be just available at different video nodes).
> >
> [Hiremath, Vaibhav] I think I am following you here, If I understand correctly, you are trying to say
> we may to consider the about what will happen if topology got changed? Is this right?

Right

> If yes, then there are 2 possible options -
> 
> - Dynamic device creation: I will restrict myself here and would leave it for future.
> 
> - Idle device node: The device will return -EBUSY if it is not available and is part of some other
> link where streaming is going on. Atleast for initial version I think we should restrict ourselves
> here.

Yes, this can be handled like that.

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center



