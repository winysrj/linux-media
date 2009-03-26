Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.emlix.com ([193.175.82.87]:46433 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755634AbZCZOgI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Mar 2009 10:36:08 -0400
From: =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Chris Zankel <chris@zankel.net>, linux-media@vger.kernel.org,
	=?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
Subject: [patch 5/5] saa7121 driver for s6000 data port
Date: Thu, 26 Mar 2009 15:36:59 +0100
Message-Id: <1238078219-25904-5-git-send-email-dg@emlix.com>
In-Reply-To: <1238078219-25904-1-git-send-email-dg@emlix.com>
References: <1238078219-25904-1-git-send-email-dg@emlix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds a driver to support the saa7121 PAL/NTSC video encoder
in combination with the s6000 data port driver.

The chip is configured for embedded BT.656 syncs as this mode should
be supported on all devices.

The driver presents two outputs to applications and while it is true
that the device has these two outputs, both of them are always active.
The only difference on the "Y/C" output is that it disables the luma
notch filter.

Signed-off-by: Daniel Glöckner <dg@emlix.com>
---
 drivers/media/video/s6dp/Kconfig        |    7 +
 drivers/media/video/s6dp/Makefile       |    1 +
 drivers/media/video/s6dp/s6dp-saa7121.c |  478 +++++++++++++++++++++++++++++++
 3 files changed, 486 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/s6dp/s6dp-saa7121.c

diff --git a/drivers/media/video/s6dp/Kconfig b/drivers/media/video/s6dp/Kconfig
index 853e6b1..c95904c 100644
--- a/drivers/media/video/s6dp/Kconfig
+++ b/drivers/media/video/s6dp/Kconfig
@@ -20,3 +20,10 @@ config VIDEO_S6DP_MT9D131
 	default n
 	help
 	  Enables the MT9D131 camera driver.
+
+config VIDEO_S6DP_SAA7121
+	tristate "SAA7121 video encoder"
+	depends on VIDEO_S6000
+	default n
+	help
+	  Enables the SAA7121 video encoder driver.
diff --git a/drivers/media/video/s6dp/Makefile b/drivers/media/video/s6dp/Makefile
index af0bc0f..61d86c9 100644
--- a/drivers/media/video/s6dp/Makefile
+++ b/drivers/media/video/s6dp/Makefile
@@ -1,2 +1,3 @@
 obj-$(CONFIG_VIDEO_S6000) += s6dp.o
 obj-$(CONFIG_VIDEO_S6DP_MT9D131) += s6dp-mt9d131.o
+obj-$(CONFIG_VIDEO_S6DP_SAA7121) += s6dp-saa7121.o
diff --git a/drivers/media/video/s6dp/s6dp-saa7121.c b/drivers/media/video/s6dp/s6dp-saa7121.c
new file mode 100644
index 0000000..70799cd
--- /dev/null
+++ b/drivers/media/video/s6dp/s6dp-saa7121.c
@@ -0,0 +1,478 @@
+/*
+ * drivers/media/video/s6dp/s6dp-saa7121.c
+ *
+ * Description: Driver for SAA7121 chips hooked up to a S6000 family data port
+ *	(c) 2009 emlix GmbH <info@emlix.com>
+ *
+ * Author:	Daniel Gloeckner <dg@emlix.com>
+ */
+
+#include <media/s6dp-link.h>
+#include "s6dp.h"
+#include <linux/i2c.h>
+
+static const u8 initial_setup[][2] = {
+	{0x3a, 0x13}
+};
+
+static const u8 pal_values[][2] = {
+	{0x28, 33}, {0x29, 29}, {0x5a, 0x00}, {0x5b, 125},
+	{0x5c, 175}, {0x5d, 35}, {0x5e, 53}, {0x5f, 0x40+53},
+	{0x61, 0x06}, {0x62, 47}, {0x63, 0xcb}, {0x64, 0x8a},
+	{0x65, 0x09}, {0x66, 0x2a}, {0x6c, 0x05}, {0x6d, 0x20},
+	{0x6e, 0xa0}
+};
+
+static const u8 pal_nc_values[][2] = {
+	{0x28, 33}, {0x29, 37}, {0x5a, 0x00}, {0x5b, 125},
+	{0x5c, 175}, {0x5d, 35}, {0x5e, 53}, {0x5f, 0xc0+53},
+	{0x61, 0x06}, {0x62, 47}, {0x63, 0x46}, {0x64, 0x94},
+	{0x65, 0xf6}, {0x66, 0x21}, {0x6c, 0x05}, {0x6d, 0x20},
+	{0x6e, 0xa0}
+};
+
+static const u8 pal_m_values[][2] = {
+	{0x28, 25}, {0x29, 29}, {0x5a, 0x00}, {0x5b, 118},
+	{0x5c, 165}, {0x5d, 45}, {0x5e, 49}, {0x5f, 0xc0+59},
+	{0x61, 0x17}, {0x62, 45}, {0x63, 0xe3}, {0x64, 0xef},
+	{0x65, 0xe6}, {0x66, 0x21}, {0x6c, 0xf9}, {0x6d, 0x00},
+	{0x6e, 0xa0}
+};
+
+static const u8 ntsc_values[][2] = {
+	{0x28, 25}, {0x29, 29}, {0x5a, 0x88}, {0x5b, 118},
+	{0x5c, 165}, {0x5d, 42}, {0x5e, 46}, {0x5f, 0xc0+46},
+	{0x61, 0x15}, {0x62, 63}, {0x63, 0x1f}, {0x64, 0x7c},
+	{0x65, 0xf0}, {0x66, 0x21}, {0x6c, 0xf9}, {0x6d, 0x00},
+	{0x6e, 0x80}
+};
+
+static const u8 ntsc_jp_values[][2] = {
+	{0x28, 25}, {0x29, 29}, {0x5a, 0x88}, {0x5b, 118},
+	{0x5c, 165}, {0x5d, 19}, {0x5e, 46}, {0x5f, 0xc0+46},
+	{0x61, 0x05}, {0x62, 62}, {0x63, 0x1f}, {0x64, 0x7c},
+	{0x65, 0xf0}, {0x66, 0x21}, {0x6c, 0xf9}, {0x6d, 0x00},
+	{0x6e, 0x80}
+};
+
+struct saa7121 {
+	int std;
+	int yc;
+	struct v4l2_pix_format fmt;
+	struct v4l2_rect crop;
+	u8 regs[128];
+};
+
+static int saa7121_write_regs(struct i2c_client *client)
+{
+	struct saa7121 *me = i2c_get_clientdata(client);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(me->regs); i++) {
+		int ret = i2c_smbus_write_byte_data(client, i, me->regs[i]);
+		if (ret < 0)
+			return ret;
+	}
+	return 0;
+}
+
+static void saa7121_change_regs(struct saa7121 *me, const u8 (*regs)[2],
+				int num)
+{
+	int i;
+	for (i = 0; i < num; i++)
+		me->regs[regs[i][0]] = regs[i][1];
+}
+
+static const struct {
+	v4l2_std_id mask;
+	const char *name;
+	const u8 (*regs)[2];
+	int num;
+} standards[] = {
+	{
+		V4L2_STD_PAL | V4L2_STD_PAL_N,
+		"PAL",
+		pal_values,
+		ARRAY_SIZE(pal_values)
+	},
+	{
+		V4L2_STD_NTSC_M | V4L2_STD_NTSC_M_KR,
+		"NTSC",
+		ntsc_values,
+		ARRAY_SIZE(ntsc_values)
+	},
+	{
+		V4L2_STD_NTSC_M_JP,
+		"NTSC-JP",
+		ntsc_jp_values,
+		ARRAY_SIZE(ntsc_jp_values)
+	},
+	{
+		V4L2_STD_PAL_M,
+		"PAL-M",
+		pal_m_values,
+		ARRAY_SIZE(pal_nc_values)
+	},
+	{
+		V4L2_STD_PAL_Nc,
+		"PAL-Nc",
+		pal_nc_values,
+		ARRAY_SIZE(pal_nc_values)
+	},
+};
+
+static int saa7121_e_std(void *ctx, struct v4l2_standard *std)
+{
+	if (std->index >= ARRAY_SIZE(standards))
+		return -EINVAL;
+	std->id = standards[std->index].mask;
+	strcpy(std->name, standards[std->index].name);
+	if (std->id & V4L2_STD_625_50) {
+		std->frameperiod.numerator = 1;
+		std->frameperiod.denominator = 25;
+		std->framelines = 625;
+	} else  {
+		std->frameperiod.numerator = 1001;
+		std->frameperiod.denominator = 30000;
+		std->framelines = 525;
+	}
+	return 0;
+}
+
+static int saa7121_cropcap(void *ctx, struct v4l2_cropcap *cap)
+{
+	struct i2c_client *client = ctx;
+	struct saa7121 *me = i2c_get_clientdata(client);
+
+	if (standards[me->std].mask & V4L2_STD_625_50) {
+		cap->bounds.top = 23 * 2;
+		cap->bounds.left = 132;
+		cap->bounds.width = 720;
+		cap->bounds.height = 576;
+		cap->defrect.left = 140;
+		cap->defrect.top = 23 * 2;
+		cap->defrect.width = 702;
+		cap->defrect.height = 576;
+		cap->pixelaspect.numerator = 54;
+		cap->pixelaspect.denominator = 59;
+	} else {
+		cap->bounds.top = 20 * 2;
+		cap->bounds.left = 122;
+		cap->bounds.width = 720;
+		cap->bounds.height = 487;
+		cap->defrect.left = 130;
+		cap->defrect.top = 22 * 2;
+		cap->defrect.width = 704;
+		cap->defrect.height = 480;
+		cap->pixelaspect.numerator = 11;
+		cap->pixelaspect.denominator = 10;
+	}
+	return 0;
+}
+
+static int saa7121_s_crop(void *ctx, struct v4l2_crop *crop, int busy)
+{
+	struct i2c_client *client = ctx;
+	struct saa7121 *me = i2c_get_clientdata(client);
+	struct v4l2_cropcap cap;
+
+	if (busy)
+		return -EBUSY;
+
+	saa7121_cropcap(ctx, &cap);
+	me->crop = crop->c;
+
+	if (me->crop.width > cap.bounds.width)
+		me->crop.width = cap.bounds.width;
+	me->crop.left += me->crop.width & 1;
+	me->crop.width &= ~1;
+	if (me->crop.height > cap.bounds.height)
+		me->crop.height = cap.bounds.height;
+	if (me->crop.left < cap.bounds.left)
+		me->crop.left = cap.bounds.left;
+	if (me->crop.left > cap.bounds.left + cap.bounds.width - me->crop.width)
+		me->crop.left = cap.bounds.left + cap.bounds.width
+				 - me->crop.width;
+	me->crop.left &= ~1;
+	if (me->crop.top < cap.bounds.top)
+		me->crop.top = cap.bounds.top;
+	if (me->crop.top > cap.bounds.top + cap.bounds.height - me->crop.height)
+		me->crop.top = cap.bounds.top + cap.bounds.height
+				- me->crop.height;
+	me->crop.top &= ~1;
+	me->fmt.width = me->crop.width;
+	me->fmt.height = me->crop.height;
+	return 0;
+}
+
+static int saa7121_g_crop(void *ctx, struct v4l2_crop *crop)
+{
+	struct i2c_client *client = ctx;
+	struct saa7121 *me = i2c_get_clientdata(client);
+
+	crop->c = me->crop;
+	return 0;
+}
+
+static int saa7121_s_fmt(void *ctx, int try_fmt, struct v4l2_pix_format *fmt,
+			 int busy)
+{
+	struct i2c_client *client = ctx;
+	struct saa7121 *me = i2c_get_clientdata(client);
+	struct v4l2_cropcap cap;
+
+	if (!try_fmt && busy)
+		return -EBUSY;
+
+	saa7121_cropcap(ctx, &cap);
+	fmt->pixelformat = V4L2_PIX_FMT_UYVY;
+	fmt->field = V4L2_FIELD_ALTERNATE;
+
+	if (standards[me->std].mask & V4L2_STD_625_50)
+		fmt->colorspace = V4L2_COLORSPACE_470_SYSTEM_BG;
+	else if (standards[me->std].mask == V4L2_STD_PAL_M)
+		fmt->colorspace = V4L2_COLORSPACE_470_SYSTEM_M;
+	else
+		fmt->colorspace = V4L2_COLORSPACE_SMPTE170M;
+
+	fmt->width &= ~1;
+	if (fmt->width > cap.bounds.width)
+		fmt->width = cap.bounds.width;
+	if (fmt->height > cap.bounds.height)
+		fmt->height = cap.bounds.height;
+
+	if (!try_fmt) {
+		me->fmt = *fmt;
+		me->crop.width = fmt->width;
+		me->crop.height = fmt->height;
+		if (me->crop.left > cap.bounds.left + cap.bounds.width
+				     - fmt->width) {
+			me->crop.left = cap.bounds.left + cap.bounds.width
+					 - fmt->width;
+			me->crop.left &= ~1;
+		}
+		if (me->crop.top > cap.bounds.top + cap.bounds.height
+				    - fmt->height) {
+			me->crop.top = cap.bounds.top + cap.bounds.height
+					- fmt->height;
+			me->crop.top &= ~1;
+		}
+	}
+	return 0;
+}
+
+static int saa7121_g_fmt(void *ctx, struct v4l2_pix_format *fmt)
+{
+	struct i2c_client *client = ctx;
+	struct saa7121 *me = i2c_get_clientdata(client);
+	*fmt = me->fmt;
+	return 0;
+}
+
+static void saa7121_g_mode(void *ctx, struct s6dp_mode *mode)
+{
+	struct i2c_client *client = ctx;
+	struct saa7121 *me = i2c_get_clientdata(client);
+	struct v4l2_cropcap cap;
+
+	saa7121_cropcap(ctx, &cap);
+	mode->type = S6_DP_VIDEO_CFG_MODE_422_SERIAL;
+	mode->progressive = 0;
+	mode->embedded_sync = 1;
+	mode->relaxed_framing = 0;
+	mode->ten_bit = 0;
+	mode->line_and_crc = 0;
+	mode->micron_mode = 0;
+	if (standards[me->std].mask & V4L2_STD_625_50) {
+		mode->pixel_total = 864;
+		mode->framelines = 625;
+		mode->odd_vsync_offset = 623;
+		mode->odd_vsync_len = 24;
+		mode->odd_first = 22;
+		mode->odd_total = 312;
+		mode->even_vsync_offset = 310;
+		mode->even_vsync_len = 25;
+		mode->even_first = 335;
+		mode->hsync_offset = 0;
+		mode->hsync_len = 4;
+	} else {
+		mode->pixel_total = 858;
+		mode->framelines = 525;
+		mode->odd_vsync_offset = 522;
+		mode->odd_vsync_len = 19;
+		mode->odd_first = 16;
+		mode->odd_total = 262;
+		mode->even_vsync_offset = 260;
+		mode->even_vsync_len = 19;
+		mode->even_first = 279;
+		mode->hsync_offset = 0;
+		mode->hsync_len = 4;
+	}
+	mode->even_active = me->crop.height / 2;
+	mode->odd_active = me->crop.height - mode->even_active;
+	mode->odd_first += (me->crop.top - cap.bounds.top) / 2;
+	mode->even_first += (me->crop.top - cap.bounds.top) / 2;
+	mode->pixel_active = me->crop.width;
+	mode->pixel_offset = me->crop.left - cap.bounds.left;
+	mode->pixel_padding = 720 - mode->pixel_active - mode->pixel_offset;
+}
+
+static void saa7121_reconfigure(struct i2c_client *client)
+{
+	struct saa7121 *me = i2c_get_clientdata(client);
+
+	saa7121_change_regs(me, standards[me->std].regs,
+			    standards[me->std].num);
+	if (me->yc)
+		me->regs[0x5f] &= 0x3f;
+
+	saa7121_write_regs(client);
+}
+
+static int saa7121_s_std(void *ctx, v4l2_std_id *mask, int busy)
+{
+	struct i2c_client *client = ctx;
+	struct saa7121 *me = i2c_get_clientdata(client);
+	int i;
+
+	if (busy && !(standards[me->std].mask & V4L2_STD_625_50)
+		     == !(*mask & V4L2_STD_625_50))
+		return -EBUSY;
+
+	for (i = 0; i < ARRAY_SIZE(standards); i++) {
+		if (standards[i].mask & *mask) {
+			me->std = i;
+			saa7121_reconfigure(client);
+			*mask = standards[i].mask;
+			saa7121_s_fmt(ctx, 0, &me->fmt, 0);
+			return 0;
+		}
+	}
+	return -EINVAL;
+}
+
+static int saa7121_e_outp(void *ctx, struct v4l2_output *outp)
+{
+	int i;
+	if (outp->index > 1)
+		return -EINVAL;
+
+	outp->type = V4L2_OUTPUT_TYPE_ANALOG;
+	for (i = 0; i < ARRAY_SIZE(standards); i++)
+		outp->std |= standards[i].mask;
+
+	strcpy(outp->name, outp->index ? "Y/C" : "CVBS");
+	return 0;
+}
+
+static int saa7121_s_outp(void *ctx, unsigned int nr, int busy)
+{
+	struct i2c_client *client = ctx;
+	struct saa7121 *me = i2c_get_clientdata(client);
+
+	if (nr > 1)
+		return -EINVAL;
+
+	/*
+	 * both outputs are always active
+	 * we just disable the cross color filter for Y/C
+	 */
+	me->yc = nr;
+	saa7121_reconfigure(client);
+	return 0;
+}
+
+static int saa7121_probe(struct i2c_client *client,
+			 const struct i2c_device_id *id)
+{
+	struct saa7121 *me;
+	struct s6dp_link *link;
+	s32 val;
+
+	if (!client->dev.platform_data)
+		return -EINVAL;
+	link = client->dev.platform_data;
+
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_READ_BYTE
+					| I2C_FUNC_SMBUS_WRITE_BYTE_DATA))
+		return -ENODEV;
+
+	val = i2c_smbus_read_byte(client);
+	if (val < 0) {
+		printk(KERN_ERR "saa7121: can't read status byte\n");
+		return -EIO;
+	}
+	if ((val & 0xE0) != 0x20) {
+		printk(KERN_ERR "saa7121: unsupported chip version %i"
+				" (status = 0x%02x)\n", val >> 5, val);
+		return -ENODEV;
+	}
+	me = kzalloc(sizeof(*me), GFP_KERNEL);
+	if (!me)
+		return -ENOMEM;
+	me->std = V4L2_STD_PAL;
+	i2c_set_clientdata(client, me);
+
+	saa7121_change_regs(me, initial_setup, ARRAY_SIZE(initial_setup));
+	saa7121_change_regs(me, pal_values, ARRAY_SIZE(pal_values));
+	if (saa7121_write_regs(client) < 0) {
+		printk(KERN_ERR "saa7121: can't write registers\n");
+		kfree(me);
+		return -EIO;
+	}
+
+	link->g_mode = saa7121_g_mode;
+	link->e_std = saa7121_e_std;
+	link->s_std = saa7121_s_std;
+	link->s_fmt = saa7121_s_fmt;
+	link->g_fmt = saa7121_g_fmt;
+	link->cropcap = saa7121_cropcap;
+	link->s_crop = saa7121_s_crop;
+	link->g_crop = saa7121_g_crop;
+	link->dir.egress.e_outp = saa7121_e_outp;
+	link->dir.egress.s_outp = saa7121_s_outp;
+	link->context = client;
+	printk(KERN_INFO "saa7121 probed successfully\n");
+	return 0;
+}
+
+static int saa7121_remove(struct i2c_client *client)
+{
+	struct saa7121_data *data;
+	data = i2c_get_clientdata(client);
+	i2c_set_clientdata(client, NULL);
+	kfree(data);
+	return 0;
+}
+
+static const struct i2c_device_id saa7121_id[] = {
+	{ "saa7121", 0 },
+	{ }
+};
+
+static struct i2c_driver saa7121_driver = {
+	.driver = {
+		.name   = "s6dp-saa7121",
+	},
+	.probe          = saa7121_probe,
+	.remove         = saa7121_remove,
+	.id_table	= saa7121_id,
+};
+
+static int __init saa7121_init(void)
+{
+	return i2c_add_driver(&saa7121_driver);
+}
+
+static void __exit saa7121_exit(void)
+{
+	i2c_del_driver(&saa7121_driver);
+}
+
+MODULE_AUTHOR("Daniel Gloeckner <dg@emlix.com>");
+MODULE_DESCRIPTION("SAA7121 driver");
+MODULE_LICENSE("GPL");
+
+module_init(saa7121_init);
+module_exit(saa7121_exit);
-- 
1.6.2.107.ge47ee

