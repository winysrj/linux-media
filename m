Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45375 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932852Ab3HGSxS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Aug 2013 14:53:18 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: =?UTF-8?q?=5BPATCH=2001/16=5D=20Mirics=20MSi3101=20SDR=20Dongle=20driver?=
Date: Wed,  7 Aug 2013 21:51:32 +0300
Message-Id: <1375901507-26661-2-git-send-email-crope@iki.fi>
In-Reply-To: <1375901507-26661-1-git-send-email-crope@iki.fi>
References: <1375901507-26661-1-git-send-email-crope@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/Kconfig               |    2 +
 drivers/staging/media/Makefile              |    1 +
 drivers/staging/media/msi3101/Kconfig       |    3 +
 drivers/staging/media/msi3101/Makefile      |    1 +
 drivers/staging/media/msi3101/sdr-msi3101.c | 1618 +++++++++++++++++++++++++++
 5 files changed, 1625 insertions(+)
 create mode 100644 drivers/staging/media/msi3101/Kconfig
 create mode 100644 drivers/staging/media/msi3101/Makefile
 create mode 100644 drivers/staging/media/msi3101/sdr-msi3101.c

diff --git a/drivers/staging/media/Kconfig b/drivers/staging/media/Kconfig
index ae0abc3..46f1e61 100644
--- a/drivers/staging/media/Kconfig
+++ b/drivers/staging/media/Kconfig
@@ -29,6 +29,8 @@ source "drivers/staging/media/dt3155v4l/Kconfig"
 
 source "drivers/staging/media/go7007/Kconfig"
 
+source "drivers/staging/media/msi3101/Kconfig"
+
 source "drivers/staging/media/solo6x10/Kconfig"
 
 # Keep LIRC at the end, as it has sub-menus
diff --git a/drivers/staging/media/Makefile b/drivers/staging/media/Makefile
index 2b97cae..eb7f30b 100644
--- a/drivers/staging/media/Makefile
+++ b/drivers/staging/media/Makefile
@@ -4,4 +4,5 @@ obj-$(CONFIG_LIRC_STAGING)	+= lirc/
 obj-$(CONFIG_SOLO6X10)		+= solo6x10/
 obj-$(CONFIG_VIDEO_DT3155)	+= dt3155v4l/
 obj-$(CONFIG_VIDEO_GO7007)	+= go7007/
+obj-$(CONFIG_USB_MSI3101)	+= msi3101/
 obj-$(CONFIG_VIDEO_DM365_VPFE)	+= davinci_vpfe/
