Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:58669 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725199AbeK0FM0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Nov 2018 00:12:26 -0500
From: Michael Grzeschik <m.grzeschik@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, stoth@kernellabs.com,
        laurent.pinchart@ideasonboard.com, kernel@pengutronix.de,
        mchehab@kernel.org, davem@davemloft.net
Subject: [PATCH v2 2/2] media: hdcapm: add support for usb2hdcapm hdmi2usb framegrabber from startech
Date: Mon, 26 Nov 2018 19:09:37 +0100
Message-Id: <20181126180937.32535-3-m.grzeschik@pengutronix.de>
In-Reply-To: <20181126180937.32535-1-m.grzeschik@pengutronix.de>
References: <20181126180937.32535-1-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Steven Toth <stoth@kernellabs.com>

This patch is based on the work of Steven Toth. He reverse engineered
the driver by tracing the windows driver.

https://github.com/stoth68000/hdcapm/

Signed-off-by: Steven Toth <stoth@kernellabs.com>
Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
---
 drivers/media/usb/Kconfig                    |   1 +
 drivers/media/usb/Makefile                   |   1 +
 drivers/media/usb/hdcapm/Kconfig             |  11 +
 drivers/media/usb/hdcapm/Makefile            |   3 +
 drivers/media/usb/hdcapm/hdcapm-buffer.c     | 230 ++++++
 drivers/media/usb/hdcapm/hdcapm-compressor.c | 782 +++++++++++++++++++
 drivers/media/usb/hdcapm/hdcapm-core.c       | 743 ++++++++++++++++++
 drivers/media/usb/hdcapm/hdcapm-i2c.c        | 332 ++++++++
 drivers/media/usb/hdcapm/hdcapm-reg.h        | 111 +++
 drivers/media/usb/hdcapm/hdcapm-video.c      | 665 ++++++++++++++++
 drivers/media/usb/hdcapm/hdcapm.h            | 283 +++++++
 11 files changed, 3162 insertions(+)
 create mode 100644 drivers/media/usb/hdcapm/Kconfig
 create mode 100644 drivers/media/usb/hdcapm/Makefile
 create mode 100644 drivers/media/usb/hdcapm/hdcapm-buffer.c
 create mode 100644 drivers/media/usb/hdcapm/hdcapm-compressor.c
 create mode 100644 drivers/media/usb/hdcapm/hdcapm-core.c
 create mode 100644 drivers/media/usb/hdcapm/hdcapm-i2c.c
 create mode 100644 drivers/media/usb/hdcapm/hdcapm-reg.h
 create mode 100644 drivers/media/usb/hdcapm/hdcapm-video.c
 create mode 100644 drivers/media/usb/hdcapm/hdcapm.h

diff --git a/drivers/media/usb/Kconfig b/drivers/media/usb/Kconfig
index b24e753c4766..5da5a849bad7 100644
--- a/drivers/media/usb/Kconfig
+++ b/drivers/media/usb/Kconfig
@@ -41,6 +41,7 @@ if I2C && MEDIA_DIGITAL_TV_SUPPORT
 	comment "Digital TV USB devices"
 source "drivers/media/usb/dvb-usb/Kconfig"
 source "drivers/media/usb/dvb-usb-v2/Kconfig"
+source "drivers/media/usb/hdcapm/Kconfig"
 source "drivers/media/usb/ttusb-budget/Kconfig"
 source "drivers/media/usb/ttusb-dec/Kconfig"
 source "drivers/media/usb/siano/Kconfig"
diff --git a/drivers/media/usb/Makefile b/drivers/media/usb/Makefile
index 21e46b10caa5..a729842842fe 100644
--- a/drivers/media/usb/Makefile
+++ b/drivers/media/usb/Makefile
@@ -16,6 +16,7 @@ obj-$(CONFIG_USB_MSI2500)       += msi2500/
 obj-$(CONFIG_VIDEO_CPIA2) += cpia2/
 obj-$(CONFIG_VIDEO_AU0828) += au0828/
 obj-$(CONFIG_VIDEO_HDPVR)	+= hdpvr/
+obj-$(CONFIG_VIDEO_HDCAPM)	+= hdcapm/
 obj-$(CONFIG_VIDEO_PVRUSB2) += pvrusb2/
 obj-$(CONFIG_VIDEO_USBVISION) += usbvision/
 obj-$(CONFIG_VIDEO_STK1160) += stk1160/
