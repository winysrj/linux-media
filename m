Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7TNhP3P028674
	for <video4linux-list@redhat.com>; Fri, 29 Aug 2008 19:43:26 -0400
Received: from arroyo.ext.ti.com (arroyo.ext.ti.com [192.94.94.40])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7TNgqnJ005297
	for <video4linux-list@redhat.com>; Fri, 29 Aug 2008 19:42:52 -0400
Received: from dlep95.itg.ti.com ([157.170.170.107])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id m7TNgkrw008888
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <video4linux-list@redhat.com>; Fri, 29 Aug 2008 18:42:52 -0500
Received: from dlee73.ent.ti.com (localhost [127.0.0.1])
	by dlep95.itg.ti.com (8.13.8/8.13.8) with ESMTP id m7TNgkUE022429
	for <video4linux-list@redhat.com>; Fri, 29 Aug 2008 18:42:46 -0500 (CDT)
From: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
To: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
Date: Fri, 29 Aug 2008 18:42:45 -0500
Message-ID: <A24693684029E5489D1D202277BE89441191E343@dlee02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 12/15] OMAP3 camera driver: Add Sensor and Lens Driver.
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

From: Sergio Aguirre <saaguirre@ti.com>

OMAP: CAM: Add Sensor and Lens Driver

This adds the following sensor drivers:
* Micron MT9P012 sensor
* DW9710 Lens driver

Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
---
 drivers/media/video/Kconfig   |   16
 drivers/media/video/Makefile  |    2
 drivers/media/video/Kconfig   |   16
 drivers/media/video/Makefile  |    2
 drivers/media/video/dw9710.c  |  583 +++++++++++++
 drivers/media/video/dw9710.h  |   61 +
 drivers/media/video/mt9p012.c | 1782 ++++++++++++++++++++++++++++++++++++++++++
 drivers/media/video/mt9p012.h |  295 ++++++
 6 files changed, 2739 insertions(+)

Index: linux-omap-2.6/drivers/media/video/Kconfig
===================================================================
--- linux-omap-2.6.orig/drivers/media/video/Kconfig     2008-08-28 19:47:42.000000000 -0500
+++ linux-omap-2.6/drivers/media/video/Kconfig  2008-08-28 19:52:24.000000000 -0500
@@ -303,6 +303,22 @@
          OV9640 camera.  It is currently working with the TI OMAP2
          camera controller.

+config VIDEO_MT9P012
+       tristate "Micron MT9P012 raw sensor driver (5MP)"
+       depends on I2C && VIDEO_V4L2
+       ---help---
+         This is a Video4Linux2 sensor-level driver for the Micron
+         MT9P012 camera.  It is currently working with the TI OMAP3
+         camera controller.
+
+config VIDEO_DW9710
+       tristate "Lens driver for DW9710"
+       depends on I2C && VIDEO_V4L2
+       ---help---
+         This is a Video4Linux2 lens driver for the Dongwoon
+         DW9710 coil.  It is currently working with the TI OMAP3
+         camera controller and micron MT9P012 sensor.
+
 config VIDEO_SAA7110
        tristate "Philips SAA7110 video decoder"
        depends on VIDEO_V4L1 && I2C
Index: linux-omap-2.6/drivers/media/video/Makefile
===================================================================
--- linux-omap-2.6.orig/drivers/media/video/Makefile    2008-08-28 19:47:42.000000000 -0500
+++ linux-omap-2.6/drivers/media/video/Makefile 2008-08-28 19:52:24.000000000 -0500
@@ -109,6 +109,8 @@
 obj-$(CONFIG_VIDEO_OMAP2) += omap24xxcam.o omap24xxcam-dma.o
 obj-$(CONFIG_VIDEO_TCM825X) += tcm825x.o
 obj-$(CONFIG_VIDEO_OV9640)     += ov9640.o
+obj-$(CONFIG_VIDEO_MT9P012)    += mt9p012.o
+obj-$(CONFIG_VIDEO_DW9710) += dw9710.o

 obj-$(CONFIG_USB_DABUSB)        += dabusb.o
 obj-$(CONFIG_USB_OV511)         += ov511.o
