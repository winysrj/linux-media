Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:45702 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756228Ab0EYOwP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 25 May 2010 10:52:15 -0400
Date: Tue, 25 May 2010 16:52:31 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Baruch Siach <baruch@tkos.co.il>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sascha Hauer <kernel@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 0/3] Driver for the i.MX2x CMOS Sensor Interface
In-Reply-To: <cover.1274706733.git.baruch@tkos.co.il>
Message-ID: <Pine.LNX.4.64.1005241757380.2611@axis700.grange>
References: <cover.1274706733.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 24 May 2010, Baruch Siach wrote:

> This series contains a soc_camera driver for the i.MX25/i.MX27 CSI device, and
> platform code for the i.MX25 and i.MX27 chips. This driver is based on a 
> driver for i.MX27 CSI from Sascha Hauer, that  Alan Carvalho de Assis has 
> posted in linux-media last December[1]. I tested the mx2_camera driver on the 
> i.MX25 PDK. Sascha Hauer has tested a earlier version of this driver on an 
> i.MX27 based board. I included in this version some fixes from Sascha that 
> enable i.MX27 support.
> 
> [1] https://patchwork.kernel.org/patch/67636/
> 
> Changes v1 -> v2
>     Addressed the comments of Guennadi Liakhovetski except from the following:
> 
>     1. The mclk_get_divisor implementation, since I don't know what this code 
>        is good for

AFAIU, it should select a divisor to provide the user-requested frequency. 
But now we know, that it can go.

>     2. mx2_videobuf_release should not set pcdev->active on i.MX27, because 
>        mx27_camera_frame_done needs this pointer

Right, that's what you have locking for. Either the ISR comes first and 
uses the pointer, or you take the spinlock and stop IRQs, while 
deactivating the hardware and clearing the pointer. So that after you 
release the lock you're sure no more interrupts can come.

>     3. In mx27_camera_emma_buf_init I don't know the meaning of those hard 
>        coded magic numbers
> 
>     Applied i.MX27 fixes from Sascha.
> 
> Baruch Siach (3):
>   mx2_camera: Add soc_camera support for i.MX25/i.MX27
>   mx27: add support for the CSI device
>   mx25: add support for the CSI device
> 
>  arch/arm/mach-mx2/clock_imx27.c          |    2 +-
>  arch/arm/mach-mx2/devices.c              |   31 +
>  arch/arm/mach-mx2/devices.h              |    1 +
>  arch/arm/mach-mx25/clock.c               |   14 +-
>  arch/arm/mach-mx25/devices.c             |   22 +
>  arch/arm/mach-mx25/devices.h             |    1 +
>  arch/arm/plat-mxc/include/mach/memory.h  |    4 +-
>  arch/arm/plat-mxc/include/mach/mx25.h    |    2 +
>  arch/arm/plat-mxc/include/mach/mx2_cam.h |   46 +
>  drivers/media/video/Kconfig              |   13 +
>  drivers/media/video/Makefile             |    1 +
>  drivers/media/video/mx2_camera.c         | 1471 ++++++++++++++++++++++++++++++
>  12 files changed, 1603 insertions(+), 5 deletions(-)
>  create mode 100644 arch/arm/plat-mxc/include/mach/mx2_cam.h
>  create mode 100644 drivers/media/video/mx2_camera.c

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
