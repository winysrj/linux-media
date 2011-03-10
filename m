Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.8]:50602 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198Ab1CJPgn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Mar 2011 10:36:43 -0500
Date: Thu, 10 Mar 2011 16:36:36 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: javier Martin <javier.martin@vista-silicon.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: mt9p031 support for Beagleboard.
In-Reply-To: <AANLkTi=8iEa4ZXvh1SqL8XdHuB2YcDAxXAqouJA2JriV@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1103101632260.18816@axis700.grange>
References: <AANLkTi=8iEa4ZXvh1SqL8XdHuB2YcDAxXAqouJA2JriV@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi

On Thu, 10 Mar 2011, javier Martin wrote:

> Hi,
> we are going to receive a Beagleaboard xM board in a couple of days.
> One of the things we would like to test is video capture.
> 
> When it comes to the DM3730 SoC, it seems the support is given through
> these two files:
> http://lxr.linux.no/#linux+v2.6.37.3/drivers/media/video/davinci/vpfe_capture.c
> --> to capture from sensor
> http://lxr.linux.no/#linux+v2.6.37.3/drivers/media/video/davinci/dm644x_ccdc.c
> --> to convert from Bayer RGB to YUV
> 
> On the other hand, the sensor we would like to test is mt9p031 which
> comes with LI-5M03, a module that can be attached to Beagleboard xM
> directly:
> https://www.leopardimaging.com/Beagle_Board_xM_Camera.html
> 
> By a lot of googling I found this version of a driver for mt9p031
> which is developed by Guennadi Liakhovetski. It is located in a 2.6.32
> based branch:

That's a back-port of my patches by a "third party";) Probably, never 
actually tested.

> http://arago-project.org/git/projects/?p=linux-davinci.git;a=blob;f=drivers/media/video/mt9p031.c;h=66b5e54d0368052bf76796aa846e9464e42204bb;hb=HEAD
> 
> The question is, what does this driver lack for not entering into
> mainline? We would be very interested on helping it make it.

I'm waiting for media-controller to be pulled by Mauro (I think, they 
needed some updates by Laurent, not sure about the current state). As soon 
as that's in the mainline, I'll try to find some time to update, clean up 
and submit my beagle-board and mt9p031 patches.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
