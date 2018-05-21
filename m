Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:47602 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751161AbeEUNEb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 May 2018 09:04:31 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Dave Stevenson <dave.stevenson@raspberrypi.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        LMML <linux-media@vger.kernel.org>
Subject: Re: [ANN] Meeting to discuss improvements to support MC-based cameras on generic apps
Date: Mon, 21 May 2018 16:04:53 +0300
Message-ID: <2510626.AtPlJJ1Wen@avalon>
In-Reply-To: <CAAoAYcODVNVF0dh8bzOXNn1ZJC1bsz=BzAnp9eEBkQZrKE9yfA@mail.gmail.com>
References: <20180517160708.74811cfb@vento.lan> <2565074.bXLGL3KLfK@avalon> <CAAoAYcODVNVF0dh8bzOXNn1ZJC1bsz=BzAnp9eEBkQZrKE9yfA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dave,

On Monday, 21 May 2018 15:16:19 EEST Dave Stevenson wrote:
> On 19 May 2018 at 08:04, Laurent Pinchart wrote:
> > On Friday, 18 May 2018 18:37:01 EEST Dave Stevenson wrote:
> >> On 18 May 2018 at 16:05, Mauro Carvalho Chehab wrote:
> >>> Em Fri, 18 May 2018 15:27:24 +0300
> >> 
> >> <snip>
> >> 
> >>>>> There, instead of an USB camera, the hardware is equipped with a
> >>>>> MC-based ISP, connected to its camera. Currently, despite having
> >>>>> a Kernel driver for it, the camera doesn't work with any
> >>>>> userspace application.
> >>>>> 
> >>>>> I'm also aware of other projects that are considering the usage of
> >>>>> mc-based devices for non-dedicated hardware.
> >>>> 
> >>>> What are those projects ?
> >>> 
> >>> Well, cheap ARM-based hardware like RPi3 already has this issue: they
> >>> have an ISP (or some GPU firmware meant to emulate an ISP). While
> >>> those hardware could have multiple sensors, typically they have just
> >>> one.
> >> 
> >> Slight hijack, but a closely linked issue for the Pi.
> >> The way I understand the issue of V4L2 / MC on Pi is a more
> >> fundamental mismatch in architecture. Please correct me if I'm wrong
> >> here.
> >> 
> >> The Pi CSI2 receiver peripheral always writes the incoming data to
> >> SDRAM, and the ISP is then a memory to memory device.
> >> 
> >> V4L2 subdevices are not dma controllers and therefore have no buffers
> >> allocated to them. So to support the full complexity of the pipeline
> >> in V4L2 requires that something somewhere would have to be dequeuing
> >> the buffers from the CSI receiver V4L2 device and queuing them to the
> >> input of a (theoretical) ISP M2M V4L2 device, and returning them once
> >> processed. The application only cares about the output of the ISP M2M
> >> device.
> > 
> > Regardless of the software stack architecture, something running on the
> > CPU has to perform that job. We have decided that that "something" needs
> > to run in userspace, to avoid pushing use-case-dependent code to the
> > kernel.
> > 
> > Note that this isn't specific to the RPi. The OMAP3 ISP, while integrating
> > the CSI-2 receiver and being able to process data on the fly, can also
> > write the raw images to memory and then process them in memory-to-memory
> > mode. This feature is used mostly for still image capture to perform
> > pre-processing with the CPU (or possibly GPU) on the raw images before
> > processing them in the ISP. There's no way we could implement this fully
> > in the kernel.
> 
> Sure. I was mainly flagging that having to manage buffers also needs
> to be considered in order to make a usable system. Just configuring an
> MC pipeline won't solve all the issues.
> 
> >> So I guess my question is whether there is a sane mechanism to remove
> >> that buffer allocation and handling from the app? Without it we are
> >> pretty much forced to hide bigger blobs of functionality to even
> >> vaguely fit in with V4L2.
> > 
> > We need a way to remove that from the application, but it won't be pushed
> > down to the kernel. These tasks should be handled by a userspace
> > framework, transparently for the application. The purpose of this
> > discussion is to decide on the design of the framework.
> 
> I'm in agreement there, but hadn't seen discussion on buffer
> management, only MC configuration.

I'll take the blame for not having been clear enough. We certainly need to 
support more than static pipeline configuration and 3A algorithms, there's a 
need to support interactions with the device at runtime even for simple 
capture without 3A. That's a use case I certainly want to see addressed.

> >> I'm at the point where it shouldn't be a huge amount of work to create
> >> at least a basic ISP V4L2 M2M device, but I'm not planning on doing it
> >> if it pushes the above buffer handling onto the app because it simply
> >> won't get used beyond demo apps. The likes of Cheese, Scratch, etc,
> >> just won't do it.
> >> 
> >> 
> >> To avoid ambiguity, the Pi has a hardware ISP block. There are other
> >> SoCs that use either GPU code or a DSP to implement their ISP.
> > 
> > Is that ISP documented publicly ?
> 
> Not publicly, and as it's Broadcom's IP we can't release it :-(
> 
> What I have working is using the Broadcom MMAL API (very similar to
> OpenMAX IL) to wrap the ISP hardware block via the VideoCore firmware.
> Currently it has the major controls exposed (black level, digital
> gain, white balance, CCMs, lens shading tables) and I'll add
> additional controls as time permits or use cases require. Resizing and
> format conversion are done based on input and output formats. Defining
> stats regions and extracting the resulting stats is still to be done.
> Overall it keeps all the implementation details hidden so we don't
> break NDAs, but should allow efficient processing. It supports
> dma-bufs in and out, so no extra copies of the data should be
> required.
> 
> I'm currently finishing off a V4L2 M2M wrapper around the MMAL
> video_encode and video_decode components, so modifying it to support
> the ISP component shouldn't be difficult if there is value in doing
> so. I know it's not the ideal, but our hands are tied.

I won't blame you for that. My personal goal with the new framework is however 
to create the foundation of an open-source ecosystem.

-- 
Regards,

Laurent Pinchart
