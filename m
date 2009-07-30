Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:45322 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750903AbZG3SXW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jul 2009 14:23:22 -0400
Date: Thu, 30 Jul 2009 20:23:36 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Valentin Longchamp <valentin.longchamp@epfl.ch>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Magnus Damm <magnus.damm@gmail.com>,
	"m-karicheri2@ti.com" <m-karicheri2@ti.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Paulius Zaleckas <paulius.zaleckas@teltonika.lt>,
	Darius Augulis <augulis.darius@gmail.com>
Subject: Re: [PATCH 0/4] soc-camera: cleanup + scaling / cropping API fix
In-Reply-To: <4A71A159.60903@epfl.ch>
Message-ID: <Pine.LNX.4.64.0907302019270.6813@axis700.grange>
References: <Pine.LNX.4.64.0907291640010.4983@axis700.grange> <4A71A159.60903@epfl.ch>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 30 Jul 2009, Valentin Longchamp wrote:

> Hi Guennadi,
> 
> Guennadi Liakhovetski wrote:
> > Hi all
> > 
> > here goes a new iteration of the soc-camera scaling / cropping API
> > compliance fix. In fact, this is only the first _complete_ one, the previous
> > version only converted one platform - i.MX31 and one camera driver -
> > MT9T031. This patch converts all soc-camera drivers. The most difficult one
> > is the SuperH driver, since it is currently the only host driver
> > implementing own scaling and cropping on top of those of sensor drivers. The
> > first three patches in the series are purely cosmetic, unifying device
> > objects, used in dev_dbg, dev_info... functions. These patches extend the
> > patch series uploaded at
> > http://download.open-technology.de/soc-camera/20090701/ with the actual
> > scaling / cropping patch still in
> > http://download.open-technology.de/testing/. The series is still based on
> > the git://git.pengutronix.de/git/imx/linux-2.6.git (now gone) for-rmk
> > branch, but the i.MX31 patches, that my patch-series depends on, are now in
> > the mainline, so, I will be rebasing the stack soon. In the meantime, I'm
> > afraid, it might require some fiddling to test the stack.
> 
> I'd love to give your patches a try. But the fiddling looks very hard for me
> ... patch 0010 does not apply correctly for me, and a 130K patch to do by hand
> is .. looooong.

Ok, a rebased patch set is under 

http://download.open-technology.de/soc-camera/20090730/

now based on 2.6.31-rc4. Notice, all patches are now in the above 
directory, .../testing is empty again.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
