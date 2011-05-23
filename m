Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:64503 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab1EWIUv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2011 04:20:51 -0400
Received: by iwn34 with SMTP id 34so4557656iwn.19
        for <linux-media@vger.kernel.org>; Mon, 23 May 2011 01:20:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1105211334260.25424@axis700.grange>
References: <1305899272-31839-1-git-send-email-javier.martin@vista-silicon.com>
	<Pine.LNX.4.64.1105211334260.25424@axis700.grange>
Date: Mon, 23 May 2011 10:20:50 +0200
Message-ID: <BANLkTinjNUVH4pvxsKos=wTd0fCB-2zz2A@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] MT9P031: Add support for Aptina mt9p031 sensor.
From: javier Martin <javier.martin@vista-silicon.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	carlighting@yahoo.co.nz, beagleboard@googlegroups.com,
	linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 21 May 2011 17:29, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> On Fri, 20 May 2011, Javier Martin wrote:
>
>> This driver adds basic support for Aptina mt9p031 sensor.
>>
>> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
>> ---
>>  drivers/media/video/Kconfig   |    8 +
>>  drivers/media/video/Makefile  |    1 +
>>  drivers/media/video/mt9p031.c |  751 +++++++++++++++++++++++++++++++++++++++++
>>  include/media/mt9p031.h       |   11 +
>>  4 files changed, 771 insertions(+), 0 deletions(-)
>>  create mode 100644 drivers/media/video/mt9p031.c
>>  create mode 100644 include/media/mt9p031.h
>>
>> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
>> index 00f51dd..5c96b89 100644
>> --- a/drivers/media/video/Kconfig
>> +++ b/drivers/media/video/Kconfig
>> @@ -329,6 +329,14 @@ config VIDEO_OV7670
>>         OV7670 VGA camera.  It currently only works with the M88ALP01
>>         controller.
>>
>> +config VIDEO_MT9P031
>> +     tristate "Aptina MT9P031 support"
>> +     depends on I2C && VIDEO_V4L2
>> +     ---help---
>> +       This driver supports MT9P031 cameras from Micron
>> +       This is a Video4Linux2 sensor-level driver for the Micron
>> +       mt0p031 5 Mpixel camera.
>
> Two sentences seem to repeat the same with other words, and it's better to
> stay consistent: just use Aptina everywhere, maybe put Micron in brackets
> at one location.
>

OK, I will fix it.

>> +
>>  config VIDEO_MT9V011
>>       tristate "Micron mt9v011 sensor support"
>>       depends on I2C && VIDEO_V4L2
>> diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
>> index ace5d8b..912b29b 100644
>> --- a/drivers/media/video/Makefile
>> +++ b/drivers/media/video/Makefile
>> @@ -65,6 +65,7 @@ obj-$(CONFIG_VIDEO_UPD64083) += upd64083.o
>>  obj-$(CONFIG_VIDEO_OV7670)   += ov7670.o
>>  obj-$(CONFIG_VIDEO_TCM825X) += tcm825x.o
>>  obj-$(CONFIG_VIDEO_TVEEPROM) += tveeprom.o
>> +obj-$(CONFIG_VIDEO_MT9P031) += mt9p031.o
>>  obj-$(CONFIG_VIDEO_MT9V011) += mt9v011.o
>>  obj-$(CONFIG_VIDEO_SR030PC30)        += sr030pc30.o
>>  obj-$(CONFIG_VIDEO_NOON010PC30)      += noon010pc30.o
>> diff --git a/drivers/media/video/mt9p031.c b/drivers/media/video/mt9p031.c
>> new file mode 100644
>> index 0000000..e406b64
>> --- /dev/null
>> +++ b/drivers/media/video/mt9p031.c
>> @@ -0,0 +1,751 @@
>> +/*
>> + * Driver for MT9P031 CMOS Image Sensor from Aptina
>> + *
>> + * Copyright (C) 2011, Javier Martin <javier.martin@vista-silicon.com>
>> + *
>> + * Copyright (C) 2011, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>> + *
>> + * Based on the MT9V032 driver and Bastian Hecht's code.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#include <linux/delay.h>
>> +#include <linux/device.h>
>> +#include <linux/i2c.h>
>> +#include <linux/log2.h>
>> +#include <linux/pm.h>
>> +#include <linux/regulator/consumer.h>
>> +#include <linux/slab.h>
>> +#include <media/v4l2-subdev.h>
>> +#include <linux/videodev2.h>
>> +
>> +#include <media/mt9p031.h>
>> +#include <media/v4l2-chip-ident.h>
>> +#include <media/v4l2-subdev.h>
>> +#include <media/v4l2-device.h>
>> +
>> +/* mt9p031 selected register addresses */
>> +#define MT9P031_CHIP_VERSION                 0x00
>> +#define              MT9P031_CHIP_VERSION_VALUE      0x1801
>> +#define MT9P031_ROW_START                    0x01
>
> Don't mix spaces and TABs between "#define" and the macro - just use one
> space everywhere.
>

