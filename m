Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:37724 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752301Ab1ISBYX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Sep 2011 21:24:23 -0400
Received: by mail-gw0-f53.google.com with SMTP id 20so5073735gwj.12
        for <linux-media@vger.kernel.org>; Sun, 18 Sep 2011 18:24:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201109181453.11615.laurent.pinchart@ideasonboard.com>
References: <1279064456-7164-1-git-send-email-saaguirre@ti.com>
 <1279064456-7164-2-git-send-email-saaguirre@ti.com> <4E75E34E.2090406@redhat.com>
 <201109181453.11615.laurent.pinchart@ideasonboard.com>
From: "Aguirre, Sergio" <saaguirre@ti.com>
Date: Sun, 18 Sep 2011 20:24:00 -0500
Message-ID: <CAKnK67TJJ+6ptkNGS=YOJpZAO5--txoX1_O5q1KxqL78kC2_jA@mail.gmail.com>
Subject: Re: [RFC][PATCH 2/2] v4l2: Add lv8093 lens driver
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org,
	halli manjunatha <manjunatha_halli@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro/Laurent,

On Sun, Sep 18, 2011 at 7:53 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi,
>
> On Sunday 18 September 2011 14:25:50 Mauro Carvalho Chehab wrote:
>> Em 13-07-2010 20:40, Sergio Aguirre escreveu:
>> > This adds LV8093 Piezo Actuator Lens driver.
>> >
>> > This is currently found in tandem with IMX046 sensor.
>>
>> Due to patchwork.kernel.org long outage, I'm working on setting a new
>> patchwork instance somewhere else. So, I'm importing the old patches and
>> double-check if something were missed.
>>
>> In this proccess, I noticed that, for two times, a driver for lv8093 were
>> proposed, one as part of the OMAPZOOM series of patches, back in Feb/2009,
>> and a second submission, on this series.
>>
>> However, it seems that this were never applied, even not having any single
>> comment on the last time you've submitted it, as a RFC.
>>
>> It seems that the omap3 maintainer lost those patches, or am I missing
>> something?
>
> If you're talking about the OMAP3 ISP maintainer, indeed, I've never even
> noticed the patches :-)

This patches are so old, that I've forgotten completely about them :P

I'll actually need to dust off my old Zoom3 HW I have around to retest this. :)

And BTW, Dominic doesn't work at TI since last year, so I'm unlooping
his e-mail address.

>
> Review inlined.

Ok. Thanks.

>
>> > Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
>> > ---
>> >
>> >  drivers/media/video/Kconfig       |    8 +
>> >  drivers/media/video/Makefile      |    1 +
>> >  drivers/media/video/lv8093.c      |  614 ++++++++++++++++++++++++++++++++
>> >  drivers/media/video/lv8093_regs.h |   76 +++++
>> >  include/media/lv8093.h            |   40 +++
>> >  include/media/v4l2-chip-ident.h   |    3 +
>> >  6 files changed, 742 insertions(+), 0 deletions(-)
>> >  create mode 100644 drivers/media/video/lv8093.c
>> >  create mode 100644 drivers/media/video/lv8093_regs.h
>> >  create mode 100644 include/media/lv8093.h
>> >
>> > diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
>> > index 10cd7b3..b62adce 100644
>> > --- a/drivers/media/video/Kconfig
>> > +++ b/drivers/media/video/Kconfig
>> > @@ -344,6 +344,14 @@ config VIDEO_IMX046
>> >
>> >       IMX046 camera.  It is currently working with the TI OMAP3
>> >       camera controller.
>> >
>> > +config VIDEO_LV8093
>> > +   tristate "Piezo Actuator Lens driver for LV8093"
>> > +   depends on I2C && VIDEO_V4L2
>> > +   ---help---
>> > +     This is a Video4Linux2 lens driver for the Sanyo LV8093.
>> > +     It is currently working with the TI OMAP3 camera controller
>> > +     and Sony IMX046 sensor.
>> > +
>
> You will need to implement the media controller API to work with the TI OMAP3
> ISP.

Yeah. I think I've implemented this driver when Media Controller
wasn't still upstreamed,
and under review still.

