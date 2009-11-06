Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:42403 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759562AbZKFTpu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Nov 2009 14:45:50 -0500
Date: Fri, 6 Nov 2009 20:46:05 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Antonio Ospite <ospite@studenti.unina.it>
cc: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: Re: pxa_camera + mt9m1111:  image shifted (was: Failed to configure
 for format 50323234)
In-Reply-To: <20091103144536.1c487f79.ospite@studenti.unina.it>
Message-ID: <Pine.LNX.4.64.0911062036590.4389@axis700.grange>
References: <20091002213530.104a5009.ospite@studenti.unina.it>
 <Pine.LNX.4.64.0910030116270.12093@axis700.grange>
 <20091003161328.36419315.ospite@studenti.unina.it>
 <Pine.LNX.4.64.0910040024070.5857@axis700.grange>
 <20091004171924.7579b589.ospite@studenti.unina.it> <4AC992EA.2070905@hni.uni-paderborn.de>
 <20091103144536.1c487f79.ospite@studenti.unina.it>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 3 Nov 2009, Antonio Ospite wrote:

> On Mon, 05 Oct 2009 08:32:10 +0200
> Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de> wrote:
> 
> > Only for your information. Maybe it helps to reproduce the error.
> > 
> > I have the same problem with my own ov9655 driver on a pxa platform 
> > since I update to kernel 2.6.30
> > and add crop support. Every  first open of the camera after system reset 
> > the image looks like yours.
> > If I use the camera the next time without changing the resolution 
> > everything is OK. Only during the
> > first open the resolution of the camera is changed  and function fmt set 
> > in the ov9655 driver is called
> > twice. I use the camera with my one program and it doesn't use crop.
> 
> Thanks Stefan, now I can reproduce the problem.
> 1. Boot the system
> 2. Capture an image with capture-example from v4l2-apps.
> 
> Then I have the shift as in the picture above on the *first* device
> open, if I open the device again and capture a second time, without
> rebooting, the picture is fine.

Ok, tried gstreamer on my pxa board with a mt9v022 camera. Indeed, in the 
beginning the frame is shifted, but then it stabilises on its own. TBH, I 
never paid attention to such temporary self-healing problems. Have you 
tried capturing several frames in a row? is it only the first one that's 
shifted? Then, perhaps, the easiest would be to throw it away on PXA. 
Don't think I saw it on other platforms, at least not consistently. So, 
just have to check a couple of platforms and cameras, and if indeed it's 
only the case on PXA with all cameras, we'll have to throw one frame away.

Robert? Any idea?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
