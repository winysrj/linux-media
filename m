Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:42400 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734Ab2BPSYJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Feb 2012 13:24:09 -0500
Received: from euspt2 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LZI00GT30G5NM@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 16 Feb 2012 18:24:05 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LZI00FB30G4MA@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 16 Feb 2012 18:24:05 +0000 (GMT)
Date: Thu, 16 Feb 2012 19:23:59 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [RFC/PATCH 6/6] s5p-csis: Add support for non-image data packets
 capture
In-reply-to: <1329416639-19454-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	s.nawrocki@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1329416639-19454-7-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1329416639-19454-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

MIPI-CSI has internal memory mapped buffers for the frame embedded
(non-image) data. There are two buffers, for even and odd frames which
need to be saved after an interrupt is raised. The packet data buffers
size is 4 KiB and there is no status register in the hardware where the
actual non-image data size can be read from. Hence the driver uses
pre-allocated buffers of 4 KiB in size to save the whole PKTDATA memory.
The packet data is copied to the bridge allocated buffers within
g_embedded_data callback. This will form a separate plane in the user
buffer.

When FIMC DMA engine is stopped by the driver due the to user space
not keeping up with buffer de-queuing the MIPI-CSIS will still run,
however it must discard data which is not captured by FIMC. For this
purpose FIMC driver sends VSYNC interrupt notification through
interrupt_service_routine callback which provides MIPI-CSIS with
information the header/footer of which frame is to be captured.

This patch also adds the hardware event/error counters which can be
dumped through VIDIOC_LOG_STATUS ioctl. The counters are reset in each
s_stream(1) call. Any errors are logged after streaming is turned off.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/mipi-csis.c |  305 ++++++++++++++++++++++++++++--
 1 files changed, 286 insertions(+), 19 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/mipi-csis.c b/drivers/media/video/s5p-fimc/mipi-csis.c
index 04f1a0d..15a0eb5 100644
--- a/drivers/media/video/s5p-fimc/mipi-csis.c
+++ b/drivers/media/video/s5p-fimc/mipi-csis.c
@@ -9,6 +9,8 @@
  * published by the Free Software Foundation.
  */
 
+#define pr_fmt(fmt) "%s:%d " fmt, __func__, __LINE__
+
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/device.h>
@@ -25,13 +27,14 @@
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/videodev2.h>
+#include <linux/vmalloc.h>
 #include <media/v4l2-subdev.h>
 #include <plat/mipi_csis.h>
 #include "mipi-csis.h"
 
 static int debug;
 module_param(debug, int, 0644);
-MODULE_PARM_DESC(debug, "Debug level (0-1)");
+MODULE_PARM_DESC(debug, "Debug level (0-2)");
 
 /* Register map definition */
 
@@ -60,16 +63,51 @@ MODULE_PARM_DESC(debug, "Debug level (0-1)");
 #define S5PCSIS_CFG_FMT_MASK		(0x3f << 2)
 #define S5PCSIS_CFG_NR_LANE_MASK	3
 
-/* Interrupt mask. */
+/* Interrupt mask */
 #define S5PCSIS_INTMSK			0x10
-#define S5PCSIS_INTMSK_EN_ALL		0xf000003f
+#define S5PCSIS_INTMSK_EN_ALL		0xf000103f
+#define S5PCSIS_INTMSK_EVEN_BEFORE	(1 << 31)
+#define S5PCSIS_INTMSK_EVEN_AFTER	(1 << 30)
+#define S5PCSIS_INTMSK_ODD_BEFORE	(1 << 29)
+#define S5PCSIS_INTMSK_ODD_AFTER	(1 << 28)
+#define S5PCSIS_INTMSK_ERR_SOT_HS	(1 << 12)
+#define S5PCSIS_INTMSK_ERR_LOST_FS	(1 << 5)
+#define S5PCSIS_INTMSK_ERR_LOST_FE	(1 << 4)
+#define S5PCSIS_INTMSK_ERR_OVER		(1 << 3)
+#define S5PCSIS_INTMSK_ERR_ECC		(1 << 2)
+#define S5PCSIS_INTMSK_ERR_CRC		(1 << 1)
+#define S5PCSIS_INTMSK_ERR_UNKNOWN	(1 << 0)
+
+/* Interrupt source */
 #define S5PCSIS_INTSRC			0x14
