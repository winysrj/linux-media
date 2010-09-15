Return-path: <mchehab@pedra>
Received: from mailout1.samsung.com ([203.254.224.24]:20356 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030Ab0IOGis (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Sep 2010 02:38:48 -0400
Received: from epmmp2 (mailout1.samsung.com [203.254.224.24])
 by mailout1.samsung.com
 (Sun Java(tm) System Messaging Server 7u3-15.01 64bit (built Feb 12 2010))
 with ESMTP id <0L8R00JQ5ZSDT370@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 15 Sep 2010 15:38:37 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0L8R001YAZSESQ@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 15 Sep 2010 15:38:38 +0900 (KST)
Date: Wed, 15 Sep 2010 15:38:37 +0900
From: "Kim, HeungJun" <riverful.kim@samsung.com>
Subject: RE: how can deal with the stream in only on-the-fly-output available
 HW block??
In-reply-to: 
To: 'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>,
	hverkuil@xs4all.nl
Cc: linux-media@vger.kernel.org, inki.dae@samsung.com,
	kyungmin.park@samsung.com
Message-id: <02d401cb54a0$a0b750e0$e225f2a0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7BIT
References: 
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Sorry, I miss sending msg into any other thread.
Send with the right thread, Again.

Thanks,
HeungJun Kim

----------------------------------------------------------------------------
--------------

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
> From: Kim, HeungJun [mailto:riverful.kim@samsung.com]
> Sent: Tuesday, September 14, 2010 2:11 PM
> To: 'linux-media@vger.kernel.org'; 'laurent.pinchart@ideasonboard.com';
> 'hverkuil@xs4all.nl'
> Cc: 'inki.dae@samsung.com'; 'kyungmin.park@samsung.com'
> Subject: how can deal with the stream in only on-the-fly-output available
> HW block??
> 
> 
> 
> -----Original Message-----
> From: Kim, HeungJun [mailto:riverful.kim@samsung.com]
> Sent: Tuesday, September 14, 2010 2:02 PM
> To: 'laurent.pinchart@ideasonboard.com'; 'hverkuil@xs4all.nl'
> Subject: RE: how can deal with the stream in only on-the-fly-output
> available HW block??
> 
> > On Monday, September 13, 2010 14:10:55 Kim, HeungJun wrote:
> > > Hi all,
> > >
> > >
> > >
> > > What if some SoC's specific HW block supports only on-the-fly mode for
> > > stream output??
> >
> > What do you mean with 'on-the-fly mode'? Does that mean that two HW
> blocks
> > are linked together so that the video stream goes directly from one to
> the
> > other without ever being DMA-ed to memory?
> 
> You're right. It's linked with internal SRAM FIFO. So, syncing streams
> with both blocks is kept with VSync Interrupt. It's not using DMA-ed to
> memory in this mode.
> 
> >
> > >
> > > In this case, what is the suitable buf_type??
> >
> > Suitable buf_type for doing what?
> 
> I wanna define this blocks topology with V4L2 APIs. But, I don't find
> suitable buf_type or any definitions in the V4L2 APIs with current SoC's
> block media topology.
> 
> >
> > You probably need the upcoming media API to be able to correctly deal
> with
> > these issues. Check the mailing list for the patches done by Laurent
> > Pinchart.
> >
> > The current V4L2 API is really not able to handle changes in the
> internal
> > video stream topology.
> 
> Thanks to Hans. It's very helpful.
> I'll check Laurent's media topology patches.
> 
> 
> Hello, Laurent,
> 
> I'm googling and find your patches, so I'm checking with. But, where can I
> get your patches?? Probably, I would find in this page :
> http://git.linuxtv.org/, so what's your repository?
> 
> Regards,
> HeungJun, Kim
> 
> >
> > Regards,
> >
> > 	Hans
> >
> > >
> > > I'm faced with such problem.
> > >
> > >
> > >
> > > As explanation for my situation briefly, the processor I deal with now
> > has 3
> > > Multimedia H/W blocks, and the problem-one in the 3 blocks do the work
> > for
> > > sensor-interfacing and pre-processing.
> > >
> > > It supports CCD or CMOS for input, and DMA or On-The-Fly for output.
> > > Exactly, it has two cases - DMA mode using memory bus & On-The-Fly
>  mode
> > > connected with any other multimedia blocks.
> > >
> > > Also, it use only one format "Bayer RGB" in case of mode the DMA and
> > > On-The-Fly mode both.
> > >
> > >
> > >
> > > So, when the device operates in the On-The-Fly mode, is it alright the
> > > driver's current type is  V4L2_BUF_TYPE_VIDEO_CAPTURE? or something
> else?
> > >
> > > or if setting buf_type is wrong itself, what v4l2 API flow is right
> for
> > > driver or userspace??
> > >
> > >
> > >
> > > the v4l2 buf_type enumeratinos is defined here, but I have no idea
> about
> > > suitable enum value in this case, also except for any other under
> enums
> > too.
> > >
> > >
> > >
> > > V4L2_BUF_TYPE_VIDEO_CAPTURE        = 1,
> > >
> > > V4L2_BUF_TYPE_VIDEO_OUTPUT         = 2,
> > >
> > > V4L2_BUF_TYPE_VIDEO_OVERLAY        = 3,
> > >
> > > V4L2_BUF_TYPE_VBI_CAPTURE          = 4,
> > >
> > > V4L2_BUF_TYPE_VBI_OUTPUT           = 5,
> > >
> > > V4L2_BUF_TYPE_SLICED_VBI_CAPTURE   = 6,
> > >
> > > V4L2_BUF_TYPE_SLICED_VBI_OUTPUT    = 7,
> > >
> > > V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY = 8,
> > >
> > > V4L2_BUF_TYPE_PRIVATE              = 0x80,
> > >
> > >
> > >
> > > I'll thanks for any idea or answer.
> > >
> > >
> > >
> > > Regards,
> > >
> > > HeungJun, Kim
> > >
> > >
> > >
> > >
> >
> > --
> > Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of
> > Cisco

