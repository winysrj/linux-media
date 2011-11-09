Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:61243 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054Ab1KIVXz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Nov 2011 16:23:55 -0500
Date: Wed, 9 Nov 2011 22:23:53 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sylwester Nawrocki <snjw23@gmail.com>
cc: linux-media <linux-media@vger.kernel.org>
Subject: Re: [KS workshop follow-up] multiple sensor contexts
In-Reply-To: <4EBAECD1.2030604@gmail.com>
Message-ID: <Pine.LNX.4.64.1111092219410.4188@axis700.grange>
References: <Pine.LNX.4.64.1111071645180.26363@axis700.grange>
 <4EBAECD1.2030604@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 9 Nov 2011, Sylwester Nawrocki wrote:

> Hi Guennadi,
> 
> On 11/07/2011 05:17 PM, Guennadi Liakhovetski wrote:
> > Hi all
> > 
> > At the V4L/DVB workshop in Prague a couple of weeks ago possible merits of
> > supporting multiple camera sensor contexts have been discussed. Such
> > contexts are often promoted by camera manufacturers as a hardware
> > optimization to support fast switching to the snapshot mode. Such a switch
> > is often accompanied by a change of the frame format. Typically, a smaller
> > frame is used for the preview mode and a larger frame is used for photo
> > shooting. Those sensors provide 2 (or more) sets of frame size and data
> > format registers and a single command to switch between them. The
> > decision, whether or not to support these multiple camera contexts has
> > been postponed until some measurements become available, how much time
> > such a "fast switching" implementation would save us.
> > 
> > I took the mt9m111 driver, that supports mt9m111, mt9m131, and mt9m112
> > camera sensors from Aptina. They do indeed implement two contexts,
> > however, the driver first had to be somewhat reorganised to make use of
> > them. I pushed my (highly!) experimental tree to
> > 
> > git://linuxtv.org/gliakhovetski/v4l-dvb.git staging-3.3
> > 
> > with the addition of the below debugging diff, that pre-programs a fixed
> > format into the second context registers and switches to it, once a
> > matching S_FMT is called. On the i.MX31 based pcm037 board, that I've got,
> > this sensor is attached to the I2C bus #2, running at 20kHz. The explicit
> > programming of the new format parameters measures to take around 27ms,
> > which is also about what we win, when using the second context.
> 
> I was expecting the re-programming time being not significant like this.
> I'll try to reserve some time next week to measure how long the sensor
> re-programming takes in case of m5mols device. It has quite a few registers
> to write but its I2C bus clock frequency is 400 kHz so perhaps the results 
> will be similar to yours. 
> 
> > 
> > As for interpretation: firstly 20kHz is not much, I expect many other set
> > ups to run much faster. But even if we accept, that on some hardware>
> > 20kHz doesn't work and we really lose 27ms when not using multiple
> > register contexts, is it a lot? Thinking about my personal photographing
> > experiences with cameras and camera-phones, I don't think, I'd notice a
> > 27ms latency;-) I don't think anything below 200ms really makes a
> > difference and, I think, the major contributor to the snapshot latency is
> > the need to synchronise on a frame, and, possibly skip or shoot several
> > frames, instead of just one.
> > 
> > So, my conclusion would be: when working with "sane" camera sensors, i.e.,
> > those, where you don't have to reprogram 100s of registers from some magic
> > tables to configure a different frame format (;-)), supporting several
> > register contexts doesn't bring a huge advantage in terms of snapshot
> > latency. OTOH, it can well happen, that at some point we anyway will have
> > to support those multiple register contexts for some other reason.
> 
> Hmm, I'm wondering what should the drivers do in case of devices that require 
> explicit setting of some control registers for still capture. Guessing on pixel
> format basis is rather a poor men's solution. This is what M-5MOLS mainline driver
> doeas - if JPEG format is set it switches to snaphot mode. This way YUV format
> cannot be used in snaphot mode.
> There are also distinct resolutions supported for snaphot mode, and it can't be
> currently properly enumerated.
> 
> Hence my question is, should such (whatsoever rare) devices stick with _private_ 
> controls ?
> 
> If we have used VIDIOC_STREAMON for triggering capture, something like boolean 
> SNAPSHOT control is needed, for instance, to tell the sensor controller it should
> fire the flash. 

Yes, I think, that was one of the conclusions of the workshop on this 
topic: we need a new control (a common one, not a private one) to switch 
to snapshot mode. I think, it has been agreed, that someone, (who first 
hits a valid practical use-case?;-)) submits an RFC / patch for such a 
control with a sufficiently detailed description of its semantics...

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
