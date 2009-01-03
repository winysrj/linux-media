Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n03E4Cw3017395
	for <video4linux-list@redhat.com>; Sat, 3 Jan 2009 09:04:12 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id n03E3u7R020550
	for <video4linux-list@redhat.com>; Sat, 3 Jan 2009 09:03:56 -0500
Date: Sat, 3 Jan 2009 15:04:03 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <20090103104338.6822c576@pedra.chehab.org>
Message-ID: <Pine.LNX.4.64.0901031415060.3955@axis700.grange>
References: <f17812d70901020716n2e6bb9cas2958ea4df2a19af8@mail.gmail.com>
	<Pine.LNX.4.64.0901021625420.4694@axis700.grange>
	<20090103104338.6822c576@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] pxa-camera: fix redefinition warnings and missing DMA
 definitions
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Sat, 3 Jan 2009, Mauro Carvalho Chehab wrote:

> On Fri, 2 Jan 2009 16:59:36 +0100 (CET)
> Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> 
> > On Fri, 2 Jan 2009, Eric Miao wrote:
> > 
> > > 1. now pxa_camera.c uses ioremap() for register access, pxa_camera.h is
> > >    totally useless. Remove it.
> > > 
> > > 2. <asm/dma.h> does no longer include <mach/dma.h>, include the latter
> > >    file explicitly
> > > 
> > > Signed-off-by: Eric Miao <eric.miao@marvell.com>
> > 
> > Mauro, it looks like the drivers/media/video/pxa_camera.h part of 
> > http://linuxtv.org/hg/~gliakhovetski/v4l-dvb/rev/30773c067724 has been 
> > dropped on its way to 
> > http://git.kernel.org/?p=linux/kernel/git/mchehab/linux-2.6.git;a=commitdiff;h=5ca11fa3e0025864df930d6d97470b87c35919ed
> > 
> > Your hg tree also includes the header hunks, so, it disappeared between 
> > your hg tree and the git tree. Looks like you also lost this hunk
> > 
> >  #include <asm/arch/camera.h>
> >  #endif
> >  
> > -#include "pxa_camera.h"
> > -
> >  #define PXA_CAM_VERSION_CODE KERNEL_VERSION(0, 0, 5)
> >  #define PXA_CAM_DRV_NAME "pxa27x-camera"
> > 
> > so that now registers are defined twice - by including the header and 
> > directly in .c. What shall we do now? I presume, we cannot roll back 
> > git-tree(s) any more, so, we have to somehow synchronise our hg-trees 
> > now. (how much easier this would be in a perfect world without partial 
> > hg-trees...)
> 
> I had to manually solve some merging conflicts when updating the upstream
> driver. Maybe someone else's patch changed something there and we didn't
> backport the patch.

Sorry, which exactly upstream driver you mean? And which changes

> Yet, I always run a script here to check for the
> differences between our tree and Linus one.
> 
> Git annotate points this patch as the responsible for adding this header:
> 
> 013132ca        ( Eric Miao     2008-11-28 09:16:52 +0800       41)#include "pxa_camera.h"
> 
> A today check for differences, pointed the enclosed changes.
> 
> I think that the better procedure is just to backport those upstream changes
> into -hg. Then, you can write a patch fixing the issues, and I'll send it
> upstream.

Mauro, I am afraid, what you have done isn't quite right. I'll try to 
explain again. In a fresh clone of your hg-tree commit 1070 contains a 
"kernel-sync:" tag, because it went in via ARM tree, and adds the

+
+#include "pxa_camera.h"

hunk to pxa_camera.c. Commit 1071 doesn't contain that tag, because I 
pulled it via my tree, and removes that header and the above #include 
line. This is also how we want it to be eventually. So, your hg-tree was 
_correct_, and didn't have to be fixed. Whereas in your git-tree commit 
http://git.kernel.org/?p=linux/kernel/git/mchehab/linux-2.6.git;a=commitdiff;h=5ca11fa3e0025864df930d6d97470b87c35919ed 
is a _corrupted_ version of hg-commit 1071 in your hg-tree - it is missing 
the removal of the header-include. Now instead of removing it in your 
git-tree, you re-added that include again...

Have I understood anything wrong or have I done anything wrong? Now I have 
no idea how we should best fix this.

And btw, the

> @@ -1402,7 +1404,7 @@ static int pxa_camera_probe(struct platf
>  		goto exit;
>  	}
>  
> -	pcdev->clk = clk_get(&pdev->dev, "CAMCLK");
> +	pcdev->clk = clk_get(&pdev->dev, NULL);
>  	if (IS_ERR(pcdev->clk)) {
>  		err = PTR_ERR(pcdev->clk);
>  		goto exit_kfree;
> 

hunk comes from yet another commit...

Can we pleeeeease somehow consider possibilities to move to a complete 
kernel-tree development, or at least allow both. Whereas I personally see 
no good way to have both. I really don't understand why you think, that 
v4l users are not intelligent enough to compile complete kernel trees. 
IMHO it is simpler, than compiling external drivers, but that's subjective 
of course.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