I've done this in order to follow Laurent's directions. He does the
same in mt9v032 driver.
So, unless Laurent and you agree I think I won't change it.

>
>> +#define              MT9P031_ROW_START_SKIP          54
>> +#define MT9P031_COLUMN_START                 0x02
>> +#define              MT9P031_COLUMN_START_SKIP       16
>> +#define MT9P031_WINDOW_HEIGHT                        0x03
>> +#define MT9P031_WINDOW_WIDTH                 0x04
>> +#define MT9P031_H_BLANKING                   0x05
>> +#define              MT9P031_H_BLANKING_VALUE        0
>> +#define MT9P031_V_BLANKING                   0x06
>> +#define              MT9P031_V_BLANKING_VALUE        25
>> +#define MT9P031_OUTPUT_CONTROL                       0x07
>> +#define              MT9P031_OUTPUT_CONTROL_CEN      2
>> +#define              MT9P031_OUTPUT_CONTROL_SYN      1
>> +#define MT9P031_SHUTTER_WIDTH_UPPER          0x08
>> +#define MT9P031_SHUTTER_WIDTH                        0x09
>> +#define MT9P031_PIXEL_CLOCK_CONTROL          0x0a
>> +#define MT9P031_FRAME_RESTART                        0x0b
>> +#define MT9P031_SHUTTER_DELAY                        0x0c
>> +#define MT9P031_RST                          0x0d
>> +#define              MT9P031_RST_ENABLE              1
>> +#define              MT9P031_RST_DISABLE             0
>> +#define MT9P031_READ_MODE_1                  0x1e
>> +#define MT9P031_READ_MODE_2                  0x20
>> +#define              MT9P031_READ_MODE_2_ROW_MIR     0x8000
>> +#define              MT9P031_READ_MODE_2_COL_MIR     0x4000
>> +#define MT9P031_ROW_ADDRESS_MODE             0x22
>> +#define MT9P031_COLUMN_ADDRESS_MODE          0x23
>> +#define MT9P031_GLOBAL_GAIN                  0x35
>> +
>> +#define MT9P031_MAX_HEIGHT                   1944
>> +#define MT9P031_MAX_WIDTH                    2592
>> +#define MT9P031_MIN_HEIGHT                   2
>> +#define MT9P031_MIN_WIDTH                    18
>> +
>> +struct mt9p031 {
>> +     struct v4l2_subdev subdev;
>> +     struct media_pad pad;
>> +     struct v4l2_rect rect;  /* Sensor window */
>> +     struct v4l2_mbus_framefmt format;
>> +     struct mt9p031_platform_data *pdata;
>> +     struct mutex power_lock;
>
> Don't locks _always_ have to be documented? And this one: you only protect
> set_power() with it, Laurent, is this correct?
>

Just following the model Laurent applies in mt9v032. Let's see what he
has to say about this.

>
>> +     int power_count;
>> +     u16 xskip;
>> +     u16 yskip;
>> +     u16 output_control;
>> +     struct regulator *reg_1v8;
>> +     struct regulator *reg_2v8;
>> +};
>> +
>> +static struct mt9p031 *to_mt9p031(const struct i2c_client *client)
>> +{
>> +     return container_of(i2c_get_clientdata(client), struct mt9p031, subdev);
>> +}
>> +
>> +static int reg_read(struct i2c_client *client, const u8 reg)
>> +{
>> +     s32 data = i2c_smbus_read_word_data(client, reg);
>> +     return data < 0 ? data : swab16(data);
>> +}
>> +
>> +static int reg_write(struct i2c_client *client, const u8 reg,
>> +                     const u16 data)
>> +{
>> +     return i2c_smbus_write_word_data(client, reg, swab16(data));
>> +}
>> +
>> +static int mt9p031_set_output_control(struct mt9p031 *mt9p031, u16 clear,
>> +                                   u16 set)
>> +{
>> +     struct i2c_client *client = v4l2_get_subdevdata(&mt9p031->subdev);
>> +     u16 value = (mt9p031->output_control & ~clear) | set;
>> +     int ret;
>> +
>> +     ret = reg_write(client, MT9P031_OUTPUT_CONTROL, value);
>> +     if (ret < 0)
>> +             return ret;
>> +
>> +     mt9p031->output_control = value;
>> +     return 0;
>> +}
>> +
>> +static int mt9p031_reset(struct i2c_client *client)
>> +{
>> +     struct mt9p031 *mt9p031 = to_mt9p031(client);
>> +     int ret;
>> +
>> +     /* Disable chip output, synchronous option update */
>> +     ret = reg_write(client, MT9P031_RST, MT9P031_RST_ENABLE);
>> +     if (ret < 0)
>> +             return -EIO;
>> +     ret = reg_write(client, MT9P031_RST, MT9P031_RST_DISABLE);
>> +     if (ret < 0)
>> +             return -EIO;
>> +     ret = mt9p031_set_output_control(mt9p031, MT9P031_OUTPUT_CONTROL_CEN, 0);
>> +     if (ret < 0)
>> +             return -EIO;
>> +     return 0;
>
>
> I think, a sequence like
>
>        ret = fn();
>        if (!ret)
>                ret = fn();
>        if (!ret)
>                ret = fn();
>        return ret;
>
> is a better way to achieve the same.
>

Sorry, but I have to disagree. I understand what you want to achieve
but this seems quite tricky to me.
I explicitly changed parts of the code that were written using that
style because I think It was better understandable.


>> +}
>> +
>> +static int mt9p031_power_on(struct mt9p031 *mt9p031)
>> +{
>> +     int ret;
>> +
>> +     /* turn on VDD_IO */
>> +     ret = regulator_enable(mt9p031->reg_2v8);
>> +     if (ret) {
>> +             pr_err("Failed to enable 2.8v regulator: %d\n", ret);
>
> dev_err()

ok

>> +             return ret;
>> +     }

[snip]

>> +
>> +     pr_info("%s(%ux%u@%u:%u : %u)\n", __func__,
>> +                     crop->rect.width, crop->rect.height,
>> +                     crop->rect.left, crop->rect.top, crop->which);
>
> dev_dbg()

ok

>> +
>> +     /*
>> +      * Clamp the crop rectangle boundaries and align them to a multiple of 2
>> +      * pixels.
>> +      */
>> +     rect.width = ALIGN(clamp(crop->rect.width,
>> +                              MT9P031_MIN_WIDTH, MT9P031_MAX_WIDTH), 2);
>> +     rect.height = ALIGN(clamp(crop->rect.height,
>> +                               MT9P031_MIN_HEIGHT, MT9P031_MAX_HEIGHT), 2);
>> +     rect.left = ALIGN(clamp(crop->rect.left,
>> +                             0, MT9P031_MAX_WIDTH - rect.width), 2);
>> +     rect.top = ALIGN(clamp(crop->rect.top,
>> +                            0, MT9P031_MAX_HEIGHT - rect.height), 2);
>> +
>> +     c = mt9p031_get_pad_crop(mt9p031, fh, crop->pad, crop->which);
>> +
>> +     if (rect.width != c->width || rect.height != c->height) {
>> +             /*
>> +              * Reset the output image size if the crop rectangle size has
>> +              * been modified.
>> +              */
>> +             f = mt9p031_get_pad_format(mt9p031, fh, crop->pad,
>> +                                                 crop->which);
>> +             width = f->width;
>> +             height = f->height;
>> +
>> +             xskip = mt9p031_skip_for_crop(rect.width, &width, 7);
>> +             yskip = mt9p031_skip_for_crop(rect.height, &height, 8);
>> +     } else {
>> +             xskip = mt9p031->xskip;
>> +             yskip = mt9p031->yskip;
>> +             f = NULL;
>> +     }
>
> Hm, looks like something is missing here: you dropped
>
>        if (crop->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
>                ret = mt9p031_set_params(client, &rect, xskip, yskip);
>                if (ret < 0)
>                        return ret;
>        }
>
> from my version, without which no cropping is actually taking place. Or
> have you also switched to the convention of only configuring the hardware
> on set_stream(1)?
>

Yes I did, following Laurent's directions.

[snip]
>> +
>> +     f = mt9p031_get_pad_format(mt9p031, fh, fmt->pad, fmt->which);
>> +
>> +     if (f->width == format->width && f->height == format->height)
>> +             return 0;
>> +
>> +
>
> One empty line is usually enough, especially inside a function.
>
ok, I'll fix.

>> +     c = mt9p031_get_pad_crop(mt9p031, fh, fmt->pad, fmt->which);
>> +
>> +     rect.width = c->width;
>> +     rect.height = c->height;
>> +
>> +     xskip = mt9p031_skip_for_scale(&rect.width, format->width, 7,
>> +                                    MT9P031_MAX_WIDTH);
>> +     if (rect.width + c->left > MT9P031_MAX_WIDTH)
>> +             rect.left = (MT9P031_MAX_WIDTH - rect.width) / 2;
>> +     else
>> +             rect.left = c->left;
>> +     yskip = mt9p031_skip_for_scale(&rect.height, format->height, 8,
>> +                                    MT9P031_MAX_HEIGHT);
>> +     if (rect.height + c->top > MT9P031_MAX_HEIGHT)
>> +             rect.top = (MT9P031_MAX_HEIGHT - rect.height) / 2;
>> +     else
>> +             rect.top = c->top;
>> +
>> +
>> +     pr_info("%s(%ux%u : %u)\n", __func__,
>> +             format->width, format->height, fmt->which);
>
> dev_dbg()

ok

>
>> +     if (c)
>> +             *c = rect;
>> +
>> +     *f = *format;
>> +     fmt->format = *format;
>> +
>> +     mt9p031->xskip = xskip;
>> +     mt9p031->yskip = yskip;
>> +     mt9p031->rect = *c;
>> +     return 0;
>> +}
>> +
>> +static int mt9p031_s_stream(struct v4l2_subdev *sd, int enable)
>> +{
>> +     struct mt9p031 *mt9p031 = container_of(sd, struct mt9p031, subdev);
>> +     struct i2c_client *client = v4l2_get_subdevdata(&mt9p031->subdev);
>> +     struct v4l2_rect rect = mt9p031->rect;
>> +     u16 xskip = mt9p031->xskip;
>> +     u16 yskip = mt9p031->yskip;
>> +     int ret;
>> +
>> +     if (enable) {
>> +             ret = mt9p031_set_params(client, &rect, xskip, yskip);
>> +             if (ret < 0)
>> +                     return ret;
>> +             /* Switch to master "normal" mode */
>> +             ret = mt9p031_set_output_control(mt9p031, 0, MT9P031_OUTPUT_CONTROL_CEN);
>> +     } else {
>> +             /* Stop sensor readout */
>> +             ret = mt9p031_set_output_control(mt9p031, MT9P031_OUTPUT_CONTROL_CEN, 0);
>> +     }
>> +     if (ret < 0)
>> +             return -EIO;
>> +
>> +     return 0;
>> +}
>> +
>> +/*
>> + * Interface active, can use i2c. If it fails, it can indeed mean, that
>> + * this wasn't our capture interface, so, we wait for the right one
>> + */
>> +static int mt9p031_video_probe(struct i2c_client *client)
>> +{
>> +     s32 data;
>> +     int ret;
>> +
>> +     /* Read out the chip version register */
>> +     data = reg_read(client, MT9P031_CHIP_VERSION);
>> +     if (data != MT9P031_CHIP_VERSION_VALUE) {
>> +             dev_err(&client->dev,
>> +                     "No MT9P031 chip detected, register read %x\n", data);
>> +             return -ENODEV;
>> +     }
>> +
>> +     dev_info(&client->dev, "Detected a MT9P031 chip ID %x\n", data);
>> +
>> +     ret = mt9p031_reset(client);
>> +     if (ret < 0)
>> +             dev_err(&client->dev, "Failed to initialise the camera\n");
>> +
>> +     return ret;
>> +}
>> +
>> +static int mt9p031_set_power(struct v4l2_subdev *sd, int on)
>> +{
>> +     struct mt9p031 *mt9p031 = container_of(sd, struct mt9p031, subdev);
>> +     int ret = 0;
>> +
>> +     mutex_lock(&mt9p031->power_lock);
>> +
>> +     /* If the power count is modified from 0 to != 0 or from != 0 to 0,
>> +      * update the power state.
>> +      */
>
> Multi-line comment style
>

Sure, let me fix that.

>> +     if (mt9p031->power_count == !on) {
>> +             if (on) {
>> +                     ret = mt9p031_power_on(mt9p031);
>> +                     if (ret) {
>> +                             pr_err("Failed to enable 2.8v regulator: %d\n", ret);
>
> dev_err

ok

>
>> +                             goto out;
>> +                     }
>> +             } else {
>> +                     mt9p031_power_off(mt9p031);
>> +             }
>> +     }
>> +
>> +     /* Update the power count. */
>> +     mt9p031->power_count +=on ? 1: -1;
>> +     WARN_ON(mt9p031->power_count < 0);
>> +
>> +out:
>> +     mutex_unlock(&mt9p031->power_lock);
>> +     return ret;
>> +}
>> +
>> +static int mt9p031_registered(struct v4l2_subdev *sd)
>> +{
>> +     struct mt9p031 *mt9p031 = container_of(sd, struct mt9p031, subdev);
>> +     struct i2c_client *client = v4l2_get_subdevdata(&mt9p031->subdev);
>> +     int ret;
>> +
>> +     ret = mt9p031_set_power(&mt9p031->subdev, 1);
>> +     if (ret) {
>> +             pr_err("Failed to power on device: %d\n", ret);
>
> dev_err()
>

ok

>> +             goto pwron;
>> +     }
>> +     if (mt9p031->pdata->reset)
>> +             mt9p031->pdata->reset(&mt9p031->subdev, 1);
>> +     msleep(50);
>> +     if (mt9p031->pdata->reset)
>> +             mt9p031->pdata->reset(&mt9p031->subdev, 0);
>> +     msleep(50);
>> +
>> +     ret = mt9p031_video_probe(client);
>> +     if (ret)
>> +             goto evprobe;
>> +
>> +     mt9p031->pad.flags = MEDIA_PAD_FL_SOURCE;
>> +     ret = media_entity_init(&mt9p031->subdev.entity, 1, &mt9p031->pad, 0);
>> +     if (ret)
>> +             goto evprobe;
>> +
>> +     mt9p031->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
>> +     mt9p031_set_power(&mt9p031->subdev, 0);
>> +
>> +     return 0;
>> +evprobe:
>> +     mt9p031_set_power(&mt9p031->subdev, 0);
>> +pwron:
>> +     return ret;
>> +}
>> +
>> +static int mt9p031_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
>> +{
>> +     struct mt9p031 *mt9p031;
>> +     mt9p031 = container_of(sd, struct mt9p031, subdev);
>> +
>> +     return mt9p031_set_power(sd, 1);
>
> Is open() called only for the first open, or for each one? If for each,
> you'll want to reference count yourself. Besides, isn't
> core_ops::s_power() called anyway, maybe you don't need these open() /
> close() at all?
>

Yes, you are right. As I only enable/disable power in open/close, they
can be safely removed.

[snip]
>> +     mt9p031 = kzalloc(sizeof(struct mt9p031), GFP_KERNEL);
>> +     if (!mt9p031)
>> +             return -ENOMEM;
>> +
>> +     mutex_init(&mt9p031->power_lock);
>> +     v4l2_i2c_subdev_init(&mt9p031->subdev, client, &mt9p031_subdev_ops);
>> +     mt9p031->subdev.internal_ops = &mt9p031_subdev_internal_ops;
>> +
>> +     mt9p031->pdata          = pdata;
>> +     mt9p031->rect.left      = 0;
>> +     mt9p031->rect.top       = 0;
>
> No need - kzalloc() has nullified it for you.

OK, I'll remove this.



-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
