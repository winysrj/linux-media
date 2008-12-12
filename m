Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBC63Tvi013474
	for <video4linux-list@redhat.com>; Fri, 12 Dec 2008 01:03:29 -0500
Received: from mu-out-0910.google.com (mu-out-0910.google.com [209.85.134.189])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBC63Fe7012211
	for <video4linux-list@redhat.com>; Fri, 12 Dec 2008 01:03:15 -0500
Received: by mu-out-0910.google.com with SMTP id g7so778911muf.1
	for <video4linux-list@redhat.com>; Thu, 11 Dec 2008 22:03:15 -0800 (PST)
Message-ID: <208cbae30812112203o6be4974epb87b3810e2de3581@mail.gmail.com>
Date: Fri, 12 Dec 2008 09:03:15 +0300
From: "Alexey Klimov" <klimov.linux@gmail.com>
To: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE894415E6E1A4@dlee02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <A24693684029E5489D1D202277BE894415E6E1A4@dlee02.ent.ti.com>
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@nokia.com>,
	"Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>, "Nagalla,
	Hari" <hnagalla@ti.com>
Subject: Re: [REVIEW PATCH 13/14] OMAP: CAM: Add Lens Driver
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hello, all

Looked through the patch and have small suggestions, it's about coding
style and releted.

On Thu, Dec 11, 2008 at 11:38 PM, Aguirre Rodriguez, Sergio Alberto
<saaguirre@ti.com> wrote:
> >From 1341b74f5a90e4aa079a4fcb4fe2127ff344cce7 Mon Sep 17 00:00:00 2001
> From: Sergio Aguirre <saaguirre@ti.com>
> Date: Thu, 11 Dec 2008 13:35:46 -0600
> Subject: [PATCH] OMAP: CAM: Add Lens Driver
>
> This adds the DW9710 Lens driver
>
> Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
> ---
>  drivers/media/video/Kconfig  |    8 +
>  drivers/media/video/Makefile |    1 +
>  drivers/media/video/dw9710.c |  569 ++++++++++++++++++++++++++++++++++++++++++
>  drivers/media/video/dw9710.h |   59 +++++
>  4 files changed, 637 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/dw9710.c
>  create mode 100644 drivers/media/video/dw9710.h
>
> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> index 24957bc..50651f2 100644
> --- a/drivers/media/video/Kconfig
> +++ b/drivers/media/video/Kconfig
> @@ -313,6 +313,14 @@ config VIDEO_MT9P012
>          MT9P012 camera.  It is currently working with the TI OMAP3
>          camera controller.
>
> +config VIDEO_DW9710
> +       tristate "Lens driver for DW9710"
> +       depends on I2C && VIDEO_V4L2
> +       ---help---
> +         This is a Video4Linux2 lens driver for the Dongwoon
> +         DW9710 coil.  It is currently working with the TI OMAP3
> +         camera controller and micron MT9P012 sensor.
> +
>  config VIDEO_SAA7110
>        tristate "Philips SAA7110 video decoder"
>        depends on VIDEO_V4L1 && I2C
> diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
> index f73b65c..41c71d5 100644
> --- a/drivers/media/video/Makefile
> +++ b/drivers/media/video/Makefile
> @@ -101,6 +101,7 @@ obj-$(CONFIG_VIDEO_OV7670)  += ov7670.o
>
>  obj-$(CONFIG_VIDEO_TCM825X) += tcm825x.o
>  obj-$(CONFIG_VIDEO_MT9P012)    += mt9p012.o
> +obj-$(CONFIG_VIDEO_DW9710) += dw9710.o
>
>  obj-$(CONFIG_VIDEO_OMAP3) += omap34xxcam.o isp/
>
> diff --git a/drivers/media/video/dw9710.c b/drivers/media/video/dw9710.c
> new file mode 100644
> index 0000000..b5d5247
> --- /dev/null
> +++ b/drivers/media/video/dw9710.c
> @@ -0,0 +1,569 @@
> +/*
> + * drivers/media/video/dw9710.c
> + *
> + * DW9710 Coil Motor (LENS) driver
> + *
> + * Copyright (C) 2008 Texas Instruments.
> + *
> + * Contributors:
> + *     Troy Laramy <t-laramy@ti.com>
> + *     Mohit Jalori <mjalori@ti.com>
> + *
> + * This file is licensed under the terms of the GNU General Public License
> + * version 2. This program is licensed "as is" without any warranty of any
> + * kind, whether express or implied.
> + *
> + */
> +
> +#include <linux/mutex.h>
> +#include <linux/i2c.h>
> +#include <linux/delay.h>
> +#include <media/v4l2-int-device.h>
> +#include <mach/gpio.h>
> +#include <linux/platform_device.h>
> +#include <linux/cdev.h>
> +#include <linux/device.h>
> +
> +#include "dw9710.h"
> +
> +#define DRIVER_NAME  "dw9710"