+#define S5PCSIS_INTSRC_EVEN_BEFORE	(1 << 31)
+#define S5PCSIS_INTSRC_EVEN_AFTER	(1 << 30)
+#define S5PCSIS_INTSRC_EVEN		(0x3 << 30)
+#define S5PCSIS_INTSRC_ODD_BEFORE	(1 << 29)
+#define S5PCSIS_INTSRC_ODD_AFTER	(1 << 28)
+#define S5PCSIS_INTSRC_ODD		(0x3 << 28)
+#define S5PCSIS_INTSRC_NON_IMAGE_DATA	(0xff << 28)
+#define S5PCSIS_INTSRC_ERR_SOT_HS	(0xf << 12)
+#define S5PCSIS_INTSRC_ERR_LOST_FS	(1 << 5)
+#define S5PCSIS_INTSRC_ERR_LOST_FE	(1 << 4)
+#define S5PCSIS_INTSRC_ERR_OVER		(1 << 3)
+#define S5PCSIS_INTSRC_ERR_ECC		(1 << 2)
+#define S5PCSIS_INTSRC_ERR_CRC		(1 << 1)
+#define S5PCSIS_INTSRC_ERR_UNKNOWN	(1 << 0)
+#define S5PCSIS_INTSRC_ERRORS		0xf03f
 
 /* Pixel resolution */
 #define S5PCSIS_RESOL			0x2c
 #define CSIS_MAX_PIX_WIDTH		0xffff
 #define CSIS_MAX_PIX_HEIGHT		0xffff
 