diff --git a/drivers/staging/media/msi3101/Kconfig b/drivers/staging/media/msi3101/Kconfig
new file mode 100644
index 0000000..b94a95a
--- /dev/null
+++ b/drivers/staging/media/msi3101/Kconfig
@@ -0,0 +1,3 @@
+config USB_MSI3101
+	tristate "Mirics MSi3101 SDR Dongle"
+	depends on USB && VIDEO_DEV && VIDEO_V4L2
diff --git a/drivers/staging/media/msi3101/Makefile b/drivers/staging/media/msi3101/Makefile
new file mode 100644
index 0000000..3730654
--- /dev/null
+++ b/drivers/staging/media/msi3101/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_USB_MSI3101)             += sdr-msi3101.o
diff --git a/drivers/staging/media/msi3101/sdr-msi3101.c b/drivers/staging/media/msi3101/sdr-msi3101.c
new file mode 100644
index 0000000..46fdb6c
--- /dev/null
+++ b/drivers/staging/media/msi3101/sdr-msi3101.c
@@ -0,0 +1,1618 @@
+/*
+ * Mirics MSi3101 SDR Dongle driver
+ *
+ * Copyright (C) 2013 Antti Palosaari <crope@iki.fi>
+ *
+ *    This program is free software; you can redistribute it and/or modify
+ *    it under the terms of the GNU General Public License as published by
+ *    the Free Software Foundation; either version 2 of the License, or
+ *    (at your option) any later version.
+ *
+ *    This program is distributed in the hope that it will be useful,
+ *    but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *    GNU General Public License for more details.
+ *
+ *    You should have received a copy of the GNU General Public License along
+ *    with this program; if not, write to the Free Software Foundation, Inc.,
+ *    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/input.h>
+#include <linux/videodev2.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-event.h>
+#include <linux/usb.h>
+#include <linux/mutex.h>
+#include <media/videobuf2-vmalloc.h>
+
+struct msi3101_gain {
+	u8 tot:7;
+	u8 baseband:6;
+	bool lna:1;
+	bool mixer:1;
+};
+
+/* 60 – 120 MHz band, lna 24dB, mixer 19dB */
+static const struct msi3101_gain msi3101_gain_lut_120[] = {
+	{  0,  0,  0,  0},
+	{  1,  1,  0,  0},
+	{  2,  2,  0,  0},
+	{  3,  3,  0,  0},
+	{  4,  4,  0,  0},
+	{  5,  5,  0,  0},
+	{  6,  6,  0,  0},
+	{  7,  7,  0,  0},
+	{  8,  8,  0,  0},
+	{  9,  9,  0,  0},
+	{ 10, 10,  0,  0},
+	{ 11, 11,  0,  0},
+	{ 12, 12,  0,  0},
+	{ 13, 13,  0,  0},
+	{ 14, 14,  0,  0},
+	{ 15, 15,  0,  0},
+	{ 16, 16,  0,  0},
+	{ 17, 17,  0,  0},
+	{ 18, 18,  0,  0},
+	{ 19, 19,  0,  0},
+	{ 20, 20,  0,  0},
+	{ 21, 21,  0,  0},
+	{ 22, 22,  0,  0},
+	{ 23, 23,  0,  0},
+	{ 24, 24,  0,  0},
+	{ 25, 25,  0,  0},
+	{ 26, 26,  0,  0},
+	{ 27, 27,  0,  0},
+	{ 28, 28,  0,  0},
+	{ 29,  5,  1,  0},
+	{ 30,  6,  1,  0},
+	{ 31,  7,  1,  0},
+	{ 32,  8,  1,  0},
+	{ 33,  9,  1,  0},
+	{ 34, 10,  1,  0},
+	{ 35, 11,  1,  0},
+	{ 36, 12,  1,  0},
+	{ 37, 13,  1,  0},
+	{ 38, 14,  1,  0},
+	{ 39, 15,  1,  0},
+	{ 40, 16,  1,  0},
+	{ 41, 17,  1,  0},
+	{ 42, 18,  1,  0},
+	{ 43, 19,  1,  0},
+	{ 44, 20,  1,  0},
+	{ 45, 21,  1,  0},
+	{ 46, 22,  1,  0},
+	{ 47, 23,  1,  0},
+	{ 48, 24,  1,  0},
+	{ 49, 25,  1,  0},
+	{ 50, 26,  1,  0},
+	{ 51, 27,  1,  0},
+	{ 52, 28,  1,  0},
+	{ 53, 29,  1,  0},
+	{ 54, 30,  1,  0},
+	{ 55, 31,  1,  0},
+	{ 56, 32,  1,  0},
+	{ 57, 33,  1,  0},
+	{ 58, 34,  1,  0},
+	{ 59, 35,  1,  0},
+	{ 60, 36,  1,  0},
+	{ 61, 37,  1,  0},
+	{ 62, 38,  1,  0},
+	{ 63, 39,  1,  0},
+	{ 64, 40,  1,  0},
+	{ 65, 41,  1,  0},
+	{ 66, 42,  1,  0},
+	{ 67, 43,  1,  0},
+	{ 68, 44,  1,  0},
+	{ 69, 45,  1,  0},
+	{ 70, 46,  1,  0},
+	{ 71, 47,  1,  0},
+	{ 72, 48,  1,  0},
+	{ 73, 49,  1,  0},
+	{ 74, 50,  1,  0},
+	{ 75, 51,  1,  0},
+	{ 76, 52,  1,  0},
+	{ 77, 53,  1,  0},
+	{ 78, 54,  1,  0},
+	{ 79, 55,  1,  0},
+	{ 80, 56,  1,  0},
+	{ 81, 57,  1,  0},
+	{ 82, 58,  1,  0},
+	{ 83, 40,  1,  1},
+	{ 84, 41,  1,  1},
+	{ 85, 42,  1,  1},
+	{ 86, 43,  1,  1},
+	{ 87, 44,  1,  1},
+	{ 88, 45,  1,  1},
+	{ 89, 46,  1,  1},
+	{ 90, 47,  1,  1},
+	{ 91, 48,  1,  1},
+	{ 92, 49,  1,  1},
+	{ 93, 50,  1,  1},
+	{ 94, 51,  1,  1},
+	{ 95, 52,  1,  1},
+	{ 96, 53,  1,  1},
+	{ 97, 54,  1,  1},
+	{ 98, 55,  1,  1},
+	{ 99, 56,  1,  1},
+	{100, 57,  1,  1},
+	{101, 58,  1,  1},
+	{102, 59,  1,  1},
+};
+
+/* 120 – 245 MHz band, lna 24dB, mixer 19dB */
+static const struct msi3101_gain msi3101_gain_lut_245[] = {
+	{  0,  0,  0,  0},
+	{  1,  1,  0,  0},
+	{  2,  2,  0,  0},
+	{  3,  3,  0,  0},
+	{  4,  4,  0,  0},
+	{  5,  5,  0,  0},
+	{  6,  6,  0,  0},
+	{  7,  7,  0,  0},
+	{  8,  8,  0,  0},
+	{  9,  9,  0,  0},
+	{ 10, 10,  0,  0},
+	{ 11, 11,  0,  0},
+	{ 12, 12,  0,  0},
+	{ 13, 13,  0,  0},
+	{ 14, 14,  0,  0},
+	{ 15, 15,  0,  0},
+	{ 16, 16,  0,  0},
+	{ 17, 17,  0,  0},
+	{ 18, 18,  0,  0},
+	{ 19, 19,  0,  0},
+	{ 20, 20,  0,  0},
+	{ 21, 21,  0,  0},
+	{ 22, 22,  0,  0},
+	{ 23, 23,  0,  0},
+	{ 24, 24,  0,  0},
+	{ 25, 25,  0,  0},
+	{ 26, 26,  0,  0},
+	{ 27, 27,  0,  0},
+	{ 28, 28,  0,  0},
+	{ 29,  5,  1,  0},
+	{ 30,  6,  1,  0},
+	{ 31,  7,  1,  0},
+	{ 32,  8,  1,  0},
+	{ 33,  9,  1,  0},
+	{ 34, 10,  1,  0},
+	{ 35, 11,  1,  0},
+	{ 36, 12,  1,  0},
+	{ 37, 13,  1,  0},
+	{ 38, 14,  1,  0},
+	{ 39, 15,  1,  0},
+	{ 40, 16,  1,  0},
+	{ 41, 17,  1,  0},
+	{ 42, 18,  1,  0},
+	{ 43, 19,  1,  0},
+	{ 44, 20,  1,  0},
+	{ 45, 21,  1,  0},
+	{ 46, 22,  1,  0},
+	{ 47, 23,  1,  0},
+	{ 48, 24,  1,  0},
+	{ 49, 25,  1,  0},
+	{ 50, 26,  1,  0},
+	{ 51, 27,  1,  0},
+	{ 52, 28,  1,  0},
+	{ 53, 29,  1,  0},
+	{ 54, 30,  1,  0},
+	{ 55, 31,  1,  0},
+	{ 56, 32,  1,  0},
+	{ 57, 33,  1,  0},
+	{ 58, 34,  1,  0},
+	{ 59, 35,  1,  0},
+	{ 60, 36,  1,  0},
+	{ 61, 37,  1,  0},
+	{ 62, 38,  1,  0},
+	{ 63, 39,  1,  0},
+	{ 64, 40,  1,  0},
+	{ 65, 41,  1,  0},
+	{ 66, 42,  1,  0},
+	{ 67, 43,  1,  0},
+	{ 68, 44,  1,  0},
+	{ 69, 45,  1,  0},
+	{ 70, 46,  1,  0},
+	{ 71, 47,  1,  0},
+	{ 72, 48,  1,  0},
+	{ 73, 49,  1,  0},
+	{ 74, 50,  1,  0},
+	{ 75, 51,  1,  0},
+	{ 76, 52,  1,  0},
+	{ 77, 53,  1,  0},
+	{ 78, 54,  1,  0},
+	{ 79, 55,  1,  0},
+	{ 80, 56,  1,  0},
+	{ 81, 57,  1,  0},
+	{ 82, 58,  1,  0},
+	{ 83, 40,  1,  1},
+	{ 84, 41,  1,  1},
+	{ 85, 42,  1,  1},
+	{ 86, 43,  1,  1},
+	{ 87, 44,  1,  1},
+	{ 88, 45,  1,  1},
+	{ 89, 46,  1,  1},
+	{ 90, 47,  1,  1},
+	{ 91, 48,  1,  1},
+	{ 92, 49,  1,  1},
+	{ 93, 50,  1,  1},
+	{ 94, 51,  1,  1},
+	{ 95, 52,  1,  1},
+	{ 96, 53,  1,  1},
+	{ 97, 54,  1,  1},
+	{ 98, 55,  1,  1},
+	{ 99, 56,  1,  1},
+	{100, 57,  1,  1},
+	{101, 58,  1,  1},
+	{102, 59,  1,  1},
+};
+
+/* 420 – 1000 MHz band, lna 7dB, mixer 19dB */
+static const struct msi3101_gain msi3101_gain_lut_1000[] = {
+	{  0,  0, 0,  0},
+	{  1,  1, 0,  0},
+	{  2,  2, 0,  0},
+	{  3,  3, 0,  0},
+	{  4,  4, 0,  0},
+	{  5,  5, 0,  0},
+	{  6,  6, 0,  0},
+	{  7,  7, 0,  0},
+	{  8,  8, 0,  0},
+	{  9,  9, 0,  0},
+	{ 10, 10, 0,  0},
+	{ 11, 11, 0,  0},
+	{ 12,  5, 1,  0},
+	{ 13,  6, 1,  0},
+	{ 14,  7, 1,  0},
+	{ 15,  8, 1,  0},
+	{ 16,  9, 1,  0},
+	{ 17, 10, 1,  0},
+	{ 18, 11, 1,  0},
+	{ 19, 12, 1,  0},
+	{ 20, 13, 1,  0},
+	{ 21, 14, 1,  0},
+	{ 22, 15, 1,  0},
+	{ 23, 16, 1,  0},
+	{ 24, 17, 1,  0},
+	{ 25, 18, 1,  0},
+	{ 26, 19, 1,  0},
+	{ 27, 20, 1,  0},
+	{ 28, 21, 1,  0},
+	{ 29, 22, 1,  0},
+	{ 30, 23, 1,  0},
+	{ 31, 24, 1,  0},
+	{ 32, 25, 1,  0},
+	{ 33, 26, 1,  0},
+	{ 34, 27, 1,  0},
+	{ 35, 28, 1,  0},
+	{ 36, 29, 1,  0},
+	{ 37, 30, 1,  0},
+	{ 38, 31, 1,  0},
+	{ 39, 32, 1,  0},
+	{ 40, 33, 1,  0},
+	{ 41, 34, 1,  0},
+	{ 42, 35, 1,  0},
+	{ 43, 36, 1,  0},
+	{ 44, 37, 1,  0},
+	{ 45, 38, 1,  0},
+	{ 46, 39, 1,  0},
+	{ 47, 40, 1,  0},
+	{ 48, 41, 1,  0},
+	{ 49, 42, 1,  0},
+	{ 50, 43, 1,  0},
+	{ 51, 44, 1,  0},
+	{ 52, 45, 1,  0},
+	{ 53, 46, 1,  0},
+	{ 54, 47, 1,  0},
+	{ 55, 48, 1,  0},
+	{ 56, 49, 1,  0},
+	{ 57, 50, 1,  0},
+	{ 58, 51, 1,  0},
+	{ 59, 52, 1,  0},
+	{ 60, 53, 1,  0},
+	{ 61, 54, 1,  0},
+	{ 62, 55, 1,  0},
+	{ 63, 56, 1,  0},
+	{ 64, 57, 1,  0},
+	{ 65, 58, 1,  0},
+	{ 66, 40, 1,  1},
+	{ 67, 41, 1,  1},
+	{ 68, 42, 1,  1},
+	{ 69, 43, 1,  1},
+	{ 70, 44, 1,  1},
+	{ 71, 45, 1,  1},
+	{ 72, 46, 1,  1},
+	{ 73, 47, 1,  1},
+	{ 74, 48, 1,  1},
+	{ 75, 49, 1,  1},
+	{ 76, 50, 1,  1},
+	{ 77, 51, 1,  1},
+	{ 78, 52, 1,  1},
+	{ 79, 53, 1,  1},
+	{ 80, 54, 1,  1},
+	{ 81, 55, 1,  1},
+	{ 82, 56, 1,  1},
+	{ 83, 57, 1,  1},
+	{ 84, 58, 1,  1},
+	{ 85, 59, 1,  1},
+};
+
+/*
+ *   iConfiguration          0
+ *     bInterfaceNumber        0
+ *     bAlternateSetting       1
+ *     bNumEndpoints           1
+ *       bEndpointAddress     0x81  EP 1 IN
+ *       bmAttributes            1
+ *         Transfer Type            Isochronous
+ *       wMaxPacketSize     0x1400  3x 1024 bytes
+ *       bInterval               1
+ */
+#define MAX_ISO_BUFS            (8)
+#define ISO_FRAMES_PER_DESC     (8)
+#define ISO_MAX_FRAME_SIZE      (3 * 1024)
+#define ISO_BUFFER_SIZE         (ISO_FRAMES_PER_DESC * ISO_MAX_FRAME_SIZE)
+
+#define MAX_ISOC_ERRORS         20
+
+#define MSI3101_CID_SAMPLING_RATE         ((V4L2_CID_USER_BASE | 0xf000) + 0)
+#define MSI3101_CID_SAMPLING_RESOLUTION   ((V4L2_CID_USER_BASE | 0xf000) + 1)
+#define MSI3101_CID_TUNER_RF              ((V4L2_CID_USER_BASE | 0xf000) + 10)
+#define MSI3101_CID_TUNER_BW              ((V4L2_CID_USER_BASE | 0xf000) + 11)
+#define MSI3101_CID_TUNER_IF              ((V4L2_CID_USER_BASE | 0xf000) + 12)
+#define MSI3101_CID_TUNER_GAIN            ((V4L2_CID_USER_BASE | 0xf000) + 13)
+
+/* intermediate buffers with raw data from the USB device */
+struct msi3101_frame_buf {
+	struct vb2_buffer vb;   /* common v4l buffer stuff -- must be first */
+	struct list_head list;
+	void *data;             /* raw data from USB device */
+	int filled;             /* number of bytes filled to *data */
+};
+
+struct msi3101_state {
+	struct video_device vdev;
+	struct v4l2_device v4l2_dev;
+
+	/* videobuf2 queue and queued buffers list */
+	struct vb2_queue vb_queue;
+	struct list_head queued_bufs;
+	spinlock_t queued_bufs_lock; /* Protects queued_bufs */
+
+	/* Note if taking both locks v4l2_lock must always be locked first! */
+	struct mutex v4l2_lock;      /* Protects everything else */
+	struct mutex vb_queue_lock;  /* Protects vb_queue and capt_file */
+
+	/* Pointer to our usb_device, will be NULL after unplug */
+	struct usb_device *udev; /* Both mutexes most be hold when setting! */
+
+	unsigned int isoc_errors; /* number of contiguous ISOC errors */
+	unsigned int vb_full; /* vb is full and packets dropped */
+
+	struct urb *urbs[MAX_ISO_BUFS];
+
+	/* Controls */
+	struct v4l2_ctrl_handler ctrl_handler;
+	struct v4l2_ctrl *ctrl_sampling_rate;
+	struct v4l2_ctrl *ctrl_tuner_rf;
+	struct v4l2_ctrl *ctrl_tuner_bw;
+	struct v4l2_ctrl *ctrl_tuner_if;
+	struct v4l2_ctrl *ctrl_tuner_gain;
+
+	u32 symbol_received; /* for track lost packets */
+	u32 symbol; /* for symbol rate calc */
+	unsigned long jiffies;
+};
+
+/* Private functions */
+static struct msi3101_frame_buf *msi3101_get_next_fill_buf(
+		struct msi3101_state *s)
+{
+	unsigned long flags = 0;
+	struct msi3101_frame_buf *buf = NULL;
+
+	spin_lock_irqsave(&s->queued_bufs_lock, flags);
+	if (list_empty(&s->queued_bufs))
+		goto leave;
+
+	buf = list_entry(s->queued_bufs.next, struct msi3101_frame_buf, list);
+	list_del(&buf->list);
+leave:
+	spin_unlock_irqrestore(&s->queued_bufs_lock, flags);
+	return buf;
+}
+
+/*
+ * Converts signed 10-bit integer into 32-bit IEEE floating point
+ * representation.
+ * Will be exact from 0 to 2^24.  Above that, we round towards zero
+ * as the fractional bits will not fit in a float.  (It would be better to
+ * round towards even as the fpu does, but that is slower.)
+ */
+#define I2F_FRAC_BITS  23
+#define I2F_MASK ((1 << I2F_FRAC_BITS) - 1)
+static uint32_t msi3101_int2float(uint32_t x)
+{
+	uint32_t msb, exponent, fraction, sign;
+
+	/* Zero is special */
+	if (!x)
+		return 0;
+
+	/* Negative / positive value */
+	if (x & 0x200) {
+		x = -x;
+		x &= 0x3ff;
+		sign = 1 << 31;
+	} else {
+		sign = 0 << 31;
+	}
+
+	/* Get location of the most significant bit */
+	msb = __fls(x);
+
+	/*
+	 * Use a rotate instead of a shift because that works both leftwards
+	 * and rightwards due to the mod(32) behaviour.  This means we don't
+	 * need to check to see if we are above 2^24 or not.
+	 */
+	fraction = ror32(x, (msb - I2F_FRAC_BITS) & 0x1f) & I2F_MASK;
+	exponent = (127 + msb) << I2F_FRAC_BITS;
+
+	return (fraction + exponent) | sign;
+}
+
+#define MSI3101_CONVERT_IN_URB_HANDLER
+#define MSI3101_EXTENSIVE_DEBUG
+static int msi3101_convert_stream(struct msi3101_state *s, u32 *dst,
+		const u8 *src, unsigned int src_len)
+{
+	int i, j, k, l, i_max, dst_len = 0;
+	u16 sample[4];
+#ifdef MSI3101_EXTENSIVE_DEBUG
+	u32 symbol[3];
+#endif
+	/* There could be 1-3 1024 bytes URB frames */
+	i_max = src_len / 1024;
+	for (i = 0; i < i_max; i++) {
+#ifdef MSI3101_EXTENSIVE_DEBUG
+		symbol[i] = src[3] << 24 | src[2] << 16 | src[1] << 8 | src[0] << 0;
+		if (i == 0 && s->symbol_received != symbol[0]) {
+			dev_dbg(&s->udev->dev,
+					"%d symbols lost, %d %08x:%08x\n",
+					symbol[0] - s->symbol_received,
+					src_len, s->symbol_received, symbol[0]);
+		}
+#endif
+		src += 16;
+		for (j = 0; j < 6; j++) {
+			for (k = 0; k < 16; k++) {
+				for (l = 0; l < 10; l += 5) {
+					sample[0] = (src[l + 0] & 0xff) >> 0 | (src[l + 1] & 0x03) << 8;
+					sample[1] = (src[l + 1] & 0xfc) >> 2 | (src[l + 2] & 0x0f) << 6;
+					sample[2] = (src[l + 2] & 0xf0) >> 4 | (src[l + 3] & 0x3f) << 4;
+					sample[3] = (src[l + 3] & 0xc0) >> 6 | (src[l + 4] & 0xff) << 2;
+
+					*dst++ = msi3101_int2float(sample[0]);
+					*dst++ = msi3101_int2float(sample[1]);
+					*dst++ = msi3101_int2float(sample[2]);
+					*dst++ = msi3101_int2float(sample[3]);
+
+					/* 4 x 32bit float samples */
+					dst_len += 4 * 4;
+				}
+				src += 10;
+			}
+#ifdef MSI3101_EXTENSIVE_DEBUG
+			if (memcmp(src, "\xff\xff\xff\xff", 4) && memcmp(src, "\x00\x00\x00\x00", 4))
+				dev_dbg_ratelimited(&s->udev->dev,
+						"padding %*ph\n", 4, src);
+#endif
+			src += 4;
+		}
+		src += 24;
+	}
+
+#ifdef MSI3101_EXTENSIVE_DEBUG
+	/* calculate symbol rate and output it in 10 seconds intervals */
+	if ((s->jiffies + msecs_to_jiffies(10000)) <= jiffies) {
+		unsigned long jiffies_now = jiffies;
+		unsigned long msecs = jiffies_to_msecs(jiffies_now) - jiffies_to_msecs(s->jiffies);
+		unsigned int symbols = symbol[i_max - 1] - s->symbol;
+		s->jiffies = jiffies_now;
+		s->symbol = symbol[i_max - 1];
+		dev_dbg(&s->udev->dev,
+				"slen=%d symbols=%u msecs=%lu symbolrate=%lu\n",
+				src_len, symbols, msecs,
+				symbols * 1000UL / msecs);
+	}
+
+	/* last received symbol (symbol = symbol + i * 384) */
+	s->symbol_received = symbol[i_max - 1] + 384;
+#endif
+	return dst_len;
+}
+
+/*
+ * This gets called for the Isochronous pipe (stream). This is done in interrupt
+ * time, so it has to be fast, not crash, and not stall. Neat.
+ */
+static void msi3101_isoc_handler(struct urb *urb)
+{
+	struct msi3101_state *s = (struct msi3101_state *)urb->context;
+	int i, flen, fstatus;
+	unsigned char *iso_buf = NULL;
+	struct msi3101_frame_buf *fbuf;
+
+	if (urb->status == -ENOENT || urb->status == -ECONNRESET ||
+			urb->status == -ESHUTDOWN) {
+		dev_dbg(&s->udev->dev, "URB (%p) unlinked %ssynchronuously\n",
+				urb, urb->status == -ENOENT ? "" : "a");
+		return;
+	}
+
+	if (urb->status != 0) {
+		dev_dbg(&s->udev->dev,
+				"msi3101_isoc_handler() called with status %d\n",
+				urb->status);
+		/* Give up after a number of contiguous errors */
+		if (++s->isoc_errors > MAX_ISOC_ERRORS)
+			dev_dbg(&s->udev->dev,
+					"Too many ISOC errors, bailing out\n");
+		goto handler_end;
+	} else {
+		/* Reset ISOC error counter. We did get here, after all. */
+		s->isoc_errors = 0;
+	}
+
+	/* Compact data */
+	for (i = 0; i < urb->number_of_packets; i++) {
+		/* Check frame error */
+		fstatus = urb->iso_frame_desc[i].status;
+		if (fstatus) {
+			dev_dbg(&s->udev->dev,
+					"frame=%d/%d has error %d skipping\n",
+					i, urb->number_of_packets, fstatus);
+			goto skip;
+		}
+
+		/* Check if that frame contains data */
+		flen = urb->iso_frame_desc[i].actual_length;
+		if (flen == 0)
+			goto skip;
+
+		iso_buf = urb->transfer_buffer + urb->iso_frame_desc[i].offset;
+
+		/* Get free framebuffer */
+		fbuf = msi3101_get_next_fill_buf(s);
+		if (fbuf == NULL) {
+			s->vb_full++;
+			dev_dbg_ratelimited(&s->udev->dev,
+					"videobuf is full, %d packets dropped\n",
+					s->vb_full);
+			goto skip;
+		}
+
+		/* fill framebuffer */
+#ifdef MSI3101_CONVERT_IN_URB_HANDLER
+		vb2_set_plane_payload(&fbuf->vb, 0,
+				msi3101_convert_stream(s,
+				vb2_plane_vaddr(&fbuf->vb, 0), iso_buf, flen));
+#else
+		memcpy(fbuf->data, iso_buf, flen);
+		fbuf->filled = flen;
+#endif
+		vb2_buffer_done(&fbuf->vb, VB2_BUF_STATE_DONE);
+skip:
+		;
+	}
+
+handler_end:
+	i = usb_submit_urb(urb, GFP_ATOMIC);
+	if (i != 0)
+		dev_dbg(&s->udev->dev,
+				"Error (%d) re-submitting urb in msi3101_isoc_handler\n",
+				i);
+}
+
+static void msi3101_iso_stop(struct msi3101_state *s)
+{
+	int i;
+	dev_dbg(&s->udev->dev, "%s:\n", __func__);
+
+	/* Unlinking ISOC buffers one by one */
+	for (i = 0; i < MAX_ISO_BUFS; i++) {
+		if (s->urbs[i]) {
+			dev_dbg(&s->udev->dev, "Unlinking URB %p\n",
+					s->urbs[i]);
+			usb_kill_urb(s->urbs[i]);
+		}
+	}
+}
+
+static void msi3101_iso_free(struct msi3101_state *s)
+{
+	int i;
+	dev_dbg(&s->udev->dev, "%s:\n", __func__);
+
+	/* Freeing ISOC buffers one by one */
+	for (i = 0; i < MAX_ISO_BUFS; i++) {
+		if (s->urbs[i]) {
+			dev_dbg(&s->udev->dev, "Freeing URB\n");
+			if (s->urbs[i]->transfer_buffer) {
+				usb_free_coherent(s->udev,
+					s->urbs[i]->transfer_buffer_length,
+					s->urbs[i]->transfer_buffer,
+					s->urbs[i]->transfer_dma);
+			}
+			usb_free_urb(s->urbs[i]);
+			s->urbs[i] = NULL;
+		}
+	}
+}
+
+/* Both v4l2_lock and vb_queue_lock should be locked when calling this */
+static void msi3101_isoc_cleanup(struct msi3101_state *s)
+{
+	dev_dbg(&s->udev->dev, "%s:\n", __func__);
+
+	msi3101_iso_stop(s);
+	msi3101_iso_free(s);
+}
+
+/* Both v4l2_lock and vb_queue_lock should be locked when calling this */
+static int msi3101_isoc_init(struct msi3101_state *s)
+{
+	struct usb_device *udev;
+	struct urb *urb;
+	int i, j, ret;
+	dev_dbg(&s->udev->dev, "%s:\n", __func__);
+
+	s->isoc_errors = 0;
+	udev = s->udev;
+
+	ret = usb_set_interface(s->udev, 0, 1);
+	if (ret < 0)
+		return ret;
+
+	/* Allocate and init Isochronuous urbs */
+	for (i = 0; i < MAX_ISO_BUFS; i++) {
+		urb = usb_alloc_urb(ISO_FRAMES_PER_DESC, GFP_KERNEL);
+		if (urb == NULL) {
+			dev_err(&s->udev->dev,
+					"Failed to allocate urb %d\n", i);
+			msi3101_isoc_cleanup(s);
+			return -ENOMEM;
+		}
+		s->urbs[i] = urb;
+		dev_dbg(&s->udev->dev, "Allocated URB at 0x%p\n", urb);
+
+		urb->interval = 1;
+		urb->dev = udev;
+		urb->pipe = usb_rcvisocpipe(udev, 0x81);
+		urb->transfer_flags = URB_ISO_ASAP | URB_NO_TRANSFER_DMA_MAP;
+		urb->transfer_buffer = usb_alloc_coherent(udev, ISO_BUFFER_SIZE,
+				GFP_KERNEL, &urb->transfer_dma);
+		if (urb->transfer_buffer == NULL) {
+			dev_err(&s->udev->dev,
+					"Failed to allocate urb buffer %d\n",
+					i);
+			msi3101_isoc_cleanup(s);
+			return -ENOMEM;
+		}
+		urb->transfer_buffer_length = ISO_BUFFER_SIZE;
+		urb->complete = msi3101_isoc_handler;
+		urb->context = s;
+		urb->start_frame = 0;
+		urb->number_of_packets = ISO_FRAMES_PER_DESC;
+		for (j = 0; j < ISO_FRAMES_PER_DESC; j++) {
+			urb->iso_frame_desc[j].offset = j * ISO_MAX_FRAME_SIZE;
+			urb->iso_frame_desc[j].length = ISO_MAX_FRAME_SIZE;
+		}
+	}
+
+	/* link */
+	for (i = 0; i < MAX_ISO_BUFS; i++) {
+		ret = usb_submit_urb(s->urbs[i], GFP_KERNEL);
+		if (ret) {
+			dev_err(&s->udev->dev,
+					"isoc_init() submit_urb %d failed with error %d\n",
+					i, ret);
+			msi3101_isoc_cleanup(s);
+			return ret;
+		}
+		dev_dbg(&s->udev->dev, "URB 0x%p submitted.\n", s->urbs[i]);
+	}
+
+	/* All is done... */
+	return 0;
+}
+
+/* Must be called with vb_queue_lock hold */
+static void msi3101_cleanup_queued_bufs(struct msi3101_state *s)
+{
+	unsigned long flags = 0;
+	dev_dbg(&s->udev->dev, "%s:\n", __func__);
+
+	spin_lock_irqsave(&s->queued_bufs_lock, flags);
+	while (!list_empty(&s->queued_bufs)) {
+		struct msi3101_frame_buf *buf;
+
+		buf = list_entry(s->queued_bufs.next, struct msi3101_frame_buf,
+				 list);
+		list_del(&buf->list);
+		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+	}
+	spin_unlock_irqrestore(&s->queued_bufs_lock, flags);
+}
+
+/* The user yanked out the cable... */
+static void msi3101_disconnect(struct usb_interface *intf)
+{
+	struct v4l2_device *v = usb_get_intfdata(intf);
+	struct msi3101_state *s =
+			container_of(v, struct msi3101_state, v4l2_dev);
+	dev_dbg(&s->udev->dev, "%s:\n", __func__);
+
+	mutex_lock(&s->vb_queue_lock);
+	mutex_lock(&s->v4l2_lock);
+	/* No need to keep the urbs around after disconnection */
+	s->udev = NULL;
+
+	v4l2_device_disconnect(&s->v4l2_dev);
+	video_unregister_device(&s->vdev);
+	mutex_unlock(&s->v4l2_lock);
+	mutex_unlock(&s->vb_queue_lock);
+
+	v4l2_device_put(&s->v4l2_dev);
+}
+
+static int msi3101_querycap(struct file *file, void *fh,
+		struct v4l2_capability *cap)
+{
+	struct msi3101_state *s = video_drvdata(file);
+	dev_dbg(&s->udev->dev, "%s:\n", __func__);
+
+	strlcpy(cap->driver, KBUILD_MODNAME, sizeof(cap->driver));
+	strlcpy(cap->card, s->vdev.name, sizeof(cap->card));
+	usb_make_path(s->udev, cap->bus_info, sizeof(cap->bus_info));
+	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
+			V4L2_CAP_READWRITE;
+	cap->device_caps = V4L2_CAP_TUNER;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
+	return 0;
+}
+
+
+/* Videobuf2 operations */
+static int msi3101_queue_setup(struct vb2_queue *vq,
+		const struct v4l2_format *fmt, unsigned int *nbuffers,
+		unsigned int *nplanes, unsigned int sizes[], void *alloc_ctxs[])
+{
+	struct msi3101_state *s = vb2_get_drv_priv(vq);
+	dev_dbg(&s->udev->dev, "%s: *nbuffers=%d\n", __func__, *nbuffers);
+
+	/* Absolute min and max number of buffers available for mmap() */
+	*nbuffers = 32;
+	*nplanes = 1;
+	sizes[0] = PAGE_ALIGN(3 * 3072); /* 3 * 768 * 4 */
+	dev_dbg(&s->udev->dev, "%s: nbuffers=%d sizes[0]=%d\n",
+			__func__, *nbuffers, sizes[0]);
+	return 0;
+}
+
+static int msi3101_buf_init(struct vb2_buffer *vb)
+{
+	struct msi3101_state *s = vb2_get_drv_priv(vb->vb2_queue);
+	struct msi3101_frame_buf *fbuf =
+			container_of(vb, struct msi3101_frame_buf, vb);
+	dev_dbg(&s->udev->dev, "%s:\n", __func__);
+
+	fbuf->data = vzalloc(ISO_MAX_FRAME_SIZE);
+	if (fbuf->data == NULL)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static int msi3101_buf_prepare(struct vb2_buffer *vb)
+{
+	struct msi3101_state *s = vb2_get_drv_priv(vb->vb2_queue);
+
+	/* Don't allow queing new buffers after device disconnection */
+	if (!s->udev)
+		return -ENODEV;
+
+	return 0;
+}
+
+/*
+ * +===========================================================================
+ * |   00-1024 | USB packet
+ * +===========================================================================
+ * |   00-  03 | packet address
+ * +---------------------------------------------------------------------------
+ * |   04-  15 | garbage
+ * +---------------------------------------------------------------------------
+ * |   16- 175 | samples
+ * +---------------------------------------------------------------------------
+ * |  176- 179 | padding
+ * +---------------------------------------------------------------------------
+ * |  180- 339 | samples
+ * +---------------------------------------------------------------------------
+ * |  340- 343 | padding
+ * +---------------------------------------------------------------------------
+ * |  344- 503 | samples
+ * +---------------------------------------------------------------------------
+ * |  504- 507 | padding
+ * +---------------------------------------------------------------------------
+ * |  508- 667 | samples
+ * +---------------------------------------------------------------------------
+ * |  668- 671 | padding
+ * +---------------------------------------------------------------------------
+ * |  672- 831 | samples
+ * +---------------------------------------------------------------------------
+ * |  832- 835 | padding
+ * +---------------------------------------------------------------------------
+ * |  836- 995 | samples
+ * +---------------------------------------------------------------------------
+ * |  996- 999 | padding
+ * +---------------------------------------------------------------------------
+ * | 1000-1024 | garbage
+ * +---------------------------------------------------------------------------
+ *
+ * bytes 4 - 7 could have some meaning?
+ * padding is "00 00 00 00" or "ff ff ff ff"
+ * 6 * 16 * 2 * 4 = 768 samples. 768 * 4 = 3072 bytes
+ */
+#ifdef MSI3101_CONVERT_IN_URB_HANDLER
+static int msi3101_buf_finish(struct vb2_buffer *vb)
+{
+	return 0;
+}
+#else
+static int msi3101_buf_finish(struct vb2_buffer *vb)
+{
+	struct msi3101_state *s = vb2_get_drv_priv(vb->vb2_queue);
+	struct msi3101_frame_buf *fbuf =
+			container_of(vb, struct msi3101_frame_buf, vb);
+	int ret;
+	u32 *dst = vb2_plane_vaddr(&fbuf->vb, 0);
+	ret = msi3101_convert_stream(s, dst, fbuf->data, fbuf->filled);
+	vb2_set_plane_payload(&fbuf->vb, 0, ret);
+	return 0;
+}
+#endif
+
+static void msi3101_buf_cleanup(struct vb2_buffer *vb)
+{
+	struct msi3101_state *s = vb2_get_drv_priv(vb->vb2_queue);
+	struct msi3101_frame_buf *buf =
+			container_of(vb, struct msi3101_frame_buf, vb);
+	dev_dbg(&s->udev->dev, "%s:\n", __func__);
+
+	vfree(buf->data);
+}
+static void msi3101_buf_queue(struct vb2_buffer *vb)
+{
+	struct msi3101_state *s = vb2_get_drv_priv(vb->vb2_queue);
+	struct msi3101_frame_buf *buf =
+			container_of(vb, struct msi3101_frame_buf, vb);
+	unsigned long flags = 0;
+
+	/* Check the device has not disconnected between prep and queuing */
+	if (!s->udev) {
+		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		return;
+	}
+
+	spin_lock_irqsave(&s->queued_bufs_lock, flags);
+	list_add_tail(&buf->list, &s->queued_bufs);
+	spin_unlock_irqrestore(&s->queued_bufs_lock, flags);
+}
+
+#define CMD_WREG               0x41
+#define CMD_START_STREAMING    0x43
+#define CMD_STOP_STREAMING     0x45
+#define CMD_READ_UNKNOW        0x48
+
+#define msi3101_dbg_usb_control_msg(udev, r, t, v, _i, b, l) { \
+	char *direction; \
+	if (t == (USB_TYPE_VENDOR | USB_DIR_OUT)) \
+		direction = ">>>"; \
+	else \
+		direction = "<<<"; \
+	dev_dbg(&udev->dev, "%s: %02x %02x %02x %02x %02x %02x %02x %02x " \
+			"%s %*ph\n",  __func__, t, r, v & 0xff, v >> 8, \
+			_i & 0xff, _i >> 8, l & 0xff, l >> 8, direction, l, b); \
+}
+
+static int msi3101_ctrl_msg(struct msi3101_state *s, u8 cmd, u32 data)
+{
+	int ret;
+	u8 request = cmd;
+	u8 requesttype = USB_DIR_OUT | USB_TYPE_VENDOR;
+	u16 value = (data >> 0) & 0xffff;
+	u16 index = (data >> 16) & 0xffff;
+
+	msi3101_dbg_usb_control_msg(s->udev,
+			request, requesttype, value, index, NULL, 0);
+
+	ret = usb_control_msg(s->udev, usb_rcvctrlpipe(s->udev, 0),
+			request, requesttype, value, index, NULL, 0, 2000);
+
+	if (ret)
+		dev_err(&s->udev->dev, "%s: failed %d, cmd %02x, data %04x\n",
+				__func__, ret, cmd, data);
+
+	return ret;
+};
+
+static int msi3101_tuner_write(struct msi3101_state *s, u32 data)
+{
+	return msi3101_ctrl_msg(s, CMD_WREG, data << 8 | 0x09);
+};
+
+#define F_REF 24000000
+static int msi3101_set_usb_adc(struct msi3101_state *s)
+{
+	int ret, div_n, div_m, div_r_out, f_sr;
+	u32 reg4, reg3;
+	/*
+	 * FIXME: Synthesizer config is just a educated guess...
+	 * It seems to give reasonable values when N is 5-12 and output
+	 * divider R is 2, which means sampling rates 5-12 Msps in practise.
+	 *
+	 * reg 3 ADC synthesizer config
+	 * [7:0]   0x03, register address
+	 * [8]     1, always
+	 * [9]     ?
+	 * [12:10] output divider
+	 * [13]    0 ?
+	 * [14]    0 ?
+	 * [15]    increase sr by max fract
+	 * [16:19] N
+	 * [23:20] ?
+	 * [24:31] 0x01
+	 *
+	 * output divider
+	 * val   div
+	 *   0     - (invalid)
+	 *   1     2
+	 *   2     3
+	 *   3     4
+	 *   4     5
+	 *   5     6
+	 *   6     7
+	 *   7     8
+	 */
+
+	f_sr = s->ctrl_sampling_rate->val64;
+	reg3 = 0x01c00303;
+
+	for (div_n = 12; div_n > 5; div_n--) {
+		if (f_sr >= div_n * 1000000)
+			break;
+	}
+
+	reg3 |= div_n << 16;
+
+	for (div_r_out = 2; div_r_out < 8; div_r_out++) {
+		if (f_sr >= div_n * F_REF / div_r_out / 12)
+			break;
+	}
+
+	reg3 |= (div_r_out - 1) << 10;
+	div_m = f_sr % (div_n * F_REF / div_r_out / 12);
+
+	if (div_m >= 500000) {
+		reg3 |= 1 << 15;
+		div_m -= 500000;
+	}
+
+	reg4 = ((div_m * 0x0ffffful / 500000) << 8) | 0x04;
+
+	dev_dbg(&s->udev->dev, "%s: sr=%d n=%d m=%d r_out=%d reg4=%08x\n",
+			__func__, f_sr, div_n, div_m, div_r_out, reg4);
+
+	ret = msi3101_ctrl_msg(s, CMD_WREG, 0x00608008);
+	if (ret)
+		goto err;
+
+	ret = msi3101_ctrl_msg(s, CMD_WREG, 0x00000c05);
+	if (ret)
+		goto err;
+
+	ret = msi3101_ctrl_msg(s, CMD_WREG, 0x00020000);
+	if (ret)
+		goto err;
+
+	ret = msi3101_ctrl_msg(s, CMD_WREG, 0x00480102);
+	if (ret)
+		goto err;
+
+	ret = msi3101_ctrl_msg(s, CMD_WREG, 0x00f38008);
+	if (ret)
+		goto err;
+
+	ret = msi3101_ctrl_msg(s, CMD_WREG, 0x0000a507);
+	if (ret)
+		goto err;
+
+	ret = msi3101_ctrl_msg(s, CMD_WREG, reg4);
+	if (ret)
+		goto err;
+
+	ret = msi3101_ctrl_msg(s, CMD_WREG, reg3);
+	if (ret)
+		goto err;
+err:
+	return ret;
+};
+
+static int msi3101_set_tuner(struct msi3101_state *s)
+{
+	int i, ret, len;
+	u32 reg, synthstep, thresh, n, frac;
+	u64 fsynth;
+	u8 mode, lo_div;
+	const struct msi3101_gain *gain_lut;
+	static const struct {
+		u32 rf;
+		u8 mode;
+		u8 lo_div;
+	} band_lut[] = {
+		{ 30000000, 0x01, 16}, /* AM_MODE1 */
+		{108000000, 0x02, 32}, /* VHF_MODE */
+		{240000000, 0x04, 16}, /* B3_MODE */
+		{960000000, 0x08,  4}, /* B45_MODE */
+		{167500000, 0x10,  2}, /* BL_MODE */
+	};
+	static const struct {
+		u32 freq;
+		u8 val;
+	} if_freq_lut[] = {
+		{      0, 0x03}, /* Zero IF */
+		{ 450000, 0x02}, /* 450 kHz IF */
+		{1620000, 0x01}, /* 1.62 MHz IF */
+		{2048000, 0x00}, /* 2.048 MHz IF */
+	};
+	static const struct {
+		u32 freq;
+		u8 val;
+	} bandwidth_lut[] = {
+		{ 200000, 0x00}, /* 200 kHz */
+		{ 300000, 0x01}, /* 300 kHz */
+		{ 600000, 0x02}, /* 600 kHz */
+		{1536000, 0x03}, /* 1.536 MHz */
+		{5000000, 0x04}, /* 5 MHz */
+		{6000000, 0x05}, /* 6 MHz */
+		{7000000, 0x06}, /* 7 MHz */
+		{8000000, 0x07}, /* 8 MHz */
+	};
+
+	unsigned int rf_freq = s->ctrl_tuner_rf->val64;
+
+	/*
+	 * bandwidth (Hz)
+	 * 200000, 300000, 600000, 1536000, 5000000, 6000000, 7000000, 8000000
+	 */
+	int bandwidth = s->ctrl_tuner_bw->val;
+
+	/*
+	 * intermediate frequency (Hz)
+	 * 0, 450000, 1620000, 2048000
+	 */
+	int if_freq = s->ctrl_tuner_if->val;
+
+	/*
+	 * gain reduction (dB)
+	 * 0 - 102 below 420 MHz
+	 * 0 - 85 above 420 MHz
+	 */
+	int gain = s->ctrl_tuner_gain->val;
+
+	dev_dbg(&s->udev->dev,
+			"%s: rf_freq=%d bandwidth=%d if_freq=%d gain=%d\n",
+			__func__, rf_freq, bandwidth, if_freq, gain);
+
+	ret = -EINVAL;
+
+	for (i = 0; i < ARRAY_SIZE(band_lut); i++) {
+		if (rf_freq <= band_lut[i].rf) {
+			mode = band_lut[i].mode;
+			lo_div = band_lut[i].lo_div;
+			break;
+		}
+	}
+
+	if (i == ARRAY_SIZE(band_lut))
+		goto err;
+
+	for (i = 0; i < ARRAY_SIZE(if_freq_lut); i++) {
+		if (if_freq == if_freq_lut[i].freq) {
+			if_freq = if_freq_lut[i].val;
+			break;
+		}
+	}
+
+	if (i == ARRAY_SIZE(if_freq_lut))
+		goto err;
+
+	for (i = 0; i < ARRAY_SIZE(bandwidth_lut); i++) {
+		if (bandwidth == bandwidth_lut[i].freq) {
+			bandwidth = bandwidth_lut[i].val;
+			break;
+		}
+	}
+
+	if (i == ARRAY_SIZE(bandwidth_lut))
+		goto err;
+
+	#define FSTEP 10000
+	#define FREF1 24000000
+	fsynth = (rf_freq + 0) * lo_div;
+	synthstep = FSTEP * lo_div;
+	thresh = (FREF1 * 4) / synthstep;
+	n = fsynth / (FREF1 * 4);
+	frac = thresh * (fsynth % (FREF1 * 4)) / (FREF1 * 4);
+
+	if (thresh > 4095 || n > 63 || frac > 4095) {
+		dev_dbg(&s->udev->dev,
+				"%s: synth setup failed rf=%d thresh=%d n=%d frac=%d\n",
+				__func__, rf_freq, thresh, n, frac);
+		ret = -EINVAL;
+		goto err;
+	}
+
+	ret = msi3101_tuner_write(s, 0x00000e);
+	ret = msi3101_tuner_write(s, 0x000003);
+
+	reg = 0 << 0;
+	reg |= mode << 4;
+	reg |= 1 << 10;
+	reg |= if_freq << 12;
+	reg |= bandwidth << 14;
+	reg |= 0x02 << 17;
+	reg |= 0x00 << 20;
+	ret = msi3101_tuner_write(s, reg);
+	if (ret)
+		goto err;
+
+	reg = 5 << 0;
+	reg |= thresh << 4;
+	reg |= 1 << 19;
+	reg |= 1 << 21;
+	ret = msi3101_tuner_write(s, reg);
+	if (ret)
+		goto err;
+
+	reg = 2 << 0;
+	reg |= frac << 4;
+	reg |= n << 16;
+	ret = msi3101_tuner_write(s, reg);
+	if (ret)
+		goto err;
+
+	if (rf_freq < 120000000) {
+		gain_lut = msi3101_gain_lut_120;
+		len = ARRAY_SIZE(msi3101_gain_lut_120);
+	} else if (rf_freq < 245000000) {
+		gain_lut = msi3101_gain_lut_245;
+		len = ARRAY_SIZE(msi3101_gain_lut_120);
+	} else {
+		gain_lut = msi3101_gain_lut_1000;
+		len = ARRAY_SIZE(msi3101_gain_lut_1000);
+	}
+
+	for (i = 0; i < len; i++) {
+		if (gain_lut[i].tot >= gain)
+			break;
+	}
+
+	if (i == len)
+		goto err;
+
+	dev_dbg(&s->udev->dev,
+			"%s: gain tot=%d baseband=%d lna=%d mixer=%d\n",
+			__func__, gain_lut[i].tot, gain_lut[i].baseband,
+			gain_lut[i].lna, gain_lut[i].mixer);
+
+	reg = 1 << 0;
+	reg |= gain_lut[i].baseband << 4;
+	reg |= 0 << 10;
+	reg |= gain_lut[i].mixer << 12;
+	reg |= gain_lut[i].lna << 13;
+	reg |= 4 << 14;
+	reg |= 0 << 17;
+	ret = msi3101_tuner_write(s, reg);
+	if (ret)
+		goto err;
+
+	reg = 6 << 0;
+	reg |= 63 << 4;
+	reg |= 4095 << 10;
+	ret = msi3101_tuner_write(s, reg);
+	if (ret)
+		goto err;
+
+	return 0;
+err:
+	dev_dbg(&s->udev->dev, "%s: failed %d\n", __func__, ret);
+	return ret;
+};
+
+static int msi3101_start_streaming(struct vb2_queue *vq, unsigned int count)
+{
+	struct msi3101_state *s = vb2_get_drv_priv(vq);
+	int ret;
+	dev_dbg(&s->udev->dev, "%s:\n", __func__);
+
+	if (!s->udev)
+		return -ENODEV;
+
+	if (mutex_lock_interruptible(&s->v4l2_lock))
+		return -ERESTARTSYS;
+
+	ret = msi3101_set_usb_adc(s);
+
+	ret = msi3101_isoc_init(s);
+	if (ret)
+		msi3101_cleanup_queued_bufs(s);
+
+	ret = msi3101_ctrl_msg(s, CMD_START_STREAMING, 0);
+
+	mutex_unlock(&s->v4l2_lock);
+
+	return ret;
+}
+
+static int msi3101_stop_streaming(struct vb2_queue *vq)
+{
+	struct msi3101_state *s = vb2_get_drv_priv(vq);
+	dev_dbg(&s->udev->dev, "%s:\n", __func__);
+
+	if (mutex_lock_interruptible(&s->v4l2_lock))
+		return -ERESTARTSYS;
+
+	msi3101_ctrl_msg(s, CMD_STOP_STREAMING, 0);
+
+	if (s->udev)
+		msi3101_isoc_cleanup(s);
+
+	msi3101_cleanup_queued_bufs(s);
+	mutex_unlock(&s->v4l2_lock);
+
+	return 0;
+}
+
+static struct vb2_ops msi3101_vb2_ops = {
+	.queue_setup            = msi3101_queue_setup,
+	.buf_init               = msi3101_buf_init,
+	.buf_prepare            = msi3101_buf_prepare,
+	.buf_finish             = msi3101_buf_finish,
+	.buf_cleanup            = msi3101_buf_cleanup,
+	.buf_queue              = msi3101_buf_queue,
+	.start_streaming        = msi3101_start_streaming,
+	.stop_streaming         = msi3101_stop_streaming,
+	.wait_prepare           = vb2_ops_wait_prepare,
+	.wait_finish            = vb2_ops_wait_finish,
+};
+
+static int msi3101_enum_input(struct file *file, void *fh, struct v4l2_input *i)
+{
+	if (i->index != 0)
+		return -EINVAL;
+
+	strlcpy(i->name, "SDR data", sizeof(i->name));
+	i->type = V4L2_INPUT_TYPE_CAMERA;
+
+	return 0;
+}
+
+static int msi3101_g_input(struct file *file, void *fh, unsigned int *i)
+{
+	*i = 0;
+
+	return 0;
+}
+
+static int msi3101_s_input(struct file *file, void *fh, unsigned int i)
+{
+	return i ? -EINVAL : 0;
+}
+
+static int vidioc_s_tuner(struct file *file, void *priv,
+		const struct v4l2_tuner *v)
+{
+	struct msi3101_state *s = video_drvdata(file);
+	dev_dbg(&s->udev->dev, "%s:\n", __func__);
+
+	return 0;
+}
+
+static int vidioc_g_tuner(struct file *file, void *priv, struct v4l2_tuner *v)
+{
+	struct msi3101_state *s = video_drvdata(file);
+	dev_dbg(&s->udev->dev, "%s:\n", __func__);
+
+	strcpy(v->name, "SDR RX");
+	v->capability = V4L2_TUNER_CAP_LOW;
+
+	return 0;
+}
+
+static int vidioc_s_frequency(struct file *file, void *priv,
+		const struct v4l2_frequency *f)
+{
+	struct msi3101_state *s = video_drvdata(file);
+	dev_dbg(&s->udev->dev, "%s: frequency=%u Hz (%d)\n",
+			__func__, f->frequency * 625U / 10U, f->frequency);
+
+	return v4l2_ctrl_s_ctrl_int64(s->ctrl_tuner_rf,
+			f->frequency * 625U / 10U);
+}
+
+const struct v4l2_ioctl_ops msi3101_ioctl_ops = {
+	.vidioc_querycap          = msi3101_querycap,
+
+	.vidioc_enum_input        = msi3101_enum_input,
+	.vidioc_g_input           = msi3101_g_input,
+	.vidioc_s_input           = msi3101_s_input,
+
+	.vidioc_reqbufs           = vb2_ioctl_reqbufs,
+	.vidioc_create_bufs       = vb2_ioctl_create_bufs,
+	.vidioc_prepare_buf       = vb2_ioctl_prepare_buf,
+	.vidioc_querybuf          = vb2_ioctl_querybuf,
+	.vidioc_qbuf              = vb2_ioctl_qbuf,
+	.vidioc_dqbuf             = vb2_ioctl_dqbuf,
+
+	.vidioc_streamon          = vb2_ioctl_streamon,
+	.vidioc_streamoff         = vb2_ioctl_streamoff,
+
+	.vidioc_g_tuner           = vidioc_g_tuner,
+	.vidioc_s_tuner           = vidioc_s_tuner,
+	.vidioc_s_frequency       = vidioc_s_frequency,
+
+	.vidioc_subscribe_event   = v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
+	.vidioc_log_status        = v4l2_ctrl_log_status,
+};
+
+static const struct v4l2_file_operations msi3101_fops = {
+	.owner                    = THIS_MODULE,
+	.open                     = v4l2_fh_open,
+	.release                  = vb2_fop_release,
+	.read                     = vb2_fop_read,
+	.poll                     = vb2_fop_poll,
+	.mmap                     = vb2_fop_mmap,
+	.unlocked_ioctl           = video_ioctl2,
+};
+
+static struct video_device msi3101_template = {
+	.name                     = "Mirics MSi3101 SDR Dongle",
+	.release                  = video_device_release_empty,
+	.fops                     = &msi3101_fops,
+	.ioctl_ops                = &msi3101_ioctl_ops,
+};
+
+static int msi3101_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct msi3101_state *s =
+			container_of(ctrl->handler, struct msi3101_state,
+					ctrl_handler);
+	int ret;
+	dev_dbg(&s->udev->dev,
+			"%s: id=%d name=%s val=%d min=%d max=%d step=%d\n",
+			__func__, ctrl->id, ctrl->name, ctrl->val,
+			ctrl->minimum, ctrl->maximum, ctrl->step);
+
+	switch (ctrl->id) {
+	case MSI3101_CID_SAMPLING_RATE:
+	case MSI3101_CID_SAMPLING_RESOLUTION:
+		ret = 0;
+		break;
+	case MSI3101_CID_TUNER_RF:
+	case MSI3101_CID_TUNER_BW:
+	case MSI3101_CID_TUNER_IF:
+	case MSI3101_CID_TUNER_GAIN:
+		ret = msi3101_set_tuner(s);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+static const struct v4l2_ctrl_ops msi3101_ctrl_ops = {
+	.s_ctrl = msi3101_s_ctrl,
+};
+
+static void msi3101_video_release(struct v4l2_device *v)
+{
+	struct msi3101_state *s =
+			container_of(v, struct msi3101_state, v4l2_dev);
+
+	v4l2_ctrl_handler_free(&s->ctrl_handler);
+	v4l2_device_unregister(&s->v4l2_dev);
+	kfree(s);
+}
+
+static int msi3101_probe(struct usb_interface *intf,
+		const struct usb_device_id *id)
+{
+	struct usb_device *udev = interface_to_usbdev(intf);
+	struct msi3101_state *s = NULL;
+	int ret;
+	static const struct v4l2_ctrl_config ctrl_sampling_rate = {
+		.ops	= &msi3101_ctrl_ops,
+		.id	= MSI3101_CID_SAMPLING_RATE,
+		.type	= V4L2_CTRL_TYPE_INTEGER64,
+		.name	= "Sampling Rate",
+		.min	= 500000,
+		.max	= 12000000,
+		.def    = 2048000,
+		.step	= 1,
+	};
+	static const struct v4l2_ctrl_config ctrl_sampling_resolution = {
+		.ops	= &msi3101_ctrl_ops,
+		.id	= MSI3101_CID_SAMPLING_RESOLUTION,
+		.type	= V4L2_CTRL_TYPE_INTEGER,
+		.flags  = V4L2_CTRL_FLAG_INACTIVE,
+		.name	= "Sampling Resolution",
+		.min	= 10,
+		.max	= 10,
+		.def    = 10,
+		.step	= 1,
+	};
+	static const struct v4l2_ctrl_config ctrl_tuner_rf = {
+		.ops	= &msi3101_ctrl_ops,
+		.id	= MSI3101_CID_TUNER_RF,
+		.type   = V4L2_CTRL_TYPE_INTEGER64,
+		.name	= "Tuner RF",
+		.min	= 40000000,
+		.max	= 2000000000,
+		.def    = 100000000,
+		.step	= 1,
+	};
+	static const struct v4l2_ctrl_config ctrl_tuner_bw = {
+		.ops	= &msi3101_ctrl_ops,
+		.id	= MSI3101_CID_TUNER_BW,
+		.type	= V4L2_CTRL_TYPE_INTEGER,
+		.name	= "Tuner BW",
+		.min	= 200000,
+		.max	= 8000000,
+		.def    = 600000,
+		.step	= 1,
+	};
+	static const struct v4l2_ctrl_config ctrl_tuner_if = {
+		.ops	= &msi3101_ctrl_ops,
+		.id	= MSI3101_CID_TUNER_IF,
+		.type	= V4L2_CTRL_TYPE_INTEGER,
+		.flags  = V4L2_CTRL_FLAG_INACTIVE,
+		.name	= "Tuner IF",
+		.min	= 0,
+		.max	= 2048000,
+		.def    = 0,
+		.step	= 1,
+	};
+	static const struct v4l2_ctrl_config ctrl_tuner_gain = {
+		.ops	= &msi3101_ctrl_ops,
+		.id	= MSI3101_CID_TUNER_GAIN,
+		.type	= V4L2_CTRL_TYPE_INTEGER,
+		.name	= "Tuner Gain",
+		.min	= 0,
+		.max	= 102,
+		.def    = 0,
+		.step	= 1,
+	};
+
+	s = kzalloc(sizeof(struct msi3101_state), GFP_KERNEL);
+	if (s == NULL) {
+		pr_err("Could not allocate memory for msi3101_state\n");
+		return -ENOMEM;
+	}
+
+	mutex_init(&s->v4l2_lock);
+	mutex_init(&s->vb_queue_lock);
+	spin_lock_init(&s->queued_bufs_lock);
+	INIT_LIST_HEAD(&s->queued_bufs);
+
+	s->udev = udev;
+
+	/* Init videobuf2 queue structure */
+	s->vb_queue.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	s->vb_queue.io_modes = VB2_MMAP | VB2_USERPTR | VB2_READ;
+	s->vb_queue.drv_priv = s;
+	s->vb_queue.buf_struct_size = sizeof(struct msi3101_frame_buf);
+	s->vb_queue.ops = &msi3101_vb2_ops;
+	s->vb_queue.mem_ops = &vb2_vmalloc_memops;
+	s->vb_queue.timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+	ret = vb2_queue_init(&s->vb_queue);
+	if (ret < 0) {
+		dev_err(&s->udev->dev, "Could not initialize vb2 queue\n");
+		goto err_free_mem;
+	}
+
+	/* Init video_device structure */
+	s->vdev = msi3101_template;
+	s->vdev.queue = &s->vb_queue;
+	s->vdev.queue->lock = &s->vb_queue_lock;
+	set_bit(V4L2_FL_USE_FH_PRIO, &s->vdev.flags);
+	video_set_drvdata(&s->vdev, s);
+
+	/* Register controls */
+	v4l2_ctrl_handler_init(&s->ctrl_handler, 6);
+	s->ctrl_sampling_rate = v4l2_ctrl_new_custom(&s->ctrl_handler, &ctrl_sampling_rate, NULL);
+	v4l2_ctrl_new_custom(&s->ctrl_handler, &ctrl_sampling_resolution, NULL);
+	s->ctrl_tuner_rf = v4l2_ctrl_new_custom(&s->ctrl_handler, &ctrl_tuner_rf, NULL);
+	s->ctrl_tuner_bw = v4l2_ctrl_new_custom(&s->ctrl_handler, &ctrl_tuner_bw, NULL);
+	s->ctrl_tuner_if = v4l2_ctrl_new_custom(&s->ctrl_handler, &ctrl_tuner_if, NULL);
+	s->ctrl_tuner_gain = v4l2_ctrl_new_custom(&s->ctrl_handler, &ctrl_tuner_gain, NULL);
+	if (s->ctrl_handler.error) {
+		ret = s->ctrl_handler.error;
+		dev_err(&s->udev->dev, "Could not initialize controls\n");
+		goto err_free_controls;
+	}
+
+	/* Register the v4l2_device structure */
+	s->v4l2_dev.release = msi3101_video_release;
+	ret = v4l2_device_register(&intf->dev, &s->v4l2_dev);
+	if (ret) {
+		dev_err(&s->udev->dev,
+				"Failed to register v4l2-device (%d)\n", ret);
+		goto err_free_controls;
+	}
+
+	s->v4l2_dev.ctrl_handler = &s->ctrl_handler;
+	s->vdev.v4l2_dev = &s->v4l2_dev;
+	s->vdev.lock = &s->v4l2_lock;
+
+	ret = video_register_device(&s->vdev, VFL_TYPE_GRABBER, -1);
+	if (ret < 0) {
+		dev_err(&s->udev->dev,
+				"Failed to register as video device (%d)\n",
+				ret);
+		goto err_unregister_v4l2_dev;
+	}
+	dev_info(&s->udev->dev, "Registered as %s\n",
+			video_device_node_name(&s->vdev));
+
+	return 0;
+
+err_unregister_v4l2_dev:
+	v4l2_device_unregister(&s->v4l2_dev);
+err_free_controls:
+	v4l2_ctrl_handler_free(&s->ctrl_handler);
+err_free_mem:
+	kfree(s);
+	return ret;
+}
+
+/* USB device ID list */
+static struct usb_device_id msi3101_id_table[] = {
+	{ USB_DEVICE(0x1df7, 0x2500) },
+	{ }
+};
+MODULE_DEVICE_TABLE(usb, msi3101_id_table);
+
+/* USB subsystem interface */
+static struct usb_driver msi3101_driver = {
+	.name                     = KBUILD_MODNAME,
+	.probe                    = msi3101_probe,
+	.disconnect               = msi3101_disconnect,
+	.id_table                 = msi3101_id_table,
+};
+
+module_usb_driver(msi3101_driver);
+
+MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
+MODULE_DESCRIPTION("Mirics MSi3101 SDR Dongle");
+MODULE_LICENSE("GPL");
-- 
1.7.11.7

