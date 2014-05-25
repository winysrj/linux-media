Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:8931 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbaEYTQP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 May 2014 15:16:15 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N65009049J29370@mailout1.w2.samsung.com> for
 linux-media@vger.kernel.org; Sun, 25 May 2014 15:16:14 -0400 (EDT)
Date: Sun, 25 May 2014 16:16:09 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL 3.16] soc-camera for 3.16: one driver removal,
 a fix and more
Message-id: <20140525161609.1aac1403.m.chehab@samsung.com>
In-reply-to: <Pine.LNX.4.64.1405252004040.7276@axis700.grange>
References: <Pine.LNX.4.64.1405241326250.1624@axis700.grange>
 <20140525115540.79c6367f.m.chehab@samsung.com>
 <Pine.LNX.4.64.1405252004040.7276@axis700.grange>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 25 May 2014 20:05:49 +0200 (CEST)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> escreveu:

> On Sun, 25 May 2014, Mauro Carvalho Chehab wrote:
> 
> > Hi Guennadi,
> > 
> > Em Sat, 24 May 2014 13:31:37 +0200 (CEST)
> > Guennadi Liakhovetski <g.liakhovetski@gmx.de> escreveu:
> > 
> > > Hi Mauro,
> > > 
> > > I was waiting for DT patches for soc-camera, but they're not yet ready. 
> > > So, here go 5 patches, including one driver removal, one error-path fix 
> > > from myself, and a couple more clean up and enhancement patches.
> > > 
> > > BTW, the "git request-pull" command issued a warning:
> > > 
> > > warn: No match for commit 66635afdc4e26f89fd7bc631f452ada84d6e4f3f found at git://linuxtv.org/gliakhovetski/v4l-dvb.git
> > > warn: Are you sure you pushed 'HEAD' there?
> > 
> > This is actually a fatal error... you forgot to do a git pull ;)
> 
> Uhm... never had to do it before... I still couldn't generate a pull 
> request properly, I only managed to do it after I specified an end hash... 
> So, here's a new version:
> 
> The following changes since commit b5c8d48bf8f4273a9fe680bd834f991005c8ab59:
> 
>   Add linux-next specific files for 20140502 (2014-05-02 17:01:07 +1000)
> 
> are available in the git repository at:
> 
>   git://linuxtv.org/gliakhovetski/v4l-dvb.git 66635afdc4e26f89fd7bc631f452ada84d6e4f3f

That doesn't work properly.

Also, it seems that there's something wrong on your tree, as there are
there even patches for linux-next:
http://git.linuxtv.org/cgit.cgi/gliakhovetski/v4l-dvb.git/log/?h=for-3.16-1

You should not send me a pull request based on linux-next, as this will
break compilation.

Instead, if you're needing patches merged via other trees, please
explicitly tell be, and I'll create a separate topic branch, pushing
there from the other maintainer's tree. Of course, in this case, it
should be a branch that the other maintainer will never rebase.

I did something similar to that today, with the OMAP3 patches from
Laurent.

Regards,
Mauro
> 
> for you to fetch changes up to 66635afdc4e26f89fd7bc631f452ada84d6e4f3f:
> 
>   media: mx2_camera: Change Kconfig dependency (2014-05-24 13:08:53 +0200)
> 
> ----------------------------------------------------------------
> Alexander Shiyan (2):
>       media: mx1_camera: Remove driver
>       media: mx2_camera: Change Kconfig dependency
> 
> Ben Dooks (1):
>       rcar_vin: copy flags from pdata
> 
> Guennadi Liakhovetski (1):
>       V4L: soc-camera: explicitly free allocated managed memory on error
> 
> Jean Delvare (1):
>       V4L2: soc_camera: add run-time dependencies to R-Car VIN driver
> 
>  drivers/media/platform/soc_camera/Kconfig      |  16 +-
>  drivers/media/platform/soc_camera/Makefile     |   1 -
>  drivers/media/platform/soc_camera/mx1_camera.c | 866 -------------------------
>  drivers/media/platform/soc_camera/rcar_vin.c   |  12 +-
>  drivers/media/platform/soc_camera/soc_camera.c |  12 +-
>  5 files changed, 16 insertions(+), 891 deletions(-)
>  delete mode 100644 drivers/media/platform/soc_camera/mx1_camera.c
