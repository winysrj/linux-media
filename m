Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:54571 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491Ab1LLRpF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Dec 2011 12:45:05 -0500
Received: from euspt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LW3000ENQN28X@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 12 Dec 2011 17:45:02 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LW3008SWQN2IN@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 12 Dec 2011 17:45:02 +0000 (GMT)
Date: Mon, 12 Dec 2011 18:44:48 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 04/14] m5mols: Improve the interrupt handling routines
In-reply-to: <1323711898-17162-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, s.nawrocki@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1323711898-17162-5-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1323711898-17162-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: HeungJun Kim <riverful.kim@samsung.com>

The work struct based interrupt handling is not flexible enough
as the M-5MOLS control sequence involves I2C access sequences
before and after an interrupt is generated. A single waitqueue is
enough for the job so remove the work struct based code.

Signed-off-by: HeungJun Kim <riverful.kim@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/m5mols/m5mols.h         |    9 +---
 drivers/media/video/m5mols/m5mols_capture.c |   34 ++--------------
 drivers/media/video/m5mols/m5mols_core.c    |   56 +++++++++------------------
 3 files changed, 25 insertions(+), 74 deletions(-)

diff --git a/drivers/media/video/m5mols/m5mols.h b/drivers/media/video/m5mols/m5mols.h
index 2461a44..13da3f2 100644
--- a/drivers/media/video/m5mols/m5mols.h
+++ b/drivers/media/video/m5mols/m5mols.h
@@ -171,7 +171,6 @@ struct m5mols_version {
  * @ffmt: current fmt according to resolution type
  * @res_type: current resolution type
  * @irq_waitq: waitqueue for the capture
- * @work_irq: workqueue for the IRQ
  * @flags: state variable for the interrupt handler
  * @handle: control handler
  * @autoexposure: Auto Exposure control
@@ -188,7 +187,6 @@ struct m5mols_version {
  * @lock_ae: true means the Auto Exposure is locked
  * @lock_awb: true means the Aut WhiteBalance is locked
  * @resolution:	register value for current resolution
- * @interrupt: register value for current interrupt status
  * @mode: register value for current operation mode
  * @mode_save: register value for current operation mode for saving
  * @set_power: optional power callback to the board code
@@ -200,8 +198,7 @@ struct m5mols_info {
 	struct v4l2_mbus_framefmt ffmt[M5MOLS_RESTYPE_MAX];
 	int res_type;
 	wait_queue_head_t irq_waitq;
-	struct work_struct work_irq;
-	unsigned long flags;
+	atomic_t irq_done;
 
 	struct v4l2_ctrl_handler handle;
 	/* Autoexposure/exposure control cluster */
@@ -221,14 +218,11 @@ struct m5mols_info {
 	bool lock_ae;
 	bool lock_awb;
 	u8 resolution;
-	u8 interrupt;
 	u8 mode;
 	u8 mode_save;
 	int (*set_power)(struct device *dev, int on);
 };
 
-#define ST_CAPT_IRQ 0
-
 #define is_powered(__info) (__info->power)
 #define is_ctrl_synced(__info) (__info->ctrl_sync)
 #define is_available_af(__info)	(__info->ver.af)
@@ -295,6 +289,7 @@ int m5mols_busy_wait(struct v4l2_subdev *sd, u32 reg, u32 value, u32 mask,
 int m5mols_mode(struct m5mols_info *info, u8 mode);
 
 int m5mols_enable_interrupt(struct v4l2_subdev *sd, u8 reg);
+int m5mols_wait_interrupt(struct v4l2_subdev *sd, u8 condition, u32 timeout);
 int m5mols_sync_controls(struct m5mols_info *info);
 int m5mols_start_capture(struct m5mols_info *info);
 int m5mols_do_scenemode(struct m5mols_info *info, u8 mode);
diff --git a/drivers/media/video/m5mols/m5mols_capture.c b/drivers/media/video/m5mols/m5mols_capture.c
index c8da22f..6409c3f 100644
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
@@ -122,7 +106,6 @@ int m5mols_start_capture(struct m5mols_info *info)
 	struct v4l2_mbus_framefmt *mf = &info->ffmt[info->res_type];
 	struct v4l2_subdev *sd = &info->sd;
 	u8 resolution = info->resolution;
-	int timeout;
 	int ret;
 
 	/*
@@ -143,14 +126,9 @@ int m5mols_start_capture(struct m5mols_info *info)
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
+		ret = m5mols_wait_interrupt(sd, REG_INT_CAPTURE, 2000);
 	if (!ret)
 		ret = m5mols_lock_3a(info, false);
 	if (ret)
@@ -179,15 +157,13 @@ int m5mols_start_capture(struct m5mols_info *info)
 		ret = m5mols_write(sd, CAPC_START, REG_CAP_START_MAIN);
 	if (!ret) {
 		/* Wait for the capture completion interrupt */
-		timeout = wait_event_interruptible_timeout(info->irq_waitq,
-					   test_bit(ST_CAPT_IRQ, &info->flags),
-					   msecs_to_jiffies(2000));
-		if (test_and_clear_bit(ST_CAPT_IRQ, &info->flags)) {
+		ret = m5mols_wait_interrupt(sd, REG_INT_CAPTURE, 2000);
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
index a1302dc..a2b44ad 100644
--- a/drivers/media/video/m5mols/m5mols_core.c
+++ b/drivers/media/video/m5mols/m5mols_core.c
@@ -323,6 +323,19 @@ int m5mols_enable_interrupt(struct v4l2_subdev *sd, u8 reg)
 	return ret;
 }
 
+int m5mols_wait_interrupt(struct v4l2_subdev *sd, u8 irq_mask, u32 timeout)
+{
+	struct m5mols_info *info = to_m5mols(sd);
+
+	int ret = wait_event_interruptible_timeout(info->irq_waitq,
+				atomic_add_unless(&info->irq_done, -1, 0),
+				msecs_to_jiffies(timeout));
+	if (ret <= 0)
+		return ret ? ret : -ETIMEDOUT;
+
+	return m5mols_busy_wait(sd, SYSTEM_INT_FACTOR, irq_mask, irq_mask, -1);
+}
+
 /**
  * m5mols_reg_mode - Write the mode and check busy status
  *
@@ -904,46 +917,12 @@ static const struct v4l2_subdev_ops m5mols_ops = {
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
-	struct v4l2_subdev *sd = data;
-	struct m5mols_info *info = to_m5mols(sd);
+	struct m5mols_info *info = to_m5mols(data);
 
-	schedule_work(&info->work_irq);
+	atomic_set(&info->irq_done, 1);
+	wake_up_interruptible(&info->irq_waitq);
 
 	return IRQ_HANDLED;
 }
@@ -1002,7 +981,6 @@ static int __devinit m5mols_probe(struct i2c_client *client,
 	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
 
 	init_waitqueue_head(&info->irq_waitq);
-	INIT_WORK(&info->work_irq, m5mols_irq_work);
 	ret = request_irq(client->irq, m5mols_irq_handler,
 			  IRQF_TRIGGER_RISING, MODULE_NAME, sd);
 	if (ret) {
@@ -1010,6 +988,8 @@ static int __devinit m5mols_probe(struct i2c_client *client,
 		goto out_me;
 	}
 	info->res_type = M5MOLS_RESTYPE_MONITOR;
+	atomic_set(&info->irq_done, 0);
+
 	return 0;
 out_me:
 	media_entity_cleanup(&sd->entity);
-- 
1.7.8

