Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:64648 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab2BZObZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Feb 2012 09:31:25 -0500
Date: Sun, 26 Feb 2012 15:31:23 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Alex Gershgorin <alexg@meprolight.com>
cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: RE: i.mx35 live video
In-Reply-To: <4875438356E7CA4A8F2145FCD3E61C0B2C89899289@MEP-EXCH.meprolight.com>
Message-ID: <Pine.LNX.4.64.1202261454530.17982@axis700.grange>
References: <4875438356E7CA4A8F2145FCD3E61C0B2C8966B289@MEP-EXCH.meprolight.com>,<alpine.DEB.2.00.1202261207001.17356@axis700.grange>
 <4875438356E7CA4A8F2145FCD3E61C0B2C89899289@MEP-EXCH.meprolight.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 26 Feb 2012, Alex Gershgorin wrote:

> 
> Thanks Guennadi for your quick response ,  
> 
> >Hi Alex
>  
> > Hi Guennadi,
> >
> > We would like to use I.MX35 processor in new project.
> > An important element of the project is to obtain life video from the camera and display it on display.
> > For these purposes, we want to use mainline Linux kernel which supports all the necessary drivers for the implementation of this task.
> > As I understand that soc_camera is not currently supported userptr method, in which case how I can configure the video pipeline in user space
> > to get the live video on display, without the intervention of the processor.
> 
> >soc-camera does support USERPTR, also the mx3_camera driver claims to
> >support it.
> 
> I based on soc-camera.txt document.

Yeah, I really have to update it...

> The soc-camera subsystem provides a unified API between camera host drivers and
> camera sensor drivers. It implements a V4L2 interface to the user, currently
> only the mmap method is supported.
> 
> In any case, I glad that this supported :-) 
> 
> What do you think it is possible to implement video streaming without 
> the intervention of the processor?

It might be difficult to completely eliminate the CPU, at the very least 
you need to queue and dequeue buffers to and from the V4L driver. To avoid 
even that, in principle, you could try to use only one buffer, but I don't 
think the current version of the mx3_camera driver would be very happy 
about that. You could take 2 buffers and use panning, then you'd just have 
to send queue and dequeue buffers and pan the display. But in any case, 
you probably will have to process buffers, but your most important 
advantage is, that you won't have to copy data, you only have to move 
pointers around.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
