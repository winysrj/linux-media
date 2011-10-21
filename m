Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:63178 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378Ab1JUHfp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Oct 2011 03:35:45 -0400
Received: from epcpsbgm1.samsung.com (mailout4.samsung.com [203.254.224.34])
 by mailout4.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LTE0088NNQUP620@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Fri, 21 Oct 2011 16:35:43 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp2.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTPA id <0LTE0015QNRIS6S0@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 21 Oct 2011 16:35:42 +0900 (KST)
From: "HeungJun, Kim" <riverful.kim@samsung.com>
To: linux-media@vger.kernel.org
Cc: "HeungJun, Kim" <riverful.kim@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 2/5] m5mols: Replace IRQ workqueue to waitqueue only
Date: Fri, 21 Oct 2011 16:35:51 +0900
Message-id: <1319182554-10645-2-git-send-email-riverful.kim@samsung.com>
In-reply-to: <1319182554-10645-1-git-send-email-riverful.kim@samsung.com>
References: <1319182554-10645-1-git-send-email-riverful.kim@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In M-5MOLS driver, the workqueue code for IRQ is hard to re-use. So, remove
the IRQ workqueue, and use only waitqueue for waiting IRQ with timeout.
The info->issue has the status that interrupt is issued or not, then
the info->interrupt has the IRQ status register at that time.

Signed-off-by: HeungJun, Kim <riverful.kim@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/m5mols/m5mols.h         |    7 +--
 drivers/media/video/m5mols/m5mols_capture.c |   34 ++-------------
 drivers/media/video/m5mols/m5mols_core.c    |   60 +++++++++++----------------
 3 files changed, 32 insertions(+), 69 deletions(-)

