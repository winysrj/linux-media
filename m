Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f177.google.com ([209.85.217.177]:46520 "EHLO
        mail-ua0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933179AbeEHIed (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 May 2018 04:34:33 -0400
Received: by mail-ua0-f177.google.com with SMTP id e8so17908833uam.13
        for <linux-media@vger.kernel.org>; Tue, 08 May 2018 01:34:32 -0700 (PDT)
Received: from mail-vk0-f45.google.com (mail-vk0-f45.google.com. [209.85.213.45])
        by smtp.gmail.com with ESMTPSA id 190-v6sm5193434vki.51.2018.05.08.01.34.30
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 May 2018 01:34:31 -0700 (PDT)
Received: by mail-vk0-f45.google.com with SMTP id 203-v6so19131352vka.12
        for <linux-media@vger.kernel.org>; Tue, 08 May 2018 01:34:30 -0700 (PDT)
MIME-Version: 1.0
References: <1525275968-17207-1-git-send-email-andy.yeh@intel.com>
In-Reply-To: <1525275968-17207-1-git-send-email-andy.yeh@intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Tue, 08 May 2018 08:34:19 +0000
Message-ID: <CAAFQd5BYokHC7J8wEjT4twx7_bU1Yyv1LbN2PAK2tjmCrr2cig@mail.gmail.com>
Subject: Re: [PATCH v11] media: imx258: Add imx258 camera sensor driver
To: "Yeh, Andy" <andy.yeh@intel.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Chen, JasonX Z" <jasonx.z.chen@intel.com>,
        Alan Chiang <alanx.chiang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

Sorry, missed one problem in previous review. Would you be able to send a
fixup patch?

On Thu, May 3, 2018 at 12:38 AM Andy Yeh <andy.yeh@intel.com> wrote:

> From: Jason Chen <jasonx.z.chen@intel.com>

> Add a V4L2 sub-device driver for the Sony IMX258 image sensor.
> This is a camera sensor using the I2C bus for control and the
> CSI-2 bus for data.

> Signed-off-by: Andy Yeh <andy.yeh@intel.com>
> Signed-off-by: Alan Chiang <alanx.chiang@intel.com>
> Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Reviewed-by: Tomasz Figa <tfiga@chromium.org>

> ---
> since v2:
> -- Update the streaming function to remove SW_STANDBY in the beginning.
> -- Adjust the delay time from 1ms to 12ms before set stream-on register.
> since v3:
> -- fix the sd.entity to make code be compiled on the mainline kernel.
> since v4:
> -- Enabled AG, DG, and Exposure time control correctly.
> since v5:
> -- Sensor vendor provided a new setting to fix different CLK issue
> -- Add one more resolution for 1048x780, used for VGA streaming
> since v6:
> -- improved i2c read/write function to support writing 2 registers
> -- modified i2c reg read/write function with a more portable way
> -- utilized v4l2_find_nearest_size instead of the local find_best_fit
function
> -- defined an enum for the link freq entries for explicit indexing
> since v7:
> -- Removed usleep due to sufficient delay implemented in coreboot
> -- Added handling for VBLANK control that auto frame-line-control is
enabled
> since v8:
> -- Fix some error return and intents
> since v9:
> -- Fix a typo (fmr -> fmt)
> since v9.1:
> -- Add code for test pattern control
> -- set vblank and read only since auto-FLL is enabled
> since v10:
> -- Implement test pattern feature:
> -- Output order of test pattern is always BGGR, so it needs a flip to
rotate bayer pattern to required one (GRBG)


>   MAINTAINERS                |    7 +
>   drivers/media/i2c/Kconfig  |   11 +
>   drivers/media/i2c/Makefile |    1 +
>   drivers/media/i2c/imx258.c | 1321
++++++++++++++++++++++++++++++++++++++++++++
>   4 files changed, 1340 insertions(+)
>   create mode 100644 drivers/media/i2c/imx258.c

> diff --git a/MAINTAINERS b/MAINTAINERS
> index a339bb5..9f75510 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -12646,6 +12646,13 @@ S:     Maintained
>   F:     drivers/ssb/
>   F:     include/linux/ssb/

> +SONY IMX258 SENSOR DRIVER
> +M:     Sakari Ailus <sakari.ailus@linux.intel.com>
> +L:     linux-media@vger.kernel.org
> +T:     git git://linuxtv.org/media_tree.git
> +S:     Maintained
> +F:     drivers/media/i2c/imx258.c
> +
>   SONY IMX274 SENSOR DRIVER
>   M:     Leon Luo <leonl@leopardimaging.com>
>   L:     linux-media@vger.kernel.org
> diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
> index fd01842..bcd4bf1 100644
> --- a/drivers/media/i2c/Kconfig
> +++ b/drivers/media/i2c/Kconfig
> @@ -565,6 +565,17 @@ config VIDEO_APTINA_PLL
>   config VIDEO_SMIAPP_PLL
>          tristate

> +config VIDEO_IMX258
> +       tristate "Sony IMX258 sensor support"
> +       depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
> +       depends on MEDIA_CAMERA_SUPPORT
> +       ---help---
> +         This is a Video4Linux2 sensor-level driver for the Sony
> +         IMX258 camera.
> +
> +         To compile this driver as a module, choose M here: the
> +         module will be called imx258.
> +
>   config VIDEO_IMX274
>          tristate "Sony IMX274 sensor support"
>          depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
> diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
> index 1b62639..4bf7d00 100644
> --- a/drivers/media/i2c/Makefile
> +++ b/drivers/media/i2c/Makefile
> @@ -94,6 +94,7 @@ obj-$(CONFIG_VIDEO_IR_I2C)  += ir-kbd-i2c.o
>   obj-$(CONFIG_VIDEO_ML86V7667)  += ml86v7667.o
>   obj-$(CONFIG_VIDEO_OV2659)     += ov2659.o
>   obj-$(CONFIG_VIDEO_TC358743)   += tc358743.o
> +obj-$(CONFIG_VIDEO_IMX258)     += imx258.o
>   obj-$(CONFIG_VIDEO_IMX274)     += imx274.o

>   obj-$(CONFIG_SDR_MAX2175) += max2175.o
> diff --git a/drivers/media/i2c/imx258.c b/drivers/media/i2c/imx258.c
> new file mode 100644
> index 0000000..b2e6d06
> --- /dev/null
> +++ b/drivers/media/i2c/imx258.c
> @@ -0,0 +1,1321 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (C) 2018 Intel Corporation
> +
> +#include <linux/acpi.h>
> +#include <linux/delay.h>
> +#include <linux/i2c.h>
> +#include <linux/module.h>
> +#include <linux/pm_runtime.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-device.h>
> +#include <asm/unaligned.h>
> +
> +#define IMX258_REG_VALUE_08BIT         1
> +#define IMX258_REG_VALUE_16BIT         2
> +
> +#define IMX258_REG_MODE_SELECT         0x0100
> +#define IMX258_MODE_STANDBY            0x00
> +#define IMX258_MODE_STREAMING          0x01
> +
> +/* Chip ID */
> +#define IMX258_REG_CHIP_ID             0x0016
> +#define IMX258_CHIP_ID                 0x0258
> +
> +/* V_TIMING internal */
> +#define IMX258_VTS_30FPS               0x0c98
> +#define IMX258_VTS_30FPS_2K            0x0638
> +#define IMX258_VTS_30FPS_VGA           0x034c
> +#define IMX258_VTS_MAX                 0xffff
> +
> +/*Frame Length Line*/
> +#define IMX258_FLL_MIN                 0x08a6
> +#define IMX258_FLL_MAX                 0xffff
> +#define IMX258_FLL_STEP                        1
> +#define IMX258_FLL_DEFAULT             0x0c98
> +
> +/* HBLANK control - read only */
> +#define IMX258_PPL_DEFAULT             5352
> +
> +/* Exposure control */
> +#define IMX258_REG_EXPOSURE            0x0202
> +#define IMX258_EXPOSURE_MIN            4
> +#define IMX258_EXPOSURE_STEP           1
> +#define IMX258_EXPOSURE_DEFAULT                0x640
> +#define IMX258_EXPOSURE_MAX            65535
> +
> +/* Analog gain control */
> +#define IMX258_REG_ANALOG_GAIN         0x0204
> +#define IMX258_ANA_GAIN_MIN            0
> +#define IMX258_ANA_GAIN_MAX            0x1fff
> +#define IMX258_ANA_GAIN_STEP           1
> +#define IMX258_ANA_GAIN_DEFAULT                0x0
> +
> +/* Digital gain control */
> +#define IMX258_REG_GR_DIGITAL_GAIN     0x020e
> +#define IMX258_REG_R_DIGITAL_GAIN      0x0210
> +#define IMX258_REG_B_DIGITAL_GAIN      0x0212
> +#define IMX258_REG_GB_DIGITAL_GAIN     0x0214
> +#define IMX258_DGTL_GAIN_MIN           0
> +#define IMX258_DGTL_GAIN_MAX           4096   /* Max = 0xFFF */
> +#define IMX258_DGTL_GAIN_DEFAULT       1024
> +#define IMX258_DGTL_GAIN_STEP           1
> +
> +/* Test Pattern Control */
> +#define IMX258_REG_TEST_PATTERN                0x0600
> +#define IMX258_TEST_PATTERN_DISABLE    0
> +#define IMX258_TEST_PATTERN_SOLID_COLOR        1
> +#define IMX258_TEST_PATTERN_COLOR_BARS 2
> +#define IMX258_TEST_PATTERN_GREY_COLOR 3
> +#define IMX258_TEST_PATTERN_PN9                4
> +
> +/* Orientation */
> +#define REG_MIRROR_FLIP_CONTROL                0x0101
> +#define REG_CONFIG_MIRROR_FLIP         0x03
> +#define REG_CONFIG_FLIP_TEST_PATTERN   0x02

The names are inconsistent here. All other register addresses start with
IMX258_REG and values with IMX258_<field name> (no REG).

[snip]
> +static const char * const imx258_test_pattern_menu[] = {
> +       "Disabled",
> +       "Color Bars",
> +       "Solid Color",
> +       "Grey Color Bars",
> +       "PN9"
> +};
> +
> +static const int imx258_test_pattern_val[] = {
> +       IMX258_TEST_PATTERN_DISABLE,
> +       IMX258_TEST_PATTERN_COLOR_BARS,
> +       IMX258_TEST_PATTERN_SOLID_COLOR,
> +       IMX258_TEST_PATTERN_GREY_COLOR,
> +       IMX258_TEST_PATTERN_PN9,
> +};

By reordering imx258_test_pattern_menu[], this array can be removed and
ctrl->val can be used directly. It is validated by control framework to be
within menu range and so safe to be used for programming hardware.

[snip]
> +       case V4L2_CID_TEST_PATTERN:
> +               ret = imx258_write_reg(imx258, IMX258_REG_TEST_PATTERN,
> +                               IMX258_REG_VALUE_16BIT,
> +                               imx258_test_pattern_val[ctrl->val]);
> +
> +               ret = imx258_write_reg(imx258, REG_MIRROR_FLIP_CONTROL,
> +                               IMX258_REG_VALUE_08BIT,
> +                               ctrl->val == imx258_test_pattern_val
> +                               [IMX258_TEST_PATTERN_DISABLE] ?
> +                               REG_CONFIG_MIRROR_FLIP :
> +                               REG_CONFIG_FLIP_TEST_PATTERN);

The comparison above doesn't make any sense. ctrl->val is an index into
imx258_test_pattern_val[], but
imx258_test_pattern_val[IMX258_TEST_PATTERN_DISABLE] is a register value.
Moreover, IMX258_TEST_PATTERN_DISABLE is also a register value, so it
doesn't make sense to use it for indexing the array. I'd suggest simply
checking for (!ctrl->val).

Best regards,
Tomasz
