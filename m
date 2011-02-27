Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.186]:63834 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670Ab1B0W0m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Feb 2011 17:26:42 -0500
Date: Sun, 27 Feb 2011 23:26:39 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Ivan Nazarenko <ivan.nazarenko@gmail.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: MT9P031 camera
In-Reply-To: <201102251141.56933.ivan.nazarenko@gmail.com>
Message-ID: <Pine.LNX.4.64.1102272325590.6510@axis700.grange>
References: <201102251141.56933.ivan.nazarenko@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, 25 Feb 2011, Ivan Nazarenko wrote:

> Dear Dr. Guennadi.
> 
> I have similar set-up as Mr. Valentini - a Beagleboard XM + leopard imaging 
> mt0p031 camera.

Sorry, I forgot about those additional patches, that I've sent to Juliano. 
I've sent them to you separately too.

Thanks
Guennadi

> 
> Could you send me those patches too?
> 
> Regards,
> 
> Ivan
> 
> 
> 
> > On Fri, 18 Feb 2011, Juliano Valentini wrote:
> > 
> > > Dears,
> > > 
> > > I'm trying to apply Guennadi's patch
> > > (http://download.open-technology.de/BeagleBoard_xM-MT9P031/linux-2.6-
> omap3isp-bbxm-mt9p031.gitdiff)
> > > to official 2.6.37.1 Kernel version.
> > 
> > No, this cannot work. That kernel patch requires media-controller and 
> > omap3isp, so, it is based on the omap3isp branch of the development tree 
> > by Laurent Pinchart:
> > 
> > git://linuxtv.org/pinchartl/media.git
> > 
> > But that tree has been rebased since then, so, I wouldn't expect that 
> > patch to apply cleanly, porting it to the current kernel would require a 
> > non-zero development effort.
> > 
> > > I suppose that kernel version is wrong or missing previous patches
> > > (see result at the end).
> > > I have to make it work:  MT9P031 SoC camera module on Beagleboard Xm.
> > > Could somebody help me? Where/how can I get the right kernel version?
> > 
> > I'll send you a tarball of those "old" patches off-list.
> > 
> > Thanks
> > Guennadi
> > 
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
