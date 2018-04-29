Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:11354 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753954AbeD2Tzs (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 29 Apr 2018 15:55:48 -0400
Date: Sun, 29 Apr 2018 22:55:38 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-media@vger.kernel.org, linux-i2c@vger.kernel.org,
        Wolfram Sang <wsa@the-dreams.de>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [RFC PATCH] media: i2c: add SCCB helpers
Message-ID: <20180429195521.yuy3ma6pw34dp3xg@kekkonen.localdomain>
References: <1524759212-10941-1-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1524759212-10941-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mita-san,

On Fri, Apr 27, 2018 at 01:13:32AM +0900, Akinobu Mita wrote:
> (This patch is in prototype stage)
> 
> This adds SCCB helper functions (sccb_read_byte and sccb_write_byte) that
> are intended to be used by some of Omnivision sensor drivers.
> 
> The ov772x driver is going to use these functions in order to make it work
> with most i2c controllers.
> 
> As the ov772x device doesn't support repeated starts, this driver currently
> requires I2C_FUNC_PROTOCOL_MANGLING that is not supported by many i2c
> controller drivers.
> 
> With the sccb_read_byte() that issues two separated requests in order to
> avoid repeated start, the driver doesn't require I2C_FUNC_PROTOCOL_MANGLING.
> 
> Cc: Wolfram Sang <wsa@the-dreams.de>
> Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> ---
>  drivers/media/i2c/Kconfig  |  4 ++++
>  drivers/media/i2c/Makefile |  1 +
>  drivers/media/i2c/sccb.c   | 35 +++++++++++++++++++++++++++++++++++
>  drivers/media/i2c/sccb.h   | 14 ++++++++++++++
>  4 files changed, 54 insertions(+)
>  create mode 100644 drivers/media/i2c/sccb.c
>  create mode 100644 drivers/media/i2c/sccb.h
> 
> diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
> index 541f0d28..19e5601 100644
> --- a/drivers/media/i2c/Kconfig
> +++ b/drivers/media/i2c/Kconfig
> @@ -569,6 +569,9 @@ config VIDEO_THS8200
>  
>  comment "Camera sensor devices"
>  
> +config SCCB
> +	bool

Tristate? This effectively depends on I²C but I²C is tristate...

> +
>  config VIDEO_APTINA_PLL
>  	tristate
>  
> @@ -692,6 +695,7 @@ config VIDEO_OV772X
>  	tristate "OmniVision OV772x sensor support"
>  	depends on I2C && VIDEO_V4L2
>  	depends on MEDIA_CAMERA_SUPPORT
> +	select SCCB
>  	---help---
>  	  This is a Video4Linux2 sensor-level driver for the OmniVision
>  	  OV772x camera.
> diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
> index ea34aee..82fbd78 100644
> --- a/drivers/media/i2c/Makefile
> +++ b/drivers/media/i2c/Makefile
> @@ -62,6 +62,7 @@ obj-$(CONFIG_VIDEO_VP27SMPX) += vp27smpx.o
>  obj-$(CONFIG_VIDEO_SONY_BTF_MPX) += sony-btf-mpx.o
>  obj-$(CONFIG_VIDEO_UPD64031A) += upd64031a.o
>  obj-$(CONFIG_VIDEO_UPD64083) += upd64083.o
> +obj-$(CONFIG_SCCB) += sccb.o
>  obj-$(CONFIG_VIDEO_OV2640) += ov2640.o
>  obj-$(CONFIG_VIDEO_OV2685) += ov2685.o
>  obj-$(CONFIG_VIDEO_OV5640) += ov5640.o
> diff --git a/drivers/media/i2c/sccb.c b/drivers/media/i2c/sccb.c
> new file mode 100644
> index 0000000..80a3fb7
> --- /dev/null
> +++ b/drivers/media/i2c/sccb.c
> @@ -0,0 +1,35 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <linux/i2c.h>
> +
> +int sccb_read_byte(struct i2c_client *client, u8 addr)
> +{
> +	int ret;
> +	u8 val;
> +
> +	/* Issue two separated requests in order to avoid repeated start */
> +
> +	ret = i2c_master_send(client, &addr, 1);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = i2c_master_recv(client, &val, 1);
> +	if (ret < 0)
> +		return ret;
> +
> +	return val;
> +}
> +EXPORT_SYMBOL_GPL(sccb_read_byte);
> +
> +int sccb_write_byte(struct i2c_client *client, u8 addr, u8 data)
> +{
> +	int ret;
> +	unsigned char msgbuf[] = { addr, data };
> +
> +	ret = i2c_master_send(client, msgbuf, 2);
> +	if (ret < 0)
> +		return ret;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(sccb_write_byte);

Please add MODULE_* macros... follows from tristate option.

> diff --git a/drivers/media/i2c/sccb.h b/drivers/media/i2c/sccb.h
> new file mode 100644
> index 0000000..68da0e9
> --- /dev/null
> +++ b/drivers/media/i2c/sccb.h
> @@ -0,0 +1,14 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * SCCB helper functions
> + */
> +
> +#ifndef __SCCB_H__
> +#define __SCCB_H__
> +
> +#include <linux/i2c.h>

struct i2c_client;

is enough; no need to include the whole header here.

> +
> +int sccb_read_byte(struct i2c_client *client, u8 addr);
> +int sccb_write_byte(struct i2c_client *client, u8 addr, u8 data);
> +
> +#endif /* __SCCB_H__ */

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
