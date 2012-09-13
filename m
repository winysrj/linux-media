Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:61760 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753770Ab2IMOmZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Sep 2012 10:42:25 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: sw0312.kim@samsung.com, linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] s5p-csis: Add transmission errors logging
Date: Thu, 13 Sep 2012 16:42:10 +0200
Message-id: <1347547330-22326-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add hardware event/error counters which can be dumped into the kernel
log through VIDIOC_LOG_STATUS ioctl. The counters are reset  in each
s_stream(1) call. Any errors are logged after streaming is turned off.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-fimc/mipi-csis.c | 159 ++++++++++++++++++++++++----
 1 file changed, 139 insertions(+), 20 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/mipi-csis.c b/drivers/media/platform/s5p-fimc/mipi-csis.c
index 2f73d9e..3bfee3a 100644
--- a/drivers/media/platform/s5p-fimc/mipi-csis.c
+++ b/drivers/media/platform/s5p-fimc/mipi-csis.c
@@ -31,7 +31,7 @@
 
 static int debug;
 module_param(debug, int, 0644);
-MODULE_PARM_DESC(debug, "Debug level (0-1)");
+MODULE_PARM_DESC(debug, "Debug level (0-2)");
 
 /* Register map definition */
 
@@ -60,10 +60,38 @@ MODULE_PARM_DESC(debug, "Debug level (0-1)");
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
@@ -93,6 +121,29 @@ enum {
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
+	{ S5PCSIS_INTSRC_ERR_LOST_FS,	"Lost Frame Start Error" },
+	{ S5PCSIS_INTSRC_ERR_LOST_FE,	"Lost Frame End Error" },
+	{ S5PCSIS_INTSRC_ERR_OVER,	"FIFO Overflow Error" },
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
 /**
  * struct csis_state - the driver's internal state data structure
  * @lock: mutex serializing the subdev and power management operations,
@@ -101,11 +152,14 @@ enum {
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
+ * @events: MIPI-CSIS event (error) counters
  */
 struct csis_state {
 	struct mutex lock;
@@ -119,6 +173,9 @@ struct csis_state {
 	u32 flags;
 	const struct csis_pix_format *csis_fmt;
 	struct v4l2_mbus_framefmt format;
+
+	struct spinlock slock;
+	struct s5pcsis_event events[S5PCSIS_NUM_EVENTS];
 };
 
 /**
@@ -292,17 +349,6 @@ err:
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
@@ -317,7 +363,47 @@ static void s5pcsis_stop_stream(struct csis_state *state)
 	s5pcsis_system_enable(state, false);
 }
 
-/* v4l2_subdev operations */
+static void s5pcsis_clear_counters(struct csis_state *state)
+{
+	unsigned long flags;
+	int i;
+
+	spin_lock_irqsave(&state->slock, flags);
+	for (i = 0; i < S5PCSIS_NUM_EVENTS; i++)
+		state->events[i].counter = 0;
+	spin_unlock_irqrestore(&state->slock, flags);
+}
+
+static void s5pcsis_log_counters(struct csis_state *state, bool non_errors)
+{
+	int i = non_errors ? S5PCSIS_NUM_EVENTS : S5PCSIS_NUM_EVENTS - 4;
+	unsigned long flags;
+
+	spin_lock_irqsave(&state->slock, flags);
+
+	for (i--; i >= 0; i--)
+		if (state->events[i].counter >= 0)
+			v4l2_info(&state->sd, "%s events: %d\n",
+				  state->events[i].name,
+				  state->events[i].counter);
+
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
@@ -327,10 +413,12 @@ static int s5pcsis_s_stream(struct v4l2_subdev *sd, int enable)
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
@@ -342,6 +430,7 @@ static int s5pcsis_s_stream(struct v4l2_subdev *sd, int enable)
 	} else {
 		s5pcsis_stop_stream(state);
 		state->flags &= ~ST_STREAMING;
+		s5pcsis_log_counters(state, true);
 	}
 unlock:
 	mutex_unlock(&state->lock);
@@ -439,6 +528,14 @@ static int s5pcsis_get_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 	return 0;
 }
 
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
@@ -458,6 +555,7 @@ static const struct v4l2_subdev_internal_ops s5pcsis_sd_internal_ops = {
 
 static struct v4l2_subdev_core_ops s5pcsis_core_ops = {
 	.s_power = s5pcsis_s_power,
+	.log_status = s5pcsis_log_status,
 };
 
 static struct v4l2_subdev_pad_ops s5pcsis_pad_ops = {
@@ -479,12 +577,29 @@ static struct v4l2_subdev_ops s5pcsis_subdev_ops = {
 static irqreturn_t s5pcsis_irq_handler(int irq, void *dev_id)
 {
 	struct csis_state *state = dev_id;
-	u32 val;
-
-	/* Just clear the interrupt pending bits. */
-	val = s5pcsis_read(state, S5PCSIS_INTSRC);
-	s5pcsis_write(state, S5PCSIS_INTSRC, val);
+	unsigned long flags;
+	u32 status;
+
+	status = s5pcsis_read(state, S5PCSIS_INTSRC);
+
+	spin_lock_irqsave(&state->slock, flags);
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
+		v4l2_dbg(2, debug, &state->sd, "status: %08x\n", status);
+	}
+	spin_unlock_irqrestore(&state->slock, flags);
 
+	s5pcsis_write(state, S5PCSIS_INTSRC, status);
 	return IRQ_HANDLED;
 }
 
@@ -501,6 +616,8 @@ static int __devinit s5pcsis_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	mutex_init(&state->lock);
+	spin_lock_init(&state->slock);
+
 	state->pdev = pdev;
 
 	pdata = pdev->dev.platform_data;
@@ -577,6 +694,8 @@ static int __devinit s5pcsis_probe(struct platform_device *pdev)
 	/* .. and a pointer to the subdev. */
 	platform_set_drvdata(pdev, &state->sd);
 
+	memcpy(state->events, s5pcsis_events, sizeof(state->events));
+
 	pm_runtime_enable(&pdev->dev);
 	return 0;
 
-- 
1.7.11.3

