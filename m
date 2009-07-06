Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f188.google.com ([209.85.210.188]:57540 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572AbZGFXOR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jul 2009 19:14:17 -0400
Received: by yxe26 with SMTP id 26so6116136yxe.33
        for <linux-media@vger.kernel.org>; Mon, 06 Jul 2009 16:14:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1246879822-21348-2-git-send-email-brijohn@gmail.com>
References: <1246879822-21348-1-git-send-email-brijohn@gmail.com>
	 <1246879822-21348-2-git-send-email-brijohn@gmail.com>
Date: Tue, 7 Jul 2009 03:14:19 +0400
Message-ID: <208cbae30907061614h12c86948w2efc95b21ce59737@mail.gmail.com>
Subject: Re: [PATCH 1/1] gspca: Add sn9c20x subdriver
From: Alexey Klimov <klimov.linux@gmail.com>
To: Brian Johnson <brijohn@gmail.com>
Cc: linux-media@vger.kernel.org, hdegoede@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Brian,
please see below

On Mon, Jul 6, 2009 at 3:30 PM, Brian Johnson<brijohn@gmail.com> wrote:
> This adds support for webcams using the sn9c201 and sn9c202 bridges.
>
> Signed-off-by: Brian Johnson <brijohn@gmail.com>
> ---
>  MAINTAINERS                                        |    8 +
>  drivers/media/video/gspca/Kconfig                  |    1 +
>  drivers/media/video/gspca/Makefile                 |    1 +
>  drivers/media/video/gspca/sn9c20x/Kconfig          |   21 +
>  drivers/media/video/gspca/sn9c20x/Makefile         |   14 +
>  drivers/media/video/gspca/sn9c20x/sn9c20x.c        | 2275 ++++++++++++++++++++
>  drivers/media/video/gspca/sn9c20x/sn9c20x.h        |  104 +
>  .../media/video/gspca/sn9c20x/sn9c20x_debugfs.c    |  320 +++
>  include/linux/videodev2.h                          |    1 +
>  9 files changed, 2745 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/gspca/sn9c20x/Kconfig
>  create mode 100644 drivers/media/video/gspca/sn9c20x/Makefile
>  create mode 100644 drivers/media/video/gspca/sn9c20x/sn9c20x.c
>  create mode 100644 drivers/media/video/gspca/sn9c20x/sn9c20x.h
>  create mode 100644 drivers/media/video/gspca/sn9c20x/sn9c20x_debugfs.c
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 381190c..fe9dd34 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2599,6 +2599,14 @@ T:       git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
>  S:     Maintained
>  F:     drivers/media/video/gspca/pac207.c
>
> +GSPCA SN9C20X SUBDRIVER
> +P:     Brian Johnson
> +M:     brijohn@gmail.com
> +L:     linux-media@vger.kernel.org
> +T:     git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
> +S:     Maintained
> +F:     drivers/media/video/gspca/sn9c20x/
> +
>  GSPCA T613 SUBDRIVER
>  P:     Leandro Costantino
>  M:     lcostantino@gmail.com
> diff --git a/drivers/media/video/gspca/Kconfig b/drivers/media/video/gspca/Kconfig
> index 578dc4f..ea40cc9 100644
> --- a/drivers/media/video/gspca/Kconfig
> +++ b/drivers/media/video/gspca/Kconfig
> @@ -17,6 +17,7 @@ menuconfig USB_GSPCA
>
>  if USB_GSPCA && VIDEO_V4L2
>
> +source "drivers/media/video/gspca/sn9c20x/Kconfig"
>  source "drivers/media/video/gspca/m5602/Kconfig"
>  source "drivers/media/video/gspca/stv06xx/Kconfig"
>
> diff --git a/drivers/media/video/gspca/Makefile b/drivers/media/video/gspca/Makefile
> index 8a6643e..ebdb54a 100644
> --- a/drivers/media/video/gspca/Makefile
> +++ b/drivers/media/video/gspca/Makefile
> @@ -52,5 +52,6 @@ gspca_tv8532-objs   := tv8532.o
>  gspca_vc032x-objs   := vc032x.o
>  gspca_zc3xx-objs    := zc3xx.o
>
> +obj-$(CONFIG_USB_GSPCA_SN9C20X) += sn9c20x/
>  obj-$(CONFIG_USB_M5602)   += m5602/
>  obj-$(CONFIG_USB_STV06XX) += stv06xx/
> diff --git a/drivers/media/video/gspca/sn9c20x/Kconfig b/drivers/media/video/gspca/sn9c20x/Kconfig
> new file mode 100644
> index 0000000..0027a35
> --- /dev/null
> +++ b/drivers/media/video/gspca/sn9c20x/Kconfig
> @@ -0,0 +1,21 @@
> +config USB_GSPCA_SN9C20X
> +       tristate "SN9C20X USB Camera Driver"
> +       depends on VIDEO_V4L2 && USB_GSPCA
> +       help
> +         Say Y here if you want support for cameras based on the
> +         sn9c20x chips (SN9C201 and SN9C202).
> +
> +         To compile this driver as a module, choose M here: the
> +         module will be called gspca_sn9c20x.
> +
> +config USB_GSPCA_SN9C20X_DEBUGFS
> +       bool "Enable debugfs support"
> +       depends on USB_GSPCA_SN9C20X
> +       ---help---
> +         Say Y here in order to enable debugfs for sn9c20x webcams
> +
> +config USB_GSPCA_SN9C20X_EVDEV
> +       bool "Enable evdev support"
> +       depends on USB_GSPCA_SN9C20X
> +       ---help---
> +         Say Y here in order to enable evdev support for sn9c20x webcam button.
> diff --git a/drivers/media/video/gspca/sn9c20x/Makefile b/drivers/media/video/gspca/sn9c20x/Makefile
> new file mode 100644
> index 0000000..0578e9d
> --- /dev/null
> +++ b/drivers/media/video/gspca/sn9c20x/Makefile
> @@ -0,0 +1,14 @@
> +obj-$(CONFIG_USB_GSPCA_SN9C20X) += gspca_sn9c20x.o
> +
> +gspca_sn9c20x-objs := sn9c20x.o
> +
> +ifeq ($(CONFIG_USB_GSPCA_SN9C20X_DEBUGFS),y)
> +gspca_sn9c20x-objs += sn9c20x_debugfs.o
> +EXTRA_CFLAGS += -DCONFIG_USB_GSPCA_SN9C20X_DEBUGFS
> +endif
> +
> +ifeq ($(CONFIG_USB_GSPCA_SN9C20X_EVDEV),y)
> +EXTRA_CFLAGS += -DCONFIG_USB_SN9C20X_EVDEV
> +endif
> +
> +EXTRA_CFLAGS += -Idrivers/media/video/gspca
> diff --git a/drivers/media/video/gspca/sn9c20x/sn9c20x.c b/drivers/media/video/gspca/sn9c20x/sn9c20x.c
> new file mode 100644
> index 0000000..081561e
> --- /dev/null
> +++ b/drivers/media/video/gspca/sn9c20x/sn9c20x.c
> @@ -0,0 +1,2275 @@
> +/*
> + *     Sonix sn9c201 sn9c202 library
> + *     Copyright (C) 2008-2009 microdia project <microdia@googlegroups.com>
> + *     Copyright (C) 2009 Brian Johnson <brijohn@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
> + */
> +
> +#include "gspca.h"
> +#include "jpeg.h"
> +#include "sn9c20x.h"
> +
> +#ifdef CONFIG_USB_GSPCA_SN9C20X_EVDEV
> +#include <linux/kthread.h>
> +#include <linux/freezer.h>
> +#include <linux/usb/input.h>
> +#endif
> +
> +MODULE_AUTHOR("Brian Johnson <brijohn@gmail.com>, "
> +               "microdia project <microdia@googlegroups.com>");
> +MODULE_DESCRIPTION("GSPCA/SN9C20X USB Camera Driver");
> +MODULE_LICENSE("GPL");
> +
> +
> +#define MODE_RAW       0x10
> +#define MODE_JPEG      0x20
> +#define MODE_SXGA      0x80
> +
> +#define SENSOR_OV9650  0
> +#define SENSOR_OV9655  1
> +#define SENSOR_SOI968  2
> +#define SENSOR_OV7660  3
> +#define SENSOR_OV7670  4
> +#define SENSOR_MT9VPRB 5
> +#define SENSOR_MT9V011 6
> +#define SENSOR_MT9V111 7
> +#define SENSOR_MT9V112 8
> +#define SENSOR_MT9M001 9
> +#define SENSOR_MT9M111 10
> +#define SENSOR_HV7131R 11
> +
> +static int sd_setbrightness(struct gspca_dev *gspca_dev, s32 val);
> +static int sd_getbrightness(struct gspca_dev *gspca_dev, s32 *val);
> +static int sd_setcontrast(struct gspca_dev *gspca_dev, s32 val);
> +static int sd_getcontrast(struct gspca_dev *gspca_dev, s32 *val);
> +static int sd_setsaturation(struct gspca_dev *gspca_dev, s32 val);
> +static int sd_getsaturation(struct gspca_dev *gspca_dev, s32 *val);
> +static int sd_sethue(struct gspca_dev *gspca_dev, s32 val);
> +static int sd_gethue(struct gspca_dev *gspca_dev, s32 *val);
> +static int sd_setgamma(struct gspca_dev *gspca_dev, s32 val);
> +static int sd_getgamma(struct gspca_dev *gspca_dev, s32 *val);
> +static int sd_setredbalance(struct gspca_dev *gspca_dev, s32 val);
> +static int sd_getredbalance(struct gspca_dev *gspca_dev, s32 *val);
> +static int sd_setbluebalance(struct gspca_dev *gspca_dev, s32 val);
> +static int sd_getbluebalance(struct gspca_dev *gspca_dev, s32 *val);
> +static int sd_setvflip(struct gspca_dev *gspca_dev, s32 val);
> +static int sd_getvflip(struct gspca_dev *gspca_dev, s32 *val);
> +static int sd_sethflip(struct gspca_dev *gspca_dev, s32 val);
> +static int sd_gethflip(struct gspca_dev *gspca_dev, s32 *val);
> +static int sd_setgain(struct gspca_dev *gspca_dev, s32 val);
> +static int sd_getgain(struct gspca_dev *gspca_dev, s32 *val);
> +static int sd_setexposure(struct gspca_dev *gspca_dev, s32 val);
> +static int sd_getexposure(struct gspca_dev *gspca_dev, s32 *val);
> +static int sd_setautoexposure(struct gspca_dev *gspca_dev, s32 val);
> +static int sd_getautoexposure(struct gspca_dev *gspca_dev, s32 *val);
> +
> +static struct ctrl sd_ctrls[] = {
> +       {
> +           {
> +               .id      = V4L2_CID_BRIGHTNESS,
> +               .type    = V4L2_CTRL_TYPE_INTEGER,
> +               .name    = "Brightness",
> +               .minimum = 0,
> +               .maximum = 0xff,
> +               .step    = 1,
> +#define BRIGHTNESS_DEFAULT 0x7f
> +               .default_value = BRIGHTNESS_DEFAULT,
> +           },
> +           .set = sd_setbrightness,
> +           .get = sd_getbrightness,
> +       },
> +       {
> +           {
> +               .id      = V4L2_CID_CONTRAST,
> +               .type    = V4L2_CTRL_TYPE_INTEGER,
> +               .name    = "Contrast",
> +               .minimum = 0,
> +               .maximum = 0xff,
> +               .step    = 1,
> +#define CONTRAST_DEFAULT 0x7f
> +               .default_value = CONTRAST_DEFAULT,
> +           },
> +           .set = sd_setcontrast,
> +           .get = sd_getcontrast,
> +       },
> +       {
> +           {
> +               .id      = V4L2_CID_SATURATION,
> +               .type    = V4L2_CTRL_TYPE_INTEGER,
> +               .name    = "Saturation",
> +               .minimum = 0,
> +               .maximum = 0xff,
> +               .step    = 1,
> +#define SATURATION_DEFAULT 0x7f
> +               .default_value = SATURATION_DEFAULT,
> +           },
> +           .set = sd_setsaturation,
> +           .get = sd_getsaturation,
> +       },
> +       {
> +           {
> +               .id      = V4L2_CID_HUE,
> +               .type    = V4L2_CTRL_TYPE_INTEGER,
> +               .name    = "Hue",
> +               .minimum = -180,
> +               .maximum = 180,
> +               .step    = 1,
> +#define HUE_DEFAULT 0
> +               .default_value = HUE_DEFAULT,
> +           },
> +           .set = sd_sethue,
> +           .get = sd_gethue,
> +       },
> +       {
> +           {
> +               .id      = V4L2_CID_GAMMA,
> +               .type    = V4L2_CTRL_TYPE_INTEGER,
> +               .name    = "Gamma",
> +               .minimum = 0,
> +               .maximum = 0xff,
> +               .step    = 1,
> +#define GAMMA_DEFAULT 0x10
> +               .default_value = GAMMA_DEFAULT,
> +           },
> +           .set = sd_setgamma,
> +           .get = sd_getgamma,
> +       },
> +       {
> +           {
> +               .id      = V4L2_CID_BLUE_BALANCE,
> +               .type    = V4L2_CTRL_TYPE_INTEGER,
> +               .name    = "Blue Balance",
> +               .minimum = 0,
> +               .maximum = 0x7f,
> +               .step    = 1,
> +#define BLUE_DEFAULT 0x28
> +               .default_value = BLUE_DEFAULT,
> +           },
> +           .set = sd_setbluebalance,
> +           .get = sd_getbluebalance,
> +       },
> +       {
> +           {
> +               .id      = V4L2_CID_RED_BALANCE,
> +               .type    = V4L2_CTRL_TYPE_INTEGER,
> +               .name    = "Red Balance",
> +               .minimum = 0,
> +               .maximum = 0x7f,
> +               .step    = 1,
> +#define RED_DEFAULT 0x28
> +               .default_value = RED_DEFAULT,
> +           },
> +           .set = sd_setredbalance,
> +           .get = sd_getredbalance,
> +       },
> +       {
> +           {
> +               .id      = V4L2_CID_HFLIP,
> +               .type    = V4L2_CTRL_TYPE_BOOLEAN,
> +               .name    = "Horizontal Flip",
> +               .minimum = 0,
> +               .maximum = 1,
> +               .step    = 1,
> +#define HFLIP_DEFAULT 0
> +               .default_value = HFLIP_DEFAULT,
> +           },
> +           .set = sd_sethflip,
> +           .get = sd_gethflip,
> +       },
> +       {
> +           {
> +               .id      = V4L2_CID_VFLIP,
> +               .type    = V4L2_CTRL_TYPE_BOOLEAN,
> +               .name    = "Vertical Flip",
> +               .minimum = 0,
> +               .maximum = 1,
> +               .step    = 1,
> +#define VFLIP_DEFAULT 0
> +               .default_value = VFLIP_DEFAULT,
> +           },
> +           .set = sd_setvflip,
> +           .get = sd_getvflip,
> +       },
> +       {
> +           {
> +               .id      = V4L2_CID_EXPOSURE,
> +               .type    = V4L2_CTRL_TYPE_INTEGER,
> +               .name    = "Exposure",
> +               .minimum = 0,
> +               .maximum = 0x1780,
> +               .step    = 1,
> +#define EXPOSURE_DEFAULT 0x33
> +               .default_value = EXPOSURE_DEFAULT,
> +           },
> +           .set = sd_setexposure,
> +           .get = sd_getexposure,
> +       },
> +       {
> +           {
> +               .id      = V4L2_CID_GAIN,
> +               .type    = V4L2_CTRL_TYPE_INTEGER,
> +               .name    = "Gain",
> +               .minimum = 0,
> +               .maximum = 28,
> +               .step    = 1,
> +#define GAIN_DEFAULT 0x00
> +               .default_value = GAIN_DEFAULT,
> +           },
> +           .set = sd_setgain,
> +           .get = sd_getgain,
> +       },
> +       {
> +           {
> +               .id      = V4L2_CID_AUTOGAIN,
> +               .type    = V4L2_CTRL_TYPE_BOOLEAN,
> +               .name    = "Auto Exposure",
> +               .minimum = 0,
> +               .maximum = 1,
> +               .step    = 1,
> +#define AUTO_EXPOSURE_DEFAULT 1
> +               .default_value = AUTO_EXPOSURE_DEFAULT,
> +           },
> +           .set = sd_setautoexposure,
> +           .get = sd_getautoexposure,
> +       },
> +};
> +
> +static const struct v4l2_pix_format vga_mode[] = {
> +       {160, 120, V4L2_PIX_FMT_JPEG, V4L2_FIELD_NONE,
> +               .bytesperline = 240,
> +               .sizeimage = 240 * 120,
> +               .colorspace = V4L2_COLORSPACE_JPEG,
> +               .priv = 0 | MODE_JPEG},
> +       {160, 120, V4L2_PIX_FMT_SBGGR8, V4L2_FIELD_NONE,
> +               .bytesperline = 160,
> +               .sizeimage = 160 * 120,
> +               .colorspace = V4L2_COLORSPACE_SRGB,
> +               .priv = 0 | MODE_RAW},
> +       {160, 120, V4L2_PIX_FMT_SN9C20X_I420, V4L2_FIELD_NONE,
> +               .bytesperline = 240,
> +               .sizeimage = 240 * 120,
> +               .colorspace = V4L2_COLORSPACE_SRGB,
> +               .priv = 0},
> +       {320, 240, V4L2_PIX_FMT_JPEG, V4L2_FIELD_NONE,
> +               .bytesperline = 480,
> +               .sizeimage = 480 * 240 ,
> +               .colorspace = V4L2_COLORSPACE_JPEG,
> +               .priv = 1 | MODE_JPEG},
> +       {320, 240, V4L2_PIX_FMT_SBGGR8, V4L2_FIELD_NONE,
> +               .bytesperline = 320,
> +               .sizeimage = 320 * 240 ,
> +               .colorspace = V4L2_COLORSPACE_SRGB,
> +               .priv = 1 | MODE_RAW},
> +       {320, 240, V4L2_PIX_FMT_SN9C20X_I420, V4L2_FIELD_NONE,
> +               .bytesperline = 480,
> +               .sizeimage = 480 * 240 ,
> +               .colorspace = V4L2_COLORSPACE_SRGB,
> +               .priv = 1},
> +       {640, 480, V4L2_PIX_FMT_JPEG, V4L2_FIELD_NONE,
> +               .bytesperline = 960,
> +               .sizeimage = 960 * 480,
> +               .colorspace = V4L2_COLORSPACE_JPEG,
> +               .priv = 2 | MODE_JPEG},
> +       {640, 480, V4L2_PIX_FMT_SBGGR8, V4L2_FIELD_NONE,
> +               .bytesperline = 640,
> +               .sizeimage = 640 * 480,
> +               .colorspace = V4L2_COLORSPACE_SRGB,
> +               .priv = 2 | MODE_RAW},
> +       {640, 480, V4L2_PIX_FMT_SN9C20X_I420, V4L2_FIELD_NONE,
> +               .bytesperline = 960,
> +               .sizeimage = 960 * 480,
> +               .colorspace = V4L2_COLORSPACE_SRGB,
> +               .priv = 2},
> +};
> +
> +static const struct v4l2_pix_format sxga_mode[] = {
> +       {160, 120, V4L2_PIX_FMT_JPEG, V4L2_FIELD_NONE,
> +               .bytesperline = 240,
> +               .sizeimage = 240 * 120,
> +               .colorspace = V4L2_COLORSPACE_JPEG,
> +               .priv = 0 | MODE_JPEG},
> +       {160, 120, V4L2_PIX_FMT_SBGGR8, V4L2_FIELD_NONE,
> +               .bytesperline = 160,
> +               .sizeimage = 160 * 120,
> +               .colorspace = V4L2_COLORSPACE_SRGB,
> +               .priv = 0 | MODE_RAW},
> +       {160, 120, V4L2_PIX_FMT_SN9C20X_I420, V4L2_FIELD_NONE,
> +               .bytesperline = 240,
> +               .sizeimage = 240 * 120,
> +               .colorspace = V4L2_COLORSPACE_SRGB,
> +               .priv = 0},
> +       {320, 240, V4L2_PIX_FMT_JPEG, V4L2_FIELD_NONE,
> +               .bytesperline = 480,
> +               .sizeimage = 480 * 240 ,
> +               .colorspace = V4L2_COLORSPACE_JPEG,
> +               .priv = 1 | MODE_JPEG},
> +       {320, 240, V4L2_PIX_FMT_SBGGR8, V4L2_FIELD_NONE,
> +               .bytesperline = 320,
> +               .sizeimage = 320 * 240 ,
> +               .colorspace = V4L2_COLORSPACE_SRGB,
> +               .priv = 1 | MODE_RAW},
> +       {320, 240, V4L2_PIX_FMT_SN9C20X_I420, V4L2_FIELD_NONE,
> +               .bytesperline = 480,
> +               .sizeimage = 480 * 240 ,
> +               .colorspace = V4L2_COLORSPACE_SRGB,
> +               .priv = 1},
> +       {640, 480, V4L2_PIX_FMT_JPEG, V4L2_FIELD_NONE,
> +               .bytesperline = 960,
> +               .sizeimage = 960 * 480,
> +               .colorspace = V4L2_COLORSPACE_JPEG,
> +               .priv = 2 | MODE_JPEG},
> +       {640, 480, V4L2_PIX_FMT_SBGGR8, V4L2_FIELD_NONE,
> +               .bytesperline = 640,
> +               .sizeimage = 640 * 480,
> +               .colorspace = V4L2_COLORSPACE_SRGB,
> +               .priv = 2 | MODE_RAW},
> +       {640, 480, V4L2_PIX_FMT_SN9C20X_I420, V4L2_FIELD_NONE,
> +               .bytesperline = 960,
> +               .sizeimage = 960 * 480,
> +               .colorspace = V4L2_COLORSPACE_SRGB,
> +               .priv = 2},
> +       {1280, 1024, V4L2_PIX_FMT_SBGGR8, V4L2_FIELD_NONE,
> +               .bytesperline = 1280,
> +               .sizeimage = (1280 * 1024) + 64,
> +               .colorspace = V4L2_COLORSPACE_SRGB,
> +               .priv = 3 | MODE_RAW | MODE_SXGA},
> +};
> +
> +static const int hsv_red_x[] = {
> +       41,  44,  46,  48,  50,  52,  54,  56,
> +       58,  60,  62,  64,  66,  68,  70,  72,
> +       74,  76,  78,  80,  81,  83,  85,  87,
> +       88,  90,  92,  93,  95,  97,  98, 100,
> +       101, 102, 104, 105, 107, 108, 109, 110,
> +       112, 113, 114, 115, 116, 117, 118, 119,
> +       120, 121, 122, 123, 123, 124, 125, 125,
> +       126, 127, 127, 128, 128, 129, 129, 129,
> +       130, 130, 130, 130, 131, 131, 131, 131,
> +       131, 131, 131, 131, 130, 130, 130, 130,
> +       129, 129, 129, 128, 128, 127, 127, 126,
> +       125, 125, 124, 123, 122, 122, 121, 120,
> +       119, 118, 117, 116, 115, 114, 112, 111,
> +       110, 109, 107, 106, 105, 103, 102, 101,
> +       99,  98,  96,  94,  93,  91,  90,  88,
> +       86,  84,  83,  81,  79,  77,  75,  74,
> +       72,  70,  68,  66,  64,  62,  60,  58,
> +       56,  54,  52,  49,  47,  45,  43,  41,
> +       39,  36,  34,  32,  30,  28,  25,  23,
> +       21,  19,  16,  14,  12,   9,   7,   5,
> +       3,   0,  -1,  -3,  -6,  -8, -10, -12,
> +       -15, -17, -19, -22, -24, -26, -28, -30,
> +       -33, -35, -37, -39, -41, -44, -46, -48,
> +       -50, -52, -54, -56, -58, -60, -62, -64,
> +       -66, -68, -70, -72, -74, -76, -78, -80,
> +       -81, -83, -85, -87, -88, -90, -92, -93,
> +       -95, -97, -98, -100, -101, -102, -104, -105,
> +       -107, -108, -109, -110, -112, -113, -114, -115,
> +       -116, -117, -118, -119, -120, -121, -122, -123,
> +       -123, -124, -125, -125, -126, -127, -127, -128,
> +       -128, -128, -128, -128, -128, -128, -128, -128,
> +       -128, -128, -128, -128, -128, -128, -128, -128,
> +       -128, -128, -128, -128, -128, -128, -128, -128,
> +       -128, -127, -127, -126, -125, -125, -124, -123,
> +       -122, -122, -121, -120, -119, -118, -117, -116,
> +       -115, -114, -112, -111, -110, -109, -107, -106,
> +       -105, -103, -102, -101, -99, -98, -96, -94,
> +       -93, -91, -90, -88, -86, -84, -83, -81,
> +       -79, -77, -75, -74, -72, -70, -68, -66,
> +       -64, -62, -60, -58, -56, -54, -52, -49,
> +       -47, -45, -43, -41, -39, -36, -34, -32,
> +       -30, -28, -25, -23, -21, -19, -16, -14,
> +       -12,  -9,  -7,  -5,  -3,   0,   1,   3,
> +       6,   8,  10,  12,  15,  17,  19,  22,
> +       24,  26,  28,  30,  33,  35,  37,  39, 41
> +};
> +
> +static const int hsv_red_y[] = {
> +       82,  80,  78,  76,  74,  73,  71,  69,
> +       67,  65,  63,  61,  58,  56,  54,  52,
> +       50,  48,  46,  44,  41,  39,  37,  35,
> +       32,  30,  28,  26,  23,  21,  19,  16,
> +       14,  12,  10,   7,   5,   3,   0,  -1,
> +       -3,  -6,  -8, -10, -13, -15, -17, -19,
> +       -22, -24, -26, -29, -31, -33, -35, -38,
> +       -40, -42, -44, -46, -48, -51, -53, -55,
> +       -57, -59, -61, -63, -65, -67, -69, -71,
> +       -73, -75, -77, -79, -81, -82, -84, -86,
> +       -88, -89, -91, -93, -94, -96, -98, -99,
> +       -101, -102, -104, -105, -106, -108, -109, -110,
> +       -112, -113, -114, -115, -116, -117, -119, -120,
> +       -120, -121, -122, -123, -124, -125, -126, -126,
> +       -127, -128, -128, -128, -128, -128, -128, -128,
> +       -128, -128, -128, -128, -128, -128, -128, -128,
> +       -128, -128, -128, -128, -128, -128, -128, -128,
> +       -128, -128, -128, -128, -128, -128, -128, -128,
> +       -127, -127, -126, -125, -125, -124, -123, -122,
> +       -121, -120, -119, -118, -117, -116, -115, -114,
> +       -113, -111, -110, -109, -107, -106, -105, -103,
> +       -102, -100, -99, -97, -96, -94, -92, -91,
> +       -89, -87, -85, -84, -82, -80, -78, -76,
> +       -74, -73, -71, -69, -67, -65, -63, -61,
> +       -58, -56, -54, -52, -50, -48, -46, -44,
> +       -41, -39, -37, -35, -32, -30, -28, -26,
> +       -23, -21, -19, -16, -14, -12, -10,  -7,
> +       -5,  -3,   0,   1,   3,   6,   8,  10,
> +       13,  15,  17,  19,  22,  24,  26,  29,
> +       31,  33,  35,  38,  40,  42,  44,  46,
> +       48,  51,  53,  55,  57,  59,  61,  63,
> +       65,  67,  69,  71,  73,  75,  77,  79,
> +       81,  82,  84,  86,  88,  89,  91,  93,
> +       94,  96,  98,  99, 101, 102, 104, 105,
> +       106, 108, 109, 110, 112, 113, 114, 115,
> +       116, 117, 119, 120, 120, 121, 122, 123,
> +       124, 125, 126, 126, 127, 128, 128, 129,
> +       129, 130, 130, 131, 131, 131, 131, 132,
> +       132, 132, 132, 132, 132, 132, 132, 132,
> +       132, 132, 132, 131, 131, 131, 130, 130,
> +       130, 129, 129, 128, 127, 127, 126, 125,
> +       125, 124, 123, 122, 121, 120, 119, 118,
> +       117, 116, 115, 114, 113, 111, 110, 109,
> +       107, 106, 105, 103, 102, 100,  99,  97,
> +       96, 94, 92, 91, 89, 87, 85, 84, 82
> +};
> +
> +static const int hsv_green_x[] = {
> +       -124, -124, -125, -125, -125, -125, -125, -125,
> +       -125, -126, -126, -125, -125, -125, -125, -125,
> +       -125, -124, -124, -124, -123, -123, -122, -122,
> +       -121, -121, -120, -120, -119, -118, -117, -117,
> +       -116, -115, -114, -113, -112, -111, -110, -109,
> +       -108, -107, -105, -104, -103, -102, -100, -99,
> +       -98, -96, -95, -93, -92, -91, -89, -87,
> +       -86, -84, -83, -81, -79, -77, -76, -74,
> +       -72, -70, -69, -67, -65, -63, -61, -59,
> +       -57, -55, -53, -51, -49, -47, -45, -43,
> +       -41, -39, -37, -35, -33, -30, -28, -26,
> +       -24, -22, -20, -18, -15, -13, -11,  -9,
> +       -7,  -4,  -2,   0,   1,   3,   6,   8,
> +       10,  12,  14,  17,  19,  21,  23,  25,
> +       27,  29,  32,  34,  36,  38,  40,  42,
> +       44,  46,  48,  50,  52,  54,  56,  58,
> +       60,  62,  64,  66,  68,  70,  71,  73,
> +       75,  77,  78,  80,  82,  83,  85,  87,
> +       88,  90,  91,  93,  94,  96,  97,  98,
> +       100, 101, 102, 104, 105, 106, 107, 108,
> +       109, 111, 112, 113, 113, 114, 115, 116,
> +       117, 118, 118, 119, 120, 120, 121, 122,
> +       122, 123, 123, 124, 124, 124, 125, 125,
> +       125, 125, 125, 125, 125, 126, 126, 125,
> +       125, 125, 125, 125, 125, 124, 124, 124,
> +       123, 123, 122, 122, 121, 121, 120, 120,
> +       119, 118, 117, 117, 116, 115, 114, 113,
> +       112, 111, 110, 109, 108, 107, 105, 104,
> +       103, 102, 100,  99,  98,  96,  95,  93,
> +       92,  91,  89,  87,  86,  84,  83,  81,
> +       79,  77,  76,  74,  72,  70,  69,  67,
> +       65,  63,  61,  59,  57,  55,  53,  51,
> +       49,  47,  45,  43,  41,  39,  37,  35,
> +       33,  30,  28,  26,  24,  22,  20,  18,
> +       15,  13,  11,   9,   7,   4,   2,   0,
> +       -1,  -3,  -6,  -8, -10, -12, -14, -17,
> +       -19, -21, -23, -25, -27, -29, -32, -34,
> +       -36, -38, -40, -42, -44, -46, -48, -50,
> +       -52, -54, -56, -58, -60, -62, -64, -66,
> +       -68, -70, -71, -73, -75, -77, -78, -80,
> +       -82, -83, -85, -87, -88, -90, -91, -93,
> +       -94, -96, -97, -98, -100, -101, -102, -104,
> +       -105, -106, -107, -108, -109, -111, -112, -113,
> +       -113, -114, -115, -116, -117, -118, -118, -119,
> +       -120, -120, -121, -122, -122, -123, -123, -124, -124
> +};
> +
> +static const int hsv_green_y[] = {
> +       -100, -99, -98, -97, -95, -94, -93, -91,
> +       -90, -89, -87, -86, -84, -83, -81, -80,
> +       -78, -76, -75, -73, -71, -70, -68, -66,
> +       -64, -63, -61, -59, -57, -55, -53, -51,
> +       -49, -48, -46, -44, -42, -40, -38, -36,
> +       -34, -32, -30, -27, -25, -23, -21, -19,
> +       -17, -15, -13, -11,  -9,  -7,  -4,  -2,
> +       0,   1,   3,   5,   7,   9,  11,  14,
> +       16,  18,  20,  22,  24,  26,  28,  30,
> +       32,  34,  36,  38,  40,  42,  44,  46,
> +       48,  50,  52,  54,  56,  58,  59,  61,
> +       63,  65,  67,  68,  70,  72,  74,  75,
> +       77,  78,  80,  82,  83,  85,  86,  88,
> +       89,  90,  92,  93,  95,  96,  97,  98,
> +       100, 101, 102, 103, 104, 105, 106, 107,
> +       108, 109, 110, 111, 112, 112, 113, 114,
> +       115, 115, 116, 116, 117, 117, 118, 118,
> +       119, 119, 119, 120, 120, 120, 120, 120,
> +       121, 121, 121, 121, 121, 121, 120, 120,
> +       120, 120, 120, 119, 119, 119, 118, 118,
> +       117, 117, 116, 116, 115, 114, 114, 113,
> +       112, 111, 111, 110, 109, 108, 107, 106,
> +       105, 104, 103, 102, 100,  99,  98,  97,
> +       95,  94,  93,  91,  90,  89,  87,  86,
> +       84,  83,  81,  80,  78,  76,  75,  73,
> +       71,  70,  68,  66,  64,  63,  61,  59,
> +       57,  55,  53,  51,  49,  48,  46,  44,
> +       42,  40,  38,  36,  34,  32,  30,  27,
> +       25,  23,  21,  19,  17,  15,  13,  11,
> +       9,   7,   4,   2,   0,  -1,  -3,  -5,
> +       -7,  -9, -11, -14, -16, -18, -20, -22,
> +       -24, -26, -28, -30, -32, -34, -36, -38,
> +       -40, -42, -44, -46, -48, -50, -52, -54,
> +       -56, -58, -59, -61, -63, -65, -67, -68,
> +       -70, -72, -74, -75, -77, -78, -80, -82,
> +       -83, -85, -86, -88, -89, -90, -92, -93,
> +       -95, -96, -97, -98, -100, -101, -102, -103,
> +       -104, -105, -106, -107, -108, -109, -110, -111,
> +       -112, -112, -113, -114, -115, -115, -116, -116,
> +       -117, -117, -118, -118, -119, -119, -119, -120,
> +       -120, -120, -120, -120, -121, -121, -121, -121,
> +       -121, -121, -120, -120, -120, -120, -120, -119,
> +       -119, -119, -118, -118, -117, -117, -116, -116,
> +       -115, -114, -114, -113, -112, -111, -111, -110,
> +       -109, -108, -107, -106, -105, -104, -103, -102, -100
> +};
> +
> +static const int hsv_blue_x[] = {
> +       112, 113, 114, 114, 115, 116, 117, 117,
> +       118, 118, 119, 119, 120, 120, 120, 121,
> +       121, 121, 122, 122, 122, 122, 122, 122,
> +       122, 122, 122, 122, 122, 122, 121, 121,
> +       121, 120, 120, 120, 119, 119, 118, 118,
> +       117, 116, 116, 115, 114, 113, 113, 112,
> +       111, 110, 109, 108, 107, 106, 105, 104,
> +       103, 102, 100,  99,  98,  97,  95,  94,
> +       93,  91,  90,  88,  87,  85,  84,  82,
> +       80,  79,  77,  76,  74,  72,  70,  69,
> +       67,  65,  63,  61,  60,  58,  56,  54,
> +       52,  50,  48,  46,  44,  42,  40,  38,
> +       36,  34,  32,  30,  28,  26,  24,  22,
> +       19,  17,  15,  13,  11,   9,   7,   5,
> +       2,   0,  -1,  -3,  -5,  -7,  -9, -12,
> +       -14, -16, -18, -20, -22, -24, -26, -28,
> +       -31, -33, -35, -37, -39, -41, -43, -45,
> +       -47, -49, -51, -53, -54, -56, -58, -60,
> +       -62, -64, -66, -67, -69, -71, -73, -74,
> +       -76, -78, -79, -81, -83, -84, -86, -87,
> +       -89, -90, -92, -93, -94, -96, -97, -98,
> +       -99, -101, -102, -103, -104, -105, -106, -107,
> +       -108, -109, -110, -111, -112, -113, -114, -114,
> +       -115, -116, -117, -117, -118, -118, -119, -119,
> +       -120, -120, -120, -121, -121, -121, -122, -122,
> +       -122, -122, -122, -122, -122, -122, -122, -122,
> +       -122, -122, -121, -121, -121, -120, -120, -120,
> +       -119, -119, -118, -118, -117, -116, -116, -115,
> +       -114, -113, -113, -112, -111, -110, -109, -108,
> +       -107, -106, -105, -104, -103, -102, -100, -99,
> +       -98, -97, -95, -94, -93, -91, -90, -88,
> +       -87, -85, -84, -82, -80, -79, -77, -76,
> +       -74, -72, -70, -69, -67, -65, -63, -61,
> +       -60, -58, -56, -54, -52, -50, -48, -46,
> +       -44, -42, -40, -38, -36, -34, -32, -30,
> +       -28, -26, -24, -22, -19, -17, -15, -13,
> +       -11,  -9,  -7,  -5,  -2,   0,   1,   3,
> +       5,   7,   9,  12,  14,  16,  18,  20,
> +       22,  24,  26,  28,  31,  33,  35,  37,
> +       39,  41,  43,  45,  47,  49,  51,  53,
> +       54,  56,  58,  60,  62,  64,  66,  67,
> +       69,  71,  73,  74,  76,  78,  79,  81,
> +       83,  84,  86,  87,  89,  90,  92,  93,
> +       94,  96,  97,  98,  99, 101, 102, 103,
> +       104, 105, 106, 107, 108, 109, 110, 111, 112
> +};
> +
> +static const int hsv_blue_y[] = {
> +       -11, -13, -15, -17, -19, -21, -23, -25,
> +       -27, -29, -31, -33, -35, -37, -39, -41,
> +       -43, -45, -46, -48, -50, -52, -54, -55,
> +       -57, -59, -61, -62, -64, -66, -67, -69,
> +       -71, -72, -74, -75, -77, -78, -80, -81,
> +       -83, -84, -86, -87, -88, -90, -91, -92,
> +       -93, -95, -96, -97, -98, -99, -100, -101,
> +       -102, -103, -104, -105, -106, -106, -107, -108,
> +       -109, -109, -110, -111, -111, -112, -112, -113,
> +       -113, -114, -114, -114, -115, -115, -115, -115,
> +       -116, -116, -116, -116, -116, -116, -116, -116,
> +       -116, -115, -115, -115, -115, -114, -114, -114,
> +       -113, -113, -112, -112, -111, -111, -110, -110,
> +       -109, -108, -108, -107, -106, -105, -104, -103,
> +       -102, -101, -100, -99, -98, -97, -96, -95,
> +       -94, -93, -91, -90, -89, -88, -86, -85,
> +       -84, -82, -81, -79, -78, -76, -75, -73,
> +       -71, -70, -68, -67, -65, -63, -62, -60,
> +       -58, -56, -55, -53, -51, -49, -47, -45,
> +       -44, -42, -40, -38, -36, -34, -32, -30,
> +       -28, -26, -24, -22, -20, -18, -16, -14,
> +       -12, -10,  -8,  -6,  -4,  -2,   0,   1,
> +       3,   5,   7,   9,  11,  13,  15,  17,
> +       19,  21,  23,  25,  27,  29,  31,  33,
> +       35,  37,  39,  41,  43,  45,  46,  48,
> +       50,  52,  54,  55,  57,  59,  61,  62,
> +       64,  66,  67,  69,  71,  72,  74,  75,
> +       77,  78,  80,  81,  83,  84,  86,  87,
> +       88,  90,  91,  92,  93,  95,  96,  97,
> +       98,  99, 100, 101, 102, 103, 104, 105,
> +       106, 106, 107, 108, 109, 109, 110, 111,
> +       111, 112, 112, 113, 113, 114, 114, 114,
> +       115, 115, 115, 115, 116, 116, 116, 116,
> +       116, 116, 116, 116, 116, 115, 115, 115,
> +       115, 114, 114, 114, 113, 113, 112, 112,
> +       111, 111, 110, 110, 109, 108, 108, 107,
> +       106, 105, 104, 103, 102, 101, 100,  99,
> +       98,  97,  96,  95,  94,  93,  91,  90,
> +       89,  88,  86,  85,  84,  82,  81,  79,
> +       78,  76,  75,  73,  71,  70,  68,  67,
> +       65,  63,  62,  60,  58,  56,  55,  53,
> +       51,  49,  47,  45,  44,  42,  40,  38,
> +       36,  34,  32,  30,  28,  26,  24,  22,
> +       20,  18,  16,  14,  12,  10,   8,   6,
> +       4,   2,   0,  -1,  -3,  -5,  -7,  -9, -11
> +};
> +
> +static u16 bridge_init[][2] = {
> +       {0x1000, 0x78}, {0x1001, 0x40}, {0x1002, 0x1c},
> +       {0x1020, 0x80}, {0x1061, 0x01}, {0x1067, 0x40},
> +       {0x1068, 0x30}, {0x1069, 0x20}, {0x106a, 0x10},
> +       {0x106b, 0x08}, {0x1188, 0x87}, {0x11a1, 0x00},
> +       {0x11a2, 0x00}, {0x11a3, 0x6a}, {0x11a4, 0x50},
> +       {0x11ab, 0x00}, {0x11ac, 0x00}, {0x11ad, 0x50},
> +       {0x11ae, 0x3c}, {0x118a, 0x04}, {0x0395, 0x04},
> +       {0x11b8, 0x3a}, {0x118b, 0x0e}, {0x10f7, 0x05},
> +       {0x10f8, 0x14}, {0x10fa, 0xff}, {0x10f9, 0x00},
> +       {0x11ba, 0x0a}, {0x11a5, 0x2d}, {0x11a6, 0x2d},
> +       {0x11a7, 0x3a}, {0x11a8, 0x05}, {0x11a9, 0x04},
> +       {0x11aa, 0x3f}, {0x11af, 0x28}, {0x11b0, 0xd8},
> +       {0x11b1, 0x14}, {0x11b2, 0xec}, {0x11b3, 0x32},
> +       {0x11b4, 0xdd}, {0x11b5, 0x32}, {0x11b6, 0xdd},
> +       {0x10e0, 0x2c}, {0x11bc, 0x40}, {0x11bd, 0x01},
> +       {0x11be, 0xf0}, {0x11bf, 0x00}, {0x118c, 0x1f},
> +       {0x118d, 0x1f}, {0x118e, 0x1f}, {0x118f, 0x1f},
> +       {0x1180, 0x01}, {0x1181, 0x00}, {0x1182, 0x01},
> +       {0x1183, 0x00}, {0x1184, 0x50}, {0x1185, 0x80}
> +};
> +
> +/* Gain = (bit[3:0] / 16 + 1) * (bit[4] + 1) * (bit[5] + 1) * (bit[6] + 1) */
> +static u8 ov_gain[] = {
> +       0x00 /* 1x */, 0x04 /* 1.25x */, 0x08 /* 1.5x */, 0x0C /* 1.75x */,
> +       0x10 /* 2x */, 0x12 /* 2.25x */, 0x14 /* 2.5x */, 0x16 /* 2.75x */,
> +       0x18 /* 3x */, 0x1A /* 3.25x */, 0x1C /* 3.5x */, 0x1E /* 3.75x */,
> +       0x30 /* 4x */, 0x31 /* 4.25x */, 0x32 /* 4.5x */, 0x33 /* 4.75x */,
> +       0x34 /* 5x */, 0x35 /* 5.25x */, 0x36 /* 5.5x */, 0x37 /* 5.75x */,
> +       0x38 /* 6x */, 0x39 /* 6.25x */, 0x3A /* 6.5x */, 0x3B /* 6.75x */,
> +       0x3C /* 7x */, 0x3D /* 7.25x */, 0x3E /* 7.5x */, 0x3F /* 7.75x */,
> +       0x70 /* 8x */
> +};
> +
> +/* Gain = (bit[8] + 1) * (bit[7] + 1) * (bit[6:0] * 0.03125) */
> +static u16 micron1_gain[] = {
> +       /* 1x   1.25x   1.5x    1.75x */
> +       0x0020, 0x0028, 0x0030, 0x0038,
> +       /* 2x   2.25x   2.5x    2.75x */
> +       0x00A0, 0x00A4, 0x00A8, 0x00AC,
> +       /* 3x   3.25x   3.5x    3.75x */
> +       0x00B0, 0x00B4, 0x00B8, 0x00BC,
> +       /* 4x   4.25x   4.5x    4.75x */
> +       0x00C0, 0x00C4, 0x00C8, 0x00CC,
> +       /* 5x   5.25x   5.5x    5.75x */
> +       0x00D0, 0x00D4, 0x00D8, 0x00DC,
> +       /* 6x   6.25x   6.5x    6.75x */
> +       0x00E0, 0x00E4, 0x00E8, 0x00EC,
> +       /* 7x   7.25x   7.5x    7.75x */
> +       0x00F0, 0x00F4, 0x00F8, 0x00FC,
> +       /* 8x */
> +       0x01C0
> +};
> +
> +/* mt9m001 sensor uses a different gain formula then other micron sensors */
> +/* Gain = (bit[6] + 1) * (bit[5-0] * 0.125) */
> +static u16 micron2_gain[] = {
> +       /* 1x   1.25x   1.5x    1.75x */
> +       0x0008, 0x000A, 0x000C, 0x000E,
> +       /* 2x   2.25x   2.5x    2.75x */
> +       0x0010, 0x0012, 0x0014, 0x0016,
> +       /* 3x   3.25x   3.5x    3.75x */
> +       0x0018, 0x001A, 0x001C, 0x001E,
> +       /* 4x   4.25x   4.5x    4.75x */
> +       0x0020, 0x0051, 0x0052, 0x0053,
> +       /* 5x   5.25x   5.5x    5.75x */
> +       0x0054, 0x0055, 0x0056, 0x0057,
> +       /* 6x   6.25x   6.5x    6.75x */
> +       0x0058, 0x0059, 0x005A, 0x005B,
> +       /* 7x   7.25x   7.5x    7.75x */
> +       0x005C, 0x005D, 0x005E, 0x005F,
> +       /* 8x */
> +       0x0060
> +};
> +
> +/* Gain = .5 + bit[7:0] / 16 */
> +static u8 hv7131r_gain[] = {
> +       0x08 /* 1x */, 0x0C /* 1.25x */, 0x10 /* 1.5x */, 0x14 /* 1.75x */,
> +       0x18 /* 2x */, 0x1C /* 2.25x */, 0x20 /* 2.5x */, 0x24 /* 2.75x */,
> +       0x28 /* 3x */, 0x2C /* 3.25x */, 0x30 /* 3.5x */, 0x34 /* 3.75x */,
> +       0x38 /* 4x */, 0x3C /* 4.25x */, 0x40 /* 4.5x */, 0x44 /* 4.75x */,
> +       0x48 /* 5x */, 0x4C /* 5.25x */, 0x50 /* 5.5x */, 0x54 /* 5.75x */,
> +       0x58 /* 6x */, 0x5C /* 6.25x */, 0x60 /* 6.5x */, 0x64 /* 6.75x */,
> +       0x68 /* 7x */, 0x6C /* 7.25x */, 0x70 /* 7.5x */, 0x74 /* 7.75x */,
> +       0x78 /* 8x */
> +};
> +
> +static u8 soi968_init[][2] = {
> +       {0x12, 0x80}, {0x0c, 0x00}, {0x0f, 0x1f},
> +       {0x11, 0x80}, {0x38, 0x52}, {0x1e, 0x00},
> +       {0x33, 0x08}, {0x35, 0x8c}, {0x36, 0x0c},
> +       {0x37, 0x04}, {0x45, 0x04}, {0x47, 0xff},
> +       {0x3e, 0x00}, {0x3f, 0x00}, {0x3b, 0x20},
> +       {0x3a, 0x96}, {0x3d, 0x0a}, {0x14, 0x8e},
> +       {0x13, 0x8a}, {0x12, 0x40}, {0x17, 0x13},
> +       {0x18, 0x63}, {0x19, 0x01}, {0x1a, 0x79},
> +       {0x32, 0x24}, {0x03, 0x00}, {0x11, 0x40},
> +       {0x2a, 0x10}, {0x2b, 0xe0}, {0x10, 0x32},
> +       {0x00, 0x00}, {0x01, 0x80}, {0x02, 0x80},
> +};
> +
> +static u8 ov7660_init[][2] = {
> +       {0x0e, 0x80}, {0x0d, 0x08}, {0x0f, 0xc3},
> +       {0x04, 0xc3}, {0x10, 0x40}, {0x11, 0x40},
> +       {0x12, 0x05}, {0x13, 0xba}, {0x14, 0x2a},
> +       {0x37, 0x0f}, {0x38, 0x02}, {0x39, 0x43},
> +       {0x3a, 0x00}, {0x69, 0x90}, {0x2d, 0xf6},
> +       {0x2e, 0x0b}, {0x01, 0x78}, {0x02, 0x50},
> +};
> +
> +static u8 ov7670_init[][2] = {
> +       {0x12, 0x80}, {0x11, 0x80}, {0x3a, 0x04}, {0x12, 0x01},
> +       {0x32, 0xb6}, {0x03, 0x0a}, {0x0c, 0x00}, {0x3e, 0x00},
> +       {0x70, 0x3a}, {0x71, 0x35}, {0x72, 0x11}, {0x73, 0xf0},
> +       {0xa2, 0x02}, {0x13, 0xe0}, {0x00, 0x00}, {0x10, 0x00},
> +       {0x0d, 0x40}, {0x14, 0x28}, {0xa5, 0x05}, {0xab, 0x07},
> +       {0x24, 0x95}, {0x25, 0x33}, {0x26, 0xe3}, {0x9f, 0x75},
> +       {0xa0, 0x65}, {0xa1, 0x0b}, {0xa6, 0xd8}, {0xa7, 0xd8},
> +       {0xa8, 0xf0}, {0xa9, 0x90}, {0xaa, 0x94}, {0x13, 0xe5},
> +       {0x0e, 0x61}, {0x0f, 0x4b}, {0x16, 0x02}, {0x1e, 0x27},
> +       {0x21, 0x02}, {0x22, 0x91}, {0x29, 0x07}, {0x33, 0x0b},
> +       {0x35, 0x0b}, {0x37, 0x1d}, {0x38, 0x71}, {0x39, 0x2a},
> +       {0x3c, 0x78}, {0x4d, 0x40}, {0x4e, 0x20}, {0x69, 0x00},
> +       {0x74, 0x19}, {0x8d, 0x4f}, {0x8e, 0x00}, {0x8f, 0x00},
> +       {0x90, 0x00}, {0x91, 0x00}, {0x96, 0x00}, {0x9a, 0x80},
> +       {0xb0, 0x84}, {0xb1, 0x0c}, {0xb2, 0x0e}, {0xb3, 0x82},
> +       {0xb8, 0x0a}, {0x43, 0x0a}, {0x44, 0xf0}, {0x45, 0x20},
> +       {0x46, 0x7d}, {0x47, 0x29}, {0x48, 0x4a}, {0x59, 0x8c},
> +       {0x5a, 0xa5}, {0x5b, 0xde}, {0x5c, 0x96}, {0x5d, 0x66},
> +       {0x5e, 0x10}, {0x6c, 0x0a}, {0x6d, 0x55}, {0x6e, 0x11},
> +       {0x6f, 0x9e}, {0x6a, 0x40}, {0x01, 0x40}, {0x02, 0x40},
> +       {0x13, 0xe7}, {0x4f, 0x6e}, {0x50, 0x70}, {0x51, 0x02},
> +       {0x52, 0x1d}, {0x53, 0x56}, {0x54, 0x73}, {0x55, 0x0a},
> +       {0x56, 0x55}, {0x57, 0x80}, {0x58, 0x9e}, {0x41, 0x08},
> +       {0x3f, 0x02}, {0x75, 0x03}, {0x76, 0x63}, {0x4c, 0x04},
> +       {0x77, 0x06}, {0x3d, 0x02}, {0x4b, 0x09}, {0xc9, 0x30},
> +       {0x41, 0x08}, {0x56, 0x48}, {0x34, 0x11}, {0xa4, 0x88},
> +       {0x96, 0x00}, {0x97, 0x30}, {0x98, 0x20}, {0x99, 0x30},
> +       {0x9a, 0x84}, {0x9b, 0x29}, {0x9c, 0x03}, {0x9d, 0x99},
> +       {0x9e, 0x7f}, {0x78, 0x04}, {0x79, 0x01}, {0xc8, 0xf0},
> +       {0x79, 0x0f}, {0xc8, 0x00}, {0x79, 0x10}, {0xc8, 0x7e},
> +       {0x79, 0x0a}, {0xc8, 0x80}, {0x79, 0x0b}, {0xc8, 0x01},
> +       {0x79, 0x0c}, {0xc8, 0x0f}, {0x79, 0x0d}, {0xc8, 0x20},
> +       {0x79, 0x09}, {0xc8, 0x80}, {0x79, 0x02}, {0xc8, 0xc0},
> +       {0x79, 0x03}, {0xc8, 0x40}, {0x79, 0x05}, {0xc8, 0x30},
> +       {0x79, 0x26}, {0x62, 0x20}, {0x63, 0x00}, {0x64, 0x06},
> +       {0x65, 0x00}, {0x66, 0x05}, {0x94, 0x05}, {0x95, 0x0a},
> +       {0x17, 0x13}, {0x18, 0x01}, {0x19, 0x02}, {0x1a, 0x7a},
> +       {0x46, 0x59}, {0x47, 0x30}, {0x58, 0x9a}, {0x59, 0x84},
> +       {0x5a, 0x91}, {0x5b, 0x57}, {0x5c, 0x75}, {0x5d, 0x6d},
> +       {0x5e, 0x13}, {0x64, 0x07}, {0x94, 0x07}, {0x95, 0x0d},
> +       {0xa6, 0xdf}, {0xa7, 0xdf}, {0x48, 0x4d}, {0x51, 0x00},
> +       {0x6b, 0x0a}, {0x11, 0x80}, {0x2a, 0x00}, {0x2b, 0x00},
> +       {0x92, 0x00}, {0x93, 0x00}, {0x55, 0x0a}, {0x56, 0x60},
> +       {0x4f, 0x6e}, {0x50, 0x70}, {0x51, 0x00}, {0x52, 0x1d},
> +       {0x53, 0x56}, {0x54, 0x73}, {0x58, 0x9a}, {0x4f, 0x6e},
> +       {0x50, 0x70}, {0x51, 0x00}, {0x52, 0x1d}, {0x53, 0x56},
> +       {0x54, 0x73}, {0x58, 0x9a}, {0x3f, 0x01}, {0x7b, 0x03},
> +       {0x7c, 0x09}, {0x7d, 0x16}, {0x7e, 0x38}, {0x7f, 0x47},
> +       {0x80, 0x53}, {0x81, 0x5e}, {0x82, 0x6a}, {0x83, 0x74},
> +       {0x84, 0x80}, {0x85, 0x8c}, {0x86, 0x9b}, {0x87, 0xb2},
> +       {0x88, 0xcc}, {0x89, 0xe5}, {0x7a, 0x24}, {0x3b, 0x00},
> +       {0x9f, 0x76}, {0xa0, 0x65}, {0x13, 0xe2}, {0x6b, 0x0a},
> +       {0x11, 0x80}, {0x2a, 0x00}, {0x2b, 0x00}, {0x92, 0x00},
> +       {0x93, 0x00},
> +};
> +
> +static u8 ov9650_init[][2] = {
> +       {0x12, 0x80}, {0x00, 0x00}, {0x01, 0x78},
> +       {0x02, 0x78}, {0x03, 0x36}, {0x04, 0x03},
> +       {0x05, 0x00}, {0x06, 0x00}, {0x08, 0x00},
> +       {0x09, 0x01}, {0x0c, 0x00}, {0x0d, 0x00},
> +       {0x0e, 0xa0}, {0x0f, 0x52}, {0x10, 0x7c},
> +       {0x11, 0x80}, {0x12, 0x45}, {0x13, 0xc2},
> +       {0x14, 0x2e}, {0x15, 0x00}, {0x16, 0x07},
> +       {0x17, 0x24}, {0x18, 0xc5}, {0x19, 0x00},
> +       {0x1a, 0x3c}, {0x1b, 0x00}, {0x1e, 0x04},
> +       {0x1f, 0x00}, {0x24, 0x78}, {0x25, 0x68},
> +       {0x26, 0xd4}, {0x27, 0x80}, {0x28, 0x80},
> +       {0x29, 0x30}, {0x2a, 0x00}, {0x2b, 0x00},
> +       {0x2c, 0x80}, {0x2d, 0x00}, {0x2e, 0x00},
> +       {0x2f, 0x00}, {0x30, 0x08}, {0x31, 0x30},
> +       {0x32, 0x84}, {0x33, 0xe2}, {0x34, 0xbf},
> +       {0x35, 0x81}, {0x36, 0xf9}, {0x37, 0x00},
> +       {0x38, 0x93}, {0x39, 0x50}, {0x3a, 0x01},
> +       {0x3b, 0x01}, {0x3c, 0x73}, {0x3d, 0x19},
> +       {0x3e, 0x0b}, {0x3f, 0x80}, {0x40, 0xc1},
> +       {0x41, 0x00}, {0x42, 0x08}, {0x67, 0x80},
> +       {0x68, 0x80}, {0x69, 0x40}, {0x6a, 0x00},
> +       {0x6b, 0x0a}, {0x8b, 0x06}, {0x8c, 0x20},
> +       {0x8d, 0x00}, {0x8e, 0x00}, {0x8f, 0xdf},
> +       {0x92, 0x00}, {0x93, 0x00}, {0x94, 0x88},
> +       {0x95, 0x88}, {0x96, 0x04}, {0xa1, 0x00},
> +       {0xa5, 0x80}, {0xa8, 0x80}, {0xa9, 0xb8},
> +       {0xaa, 0x92}, {0xab, 0x0a},
> +};
> +
> +static u8 ov9655_init[][2] = {
> +       {0x12, 0x80}, {0x12, 0x01}, {0x0d, 0x00}, {0x0e, 0x61},
> +       {0x11, 0x80}, {0x13, 0xba}, {0x14, 0x2e}, {0x16, 0x24},
> +       {0x1e, 0x04}, {0x1e, 0x04}, {0x1e, 0x04}, {0x27, 0x08},
> +       {0x28, 0x08}, {0x29, 0x15}, {0x2c, 0x08}, {0x32, 0xbf},
> +       {0x34, 0x3d}, {0x35, 0x00}, {0x36, 0xf8}, {0x38, 0x12},
> +       {0x39, 0x57}, {0x3a, 0x00}, {0x3b, 0xcc}, {0x3c, 0x0c},
> +       {0x3d, 0x19}, {0x3e, 0x0c}, {0x3f, 0x01}, {0x41, 0x40},
> +       {0x42, 0x80}, {0x45, 0x46}, {0x46, 0x62}, {0x47, 0x2a},
> +       {0x48, 0x3c}, {0x4a, 0xf0}, {0x4b, 0xdc}, {0x4c, 0xdc},
> +       {0x4d, 0xdc}, {0x4e, 0xdc}, {0x69, 0x02}, {0x6c, 0x04},
> +       {0x6f, 0x9e}, {0x70, 0x05}, {0x71, 0x78}, {0x77, 0x02},
> +       {0x8a, 0x23}, {0x8c, 0x0d}, {0x90, 0x7e}, {0x91, 0x7c},
> +       {0x9f, 0x6e}, {0xa0, 0x6e}, {0xa5, 0x68}, {0xa6, 0x60},
> +       {0xa8, 0xc1}, {0xa9, 0xfa}, {0xaa, 0x92}, {0xab, 0x04},
> +       {0xac, 0x80}, {0xad, 0x80}, {0xae, 0x80}, {0xaf, 0x80},
> +       {0xb2, 0xf2}, {0xb3, 0x20}, {0xb5, 0x00}, {0xb6, 0xaf},
> +       {0xbb, 0xae}, {0xbc, 0x44}, {0xbd, 0x44}, {0xbe, 0x3b},
> +       {0xbf, 0x3a}, {0xc0, 0xe2}, {0xc1, 0xc8}, {0xc2, 0x01},
> +       {0xc4, 0x00}, {0xc6, 0x85}, {0xc7, 0x81}, {0xc9, 0xe0},
> +       {0xca, 0xe8}, {0xcc, 0xd8}, {0xcd, 0x93}, {0x12, 0x61},
> +       {0x36, 0xfa}, {0x8c, 0x8d}, {0xc0, 0xaa}, {0x69, 0x0a},
> +       {0x03, 0x12}, {0x17, 0x14}, {0x18, 0x00}, {0x19, 0x01},
> +       {0x1a, 0x3d}, {0x32, 0xbf}, {0x11, 0x80}, {0x2a, 0x10},
> +       {0x2b, 0x0a}, {0x92, 0x00}, {0x93, 0x00}, {0x1e, 0x04},
> +       {0x1e, 0x04}, {0x10, 0x7c}, {0x04, 0x03}, {0xa1, 0x00},
> +       {0x2d, 0x00}, {0x2e, 0x00}, {0x00, 0x00}, {0x01, 0x80},
> +       {0x02, 0x80}, {0x12, 0x61}, {0x36, 0xfa}, {0x8c, 0x8d},
> +       {0xc0, 0xaa}, {0x69, 0x0a}, {0x03, 0x12}, {0x17, 0x14},
> +       {0x18, 0x00}, {0x19, 0x01}, {0x1a, 0x3d}, {0x32, 0xbf},
> +       {0x11, 0x80}, {0x2a, 0x10}, {0x2b, 0x0a}, {0x92, 0x00},
> +       {0x93, 0x00}, {0x04, 0x01}, {0x10, 0x1f}, {0xa1, 0x00},
> +       {0x00, 0x0a}, {0xa1, 0x00}, {0x10, 0x5d}, {0x04, 0x03},
> +       {0x00, 0x01}, {0xa1, 0x00}, {0x10, 0x7c}, {0x04, 0x03},
> +       {0x00, 0x03}, {0x00, 0x0a}, {0x00, 0x10}, {0x00, 0x13},
> +};
> +
> +static u16 mt9v112_init[][2] = {
> +       {0xf0, 0x0000}, {0x0d, 0x0021}, {0x0d, 0x0020},
> +       {0x34, 0xc019}, {0x0a, 0x0011}, {0x0b, 0x000b},
> +       {0x20, 0x0703}, {0x35, 0x2022}, {0xf0, 0x0001},
> +       {0x05, 0x0000}, {0x06, 0x340c}, {0x3b, 0x042a},
> +       {0x3c, 0x0400}, {0xf0, 0x0002}, {0x2e, 0x0c58},
> +       {0x5b, 0x0001}, {0xc8, 0x9f0b}, {0xf0, 0x0001},
> +       {0x9b, 0x5300}, {0xf0, 0x0000}, {0x2b, 0x0020},
> +       {0x2c, 0x002a}, {0x2d, 0x0032}, {0x2e, 0x0020},
> +       {0x09, 0x01dc}, {0x01, 0x000c}, {0x02, 0x0020},
> +       {0x03, 0x01e0}, {0x04, 0x0280}, {0x06, 0x000c},
> +       {0x05, 0x0098}, {0x20, 0x0703}, {0x09, 0x01f2},
> +       {0x2b, 0x00a0}, {0x2c, 0x00a0}, {0x2d, 0x00a0},
> +       {0x2e, 0x00a0}, {0x01, 0x000c}, {0x02, 0x0020},
> +       {0x03, 0x01e0}, {0x04, 0x0280}, {0x06, 0x000c},
> +       {0x05, 0x0098}, {0x09, 0x01c1}, {0x2b, 0x00ae},
> +       {0x2c, 0x00ae}, {0x2d, 0x00ae}, {0x2e, 0x00ae},
> +};
> +
> +static u16 mt9v111_init[][2] = {
> +       {0x01, 0x0004}, {0x0d, 0x0001}, {0x0d, 0x0000},
> +       {0x01, 0x0001}, {0x02, 0x0016}, {0x03, 0x01e1},
> +       {0x04, 0x0281}, {0x05, 0x0004}, {0x07, 0x3002},
> +       {0x21, 0x0000}, {0x25, 0x4024}, {0x26, 0xff03},
> +       {0x27, 0xff10}, {0x2b, 0x7828}, {0x2c, 0xb43c},
> +       {0x2d, 0xf0a0}, {0x2e, 0x0c64}, {0x2f, 0x0064},
> +       {0x67, 0x4010}, {0x06, 0x301e}, {0x08, 0x0480},
> +       {0x01, 0x0004}, {0x02, 0x0016}, {0x03, 0x01e6},
> +       {0x04, 0x0286}, {0x05, 0x0004}, {0x06, 0x0000},
> +       {0x07, 0x3002}, {0x08, 0x0008}, {0x0c, 0x0000},
> +       {0x0d, 0x0000}, {0x0e, 0x0000}, {0x0f, 0x0000},
> +       {0x10, 0x0000}, {0x11, 0x0000}, {0x12, 0x00b0},
> +       {0x13, 0x007c}, {0x14, 0x0000}, {0x15, 0x0000},
> +       {0x16, 0x0000}, {0x17, 0x0000}, {0x18, 0x0000},
> +       {0x19, 0x0000}, {0x1a, 0x0000}, {0x1b, 0x0000},
> +       {0x1c, 0x0000}, {0x1d, 0x0000}, {0x30, 0x0000},
> +       {0x30, 0x0005}, {0x31, 0x0000}, {0x02, 0x0016},
> +       {0x03, 0x01e1}, {0x04, 0x0281}, {0x05, 0x0004},
> +       {0x06, 0x0000}, {0x07, 0x3002}, {0x06, 0x002d},
> +       {0x05, 0x0004}, {0x09, 0x0064}, {0x2b, 0x00a0},
> +       {0x2c, 0x00a0}, {0x2d, 0x00a0}, {0x2e, 0x00a0},
> +       {0x02, 0x0016}, {0x03, 0x01e1}, {0x04, 0x0281},
> +       {0x05, 0x0004}, {0x06, 0x002d}, {0x07, 0x3002},
> +       {0x0e, 0x0008}, {0x06, 0x002d}, {0x05, 0x0004},
> +};
> +
> +static u16 mt9v011_init[][2] = {
> +       {0x07, 0x0002}, {0x0d, 0x0001}, {0x0d, 0x0000},
> +       {0x01, 0x0008}, {0x02, 0x0016}, {0x03, 0x01e1},
> +       {0x04, 0x0281}, {0x05, 0x0083}, {0x06, 0x0006},
> +       {0x0d, 0x0002}, {0x0a, 0x0000}, {0x0b, 0x0000},
> +       {0x0c, 0x0000}, {0x0d, 0x0000}, {0x0e, 0x0000},
> +       {0x0f, 0x0000}, {0x10, 0x0000}, {0x11, 0x0000},
> +       {0x12, 0x0000}, {0x13, 0x0000}, {0x14, 0x0000},
> +       {0x15, 0x0000}, {0x16, 0x0000}, {0x17, 0x0000},
> +       {0x18, 0x0000}, {0x19, 0x0000}, {0x1a, 0x0000},
> +       {0x1b, 0x0000}, {0x1c, 0x0000}, {0x1d, 0x0000},
> +       {0x32, 0x0000}, {0x20, 0x1101}, {0x21, 0x0000},
> +       {0x22, 0x0000}, {0x23, 0x0000}, {0x24, 0x0000},
> +       {0x25, 0x0000}, {0x26, 0x0000}, {0x27, 0x0024},
> +       {0x2f, 0xf7b0}, {0x30, 0x0005}, {0x31, 0x0000},
> +       {0x32, 0x0000}, {0x33, 0x0000}, {0x34, 0x0100},
> +       {0x3d, 0x068f}, {0x40, 0x01e0}, {0x41, 0x00d1},
> +       {0x44, 0x0082}, {0x5a, 0x0000}, {0x5b, 0x0000},
> +       {0x5c, 0x0000}, {0x5d, 0x0000}, {0x5e, 0x0000},
> +       {0x5f, 0xa31d}, {0x62, 0x0611}, {0x0a, 0x0000},
> +       {0x06, 0x0029}, {0x05, 0x0009}, {0x20, 0x1101},
> +       {0x20, 0x1101}, {0x09, 0x0064}, {0x07, 0x0003},
> +       {0x2b, 0x0033}, {0x2c, 0x00a0}, {0x2d, 0x00a0},
> +       {0x2e, 0x0033}, {0x07, 0x0002}, {0x06, 0x0000},
> +       {0x06, 0x0029}, {0x05, 0x0009},
> +};
> +
> +static u16 mt9m001_init[][2] = {
> +       {0x0d, 0x0001}, {0x0d, 0x0000}, {0x01, 0x000e},
> +       {0x02, 0x0014}, {0x03, 0x03c1}, {0x04, 0x0501},
> +       {0x05, 0x0083}, {0x06, 0x0006}, {0x0d, 0x0002},
> +       {0x0a, 0x0000}, {0x0c, 0x0000}, {0x11, 0x0000},
> +       {0x1e, 0x8000}, {0x5f, 0x8904}, {0x60, 0x0000},
> +       {0x61, 0x0000}, {0x62, 0x0498}, {0x63, 0x0000},
> +       {0x64, 0x0000}, {0x20, 0x111d}, {0x06, 0x00f2},
> +       {0x05, 0x0013}, {0x09, 0x10f2}, {0x07, 0x0003},
> +       {0x2b, 0x002a}, {0x2d, 0x002a}, {0x2c, 0x002a},
> +       {0x2e, 0x0029}, {0x07, 0x0002},
> +};
> +
> +static u16 mt9m111_init[][2] = {
> +       {0xf0, 0x0000}, {0x0d, 0x0008}, {0x0d, 0x0009},
> +       {0x0d, 0x0008}, {0xf0, 0x0001}, {0x3a, 0x4300},
> +       {0x9b, 0x4300}, {0xa1, 0x0280}, {0xa4, 0x0200},
> +       {0x06, 0x308e}, {0xf0, 0x0000},
> +};
> +
> +static u8 hv7131r_init[][2] = {
> +       {0x02, 0x08}, {0x02, 0x00}, {0x01, 0x08},
> +       {0x02, 0x00}, {0x20, 0x00}, {0x21, 0xd0},
> +       {0x22, 0x00}, {0x23, 0x09}, {0x01, 0x08},
> +       {0x01, 0x08}, {0x01, 0x08}, {0x25, 0x07},
> +       {0x26, 0xc3}, {0x27, 0x50}, {0x30, 0x62},
> +       {0x31, 0x10}, {0x32, 0x06}, {0x33, 0x10},
> +       {0x20, 0x00}, {0x21, 0xd0}, {0x22, 0x00},
> +       {0x23, 0x09}, {0x01, 0x08},
> +};
> +
> +int reg_r(struct gspca_dev *gspca_dev, u16 reg, u16 length)
> +{
> +       struct usb_device *dev = gspca_dev->dev;
> +       int result;
> +       result = usb_control_msg(dev, usb_rcvctrlpipe(dev, 0),
> +                       0x00,
> +                       USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
> +                       reg,
> +                       0x00,
> +                       gspca_dev->usb_buf,
> +                       length,
> +                       500);
> +       if (unlikely(result < 0)) {
> +               err("Read register failed 0x%02X", reg);
> +               return result;
> +       }
> +       return 0;
> +}
> +
> +int reg_w(struct gspca_dev *gspca_dev, u16 reg, const u8 *buffer, int length)
> +{
> +       struct usb_device *dev = gspca_dev->dev;
> +       int result;
> +       memcpy(gspca_dev->usb_buf, buffer, length);
> +       result = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
> +                       0x08,
> +                       USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
> +                       reg,
> +                       0x00,
> +                       gspca_dev->usb_buf,
> +                       length,
> +                       500);
> +       if (unlikely(result < 0)) {


>From file: drivers/usb/core/message.c
(section that describes usb_control_msg)

"If successful, it returns the number of bytes transferred, otherwise
a negative error number."

So there is suggestion - don't you want to convert if-check in reg_r()
and reg_w() for example into like this:

if (unlikely(result < 0 || retval != length))

?
Is this right/possible?

-- 
Best regards, Klimov Alexey
