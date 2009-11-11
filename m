Return-path: <linux-media-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:43393 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbZKKHM7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Nov 2009 02:12:59 -0500
Date: Wed, 11 Nov 2009 16:12:50 +0900
From: Harald Welte <laforge@gnumonks.org>
To: linux-media@vger.kernel.org
Cc: Jin-Sung Yang <jsgood.yang@samsung.com>
Subject: Re: [RFC] Global video buffers pool / Samsung SoC's
Message-ID: <20091111071250.GV4047@prithivi.gnumonks.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi and others,

first of all sorry for breaking the thread, but I am new to this list
and could not find the message-id of the original mails nor a .mbox
format archive for the list :(

As I was one of the people giving comments to Guennadi's talk at ELCE,
let me give some feedback here, too.

I'm currently helping the Samsung System LSI Linux kernel team with
bringing their various ports for their ARM SoCs mainline.  So far we
have excluded much of the multimedia related parts due to the complexity
and lack of kernel infrastructure.

Let me briefly describe the SoCs in question: They have an ARM9, ARM11
or Cortex-A8 core and multiple video input and output paths, such as
* camera interface
* 2d acceleration engine
* 3d acceleration engine
* post-processor (colorspace conversion, scaling, rotating)
* LCM output for classic digital RGB+sync interfaces
* TV scaler
* TV encoder
* HDMI interface (simple serial-HDMI with DMA from/to system memory)
* Transport Stream interface (MPEG-transport stream input with PID
  filter which can DMA to system memory
* MIPI-HSI LCM output device
* Multi-Function codec for H.264 and other stuff
* Hardware JPEG codec.
plus even some more that I might have missed.

One of the issues is that, at least in many current and upcoming
products, all those integrated peripherals can only use physically
contiguous memory.

For the classic output path (e.g. Xorg+EXA+XAA+3D), that is fine.  The
framebuffer driver can simply allocate some large chunk of physical
system memory at boot time, map that into userspace and be happy.  This
includes things like Xvideo support in the Xserver.  Also, HDMI output
and TV output can be handled inside X or switch to a new KMS model.

However, the input side looks quite different,  On the one hand, we have
the camera driver, but possibly HDMI input and transport stream input,
are less easy.

also, given the plethora of such subsytems in a device, you definitely
don't want to have one static big boot-time allocation for each of those
devices.  You don't want to waste that much memory all the time just in
case at some time you start an application that actually needs this.
Also, it is unlikely that all of the subsystems will operate at the same
time.

So having an in-kernel allocator for physically contiguous memory is
something that is needed to properly support this hardware.  At boot
time you allocate one big pool, from which you then on-demand allocate
and free physically contiguous buffers, even at much later time.

Furthermore, think of something like the JPEG codec acceleration, which
you also want to use zero-copy from userspace.  So userpsace (like
libjpeg for decode, or a camera application for encode)would also need
to be able to allocate such a buffer inside the kernel for input and
output data of the codec, mmap it, put its jpeg data into it and then
run the actual codec.

How would that relate to the proposed global video buffers pool? Well,
I think before thinking strictly about video buffers for camera chips,
we have to think much more generically!

Also, has anyone investigated if GEM or TTM could be used in unmodified
or modified form for this?  After all, they are intended to allocate
(and possibly map) video buffers...

Regards,
	Harald
-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
