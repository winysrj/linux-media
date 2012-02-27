Return-path: <linux-media-owner@vger.kernel.org>
Received: from ftp.meprolight.com ([194.90.149.17]:37823 "EHLO meprolight.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750985Ab2B0I6T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Feb 2012 03:58:19 -0500
From: Alex Gershgorin <alexg@meprolight.com>
To: 'Guennadi Liakhovetski' <g.liakhovetski@gmx.de>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Mon, 27 Feb 2012 10:58:10 +0200
Subject: RE: i.mx35 live video
Message-ID: <4875438356E7CA4A8F2145FCD3E61C0B2C8966B28C@MEP-EXCH.meprolight.com>
In-Reply-To: <Pine.LNX.4.64.1202262154550.17982@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



-----Original Message-----
From: Guennadi Liakhovetski [mailto:g.liakhovetski@gmx.de] 
Sent: Sunday, February 26, 2012 10:58 PM
To: Alex Gershgorin
Cc: linux-media@vger.kernel.org
Subject: RE: i.mx35 live video

On Sun, 26 Feb 2012, Alex Gershgorin wrote:

> > Thanks Guennadi for your quick response ,  
> > 
> > >Hi Alex
> >  
> > > Hi Guennadi,
> > >
> > > We would like to use I.MX35 processor in new project.
> > > An important element of the project is to obtain life video from the camera and display it on display.
> > > For these purposes, we want to use mainline Linux kernel which supports all the necessary drivers for the implementation of this task.
> > > As I understand that soc_camera is not currently supported userptr method, in which case how I can configure the video pipeline in user space
> > > to get the live video on display, without the intervention of the processor.
> > 
> > >soc-camera does support USERPTR, also the mx3_camera driver claims to
> > >support it.
> > 
> > I based on soc-camera.txt document.
> 
> > Yeah, I really have to update it...
> 
> > The soc-camera subsystem provides a unified API between camera host drivers and
> > camera sensor drivers. It implements a V4L2 interface to the user, currently
> > only the mmap method is supported.
> > 
> > In any case, I glad that this supported :-) 
> > 
> > What do you think it is possible to implement video streaming without 
> > the intervention of the processor?
> 
> >It might be difficult to completely eliminate the CPU, at the very least 
> >you need to queue and dequeue buffers to and from the V4L driver. To avoid 
> >even that, in principle, you could try to use only one buffer, but I don't 
> >think the current version of the mx3_camera driver would be very happy 
> >about that. You could take 2 buffers and use panning, then you'd just have 
> >to send queue and dequeue buffers and pan the display. But in any case, 
> >you probably will have to process buffers, but your most important 
> >advantage is, that you won't have to copy data, you only have to move 
> >pointers around.
> 
> The method that you describe is exactly what I had in mind.
> It would be more correct to say it is "minimum" CPU intervention and not without CPU intervention. 

> As far I understand, I can implement MMAP method for frame buffer device 
> and pass this pointer directly to mx3_camera driver with use USERPTR 
> method, then send queue and dequeue buffers to mx3_camera driver.
> What is not clear, if it is possible to pass the same pointer of frame 
> buffer in mx3_camera, if the driver is using two buffers?

<Sorry, I really don't know for sure. It should work, but I don't think I 
<tested thid myself nor I remember anybody reporting having tested this 
<mode. So, you can either try to search mailing list archives, or just test 
<it. Begin with a simpler mode - USERPTR with separately allocated buffers 
<and copying them manually to the framebuffer, then try to switch to just 
<one buffer in this same mode, then switch to direct framebuffer memory.

Thanks Gennady this a good road map, in the near future I will be testing it and will get back to you.

Regards,
Alex Gershgorin




 
 
