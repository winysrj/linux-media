Return-path: <linux-media-owner@vger.kernel.org>
Received: from av9-1-sn2.hy.skanova.net ([81.228.8.179]:51509 "EHLO
	av9-1-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756487AbZIVNOj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2009 09:14:39 -0400
Message-ID: <4AB8CDBF.8040003@mocean-labs.com>
Date: Tue, 22 Sep 2009 15:14:39 +0200
From: =?ISO-8859-1?Q?Richard_R=F6jfors?=
	<richard.rojfors@mocean-labs.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] radio: Add support for TEF6862 tuner
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support for TEF6862 Car Radio Enhanced Selectivity Tuner.

It's implemented as a subdev, supporting checking signal strength
and setting and getting frequency.

Signed-off-by: Richard Röjfors <richard.rojfors@mocean-labs.com>
---
diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
index 3315cac..c87a2d9 100644
--- a/drivers/media/radio/Kconfig
+++ b/drivers/media/radio/Kconfig
@@ -406,4 +406,16 @@ config RADIO_TEA5764_XTAL
 	  Say Y here if TEA5764 have a 32768 Hz crystal in circuit, say N
 	  here if TEA5764 reference frequency is connected in FREQIN.

+config RADIO_TEF6862
+	tristate "TEF6862 Car Radio Enhanced Selectivity Tuner"
+	depends on I2C && VIDEO_V4L2
+	---help---
+	  Say Y here if you want to use the TEF6862 Car Radio Enhanced
+	  Selectivity Tuner, found for instance on the Russellville development
+	  board. On the russellville the device is connected to internal
+	  timberdale I2C bus.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called TEF6862.
+
 endif # RADIO_ADAPTERS
diff --git a/drivers/media/radio/Makefile b/drivers/media/radio/Makefile
index 0f2b35b..8a76041 100644
--- a/drivers/media/radio/Makefile
+++ b/drivers/media/radio/Makefile
@@ -20,5 +20,6 @@ obj-$(CONFIG_USB_DSBR) += dsbr100.o
 obj-$(CONFIG_USB_SI470X) += radio-si470x.o
 obj-$(CONFIG_USB_MR800) += radio-mr800.o
 obj-$(CONFIG_RADIO_TEA5764) += radio-tea5764.o
+obj-$(CONFIG_RADIO_TEF6862) += tef6862.o

 EXTRA_CFLAGS += -Isound
