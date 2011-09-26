Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4077 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282Ab1IZKVS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Sep 2011 06:21:18 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 2/2] as3645a: Add driver for LED flash controller
Date: Mon, 26 Sep 2011 12:21:11 +0200
Cc: linux-media@vger.kernel.org,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Nayden Kanchev <nkanchev@mm-sol.com>,
	Tuukka Toivonen <tuukkat76@gmail.com>,
	Antti Koskipaa <antti.koskipaa@gmail.com>,
	Stanimir Varbanov <svarbanov@mm-sol.com>,
	Vimarsh Zutshi <vimarsh.zutshi@gmail.com>,
	"Ivan T. Ivanov" <iivanov@mm-sol.com>,
	Mika Westerberg <ext-mika.1.westerberg@nokia.com>,
	David Cohen <dacohen@gmail.com>
References: <1315583569-22727-1-git-send-email-laurent.pinchart@ideasonboard.com> <1315583569-22727-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1315583569-22727-3-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201109261221.12068.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Here's a quick review (just two small things):

On Friday, September 09, 2011 17:52:49 Laurent Pinchart wrote:
> This patch adds the driver for the as3645a LED flash controller. This
> controller supports a high power led in flash and torch modes and an
> indicator light, sometimes also called privacy light.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Nayden Kanchev <nkanchev@mm-sol.com>
> Signed-off-by: Tuukka Toivonen <tuukkat76@gmail.com>
> Signed-off-by: Antti Koskipaa <antti.koskipaa@gmail.com>
> Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
> Signed-off-by: Vimarsh Zutshi <vimarsh.zutshi@gmail.com>
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> Signed-off-by: Mika Westerberg <ext-mika.1.westerberg@nokia.com>
> Signed-off-by: David Cohen <dacohen@gmail.com>
> ---
>  drivers/media/video/Kconfig   |    7 +
>  drivers/media/video/Makefile  |    1 +
>  drivers/media/video/as3645a.c | 1425 +++++++++++++++++++++++++++++++++++++++++
>  include/linux/as3645a.h       |   36 +
>  include/media/as3645a.h       |   69 ++
>  5 files changed, 1538 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/as3645a.c
>  create mode 100644 include/linux/as3645a.h
>  create mode 100644 include/media/as3645a.h
> 
> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> index c1c4aed..d01c670 100644
> --- a/drivers/media/video/Kconfig
> +++ b/drivers/media/video/Kconfig
> @@ -505,6 +505,13 @@ config VIDEO_ADP1653
>  	  This is a driver for the ADP1653 flash controller. It is used for
>  	  example in Nokia N900.
>  
> +config VIDEO_AS3645A
> +	tristate "AS3645A flash driver support"
> +	depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
> +	---help---
> +	  This is a driver for the AS3645A flash chip. It has build in control
> +	  for Flash, Torch and Indicator LEDs.
> +
>  comment "Video improvement chips"
>  
>  config VIDEO_UPD64031A
> diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
> index a1bfd06..e0b495a 100644
> --- a/drivers/media/video/Makefile
> +++ b/drivers/media/video/Makefile
> @@ -72,6 +72,7 @@ obj-$(CONFIG_VIDEO_SR030PC30)	+= sr030pc30.o
>  obj-$(CONFIG_VIDEO_NOON010PC30)	+= noon010pc30.o
>  obj-$(CONFIG_VIDEO_M5MOLS)	+= m5mols/
>  obj-$(CONFIG_VIDEO_ADP1653)	+= adp1653.o
> +obj-$(CONFIG_VIDEO_AS3645A)	+= as3645a.o
>  
>  obj-$(CONFIG_SOC_CAMERA_IMX074)		+= imx074.o
>  obj-$(CONFIG_SOC_CAMERA_MT9M001)	+= mt9m001.o
> diff --git a/drivers/media/video/as3645a.c b/drivers/media/video/as3645a.c
> new file mode 100644
> index 0000000..6e8adf8
> --- /dev/null
> +++ b/drivers/media/video/as3645a.c
> @@ -0,0 +1,1425 @@
> +/*
> + * drivers/media/video/as3645a.c
> + *
> + * Copyright (C) 2008-2011 Nokia Corporation
> + *
> + * Contact: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
> + * 02110-1301 USA
> + *
> + * NOTES:
> + * - Inductor peak current limit setting fixed to 1.75A
> + * - VREF offset fixed to 0V
> + *
> + * TODO:
> + * - Check hardware FSTROBE control when sensor driver add support for this
> + *
> + */
> +
> +#include <linux/i2c.h>
> +#include <linux/version.h>
> +#include <linux/sysfs.h>
> +#include <linux/as3645a.h>
> +#include <linux/ktime.h>
> +#include <linux/delay.h>
> +#include <linux/timer.h>
> +#include <linux/mutex.h>
> +
> +#include <media/as3645a.h>
> +
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-event.h>
> +
> +#define AS_TIMER_MS_TO_CODE(t)			(((t) - 100) / 50)
> +#define AS_TIMER_CODE_TO_MS(c)			(50 * (c) + 100)
> +
> +/* Register definitions */
> +
> +/* Read-only Design info register: Reset state: xxxx 0001 - for Senna */

What's 'Senna'? I see this at several places in this driver. It's probably
a code name of some sort, but this needs some explanation.

<...cut...>

> +
> +	/* V4L2_CID_FLASH_INDICATOR_INTENSITY */
> +	v4l2_ctrl_new_std(&flash->ctrls, &as3645a_ctrl_ops,
> +			  V4L2_CID_FLASH_INDICATOR_INTENSITY,
> +			  AS3645A_INDICATOR_INTENSITY_MIN,
> +			  AS3645A_INDICATOR_INTENSITY_MAX,
> +			  AS3645A_INDICATOR_INTENSITY_STEP,
> +			  AS3645A_INDICATOR_INTENSITY_MIN);
> +
> +	flash->indicator_current = 0;
> +
> +	/* V4L2_CID_FLASH_FAULT */
> +	ctrl = v4l2_ctrl_new_std(&flash->ctrls, &as3645a_ctrl_ops,
> +				 V4L2_CID_FLASH_FAULT, 0,
> +				 V4L2_FLASH_FAULT_OVER_VOLTAGE |
> +				 V4L2_FLASH_FAULT_TIMEOUT |
> +				 V4L2_FLASH_FAULT_OVER_TEMPERATURE |
> +				 V4L2_FLASH_FAULT_SHORT_CIRCUIT, 0, 0);
> +	if (ctrl != NULL)
> +		ctrl->is_volatile = 1;
> +
> +	/* V4L2_CID_FLASH_READY */
> +	ctrl = v4l2_ctrl_new_std(&flash->ctrls, &as3645a_ctrl_ops,
> +				 V4L2_CID_FLASH_READY, 0, 1, 1, 1);
> +	if (ctrl != NULL)
> +		ctrl->is_volatile = 1;

Note that 'is_volatile' is now replaced by the new V4L2_CTRL_FLAG_VOLATILE
flag for ctrl->flags. You'll need to redo your patch.

Regards,

	Hans
