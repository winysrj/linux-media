Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51424 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880Ab2K3NKT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Nov 2012 08:10:19 -0500
Received: by mail-ob0-f174.google.com with SMTP id ta14so361209obb.19
        for <linux-media@vger.kernel.org>; Fri, 30 Nov 2012 05:10:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1349433287-28628-1-git-send-email-eballetbo@gmail.com>
References: <1349433287-28628-1-git-send-email-eballetbo@gmail.com>
Date: Fri, 30 Nov 2012 16:10:18 +0300
Message-ID: <CALW4P+J5fyp+HLdUYTgo+yeVE3o0P9T10R=cFJ_3qkkjR4jDVw@mail.gmail.com>
Subject: Re: [PATCH] [media] v4l: Add mt9v034 sensor driver
From: Alexey Klimov <klimov.linux@gmail.com>
To: Enric Balletbo i Serra <eballetbo@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media <linux-media@vger.kernel.org>,
	mchehab@infradead.org, hans.verkuil@cisco.com,
	sakari.ailus@maxwell.research.nokia.com, s.nawrocki@samsung.com,
	Enric Balletbo i Serra <eballetbo@iseebcn.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Enric,

May i ask about mt9v034_probe() and mt9v034_remove()?

On Fri, Oct 5, 2012 at 2:34 PM, Enric Balletbo i Serra
<eballetbo@gmail.com> wrote:
> From: Enric Balletbo i Serra <eballetbo@iseebcn.com>
>
> The MT9V034 is a parallel wide VGA sensor from Aptina (formerly Micron)
> controlled through I2C.
>
> The driver creates a V4L2 subdevice. It currently supports binning and
> cropping, and the gain, auto gain, exposure, auto exposure and test
> pattern controls.
>
> The following patch is based on the MT9V032 driver from Laurent Pinchart
> and was tested on IGEP tech based boards with custom expansion board with
> MT9V034 sensor.
>
> Signed-off-by: Enric Balletbo i Serra <eballetbo@iseebcn.com>
> ---
>  drivers/media/i2c/Kconfig   |   10 +
>  drivers/media/i2c/Makefile  |    1 +
>  drivers/media/i2c/mt9v034.c |  834 +++++++++++++++++++++++++++++++++++++++++++
>  include/media/mt9v034.h     |   15 +
>  4 files changed, 860 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/i2c/mt9v034.c
>  create mode 100644 include/media/mt9v034.h
>
> diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
> index 0e0793a..c35efda 100644
> --- a/drivers/media/i2c/Kconfig
> +++ b/drivers/media/i2c/Kconfig
> @@ -475,6 +475,16 @@ config VIDEO_MT9V032
>           This is a Video4Linux2 sensor-level driver for the Micron
>           MT9V032 752x480 CMOS sensor.
>
> +config VIDEO_MT9V034
> +       tristate "Micron MT9V034 sensor support"
> +       depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
> +       depends on MEDIA_CAMERA_SUPPORT
> +       ---help---
> +         This is a Video4Linux2 sensor-level driver for the Micron
> +         MT9V034 752x480 CMOS sensor. The MT9V034 is a 1/3-inch
> +         wide-VGA format CMOS active-pixel digital image sensor with
> +         TrueSNAP gobal shutter and high dynamic range (HDR) operation.
> +
>  config VIDEO_TCM825X
>         tristate "TCM825x camera sensor support"
>         depends on I2C && VIDEO_V4L2
> diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
> index 4a270f7..9d4c417 100644
> --- a/drivers/media/i2c/Makefile
> +++ b/drivers/media/i2c/Makefile
> @@ -54,6 +54,7 @@ obj-$(CONFIG_VIDEO_MT9P031) += mt9p031.o
>  obj-$(CONFIG_VIDEO_MT9T001) += mt9t001.o
>  obj-$(CONFIG_VIDEO_MT9V011) += mt9v011.o
>  obj-$(CONFIG_VIDEO_MT9V032) += mt9v032.o
> +obj-$(CONFIG_VIDEO_MT9V034) += mt9v034.o
>  obj-$(CONFIG_VIDEO_SR030PC30)  += sr030pc30.o
>  obj-$(CONFIG_VIDEO_NOON010PC30)        += noon010pc30.o
>  obj-$(CONFIG_VIDEO_S5K6AA)     += s5k6aa.o
> diff --git a/drivers/media/i2c/mt9v034.c b/drivers/media/i2c/mt9v034.c
> new file mode 100644
> index 0000000..7bbfeb6
> --- /dev/null
> +++ b/drivers/media/i2c/mt9v034.c
> @@ -0,0 +1,834 @@
> +/*
> + * Driver for MT9V034 CMOS Image Sensor from Micron
> + *
> + * Copyright (C) 2012, Enric Balletbo <eballetbo@iseebcn.com>
> + *
> + * Based on the MT9V032 driver,
> + *
> + * Copyright (C) 2010, Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/delay.h>
> +#include <linux/i2c.h>
> +#include <linux/log2.h>
> +#include <linux/mutex.h>
> +#include <linux/slab.h>
> +#include <linux/videodev2.h>
> +#include <linux/v4l2-mediabus.h>
> +#include <linux/module.h>
> +
> +#include <media/mt9v034.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-subdev.h>
> +
> +#define MT9V034_PIXEL_ARRAY_HEIGHT                     499
> +#define MT9V034_PIXEL_ARRAY_WIDTH                      809
> +
> +#define MT9V034_SYSCLK_FREQ_DEF                                26600000
> +
> +#define MT9V034_CHIP_VERSION                           0x00
> +#define                MT9V034_CHIP_ID_REV1                    0x1324
> +#define MT9V034_COLUMN_START                           0x01
> +#define                MT9V034_COLUMN_START_MIN                1
> +#define                MT9V034_COLUMN_START_DEF                1
> +#define                MT9V034_COLUMN_START_MAX                752
> +#define MT9V034_ROW_START                              0x02
> +#define                MT9V034_ROW_START_MIN                   4
> +#define                MT9V034_ROW_START_DEF                   4
> +#define                MT9V034_ROW_START_MAX                   482
> +#define MT9V034_WINDOW_HEIGHT                          0x03
> +#define                MT9V034_WINDOW_HEIGHT_MIN               1
> +#define                MT9V034_WINDOW_HEIGHT_DEF               480
> +#define                MT9V034_WINDOW_HEIGHT_MAX               480
> +#define MT9V034_WINDOW_WIDTH                           0x04
> +#define                MT9V034_WINDOW_WIDTH_MIN                1
> +#define                MT9V034_WINDOW_WIDTH_DEF                752
> +#define                MT9V034_WINDOW_WIDTH_MAX                752
> +#define MT9V034_HORIZONTAL_BLANKING                    0x05
> +#define                MT9V034_HORIZONTAL_BLANKING_MIN         61
> +#define                MT9V034_HORIZONTAL_BLANKING_DEF         94
> +#define                MT9V034_HORIZONTAL_BLANKING_MAX         1023
> +#define MT9V034_VERTICAL_BLANKING                      0x06
> +#define                MT9V034_VERTICAL_BLANKING_MIN           2
> +#define                MT9V034_VERTICAL_BLANKING_DEF           45
> +#define                MT9V034_VERTICAL_BLANKING_MAX           32288
> +#define MT9V034_CHIP_CONTROL                           0x07
> +#define                MT9V034_CHIP_CONTROL_MASTER_MODE        (1 << 3)
> +#define                MT9V034_CHIP_CONTROL_DOUT_ENABLE        (1 << 7)
> +#define                MT9V034_CHIP_CONTROL_SEQUENTIAL         (1 << 8)
> +#define MT9V034_SHUTTER_WIDTH1                         0x08
> +#define MT9V034_SHUTTER_WIDTH2                         0x09
> +#define MT9V034_SHUTTER_WIDTH_CONTROL                  0x0a
> +#define MT9V034_TOTAL_SHUTTER_WIDTH                    0x0b
> +#define                MT9V034_TOTAL_SHUTTER_WIDTH_MIN         0
> +#define                MT9V034_TOTAL_SHUTTER_WIDTH_DEF         480
> +#define                MT9V034_TOTAL_SHUTTER_WIDTH_MAX         32765
> +#define MT9V034_RESET                                  0x0c
> +#define MT9V034_READ_MODE                              0x0d
> +#define                MT9V034_READ_MODE_ROW_BIN_MASK          (3 << 0)
> +#define                MT9V034_READ_MODE_ROW_BIN_SHIFT         0
> +#define                MT9V034_READ_MODE_COLUMN_BIN_MASK       (3 << 2)
> +#define                MT9V034_READ_MODE_COLUMN_BIN_SHIFT      2
> +#define                MT9V034_READ_MODE_ROW_FLIP              (1 << 4)
> +#define                MT9V034_READ_MODE_COLUMN_FLIP           (1 << 5)
> +#define                MT9V034_READ_MODE_DARK_COLUMNS          (1 << 6)
> +#define                MT9V034_READ_MODE_DARK_ROWS             (1 << 7)
> +#define MT9V034_SENSOR_TYPE_CONTROL                    0x0f
> +#define                MT9V034_SENSOR_TYPE_MODE_COLOR          (1 << 1)
> +#define MT9V034_ANALOG_GAIN                            0x35
> +#define                MT9V034_ANALOG_GAIN_MIN                 16
> +#define                MT9V034_ANALOG_GAIN_DEF                 16
> +#define                MT9V034_ANALOG_GAIN_MAX                 64
> +#define MT9V034_ROW_NOISE_CORR_CONTROL                 0x70
> +#define        MT9V034_PIXEL_CLOCK                             0x72
> +#define                MT9V034_PIXEL_CLOCK_INV_LINE            (1 << 0)
> +#define                MT9V034_PIXEL_CLOCK_INV_FRAME           (1 << 1)
> +#define                MT9V034_PIXEL_CLOCK_XOR_LINE            (1 << 2)
> +#define                MT9V034_PIXEL_CLOCK_CONT_LINE           (1 << 3)
> +#define                MT9V034_PIXEL_CLOCK_INV_PXL_CLK         (1 << 4)
> +#define MT9V034_TEST_PATTERN                           0x7f
> +#define                MT9V034_TEST_PATTERN_DATA_MASK          (1023 << 0)
> +#define                MT9V034_TEST_PATTERN_DATA_SHIFT         0
> +#define                MT9V034_TEST_PATTERN_USE_DATA           (1 << 10)
> +#define                MT9V034_TEST_PATTERN_GRAY_MASK          (3 << 11)
> +#define                MT9V034_TEST_PATTERN_GRAY_NONE          (0 << 11)
> +#define                MT9V034_TEST_PATTERN_GRAY_VERTICAL      (1 << 11)
> +#define                MT9V034_TEST_PATTERN_GRAY_HORIZONTAL    (2 << 11)
> +#define                MT9V034_TEST_PATTERN_GRAY_DIAGONAL      (3 << 11)
> +#define                MT9V034_TEST_PATTERN_ENABLE             (1 << 13)
> +#define                MT9V034_TEST_PATTERN_FLIP               (1 << 14)
> +#define MT9V034_AEC_AGC_ENABLE                         0xaf
> +#define                MT9V034_AEC_ENABLE                      (1 << 0)
> +#define                MT9V034_AGC_ENABLE                      (1 << 1)
> +
> +struct mt9v034 {
> +       struct v4l2_subdev subdev;
> +       struct media_pad pad;
> +
> +       struct v4l2_mbus_framefmt format;
> +       struct v4l2_rect crop;
> +
> +       struct v4l2_ctrl_handler ctrls;
> +       struct {
> +               struct v4l2_ctrl *link_freq;
> +               struct v4l2_ctrl *pixel_rate;
> +       };
> +
> +       struct mutex power_lock;
> +       int power_count;
> +
> +       struct mt9v034_platform_data *pdata;
> +
> +       u32 sysclk;
> +       u16 chip_control;
> +       u16 aec_agc;
> +       u16 hblank;
> +};
> +
> +static struct mt9v034 *to_mt9v034(struct v4l2_subdev *sd)
> +{
> +       return container_of(sd, struct mt9v034, subdev);
> +}
> +
> +static int mt9v034_read(struct i2c_client *client, const u8 reg)
> +{
> +       s32 data = i2c_smbus_read_word_swapped(client, reg);
> +       dev_dbg(&client->dev, "%s: read 0x%04x from 0x%02x\n", __func__,
> +               data, reg);
> +       return data;
> +}
> +
> +static int mt9v034_write(struct i2c_client *client, const u8 reg,
> +                        const u16 data)
> +{
> +       dev_dbg(&client->dev, "%s: writing 0x%04x to 0x%02x\n", __func__,
> +               data, reg);
> +       return i2c_smbus_write_word_swapped(client, reg, data);
> +}
> +
> +static int mt9v034_set_chip_control(struct mt9v034 *mt9v034, u16 clear, u16 set)
> +{
> +       struct i2c_client *client = v4l2_get_subdevdata(&mt9v034->subdev);
> +       u16 value = (mt9v034->chip_control & ~clear) | set;
> +       int ret;
> +
> +       ret = mt9v034_write(client, MT9V034_CHIP_CONTROL, value);
> +       if (ret < 0)
> +               return ret;
> +
> +       mt9v034->chip_control = value;
> +       return 0;
> +}
> +
> +static int
> +mt9v034_update_aec_agc(struct mt9v034 *mt9v034, u16 which, int enable)
> +{
> +       struct i2c_client *client = v4l2_get_subdevdata(&mt9v034->subdev);
> +       u16 value = mt9v034->aec_agc;
> +       int ret;
> +
> +       if (enable)
> +               value |= which;
> +       else
> +               value &= ~which;
> +
> +       ret = mt9v034_write(client, MT9V034_AEC_AGC_ENABLE, value);
> +       if (ret < 0)
> +               return ret;
> +
> +       mt9v034->aec_agc = value;
> +       return 0;
> +}
> +
> +static int
> +mt9v034_update_hblank(struct mt9v034 *mt9v034)
> +{
> +       struct i2c_client *client = v4l2_get_subdevdata(&mt9v034->subdev);
> +       struct v4l2_rect *crop = &mt9v034->crop;
> +
> +       return mt9v034_write(client, MT9V034_HORIZONTAL_BLANKING,
> +                            max_t(s32, mt9v034->hblank, 690 - crop->width));
> +}
> +
> +static int mt9v034_power_on(struct mt9v034 *mt9v034)
> +{
> +       struct i2c_client *client = v4l2_get_subdevdata(&mt9v034->subdev);
> +       int ret;
> +
> +       if (mt9v034->pdata->set_clock) {
> +               mt9v034->pdata->set_clock(&mt9v034->subdev, mt9v034->sysclk);
> +               udelay(1);
> +       }
> +
> +       /* Reset the chip and stop data read out */
> +       ret = mt9v034_write(client, MT9V034_RESET, 1);
> +       if (ret < 0)
> +               return ret;
> +
> +       ret = mt9v034_write(client, MT9V034_RESET, 0);
> +       if (ret < 0)
> +               return ret;
> +
> +       return mt9v034_write(client, MT9V034_CHIP_CONTROL, 0);
> +}
> +
> +static void mt9v034_power_off(struct mt9v034 *mt9v034)
> +{
> +       if (mt9v034->pdata->set_clock)
> +               mt9v034->pdata->set_clock(&mt9v034->subdev, 0);
> +}
> +
> +static int __mt9v034_set_power(struct mt9v034 *mt9v034, bool on)
> +{
> +       struct i2c_client *client = v4l2_get_subdevdata(&mt9v034->subdev);
> +       int ret;
> +
> +       if (!on) {
> +               mt9v034_power_off(mt9v034);
> +               return 0;
> +       }
> +
> +       ret = mt9v034_power_on(mt9v034);
> +       if (ret < 0)
> +               return ret;
> +
> +       /* Configure the pixel clock polarity */
> +       if (mt9v034->pdata && mt9v034->pdata->clk_pol) {
> +               ret = mt9v034_write(client, MT9V034_PIXEL_CLOCK,
> +                               MT9V034_PIXEL_CLOCK_INV_PXL_CLK);
> +               if (ret < 0)
> +                       return ret;
> +       }
> +
> +       return v4l2_ctrl_handler_setup(&mt9v034->ctrls);
> +}
> +
> +/* -----------------------------------------------------------------------------
> + * V4L2 subdev video operations
> + */
> +
> +static struct v4l2_mbus_framefmt *
> +__mt9v034_get_pad_format(struct mt9v034 *mt9v034, struct v4l2_subdev_fh *fh,
> +                        unsigned int pad, enum v4l2_subdev_format_whence which)
> +{
> +       switch (which) {
> +       case V4L2_SUBDEV_FORMAT_TRY:
> +               return v4l2_subdev_get_try_format(fh, pad);
> +       case V4L2_SUBDEV_FORMAT_ACTIVE:
> +               return &mt9v034->format;
> +       default:
> +               return NULL;
> +       }
> +}
> +
> +static struct v4l2_rect *
> +__mt9v034_get_pad_crop(struct mt9v034 *mt9v034, struct v4l2_subdev_fh *fh,
> +                      unsigned int pad, enum v4l2_subdev_format_whence which)
> +{
> +       switch (which) {
> +       case V4L2_SUBDEV_FORMAT_TRY:
> +               return v4l2_subdev_get_try_crop(fh, pad);
> +       case V4L2_SUBDEV_FORMAT_ACTIVE:
> +               return &mt9v034->crop;
> +       default:
> +               return NULL;
> +       }
> +}
> +
> +static int mt9v034_s_stream(struct v4l2_subdev *subdev, int enable)
> +{
> +       const u16 mode = MT9V034_CHIP_CONTROL_MASTER_MODE
> +                      | MT9V034_CHIP_CONTROL_DOUT_ENABLE
> +                      | MT9V034_CHIP_CONTROL_SEQUENTIAL;
> +       struct i2c_client *client = v4l2_get_subdevdata(subdev);
> +       struct mt9v034 *mt9v034 = to_mt9v034(subdev);
> +       struct v4l2_mbus_framefmt *format = &mt9v034->format;
> +       struct v4l2_rect *crop = &mt9v034->crop;
> +       unsigned int hratio;
> +       unsigned int vratio;
> +       int ret;
> +
> +       if (!enable)
> +               return mt9v034_set_chip_control(mt9v034, mode, 0);
> +
> +       /* Configure the window size and row/column bin */
> +       hratio = DIV_ROUND_CLOSEST(crop->width, format->width);
> +       vratio = DIV_ROUND_CLOSEST(crop->height, format->height);
> +
> +       ret = mt9v034_write(client, MT9V034_READ_MODE,
> +                   (hratio - 1) << MT9V034_READ_MODE_ROW_BIN_SHIFT |
> +                   (vratio - 1) << MT9V034_READ_MODE_COLUMN_BIN_SHIFT);
> +       if (ret < 0)
> +               return ret;
> +
> +       ret = mt9v034_write(client, MT9V034_COLUMN_START, crop->left);
> +       if (ret < 0)
> +               return ret;
> +
> +       ret = mt9v034_write(client, MT9V034_ROW_START, crop->top);
> +       if (ret < 0)
> +               return ret;
> +
> +       ret = mt9v034_write(client, MT9V034_WINDOW_WIDTH, crop->width);
> +       if (ret < 0)
> +               return ret;
> +
> +       ret = mt9v034_write(client, MT9V034_WINDOW_HEIGHT, crop->height);
> +       if (ret < 0)
> +               return ret;
> +
> +       ret = mt9v034_update_hblank(mt9v034);
> +       if (ret < 0)
> +               return ret;
> +
> +       /* Switch to master "normal" mode */
> +       return mt9v034_set_chip_control(mt9v034, 0, mode);
> +}
> +
> +static int mt9v034_enum_mbus_code(struct v4l2_subdev *subdev,
> +                                 struct v4l2_subdev_fh *fh,
> +                                 struct v4l2_subdev_mbus_code_enum *code)
> +{
> +       if (code->index > 0)
> +               return -EINVAL;
> +
> +       code->code = V4L2_MBUS_FMT_SBGGR10_1X10;
> +       return 0;
> +}
> +
> +static int mt9v034_enum_frame_size(struct v4l2_subdev *subdev,
> +                                  struct v4l2_subdev_fh *fh,
> +                                  struct v4l2_subdev_frame_size_enum *fse)
> +{
> +       if (fse->index >= 8 || fse->code != V4L2_MBUS_FMT_SBGGR10_1X10)
> +               return -EINVAL;
> +
> +       fse->min_width = MT9V034_WINDOW_WIDTH_DEF / fse->index;
> +       fse->max_width = fse->min_width;
> +       fse->min_height = MT9V034_WINDOW_HEIGHT_DEF / fse->index;
> +       fse->max_height = fse->min_height;
> +
> +       return 0;
> +}
> +
> +static int mt9v034_get_format(struct v4l2_subdev *subdev,
> +                             struct v4l2_subdev_fh *fh,
> +                             struct v4l2_subdev_format *format)
> +{
> +       struct mt9v034 *mt9v034 = to_mt9v034(subdev);
> +
> +       format->format = *__mt9v034_get_pad_format(mt9v034, fh, format->pad,
> +                                                  format->which);
> +       return 0;
> +}
> +
> +static void mt9v034_configure_pixel_rate(struct mt9v034 *mt9v034,
> +                                        unsigned int hratio)
> +{
> +       struct i2c_client *client = v4l2_get_subdevdata(&mt9v034->subdev);
> +       int ret;
> +
> +       ret = v4l2_ctrl_s_ctrl_int64(mt9v034->pixel_rate,
> +                                    mt9v034->sysclk / hratio);
> +       if (ret < 0)
> +               dev_warn(&client->dev, "failed to set pixel rate (%d)\n", ret);
> +}
> +
> +static int mt9v034_set_format(struct v4l2_subdev *subdev,
> +                             struct v4l2_subdev_fh *fh,
> +                             struct v4l2_subdev_format *format)
> +{
> +       struct mt9v034 *mt9v034 = to_mt9v034(subdev);
> +       struct v4l2_mbus_framefmt *__format;
> +       struct v4l2_rect *__crop;
> +       unsigned int width;
> +       unsigned int height;
> +       unsigned int hratio;
> +       unsigned int vratio;
> +
> +       __crop = __mt9v034_get_pad_crop(mt9v034, fh, format->pad,
> +                                       format->which);
> +
> +       /* Clamp the width and height to avoid dividing by zero. */
> +       width = clamp_t(unsigned int, ALIGN(format->format.width, 2),
> +                       max(__crop->width / 8, MT9V034_WINDOW_WIDTH_MIN),
> +                       __crop->width);
> +       height = clamp_t(unsigned int, ALIGN(format->format.height, 2),
> +                        max(__crop->height / 8, MT9V034_WINDOW_HEIGHT_MIN),
> +                        __crop->height);
> +
> +       hratio = DIV_ROUND_CLOSEST(__crop->width, width);
> +       vratio = DIV_ROUND_CLOSEST(__crop->height, height);
> +
> +       __format = __mt9v034_get_pad_format(mt9v034, fh, format->pad,
> +                                           format->which);
> +       __format->width = __crop->width / hratio;
> +       __format->height = __crop->height / vratio;
> +       if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
> +               mt9v034_configure_pixel_rate(mt9v034, hratio);
> +
> +       format->format = *__format;
> +
> +       return 0;
> +}
> +
> +static int mt9v034_get_crop(struct v4l2_subdev *subdev,
> +                           struct v4l2_subdev_fh *fh,
> +                           struct v4l2_subdev_crop *crop)
> +{
> +       struct mt9v034 *mt9v034 = to_mt9v034(subdev);
> +
> +       crop->rect = *__mt9v034_get_pad_crop(mt9v034, fh, crop->pad,
> +                                            crop->which);
> +       return 0;
> +}
> +
> +static int mt9v034_set_crop(struct v4l2_subdev *subdev,
> +                           struct v4l2_subdev_fh *fh,
> +                           struct v4l2_subdev_crop *crop)
> +{
> +       struct mt9v034 *mt9v034 = to_mt9v034(subdev);
> +       struct v4l2_mbus_framefmt *__format;
> +       struct v4l2_rect *__crop;
> +       struct v4l2_rect rect;
> +
> +       /* Clamp the crop rectangle boundaries and align them to a multiple
> +        * of 2 pixels to ensure a BGGR Bayer pattern.
> +        */
> +       rect.left = clamp(ALIGN(crop->rect.left, 2) - 1,
> +                         MT9V034_COLUMN_START_MIN,
> +                         MT9V034_COLUMN_START_MAX);
> +       rect.top = clamp(ALIGN(crop->rect.top, 2) - 1,
> +                        MT9V034_ROW_START_MIN,
> +                        MT9V034_ROW_START_MAX);
> +       rect.width = clamp(ALIGN(crop->rect.width, 2),
> +                          MT9V034_WINDOW_WIDTH_MIN,
> +                          MT9V034_WINDOW_WIDTH_MAX);
> +       rect.height = clamp(ALIGN(crop->rect.height, 2),
> +                           MT9V034_WINDOW_HEIGHT_MIN,
> +                           MT9V034_WINDOW_HEIGHT_MAX);
> +
> +       rect.width = min(rect.width, MT9V034_PIXEL_ARRAY_WIDTH - rect.left);
> +       rect.height = min(rect.height, MT9V034_PIXEL_ARRAY_HEIGHT - rect.top);
> +
> +       __crop = __mt9v034_get_pad_crop(mt9v034, fh, crop->pad, crop->which);
> +
> +       if (rect.width != __crop->width || rect.height != __crop->height) {
> +               /* Reset the output image size if the crop rectangle size has
> +                * been modified.
> +                */
> +               __format = __mt9v034_get_pad_format(mt9v034, fh, crop->pad,
> +                                                   crop->which);
> +               __format->width = rect.width;
> +               __format->height = rect.height;
> +               if (crop->which == V4L2_SUBDEV_FORMAT_ACTIVE)
> +                       mt9v034_configure_pixel_rate(mt9v034, 1);
> +       }
> +
> +       *__crop = rect;
> +       crop->rect = rect;
> +
> +       return 0;
> +}
> +
> +/* -----------------------------------------------------------------------------
> + * V4L2 subdev control operations
> + */
> +
> +#define V4L2_CID_TEST_PATTERN          (V4L2_CID_USER_BASE | 0x1001)
> +
> +static int mt9v034_s_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +       struct mt9v034 *mt9v034 =
> +                       container_of(ctrl->handler, struct mt9v034, ctrls);
> +       struct i2c_client *client = v4l2_get_subdevdata(&mt9v034->subdev);
> +       u32 freq;
> +       u16 data;
> +
> +       switch (ctrl->id) {
> +       case V4L2_CID_AUTOGAIN:
> +               return mt9v034_update_aec_agc(mt9v034, MT9V034_AGC_ENABLE,
> +                                             ctrl->val);
> +
> +       case V4L2_CID_GAIN:
> +               return mt9v034_write(client, MT9V034_ANALOG_GAIN, ctrl->val);
> +
> +       case V4L2_CID_EXPOSURE_AUTO:
> +               return mt9v034_update_aec_agc(mt9v034, MT9V034_AEC_ENABLE,
> +                                             !ctrl->val);
> +
> +       case V4L2_CID_EXPOSURE:
> +               return mt9v034_write(client, MT9V034_TOTAL_SHUTTER_WIDTH,
> +                                    ctrl->val);
> +
> +       case V4L2_CID_HBLANK:
> +               mt9v034->hblank = ctrl->val;
> +               return mt9v034_update_hblank(mt9v034);
> +
> +       case V4L2_CID_VBLANK:
> +               return mt9v034_write(client, MT9V034_VERTICAL_BLANKING,
> +                                    ctrl->val);
> +
> +       case V4L2_CID_PIXEL_RATE:
> +       case V4L2_CID_LINK_FREQ:
> +               if (mt9v034->link_freq == NULL)
> +                       break;
> +
> +               freq = mt9v034->pdata->link_freqs[mt9v034->link_freq->val];
> +               mt9v034->pixel_rate->val64 = freq;
> +               mt9v034->sysclk = freq;
> +               break;
> +
> +       case V4L2_CID_TEST_PATTERN:
> +               switch (ctrl->val) {
> +               case 0:
> +                       data = 0;
> +                       break;
> +               case 1:
> +                       data = MT9V034_TEST_PATTERN_GRAY_VERTICAL
> +                            | MT9V034_TEST_PATTERN_ENABLE;
> +                       break;
> +               case 2:
> +                       data = MT9V034_TEST_PATTERN_GRAY_HORIZONTAL
> +                            | MT9V034_TEST_PATTERN_ENABLE;
> +                       break;
> +               case 3:
> +                       data = MT9V034_TEST_PATTERN_GRAY_DIAGONAL
> +                            | MT9V034_TEST_PATTERN_ENABLE;
> +                       break;
> +               default:
> +                       data = (ctrl->val << MT9V034_TEST_PATTERN_DATA_SHIFT)
> +                            | MT9V034_TEST_PATTERN_USE_DATA
> +                            | MT9V034_TEST_PATTERN_ENABLE
> +                            | MT9V034_TEST_PATTERN_FLIP;
> +                       break;
> +               }
> +
> +               return mt9v034_write(client, MT9V034_TEST_PATTERN, data);
> +       }
> +
> +       return 0;
> +}
> +
> +static struct v4l2_ctrl_ops mt9v034_ctrl_ops = {
> +       .s_ctrl = mt9v034_s_ctrl,
> +};
> +
> +static const struct v4l2_ctrl_config mt9v034_ctrls[] = {
> +       {
> +               .ops            = &mt9v034_ctrl_ops,
> +               .id             = V4L2_CID_TEST_PATTERN,
> +               .type           = V4L2_CTRL_TYPE_INTEGER,
> +               .name           = "Test pattern",
> +               .min            = 0,
> +               .max            = 1023,
> +               .step           = 1,
> +               .def            = 0,
> +               .flags          = 0,
> +       }
> +};
> +
> +/* -----------------------------------------------------------------------------
> + * V4L2 subdev core operations
> + */
> +
> +static int mt9v034_set_power(struct v4l2_subdev *subdev, int on)
> +{
> +       struct mt9v034 *mt9v034 = to_mt9v034(subdev);
> +       int ret = 0;
> +
> +       mutex_lock(&mt9v034->power_lock);
> +
> +       /* If the power count is modified from 0 to != 0 or from != 0 to 0,
> +        * update the power state.
> +        */
> +       if (mt9v034->power_count == !on) {
> +               ret = __mt9v034_set_power(mt9v034, !!on);
> +               if (ret < 0)
> +                       goto done;
> +       }
> +
> +       /* Update the power count. */
> +       mt9v034->power_count += on ? 1 : -1;
> +       WARN_ON(mt9v034->power_count < 0);
> +
> +done:
> +       mutex_unlock(&mt9v034->power_lock);
> +       return ret;
> +}
> +
> +/* -----------------------------------------------------------------------------
> + * V4L2 subdev internal operations
> + */
> +
> +static int mt9v034_registered(struct v4l2_subdev *subdev)
> +{
> +       struct i2c_client *client = v4l2_get_subdevdata(subdev);
> +       struct mt9v034 *mt9v034 = to_mt9v034(subdev);
> +       s32 data;
> +       int ret;
> +
> +       dev_info(&client->dev, "Probing MT9V034 at address 0x%02x\n",
> +                       client->addr);
> +
> +       ret = mt9v034_power_on(mt9v034);
> +       if (ret < 0) {
> +               dev_err(&client->dev, "MT9V034 power up failed\n");
> +               return ret;
> +       }
> +
> +       /* Read and check the sensor version */
> +       data = mt9v034_read(client, MT9V034_CHIP_VERSION);
> +       if (data != MT9V034_CHIP_ID_REV1) {
> +               dev_err(&client->dev,
> +                       "MT9V034 not detected, wrong version 0x%04x\n", data);
> +               return -ENODEV;
> +       }
> +
> +       mt9v034_power_off(mt9v034);
> +
> +       dev_info(&client->dev, "MT9V034 detected at address 0x%02x\n",
> +                       client->addr);
> +
> +       mt9v034_configure_pixel_rate(mt9v034, 1);
> +
> +       return ret;
> +}
> +
> +static int mt9v034_open(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh)
> +{
> +       struct v4l2_mbus_framefmt *format;
> +       struct v4l2_rect *crop;
> +
> +       crop = v4l2_subdev_get_try_crop(fh, 0);
> +       crop->left = MT9V034_COLUMN_START_DEF;
> +       crop->top = MT9V034_ROW_START_DEF;
> +       crop->width = MT9V034_WINDOW_WIDTH_DEF;
> +       crop->height = MT9V034_WINDOW_HEIGHT_DEF;
> +
> +       format = v4l2_subdev_get_try_format(fh, 0);
> +
> +       format->code = V4L2_MBUS_FMT_SBGGR10_1X10;
> +       format->width = MT9V034_WINDOW_WIDTH_DEF;
> +       format->height = MT9V034_WINDOW_HEIGHT_DEF;
> +       format->field = V4L2_FIELD_NONE;
> +       format->colorspace = V4L2_COLORSPACE_SRGB;
> +
> +       return mt9v034_set_power(subdev, 1);
> +}
> +
> +static int mt9v034_close(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh)
> +{
> +       return mt9v034_set_power(subdev, 0);
> +}
> +
> +static struct v4l2_subdev_core_ops mt9v034_subdev_core_ops = {
> +       .s_power        = mt9v034_set_power,
> +};
> +
> +static struct v4l2_subdev_video_ops mt9v034_subdev_video_ops = {
> +       .s_stream       = mt9v034_s_stream,
> +};
> +
> +static struct v4l2_subdev_pad_ops mt9v034_subdev_pad_ops = {
> +       .enum_mbus_code = mt9v034_enum_mbus_code,
> +       .enum_frame_size = mt9v034_enum_frame_size,
> +       .get_fmt = mt9v034_get_format,
> +       .set_fmt = mt9v034_set_format,
> +       .get_crop = mt9v034_get_crop,
> +       .set_crop = mt9v034_set_crop,
> +};
> +
> +static struct v4l2_subdev_ops mt9v034_subdev_ops = {
> +       .core   = &mt9v034_subdev_core_ops,
> +       .video  = &mt9v034_subdev_video_ops,
> +       .pad    = &mt9v034_subdev_pad_ops,
> +};
> +
> +static const struct v4l2_subdev_internal_ops mt9v034_subdev_internal_ops = {
> +       .registered = mt9v034_registered,
> +       .open = mt9v034_open,
> +       .close = mt9v034_close,
> +};
> +
> +/* -----------------------------------------------------------------------------
> + * Driver initialization and probing
> + */
> +
> +static int mt9v034_probe(struct i2c_client *client,
> +               const struct i2c_device_id *did)
> +{
> +       struct mt9v034_platform_data *pdata = client->dev.platform_data;
> +       struct mt9v034 *mt9v034;
> +       unsigned int i;
> +       int ret;
> +
> +       if (!i2c_check_functionality(client->adapter,
> +                                    I2C_FUNC_SMBUS_WORD_DATA)) {
> +               dev_warn(&client->adapter->dev,
> +                        "I2C-Adapter doesn't support I2C_FUNC_SMBUS_WORD\n");
> +               return -EIO;
> +       }
> +
> +       mt9v034 = kzalloc(sizeof(*mt9v034), GFP_KERNEL);
> +       if (!mt9v034)
> +               return -ENOMEM;
> +
> +       mutex_init(&mt9v034->power_lock);
> +       mt9v034->pdata = pdata;
> +
> +       v4l2_ctrl_handler_init(&mt9v034->ctrls, ARRAY_SIZE(mt9v034_ctrls) + 8);
> +
> +       v4l2_ctrl_new_std(&mt9v034->ctrls, &mt9v034_ctrl_ops,
> +                         V4L2_CID_AUTOGAIN, 0, 1, 1, 1);
> +       v4l2_ctrl_new_std(&mt9v034->ctrls, &mt9v034_ctrl_ops,
> +                         V4L2_CID_GAIN, MT9V034_ANALOG_GAIN_MIN,
> +                         MT9V034_ANALOG_GAIN_MAX, 1, MT9V034_ANALOG_GAIN_DEF);
> +       v4l2_ctrl_new_std_menu(&mt9v034->ctrls, &mt9v034_ctrl_ops,
> +                              V4L2_CID_EXPOSURE_AUTO, V4L2_EXPOSURE_MANUAL, 0,
> +                              V4L2_EXPOSURE_AUTO);
> +       v4l2_ctrl_new_std(&mt9v034->ctrls, &mt9v034_ctrl_ops,
> +                         V4L2_CID_EXPOSURE, MT9V034_TOTAL_SHUTTER_WIDTH_MIN,
> +                         MT9V034_TOTAL_SHUTTER_WIDTH_MAX, 1,
> +                         MT9V034_TOTAL_SHUTTER_WIDTH_DEF);
> +       v4l2_ctrl_new_std(&mt9v034->ctrls, &mt9v034_ctrl_ops,
> +                         V4L2_CID_HBLANK, MT9V034_HORIZONTAL_BLANKING_MIN,
> +                         MT9V034_HORIZONTAL_BLANKING_MAX, 1,
> +                         MT9V034_HORIZONTAL_BLANKING_DEF);
> +       v4l2_ctrl_new_std(&mt9v034->ctrls, &mt9v034_ctrl_ops,
> +                         V4L2_CID_VBLANK, MT9V034_VERTICAL_BLANKING_MIN,
> +                         MT9V034_VERTICAL_BLANKING_MAX, 1,
> +                         MT9V034_VERTICAL_BLANKING_DEF);
> +
> +       mt9v034->pixel_rate =
> +               v4l2_ctrl_new_std(&mt9v034->ctrls, &mt9v034_ctrl_ops,
> +                                 V4L2_CID_PIXEL_RATE, 0, 0, 1, 0);
> +
> +       if (pdata && pdata->link_freqs) {
> +               unsigned int def = 0;
> +
> +               for (i = 0; pdata->link_freqs[i]; ++i) {
> +                       if (pdata->link_freqs[i] == pdata->link_def_freq)
> +                               def = i;
> +               }
> +
> +               mt9v034->link_freq =
> +                       v4l2_ctrl_new_int_menu(&mt9v034->ctrls,
> +                                              &mt9v034_ctrl_ops,
> +                                              V4L2_CID_LINK_FREQ, i - 1, def,
> +                                              pdata->link_freqs);
> +               v4l2_ctrl_cluster(2, &mt9v034->link_freq);
> +       }
> +
> +       for (i = 0; i < ARRAY_SIZE(mt9v034_ctrls); ++i)
> +               v4l2_ctrl_new_custom(&mt9v034->ctrls, &mt9v034_ctrls[i], NULL);
> +
> +       mt9v034->subdev.ctrl_handler = &mt9v034->ctrls;
> +
> +       if (mt9v034->ctrls.error)
> +               pr_info("%s: control initialization error %d\n",
> +                      __func__, mt9v034->ctrls.error);

Shouldn't you stop here if you can't initialize control, put error
message (not info) and go on cleanup path?


> +       mt9v034->crop.left = MT9V034_COLUMN_START_DEF;
> +       mt9v034->crop.top = MT9V034_ROW_START_DEF;
> +       mt9v034->crop.width = MT9V034_WINDOW_WIDTH_DEF;
> +       mt9v034->crop.height = MT9V034_WINDOW_HEIGHT_DEF;
> +
> +       mt9v034->format.code = V4L2_MBUS_FMT_SBGGR10_1X10;
> +       mt9v034->format.width = MT9V034_WINDOW_WIDTH_DEF;
> +       mt9v034->format.height = MT9V034_WINDOW_HEIGHT_DEF;
> +       mt9v034->format.field = V4L2_FIELD_NONE;
> +       mt9v034->format.colorspace = V4L2_COLORSPACE_SRGB;
> +
> +       mt9v034->aec_agc = MT9V034_AEC_ENABLE | MT9V034_AGC_ENABLE;
> +       mt9v034->hblank = MT9V034_HORIZONTAL_BLANKING_DEF;
> +       mt9v034->sysclk = MT9V034_SYSCLK_FREQ_DEF;
> +
> +       v4l2_i2c_subdev_init(&mt9v034->subdev, client, &mt9v034_subdev_ops);
> +       mt9v034->subdev.internal_ops = &mt9v034_subdev_internal_ops;
> +       mt9v034->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> +
> +       mt9v034->pad.flags = MEDIA_PAD_FL_SOURCE;
> +       ret = media_entity_init(&mt9v034->subdev.entity, 1, &mt9v034->pad, 0);
> +       if (ret < 0)
> +               kfree(mt9v034);

Do you need v4l2_ctrl_handler_free(&mt9v034->ctrls) on error path
here? Maybe error paths can be rethinked.


> +
> +       return ret;
> +}
> +
> +static int mt9v034_remove(struct i2c_client *client)
> +{
> +       struct v4l2_subdev *subdev = i2c_get_clientdata(client);
> +       struct mt9v034 *mt9v034 = to_mt9v034(subdev);
> +
> +       v4l2_device_unregister_subdev(subdev);
> +       media_entity_cleanup(&subdev->entity);
> +       kfree(mt9v034);
> +       return 0;
> +}

And may be v4l2_ctrl_handler_free(&mt9v034->ctrls) in _remove() is needed?

It looks like mt9v032.c (basis for your driver) has the same
behaviour. I'm not sure but may be _probe() and _remove() in mt9v032.c
also should be checked.

-- 
Best regards, Klimov Alexey
