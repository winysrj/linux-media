Return-path: <mchehab@pedra>
Received: from mailout2.samsung.com ([203.254.224.25]:12340 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab0IOF5p (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Sep 2010 01:57:45 -0400
Received: from epmmp2 (mailout2.samsung.com [203.254.224.25])
 by mailout2.samsung.com
 (Sun Java(tm) System Messaging Server 7u3-15.01 64bit (built Feb 12 2010))
 with ESMTP id <0L8R00971XVMU600@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 15 Sep 2010 14:57:22 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0L8R00162XVMSQ@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 15 Sep 2010 14:57:22 +0900 (KST)
Date: Wed, 15 Sep 2010 14:57:22 +0900
From: "Kim, HeungJun" <riverful.kim@samsung.com>
Subject: RE: Linux V4L2 support dual stream video capture device
In-reply-to: <201009141152.59353.laurent.pinchart@ideasonboard.com>
To: 'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>,
	hverkuil@xs4all.nl
Cc: linux-media@vger.kernel.org, inki.dae@samsung.com,
	kyungmin.park@samsung.com
Message-id: <02d301cb549a$dd3b0300$97b10900$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7BIT
References: <D5AB6E638E5A3E4B8F4406B113A5A19A1E55D29F@shsmsx501.ccr.corp.intel.com>
 <201009130838.56888.laurent.pinchart@ideasonboard.com>
 <alpine.LNX.2.00.1009131142000.22384@banach.math.auburn.edu>
 <201009141152.59353.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Laurent, and Hans,

I checked media frameworks, it was helpful for me, but It's not usable on my
case. Because, before defining the device for using media frameworks, the
device must be defined by some other device like FB, ALSA, DVB, etc. But,
this H/W Block is no way to define using any other method in current V4L2
frameworks.

So, I wanna listen to your advices about this cases.

It has 2 modes, the Preview mode to have Capturing & FIFOing capability, and
the Capture mode to DMAing capabilitiy. Exactly, in Preview mode, it dosen't
need any other V4L2 IOCTL calls related with buffer, like VIDIOC_REQBUFS,
VIDIOC_QUERYBUFS, and mmap() operation. Using just VIDIOC_S_FMT IOCTL calls,
is able to define this block. Because, it has no buffers. The QBUF and DQBUF
looping, also is same any other V4L2 driver working process. On the other
hand, In Capture mode, the same stream of Preview mode, is able to get using
WDMA. So, at this mode, it need V4L2 IOCTL calls related with buffers.

I would show this SoC's media H/W Blocks flowchart briefly.



                                        +------------------+
                                        |     FIFO Link    |
                                    +---|       using      |---+
                                    |   |   Internal SRAM  |   |
   +---+                            |   +------------------+   |
   | C |                            |                          |
   | C |       +--------------------+---+
+---------------+
   | D |       |  H/W Block A           |--------------------|  H/W Block B
|
   |   |       +-----------+------------+   Vsync issued
+---------------+
   | S +-------+ Sensor    | Pre -      |   using Interrupt  |    Post -
|
   | E |       | Interface | Processor  |   recognized at    |   Processor
|
   | N |       +----+--------------+----+   H/W Block B
+-+-------------+
   | S |            |              |                           |
   | O |            +--------------+                           |
   | R |             Vsync issued                              | DMA Link
   +---+             using Interrupt                           |
                     recognized in H/W Block A                 |
                                                               |
 
+---------------------------------------------------+-----------------+
           |                               DMA Bus
|
 
+---------------------------------------------------------------------+

If the flowchart is crashed, copy and paste in the notepad or something.
In the fixed size font, it will looks well.

Actualy my opinion, any other buf_type is needed to define in such case,
like a V4L2_BUF_FLAG_FIFO, not using media framework. 

Thanks to reading, and I'll wait any advises and opinions.

Regards,
HeungJun, Kim



> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Laurent Pinchart
> Sent: Tuesday, September 14, 2010 6:53 PM
> To: Theodore Kilgore
> Cc: Wang, Wen W; linux-media@vger.kernel.org; Zhang, Xiaolin; Huang, Kai;
> Hu, Gang A
> Subject: Re: Linux V4L2 support dual stream video capture device
> 
> Hi Theodore,
> 
> On Monday 13 September 2010 19:17:48 Theodore Kilgore wrote:
> > On Mon, 13 Sep 2010, Laurent Pinchart wrote:
> > > On Friday 07 May 2010 20:20:38 Wang, Wen W wrote:
> > > > Hi all,
> > > >
> > > > I'm wondering if V4L2 framework supports dual stream video capture
> > > > device that transfer a preview stream and a regular stream (still
> > > > capture or video capture) at the same time.
> > > >
> > > > We are developing a device driver with such capability. Our proposal
> to
> > > > do this in V4L2 framework is to have two device nodes, one as
> primary
> > > > node for still/video capture and one for preview.
> > >
> > > If the device supports multiple simultaneous video streams, multiple
> > > video nodes is the way to go.
> > >
> > > > The primary still/video capture device node is used for device
> > > > configuration which can be compatible with open sourced
applications.
> > > > This will ensure the normal V4L2 application can run without code
> > > > modification. Device node for preview will only accept preview
> buffer
> > > > related operations. Buffer synchronization for still/video capture
> and
> > > > preview will be done internally in the driver.
> > >
> > > I suspect that the preview device node will need to support more than
> the
> > > buffer-related operations, as you probably want applications to
> configure
> > > the preview video stream format and size.
> > >
> > > > This is our initial idea about the dual stream support in V4L2. Your
> > > > comments will be appreciated!
> > >
> > > You should use the media controller framework. This will allow
> > > applications to configure all sizes in the pipeline, including the
> frame
> > > sizes for the two video nodes.
> >
> > Hi, Wen,
> >
> > You have hit upon an old and rather vexing problem. It affects many
> > devices, not just your prospective one. The problem is that still mode
> is
> > supported in Linux for a lot of cameras through userspace tools, namely
> > libgphoto2 which uses libusb to interface with the device. But if the
> same
> > device can also do video streaming then the streaming has to be
> supported
> > through a kernel module. Thus until now it is not possible to do both of
> > these smoothly and simultaneously.
> >
> > As I have written both the kernel support and the libgphoto2 support for
> > several dual-mode cameras, I am looking into the related problems, along
> > with Hans de Goede. But right now I am dealing instead with a rather
> > severe illness of a family member. So there is not much coding going on
> > over here.
> >
> > What I think that both of us (Hans and I) agree on is that the kernel
> > modules for the affected devices have to be rewritten in order to allow
> > the opening and closing of the different modes of the devices, and
> > (perhaps) the userspace support has to take that into account as well.
> > There might also have to be some additions to libv4l2 in order to make
> it
> > "aware" of such devices. We have not gotten very far with this project.
> > Hans is quite busy, and so am I (see above).
> >
> > In spite of my present preoccupation, however, I would be very curious
> > about any details of your envisioned camera. For example:
> >
> > Does it use the isochronous mode for streaming and the bulk mode for
> > stills? Or not?
> 
> There seems to be a small misunderstanding. The device Wen is working on
> (as
> far as I'm aware of) isn't a USB device.
> 
> > In still mode, is it some kind of standard device, such as Mass Storage
> or
> > PTP? Or will it use a proprietary or device-specific protocol? If so,
> > it will clearly require a libgphoto2 driver.
> >
> > In video mode, will it use a proprietary or device-specific protocol, or
> > will it be a standard USB video class device? If it is proprietary, then
> > it will presumably need its own module, and if standard then in any
> > event we have to figure out how to make the two different modes to
> > coexist.
> >
> > If either of the still mode or the streaming video mode will use a
> > proprietary protocol and especially if some unknown data compression
> > algorithm is going to be in use, then clearly it is possible to get the
> > support going much earlier if information is provided.
> >
> > Hoping that this will help you and thanking you for any additional
> > information about the new camera.
> 
> --
> Regards,
> 
> Laurent Pinchart
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

