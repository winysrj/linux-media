Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45917 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221Ab1CVKsB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Mar 2011 06:48:01 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: soc-camera layer2 driver
Date: Tue, 22 Mar 2011 11:48:17 +0100
Cc: Gilles <gilles@gigadevices.com>, linux-media@vger.kernel.org
References: <092708F1-CB5B-420A-B675-EED63B7E68A7@gigadevices.com> <4898622A-5298-4E4D-BAB0-D1C71B7C2845@gigadevices.com> <Pine.LNX.4.64.1103221021450.29576@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1103221021450.29576@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103221148.17804.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday 22 March 2011 10:37:36 Guennadi Liakhovetski wrote:
> On Tue, 22 Mar 2011, Gilles wrote:
> > Dear Dr Guennadi,
> > 
> > Thank you for your answer.
> > 
> > > 1. soc-camera core
> > > 2. camera host driver (receive from sensor, DMA to RAM)
> > > 3. camera sensor drivers
> > > 
> > > If you're developing new hardware, you'll have to write new layer 2
> > > driver for it.
> > 
> > I do understand that part, I guess what I was asking was for any
> > pointers to some up-to-date guides on how to do this. I couldn't find a
> > good documentation on how to to that. I must add that even though I have
> > written drivers to other operating systems, I am new at writing drivers
> > for Linux. The V4L2 layer appears very powerful and, at the same time,
> > there is a lot of documentation out there but, a lot also appears to be
> > obsolete. Of course, the best way is to modify something current. I will
> > attempt to do this but I would still appreciate any current howtos you
> > could point me to.
> 
> Well, there's a Documentation/video4linux/soc-camera.txt but it's not
> really that modern (it mentions 2.6.27 in it...). Last time it has been
> updated for 2.6.32. I have to update it again at some point, things change
> way too quickly. So, yes, your best bet would be to take existing drivers.
> If you plan to support scatter-gather DMA, look at pxa_camera.c, if your
> buffers are going to be contiguous (even though you're not going to use
> the videobuf2-dma-contig allocator), look at sh_mobile_ceu for an advanced
> example, or at one of mx3_camera, mx2_camera, mx1_camera for simpler ones.
> omap1_camera is also trying to support both sg and contig... If you have
> questions, don't hesitate to ask on the ML, also cc me and / or the
> respective driver author. Maybe you end up writing some such howto too;)
> 
> > > As for stereo vision: since you're going to use the same sensor, you
> > > will either have to put it on a different i2c bus, or wire it to
> > > configure a different i2c address. In either case communicating to it
> > > shouldn't be a problem.
> > 
> > Yes, of course and I can change the I2C address so I can use the same
> > bus. My question was more related to synchronization of both frames.
> > Initially, I thought about multiplexing the cameras at the hardware
> > level so that every frame, the data bus would switch to the other camera
> > but then, one has not control over the camera horizontal sync signals.
> > There is no way to guarantee that both cameras HSync are ... well
> > synchronized. Then of course, the other problem would be that the frames
> > would be out of sync in terms of time of capture.
> > 
> > Anyway, the question was more related to synchronicity. And I guess the
> > answer would depend on whether I wanted to capture frame-alternative 3D
> > or side-by-side 3D. Maybe this is too new, I just can't find detailed
> > information about 3D in V4L2.
> 
> I'm not aware about any 3d efforts in v4l2... I would've thought, that one
> would want to synchronize frames at the driver level, the application
> level is too indeterministic. So, you would need to add an API to retrieve
> pairs of frames, I presume, one of which is marked left, other right. This
> frame-pair handling is one addition to the generic V4L2 API. You'll also
> need a way to open / associate two sensors with one v4l2 device node.
> Then, how you assemble two different frames from two sensors in one
> stereo-frame is up to your driver, I presume.
> 
> Alternatively you could use two device nodes and reassemble stereo frames
> in user-space based on indices or timestamps. This should also be
> possible, as long as you guarantee in your driver, that that information
> is really consistent.
> 
> Those were just a couple of quick ideas, perhaps, 3d / stereo-vision
> support in v4l2 requires a careful study and some RFC-rounds...

What about using the multi-plane API for that ?

-- 
Regards,

Laurent Pinchart
