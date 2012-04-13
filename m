Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:53809 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283Ab2DMMqT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Apr 2012 08:46:19 -0400
Date: Fri, 13 Apr 2012 14:46:08 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-mmc@vger.kernel.org
cc: linux-sh@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
	Paul Mundt <lethal@linux-sh.org>,
	Magnus Damm <magnus.damm@gmail.com>
Subject: outstanding ARM patches
In-Reply-To: <Pine.LNX.4.64.1204081328100.29005@axis700.grange>
Message-ID: <Pine.LNX.4.64.1204131439000.16773@axis700.grange>
References: <1328824636-10553-1-git-send-email-g.liakhovetski@gmx.de>
 <1328824636-10553-7-git-send-email-g.liakhovetski@gmx.de>
 <Pine.LNX.4.64.1204081328100.29005@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

Just confirming, that the 3 outstanding ARM patches, that I mentioned in 
recent emails:

http://article.gmane.org/gmane.linux.kernel.mmc/12748
http://article.gmane.org/gmane.linux.ports.sh.devel/13535
http://article.gmane.org/gmane.linux.ports.sh.devel/13975

still apply to the current Linus' tree, though, the former 2 with a fuzz, 
if needed, I can provide a version, that applies cleanly. Compile-tested.

Thanks
Guennadi

On Sun, 8 Apr 2012, Guennadi Liakhovetski wrote:

> On Wed, 14 Mar 2012, Guennadi Liakhovetski wrote:
> 
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > ---
> > 
> > This patch we can push some time after the first one in this series gets 
> > in, no breakage is caused.
> 
> Patch 1/2 from this series is now in the mainline, so, also this patch can 
> be applied now. Not sure whether this qualifies as a fix (in the sense, 
> that the default maximum sizes of 2560x1920, used without this patch are 
> wrong for sh7372). Please, either push for 3.4 or queue for 3.5 
> accordingly.
...
> >  arch/arm/mach-shmobile/board-ap4evb.c   |    2 ++
> >  arch/arm/mach-shmobile/board-mackerel.c |    2 ++
> >  2 files changed, 4 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/arm/mach-shmobile/board-ap4evb.c b/arch/arm/mach-shmobile/board-ap4evb.c
> > index aab0a34..f67aa03 100644
> > --- a/arch/arm/mach-shmobile/board-ap4evb.c
> > +++ b/arch/arm/mach-shmobile/board-ap4evb.c
> > @@ -1009,6 +1009,8 @@ static struct sh_mobile_ceu_companion csi2 = {
> >  
> >  static struct sh_mobile_ceu_info sh_mobile_ceu_info = {
> >  	.flags = SH_CEU_FLAG_USE_8BIT_BUS,
> > +	.max_width = 8188,
> > +	.max_height = 8188,
> >  	.csi2 = &csi2,
> >  };
> >  
> > diff --git a/arch/arm/mach-shmobile/board-mackerel.c b/arch/arm/mach-shmobile/board-mackerel.c
> > index 9b42fbd..f790772 100644
> > --- a/arch/arm/mach-shmobile/board-mackerel.c
> > +++ b/arch/arm/mach-shmobile/board-mackerel.c
> > @@ -1270,6 +1270,8 @@ static void mackerel_camera_del(struct soc_camera_device *icd)
> >  
> >  static struct sh_mobile_ceu_info sh_mobile_ceu_info = {
> >  	.flags = SH_CEU_FLAG_USE_8BIT_BUS,
> > +	.max_width = 8188,
> > +	.max_height = 8188,
> >  };
> >  
> >  static struct resource ceu_resources[] = {
> > -- 
> > 1.7.2.5

On Sun, 8 Apr 2012, Guennadi Liakhovetski wrote:

> Now that MMC patches from this series are in the mainline, also 
> architecture patches can and should be applied. These are patches 5 and 6 
> from this series:
> 
> http://article.gmane.org/gmane.linux.kernel.mmc/12748
> http://article.gmane.org/gmane.linux.ports.sh.devel/13535
> 
> Would be good to have them in 3.4 since they fix modular MMC builds on 
> ag5evm and mackerel.

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
