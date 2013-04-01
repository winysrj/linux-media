Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-da0-f43.google.com ([209.85.210.43]:37163 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756470Ab3DAAzi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Mar 2013 20:55:38 -0400
From: John McMaster <johndmcmaster@gmail.com>
To: hdegoede@redhat.com, mchehab@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	John McMaster <johndmcmaster@gmail.com>
Subject: [PATCH] [media] gspca_touptek: Add support for ToupTek UCMOS series USB cameras
Date: Sun, 31 Mar 2013 17:53:53 -0700
Message-Id: <1364777633-10769-1-git-send-email-johndmcmaster@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds support for AmScope MU800 / ToupTek UCMOS08000KPB USB microscope camera.

Signed-off-by: John McMaster <johndmcmaster@gmail.com>
---
 drivers/media/usb/gspca/Kconfig   |   10 +
 drivers/media/usb/gspca/Makefile  |    2 +
 drivers/media/usb/gspca/touptek.c |  857 +++++++++++++++++++++++++++++++++++++
 3 files changed, 869 insertions(+)
 create mode 100644 drivers/media/usb/gspca/touptek.c

diff --git a/drivers/media/usb/gspca/Kconfig b/drivers/media/usb/gspca/Kconfig
index 6345f93..113f181 100644
--- a/drivers/media/usb/gspca/Kconfig
+++ b/drivers/media/usb/gspca/Kconfig
@@ -376,6 +376,16 @@ config USB_GSPCA_TOPRO
 	  To compile this driver as a module, choose M here: the
 	  module will be called gspca_topro.
 
+config USB_GSPCA_TOUPTEK
+	tristate "Touptek USB Camera Driver"
+	depends on VIDEO_V4L2 && USB_GSPCA
+	help
+	  Say Y here if you want support for cameras based on the ToupTek UCMOS
+	  / AmScope MU series camera.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called gspca_touptek.
+
 config USB_GSPCA_TV8532
 	tristate "TV8532 USB Camera Driver"
 	depends on VIDEO_V4L2 && USB_GSPCA
diff --git a/drivers/media/usb/gspca/Makefile b/drivers/media/usb/gspca/Makefile
index c901da0..5f18e7f 100644
--- a/drivers/media/usb/gspca/Makefile
+++ b/drivers/media/usb/gspca/Makefile
@@ -37,6 +37,7 @@ obj-$(CONFIG_USB_GSPCA_STK014)   += gspca_stk014.o
 obj-$(CONFIG_USB_GSPCA_STV0680)  += gspca_stv0680.o
 obj-$(CONFIG_USB_GSPCA_T613)     += gspca_t613.o
 obj-$(CONFIG_USB_GSPCA_TOPRO)    += gspca_topro.o
+obj-$(CONFIG_USB_GSPCA_TOUPTEK)  += gspca_touptek.o
 obj-$(CONFIG_USB_GSPCA_TV8532)   += gspca_tv8532.o
 obj-$(CONFIG_USB_GSPCA_VC032X)   += gspca_vc032x.o
 obj-$(CONFIG_USB_GSPCA_VICAM)    += gspca_vicam.o
@@ -82,6 +83,7 @@ gspca_stv0680-objs  := stv0680.o
 gspca_sunplus-objs  := sunplus.o
 gspca_t613-objs     := t613.o
 gspca_topro-objs    := topro.o
+gspca_touptek-objs  := touptek.o
 gspca_tv8532-objs   := tv8532.o
 gspca_vc032x-objs   := vc032x.o
 gspca_vicam-objs    := vicam.o
diff --git a/drivers/media/usb/gspca/touptek.c b/drivers/media/usb/gspca/touptek.c
new file mode 100644
index 0000000..9ce31f0
--- /dev/null
+++ b/drivers/media/usb/gspca/touptek.c
@@ -0,0 +1,857 @@
+/*
+ * ToupTek UCMOS / AmScope MU series camera driver
+ * TODO: contrast with ScopeTek / AmScope MDC cameras
+ *
+ * Copyright (C) 2012 John McMaster <JohnDMcMaster@gmail.com>
+ *
+ * Special thanks to Bushing for helping with the decrypt algorithm and
+ * Sean O'Sullivan / the Rensselaer Center for Open Source
+ * Software (RCOS) for helping me learn kernel development
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+
+#include "gspca.h"
+
+#define MODULE_NAME "touptek"
+
+MODULE_AUTHOR("John McMaster");
+MODULE_DESCRIPTION("ToupTek UCMOS / Amscope MU microscope camera driver");
+MODULE_LICENSE("GPL");
+
+/*
+Register value is linear with exposure time
+Exposure (sec), E (reg)
+0.000400, 0x0002
+0.001000, 0x0005
+0.005000, 0x0019
+0.020000, 0x0064
+0.080000, 0x0190
+0.400000, 0x07D0
+1.000000, 0x1388
+2.000000, 0x2710
+*/
+#define INDEX_EXPOSURE		0x3012
+#define INDEX_WIDTH		0x034C
+#define INDEX_HEIGHT		0x034E
+
+/*
+Gain does not vary with resolution (checked 640x480 vs 1600x1200)
+Range 0x1000 (nothing) to 0x11FF (highest)
+However, there appear to be gaps
+
+Suspect three gain stages
+0x1000: master channel enable bit
+0x007F: low gain bits
+0x0080: medium gain bit
+0x0100: high gain bit
+
+gain = enable * (1 + regH) * (1 + regM) * z * regL
+
+zR = 0.0069605943152454778
+	about 3/431 = 0.0069605568445475635
+zB = 0.0095695970695970703
+	about 6/627 = 0.0095693779904306216
+zG = 0.010889328063241107
+	about 6/551 = 0.010889292196007259
+about 10 bits for constant + 7 bits for value => at least 17 bit intermediate
+with 32 bit ints should be fine for overflow etc
+Essentially gains are in range 0-0x001FF
+
+However, V4L expects a main gain channel + R and B balance
+To keep things simple for now saturate the values of balance is too high/low
+This isn't really ideal but easy way to fit the Linux model
+
+Raw data:
+Gain,   GTOP,   B,	  R,	  GBOT
+1.00,   0x105C, 0x1068, 0x10C8, 0x105C
+1.20,   0x106E, 0x107E, 0x10D6, 0x106E
+1.40,   0x10C0, 0x10CA, 0x10E5, 0x10C0
+1.60,   0x10C9, 0x10D4, 0x10F3, 0x10C9
+1.80,   0x10D2, 0x10DE, 0x11C1, 0x10D2
+2.00,   0x10DC, 0x10E9, 0x11C8, 0x10DC
+2.20,   0x10E5, 0x10F3, 0x11CF, 0x10E5
+2.40,   0x10EE, 0x10FE, 0x11D7, 0x10EE
+2.60,   0x10F7, 0x11C4, 0x11DE, 0x10F7
+2.80,   0x11C0, 0x11CA, 0x11E5, 0x11C0
+3.00,   0x11C5, 0x11CF, 0x11ED, 0x11C5
+
+Converted using gain model turns out to be quite linear:
+Gain, GTOP, B, R, GBOT
+1.00, 92, 104, 144, 92
+1.20, 110, 126, 172, 110
+1.40, 128, 148, 202, 128
+1.60, 146, 168, 230, 146
+1.80, 164, 188, 260, 164
+2.00, 184, 210, 288, 184
+2.20, 202, 230, 316, 202
+2.40, 220, 252, 348, 220
+2.60, 238, 272, 376, 238
+2.80, 256, 296, 404, 256
+3.00, 276, 316, 436, 276
+*/
+#define GAIN_BASE		0x1000
+/*
+Maximum gain is 0x7FF * 2 * 2 => 0x1FFC (8188)
+or about 13 effective bits of gain
+The highest the commercial driver goes in my setup 436
+However, because could potentially damage circuits
+limit the gain until have a reason to go higher
+*/
+#define GAIN_MAX		511
+#define BAL_MAX			511
+#define INDEX_GAIN_GTOP		0x3056
+#define INDEX_GAIN_B		0x3058
+#define INDEX_GAIN_R		0x305A
+#define INDEX_GAIN_GBOT		0x305C
+
+#define EXPOSURE_DEFAULT	350
+/*
+Gain implementation
+Goal: simple conversion for default gain at 1.00
+Want to do something similar to mt9v011.c's set_balance
+Problem: can lead to gains higher than possible
+When this happens the gain is clipped and a debug warning is emitted
+
+green_gain = sd->global_gain
+blue_gain = sd->global_gain +
+	((uint32_t)sd->global_gain) * sd->blue_bal / GAIN_MAX;
+red_gain = sd->global_gain +
+	((uint32_t)sd->global_gain) * sd->blue_bal / GAIN_MAX;
+
+Want initial gain of 1.4 (since it works well for me ;) ):
+-G: 128 => global_gain = 128
+-B: 148 => blue_bal = 80
+	148 = 128 + 128 * blue_bal / 511
+-R: 202 => red_bal = 295
+	202 = 128 + 128 * red_bal / 511
+*/
+#define GAIN_DEFAULT 128
+#define BLUE_DEFAULT 80
+#define RED_DEFAULT 295
+
+/* specific webcam descriptor */
+struct sd {
+	struct gspca_dev gspca_dev;	/* !! must be the first item */
+	/* How many bytes this frame */
+	unsigned int this_f;
+
+	/*
+	Device has separate gains for each Bayer quadrant
+	V4L supports master gain which is referenced to G1/G2 and supplies
+	individual balance controls for R/B
+	*/
+	u16 global_gain, red_bal, blue_bal;
+	/* In ms */
+	unsigned int exposure;
+};
+
+/* Used to simplify reg write error handling */
+struct cmd {
+	u16 value;
+	u16 index;
+};
+
+static const struct v4l2_pix_format vga_mode[] = {
+	{800, 600,
+		V4L2_PIX_FMT_SGRBG8,
+		V4L2_FIELD_NONE,
+		.bytesperline = 800,
+		.sizeimage = 800 * 600,
+		.colorspace = V4L2_COLORSPACE_SRGB},
+	{1600, 1200,
+		V4L2_PIX_FMT_SGRBG8,
+		V4L2_FIELD_NONE,
+		.bytesperline = 1600,
+		.sizeimage = 1600 * 1200,
+		.colorspace = V4L2_COLORSPACE_SRGB},
+	{3264, 2448,
+		V4L2_PIX_FMT_SGRBG8,
+		V4L2_FIELD_NONE,
+		.bytesperline = 3264,
+		.sizeimage = 3264 * 2448,
+		.colorspace = V4L2_COLORSPACE_SRGB},
+};
+
+/*
+As theres no (known) frame sync, the only way to keep synced is to try hard
+to never miss any packets
+*/
+#if MAX_NURBS < 4
+#error "Not enough URBs in the gspca table"
+#endif
+
+static int val_reply(const char *reply, int rc)
+{
+	if (rc < 0) {
+		pr_warn("reply has error %d", rc);
+		return -EIO;
+	}
+	if (rc != 1) {
+		pr_warn("Bad reply size %d", rc);
+		return -EIO;
+	}
+	if (reply[0] != 0x08) {
+		pr_warn("Bad reply 0x%02X", reply[0]);
+		return -EIO;
+	}
+	return 0;
+}
+
+static int reg_w(struct gspca_dev *gspca_dev, u16 value, u16 index)
+{
+	char buff[1];
+	int rc;
+
+	pr_devel("bReq=0x0B, bReqT=0xC0, wVal=0x%04X, wInd=0x%04X",
+		value, index);
+	rc = usb_control_msg(gspca_dev->dev, usb_rcvctrlpipe(gspca_dev->dev, 0),
+		0x0B, 0xC0, value, index, buff, 1, 500);
+	pr_devel("rc=%d, ret={0x%02X}", rc, buff[0]);
+	if (rc < 0) {
+		pr_warn("Failed reg_w(0x0B, 0xC0, 0x%04X, 0x%04X) w/ rc %d",
+			value, index, rc);
+		return rc;
+	}
+	if (val_reply(buff, rc)) {
+		pr_warn("Bad reply to reg_w(0x0B, 0xC0, 0x%04X, 0x%04X\n",
+			value, index);
+		return -EIO;
+	}
+	return 0;
+}
+
+static int reg_w_buf(struct gspca_dev *gspca_dev,
+		const struct cmd *p, int l)
+{
+	do {
+		int rc = reg_w(gspca_dev, p->value, p->index);
+
+		if (rc < 0)
+			return rc;
+		p++;
+	} while (--l > 0);
+	return 0;
+}
+
+static int sd_getexposure(struct gspca_dev *gspca_dev, s32 *val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	*val = sd->exposure;
+	return 0;
+}
+
+static int set_exposure(struct gspca_dev *gspca_dev)
+{
+	int rc;
+	struct sd *sd = container_of(gspca_dev, struct sd, gspca_dev);
+	uint16_t value;
+	unsigned int w = gspca_dev->cam.cam_mode->width;
+
+	if (w == 800)
+		value = sd->exposure * 5;
+	else if (w == 1600)
+		value = sd->exposure * 3;
+	else if (w == 3264)
+		value = sd->exposure * 3 / 2;
+	else {
+		pr_devel("Invalid width %u", w);
+		return -EINVAL;
+	}
+	pr_devel("exposure: 0x%04X", value);
+	/* Wonder if theres a good reason for sending it twice */
+	rc = reg_w(gspca_dev, value, INDEX_EXPOSURE);
+	if (rc)
+		return rc;
+	rc = reg_w(gspca_dev, value, INDEX_EXPOSURE);
+	if (rc)
+		return rc;
+
+	return 0;
+}
+
+static int sd_setexposure(struct gspca_dev *gspca_dev, s32 val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	sd->exposure = val;
+	if (gspca_dev->streaming)
+		return set_exposure(gspca_dev);
+	return 0;
+}
+
+
+static int gainify(int in)
+{
+	/*
+	TODO: check if there are any issues with corner cases
+	0x000 (0):0x07F (127): regL
+	0x080 (128) - 0x0FF (255): regM, regL
+	0x100 (256) - max: regH, regM, regL
+	*/
+	if (in <= 0x7F)
+		return 0x1000 | in;
+	else if (in <= 0xFF)
+		return 0x1080 | in / 2;
+	else
+		return 0x1180 | in / 4;
+}
+
+static int set_gain(struct gspca_dev *gspca_dev, int set)
+{
+	struct sd *sd = container_of(gspca_dev, struct sd, gspca_dev);
+	u16 green_gain, blue_gain, red_gain;
+	int rc;
+
+	green_gain = gainify(sd->global_gain);
+	pr_devel("gain G1/G2 (0x%04X): 0x%04X (src 0x%04X, def: 0x%04X)",
+		 INDEX_GAIN_GTOP,
+		 green_gain, sd->global_gain, GAIN_DEFAULT);
+
+	blue_gain = sd->global_gain +
+		((uint32_t)sd->global_gain) * sd->blue_bal / GAIN_MAX;
+	if (blue_gain > GAIN_MAX) {
+		pr_devel("Truncating blue 0x%04X w/ value 0x%04X",
+			 GAIN_MAX, blue_gain);
+		blue_gain = GAIN_MAX;
+	}
+	blue_gain = gainify(blue_gain);
+	pr_devel("gain B (0x%04X): 0x%04X w/ source 0x%04X, default 0x%04X",
+		 INDEX_GAIN_B, blue_gain, sd->blue_bal, BLUE_DEFAULT);
+
+	red_gain = sd->global_gain +
+		((uint32_t)sd->global_gain) * sd->red_bal / GAIN_MAX;
+	if (red_gain > GAIN_MAX) {
+		pr_devel("Truncating gain 0x%04X w/ value 0x%04X",
+			 GAIN_MAX, red_gain);
+		red_gain = GAIN_MAX;
+	}
+	red_gain = gainify(red_gain);
+	pr_devel("gain R (0x%04X): 0x%04X w / source 0x%04X, default 0x%04X",
+		 INDEX_GAIN_R, red_gain, sd->red_bal, RED_DEFAULT);
+
+	if (set) {
+		rc = reg_w(gspca_dev, green_gain, INDEX_GAIN_GTOP);
+		if (rc)
+			return rc;
+		rc = reg_w(gspca_dev, blue_gain, INDEX_GAIN_B);
+		if (rc)
+			return rc;
+		rc = reg_w(gspca_dev, red_gain, INDEX_GAIN_R);
+		if (rc)
+			return rc;
+		rc = reg_w(gspca_dev, green_gain, INDEX_GAIN_GBOT);
+		if (rc)
+			return rc;
+	}
+
+	return 0;
+}
+
+static int sd_setgain(struct gspca_dev *gspca_dev, s32 val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	sd->global_gain = val;
+	if (gspca_dev->streaming)
+		return set_gain(gspca_dev, 1);
+	return 0;
+}
+
+static int sd_getgain(struct gspca_dev *gspca_dev, s32 *val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	*val = sd->global_gain;
+	return 0;
+}
+
+static int sd_setredbalance(struct gspca_dev *gspca_dev, s32 val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	sd->red_bal = val;
+	if (gspca_dev->streaming)
+		return set_gain(gspca_dev, 1);
+	return 0;
+}
+
+static int sd_getredbalance(struct gspca_dev *gspca_dev, s32 *val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	*val = sd->red_bal;
+	return 0;
+}
+
+static int sd_setbluebalance(struct gspca_dev *gspca_dev, s32 val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	sd->blue_bal = val;
+	if (gspca_dev->streaming)
+		return set_gain(gspca_dev, 1);
+	return 0;
+}
+
+static int sd_getbluebalance(struct gspca_dev *gspca_dev, s32 *val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	*val = sd->blue_bal;
+	return 0;
+}
+
+static int configure_wh(struct gspca_dev *gspca_dev)
+{
+	unsigned int rc;
+	int w = gspca_dev->cam.cam_mode->width;
+
+	if (w == 800) {
+		static const struct cmd reg_init_res[] = {
+			{0x0060, 0x0344},
+			{0x0CD9, 0x0348},
+			{0x0036, 0x0346},
+			{0x098F, 0x034A},
+			{0x07C7, 0x3040},
+		};
+
+		rc = reg_w_buf(gspca_dev,
+			       reg_init_res, ARRAY_SIZE(reg_init_res));
+		if (rc < 0)
+			return rc;
+	} else if (w == 1600) {
+		static const struct cmd reg_init_res[] = {
+			{0x009C, 0x0344},
+			{0x0D19, 0x0348},
+			{0x0068, 0x0346},
+			{0x09C5, 0x034A},
+			{0x06C3, 0x3040},
+		};
+
+		rc = reg_w_buf(gspca_dev,
+			       reg_init_res, ARRAY_SIZE(reg_init_res));
+		if (rc < 0)
+			return rc;
+	} else if (w == 3264) {
+		static const struct cmd reg_init_res[] = {
+			{0x00E8, 0x0344},
+			{0x0DA7, 0x0348},
+			{0x009E, 0x0346},
+			{0x0A2D, 0x034A},
+			{0x0241, 0x3040},
+		};
+
+		rc = reg_w_buf(gspca_dev,
+			       reg_init_res, ARRAY_SIZE(reg_init_res));
+		if (rc < 0)
+			return rc;
+	} else {
+		pr_devel("bad width %u", w);
+		return -EINVAL;
+	}
+
+	rc = reg_w(gspca_dev, 0x0000, 0x0400);
+	if (rc)
+		return rc;
+	rc = reg_w(gspca_dev, 0x0010, 0x0404);
+	if (rc)
+		return rc;
+	rc = reg_w(gspca_dev, w, INDEX_WIDTH);
+	if (rc)
+		return rc;
+	rc = reg_w(gspca_dev, gspca_dev->cam.cam_mode->height, INDEX_HEIGHT);
+	if (rc)
+		return rc;
+
+	if (w == 800) {
+		rc = reg_w(gspca_dev, 0x0384, 0x300A);
+		if (rc)
+			return rc;
+		rc = reg_w(gspca_dev, 0x0960, 0x300C);
+		if (rc)
+			return rc;
+	} else if (w == 1600) {
+		rc = reg_w(gspca_dev, 0x0640, 0x300A);
+		if (rc)
+			return rc;
+		rc = reg_w(gspca_dev, 0x0FA0, 0x300C);
+		if (rc)
+			return rc;
+	} else if (w == 3264) {
+		rc = reg_w(gspca_dev, 0x0B4B, 0x300A);
+		if (rc)
+			return rc;
+		rc = reg_w(gspca_dev, 0x1F40, 0x300C);
+		if (rc)
+			return rc;
+	} else {
+		pr_devel("bad width %u", w);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/* Packets that were encrypted, no idea if the grouping is significant */
+static int configure_encrypted(struct gspca_dev *gspca_dev)
+{
+	unsigned int rc;
+	static const struct cmd reg_init_begin[] = {
+		{0x0100, 0x0103},
+		{0x0000, 0x0100},
+		{0x0100, 0x0104},
+		{0x0004, 0x0300},
+		{0x0001, 0x0302},
+		{0x0008, 0x0308},
+		{0x0001, 0x030A},
+		{0x0004, 0x0304},
+		{0x0040, 0x0306},
+		{0x0000, 0x0104},
+		{0x0100, 0x0104},
+	};
+	static const struct cmd reg_init_end[] = {
+		{0x0000, 0x0104},
+		{0x0301, 0x31AE},
+		{0x0805, 0x3064},
+		{0x0071, 0x3170},
+		{0x10DE, 0x301A},
+		{0x0000, 0x0100},
+		{0x0010, 0x0306},
+		{0x0100, 0x0100},
+	};
+
+	pr_devel("Encrypted begin, w = %u", gspca_dev->cam.cam_mode->width);
+	rc = reg_w_buf(gspca_dev, reg_init_begin, ARRAY_SIZE(reg_init_begin));
+	if (rc < 0)
+		return rc;
+	rc = configure_wh(gspca_dev);
+	if (rc < 0)
+		return rc;
+	rc = reg_w_buf(gspca_dev, reg_init_end, ARRAY_SIZE(reg_init_end));
+	if (rc < 0)
+		return rc;
+
+	pr_devel("Setting exposure");
+	rc = set_exposure(gspca_dev);
+	if (rc) {
+		pr_devel("Failed to set exposure");
+		return rc;
+	}
+
+	rc = reg_w(gspca_dev, 0x0100, 0x0104);
+	if (rc)
+		return rc;
+
+	pr_devel("Setting gain");
+	rc = set_gain(gspca_dev, 1);
+	if (rc) {
+		pr_devel("Failed to set gain");
+		return rc;
+	}
+
+	rc = reg_w(gspca_dev, 0x0000, 0x0104);
+	if (rc)
+		return rc;
+
+	pr_devel("Encrypted end");
+	return 0;
+}
+
+static int configure(struct gspca_dev *gspca_dev)
+{
+	uint8_t buff[4];
+	unsigned int rc;
+
+	pr_devel("Beginning configure");
+
+	/*
+	First driver sets a sort of encryption key
+	A number of futur requests of this type have wValue and wIndex encrypted
+	as follows:
+	-Compute key = this wValue rotate left by 4 bits
+		(decrypt.py rotates right because we are decrypting)
+	-Later packets encrypt packets by XOR'ing with key
+		XOR encrypt/decrypt is symmetrical
+		wValue, and wIndex are encrypted
+		bRequest is not and bRequestType is always 0xC0
+			This allows resyncing if key is unknown?
+	By setting 0 we XOR with 0 and the shifting and XOR drops out
+	*/
+	rc = usb_control_msg(gspca_dev->dev, usb_rcvctrlpipe(gspca_dev->dev, 0),
+			0x16, 0xC0, 0x0000, 0x0000, buff, 2, 500);
+	if (val_reply(buff, rc)) {
+		pr_warn("failed key req");
+		return -EIO;
+	}
+
+	/*
+	Next does some sort of 2 packet challenge / response
+	(to make sure its not cloned hardware?)
+	Ignore: I want to work with their hardware, not clone it
+	16 bytes out challenge, requestType: 0x40
+	16 bytes in response, requestType: 0xC0
+	*/
+
+	rc = usb_control_msg(gspca_dev->dev, usb_sndctrlpipe(gspca_dev->dev, 0),
+			0x01, 0x40, 0x0001, 0x000F, NULL, 0, 500);
+	if (rc < 0) {
+		pr_warn("failed to replay packet 176 w/ rc %d\n", rc);
+		return rc;
+	}
+
+	rc = usb_control_msg(gspca_dev->dev, usb_sndctrlpipe(gspca_dev->dev, 0),
+			0x01, 0x40, 0x0000, 0x000F, NULL, 0, 500);
+	if (rc < 0) {
+		pr_warn("failed to replay packet 178 w/ rc %d\n", rc);
+		return rc;
+	}
+
+	rc = usb_control_msg(gspca_dev->dev, usb_sndctrlpipe(gspca_dev->dev, 0),
+			0x01, 0x40, 0x0001, 0x000F, NULL, 0, 500);
+	if (rc < 0) {
+		pr_warn("failed to replay packet 180 w/ rc %d\n", rc);
+		return rc;
+	}
+
+	rc = usb_control_msg(gspca_dev->dev, usb_rcvctrlpipe(gspca_dev->dev, 0),
+			0x20, 0xC0, 0x0000, 0x0000, buff, 4, 500);
+	if (rc != 4 || memcmp((char[]){0xE6, 0x0D, 0x00, 0x00}, buff, 4)) {
+		pr_warn("failed to replay packet 182 w/ rc %d\n", rc);
+		if (rc < 0)
+			return rc;
+		return -EIO;
+	}
+
+	/* Large (EEPROM?) read, skip it since no idea what to do with it */
+
+	rc = configure_encrypted(gspca_dev);
+	if (rc)
+		return rc;
+
+	/* Omitted this by accident, does not work without it */
+	rc = usb_control_msg(gspca_dev->dev, usb_sndctrlpipe(gspca_dev->dev, 0),
+			0x01, 0x40, 0x0003, 0x000F, NULL, 0, 500);
+
+	pr_devel("Configure complete");
+	return 0;
+}
+
+static int sd_config(struct gspca_dev *gspca_dev,
+			const struct usb_device_id *id)
+{
+	pr_devel("sd_config start");
+	gspca_dev->cam.cam_mode = vga_mode;
+	gspca_dev->cam.nmodes = ARRAY_SIZE(vga_mode);
+	pr_devel("cam modes size: %d", gspca_dev->cam.nmodes);
+
+	pr_devel("Input flags: 0x%08X", gspca_dev->cam.input_flags);
+	/* Yes we want URBs and we want them now! */
+	gspca_dev->cam.no_urb_create = 0;
+	/*
+	TODO: considering increasing much higher
+	Without frame sync we need to make sure we never drop
+	*/
+	pr_devel("Max nurbs: %d", MAX_NURBS);
+	gspca_dev->cam.bulk_nurbs = 4;
+	/* Largest size the windows driver uses */
+	gspca_dev->cam.bulk_size = 0x4000;
+	/* Def need to use bulk transfers */
+	gspca_dev->cam.bulk = 1;
+
+	pr_devel("sd_config end");
+	return 0;
+}
+
+static int sd_start(struct gspca_dev *gspca_dev)
+{
+	struct sd *sd = container_of(gspca_dev, struct sd, gspca_dev);
+	int rc;
+
+	pr_devel("sd_start() begin");
+	sd->this_f = 0;
+
+	rc = configure(gspca_dev);
+	if (rc < 0) {
+		pr_warn("Failed configure");
+		return rc;
+	}
+	/* First two frames have messed up gains
+	Drop them to avoid special cases in user apps? */
+	rc = gspca_dev->cam.cam_mode->sizeimage;
+	if (rc < 0) {
+		pr_devel("Failed size");
+		return rc;
+	}
+
+	pr_devel("sd_start() end, status %d", gspca_dev->usb_err);
+	return gspca_dev->usb_err;
+}
+
+static void sd_pkt_scan(struct gspca_dev *gspca_dev,
+			u8 *data,		/* isoc packet */
+			int len)		/* iso packet length */
+{
+	struct sd *sd = container_of(gspca_dev, struct sd, gspca_dev);
+	size_t frame_sz;
+
+	frame_sz = gspca_dev->cam.cam_mode->sizeimage;
+
+	/* can we finish a frame? */
+	if (sd->this_f + len >= frame_sz) {
+		unsigned int remainder = frame_sz - sd->this_f;
+		gspca_frame_add(gspca_dev, LAST_PACKET,
+				data, remainder);
+		len -= remainder;
+		data += remainder;
+		sd->this_f = 0;
+	}
+	/* in theory even if finished a frame could have part of next,
+	   not sure if it ever happens though */
+	if (len > 0) {
+		if (sd->this_f == 0)
+			gspca_frame_add(gspca_dev, FIRST_PACKET, data, len);
+		else
+			gspca_frame_add(gspca_dev, INTER_PACKET, data, len);
+		sd->this_f += len;
+	}
+}
+
+static int sd_init(struct gspca_dev *gspca_dev)
+{
+	struct sd *sd = container_of(gspca_dev, struct sd, gspca_dev);
+
+	pr_devel("sd_init");
+	/* Setting at init allows one app to adjust and another take pictures */
+	sd->exposure = EXPOSURE_DEFAULT;
+	sd->global_gain = GAIN_DEFAULT;
+	sd->red_bal = RED_DEFAULT;
+	sd->blue_bal = BLUE_DEFAULT;
+
+	return 0;
+}
+
+static const struct ctrl sd_ctrls[] = {
+	{
+		{
+			.id	  = V4L2_CID_EXPOSURE,
+			.type	= V4L2_CTRL_TYPE_INTEGER,
+			.name	= "Exposure",
+			.minimum = 0,
+			/* Mostly limited by URB timeouts */
+			.maximum = 800,
+			.step	= 1,
+			.default_value = EXPOSURE_DEFAULT,
+		},
+		.set = sd_setexposure,
+		.get = sd_getexposure,
+	},
+	{
+		{
+			.id	 = V4L2_CID_GAIN,
+			.type	 = V4L2_CTRL_TYPE_INTEGER,
+			.name	 = "Gain",
+			.minimum = 0,
+			.maximum = GAIN_MAX,
+			.step	 = 1,
+			.default_value = GAIN_DEFAULT,
+		},
+		.set = sd_setgain,
+		.get = sd_getgain,
+	},
+	{
+		{
+			.id	 = V4L2_CID_BLUE_BALANCE,
+			.type	 = V4L2_CTRL_TYPE_INTEGER,
+			.name	 = "Blue Balance",
+			.minimum = 0,
+			.maximum = BAL_MAX,
+			.step	 = 1,
+			.default_value = BLUE_DEFAULT,
+		},
+		.set = sd_setbluebalance,
+		.get = sd_getbluebalance,
+	},
+	{
+		{
+			.id	 = V4L2_CID_RED_BALANCE,
+			.type	 = V4L2_CTRL_TYPE_INTEGER,
+			.name	 = "Red Balance",
+			.minimum = 0,
+			.maximum = BAL_MAX,
+			.step	 = 1,
+			.default_value = RED_DEFAULT,
+		},
+		.set = sd_setredbalance,
+		.get = sd_getredbalance,
+	},
+};
+
+static const struct sd_desc sd_desc = {
+	.name = MODULE_NAME,
+	.ctrls = sd_ctrls,
+	.nctrls = ARRAY_SIZE(sd_ctrls),
+	.config = sd_config,
+	.init = sd_init,
+	.start = sd_start,
+	.pkt_scan = sd_pkt_scan,
+};
+
+/* TODO: should add the untested devices? */
+static const struct usb_device_id device_table[] = {
+	{ USB_DEVICE(0x0547, 0x6801) }, /* UCMOS08000KPB */
+	{ }
+};
+MODULE_DEVICE_TABLE(usb, device_table);
+
+static int sd_probe(struct usb_interface *intf,
+			const struct usb_device_id *id)
+{
+	int rc = 0;
+	pr_devel("sd_probe start, alt 0x%p", intf->cur_altsetting);
+	rc = gspca_dev_probe(intf, id, &sd_desc, sizeof(struct sd),
+				THIS_MODULE);
+	pr_devel("sd_probe done, rc %d", rc);
+	return rc;
+}
+
+static struct usb_driver sd_driver = {
+	.name = MODULE_NAME,
+	.id_table = device_table,
+	.probe = sd_probe,
+	.disconnect = gspca_disconnect,
+#ifdef CONFIG_PM
+	.suspend = gspca_suspend,
+	.resume = gspca_resume,
+#endif
+};
+
+static int __init sd_mod_init(void)
+{
+	int ret;
+
+	ret = usb_register(&sd_driver);
+	if (ret < 0)
+		return ret;
+	return 0;
+}
+static void __exit sd_mod_exit(void)
+{
+	usb_deregister(&sd_driver);
+}
+
+module_init(sd_mod_init);
+module_exit(sd_mod_exit);
+
-- 
1.7.9.5

