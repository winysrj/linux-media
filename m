Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51692 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752726Ab2KVTRB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Nov 2012 14:17:01 -0500
Date: Thu, 22 Nov 2012 11:41:05 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL] soc-camera + VEU for 3.8
Message-ID: <20121122114105.1517d582@redhat.com>
In-Reply-To: <Pine.LNX.4.64.1210311258420.9048@axis700.grange>
References: <Pine.LNX.4.64.1210311258420.9048@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 31 Oct 2012 13:01:19 +0100 (CET)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> escreveu:

> Hi Mauro
> 
> Please pull driver updates for 3.8. Apart from usual soc-camera 
> development this pull request also includes a new VEU MEM2MEM driver.
> 
> The following changes since commit 016e804df1632fa99b1d96825df4c0db075ac196:
> 
>   media: sh_vou: fix const cropping related warnings (2012-10-31 11:35:51 +0100)
> 
> are available in the git repository at:
> 
>   git://linuxtv.org/gliakhovetski/v4l-dvb.git for-3.8
> 
> for you to fetch changes up to 223916e1817ce458e947a5f99026ee7d05acaa66:
> 
>   media: add a VEU MEM2MEM format conversion and scaling driver (2012-10-31 12:54:58 +0100)
> 
> ----------------------------------------------------------------
> Anatolij Gustschin (4):
>       V4L: soc_camera: allow reading from video device if supported
>       mt9v022: add v4l2 controls for blanking
>       mt9v022: support required register settings in snapshot mode
>       mt9v022: set y_skip_top field to zero as default
> 
> Frank SchÃ€fer (1):
>       ov2640: add support for V4L2_MBUS_FMT_YUYV8_2X8, V4L2_MBUS_FMT_RGB565_2X8_BE
> 
> Guennadi Liakhovetski (1):
>       media: add a VEU MEM2MEM format conversion and scaling driver
> 
> Shawn Guo (1):
>       media: mx1_camera: mark the driver BROKEN
> 
>  arch/arm/mach-pxa/pcm990-baseboard.c           |    6 +
>  drivers/media/i2c/soc_camera/mt9v022.c         |   88 ++-
>  drivers/media/i2c/soc_camera/ov2640.c          |   49 +-
>  drivers/media/platform/Kconfig                 |    9 +
>  drivers/media/platform/Makefile                |    2 +
>  drivers/media/platform/sh_veu.c                | 1264 ++++++++++++++++++++++++

Applied, thanks!

Please submit a MAINTAINERS entry for this new driver.

Regards,
Mauro
