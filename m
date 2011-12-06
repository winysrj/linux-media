Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:57180 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932901Ab1LFJXr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Dec 2011 04:23:47 -0500
Date: Tue, 6 Dec 2011 10:23:45 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PULL] soc-camera fixes for 3.2
In-Reply-To: <Pine.LNX.4.64.1112060858340.10715@axis700.grange>
Message-ID: <Pine.LNX.4.64.1112061013020.10715@axis700.grange>
References: <Pine.LNX.4.64.1112060858340.10715@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 6 Dec 2011, Guennadi Liakhovetski wrote:

> Hi Mauro
> 
> Here a couple of fixes for 3.2. You've already applied the mt9t112 patch 
> from Dan, but only to your 3.3 branch, it certainly has to go to 3.2 too.

Sorry, forgot one more fix (same branch updated):

The following changes since commit f2ded9bc4e162cb7c2859c2a4c2d9bd69bf01f5f:

  V4L: omap1_camera: fix missing <linux/module.h> include (2011-12-05 20:46:05 +0100)

are available in the git repository at:
  git://linuxtv.org/gliakhovetski/v4l-dvb.git 3.2-rc4-fixes

Guennadi Liakhovetski (1):
      V4L: mt9m111: fix uninitialised mutex

 drivers/media/video/mt9m111.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

Thanks
Guennadi

> The following changes since commit 8e8da023f5af71662867729db5547dc54786093c:
> 
>   x86: Fix boot failures on older AMD CPU's (2011-12-04 11:57:09 -0800)
> 
> are available in the git repository at:
>   git://linuxtv.org/gliakhovetski/v4l-dvb.git 3.2-rc4-fixes
> 
> Dan Carpenter (1):
>       V4L: mt9t112: use after free in mt9t112_probe()
> 
> Guennadi Liakhovetski (1):
>       V4L: soc-camera: fix compiler warnings on 64-bit platforms
> 
> Janusz Krzysztofik (1):
>       V4L: omap1_camera: fix missing <linux/module.h> include
> 
>  drivers/media/video/mt9t112.c              |    4 ++-
>  drivers/media/video/omap1_camera.c         |    1 +
>  drivers/media/video/ov6650.c               |    2 +-
>  drivers/media/video/sh_mobile_ceu_camera.c |   34 +++++++++++++++++----------
>  drivers/media/video/sh_mobile_csi2.c       |    4 +-
>  drivers/media/video/soc_camera.c           |    3 +-
>  include/media/soc_camera.h                 |    7 +++++-
>  7 files changed, 36 insertions(+), 19 deletions(-)
> 
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
