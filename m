Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:4912 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932545AbZEAO5h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 May 2009 10:57:37 -0400
From: "Zhang, Xiaolin" <xiaolin.zhang@intel.com>
To: Alexey Klimov <klimov.linux@gmail.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Fri, 1 May 2009 22:57:24 +0800
Subject: RE: [PATCH 2/5] V4L2 patches for Intel Moorestown Camera Imaging
 	Drivers
Message-ID: <0A882F4D99BBF6449D58E61AAFD7EDD613793A71@pdsmsx502.ccr.corp.intel.com>
References: <90b950fc0904292317m500820efv66755aed31b46853@mail.gmail.com>
	 <5A47E75E594F054BAF48C5E4FC4B92AB030548BA1B@dbde02.ent.ti.com>
	 <0A882F4D99BBF6449D58E61AAFD7EDD613793936@pdsmsx502.ccr.corp.intel.com>
 <208cbae30904300937j4f25bf9bmd7a95fc4b7fd9bba@mail.gmail.com>
In-Reply-To: <208cbae30904300937j4f25bf9bmd7a95fc4b7fd9bba@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

No mind, welcome any comments.

I am working on this issue why the first patch -isp drive can't send it out. Actually it is a little bit large, size about 800k. I need time to split it.

BRs
Xiaolin

-----Original Message-----
From: Alexey Klimov [mailto:klimov.linux@gmail.com]
Sent: Friday, May 01, 2009 12:37 AM
To: Zhang, Xiaolin
Cc: linux-media@vger.kernel.org; Johnson, Charles F
Subject: Re: [PATCH 2/5] V4L2 patches for Intel Moorestown Camera Imaging Drivers

Hello,
do you mind if i make few comments?

Really, looks like
http://patchwork.kernel.org/project/linux-media/list/
didnt catch your [1/5] patch.