diff --git a/drivers/media/usb/hdcapm/Kconfig b/drivers/media/usb/hdcapm/Kconfig
new file mode 100644
index 000000000000..925e88abe68b
--- /dev/null
+++ b/drivers/media/usb/hdcapm/Kconfig
@@ -0,0 +1,11 @@
+
+config VIDEO_HDCAPM
+	tristate "Startech HDCAPM support"
+	depends on VIDEO_DEV && VIDEO_V4L2
+	select VIDEO_MST3367 if MEDIA_SUBDRV_AUTOSELECT
+	select I2C_ALGOBIT
+	help
+	  This is a video4linux driver for Startech's HDCAPM USB device.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called hdpvr
diff --git a/drivers/media/usb/hdcapm/Makefile b/drivers/media/usb/hdcapm/Makefile
new file mode 100644
index 000000000000..a0ccdecbd8f7
--- /dev/null
+++ b/drivers/media/usb/hdcapm/Makefile
@@ -0,0 +1,3 @@
+hdcapm-objs	:= hdcapm-core.o hdcapm-video.o hdcapm-compressor.o hdcapm-buffer.o hdcapm-i2c.o
+
+obj-$(CONFIG_VIDEO_HDCAPM) += hdcapm.o
diff --git a/drivers/media/usb/hdcapm/hdcapm-buffer.c b/drivers/media/usb/hdcapm/hdcapm-buffer.c
new file mode 100644
index 000000000000..e61de3e29d91
--- /dev/null
+++ b/drivers/media/usb/hdcapm/hdcapm-buffer.c
@@ -0,0 +1,230 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Driver for the Startech USB2HDCAPM USB capture device
+ *
+ * Copyright (c) 2017 Steven Toth <stoth@kernellabs.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *
+ * GNU General Public License for more details.
+ */
+
+#include "hdcapm.h"
+
+struct hdcapm_buffer *hdcapm_buffer_alloc(struct hdcapm_dev *dev,
+					  u32 nr, u32 maxsize)
+{
+	struct hdcapm_buffer *buf;
+
+	buf = kzalloc(sizeof(*buf), GFP_KERNEL);
+	if (!buf)
+		return NULL;
+
+	buf->nr = nr;
+	buf->dev = dev;
+	buf->maxsize = maxsize;
+	buf->ptr = kzalloc(maxsize, GFP_KERNEL);
+	if (!buf->ptr) {
+		kfree(buf);
+		return NULL;
+	}
+
+	return buf;
+}
+
+void hdcapm_buffer_free(struct hdcapm_buffer *buf)
+{
+	kfree(buf->ptr);
+	buf->ptr = NULL;
+
+	usb_free_urb(buf->urb);
+	buf->urb = NULL;
+
+	kfree(buf);
+}
+
+/* Helper macro for moving all buffers to another list.
+ * We WILL take the mutex in this func.
+ */
+void hdcapm_buffers_move_all(struct hdcapm_dev *dev,
+			     struct list_head *to, struct list_head *from)
+{
+	struct hdcapm_buffer *buf;
+
+	mutex_lock(&dev->dmaqueue_lock);
+	while (!list_empty(from)) {
+		buf = list_first_entry(from, struct hdcapm_buffer, list);
+		if (buf)
+			list_move_tail(&buf->list, to);
+	}
+	mutex_unlock(&dev->dmaqueue_lock);
+}
+
+/* Helper macro to free all buffers from a list.
+ * We WILL take the mutex in this func.
+ */
+void hdcapm_buffers_free_all(struct hdcapm_dev *dev, struct list_head *head)
+{
+	struct hdcapm_buffer *buf;
+
+	mutex_lock(&dev->dmaqueue_lock);
+	while (!list_empty(head)) {
+		buf = list_first_entry(head, struct hdcapm_buffer, list);
+		if (buf) {
+			list_del(&buf->list);
+			hdcapm_buffer_free(buf);
+		}
+	}
+	mutex_unlock(&dev->dmaqueue_lock);
+}
+
+/* Helper macros for managing the device lists.
+ * We WILL take the mutex in this func.
+ * Return a reference to the top most used buffer, we're going to
+ * read some or all of it (probably). Don't delete it from the list.
+ */
+struct hdcapm_buffer *hdcapm_buffer_peek_used(struct hdcapm_dev *dev)
+{
+	struct hdcapm_buffer *buf = NULL;
+
+	mutex_lock(&dev->dmaqueue_lock);
+	if (!list_empty(&dev->list_buf_used)) {
+		buf = list_first_entry(&dev->list_buf_used,
+				       struct hdcapm_buffer, list);
+	}
+	mutex_unlock(&dev->dmaqueue_lock);
+
+	v4l2_dbg(3, hdcapm_debug, dev->sd, "%s() returns %p\n", __func__, buf);
+
+	return buf;
+}
+
+static struct hdcapm_buffer *hdcapm_buffer_next_used(struct hdcapm_dev *dev)
+{
+	struct hdcapm_buffer *buf = NULL;
+
+	mutex_lock(&dev->dmaqueue_lock);
+	if (!list_empty(&dev->list_buf_used)) {
+		buf = list_first_entry(&dev->list_buf_used,
+				       struct hdcapm_buffer, list);
+		list_del(&buf->list);
+	}
+	mutex_unlock(&dev->dmaqueue_lock);
+
+	v4l2_dbg(3, hdcapm_debug, dev->sd, "%s() returns %p\n", __func__, buf);
+
+	return buf;
+}
+
+/* Pull the top buffer from the free list, but don't specifically remove
+ * it from the list. If no buffer exists, steal one from the used list.
+ * We WILL take the mutex in this func. Return the buffer at the top of
+ * the free list, delete the list node. We're probably going to fill it
+ * and move it to the used list. IF no free buffers exist, steal one
+ * from the used list and flag an internal data loss statistic.
+ */
+struct hdcapm_buffer *hdcapm_buffer_next_free(struct hdcapm_dev *dev)
+{
+	struct hdcapm_buffer *buf = NULL;
+
+	mutex_lock(&dev->dmaqueue_lock);
+	if (!list_empty(&dev->list_buf_free)) {
+		buf = list_first_entry(&dev->list_buf_free,
+				       struct hdcapm_buffer, list);
+		list_del(&buf->list);
+	}
+	mutex_unlock(&dev->dmaqueue_lock);
+
+	if (!buf) {
+		v4l2_err(dev->sd,
+			 "%s() No empty buffers. Increase buffer_count.\n",
+			 __func__);
+		buf = hdcapm_buffer_next_used(dev);
+		if (!buf)
+			v4l2_err(dev->sd,
+				 "%s() No free or empty buffers.\n", __func__);
+		dev->stats->buffer_overrun++;
+	}
+
+	v4l2_dbg(3, hdcapm_debug, dev->sd, "%s() returns %p\n", __func__, buf);
+
+	return buf;
+}
+
+static void hdcapm_buffer_add_to_list(struct hdcapm_dev *dev,
+				      struct hdcapm_buffer *buf,
+				      struct list_head *list)
+{
+	mutex_lock(&dev->dmaqueue_lock);
+	list_add_tail(&buf->list, list);
+	mutex_unlock(&dev->dmaqueue_lock);
+}
+
+inline void hdcapm_buffer_add_to_free(struct hdcapm_dev *dev,
+				      struct hdcapm_buffer *buf)
+{
+	hdcapm_buffer_add_to_list(dev, buf, &dev->list_buf_free);
+}
+
+inline void hdcapm_buffer_add_to_used(struct hdcapm_dev *dev,
+				      struct hdcapm_buffer *buf)
+{
+	hdcapm_buffer_add_to_list(dev, buf, &dev->list_buf_used);
+}
+
+static inline void hdcapm_buffer_move(struct hdcapm_dev *dev,
+				      struct hdcapm_buffer *buf,
+				      struct list_head *list)
+{
+	mutex_lock(&dev->dmaqueue_lock);
+	list_move_tail(&buf->list, list);
+	mutex_unlock(&dev->dmaqueue_lock);
+}
+
+/* Helper macros for moving a buffer to the free list.
+ * We WILL take the mutex in this func.
+ */
+void hdcapm_buffer_move_to_free(struct hdcapm_dev *dev,
+				struct hdcapm_buffer *buf)
+{
+	hdcapm_buffer_move(dev, buf, &dev->list_buf_free);
+}
+
+/* Helper macros for moving a buffer to the used list.
+ * We WILL take the mutex in this func.
+ */
+void hdcapm_buffer_move_to_used(struct hdcapm_dev *dev,
+				struct hdcapm_buffer *buf)
+{
+	hdcapm_buffer_move(dev, buf, &dev->list_buf_used);
+}
+
+/* For debugging. Lock the buffer queue and measure how much data (in bytes)
+ * and how many items are on the list.
+ */
+int hdcapm_buffer_used_queue_stats(struct hdcapm_dev *dev,
+				   u64 *bytes, u64 *items)
+{
+	struct hdcapm_buffer *buf = NULL;
+	struct list_head *p = NULL, *q = NULL;
+
+	*bytes = 0;
+	*items = 0;
+
+	mutex_lock(&dev->dmaqueue_lock);
+	list_for_each_safe(p, q, &dev->list_buf_used) {
+		buf = list_entry(p, struct hdcapm_buffer, list);
+		(*bytes) += (buf->actual_size - buf->readpos);
+		(*items)++;
+	}
+	mutex_unlock(&dev->dmaqueue_lock);
+
+	return 0;
+}
diff --git a/drivers/media/usb/hdcapm/hdcapm-compressor.c b/drivers/media/usb/hdcapm/hdcapm-compressor.c
new file mode 100644
index 000000000000..c8795bef4d00
--- /dev/null
+++ b/drivers/media/usb/hdcapm/hdcapm-compressor.c
@@ -0,0 +1,782 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Driver for the Startech USB2HDCAPM USB capture device
+ *
+ * Copyright (c) 2017 Steven Toth <stoth@kernellabs.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *
+ * GNU General Public License for more details.
+ */
+
+#include "hdcapm.h"
+
+#define CMD_ARRAY_SIZE(arr) (sizeof((arr)) / sizeof(u32))
+
+static char *cmd_name(u32 id)
+{
+	switch (id) {
+	case 0x01: return "Start Compressor";
+	case 0x02: return "Stop Compressor";
+	case 0x10: return "Configure Compressor Interface";
+	default:   return "Undefined";
+	}
+}
+
+/* Wait up to 500ms for the firmware to be ready, or return a timeout.
+ * On idle, value 1 is return else < 0 indicates an error.
+ */
+static int fw_check_idle(struct hdcapm_dev *dev)
+{
+	unsigned long timeout = jiffies + msecs_to_jiffies(500);
+	int ret = -ETIMEDOUT;
+	u32 val;
+
+	while (!time_after(jiffies, timeout)) {
+		if (hdcapm_read32(dev, REG_FW_CMD_BUSY, &val) != 0) {
+			ret = -EINVAL; /* Error trying to read register. */
+			break;
+		}
+
+		if (val == 0) {
+			ret = 1; /* Success - Firmware is idle. */
+			break;
+		}
+
+		usleep_range(10000, 15000);
+	}
+
+	return ret;
+}
+
+/* Send a command to the firmware.
+ *
+ * Firmware commands and arguments are passed to this function for
+ * transmission to the hardware.
+ * An array of u32s, with the first u32 being the command type, followed
+ * by N arguments that are written to ARGS[0-n].
+ * Return 0 on success else < 0.
+ */
+static int execute_cmd(struct hdcapm_dev *dev, const u32 *cmdarr, u32 entries)
+{
+	int ret;
+	int i;
+
+	/* Check hardware is ready */
+	mutex_lock(&dev->lock);
+
+	if (fw_check_idle(dev) > 0) {
+		v4l2_dbg(1, hdcapm_debug, dev->sd,
+			 "FIRMWARE CMD = 0x%08x [%s]\n",
+			 *cmdarr, cmd_name(*cmdarr));
+
+		/* Send a new command to the hardware/firmware. */
+		/* Write all args into the FW arg registers */
+		for (i = 1; i < entries; i++)
+			v4l2_dbg(1, hdcapm_debug, dev->sd,
+				 "%2d: 0x%08x\n", i - 1, *(cmdarr + i));
+
+		for (i = 1; i < entries; i++)
+			hdcapm_write32(dev, REG_FW_CMD_ARG(i - 1),
+				       *(cmdarr + i));
+
+		/* Prepare the firmware to execute a command. */
+		hdcapm_write32(dev, REG_FW_CMD_BUSY, 1);
+
+		/* Trigger the command execution. */
+		hdcapm_write32(dev, REG_FW_CMD_EXECUTE, *cmdarr);
+
+		ret = 0; /* Success */
+	} else {
+		ret = -EINVAL;
+	}
+
+	mutex_unlock(&dev->lock);
+
+	return ret;
+}
+
+/* Stop encoder */
+static const u32 cmd_02[] = {
+	0x00000002,
+	0x00000000,
+};
+
+/* start encoder */
+static const u32 cmd_0a[] = {
+	0x0000000a,
+	0x00000008,
+};
+
+/* 27813 in LGPEncoder/complete-trace.tdc */
+static const u32 cmd_f1[] = {
+	0x000000f1,
+	0x80000011,
+};
+
+/* 27873 in LGPEncoder/complete-trace.tdc */
+static const u32 cmd_f2[] = {
+	0x000000f2,
+	0x01000100,
+};
+
+/* disable encoder */
+static const u32 cmd_f3[] = {
+	0x000000f3,
+	0x00000000,
+};
+
+/* 28548 in LGPEncoder/complete-trace.tdc */
+static const u32 cmd_10_0f[] = {
+	0x00000010,
+	0x0000000f,
+	0x00000000,
+	0x00000000,
+};
+
+/* 28643 in LGPEncoder/complete-trace.tdc */
+static const u32 cmd_10_10[] = {
+	0x00000010,
+	0x00000010,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+};
+
+/* 28743 in LGPEncoder/complete-trace.tdc */
+static const u32 cmd_10_12[] = {
+	0x00000010,
+	0x00000012,
+	0x00000000,
+};
+
+/* 28823 in LGPEncoder/complete-trace.tdc */
+static const u32 cmd_10_13[] = {
+	0x00000010,
+	0x00000013,
+	0x00000050,
+	0x00000000,
+	0x0000000a,
+};
+
+/* 29028 in LGPEncoder/complete-trace.tdc */
+static const u32 cmd_10_16[] = {
+	0x00000010,
+	0x00000016,
+	0x00000000,
+	0x00000000,
+};
+
+/* 29123 in LGPEncoder/complete-trace.tdc */
+static const u32 cmd_10_17[] = {
+	0x00000010,
+	0x00000017,
+	0x00000000,
+};
+
+/* 29203 in LGPEncoder/complete-trace.tdc */
+static const u32 cmd_10_02[] = {
+	0x00000010,
+	0x00000002,
+	0xf1f1f1da,
+	0xb6f1f1b6,
+};
+
+/* LGPEncoder/complete-trace.tdc
+ * EP4 -> 01 00 07 00 B0 06 00 00
+ *	- (query buffer availablility, read 7 words from address 6b0)
+ * EP3 <- 40 00 00 00 83 00 00 00 00 1F 3E 00 00 00
+ *	  00 00 3F 5B 00 00 AA AA AA AA 01 00 00 00
+ * EP4 -> 09 00 08 00 00 00 00 00 00 1F 3E 00 3F 5B 00 00
+ * The buffer is transferred via EP1 IN,
+ * note that the ISO13818 DWORDS are byte reversed.....
+ * then this message is sent to the firmware to acknowledge the buffer was read?
+ */
+/* 30739 in LGPEncoder/complete-trace.tdc */
+static const u32 cmd_30[] = {
+	0x00000030, /* Fixed value */
+	0x00000083, /* Fixed value */
+	0x00005b3f, /* Number of DWORDS we previously read. */
+	0x00010007, /* Fixed value */
+	0x2aaaaaaa, /* Fixed value */
+	0x00000000, /* Fixed value */
+	0x00000000, /* Fixed value */
+};
+
+static int hdcapm_compressor_enable_firmware(struct hdcapm_dev *dev, int val)
+{
+	// 32527
+	/* EP4 Host -> 07 01 00 00 00 00 00 00 */
+	u8 tx[] = {
+		0x07,
+		 val, /* 0 = stop, 1 = start. */
+		0x00,
+		0x00,
+		0x00,
+		0x00,
+		0x00,
+		0x00,
+	};
+
+	v4l2_dbg(2, hdcapm_debug, dev->sd, "%s()\n", __func__);
+
+	/* Flush this to EP4 via a bulk write. */
+	if (hdcapm_core_ep_send(dev, PIPE_EP4, &tx[0], sizeof(tx), 500) < 0)
+		return -1;
+
+	return 0; /* Success */
+}
+
+static int firmware_transition(struct hdcapm_dev *dev, int run,
+			       struct v4l2_dv_timings *timings)
+{
+	struct hdcapm_encoder_parameters *p = &dev->encoder_parameters;
+
+	/* 29298 in LGPEncoder/complete-trace.tdc */
+	u32 cfg[12];
+
+	u32 i_width, i_height, i_fps;
+	u32 o_width, o_height, o_fps;
+	u32 min_bitrate_kbps = dev->encoder_parameters.bitrate_bps / 1000;
+	u32 max_bitrate_kbps = dev->encoder_parameters.bitrate_peak_bps / 1000;
+	u32 htotal, vtotal;
+	u32 timing_fpsx100;
+
+	v4l2_dbg(1, hdcapm_debug, dev->sd,
+		 "%s(%p, %s)\n", __func__, dev, run == 1 ? "START" : "STOP");
+	if (run) {
+		if (!timings) {
+			v4l2_err(dev->sd, "no timing during firmware transition\n");
+			return -EINVAL;
+		}
+
+		/* Prepare the video/audio compression settings. */
+		i_width  = timings->bt.width;
+		i_height = timings->bt.height;
+		htotal   = V4L2_DV_BT_FRAME_WIDTH(&timings->bt);
+		vtotal   = V4L2_DV_BT_FRAME_HEIGHT(&timings->bt);
+		if (htotal * vtotal) {
+			timing_fpsx100 =
+				div_u64((100 * (u64)timings->bt.pixelclock),
+					(htotal * vtotal));
+		} else {
+			v4l2_err(dev->sd, "no fps calulated\n");
+			return -EINVAL;
+		}
+
+		i_fps = timing_fpsx100 / 100;
+
+		/* If the user has requested a different output
+		 * resolution via set/try fmt, obey.
+		 */
+		if (p->output_width)
+			o_width  = p->output_width;
+		else
+			o_width  = i_width;
+
+		if (p->output_width)
+			o_height = p->output_height;
+		else
+			o_height = i_height;
+
+		o_fps    = i_fps;
+
+		/* Scaling. Adjust width, height and output fps.
+		 * Hardware can't handle anything above p30, drop frames
+		 * from p60 to 30, p50 to 25.
+		 */
+
+		if (timings->bt.width == 1920 && timings->bt.height == 1080 &&
+		    !timings->bt.interlaced && i_fps > 30)
+			o_fps /= 2;
+
+		cfg[0] = 0x00000001;
+		cfg[1] = 0x21010019 |
+			(dev->encoder_parameters.h264_level << 12) |
+			(dev->encoder_parameters.h264_entropy_mode << 26) |
+			(dev->encoder_parameters.h264_profile << 8);
+
+		cfg[2] = i_height << 16 | i_width;
+		cfg[3] = o_fps << 23 | i_fps << 16 | 0x0609;
+		cfg[4] = 0x0050 << 16 | min_bitrate_kbps |
+			(dev->encoder_parameters.h264_mode << 31);
+		cfg[5] = max_bitrate_kbps << 16 | min_bitrate_kbps;
+		cfg[6] = 0x48002000;
+		cfg[7] = 0xe0010000 | dev->encoder_parameters.gop_size;
+		cfg[8] = o_height << 16 | o_width;
+		cfg[9] = 0xc00000d0;
+		cfg[10] = 0x21121080;
+		cfg[11] = 0x465001f2;
+
+		hdcapm_compressor_enable_firmware(dev, 1);
+
+		/* From LGP device dump line 27788 */
+		execute_cmd(dev, cmd_f1, CMD_ARRAY_SIZE(cmd_f1));
+		execute_cmd(dev, cmd_f2, CMD_ARRAY_SIZE(cmd_f2));
+
+		/* Configure the video / audio compressors. */
+		execute_cmd(dev, cmd_10_0f, CMD_ARRAY_SIZE(cmd_10_0f));
+		execute_cmd(dev, cmd_10_10, CMD_ARRAY_SIZE(cmd_10_10));
+		execute_cmd(dev, cmd_10_12, CMD_ARRAY_SIZE(cmd_10_12));
+		execute_cmd(dev, cmd_10_13, CMD_ARRAY_SIZE(cmd_10_13));
+		execute_cmd(dev, cmd_10_16, CMD_ARRAY_SIZE(cmd_10_16));
+		execute_cmd(dev, cmd_10_17, CMD_ARRAY_SIZE(cmd_10_17));
+		execute_cmd(dev, cmd_10_02, CMD_ARRAY_SIZE(cmd_10_02));
+
+		/* Configure and start encoder. */
+		execute_cmd(dev, cfg, CMD_ARRAY_SIZE(cfg));
+		execute_cmd(dev, cmd_0a, CMD_ARRAY_SIZE(cmd_0a));
+	} else {
+		/* Stop and disable encoder. */
+		execute_cmd(dev, cmd_02, CMD_ARRAY_SIZE(cmd_02));
+		execute_cmd(dev, cmd_f3, CMD_ARRAY_SIZE(cmd_f3));
+	}
+
+	return 0;
+}
+
+/* Perform a status read of the compressor. If TS data is available then
+ * query that and push the buffer into a user queue for later processing.
+ */
+static int usb_read(struct hdcapm_dev *dev)
+{
+	struct hdcapm_buffer *buf;
+	u32 val;
+	u32 arr[7];
+	u8 r[4];
+	int ret, i;
+	u32 bytes_to_read;
+
+	/* Query the Compressor regs 0x6b0-0x6c8.
+	 * Determine whether a buffer is ready for transfer.
+	 * Reg 6b0 (0): Status indicator?
+	 * Reg 6b4 (1): F1 always 0x83
+	 * Reg 6b8 (2): Transport buffer address (on host h/w)
+	 * Reg 6bc (3):
+	 * Reg 6c0 (4): Number of dwords
+	 * Reg 6c4 (5):
+	 * Reg 6c8 (6):
+	 * Line 55674 - LGPEncoder/complete-trace.tdc
+	 */
+
+	ret = hdcapm_read32_array(dev, REG_06B0, ARRAY_SIZE(arr), &arr[0], 1);
+	if (ret < 0) {
+		/* Failure to read from the device. */
+		return -EINVAL;
+	}
+
+	v4l2_dbg(3, hdcapm_debug, dev->sd,
+		 "tsb reply: %08x %08x %08x %08x %08x %08x %08x\n",
+		 arr[0], arr[1], arr[2], arr[3], arr[4], arr[5], arr[6]);
+
+	/* Check the reply */
+	if (arr[6] == 0) {
+		/* Buffer not yet ready. */
+		dev->stats->codec_ts_not_yet_ready++;
+		return -ETIMEDOUT;
+	}
+
+	/* Check this is a TS buffer */
+	if ((arr[0] & 0xff) != 0x40) {
+		/* Unexpected, debug this. */
+		v4l2_err(dev->sd,
+			 "tsb reply: %08x %08x %08x %08x %08x %08x %08x (No 0x40?)\n",
+			 arr[0], arr[1], arr[2], arr[3],
+			 arr[4], arr[5], arr[6]);
+		//WARN_ON();
+	}
+
+	/* Check this other fixed value. */
+	if ((arr[1] & 0xff) != 0x83) {
+		/* Unexpected, debug this. */
+		v4l2_err(dev->sd,
+			 "tsb reply: %08x %08x %08x %08x %08x %08x %08x (No 0x83?)\n",
+			 arr[0], arr[1], arr[2], arr[3],
+			 arr[4], arr[5], arr[6]);
+		WARN_ON(1);
+	}
+
+	bytes_to_read = arr[4] * sizeof(u32);
+	if (bytes_to_read > 256000) {
+		/* Unexpected, debug this. */
+		v4l2_err(dev->sd,
+			 "tsb reply: %08x %08x %08x %08x %08x %08x %08x (Too many dwords?)\n",
+			 arr[0], arr[1], arr[2], arr[3],
+			 arr[4], arr[5], arr[6]);
+		WARN_ON(1);
+	}
+
+	/* We need a buffer to transfer the TS into. */
+	buf = hdcapm_buffer_next_free(dev);
+	if (!buf)
+		return -EINVAL;
+
+	/* Transfer buffer from the USB device
+	 * (address arr[2]), length arr[4]).
+	 */
+	ret = hdcapm_dmaread32(dev, arr[2], (u32 *)buf->ptr, arr[4]);
+	if (ret < 0) {
+		/* Throw the buffer back in the free list. */
+		hdcapm_buffer_add_to_free(dev, buf);
+		return -EINVAL;
+	}
+
+	/* The buffer comes back in DWORD ordering, we need to fixup the
+	 * payload to put the TS packet bytes back into the right order.
+	 */
+	for (i = 0; i < bytes_to_read; i += 4) {
+		r[0] = *(buf->ptr + i + 3);
+		r[1] = *(buf->ptr + i + 2);
+		r[2] = *(buf->ptr + i + 1);
+		r[3] = *(buf->ptr + i + 0);
+
+		*(buf->ptr + i + 0) = r[0];
+		*(buf->ptr + i + 1) = r[1];
+		*(buf->ptr + i + 2) = r[2];
+		*(buf->ptr + i + 3) = r[3];
+	}
+
+	dev->stats->codec_bytes_received += bytes_to_read;
+	dev->stats->codec_buffers_received++;
+
+	/* Put the buffer on the used list,
+	 * the caller will read/dequeue it later.
+	 */
+	buf->actual_size = bytes_to_read;
+	buf->readpos = 0;
+	hdcapm_buffer_add_to_used(dev, buf);
+
+	/* Signal to any userland waiters, new buffer available. */
+	wake_up_interruptible(&dev->wait_read);
+
+	/* Acknowledge the buffer back to the firmware. */
+	hdcapm_read32(dev, 0x800, &val);
+	hdcapm_write32(dev, 0x800, val);
+
+	hdcapm_write32(dev, REG_FW_CMD_ARG(0), 0x83);
+	hdcapm_write32(dev, REG_FW_CMD_ARG(1), arr[4]);
+	hdcapm_write32(dev, REG_FW_CMD_ARG(2), 0x2aaaaaaa);
+	hdcapm_write32(dev, REG_FW_CMD_ARG(3), 0);
+	hdcapm_write32(dev, REG_FW_CMD_ARG(5), 0);
+	hdcapm_write32(dev, REG_FW_CMD_BUSY, 1);
+	hdcapm_write32(dev, REG_FW_CMD_EXECUTE, 0x30);
+
+	hdcapm_write32(dev, 0x6c8, 0);
+
+	return 0;
+}
+
+void hdcapm_compressor_init_gpios(struct hdcapm_dev *dev)
+{
+	// 38045 - bit toggling, gpios
+
+	/* Available GPIO's 15-0. */
+
+	/* Configure GPIO's 3-1, 8, 11, 12 as outputs. */
+	hdcapm_set32(dev, REG_GPIO_OE, 0x2);
+	hdcapm_set32(dev, REG_GPIO_OE, 0x4);
+	hdcapm_set32(dev, REG_GPIO_OE, 0x8);
+	hdcapm_set32(dev, REG_GPIO_OE, 0x100);
+	hdcapm_set32(dev, REG_GPIO_OE, 0x800);
+	hdcapm_set32(dev, REG_GPIO_OE, 0x1000);
+	/* Reg should end up at 190E */
+
+	/* Pull all GPIO's high. */
+	hdcapm_clr32(dev, REG_GPIO_DATA_WR, 0xFFFFFFFF);
+
+	/* GPIO #2 is the MST3367 reset, active high, */
+
+	/* TODO: is this register inverted,
+	 * meaning writes high result in low?
+	 */
+	hdcapm_set32(dev, REG_GPIO_DATA_WR, 0x00000004);
+
+	mdelay(500);
+}
+
+int hdcapm_compressor_register(struct hdcapm_dev *dev)
+{
+	const struct firmware *fw = NULL;
+	const char *fw_video = "v4l-hdcapm-vidfw-01.fw";
+	size_t fw_video_len = 453684;
+	const char *fw_audio = "v4l-hdcapm-audfw-01.fw";
+	size_t fw_audio_len = 363832;
+	u32 val;
+	u32 *dwords;
+	u32 addr;
+	u32 chunk;
+	u32 cpy;
+	u32 offset;
+	int ret;
+
+	hdcapm_compressor_enable_firmware(dev, 0);
+
+// pl330b_lib_reinit
+	hdcapm_write32(dev, REG_081C, 0x00004000);
+	hdcapm_write32(dev, REG_0820, 0x00103FFF);
+	hdcapm_write32(dev, REG_0824, 0x00000000);
+
+	hdcapm_write32(dev, REG_0828, 0x00104000);
+	hdcapm_write32(dev, REG_082C, 0x00203FFF);
+	hdcapm_write32(dev, REG_0830, 0x00100000);
+
+	hdcapm_write32(dev, REG_0834, 0x00204000);
+	hdcapm_write32(dev, REG_0838, 0x00303FFF);
+	hdcapm_write32(dev, REG_083C, 0x00200000);
+
+	hdcapm_write32(dev, REG_0840, 0x70003124);
+	hdcapm_write32(dev, REG_0840, 0x90003124);
+
+	/* Hardware ID? Only every read, never written */
+	if (hdcapm_read32(dev, REG_0038, &val) < 0) {
+		v4l2_err(dev->sd,
+			 "USB read failure, chip id check failed, aborting.\n");
+		return -EINVAL;
+	}
+	v4l2_dbg(1, hdcapm_debug, dev->sd,
+		 "chiprev? [%08x = %08x]\n", REG_0038, val);
+	WARN_ON(val != 0x00010020);
+
+#if ONETIME_FW_LOAD
+	hdcapm_write32(dev, REG_GPIO_OE, 0x00000000);
+	hdcapm_write32(dev, REG_GPIO_DATA_WR, 0x00000000);
+#endif
+
+	/* Disable audio / video outputs (bits 1/2). */
+	hdcapm_write32(dev, REG_0050, 0x00200400);
+	hdcapm_read32(dev, REG_0050, &val);
+
+	v4l2_dbg(1, hdcapm_debug, dev->sd, "%08x = %08x\n", REG_0050, val);
+	WARN_ON(val != 0x00200400);
+
+	/* Give the device enough time to boot its initial microcode. */
+	msleep(1000);
+
+	hdcapm_compressor_enable_firmware(dev, 0);
+
+	hdcapm_write32(dev, REG_FW_CMD_BUSY, 0x00000000);
+	hdcapm_write32(dev, REG_081C, 0x00004000);
+
+	hdcapm_write32(dev, REG_0820, 0x00103FFF);
+	hdcapm_write32(dev, REG_0824, 0x00000000);
+	hdcapm_write32(dev, REG_0828, 0x00104000);
+	hdcapm_write32(dev, REG_082C, 0x00203FFF);
+	hdcapm_write32(dev, REG_0830, 0x00100000);
+	hdcapm_write32(dev, REG_0834, 0x00204000);
+	hdcapm_write32(dev, REG_0838, 0x00303FFF);
+	hdcapm_write32(dev, REG_083C, 0x00200000);
+	hdcapm_write32(dev, REG_0840, 0x70003124);
+	hdcapm_write32(dev, REG_0840, 0x90003124);
+
+	hdcapm_write32(dev, REG_0050, 0x00200406);
+
+	hdcapm_write32(dev, REG_0050, 0x00200406);
+	hdcapm_read32(dev, REG_0050, &val);
+
+	/* Disable audio and video outputs. */
+	hdcapm_write32(dev, REG_0050, 0x00200406);
+
+#if ONETIME_FW_LOAD
+	hdcapm_write32(dev, REG_GPIO_OE, 0x00000000);
+	hdcapm_write32(dev, REG_GPIO_DATA_WR, 0x00000000);
+#endif
+
+	hdcapm_read32(dev, REG_0000, &val);
+	hdcapm_write32(dev, REG_0000, 0x03FF0300);
+
+	/* Wipe memory at various addresses */
+	dwords = kzalloc(0x2000 * sizeof(u32), GFP_KERNEL);
+	if (!dwords)
+		return -ENOMEM;
+
+	if (hdcapm_dmawrite32(dev, 0x0005634E, dwords, 0x2000) < 0) {
+		v4l2_err(dev->sd, "wipe of addr1 failed\n");
+		return -EINVAL;
+	}
+	if (hdcapm_dmawrite32(dev, 0x0005834E, dwords, 0x2000) < 0) {
+		v4l2_err(dev->sd, "wipe of addr2 failed\n");
+		return -EINVAL;
+	}
+	if (hdcapm_dmawrite32(dev, 0x0005A34E, dwords, 0x1E3B) < 0) {
+		v4l2_err(dev->sd, "wipe of addr3 failed\n");
+		return -EINVAL;
+	}
+	kfree(dwords);
+
+	/* Upload the audio firmware. */
+	ret = request_firmware(&fw, fw_audio, &dev->udev->dev);
+	if (ret) {
+		v4l2_err(dev->sd,
+			 "failed to find firmware file %s, aborting upload.\n",
+			 fw_video);
+		return -EINVAL;
+	}
+	if (fw->size != fw_audio_len) {
+		v4l2_err(dev->sd, "failed video firmware length check\n");
+		release_firmware(fw);
+		return -EINVAL;
+	}
+	v4l2_info(dev->sd, "loading audio firmware size %zu bytes.\n",
+		  fw->size);
+
+	offset = 0;
+	addr = 0x00040000;
+	val = fw_audio_len;
+	chunk = 0x2000 * sizeof(u32);
+	while (val > 0) {
+		if (val > chunk)
+			cpy = chunk;
+		else
+			cpy = val;
+
+		hdcapm_dmawrite32(dev, addr, (const u32 *)fw->data + offset,
+				  cpy / sizeof(u32));
+
+		val -= cpy;
+		addr += (cpy / sizeof(u32));
+		offset += (cpy / sizeof(u32));
+	}
+	release_firmware(fw);
+
+	hdcapm_mem_write32(dev, 0x000BC425, 1);
+	hdcapm_mem_write32(dev, 0x000BC424, 0);
+	hdcapm_mem_write32(dev, 0x000BC801, 0);
+
+	hdcapm_write32(dev, REG_0B78, 0x00150000);
+	hdcapm_write32(dev, REG_FW_CMD_BUSY, 0x00000000);
+
+	/* Upload the video firmware. */
+	ret = request_firmware(&fw, fw_video, &dev->udev->dev);
+	if (ret) {
+		v4l2_err(dev->sd,
+			 "failed to find firmware file %s, aborting upload.\n",
+			 fw_video);
+		return -EINVAL;
+	}
+	if (fw->size != fw_video_len) {
+		v4l2_err(dev->sd,
+			 "failed video firmware length check\n");
+		release_firmware(fw);
+		return -EINVAL;
+	}
+	v4l2_info(dev->sd, "loading video firmware size %zu bytes.\n",
+		  fw->size);
+
+	/* Load the video firmware */
+	offset = 0;
+	addr = 0x00000000;
+	val = fw_video_len;
+	chunk = 0x2000 * sizeof(u32);
+	while (val > 0) {
+		if (val > chunk)
+			cpy = chunk;
+		else
+			cpy = val;
+
+		hdcapm_dmawrite32(dev, addr, (const u32 *)fw->data + offset,
+				  cpy / sizeof(u32));
+
+		val -= cpy;
+		addr += (cpy / sizeof(u32));
+		offset += (cpy / sizeof(u32));
+	}
+	release_firmware(fw);
+
+	hdcapm_compressor_enable_firmware(dev, 1);
+	hdcapm_write32(dev, REG_FW_CMD_BUSY, 0x00000000);
+
+	hdcapm_mem_read32(dev, 0x00000040, &val);
+
+	hdcapm_mem_read32(dev, 0x00000041, &val);
+
+	hdcapm_mem_read32(dev, 0x000Bc804, &val);
+
+	msleep(100);
+
+#if ONETIME_FW_LOAD
+	hdcapm_compressor_init_gpios(dev);
+#endif
+
+	v4l2_info(dev->sd, "Registered compressor\n");
+	return 0;
+}
+
+void hdcapm_compressor_unregister(struct hdcapm_dev *dev)
+{
+	v4l2_dbg(1, hdcapm_debug, dev->sd,
+		 "%s() Unregistered compressor\n", __func__);
+}
+
+void hdcapm_compressor_run(struct hdcapm_dev *dev)
+{
+	struct v4l2_dv_timings timings;
+	int ret;
+	int val;
+
+	v4l2_dbg(1, hdcapm_debug, dev->sd, "%s()\n", __func__);
+
+	if (v4l2_subdev_call(dev->sd, video, g_dv_timings, &timings) < 0) {
+		v4l2_err(dev->sd, "%s() subdev call failed\n", __func__);
+		dev->state = STATE_STOPPED;
+		return;
+	}
+
+	/* Make sure all of our buffers are available again. */
+	hdcapm_buffers_move_all(dev, &dev->list_buf_free, &dev->list_buf_used);
+
+#if !(ONETIME_FW_LOAD)
+	/* Register the compression codec (it does both audio and video). */
+	if (hdcapm_compressor_register(dev) < 0) {
+		v4l2_err(dev->sd, "failed to register compressor\n");
+		return;
+	}
+#endif
+
+	/* Enable audio and video outputs. */
+	hdcapm_read32(dev, REG_0050, &val);
+	val &= ~(1 << 1);
+	val &= ~(1 << 2);
+	hdcapm_write32(dev, REG_0050, val);
+
+	ret = firmware_transition(dev, 1, &timings);
+
+	dev->state = STATE_STARTED;
+	while (dev->state == STATE_STARTED) {
+		ret = usb_read(dev);
+		usleep_range(500, 4000);
+	}
+
+	/* Disable audio and video outputs. */
+	hdcapm_read32(dev, REG_0050, &val);
+	val |= (1 << 1);
+	val |= (1 << 2);
+	hdcapm_write32(dev, REG_0050, val);
+
+	/* Give the device enough time to resume its microcode. */
+	msleep(1000);
+
+	ret = firmware_transition(dev, 0, NULL);
+
+#if !(ONETIME_FW_LOAD)
+	hdcapm_compressor_unregister(dev);
+	hdcapm_compressor_init_gpios(dev);
+
+	/* Reloading the firmware disturbs the GPIOs and
+	 * causes the MST3367 to go into reset.
+	 * Be kind, tell the HDMI receiver to
+	 * reconfigure itself.
+	 */
+	v4l2_subdev_call(dev->sd, core, s_power, 1);
+#endif
+
+	dev->state = STATE_STOPPED;
+
+	hdcapm_buffers_move_all(dev, &dev->list_buf_free, &dev->list_buf_used);
+}
diff --git a/drivers/media/usb/hdcapm/hdcapm-core.c b/drivers/media/usb/hdcapm/hdcapm-core.c
new file mode 100644
index 000000000000..68836d339b7d
--- /dev/null
+++ b/drivers/media/usb/hdcapm/hdcapm-core.c
@@ -0,0 +1,743 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Driver for the Startech USB2HDCAPM USB capture device
+ *
+ * Copyright (c) 2017 Steven Toth <stoth@kernellabs.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *
+ * GNU General Public License for more details.
+ */
+
+#include "hdcapm.h"
+#include <media/i2c/mst3367.h>
+
+int hdcapm_debug;
+module_param_named(debug, hdcapm_debug, int, 0644);
+MODULE_PARM_DESC(debug, "debug bitmask: 1) module");
+
+int hdcapm_i2c_scan;
+module_param_named(i2c_scan, hdcapm_i2c_scan, int, 0644);
+MODULE_PARM_DESC(i2c_scan, "Probe i2c bus for devices");
+
+unsigned int thread_poll_interval = 500;
+module_param(thread_poll_interval, int, 0644);
+MODULE_PARM_DESC(thread_poll_interval,
+		 "have the kernel thread poll every N ms (def:500)");
+
+unsigned int buffer_count = 128;
+module_param(buffer_count, int, 0644);
+MODULE_PARM_DESC(buffer_count, "# of buffers the driver should queue");
+
+#define XFERBUF_SIZE (65536 * 4)
+unsigned int buffer_size = XFERBUF_SIZE;
+module_param(buffer_size, int, 0644);
+MODULE_PARM_DESC(buffer_size, "size of each buffer in bytes");
+
+static DEFINE_MUTEX(devlist);
+LIST_HEAD(hdcapm_devlist);
+static unsigned int devlist_count;
+
+/* Copy an on-stack transfer buffer into a device context. Do this
+ * before we pass it to the USB subsystem, else ARM complains (once) in
+ * the USB controller about the location of the transfer. TODO: Review
+ * usage and optimize of the calls so that not all transfers need to be
+ * on stack.
+ */
+int hdcapm_core_ep_send(struct hdcapm_dev *dev, int endpoint,
+			u8 *buf, u32 len, u32 timeout)
+{
+	int writelength;
+
+	if (len > XFERBUF_SIZE) {
+		v4l2_err(dev->sd,
+			 "%s() buffer of %d bytes too large for transfer\n",
+			 __func__, len);
+		return -1;
+	}
+
+	memcpy(dev->xferbuf, buf, len);
+	dev->xferbuf_len = len;
+
+	/* Flush this to EP4 via a bulk write. */
+	return usb_bulk_msg(dev->udev, usb_sndbulkpipe(dev->udev, endpoint),
+			    dev->xferbuf, dev->xferbuf_len,
+			    &writelength, timeout);
+}
+
+/* Copy a transfer buffer from the device context back to an onstack location.
+ * TODO: Review usage and optimize of the calls so that not all
+ * transfers need to be on stack.
+ */
+int hdcapm_core_ep_recv(struct hdcapm_dev *dev, int endpoint,
+			u8 *buf, u32 len, u32 *actual, u32 timeout)
+{
+	int ret;
+
+	WARN_ON(len > XFERBUF_SIZE);
+
+	/* Bulk read */
+	ret = usb_bulk_msg(dev->udev, usb_rcvbulkpipe(dev->udev, endpoint),
+			   dev->xferbuf, len, &dev->xferbuf_len, timeout);
+
+	memcpy(buf, dev->xferbuf, dev->xferbuf_len);
+	*actual = dev->xferbuf_len;
+
+	return ret;
+}
+
+int hdcapm_mem_write32(struct hdcapm_dev *dev, u32 addr, u32 val)
+{
+	/* EP4 Host -> 02 01 04 00 01 C8 0B 00 01 C8 0B 00 00 00 00 00 */
+	u8 tx[] = {
+		0x02,
+		0x01, /* Write */
+		0x04,
+		0x00,
+		addr, /* This is really a fill function? */
+		addr >> 8,
+		addr >> 16,
+		addr >> 24,
+		addr,
+		addr >> 8,
+		addr >> 16,
+		addr >> 24,
+		val,
+		val >> 8,
+		val >> 16,
+		val >> 24,
+	};
+
+	v4l2_dbg(2, hdcapm_debug, dev->sd,
+		 "%s(0x%08x, 0x%08x)\n", __func__, addr, val);
+
+	if (hdcapm_core_ep_send(dev, PIPE_EP4, &tx[0], sizeof(tx), 500) < 0)
+		return -1;
+
+	return 0;
+}
+
+/* Read a single DWORD from the USB device memory. */
+int hdcapm_mem_read32(struct hdcapm_dev *dev, u32 addr, u32 *val)
+{
+	int len;
+	u8 rx[4];
+
+	/* Read bytes between to addresses
+	 * EP4 Host -> 02 00 04 00 01 C8 0B 00 01 C8 0B 00
+	 * EP3 Host <- 00 00 00 00
+	 */
+	u8 tx[] = {
+		0x02,
+		0x00, /* Read */
+		0x04,
+		0x00,
+		addr,
+		addr >> 8,
+		addr >> 16,
+		addr >> 24,
+		addr,
+		addr >> 8,
+		addr >> 16,
+		addr >> 24,
+	};
+
+	if (hdcapm_core_ep_send(dev, PIPE_EP4, &tx[0], sizeof(tx), 500) < 0)
+		return -1;
+
+	/* Read 4 bytes from EP 3. */
+	/* TODO: shouldn;t the buffer length be 4? */
+	if (hdcapm_core_ep_recv(dev,
+				PIPE_EP3, &rx[0], sizeof(rx), &len, 500) < 0)
+		return -1;
+
+	*val = rx[0] | (rx[1] << 8) | (rx[2] << 16) | (rx[3] << 24);
+	v4l2_dbg(2, hdcapm_debug, dev->sd,
+		 "%s(0x%08x, 0x%08x)\n", __func__, addr, *val);
+
+	return 0;
+}
+
+/* Write a series of DMA DWORDS from the USB device memory. */
+int hdcapm_dmawrite32(struct hdcapm_dev *dev, u32 addr,
+		      const u32 *arr, u32 entries)
+{
+	int len;
+	u8 rx;
+
+	/* EP4 Host -> 09 01 08 00 00 00 00 00 4E 63 05 00 00 20 00 00 */
+	u8 tx[] = {
+		0x09,
+		0x01, /* Write */
+		0x08,
+		0x00,
+		0x00,
+		0x00,
+		0x00,
+		0x00,
+		addr,
+		addr >> 8,
+		addr >> 16,
+		addr >> 24,
+		entries,
+		entries >> 8,
+		entries >> 16,
+		entries >> 24,
+	};
+
+	v4l2_dbg(2, hdcapm_debug, dev->sd,
+		 "%s(0x%08x, 0x%08x)\n", __func__, addr, entries);
+
+	if (hdcapm_core_ep_send(dev, PIPE_EP4, &tx[0], sizeof(tx), 500) < 0)
+		return -1;
+
+	/* Read 1 byte1 from EP 3. */
+	if (hdcapm_core_ep_recv(dev, PIPE_EP3, &rx, sizeof(rx), &len, 500) < 0)
+		return -1;
+
+	if (rx != 0)
+		return -1;
+
+	/* Flush the buffer to device */
+	if (hdcapm_core_ep_send(dev, PIPE_EP2, (u8 *)arr, entries * sizeof(u32),
+				5000) < 0)
+		return -1;
+
+	return 0;
+}
+
+/* Read a series of DMA DWORDS from the USB device memory. */
+int hdcapm_dmaread32(struct hdcapm_dev *dev, u32 addr, u32 *arr, u32 entries)
+{
+	int len;
+	u8 rx;
+
+	/* EP4 Host -> 09 00 08 00 00 00 00 00 00 C8 05 00 00 04 00 00 */
+	u8 tx[] = {
+		0x09,
+		0x00, /* Read */
+		0x08,
+		0x00,
+		0x00,
+		0x00,
+		0x00,
+		0x00,
+		addr,
+		addr >> 8,
+		addr >> 16,
+		addr >> 24,
+		entries,
+		entries >> 8,
+		entries >> 16,
+		entries >> 24,
+	};
+
+	v4l2_dbg(2, hdcapm_debug, dev->sd,
+		 "%s(0x%08x, 0x%08x)\n", __func__, addr, entries);
+
+	if (hdcapm_core_ep_send(dev, PIPE_EP4, &tx[0], sizeof(tx), 500) < 0)
+		return -1;
+
+	/* Read 1 byte1 from EP 3. */
+	if (hdcapm_core_ep_recv(dev, PIPE_EP3, &rx, sizeof(rx), &len, 500) < 0)
+		return -1;
+
+	if (rx != 0)
+		return -1;
+
+	/* Flush the buffer to device */
+	if (hdcapm_core_ep_recv(dev, PIPE_EP1, (u8 *)arr, entries * sizeof(u32),
+				&len, 5000) < 0)
+		return -1;
+
+	return 0;
+}
+
+/* Write a DWORD to a USB device register. */
+int hdcapm_write32(struct hdcapm_dev *dev, u32 addr, u32 val)
+{
+	/* EP4 Host -> 01 01 01 00 04 05 00 00 55 00 00 00 */
+	u8 tx[] = {
+		0x01,
+		0x01, /* Write */
+		0x01,
+		0x00,
+		addr,
+		addr >> 8,
+		addr >> 16,
+		addr >> 24,
+		val,
+		val >> 8,
+		val >> 16,
+		val >> 24,
+	};
+
+	v4l2_dbg(2, hdcapm_debug, dev->sd,
+		 "%s(0x%08x, 0x%08x)\n", __func__, addr, val);
+
+	if (hdcapm_core_ep_send(dev, PIPE_EP4, &tx[0], sizeof(tx), 500) < 0)
+		return -1;
+
+	return 0;
+}
+
+/* Read a DWORD from a USB device register. */
+int hdcapm_read32(struct hdcapm_dev *dev, u32 addr, u32 *val)
+{
+	int len;
+	u8 rx[4];
+
+	/* EP4 Host -> 01 00 01 00 00 05 00 00 */
+	u8 tx[] = {
+		0x01,
+		0x00, /* Read */
+		0x01,
+		0x00,
+		addr,
+		addr >> 8,
+		addr >> 16,
+		addr >> 24,
+	};
+
+	/* Flush this to EP4 via a write. */
+	if (hdcapm_core_ep_send(dev, PIPE_EP4, &tx[0], sizeof(tx), 500) < 0)
+		return -1;
+
+	/* Read 4 bytes from EP 3. */
+	if (hdcapm_core_ep_recv(dev, PIPE_EP3, &rx[0],
+				sizeof(rx), &len, 500) < 0)
+		return -1;
+
+	*val = rx[0] | (rx[1] << 8) | (rx[2] << 16) | (rx[3] << 24);
+
+	v4l2_dbg(2, hdcapm_debug, dev->sd,
+		 "%s(0x%08x, 0x%08x)\n", __func__, addr, *val);
+
+	return 0;
+}
+
+/* Read (bulk) a number of DWORDS from device registers and endian
+ * convert if requested.
+ */
+int hdcapm_read32_array(struct hdcapm_dev *dev, u32 addr,
+			u32 wordcount, u32 *arr, int le_to_cpu)
+{
+	int len, i, j;
+	int readlenbytes = wordcount * sizeof(u32);
+	u8 *rx;
+
+	/* EP4 Host -> 01 00 07 00 B0 06 00 00 */
+	u8 tx[] = {
+		0x01,
+		0x00, /* Read */
+		wordcount,
+		0x00,
+		addr,
+		addr >> 8,
+		addr >> 16,
+		addr >> 24,
+	};
+
+	rx = kzalloc(readlenbytes, GFP_KERNEL);
+	if (!rx)
+		return -ENOMEM;
+
+	/* Flush this to EP4 via a write. */
+	if (hdcapm_core_ep_send(dev, PIPE_EP4, &tx[0], sizeof(tx), 500) < 0) {
+		kfree(rx);
+		return -1;
+	}
+
+	/* Read 4 bytes from EP 3. */
+	if (hdcapm_core_ep_recv(dev, PIPE_EP3, rx, readlenbytes, &len, 500)
+	    < 0) {
+		kfree(rx);
+		return -1;
+	}
+
+	v4l2_dbg(2, hdcapm_debug, dev->sd, "%s(0x%08x) =\n", __func__, addr);
+
+	for (i = 0, j = 0; i < len; i += 4, j++) {
+		*(arr + j) = rx[i + 0] | (rx[i + 1] << 8) |
+		    (rx[i + 2] << 16) | (rx[i + 3] << 24);
+
+		if (le_to_cpu)
+			*(arr + j) = le32_to_cpu(*(arr + j));
+	}
+
+	kfree(rx);
+	return 0;
+}
+
+/* Set one or more bits high int a USB device register. */
+void hdcapm_set32(struct hdcapm_dev *dev, u32 addr, u32 mask)
+{
+	u32 val;
+
+	hdcapm_read32(dev, addr, &val);
+	val |= mask;
+	hdcapm_write32(dev, addr, val);
+}
+
+/* Set one or more bits low int a USB device register. */
+void hdcapm_clr32(struct hdcapm_dev *dev, u32 addr, u32 mask)
+{
+	u32 val;
+
+	hdcapm_read32(dev, addr, &val);
+	val &= ~mask;
+	hdcapm_write32(dev, addr, val);
+}
+
+int hdcapm_core_stop_streaming(struct hdcapm_dev *dev)
+{
+	dev->state = STATE_STOP;
+
+	return 0;
+}
+
+int hdcapm_core_start_streaming(struct hdcapm_dev *dev)
+{
+	dev->state = STATE_START;
+
+	return 0;
+}
+
+/* Worker thread to poll the HDMI receiver, and run the USB
+ * transfer mechanism when the encoder starts.
+ */
+static int hdcapm_thread_function(void *data)
+{
+	struct hdcapm_dev *dev = data;
+	struct v4l2_dv_timings timings;
+	int ret;
+
+	dev->thread_active = 1;
+	v4l2_dbg(1, hdcapm_debug, dev->sd, "%s() Started\n", __func__);
+
+	set_freezable();
+
+	while (1) {
+		msleep_interruptible(thread_poll_interval);
+
+		if (kthread_should_stop())
+			break;
+
+		try_to_freeze();
+
+		if (dev->state == STATE_STOPPED)
+			ret = v4l2_subdev_call(dev->sd,
+					       video, query_dv_timings,
+					       &timings);
+
+		if (dev->state == STATE_START)
+			hdcapm_compressor_run(dev); /* blocking */
+	}
+
+	dev->thread_active = 0;
+	return 0;
+}
+
+static void hdcapm_usb_v4l2_release(struct v4l2_device *v4l2_dev)
+{
+	struct hdcapm_dev *dev =
+	    container_of(v4l2_dev, struct hdcapm_dev, v4l2_dev);
+
+	v4l2_device_unregister_subdev(dev->sd);
+
+	// TODO: Do I need this?
+	//v4l2_ctrl_handler_free(&dev->v4l2_ctrl_hdl);
+
+	v4l2_device_unregister(&dev->v4l2_dev);
+}
+
+/* sub-device events are pushed with v4l2_subdev_notify() and
+ * v4l2_subdev_notify_enent(). They eventually make their way here.
+ * The bridge then forwards those events via v4l2_event_queue()
+ * to the v4l2_device, and so eventually they end up in userspace.
+ */
+static void hdcapm_notify(struct v4l2_subdev *sd,
+			  unsigned int notification, void *arg)
+{
+	struct hdcapm_dev *dev = container_of(sd->v4l2_dev,
+					      struct hdcapm_dev, v4l2_dev);
+	struct mst3367_source_detect *mst3367;
+
+	switch (notification) {
+	case MST3367_SOURCE_DETECT:
+		mst3367 = (struct mst3367_source_detect *)arg;
+		break;
+	case V4L2_DEVICE_NOTIFY_EVENT:
+		/*
+		 * Userspace can monitor for these with:
+		 * v4l2-ctl -d /dev/video2 --wait-for-event=source_change=0
+		 */
+		v4l2_event_queue(dev->v4l_device, arg);
+		break;
+	default:
+		v4l2_err(sd, "unhandled notification = 0x%x\n", notification);
+		break;
+	}
+}
+
+static int hdcapm_usb_probe(struct usb_interface *intf,
+			    const struct usb_device_id *id)
+{
+	struct hdcapm_dev *dev;
+	struct hdcapm_buffer *buf;
+	struct usb_device *udev;
+	struct i2c_board_info mst3367_info;
+	int ret, i;
+
+	udev = interface_to_usbdev(intf);
+
+	if (intf->altsetting->desc.bInterfaceNumber != 0)
+		return -ENODEV;
+
+	dev_dbg(&udev->dev,
+		"%s() vendor id 0x%x device id 0x%x\n", __func__,
+		le16_to_cpu(udev->descriptor.idVendor),
+		le16_to_cpu(udev->descriptor.idProduct));
+
+	/* Ensure the bus speed is 480Mbps. */
+	if (udev->speed != USB_SPEED_HIGH) {
+		dev_err(&intf->dev,
+			"Device must be connected to a USB 2.0 port (480Mbps).\n");
+		return -ENODEV;
+	}
+
+	dev = devm_kzalloc(&udev->dev, sizeof(*dev), GFP_KERNEL);
+	if (!dev)
+		return -ENOMEM;
+
+	dev->xferbuf = devm_kzalloc(&udev->dev, XFERBUF_SIZE, GFP_KERNEL);
+	if (!dev->xferbuf)
+		return -ENOMEM;
+
+	dev->stats = devm_kzalloc(&udev->dev, sizeof(struct hdcapm_statistics),
+				  GFP_KERNEL);
+	if (!dev->stats)
+		return -ENOMEM;
+
+	strlcpy(dev->name, "Startech HDCAPM Encoder", sizeof(dev->name));
+	dev->state = STATE_STOPPED;
+	dev->udev = udev;
+
+	mutex_init(&dev->lock);
+	mutex_init(&dev->dmaqueue_lock);
+	INIT_LIST_HEAD(&dev->list_buf_free);
+	INIT_LIST_HEAD(&dev->list_buf_used);
+	init_waitqueue_head(&dev->wait_read);
+	usb_set_intfdata(intf, dev);
+
+	/* Register the I2C buses. */
+	if (hdcapm_i2c_register(dev, &dev->i2cbus[0], 0) < 0) {
+		dev_err(&intf->dev, "failed to register i2cbus 0\n");
+		return -EINVAL;
+	}
+
+	/* We're not using bus#1, it has the eeprom on it. Remove this or leave
+	 * for future developers with future products?
+	 */
+	if (hdcapm_i2c_register(dev, &dev->i2cbus[1], 1) < 0) {
+		dev_err(&intf->dev, "failed to register i2cbus 1\n");
+		ret = -EINVAL;
+		goto fail3;
+	}
+#if ONETIME_FW_LOAD
+	/* Register the compression codec (it does both audio and video). */
+	if (hdcapm_compressor_register(dev) < 0) {
+		dev_err(&intf->dev, "failed to register compressor\n");
+		ret = -EINVAL;
+		goto fail4;
+	}
+#else
+	hdcapm_compressor_init_gpios(dev);
+#endif
+
+	/* Attach HDMI receiver */
+	ret = v4l2_device_register(&intf->dev, &dev->v4l2_dev);
+	if (ret < 0) {
+		dev_err(&intf->dev, "v4l2_device_register failed\n");
+		ret = -EINVAL;
+		goto fail5;
+	}
+
+	dev->v4l2_dev.release = hdcapm_usb_v4l2_release;
+	dev->v4l2_dev.notify = hdcapm_notify;
+
+	/* Configure a sub-device attachment for the HDMI receiver. */
+	memset(&mst3367_info, 0, sizeof(struct i2c_board_info));
+	strlcpy(mst3367_info.type, "mst3367", I2C_NAME_SIZE);
+
+	mst3367_info.addr = 0x9c >> 1;
+
+	dev->sd = v4l2_i2c_new_subdev_board(&dev->v4l2_dev,
+					    &dev->i2cbus[0].i2c_adap,
+					    &mst3367_info, NULL);
+	if (!dev->sd) {
+		dev_err(&intf->dev,
+			"failed to find or load a driver for the MST3367\n");
+		ret = -EINVAL;
+		goto fail6;
+	}
+
+	/* Power on the HDMI receiver, assuming it needs it. */
+	v4l2_subdev_call(dev->sd, core, s_power, 1);
+
+	/* We need some buffers to hold user payload. */
+	for (i = 0; i < buffer_count; i++) {
+		buf = hdcapm_buffer_alloc(dev, i, buffer_size);
+		if (!buf) {
+			dev_err(&intf->dev,
+				"failed to allocate a user buffer\n");
+			ret = -ENOMEM;
+			goto fail8;
+		}
+
+		mutex_lock(&dev->dmaqueue_lock);
+		list_add_tail(&buf->list, &dev->list_buf_free);
+		mutex_unlock(&dev->dmaqueue_lock);
+	}
+
+	/* Formally register the V4L2 interfaces. */
+	if (hdcapm_video_register(dev) < 0) {
+		dev_err(&intf->dev, "failed to register video device\n");
+		ret = -EINVAL;
+		goto fail8;
+	}
+
+	/* Bring up a kernel thread to manage the HDMI frontend and run
+	 * the data pump.
+	 */
+	dev->kthread = kthread_run(hdcapm_thread_function, dev, "hdcapm hdmi");
+	if (!dev->kthread) {
+		dev_err(&intf->dev, "failed to create hdmi kernel thread\n");
+		ret = -EINVAL;
+		goto fail9;
+	}
+
+	/* Finish the rest of the hardware configuration. */
+	mutex_lock(&devlist);
+	list_add_tail(&dev->devlist, &hdcapm_devlist);
+	devlist_count++;
+	mutex_unlock(&devlist);
+
+	dev_info(&intf->dev, "Registered device '%s'\n", dev->name);
+
+	return 0; /* Success */
+
+fail9:
+	hdcapm_video_unregister(dev);
+fail8:
+	/* Put all the buffers back on the free list, then dealloc them. */
+	hdcapm_buffers_move_all(dev, &dev->list_buf_free, &dev->list_buf_used);
+	hdcapm_buffers_free_all(dev, &dev->list_buf_free);
+fail6:
+	v4l2_device_unregister(&dev->v4l2_dev);
+fail5:
+#if ONETIME_FW_LOAD
+	hdcapm_compressor_unregister(dev);
+fail4:
+#endif
+	hdcapm_i2c_unregister(dev, &dev->i2cbus[1]);
+fail3:
+	hdcapm_i2c_unregister(dev, &dev->i2cbus[0]);
+
+	return ret;
+}
+
+static void hdcapm_usb_disconnect(struct usb_interface *intf)
+{
+	struct hdcapm_dev *dev = usb_get_intfdata(intf);
+	int i;
+
+	v4l2_dbg(1, hdcapm_debug, dev->sd, "%s()\n", __func__);
+
+	if (dev->kthread) {
+		kthread_stop(dev->kthread);
+		dev->kthread = NULL;
+
+		i = 0;
+		while (dev->thread_active) {
+			msleep(500);
+			if (i++ > 24)
+				break;
+		}
+	}
+
+	hdcapm_video_unregister(dev);
+
+#if ONETIME_FW_LOAD
+	/* Unregister the compression codec. */
+	hdcapm_compressor_unregister(dev);
+#endif
+
+	/* Unregister any I2C buses. */
+	hdcapm_i2c_unregister(dev, &dev->i2cbus[1]);
+	hdcapm_i2c_unregister(dev, &dev->i2cbus[0]);
+
+	/* Put all the buffers back on the free list, the dealloc them. */
+	hdcapm_buffers_move_all(dev, &dev->list_buf_free, &dev->list_buf_used);
+	hdcapm_buffers_free_all(dev, &dev->list_buf_free);
+
+	mutex_lock(&devlist);
+	list_del(&dev->devlist);
+	mutex_unlock(&devlist);
+}
+
+static int hdcapm_suspend(struct usb_interface *intf, pm_message_t message)
+{
+	struct hdcapm_dev *dev = usb_get_intfdata(intf);
+
+	if (!dev)
+		return 0;
+
+	/* TODO: Power off the HDMI receiver? */
+
+	pr_info(KBUILD_MODNAME ": USB is suspend\n");
+
+	return 0;
+}
+
+static int hdcapm_resume(struct usb_interface *intf)
+{
+	struct hdcapm_dev *dev = usb_get_intfdata(intf);
+
+	if (!dev)
+		return 0;
+
+	/* TODO: Power on the HDMI receiver? */
+
+	return 0;
+}
+
+struct usb_device_id hdcapm_usb_id_table[] = {
+	{ USB_DEVICE(0x1164, 0x75a7), .driver_info = HDCAPM_CARD_REV1 },
+	{ /* -- end -- */ },
+};
+MODULE_DEVICE_TABLE(usb, hdcapm_usb_id_table);
+
+static struct usb_driver hdcapm_usb_driver = {
+	.name		= KBUILD_MODNAME,
+	.probe		= hdcapm_usb_probe,
+	.disconnect	= hdcapm_usb_disconnect,
+	.id_table	= hdcapm_usb_id_table,
+	.suspend	= hdcapm_suspend,
+	.resume		= hdcapm_resume,
+	.reset_resume	= hdcapm_resume,
+};
+
+module_usb_driver(hdcapm_usb_driver);
+
+MODULE_DESCRIPTION("Driver for StarTech USB2HDCAPM USB capture product");
+MODULE_AUTHOR("Steven Toth <stoth@kernellabs.com>");
+MODULE_LICENSE("GPL");
+MODULE_VERSION("0.0.1");
diff --git a/drivers/media/usb/hdcapm/hdcapm-i2c.c b/drivers/media/usb/hdcapm/hdcapm-i2c.c
new file mode 100644
index 000000000000..6ef74459948b
--- /dev/null
+++ b/drivers/media/usb/hdcapm/hdcapm-i2c.c
@@ -0,0 +1,332 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Driver for the Startech USB2HDCAPM USB capture device
+ *
+ * Copyright (c) 2017 Steven Toth <stoth@kernellabs.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *
+ * GNU General Public License for more details.
+ */
+
+#include "hdcapm.h"
+
+#define GPIO_SCL BIT(14)
+#define GPIO_SDA BIT(15)
+
+static unsigned int i2c_udelay = 5;
+module_param(i2c_udelay, int, 0644);
+MODULE_PARM_DESC(i2c_udelay,
+		 "i2c delay at insmod time, in usecs (should be 5 or higher). Lower value means higher bus speed.");
+
+/* GPIO bit-banged bus */
+static void hdcapm_bit_setscl(void *data, int state)
+{
+	struct hdcapm_i2c_bus *bus = data;
+	struct hdcapm_dev *dev = bus->dev;
+
+	if (state)
+		hdcapm_clr32(dev, REG_GPIO_OE, GPIO_SCL);
+	else
+		hdcapm_set32(dev, REG_GPIO_OE, GPIO_SCL);
+}
+
+static void hdcapm_bit_setsda(void *data, int state)
+{
+	struct hdcapm_i2c_bus *bus = data;
+	struct hdcapm_dev *dev = bus->dev;
+
+	if (state)
+		hdcapm_clr32(dev, REG_GPIO_OE, GPIO_SDA);
+	else
+		hdcapm_set32(dev, REG_GPIO_OE, GPIO_SDA);
+}
+
+static int hdcapm_bit_getscl(void *data)
+{
+	struct hdcapm_i2c_bus *bus = data;
+	struct hdcapm_dev *dev = bus->dev;
+	u32 val;
+
+	hdcapm_read32(dev, REG_GPIO_DATA_RD, &val);
+
+	return val & GPIO_SCL ? 1 : 0;
+}
+
+static int hdcapm_bit_getsda(void *data)
+{
+	struct hdcapm_i2c_bus *bus = data;
+	struct hdcapm_dev *dev = bus->dev;
+	u32 val;
+
+	hdcapm_read32(dev, REG_GPIO_DATA_RD, &val);
+
+	return val & GPIO_SDA ? 1 : 0;
+}
+
+/* ----------------------------------------------------------------------- */
+
+static const struct i2c_algo_bit_data hdcapm_i2c1_algo_template = {
+	.setsda  = hdcapm_bit_setsda,
+	.setscl  = hdcapm_bit_setscl,
+	.getsda  = hdcapm_bit_getsda,
+	.getscl  = hdcapm_bit_getscl,
+	.udelay  = 16,
+	.timeout = 200,
+};
+
+/* Internal I2C Bus */
+static int i2c_writeread(struct i2c_adapter *i2c_adap,
+			 const struct i2c_msg *msg, int joined_rlen)
+{
+/*
+ * EP4 Host -> 01 01 01 00 04 05 00 00 55 00 00 00
+ *		- usbwrite(REG_504, 0x55)
+ * EP4 Host -> 01 01 01 00 00 05 00 00 09 27 00 80
+ *		- usbwrite(REG_500, 0x80002709);
+ * EP4 Host -> 01 00 01 00 00 05 00 00
+ * EP3 Host <- 09 27 00 00
+ *		- 2709 = usbread(REG_0500);
+ * EP4 Host -> 01 00 01 00 0c 05 00 00
+ * EP3 Host <- 03 00 00 00
+ *		- 03 = usbread(REG_050c);
+ */
+	struct hdcapm_i2c_bus *bus = i2c_adap->algo_data;
+	struct hdcapm_dev *dev = bus->dev;
+	struct i2c_msg *nextmsg = (struct i2c_msg *)(msg + 1);
+	u32 val;
+	int ret;
+	int safety = 32;
+
+	v4l2_dbg(2, hdcapm_debug, dev->sd,
+		 "%s(addr=0x%x, reg=0x%x, len=%d)\n", __func__,
+		 msg->addr, msg->buf[0], msg->len);
+
+	ret = hdcapm_write32(dev, REG_I2C_W_BUF, msg->buf[0]);
+
+	/* Write one and read one byte? */
+	val  = (1 << 31);
+	val |= 9;
+	val |= (msg->addr << 7);
+	ret = hdcapm_write32(dev, REG_I2C_XACT, val);
+
+	/* I2C engine busy? */
+	val = (1 << 31);
+	while (val & 0x80000000) {
+		/* Check bit31 has cleared? */
+		ret = hdcapm_read32(dev, REG_I2C_XACT, &val);
+		if (safety-- == 0)
+			break;
+	}
+	if (safety == 0) {
+		v4l2_err(dev->sd, ": stuck i2c bit, aborting.\n");
+		return 0;
+	}
+
+	/* Read i2c result */
+	ret = hdcapm_read32(dev, REG_I2C_R_BUF, &val);
+	nextmsg->buf[0] = val & 0x000000ff;
+
+	v4l2_dbg(2, hdcapm_debug, dev->sd,
+		 "%s(addr=0x%x, reg = 0x%x) = 0x%02x\n", __func__,
+		 msg->addr, msg->buf[0], nextmsg->buf[0]);
+	return 1;
+}
+
+static int i2c_write(struct i2c_adapter *i2c_adap, const struct i2c_msg *msg,
+		     int joined)
+{
+	struct hdcapm_i2c_bus *bus = i2c_adap->algo_data;
+	struct hdcapm_dev *dev = bus->dev;
+	u32 val;
+	int ret, i;
+
+	/* Position each data byte into the u32, for a single strobe
+	 * into the write buffer.
+	 */
+	val = 0;
+	for (i = msg->len; i > 0; i--) {
+		val <<= 8;
+		val |= msg->buf[i - 1];
+	}
+
+	ret = hdcapm_write32(dev, REG_I2C_W_BUF, val);
+
+	/* Write N bytes, no read */
+	val  = (1 << 31);
+	val |= msg->len;
+	val |= (msg->addr << 7);
+	ret = hdcapm_write32(dev, REG_I2C_XACT, val);
+
+	return 1;
+}
+
+static int i2c_xfer(struct i2c_adapter *i2c_adap,
+		    struct i2c_msg *msgs, int num)
+{
+	struct hdcapm_i2c_bus *bus = i2c_adap->algo_data;
+	struct hdcapm_dev *dev = bus->dev;
+	int ret = 0;
+	int i;
+
+	v4l2_dbg(2, hdcapm_debug, dev->sd,
+		 "%s(num = %d)\n", __func__, num);
+
+	for (i = 0; i < num; i++) {
+		v4l2_dbg(4, hdcapm_debug, dev->sd,
+			 "%s(num = %d) addr = 0x%02x  len = 0x%x\n",
+			 __func__, num, msgs[i].addr, msgs[i].len);
+		if (msgs[i].flags & I2C_M_RD) {
+			/* do nothing */
+		} else if (i + 1 < num && (msgs[i + 1].flags & I2C_M_RD) &&
+			   msgs[i].addr == msgs[i + 1].addr) {
+			/* write then read from same address */
+			ret = i2c_writeread(i2c_adap, &msgs[i],
+					    msgs[i + 1].len);
+			if (ret < 0)
+				goto error;
+			i++;
+
+		} else {
+			/* Write */
+			ret = i2c_write(i2c_adap, &msgs[i], 0);
+		}
+		if (ret < 0)
+			goto error;
+	}
+	return num;
+
+error:
+	return ret;
+}
+
+static u32 hdcapm0_functionality(struct i2c_adapter *adap)
+{
+	return I2C_FUNC_SMBUS_BYTE_DATA;
+}
+
+static const struct i2c_algorithm hdcapm_i2c0_algo_template = {
+	.master_xfer	= i2c_xfer,
+	.functionality	= hdcapm0_functionality,
+};
+
+static const struct i2c_adapter hdcapm_i2c0_adap_template = {
+	.name		= "hdcapm internal",
+	.owner		= THIS_MODULE,
+	.algo		= &hdcapm_i2c0_algo_template,
+};
+
+static struct i2c_client hdcapm_i2c0_client_template = {
+	.name	= "hdcapm internal",
+};
+
+static int i2c_readreg8(struct hdcapm_i2c_bus *bus, u8 addr, u8 reg, u8 *val)
+{
+	int ret;
+	u8 b0[] = { reg };
+	u8 b1[] = { 0 };
+
+	struct i2c_msg msg[] = {
+		{ .addr = addr, .flags = 0, .buf = b0, .len = 1 },
+		{ .addr = addr, .flags = I2C_M_RD, .buf = b1, .len = 1 } };
+
+	ret = i2c_transfer(&bus->i2c_adap, msg, 2);
+	if (ret != 2)
+		return 0;
+
+	*val = b1[0];
+
+	return 2;
+}
+
+static char *i2c_devs[128] = {
+	[0x66 >> 1] = "MST3367?",
+	[0x88 >> 1] = "MST3367?",
+	[0x94 >> 1] = "MST3367?",
+	[0x9c >> 1] = "MST3367?",
+	[0xa2 >> 1] = "EEPROM",
+};
+
+static void do_i2c_scan(struct hdcapm_i2c_bus *bus)
+{
+	struct hdcapm_dev *dev = bus->dev;
+	int a, ret;
+	u8 val;
+
+	for (a = 0; a < 128; a++) {
+		ret = i2c_readreg8(bus, a, 0x00, &val);
+		if (ret == 2) {
+			v4l2_info(dev->sd,
+				  "%s: i2c scan: found device @ 0x%x  [%s]\n",
+				  __func__, a << 1,
+				  i2c_devs[a] ? i2c_devs[a] : "???");
+		}
+	}
+}
+
+int hdcapm_i2c_register(struct hdcapm_dev *dev,
+			struct hdcapm_i2c_bus *bus, int nr)
+{
+	bus->nr = nr;
+	bus->dev = dev;
+
+	v4l2_dbg(1, hdcapm_debug, dev->sd,
+		 "%s() registering I2C Bus#%d\n", __func__, bus->nr);
+
+	if (bus->nr == 0) {
+		bus->i2c_adap = hdcapm_i2c0_adap_template;
+		bus->i2c_client = hdcapm_i2c0_client_template;
+
+		bus->i2c_adap.dev.parent = &dev->udev->dev;
+		strlcpy(bus->i2c_adap.name, KBUILD_MODNAME,
+			sizeof(bus->i2c_adap.name));
+
+		bus->i2c_adap.algo_data = bus;
+		i2c_set_adapdata(&bus->i2c_adap, bus);
+		i2c_add_adapter(&bus->i2c_adap);
+
+		bus->i2c_client.adapter = &bus->i2c_adap;
+
+	} else if (bus->nr == 1) {
+		bus->i2c_algo = hdcapm_i2c1_algo_template;
+
+		bus->i2c_adap.dev.parent = &dev->udev->dev;
+		strlcpy(bus->i2c_adap.name, KBUILD_MODNAME,
+			sizeof(bus->i2c_adap.name));
+		bus->i2c_adap.owner = THIS_MODULE;
+		bus->i2c_algo.udelay = i2c_udelay;
+		bus->i2c_algo.data = bus;
+		i2c_set_adapdata(&bus->i2c_adap, bus);
+		bus->i2c_adap.algo_data = &bus->i2c_algo;
+		bus->i2c_client.adapter = &bus->i2c_adap;
+		strlcpy(bus->i2c_client.name, "hdcapm gpio", I2C_NAME_SIZE);
+
+		hdcapm_bit_setscl(bus, 1);
+		hdcapm_bit_setsda(bus, 1);
+
+		i2c_bit_add_bus(&bus->i2c_adap);
+
+	} else {
+		WARN_ON(1);
+	}
+
+	if (hdcapm_i2c_scan && bus->nr == 1)
+		do_i2c_scan(bus);
+
+	return 0;
+}
+
+void hdcapm_i2c_unregister(struct hdcapm_dev *dev, struct hdcapm_i2c_bus *bus)
+{
+	v4l2_dbg(1, hdcapm_debug, dev->sd,
+		 "%s() unregistering I2C Bus#%d\n", __func__, bus->nr);
+
+	i2c_del_adapter(&bus->i2c_adap);
+}
diff --git a/drivers/media/usb/hdcapm/hdcapm-reg.h b/drivers/media/usb/hdcapm/hdcapm-reg.h
new file mode 100644
index 000000000000..8f8487840ac5
--- /dev/null
+++ b/drivers/media/usb/hdcapm/hdcapm-reg.h
@@ -0,0 +1,111 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/*
+ * Driver for the Startech USB2HDCAPM USB capture device
+ *
+ * Copyright (c) 2017 Steven Toth <stoth@kernellabs.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *
+ * GNU General Public License for more details.
+ */
+
+/*
+ * idle-no-hdmi-connected.tdc -- Nothing else of consequence in the
+ * file. It's worth noting that when you run the graphedit tool under
+ * windows, open up the Analog Capture property page, switch to the
+ * Driver Properties view, and enable "PRINT DEBUG" option, debug view
+ * shows the following driver activity:
+ * "MST3367_HDMI_MODE_DETECT(0x55 = 0x03)".
+ *
+ * Record 4:
+ *
+ * EP4 Host -> 01 01 01 00 04 05 00 00 55 00 00 00
+ *		- usbwrite(REG_504, 0x55)
+ * EP4 Host -> 01 01 01 00 00 05 00 00 09 27 00 80
+ *		- usbwrite(REG_500, 0x80002709);
+ * EP4 Host -> 01 00 01 00 00 05 00 00
+ * EP3 Host <- 09 27 00 00
+ *		- 2709 = usbread(REG_0500);
+ * EP4 Host -> 01 00 01 00 0c 05 00 00
+ * EP3 Host <- 03 00 00 00
+ *		- 03 = usbread(REG_050c);
+ *
+ * In light of the debug view findings, I conclude:
+ * Writes to 504 establist a I2C write to device 0x55.
+ * Writes to 500 are...... what?
+ * reads for 50c are reads from the i2c bus answer.
+ *
+ * 80 00 27 09 =
+ * 1000 0000 | 0000 0000 | 0010 0111 | 0000 1001
+ *
+ * 001 = 1     rx/tx length?
+ * 001 = 1
+ * 01001110 = 0x4e  device address or register of MST3367?
+ * 10011100 = 0x9c  device address or register of MST3367?
+ *		.... tv  schematic suggests this is likely correct.
+ *
+ */
+
+/* Bit 13: Cleared during initialization, stall h/w
+ */
+#define REG_0000 0x000
+
+/* Register is read but never written to.
+ * Hardware version / chip id?
+ */
+#define REG_0038 0x038
+
+/* Bit 0,3-7: Unknown
+ *     1: Low when audio output is required, high when disabled.
+ *     2: Low when video output is required, high when disabled.
+ */
+#define REG_0050 0x050
+
+#define REG_I2C_XACT  0x500
+#define REG_I2C_W_BUF 0x504
+#define REG_I2C_R_BUF 0x50c
+
+/* driver-install.csv shows toggling of register between values:
+ *      Bits 15..           .. 0
+ * 19 0E  -- 0001 1001 0000 1110
+ * 59 0E  -- 0101 1001 0000 1110
+ * 99 0E  -- 1001 1001 0000 1110
+ * D9 0E  -- 1101 1001 0000 1110
+ * Suggesting bits 15/14 are a bitbanged I2C bus.
+ * We'll assume 15: SDA, 14: SCL
+ */
+#define REG_GPIO_OE      0x610
+#define REG_GPIO_DATA_WR 0x614
+#define REG_GPIO_DATA_RD 0x618
+
+#define REG_06B0  0x6b0
+
+#define REG_FW_CMD_BUSY  0x6cc
+
+/* Valid args are 0 - 10 */
+#define REG_FW_CMD_ARG(n) (0x6f8 - ((n) * 4))
+
+/* A command 'type' or identifier is written to this register,
+ * after the type specifics args have already been written.
+ */
+#define REG_FW_CMD_EXECUTE 0x6fc
+
+#define REG_081C 0x81c
+#define REG_0820 0x820
+#define REG_0824 0x824
+#define REG_0828 0x828
+#define REG_082C 0x82c
+#define REG_0830 0x830
+#define REG_0834 0x834
+#define REG_0838 0x838
+#define REG_083C 0x83c
+#define REG_0840 0x840
+
+#define REG_0B78 0xb78
diff --git a/drivers/media/usb/hdcapm/hdcapm-video.c b/drivers/media/usb/hdcapm/hdcapm-video.c
new file mode 100644
index 000000000000..47d19361f54a
--- /dev/null
+++ b/drivers/media/usb/hdcapm/hdcapm-video.c
@@ -0,0 +1,665 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Driver for the Startech USB2HDCAPM USB capture device
+ *
+ * Copyright (c) 2017 Steven Toth <stoth@kernellabs.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *
+ * GNU General Public License for more details.
+ */
+
+#include "hdcapm.h"
+
+#define ENCODER_MIN_BITRATE  2000000
+#define ENCODER_MAX_BITRATE 20000000
+#define ENCODER_DEF_BITRATE ENCODER_MAX_BITRATE
+
+#define ENCODER_MIN_GOP_SIZE  1
+#define ENCODER_MAX_GOP_SIZE 60
+#define ENCODER_DEF_GOP_SIZE ENCODER_MAX_GOP_SIZE
+
+static int s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct hdcapm_dev *dev = container_of(ctrl->handler,
+					      struct hdcapm_dev, ctrl_handler);
+	struct hdcapm_encoder_parameters *p = &dev->encoder_parameters;
+	int ret = 0;
+
+	switch (ctrl->id) {
+	case V4L2_CID_MPEG_AUDIO_MUTE:
+		v4l2_dbg(1, hdcapm_debug, dev->sd,
+			 "%s(V4L2_CID_MPEG_AUDIO_MUTE) = %d\n",
+			 __func__, ctrl->val);
+		p->audio_mute = ctrl->val;
+		break;
+	case V4L2_CID_BRIGHTNESS:
+		v4l2_dbg(1, hdcapm_debug, dev->sd,
+			 "%s(V4L2_CID_BRIGHTNESS) = %d\n", __func__, ctrl->val);
+		p->brightness = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_BITRATE:
+		v4l2_dbg(1, hdcapm_debug, dev->sd,
+			 "%s(V4L2_CID_MPEG_VIDEO_BITRATE) = %d\n",
+			 __func__, ctrl->val);
+		p->bitrate_bps = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_BITRATE_PEAK:
+		v4l2_dbg(1, hdcapm_debug, dev->sd,
+			 "%s(V4L2_CID_MPEG_BITRATE_PEAK) = %d\n",
+			 __func__, ctrl->val);
+		p->bitrate_peak_bps = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_BITRATE_MODE:
+		switch (ctrl->val) {
+		case V4L2_MPEG_VIDEO_BITRATE_MODE_VBR:
+			p->h264_mode = 1;
+			break;
+		case V4L2_MPEG_VIDEO_BITRATE_MODE_CBR:
+			p->h264_mode = 0;
+			break;
+		default:
+			v4l2_err(dev->sd,
+				 "failed to handle ctrl->id 0x%x, value = %d\n",
+				 ctrl->id, ctrl->val);
+			ret = -EINVAL;
+		}
+		v4l2_dbg(1, hdcapm_debug, dev->sd,
+			 "%s(V4L2_CID_MPEG_VIDEO_BITRATE_MODE) = %d\n",
+			 __func__, ctrl->val);
+		break;
+	case V4L2_CID_MPEG_VIDEO_GOP_SIZE:
+		v4l2_dbg(1, hdcapm_debug, dev->sd,
+			 "%s(V4L2_CID_MPEG_VIDEO_GOP_SIZE) = %d\n",
+			 __func__, ctrl->val);
+		p->gop_size = ctrl->val;
+
+		/* If we're in VBR mode GOP 1 looks bad,
+		 * force a change to CBR.
+		 */
+		if (p->gop_size == 1 && p->h264_mode == 1) {
+			v4l2_info(dev->sd,
+				  "GOP size 1 produces poor quality, switching from VBR to CBR\n");
+			p->h264_mode = 0;
+		}
+		break;
+	case V4L2_CID_MPEG_VIDEO_H264_LEVEL:
+		if (ctrl->val > V4L2_MPEG_VIDEO_H264_LEVEL_5_1) {
+			v4l2_err(dev->sd,
+				 "failed to handle ctrl->id 0x%x, value = %d\n",
+				 ctrl->id, ctrl->val);
+			ret = -EINVAL;
+		}
+		p->h264_level = ctrl->val;
+		v4l2_dbg(1, hdcapm_debug, dev->sd,
+			 "%s(V4L2_CID_MPEG_VIDEO_H264_LEVEL) = %d\n",
+			 __func__, ctrl->val);
+		break;
+	case V4L2_CID_MPEG_VIDEO_H264_ENTROPY_MODE:
+		switch (ctrl->val) {
+		case V4L2_MPEG_VIDEO_H264_ENTROPY_MODE_CABAC:
+			p->h264_entropy_mode = 1;
+			break;
+		case V4L2_MPEG_VIDEO_H264_ENTROPY_MODE_CAVLC:
+			p->h264_entropy_mode = 0;
+			break;
+		default:
+			v4l2_err(dev->sd,
+				 "failed to handle ctrl->id 0x%x, value = %d\n",
+				 ctrl->id, ctrl->val);
+			ret = -EINVAL;
+		}
+		v4l2_dbg(1, hdcapm_debug, dev->sd,
+			 "%s(V4L2_CID_MPEG_VIDEO_H264_ENTROPY_MODE) = %d\n",
+			 __func__, ctrl->val);
+		break;
+	case V4L2_CID_MPEG_VIDEO_H264_PROFILE:
+		switch (ctrl->val) {
+		case V4L2_MPEG_VIDEO_H264_PROFILE_BASELINE:
+			p->h264_profile = 0;
+			break;
+		case V4L2_MPEG_VIDEO_H264_PROFILE_MAIN:
+			p->h264_profile = 1;
+			break;
+		case V4L2_MPEG_VIDEO_H264_PROFILE_HIGH:
+			p->h264_profile = 2;
+			break;
+		default:
+			v4l2_err(dev->sd,
+				 "failed to handle ctrl->id 0x%x, value = %d\n",
+				 ctrl->id, ctrl->val);
+			ret = -EINVAL;
+		}
+		v4l2_dbg(1, hdcapm_debug, dev->sd,
+			 "%s(V4L2_CID_MPEG_VIDEO_H264_PROFILE) = %d\n",
+			 __func__, ctrl->val);
+		break;
+	case V4L2_CID_MPEG_STREAM_TYPE:
+		v4l2_dbg(1, hdcapm_debug, dev->sd,
+			 "%s(V4L2_CID_MPEG_STREAM_TYPE) = %d\n",
+			 __func__, ctrl->val);
+		break;
+	default:
+		v4l2_err(dev->sd,
+			 "failed to handle ctrl->id 0x%x, value = %d\n",
+			 ctrl->id, ctrl->val);
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+static const struct v4l2_ctrl_ops ctrl_ops = {
+	.s_ctrl = s_ctrl,
+};
+
+static int vidioc_enum_input(struct file *file, void *priv_fh,
+			     struct v4l2_input *i)
+{
+	struct hdcapm_fh *fh = file->private_data;
+	struct hdcapm_dev *dev = fh->dev;
+
+	if (i->index > 0)
+		return -EINVAL;
+
+	snprintf(i->name, sizeof(i->name), "HDMI / DVI");
+	i->type = V4L2_INPUT_TYPE_CAMERA;
+	i->capabilities = V4L2_IN_CAP_DV_TIMINGS;
+
+	return v4l2_subdev_call(dev->sd, video, g_input_status, &i->status);
+}
+
+static int vidioc_querycap(struct file *file, void *priv,
+			   struct v4l2_capability *cap)
+{
+	struct hdcapm_fh *fh = file->private_data;
+	struct hdcapm_dev *dev = fh->dev;
+
+	strcpy(cap->driver, KBUILD_MODNAME);
+	strlcpy(cap->card, dev->name, sizeof(cap->card));
+	usb_make_path(dev->udev, cap->bus_info, sizeof(cap->bus_info));
+
+	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_READWRITE;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
+
+	return 0;
+}
+
+static int vidioc_log_status(struct file *file, void *priv)
+{
+	struct hdcapm_fh *fh = file->private_data;
+	struct hdcapm_dev *dev = fh->dev;
+	struct hdcapm_statistics *s = dev->stats;
+	u64 q_used_bytes, q_used_items;
+	struct hdcapm_encoder_parameters *p = &dev->encoder_parameters;
+
+	v4l2_info(dev->sd, "device_state:           %s\n",
+		  dev->state == STATE_START ? "START" :
+		  dev->state == STATE_STARTED ? "STARTED" :
+		  dev->state == STATE_STOP ? "STOP" :
+		  dev->state == STATE_STOPPED ? "STOPPED" : "UNDEFINED");
+
+	v4l2_info(dev->sd, "device_context:         0x%p\n", dev);
+	v4l2_info(dev->sd, "codec_buffers_received: %llu\n",
+		  s->codec_buffers_received);
+	v4l2_info(dev->sd, "codec_bytes_received:   %llu\n",
+		  s->codec_bytes_received);
+	v4l2_info(dev->sd, "codec_ts_not_yet_ready: %llu\n",
+		  s->codec_ts_not_yet_ready);
+	v4l2_info(dev->sd, "buffer_overrun:         %llu\n", s->buffer_overrun);
+
+	if (p->output_width && p->output_height)
+		v4l2_info(dev->sd, "video_scaler_output:    %dx%d\n",
+			  p->output_width, p->output_height);
+	else
+		v4l2_info(dev->sd, "video_scaler_output:    [native 1:1]\n");
+
+	if (hdcapm_buffer_used_queue_stats(dev,
+					   &q_used_bytes, &q_used_items) == 0) {
+		v4l2_info(dev->sd, "q_used_bytes:           %llu\n",
+			  q_used_bytes);
+		v4l2_info(dev->sd, "q_used_items:           %llu\n",
+			  q_used_items);
+	}
+
+	return v4l2_subdev_call(dev->sd, core, log_status);
+}
+
+static int vidioc_g_input(struct file *file, void *priv, unsigned int *i)
+{
+	*i = 0;
+
+	return 0;
+}
+
+static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
+{
+	if (i > 0)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int vidioc_g_dv_timings(struct file *file, void *priv,
+			       struct v4l2_dv_timings *timings)
+{
+	struct hdcapm_fh *fh = file->private_data;
+	struct hdcapm_dev *dev = fh->dev;
+
+	return v4l2_subdev_call(dev->sd, video, g_dv_timings, timings);
+}
+
+static int vidioc_enum_dv_timings(struct file *file, void *priv,
+				  struct v4l2_enum_dv_timings *timings)
+{
+	struct hdcapm_fh *fh = file->private_data;
+	struct hdcapm_dev *dev = fh->dev;
+
+	timings->pad = 0;
+	timings->reserved[0] = 0;
+	timings->reserved[1] = 0;
+
+	return v4l2_subdev_call(dev->sd, pad, enum_dv_timings, timings);
+}
+
+static int vidioc_dv_timings_cap(struct file *file, void *priv,
+				 struct v4l2_dv_timings_cap *cap)
+{
+	struct hdcapm_fh *fh = file->private_data;
+	struct hdcapm_dev *dev = fh->dev;
+
+	cap->pad = 0;
+
+	return v4l2_subdev_call(dev->sd, pad, dv_timings_cap, cap);
+}
+
+static int vidioc_enum_fmt_vid_cap(struct file *file, void *priv,
+				   struct v4l2_fmtdesc *f)
+{
+	if (f->index != 0)
+		return -EINVAL;
+
+	strlcpy(f->description, "MPEG", sizeof(f->description));
+	f->pixelformat = V4L2_PIX_FMT_MPEG;
+	f->flags = V4L2_FMT_FLAG_COMPRESSED;
+	return 0;
+}
+
+static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
+				struct v4l2_format *f)
+{
+	struct hdcapm_fh *fh = file->private_data;
+	struct hdcapm_dev *dev = fh->dev;
+	struct hdcapm_encoder_parameters *p = &dev->encoder_parameters;
+	struct v4l2_dv_timings timings;
+
+	if (v4l2_subdev_call(dev->sd, video, g_dv_timings, &timings) < 0)
+		return -EINVAL;
+
+	f->fmt.pix.pixelformat    = V4L2_PIX_FMT_MPEG;
+	f->fmt.pix.bytesperline   = 0;
+	f->fmt.pix.sizeimage      = 188 * 312;
+	f->fmt.pix.colorspace     = V4L2_COLORSPACE_SMPTE170M;
+
+	if (p->output_width)
+		f->fmt.pix.width  = p->output_width;
+	else
+		f->fmt.pix.width  = timings.bt.width;
+
+	if (p->output_height)
+		f->fmt.pix.height = p->output_height;
+	else
+		f->fmt.pix.height = timings.bt.width;
+
+	f->fmt.pix.height         = timings.bt.height;
+	f->fmt.pix.field          = V4L2_FIELD_NONE;
+
+	return 0;
+}
+
+static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
+				struct v4l2_format *f)
+{
+	struct hdcapm_fh *fh = file->private_data;
+	struct hdcapm_dev *dev = fh->dev;
+	struct hdcapm_encoder_parameters *p = &dev->encoder_parameters;
+	struct v4l2_dv_timings timings;
+
+	if (v4l2_subdev_call(dev->sd, video, g_dv_timings, &timings) < 0)
+		return -EINVAL;
+
+	/* Its not clear to me if the input resolution changes, if we're
+	 * required to preserve the users requested width and height, or
+	 * default it back to 1:1 with the input signal.
+	 */
+	p->output_width = f->fmt.pix.width;
+	p->output_height = f->fmt.pix.height;
+
+	f->fmt.pix.pixelformat  = V4L2_PIX_FMT_MPEG;
+	f->fmt.pix.bytesperline = 0;
+	f->fmt.pix.sizeimage    = 188 * 312;
+	f->fmt.pix.colorspace   = V4L2_COLORSPACE_SMPTE170M;
+	f->fmt.pix.width        = timings.bt.width;
+	f->fmt.pix.height       = timings.bt.height;
+	f->fmt.pix.field        = V4L2_FIELD_NONE;
+
+	return 0;
+}
+
+static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
+				  struct v4l2_format *f)
+{
+	return vidioc_s_fmt_vid_cap(file, priv, f);
+}
+
+static int vidioc_subscribe_event(struct v4l2_fh *fh,
+				  const struct v4l2_event_subscription *sub)
+{
+	switch (sub->type) {
+	case V4L2_EVENT_SOURCE_CHANGE:
+		return v4l2_event_subscribe(fh, sub, 16, NULL);
+	default:
+		v4l2_warn(fh->vdev->v4l2_dev,
+			  "event sub->type = 0x%x (UNKNOWN)\n", sub->type);
+	}
+	return v4l2_ctrl_subscribe_event(fh, sub);
+}
+
+static int vidioc_query_dv_timings(struct file *file,
+				   void *priv_fh,
+				   struct v4l2_dv_timings *timings)
+{
+	struct hdcapm_fh *fh = file->private_data;
+	struct hdcapm_dev *dev = fh->dev;
+
+	return v4l2_subdev_call(dev->sd, video, query_dv_timings, timings);
+}
+
+static const struct v4l2_ioctl_ops mpeg_ioctl_ops = {
+	.vidioc_enum_input        = vidioc_enum_input,
+	.vidioc_querycap          = vidioc_querycap,
+	.vidioc_log_status        = vidioc_log_status,
+	.vidioc_g_input           = vidioc_g_input,
+	.vidioc_s_input           = vidioc_s_input,
+	.vidioc_g_dv_timings      = vidioc_g_dv_timings,
+	.vidioc_query_dv_timings  = vidioc_query_dv_timings,
+	.vidioc_enum_dv_timings   = vidioc_enum_dv_timings,
+	.vidioc_dv_timings_cap    = vidioc_dv_timings_cap,
+	.vidioc_enum_fmt_vid_cap  = vidioc_enum_fmt_vid_cap,
+	.vidioc_g_fmt_vid_cap     = vidioc_g_fmt_vid_cap,
+	.vidioc_s_fmt_vid_cap     = vidioc_s_fmt_vid_cap,
+	.vidioc_try_fmt_vid_cap   = vidioc_try_fmt_vid_cap,
+	.vidioc_subscribe_event   = vidioc_subscribe_event,
+	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
+};
+
+static int fops_open(struct file *file)
+{
+	struct hdcapm_dev *dev;
+	struct hdcapm_fh *fh;
+
+	dev = (struct hdcapm_dev *)video_get_drvdata(video_devdata(file));
+	if (!dev)
+		return -ENODEV;
+
+	v4l2_dbg(2, hdcapm_debug, dev->sd, "%s()\n", __func__);
+
+	/* allocate + initialize per filehandle data */
+	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
+	if (!fh)
+		return -ENOMEM;
+
+	fh->dev = dev;
+	v4l2_fh_init(&fh->fh, video_devdata(file));
+	file->private_data = &fh->fh;
+	v4l2_fh_add(&fh->fh);
+
+	return 0;
+}
+
+static int fops_release(struct file *file)
+{
+	struct hdcapm_fh *fh = file->private_data;
+	struct hdcapm_dev *dev = fh->dev;
+
+	v4l2_dbg(2, hdcapm_debug, dev->sd, "%s()\n", __func__);
+
+	/* Shut device down on last close */
+	if ((atomic_cmpxchg(&fh->v4l_reading, 1, 0) == 1) &&
+	    (atomic_dec_return(&dev->v4l_reader_count) == 0))
+		/* stop mpeg capture then cancel buffers */
+		hdcapm_core_stop_streaming(dev);
+
+	v4l2_fh_del(&fh->fh);
+	v4l2_fh_exit(&fh->fh);
+	kfree(fh);
+
+	return 0;
+}
+
+static ssize_t fops_read(struct file *file, char __user *buffer,
+			 size_t count, loff_t *pos)
+{
+	struct hdcapm_fh *fh = file->private_data;
+	struct hdcapm_dev *dev = fh->dev;
+	struct hdcapm_buffer *ubuf = NULL;
+	int ret = 0;
+	int rem, cnt;
+	u8 *p;
+
+	if (*pos) {
+		v4l2_err(dev->sd, "%s() ESPIPE\n", __func__);
+		return -ESPIPE;
+	}
+
+	if ((atomic_cmpxchg(&fh->v4l_reading, 0, 1) == 0) &&
+	    (atomic_inc_return(&dev->v4l_reader_count) == 1))
+		hdcapm_core_start_streaming(dev);
+
+	/* blocking wait for buffer */
+	if ((file->f_flags & O_NONBLOCK) == 0) {
+		if (wait_event_interruptible(dev->wait_read,
+					     hdcapm_buffer_peek_used(dev))) {
+			v4l2_err(dev->sd,
+				 "%s() ERESTARTSYS\n", __func__);
+			//return -ERESTARTSYS;
+			return -EINVAL;
+		}
+	}
+
+	/* Pull the first buffer from the used list */
+	ubuf = hdcapm_buffer_peek_used(dev);
+
+	while ((count > 0) && ubuf) {
+		/* set remaining bytes to copy */
+		rem = ubuf->actual_size - ubuf->readpos;
+		cnt = rem > count ? count : rem;
+
+		p = ubuf->ptr + ubuf->readpos;
+
+		v4l2_dbg(3, hdcapm_debug, dev->sd,
+			 "%s() nr=%d count=%d cnt=%d rem=%d buf=%p buf->readpos=%d\n",
+			 __func__, ubuf->nr, (int)count,
+			 cnt, rem, ubuf, ubuf->readpos);
+
+		if (copy_to_user(buffer, p, cnt)) {
+			v4l2_err(dev->sd,
+				 "%s() copy_to_user failed\n", __func__);
+			if (!ret) {
+				v4l2_err(dev->sd, "%s() EFAULT\n", __func__);
+				ret = -EFAULT;
+			}
+			goto err;
+		}
+
+		ubuf->readpos += cnt;
+		count -= cnt;
+		buffer += cnt;
+		ret += cnt;
+
+		if (ubuf->readpos > ubuf->actual_size)
+			v4l2_err(dev->sd, "read() pos > actual, huh?\n");
+
+		if (ubuf->readpos == ubuf->actual_size) {
+			/* finished with current buffer, take next buffer */
+
+			/* Requeue the buffer on the free list */
+			ubuf->readpos = 0;
+
+			hdcapm_buffer_move_to_free(dev, ubuf);
+
+			/* Dequeue next */
+			if ((file->f_flags & O_NONBLOCK) == 0) {
+				if (wait_event_interruptible(dev->wait_read,
+						hdcapm_buffer_peek_used(dev)))
+					break;
+			}
+			ubuf = hdcapm_buffer_peek_used(dev);
+		}
+	}
+err:
+	if (!ret && !ubuf)
+		ret = -EAGAIN;
+
+	return ret;
+}
+
+static unsigned int fops_poll(struct file *file, poll_table *wait)
+{
+	unsigned long req_events = poll_requested_events(wait);
+	struct hdcapm_fh *fh = (struct hdcapm_fh *)file->private_data;
+	struct hdcapm_dev *dev = fh->dev;
+	unsigned int mask = v4l2_ctrl_poll(file, wait);
+
+	if (!(req_events & (POLLIN | POLLRDNORM)))
+		return mask;
+
+	if (atomic_cmpxchg(&fh->v4l_reading, 0, 1) == 0) {
+		if (atomic_inc_return(&dev->v4l_reader_count) == 1)
+			hdcapm_core_start_streaming(dev);
+	}
+
+	/* Pull the first buffer from the used list */
+	if (!list_empty(&dev->list_buf_used))
+		mask |= POLLIN | POLLRDNORM;
+
+	return mask;
+}
+
+static const struct v4l2_file_operations mpeg_fops = {
+	.owner          = THIS_MODULE,
+	.open           = fops_open,
+	.release        = fops_release,
+	.read           = fops_read,
+	.poll           = fops_poll,
+	.unlocked_ioctl = video_ioctl2,
+};
+
+static struct video_device mpeg_template = {
+	.name          = "hdcapm",
+	.fops          = &mpeg_fops,
+	.ioctl_ops     = &mpeg_ioctl_ops,
+	.minor         = -1,
+};
+
+int hdcapm_video_register(struct hdcapm_dev *dev)
+{
+	struct v4l2_ctrl_handler *hdl = &dev->ctrl_handler;
+	int ret;
+
+	v4l2_dbg(1, hdcapm_debug, dev->sd, "%s()\n", __func__);
+
+	/* Any video controls. */
+
+	dev->v4l_device = video_device_alloc();
+	if (!dev->v4l_device)
+		return -EINVAL;
+
+	/* Configure the V4L2 device properties */
+	*dev->v4l_device = mpeg_template;
+	snprintf(dev->v4l_device->name, sizeof(dev->v4l_device->name),
+		 "%s %s (%s)", dev->name, "mpeg", dev->name);
+	dev->v4l_device->v4l2_dev = &dev->v4l2_dev;
+	dev->v4l_device->release = video_device_release;
+
+	v4l2_ctrl_handler_init(hdl, 14);
+	dev->v4l_device->ctrl_handler = hdl;
+
+	v4l2_ctrl_new_std(hdl, &ctrl_ops, V4L2_CID_MPEG_AUDIO_MUTE, 0, 1, 1, 0);
+	v4l2_ctrl_new_std(hdl, &ctrl_ops, V4L2_CID_BRIGHTNESS, 0, 255, 1, 127);
+	v4l2_ctrl_new_std(hdl, &ctrl_ops, V4L2_CID_MPEG_VIDEO_GOP_SIZE,
+			  ENCODER_MIN_GOP_SIZE,
+			  ENCODER_MAX_GOP_SIZE, 1, ENCODER_DEF_GOP_SIZE);
+	v4l2_ctrl_new_std(hdl, &ctrl_ops, V4L2_CID_MPEG_VIDEO_BITRATE,
+			  ENCODER_MIN_BITRATE,
+			  ENCODER_MAX_BITRATE, 100000, ENCODER_DEF_BITRATE);
+	v4l2_ctrl_new_std(hdl, &ctrl_ops, V4L2_CID_MPEG_VIDEO_BITRATE_PEAK,
+			  ENCODER_MIN_BITRATE,
+			  ENCODER_MAX_BITRATE, 100000, ENCODER_DEF_BITRATE);
+
+	v4l2_ctrl_new_std_menu(hdl, &ctrl_ops,
+			       V4L2_CID_MPEG_VIDEO_BITRATE_MODE,
+			       V4L2_MPEG_VIDEO_BITRATE_MODE_CBR, 0,
+			       V4L2_MPEG_VIDEO_BITRATE_MODE_VBR);
+
+	v4l2_ctrl_new_std_menu(hdl, &ctrl_ops, V4L2_CID_MPEG_VIDEO_H264_LEVEL,
+			       V4L2_MPEG_VIDEO_H264_LEVEL_5_1,
+			       0, V4L2_MPEG_VIDEO_H264_LEVEL_4_0);
+
+	v4l2_ctrl_new_std_menu(hdl, &ctrl_ops,
+			       V4L2_CID_MPEG_VIDEO_H264_ENTROPY_MODE,
+			       V4L2_MPEG_VIDEO_H264_ENTROPY_MODE_CABAC,
+			       0, V4L2_MPEG_VIDEO_H264_ENTROPY_MODE_CAVLC);
+
+	v4l2_ctrl_new_std_menu(hdl, &ctrl_ops,
+			       V4L2_CID_MPEG_VIDEO_H264_PROFILE,
+			       V4L2_MPEG_VIDEO_H264_PROFILE_HIGH,
+			       ~((1 << V4L2_MPEG_VIDEO_H264_PROFILE_BASELINE) |
+				 (1 << V4L2_MPEG_VIDEO_H264_PROFILE_MAIN) |
+				 (1 << V4L2_MPEG_VIDEO_H264_PROFILE_HIGH)),
+			       V4L2_MPEG_VIDEO_H264_PROFILE_HIGH);
+
+	v4l2_ctrl_new_std_menu(hdl, &ctrl_ops,
+			       V4L2_CID_MPEG_STREAM_TYPE,
+			       V4L2_MPEG_STREAM_TYPE_MPEG2_TS,
+			       ~(1 << V4L2_MPEG_STREAM_TYPE_MPEG2_TS),
+			       V4L2_MPEG_STREAM_TYPE_MPEG2_TS);
+
+	/* Establish all default control values. */
+	v4l2_ctrl_handler_setup(hdl);
+
+	video_set_drvdata(dev->v4l_device, dev);
+	ret = video_register_device(dev->v4l_device, VFL_TYPE_GRABBER, -1);
+	if (ret < 0)
+		goto fail1;
+
+	v4l2_info(dev->sd,
+		  "registered device video%d [mpeg]\n", dev->v4l_device->num);
+
+	ret = 0; /* Success */
+
+fail1:
+	return ret;
+}
+
+void hdcapm_video_unregister(struct hdcapm_dev *dev)
+{
+	v4l2_dbg(1, hdcapm_debug, dev->sd, "%s()\n", __func__);
+
+	if (dev->v4l_device) {
+		if (dev->v4l_device->minor != -1)
+			video_unregister_device(dev->v4l_device);
+		else
+			video_device_release(dev->v4l_device);
+
+		dev->v4l_device = NULL;
+	}
+	v4l2_ctrl_handler_free(&dev->ctrl_handler);
+}
diff --git a/drivers/media/usb/hdcapm/hdcapm.h b/drivers/media/usb/hdcapm/hdcapm.h
new file mode 100644
index 000000000000..d2a0e820c3eb
--- /dev/null
+++ b/drivers/media/usb/hdcapm/hdcapm.h
@@ -0,0 +1,283 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/*
+ * Driver for the Startech USB2HDCAPM USB capture device
+ *
+ * Copyright (c) 2017 Steven Toth <stoth@kernellabs.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *
+ * GNU General Public License for more details.
+ */
+
+#ifndef _HDCAPM_H
+#define _HDCAPM_H
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/bitops.h>
+#include <linux/i2c.h>
+#include <linux/i2c-algo-bit.h>
+#include <linux/kdev_t.h>
+#include <linux/kthread.h>
+#include <linux/freezer.h>
+#include <linux/usb.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
+#include <linux/firmware.h>
+#include <linux/timer.h>
+#include <media/v4l2-common.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-event.h>
+#include <media/v4l2-fh.h>
+
+#include "hdcapm-reg.h"
+
+extern int hdcapm_i2c_scan;
+extern int hdcapm_debug;
+
+#define HDCAPM_CARD_REV1 1
+
+#define PIPE_EP1 0x01
+#define PIPE_EP2 0x02
+#define PIPE_EP3 0x83
+#define PIPE_EP4 0x04
+
+/* The scheduler on ARM/RDU2 uses a different quanta, probably 20ms.
+ * on X86 its 10. This skews our hard timing when polling the
+ * codec memory levels (and downloading payload).
+ * SOme discussion was had re hires timers for ARM and how they may
+ * be more accurate.
+ * They're not, they just trade CPU cycles for more accurate timing.
+ * Enable this to evaluate ARM hires timers and look for the histogram
+ * results in the --log-status output, they show how accurate the
+ * kernel is for certain requested sleep intervals.
+ */
+#define TIMER_EVAL 0
+
+/* The driver started development by loading the firmware once
+ * during startup, unlike the windows driver that loads the
+ * firmware before every capture session. (ONETIME = 1).
+ * During later development, we found that if we don't load the
+ * firmware before ever capture, we lose audio in the second
+ * and subsequent capture.
+ * With ONETIME = 0 we load the firm whenever a capture starts.
+ */
+#define ONETIME_FW_LOAD 0
+
+extern struct usb_device_id hdcapm_usb_id_table[];
+
+struct hdcapm_dev;
+struct hdcapm_statistics;
+
+enum transition_state_e {
+	STATE_UNDEFINED = 0,
+	STATE_START,	/* V4L2 read() or poll() advanced to _START state. */
+
+	STATE_STARTED,	/* kernel thread notices _START state, starts
+			 * the firmware and moves state to _STARTED.
+			 */
+	STATE_STOP,     /* V4L2 close advances from _STARTED to _STOP. */
+
+	STATE_STOPPED,  /* kernel thread notices _STOPPING, stops
+			 * firmware and moves to STOPPED state.
+			 */
+};
+
+struct hdcapm_encoder_parameters {
+	/* TODO: Mostly all todo items. */
+	u32 audio_mute;
+	u32 brightness;
+	u32 bitrate_bps;
+	u32 bitrate_peak_bps;
+	u32 bitrate_mode;
+	u32 gop_size;
+
+	u32 h264_profile; /* H264 profile BASELINE etc */
+	u32 h264_level; /* H264 profile 4.1 etc */
+	u32 h264_entropy_mode; /* CABAC = 1 / CAVLC = 0 */
+	u32 h264_mode; /* VBR = 1, CBR = 0 */
+
+	/* Typically these map 1:1 to the detected timing
+	 * resolution, but these could be modified bu
+	 * s_fmt to invoke the hardware video scaler.
+	 */
+	u32 output_width;
+	u32 output_height;
+};
+
+struct hdcapm_fh {
+	struct v4l2_fh fh;
+	struct hdcapm_dev *dev;
+	atomic_t v4l_reading;
+};
+
+struct hdcapm_i2c_bus {
+	struct hdcapm_dev *dev;
+	int nr;
+	struct i2c_adapter i2c_adap;
+	struct i2c_client  i2c_client;
+	struct i2c_algo_bit_data i2c_algo;
+};
+
+struct hdcapm_dev {
+	struct list_head devlist;
+
+	char name[32];
+
+	enum transition_state_e state;
+	int thread_active;
+	struct task_struct *kthread;
+
+	struct hdcapm_statistics *stats;
+
+	/* Held by the follow driver features.
+	 * 1. During probe and disconnect.
+	 * 2. When writing commands to the firmware.
+	 */
+	struct mutex lock;
+
+	struct usb_device *udev;
+
+	/* We need to xfer USB buffers off the stack, put them here. */
+	u8  *xferbuf;
+	u32  xferbuf_len;
+
+	/* I2C.
+	 * Bus0 - MST3367.
+	 * Bus1 - Sonix chip.
+	 */
+	struct hdcapm_i2c_bus i2cbus[2];
+	//struct i2c_client *i2c_client_hdmi;
+	struct v4l2_subdev *sd;
+
+	/* V4L2 */
+	struct v4l2_device v4l2_dev;
+	struct video_device *v4l_device;
+	struct v4l2_ctrl_handler ctrl_handler;
+	atomic_t v4l_reader_count;
+	struct hdcapm_encoder_parameters encoder_parameters;
+#if TIMER_EVAL
+	struct timer_list ktimer;
+	struct hrtimer hrtimer;
+#endif
+
+	/* User buffering */
+	struct mutex dmaqueue_lock;
+	struct list_head list_buf_free;
+	struct list_head list_buf_used;
+	wait_queue_head_t wait_read;
+};
+
+struct hdcapm_buffer {
+	struct list_head   list;
+
+	int                nr;
+	struct hdcapm_dev *dev;
+	struct urb        *urb;
+
+	u8  *ptr;
+	u32  maxsize;
+	u32  actual_size;
+	u32  readpos;
+};
+
+struct hdcapm_statistics {
+	/* Number of times the driver stole a used buffer to satisfy a
+	 * free buffer streaming request.
+	 */
+	u64 buffer_overrun;
+
+	/* The amount of data we've received from the firmware
+	 * (video/audio codec data).
+	 */
+	u64 codec_bytes_received;
+
+	/* The number of buffers we're received full of codec data
+	 * (video/audio codec data).
+	 */
+	u64 codec_buffers_received;
+
+	/* Any time we call the codec to check for a TS buffer, and it
+	 * replies that it doesn't yet have one.
+	 */
+	u64 codec_ts_not_yet_ready;
+};
+
+/* -core.c */
+int hdcapm_write32(struct hdcapm_dev *dev, u32 addr, u32 val);
+int hdcapm_read32(struct hdcapm_dev *dev, u32 addr, u32 *val);
+
+/* Read N DWORDS from the firmware and optionally convert the LE
+ * firmware dwords to platform CPU DWORDS.
+ */
+int hdcapm_read32_array(struct hdcapm_dev *dev, u32 addr, u32 wordcount,
+			u32 *arr, int le_to_cpu);
+
+void hdcapm_set32(struct hdcapm_dev *dev, u32 addr, u32 mask);
+void hdcapm_clr32(struct hdcapm_dev *dev, u32 addr, u32 mask);
+
+int hdcapm_dmawrite32(struct hdcapm_dev *dev, u32 addr, const u32 *arr,
+		      u32 entries);
+int hdcapm_dmaread32(struct hdcapm_dev *dev, u32 addr, u32 *arr, u32 entries);
+int hdcapm_mem_write32(struct hdcapm_dev *dev, u32 addr, u32 val);
+int hdcapm_mem_read32(struct hdcapm_dev *dev, u32 addr, u32 *val);
+
+int hdcapm_core_ep_send(struct hdcapm_dev *dev, int endpoint, u8 *buf,
+			u32 len, u32 timeout);
+
+int hdcapm_core_ep_recv(struct hdcapm_dev *dev, int endpoint, u8 *buf,
+			u32 len, u32 *actual, u32 timeout);
+
+int hdcapm_core_stop_streaming(struct hdcapm_dev *dev);
+int hdcapm_core_start_streaming(struct hdcapm_dev *dev);
+
+/* -i2c.c */
+int hdcapm_i2c_register(struct hdcapm_dev *dev,
+			struct hdcapm_i2c_bus *bus, int nr);
+void hdcapm_i2c_unregister(struct hdcapm_dev *dev,
+			   struct hdcapm_i2c_bus *bus);
+
+/* -buffer.c */
+struct hdcapm_buffer *hdcapm_buffer_alloc(struct hdcapm_dev *dev,
+					  u32 nr, u32 maxsize);
+
+void hdcapm_buffer_free(struct hdcapm_buffer *buf);
+void hdcapm_buffers_move_all(struct hdcapm_dev *dev, struct list_head *to,
+			     struct list_head *from);
+void hdcapm_buffers_free_all(struct hdcapm_dev *dev, struct list_head *head);
+struct hdcapm_buffer *hdcapm_buffer_next_free(struct hdcapm_dev *dev);
+struct hdcapm_buffer *hdcapm_buffer_peek_used(struct hdcapm_dev *dev);
+void hdcapm_buffer_move_to_free(struct hdcapm_dev *dev,
+				struct hdcapm_buffer *buf);
+void hdcapm_buffer_move_to_used(struct hdcapm_dev *dev,
+				struct hdcapm_buffer *buf);
+void hdcapm_buffer_add_to_free(struct hdcapm_dev *dev,
+			       struct hdcapm_buffer *buf);
+void hdcapm_buffer_add_to_used(struct hdcapm_dev *dev,
+			       struct hdcapm_buffer *buf);
+int hdcapm_buffer_used_queue_stats(struct hdcapm_dev *dev,
+				   u64 *bytes, u64 *items);
+
+/* -compressor.c */
+int  hdcapm_compressor_register(struct hdcapm_dev *dev);
+void hdcapm_compressor_unregister(struct hdcapm_dev *dev);
+void hdcapm_compressor_run(struct hdcapm_dev *dev);
+void hdcapm_compressor_init_gpios(struct hdcapm_dev *dev);
+
+/* -video.c */
+int  hdcapm_video_register(struct hdcapm_dev *dev);
+void hdcapm_video_unregister(struct hdcapm_dev *dev);
+
+#endif /* _HDCAPM_H */
-- 
2.19.1