Here you define DRIVER_NAME. I saw patch(for another module) that
remover MODULE_NAME and places VIVI_MODULE_NAME there. Here it is:
http://linuxtv.org/hg/v4l-dvb/rev/58b95134acb8

May be it's better to define something like this: #define
DW9710_DRIVER_NAME  "dw9710" ?

Probably it will help you to avoid possible namespace conflicts and
code become a bit more readible.

> +static int
> +dw9710_probe(struct i2c_client *client, const struct i2c_device_id *id);
> +static int __exit dw9710_remove(struct i2c_client *client);
> +
> +struct dw9710_device {
> +       const struct dw9710_platform_data *pdata;
> +       struct v4l2_int_device *v4l2_int_device;
> +       struct i2c_client *i2c_client;
> +       int opened;
> +       u16 current_lens_posn;
> +       u16 saved_lens_posn;
> +       int state;
> +       int power_state;
> +};
> +
> +static const struct i2c_device_id dw9710_id[] = {
> +       { DW9710_NAME, 0 },
> +       { }
> +};

Hmmm, looks like you already defined DW9710_NAME in header-file. Why
didn't you reformat to use _one_ define for this and previous place ?

> +MODULE_DEVICE_TABLE(i2c, dw9710_id);
> +
> +static struct i2c_driver dw9710_i2c_driver = {
> +       .driver = {
> +               .name = DW9710_NAME,

Actually, the same thing here.

> +               .owner = THIS_MODULE,
> +       },
> +       .probe = dw9710_probe,
> +       .remove = __exit_p(dw9710_remove),
> +       .id_table = dw9710_id,
> +};
> +
> +static struct dw9710_device dw9710 = {
> +       .state = LENS_NOT_DETECTED,
> +       .current_lens_posn = DEF_LENS_POSN,
> +};
> +
> +static struct vcontrol {
> +       struct v4l2_queryctrl qc;
> +       int current_value;
> +} video_control[] = {
> +       {
> +               {
> +                       .id = V4L2_CID_FOCUS_ABSOLUTE,
> +                       .type = V4L2_CTRL_TYPE_INTEGER,
> +                       .name = "Lens Position",
> +                       .minimum = 0,
> +                       .maximum = MAX_FOCUS_POS,
> +                       .step = LENS_POSN_STEP,
> +                       .default_value = DEF_LENS_POSN,
> +               },
> +               .current_value = DEF_LENS_POSN,
> +       }
> +};
> +
> +static struct i2c_driver dw9710_i2c_driver;
> +
> +/**
> + * find_vctrl - Finds the requested ID in the video control structure array
> + * @id: ID of control to search the video control array for
> + *
> + * Returns the index of the requested ID from the control structure array
> + */
> +static int
> +find_vctrl(int id)
> +{
> +       int i;
> +
> +       if (id < V4L2_CID_BASE)
> +               return -EDOM;
> +
> +       for (i = (ARRAY_SIZE(video_control) - 1); i >= 0; i--)
> +               if (video_control[i].qc.id == id)
> +                       break;
> +       if (i < 0)
> +               i = -EINVAL;
> +       return i;
> +}

In this function you use return after if, and in second place you set
i equals to -EINVAL, and then return. Probably, to make it more easily
to read it's better to do such thing:

if (i < 0)
return -EINVAL;


> +/**
> + * camaf_reg_read - Reads a value from a register in DW9710 Coil driver device.
> + * @client: Pointer to structure of I2C client.
> + * @value: Pointer to u16 for returning value of register to read.
> + *
> + * Returns zero if successful, or non-zero otherwise.
> + **/
> +static int camaf_reg_read(struct i2c_client *client, u16 *value)
> +{
> +       int err;
> +       struct i2c_msg msg[1];
> +       unsigned char data[2];
> +
> +       if (!client->adapter)
> +               return -ENODEV;
> +
> +       msg->addr = client->addr;
> +       msg->flags = I2C_M_RD;
> +       msg->len = 2;
> +       msg->buf = data;
> +
> +       data[0] = 0;
> +       data[1] = 0;
> +
> +       err = i2c_transfer(client->adapter, msg, 1);
> +
> +       if (err >= 0) {
> +               *value = err = ((data[0] & 0xFF) << 8) | (data[1]);

I didn't ever see two "=" in one line in code. Is it okay ?

> +               return 0;
> +       }
> +       return err;
> +}
> +
> +/**
> + * camaf_reg_write - Writes a value to a register in DW9710 Coil driver device.
> + * @client: Pointer to structure of I2C client.
> + * @value: Value of register to write.
> + *
> + * Returns zero if successful, or non-zero otherwise.
> + **/
> +static int camaf_reg_write(struct i2c_client *client, u16 value)
> +{
> +       int err;
> +       struct i2c_msg msg[1];
> +       unsigned char data[2];
> +       int retry = 0;
> +
> +       if (!client->adapter)
> +               return -ENODEV;
> +
> +again:
> +       msg->addr = client->addr;
> +       msg->flags = 0;
> +       msg->len = 2;
> +       msg->buf = data;
> +
> +       data[0] = (u8)(value >> 8);
> +       data[1] = (u8)(value & 0xFF);
> +
> +       err = i2c_transfer(client->adapter, msg, 1);
> +
> +       if (err >= 0)
> +               return 0;
> +
> +       if (retry <= DW9710_I2C_RETRY_COUNT) {
> +               dev_dbg(&client->dev, "retry ... %d", retry);
> +               retry++;
> +               set_current_state(TASK_UNINTERRUPTIBLE);
> +               schedule_timeout(msecs_to_jiffies(20));
> +               goto again;
> +       }
> +       return err;
> +}
> +
> +/**
> + * dw9710_detect - Detects DW9710 Coil driver device.
> + * @client: Pointer to structure of I2C client.
> + *
> + * Returns 0 if successful, -1 if camera is off or if test register value
> + * wasn't stored properly, or returned errors from either camaf_reg_write or
> + * camaf_reg_read functions.
> + **/
> +static int dw9710_detect(struct i2c_client *client)
> +{
> +       int err = 0;
> +       u16 wposn = 0, rposn = 0;
> +       u16 posn = 0x05;
> +
> +       wposn = (CAMAF_DW9710_POWERDN(CAMAF_DW9710_ENABLE) |
> +                                               CAMAF_DW9710_DATA(posn));
> +
> +       err = camaf_reg_write(client, wposn);
> +       if (err) {
> +               printk(KERN_ERR "Unable to write DW9710 \n");
> +               return err;
> +       }
> +
> +       err = camaf_reg_read(client, &rposn);
> +       if (err) {
> +               printk(KERN_ERR "Unable to read DW9710 \n");
> +               return err;
> +       }
> +
> +       if (wposn != rposn) {
> +               printk(KERN_ERR "W/R MISMATCH!\n");

If I were writing it, I'd do the following:

printk(KERN_ERR DRIVER_NAME "W/R MISMATCH!\n");

And driver-name have to be unique, see above.
To be onest it's better to provide module name to dmesg if you(or any
user) want to catch bad behavour.

> +               return -1;
> +       }
> +       posn = 0;
> +       wposn = (CAMAF_DW9710_POWERDN(CAMAF_DW9710_ENABLE) |
> +                                               CAMAF_DW9710_DATA(posn));
> +       err = camaf_reg_write(client, wposn);
> +
> +       return err;
> +}
> +
> +/**
> + * dw9710_af_setfocus - Sets the desired focus.
> + * @posn: Desired focus position, 0 (far) - 100 (close).
> + *
> + * Returns 0 on success, -EINVAL if camera is off or focus value is out of
> + * bounds, or returned errors from either camaf_reg_write or camaf_reg_read
> + * functions.
> + **/
> +int dw9710_af_setfocus(u16 posn)
> +{
> +       struct dw9710_device *af_dev = &dw9710;
> +       struct i2c_client *client = af_dev->i2c_client;
> +       u16 cur_focus_value = 0;
> +       int ret = -EINVAL;
> +
> +       if (posn > MAX_FOCUS_POS) {
> +               printk(KERN_ERR "Bad posn params 0x%x \n", posn);
> +               return ret;
> +       }
> +
> +       if ((af_dev->power_state == V4L2_POWER_OFF) ||
> +               (af_dev->power_state == V4L2_POWER_STANDBY)) {
> +               af_dev->current_lens_posn = posn;
> +               return 0;
> +       }
> +
> +       ret = camaf_reg_read(client, &cur_focus_value);
> +
> +       if (ret) {
> +               printk(KERN_ERR "Read of current Lens position failed\n");
> +               return ret;
> +       }
> +
> +       if (CAMAF_DW9710_DATA_R(cur_focus_value) == posn) {
> +               printk(KERN_DEBUG "Device already in requested focal point\n");
> +               return ret;
> +       }
> +
> +       ret = camaf_reg_write(client,
> +                               CAMAF_DW9710_POWERDN(CAMAF_DW9710_ENABLE) |
> +                               CAMAF_DW9710_DATA(posn));
> +
> +       if (ret)
> +               printk(KERN_ERR "Setfocus register write failed\n");
> +       dw9710.current_lens_posn = posn;
> +       return ret;
> +}
> +EXPORT_SYMBOL(dw9710_af_setfocus);
> +
> +/**
> + * dw9710_af_getfocus - Gets the focus value from device.
> + * @value: Pointer to u16 variable which will contain the focus value.
> + *
> + * Returns 0 if successful, -EINVAL if camera is off, or return value of
> + * camaf_reg_read if fails.
> + **/
> +int dw9710_af_getfocus(u16 *value)
> +{
> +       int ret = -EINVAL;
> +       u16 posn = 0;

Why just don't use int ret;
And later in code use return -EINVAL; ?
Anyway, you change ret variable with reg_read call.

> +       struct dw9710_device *af_dev = &dw9710;
> +       struct i2c_client *client = af_dev->i2c_client;
> +
> +       if ((af_dev->power_state == V4L2_POWER_OFF) ||
> +          (af_dev->power_state == V4L2_POWER_STANDBY))
> +               return ret;
> +
> +       ret = camaf_reg_read(client, &posn);
> +
> +       if (ret) {
> +               printk(KERN_ERR "Read of current Lens position failed\n");
> +               return ret;
> +       }
> +       *value = CAMAF_DW9710_DATA_R(posn);
> +       dw9710.current_lens_posn = CAMAF_DW9710_DATA_R(posn);
> +       return ret;
> +}
> +EXPORT_SYMBOL(dw9710_af_getfocus);
> +
> +/**
> + * ioctl_queryctrl - V4L2 lens interface handler for VIDIOC_QUERYCTRL ioctl
> + * @s: pointer to standard V4L2 device structure
> + * @qc: standard V4L2 VIDIOC_QUERYCTRL ioctl structure
> + *
> + * If the requested control is supported, returns the control information
> + * from the video_control[] array.  Otherwise, returns -EINVAL if the
> + * control is not supported.
> + */
> +static int ioctl_queryctrl(struct v4l2_int_device *s,
> +                               struct v4l2_queryctrl *qc)
> +{
> +       int i;
> +
> +       i = find_vctrl(qc->id);
> +       if (i == -EINVAL)
> +               qc->flags = V4L2_CTRL_FLAG_DISABLED;
> +
> +       if (i < 0)
> +               return -EINVAL;
> +
> +       *qc = video_control[i].qc;
> +       return 0;
> +}
> +
> +/**
> + * ioctl_g_ctrl - V4L2 DW9710 lens interface handler for VIDIOC_G_CTRL ioctl
> + * @s: pointer to standard V4L2 device structure
> + * @vc: standard V4L2 VIDIOC_G_CTRL ioctl structure
> + *
> + * If the requested control is supported, returns the control's current
> + * value from the video_control[] array.  Otherwise, returns -EINVAL
> + * if the control is not supported.
> + */
> +static int ioctl_g_ctrl(struct v4l2_int_device *s,
> +                            struct v4l2_control *vc)
> +{
> +       struct vcontrol *lvc;
> +       int i;
> +       u16 curr_posn;
> +
> +       i = find_vctrl(vc->id);
> +       if (i < 0)
> +               return -EINVAL;
> +       lvc = &video_control[i];
> +
> +       switch (vc->id) {
> +       case  V4L2_CID_FOCUS_ABSOLUTE:
> +               if (dw9710_af_getfocus(&curr_posn))
> +                       return -EFAULT;
> +               vc->value = curr_posn;
> +               lvc->current_value = curr_posn;
> +               break;
> +       }
> +
> +       return 0;
> +}
> +
> +/**
> + * ioctl_s_ctrl - V4L2 DW9710 lens interface handler for VIDIOC_S_CTRL ioctl
> + * @s: pointer to standard V4L2 device structure
> + * @vc: standard V4L2 VIDIOC_S_CTRL ioctl structure
> + *
> + * If the requested control is supported, sets the control's current
> + * value in HW (and updates the video_control[] array).  Otherwise,
> + * returns -EINVAL if the control is not supported.
> + */
> +static int ioctl_s_ctrl(struct v4l2_int_device *s,
> +                            struct v4l2_control *vc)
> +{
> +       int retval = -EINVAL;
> +       int i;
> +       struct vcontrol *lvc;
> +
> +       i = find_vctrl(vc->id);
> +       if (i < 0)
> +               return -EINVAL;
> +       lvc = &video_control[i];
> +
> +       switch (vc->id) {
> +       case V4L2_CID_FOCUS_ABSOLUTE:
> +               retval = dw9710_af_setfocus(vc->value);
> +               if (!retval)
> +                       lvc->current_value = vc->value;
> +               break;
> +       }
> +
> +       return retval;
> +}
> +
> +/**
> + * ioctl_g_priv - V4L2 sensor interface handler for vidioc_int_g_priv_num
> + * @s: pointer to standard V4L2 device structure
> + * @p: void pointer to hold sensor's private data address
> + *
> + * Returns device's (sensor's) private data area address in p parameter
> + */
> +static int ioctl_g_priv(struct v4l2_int_device *s, void *p)
> +{
> +       struct dw9710_device *lens = s->priv;
> +
> +       return lens->pdata->priv_data_set(p);
> +
> +}
> +
> +/**
> + * ioctl_s_power - V4L2 sensor interface handler for vidioc_int_s_power_num
> + * @s: pointer to standard V4L2 device structure
> + * @on: power state to which device is to be set
> + *
> + * Sets devices power state to requrested state, if possible.
> + */
> +static int ioctl_s_power(struct v4l2_int_device *s, enum v4l2_power on)
> +{
> +       struct dw9710_device *lens = s->priv;
> +       struct i2c_client *c = lens->i2c_client;
> +       int rval;
> +
> +       rval = lens->pdata->power_set(on);
> +       if (rval < 0) {
> +               dev_err(&c->dev, "Unable to set the power state: " DRIVER_NAME
> +                                                               " lens HW\n");
> +               return rval;
> +       }
> +
> +       if ((on == V4L2_POWER_ON) && (lens->state == LENS_NOT_DETECTED)) {
> +               rval = dw9710_detect(c);
> +               if (rval < 0) {
> +                       dev_err(&c->dev, "Unable to detect "
> +                               DRIVER_NAME " lens HW\n");
> +                       printk(KERN_ERR "Unable to detect "
> +                               DRIVER_NAME " lens HW\n");

Two thing here. As i know it's more preferable to use dev_macro
instead of printk if possible.
As i know(may be i'm wrong) it's not good to use DRIVER_NAME in dev_err here.
Why do you print the same text two times here ?

> +                       lens->state = LENS_NOT_DETECTED;
> +                       return rval;
> +               }
> +               lens->state = LENS_DETECTED;
> +               pr_info(DRIVER_NAME " lens HW detected\n");
> +       }
> +
> +       if ((lens->power_state == V4L2_POWER_STANDBY) && (on == V4L2_POWER_ON)
> +                                       && (lens->state == LENS_DETECTED))
> +               dw9710_af_setfocus(lens->current_lens_posn);
> +
> +       lens->power_state = on;
> +       return 0;
> +}
> +
> +static struct v4l2_int_ioctl_desc dw9710_ioctl_desc[] = {
> +       { .num = vidioc_int_s_power_num,
> +         .func = (v4l2_int_ioctl_func *)ioctl_s_power },
> +       { .num = vidioc_int_g_priv_num,
> +         .func = (v4l2_int_ioctl_func *)ioctl_g_priv },
> +       { .num = vidioc_int_queryctrl_num,
> +         .func = (v4l2_int_ioctl_func *)ioctl_queryctrl },
> +       { .num = vidioc_int_g_ctrl_num,
> +         .func = (v4l2_int_ioctl_func *)ioctl_g_ctrl },
> +       { .num = vidioc_int_s_ctrl_num,
> +         .func = (v4l2_int_ioctl_func *)ioctl_s_ctrl },
> +};
> +
> +static struct v4l2_int_slave dw9710_slave = {
> +       .ioctls = dw9710_ioctl_desc,
> +       .num_ioctls = ARRAY_SIZE(dw9710_ioctl_desc),
> +};
> +
> +static struct v4l2_int_device dw9710_int_device = {
> +       .module = THIS_MODULE,
> +       .name = DRIVER_NAME,
> +       .priv = &dw9710,
> +       .type = v4l2_int_type_slave,
> +       .u = {
> +               .slave = &dw9710_slave,
> +       },
> +};
> +
> +/**
> + * dw9710_probe - Probes the driver for valid I2C attachment.
> + * @client: Pointer to structure of I2C client.
> + *
> + * Returns 0 if successful, or -EBUSY if unable to get client attached data.
> + **/
> +static int
> +dw9710_probe(struct i2c_client *client, const struct i2c_device_id *id)
> +{
> +       struct dw9710_device *lens = &dw9710;
> +       int err;
> +
> +       dev_info(&client->dev, "dw9710 probe called....\n");
> +
> +       if (i2c_get_clientdata(client)) {
> +               printk(KERN_ERR " DTA BUSY %s\n", client->name);
> +               return -EBUSY;
> +       }
> +
> +       lens->pdata = client->dev.platform_data;
> +
> +       if (!lens->pdata) {
> +               dev_err(&client->dev, "no platform data?\n");
> +               return -ENODEV;
> +       }
> +
> +       lens->v4l2_int_device = &dw9710_int_device;
> +
> +       lens->i2c_client = client;
> +       i2c_set_clientdata(client, lens);
> +
> +       err = v4l2_int_device_register(lens->v4l2_int_device);
> +       if (err) {
> +               printk(KERN_ERR "Failed to Register "
> +                       DRIVER_NAME " as V4L2 device.\n");
> +               i2c_set_clientdata(client, NULL);
> +       } else {
> +               printk(KERN_ERR "Registered "
> +                       DRIVER_NAME " as V4L2 device.\n");
> +       }
> +
> +       return 0;
> +}
> +
> +/**
> + * dw9710_remove - Routine when device its unregistered from I2C
> + * @client: Pointer to structure of I2C client.
> + *
> + * Returns 0 if successful, or -ENODEV if the client isn't attached.
> + **/
> +static int __exit dw9710_remove(struct i2c_client *client)
> +{
> +       if (!client->adapter)
> +               return -ENODEV;
> +
> +       i2c_set_clientdata(client, NULL);
> +       return 0;
> +}
> +
> +/**
> + * dw9710_init - Module initialisation.
> + *
> + * Returns 0 if successful, or -EINVAL if device couldn't be initialized, or
> + * added as a character device.
> + **/
> +static int __init dw9710_init(void)
> +{
> +       int err = -EINVAL;

int err = something, and then changed with call to i2c..

This is all i can suggest, it's not about functionality, it's about
coding style..
Please, use dev_macros if possible instead of printk.


> +       err = i2c_add_driver(&dw9710_i2c_driver);
> +       if (err)
> +               goto fail;
> +       return err;
> +fail:
> +       printk(KERN_ERR "Failed to register " DRIVER_NAME ".\n");
> +       return err;
> +}
> +late_initcall(dw9710_init);
> +
> +/**
> + * dw9710_cleanup - Module cleanup.
> + **/
> +static void __exit dw9710_cleanup(void)
> +{
> +       i2c_del_driver(&dw9710_i2c_driver);
> +}
> +module_exit(dw9710_cleanup);
> +
> +MODULE_AUTHOR("Texas Instruments");
> +MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("DW9710 LENS driver");
> diff --git a/drivers/media/video/dw9710.h b/drivers/media/video/dw9710.h
> new file mode 100644
> index 0000000..e4050a4
> --- /dev/null
> +++ b/drivers/media/video/dw9710.h
> @@ -0,0 +1,59 @@
> +/*
> + * drivers/media/video/dw9710.h
> + *
> + * Register defines for Auto Focus device
> + *
> + * Copyright (C) 2008 Texas Instruments.
> + *
> + * Contributors:
> + *     Troy Laramy <t-laramy@ti.com>
> + *     Mohit Jalori <mjalori@ti.com>
> + *
> + * This file is licensed under the terms of the GNU General Public License
> + * version 2. This program is licensed "as is" without any warranty of any
> + * kind, whether express or implied.
> + *
> + */
> +
> +#ifndef CAMAF_DW9710_H
> +#define CAMAF_DW9710_H
> +
> +#define DW9710_AF_I2C_ADDR     0x0C
> +#define DW9710_NAME            "DW9710"
> +#define DW9710_I2C_RETRY_COUNT 5
> +#define MAX_FOCUS_POS  0xFF
> +
> +#define CAMAF_DW9710_DISABLE           0x1
> +#define CAMAF_DW9710_ENABLE            0x0
> +#define CAMAF_DW9710_POWERDN(ARG)      (((ARG) & 0x1) << 15)
> +#define CAMAF_DW9710_POWERDN_R(ARG)    (((ARG) >> 15) & 0x1)
> +
> +#define CAMAF_DW9710_DATA(ARG)         (((ARG) & 0xFF) << 6)
> +#define CAMAF_DW9710_DATA_R(ARG)       (((ARG) >> 6) & 0xFF)
> +#define CAMAF_FREQUENCY_EQ1(mclk)      ((u16)(mclk/16000))
> +
> +/* State of lens */
> +#define LENS_DETECTED          1
> +#define LENS_NOT_DETECTED      0
> +
> +/* Focus control values */
> +#define DEF_LENS_POSN          0       /* 0x7F */
> +#define LENS_POSN_STEP         1
> +
> +
> +/**
> + * struct dw9710_platform_data - platform data values and access functions
> + * @power_set: Power state access function, zero is off, non-zero is on.
> + * @priv_data_set: device private data (pointer) access function
> + */
> +struct dw9710_platform_data {
> +       int (*power_set)(enum v4l2_power power);
> +       int (*priv_data_set)(void *);
> +};
> +
> +/*
> + * Sets the specified focus value [0(far) - 100(near)]
> + */
> +int dw9710_af_setfocus(u16 posn);
> +int dw9710_af_getfocus(u16 *value);
> +#endif /* End of of CAMAF_DW9710_H */
> --
> 1.5.6.5
>
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>



-- 
Best regards, Klimov Alexey

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
