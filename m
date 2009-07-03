Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:48413 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758686AbZGCUD1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 3 Jul 2009 16:03:27 -0400
Date: Fri, 3 Jul 2009 22:03:27 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Antonio Ospite <ospite@studenti.unina.it>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Robert Jarzmik <robert.jarzmik@free.fr>, rsc@pengutronix.de
Subject: Re: pxa_camera: Oops in pxa_camera_probe.
In-Reply-To: <20090703161140.845950e8.ospite@studenti.unina.it>
Message-ID: <Pine.LNX.4.64.0907032200420.25247@axis700.grange>
References: <20090701204325.2a277884.ospite@studenti.unina.it>
 <20090703161140.845950e8.ospite@studenti.unina.it>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 3 Jul 2009, Antonio Ospite wrote:

> On Wed, 1 Jul 2009 20:43:25 +0200
> Antonio Ospite <ospite@studenti.unina.it> wrote:
> 
> > Hi,
> > 
> > I get this with pxa-camera in mainline linux (from today).
> > I haven't touched my board code which used to work in 2.6.30
> >
> 
> I think I've tracked down the cause. The board code is triggering a
> bug in pxa_camera. The same should apply to mioa701 as well.
> 
> > Linux video capture interface: v2.00
> > Unable to handle kernel NULL pointer dereference at virtual address 00000060
> > pgd = c0004000
> > [00000060] *pgd=00000000
> > Internal error: Oops: f5 [#1] PREEMPT
> > Modules linked in:
> > CPU: 0    Tainted: G        W   (2.6.31-rc1-ezxdev #1)
> > PC is at dev_driver_string+0x0/0x38
> > LR is at pxa_camera_probe+0x144/0x428
> 
> The offending dev_driver_str() here is the one in the dev_warn() call in
> mclk_get_divisor().
> 
> This is what is happening: in struct pxacamera_platform_data I have:
> 	.mclk_10khz = 5000,
> 
> which makes the > test in mclk_get_divisor() succeed calling dev_warn
> to report that the clock has been limited, but pcdev->soc_host.dev is
> still uninitialized at this time.
> 
> I could lower the value in my platform data and avoid the bug, but it
> would be good to have this fixed ASAP anyway.
> 
> The attached rough patch fixes the problem, but you will surely come
> out with a better one :)

Why should I? Your patch seems correct to me so far, thanks. I'll push it 
for 2.6.31. Please, next time inline your patch as described in 
Documentation/SubmittingPatches.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
