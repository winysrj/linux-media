Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:44689 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758375AbZKKSeY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Nov 2009 13:34:24 -0500
Date: Wed, 11 Nov 2009 19:34:43 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Harald Welte <laforge@gnumonks.org>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jin-Sung Yang <jsgood.yang@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC] Global video buffers pool / Samsung SoC's
In-Reply-To: <20091111071250.GV4047@prithivi.gnumonks.org>
Message-ID: <Pine.LNX.4.64.0911111926560.4072@axis700.grange>
References: <20091111071250.GV4047@prithivi.gnumonks.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 11 Nov 2009, Harald Welte wrote:

> Hi Guennadi and others,
> 
> first of all sorry for breaking the thread, but I am new to this list
> and could not find the message-id of the original mails nor a .mbox
> format archive for the list :(
> 
> As I was one of the people giving comments to Guennadi's talk at ELCE,
> let me give some feedback here, too.

Adding the author of the RFC to CC.

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
> 
> Also, has anyone investigated if GEM or TTM could be used in unmodified
> or modified form for this?  After all, they are intended to allocate
> (and possibly map) video buffers...

Don't think I can contribute much to the actual matter of the discussion, 
yes, there is a problem, the RFC is trying to address it, there have been 
attempts to implement similar things before (as you write above), so, it 
"just" has to eventually be done.

One question to your SoCs though - do they have SRAM? usable and 
sufficient for graphics buffers? In any case any such implementation will 
have to be able to handle RAMs other than main system memory too, 
including card memory, NUMA, sparse RAM, etc., which is probably obvious 
anyway.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