+/* Non-image packet data buffers */
+#define S5PCSIS_PKTDATA_ODD		0x2000
+#define S5PCSIS_PKTDATA_EVEN		0x3000
+#define S5PCSIS_PKTDATA_SIZE		SZ_4K
+/* Number of non-image data buffers */
+#define S5PCSIS_NUM_BUFFERS		4
+
 enum {
 	CSIS_CLK_MUX,
 	CSIS_CLK_GATE,
@@ -93,6 +131,35 @@ enum {
 	ST_SUSPENDED	= 4,
 };
 
+struct s5pcsis_event {
+	u32 mask;
+	const char * const name;
+	unsigned int counter;
+};
+
+static const struct s5pcsis_event s5pcsis_events[] = {
+	/* Errors */
+	{ S5PCSIS_INTSRC_ERR_SOT_HS,	"SOT Error" },
+	{ S5PCSIS_INTSRC_ERR_LOST_FS,	"Lost FS Error" },
+	{ S5PCSIS_INTSRC_ERR_LOST_FE,	"Lost FE Error" },
+	{ S5PCSIS_INTSRC_ERR_OVER,	"OVER Error" },
+	{ S5PCSIS_INTSRC_ERR_ECC,	"ECC Error" },
+	{ S5PCSIS_INTSRC_ERR_CRC,	"CRC Error" },
+	{ S5PCSIS_INTSRC_ERR_UNKNOWN,	"Unknown Error" },
+	/* Non-image data receive events */
+	{ S5PCSIS_INTSRC_EVEN_BEFORE,	"Non-image data before even frame" },
+	{ S5PCSIS_INTSRC_EVEN_AFTER,	"Non-image data after even frame" },
+	{ S5PCSIS_INTSRC_ODD_BEFORE,	"Non-image data before odd frame" },
+	{ S5PCSIS_INTSRC_ODD_AFTER,	"Non-image data after odd frame" },
+};
+#define S5PCSIS_NUM_EVENTS ARRAY_SIZE(s5pcsis_events)
+
+struct csis_pktbuf {
+	u32 *data;
+	unsigned int len;
+	struct list_head list;
+};
+
 /**
  * struct csis_state - the driver's internal state data structure
  * @lock: mutex serializing the subdev and power management operations,
@@ -101,11 +168,19 @@ enum {
  * @sd: v4l2_subdev associated with CSIS device instance
  * @pdev: CSIS platform device
  * @regs: mmaped I/O registers memory
+ * @supplies: CSIS regulator supplies
  * @clock: CSIS clocks
  * @irq: requested s5p-mipi-csis irq number
  * @flags: the state variable for power and streaming control
  * @csis_fmt: current CSIS pixel format
  * @format: common media bus format for the source and sink pad
+ * @slock: spinlock protecting structure members below
+ * @empty_buf_list: list of empty non-image data buffers
+ * @empty_buf_list: list of filled non-image data buffers
+ * @buffers: the frame embedded (non-image) data buffers
+ * @frame_seq: data frame sequence number (updated from FIMC)
+ * @last_frame_seq: sequence number of the last serviced frame
+ * @events: MIPI-CSIS event (error) counters
  */
 struct csis_state {
 	struct mutex lock;
@@ -119,6 +194,14 @@ struct csis_state {
 	u32 flags;
 	const struct csis_pix_format *csis_fmt;
 	struct v4l2_mbus_framefmt format;
+
+	struct spinlock slock;
+	struct list_head empty_buf_list;
+	struct list_head ready_buf_list;
+	struct csis_pktbuf buffers[S5PCSIS_NUM_BUFFERS];
+	unsigned int frame_seq;
+	unsigned int last_frame_seq;
+	struct s5pcsis_event events[S5PCSIS_NUM_EVENTS];
 };
 
 /**
@@ -291,17 +374,6 @@ err:
 	return -ENXIO;
 }
 
-static int s5pcsis_s_power(struct v4l2_subdev *sd, int on)
-{
-	struct csis_state *state = sd_to_csis_state(sd);
-	struct device *dev = &state->pdev->dev;
-
-	if (on)
-		return pm_runtime_get_sync(dev);
-
-	return pm_runtime_put_sync(dev);
-}
-
 static void s5pcsis_start_stream(struct csis_state *state)
 {
 	s5pcsis_reset(state);
@@ -316,7 +388,86 @@ static void s5pcsis_stop_stream(struct csis_state *state)
 	s5pcsis_system_enable(state, false);
 }
 
-/* v4l2_subdev operations */
+/*
+ * Non-image data packet queue handling
+ */
+static void s5pcsis_free_packet_queue(struct csis_state *state)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(state->buffers); i++) {
+		vfree(state->buffers[i].data);
+		state->buffers[i].data = NULL;
+		state->buffers[i].len = 0;
+	}
+}
+
+static int s5pcsis_init_packet_queue(struct csis_state *state)
+{
+	struct csis_pktbuf *buf;
+	int i, ret = -ENOMEM;
+
+	for (i = 0; i < ARRAY_SIZE(state->buffers); i++) {
+		buf = &state->buffers[i];
+		buf->data = vmalloc(S5PCSIS_PKTDATA_SIZE);
+		if (buf->data == NULL)
+			goto err;
+		buf->len = S5PCSIS_PKTDATA_SIZE;
+		list_add_tail(&buf->list, &state->empty_buf_list);
+	}
+
+	return 0;
+err:
+	s5pcsis_free_packet_queue(state);
+	v4l2_err(&state->sd, "%s failed\n", __func__);
+	return ret;
+}
+
+static void s5pcsis_clear_counters(struct csis_state *state)
+{
+	unsigned long flags;
+	int i;
+
+	spin_lock_irqsave(&state->slock, flags);
+
+	for (i = 0; i < S5PCSIS_NUM_EVENTS; i++)
+		state->events[i].counter = 0;
+	state->last_frame_seq = 0;
+	state->frame_seq = 0;
+	spin_unlock_irqrestore(&state->slock, flags);
+}
+
+static void s5pcsis_log_counters(struct csis_state *state, bool non_errors)
+{
+	unsigned long flags;
+	int i = non_errors ? S5PCSIS_NUM_EVENTS : S5PCSIS_NUM_EVENTS - 4;
+
+	spin_lock_irqsave(&state->slock, flags);
+
+	for (i--; i >= 0; i--)
+		if (state->events[i].counter >= 0)
+			v4l2_info(&state->sd, "%s events: %d\n",
+				  state->events[i].name,
+				  state->events[i].counter);
+
+	v4l2_info(&state->sd, "frame sequence: %d\n", state->frame_seq);
+	spin_unlock_irqrestore(&state->slock, flags);
+}
+
+/*
+ * V4L2 subdev operations
+ */
+static int s5pcsis_s_power(struct v4l2_subdev *sd, int on)
+{
+	struct csis_state *state = sd_to_csis_state(sd);
+	struct device *dev = &state->pdev->dev;
+
+	if (on)
+		return pm_runtime_get_sync(dev);
+
+	return pm_runtime_put_sync(dev);
+}
+
 static int s5pcsis_s_stream(struct v4l2_subdev *sd, int enable)
 {
 	struct csis_state *state = sd_to_csis_state(sd);
@@ -326,10 +477,12 @@ static int s5pcsis_s_stream(struct v4l2_subdev *sd, int enable)
 		 __func__, enable, state->flags);
 
 	if (enable) {
+		s5pcsis_clear_counters(state);
 		ret = pm_runtime_get_sync(&state->pdev->dev);
 		if (ret && ret != 1)
 			return ret;
 	}
