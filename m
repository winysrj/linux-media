Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:59440 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757271Ab1IASpo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Sep 2011 14:45:44 -0400
Date: Thu, 1 Sep 2011 20:45:38 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
cc: josh.wu@atmel.com, linux-media@vger.kernel.org
Subject: Re: Using atmel-isi for direct output on framebuffer ?
In-Reply-To: <20110901170555.568af6ea@skate>
Message-ID: <Pine.LNX.4.64.1109012041030.6316@axis700.grange>
References: <20110901170555.568af6ea@skate>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Thomas

On Thu, 1 Sep 2011, Thomas Petazzoni wrote:

> Hello Josh,
> 
> I am currently looking at V4L2 and your atmel-isi driver for an AT91
> based platform on which I would like the ISI interface to capture the
> image from a camera and have this image directly output in RGB format
> at a specific location on the screen (so that it can be nicely
> integrated into a Qt application for example).

Isn't this what V4L2_CAP_VIDEO_OVERLAY type drivers are doing? I've never 
dealt with those, but it seems to be exactly what you need. ATM there are 
no soc-camera drivers, implementing this capability, so, looks like 
implementing this in atmel-isi won't be a very boring task for you;-)

Thanks
Guennadi

> 
> At the moment, I grab frames from the V4L2 device to userspace, do the
> YUV -> RGB conversion manually in my application, and then displays the
> converted frame on the framebuffer thanks to normal Qt painting
> mechanisms. This works, but obviously consumes a lot of CPU.
> 
> >From the AT91 datasheet, I understand that the ISI interface is capable
> of doing the YUV -> RGB conversion and is also capable of outputting
> the frame at some location in the framebuffer, but I don't see how to
> use this capability with the Linux V4L2 and framebuffer infrastructures.
> 
> Is this possible ? If so, could you provide some pointers or starting
> points to get me started ? If not, what is missing in the driver ?
> 
> Thanks a lot,
> 
> Thomas
> -- 
> Thomas Petazzoni, Free Electrons
> Kernel, drivers, real-time and embedded Linux
> development, consulting, training and support.
> http://free-electrons.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