>
>> >  config VIDEO_SAA7110
>> >
>> >     tristate "Philips SAA7110 video decoder"
>> >     depends on VIDEO_V4L2 && I2C
>> >
>> > diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
>> > index 00341cb..50f528c 100644
>> > --- a/drivers/media/video/Makefile
>> > +++ b/drivers/media/video/Makefile
>> > @@ -39,6 +39,7 @@ obj-$(CONFIG_VIDEO_TDA9840) += tda9840.o
>> >
>> >  obj-$(CONFIG_VIDEO_TEA6415C) += tea6415c.o
>> >  obj-$(CONFIG_VIDEO_TEA6420) += tea6420.o
>> >  obj-$(CONFIG_VIDEO_IMX046) += imx046.o
>> >
>> > +obj-$(CONFIG_VIDEO_LV8093) += lv8093.o
>> >
>> >  obj-$(CONFIG_VIDEO_SAA7110) += saa7110.o
>> >  obj-$(CONFIG_VIDEO_SAA711X) += saa7115.o
>> >  obj-$(CONFIG_VIDEO_SAA717X) += saa717x.o
>> >
>> > diff --git a/drivers/media/video/lv8093.c b/drivers/media/video/lv8093.c
>> > new file mode 100644
>> > index 0000000..b0b0fcf
>> > --- /dev/null
>> > +++ b/drivers/media/video/lv8093.c
>> > @@ -0,0 +1,614 @@
>> > +/*
>> > + * drivers/media/video/lv8093.c
>> > + *
>> > + * LV8093 Piezo Motor (LENS) driver
>> > + *
>> > + * Copyright (C) 2008-2009 Texas Instruments.
>> > + * Copyright (C) 2009 Hewlett-Packard.
>> > + *
>> > + * This package is free software; you can redistribute it and/or modify
>> > + * it under the terms of the GNU General Public License version 2 as
>> > + * published by the Free Software Foundation.
>> > + *
>> > + * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
>> > + * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
>> > + * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
>> > + */
>> > +
>> > +#include <linux/mutex.h>
>> > +#include <linux/i2c.h>
>> > +#include <linux/delay.h>
>> > +#include <linux/platform_device.h>
>> > +#include <linux/cdev.h>
>> > +#include <linux/device.h>
>> > +
>> > +#include <media/lv8093.h>
>> > +#include <media/v4l2-chip-ident.h>
>> > +#include <media/v4l2-device.h>
>> > +#include <media/v4l2-subdev.h>
>> > +
>> > +#include "lv8093_regs.h"
>> > +
>> > +static struct vcontrol {
>> > +   struct v4l2_queryctrl qc;
>> > +} video_control[] = {
>> > +   {
>> > +           {
>> > +           .id = V4L2_CID_FOCUS_RELATIVE,
>> > +           .type = V4L2_CTRL_TYPE_INTEGER,
>> > +           .name = "Lens Relative Position",
>> > +           .minimum = 0,
>> > +           .maximum = 0,
>> > +           .step = LV8093_MAX_RELATIVE_STEP,
>> > +           .default_value = 0,
>> > +           }
>> > +   ,}
>> > +};
>> > +
>> > +static struct i2c_driver lv8093_i2c_driver;
>> > +
>> > +static struct lv8093_lens_settings {
>> > +   u8 reg;
>> > +   u8 val;
>> > +} lens_settings[] = {
>> > +   {       /* Set control register */
>> > +           .reg = CAMAF_LV8093_CTL_REG,
>> > +           .val = CAMAF_LV8093_GATE0 |
>> > +                           CAMAF_LV8093_ENIN |
>> > +                           CAMAF_LV8093_CKSEL_ONE |
>> > +                           CAMAF_LV8093_RET2 |
>> > +                           CAMAF_LV8093_INIT_OFF,
>> > +   },
>> > +   {       /* Specify number of clocks per period */
>> > +           .reg = CAMAF_LV8093_RST_REG,
>> > +           .val = (LV8093_CLK_PER_PERIOD - 1),
>> > +   },
>> > +   {       /* Set the GATE_A pulse set value */
>> > +           .reg = CAMAF_LV8093_GTAS_REG,
>> > +           .val = (LV8093_TIME_GATEA + 1),
>> > +   },
>> > +   {       /* Set the GATE_B pulse reset value */
>> > +           .reg = CAMAF_LV8093_GTBR_REG,
>> > +           .val = (LV8093_TIME_GATEA + 1 + LV8093_TIME_OFF),
>> > +   },
>> > +   {       /* Set the GATE_B pulse set value */
>> > +           .reg = CAMAF_LV8093_GTBS_REG,
>> > +           .val = (LV8093_TIME_GATEA + 1 +
>> > +                           LV8093_TIME_OFF + LV8093_TIME_GATEB),
>> > +   },
>> > +   {       /* Specific the number of output pulse steps */
>> > +           .reg = CAMAF_LV8093_STP_REG,
>> > +           .val = LV8093_STP,
>> > +   },
>> > +   {       /* Set the number of swing back of init sequence performed */
>> > +           .reg = CAMAF_LV8093_MOV_REG,
>> > +           .val = 0,
>> > +   },
>> > +};
>> > +
>> > +/**
>> > + * find_vctrl - Finds the requested ID in the video control structure
>> > array + * @id: ID of control to search the video control array for
>> > + *
>> > + * Returns the index of the requested ID from the control structure
>> > array + */
>> > +static int find_vctrl(int id)
>> > +{
>> > +   int i;
>> > +
>> > +   if (id < V4L2_CID_BASE)
>> > +           return -EDOM;
>> > +
>> > +   for (i = (ARRAY_SIZE(video_control) - 1); i >= 0; i--)
>> > +           if (video_control[i].qc.id == id)
>> > +                   break;
>> > +   if (i < 0)
>> > +           i = -EINVAL;
>> > +   return i;
>> > +}
>> > +
>> > +/**
>> > + * lv8093_reg_read - Reads a value from a register in LV8093 Piezo
>> > + * driver device.
>> > + * @client: Pointer to structure of I2C client.
>> > + * @value: Pointer to u16 for returning value of register to read.
>> > + *
>> > + * Returns zero if successful, or non-zero otherwise.
>> > + **/
>> > +static int lv8093_reg_read(struct i2c_client *client, u8 *value)
>> > +{
>> > +   int err;
>> > +   struct i2c_msg msg[1];
>> > +
>> > +   if (!client->adapter)
>> > +           return -ENODEV;
>> > +
>> > +   msg->addr = client->addr;
>> > +   msg->flags = I2C_M_RD;
>> > +   msg->len = 1;
>> > +   msg->buf = value;
>> > +
>> > +   err = i2c_transfer(client->adapter, msg, 1);
>> > +
>> > +   if (err < 0)
>> > +           v4l_err(client, "i2c read failed with error %i", err);
>
> It looks like you're reimplementing i2c_smbus_read_byte_data() and
> i2c_smbus_write_byte_data(). Can you use them instead ?

You're right. I will, thanks.

>
>> > +
>> > +   return err;
>> > +}
>> > +
>> > +/**
>> > + * lv8093_reg_write - Writes a value to a register in LV8093 Piezo
>> > + * driver device.
>> > + * @client: Pointer to structure of I2C client.
>> > + * @reg: Register to write.
>> > + * @value: Value of register to write.
>> > + *
>> > + * Returns zero or +ve if successful, -ve for error.
>> > + **/
>> > +static int lv8093_reg_write(struct i2c_client *client, u8 reg, u8 value)
>> > +{
>> > +   int err;
>> > +   struct i2c_msg msg[1];
>> > +   unsigned char data[2];
>> > +
>> > +   if (!client->adapter)
>> > +           return -ENODEV;
>> > +
>> > +   msg->addr = client->addr;
>> > +   msg->flags = 0;
>> > +   msg->len = 2;
>> > +   msg->buf = data;
>> > +
>> > +   data[0] = reg;
>> > +   data[1] = value;
>> > +
>> > +   err = i2c_transfer(client->adapter, msg, 1);
>> > +   if (err < 0)
>> > +           v4l_err(client, "i2c write failed with error %i", err);
>> > +
>> > +   return err;
>> > +}
>> > +
>> > +/**
>> > + * lv8093_detect - Detects LV8093 Piezo driver device.
>> > + * @client: Pointer to structure of I2C client.
>> > + *
>> > + * Returns 0 if successful, -1 if camera is off or if test register
>> > value + * wasn't stored properly, or return error from lv8093_reg_write
>> > function. + **/
>> > +static int lv8093_detect(struct i2c_client *client)
>> > +{
>> > +   int err = 0;
>> > +   u8 rposn = 0;
>> > +
>> > +   err = lv8093_reg_write(client, CAMAF_LV8093_CTL_REG,
>> > +                           CAMAF_LV8093_GATE0 |
>> > +                           CAMAF_LV8093_CKSEL_ONE |
>> > +                           CAMAF_LV8093_RET2 |
>> > +                           CAMAF_LV8093_INIT_OFF);
>> > +
>> > +   if (err < 0) {
>> > +           v4l_err(client, "Unable to write LV8093\n");
>> > +           return err;
>> > +   }
>> > +
>> > +   err = lv8093_reg_read(client, &rposn);
>> > +   if (err < 0) {
>> > +           v4l_err(client, "Unable to read LV8093\n");
>> > +           return err;
>> > +   }
>> > +
>> > +   return err;
>> > +}
>> > +
>> > +/**
>> > + * lv8093_reginit - Initializes LV8093 Piezo driver device.
>> > + * @client: Pointer to structure of I2C client.
>> > + *
>> > + * Returns 0 if successful, or returns errors from lv8093_reg_write.
>> > + **/
>> > +static int lv8093_reginit(struct i2c_client *client)
>> > +{
>> > +   int i, err = 0;
>> > +
>> > +   for (i = 0; i < ARRAY_SIZE(lens_settings); i++) {
>> > +
>> > +           err = lv8093_reg_write(client,
>> > +                           lens_settings[i].reg, lens_settings[i].val);
>> > +
>> > +           if (err < 0) {
>> > +                   v4l_err(client, "Unable to initialize LV8093\n");
>> > +                   return err;
>> > +           }
>> > +   }
>> > +
>> > +   return 0;
>> > +}
>> > +
>> > +/**
>> > + * lv8093_af_setfocus - Sets the desired focus.
>> > + * @relpos: Relative focus position:
>> > + *                 -ve - Direction INFINITY.
>> > + *                 +ve - Direction MACRO.
>> > + *                 abs(relpos) gives number of steps in desired direction.
>> > + *
>> > + * Returns 0 on success, -EINVAL if camera is off or returned errors
>> > + * from lv8093_reg_write function.
>> > + **/
>> > +static int lv8093_af_setfocus(struct v4l2_subdev *subdev, s16 relpos)
>> > +{
>> > +   struct lv8093_device *af_dev = to_lv8093_device(subdev);
>> > +   struct i2c_client *client = v4l2_get_subdevdata(subdev);
>> > +   u8 num_pulses = abs(relpos);
>> > +   int ret = 0;
>> > +
>> > +   if ((af_dev->power_state == V4L2_POWER_OFF) ||
>> > +       (af_dev->power_state == V4L2_POWER_STANDBY))
>> > +           return -EINVAL;
>> > +
>> > +   if (relpos >= 0) {
>> > +           /* Move lens in Macro direction */
>> > +           ret |= lv8093_reg_write(client, CAMAF_LV8093_DRVPLS_REG,
>> > +                   0 & (~CAMAF_LV8093_MAC_DIR));
>> > +           ret |= lv8093_reg_write(client, CAMAF_LV8093_DRVPLS_REG,
>> > +                   num_pulses | CAMAF_LV8093_MAC_DIR);
>> > +
>> > +   } else {
>> > +           /* Move lens in Infinite direction */
>> > +           ret |= lv8093_reg_write(client, CAMAF_LV8093_DRVPLS_REG,
>> > +                   0 | CAMAF_LV8093_MAC_DIR);
>> > +           ret |= lv8093_reg_write(client, CAMAF_LV8093_DRVPLS_REG,
>> > +                   num_pulses & (~CAMAF_LV8093_MAC_DIR));
>> > +
>> > +   }
>> > +
>> > +   if (ret < 0) {
>> > +           v4l_err(client, "Unable to write " LV8093_NAME
>> > +                   " lens HW\n");
>> > +           return -EINVAL;
>> > +   }
>> > +
>> > +   return 0;
>> > +}
>> > +
>> > +/**
>> > + * lv8093_is_busy - Read busy bit.
>> > + *
>> > + * Returns:
>> > + *  0 for READY, -EBUSY for device busy, -EINVAL on error.
>> > + **/
>> > +static int lv8093_is_busy(struct v4l2_subdev *subdev)
>> > +{
>> > +   struct i2c_client *client = v4l2_get_subdevdata(subdev);
>> > +   int ret;
>> > +   u8  regval;
>> > +
>> > +   ret = lv8093_reg_read(client, &regval);
>> > +
>> > +   if (ret < 0) {
>> > +           dev_err(&client->dev, "Unable to read " LV8093_NAME
>> > +                   " lens HW\n");
>> > +           return -EINVAL;
>> > +   }
>> > +
>> > +   if (regval & CAMAF_LV8093_BUSY)
>> > +           return -EBUSY;
>> > +
>> > +   return 0;
>> > +}
>> > +
>> > +static int lv8093_power_on(struct v4l2_subdev *subdev)
>> > +{
>> > +   struct lv8093_device *lens = to_lv8093_device(subdev);
>> > +   struct i2c_client *client = v4l2_get_subdevdata(subdev);
>> > +   int rval = -EINVAL;
>> > +
>> > +   if (lens->pdata->s_power)
>> > +           rval = lens->pdata->s_power(subdev, 1);
>> > +
>> > +   if (rval < 0) {
>> > +           v4l_err(client, "Unable to set the power state ON\n");
>> > +           return rval;
>> > +   }
>> > +
>> > +   return 0;
>> > +}
>> > +
>> > +static int lv8093_power_off(struct v4l2_subdev *subdev)
>> > +{
>> > +   struct lv8093_device *lens = to_lv8093_device(subdev);
>> > +   struct i2c_client *client = v4l2_get_subdevdata(subdev);
>> > +   int rval = -EINVAL;
>> > +
>> > +   if (lens->pdata->s_power)
>> > +           rval = lens->pdata->s_power(subdev, 0);
>> > +
>> > +   if (rval < 0) {
>> > +           v4l_err(client, "Unable to set the power state OFF\n");
>> > +           return rval;
>> > +   }
>> > +
>> > +   return 0;
>> > +}
>> > +
>> > +/**
>> > + * lv8093_dev_init - V4L2 sensor interface handler for
>> > vidioc_int_dev_init_num + * @s: pointer to standard V4L2 device
>> > structure
>> > + *
>> > + * Initialise the device when slave attaches to the master.  Returns 0
>> > if + * lv8093 device could be found, otherwise returns appropriate
>> > error. + */
>> > +static int lv8093_dev_init(struct v4l2_subdev *subdev)
>> > +{
>> > +   struct i2c_client *client = v4l2_get_subdevdata(subdev);
>> > +   int err;
>> > +
>> > +   err = lv8093_power_on(subdev);
>> > +   if (err)
>> > +           return -ENODEV;
>> > +
>> > +   err = lv8093_detect(client);
>> > +   if (err < 0) {
>> > +           v4l_err(client, "Unable to detect " LV8093_NAME
>> > +                   " lens HW\n");
>> > +           return err;
>> > +   }
>> > +   pr_info(LV8093_NAME " Lens HW detected\n");
>> > +
>> > +   err = lv8093_reginit(client);
>> > +   if (err < 0) {
>> > +           v4l_err(client, "Unable to initialize " LV8093_NAME
>> > +                   " lens HW\n");
>> > +           return err;
>> > +   }
>> > +
>> > +   err = lv8093_power_off(subdev);
>> > +   if (err)
>> > +           return -ENODEV;
>> > +
>> > +   return 0;
>> > +}
>> > +
>> > +/*
>> > ------------------------------------------------------------------------
>> > -- + * V4L2 subdev operations
>> > + */
>> > +static int lv8093_g_chip_ident(struct v4l2_subdev *subdev,
>> > +                          struct v4l2_dbg_chip_ident *chip)
>> > +{
>> > +   struct i2c_client *client = v4l2_get_subdevdata(subdev);
>> > +
>> > +   return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_LV8093, 0);
>> > +}
>> > +
>> > +static int lv8093_s_config(struct v4l2_subdev *subdev, int irq,
>> > +                      void *platform_data)
>> > +{
>> > +   struct lv8093_device *lens = to_lv8093_device(subdev);
>> > +
>> > +   if (platform_data == NULL)
>> > +           return -ENODEV;
>> > +
>> > +   lens->pdata = platform_data;
>> > +
>> > +   return lv8093_dev_init(subdev);
>> > +}
>> > +
>> > +/**
>> > + * lv8093_queryctrl - V4L2 lens interface handler for VIDIOC_QUERYCTRL
>> > ioctl + * @s: pointer to standard V4L2 device structure
>> > + * @qc: standard V4L2 VIDIOC_QUERYCTRL ioctl structure
>> > + *
>> > + * If the requested control is supported, returns the control
>> > information + * from the video_control[] array.  Otherwise, returns
>> > -EINVAL if the + * control is not supported.
>> > + */
>> > +static int lv8093_queryctrl(struct v4l2_subdev *subdev,
>> > +                       struct v4l2_queryctrl *qc)
>> > +{
>> > +   int i;
>> > +
>> > +   i = find_vctrl(qc->id);
>> > +   if (i == -EINVAL)
>> > +           qc->flags = V4L2_CTRL_FLAG_DISABLED;
>> > +
>> > +   if (i < 0)
>> > +           return -EINVAL;
>> > +
>> > +   *qc = video_control[i].qc;
>> > +   return 0;
>> > +}
>> > +
>> > +/**
>> > + * lv8093_s_ctrl - V4L2 LV8093 lens interface handler for VIDIOC_S_CTRL
>> > ioctl + * @s: pointer to standard V4L2 device structure
>> > + * @vc: standard V4L2 VIDIOC_S_CTRL ioctl structure
>> > + *
>> > + * If the requested control is supported, sets the control's current
>> > + * value in HW.
>> > + * Otherwise, returns -EINVAL if the control is not supported.
>> > + */
>> > +static int lv8093_s_ctrl(struct v4l2_subdev *subdev, struct v4l2_control
>> > *vc) +{
>> > +   int retval = -EINVAL;
>> > +   int i;
>> > +   struct vcontrol *lvc;
>> > +
>> > +   i = find_vctrl(vc->id);
>> > +   if (i < 0)
>> > +           return -EINVAL;
>> > +   lvc = &video_control[i];
>> > +
>> > +   switch (vc->id) {
>> > +   case V4L2_CID_FOCUS_RELATIVE:
>> > +           retval = lv8093_af_setfocus(subdev, (s16)vc->value);
>> > +           break;
>> > +   }
>> > +
>> > +   return retval;
>> > +}
>> > +
>> > +/**
>> > + * lv8093_g_ctrl - V4L2 LV8093 lens interface handler for VIDIOC_G_CTRL
>> > ioctl + * @s: pointer to standard V4L2 device structure
>> > + * @vc: standard V4L2 VIDIOC_S_CTRL ioctl structure
>> > + *
>> > + * For V4L2_CID_FOCUS_RELATIVE control always returns the control's
>> > value + * as zero. However, the return value is used to return whether
>> > the device + * is busy still moving the lens. It will do this by
>> > returning -EBUSY (busy) + * or 0 (ready).
>> > + * Otherwise, returns -EINVAL if the control is not supported.
>> > + */
>> > +static int lv8093_g_ctrl(struct v4l2_subdev *subdev, struct v4l2_control
>> > *vc) +{
>> > +   int i, retval = -EINVAL;
>> > +   struct vcontrol *lvc;
>> > +
>> > +   i = find_vctrl(vc->id);
>> > +   if (i < 0)
>> > +           return -EINVAL;
>> > +   lvc = &video_control[i];
>> > +
>> > +   switch (vc->id) {
>> > +   case V4L2_CID_FOCUS_RELATIVE:
>> > +           retval = lv8093_is_busy(subdev);
>> > +           vc->value = 0;
>> > +           break;
>> > +   }
>> > +   return retval;
>> > +}
>> > +
>> > +/**
>> > + * lv8093_s_power - V4L2 sensor interface handler for
>> > vidioc_int_s_power_num + * @s: pointer to standard V4L2 device structure
>> > + * @on: power state to which device is to be set
>> > + *
>> > + * Sets devices power state to requested state, if possible.
>> > + */
>> > +static int lv8093_s_power(struct v4l2_subdev *subdev, int on)
>> > +{
>> > +   struct lv8093_device *lens = to_lv8093_device(subdev);
>> > +   struct i2c_client *client = v4l2_get_subdevdata(subdev);
>> > +   int rval = 0;
>> > +
>> > +   if (on) {
>> > +           rval = lv8093_power_on(subdev);
>> > +           if (rval)
>> > +                   goto error;
>> > +
>> > +           if (!lens->power_state) {
>> > +                   rval = lv8093_reginit(client);
>> > +                   if (rval < 0) {
>> > +                           v4l_err(client, "Unable to initialize "
>> > +                                   LV8093_NAME " lens HW\n");
>> > +                           return rval;
>> > +                   }
>> > +           }
>> > +   } else
>> > +           rval = lv8093_power_off(subdev);
>> > +
>> > +   lens->power_state = on;
>
> Isn't locking needed here ?

Right. Will do.

>
>> > +error:
>> > +   return rval;
>> > +}
>> > +
>> > +static const struct v4l2_subdev_core_ops lv8093_core_ops = {
>> > +   .g_chip_ident = lv8093_g_chip_ident,
>
> There's no need to implement .g_chip_ident with the media controller API.

Yeah, I can see that now. Will do.

>
>> > +   .s_config = lv8093_s_config,
>
> .s_config has been removed. You're probably looking for .registered in the
> internal ops.

Will do.

>
>> > +   .queryctrl = lv8093_queryctrl,
>> > +   .g_ctrl = lv8093_g_ctrl,
>> > +   .s_ctrl = lv8093_s_ctrl,
>
> Please use the control framework.

Ok. Will do.

>
>> > +   .s_power = lv8093_s_power,
>> > +};
>> > +
>> > +static const struct v4l2_subdev_ops lv8093_ops = {
>> > +   .core = &lv8093_core_ops,
>> > +};
>> > +
>> > +/**
>> > + * lv8093_probe - Probes the driver for valid I2C attachment.
>> > + * @client: Pointer to structure of I2C client.
>> > + *
>> > + * Returns 0 if successful, or -EBUSY if unable to get client attached
>> > data. + **/
>> > +static int
>> > +lv8093_probe(struct i2c_client *client, const struct i2c_device_id *id)
>> > +{
>> > +   struct lv8093_device *lens;
>> > +
>> > +   lens = kzalloc(sizeof(*lens), GFP_KERNEL);
>> > +   if (lens == NULL)
>> > +           return -ENOMEM;
>> > +
>> > +   v4l2_i2c_subdev_init(&lens->subdev, client, &lv8093_ops);
>> > +   return 0;
>> > +}
>> > +
>> > +/**
>> > + * lv8093_remove - Routine when device its unregistered from I2C
>> > + * @client: Pointer to structure of I2C client.
>> > + *
>> > + * Returns 0 if successful, or -ENODEV if the client isn't attached.
>> > + **/
>> > +static int __exit lv8093_remove(struct i2c_client *client)
>> > +{
>> > +   struct v4l2_subdev *subdev = i2c_get_clientdata(client);
>> > +   struct lv8093_device *lens = to_lv8093_device(subdev);
>> > +
>> > +   v4l2_device_unregister_subdev(&lens->subdev);
>> > +   kfree(lens);
>> > +   return 0;
>> > +}
>> > +
>> > +static const struct i2c_device_id lv8093_id[] = {
>> > +   {LV8093_NAME, 0},
>> > +   {}
>> > +};
>> > +
>> > +MODULE_DEVICE_TABLE(i2c, lv8093_id);
>> > +
>> > +static struct i2c_driver lv8093_i2c_driver = {
>> > +   .driver = {
>> > +              .name = LV8093_NAME,
>> > +              .owner = THIS_MODULE,
>> > +              },
>> > +   .probe = lv8093_probe,
>> > +   .remove = __exit_p(lv8093_remove),
>> > +   .id_table = lv8093_id,
>> > +};
>> > +
>> > +/**
>> > + * lv8093_init - Module initialisation.
>> > + *
>> > + * Returns 0 if successful, or -EINVAL if device couldn't be
>> > initialized, or + * added as a character device.
>> > + **/
>> > +static int __init lv8093_init(void)
>> > +{
>> > +   int err;
>> > +
>> > +   err = i2c_add_driver(&lv8093_i2c_driver);
>> > +   if (err)
>> > +           goto fail;
>> > +   pr_info("Registered " LV8093_NAME " as i2c device.\n");
>> > +
>> > +   return err;
>> > +fail:
>> > +   pr_err("Failed to register " LV8093_NAME " as i2c driver.\n");
>> > +   return err;
>> > +}
>> > +
>> > +late_initcall(lv8093_init);
>> > +
>> > +/**
>> > + * lv8093_cleanup - Module cleanup.
>> > + **/
>> > +static void __exit lv8093_cleanup(void)
>> > +{
>> > +   i2c_del_driver(&lv8093_i2c_driver);
>> > +}
>> > +
>> > +module_exit(lv8093_cleanup);
>> > +
>> > +MODULE_AUTHOR("Texas Instruments");
>> > +MODULE_LICENSE("GPL");
>> > +MODULE_DESCRIPTION("LV8093 LENS driver");
>> > diff --git a/drivers/media/video/lv8093_regs.h
>> > b/drivers/media/video/lv8093_regs.h new file mode 100644
>> > index 0000000..aaebf03
>> > --- /dev/null
>> > +++ b/drivers/media/video/lv8093_regs.h
>
> I would merge this with lv8093.c, but that might just be me.

