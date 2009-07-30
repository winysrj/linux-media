Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp0.epfl.ch ([128.178.224.219]:49838 "HELO smtp0.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750776AbZG3NeS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jul 2009 09:34:18 -0400
Message-ID: <4A71A159.60903@epfl.ch>
Date: Thu, 30 Jul 2009 15:34:17 +0200
From: Valentin Longchamp <valentin.longchamp@epfl.ch>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Magnus Damm <magnus.damm@gmail.com>,
	"m-karicheri2@ti.com" <m-karicheri2@ti.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Paulius Zaleckas <paulius.zaleckas@teltonika.lt>,
	Darius Augulis <augulis.darius@gmail.com>
Subject: Re: [PATCH 0/4] soc-camera: cleanup + scaling / cropping API fix
References: <Pine.LNX.4.64.0907291640010.4983@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0907291640010.4983@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Guennadi Liakhovetski wrote:
> Hi all
> 
> here goes a new iteration of the soc-camera scaling / cropping API 
> compliance fix. In fact, this is only the first _complete_ one, the 
> previous version only converted one platform - i.MX31 and one camera 
> driver - MT9T031. This patch converts all soc-camera drivers. The most 
> difficult one is the SuperH driver, since it is currently the only host 
> driver implementing own scaling and cropping on top of those of sensor 
> drivers. The first three patches in the series are purely cosmetic, 
> unifying device objects, used in dev_dbg, dev_info... functions. These 
> patches extend the patch series uploaded at 
> http://download.open-technology.de/soc-camera/20090701/ with the actual 
> scaling / cropping patch still in 
> http://download.open-technology.de/testing/. The series is still based on 
> the git://git.pengutronix.de/git/imx/linux-2.6.git (now gone) for-rmk 
> branch, but the i.MX31 patches, that my patch-series depends on, are now 
> in the mainline, so, I will be rebasing the stack soon. In the meantime, 
> I'm afraid, it might require some fiddling to test the stack.

I'd love to give your patches a try. But the fiddling looks very hard 
for me ... patch 0010 does not apply correctly for me, and a 130K patch 
to do by hand is .. looooong.

If someone could tell me how to get out of that hell, I could give it a 
try, otherwise, I will have to wait for a rebase (I'm using Sascha's 
mxc-master branch, currently based on 2.6.31-rc2):

fatal: sha1 information is lacking or useless 
(drivers/media/video/mt9m001.c).
Repository lacks necessary blobs to fall back on 3-way merge.
Cannot fall back to three-way merge.

Thanks

Val

-- 
Valentin Longchamp, PhD Student, EPFL-STI-LSRO1
valentin.longchamp@epfl.ch, Phone: +41216937827
http://people.epfl.ch/valentin.longchamp
MEA3485, Station 9, CH-1015 Lausanne