Index: linux-omap-2.6/drivers/media/video/dw9710.c
===================================================================
--- /dev/null   1970-01-01 00:00:00.000000000 +0000
+++ linux-omap-2.6/drivers/media/video/dw9710.c 2008-08-28 19:52:24.000000000 -0500
@@ -0,0 +1,583 @@
+/*
+ * drivers/media/video/dw9710.c
+ *
+ * DW9710 Coil Motor (LENS) driver
+ *
+ * Copyright (C) 2008 Texas Instruments.
+ *
+ * Contributors:
+ *     Troy Laramy <t-laramy@ti.com>
+ *     Mohit Jalori <mjalori@ti.com>
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2. This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ *
+ */
+
+#include <linux/mutex.h>
+#include <linux/i2c.h>
+#include <linux/delay.h>
+#include <media/v4l2-int-device.h>
+#include <mach/gpio.h>
+#include <linux/platform_device.h>
+#include <linux/cdev.h>
+#include <linux/device.h>
+
+#include "dw9710.h"
+
+#define DRIVER_NAME  "dw9710"
+
+static int
+dw9710_probe(struct i2c_client *client, const struct i2c_device_id *id);
+static int __exit dw9710_remove(struct i2c_client *client);
+
+struct dw9710_device {
+       const struct dw9710_platform_data *pdata;
+       struct v4l2_int_device *v4l2_int_device;
+       struct i2c_client *i2c_client;
+       int opened;
+       u16 current_lens_posn;
+       u16 saved_lens_posn;
+       int state;
+};
+
+static const struct i2c_device_id dw9710_id[] = {
+       { DW9710_NAME, 0 },
+       { }
+};
+MODULE_DEVICE_TABLE(i2c, dw9710_id);
+
+static struct i2c_driver dw9710_i2c_driver = {
+       .driver = {
+               .name = DW9710_NAME,
+               .owner = THIS_MODULE,
+       },
+       .probe = dw9710_probe,
+       .remove = __exit_p(dw9710_remove),
+       .id_table = dw9710_id,
+};
+
+static struct dw9710_device dw9710 = {
+       .state = LENS_NOT_DETECTED,
+};
+
+static struct vcontrol {
+       struct v4l2_queryctrl qc;
+       int current_value;
+} video_control[] = {
+       {
+               {
+                       .id = V4L2_CID_FOCUS_ABSOLUTE,
+                       .type = V4L2_CTRL_TYPE_INTEGER,
+                       .name = "Lens Position",
+                       .minimum = 0,
+                       .maximum = MAX_FOCUS_POS,
+                       .step = LENS_POSN_STEP,
+                       .default_value = DEF_LENS_POSN,
+               },
+               .current_value = DEF_LENS_POSN,
+       }
+};
+
+static struct i2c_driver dw9710_i2c_driver;
+static int camera_enabled;
+
+/**
+ * find_vctrl - Finds the requested ID in the video control structure array
+ * @id: ID of control to search the video control array for
+ *
+ * Returns the index of the requested ID from the control structure array
+ */
+static int
+find_vctrl(int id)
+{
+       int i;
+
+       if (id < V4L2_CID_BASE)
+               return -EDOM;
+
+       for (i = (ARRAY_SIZE(video_control) - 1); i >= 0; i--)
+               if (video_control[i].qc.id == id)
+                       break;
+       if (i < 0)
+               i = -EINVAL;
+       return i;
+}
+
+/**
+ * camaf_reg_read - Reads a value from a register in DW9710 Coil driver device.
+ * @client: Pointer to structure of I2C client.
+ * @value: Pointer to u16 for returning value of register to read.
+ *
+ * Returns zero if successful, or non-zero otherwise.
+ **/
+static int camaf_reg_read(struct i2c_client *client, u16 *value)
+{
+       int err;
+       struct i2c_msg msg[1];
+       unsigned char data[2];
+
+       if (!client->adapter)
+               return -ENODEV;
+
+       msg->addr = client->addr;
+       msg->flags = I2C_M_RD;
+       msg->len = 2;
+       msg->buf = data;
+
+       data[0] = 0;
+       data[1] = 0;
+
+       err = i2c_transfer(client->adapter, msg, 1);
+
+       if (err >= 0) {
+               *value = err = ((data[0] & 0xFF) << 8) | (data[1]);
+               return 0;
+       }
+       return err;
+}
+
+/**
+ * camaf_reg_write - Writes a value to a register in DW9710 Coil driver device.
+ * @client: Pointer to structure of I2C client.
+ * @value: Value of register to write.
+ *
+ * Returns zero if successful, or non-zero otherwise.
+ **/
+static int camaf_reg_write(struct i2c_client *client, u16 value)
+{
+       int err;
+       struct i2c_msg msg[1];
+       unsigned char data[2];
+       int retry = 0;
+
+       if (!client->adapter)
+               return -ENODEV;
+
+again:
+       msg->addr = client->addr;
+       msg->flags = 0;
+       msg->len = 2;
+       msg->buf = data;
+
+       data[0] = (u8)(value >> 8);
+       data[1] = (u8)(value & 0xFF);
+
+       err = i2c_transfer(client->adapter, msg, 1);
+
+       if (err >= 0)
+               return 0;
+
+       if (retry <= DW9710_I2C_RETRY_COUNT) {
+               dev_dbg(&client->dev, "retry ... %d", retry);
+               retry++;
+               set_current_state(TASK_UNINTERRUPTIBLE);
+               schedule_timeout(msecs_to_jiffies(20));
+               goto again;
+       }
+       return err;
+}
+
+/**
+ * dw9710_enable - Sets flag to confirm if camera is turned on.
+ * @power: Status of camera power. 1 - On, 2 - Off.
+ **/
+void dw9710_enable(int power)
+{
+       camera_enabled = power;
+}
+EXPORT_SYMBOL(dw9710_enable);
+
+/**
+ * dw9710_detect - Detects DW9710 Coil driver device.
+ * @client: Pointer to structure of I2C client.
+ *
+ * Returns 0 if successful, -1 if camera is off or if test register value
+ * wasn't stored properly, or returned errors from either camaf_reg_write or
+ * camaf_reg_read functions.
+ **/
+static int dw9710_detect(struct i2c_client *client)
+{
+       int err = 0;
+       u16 wposn = 0, rposn = 0;
+       u16 posn = 0x05;
+
+       if (!camera_enabled)
+               return -1;
+       wposn = (CAMAF_DW9710_POWERDN(CAMAF_DW9710_ENABLE) |
+                                               CAMAF_DW9710_DATA(posn));
+
+       err = camaf_reg_write(client, wposn);
+       if (err) {
+               printk(KERN_ERR "Unable to write DW9710 \n");
+               return err;
+       }
+
+       err = camaf_reg_read(client, &rposn);
+       if (err) {
+               printk(KERN_ERR "Unable to read DW9710 \n");
+               return err;
+       }
+
+       if (wposn != rposn) {
+               printk(KERN_ERR "W/R MISMATCH!\n");
+               return -1;
+       }
+       posn = 0;
+       wposn = (CAMAF_DW9710_POWERDN(CAMAF_DW9710_ENABLE) |
+                                               CAMAF_DW9710_DATA(posn));
+       err = camaf_reg_write(client, wposn);
+
+       return err;
+}
+
+/**
+ * dw9710_af_setfocus - Sets the desired focus.
+ * @posn: Desired focus position, 0 (far) - 100 (close).
+ *
+ * Returns 0 on success, -EINVAL if camera is off or focus value is out of
+ * bounds, or returned errors from either camaf_reg_write or camaf_reg_read
+ * functions.
+ **/
+int dw9710_af_setfocus(u16 posn)
+{
+       struct dw9710_device *af_dev = &dw9710;
+       struct i2c_client *client = af_dev->i2c_client;
+       u16 cur_focus_value = 0;
+       int ret = -EINVAL;
+
+       if (!camera_enabled)
+               return ret;
+
+       if (posn > MAX_FOCUS_POS) {
+               printk(KERN_ERR "Bad posn params 0x%x \n", posn);
+               return ret;
+       }
+
+       ret = camaf_reg_read(client, &cur_focus_value);
+
+       if (ret) {
+               printk(KERN_ERR "Read of current Lens position failed\n");
+               return ret;
+       }
+
+       if (CAMAF_DW9710_DATA_R(cur_focus_value) == posn) {
+               printk(KERN_DEBUG "Device already in requested focal point");
+               return ret;
+       }
+
+       ret = camaf_reg_write(client,
+                               CAMAF_DW9710_POWERDN(CAMAF_DW9710_ENABLE) |
+                               CAMAF_DW9710_DATA(posn));
+
+       if (ret)
+               printk(KERN_ERR "Setfocus register write failed\n");
+       dw9710.current_lens_posn = posn;
+       return ret;
+}
+EXPORT_SYMBOL(dw9710_af_setfocus);
+
+/**
+ * dw9710_af_getfocus - Gets the focus value from device.
+ * @value: Pointer to u16 variable which will contain the focus value.
+ *
+ * Returns 0 if successful, -EINVAL if camera is off, or return value of
+ * camaf_reg_read if fails.
+ **/
+int dw9710_af_getfocus(u16 *value)
+{
+       int ret = -EINVAL;
+       u16 posn = 0;
+
+       struct dw9710_device *af_dev = &dw9710;
+       struct i2c_client *client = af_dev->i2c_client;
+
+       if (!camera_enabled)
+               return ret;
+
+       ret = camaf_reg_read(client, &posn);
+
+       if (ret) {
+               printk(KERN_ERR "Read of current Lens position failed\n");
+               return ret;
+       }
+       *value = CAMAF_DW9710_DATA_R(posn);
+       dw9710.current_lens_posn = CAMAF_DW9710_DATA_R(posn);
+       return ret;
+}
+EXPORT_SYMBOL(dw9710_af_getfocus);
+
+/**
+ * dw9710_af_getfocus_cached - Gets the focus value from internal variable.
+ * @value: Pointer to u16 variable which will contain the focus value.
+ *
+ * Returns 0 if successful, or -EINVAL if camera is off.
+ **/
+int dw9710_af_getfocus_cached(u16 *value)
+{
+       if (!camera_enabled)
+               return -EINVAL;
+       *value = dw9710.current_lens_posn;
+       return 0;
+}
+EXPORT_SYMBOL(dw9710_af_getfocus_cached);
+
+/**
+ * ioctl_queryctrl - V4L2 lens interface handler for VIDIOC_QUERYCTRL ioctl
+ * @s: pointer to standard V4L2 device structure
+ * @qc: standard V4L2 VIDIOC_QUERYCTRL ioctl structure
+ *
+ * If the requested control is supported, returns the control information
+ * from the video_control[] array.  Otherwise, returns -EINVAL if the
+ * control is not supported.
+ */
+static int ioctl_queryctrl(struct v4l2_int_device *s,
+                               struct v4l2_queryctrl *qc)
+{
+       int i;
+
+       i = find_vctrl(qc->id);
+       if (i == -EINVAL)
+               qc->flags = V4L2_CTRL_FLAG_DISABLED;
+
+       if (i < 0)
+               return -EINVAL;
+
+       *qc = video_control[i].qc;
+       return 0;
+}
+
+/**
+ * ioctl_g_ctrl - V4L2 DW9710 lens interface handler for VIDIOC_G_CTRL ioctl
+ * @s: pointer to standard V4L2 device structure
+ * @vc: standard V4L2 VIDIOC_G_CTRL ioctl structure
+ *
+ * If the requested control is supported, returns the control's current
+ * value from the video_control[] array.  Otherwise, returns -EINVAL
+ * if the control is not supported.
+ */
+static int ioctl_g_ctrl(struct v4l2_int_device *s,
+                            struct v4l2_control *vc)
+{
+       struct vcontrol *lvc;
+       int i;
+       u16 curr_posn;
+
+       i = find_vctrl(vc->id);
+       if (i < 0)
+               return -EINVAL;
+       lvc = &video_control[i];
+
+       switch (vc->id) {
+       case  V4L2_CID_FOCUS_ABSOLUTE:
+               if (dw9710_af_getfocus(&curr_posn))
+                       return -EFAULT;
+               vc->value = curr_posn;
+               lvc->current_value = curr_posn;
+               break;
+       }
+
+       return 0;
+}
+
+/**
+ * ioctl_s_ctrl - V4L2 DW9710 lens interface handler for VIDIOC_S_CTRL ioctl
+ * @s: pointer to standard V4L2 device structure
+ * @vc: standard V4L2 VIDIOC_S_CTRL ioctl structure
+ *
+ * If the requested control is supported, sets the control's current
+ * value in HW (and updates the video_control[] array).  Otherwise,
+ * returns -EINVAL if the control is not supported.
+ */
+static int ioctl_s_ctrl(struct v4l2_int_device *s,
+                            struct v4l2_control *vc)
+{
+       int retval = -EINVAL;
+       int i;
+       struct vcontrol *lvc;
+
+       i = find_vctrl(vc->id);
+       if (i < 0)
+               return -EINVAL;
+       lvc = &video_control[i];
+
+       switch (vc->id) {
+       case V4L2_CID_FOCUS_ABSOLUTE:
+               retval = dw9710_af_setfocus(vc->value);
+               if (!retval)
+                       lvc->current_value = vc->value;
+               break;
+       }
+
+       return retval;
+}
+
+/**
+ * ioctl_g_priv - V4L2 sensor interface handler for vidioc_int_g_priv_num
+ * @s: pointer to standard V4L2 device structure
+ * @p: void pointer to hold sensor's private data address
+ *
+ * Returns device's (sensor's) private data area address in p parameter
+ */
+static int ioctl_g_priv(struct v4l2_int_device *s, void *p)
+{
+       struct dw9710_device *lens = s->priv;
+
+       return lens->pdata->priv_data_set(p);
+
+}
+
+/**
+ * ioctl_s_power - V4L2 sensor interface handler for vidioc_int_s_power_num
+ * @s: pointer to standard V4L2 device structure
+ * @on: power state to which device is to be set
+ *
+ * Sets devices power state to requrested state, if possible.
+ */
+static int ioctl_s_power(struct v4l2_int_device *s, enum v4l2_power on)
+{
+       struct dw9710_device *lens = s->priv;
+       struct i2c_client *c = lens->i2c_client;
+       int rval;
+
+       rval = lens->pdata->power_set(on);
+       camera_enabled = on;
+
+       if ((on == V4L2_POWER_ON) && (lens->state == LENS_NOT_DETECTED)) {
+               rval = dw9710_detect(c);
+               if (rval < 0) {
+                       dev_err(&c->dev, "Unable to detect "
+                               DRIVER_NAME " lens HW\n");
+                       printk(KERN_ERR "Unable to detect "
+                               DRIVER_NAME " lens HW\n");
+                       lens->state = LENS_NOT_DETECTED;
+                       return rval;
+               }
+               lens->state = LENS_DETECTED;
+               pr_info(DRIVER_NAME " lens HW detected\n");
+       }
+       return 0;
+}
+
+static struct v4l2_int_ioctl_desc dw9710_ioctl_desc[] = {
+       { .num = vidioc_int_s_power_num,
+         .func = (v4l2_int_ioctl_func *)ioctl_s_power },
+       { .num = vidioc_int_g_priv_num,
+         .func = (v4l2_int_ioctl_func *)ioctl_g_priv },
+       { .num = vidioc_int_queryctrl_num,
+         .func = (v4l2_int_ioctl_func *)ioctl_queryctrl },
+       { .num = vidioc_int_g_ctrl_num,
+         .func = (v4l2_int_ioctl_func *)ioctl_g_ctrl },
+       { .num = vidioc_int_s_ctrl_num,
+         .func = (v4l2_int_ioctl_func *)ioctl_s_ctrl },
+};
+
+static struct v4l2_int_slave dw9710_slave = {
+       .ioctls = dw9710_ioctl_desc,
+       .num_ioctls = ARRAY_SIZE(dw9710_ioctl_desc),
+};
+
+static struct v4l2_int_device dw9710_int_device = {
+       .module = THIS_MODULE,
+       .name = DRIVER_NAME,
+       .priv = &dw9710,
+       .type = v4l2_int_type_slave,
+       .u = {
+               .slave = &dw9710_slave,
+       },
+};
+
+/**
+ * dw9710_probe - Probes the driver for valid I2C attachment.
+ * @client: Pointer to structure of I2C client.
+ *
+ * Returns 0 if successful, or -EBUSY if unable to get client attached data.
+ **/
+static int
+dw9710_probe(struct i2c_client *client, const struct i2c_device_id *id)
+{
+       struct dw9710_device *lens = &dw9710;
+       int err;
+
+       dev_info(&client->dev, "dw9710 probe called....\n");
+
+       if (i2c_get_clientdata(client)) {
+               printk(KERN_ERR " DTA BUSY %s\n", client->name);
+               return -EBUSY;
+       }
+
+       lens->pdata = client->dev.platform_data;
+
+       if (!lens->pdata) {
+               dev_err(&client->dev, "no platform data?\n");
+               return -ENODEV;
+       }
+
+       lens->v4l2_int_device = &dw9710_int_device;
+
+       lens->i2c_client = client;
+       i2c_set_clientdata(client, lens);
+
+       err = v4l2_int_device_register(lens->v4l2_int_device);
+       if (err) {
+               printk(KERN_ERR "Failed to Register "
+                       DRIVER_NAME " as V4L2 device.\n");
+               i2c_set_clientdata(client, NULL);
+       } else {
+               printk(KERN_ERR "Registered "
+                       DRIVER_NAME " as V4L2 device.\n");
+       }
+
+       return 0;
+}
+
+/**
+ * dw9710_remove - Routine when device its unregistered from I2C
+ * @client: Pointer to structure of I2C client.
+ *
+ * Returns 0 if successful, or -ENODEV if the client isn't attached.
+ **/
+static int __exit dw9710_remove(struct i2c_client *client)
+{
+       if (!client->adapter)
+               return -ENODEV;
+
+       i2c_set_clientdata(client, NULL);
+       return 0;
+}
+
+/**
+ * dw9710_init - Module initialisation.
+ *
+ * Returns 0 if successful, or -EINVAL if device couldn't be initialized, or
+ * added as a character device.
+ **/
+static int __init dw9710_init(void)
+{
+       int err = -EINVAL;
+
+       camera_enabled = 0;
+
+       err = i2c_add_driver(&dw9710_i2c_driver);
+       if (err)
+               goto fail;
+       return err;
+fail:
+       printk(KERN_ERR "Failed to register " DRIVER_NAME ".\n");
+       return err;
+}
+late_initcall(dw9710_init);
+
+/**
+ * dw9710_cleanup - Module cleanup.
+ **/
+static void __exit dw9710_cleanup(void)
+{
+       i2c_del_driver(&dw9710_i2c_driver);
+}
+module_exit(dw9710_cleanup);
+
+MODULE_AUTHOR("Texas Instruments");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("DW9710 LENS driver");
Index: linux-omap-2.6/drivers/media/video/dw9710.h
===================================================================
--- /dev/null   1970-01-01 00:00:00.000000000 +0000
+++ linux-omap-2.6/drivers/media/video/dw9710.h 2008-08-28 19:52:24.000000000 -0500
@@ -0,0 +1,61 @@
+/*
+ * drivers/media/video/dw9710.h
+ *
+ * Register defines for Auto Focus device
+ *
+ * Copyright (C) 2008 Texas Instruments.
+ *
+ * Contributors:
+ *     Troy Laramy <t-laramy@ti.com>
+ *     Mohit Jalori <mjalori@ti.com>
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2. This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ *
+ */
+
+#ifndef CAMAF_DW9710_H
+#define CAMAF_DW9710_H
+
+#define DW9710_AF_I2C_ADDR     0x0C
+#define DW9710_NAME            "DW9710"
+#define DW9710_I2C_RETRY_COUNT 5
+#define MAX_FOCUS_POS  0xFF
+
+#define CAMAF_DW9710_DISABLE           0x1
+#define CAMAF_DW9710_ENABLE            0x0
+#define CAMAF_DW9710_POWERDN(ARG)      (((ARG) & 0x1) << 15)
+#define CAMAF_DW9710_POWERDN_R(ARG)    (((ARG) >> 15) & 0x1)
+
+#define CAMAF_DW9710_DATA(ARG)         (((ARG) & 0xFF) << 6)
+#define CAMAF_DW9710_DATA_R(ARG)       (((ARG) >> 6) & 0xFF)
+#define CAMAF_FREQUENCY_EQ1(mclk)      ((u16)(mclk/16000))
+
+/* State of lens */
+#define LENS_DETECTED          1
+#define LENS_NOT_DETECTED      0
+
+/* Focus control values */
+#define DEF_LENS_POSN          0x7F
+#define LENS_POSN_STEP         1
+
+
+/**
+ * struct dw9710_platform_data - platform data values and access functions
+ * @power_set: Power state access function, zero is off, non-zero is on.
+ * @priv_data_set: device private data (pointer) access function
+ */
+struct dw9710_platform_data {
+       int (*power_set)(enum v4l2_power power);
+       int (*priv_data_set)(void *);
+};
+
+void dw9710_enable(int power);
+/*
+ * Sets the specified focus value [0(far) - 100(near)]
+ */
+int dw9710_af_setfocus(u16 posn);
+int dw9710_af_getfocus(u16 *value);
+int dw9710_af_getfocus_cached(u16 *value);
+#endif /* End of of CAMAF_DW9710_H */
Index: linux-omap-2.6/drivers/media/video/mt9p012.c
===================================================================
--- /dev/null   1970-01-01 00:00:00.000000000 +0000
+++ linux-omap-2.6/drivers/media/video/mt9p012.c        2008-08-28 19:53:38.000000000 -0500
@@ -0,0 +1,1782 @@
+/*
+ * drivers/media/video/mt9p012.c
+ *
+ * mt9p012 sensor driver
+ *
+ * Copyright (C) 2008 Texas Instruments.
+ *
+ * Contributors:
+ *     Sameer Venkatraman <sameerv@ti.com>
+ *     Martinez Leonides
+ *
+ * Leverage OV9640.c
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2. This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ */
+
+#include <linux/i2c.h>
+#include <linux/delay.h>
+#include <media/v4l2-int-device.h>
+
+#include "mt9p012.h"
+#include "isp/isp.h"
+
+#define DRIVER_NAME  "mt9p012"
+#define MOD_NAME "MT9P012: "
+
+/**
+ * struct mt9p012_sensor - main structure for storage of sensor information
+ * @pdata: access functions and data for platform level information
+ * @v4l2_int_device: V4L2 device structure structure
+ * @i2c_client: iic client device structure
+ * @pix: V4L2 pixel format information structure
+ * @timeperframe: time per frame expressed as V4L fraction
+ * @scaler:
+ * @ver: mt9p012 chip version
+ * @fps: frames per second value
+ */
+struct mt9p012_sensor {
+       const struct mt9p012_platform_data *pdata;
+       struct v4l2_int_device *v4l2_int_device;
+       struct i2c_client *i2c_client;
+       struct v4l2_pix_format pix;
+       struct v4l2_fract timeperframe;
+       int scaler;
+       int ver;
+       int fps;
+       int state;
+};
+
+static struct mt9p012_sensor mt9p012;
+static struct i2c_driver mt9p012sensor_i2c_driver;
+static unsigned long xclk_current = MT9P012_XCLK_NOM_1;
+
+/* list of image formats supported by mt9p012 sensor */
+const static struct v4l2_fmtdesc mt9p012_formats[] = {
+       {
+               .description    = "Bayer10 (GrR/BGb)",
+               .pixelformat    = V4L2_PIX_FMT_SGRBG10,
+       }
+};
+
+#define NUM_CAPTURE_FORMATS ARRAY_SIZE(mt9p012_formats)
+
+/* Enters soft standby, all settings are maintained */
+const static struct mt9p012_reg stream_off_list[] = {
+       {.length = MT9P012_8BIT, .reg = REG_MODE_SELECT, .val = 0x00},
+       {.length = MT9P012_TOK_TERM, .reg = 0, .val = 0}
+};
+
+/* Exits soft standby */
+const static struct mt9p012_reg stream_on_list[] = {
+       {.length = MT9P012_8BIT, .reg = REG_MODE_SELECT, .val = 0x01},
+       /* Sensor datasheet says we need 1 ms to allow PLL lock */
+       {.length = MT9P012_TOK_DELAY, .reg = 0x00, .val = 1},
+       {.length = MT9P012_TOK_TERM, .reg = 0, .val = 0}
+};
+
+/* Structure which will set the exposure time */
+static struct mt9p012_reg set_exposure_time[] = {
+       {.length = MT9P012_8BIT, .reg = REG_GROUPED_PAR_HOLD, .val = 0x01},
+       /* less than frame_lines-1 */
+       {.length = MT9P012_16BIT, .reg = REG_COARSE_INT_TIME, .val = 500},
+        /* updating */
+       {.length = MT9P012_8BIT, .reg = REG_GROUPED_PAR_HOLD, .val = 0x00},
+       {.length = MT9P012_TOK_TERM, .reg = 0, .val = 0}
+};
+
+/* Structure to set analog gain */
+static struct mt9p012_reg set_analog_gain[] = {
+       {.length = MT9P012_8BIT, .reg = REG_GROUPED_PAR_HOLD, .val = 0x01},
+       {.length = MT9P012_16BIT, .reg = REG_ANALOG_GAIN_GLOBAL,
+               .val = MIN_GAIN},
+        /* updating */
+       {.length = MT9P012_8BIT, .reg = REG_GROUPED_PAR_HOLD, .val = 0x00},
+       {.length = MT9P012_TOK_TERM, .reg = 0, .val = 0},
+};
+
+/*
+ * Common MT9P012 register initialization for all image sizes, pixel formats,
+ * and frame rates
+ */
+const static struct mt9p012_reg mt9p012_common[] = {
+       {MT9P012_8BIT, REG_SOFTWARE_RESET, 0x01},
+       {MT9P012_TOK_DELAY, 0x00, 5}, /* Delay = 5ms, min 2400 xcks */
+       {MT9P012_16BIT, REG_RESET_REGISTER, 0x10C8},
+       {MT9P012_8BIT, REG_GROUPED_PAR_HOLD, 0x01}, /* hold */
+       {MT9P012_16BIT, REG_ANALOG_GAIN_GREENR, 0x0020},
+       {MT9P012_16BIT, REG_ANALOG_GAIN_RED, 0x0020},
+       {MT9P012_16BIT, REG_ANALOG_GAIN_BLUE, 0x0020},
+       {MT9P012_16BIT, REG_ANALOG_GAIN_GREENB, 0x0020},
+       {MT9P012_16BIT, REG_DIGITAL_GAIN_GREENR, 0x0100},
+       {MT9P012_16BIT, REG_DIGITAL_GAIN_RED, 0x0100},
+       {MT9P012_16BIT, REG_DIGITAL_GAIN_BLUE, 0x0100},
+       {MT9P012_16BIT, REG_DIGITAL_GAIN_GREENB, 0x0100},
+       /* Recommended values for image quality, sensor Rev 1 */
+       {MT9P012_16BIT, 0x3088, 0x6FFB},
+       {MT9P012_16BIT, 0x308E, 0x2020},
+       {MT9P012_16BIT, 0x309E, 0x4400},
+       {MT9P012_16BIT, 0x30D4, 0x9080},
+       {MT9P012_16BIT, 0x3126, 0x00FF},
+       {MT9P012_16BIT, 0x3154, 0x1482},
+       {MT9P012_16BIT, 0x3158, 0x97C7},
+       {MT9P012_16BIT, 0x315A, 0x97C6},
+       {MT9P012_16BIT, 0x3162, 0x074C},
+       {MT9P012_16BIT, 0x3164, 0x0756},
+       {MT9P012_16BIT, 0x3166, 0x0760},
+       {MT9P012_16BIT, 0x316E, 0x8488},
+       {MT9P012_16BIT, 0x3172, 0x0003},
+       {MT9P012_16BIT, 0x30EA, 0x3F06},
+       {MT9P012_8BIT, REG_GROUPED_PAR_HOLD, 0x00}, /* update all at once */
+       {MT9P012_TOK_TERM, 0, 0}
+
+};
+
+/*
+ * mt9p012 register configuration for all combinations of pixel format and
+ * image size
+ */
+       /* 4X BINNING+SCALING */
+const static struct mt9p012_reg enter_video_216_15fps[] = {
+       /* stream off */
+       {.length = MT9P012_8BIT, .reg = REG_MODE_SELECT, .val = 0x00},
+       {.length = MT9P012_TOK_DELAY, .reg = 0x00, .val = 100},
+        /* hold */
+       {.length = MT9P012_8BIT, .reg = REG_GROUPED_PAR_HOLD, .val = 0x01},
+       {.length = MT9P012_16BIT, .reg = REG_VT_PIX_CLK_DIV, .val = 8},
+       {.length = MT9P012_16BIT, .reg = REG_VT_SYS_CLK_DIV, .val = 2},
+       {.length = MT9P012_16BIT, .reg = REG_PRE_PLL_CLK_DIV, .val = 2},
+       {.length = MT9P012_16BIT, .reg = REG_PLL_MULTIPLIER, .val = 126},
+       {.length = MT9P012_16BIT, .reg = REG_OP_PIX_CLK_DIV, .val = 8},
+       {.length = MT9P012_16BIT, .reg = REG_OP_SYS_CLK_DIV, .val = 2},
+       {.length = MT9P012_16BIT, .reg = REG_RESERVED_MFR_3064,
+               .val = 0x0805},
+       {.length = MT9P012_16BIT, .reg = REG_X_OUTPUT_SIZE,
+               .val = VIDEO_WIDTH_4X_BINN_SCALED},
+       {.length = MT9P012_16BIT, .reg = REG_Y_OUTPUT_SIZE,
+               .val = VIDEO_HEIGHT_4X_BINN_SCALED},
+       {.length = MT9P012_16BIT, .reg = REG_X_ADDR_START, .val = 8},
+       {.length = MT9P012_16BIT, .reg = REG_Y_ADDR_START, .val = 8},
+       {.length = MT9P012_16BIT, .reg = REG_X_ADDR_END, .val = 2593},
+       {.length = MT9P012_16BIT, .reg = REG_Y_ADDR_END, .val = 1945},
+       {.length = MT9P012_16BIT, .reg = REG_READ_MODE, .val = 0x04FC},
+       {.length = MT9P012_16BIT, .reg = REG_FINE_INT_TIME, .val = 1794},
+       {.length = MT9P012_16BIT, .reg = REG_FRAME_LEN_LINES, .val = 574},
+       {.length = MT9P012_16BIT, .reg = REG_LINE_LEN_PCK, .val = 2712},
+        /* 0x10/0x30 = 0.3333 */
+       {.length = MT9P012_16BIT, .reg = REG_SCALE_M, .val = 0x0030},
+       /* enable scaler */
+       {.length = MT9P012_16BIT, .reg = REG_SCALING_MODE, .val = 0x0002},
+       {.length = MT9P012_16BIT, .reg = REG_COARSE_INT_TIME,
+               .val = COARSE_INT_TIME_216},
+       /* update */
+       {.length = MT9P012_8BIT, .reg = REG_GROUPED_PAR_HOLD, .val = 0x00},
+       {.length = MT9P012_TOK_TERM, .reg = 0, .val = 0}
+       };
+
+       /* Video mode, 4x binning + scaling, range 16 - 30 fps */
+const static struct mt9p012_reg enter_video_216_30fps[] = {
+       /* stream off */
+       {.length = MT9P012_8BIT, .reg = REG_MODE_SELECT, .val = 0x00},
+       {.length = MT9P012_TOK_DELAY, .reg = 0x00, .val = 100},
+       /* hold */
+       {.length = MT9P012_8BIT, .reg = REG_GROUPED_PAR_HOLD, .val = 0x01},
+       {.length = MT9P012_16BIT, .reg = REG_VT_PIX_CLK_DIV, .val = 5},
+       {.length = MT9P012_16BIT, .reg = REG_VT_SYS_CLK_DIV, .val = 2},
+       {.length = MT9P012_16BIT, .reg = REG_PRE_PLL_CLK_DIV, .val = 3},
+       {.length = MT9P012_16BIT, .reg = REG_PLL_MULTIPLIER, .val = 192},
+       {.length = MT9P012_16BIT, .reg = REG_OP_PIX_CLK_DIV, .val = 10},
+       {.length = MT9P012_16BIT, .reg = REG_OP_SYS_CLK_DIV, .val = 2},
+       {.length = MT9P012_16BIT, .reg = REG_RESERVED_MFR_3064, .val = 0x0805},
+       {.length = MT9P012_16BIT, .reg = REG_X_OUTPUT_SIZE,
+               .val = VIDEO_WIDTH_4X_BINN},
+       {.length = MT9P012_16BIT, .reg = REG_Y_OUTPUT_SIZE,
+               .val = VIDEO_HEIGHT_4X_BINN},
+       {.length = MT9P012_16BIT, .reg = REG_X_ADDR_START, .val = 8},
+       {.length = MT9P012_16BIT, .reg = REG_Y_ADDR_START, .val = 8},
+       {.length = MT9P012_16BIT, .reg = REG_X_ADDR_END, .val = 2593},
+       {.length = MT9P012_16BIT, .reg = REG_Y_ADDR_END, .val = 1945},
+       {.length = MT9P012_16BIT, .reg = REG_READ_MODE, .val = 0x04FC},
+       {.length = MT9P012_16BIT, .reg = REG_FINE_INT_TIME, .val = 1794},
+       {.length = MT9P012_16BIT, .reg = REG_FRAME_LEN_LINES, .val = 1374},
+       {.length = MT9P012_16BIT, .reg = REG_LINE_LEN_PCK, .val = 3712},
+       /* 0x10/0x30 = 0.3333 */
+       {.length = MT9P012_16BIT, .reg = REG_SCALE_M, .val = 0x0030},
+       /* enable scaler */
+       {.length = MT9P012_16BIT, .reg = REG_SCALING_MODE, .val = 0x0002},
+       {.length = MT9P012_16BIT, .reg = REG_COARSE_INT_TIME,
+               .val = COARSE_INT_TIME_216_30FPS},
+       /* update */
+       {.length = MT9P012_8BIT, .reg = REG_GROUPED_PAR_HOLD, .val = 0x00},
+       {.length = MT9P012_TOK_TERM, .reg = 0, .val = 0}
+       };
+
+
+       /*Video mode, 4x binning: 648 x 486, range 8 - 15 fps*/
+const static struct mt9p012_reg enter_video_648_15fps[] = {
+       /* stream off */
+       {.length = MT9P012_8BIT, .reg = REG_MODE_SELECT, .val = 0x00},
+       {.length = MT9P012_TOK_DELAY, .reg = 0x00, .val = 100},
+       /* hold */
+       {.length = MT9P012_8BIT, .reg = REG_GROUPED_PAR_HOLD, .val = 0x01},
+       {.length = MT9P012_16BIT, .reg = REG_VT_PIX_CLK_DIV, .val = 8},
+       {.length = MT9P012_16BIT, .reg = REG_VT_SYS_CLK_DIV, .val = 2},
+       {.length = MT9P012_16BIT, .reg = REG_PRE_PLL_CLK_DIV, .val = 2},
+       {.length = MT9P012_16BIT, .reg = REG_PLL_MULTIPLIER, .val = 126},
+       {.length = MT9P012_16BIT, .reg = REG_OP_PIX_CLK_DIV, .val = 8},
+       {.length = MT9P012_16BIT, .reg = REG_OP_SYS_CLK_DIV, .val = 2},
+       {.length = MT9P012_16BIT, .reg = REG_RESERVED_MFR_3064, .val = 0x0805},
+       {.length = MT9P012_16BIT, .reg = REG_X_OUTPUT_SIZE,
+               .val = VIDEO_WIDTH_4X_BINN},
+       {.length = MT9P012_16BIT, .reg = REG_Y_OUTPUT_SIZE,
+               .val = VIDEO_HEIGHT_4X_BINN},
+       {.length = MT9P012_16BIT, .reg = REG_X_ADDR_START, .val = 8},
+       {.length = MT9P012_16BIT, .reg = REG_Y_ADDR_START, .val = 8},
+       {.length = MT9P012_16BIT, .reg = REG_X_ADDR_END, .val = 2593},
+       {.length = MT9P012_16BIT, .reg = REG_Y_ADDR_END, .val = 1945},
+       {.length = MT9P012_16BIT, .reg = REG_READ_MODE, .val = 0x04FC},
+       {.length = MT9P012_16BIT, .reg = REG_FINE_INT_TIME, .val = 1794},
+       {.length = MT9P012_16BIT, .reg = REG_FRAME_LEN_LINES, .val = 574},
+       {.length = MT9P012_16BIT, .reg = REG_LINE_LEN_PCK, .val = 2712},
+       {.length = MT9P012_16BIT, .reg = REG_SCALING_MODE, .val = 0x0000},
+       {.length = MT9P012_16BIT, .reg = REG_COARSE_INT_TIME,
+               .val = COARSE_INT_TIME_648},
+       /* update */
+       {.length = MT9P012_8BIT, .reg = REG_GROUPED_PAR_HOLD, .val = 0x00},
+       {.length = MT9P012_TOK_TERM, .reg = 0, .val = 0}
+};
+
+       /* Video mode, 4x binning: 648 x 486, range 16 - 30 fps */
+const static struct mt9p012_reg enter_video_648_30fps[] = {
+       /* stream off */
+       {.length = MT9P012_8BIT, .reg = REG_MODE_SELECT, .val = 0x00},
+       {.length = MT9P012_TOK_DELAY, .reg = 0x00, .val = 100},
+       /* hold */
+       {.length = MT9P012_8BIT, .reg = REG_GROUPED_PAR_HOLD, .val = 0x01},
+       {.length = MT9P012_16BIT, .reg = REG_VT_PIX_CLK_DIV, .val = 5},
+       {.length = MT9P012_16BIT, .reg = REG_VT_SYS_CLK_DIV, .val = 2},
+       {.length = MT9P012_16BIT, .reg = REG_PRE_PLL_CLK_DIV, .val = 3},
+       {.length = MT9P012_16BIT, .reg = REG_PLL_MULTIPLIER, .val = 192},
+       {.length = MT9P012_16BIT, .reg = REG_OP_PIX_CLK_DIV, .val = 10},
+       {.length = MT9P012_16BIT, .reg = REG_OP_SYS_CLK_DIV, .val = 2},
+       {.length = MT9P012_16BIT, .reg = REG_RESERVED_MFR_3064, .val = 0x0805},
+       {.length = MT9P012_16BIT, .reg = REG_X_OUTPUT_SIZE,
+               .val = VIDEO_WIDTH_4X_BINN},
+       {.length = MT9P012_16BIT, .reg = REG_Y_OUTPUT_SIZE,
+               .val = VIDEO_HEIGHT_4X_BINN},
+       {.length = MT9P012_16BIT, .reg = REG_X_ADDR_START, .val = 8},
+       {.length = MT9P012_16BIT, .reg = REG_Y_ADDR_START, .val = 8},
+       {.length = MT9P012_16BIT, .reg = REG_X_ADDR_END, .val = 2593},
+       {.length = MT9P012_16BIT, .reg = REG_Y_ADDR_END, .val = 1945},
+       {.length = MT9P012_16BIT, .reg = REG_READ_MODE, .val = 0x04FC},
+       {.length = MT9P012_16BIT, .reg = REG_FINE_INT_TIME, .val = 1794},
+       {.length = MT9P012_16BIT, .reg = REG_FRAME_LEN_LINES, .val = 1374},
+       {.length = MT9P012_16BIT, .reg = REG_LINE_LEN_PCK, .val = 3712},
+       {.length = MT9P012_16BIT, .reg = REG_SCALING_MODE, .val = 0x0000},
+       {.length = MT9P012_16BIT, .reg = REG_COARSE_INT_TIME,
+               .val = COARSE_INT_TIME_648_30FPS},
+       /* update */
+       {.length = MT9P012_8BIT, .reg = REG_GROUPED_PAR_HOLD, .val = 0x00},
+       {.length = MT9P012_TOK_TERM, .reg = 0, .val = 0}
+};
+
+       /* Video mode, scaler off: 1296 x 972, range  11 - 21 fps*/
+const static struct mt9p012_reg enter_video_1296_15fps[] = {
+       /* stream off */
+       {.length = MT9P012_8BIT, .reg = REG_MODE_SELECT, .val = 0x00},
+       {.length = MT9P012_TOK_DELAY, .reg = 0x00, .val = 100},
+       /* hold */
+       {.length = MT9P012_8BIT, .reg = REG_GROUPED_PAR_HOLD, .val = 0x01},
+       {.length = MT9P012_16BIT, .reg = REG_VT_PIX_CLK_DIV, .val = 5},
+       {.length = MT9P012_16BIT, .reg = REG_VT_SYS_CLK_DIV, .val = 2},
+       {.length = MT9P012_16BIT, .reg = REG_PRE_PLL_CLK_DIV, .val = 3},
+       {.length = MT9P012_16BIT, .reg = REG_PLL_MULTIPLIER, .val = 134},
+       {.length = MT9P012_16BIT, .reg = REG_OP_PIX_CLK_DIV, .val = 10},
+       {.length = MT9P012_16BIT, .reg = REG_OP_SYS_CLK_DIV, .val = 1},
+       {.length = MT9P012_16BIT, .reg = REG_RESERVED_MFR_3064, .val = 0x0805},
+       {.length = MT9P012_16BIT, .reg = REG_X_OUTPUT_SIZE,
+               .val = VIDEO_WIDTH_2X_BINN},
+       {.length = MT9P012_16BIT, .reg = REG_Y_OUTPUT_SIZE,
+               .val = VIDEO_HEIGHT_2X_BINN},
+       {.length = MT9P012_16BIT, .reg = REG_X_ADDR_START, .val = 8},
+       {.length = MT9P012_16BIT, .reg = REG_Y_ADDR_START, .val = 8},
+       {.length = MT9P012_16BIT, .reg = REG_X_ADDR_END, .val = 2597},
+       {.length = MT9P012_16BIT, .reg = REG_Y_ADDR_END, .val = 1949},
+       {.length = MT9P012_16BIT, .reg = REG_READ_MODE, .val = 0x046C},
+       {.length = MT9P012_16BIT, .reg = REG_FINE_INT_TIME, .val = 1794},
+       {.length = MT9P012_16BIT, .reg = REG_FRAME_LEN_LINES, .val = 1061},
+       {.length = MT9P012_16BIT, .reg = REG_LINE_LEN_PCK, .val = 3360},
+       {.length = MT9P012_16BIT, .reg = REG_SCALING_MODE, .val = 0x0000},
+       {.length = MT9P012_16BIT, .reg = REG_COARSE_INT_TIME,
+               .val = COARSE_INT_TIME_1296},
+       /* update */
+       {.length = MT9P012_8BIT, .reg = REG_GROUPED_PAR_HOLD, .val = 0x00},
+       {.length = MT9P012_TOK_TERM, .reg = 0, .val = 0}
+};
+
+       /* YUV (YCbCr) VGA */
+const static struct mt9p012_reg enter_video_1296_30fps[] = {
+       /* stream off */
+       {.length = MT9P012_8BIT, .reg = REG_MODE_SELECT, .val = 0x00},
+       {.length = MT9P012_TOK_DELAY, .reg = 0x00, .val = 100},
+       /* hold */
+       {.length = MT9P012_8BIT, .reg = REG_GROUPED_PAR_HOLD, .val = 0x01},
+       {.length = MT9P012_16BIT, .reg = REG_VT_PIX_CLK_DIV, .val = 5},
+       {.length = MT9P012_16BIT, .reg = REG_VT_SYS_CLK_DIV, .val = 1},
+       {.length = MT9P012_16BIT, .reg = REG_PRE_PLL_CLK_DIV, .val = 3},
+       {.length = MT9P012_16BIT, .reg = REG_PLL_MULTIPLIER, .val = 134},
+       {.length = MT9P012_16BIT, .reg = REG_OP_PIX_CLK_DIV, .val = 10},
+       {.length = MT9P012_16BIT, .reg = REG_OP_SYS_CLK_DIV, .val = 1},
+       {.length = MT9P012_16BIT, .reg = REG_RESERVED_MFR_3064, .val = 0x0805},
+       {.length = MT9P012_16BIT, .reg = REG_X_OUTPUT_SIZE,
+               .val = VIDEO_WIDTH_2X_BINN},
+       {.length = MT9P012_16BIT, .reg = REG_Y_OUTPUT_SIZE,
+               .val = VIDEO_HEIGHT_2X_BINN},
+       {.length = MT9P012_16BIT, .reg = REG_X_ADDR_START, .val = 8},
+       {.length = MT9P012_16BIT, .reg = REG_Y_ADDR_START, .val = 8},
+       {.length = MT9P012_16BIT, .reg = REG_X_ADDR_END, .val = 2597},
+       {.length = MT9P012_16BIT, .reg = REG_Y_ADDR_END, .val = 1949},
+       {.length = MT9P012_16BIT, .reg = REG_READ_MODE, .val = 0x046C},
+       {.length = MT9P012_16BIT, .reg = REG_FINE_INT_TIME, .val = 1794},
+       {.length = MT9P012_16BIT, .reg = REG_FRAME_LEN_LINES, .val = 1061},
+       {.length = MT9P012_16BIT, .reg = REG_LINE_LEN_PCK, .val = 3360},
+       {.length = MT9P012_16BIT, .reg = REG_SCALING_MODE, .val = 0x0000},
+       {.length = MT9P012_16BIT, .reg = REG_COARSE_INT_TIME,
+               .val = COARSE_INT_TIME_1296},
+        /* update */
+       {.length = MT9P012_8BIT, .reg = REG_GROUPED_PAR_HOLD, .val = 0x00},
+       {.length = MT9P012_TOK_TERM, .reg = 0, .val = 0}
+};
+
+const static struct mt9p012_reg enter_image_mode_3MP_10fps[] = {
+       /* stream off */
+       {.length = MT9P012_8BIT, .reg = REG_MODE_SELECT, .val = 0x00},
+       {.length = MT9P012_TOK_DELAY, .reg = 0x00, .val = 100},
+       /* hold */
+       {.length = MT9P012_8BIT, .reg = REG_GROUPED_PAR_HOLD, .val = 0x01},
+       {.length = MT9P012_16BIT, .reg = REG_VT_PIX_CLK_DIV, .val = 4},
+       {.length = MT9P012_16BIT, .reg = REG_VT_SYS_CLK_DIV, .val = 1},
+       {.length = MT9P012_16BIT, .reg = REG_PRE_PLL_CLK_DIV, .val = 5},
+       /* 10 fps */
+       {.length = MT9P012_16BIT, .reg = REG_PLL_MULTIPLIER, .val = 184},
+       {.length = MT9P012_16BIT, .reg = REG_OP_PIX_CLK_DIV, .val = 8},
+       {.length = MT9P012_16BIT, .reg = REG_OP_SYS_CLK_DIV, .val = 1},
+       {.length = MT9P012_16BIT, .reg = REG_RESERVED_MFR_3064, .val = 0x0805},
+       {.length = MT9P012_16BIT, .reg = REG_X_OUTPUT_SIZE,
+               .val = IMAGE_WIDTH_MIN},
+       {.length = MT9P012_16BIT, .reg = REG_Y_OUTPUT_SIZE,
+               .val = IMAGE_HEIGHT_MIN},
+       {.length = MT9P012_16BIT, .reg = REG_X_ADDR_START, .val = 8},
+       {.length = MT9P012_16BIT, .reg = REG_Y_ADDR_START, .val = 8},
+       {.length = MT9P012_16BIT, .reg = REG_X_ADDR_END, .val = 2599},
+       {.length = MT9P012_16BIT, .reg = REG_Y_ADDR_END, .val = 1951},
+       {.length = MT9P012_16BIT, .reg = REG_READ_MODE, .val = 0x0024},
+       {.length = MT9P012_16BIT, .reg = REG_FINE_INT_TIME, .val = 882},
+       {.length = MT9P012_16BIT, .reg = REG_FRAME_LEN_LINES, .val = 2056},
+       {.length = MT9P012_16BIT, .reg = REG_LINE_LEN_PCK, .val = 5372},
+       /* 0x10/0x14 = 0.80 */
+       {.length = MT9P012_16BIT, .reg = REG_SCALE_M, .val = 0x0014},
+       /* enable scaler */
+       {.length = MT9P012_16BIT, .reg = REG_SCALING_MODE, .val = 0x0002},
+       {.length = MT9P012_16BIT, .reg = REG_TEST_PATTERN, .val = TST_PAT},
+       {.length = MT9P012_16BIT, .reg = REG_COARSE_INT_TIME,
+               .val = COARSE_INT_TIME_3MP},
+       /* update */
+       {.length = MT9P012_8BIT, .reg = REG_GROUPED_PAR_HOLD, .val = 0x00},
+       {.length = MT9P012_TOK_TERM, .reg = 0, .val = 0}
+};
+
+/* Image mode, 5 MP @ 10 fps */
+const static struct mt9p012_reg enter_image_mode_5MP_10fps[] = {
+       /* stream off */
+       {.length = MT9P012_8BIT, .reg = REG_MODE_SELECT, .val = 0x00},
+       {.length = MT9P012_TOK_DELAY, .reg = 0x00, .val = 100},
+       /* hold */
+       {.length = MT9P012_8BIT, .reg = REG_GROUPED_PAR_HOLD, .val = 0x01},
+       {.length = MT9P012_16BIT, .reg = REG_VT_PIX_CLK_DIV, .val = 4},
+       {.length = MT9P012_16BIT, .reg = REG_VT_SYS_CLK_DIV, .val = 1},
+       {.length = MT9P012_16BIT, .reg = REG_PRE_PLL_CLK_DIV, .val = 5},
+       /* 10 fps */
+       {.length = MT9P012_16BIT, .reg = REG_PLL_MULTIPLIER, .val = 184},
+       {.length = MT9P012_16BIT, .reg = REG_OP_PIX_CLK_DIV, .val = 8},
+       {.length = MT9P012_16BIT, .reg = REG_OP_SYS_CLK_DIV, .val = 1},
+       {.length = MT9P012_16BIT, .reg = REG_RESERVED_MFR_3064, .val = 0x0805},
+       {.length = MT9P012_16BIT, .reg = REG_X_OUTPUT_SIZE,
+               .val = IMAGE_WIDTH_MAX},
+       {.length = MT9P012_16BIT, .reg = REG_Y_OUTPUT_SIZE,
+               .val = IMAGE_HEIGHT_MAX},
+       {.length = MT9P012_16BIT, .reg = REG_X_ADDR_START, .val = 8},
+       {.length = MT9P012_16BIT, .reg = REG_Y_ADDR_START, .val = 8},
+       {.length = MT9P012_16BIT, .reg = REG_X_ADDR_END, .val = 2599},
+       {.length = MT9P012_16BIT, .reg = REG_Y_ADDR_END, .val = 1951},
+       {.length = MT9P012_16BIT, .reg = REG_READ_MODE, .val = 0x0024},
+       {.length = MT9P012_16BIT, .reg = REG_FINE_INT_TIME, .val = 882},
+       {.length = MT9P012_16BIT, .reg = REG_FRAME_LEN_LINES, .val = 2056},
+       {.length = MT9P012_16BIT, .reg = REG_LINE_LEN_PCK, .val = 5372},
+       {.length = MT9P012_16BIT, .reg = REG_SCALE_M, .val = 0x0000},
+       /* disable scaler */
+       {.length = MT9P012_16BIT, .reg = REG_SCALING_MODE, .val = 0x0000},
+       {.length = MT9P012_16BIT, .reg = REG_COARSE_INT_TIME,
+               .val = COARSE_INT_TIME_5MP},
+       /* update */
+       {.length = MT9P012_8BIT, .reg = REG_GROUPED_PAR_HOLD, .val = 0x00},
+       {.length = MT9P012_TOK_TERM, .reg = 0, .val = 0}
+};
+
+static u32 min_exposure_time;
+static u32 max_exposure_time;
+static u32 pix_clk_freq;
+
+/* Structure to set frame rate */
+static struct mt9p012_reg set_fps[2];
+
+/**
+ * struct mt9p012_pll_settings - struct for storage of sensor pll values
+ * @vt_pix_clk_div: vertical pixel clock divider
+ * @vt_sys_clk_div: veritcal system clock divider
+ * @pre_pll_div: pre pll divider
+ * @fine_int_tm: fine resolution interval time
+ * @frame_lines: number of lines in frame
+ * @line_len: number of pixels in line
+ * @min_pll: minimum pll multiplier
+ * @max_pll: maximum pll multiplier
+ */
+static struct mt9p012_pll_settings all_pll_settings[] = {
+       /* PLL_5MP */
+       {.vt_pix_clk_div = 4, .vt_sys_clk_div = 1, .pre_pll_div = 5,
+       .fine_int_tm = 882, .frame_lines = 2056, .line_len = 5372,
+       .min_pll = 160, .max_pll = 200},
+       /* PLL_3MP */
+       {.vt_pix_clk_div = 4, .vt_sys_clk_div = 1, .pre_pll_div = 5,
+       .fine_int_tm = 882, .frame_lines = 2056, .line_len = 5372,
+       .min_pll = 160, .max_pll = 200},
+       /* PLL_1296_15FPS */
+       {.vt_pix_clk_div = 5, .vt_sys_clk_div = 2, .pre_pll_div = 3,
+       .fine_int_tm = 1794, .frame_lines = 1061, .line_len = 3360,
+       .min_pll = 96, .max_pll = 190},
+       /* PLL_1296_30FPS */
+       {.vt_pix_clk_div = 5, .vt_sys_clk_div = 1, .pre_pll_div = 3,
+       .fine_int_tm = 1794, .frame_lines = 1061, .line_len = 3360,
+       .min_pll = 96, .max_pll = 150},
+       /* PLL_648_15FPS */
+       {.vt_pix_clk_div = 8, .vt_sys_clk_div = 2, .pre_pll_div = 2,
+       .fine_int_tm = 1794, .frame_lines = 574, .line_len = 2712,
+       .min_pll = 92, .max_pll = 128},
+       /* PLL_648_30FPS */
+       {.vt_pix_clk_div = 5, .vt_sys_clk_div = 2, .pre_pll_div = 3,
+       .fine_int_tm = 1794, .frame_lines = 1374, .line_len = 3712,
+       .min_pll = 96, .max_pll = 192},
+       /* PLL_216_15FPS */
+       {.vt_pix_clk_div = 8, .vt_sys_clk_div = 2, .pre_pll_div = 2,
+       .fine_int_tm = 1794,  .frame_lines = 574, .line_len = 2712,
+       .min_pll = 92, .max_pll = 126},
+       /* PLL_216_30FPS */
+       {.vt_pix_clk_div = 5, .vt_sys_clk_div = 2, .pre_pll_div = 3,
+       .fine_int_tm = 1794,  .frame_lines = 1374, .line_len = 3712,
+       .min_pll = 96, .max_pll = 192}
+};
+
+static enum mt9p012_pll_type current_pll_video;
+
+const static struct mt9p012_reg *
+       mt9p012_reg_init[NUM_FPS][NUM_IMAGE_SIZES] =
+{
+       {
+               enter_video_216_15fps,
+               enter_video_648_15fps,
+               enter_video_1296_15fps,
+               enter_image_mode_3MP_10fps,
+               enter_image_mode_5MP_10fps
+       },
+       {
+               enter_video_216_30fps,
+               enter_video_648_30fps,
+               enter_video_1296_30fps,
+               enter_image_mode_3MP_10fps,
+               enter_image_mode_5MP_10fps
+       },
+};
+
+/**
+ * struct vcontrol - Video controls
+ * @v4l2_queryctrl: V4L2 VIDIOC_QUERYCTRL ioctl structure
+ * @current_value: current value of this control
+ */
+static struct vcontrol {
+       struct v4l2_queryctrl qc;
+       int current_value;
+} video_control[] = {
+       {
+               {
+                       .id = V4L2_CID_EXPOSURE,
+                       .type = V4L2_CTRL_TYPE_INTEGER,
+                       .name = "Exposure",
+                       .minimum = DEF_MIN_EXPOSURE,
+                       .maximum = DEF_MAX_EXPOSURE,
+                       .step = EXPOSURE_STEP,
+                       .default_value = DEF_EXPOSURE,
+               },
+               .current_value = DEF_EXPOSURE,
+       },
+       {
+               {
+                       .id = V4L2_CID_GAIN,
+                       .type = V4L2_CTRL_TYPE_INTEGER,
+                       .name = "Analog Gain",
+                       .minimum = MIN_GAIN,
+                       .maximum = MAX_GAIN,
+                       .step = GAIN_STEP,
+                       .default_value = DEF_GAIN,
+               },
+               .current_value = DEF_GAIN,
+       }
+};
+
+/**
+ * find_vctrl - Finds the requested ID in the video control structure array
+ * @id: ID of control to search the video control array for
+ *
+ * Returns the index of the requested ID from the control structure array
+ */
+static int
+find_vctrl(int id)
+{
+       int i;
+
+       if (id < V4L2_CID_BASE)
+               return -EDOM;
+
+       for (i = (ARRAY_SIZE(video_control) - 1); i >= 0; i--)
+               if (video_control[i].qc.id == id)
+                       break;
+       if (i < 0)
+               i = -EINVAL;
+       return i;
+}
+
+/**
+ * mt9p012_read_reg - Read a value from a register in an mt9p012 sensor device
+ * @client: i2c driver client structure
+ * @data_length: length of data to be read
+ * @reg: register address / offset
+ * @val: stores the value that gets read
+ *
+ * Read a value from a register in an mt9p012 sensor device.
+ * The value is returned in 'val'.
+ * Returns zero if successful, or non-zero otherwise.
+ */
+static int
+mt9p012_read_reg(struct i2c_client *client, u16 data_length, u16 reg, u32 *val)
+{
+       int err;
+       struct i2c_msg msg[1];
+       unsigned char data[4];
+
+       if (!client->adapter)
+               return -ENODEV;
+       if (data_length != MT9P012_8BIT && data_length != MT9P012_16BIT
+                                       && data_length != MT9P012_32BIT)
+               return -EINVAL;
+
+       msg->addr = client->addr;
+       msg->flags = 0;
+       msg->len = 2;
+       msg->buf = data;
+
+       /* high byte goes out first */
+       data[0] = (u8) (reg >> 8);;
+       data[1] = (u8) (reg & 0xff);
+       err = i2c_transfer(client->adapter, msg, 1);
+       if (err >= 0) {
+               msg->len = data_length;
+               msg->flags = I2C_M_RD;
+               err = i2c_transfer(client->adapter, msg, 1);
+       }
+       if (err >= 0) {
+               *val = 0;
+               /* high byte comes first */
+               if (data_length == MT9P012_8BIT)
+                       *val = data[0];
+               else if (data_length == MT9P012_16BIT)
+                       *val = data[1] + (data[0] << 8);
+               else
+                       *val = data[3] + (data[2] << 8) +
+                               (data[1] << 16) + (data[0] << 24);
+               return 0;
+       }
+       dev_err(&client->dev, "read from offset 0x%x error %d", reg, err);
+       return err;
+}
+/**
+ * mt9p012_write_reg - Write a value to a register in an mt9p012 sensor device
+ * @client: i2c driver client structure
+ * @data_length: length of data to be read
+ * @reg: register address / offset
+ * @val: value to be written to specified register
+ *
+ * Write a value to a register in an mt9p012 sensor device.
+ * Returns zero if successful, or non-zero otherwise.
+ */
+static int
+mt9p012_write_reg(struct i2c_client *client, u16 data_length, u16 reg, u32 val)
+{
+       int err;
+       struct i2c_msg msg[1];
+       unsigned char data[6];
+       int retry = 0;
+
+       if (!client->adapter)
+               return -ENODEV;
+
+       if (data_length != MT9P012_8BIT && data_length != MT9P012_16BIT
+                                       && data_length != MT9P012_32BIT)
+               return -EINVAL;
+
+again:
+       msg->addr = client->addr;
+       msg->flags = 0;
+       msg->len = 2 + data_length;
+       msg->buf = data;
+
+       /* high byte goes out first */
+       data[0] = (u8) (reg >> 8);;
+       data[1] = (u8) (reg & 0xff);
+
+       if (data_length == MT9P012_8BIT)
+               data[2] = (u8) (val & 0xff);
+       else if (data_length == MT9P012_16BIT) {
+               data[2] = (u8) (val >> 8);
+               data[3] = (u8) (val & 0xff);
+       } else {
+               data[2] = (u8) (val >> 24);
+               data[3] = (u8) (val >> 16);
+               data[4] = (u8) (val >> 8);
+               data[5] = (u8) (val & 0xff);
+       }
+
+       err = i2c_transfer(client->adapter, msg, 1);
+       if (err >= 0)
+               return 0;
+
+       dev_err(&client->dev, "wrote 0x%x to offset 0x%x error %d", val, reg,
+                                                                       err);
+       if (retry <= I2C_RETRY_COUNT) {
+               dev_dbg(&client->dev, "retry ... %d", retry);
+               retry++;
+               set_current_state(TASK_UNINTERRUPTIBLE);
+               schedule_timeout(msecs_to_jiffies(20));
+               goto again;
+       }
+       return err;
+}
+
+/**
+ * mt9p012_write_regs - Initializes a list of MT9P012 registers
+ * @client: i2c driver client structure
+ * @reglist: list of registers to be written
+ *
+ * Initializes a list of MT9P012 registers. The list of registers is
+ * terminated by MT9P012_TOK_TERM.
+ */
+static int
+mt9p012_write_regs(struct i2c_client *client,
+                       const struct mt9p012_reg reglist[])
+{
+       int err;
+       const struct mt9p012_reg *next = reglist;
+
+       for (; next->length != MT9P012_TOK_TERM; next++) {
+               if (next->length == MT9P012_TOK_DELAY) {
+                       set_current_state(TASK_UNINTERRUPTIBLE);
+                       schedule_timeout(msecs_to_jiffies(next->val));
+                       continue;
+               }
+
+               err = mt9p012_write_reg(client, next->length,
+                                               next->reg, next->val);
+               if (err)
+                       return err;
+       }
+       return 0;
+}
+
+/**
+ * mt9p012_calc_pll - Calculate PLL settings based on input image size
+ * @isize: enum value corresponding to image size
+ * @xclk: xclk value (calculate by mt9p012sensor_calc_xclk())
+ * @sensor: pointer to sensor device information structure
+ *
+ * Calculates sensor PLL related settings (scaler, fps, pll_multiplier,
+ * pix_clk_freq, min_exposure_time, max_exposure_time) based on input
+ * image size.  It then applies the fps register settings based on
+ * these calculations.
+ */
+static int
+mt9p012_calc_pll(enum image_size isize,
+               unsigned long xclk,
+               struct mt9p012_sensor *sensor)
+{
+       int err = 0, row = 1, i = 0;
+       unsigned int vt_pix_clk;
+       unsigned int pll_multiplier;
+       unsigned int exposure_factor, pix_clk_scaled;
+       struct i2c_client *client = sensor->i2c_client;
+       struct vcontrol *lvc;
+
+       /* Greater than 1296x972
+       1. Scaler is 0
+       2. fps is 10
+       3. Apply image mode settings
+       4. Turn Streaming ON.
+       5. Exit
+       */
+       if (isize > BIN2X) {
+               /* Burst Mode */
+               sensor->scaler = 0;
+               sensor->fps = 10;
+               current_pll_video = PLL_5MP;
+               return 0;
+       }
+
+       /* Greater than 648X486 case
+       1. Scaler is 0
+       2. If fps>21 then choose PLL for 30
+       3. If fps<21 then choose PLL for 15
+
+       Greater than 216X162 case
+       1. Scaler is 1
+       2. If fps>15 then choose PLL for 30
+       3. If fps<15 then choose PLL for 15
+
+       Greater than 0 to 216x162
+       1. Scaler is 2.
+       2. If fps>15 then choose PLL for 30
+       3. If fps<15 then choose PLL for 15
+       */
+
+       if (isize > BIN4X) {
+               sensor->scaler = 0;
+               if (sensor->fps > 21)
+                       current_pll_video = PLL_1296_30FPS;
+               else
+                       current_pll_video = PLL_1296_15FPS;
+       } else if (isize > BIN4XSCALE) {
+               sensor->scaler = 1;
+               if (sensor->fps > 15)
+                       current_pll_video = PLL_648_30FPS;
+               else
+                       current_pll_video = PLL_648_15FPS;
+       } else {
+               sensor->scaler = 2;
+               if (sensor->fps > 15)
+                       current_pll_video = PLL_216_30FPS;
+               else
+                       current_pll_video = PLL_216_15FPS;
+       }
+
+       /* Row adjustment */
+       if (sensor->scaler && (sensor->fps < 16))
+               row = 2; /* Adjustment when using 4x binning and 12 MHz clk */
+
+       /* Calculate the PLL, set fps register */
+       vt_pix_clk = sensor->fps *
+               all_pll_settings[current_pll_video].frame_lines *
+               all_pll_settings[current_pll_video].line_len;
+
+       pll_multiplier =
+               (((vt_pix_clk
+                  * all_pll_settings[current_pll_video].vt_pix_clk_div
+                  * all_pll_settings[current_pll_video].vt_sys_clk_div
+                  * row) / xclk)
+                  * all_pll_settings[current_pll_video].pre_pll_div) + 1;
+
+       if (pll_multiplier < all_pll_settings[current_pll_video].min_pll)
+               pll_multiplier = all_pll_settings[current_pll_video].min_pll;
+       else if (pll_multiplier > all_pll_settings[current_pll_video].max_pll)
+               pll_multiplier = all_pll_settings[current_pll_video].max_pll;
+
+       pix_clk_freq = (xclk /
+                       (all_pll_settings[current_pll_video].pre_pll_div
+                        * all_pll_settings[current_pll_video].vt_pix_clk_div
+                        * all_pll_settings[current_pll_video].vt_sys_clk_div
+                        * row)) * pll_multiplier;
+       min_exposure_time = (all_pll_settings[current_pll_video].fine_int_tm
+                            * 1000000 / pix_clk_freq) + 1;
+       exposure_factor = (all_pll_settings[current_pll_video].frame_lines - 1)
+                               * all_pll_settings[current_pll_video].line_len;
+       exposure_factor += all_pll_settings[current_pll_video].fine_int_tm;
+       exposure_factor *= 100;
+       pix_clk_scaled = pix_clk_freq / 100;
+       max_exposure_time = (exposure_factor / pix_clk_scaled) * 100;
+
+       /* Apply the fps settings */
+       set_fps[0].length = MT9P012_16BIT;
+       set_fps[0].reg = REG_PLL_MULTIPLIER;
+       set_fps[0].val = pll_multiplier;
+       set_fps[1].length = MT9P012_TOK_TERM;
+       set_fps[1].reg = 0;
+       set_fps[1].val = 0;
+
+       /* Update min/max for query control */
+       i = find_vctrl(V4L2_CID_EXPOSURE);
+       if (i >= 0) {
+               lvc = &video_control[i];
+               lvc->qc.minimum = min_exposure_time;
+               lvc->qc.maximum = max_exposure_time;
+       }
+
+       err = mt9p012_write_regs(client, set_fps);
+       return err;
+}
+
+/**
+ * mt9p012_calc_size - Find the best match for a requested image capture size
+ * @width: requested image width in pixels
+ * @height: requested image height in pixels
+ *
+ * Find the best match for a requested image capture size.  The best match
+ * is chosen as the nearest match that has the same number or fewer pixels
+ * as the requested size, or the smallest image size if the requested size
+ * has fewer pixels than the smallest image.
+ */
+static enum image_size mt9p012_calc_size(unsigned int width,
+                                                       unsigned int height)
+{
+       enum image_size isize;
+       unsigned long pixels = width * height;
+
+       for (isize = BIN4XSCALE; isize <= FIVE_MP; isize++) {
+               if (mt9p012_sizes[isize].height *
+                                       mt9p012_sizes[isize].width >= pixels) {
+                       /* To improve image quality in VGA */
+                       if ((pixels > CIF_PIXELS) && (isize == BIN4X)) {
+                               isize = BIN2X;
+                       } else if ((pixels > QQVGA_PIXELS) &&
+                                                       (isize == BIN4XSCALE)) {
+                               isize = BIN4X;
+                       }
+                       return isize;
+               }
+       }
+
+       return FIVE_MP;
+}
+
+/**
+ * mt9p012_find_isize - Find the best match for a requested image capture size
+ * @width: requested image width in pixels
+ * @height: requested image height in pixels
+ *
+ * Find the best match for a requested image capture size.  The best match
+ * is chosen as the nearest match that has the same number or fewer pixels
+ * as the requested size, or the smallest image size if the requested size
+ * has fewer pixels than the smallest image.
+ */
+static enum image_size mt9p012_find_isize(unsigned int width)
+{
+       enum image_size isize;
+
+       for (isize = BIN4XSCALE; isize <= FIVE_MP; isize++) {
+               if (mt9p012_sizes[isize].width >= width)
+                       break;
+       }
+
+       return isize;
+}
+/**
+ * mt9p012_find_fps_index - Find the best fps range match for a
+ *  requested frame rate
+ * @fps: desired frame rate
+ * @isize: enum value corresponding to image size
+ *
+ * Find the best match for a requested frame rate.  The best match
+ * is chosen between two fps ranges (11 - 15 and 16 - 30 fps) depending on
+ * the image size. For image sizes larger than BIN2X, frame rate is fixed
+ * at 10 fps.
+ */
+static unsigned int mt9p012_find_fps_index(unsigned int fps,
+                                                       enum image_size isize)
+{
+       unsigned int index = FPS_LOW_RANGE;
+
+       if (isize > BIN4X) {
+               if (fps > 21)
+                       index = FPS_HIGH_RANGE;
+       } else {
+               if (fps > 15)
+                       index = FPS_HIGH_RANGE;
+       }
+
+       return index;
+}
+
+/**
+ * mt9p012sensor_calc_xclk - Calculate the required xclk frequency
+ * @c: i2c client driver structure
+ *
+ * Given the image capture format in pix, the nominal frame period in
+ * timeperframe, calculate and return the required xclk frequency
+ */
+static unsigned long mt9p012sensor_calc_xclk(struct i2c_client *c)
+{
+       struct mt9p012_sensor *sensor = i2c_get_clientdata(c);
+       struct v4l2_fract *timeperframe = &sensor->timeperframe;
+       struct v4l2_pix_format *pix = &sensor->pix;
+
+       if ((timeperframe->numerator == 0)
+       || (timeperframe->denominator == 0)) {
+               /* supply a default nominal_timeperframe */
+               timeperframe->numerator = 1;
+               timeperframe->denominator = MT9P012_DEF_FPS;
+       }
+
+       sensor->fps = timeperframe->denominator/timeperframe->numerator;
+       if (sensor->fps < MT9P012_MIN_FPS)
+               sensor->fps = MT9P012_MIN_FPS;
+       else if (sensor->fps > MT9P012_MAX_FPS)
+               sensor->fps = MT9P012_MAX_FPS;
+
+       timeperframe->numerator = 1;
+       timeperframe->denominator = sensor->fps;
+
+       if ((pix->width <= VIDEO_WIDTH_4X_BINN) && (sensor->fps > 15))
+               xclk_current = MT9P012_XCLK_NOM_2;
+       else
+               xclk_current = MT9P012_XCLK_NOM_1;
+
+       return xclk_current;
+}
+
+/**
+ * mt9p012_configure - Configure the mt9p012 for the specified image mode
+ * @s: pointer to standard V4L2 device structure
+ *
+ * Configure the mt9p012 for a specified image size, pixel format, and frame
+ * period.  xclk is the frequency (in Hz) of the xclk input to the mt9p012.
+ * fper is the frame period (in seconds) expressed as a fraction.
+ * Returns zero if successful, or non-zero otherwise.
+ * The actual frame period is returned in fper.
+ */
+static int mt9p012_configure(struct v4l2_int_device *s)
+{
+       struct mt9p012_sensor *sensor = s->priv;
+       struct v4l2_pix_format *pix = &sensor->pix;
+       struct i2c_client *client = sensor->i2c_client;
+       enum image_size isize;
+       unsigned int fps_index;
+       int err;
+
+       isize = mt9p012_find_isize(pix->width);
+
+       /* common register initialization */
+       err = mt9p012_write_regs(client, mt9p012_common);
+       if (err)
+               return err;
+
+       fps_index = mt9p012_find_fps_index(sensor->fps, isize);
+
+       /* configure image size and pixel format */
+       err = mt9p012_write_regs(client, mt9p012_reg_init[fps_index][isize]);
+       if (err)
+               return err;
+
+       /* configure frame rate */
+       err = mt9p012_calc_pll(isize, xclk_current, sensor);
+       if (err)
+               return err;
+
+       /* configure streaming ON */
+       err = mt9p012_write_regs(client, stream_on_list);
+
+       return err;
+}
+
+/**
+ * mt9p012_detect - Detect if an mt9p012 is present, and if so which revision
+ * @client: pointer to the i2c client driver structure
+ *
+ * Detect if an mt9p012 is present, and if so which revision.
+ * A device is considered to be detected if the manufacturer ID (MIDH and MIDL)
+ * and the product ID (PID) registers match the expected values.
+ * Any value of the version ID (VER) register is accepted.
+ * Here are the version numbers we know about:
+ *     0x48 --> mt9p012 Revision 1 or mt9p012 Revision 2
+ *     0x49 --> mt9p012 Revision 3
+ * Returns a negative error number if no device is detected, or the
+ * non-negative value of the version ID register if a device is detected.
+ */
+static int
+mt9p012_detect(struct i2c_client *client)
+{
+       u32 model_id, mfr_id, rev;
+
+       if (!client)
+               return -ENODEV;
+
+       if (mt9p012_read_reg(client, MT9P012_16BIT, REG_MODEL_ID, &model_id))
+               return -ENODEV;
+       if (mt9p012_read_reg(client, MT9P012_8BIT, REG_MANUFACTURER_ID,
+                               &mfr_id))
+               return -ENODEV;
+       if (mt9p012_read_reg(client, MT9P012_8BIT, REG_REVISION_NUMBER, &rev))
+               return -ENODEV;
+
+       dev_info(&client->dev, "model id detected 0x%x mfr 0x%x\n", model_id,
+                                                               mfr_id);
+       if ((model_id != MT9P012_MOD_ID) || (mfr_id != MT9P012_MFR_ID)) {
+               /* We didn't read the values we expected, so
+                * this must not be an MT9P012.
+                */
+               dev_warn(&client->dev, "model id mismatch 0x%x mfr 0x%x\n",
+                       model_id, mfr_id);
+
+               return -ENODEV;
+       }
+       return 0;
+
+}
+
+/**
+ * mt9p012sensor_set_exposure_time - sets exposure time per input value
+ * @exp_time: exposure time to be set on device
+ * @s: pointer to standard V4L2 device structure
+ * @lvc: pointer to V4L2 exposure entry in video_controls array
+ *
+ * If the requested exposure time is within the allowed limits, the HW
+ * is configured to use the new exposure time, and the video_controls
+ * array is updated with the new current value.
+ * The function returns 0 upon success.  Otherwise an error code is
+ * returned.
+ */
+int
+mt9p012sensor_set_exposure_time(u32 exp_time, struct v4l2_int_device *s,
+                                               struct vcontrol *lvc)
+{
+       int err;
+       struct mt9p012_sensor *sensor = s->priv;
+       struct i2c_client *client = sensor->i2c_client;
+       u32 coarse_int_time = 0;
+
+       if ((exp_time < min_exposure_time) ||
+                       (exp_time > max_exposure_time)) {
+               dev_err(&client->dev, "Exposure time not within the "
+                       "legal range.\n");
+               dev_err(&client->dev, "Min time %d us Max time %d us",
+                       min_exposure_time, max_exposure_time);
+               return -EINVAL;
+       }
+       coarse_int_time =
+               ((((exp_time / 10) * (pix_clk_freq / 1000)) / 1000)
+                  - (all_pll_settings[current_pll_video].fine_int_tm
+                     / 10))
+                  / (all_pll_settings[current_pll_video].line_len
+                     / 10);
+
+       dev_dbg(&client->dev, "coarse_int_time calculated = %d\n",
+                                               coarse_int_time);
+
+       set_exposure_time[COARSE_INT_TIME_INDEX].val = coarse_int_time;
+       err = mt9p012_write_regs(client, set_exposure_time);
+
+       if (err)
+               dev_err(&client->dev, "Error setting exposure time %d\n",
+                                                                       err);
+       else
+               lvc->current_value = exp_time;
+
+       return err;
+}
+
+/**
+ * mt9p012sensor_set_gain - sets sensor analog gain per input value
+ * @gain: analog gain value to be set on device
+ * @s: pointer to standard V4L2 device structure
+ * @lvc: pointer to V4L2 analog gain entry in video_controls array
+ *
+ * If the requested analog gain is within the allowed limits, the HW
+ * is configured to use the new gain value, and the video_controls
+ * array is updated with the new current value.
+ * The function returns 0 upon success.  Otherwise an error code is
+ * returned.
+ */
+int
+mt9p012sensor_set_gain(u16 gain, struct v4l2_int_device *s,
+                                       struct vcontrol *lvc)
+{
+       int err;
+       struct mt9p012_sensor *sensor = s->priv;
+       struct i2c_client *client = sensor->i2c_client;
+
+       if ((gain < MIN_GAIN) || (gain > MAX_GAIN)) {
+               dev_err(&client->dev, "Gain not within the legal range");
+               return -EINVAL;
+       }
+       set_analog_gain[GAIN_INDEX].val = gain;
+       err = mt9p012_write_regs(client, set_analog_gain);
+       if (err) {
+               dev_err(&client->dev, "Error setting gain.%d", err);
+               return err;
+       } else
+               lvc->current_value = gain;
+
+       return err;
+}
+
+/**
+ * ioctl_queryctrl - V4L2 sensor interface handler for VIDIOC_QUERYCTRL ioctl
+ * @s: pointer to standard V4L2 device structure
+ * @qc: standard V4L2 VIDIOC_QUERYCTRL ioctl structure
+ *
+ * If the requested control is supported, returns the control information
+ * from the video_control[] array.  Otherwise, returns -EINVAL if the
+ * control is not supported.
+ */
+static int ioctl_queryctrl(struct v4l2_int_device *s,
+                               struct v4l2_queryctrl *qc)
+{
+       int i;
+
+       i = find_vctrl(qc->id);
+       if (i == -EINVAL)
+               qc->flags = V4L2_CTRL_FLAG_DISABLED;
+
+       if (i < 0)
+               return -EINVAL;
+
+       *qc = video_control[i].qc;
+       return 0;
+}
+
+/**
+ * ioctl_g_ctrl - V4L2 sensor interface handler for VIDIOC_G_CTRL ioctl
+ * @s: pointer to standard V4L2 device structure
+ * @vc: standard V4L2 VIDIOC_G_CTRL ioctl structure
+ *
+ * If the requested control is supported, returns the control's current
+ * value from the video_control[] array.  Otherwise, returns -EINVAL
+ * if the control is not supported.
+ */
+static int ioctl_g_ctrl(struct v4l2_int_device *s,
+                            struct v4l2_control *vc)
+{
+       struct vcontrol *lvc;
+       int i;
+
+       i = find_vctrl(vc->id);
+       if (i < 0)
+               return -EINVAL;
+       lvc = &video_control[i];
+
+       switch (vc->id) {
+       case  V4L2_CID_EXPOSURE:
+               vc->value = lvc->current_value;
+               break;
+       case V4L2_CID_GAIN:
+               vc->value = lvc->current_value;
+               break;
+       }
+
+       return 0;
+}
+
+/**
+ * ioctl_s_ctrl - V4L2 sensor interface handler for VIDIOC_S_CTRL ioctl
+ * @s: pointer to standard V4L2 device structure
+ * @vc: standard V4L2 VIDIOC_S_CTRL ioctl structure
+ *
+ * If the requested control is supported, sets the control's current
+ * value in HW (and updates the video_control[] array).  Otherwise,
+ * returns -EINVAL if the control is not supported.
+ */
+static int ioctl_s_ctrl(struct v4l2_int_device *s,
+                            struct v4l2_control *vc)
+{
+       int retval = -EINVAL;
+       int i;
+       struct vcontrol *lvc;
+
+       i = find_vctrl(vc->id);
+       if (i < 0)
+               return -EINVAL;
+       lvc = &video_control[i];
+
+       switch (vc->id) {
+       case V4L2_CID_EXPOSURE:
+               retval = mt9p012sensor_set_exposure_time(vc->value, s, lvc);
+               break;
+       case V4L2_CID_GAIN:
+               retval = mt9p012sensor_set_gain(vc->value, s, lvc);
+               break;
+       }
+
+       return retval;
+}
+
+
+/**
+ * ioctl_enum_fmt_cap - Implement the CAPTURE buffer VIDIOC_ENUM_FMT ioctl
+ * @s: pointer to standard V4L2 device structure
+ * @fmt: standard V4L2 VIDIOC_ENUM_FMT ioctl structure
+ *
+ * Implement the VIDIOC_ENUM_FMT ioctl for the CAPTURE buffer type.
+ */
+static int ioctl_enum_fmt_cap(struct v4l2_int_device *s,
+                                  struct v4l2_fmtdesc *fmt)
+{
+       int index = fmt->index;
+       enum v4l2_buf_type type = fmt->type;
+
+       memset(fmt, 0, sizeof(*fmt));
+       fmt->index = index;
+       fmt->type = type;
+
+       switch (fmt->type) {
+       case V4L2_BUF_TYPE_VIDEO_CAPTURE:
+               if (index >= NUM_CAPTURE_FORMATS)
+                       return -EINVAL;
+       break;
+       default:
+               return -EINVAL;
+       }
+
+       fmt->flags = mt9p012_formats[index].flags;
+       strlcpy(fmt->description, mt9p012_formats[index].description,
+                                       sizeof(fmt->description));
+       fmt->pixelformat = mt9p012_formats[index].pixelformat;
+
+       return 0;
+}
+
+/**
+ * ioctl_try_fmt_cap - Implement the CAPTURE buffer VIDIOC_TRY_FMT ioctl
+ * @s: pointer to standard V4L2 device structure
+ * @f: pointer to standard V4L2 VIDIOC_TRY_FMT ioctl structure
+ *
+ * Implement the VIDIOC_TRY_FMT ioctl for the CAPTURE buffer type.  This
+ * ioctl is used to negotiate the image capture size and pixel format
+ * without actually making it take effect.
+ */
+static int ioctl_try_fmt_cap(struct v4l2_int_device *s,
+                            struct v4l2_format *f)
+{
+       enum image_size isize;
+       int ifmt;
+       struct v4l2_pix_format *pix = &f->fmt.pix;
+       struct mt9p012_sensor *sensor = s->priv;
+       struct v4l2_pix_format *pix2 = &sensor->pix;
+
+       isize = mt9p012_calc_size(pix->width, pix->height);
+
+       pix->width = mt9p012_sizes[isize].width;
+       pix->height = mt9p012_sizes[isize].height;
+       for (ifmt = 0; ifmt < NUM_CAPTURE_FORMATS; ifmt++) {
+               if (pix->pixelformat == mt9p012_formats[ifmt].pixelformat)
+                       break;
+       }
+       if (ifmt == NUM_CAPTURE_FORMATS)
+               ifmt = 0;
+       pix->pixelformat = mt9p012_formats[ifmt].pixelformat;
+       pix->field = V4L2_FIELD_NONE;
+       pix->bytesperline = pix->width * 2;
+       pix->sizeimage = pix->bytesperline * pix->height;
+       pix->priv = 0;
+       switch (pix->pixelformat) {
+       case V4L2_PIX_FMT_YUYV:
+       case V4L2_PIX_FMT_UYVY:
+               pix->colorspace = V4L2_COLORSPACE_JPEG;
+               break;
+       case V4L2_PIX_FMT_RGB565:
+       case V4L2_PIX_FMT_RGB565X:
+       case V4L2_PIX_FMT_RGB555:
+       case V4L2_PIX_FMT_SGRBG10:
+       case V4L2_PIX_FMT_RGB555X:
+       default:
+               pix->colorspace = V4L2_COLORSPACE_SRGB;
+               break;
+       }
+       *pix2 = *pix;
+       return 0;
+}
+
+/**
+ * ioctl_s_fmt_cap - V4L2 sensor interface handler for VIDIOC_S_FMT ioctl
+ * @s: pointer to standard V4L2 device structure
+ * @f: pointer to standard V4L2 VIDIOC_S_FMT ioctl structure
+ *
+ * If the requested format is supported, configures the HW to use that
+ * format, returns error code if format not supported or HW can't be
+ * correctly configured.
+ */
+static int ioctl_s_fmt_cap(struct v4l2_int_device *s,
+                               struct v4l2_format *f)
+{
+       struct mt9p012_sensor *sensor = s->priv;
+       struct v4l2_pix_format *pix = &f->fmt.pix;
+       int rval;
+
+       rval = ioctl_try_fmt_cap(s, f);
+       if (rval)
+               return rval;
+       else
+               sensor->pix = *pix;
+
+       return rval;
+}
+
+/**
+ * ioctl_g_fmt_cap - V4L2 sensor interface handler for ioctl_g_fmt_cap
+ * @s: pointer to standard V4L2 device structure
+ * @f: pointer to standard V4L2 v4l2_format structure
+ *
+ * Returns the sensor's current pixel format in the v4l2_format
+ * parameter.
+ */
+static int ioctl_g_fmt_cap(struct v4l2_int_device *s,
+                               struct v4l2_format *f)
+{
+       struct mt9p012_sensor *sensor = s->priv;
+       f->fmt.pix = sensor->pix;
+
+       return 0;
+}
+
+/**
+ * ioctl_g_parm - V4L2 sensor interface handler for VIDIOC_G_PARM ioctl
+ * @s: pointer to standard V4L2 device structure
+ * @a: pointer to standard V4L2 VIDIOC_G_PARM ioctl structure
+ *
+ * Returns the sensor's video CAPTURE parameters.
+ */
+static int ioctl_g_parm(struct v4l2_int_device *s,
+                            struct v4l2_streamparm *a)
+{
+       struct mt9p012_sensor *sensor = s->priv;
+       struct v4l2_captureparm *cparm = &a->parm.capture;
+
+       if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+               return -EINVAL;
+
+       memset(a, 0, sizeof(*a));
+       a->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+
+       cparm->capability = V4L2_CAP_TIMEPERFRAME;
+       cparm->timeperframe = sensor->timeperframe;
+
+       return 0;
+}
+
+/**
+ * ioctl_s_parm - V4L2 sensor interface handler for VIDIOC_S_PARM ioctl
+ * @s: pointer to standard V4L2 device structure
+ * @a: pointer to standard V4L2 VIDIOC_S_PARM ioctl structure
+ *
+ * Configures the sensor to use the input parameters, if possible.  If
+ * not possible, reverts to the old parameters and returns the
+ * appropriate error code.
+ */
+static int ioctl_s_parm(struct v4l2_int_device *s,
+                            struct v4l2_streamparm *a)
+{
+       struct mt9p012_sensor *sensor = s->priv;
+       struct i2c_client *client = sensor->i2c_client;
+       struct v4l2_fract *timeperframe = &a->parm.capture.timeperframe;
+
+       sensor->timeperframe = *timeperframe;
+       mt9p012sensor_calc_xclk(client);
+       *timeperframe = sensor->timeperframe;
+
+       return 0;
+}
+
+/**
+ * ioctl_g_ifparm - V4L2 sensor interface handler for vidioc_int_g_ifparm_num
+ * @s: pointer to standard V4L2 device structure
+ * @p: pointer to standard V4L2 vidioc_int_g_ifparm_num ioctl structure
+ *
+ * Gets slave interface parameters.
+ * Calculates the required xclk value to support the requested
+ * clock parameters in p.  This value is returned in the p
+ * parameter.
+ */
+static int ioctl_g_ifparm(struct v4l2_int_device *s, struct v4l2_ifparm *p)
+{
+       struct mt9p012_sensor *sensor = s->priv;
+       int rval;
+
+       rval = sensor->pdata->ifparm(p);
+       if (rval)
+               return rval;
+
+       p->u.bt656.clock_curr = xclk_current;
+
+       return 0;
+}
+
+/**
+ * ioctl_g_priv - V4L2 sensor interface handler for vidioc_int_g_priv_num
+ * @s: pointer to standard V4L2 device structure
+ * @p: void pointer to hold sensor's private data address
+ *
+ * Returns device's (sensor's) private data area address in p parameter
+ */
+static int ioctl_g_priv(struct v4l2_int_device *s, void *p)
+{
+       struct mt9p012_sensor *sensor = s->priv;
+
+       return sensor->pdata->priv_data_set(p);
+
+}
+
+/**
+ * ioctl_s_power - V4L2 sensor interface handler for vidioc_int_s_power_num
+ * @s: pointer to standard V4L2 device structure
+ * @on: power state to which device is to be set
+ *
+ * Sets devices power state to requrested state, if possible.
+ */
+static int ioctl_s_power(struct v4l2_int_device *s, enum v4l2_power on)
+{
+       struct mt9p012_sensor *sensor = s->priv;
+       struct i2c_client *c = sensor->i2c_client;
+       struct v4l2_ifparm p;
+       int rval;
+
+       rval = ioctl_g_ifparm(s, &p);
+       if (rval) {
+               dev_err(&c->dev, "Unable to get if params\n");
+               return rval;
+       }
+
+       if (((on == V4L2_POWER_OFF) || (on == V4L2_POWER_STANDBY))
+               && (sensor->state == SENSOR_DETECTED))
+               mt9p012_write_regs(c, stream_off_list);
+
+
+       if ((on != V4L2_POWER_ON) && (on != V4L2_POWER_RESUME))
+               isp_set_xclk(0, MT9P012_USE_XCLKA);
+       else
+               isp_set_xclk(p.u.bt656.clock_curr, MT9P012_USE_XCLKA);
+
+
+       rval = sensor->pdata->power_set(on);
+       if (rval < 0) {
+               dev_err(&c->dev, "Unable to set the power state: " DRIVER_NAME
+                                                               " sensor\n");
+               isp_set_xclk(0, MT9P012_USE_XCLKA);
+               return rval;
+       }
+
+       if ((on == V4L2_POWER_RESUME) && (sensor->state == SENSOR_DETECTED))
+               mt9p012_configure(s);
+
+       if ((on == V4L2_POWER_ON) && (sensor->state == SENSOR_NOT_DETECTED)) {
+               rval = mt9p012_detect(c);
+               if (rval < 0) {
+                       dev_err(&c->dev, "Unable to detect " DRIVER_NAME
+                                                               " sensor\n");
+                       sensor->state = SENSOR_NOT_DETECTED;
+                       return rval;
+               }
+               sensor->state = SENSOR_DETECTED;
+               sensor->ver = rval;
+               pr_info(DRIVER_NAME " chip version 0x%02x detected\n",
+                                                               sensor->ver);
+       }
+
+       return 0;
+}
+
+/**
+ * ioctl_init - V4L2 sensor interface handler for VIDIOC_INT_INIT
+ * @s: pointer to standard V4L2 device structure
+ *
+ * Initialize the sensor device (call mt9p012_configure())
+ */
+static int ioctl_init(struct v4l2_int_device *s)
+{
+       return 0;
+}
+
+/**
+ * ioctl_dev_exit - V4L2 sensor interface handler for vidioc_int_dev_exit_num
+ * @s: pointer to standard V4L2 device structure
+ *
+ * Delinitialise the dev. at slave detach.  The complement of ioctl_dev_init.
+ */
+static int ioctl_dev_exit(struct v4l2_int_device *s)
+{
+       return 0;
+}
+
+/**
+ * ioctl_dev_init - V4L2 sensor interface handler for vidioc_int_dev_init_num
+ * @s: pointer to standard V4L2 device structure
+ *
+ * Initialise the device when slave attaches to the master.  Returns 0 if
+ * mt9p012 device could be found, otherwise returns appropriate error.
+ */
+static int ioctl_dev_init(struct v4l2_int_device *s)
+{
+       struct mt9p012_sensor *sensor = s->priv;
+       struct i2c_client *c = sensor->i2c_client;
+       int err;
+
+       err = mt9p012_detect(c);
+       if (err < 0) {
+               dev_err(&c->dev, "Unable to detect " DRIVER_NAME " sensor\n");
+               return err;
+       }
+
+       sensor->ver = err;
+       pr_info(DRIVER_NAME " chip version 0x%02x detected\n", sensor->ver);
+
+       return 0;
+}
+/**
+ * ioctl_enum_framesizes - V4L2 sensor if handler for vidioc_int_enum_framesizes
+ * @s: pointer to standard V4L2 device structure
+ * @frms: pointer to standard V4L2 framesizes enumeration structure
+ *
+ * Returns possible framesizes depending on choosen pixel format
+ **/
+static int ioctl_enum_framesizes(struct v4l2_int_device *s,
+                                       struct v4l2_frmsizeenum *frms)
+{
+       int ifmt;
+
+       for (ifmt = 0; ifmt < NUM_CAPTURE_FORMATS; ifmt++) {
+               if (frms->pixel_format == mt9p012_formats[ifmt].pixelformat)
+                       break;
+       }
+       /* Is requested pixelformat not found on sensor? */
+       if (ifmt == NUM_CAPTURE_FORMATS)
+               return -EINVAL;
+
+       /* Do we already reached all discrete framesizes? */
+       if (frms->index >= 5)
+               return -EINVAL;
+
+       frms->type = V4L2_FRMSIZE_TYPE_DISCRETE;
+       frms->discrete.width = mt9p012_sizes[frms->index].width;
+       frms->discrete.height = mt9p012_sizes[frms->index].height;
+
+       return 0;
+}
+
+const struct v4l2_fract mt9p012_frameintervals[] = {
+       {  .numerator = 1, .denominator = 11 },
+       {  .numerator = 1, .denominator = 15 },
+       {  .numerator = 1, .denominator = 20 },
+       {  .numerator = 1, .denominator = 25 },
+       {  .numerator = 1, .denominator = 30 },
+};
+
+static int ioctl_enum_frameintervals(struct v4l2_int_device *s,
+                                       struct v4l2_frmivalenum *frmi)
+{
+       int ifmt;
+
+       for (ifmt = 0; ifmt < NUM_CAPTURE_FORMATS; ifmt++) {
+               if (frmi->pixel_format == mt9p012_formats[ifmt].pixelformat)
+                       break;
+       }
+       /* Is requested pixelformat not found on sensor? */
+       if (ifmt == NUM_CAPTURE_FORMATS)
+               return -EINVAL;
+
+       /* Do we already reached all discrete framesizes? */
+
+       if ((frmi->width == mt9p012_sizes[4].width) &&
+                               (frmi->height == mt9p012_sizes[4].height)) {
+               /* FIXME: The only frameinterval supported by 5MP capture is
+                * 1/11 fps
+                */
+               if (frmi->index != 0)
+                       return -EINVAL;
+       } else {
+               if (frmi->index >= 5)
+                       return -EINVAL;
+       }
+
+       frmi->type = V4L2_FRMSIZE_TYPE_DISCRETE;
+       frmi->discrete.numerator =
+                               mt9p012_frameintervals[frmi->index].numerator;
+       frmi->discrete.denominator =
+                               mt9p012_frameintervals[frmi->index].denominator;
+
+       return 0;
+}
+
+static struct v4l2_int_ioctl_desc mt9p012_ioctl_desc[] = {
+       { .num = vidioc_int_enum_framesizes_num,
+         .func = (v4l2_int_ioctl_func *)ioctl_enum_framesizes },
+       { .num = vidioc_int_enum_frameintervals_num,
+         .func = (v4l2_int_ioctl_func *)ioctl_enum_frameintervals },
+       { .num = vidioc_int_dev_init_num,
+         .func = (v4l2_int_ioctl_func *)ioctl_dev_init },
+       { .num = vidioc_int_dev_exit_num,
+         .func = (v4l2_int_ioctl_func *)ioctl_dev_exit },
+       { .num = vidioc_int_s_power_num,
+         .func = (v4l2_int_ioctl_func *)ioctl_s_power },
+       { .num = vidioc_int_g_priv_num,
+         .func = (v4l2_int_ioctl_func *)ioctl_g_priv },
+       { .num = vidioc_int_g_ifparm_num,
+         .func = (v4l2_int_ioctl_func *)ioctl_g_ifparm },
+       { .num = vidioc_int_init_num,
+         .func = (v4l2_int_ioctl_func *)ioctl_init },
+       { .num = vidioc_int_enum_fmt_cap_num,
+         .func = (v4l2_int_ioctl_func *)ioctl_enum_fmt_cap },
+       { .num = vidioc_int_try_fmt_cap_num,
+         .func = (v4l2_int_ioctl_func *)ioctl_try_fmt_cap },
+       { .num = vidioc_int_g_fmt_cap_num,
+         .func = (v4l2_int_ioctl_func *)ioctl_g_fmt_cap },
+       { .num = vidioc_int_s_fmt_cap_num,
+         .func = (v4l2_int_ioctl_func *)ioctl_s_fmt_cap },
+       { .num = vidioc_int_g_parm_num,
+         .func = (v4l2_int_ioctl_func *)ioctl_g_parm },
+       { .num = vidioc_int_s_parm_num,
+         .func = (v4l2_int_ioctl_func *)ioctl_s_parm },
+       { .num = vidioc_int_queryctrl_num,
+         .func = (v4l2_int_ioctl_func *)ioctl_queryctrl },
+       { .num = vidioc_int_g_ctrl_num,
+         .func = (v4l2_int_ioctl_func *)ioctl_g_ctrl },
+       { .num = vidioc_int_s_ctrl_num,
+         .func = (v4l2_int_ioctl_func *)ioctl_s_ctrl },
+};
+
+static struct v4l2_int_slave mt9p012_slave = {
+       .ioctls = mt9p012_ioctl_desc,
+       .num_ioctls = ARRAY_SIZE(mt9p012_ioctl_desc),
+};
+
+static struct v4l2_int_device mt9p012_int_device = {
+       .module = THIS_MODULE,
+       .name = DRIVER_NAME,
+       .priv = &mt9p012,
+       .type = v4l2_int_type_slave,
+       .u = {
+               .slave = &mt9p012_slave,
+       },
+};
+
+/**
+ * mt9p012_probe - sensor driver i2c probe handler
+ * @client: i2c driver client device structure
+ *
+ * Register sensor as an i2c client device and V4L2
+ * device.
+ */
+static int
+mt9p012_probe(struct i2c_client *client, const struct i2c_device_id *id)
+{
+       struct mt9p012_sensor *sensor = &mt9p012;
+       int err;
+
+       if (i2c_get_clientdata(client))
+               return -EBUSY;
+
+       sensor->pdata = client->dev.platform_data;
+
+       if (!sensor->pdata) {
+               dev_err(&client->dev, "no platform data?\n");
+               return -ENODEV;
+       }
+
+       sensor->v4l2_int_device = &mt9p012_int_device;
+       sensor->i2c_client = client;
+
+       i2c_set_clientdata(client, sensor);
+
+       /* Make the default capture format QCIF V4L2_PIX_FMT_SGRBG10 */
+       sensor->pix.width = VIDEO_WIDTH_4X_BINN_SCALED;
+       sensor->pix.height = VIDEO_WIDTH_4X_BINN_SCALED;
+       sensor->pix.pixelformat = V4L2_PIX_FMT_SGRBG10;
+
+       err = v4l2_int_device_register(sensor->v4l2_int_device);
+       if (err)
+               i2c_set_clientdata(client, NULL);
+
+       return err;
+}
+
+/**
+ * mt9p012_remove - sensor driver i2c remove handler
+ * @client: i2c driver client device structure
+ *
+ * Unregister sensor as an i2c client device and V4L2
+ * device.  Complement of mt9p012_probe().
+ */
+static int __exit
+mt9p012_remove(struct i2c_client *client)
+{
+       struct mt9p012_sensor *sensor = i2c_get_clientdata(client);
+
+       if (!client->adapter)
+               return -ENODEV; /* our client isn't attached */
+
+       v4l2_int_device_unregister(sensor->v4l2_int_device);
+       i2c_set_clientdata(client, NULL);
+
+       return 0;
+}
+
+static const struct i2c_device_id mt9p012_id[] = {
+       { DRIVER_NAME, 0 },
+       { },
+};
+MODULE_DEVICE_TABLE(i2c, mt9p012_id);
+
+static struct i2c_driver mt9p012sensor_i2c_driver = {
+       .driver = {
+               .name = DRIVER_NAME,
+               .owner = THIS_MODULE,
+       },
+       .probe = mt9p012_probe,
+       .remove = __exit_p(mt9p012_remove),
+       .id_table = mt9p012_id,
+};
+
+static struct mt9p012_sensor mt9p012 = {
+       .timeperframe = {
+               .numerator = 1,
+               .denominator = 15,
+       },
+       .state = SENSOR_NOT_DETECTED,
+};
+
+/**
+ * mt9p012sensor_init - sensor driver module_init handler
+ *
+ * Registers driver as an i2c client driver.  Returns 0 on success,
+ * error code otherwise.
+ */
+static int __init mt9p012sensor_init(void)
+{
+       int err;
+
+       err = i2c_add_driver(&mt9p012sensor_i2c_driver);
+       if (err) {
+               printk(KERN_ERR "Failed to register" DRIVER_NAME ".\n");
+               return err;
+       }
+
+       return 0;
+}
+late_initcall(mt9p012sensor_init);
+
+/**
+ * mt9p012sensor_cleanup - sensor driver module_exit handler
+ *
+ * Unregisters/deletes driver as an i2c client driver.
+ * Complement of mt9p012sensor_init.
+ */
+static void __exit mt9p012sensor_cleanup(void)
+{
+       i2c_del_driver(&mt9p012sensor_i2c_driver);
+}
+module_exit(mt9p012sensor_cleanup);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("mt9p012 camera sensor driver");
Index: linux-omap-2.6/drivers/media/video/mt9p012.h
===================================================================
--- /dev/null   1970-01-01 00:00:00.000000000 +0000
+++ linux-omap-2.6/drivers/media/video/mt9p012.h        2008-08-28 19:52:24.000000000 -0500
@@ -0,0 +1,295 @@
+/*
+ * drivers/media/video/mt9p012.h
+ *
+ * Register definitions for the MT9P012 camera sensor.
+ *
+ * Author:
+ *     Sameer Venkatraman <sameerv@ti.com>
+ *     Martinez Leonides
+ *
+ *
+ * Copyright (C) 2008 Texas Instruments.
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2. This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ */
+
+#ifndef MT9P012_H
+#define MT9P012_H
+
+
+#define MT9P012_I2C_ADDR               0x10
+
+/* The ID values we are looking for */
+#define MT9P012_MOD_ID                 0x2800
+#define MT9P012_MFR_ID                 0x0006
+
+/* MT9P012 has 8/16/32 registers */
+#define MT9P012_8BIT                   1
+#define MT9P012_16BIT                  2
+#define MT9P012_32BIT                  4
+
+/* terminating token for reg list */
+#define MT9P012_TOK_TERM               0xFF
+
+/* delay token for reg list */
+#define MT9P012_TOK_DELAY              100
+
+/* Sensor specific GPIO signals */
+#define MT9P012_RESET_GPIO     98
+#define MT9P012_STANDBY_GPIO   58
+
+#define VAUX_2_8_V             0x09
+#define VAUX_DEV_GRP_P1                0x20
+#define VAUX_DEV_GRP_NONE      0x00
+
+#define DEBUG_BASE             0x08000000
+#define REG_SDP3430_FPGA_GPIO_2 (0x50)
+#define FPGA_SPR_GPIO1_3v3     (0x1 << 14)
+#define FPGA_GPIO6_DIR_CTRL    (0x1 << 6)
+
+/* terminating list entry for reg */
+#define MT9P012_REG_TERM               0xFF
+/* terminating list entry for val */
+#define MT9P012_VAL_TERM               0xFF
+
+#define MT9P012_CLKRC                  0x11
+
+/* Used registers */
+#define REG_MODEL_ID                   0x0000
+#define REG_REVISION_NUMBER            0x0002
+#define REG_MANUFACTURER_ID            0x0003
+
+#define REG_MODE_SELECT                        0x0100
+#define REG_IMAGE_ORIENTATION          0x0101
+#define REG_SOFTWARE_RESET             0x0103
+#define REG_GROUPED_PAR_HOLD           0x0104
+
+#define REG_FINE_INT_TIME              0x0200
+#define REG_COARSE_INT_TIME            0x0202
+
+#define REG_ANALOG_GAIN_GLOBAL         0x0204
+#define REG_ANALOG_GAIN_GREENR         0x0206
+#define REG_ANALOG_GAIN_RED            0x0208
+#define REG_ANALOG_GAIN_BLUE           0x020A
+#define REG_ANALOG_GAIN_GREENB         0x020C
+#define REG_DIGITAL_GAIN_GREENR                0x020E
+#define REG_DIGITAL_GAIN_RED           0x0210
+#define REG_DIGITAL_GAIN_BLUE          0x0212
+#define REG_DIGITAL_GAIN_GREENB                0x0214
+
+#define REG_VT_PIX_CLK_DIV             0x0300
+#define REG_VT_SYS_CLK_DIV             0x0302
+#define REG_PRE_PLL_CLK_DIV            0x0304
+#define REG_PLL_MULTIPLIER             0x0306
+#define REG_OP_PIX_CLK_DIV             0x0308
+#define REG_OP_SYS_CLK_DIV             0x030A
+
+#define REG_FRAME_LEN_LINES            0x0340
+#define REG_LINE_LEN_PCK               0x0342
+
+#define REG_X_ADDR_START               0x0344
+#define REG_Y_ADDR_START               0x0346
+#define REG_X_ADDR_END                 0x0348
+#define REG_Y_ADDR_END                 0x034A
+#define REG_X_OUTPUT_SIZE              0x034C
+#define REG_Y_OUTPUT_SIZE              0x034E
+#define REG_X_ODD_INC                  0x0382
+#define REG_Y_ODD_INC                  0x0386
+
+#define REG_SCALING_MODE               0x0400
+#define REG_SCALE_M                    0x0404
+#define REG_SCALE_N                    0x0406
+
+#define REG_ROW_SPEED                  0x3016
+#define REG_RESET_REGISTER             0x301A
+#define REG_PIXEL_ORDER                        0x3024
+#define REG_READ_MODE                  0x3040
+
+#define REG_DATAPATH_STATUS            0x306A
+#define REG_DATAPATH_SELECT            0x306E
+
+#define REG_RESERVED_MFR_3064          0x3064
+#define REG_TEST_PATTERN               0x3070
+
+
+#define MT9P012_GAIN                   0x00
+
+/*
+ * The nominal xclk input frequency of the MT9P012 is 12MHz, maximum
+ * frequency is 64MHz, and minimum frequency is 2MHz.
+ */
+#define MT9P012_XCLK_MIN   2000000
+#define MT9P012_XCLK_MAX   64000000
+#define MT9P012_XCLK_NOM_1 12000000
+#define MT9P012_XCLK_NOM_2 24000000
+
+#define MT9P012_USE_XCLKA      0
+#define MT9P012_USE_XCLKB      1
+
+
+/* FPS Capabilities */
+#define MT9P012_MIN_FPS                11
+#define MT9P012_DEF_FPS                15
+#define MT9P012_MAX_FPS                30
+
+#define MT9P012_I2C_DELAY      3
+#define I2C_RETRY_COUNT                5
+
+/* Still capture 5 MP */
+#define IMAGE_WIDTH_MAX                2592
+#define IMAGE_HEIGHT_MAX       1944
+/* Still capture 3 MP and down to VGA, using ISP resizer */
+#define IMAGE_WIDTH_MIN                2048
+#define IMAGE_HEIGHT_MIN       1536
+
+
+/* Video mode, for D1 NTSC, D1 PAL */
+#define VIDEO_WIDTH_2X_BINN    1296
+#define VIDEO_HEIGHT_2X_BINN   972
+
+/* Sensor Video mode size for VGA, CIF, QVGA in 4x binning mode */
+#define VIDEO_WIDTH_4X_BINN    648
+#define VIDEO_HEIGHT_4X_BINN   486
+/* To improve image quality in VGA */
+#define CIF_PIXELS             (352 * 288)
+#define QQVGA_PIXELS           (160 * 120)
+
+/* Video mode, for QCIF, SQCIF */
+#define VIDEO_WIDTH_4X_BINN_SCALED      216
+#define VIDEO_HEIGHT_4X_BINN_SCALED     162
+
+/* Default coarse integration times to get a good exposure */
+#define COARSE_INT_TIME_216             550
+#define COARSE_INT_TIME_648             550
+#define COARSE_INT_TIME_216_30FPS      1350
+#define COARSE_INT_TIME_648_30FPS      1350
+#define COARSE_INT_TIME_1296           1000
+#define COARSE_INT_TIME_3MP            1700
+#define COARSE_INT_TIME_5MP            1700
+#define COARSE_INT_TIME_INDEX          1
+#define TST_PAT                        0x0
+
+/* Analog gain values */
+#define MIN_GAIN       0x08
+#define MAX_GAIN       0x7F
+#define DEF_GAIN       0x43
+#define GAIN_STEP      0x1
+
+#define GAIN_INDEX     1
+
+/* Exposure time values */
+#define DEF_MIN_EXPOSURE       0x08
+#define DEF_MAX_EXPOSURE       0x7F
+#define DEF_EXPOSURE           0x43
+#define EXPOSURE_STEP          1
+
+#define SENSOR_DETECTED                1
+#define SENSOR_NOT_DETECTED    0
+
+/**
+ * struct mt9p012_reg - mt9p012 register format
+ * @length: length of the register
+ * @reg: 16-bit offset to register
+ * @val: 8/16/32-bit register value
+ *
+ * Define a structure for MT9P012 register initialization values
+ */
+struct mt9p012_reg {
+       u16     length;
+       u16     reg;
+       u32     val;
+};
+
+enum image_size {
+       BIN4XSCALE,
+       BIN4X,
+       BIN2X,
+       THREE_MP,
+       FIVE_MP
+};
+
+enum pixel_format {
+       RAWBAYER10
+};
+
+#define NUM_IMAGE_SIZES                5
+#define NUM_PIXEL_FORMATS      1
+#define NUM_FPS                        2       /* 2 ranges */
+#define FPS_LOW_RANGE          0
+#define FPS_HIGH_RANGE         1
+
+/**
+ * struct capture_size - image capture size information
+ * @width: image width in pixels
+ * @height: image height in pixels
+ */
+struct capture_size {
+       unsigned long width;
+       unsigned long height;
+};
+
+/**
+ * struct mt9p012_platform_data - platform data values and access functions
+ * @power_set: Power state access function, zero is off, non-zero is on.
+ * @default_regs: Default registers written after power-on or reset.
+ * @ifparm: Interface parameters access function
+ * @priv_data_set: device private data (pointer) access function
+ */
+struct mt9p012_platform_data {
+       int (*power_set)(enum v4l2_power power);
+       const struct mt9p012_reg *default_regs;
+       int (*ifparm)(struct v4l2_ifparm *p);
+       int (*priv_data_set)(void *);
+};
+
+/**
+ * struct mt9p012_pll_settings - struct for storage of sensor pll values
+ * @vt_pix_clk_div: vertical pixel clock divider
+ * @vt_sys_clk_div: veritcal system clock divider
+ * @pre_pll_div: pre pll divider
+ * @fine_int_tm: fine resolution interval time
+ * @frame_lines: number of lines in frame
+ * @line_len: number of pixels in line
+ * @min_pll: minimum pll multiplier
+ * @max_pll: maximum pll multiplier
+ */
+struct mt9p012_pll_settings {
+       u16     vt_pix_clk_div;
+       u16     vt_sys_clk_div;
+       u16     pre_pll_div;
+
+       u16     fine_int_tm;
+       u16     frame_lines;
+       u16     line_len;
+
+       u16     min_pll;
+       u16     max_pll;
+};
+
+/*
+ * Array of image sizes supported by MT9P012.  These must be ordered from
+ * smallest image size to largest.
+ */
+const static struct capture_size mt9p012_sizes[] = {
+       {  216, 162 },  /* 4X BINNING+SCALING */
+       {  648, 486 },  /* 4X BINNING */
+       { 1296, 972 },  /* 2X BINNING */
+       { 2048, 1536},  /* 3 MP */
+       { 2592, 1944},  /* 5 MP */
+};
+
+/* PLL settings for MT9P012 */
+enum mt9p012_pll_type {
+  PLL_5MP = 0,
+  PLL_3MP,
+  PLL_1296_15FPS,
+  PLL_1296_30FPS,
+  PLL_648_15FPS,
+  PLL_648_30FPS,
+  PLL_216_15FPS,
+  PLL_216_30FPS
+};
+
+#endif /* ifndef MT9P012_H */

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