Agreed. Will do.

Thanks for the comments.

Regards,
Sergio

>
>> > @@ -0,0 +1,76 @@
>> > +/*
>> > + * lv8093_regs.h
>> > + *
>> > + * Copyright (C) 2008-2009 Texas Instruments.
>> > + * Copyright (C) 2009 Hewlett-Packard.
>> > + *
>> > + * This package is free software; you can redistribute it and/or modify
>> > + * it under the terms of the GNU General Public License version 2 as
>> > + * published by the Free Software Foundation.
>> > + *
>> > + * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
>> > + * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
>> > + * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
>> > + *
>> > + * Register defines for Lens piezo-actuator device
>> > + *
>> > + */
>> > +#ifndef LV8093_REGS_H
>> > +#define LV8093_REGS_H
>> > +
>> > +#include <media/v4l2-int-device.h>
>> > +
>> > +#define LV8093_I2C_RETRY_COUNT             5
>> > +
>> > +#define CAMAF_LV8093_DISABLE               0x1
>> > +#define CAMAF_LV8093_ENABLE                0x0
>> > +#define CAMAF_LV8093_DRVPLS_REG            0x0
>> > +#define CAMAF_LV8093_CTL_REG               0x1
>> > +#define CAMAF_LV8093_RST_REG               0x2
>> > +#define CAMAF_LV8093_GTAS_REG              0x3
>> > +#define CAMAF_LV8093_GTBR_REG              0x4
>> > +#define CAMAF_LV8093_GTBS_REG              0x5
>> > +#define CAMAF_LV8093_STP_REG               0x6
>> > +#define CAMAF_LV8093_MOV_REG               0x7
>> > +#define CAMAF_LV8093_MAC_DIR        0x80
>> > +#define CAMAF_LV8093_INF_DIR        0x00
>> > +#define CAMAF_LV8093_GATE0          0x00
>> > +#define CAMAF_LV8093_GATE1          0x80
>> > +#define CAMAF_LV8093_ENIN           0x20
>> > +#define CAMAF_LV8093_CKSEL_ONE      0x18
>> > +#define CAMAF_LV8093_CKSEL_HALF     0x08
>> > +#define CAMAF_LV8093_CKSEL_QTR      0x00
>> > +#define CAMAF_LV8093_RET2           0x00
>> > +#define CAMAF_LV8093_RET1           0x02
>> > +#define CAMAF_LV8093_RET3           0x04
>> > +#define CAMAF_LV8093_RET4           0x06
>> > +#define CAMAF_LV8093_INIT_OFF       0x01
>> > +#define CAMAF_LV8093_INIT_ON        0x00
>> > +#define CAMAF_LV8093_BUSY           0x80
>> > +#define CAMAF_LV8093_REGDATA(REG, DATA)  (((REG) << 8) | (DATA))
>> > +
>> > +#define CAMAF_LV8093_POWERDN(ARG)  (((ARG) & 0x1) << 15)
>> > +#define CAMAF_LV8093_POWERDN_R(ARG)        (((ARG) >> 15) & 0x1)
>> > +
>> > +#define CAMAF_LV8093_DATA(ARG)             (((ARG) & 0xFF) << 6)
>> > +#define CAMAF_LV8093_DATA_R(ARG)   (((ARG) >> 6) & 0xFF)
>> > +#define CAMAF_FREQUENCY_EQ1(mclk)  ((u16)(mclk/16000))
>> > +
>> > +/* State of lens */
>> > +#define LENS_DETECTED 1
>> > +#define LENS_NOT_DETECTED 0
>> > +
>> > +/* Focus control values */
>> > +#define LV8093_MAX_RELATIVE_STEP   127
>> > +
>> > +/* Initialization Mode Settings */
>> > +#define LV8093_TIME_GATEA  23              /* First pulse width. */
>> > +#define LV8093_TIME_OFF            2               /* Off time between pulses. */
>> > +#define LV8093_TIME_GATEB  29              /* Second pulse width. */
>> > +#define LV8093_STP         24              /* Pulse repetitions. */
>> > +/* Numbers of clock periods per cycle: */
>> > +/* 18MHz clock, period = 55.6 nsec */
>> > +#define LV8093_CLK_PER_PERIOD      104
>> > +
>> > +#endif /* End of of LV8093_REGS_H */
>> > +
>
> --
> Regards,
>
> Laurent Pinchart
>
