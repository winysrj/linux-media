Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35627 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247AbcDXVKQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Apr 2016 17:10:16 -0400
Received: by mail-wm0-f67.google.com with SMTP id e201so17586525wme.2
        for <linux-media@vger.kernel.org>; Sun, 24 Apr 2016 14:10:15 -0700 (PDT)
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
To: sakari.ailus@iki.fi
Cc: sre@kernel.org, pali.rohar@gmail.com, pavel@ucw.cz,
	linux-media@vger.kernel.org,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Subject: [RFC PATCH 02/24] smiaregs: Generic i2c register writing
Date: Mon, 25 Apr 2016 00:08:02 +0300
Message-Id: <1461532104-24032-3-git-send-email-ivo.g.dimitrov.75@gmail.com>
In-Reply-To: <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
References: <20160420081427.GZ32125@valkosipuli.retiisi.org.uk>
 <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
---
 drivers/media/i2c/Kconfig         |   1 +
 drivers/media/i2c/Makefile        |   1 +
 drivers/media/i2c/smia/Kconfig    |   9 +
 drivers/media/i2c/smia/Makefile   |   1 +
 drivers/media/i2c/smia/smiaregs.c | 724 ++++++++++++++++++++++++++++++++++++++
 include/media/smiaregs.h          | 143 ++++++++
 6 files changed, 879 insertions(+)
 create mode 100644 drivers/media/i2c/smia/Kconfig
 create mode 100644 drivers/media/i2c/smia/Makefile
 create mode 100644 drivers/media/i2c/smia/smiaregs.c
 create mode 100644 include/media/smiaregs.h

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 993dc50..254c106 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -629,6 +629,7 @@ config VIDEO_S5K5BAF
 	  camera sensor with an embedded SoC image signal processor.
 
 source "drivers/media/i2c/smiapp/Kconfig"
+source "drivers/media/i2c/smia/Kconfig"
 
 config VIDEO_S5C73M3
 	tristate "Samsung S5C73M3 sensor support"
diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
index 94f2c99..05e79aa 100644
--- a/drivers/media/i2c/Makefile
+++ b/drivers/media/i2c/Makefile
@@ -5,6 +5,7 @@ obj-$(CONFIG_VIDEO_SMIAPP)	+= smiapp/
 obj-$(CONFIG_VIDEO_CX25840) += cx25840/
 obj-$(CONFIG_VIDEO_M5MOLS)	+= m5mols/
 obj-y				+= soc_camera/
+obj-y				+= smia/
 
 obj-$(CONFIG_VIDEO_APTINA_PLL) += aptina-pll.o
 obj-$(CONFIG_VIDEO_TVAUDIO) += tvaudio.o
