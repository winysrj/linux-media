Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:35989 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755880AbcAMLiw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jan 2016 06:38:52 -0500
Date: Wed, 13 Jan 2016 09:38:46 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Dave Stevenson <linux-media@destevenson.freeserve.co.uk>,
	linux-media@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>
Subject: Re: Using the V4L2 device kernel drivers - TC358743
Message-ID: <20160113093846.2bbcc7a2@recife.lan>
In-Reply-To: <56960390.30303@xs4all.nl>
References: <56956454.4090307@destevenson.freeserve.co.uk>
	<56960390.30303@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 13 Jan 2016 08:58:08 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> Hi Dave,
> 
> On 01/12/2016 09:38 PM, Dave Stevenson wrote:
> > Hi All.
> > 
> > Apologies for what feels like such a newbie question, but I've failed to 
> > find useful information elsewhere.
> > 
> > I'm one of the ex-Broadcom developers who is still supporting Raspberry 
> > Pi, although I'm not employed by Pi Foundation or Trading.
> > My aim is to open up that platform by exposing the CSI2 receiver block 
> > (and eventually parts of the ISP) via V4L2. The first use case would be 
> > for the Toshiba TC358743 HDMI to CSI2 converter, but it should be 
> > applicable to any of the other device drivers too.
> > Sadly it probably won't be upstreamable as it will require the GPU to do 
> > most of the register poking to avoid potential IP issues (Broadcom not 
> > having released the docs for the relevant hardware blocks). In that 
> > regard it will be fairly similar to the existing V4L2 driver for the Pi 
> > camera.

Hmm.... Broadcom wrote a new GPU driver (vc4) that was recently
upstreamed:
	https://wiki.freedesktop.org/dri/VC4/

Maybe its driver could be used/modified to cope with a V4L2 driver.

> > 
> > There is now the driver for the TC358743 in mainline, but my stumbling 
> > block is finding a useful example of how to actually use it. The commit 
> > text by Mats Randgaard says it was "tested on our hardware and all the 
> > implemented features works as expected", but I don't know what that 
> > hardware was or how it was used.  
> 
> It's for Cisco video conferencing equipment, but it basically boils down to
> capturing HDMI input over a CSI2 bus. I believe it's on an omap4.
> 
> I know Philip Zabel also developed for the TC358743. Philip, do you have a
> git tree available that shows how it is used?
> 
> > The media controller API seems to be part of the answer, but that seems 
> > to be a large overhead for an application to have to connect together 
> > multiple sub-devices when it is only interested in images out the back.   
> 
> The MC is only needed if you have hardware that allows for complex and/or
> dynamic internal video routing. For a standard linear video pipeline it
> is not needed.
> 
> > Is there something that sets up default connections that I'm missing? 
> > Somewhere within device tree?  
> 
> Typically the bridge driver (i.e. the platform driver that sets up the
> pipeline and creates the video devices) will use the device tree to find
> the v4l2-subdevice(s) it has to load and hooks them into the pipeline.
> 
> drivers/media/platform/am437x/am437x-vpfe.c looks to be a decent example
> of that.
> 
> Of course, if you have more complex pipelines, then you need to support
> the MC.
> 
> > 
> > I have looked at the OMAP4 ISS driver as a vaguely similar device, but 
> > that seemingly covers the image processing pipe only, not hooking in to 
> > the sensor drivers.  
> 
> Sensor drivers are hooked in in function iss_register_entities(), see the
> section for "/* Register external entities */".
> 
> > I've also got a slight challenge in that ideally I want the GPU to 
> > allocate the memory, and ARM map that memory (we already have a service 
> > to do that), but I can't see how that would fit in with the the existing 
> > videobuf modes. Any thoughts on how I might be able to support that? The 
> > existing V4L2 driver ends up doing a full copy of every buffer from GPU 
> > memory to ARM, which isn't great for performance.
> > There may be an option to use contiguous memory and get the GPU to map 
> > that, but it's more involved as I don't believe the supporting code is 
> > on the Pi branch.  
> 
> The proper way to do this is that the GPU can export buffers as a DMABUF file
> descriptor, then import them in V4L2 (V4L2_MEMORY_DMABUF). The videobuf2
> v4l2 framework will handle all the details for you, so it is trivial on
> the v4l2 side.
> 
> If the GPU doesn't support dmabuf, then I'm not sure if you can do this
> without horrible hacks.
> 
> Regards,
> 
> 	Hans
> 
> > 
> > Any help much appreciated.
> > 
> > Thanks.
> >    Dave
> > 
> > PS If those involved in the TC358743 driver are reading, a couple of 
> > quick emails over the possibility of bringing the audio in over CSI2 
> > rather than I2S would be appreciated. I can split out the relevant CSI2 
> > ID stream, but have no idea how I would then feed that through the 
> > kernel to appear via ALSA.
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >   
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
