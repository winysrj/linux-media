Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.187]:49855 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053Ab1CVJhk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Mar 2011 05:37:40 -0400
Date: Tue, 22 Mar 2011 10:37:36 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Gilles <gilles@gigadevices.com>
cc: linux-media@vger.kernel.org
Subject: Re: soc-camera layer2 driver
In-Reply-To: <4898622A-5298-4E4D-BAB0-D1C71B7C2845@gigadevices.com>
Message-ID: <Pine.LNX.4.64.1103221021450.29576@axis700.grange>
References: <092708F1-CB5B-420A-B675-EED63B7E68A7@gigadevices.com>
 <Pine.LNX.4.64.1103210854040.21013@axis700.grange>
 <4898622A-5298-4E4D-BAB0-D1C71B7C2845@gigadevices.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi

On Tue, 22 Mar 2011, Gilles wrote:

> Dear Dr Guennadi,
> 
> Thank you for your answer.
> 
> 
> > 1. soc-camera core
> > 2. camera host driver (receive from sensor, DMA to RAM)
> > 3. camera sensor drivers
> > 
> > If you're developing new hardware, you'll have to write new layer 2 driver 
> > for it.
> 
> I do understand that part, I guess what I was asking was for any 
> pointers to some up-to-date guides on how to do this. I couldn't find a 
> good documentation on how to to that. I must add that even though I have 
> written drivers to other operating systems, I am new at writing drivers 
> for Linux. The V4L2 layer appears very powerful and, at the same time, 
> there is a lot of documentation out there but, a lot also appears to be 
> obsolete. Of course, the best way is to modify something current. I will 
> attempt to do this but I would still appreciate any current howtos you 
> could point me to.

Well, there's a Documentation/video4linux/soc-camera.txt but it's not 
really that modern (it mentions 2.6.27 in it...). Last time it has been 
updated for 2.6.32. I have to update it again at some point, things change 
way too quickly. So, yes, your best bet would be to take existing drivers. 
If you plan to support scatter-gather DMA, look at pxa_camera.c, if your 
buffers are going to be contiguous (even though you're not going to use 
the videobuf2-dma-contig allocator), look at sh_mobile_ceu for an advanced 
example, or at one of mx3_camera, mx2_camera, mx1_camera for simpler ones. 
omap1_camera is also trying to support both sg and contig... If you have 
questions, don't hesitate to ask on the ML, also cc me and / or the 
respective driver author. Maybe you end up writing some such howto too;)

> > As for stereo vision: since you're going to use the same sensor, you will 
> > either have to put it on a different i2c bus, or wire it to configure a 
> > different i2c address. In either case communicating to it shouldn't be a 
> > problem.
> 
> Yes, of course and I can change the I2C address so I can use the same 
> bus. My question was more related to synchronization of both frames. 
> Initially, I thought about multiplexing the cameras at the hardware 
> level so that every frame, the data bus would switch to the other camera 
> but then, one has not control over the camera horizontal sync signals. 
> There is no way to guarantee that both cameras HSync are ... well 
> synchronized. Then of course, the other problem would be that the frames 
> would be out of sync in terms of time of capture.
> 
> Anyway, the question was more related to synchronicity. And I guess the 
> answer would depend on whether I wanted to capture frame-alternative 3D 
> or side-by-side 3D. Maybe this is too new, I just can't find detailed 
> information about 3D in V4L2.

I'm not aware about any 3d efforts in v4l2... I would've thought, that one 
would want to synchronize frames at the driver level, the application 
level is too indeterministic. So, you would need to add an API to retrieve 
pairs of frames, I presume, one of which is marked left, other right. This 
frame-pair handling is one addition to the generic V4L2 API. You'll also 
need a way to open / associate two sensors with one v4l2 device node. 
Then, how you assemble two different frames from two sensors in one 
stereo-frame is up to your driver, I presume.

Alternatively you could use two device nodes and reassemble stereo frames 
in user-space based on indices or timestamps. This should also be 
possible, as long as you guarantee in your driver, that that information 
is really consistent.

Those were just a couple of quick ideas, perhaps, 3d / stereo-vision 
support in v4l2 requires a careful study and some RFC-rounds...

Thanks
Guennadi

> I appreciate any up-to-date documents you can point me to.
> 
> Cheers,
> Gilles
> .
> 
> 
> On Mar 21, 2011, at 01:02 , Guennadi Liakhovetski wrote:
> 
> > Hi Gilles
> > 
> > On Mon, 21 Mar 2011, Gilles wrote:
> > 
> >> Hi,
> >> 
> >> I am sorry to bother you but after hours of searching google without 
> >> luck I thought I'd ask you what might take you 5 minutes to answer if 
> >> you please would.
> >> 
> >> I have developed a custom hardware which can host one or two cameras and 
> >> I am a little confused (mainly because I can't seem to find up-to-date 
> >> documentation on how to do it) as to:
> > 
> > All (non-commercial) requests should really be discussed on the
> > 
> > Linux Media Mailing List <linux-media@vger.kernel.org>
> > 
> > mailing list. Please, repost your query to the list with my email in CC.
> > 
> > In short, if I understood you right, you are developing new hardware, that 
> > receives data from video sensors and DMAs it into RAM, correct? In general 
> > the soc-camera stack consists of 3 layers:
> > 
> > 1. soc-camera core
> > 2. camera host driver (receive from sensor, DMA to RAM)
> > 3. camera sensor drivers
> > 
> > If you're developing new hardware, you'll have to write new layer 2 driver 
> > for it.
> > 
> > As for stereo vision: since you're going to use the same sensor, you will 
> > either have to put it on a different i2c bus, or wire it to configure a 
> > different i2c address. In either case communicating to it shouldn't be a 
> > problem.
> > 
> > We can further discuss details on the mailing list.
> > 
> > Thanks
> > Guennadi
> > 
> >> - Which files do I need to modify so that soc-camera "knows" where/how 
> >> to access the hardware pins where the camera is connected to.
> >> 
> >> - I'm not sure I understand how the H/V sync works. My camera is 
> >> connected to a parallel interface which is designed to do DMA into 
> >> memory (clocked by the camera pixel clock). Don't the H/V signals need 
> >> to generate an interrupt to reset the DMA addresses? It appears as the 
> >> soc infrastructure does not require that but I don't understand how the 
> >> drivers know that a new frame is available?
> >> 
> >> - Curently, the hardware I designed is designed to handle one camera at 
> >> once but I have been asked if it would be possible to modify the 
> >> hardware to run both cameras at once (which I can easily do). How would 
> >> you recommend implementing stereo-vision? If both cameras are of the 
> >> same kind (same driver), I am also a little confused how the same soc 
> >> driver would know which one of the two hardwares it needs to bind to.
> >> 
> >> If you could just point me to *any* documentation that would explain 
> >> (something up-to-date) how to adapt linux to match my hardware, I would 
> >> GREATLY appreciate it as I am a bit lost.
> >> 
> >> Thank you,
> >> Gilles
> >> .
> >> 
> >> 
> > 
> > ---
> > Guennadi Liakhovetski, Ph.D.
> > Freelance Open-Source Software Developer
> > http://www.open-technology.de/
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