diff --git a/drivers/media/i2c/smia/Kconfig b/drivers/media/i2c/smia/Kconfig
new file mode 100644
index 0000000..d9be497
--- /dev/null
+++ b/drivers/media/i2c/smia/Kconfig
@@ -0,0 +1,9 @@
+config VIDEO_SMIAREGS
+	tristate "Generic SMIA I2C register access and register list helper"
+	depends on I2C
+	---help---
+	  This allows writing and reading SMIA image sensors' I2C registers
+	  easily.
+
+	  Also a few helper functions are provided to work with binary
+	  register lists.
diff --git a/drivers/media/i2c/smia/Makefile b/drivers/media/i2c/smia/Makefile
new file mode 100644
index 0000000..cff67bc
--- /dev/null
+++ b/drivers/media/i2c/smia/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_VIDEO_SMIAREGS)  += smiaregs.o
diff --git a/drivers/media/i2c/smia/smiaregs.c b/drivers/media/i2c/smia/smiaregs.c
new file mode 100644
index 0000000..1479bba
--- /dev/null
+++ b/drivers/media/i2c/smia/smiaregs.c
@@ -0,0 +1,724 @@
+/*
+ * drivers/media/i2c/smia/smiaregs.c
+ *
+ * Copyright (C) 2008 Nokia Corporation
+ *
+ * Contact: Sakari Ailus <sakari.ailus@nokia.com>
+ *          Tuukka Toivonen <tuukka.o.toivonen@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/i2c.h>
+#include <linux/module.h>
+#include <linux/sort.h>
+#include <linux/v4l2-subdev.h>
+#include <media/smiaregs.h>
+
+/*
+ * Video control helpers
+ */
+int smia_ctrl_find(const struct v4l2_queryctrl *ctrls, size_t nctrls, int id)
+{
+	size_t i;
+
+	for (i = 0; i < nctrls; i++)
+		if (ctrls[i].id == id)
+			break;
+
+	if (i == nctrls)
+		i = -EINVAL;
+
+	return i;
+}
+EXPORT_SYMBOL_GPL(smia_ctrl_find);
+
+int smia_ctrl_find_next(const struct v4l2_queryctrl *ctrls, size_t nctrls,
+			int id)
+{
+	int i;
+	u32 best = (u32)-1;
+
+	for (i = 0; i < nctrls; i++)
+		if (ctrls[i].id > id
+		    && (best == (u32)-1 || ctrls[i].id < ctrls[best].id))
+			best = i;
+
+	if (best == (u32)-1)
+		return -EINVAL;
+
+	return best;
+}
+EXPORT_SYMBOL_GPL(smia_ctrl_find_next);
+
+int smia_ctrl_query(const struct v4l2_queryctrl *ctrls, size_t nctrls,
+		    struct v4l2_queryctrl *a)
+{
+	int id, i;
+
+	id = a->id;
+	if (id & V4L2_CTRL_FLAG_NEXT_CTRL) {
+		id &= ~V4L2_CTRL_FLAG_NEXT_CTRL;
+		i = smia_ctrl_find_next(ctrls, nctrls, id);
+	} else {
+		i = smia_ctrl_find(ctrls, nctrls, id);
+	}
+
+	if (i < 0)
+		return -EINVAL;
+
+	*a = ctrls[i];
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(smia_ctrl_query);
+
+int smia_mode_query(const __u32 *ctrls, size_t nctrls, struct v4l2_queryctrl *a)
+{
+	static const struct {
+		__u32 id;
+		char *name;
+	} ctrl[] = {
+		{ .id = V4L2_CID_MODE_FRAME_WIDTH,    .name = "Frame width" },
+		{ .id = V4L2_CID_MODE_FRAME_HEIGHT,   .name = "Frame height" },
+		{ .id = V4L2_CID_MODE_VISIBLE_WIDTH,  .name = "Visible width" },
+		{ .id = V4L2_CID_MODE_VISIBLE_HEIGHT,
+		  .name = "Visible height" },
+		{ .id = V4L2_CID_MODE_PIXELCLOCK,
+		  .name = "Pixel clock [Hz]" },
+		{ .id = V4L2_CID_MODE_SENSITIVITY,    .name = "Sensitivity" },
+		{ .id = V4L2_CID_MODE_OPSYSCLOCK,
+		  .name = "Output pixel clock [Hz]" },
+	};
+	int id, next = 0, i;
+
+	id = a->id;
+	if (id & V4L2_CTRL_FLAG_NEXT_CTRL) {
+		id &= ~V4L2_CTRL_FLAG_NEXT_CTRL;
+		next = 1;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(ctrl); i++) {
+		if ((!next && ctrl[i].id == id) ||
+		    (next && ctrl[i].id > id)) {
+			int j;
+			for (j = 0; j < nctrls; j++)
+				if (ctrl[i].id == ctrls[j])
+					goto found;
+		}
+	}
+	return -EINVAL;
+
+found:
+	a->id            = ctrl[i].id;
+	strcpy(a->name, ctrl[i].name);
+	a->type          = V4L2_CTRL_TYPE_INTEGER;
+	a->minimum       = 0;
+	a->maximum       = 0;
+	a->step          = 0;
+	a->default_value = 0;
+	a->flags         = V4L2_CTRL_FLAG_READ_ONLY;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(smia_mode_query);
+
+int smia_mode_g_ctrl(const __u32 *ctrls, size_t nctrls, struct v4l2_control *vc,
+		     const struct smia_mode *sm)
+{
+	int i;
+
+	for (i = 0; i < nctrls; i++)
+		if (ctrls[i] == vc->id)
+			break;
+	if (i >= nctrls)
+		return -EINVAL;
+
+	switch (vc->id) {
+	case V4L2_CID_MODE_FRAME_WIDTH:
+		vc->value = sm->width;
+		break;
+	case V4L2_CID_MODE_FRAME_HEIGHT:
+		vc->value = sm->height;
+		break;
+	case V4L2_CID_MODE_VISIBLE_WIDTH:
+		vc->value = sm->window_width;
+		break;
+	case V4L2_CID_MODE_VISIBLE_HEIGHT:
+		vc->value = sm->window_height;
+		break;
+	case V4L2_CID_MODE_PIXELCLOCK:
+		vc->value = sm->pixel_clock;
+		break;
+	case V4L2_CID_MODE_SENSITIVITY:
+		vc->value = sm->sensitivity;
+		break;
+	case V4L2_CID_MODE_OPSYSCLOCK:
+		vc->value = sm->opsys_clock;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(smia_mode_g_ctrl);
+
+/*
+ * Reglist helpers
+ */
+static int smia_reglist_cmp(const void *a, const void *b)
+{
+	const struct smia_reglist **list1 = (const struct smia_reglist **)a,
+		**list2 = (const struct smia_reglist **)b;
+
+	/* Put real modes in the beginning. */
+	if ((*list1)->type == SMIA_REGLIST_MODE &&
+	    (*list2)->type != SMIA_REGLIST_MODE)
+		return -1;
+	if ((*list1)->type != SMIA_REGLIST_MODE &&
+	    (*list2)->type == SMIA_REGLIST_MODE)
+		return 1;
+
+	/* Descending width. */
+	if ((*list1)->mode.window_width > (*list2)->mode.window_width)
+		return -1;
+	if ((*list1)->mode.window_width < (*list2)->mode.window_width)
+		return 1;
+
+	if ((*list1)->mode.window_height > (*list2)->mode.window_height)
+		return -1;
+	if ((*list1)->mode.window_height < (*list2)->mode.window_height)
+		return 1;
+
+	return 0;
+}
+
+/*
+ * Prepare register list created by dcc-pulautin for use in kernel.
+ */
+int smia_reglist_import(struct smia_meta_reglist *meta)
+{
+	uintptr_t nlists = 0;
+
+	if (meta->magic != SMIA_MAGIC) {
+		printk(KERN_ERR "invalid camera sensor firmware (0x%08X)\n",
+		       meta->magic);
+		return -EILSEQ;
+	}
+
+	printk(KERN_ALERT "%s: meta_reglist version %s\n",
+	       __func__, meta->version);
+
+	while (meta->reglist[nlists].ptr != NULL)
+		nlists++;
+
+	if (!nlists)
+		return -EINVAL;
+
+	sort(&meta->reglist[0].ptr, nlists, sizeof(meta->reglist[0].ptr),
+	     smia_reglist_cmp, NULL);
+
+	nlists = 0;
+	while (meta->reglist[nlists].ptr != NULL) {
+		struct smia_reglist *list;
+
+		list = meta->reglist[nlists].ptr;
+
+		printk(KERN_DEBUG
+		       "%s: type %d\tw %d\th %d\tfmt %x\tival %d/%d\tptr %p\n",
+		       __func__,
+		       list->type,
+		       list->mode.window_width, list->mode.window_height,
+		       list->mode.pixel_format,
+		       list->mode.timeperframe.numerator,
+		       list->mode.timeperframe.denominator,
+		       (void *)meta->reglist[nlists].ptr);
+
+		nlists++;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(smia_reglist_import);
+
+struct smia_reglist *smia_reglist_find_type(struct smia_meta_reglist *meta,
+					    u16 type)
+{
+	struct smia_reglist **next = &meta->reglist[0].ptr;
+
+	while (*next) {
+		if ((*next)->type == type)
+			return *next;
+
+		next++;
+	}
+
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(smia_reglist_find_type);
+
+struct smia_reglist **smia_reglist_first(struct smia_meta_reglist *meta)
+{
+	return &meta->reglist[0].ptr;
+}
+EXPORT_SYMBOL_GPL(smia_reglist_first);
+
+struct smia_reglist *smia_reglist_find_mode_fmt(struct smia_meta_reglist *meta,
+						struct v4l2_mbus_framefmt *fmt)
+{
+	struct smia_reglist **list = smia_reglist_first(meta);
+	struct smia_reglist *best_match = NULL;
+	struct smia_reglist *best_other = NULL;
+	struct v4l2_mbus_framefmt format;
+	unsigned int max_dist_match = (unsigned int)-1;
+	unsigned int max_dist_other = (unsigned int)-1;
+
+	/* Find the mode with the closest image size. The distance between
+	 * image sizes is the size in pixels of the non-overlapping regions
+	 * between the requested size and the frame-specified size.
+	 *
+	 * Store both the closest mode that matches the requested format, and
+	 * the closest mode for all other formats. The best match is returned
+	 * if found, otherwise the best mode with a non-matching format is
+	 * returned.
+	 */
+	for (; *list; list++) {
+		unsigned int dist;
+
+		if ((*list)->type != SMIA_REGLIST_MODE)
+			continue;
+
+		smia_reglist_to_mbus(*list, &format);
+
+		dist = min(fmt->width, format.width)
+		     * min(fmt->height, format.height);
+		dist = format.width * format.height
+		     + fmt->width * fmt->height - 2 * dist;
+
+
+		if (fmt->code == format.code) {
+			if (dist < max_dist_match || best_match == NULL) {
+				best_match = *list;
+				max_dist_match = dist;
+			}
+		} else {
+			if (dist < max_dist_other || best_other == NULL) {
+				best_other = *list;
+				max_dist_other = dist;
+			}
+		}
+	}
+
+	return best_match ? best_match : best_other;
+}
+EXPORT_SYMBOL_GPL(smia_reglist_find_mode_fmt);
+
+#define TIMEPERFRAME_AVG_FPS(t)						\
+	(((t).denominator + ((t).numerator >> 1)) / (t).numerator)
+struct smia_reglist *smia_reglist_find_mode_ival(
+	struct smia_meta_reglist *meta,
+	struct smia_reglist *current_reglist,
+	struct v4l2_fract *timeperframe)
+{
+	int fps = TIMEPERFRAME_AVG_FPS(*timeperframe);
+	struct smia_reglist **list = smia_reglist_first(meta);
+	struct smia_mode *current_mode = &current_reglist->mode;
+
+	for (; *list; list++) {
+		struct smia_mode *mode = &(*list)->mode;
+
+		if ((*list)->type != SMIA_REGLIST_MODE)
+			continue;
+
+		if (mode->window_width != current_mode->window_width
+		    || mode->window_height != current_mode->window_height)
+			continue;
+
+		if (TIMEPERFRAME_AVG_FPS(mode->timeperframe) == fps)
+			return *list;
+	}
+
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(smia_reglist_find_mode_ival);
+
+#define MAX_FMTS 4
+int smia_reglist_enum_mbus_code(struct smia_meta_reglist *meta,
+				struct v4l2_subdev_mbus_code_enum *code)
+{
+	struct smia_reglist **list = smia_reglist_first(meta);
+	u32 pixelformat[MAX_FMTS];
+	int npixelformat = 0;
+
+	if (code->index >= MAX_FMTS)
+		return -EINVAL;
+
+	for (; *list; list++) {
+		struct smia_mode *mode = &(*list)->mode;
+		int i;
+
+		if ((*list)->type != SMIA_REGLIST_MODE)
+			continue;
+
+		for (i = 0; i < npixelformat; i++) {
+			if (pixelformat[i] == mode->pixel_format)
+				break;
+		}
+		if (i != npixelformat)
+			continue;
+
+		if (code->index == npixelformat) {
+			if (mode->pixel_format == V4L2_PIX_FMT_SGRBG10DPCM8)
+				code->code = MEDIA_BUS_FMT_SGRBG10_DPCM8_1X8;
+			else
+				code->code = MEDIA_BUS_FMT_SGRBG10_1X10;
+			return 0;
+		}
+
+		pixelformat[npixelformat] = mode->pixel_format;
+		npixelformat++;
+	}
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(smia_reglist_enum_mbus_code);
+
+int smia_reglist_enum_frame_size(struct smia_meta_reglist *meta,
+				 struct v4l2_subdev_frame_size_enum *fse)
+{
+	struct smia_reglist **list = smia_reglist_first(meta);
+	struct v4l2_mbus_framefmt format;
+	int cmp_width = INT_MAX;
+	int cmp_height = INT_MAX;
+	int index = fse->index;
+
+	for (; *list; list++) {
+		if ((*list)->type != SMIA_REGLIST_MODE)
+			continue;
+
+		smia_reglist_to_mbus(*list, &format);
+		if (fse->code != format.code)
+			continue;
+
+		/* Assume that the modes are grouped by frame size. */
+		if (format.width == cmp_width && format.height == cmp_height)
+			continue;
+
+		cmp_width = format.width;
+		cmp_height = format.height;
+
+		if (index-- == 0) {
+			fse->min_width = format.width;
+			fse->min_height = format.height;
+			fse->max_width = format.width;
+			fse->max_height = format.height;
+			return 0;
+		}
+	}
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(smia_reglist_enum_frame_size);
+
+int smia_reglist_enum_frame_ival(struct smia_meta_reglist *meta,
+				 struct v4l2_subdev_frame_interval_enum *fie)
+{
+	struct smia_reglist **list = smia_reglist_first(meta);
+	struct v4l2_mbus_framefmt format;
+	int index = fie->index;
+
+	for (; *list; list++) {
+		struct smia_mode *mode = &(*list)->mode;
+
+		if ((*list)->type != SMIA_REGLIST_MODE)
+			continue;
+
+		smia_reglist_to_mbus(*list, &format);
+		if (fie->code != format.code)
+			continue;
+
+		if (fie->width != format.width || fie->height != format.height)
+			continue;
+
+		if (index-- == 0) {
+			fie->interval = mode->timeperframe;
+			return 0;
+		}
+	}
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(smia_reglist_enum_frame_ival);
+
+void smia_reglist_to_mbus(const struct smia_reglist *reglist,
+			  struct v4l2_mbus_framefmt *fmt)
+{
+	fmt->width = reglist->mode.window_width;
+	fmt->height = reglist->mode.window_height;
+
+	if (reglist->mode.pixel_format == V4L2_PIX_FMT_SGRBG10DPCM8)
+		fmt->code = MEDIA_BUS_FMT_SGRBG10_DPCM8_1X8;
+	else
+		fmt->code = MEDIA_BUS_FMT_SGRBG10_1X10;
+}
+EXPORT_SYMBOL_GPL(smia_reglist_to_mbus);
+
+/*
+ *
+ * Register access helpers
+ *
+ */
+
+/*
+ * Read a 8/16/32-bit i2c register.  The value is returned in 'val'.
+ * Returns zero if successful, or non-zero otherwise.
+ */
+int smia_i2c_read_reg(struct i2c_client *client, u16 data_length,
+		      u16 reg, u32 *val)
+{
+	int r;
+	struct i2c_msg msg[1];
+	unsigned char data[4];
+
+	if (!client->adapter)
+		return -ENODEV;
+	if (data_length != SMIA_REG_8BIT && data_length != SMIA_REG_16BIT)
+		return -EINVAL;
+
+	msg->addr = client->addr;
+	msg->flags = 0;
+	msg->len = 2;
+	msg->buf = data;
+
+	/* high byte goes out first */
+	data[0] = (u8) (reg >> 8);;
+	data[1] = (u8) (reg & 0xff);
+	r = i2c_transfer(client->adapter, msg, 1);
+	if (r < 0)
+		goto err;
+
+	msg->len = data_length;
+	msg->flags = I2C_M_RD;
+	r = i2c_transfer(client->adapter, msg, 1);
+	if (r < 0)
+		goto err;
+
+	*val = 0;
+	/* high byte comes first */
+	if (data_length == SMIA_REG_8BIT)
+		*val = data[0];
+	else
+		*val = (data[0] << 8) + data[1];
+
+	return 0;
+
+err:
+	dev_err(&client->dev, "read from offset 0x%x error %d\n", reg, r);
+
+	return r;
+}
+EXPORT_SYMBOL_GPL(smia_i2c_read_reg);
+
+static void smia_i2c_create_msg(struct i2c_client *client, u16 len, u16 reg,
+				u32 val, struct i2c_msg *msg,
+				unsigned char *buf)
+{
+	msg->addr = client->addr;
+	msg->flags = 0; /* Write */
+	msg->len = 2 + len;
+	msg->buf = buf;
+
+	/* high byte goes out first */
+	buf[0] = (u8) (reg >> 8);;
+	buf[1] = (u8) (reg & 0xff);
+
+	switch (len) {
+	case SMIA_REG_8BIT:
+		buf[2] = (u8) (val) & 0xff;
+		break;
+	case SMIA_REG_16BIT:
+		buf[2] = (u8) (val >> 8) & 0xff;
+		buf[3] = (u8) (val & 0xff);
+		break;
+	case SMIA_REG_32BIT:
+		buf[2] = (u8) (val >> 24) & 0xff;
+		buf[3] = (u8) (val >> 16) & 0xff;
+		buf[4] = (u8) (val >> 8) & 0xff;
+		buf[5] = (u8) (val & 0xff);
+		break;
+	default:
+		BUG();
+	}
+}
+
+/*
+ * Write to a 8/16-bit register.
+ * Returns zero if successful, or non-zero otherwise.
+ */
+int smia_i2c_write_reg(struct i2c_client *client, u16 data_length, u16 reg,
+		       u32 val)
+{
+	int r;
+	struct i2c_msg msg[1];
+	unsigned char data[6];
+
+	if (!client->adapter)
+		return -ENODEV;
+	if (data_length != SMIA_REG_8BIT && data_length != SMIA_REG_16BIT)
+		return -EINVAL;
+
+	smia_i2c_create_msg(client, data_length, reg, val, msg, data);
+
+	r = i2c_transfer(client->adapter, msg, 1);
+	if (r < 0)
+		dev_err(&client->dev,
+			"wrote 0x%x to offset 0x%x error %d\n", val, reg, r);
+	else
+		r = 0; /* on success i2c_transfer() return messages trasfered */
+
+	return r;
+}
+EXPORT_SYMBOL_GPL(smia_i2c_write_reg);
+
+/*
+ * A buffered write method that puts the wanted register write
+ * commands in a message list and passes the list to the i2c framework
+ */
+static int smia_i2c_buffered_write_regs(struct i2c_client *client,
+					const struct smia_reg *wnext, int cnt)
+{
+	/* FIXME: check how big cnt is */
+	struct i2c_msg msg[cnt];
+	unsigned char data[cnt][6];
+	int wcnt = 0;
+	u16 reg, data_length;
+	u32 val;
+
+	/* Create new write messages for all writes */
+	while (wcnt < cnt) {
+		data_length = wnext->type;
+		reg = wnext->reg;
+		val = wnext->val;
+		wnext++;
+
+		smia_i2c_create_msg(client, data_length, reg,
+				    val, &msg[wcnt], &data[wcnt][0]);
+
+		/* Update write count */
+		wcnt++;
+	}
+
+	/* Now we send everything ... */
+	return i2c_transfer(client->adapter, msg, wcnt);
+}
+
+/*
+ * Write a list of registers to i2c device.
+ *
+ * The list of registers is terminated by SMIA_REG_TERM.
+ * Returns zero if successful, or non-zero otherwise.
+ */
+int smia_i2c_write_regs(struct i2c_client *client,
+			const struct smia_reg reglist[])
+{
+	int r, cnt = 0;
+	const struct smia_reg *next, *wnext;
+
+	if (!client->adapter)
+		return -ENODEV;
+
+	if (reglist == NULL)
+		return -EINVAL;
+
+	/* Initialize list pointers to the start of the list */
+	next = wnext = reglist;
+
+	do {
+		/*
+		 * We have to go through the list to figure out how
+		 * many regular writes we have in a row
+		 */
+		while (next->type != SMIA_REG_TERM
+		       && next->type != SMIA_REG_DELAY) {
+			/*
+			 * Here we check that the actual lenght fields
+			 * are valid
+			 */
+			if (next->type != SMIA_REG_8BIT
+			    &&  next->type != SMIA_REG_16BIT) {
+				dev_err(&client->dev,
+					"Invalid value on entry %d 0x%x\n",
+					cnt, next->type);
+				return -EINVAL;
+			}
+
+			/*
+			 * Increment count of successive writes and
+			 * read pointer
+			 */
+			cnt++;
+			next++;
+		}
+
+		/* Now we start writing ... */
+		r = smia_i2c_buffered_write_regs(client, wnext, cnt);
+
+		/* ... and then check that everything was OK */
+		if (r < 0) {
+			dev_err(&client->dev, "i2c transfer error !!!\n");
+			return r;
+		}
+
+		/*
+		 * If we ran into a sleep statement when going through
+		 * the list, this is where we snooze for the required time
+		 */
+		if (next->type == SMIA_REG_DELAY) {
+			set_current_state(TASK_UNINTERRUPTIBLE);
+			schedule_timeout(msecs_to_jiffies(next->val));
+			/*
+			 * ZZZ ...
+			 * Update list pointers and cnt and start over ...
+			 */
+			next++;
+			wnext = next;
+			cnt = 0;
+		}
+	} while (next->type != SMIA_REG_TERM);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(smia_i2c_write_regs);
+
+int smia_i2c_reglist_find_write(struct i2c_client *client,
+				struct smia_meta_reglist *meta, u16 type)
+{
+	struct smia_reglist *reglist;
+
+	reglist = smia_reglist_find_type(meta, type);
+	if (IS_ERR(reglist))
+		return PTR_ERR(reglist);
+
+	return smia_i2c_write_regs(client, reglist->regs);
+}
+EXPORT_SYMBOL_GPL(smia_i2c_reglist_find_write);
+
+MODULE_AUTHOR("Sakari Ailus <sakari.ailus@nokia.com>");
+MODULE_DESCRIPTION("Generic SMIA configuration and i2c register access");
+MODULE_LICENSE("GPL");
diff --git a/include/media/smiaregs.h b/include/media/smiaregs.h
new file mode 100644
index 0000000..8d7e79d
--- /dev/null
+++ b/include/media/smiaregs.h
@@ -0,0 +1,143 @@
+/*
+ * include/media/smiaregs.h
+ *
+ * Copyright (C) 2008 Nokia Corporation
+ *
+ * Contact: Sakari Ailus <sakari.ailus@nokia.com>
+ *          Tuukka Toivonen <tuukka.o.toivonen@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#ifndef SMIAREGS_H
+#define SMIAREGS_H
+
+#include <linux/i2c.h>
+#include <linux/types.h>
+#include <linux/videodev2.h>
+#include <linux/v4l2-subdev.h>
+
+struct v4l2_mbus_framefmt;
+struct v4l2_subdev_pad_mbus_code_enum;
+
+#define SMIA_MAGIC			0x531A0002
+
+struct smia_mode {
+	/* Physical sensor resolution and current image window */
+	__u16 sensor_width;
+	__u16 sensor_height;
+	__u16 sensor_window_origin_x;
+	__u16 sensor_window_origin_y;
+	__u16 sensor_window_width;
+	__u16 sensor_window_height;
+
+	/* Image data coming from sensor (after scaling) */
+	__u16 width;
+	__u16 height;
+	__u16 window_origin_x;
+	__u16 window_origin_y;
+	__u16 window_width;
+	__u16 window_height;
+
+	__u32 pixel_clock;		/* in Hz */
+	__u32 opsys_clock;		/* in Hz */
+	__u32 ext_clock;		/* in Hz */
+	struct v4l2_fract timeperframe;
+	__u32 max_exp;			/* Maximum exposure value */
+	__u32 pixel_format;		/* V4L2_PIX_FMT_xxx */
+	__u32 sensitivity;		/* 16.16 fixed point */
+};
+
+#define SMIA_REG_8BIT			1
+#define SMIA_REG_16BIT			2
+#define SMIA_REG_32BIT			4
+#define SMIA_REG_DELAY			100
+#define SMIA_REG_TERM			0xff
+struct smia_reg {
+	u16 type;
+	u16 reg;			/* 16-bit offset */
+	u32 val;			/* 8/16/32-bit value */
+};
+
+/* Possible struct smia_reglist types. */
+#define SMIA_REGLIST_STANDBY		0
+#define SMIA_REGLIST_POWERON		1
+#define SMIA_REGLIST_RESUME		2
+#define SMIA_REGLIST_STREAMON		3
+#define SMIA_REGLIST_STREAMOFF		4
+#define SMIA_REGLIST_DISABLED		5
+
+#define SMIA_REGLIST_MODE		10
+
+#define SMIA_REGLIST_LSC_ENABLE		100
+#define SMIA_REGLIST_LSC_DISABLE	101
+#define SMIA_REGLIST_ANR_ENABLE		102
+#define SMIA_REGLIST_ANR_DISABLE	103
+
+struct smia_reglist {
+	u32 type;
+	struct smia_mode mode;
+	struct smia_reg regs[];
+};
+
+#define SMIA_MAX_LEN			32
+struct smia_meta_reglist {
+	u32 magic;
+	char version[SMIA_MAX_LEN];
+	union {
+		struct smia_reglist *ptr;
+	} reglist[];
+};
+
+int smia_ctrl_find(const struct v4l2_queryctrl *ctrls, size_t nctrls, int id);
+int smia_ctrl_find_next(const struct v4l2_queryctrl *ctrls, size_t nctrls,
+			int id);
+int smia_ctrl_query(const struct v4l2_queryctrl *ctrls, size_t nctrls,
+		    struct v4l2_queryctrl *a);
+int smia_mode_query(const __u32 *ctrls, size_t nctrls,
+		    struct v4l2_queryctrl *a);
+int smia_mode_g_ctrl(const __u32 *ctrls, size_t nctrls, struct v4l2_control *vc,
+		     const struct smia_mode *sm);
+
+int smia_reglist_import(struct smia_meta_reglist *meta);
+struct smia_reglist *smia_reglist_find_type(struct smia_meta_reglist *meta,
+					    u16 type);
+struct smia_reglist **smia_reglist_first(struct smia_meta_reglist *meta);
+struct smia_reglist *smia_reglist_find_mode_fmt(struct smia_meta_reglist *meta,
+						struct v4l2_mbus_framefmt *fmt);
+struct smia_reglist *smia_reglist_find_mode_ival(
+	struct smia_meta_reglist *meta,
+	struct smia_reglist *current_reglist,
+	struct v4l2_fract *timeperframe);
+int smia_reglist_enum_mbus_code(struct smia_meta_reglist *meta,
+				struct v4l2_subdev_mbus_code_enum *code);
+int smia_reglist_enum_frame_size(struct smia_meta_reglist *meta,
+				 struct v4l2_subdev_frame_size_enum *fse);
+int smia_reglist_enum_frame_ival(struct smia_meta_reglist *meta,
+				 struct v4l2_subdev_frame_interval_enum *fie);
+void smia_reglist_to_mbus(const struct smia_reglist *reglist,
+			  struct v4l2_mbus_framefmt *fmt);
+
+int smia_i2c_read_reg(struct i2c_client *client, u16 data_length,
+		      u16 reg, u32 *val);
+int smia_i2c_write_reg(struct i2c_client *client, u16 data_length, u16 reg,
+		       u32 val);
+int smia_i2c_write_regs(struct i2c_client *client,
+			const struct smia_reg reglist[]);
+int smia_i2c_reglist_find_write(struct i2c_client *client,
+				struct smia_meta_reglist *meta, u16 type);
+
+#endif
-- 
1.9.1

