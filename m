Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:41577 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539Ab1LLRpK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Dec 2011 12:45:10 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt2 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LW300DC4QN3CU90@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 12 Dec 2011 17:45:03 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LW3008T7QN2IN@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 12 Dec 2011 17:45:03 +0000 (GMT)
Date: Mon, 12 Dec 2011 18:44:53 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 09/14] m5mols: Don't ignore v4l2_ctrl_handler_setup() return
 value
In-reply-to: <1323711898-17162-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, s.nawrocki@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1323711898-17162-10-git-send-email-s.nawrocki@samsung.com>
References: <1323711898-17162-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2_ctrl_handler_setup() may fail so check its return value when
restoring controls after device is powered on. While at it simplify
the m5mols_restore_function() a bit.

Acked-by: HeungJun Kim <riverful.kim@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/m5mols/m5mols.h         |   13 ++++++-----
 drivers/media/video/m5mols/m5mols_capture.c |    2 +-
 drivers/media/video/m5mols/m5mols_core.c    |   31 +++++++++++++--------------
 3 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/media/video/m5mols/m5mols.h b/drivers/media/video/m5mols/m5mols.h
index 3cf9af3..78f82c9 100644
--- a/drivers/media/video/m5mols/m5mols.h
+++ b/drivers/media/video/m5mols/m5mols.h
@@ -196,15 +196,16 @@ struct m5mols_info {
 	struct media_pad pad;
 	struct v4l2_mbus_framefmt ffmt[M5MOLS_RESTYPE_MAX];
 	int res_type;
+
 	wait_queue_head_t irq_waitq;
 	atomic_t irq_done;
 
 	struct v4l2_ctrl_handler handle;
+
 	/* Autoexposure/exposure control cluster */
-	struct {
-		struct v4l2_ctrl *autoexposure;
-		struct v4l2_ctrl *exposure;
-	};
+	struct v4l2_ctrl *autoexposure;
+	struct v4l2_ctrl *exposure;
+
 	struct v4l2_ctrl *autowb;
 	struct v4l2_ctrl *colorfx;
 	struct v4l2_ctrl *saturation;
@@ -221,10 +222,10 @@ struct m5mols_info {
 	bool lock_awb;
 	u8 resolution;
 	u8 mode;
+
 	int (*set_power)(struct device *dev, int on);
 };
 
-#define is_ctrl_synced(__info) (__info->ctrl_sync)
 #define is_available_af(__info)	(__info->ver.af)
 #define is_code(__code, __type) (__code == m5mols_default_ffmt[__type].code)
 #define is_manufacturer(__info, __manufacturer)	\
@@ -290,7 +291,7 @@ int m5mols_mode(struct m5mols_info *info, u8 mode);
 
 int m5mols_enable_interrupt(struct v4l2_subdev *sd, u8 reg);
 int m5mols_wait_interrupt(struct v4l2_subdev *sd, u8 condition, u32 timeout);
-int m5mols_sync_controls(struct m5mols_info *info);
+int m5mols_restore_controls(struct m5mols_info *info);
 int m5mols_start_capture(struct m5mols_info *info);
 int m5mols_do_scenemode(struct m5mols_info *info, u8 mode);
 int m5mols_lock_3a(struct m5mols_info *info, bool lock);
diff --git a/drivers/media/video/m5mols/m5mols_capture.c b/drivers/media/video/m5mols/m5mols_capture.c
index 038b349..0fea2ad 100644
--- a/drivers/media/video/m5mols/m5mols_capture.c
+++ b/drivers/media/video/m5mols/m5mols_capture.c
@@ -117,7 +117,7 @@ int m5mols_start_capture(struct m5mols_info *info)
 	 */
 	ret = m5mols_mode(info, REG_MONITOR);
 	if (!ret)
-		ret = m5mols_sync_controls(info);
+		ret = m5mols_restore_controls(info);
 	if (!ret)
 		ret = m5mols_write(sd, CAPP_YUVOUT_MAIN, REG_JPEG);
 	if (!ret)
diff --git a/drivers/media/video/m5mols/m5mols_core.c b/drivers/media/video/m5mols/m5mols_core.c
index f47d406..99a096de 100644
--- a/drivers/media/video/m5mols/m5mols_core.c
+++ b/drivers/media/video/m5mols/m5mols_core.c
@@ -625,26 +625,25 @@ static struct v4l2_subdev_pad_ops m5mols_pad_ops = {
 };
 
 /**
- * m5mols_sync_controls - Apply default scene mode and the current controls
+ * m5mols_restore_controls - Apply current control values to the registers
  *
- * This is used only streaming for syncing between v4l2_ctrl framework and
- * m5mols's controls. First, do the scenemode to the sensor, then call
- * v4l2_ctrl_handler_setup. It can be same between some commands and
- * the scenemode's in the default v4l2_ctrls. But, such commands of control
- * should be prior to the scenemode's one.
+ * m5mols_do_scenemode() handles all parameters for which there is yet no
+ * standard control in V4L2. It should be replaced at some point by setting
+ * each control individually, in required register set up order.
  */
-int m5mols_sync_controls(struct m5mols_info *info)
+int m5mols_restore_controls(struct m5mols_info *info)
 {
-	int ret = -EINVAL;
+	int ret;
 
-	if (!is_ctrl_synced(info)) {
-		ret = m5mols_do_scenemode(info, REG_SCENE_NORMAL);
-		if (ret)
-			return ret;
+	if (info->ctrl_sync)
+		return 0;
 
-		v4l2_ctrl_handler_setup(&info->handle);
-		info->ctrl_sync = 1;
-	}
+	ret = m5mols_do_scenemode(info, REG_SCENE_NORMAL);
+	if (ret)
+		return ret;
+
+	ret = v4l2_ctrl_handler_setup(&info->handle);
+	info->ctrl_sync = !ret;
 
 	return ret;
 }
@@ -668,7 +667,7 @@ static int m5mols_start_monitor(struct m5mols_info *info)
 	if (!ret)
 		ret = m5mols_mode(info, REG_MONITOR);
 	if (!ret)
-		ret = m5mols_sync_controls(info);
+		ret = m5mols_restore_controls(info);
 
 	return ret;
 }
-- 
1.7.8