diff --git a/drivers/media/video/m5mols/m5mols.h b/drivers/media/video/m5mols/m5mols.h
index c8e1572..75f7984 100644
--- a/drivers/media/video/m5mols/m5mols.h
+++ b/drivers/media/video/m5mols/m5mols.h
@@ -164,7 +164,6 @@ struct m5mols_version {
  * @res_type: current resolution type
  * @code: current code
  * @irq_waitq: waitqueue for the capture
- * @work_irq: workqueue for the IRQ
  * @flags: state variable for the interrupt handler
  * @handle: control handler
  * @autoexposure: Auto Exposure control
@@ -181,6 +180,7 @@ struct m5mols_version {
  * @lock_ae: true means the Auto Exposure is locked
  * @lock_awb: true means the Aut WhiteBalance is locked
  * @resolution:	register value for current resolution
+ * @issue: "true" means the M-5MOLS sensor's interrupt issued
  * @interrupt: register value for current interrupt status
  * @mode: register value for current operation mode
  * @mode_save: register value for current operation mode for saving
@@ -194,7 +194,6 @@ struct m5mols_info {
 	int res_type;
 	enum v4l2_mbus_pixelcode code;
 	wait_queue_head_t irq_waitq;
-	struct work_struct work_irq;
 	unsigned long flags;
 
 	struct v4l2_ctrl_handler handle;
@@ -211,6 +210,7 @@ struct m5mols_info {
 	struct m5mols_version ver;
 	struct m5mols_capture cap;
 	bool power;
+	bool issue;
 	bool ctrl_sync;
 	bool lock_ae;
 	bool lock_awb;
@@ -221,8 +221,6 @@ struct m5mols_info {
 	int (*set_power)(struct device *dev, int on);
 };
 
-#define ST_CAPT_IRQ 0
-
 #define is_powered(__info) (__info->power)
 #define is_ctrl_synced(__info) (__info->ctrl_sync)
 #define is_available_af(__info)	(__info->ver.af)
@@ -283,6 +281,7 @@ int m5mols_write(struct v4l2_subdev *sd, u32 reg_comb, u32 val);
 int m5mols_mode(struct m5mols_info *info, u8 mode);
 
 int m5mols_enable_interrupt(struct v4l2_subdev *sd, u8 reg);
+int m5mols_timeout_interrupt(struct v4l2_subdev *sd, u8 condition, u32 timeout);
 int m5mols_sync_controls(struct m5mols_info *info);
 int m5mols_start_capture(struct m5mols_info *info);
 int m5mols_do_scenemode(struct m5mols_info *info, u8 mode);
diff --git a/drivers/media/video/m5mols/m5mols_capture.c b/drivers/media/video/m5mols/m5mols_capture.c
index 3248ac8..18a56bf 100644
--- a/drivers/media/video/m5mols/m5mols_capture.c
+++ b/drivers/media/video/m5mols/m5mols_capture.c
@@ -29,22 +29,6 @@
 #include "m5mols.h"
 #include "m5mols_reg.h"
 
-static int m5mols_capture_error_handler(struct m5mols_info *info,
-					int timeout)
-{
-	int ret;
-
-	/* Disable all interrupts and clear relevant interrupt staus bits */
-	ret = m5mols_write(&info->sd, SYSTEM_INT_ENABLE,
-			   info->interrupt & ~(REG_INT_CAPTURE));
-	if (ret)
-		return ret;
-
-	if (timeout == 0)
-		return -ETIMEDOUT;
-
-	return 0;
-}
 /**
  * m5mols_read_rational - I2C read of a rational number
  *
@@ -121,7 +105,6 @@ int m5mols_start_capture(struct m5mols_info *info)
 {
 	struct v4l2_subdev *sd = &info->sd;
 	u8 resolution = info->resolution;
-	int timeout;
 	int ret;
 
 	/*
@@ -142,14 +125,9 @@ int m5mols_start_capture(struct m5mols_info *info)
 		ret = m5mols_enable_interrupt(sd, REG_INT_CAPTURE);
 	if (!ret)
 		ret = m5mols_mode(info, REG_CAPTURE);
-	if (!ret) {
+	if (!ret)
 		/* Wait for capture interrupt, after changing capture mode */
-		timeout = wait_event_interruptible_timeout(info->irq_waitq,
-					   test_bit(ST_CAPT_IRQ, &info->flags),
-					   msecs_to_jiffies(2000));
-		if (test_and_clear_bit(ST_CAPT_IRQ, &info->flags))
-			ret = m5mols_capture_error_handler(info, timeout);
-	}
+		ret = m5mols_timeout_interrupt(sd, REG_INT_CAPTURE, 2000);
 	if (!ret)
 		ret = m5mols_lock_3a(info, false);
 	if (ret)
@@ -175,15 +153,13 @@ int m5mols_start_capture(struct m5mols_info *info)
 		ret = m5mols_write(sd, CAPC_START, REG_CAP_START_MAIN);
 	if (!ret) {
 		/* Wait for the capture completion interrupt */
-		timeout = wait_event_interruptible_timeout(info->irq_waitq,
-					   test_bit(ST_CAPT_IRQ, &info->flags),
-					   msecs_to_jiffies(2000));
-		if (test_and_clear_bit(ST_CAPT_IRQ, &info->flags)) {
+		ret = m5mols_timeout_interrupt(sd, REG_INT_CAPTURE, 2000);
+		if (!ret) {
 			ret = m5mols_capture_info(info);
 			if (!ret)
 				v4l2_subdev_notify(sd, 0, &info->cap.total);
 		}
 	}
 
-	return m5mols_capture_error_handler(info, timeout);
+	return ret;
 }
diff --git a/drivers/media/video/m5mols/m5mols_core.c b/drivers/media/video/m5mols/m5mols_core.c
index 73db96e..f3b9415 100644
--- a/drivers/media/video/m5mols/m5mols_core.c
+++ b/drivers/media/video/m5mols/m5mols_core.c
@@ -333,6 +333,28 @@ int m5mols_enable_interrupt(struct v4l2_subdev *sd, u8 reg)
 	return ret;
 }
 
+/* m5mols_timeout_interrupt - Wait interrupt and figure out which interrupt. */
+int m5mols_timeout_interrupt(struct v4l2_subdev *sd, u8 condition, u32 timeout)
+{
+	struct m5mols_info *info = to_m5mols(sd);
+	u8 reg;
+	int timed;
+	int ret;
+
+	timed = wait_event_interruptible_timeout(info->irq_waitq,
+			info->issue, msecs_to_jiffies(timeout));
+	if (!timed)
+		return -ETIMEDOUT;
+
+	ret = m5mols_busy_val(sd, condition, &reg, CAT_SYSTEM, CAT0_INT_FACTOR);
+	if (ret || (!ret && reg != condition))
+		return -EINVAL;
+
+	info->interrupt = reg;
+	info->issue = false;
+	return 0;
+}
+
 /**
  * m5mols_reg_mode - Write the mode and check busy status
  *
@@ -901,46 +923,13 @@ static const struct v4l2_subdev_ops m5mols_ops = {
 	.video		= &m5mols_video_ops,
 };
 
-static void m5mols_irq_work(struct work_struct *work)
-{
-	struct m5mols_info *info =
-		container_of(work, struct m5mols_info, work_irq);
-	struct v4l2_subdev *sd = &info->sd;
-	u8 reg;
-	int ret;
-
-	if (!is_powered(info) ||
-			m5mols_read_u8(sd, SYSTEM_INT_FACTOR, &info->interrupt))
-		return;
-
-	switch (info->interrupt & REG_INT_MASK) {
-	case REG_INT_AF:
-		if (!is_available_af(info))
-			break;
-		ret = m5mols_read_u8(sd, AF_STATUS, &reg);
-		v4l2_dbg(2, m5mols_debug, sd, "AF %s\n",
-			 reg == REG_AF_FAIL ? "Failed" :
-			 reg == REG_AF_SUCCESS ? "Success" :
-			 reg == REG_AF_IDLE ? "Idle" : "Busy");
-		break;
-	case REG_INT_CAPTURE:
-		if (!test_and_set_bit(ST_CAPT_IRQ, &info->flags))
-			wake_up_interruptible(&info->irq_waitq);
-
-		v4l2_dbg(2, m5mols_debug, sd, "CAPTURE\n");
-		break;
-	default:
-		v4l2_dbg(2, m5mols_debug, sd, "Undefined: %02x\n", reg);
-		break;
-	};
-}
-
 static irqreturn_t m5mols_irq_handler(int irq, void *data)
 {
 	struct v4l2_subdev *sd = data;
 	struct m5mols_info *info = to_m5mols(sd);
 
-	schedule_work(&info->work_irq);
+	info->issue = true;
+	wake_up_interruptible(&info->irq_waitq);
 
 	return IRQ_HANDLED;
 }
@@ -999,7 +988,6 @@ static int __devinit m5mols_probe(struct i2c_client *client,
 	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
 
 	init_waitqueue_head(&info->irq_waitq);
-	INIT_WORK(&info->work_irq, m5mols_irq_work);
 	ret = request_irq(client->irq, m5mols_irq_handler,
 			  IRQF_TRIGGER_RISING, MODULE_NAME, sd);
 	if (ret) {
-- 
1.7.4.1