+
 	mutex_lock(&state->lock);
 	if (enable) {
 		if (state->flags & ST_SUSPENDED) {
@@ -341,6 +494,7 @@ static int s5pcsis_s_stream(struct v4l2_subdev *sd, int enable)
 	} else {
 		s5pcsis_stop_stream(state);
 		state->flags &= ~ST_STREAMING;
+		s5pcsis_log_counters(state, true);
 	}
 unlock:
 	mutex_unlock(&state->lock);
@@ -438,6 +592,41 @@ static int s5pcsis_get_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 	return 0;
 }
 
+static int s5pcsis_g_embedded_data(struct v4l2_subdev *sd, unsigned int *size,
+				   void **data)
+{
+	struct csis_state *state = sd_to_csis_state(sd);
+	unsigned long flags;
+	int ret = 0;
+
+	spin_lock_irqsave(&state->slock, flags);
+
+	if (!list_empty(&state->ready_buf_list)) {
+		struct csis_pktbuf *buf = list_first_entry(
+			   &state->ready_buf_list, struct csis_pktbuf, list);
+
+		*size = min_t(unsigned int, *size, S5PCSIS_PKTDATA_SIZE);
+
+		if (!WARN_ON(buf->data == NULL))
+			memcpy(*data, buf->data, *size);
+		list_move_tail(&buf->list, state->empty_buf_list.next);
+	} else {
+		*size = 0;
+		ret = -ENODATA;
+	}
+	spin_unlock_irqrestore(&state->slock, flags);
+
+	return ret;
+}
+
+static int s5pcsis_log_status(struct v4l2_subdev *sd)
+{
+	struct csis_state *state = sd_to_csis_state(sd);
+
+	s5pcsis_log_counters(state, true);
+	return 0;
+}
+
 static int s5pcsis_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 {
 	struct v4l2_mbus_framefmt *format = v4l2_subdev_get_try_format(fh, 0);
@@ -450,13 +639,32 @@ static int s5pcsis_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 
 	return 0;
 }