On Thu, Apr 30, 2009 at 12:22 PM, Zhang, Xiaolin
<xiaolin.zhang@intel.com> wrote:
> From d8f37b4340ea4cfd28d6e620f1b3224d946b9fab Mon Sep 17 00:00:00 2001
> From: Xiaolin Zhang <xiaolin.zhang@intel.com>
> Date: Thu, 30 Apr 2009 12:31:21 +0800
> Subject: [PATCH] sensor pseduo driver in camera imaging on Intel moorestown platform.
>  The moorestown platform with dual cameras will have one the same side as
>  the display and the second on the oppsoite side of the display. The pseduo
>  driver provides the uniform interface for isp kernel driver.
>  Signed-off-by: Xiaolin Zhang <xiaolin.zhang@intel.com>
>
> ---
>  drivers/media/video/Makefile                       |    1 +
>  drivers/media/video/mrstci/Kconfig                 |    1 +
>  drivers/media/video/mrstci/include/ci_sensor_ioc.h |   57 +
>  drivers/media/video/mrstci/include/sensordev.h     |  119 +++
>  drivers/media/video/mrstci/mrstsensor/Kconfig      |    9 +
>  drivers/media/video/mrstci/mrstsensor/Makefile     |    3 +
>  drivers/media/video/mrstci/mrstsensor/mrstsensor.c | 1094 ++++++++++++++++++++
>  .../media/video/mrstci/mrstsensor/sensordev_priv.h |   37 +
>  8 files changed, 1321 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/mrstci/include/ci_sensor_ioc.h
>  create mode 100644 drivers/media/video/mrstci/include/sensordev.h
>  create mode 100644 drivers/media/video/mrstci/mrstsensor/Kconfig
>  create mode 100644 drivers/media/video/mrstci/mrstsensor/Makefile
>  create mode 100644 drivers/media/video/mrstci/mrstsensor/mrstsensor.c
>  create mode 100644 drivers/media/video/mrstci/mrstsensor/sensordev_priv.h
>
> diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
> index f06f1cb..34a3461 100644
> --- a/drivers/media/video/Makefile
> +++ b/drivers/media/video/Makefile
> @@ -152,6 +152,7 @@ obj-$(CONFIG_VIDEO_AU0828) += au0828/
>
>  obj-$(CONFIG_USB_VIDEO_CLASS)  += uvc/
>  obj-$(CONFIG_VIDEO_MRST_ISP) += mrstci/mrstisp/
> +obj-$(CONFIG_VIDEO_MRST_SENSOR) += mrstci/mrstsensor/
>
>  EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
>  EXTRA_CFLAGS += -Idrivers/media/dvb/frontends
> diff --git a/drivers/media/video/mrstci/Kconfig b/drivers/media/video/mrstci/Kconfig
> index 8f0a620..bf01447 100644
> --- a/drivers/media/video/mrstci/Kconfig
> +++ b/drivers/media/video/mrstci/Kconfig
> @@ -10,6 +10,7 @@ if VIDEO_MRSTCI && VIDEO_V4L2
>
>  source "drivers/media/video/mrstci/mrstisp/Kconfig"
>
> +source "drivers/media/video/mrstci/mrstsensor/Kconfig"
>
>  endif # VIDEO_MRSTCI
>
> diff --git a/drivers/media/video/mrstci/include/ci_sensor_ioc.h b/drivers/media/video/mrstci/include/ci_sensor_ioc.h
> new file mode 100644
> index 0000000..80d3b0f
> --- /dev/null
> +++ b/drivers/media/video/mrstci/include/ci_sensor_ioc.h
> @@ -0,0 +1,57 @@
> +/*
> + * Support for Moorestown Langwell Camera Imaging ISP subsystem.
> + *
> + * Copyright (c) 2009 Intel Corporation. All Rights Reserved.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License version
> + * 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
> + * 02110-1301, USA.
> + *
> + *
> + * Xiaolin Zhang <xiaolin.zhang@intel.com>
> + */
> +
> +/* Sensor IOCTL */
> +#ifndef _SENSOR_IOC_H
> +#define        _SENSOR_IOC_H
> +
> +#ifdef __cplusplus
> +extern "C" {
> +#endif

Looks interesting. Why is this workaround for C++ here?

> +
> +#define SENSOR_MAGIC 0x83
> +
> +#define SENIOC_QUERYCAP _IOR(SENSOR_MAGIC, 0, struct ci_sensor_caps)
> +#define SENIOC_G_CONFIG _IOR(SENSOR_MAGIC, 1, struct ci_sensor_config)
> +#define SENIOC_S_CONFIG _IOW(SENSOR_MAGIC, 2, struct ci_sensor_config)
> +#define SENIOC_STREAM_ON _IO(SENSOR_MAGIC, 3)
> +#define SENIOC_STREAM_OFF _IO(SENSOR_MAGIC, 4)
> +#define SENIOC_G_REG _IOWR(SENSOR_MAGIC, 5, struct ci_sensor_reg)
> +#define SENIOC_S_REG _IOW(SENSOR_MAGIC, 6, struct ci_sensor_reg)
> +/* Get current focus position */
> +#define SENIOC_MDI_G_FOCUS _IOR(SENSOR_MAGIC, 9, unsigned int)
> +/* Set focus to the given position */
> +#define SENIOC_MDI_S_FOCUS _IOW(SENSOR_MAGIC, 10, unsigned int)
> +/* Trigger a forced calibration of focus hardware */
> +#define SENIOC_MDI_CALIBRATE _IO(SENSOR_MAGIC, 11)
> +#define SENIOC_MDI_MAX_STEP _IOR(SENSOR_MAGIC, 12, unsigned int)
> +/* Get the max step hardware can support */
> +#define SENIOC_ENUMPARM _IOWR(SENSOR_MAGIC, 13, struct ci_sensor_parm)
> +#define SENIOC_G_PARM _IOWR(SENSOR_MAGIC, 14, struct ci_sensor_parm)
> +#define SENIOC_S_PARM _IOW(SENSOR_MAGIC, 15, struct ci_sensor_parm)
> +
> +#ifdef __cplusplus
> +}
> +#endif
> +
> +#endif
> diff --git a/drivers/media/video/mrstci/include/sensordev.h b/drivers/media/video/mrstci/include/sensordev.h
> new file mode 100644
> index 0000000..f4cf603
> --- /dev/null
> +++ b/drivers/media/video/mrstci/include/sensordev.h
> @@ -0,0 +1,119 @@
> +/*
> + * Support for Moorestown Langwell Camera Imaging ISP subsystem.
> + *
> + * Copyright (c) 2009 Intel Corporation. All Rights Reserved.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License version
> + * 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
> + * 02110-1301, USA.
> + *
> + *
> + * Xiaolin Zhang <xiaolin.zhang@intel.com>
> + */
> +
> +#ifndef _SENSOR_DEV_H
> +#define _SENSOR_DEV_H
> +
> +#include "ci_sensor_common.h"
> +
> +/* I2C setting for both sensor and motor */
> +struct i2c_setting{
> +       struct i2c_client *sensor_client;
> +       struct i2c_client *motor_client;
> +};
> +
> +/* Sensor description structure */
> +struct sensor_device{
> +       /* Note: Pointers to not supported parts remain NULL! */
> +       struct device class_dev;
> +       struct device *dev;
> +
> +       /* Name of the camera */
> +       const char name[32];
> +       /* Type of the camera, SoC or Raw */
> +       int type;
> +       /* Minor number for sensor device */
> +       int minor;
> +       /* Desired camera input clock for the camera */
> +       unsigned int clock_freq;
> +       /* Pointer to default configuration */
> +       const struct ci_sensor_config *def_config;
> +       /* I2C for sensor and motor */
> +       struct i2c_setting *i2c;
> +
> +       /* pointers to the sensor specific functions */
> +       /* Device open */
> +       int (*open) (struct i2c_setting *, void *);
> +       /* Close device and power-off */
> +       int (*release) (struct i2c_setting *, void *);
> +       int (*on) (struct i2c_setting *);
> +       int (*off) (struct i2c_setting *);
> +       /* Return sensor capablity */
> +       int (*querycap) (struct i2c_client *, struct ci_sensor_caps *);
> +       /* Return sensor current configuration */
> +       int (*get_config) (struct i2c_client *, struct ci_sensor_config *);
> +       /* Set sensor configration into sensor */
> +       int (*set_config) (struct i2c_client *,
> +                          const struct ci_sensor_config *);
> +       /* Raw sensor specific function to set black level control */
> +       int (*set_blc) (struct i2c_client *,
> +                       const struct ci_sensor_blc_mean *);
> +       /* Raw sensor specific function to set auto white balance */
> +       int (*set_awb) (struct i2c_client *,
> +                       const struct ci_sensor_awb_mean *);
> +       /* Raw sensor specific function to set auto exposure control */
> +       int (*set_aec) (struct i2c_client *,
> +                       const struct ci_sensor_aec_mean *);
> +       /* Return sensor control info */
> +       int (*enum_parm) (struct i2c_client *, struct ci_sensor_parm *);
> +       /* return sensor control value */
> +       int (*get_parm) (struct i2c_client *, struct ci_sensor_parm *);
> +       /* Set sensor control value into sensor */
> +       int (*set_parm) (struct i2c_client *, struct ci_sensor_parm *);
> +       /*
> +        * Raw sensor specific function to get lens correction configuration
> +        * value
> +        */
> +       int (*get_ls_corr_config) (struct i2c_client *,
> +                                  struct ci_sensor_ls_corr_config *);
> +       /* Return sensor supoorted resolution */
> +       int (*try_res) (struct i2c_client *, unsigned short *,
> +                       unsigned short *);
> +       /* Set resolution into sensor */
> +       int (*set_res) (struct i2c_client *, const int, const int);
> +
> +       int (*mdi_get_focus) (struct i2c_client *, unsigned int *focus);
> +       int (*mdi_set_focus) (struct i2c_client *, unsigned int *focus);
> +
> +       int (*mdi_calibrate) (struct i2c_client *);
> +       int (*mdi_max_step) (struct i2c_client *, unsigned int *step);
> +
> +       int (*read) (struct i2c_client *, uint32_t addr, uint32_t *val);
> +       int (*write) (struct i2c_client *, uint32_t addr, uint32_t val);
> +       int (*suspend) (void);
> +       int (*resume) (void);
> +       /* Sensor private data */
> +       void *data;
> +       struct mutex lock;
> +       int state;
> +};
> +
> +/*
> + * Sensor register function for to register device into camera sensor
> + * framework
> + */
> +int sensor_register_device(struct sensor_device *, int);
> +void sensor_unregister_device(struct sensor_device *);
> +int ci_sensor_res2size(u32, u16 *, u16 *);
> +/* _SENSOR_DEV_H */
> +#endif
> diff --git a/drivers/media/video/mrstci/mrstsensor/Kconfig b/drivers/media/video/mrstci/mrstsensor/Kconfig
> new file mode 100644
> index 0000000..97f8817
> --- /dev/null
> +++ b/drivers/media/video/mrstci/mrstsensor/Kconfig
> @@ -0,0 +1,9 @@
> +config VIDEO_MRST_SENSOR
> +       tristate "Moorestown Sensor Pseduo Driver"
> +       depends on VIDEO_MRST_ISP
> +       default y
> +       ---help---
> +         Say Y here if you want to support for cameras based on the Intel Moorestown platform.
> +
> +         To compile this driver as a module, choose M here: the
> +         module will be called mrstsensor.ko.
> diff --git a/drivers/media/video/mrstci/mrstsensor/Makefile b/drivers/media/video/mrstci/mrstsensor/Makefile
> new file mode 100644
> index 0000000..d0295d4
> --- /dev/null
> +++ b/drivers/media/video/mrstci/mrstsensor/Makefile
> @@ -0,0 +1,3 @@
> +obj-$(CONFIG_VIDEO_MRST_SENSOR)         += mrstsensor.o
> +
> +EXTRA_CFLAGS   +=      -I$(src)/../include
> \ No newline at end of file
> diff --git a/drivers/media/video/mrstci/mrstsensor/mrstsensor.c b/drivers/media/video/mrstci/mrstsensor/mrstsensor.c
> new file mode 100644
> index 0000000..40aee6d
> --- /dev/null
> +++ b/drivers/media/video/mrstci/mrstsensor/mrstsensor.c
> @@ -0,0 +1,1094 @@
> +/*
> + * Support for Moorestown Langwell Camera Imaging ISP subsystem.
> + *
> + * Copyright (c) 2009 Intel Corporation. All Rights Reserved.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License version
> + * 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
> + * 02110-1301, USA.
> + *
> + *
> + * Xiaolin Zhang <xiaolin.zhang@intel.com>
> + */
> +
> +#include <linux/module.h>
> +#include <linux/types.h>
> +#include <linux/kernel.h>
> +#include <linux/mm.h>
> +#include <linux/string.h>
> +#include <linux/errno.h>
> +#include <linux/init.h>
> +#include <linux/kmod.h>
> +#include <linux/device.h>
> +#include <linux/i2c.h>
> +#include <linux/fs.h>
> +#include <linux/videodev2.h>
> +#include <linux/uaccess.h>
> +#include <asm/system.h>
> +#include <linux/gpio.h>
> +
> +#include "sensordev_priv.h"
> +
> +#define GPIO_SCLK_25   44
> +#define GPIO_STDBY1_PIN        48
> +#define GPIO_STDBY2_PIN        49
> +#define GPIO_RESET_PIN 50
> +
> +static int def_sensor;
> +static struct sensor_device *sensor_device[AMOUNT_OF_CAM_DRIVERS];
> +static struct sensor_device *sensor_cur;
> +static DEFINE_MUTEX(sensordev_lock);
> +
> +/*
> + * sysfs stuff
> + */
> +static ssize_t show_name(struct device *cd,
> +                        struct device_attribute *attr, char *buf)
> +{
> +       struct sensor_device *sdp = container_of(cd, struct sensor_device,
> +                                                class_dev);
> +       /* Need to get back here */
> +       return sprintf(buf, "%.*s\n", (int)sizeof(sdp->name), sdp->name);
> +}
> +
> +static struct device_attribute sensor_device_attrs[] = {
> +       __ATTR(name, S_IRUGO, show_name, NULL),
> +       __ATTR_NULL
> +};
> +
> +static void sensor_class_release(struct device *cd)
> +{
> +       ;
> +}
> +
> +static struct class sensor_class = {
> +       .name    = "mrstsensor",
> +       .dev_attrs = sensor_device_attrs,
> +       .dev_release = sensor_class_release,
> +};
> +
> +/*
> + *     Active devices
> + */
> +static struct sensor_device *sensor_devdata(struct file *file)
> +{
> +       return sensor_device[iminor(file->f_path.dentry->d_inode)];
> +}
> +
> +int ci_sensor_res2size(unsigned int res, unsigned short *h_size,
> +                      unsigned short *v_size)
> +{
> +       unsigned short hsize;
> +       unsigned short vsize;
> +       int err = 0;
> +
> +       switch (res) {
> +       case SENSOR_RES_QQCIF:
> +               hsize = QQCIF_SIZE_H;
> +               vsize = QQCIF_SIZE_V;
> +               break;
> +       case SENSOR_RES_QQVGA:
> +               hsize = QQVGA_SIZE_H;
> +               vsize = QQVGA_SIZE_V;
> +               break;
> +       case SENSOR_RES_QCIF:
> +               hsize = QCIF_SIZE_H;
> +               vsize = QCIF_SIZE_V;
> +               break;
> +       case SENSOR_RES_QVGA:
> +               hsize = QVGA_SIZE_H;
> +               vsize = QVGA_SIZE_V;
> +               break;
> +       case SENSOR_RES_CIF:
> +               hsize = CIF_SIZE_H;
> +               vsize = CIF_SIZE_V;
> +               break;
> +       case SENSOR_RES_VGA:
> +               hsize = VGA_SIZE_H;
> +               vsize = VGA_SIZE_V;
> +               break;
> +       case SENSOR_RES_SVGA:
> +               hsize = SVGA_SIZE_H;
> +               vsize = SVGA_SIZE_V;
> +               break;
> +       case SENSOR_RES_XGA:
> +               hsize = XGA_SIZE_H;
> +               vsize = XGA_SIZE_V;
> +               break;
> +       case SENSOR_RES_XGA_PLUS:
> +               hsize = XGA_PLUS_SIZE_H;
> +               vsize = XGA_PLUS_SIZE_V;
> +               break;
> +       case SENSOR_RES_SXGA:
> +               hsize = SXGA_SIZE_H;
> +               vsize = SXGA_SIZE_V;
> +               break;
> +       case SENSOR_RES_UXGA:
> +               hsize = UXGA_SIZE_H;
> +               vsize = UXGA_SIZE_V;
> +               break;
> +       case SENSOR_RES_QXGA:
> +               hsize = QXGA_SIZE_H;
> +               vsize = QXGA_SIZE_V;
> +               break;
> +       case SENSOR_RES_QSXGA:
> +               hsize = QSXGA_SIZE_H;
> +               vsize = QSXGA_SIZE_V;
> +               break;
> +       case SENSOR_RES_QSXGA_PLUS:
> +               hsize = QSXGA_PLUS_SIZE_H;
> +               vsize = QSXGA_PLUS_SIZE_V;
> +               break;
> +       case SENSOR_RES_QSXGA_PLUS2:
> +               hsize = QSXGA_PLUS2_SIZE_H;
> +               vsize = QSXGA_PLUS2_SIZE_V;
> +               break;
> +       case SENSOR_RES_QSXGA_PLUS3:
> +               hsize = QSXGA_PLUS3_SIZE_H;
> +               vsize = QSXGA_PLUS3_SIZE_V;
> +               break;
> +       case SENSOR_RES_WQSXGA:
> +               hsize = WQSXGA_SIZE_H;
> +               vsize = WQSXGA_SIZE_V;
> +               break;
> +       case SENSOR_RES_QUXGA:
> +               hsize = QUXGA_SIZE_H;
> +               vsize = QUXGA_SIZE_V;
> +               break;
> +       case SENSOR_RES_WQUXGA:
> +               hsize = WQUXGA_SIZE_H;
> +               vsize = WQUXGA_SIZE_V;
> +               break;
> +       case SENSOR_RES_HXGA:
> +               hsize = HXGA_SIZE_H;
> +               vsize = HXGA_SIZE_V;
> +               break;
> +       case SENSOR_RES_RAWMAX:
> +               hsize = RAWMAX_SIZE_H;
> +               vsize = RAWMAX_SIZE_V;
> +               break;
> +       case SENSOR_RES_YUV_HMAX:
> +               hsize = YUV_HMAX_SIZE_H;
> +               vsize = YUV_HMAX_SIZE_V;
> +               break;
> +       case SENSOR_RES_YUV_VMAX:
> +               hsize = YUV_VMAX_SIZE_H;
> +               vsize = YUV_VMAX_SIZE_V;
> +               break;
> +       case SENSOR_RES_BP1:
> +               hsize = BP1_SIZE_H;
> +               vsize = BP1_SIZE_V;
> +               break;
> +       case SENSOR_RES_L_AFM:
> +               hsize = L_AFM_SIZE_H;
> +               vsize = L_AFM_SIZE_V;
> +               break;
> +       case SENSOR_RES_M_AFM:
> +               hsize = M_AFM_SIZE_H;
> +               vsize = M_AFM_SIZE_V;
> +               break;
> +       case SENSOR_RES_S_AFM:
> +               hsize = S_AFM_SIZE_H;
> +               vsize = S_AFM_SIZE_V;
> +               break;
> +
> +       case SENSOR_RES_QXGA_PLUS:
> +               hsize = QXGA_PLUS_SIZE_H;
> +               vsize = QXGA_PLUS_SIZE_V;
> +               break;
> +
> +       case SENSOR_RES_1080P:
> +               hsize = RES_1080P_SIZE_H;
> +               vsize = 1080;
> +               break;
> +
> +       case SENSOR_RES_720P:
> +               hsize = RES_720P_SIZE_H;
> +               vsize = RES_720P_SIZE_V;
> +               break;
> +
> +       default:
> +               hsize = 0;
> +               vsize = 0;
> +               err = -1;
> +               printk(KERN_ERR "ci_sensor_res2size: Resolution 0x%08x"
> +                      "unknown\n", res);
> +               break;
> +       }
> +
> +       if (h_size != NULL)
> +               *h_size = hsize;
> +       if (v_size != NULL)
> +               *v_size = vsize;
> +
> +       return err;
> +}
> +EXPORT_SYMBOL(ci_sensor_res2size);
> +
> +static int __sensor_do_ioctl(struct inode *inode, struct file *file,
> +                            unsigned int cmd, void *arg)
> +{
> +       struct sensor_device *sdp = sensor_devdata(file);
> +       struct i2c_client *sc = sdp->i2c->sensor_client;
> +       struct i2c_client *mc = sdp->i2c->motor_client;
> +
> +       int err = -EINVAL;
> +
> +       if (sdp == NULL) {
> +               printk(KERN_WARNING "Device should be open first\n");
> +               return -1;
> +       }
> +
> +       if (sdp->state == SENSOR_SUSPEND) {
> +               printk(KERN_INFO "Device in suspend mode, wakeup first\n");
> +               /* ci_sensor_resume(); */
> +               return -1;
> +       }
> +
> +       switch (cmd) {
> +       case SENIOC_G_REG:
> +       {
> +               struct ci_sensor_reg *reg = (struct ci_sensor_reg *)arg;
> +
> +               if (!sdp->read)
> +                       break;
> +               err = sdp->read(sc, reg->addr, &reg->value);
> +
> +               break;
> +       }
> +       case SENIOC_S_REG:
> +       {
> +               struct ci_sensor_reg *reg = (struct ci_sensor_reg *)arg;
> +
> +               if (!sdp->write)
> +                       break;
> +               err = sdp->write(sc, reg->addr, reg->value);
> +
> +               break;
> +       }
> +       case SENIOC_STREAM_ON:
> +       {
> +               if (sensor_cur != NULL) {
> +                       printk(KERN_ERR "sensor_stream_on: Another camera is"
> +                              "in use, close it first\n");
> +                       break;
> +               }
> +
> +               if (sensor_cur == sdp) {
> +                       /* Sensor is in use, stop here */
> +                       printk(KERN_WARNING "sensor_stream_on: The camera is"
> +                              "already in use\n");
> +                       err = 0;
> +                       break;
> +               }
> +
> +               if (sdp->on)
> +                       err = sdp->on(sdp->i2c);
> +               if (err) {
> +                       printk(KERN_ERR "sensor_stream_on: Error while open"
> +                              "the device\n");
> +                       break;
> +               }
> +
> +               /* Need to wake up this sensor  */
> +               sensor_cur = sdp;
> +               err = 0;
> +               break;
> +       }
> +
> +       case SENIOC_STREAM_OFF:
> +       {
> +               if (sensor_cur != sdp) {
> +                       printk(KERN_WARNING "sensor_stream_off: The device is"
> +                              "not in use\n");
> +                       break;
> +               }
> +
> +               if (sdp->off)
> +                       err = sdp->off(sdp->i2c);
> +               if (err) {
> +                       printk(KERN_ERR "sensor_stream_off: Error while off the"
> +                              " device\n");
> +                       break;
> +               }
> +
> +               sensor_cur = NULL;
> +               break;
> +       }
> +       /* --- capabilities ----------------------------------------------- */
> +       case SENIOC_QUERYCAP:
> +       {
> +               struct ci_sensor_caps *cap = (struct ci_sensor_caps *)arg;
> +               memset(cap, 0, sizeof(*cap));
> +
> +               if (!sdp->querycap)
> +                       break;
> +
> +               err = sdp->querycap(sc, cap);
> +               break;
> +       }
> +
> +       /* --- configuration ioctls --------------------------------------- */
> +       case SENIOC_G_CONFIG:
> +       {
> +               struct ci_sensor_config *config;
> +               config = (struct ci_sensor_config *)arg;
> +               memset(config, 0, sizeof(*config));
> +
> +               if (!sdp->get_config)
> +                       break;
> +
> +               err = sdp->get_config(sc, config);
> +               break;
> +       }
> +       case SENIOC_S_CONFIG:
> +       {
> +               struct ci_sensor_config *config;
> +               config = (struct ci_sensor_config *)arg;
> +
> +               if (!sdp->set_config)
> +                       break;
> +
> +               err = sdp->set_config(sc, config);
> +               break;
> +
> +       }
> +
> +       /* --- Parameters ioctls ------------------------------------------- */
> +       case SENIOC_ENUMPARM:
> +       {
> +               struct ci_sensor_parm *parm;
> +               parm = (struct ci_sensor_parm *)arg;
> +
> +               if (!sdp->enum_parm)
> +                       break;
> +
> +               err = sdp->enum_parm(sc, parm);
> +               break;
> +       }
> +       case SENIOC_G_PARM:
> +       {
> +               struct ci_sensor_parm *parm;
> +               parm = (struct ci_sensor_parm *)arg;
> +
> +               if (!sdp->get_parm)
> +                       break;
> +
> +               err = sdp->get_parm(sc, parm);
> +               break;
> +       }
> +       case SENIOC_S_PARM:
> +       {
> +               struct ci_sensor_parm *parm;
> +               parm = (struct ci_sensor_parm *)arg;
> +
> +               if (!sdp->set_parm)
> +                       break;
> +
> +               err = sdp->set_parm(sc, parm);
> +               break;
> +       }
> +       case SENIOC_MDI_G_FOCUS:
> +       {
> +               unsigned int *focus = (unsigned int *)arg;
> +
> +               if (!sdp->mdi_get_focus)
> +                       break;
> +
> +               err = sdp->mdi_get_focus(mc, focus);
> +               break;
> +       }
> +       case SENIOC_MDI_S_FOCUS:
> +       {
> +               unsigned int *focus = (unsigned int *)arg;
> +
> +               if (!sdp->mdi_set_focus)
> +                       break;
> +
> +               err = sdp->mdi_set_focus(mc, focus);
> +               break;
> +       }
> +       case SENIOC_MDI_CALIBRATE:
> +       {
> +               if (!sdp->mdi_calibrate)
> +                       break;
> +
> +               err = sdp->mdi_calibrate(mc);
> +               break;
> +       }
> +       case SENIOC_MDI_MAX_STEP:
> +       {
> +               unsigned int *step = (unsigned int *)arg;
> +
> +               if (!sdp->mdi_max_step)
> +                       break;
> +
> +               err = sdp->mdi_max_step(mc, step);
> +               break;
> +       }
> +       default:
> +               printk(KERN_WARNING "Unmatched IOCTL: %d in CI\n", cmd);
> +       } /* switch */
> +
> +       return err;
> +}
> +
> +int ci_sensor_ioctl(struct inode *inode, struct file *file,
> +                   unsigned int cmd, unsigned long arg)
> +{
> +       char    sbuf[128];
> +       void    *mbuf = NULL;
> +       void    *parg = NULL;
> +       int     err  = -EINVAL;
> +
> +       /*  Copy arguments into temp kernel buffer  */
> +       switch (_IOC_DIR(cmd)) {
> +       case _IOC_NONE:
> +               parg = NULL;
> +               break;
> +       case _IOC_READ:
> +       case _IOC_WRITE:
> +       case (_IOC_WRITE | _IOC_READ):
> +               if (_IOC_SIZE(cmd) <= sizeof(sbuf))
> +                       parg = sbuf;
> +               else {
> +                       /* too big to allocate from stack */
> +                       mbuf = kmalloc(_IOC_SIZE(cmd), GFP_KERNEL);
> +                       if (NULL == mbuf)
> +                               return -ENOMEM;
> +                       parg = mbuf;
> +               }
> +
> +               err = -EFAULT;
> +               if (_IOC_DIR(cmd) & _IOC_WRITE)
> +                       if (copy_from_user(parg, (void __user *)arg,
> +                                          _IOC_SIZE(cmd)))
> +                               goto out;
> +               break;
> +       }
> +
> +       /* Handles IOCTL */
> +       err = __sensor_do_ioctl(inode, file, cmd, parg);
> +       if (err == -ENOIOCTLCMD)
> +               err = -EINVAL;
> +
> +       switch (_IOC_DIR(cmd)) {
> +       case _IOC_READ:
> +       case (_IOC_WRITE | _IOC_READ):
> +               if (copy_to_user((void __user *)arg, parg, _IOC_SIZE(cmd)))
> +                       err = -EFAULT;
> +               break;
> +       }
> +out:
> +       kfree(mbuf);
> +       return err;
> +}
> +EXPORT_SYMBOL(ci_sensor_ioctl);
> +
> +int ci_sensor_get_caps(struct ci_sensor_caps *caps)
> +{
> +       int err = 0;
> +       struct i2c_client *sc;
> +
> +       if (caps == NULL)
> +               return -EIO;
> +
> +       if (sensor_cur == NULL) {
> +               printk(KERN_WARNING "sensor_get_caps: No current camera\n");
> +               return -ENODEV;
> +       }
> +       sc = sensor_cur->i2c->sensor_client;
> +       /* init struct with 0 */
> +       memset(caps, 0, sizeof(*caps));
> +
> +       if (sensor_cur->querycap != NULL)
> +               err = sensor_cur->querycap(sc, caps);
> +       else {
> +               err = -EIO;
> +               printk(KERN_WARNING "sensor_get_caps: Not supported!\n");
> +       }
> +
> +       return err;
> +}
> +EXPORT_SYMBOL(ci_sensor_get_caps);
> +
> +int ci_sensor_get_config(struct ci_sensor_config *config)
> +{
> +       int err = 0;
> +       struct i2c_client *sc;
> +
> +       if (config == NULL)
> +               return -EIO;
> +
> +       if (sensor_cur == NULL) {
> +               printk(KERN_WARNING "sensor_get_config: No current camera\n");
> +               return -ENODEV;
> +       }
> +       sc = sensor_cur->i2c->sensor_client;
> +       /* init struct with 0 */
> +       memset(config, 0, sizeof(*config));
> +
> +       if (sensor_cur->get_config != NULL)
> +               err = sensor_cur->get_config(sc, config);
> +       else {
> +               err = -EIO;
> +               printk(KERN_WARNING "sensor_get_config: Not supported!\n");
> +       }
> +
> +       return err;
> +}
> +EXPORT_SYMBOL(ci_sensor_get_config);
> +
> +int ci_sensor_get_ls_corr_config(struct ci_sensor_ls_corr_config *config)
> +{
> +       int err = 0;
> +       struct i2c_client *sc;
> +
> +       if (config == NULL)
> +               return -EIO;
> +
> +       if (sensor_cur == NULL) {
> +               printk(KERN_WARNING "sensor_get_ls_config: No current"
> +                      "camera\n");
> +               return -ENODEV;
> +       }
> +       sc = sensor_cur->i2c->sensor_client;
> +       /* init struct with 0 */
> +       memset(config, 0, sizeof(*config));
> +
> +       if (sensor_cur->get_ls_corr_config != NULL)
> +               err = sensor_cur->get_ls_corr_config(sc, config);
> +       else {
> +               err = -EIO;
> +               printk(KERN_WARNING "sensor_get_config: Not supported!\n");
> +       }
> +
> +       return err;
> +}
> +EXPORT_SYMBOL(ci_sensor_get_ls_corr_config);
> +
> +int ci_sensor_suspend(void)
> +{
> +       int err = 0;
> +
> +       if (sensor_cur == NULL)
> +               return 0;
> +
> +       if (sensor_cur->suspend != NULL)
> +               err = sensor_cur->suspend();
> +       if (!err)
> +               sensor_cur->state = SENSOR_SUSPEND;
> +
> +       return err;
> +}
> +EXPORT_SYMBOL(ci_sensor_suspend);
> +
> +int ci_sensor_resume(void)
> +{
> +       int err = 0;
> +
> +       if (sensor_cur == NULL)
> +               return 0;
> +
> +       if (sensor_cur->resume != NULL)
> +               err = sensor_cur->resume();
> +       if (!err)
> +               sensor_cur->state = SENSOR_RUNNING;
> +
> +       return err;
> +}
> +EXPORT_SYMBOL(ci_sensor_resume);
> +
> +/* This will start default sensor */
> +int ci_sensor_start(void)
> +{
> +       int err = 0;
> +       int offset;
> +       struct sensor_device *vfl;
> +
> +       offset = def_sensor;
> +       mutex_lock(&sensordev_lock);
> +       if (!sensor_device[offset]) {
> +               if (!sensor_device[offset + MINOR_MAX]) {
> +                       mutex_unlock(&sensordev_lock);
> +                       printk(KERN_WARNING "sensor_start: NULL device\n");
> +                       return -EIO;
> +               } else
> +                       offset += MINOR_MAX;
> +       }
> +
> +       vfl = sensor_device[offset];
> +       if (sensor_cur == vfl) {
> +               mutex_unlock(&sensordev_lock);
> +               /* Sensor is in use, stop here */
> +               printk(KERN_INFO "sensor_start: The camera is"
> +                      "already in use\n");
> +               return 0;
> +       }
> +       if (sensor_cur != NULL) {
> +               mutex_unlock(&sensordev_lock);
> +               printk(KERN_ERR "sensor_start: Another camera is in"
> +                      "use, close it first\n");
> +               return -EIO;
> +       }
> +
> +       if (vfl->open)
> +               err = vfl->open(vfl->i2c, vfl->data);
> +       if (err) {
> +               mutex_unlock(&sensordev_lock);
> +               printk(KERN_ERR "sensor_start: Error while open device\n");
> +               return -EIO;
> +       }
> +       if (vfl->on)
> +               err = vfl->on(vfl->i2c);
> +       if (err) {
> +               mutex_unlock(&sensordev_lock);
> +               printk(KERN_ERR "sensor_start: Error while open device\n");
> +               return -EIO;
> +       }
> +
> +       /* Need to wake up this sensor  */
> +       sensor_cur = vfl;
> +       sensor_cur->state = SENSOR_RUNNING;
> +       mutex_unlock(&sensordev_lock);
> +
> +       return err;
> +}
> +EXPORT_SYMBOL(ci_sensor_start);
> +
> +int ci_sensor_stop(void)
> +{
> +       int err = 0;
> +       struct sensor_device *vfl;
> +       int offset;
> +
> +       offset = def_sensor;
> +       mutex_lock(&sensordev_lock);
> +       if (!sensor_device[offset]) {
> +               if (!sensor_device[offset + MINOR_MAX]) {
> +                       mutex_unlock(&sensordev_lock);
> +                       printk(KERN_WARNING "sensor_stop: NULL device\n");
> +                       return -EIO;
> +               } else
> +                       offset += MINOR_MAX;
> +       }
> +
> +       vfl = sensor_device[offset];
> +       if (vfl == NULL) {
> +               mutex_unlock(&sensordev_lock);
> +               printk(KERN_WARNING "sensor_stop: No such device\n");
> +               return -ENODEV;
> +       }
> +
> +       if (sensor_cur != vfl) {
> +               mutex_unlock(&sensordev_lock);
> +               printk(KERN_WARNING "sensor_stop: The device is not in"
> +                      "use\n");
> +               return -EIO;
> +       }
> +       if (vfl->release)
> +               err = vfl->release(vfl->i2c, vfl->data);
> +       if (err) {
> +               mutex_unlock(&sensordev_lock);
> +               printk(KERN_ERR "sensor_stop: Error while release"
> +                      "device\n");
> +               return -EIO;
> +       }
> +
> +       vfl->state = SENSOR_INIT;
> +       sensor_cur = NULL;
> +       mutex_unlock(&sensordev_lock);
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL(ci_sensor_stop);
> +
> +int ci_sensor_try_mode(int *width, int *high)
> +{
> +       int err = 0;
> +       struct i2c_client *sc;
> +
> +       if (sensor_cur == NULL) {
> +               printk(KERN_WARNING "sensor_try_mode: No current camera\n");

Will user understand what module generates such messages?
Is it better to add module name in such messages everywhere in your patches?
The better variant here is dev_warn, dev_info or if you will use v4l2
framework - v4l2_info, etc.

> +               return -ENODEV;
> +       }
> +
> +       sc = sensor_cur->i2c->sensor_client;
> +       if (sensor_cur->try_res != NULL)
> +               err = sensor_cur->try_res(sc, (u16 *)width, (u16 *)high);
> +       else {
> +               err = -EIO;
> +               printk(KERN_WARNING "sensor_try_mode: Not supported!\n");
> +       }
> +
> +       return err;
> +}
> +EXPORT_SYMBOL(ci_sensor_try_mode);
> +
> +int ci_sensor_set_mode(const int width, const int high)
> +{
> +       int err = 0;
> +       struct i2c_client *sc;
> +
> +       if (sensor_cur == NULL) {
> +               printk(KERN_WARNING "sensor_set_mode: No current camera\n");
> +               return -ENODEV;
> +       }
> +
> +       sc = sensor_cur->i2c->sensor_client;
> +       if (sensor_cur->set_res != NULL)
> +               err = sensor_cur->set_res(sc, width, high);
> +       else {
> +               err = -EIO;
> +               printk(KERN_WARNING "sensor_set_mode: Not supported!\n");
> +       }
> +
> +       return err;
> +}
> +EXPORT_SYMBOL(ci_sensor_set_mode);
> +
> +int ci_sensor_queryctrl(struct v4l2_queryctrl *qc)
> +{
> +       int err = 0;
> +       struct ci_sensor_parm *parm;
> +       struct i2c_client *sc;
> +
> +       if (qc == NULL)
> +               return -EIO;
> +
> +       if (sensor_cur == NULL) {
> +               printk(KERN_WARNING "sensor_queryctrl: No current camera\n");
> +               return -ENODEV;
> +       }
> +
> +       sc = sensor_cur->i2c->sensor_client;
> +       parm = kzalloc(sizeof(struct ci_sensor_parm), GFP_KERNEL);
> +       if (parm == NULL)
> +               return -ENOMEM;
> +       parm->index = qc->id;
> +       if (sensor_cur->enum_parm != NULL)
> +               err = sensor_cur->enum_parm(sc, parm);
> +       else {
> +               err = -EIO;
> +               printk(KERN_WARNING "sensor_queryctrl: Not supported!\n");
> +       }
> +
> +       if (!err) {
> +               qc->type = parm->type;
> +               /* XXX */
> +               strncpy(qc->name, parm->name, 32);
> +               qc->minimum = parm->min;
> +               qc->maximum = parm->max;
> +               qc->step = parm->step;
> +               qc->default_value = parm->def_value;
> +               qc->flags = parm->flags;
> +       }
> +       kfree(parm);
> +
> +       return err;
> +}
> +EXPORT_SYMBOL(ci_sensor_queryctrl);
> +
> +int ci_sensor_get_ctrl(struct v4l2_control *qc)
> +{
> +       int err = 0;
> +       struct ci_sensor_parm *parm;
> +       struct i2c_client *sc;
> +
> +       if (qc == NULL)
> +               return -EIO;
> +
> +       if (sensor_cur == NULL) {
> +               printk(KERN_WARNING "sensor_get_ctrl: No current camera\n");
> +               return -ENODEV;
> +       }
> +
> +       sc = sensor_cur->i2c->sensor_client;
> +       parm = kzalloc(sizeof(struct ci_sensor_parm), GFP_KERNEL);
> +       if (parm == NULL)
> +               return -ENOMEM;
> +       parm->index = qc->id;
> +       if (sensor_cur->get_parm != NULL)
> +               err = sensor_cur->get_parm(sc, parm);
> +       else {
> +               err = -EIO;
> +               printk(KERN_WARNING "sensor_get_ctrl: Not supported!\n");
> +       }
> +       if (!err)
> +               qc->value = parm->value;
> +
> +       kfree(parm);
> +       return err;
> +}
> +EXPORT_SYMBOL(ci_sensor_get_ctrl);
> +
> +int ci_sensor_set_ctrl(struct v4l2_control *qc)
> +{
> +       int err = 0;
> +       struct ci_sensor_parm *parm;
> +       struct i2c_client *sc;
> +
> +       if (qc == NULL)
> +               return -EIO;
> +
> +       if (sensor_cur == NULL) {
> +               printk(KERN_WARNING "sensor_set_ctrl: No current camera\n");
> +               return -ENODEV;
> +       }
> +
> +       sc = sensor_cur->i2c->sensor_client;
> +       parm = kzalloc(sizeof(struct ci_sensor_parm), GFP_KERNEL);
> +       if (parm == NULL)
> +               return -ENOMEM;
> +       parm->index  = qc->id;
> +       parm->value = qc->value;
> +       /* XXX */
> +       if (sensor_cur->set_parm != NULL)
> +               err = sensor_cur->set_parm(sc, parm);
> +       else {
> +               err = -EIO;
> +               printk(KERN_WARNING "sensor_set_ctrl: Not supported!\n");
> +       }
> +
> +       kfree(parm);
> +       return err;
> +}
> +EXPORT_SYMBOL(ci_sensor_set_ctrl);
> +
> +/*
> + * Specific sensor driver register function
> + */
> +int sensor_register_device(struct sensor_device *sdp, int type)
> +{
> +       int nr, err;
> +       int base;
> +       char *name;
> +
> +       switch (type) {
> +       case SENSOR_TYPE_SOC:
> +               base = 0;
> +               name = "SoC";
> +               break;
> +       case SENSOR_TYPE_RAW:
> +               base = MINOR_MAX;
> +               name = "Raw";
> +               break;
> +       default:
> +               printk(KERN_ERR "%s called with unknown type: %d\n",
> +                      __func__, type);
> +               return -1;
> +       }
> +
> +       /* Check if already have a minor number */
> +       if (sdp->minor != -1)
> +               return -ENFILE;
> +
> +       /* Get the minor number */
> +       mutex_lock(&sensordev_lock);
> +       for (nr = base; nr < (base + MINOR_MAX); nr++)
> +               if (NULL == sensor_device[nr])
> +                       break;
> +       if (nr == (base + MINOR_MAX)) {
> +               mutex_unlock(&sensordev_lock);
> +               return -ENFILE;
> +       }
> +
> +       sensor_device[nr] = sdp;
> +       sdp->minor = nr;
> +
> +       mutex_unlock(&sensordev_lock);
> +       mutex_init(&sdp->lock);
> +
> +       /* sysfs class */
> +       memset(&sdp->class_dev, 0x00, sizeof(sdp->class_dev));
> +       if (sdp->dev)
> +               sdp->class_dev.parent = sdp->dev;
> +       sdp->class_dev.class       = &sensor_class;
> +       sdp->class_dev.devt        = MKDEV(SENSOR_MAJOR, sdp->minor);
> +       dev_set_name(&sdp->class_dev, "%s%d", name, nr);
> +       err = device_register(&sdp->class_dev);
> +       if (err < 0) {
> +               printk(KERN_ERR "%s: device_register failed\n",
> +                      __func__);
> +               goto fail_minor;
> +       }
> +
> +       return 0;
> +
> +fail_minor:
> +       mutex_lock(&sensordev_lock);
> +       sensor_device[sdp->minor] = NULL;
> +       sdp->minor = -1;
> +       mutex_unlock(&sensordev_lock);
> +       return err;
> +}
> +EXPORT_SYMBOL(sensor_register_device);
> +
> +void sensor_unregister_device(struct sensor_device *sdp)
> +{
> +       mutex_lock(&sensordev_lock);
> +       if (sensor_device[sdp->minor] != sdp)
> +               panic("sensordev: bad unregister");
> +
> +       if (sensor_device[sdp->minor] == sensor_cur)
> +               sensor_cur = NULL;
> +       sensor_device[sdp->minor] = NULL;
> +       device_unregister(&sdp->class_dev);
> +       mutex_unlock(&sensordev_lock);
> +}
> +EXPORT_SYMBOL(sensor_unregister_device);
> +
> +static int ci_sensor_release(struct inode *inode, struct file *file)
> +{
> +       unsigned int minor = iminor(inode);
> +       int err = 0;
> +       struct sensor_device *vfl;
> +
> +       if (minor < 0 || minor >= AMOUNT_OF_CAM_DRIVERS)
> +               return -ENODEV;
> +
> +       vfl = sensor_device[minor];
> +       if (vfl == NULL) {
> +               printk(KERN_WARNING "sensor_release: No such device\n");
> +               return -ENODEV;
> +       }
> +
> +       if (vfl == sensor_cur) {
> +               if (vfl->release)
> +                       err = vfl->release(vfl->i2c, vfl->data);
> +               if (err) {
> +                       printk(KERN_ERR "sensor_release: Error while close"
> +                              "device\n");
> +                       return -EIO;
> +               }
> +
> +               mutex_lock(&sensordev_lock);
> +               sensor_cur = NULL;
> +               vfl->state = SENSOR_INIT;
> +               mutex_unlock(&sensordev_lock);
> +       }
> +       return 0;
> +}
> +
> +/*
> + * Open a sensor device
> + */
> +static int ci_sensor_open(struct inode *inode, struct file *file)
> +{
> +       unsigned int minor = iminor(inode);
> +       int err = 0;
> +       struct sensor_device *vfl;
> +
> +       if (minor >= AMOUNT_OF_CAM_DRIVERS || minor < 0)
> +               return -ENODEV;
> +
> +       mutex_lock(&sensordev_lock);
> +       vfl = sensor_device[minor];
> +       if (vfl == NULL) {
> +               mutex_unlock(&sensordev_lock);
> +               printk(KERN_WARNING "sensor_open: There is no such device\n");
> +               return -EIO;
> +       } else {
> +               if (sensor_cur == vfl) {
> +                       mutex_unlock(&sensordev_lock);
> +                       /* Sensor is in use, stop here */
> +                       printk(KERN_WARNING "sensor_open: The camera is"
> +                              "already in use\n");
> +                       return 0;
> +               }
> +
> +               if (vfl->open)
> +                       err = vfl->open(vfl->i2c, vfl->data);
> +               if (err) {
> +                       mutex_unlock(&sensordev_lock);
> +                       printk(KERN_ERR "sensor_open: Fail to open device\n");
> +                       return -EIO;
> +               }
> +               err = 0;
> +       }
> +       vfl->state = SENSOR_INIT;
> +       mutex_unlock(&sensordev_lock);
> +
> +       return err;
> +}
> +
> +/*
> + * Sensor fs opration
> + */
> +static const struct file_operations sensor_fops = {
> +       .owner  = THIS_MODULE,
> +       .llseek = no_llseek,
> +       .open   = ci_sensor_open,
> +       .release = ci_sensor_release,
> +       .ioctl = ci_sensor_ioctl,
> +};
> +
> +/*
> + * Initialize sensor module
> + */
> +static int __init sensordev_init(void)
> +{
> +       int ret;
> +
> +       printk(KERN_INFO "Sensor device interface\n");
> +       if (register_chrdev(SENSOR_MAJOR, SENSOR_NAME, &sensor_fops)) {
> +               printk(KERN_WARNING "sensor_dev: unable to get major %d\n",
> +                      SENSOR_MAJOR);
> +               return -EIO;
> +       }
> +
> +       ret = class_register(&sensor_class);
> +       if (ret < 0) {
> +               unregister_chrdev(SENSOR_MAJOR, SENSOR_NAME);
> +               printk(KERN_WARNING "sensor_dev: class register failed\n");
> +               return -EIO;

Well, if i were writing this i did:

ret = register_chrdev(SENSOR_MAJOR, SENSOR_NAME, &sensor_fops);
if (ret < 0) {
   printk("..");
   return ret;
}

Is it better to return ret instead of -EIO here?

> +       }
> +
> +       /* Enable sensor related GPIO in system */
> +       gpio_direction_output(GPIO_STDBY1_PIN, 0);
> +       gpio_direction_output(GPIO_STDBY2_PIN, 0);
> +       gpio_direction_output(GPIO_RESET_PIN, 1);
> +       gpio_direction_output(GPIO_SCLK_25, 0);
> +       /* gpio_direction_output(GPIO_AF_PD, 1); */
> +
> +       #if 0 /* disabled the mrst gpio driver function call, need to turn on in futher */
> +       gpio_alt_func(GPIO_STDBY1_PIN, 0);
> +       gpio_alt_func(GPIO_STDBY2_PIN, 0);
> +       gpio_alt_func(GPIO_RESET_PIN, 0);
> +       gpio_alt_func(GPIO_SCLK_25, 1);
> +       #endif
> +       def_sensor = 0;
> +       sensor_cur = NULL;
> +       return 0;
> +}
> +
> +static void __exit sensordev_exit(void)
> +{
> +       class_unregister(&sensor_class);
> +       unregister_chrdev(SENSOR_MAJOR, SENSOR_NAME);
> +
> +       gpio_direction_output(GPIO_STDBY1_PIN, 1);
> +       gpio_direction_output(GPIO_STDBY2_PIN, 1);
> +       /* gpio_direction_output(GPIO_AF_PD, 0); */
> +}
> +
> +module_init(sensordev_init);
> +module_exit(sensordev_exit);
> +
> +MODULE_AUTHOR("Xiaolin Zhang <xiaolin.zhang@intel.com>");
> +MODULE_DESCRIPTION("Device registrar for Intel Moorestown camera sensor"
> +                  "drivers");
> +MODULE_LICENSE("GPL");
> +
> +module_param(def_sensor, int, S_IRUGO);
> +MODULE_PARM_DESC(def_sensor, "Default sensor number to open");
> diff --git a/drivers/media/video/mrstci/mrstsensor/sensordev_priv.h b/drivers/media/video/mrstci/mrstsensor/sensordev_priv.h
> new file mode 100644
> index 0000000..433e69b
> --- /dev/null
> +++ b/drivers/media/video/mrstci/mrstsensor/sensordev_priv.h
> @@ -0,0 +1,37 @@
> +/*
> + * Support for Moorestown Langwell Camera Imaging ISP subsystem.
> + *
> + * Copyright (c) 2009 Intel Corporation. All Rights Reserved.
> + *
> + * Copyright (c) Silicon Image 2008  www.siliconimage.com
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License version
> + * 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
> + * 02110-1301, USA.
> + *
> + *
> + * Xiaolin Zhang <xiaolin.zhang@intel.com>
> + */
> +
> +#include "sensordev.h"
> +#include "ci_sensor_ioc.h"
> +
> +#define SENSOR_MAJOR   260
> +#define SENSOR_NAME    "IntelSensor"
> +#define MINOR_MAX      2
> +#define AMOUNT_OF_CAM_DRIVERS  4
> +#define V4L2_DEF_SEN   SENSOR_TYPE_SOC
> +
> +#define SENSOR_INIT    0
> +#define SENSOR_RUNNING 1
> +#define SENSOR_SUSPEND 2
> --
> 1.5.5


--
Best regards, Klimov Alexey
