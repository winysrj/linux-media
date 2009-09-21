Return-path: <linux-media-owner@vger.kernel.org>
Received: from av10-1-sn2.hy.skanova.net ([81.228.8.181]:44426 "EHLO
	av10-1-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754860AbZIUHst (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Sep 2009 03:48:49 -0400
Message-ID: <4AB72B33.5070107@mocean-labs.com>
Date: Mon, 21 Sep 2009 09:28:51 +0200
From: =?ISO-8859-1?Q?Richard_R=F6jfors?=
	<richard.rojfors@mocean-labs.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	dougsland@redhat.com
Subject: Re: [hg:v4l-dvb] video: initial support for ADV7180
References: <E1MoqBB-0006BF-Qx@mail.linuxtv.org>
In-Reply-To: <E1MoqBB-0006BF-Qx@mail.linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patch from Richard Röjfors wrote:
> The patch number 13019 was added via Douglas Schilling Landgraf <dougsland@redhat.com>
> to http://linuxtv.org/hg/v4l-dvb master development tree.
> 
> Kernel patches in this development tree may be modified to be backward
> compatible with older kernels. Compatibility modifications will be
> removed before inclusion into the mainstream Kernel
> 
> If anyone has any objections, please let us know by sending a message to:
> 	Linux Media Mailing List <linux-media@vger.kernel.org>
> 
> ------

Hi,

There is a newer version of the driver that has support for beeing
interrupt driver and setting standard, and checking the signal status.

I would be very happy if that gets committed instead.

Here it is:
------

Support for the ADV7180 Video Decoder.

Includes support for setting, getting video standard and status.
The driver can optionally be interrupt driven, otherwise it
polls for standard when required.

Signed-off-by: Richard Röjfors <richard.rojfors@mocean-labs.com>
---
diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 84b6fc1..ac9f636 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -265,6 +265,15 @@ config VIDEO_SAA6588

 comment "Video decoders"

+config VIDEO_ADV7180
+	tristate "Analog Devices ADV7180 decoder"
+	depends on VIDEO_V4L2 && I2C
+	---help---
+	  Support for the Analog Devices ADV7180 video decoder.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called adv7180.
+
 config VIDEO_BT819
 	tristate "BT819A VideoStream decoder"
 	depends on VIDEO_V4L2 && I2C
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 9f2e321..aac0884 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -45,6 +45,7 @@ obj-$(CONFIG_VIDEO_SAA7185) += saa7185.o
 obj-$(CONFIG_VIDEO_SAA7191) += saa7191.o
 obj-$(CONFIG_VIDEO_ADV7170) += adv7170.o
 obj-$(CONFIG_VIDEO_ADV7175) += adv7175.o
+obj-$(CONFIG_VIDEO_ADV7180) += adv7180.o
 obj-$(CONFIG_VIDEO_ADV7343) += adv7343.o
 obj-$(CONFIG_VIDEO_VPX3220) += vpx3220.o
 obj-$(CONFIG_VIDEO_BT819) += bt819.o
diff --git a/drivers/media/video/adv7180.c b/drivers/media/video/adv7180.c
new file mode 100644
index 0000000..a2169c1
--- /dev/null
+++ b/drivers/media/video/adv7180.c
@@ -0,0 +1,466 @@
+/*
+ * adv7180.c Analog Devices ADV7180 video decoder driver
+ * Copyright (c) 2009 Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/interrupt.h>
+#include <linux/i2c.h>
+#include <linux/i2c-id.h>
+#include <media/v4l2-ioctl.h>
+#include <linux/videodev2.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-chip-ident.h>
+#include <linux/mutex.h>
+
+#define DRIVER_NAME "adv7180"
+
+#define ADV7180_INPUT_CONTROL_REG			0x00
+#define ADV7180_INPUT_CONTROL_AD_PAL_BG_NTSC_J_SECAM	0x00
+#define ADV7180_INPUT_CONTROL_AD_PAL_BG_NTSC_J_SECAM_PED 0x10
+#define ADV7180_INPUT_CONTROL_AD_PAL_N_NTSC_J_SECAM	0x20
+#define ADV7180_INPUT_CONTROL_AD_PAL_N_NTSC_M_SECAM	0x30
+#define ADV7180_INPUT_CONTROL_NTSC_J			0x40
+#define ADV7180_INPUT_CONTROL_NTSC_M			0x50
+#define ADV7180_INPUT_CONTROL_PAL60			0x60
+#define ADV7180_INPUT_CONTROL_NTSC_443			0x70
+#define ADV7180_INPUT_CONTROL_PAL_BG			0x80
+#define ADV7180_INPUT_CONTROL_PAL_N			0x90
+#define ADV7180_INPUT_CONTROL_PAL_M			0xa0
+#define ADV7180_INPUT_CONTROL_PAL_M_PED			0xb0
+#define ADV7180_INPUT_CONTROL_PAL_COMB_N		0xc0
+#define ADV7180_INPUT_CONTROL_PAL_COMB_N_PED		0xd0
+#define ADV7180_INPUT_CONTROL_PAL_SECAM			0xe0
+#define ADV7180_INPUT_CONTROL_PAL_SECAM_PED		0xf0
+
+#define ADV7180_EXTENDED_OUTPUT_CONTROL_REG		0x04
+#define ADV7180_EXTENDED_OUTPUT_CONTROL_NTSCDIS		0xC5
+
+#define ADV7180_AUTODETECT_ENABLE_REG			0x07
+#define ADV7180_AUTODETECT_DEFAULT			0x7f
+
+#define ADV7180_ADI_CTRL_REG				0x0e
+#define ADV7180_ADI_CTRL_IRQ_SPACE			0x20
+
+#define ADV7180_STATUS1_REG				0x10
+#define ADV7180_STATUS1_IN_LOCK		0x01
+#define ADV7180_STATUS1_AUTOD_MASK	0x70
+#define ADV7180_STATUS1_AUTOD_NTSM_M_J	0x00
+#define ADV7180_STATUS1_AUTOD_NTSC_4_43 0x10
+#define ADV7180_STATUS1_AUTOD_PAL_M	0x20
+#define ADV7180_STATUS1_AUTOD_PAL_60	0x30
+#define ADV7180_STATUS1_AUTOD_PAL_B_G	0x40
+#define ADV7180_STATUS1_AUTOD_SECAM	0x50
+#define ADV7180_STATUS1_AUTOD_PAL_COMB	0x60
+#define ADV7180_STATUS1_AUTOD_SECAM_525	0x70
+
+#define ADV7180_IDENT_REG 0x11
+#define ADV7180_ID_7180 0x18
+
+#define ADV7180_ICONF1_ADI		0x40
+#define ADV7180_ICONF1_ACTIVE_LOW	0x01
+#define ADV7180_ICONF1_PSYNC_ONLY	0x10
+#define ADV7180_ICONF1_ACTIVE_TO_CLR	0xC0
+
+#define ADV7180_IRQ1_LOCK	0x01
+#define ADV7180_IRQ1_UNLOCK	0x02
+#define ADV7180_ISR1_ADI	0x42
+#define ADV7180_ICR1_ADI	0x43
+#define ADV7180_IMR1_ADI	0x44
+#define ADV7180_IMR2_ADI	0x48
+#define ADV7180_IRQ3_AD_CHANGE	0x08
+#define ADV7180_ISR3_ADI	0x4A
+#define ADV7180_ICR3_ADI	0x4B
+#define ADV7180_IMR3_ADI	0x4C
+#define ADV7180_IMR4_ADI	0x50
+
+struct adv7180_state {
+	struct v4l2_subdev	sd;
+	struct work_struct	work;
+	struct mutex		mutex; /* mutual excl. when accessing chip */
+	int			irq;
+	v4l2_std_id		curr_norm;
+	bool			autodetect;
+};
+
+static v4l2_std_id adv7180_std_to_v4l2(u8 status1)
+{
+	switch (status1 & ADV7180_STATUS1_AUTOD_MASK) {
+	case ADV7180_STATUS1_AUTOD_NTSM_M_J:
+		return V4L2_STD_NTSC;
+	case ADV7180_STATUS1_AUTOD_NTSC_4_43:
+		return V4L2_STD_NTSC_443;
+	case ADV7180_STATUS1_AUTOD_PAL_M:
+		return V4L2_STD_PAL_M;
+	case ADV7180_STATUS1_AUTOD_PAL_60:
+		return V4L2_STD_PAL_60;
+	case ADV7180_STATUS1_AUTOD_PAL_B_G:
+		return V4L2_STD_PAL;
+	case ADV7180_STATUS1_AUTOD_SECAM:
+		return V4L2_STD_SECAM;
+	case ADV7180_STATUS1_AUTOD_PAL_COMB:
+		return V4L2_STD_PAL_Nc | V4L2_STD_PAL_N;
+	case ADV7180_STATUS1_AUTOD_SECAM_525:
+		return V4L2_STD_SECAM;
+	default:
+		return V4L2_STD_UNKNOWN;
+	}
+}
+
+static int v4l2_std_to_adv7180(v4l2_std_id std)
+{
+	/* pal is a combination of several variants */
+	if (std & V4L2_STD_PAL)
+		return ADV7180_INPUT_CONTROL_PAL_BG;
+	if (std & V4L2_STD_NTSC)
+		return ADV7180_INPUT_CONTROL_NTSC_M;
+
+	switch (std) {
+	case V4L2_STD_PAL_60:
+		return ADV7180_INPUT_CONTROL_PAL60;
+	case V4L2_STD_NTSC_443:
+		return ADV7180_INPUT_CONTROL_NTSC_443;
+	case V4L2_STD_PAL_N:
+		return ADV7180_INPUT_CONTROL_PAL_N;
+	case V4L2_STD_PAL_M:
+		return ADV7180_INPUT_CONTROL_PAL_M;
+	case V4L2_STD_PAL_Nc:
+		return ADV7180_INPUT_CONTROL_PAL_COMB_N;
+	case V4L2_STD_SECAM:
+		return ADV7180_INPUT_CONTROL_PAL_SECAM;
+	default:
+		return -EINVAL;
+	}
+}
+
+static u32 adv7180_status_to_v4l2(u8 status1)
+{
+	if (!(status1 & ADV7180_STATUS1_IN_LOCK))
+		return V4L2_IN_ST_NO_SIGNAL;
+
+	return 0;
+}
+
+static int __adv7180_status(struct i2c_client *client, u32 *status,
+	v4l2_std_id *std)
+{
+	int status1 = i2c_smbus_read_byte_data(client, ADV7180_STATUS1_REG);
+
+	if (status1 < 0)
+		return status1;
+
+	if (status)
+		*status = adv7180_status_to_v4l2(status1);
+	if (std)
+		*std = adv7180_std_to_v4l2(status1);
+
+	return 0;
+}
+
+static inline struct adv7180_state *to_state(struct v4l2_subdev *sd)
+{
+	return container_of(sd, struct adv7180_state, sd);
+}
+
+static int adv7180_querystd(struct v4l2_subdev *sd, v4l2_std_id *std)
+{
+	struct adv7180_state *state = to_state(sd);
+	int err = mutex_lock_interruptible(&state->mutex);
+	if (err)
+		return err;
+
+	/* when we are interrupt driven we know the state */
+	if (!state->autodetect || state->irq > 0)
+		*std = state->curr_norm;
+	else
+		err = __adv7180_status(v4l2_get_subdevdata(sd), NULL, std);
+
+	mutex_unlock(&state->mutex);
+	return err;
+}
+
+static int adv7180_s_std(struct v4l2_subdev *sd, v4l2_std_id std)
+{
+	struct adv7180_state *state = to_state(sd);
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	int ret = mutex_lock_interruptible(&state->mutex);
+	if (ret)
+		return ret;
+
+	/* all standards -> autodetect */
+	if (std == V4L2_STD_ALL) {
+		ret = i2c_smbus_write_byte_data(client,
+			ADV7180_INPUT_CONTROL_REG,
+			ADV7180_INPUT_CONTROL_AD_PAL_BG_NTSC_J_SECAM);
+		if (ret < 0)
+			goto out;
+
+		__adv7180_status(client, NULL, &state->curr_norm);
+		state->autodetect = true;
+	} else {
+		ret = v4l2_std_to_adv7180(std);
+		if (ret < 0)
+			goto out;
+
+		ret = i2c_smbus_write_byte_data(client,
+			ADV7180_INPUT_CONTROL_REG, ret);
+		if (ret < 0)
+			goto out;
+
+		state->curr_norm = std;
+		state->autodetect = false;
+	}
+	ret = 0;
+out:
+	mutex_unlock(&state->mutex);
+	return ret;
+}
+
+static int adv7180_g_input_status(struct v4l2_subdev *sd, u32 *status)
+{
+	struct adv7180_state *state = to_state(sd);
+	int ret = mutex_lock_interruptible(&state->mutex);
+	if (ret)
+		return ret;
+
+	ret = __adv7180_status(v4l2_get_subdevdata(sd), status, NULL);
+	mutex_unlock(&state->mutex);
+	return ret;
+}
+
+static int adv7180_g_chip_ident(struct v4l2_subdev *sd,
+	struct v4l2_dbg_chip_ident *chip)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+	return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_ADV7180, 0);
+}
+
+static const struct v4l2_subdev_video_ops adv7180_video_ops = {
+	.querystd = adv7180_querystd,
+	.g_input_status = adv7180_g_input_status,
+};
+
+static const struct v4l2_subdev_core_ops adv7180_core_ops = {
+	.g_chip_ident = adv7180_g_chip_ident,
+	.s_std = adv7180_s_std,
+};
+
+static const struct v4l2_subdev_ops adv7180_ops = {
+	.core = &adv7180_core_ops,
+	.video = &adv7180_video_ops,
+};
+
+static void adv7180_work(struct work_struct *work)
+{
+	struct adv7180_state *state = container_of(work, struct adv7180_state,
+		work);
+	struct i2c_client *client = v4l2_get_subdevdata(&state->sd);
+	u8 isr3;
+
+	mutex_lock(&state->mutex);
+	i2c_smbus_write_byte_data(client, ADV7180_ADI_CTRL_REG,
+		ADV7180_ADI_CTRL_IRQ_SPACE);
+	isr3 = i2c_smbus_read_byte_data(client, ADV7180_ISR3_ADI);
+	/* clear */
+	i2c_smbus_write_byte_data(client, ADV7180_ICR3_ADI, isr3);
+	i2c_smbus_write_byte_data(client, ADV7180_ADI_CTRL_REG, 0);
+
+	if (isr3 & ADV7180_IRQ3_AD_CHANGE && state->autodetect)
+		__adv7180_status(client, NULL, &state->curr_norm);
+	mutex_unlock(&state->mutex);
+
+	enable_irq(state->irq);
+}
+
+static irqreturn_t adv7180_irq(int irq, void *devid)
+{
+	struct adv7180_state *state = devid;
+
+	schedule_work(&state->work);
+
+	disable_irq_nosync(state->irq);
+
+	return IRQ_HANDLED;
+}
+
+/*
+ * Generic i2c probe
+ * concerning the addresses: i2c wants 7 bit (without the r/w bit), so '>>1'
+ */
+
+static int adv7180_probe(struct i2c_client *client,
+			const struct i2c_device_id *id)
+{
+	struct adv7180_state *state;
+	struct v4l2_subdev *sd;
+	int ret;
+
+	/* Check if the adapter supports the needed features */
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
+		return -EIO;
+
+	v4l_info(client, "chip found @ 0x%02x (%s)\n",
+			client->addr << 1, client->adapter->name);
+
+	state = kzalloc(sizeof(struct adv7180_state), GFP_KERNEL);
+	if (state == NULL) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	state->irq = client->irq;
+	INIT_WORK(&state->work, adv7180_work);
+	mutex_init(&state->mutex);
+	state->autodetect = true;
+	sd = &state->sd;
+	v4l2_i2c_subdev_init(sd, client, &adv7180_ops);
+
+	/* Initialize adv7180 */
+	/* Enable autodetection */
+	ret = i2c_smbus_write_byte_data(client, ADV7180_INPUT_CONTROL_REG,
+		ADV7180_INPUT_CONTROL_AD_PAL_BG_NTSC_J_SECAM);
+	if (ret < 0)
+		goto err_unreg_subdev;
+
+	ret = i2c_smbus_write_byte_data(client, ADV7180_AUTODETECT_ENABLE_REG,
+		ADV7180_AUTODETECT_DEFAULT);
+	if (ret < 0)
+		goto err_unreg_subdev;
+
+	/* ITU-R BT.656-4 compatible */
+	ret = i2c_smbus_write_byte_data(client,
+		ADV7180_EXTENDED_OUTPUT_CONTROL_REG,
+		ADV7180_EXTENDED_OUTPUT_CONTROL_NTSCDIS);
+	if (ret < 0)
+		goto err_unreg_subdev;
+
+	/* read current norm */
+	__adv7180_status(client, NULL, &state->curr_norm);
+
+	/* register for interrupts */
+	if (state->irq > 0) {
+		ret = request_irq(state->irq, adv7180_irq, 0, DRIVER_NAME,
+			state);
+		if (ret)
+			goto err_unreg_subdev;
+
+		ret = i2c_smbus_write_byte_data(client, ADV7180_ADI_CTRL_REG,
+			ADV7180_ADI_CTRL_IRQ_SPACE);
+		if (ret < 0)
+			goto err_unreg_subdev;
+
+		/* config the Interrupt pin to be active low */
+		ret = i2c_smbus_write_byte_data(client, ADV7180_ICONF1_ADI,
+			ADV7180_ICONF1_ACTIVE_LOW | ADV7180_ICONF1_PSYNC_ONLY);
+		if (ret < 0)
+			goto err_unreg_subdev;
+
+		ret = i2c_smbus_write_byte_data(client, ADV7180_IMR1_ADI, 0);
+		if (ret < 0)
+			goto err_unreg_subdev;
+
+		ret = i2c_smbus_write_byte_data(client, ADV7180_IMR2_ADI, 0);
+		if (ret < 0)
+			goto err_unreg_subdev;
+
+		/* enable AD change interrupts interrupts */
+		ret = i2c_smbus_write_byte_data(client, ADV7180_IMR3_ADI,
+			ADV7180_IRQ3_AD_CHANGE);
+		if (ret < 0)
+			goto err_unreg_subdev;
+
+		ret = i2c_smbus_write_byte_data(client, ADV7180_IMR4_ADI, 0);
+		if (ret < 0)
+			goto err_unreg_subdev;
+
+		ret = i2c_smbus_write_byte_data(client, ADV7180_ADI_CTRL_REG,
+			0);
+		if (ret < 0)
+			goto err_unreg_subdev;
+	}
+
+	return 0;
+
+err_unreg_subdev:
+	mutex_destroy(&state->mutex);
+	v4l2_device_unregister_subdev(sd);
+	kfree(state);
+err:
+	printk(KERN_ERR DRIVER_NAME ": Failed to probe: %d\n", ret);
+	return ret;
+}
+
+static int adv7180_remove(struct i2c_client *client)
+{
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct adv7180_state *state = to_state(sd);
+
+	if (state->irq > 0) {
+		free_irq(client->irq, state);
+		if (cancel_work_sync(&state->work)) {
+			/*
+			 * Work was pending, therefore we need to enable
+			 * IRQ here to balance the disable_irq() done in the
+			 * interrupt handler.
+			 */
+			enable_irq(state->irq);
+		}
+	}
+
+	mutex_destroy(&state->mutex);
+	v4l2_device_unregister_subdev(sd);
+	kfree(to_state(sd));
+	return 0;
+}
+
+static const struct i2c_device_id adv7180_id[] = {
+	{DRIVER_NAME, 0},
+	{},
+};
+
+MODULE_DEVICE_TABLE(i2c, adv7180_id);
+
+static struct i2c_driver adv7180_driver = {
+	.driver = {
+		.owner	= THIS_MODULE,
+		.name	= DRIVER_NAME,
+	},
+	.probe		= adv7180_probe,
+	.remove		= adv7180_remove,
+	.id_table	= adv7180_id,
+};
+
+static __init int adv7180_init(void)
+{
+	return i2c_add_driver(&adv7180_driver);
+}
+
+static __exit void adv7180_exit(void)
+{
+	i2c_del_driver(&adv7180_driver);
+}
+
+module_init(adv7180_init);
+module_exit(adv7180_exit);
+
+MODULE_DESCRIPTION("Analog Devices ADV7180 video decoder driver");
+MODULE_AUTHOR("Mocean Laboratories");
+MODULE_LICENSE("GPL v2");
+
diff --git a/include/media/v4l2-chip-ident.h b/include/media/v4l2-chip-ident.h
index 94e908c..4e3eed9 100644
--- a/include/media/v4l2-chip-ident.h
+++ b/include/media/v4l2-chip-ident.h
@@ -135,6 +135,9 @@ enum {
 	/* module adv7175: just ident 7175 */
 	V4L2_IDENT_ADV7175 = 7175,

+	/* module adv7180: just ident 7180 */
+	V4L2_IDENT_ADV7180 = 7180,
+
 	/* module saa7185: just ident 7185 */
 	V4L2_IDENT_SAA7185 = 7185,