+static int s5pcsis_ext_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
+{
+	struct csis_state *state = sd_to_csis_state(sd);
+	unsigned long flags;
+
+	spin_lock_irqsave(&state->slock, flags);
+	/*
+	 * Increment the frame_seq counter at each FIMC VSYNC interrupt before
+	 * an image frame is captured. This signals to MIPI-CSIS for which
+	 * frames the embedded non-image data is to be stored into the internal
+	 * buffer queue. The queue is emptied in g_embedded_data callback.
+	 */
+	state->frame_seq++;
+	spin_unlock_irqrestore(&state->slock, flags);
+
+	return 0;
+}
 
 static const struct v4l2_subdev_internal_ops s5pcsis_sd_internal_ops = {
 	.open = s5pcsis_open,
 };
 
 static struct v4l2_subdev_core_ops s5pcsis_core_ops = {
+	.interrupt_service_routine = s5pcsis_ext_isr,
 	.s_power = s5pcsis_s_power,
+	.log_status = s5pcsis_log_status,
 };
 
 static struct v4l2_subdev_pad_ops s5pcsis_pad_ops = {
@@ -466,6 +674,7 @@ static struct v4l2_subdev_pad_ops s5pcsis_pad_ops = {
 };
 
 static struct v4l2_subdev_video_ops s5pcsis_video_ops = {
+	.g_embedded_data = s5pcsis_g_embedded_data,
 	.s_stream = s5pcsis_s_stream,
 };
 
@@ -475,15 +684,63 @@ static struct v4l2_subdev_ops s5pcsis_subdev_ops = {
 	.video = &s5pcsis_video_ops,
 };
 
+static void s5pcsis_pkt_copy(struct csis_state *state, u32 *buf,
+			     u32 offset, u32 size)
+{
+	int i;
+
+	for (i = 0; i < S5PCSIS_PKTDATA_SIZE; i += 4, buf++)
+		*buf = s5pcsis_read(state, offset + i);
+}
+
 static irqreturn_t s5pcsis_irq_handler(int irq, void *dev_id)
 {
 	struct csis_state *state = dev_id;
-	u32 val;
+	unsigned long flags;
+	u32 status;
+
+	status = s5pcsis_read(state, S5PCSIS_INTSRC);
 
-	/* Just clear the interrupt pending bits. */
-	val = s5pcsis_read(state, S5PCSIS_INTSRC);
-	s5pcsis_write(state, S5PCSIS_INTSRC, val);
+	spin_lock_irqsave(&state->slock, flags);
+	WARN_ON(state->frame_seq == 0);
 
+	if ((status & S5PCSIS_INTSRC_NON_IMAGE_DATA) &&
+	    state->frame_seq != state->last_frame_seq &&
+	    !list_empty(&state->empty_buf_list)) {
+		struct csis_pktbuf *buf = list_first_entry(
+			   &state->empty_buf_list, struct csis_pktbuf, list);
+		u32 offset;
+
+		if (status & S5PCSIS_INTSRC_EVEN)
+			offset = S5PCSIS_PKTDATA_EVEN;
+		else
+			offset = S5PCSIS_PKTDATA_ODD;
+
+		s5pcsis_pkt_copy(state, buf->data, offset, 4096);
+		list_move_tail(&buf->list, state->ready_buf_list.next);
+
+		/* Let FIMC driver control which frames are captured */
+		state->last_frame_seq = state->frame_seq;
+	}
+
+	/* Update the event/error counters */
+	if ((status & S5PCSIS_INTSRC_ERRORS) || debug) {
+		int i;
+		for (i = 0; i < S5PCSIS_NUM_EVENTS; i++) {
+			if (!(status & state->events[i].mask))
+				continue;
+			state->events[i].counter++;
+			v4l2_dbg(2, debug, &state->sd, "%s: %d\n",
+				 state->events[i].name,
+				 state->events[i].counter);
+		}
+
+		v4l2_dbg(2, debug, &state->sd, "status: %#08x, frame %d\n",
+			 status, state->frame_seq);
+	}
+	spin_unlock_irqrestore(&state->slock, flags);
+
+	s5pcsis_write(state, S5PCSIS_INTSRC, status);
 	return IRQ_HANDLED;
 }
 
@@ -500,6 +757,10 @@ static int __devinit s5pcsis_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	mutex_init(&state->lock);
+	INIT_LIST_HEAD(&state->empty_buf_list);
+	INIT_LIST_HEAD(&state->ready_buf_list);
+	spin_lock_init(&state->slock);
+
 	state->pdev = pdev;
 
 	pdata = pdev->dev.platform_data;
@@ -576,6 +837,11 @@ static int __devinit s5pcsis_probe(struct platform_device *pdev)
 	/* .. and a pointer to the subdev. */
 	platform_set_drvdata(pdev, &state->sd);
 
+	ret = s5pcsis_init_packet_queue(state);
+	if (ret < 0)
+		goto e_regput;
+
+	memcpy(state->events, s5pcsis_events, sizeof(state->events));;
 	pm_runtime_enable(&pdev->dev);
 	return 0;
 
@@ -694,6 +960,7 @@ static int __devexit s5pcsis_remove(struct platform_device *pdev)
 	regulator_bulk_free(CSIS_NUM_SUPPLIES, state->supplies);
 
 	media_entity_cleanup(&state->sd.entity);
+	s5pcsis_free_packet_queue(state);
 
 	return 0;
 }
-- 
1.7.9

