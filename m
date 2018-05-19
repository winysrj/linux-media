Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:46862 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750771AbeESHE1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 19 May 2018 03:04:27 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Dave Stevenson <dave.stevenson@raspberrypi.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        LMML <linux-media@vger.kernel.org>
Subject: Re: [ANN] Meeting to discuss improvements to support MC-based cameras on generic apps
Date: Sat, 19 May 2018 10:04:47 +0300
Message-ID: <2565074.bXLGL3KLfK@avalon>
In-Reply-To: <CAAoAYcN-9zrbLWZULZM9emF5G8=stssQy04QgrguSYi4g6dQxw@mail.gmail.com>
References: <20180517160708.74811cfb@vento.lan> <20180518120522.79b36f77@vento.lan> <CAAoAYcN-9zrbLWZULZM9emF5G8=stssQy04QgrguSYi4g6dQxw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dave,

On Friday, 18 May 2018 18:37:01 EEST Dave Stevenson wrote:
> On 18 May 2018 at 16:05, Mauro Carvalho Chehab wrote:
> > Em Fri, 18 May 2018 15:27:24 +0300
> 
> <snip>
> 
> >>> There, instead of an USB camera, the hardware is equipped with a
> >>> MC-based ISP, connected to its camera. Currently, despite having
> >>> a Kernel driver for it, the camera doesn't work with any
> >>> userspace application.
> >>> 
> >>> I'm also aware of other projects that are considering the usage of
> >>> mc-based devices for non-dedicated hardware.
> >> 
> >> What are those projects ?
> > 
> > Well, cheap ARM-based hardware like RPi3 already has this issue: they
> > have an ISP (or some GPU firmware meant to emulate an ISP). While
> > those hardware could have multiple sensors, typically they have just
> > one.
> 
> Slight hijack, but a closely linked issue for the Pi.
> The way I understand the issue of V4L2 / MC on Pi is a more
> fundamental mismatch in architecture. Please correct me if I'm wrong
> here.
> 
> The Pi CSI2 receiver peripheral always writes the incoming data to
> SDRAM, and the ISP is then a memory to memory device.
> 
> V4L2 subdevices are not dma controllers and therefore have no buffers
> allocated to them. So to support the full complexity of the pipeline
> in V4L2 requires that something somewhere would have to be dequeuing
> the buffers from the CSI receiver V4L2 device and queuing them to the
> input of a (theoretical) ISP M2M V4L2 device, and returning them once
> processed. The application only cares about the output of the ISP M2M
> device.

Regardless of the software stack architecture, something running on the CPU 
has to perform that job. We have decided that that "something" needs to run in 
userspace, to avoid pushing use-case-dependent code to the kernel.

Note that this isn't specific to the RPi. The OMAP3 ISP, while integrating the 
CSI-2 receiver and being able to process data on the fly, can also write the 
raw images to memory and then process them in memory-to-memory mode. This 
feature is used mostly for still image capture to perform pre-processing with 
the CPU (or possibly GPU) on the raw images before processing them in the ISP. 
There's no way we could implement this fully in the kernel.

> So I guess my question is whether there is a sane mechanism to remove
> that buffer allocation and handling from the app? Without it we are
> pretty much forced to hide bigger blobs of functionality to even
> vaguely fit in with V4L2.

We need a way to remove that from the application, but it won't be pushed down 
to the kernel. These tasks should be handled by a userspace framework, 
transparently for the application. The purpose of this discussion is to decide 
on the design of the framework.

> I'm at the point where it shouldn't be a huge amount of work to create
> at least a basic ISP V4L2 M2M device, but I'm not planning on doing it
> if it pushes the above buffer handling onto the app because it simply
> won't get used beyond demo apps. The likes of Cheese, Scratch, etc,
> just won't do it.
> 
> 
> To avoid ambiguity, the Pi has a hardware ISP block. There are other
> SoCs that use either GPU code or a DSP to implement their ISP.

Is that ISP documented publicly ?

-- 
Regards,

Laurent Pinchart
