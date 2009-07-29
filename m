Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:46484 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751494AbZG2PSL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jul 2009 11:18:11 -0400
Date: Wed, 29 Jul 2009 17:18:21 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Magnus Damm <magnus.damm@gmail.com>, m-karicheri2@ti.com,
	Valentin Longchamp <valentin.longchamp@epfl.ch>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Paulius Zaleckas <paulius.zaleckas@teltonika.lt>,
	Darius Augulis <augulis.darius@gmail.com>
Subject: [PATCH 0/4] soc-camera: cleanup + scaling / cropping API fix
Message-ID: <Pine.LNX.4.64.0907291640010.4983@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all

here goes a new iteration of the soc-camera scaling / cropping API 
compliance fix. In fact, this is only the first _complete_ one, the 
previous version only converted one platform - i.MX31 and one camera 
driver - MT9T031. This patch converts all soc-camera drivers. The most 
difficult one is the SuperH driver, since it is currently the only host 
driver implementing own scaling and cropping on top of those of sensor 
drivers. The first three patches in the series are purely cosmetic, 
unifying device objects, used in dev_dbg, dev_info... functions. These 
patches extend the patch series uploaded at 
http://download.open-technology.de/soc-camera/20090701/ with the actual 
scaling / cropping patch still in 
http://download.open-technology.de/testing/. The series is still based on 
the git://git.pengutronix.de/git/imx/linux-2.6.git (now gone) for-rmk 
branch, but the i.MX31 patches, that my patch-series depends on, are now 
in the mainline, so, I will be rebasing the stack soon. In the meantime, 
I'm afraid, it might require some fiddling to test the stack.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
