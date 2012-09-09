Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:63989 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab2IIVCs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Sep 2012 17:02:48 -0400
Date: Sun, 9 Sep 2012 23:02:20 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Prashanth Subramanya <sprashanth@aptina.com>
cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	laurent.pinchart@ideasonboard.com, s.nawrocki@samsung.com,
	kyungmin.park@samsung.com, sakari.ailus@maxwell.research.nokia.com,
	scott.jiang.linux@gmail.com
Subject: Re: =?UTF-8?q?=5BPATCH=5D=20drivers=3A=20media=3A=20video=3A=20Add=20support=20for=20Aptina=20ar0130=20sensor?=
In-Reply-To: <1347010226-12546-1-git-send-email-sprashanth@aptina.com>
Message-ID: <Pine.LNX.4.64.1209092249220.11567@axis700.grange>
References: <1347010226-12546-1-git-send-email-sprashanth@aptina.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Prashanth

On Fri, 7 Sep 2012, Prashanth Subramanya wrote:

> This driver adds basic support for Aptina ar0130 1.2M sensor.
> 
> Signed-off-by: Prashanth Subramanya <sprashanth@aptina.com>
> ---
>  drivers/media/video/Kconfig       |    7 +
>  drivers/media/video/Makefile      |    1 +
>  drivers/media/video/ar0130.c      | 1114 +++++++++++++++++++++++++++++++++++++
>  drivers/media/video/ar0130_regs.h |  107 ++++
>  include/media/ar0130.h            |   52 ++
>  include/media/v4l2-chip-ident.h   |    1 +
>  6 files changed, 1282 insertions(+)
>  create mode 100644 drivers/media/video/ar0130.c
>  create mode 100644 drivers/media/video/ar0130_regs.h
>  create mode 100644 include/media/ar0130.h
> 
> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> index 99937c9..54d7063 100644
> --- a/drivers/media/video/Kconfig
> +++ b/drivers/media/video/Kconfig
> @@ -493,6 +493,13 @@ config VIDEO_VS6624
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called vs6624.
>  
> +config VIDEO_AR0130
> +	tristate "Aptina AR0130 support"
> +	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
> +	---help---
> +	This is a Video4Linux2 sensor-level driver for the Aptina
> +	ar0130 1.2 Mpixel camera.
> +
>  config VIDEO_MT9M032
>  	tristate "MT9M032 camera sensor support"
>  	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
> diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
> index d209de0..a208911 100644
> --- a/drivers/media/video/Makefile
> +++ b/drivers/media/video/Makefile
> @@ -70,6 +70,7 @@ obj-$(CONFIG_VIDEO_UPD64083) += upd64083.o
>  obj-$(CONFIG_VIDEO_OV7670) 	+= ov7670.o
>  obj-$(CONFIG_VIDEO_TCM825X) += tcm825x.o
>  obj-$(CONFIG_VIDEO_TVEEPROM) += tveeprom.o
> +obj-$(CONFIG_VIDEO_AR0130) += ar0130.o
>  obj-$(CONFIG_VIDEO_MT9M032) += mt9m032.o
>  obj-$(CONFIG_VIDEO_MT9P031) += mt9p031.o
>  obj-$(CONFIG_VIDEO_MT9T001) += mt9t001.o
> diff --git a/drivers/media/video/ar0130.c b/drivers/media/video/ar0130.c
> new file mode 100644
> index 0000000..d257fe8
> --- /dev/null
> +++ b/drivers/media/video/ar0130.c
> @@ -0,0 +1,1114 @@
> +/*
> + * drivers/media/video/ar0130.c
> + *
> + * Aptina AR0130 sensor driver
> + *
> + * Copyright (C) 2012 Aptina Imaging
> + *
> + * Contributor Prashanth Subramanya <sprashanth@aptina.com>
> + *
> + * Based on MT9P031 driver
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> + *
> + */
> +
> +#include <linux/delay.h>
> +#include <linux/device.h>
> +#include <linux/i2c.h>
> +#include <linux/log2.h>
> +#include <linux/pm.h>
> +#include <linux/slab.h>
> +#include <media/v4l2-subdev.h>
> +#include <linux/videodev2.h>
> +#include <linux/module.h>
> +
> +#include <media/ar0130.h>
> +#include <media/v4l2-chip-ident.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-subdev.h>
> +#include <media/soc_camera.h>

Do you really need the soc_camera.h header? From a quick glance I didn't 
find any uses of the soc-camera API. If I missed them and you really are 
using the API, the driver should probably go under 
drivers/media/i2c/soc_camera/ and be submitted to the mainline via my 
tree. Since you're submitting your patch against an older tree, it is not 
clear, what your intended destination is. Further, since your driver is 
using the pad API, it very much looks like you don't need soc-camera. If 
this is the case, please, remove the header.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
