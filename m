Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:27397 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbaEYOzr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 May 2014 10:55:47 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N6400HH3XGXGP50@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Sun, 25 May 2014 10:55:45 -0400 (EDT)
Date: Sun, 25 May 2014 11:55:40 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL 3.16] soc-camera for 3.16: one driver removal,
 a fix and more
Message-id: <20140525115540.79c6367f.m.chehab@samsung.com>
In-reply-to: <Pine.LNX.4.64.1405241326250.1624@axis700.grange>
References: <Pine.LNX.4.64.1405241326250.1624@axis700.grange>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Em Sat, 24 May 2014 13:31:37 +0200 (CEST)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> escreveu:

> Hi Mauro,
> 
> I was waiting for DT patches for soc-camera, but they're not yet ready. 
> So, here go 5 patches, including one driver removal, one error-path fix 
> from myself, and a couple more clean up and enhancement patches.
> 
> BTW, the "git request-pull" command issued a warning:
> 
> warn: No match for commit 66635afdc4e26f89fd7bc631f452ada84d6e4f3f found at git://linuxtv.org/gliakhovetski/v4l-dvb.git
> warn: Are you sure you pushed 'HEAD' there?

This is actually a fatal error... you forgot to do a git pull ;)

> 
> I hope, the result is still ok...
> 
> The following changes since commit b5c8d48bf8f4273a9fe680bd834f991005c8ab59:
> 
>   Add linux-next specific files for 20140502 (2014-05-02 17:01:07 +1000)
> 
> are available in the git repository at:
> 
>   git://linuxtv.org/gliakhovetski/v4l-dvb.git 

See, the URL above doesn't have a branch. That's because git request-pull
were unable to find a branch upstream with your patches.

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
> 
> Thanks
> Guennadi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
