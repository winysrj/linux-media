Return-path: <mchehab@pedra>
Received: from mail02.prevas.se ([62.95.78.10]:53173 "EHLO mail02.prevas.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751417Ab1CXKy4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2011 06:54:56 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: SV: SV: OMAP3 isp single-shot
Date: Thu, 24 Mar 2011 11:54:54 +0100
Message-ID: <CA7B7D6C54015B459601D68441548157C5A3AF@prevas1.prevas.se>
In-Reply-To: <201103241135.06025.laurent.pinchart@ideasonboard.com>
References: <loom.20110323T141429-496@post.gmane.org> <4D8B00FA.1090008@maxwell.research.nokia.com> <CA7B7D6C54015B459601D68441548157C5A3AE@prevas1.prevas.se> <201103241135.06025.laurent.pinchart@ideasonboard.com>
From: "Daniel Lundborg" <Daniel.Lundborg@prevas.se>
To: "Laurent Pinchart" <laurent.pinchart@ideasonboard.com>
Cc: "Sakari Ailus" <sakari.ailus@maxwell.research.nokia.com>,
	<linux-media@vger.kernel.org>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Laurent,

> Hi Daniel,
> 
> On Thursday 24 March 2011 11:26:01 Daniel Lundborg wrote:
> > > Daniel Lundborg wrote:
> > > >
> > > > I am successfully using the gumstix overo board together with a 
> > > > camera sensor Aptina MT9V034 with the kernel 2.6.35 and patches 
> > > > from http://git.linuxtv.org/pinchartl/media.git (isp6).
> > > 
> > > Which branch did you use?
> > 
> > I am using the media-2.6.35-0006-sensors branch which could be found

> > just a couple of weeks ago. It has the mt9v032 sensor in it. My 
> > mt9v034 driver is based on the mt9v032 code.
> 
> Now that the OMAP3 ISP driver is on its way to mainline, I've
reorganized the repository. You can use the media-2.6.38-0002-sensors
branch for 2.6.38.

Ok. I will test that one.

> ---
> > 
> > This is the output from yavta when I put the sensor in streaming
mode:
> > 
> > root@overo:~/yavta# ./yavta -f SGRBG10 -s 752x480 -n 1 --capture=1
-F
> > /dev/video2
> > 
> > Device /dev/video2 opened: OMAP3 ISP CCDC output (media).
> > Video format set: width: 752 height: 480 buffer size: 721920 Video 
> > format: BA10 (30314142) 752x480
> > 1 buffers requested.
> > length: 721920 offset: 0
> > Buffer 0 mapped at address 0x4014d000.
> > 0 (0) [-] 0 721920 bytes 65877.098848 1300958239.111966 0.001 fps 
> > Captured 1 frames in 0.000062 seconds (16129.032258 fps,
> > 11643870967.741936 B/s).
> > 1 buffers released.
> > 
> > And the output when putting the sensor in snapshot mode:
> > 
> > root@overo:~/yavta# ./yavta -f SGRBG10 -s 752x480 -n 1 --capture=1
-F
> > /dev/video2
> > 
> > Device /dev/video2 opened: OMAP3 ISP CCDC output (media).
> > Video format set: width: 752 height: 480 buffer size: 721920 Video 
> > format: BA10 (30314142) 752x480
> > 1 buffers requested.
> > length: 721920 offset: 0
> > Buffer 0 mapped at address 0x4014d000.
> > 
> > And it freezes. I can stop yavta with CTRL+C.
> 
> Have you tried to trigger the sensor multiple times in a row ?

No. I will test that.

> 
> > 
> > I can see on the oscilloscope that the sensor is sending something 
> > when I trigger it, but no picture is received..
> 
> "something" is a bit vague, can you check the hsync/vsync signals and
make sure they're identical in both modes ?

Ok. Yes this needs more oscilloscope testing. 

> 
> > > As the sensor works in streaming mode, are you sure it outputs the

> > > image of correct size in the single shot mode?
> > 
> > The sensor has the same output in streaming and single shot mode.
> 
> --
> Regards,
> 
> Laurent Pinchart

Thanks,

Daniel Lundborg
daniel.lundborg@prevas.se
