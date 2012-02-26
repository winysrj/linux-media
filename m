Return-path: <linux-media-owner@vger.kernel.org>
Received: from ftp.meprolight.com ([194.90.149.17]:53895 "EHLO meprolight.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751226Ab2BZNHi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Feb 2012 08:07:38 -0500
From: Alex Gershgorin <alexg@meprolight.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Sun, 26 Feb 2012 15:00:49 +0200
Subject: RE: i.mx35 live video
Message-ID: <4875438356E7CA4A8F2145FCD3E61C0B2C89899289@MEP-EXCH.meprolight.com>
References: <4875438356E7CA4A8F2145FCD3E61C0B2C8966B289@MEP-EXCH.meprolight.com>,<alpine.DEB.2.00.1202261207001.17356@axis700.grange>
In-Reply-To: <alpine.DEB.2.00.1202261207001.17356@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Thanks Guennadi for your quick response ,  

>Hi Alex
 
> Hi Guennadi,
>
> We would like to use I.MX35 processor in new project.
> An important element of the project is to obtain life video from the camera and display it on display.
> For these purposes, we want to use mainline Linux kernel which supports all the necessary drivers for the implementation of this task.
> As I understand that soc_camera is not currently supported userptr method, in which case how I can configure the video pipeline in user space
> to get the live video on display, without the intervention of the processor.

>soc-camera does support USERPTR, also the mx3_camera driver claims to
>support it.

I based on soc-camera.txt document.

The soc-camera subsystem provides a unified API between camera host drivers and
camera sensor drivers. It implements a V4L2 interface to the user, currently
only the mmap method is supported.

In any case, I glad that this supported :-) 

What do you think it is possible to implement video streaming without the intervention of the processor?   

Regards,

Alex Gershgorin 
 
  
 


 


 