diff --git a/drivers/media/radio/tef6862.c b/drivers/media/radio/tef6862.c
new file mode 100644
index 0000000..6e607ff
--- /dev/null
+++ b/drivers/media/radio/tef6862.c
@@ -0,0 +1,232 @@
+/*
+ * tef6862.c Philips TEF6862 Car Radio Enhanced Selectivity Tuner
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
+#include <media/v4l2-device.h>
+#include <media/v4l2-chip-ident.h>
+
+#define DRIVER_NAME "tef6862"
+
+#define FREQ_MUL 16000
+
+#define TEF6862_LO_FREQ (875 * FREQ_MUL / 10)
+#define TEF6862_HI_FREQ (108 * FREQ_MUL)
+
+/* Write mode sub addresses */
+#define WM_SUB_BANDWIDTH	0x0
+#define WM_SUB_PLLM		0x1
+#define WM_SUB_PLLL		0x2
+#define WM_SUB_DAA		0x3
+#define WM_SUB_AGC		0x4
+#define WM_SUB_BAND		0x5
+#define WM_SUB_CONTROL		0x6
+#define WM_SUB_LEVEL		0x7
+#define WM_SUB_IFCF		0x8
+#define WM_SUB_IFCAP		0x9
+#define WM_SUB_ACD		0xA
+#define WM_SUB_TEST		0xF
+
+/* Different modes of the MSA register */
+#define MODE_BUFFER		0x0
+#define MODE_PRESET		0x1
+#define MODE_SEARCH		0x2
+#define MODE_AF_UPDATE		0x3
+#define MODE_JUMP		0x4
+#define MODE_CHECK		0x5
+#define MODE_LOAD		0x6
+#define MODE_END		0x7
+#define MODE_SHIFT		5
+
+struct tef6862_state {
+	struct v4l2_subdev sd;
+	unsigned long freq;
+};
+
+static inline struct tef6862_state *to_state(struct v4l2_subdev *sd)
+{
+	return container_of(sd, struct tef6862_state, sd);
+}
+
+static u16 tef6862_sigstr(struct i2c_client *client)
+{
+	u8 buf[4];
+	int err = i2c_master_recv(client, buf, sizeof(buf));
+	if (err == sizeof(buf))
+		return buf[3] << 8;
+	return 0;
+}
+
+static int tef6862_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *v)
+{
+	if (v->index > 0)
+		return -EINVAL;
+
+	/* only support FM for now */
+	strlcpy(v->name, "FM", sizeof(v->name));
+	v->type = V4L2_TUNER_RADIO;
+	v->rangelow = TEF6862_LO_FREQ;
+	v->rangehigh = TEF6862_HI_FREQ;
+	v->rxsubchans = V4L2_TUNER_SUB_MONO;
+	v->capability = V4L2_TUNER_CAP_LOW;
+	v->audmode = V4L2_TUNER_MODE_STEREO;
+	v->signal = tef6862_sigstr(v4l2_get_subdevdata(sd));
+
+	return 0;
+}
+
+static int tef6862_s_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *v)
+{
+	return v->index ? -EINVAL : 0;
+}
+
+static int tef6862_s_frequency(struct v4l2_subdev *sd, struct v4l2_frequency *f)
+{
+	struct tef6862_state *state = to_state(sd);
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	u16 pll;
+	u8 i2cmsg[3];
+	int err;
+
+	if (f->tuner != 0)
+		return -EINVAL;
+
+	pll = 1964 + ((f->frequency - TEF6862_LO_FREQ) * 20) / FREQ_MUL;
+	i2cmsg[0] = (MODE_PRESET << MODE_SHIFT) | WM_SUB_PLLM;
+	i2cmsg[1] = (pll >> 8) & 0xff;
+	i2cmsg[2] = pll & 0xff;
+
+	err = i2c_master_send(client, i2cmsg, sizeof(i2cmsg));
+	if (!err)
+		state->freq = f->frequency;
+	return err;
+}
+
+static int tef6862_g_frequency(struct v4l2_subdev *sd, struct v4l2_frequency *f)
+{
+	struct tef6862_state *state = to_state(sd);
+
+	if (f->tuner != 0)
+		return -EINVAL;
+	f->type = V4L2_TUNER_RADIO;
+	f->frequency = state->freq;
+	return 0;
+}
+
+static int tef6862_g_chip_ident(struct v4l2_subdev *sd,
+	struct v4l2_dbg_chip_ident *chip)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+	return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_TEF6862, 0);
+}
+
+static const struct v4l2_subdev_tuner_ops tef6862_tuner_ops = {
+	.g_tuner = tef6862_g_tuner,
+	.s_tuner = tef6862_s_tuner,
+	.s_frequency = tef6862_s_frequency,
+	.g_frequency = tef6862_g_frequency,
+};
+
+static const struct v4l2_subdev_core_ops tef6862_core_ops = {
+	.g_chip_ident = tef6862_g_chip_ident,
+};
+
+static const struct v4l2_subdev_ops tef6862_ops = {
+	.core = &tef6862_core_ops,
+	.tuner = &tef6862_tuner_ops,
+};
+
+/*
+ * Generic i2c probe
+ * concerning the addresses: i2c wants 7 bit (without the r/w bit), so '>>1'
+ */
+
+static int __devinit tef6862_probe(struct i2c_client *client,
+			const struct i2c_device_id *id)
+{
+	struct tef6862_state *state;
+	struct v4l2_subdev *sd;
+
+	/* Check if the adapter supports the needed features */
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
+		return -EIO;
+
+	v4l_info(client, "chip found @ 0x%02x (%s)\n",
+			client->addr << 1, client->adapter->name);
+
+	state = kmalloc(sizeof(struct tef6862_state), GFP_KERNEL);
+	if (state == NULL)
+		return -ENOMEM;
+	state->freq = TEF6862_LO_FREQ;
+
+	sd = &state->sd;
+	v4l2_i2c_subdev_init(sd, client, &tef6862_ops);
+
+	return 0;
+}
+
+static int __devexit tef6862_remove(struct i2c_client *client)
+{
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+
+	v4l2_device_unregister_subdev(sd);
+	kfree(to_state(sd));
+	return 0;
+}
+
+static const struct i2c_device_id tef6862_id[] = {
+	{DRIVER_NAME, 0},
+	{},
+};
+
+MODULE_DEVICE_TABLE(i2c, tef6862_id);
+
+static struct i2c_driver tef6862_driver = {
+	.driver = {
+		.owner	= THIS_MODULE,
+		.name	= DRIVER_NAME,
+	},
+	.probe		= tef6862_probe,
+	.remove		= tef6862_remove,
+	.id_table	= tef6862_id,
+};
+
+static __init int tef6862_init(void)
+{
+	return i2c_add_driver(&tef6862_driver);
+}
+
+static __exit void tef6862_exit(void)
+{
+	i2c_del_driver(&tef6862_driver);
+}
+
+module_init(tef6862_init);
+module_exit(tef6862_exit);
+
+MODULE_DESCRIPTION("TEF6862 Car Radio Enhanced Selectivity Tuner");
+MODULE_AUTHOR("Mocean Laboratories");
+MODULE_LICENSE("GPL v2");
+
diff --git a/include/media/v4l2-chip-ident.h b/include/media/v4l2-chip-ident.h
index 94e908c..1781d20 100644
--- a/include/media/v4l2-chip-ident.h
+++ b/include/media/v4l2-chip-ident.h
@@ -129,6 +129,9 @@ enum {
 	V4L2_IDENT_SAA6752HS = 6752,
 	V4L2_IDENT_SAA6752HS_AC3 = 6753,

+	/* modules tef6862: just ident 6862 */
+	V4L2_IDENT_TEF6862 = 6862,
+
 	/* module adv7170: just ident 7170 */
 	V4L2_IDENT_ADV7170 = 7170,

