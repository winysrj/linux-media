Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout5.samsung.com ([203.254.224.35]:60142 "EHLO
	mailout5.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbZKLLGp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Nov 2009 06:06:45 -0500
Received: from epmmp1 (mailout5.samsung.com [203.254.224.35])
 by mailout1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0KSZ008X8TJDKZ@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 12 Nov 2009 20:06:49 +0900 (KST)
Received: from AMDC159 ([106.116.37.153])
 by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0KSZ00MQITICQY@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 12 Nov 2009 20:06:49 +0900 (KST)
Date: Thu, 12 Nov 2009 12:04:06 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [RFC] Global video buffers pool / Samsung SoC's
In-reply-to: <20091111071250.GV4047@prithivi.gnumonks.org>
To: 'Harald Welte' <laforge@gnumonks.org>, linux-media@vger.kernel.org
Cc: 'Jin-Sung Yang' <jsgood.yang@samsung.com>,
	'Kyungmin Park' <kmpark@infradead.org>,
	Tomasz Fujak <t.fujak@samsung.com>,
	Pawel Osciak <p.osciak@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <007d01ca6387$dd072c10$97158430$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-language: pl
Content-transfer-encoding: 7BIT
References: <20091111071250.GV4047@prithivi.gnumonks.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Wednesday, November 11, 2009 8:13 AM Harald Welte wrote:

> Hi Guennadi and others,
> 
> first of all sorry for breaking the thread, but I am new to this list
> and could not find the message-id of the original mails nor a .mbox
> format archive for the list :(
> 
> As I was one of the people giving comments to Guennadi's talk at ELCE,
> let me give some feedback here, too.
> 
> I'm currently helping the Samsung System LSI Linux kernel team with
> bringing their various ports for their ARM SoCs mainline.  So far we
> have excluded much of the multimedia related parts due to the complexity
> and lack of kernel infrastructure.
> 
> Let me briefly describe the SoCs in question: They have an ARM9, ARM11
> or Cortex-A8 core and multiple video input and output paths, such as
> * camera interface
> * 2d acceleration engine
> * 3d acceleration engine
> * post-processor (colorspace conversion, scaling, rotating)
> * LCM output for classic digital RGB+sync interfaces
> * TV scaler
> * TV encoder
> * HDMI interface (simple serial-HDMI with DMA from/to system memory)
> * Transport Stream interface (MPEG-transport stream input with PID
>   filter which can DMA to system memory
> * MIPI-HSI LCM output device
> * Multi-Function codec for H.264 and other stuff
> * Hardware JPEG codec.
> plus even some more that I might have missed.
> 
> One of the issues is that, at least in many current and upcoming
> products, all those integrated peripherals can only use physically
> contiguous memory.
> 
> For the classic output path (e.g. Xorg+EXA+XAA+3D), that is fine.  The
> framebuffer driver can simply allocate some large chunk of physical
> system memory at boot time, map that into userspace and be happy.  This
> includes things like Xvideo support in the Xserver.  Also, HDMI output
> and TV output can be handled inside X or switch to a new KMS model.
> 
> However, the input side looks quite different,  On the one hand, we have
> the camera driver, but possibly HDMI input and transport stream input,
> are less easy.
> 
> also, given the plethora of such subsytems in a device, you definitely
> don't want to have one static big boot-time allocation for each of those
> devices.  You don't want to waste that much memory all the time just in
> case at some time you start an application that actually needs this.
> Also, it is unlikely that all of the subsystems will operate at the same
> time.
> 
> So having an in-kernel allocator for physically contiguous memory is
> something that is needed to properly support this hardware.  At boot
> time you allocate one big pool, from which you then on-demand allocate
> and free physically contiguous buffers, even at much later time.
> 
> Furthermore, think of something like the JPEG codec acceleration, which
> you also want to use zero-copy from userspace.  So userpsace (like
> libjpeg for decode, or a camera application for encode)would also need
> to be able to allocate such a buffer inside the kernel for input and
> output data of the codec, mmap it, put its jpeg data into it and then
> run the actual codec.
> 
> How would that relate to the proposed global video buffers pool? Well,
> I think before thinking strictly about video buffers for camera chips,
> we have to think much more generically!

We have been working on multimedia drivers for Samsung SoCs for a while
and we already got through all these problems.

The current version of our drivers use private ioctls, zero-copy user
space memory access and our custom memory manager. Our solution is described
in the following thread: 
http://article.gmane.org/gmane.linux.ports.arm.kernel/66463
We posted it as a base (or reference) for the discussion on Global Video
Buffers Pool.

We also found that most of the multimedia devices (FIMC, JPEG, Rotator/Scaler,
MFC, Post Processor, TVOUT, maybe others) can be successfully wrapped into V4L2
framework. We only need to extend the framework a bit, but this is doable and
has been discussed on V4L2 mini summit on LPC 2009. 

The most important issue is how the device that only processes multimedia data
from one buffer in system memory to another should be implemented in V4L2
framework. Quite long, but successful discussion can be found here:
http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/10668/
We are currently implementing a reference test driver for v4l2 mem2mem device.

The other important issues that came up while preparing multimedia drivers
for v4l2 framework is the proper support for multi-plane buffers (like these
required by MFC on newer Samsung SoCs). Here are more details:
http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/11212/

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center


