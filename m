Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:54972 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340Ab2EJKbR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 May 2012 06:31:17 -0400
Received: from euspt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M3S005EIYJLKG@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 May 2012 11:30:57 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M3S00DB9YJQ3L@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 May 2012 11:31:03 +0100 (BST)
Date: Thu, 10 May 2012 12:30:58 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 23/23] m5mols: Add 3A lock control
In-reply-to: <1336645858-30366-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, s.nawrocki@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1336645858-30366-24-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1336645858-30366-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add control for locking automatic exposure, focus and white balance
adjustments. While at it, tidy up the data structure documentation.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/m5mols/m5mols.h          |   10 ++-
 drivers/media/video/m5mols/m5mols_capture.c  |    7 +-
 drivers/media/video/m5mols/m5mols_controls.c |   89 ++++++++++++++++----------
 3 files changed, 60 insertions(+), 46 deletions(-)

diff --git a/drivers/media/video/m5mols/m5mols.h b/drivers/media/video/m5mols/m5mols.h
index 00f8d31..bb58991 100644
--- a/drivers/media/video/m5mols/m5mols.h
+++ b/drivers/media/video/m5mols/m5mols.h
@@ -158,7 +158,7 @@ struct m5mols_version {
  * @ffmt: current fmt according to resolution type
  * @res_type: current resolution type
  * @irq_waitq: waitqueue for the capture
- * @flags: state variable for the interrupt handler
+ * @irq_done: set to 1 in the interrupt handler
  * @handle: control handler
  * @auto_exposure: auto/manual exposure control
  * @exposure_bias: exposure compensation control
@@ -167,6 +167,7 @@ struct m5mols_version {
  * @auto_iso: auto/manual ISO sensitivity control
  * @iso: manual ISO sensitivity control
  * @auto_wb: auto white balance control
+ * @lock_3a: 3A lock control
  * @colorfx: color effect control
  * @saturation: saturation control
  * @zoom: zoom control
@@ -175,11 +176,9 @@ struct m5mols_version {
  * @jpeg_quality: JPEG compression quality control
  * @ver: information of the version
  * @cap: the capture mode attributes
- * @power: current sensor's power status
  * @isp_ready: 1 when the ISP controller has completed booting
+ * @power: current sensor's power status
  * @ctrl_sync: 1 when the control handler state is restored in H/W
- * @lock_ae: true means the Auto Exposure is locked
- * @lock_awb: true means the Aut WhiteBalance is locked
  * @resolution:	register value for current resolution
  * @mode: register value for current operation mode
  * @set_power: optional power callback to the board code
@@ -209,6 +208,7 @@ struct m5mols_info {
 	};
 	struct v4l2_ctrl *auto_wb;
 
+	struct v4l2_ctrl *lock_3a;
 	struct v4l2_ctrl *colorfx;
 	struct v4l2_ctrl *saturation;
 	struct v4l2_ctrl *zoom;
@@ -223,8 +223,6 @@ struct m5mols_info {
 	unsigned int power:1;
 	unsigned int ctrl_sync:1;
 
-	bool lock_ae;
-	bool lock_awb;
 	u8 resolution;
 	u8 mode;
 
diff --git a/drivers/media/video/m5mols/m5mols_capture.c b/drivers/media/video/m5mols/m5mols_capture.c
index 4f27aed..cb243bd 100644
--- a/drivers/media/video/m5mols/m5mols_capture.c
+++ b/drivers/media/video/m5mols/m5mols_capture.c
@@ -106,7 +106,6 @@ static int m5mols_capture_info(struct m5mols_info *info)
 int m5mols_start_capture(struct m5mols_info *info)
 {
 	struct v4l2_subdev *sd = &info->sd;
-	u8 resolution = info->resolution;
 	int ret;
 
 	/*
@@ -120,16 +119,12 @@ int m5mols_start_capture(struct m5mols_info *info)
 	if (!ret)
 		ret = m5mols_write(sd, CAPP_YUVOUT_MAIN, REG_JPEG);
 	if (!ret)
-		ret = m5mols_write(sd, CAPP_MAIN_IMAGE_SIZE, resolution);
-	if (!ret)
-		ret = m5mols_lock_3a(info, true);
+		ret = m5mols_write(sd, CAPP_MAIN_IMAGE_SIZE, info->resolution);
 	if (!ret)
 		ret = m5mols_set_mode(info, REG_CAPTURE);
 	if (!ret)
 		/* Wait until a frame is captured to ISP internal memory */
 		ret = m5mols_wait_interrupt(sd, REG_INT_CAPTURE, 2000);
-	if (!ret)
-		ret = m5mols_lock_3a(info, false);
 	if (ret)
 		return ret;
 
diff --git a/drivers/media/video/m5mols/m5mols_controls.c b/drivers/media/video/m5mols/m5mols_controls.c
index 1c3b1e0..392a028 100644
--- a/drivers/media/video/m5mols/m5mols_controls.c
+++ b/drivers/media/video/m5mols/m5mols_controls.c
@@ -139,7 +139,7 @@ int m5mols_do_scenemode(struct m5mols_info *info, u8 mode)
 	if (mode > REG_SCENE_CANDLE)
 		return -EINVAL;
 
-	ret = m5mols_lock_3a(info, false);
+	ret = v4l2_ctrl_s_ctrl(info->lock_3a, 0);
 	if (!ret)
 		ret = m5mols_write(sd, AE_EV_PRESET_MONITOR, mode);
 	if (!ret)
@@ -186,42 +186,34 @@ int m5mols_do_scenemode(struct m5mols_info *info, u8 mode)
 	return ret;
 }
 
-static int m5mols_lock_ae(struct m5mols_info *info, bool lock)
+static int m5mols_3a_lock(struct m5mols_info *info, struct v4l2_ctrl *ctrl)
 {
+	bool af_lock = ctrl->val & V4L2_LOCK_FOCUS;
 	int ret = 0;
 
-	if (info->lock_ae != lock)
-		ret = m5mols_write(&info->sd, AE_LOCK,
-				lock ? REG_AE_LOCK : REG_AE_UNLOCK);
-	if (!ret)
-		info->lock_ae = lock;
+	if ((ctrl->val ^ ctrl->cur.val) & V4L2_LOCK_EXPOSURE) {
+		bool ae_lock = ctrl->val & V4L2_LOCK_EXPOSURE;
 
-	return ret;
-}
-
-static int m5mols_lock_awb(struct m5mols_info *info, bool lock)
-{
-	int ret = 0;
+		ret = m5mols_write(&info->sd, AE_LOCK, ae_lock ?
+				   REG_AE_LOCK : REG_AE_UNLOCK);
+		if (ret)
+			return ret;
+	}
 
-	if (info->lock_awb != lock)
-		ret = m5mols_write(&info->sd, AWB_LOCK,
-				lock ? REG_AWB_LOCK : REG_AWB_UNLOCK);
-	if (!ret)
-		info->lock_awb = lock;
+	if (((ctrl->val ^ ctrl->cur.val) & V4L2_LOCK_WHITE_BALANCE)
+	    && info->auto_wb->val) {
+		bool awb_lock = ctrl->val & V4L2_LOCK_WHITE_BALANCE;
 
-	return ret;
-}
+		ret = m5mols_write(&info->sd, AWB_LOCK, awb_lock ?
+				   REG_AWB_LOCK : REG_AWB_UNLOCK);
+		if (ret)
+			return ret;
+	}
 
-/* m5mols_lock_3a() - Lock 3A(Auto Exposure, Auto Whitebalance, Auto Focus) */
-int m5mols_lock_3a(struct m5mols_info *info, bool lock)
-{
-	int ret;
+	if (!info->ver.af || !af_lock)
+		return ret;
 
-	ret = m5mols_lock_ae(info, lock);
-	if (!ret)
-		ret = m5mols_lock_awb(info, lock);
-	/* Don't need to handle unlocking AF */
-	if (!ret && is_available_af(info) && lock)
+	if ((ctrl->val ^ ctrl->cur.val) & V4L2_LOCK_FOCUS)
 		ret = m5mols_write(&info->sd, AF_EXECUTE, REG_AF_STOP);
 
 	return ret;
@@ -249,13 +241,13 @@ static int m5mols_set_metering_mode(struct m5mols_info *info, int mode)
 static int m5mols_set_exposure(struct m5mols_info *info, int exposure)
 {
 	struct v4l2_subdev *sd = &info->sd;
-	int ret;
-
-	ret = m5mols_lock_ae(info, exposure != V4L2_EXPOSURE_AUTO);
-	if (ret < 0)
-		return ret;
+	int ret = 0;
 
 	if (exposure == V4L2_EXPOSURE_AUTO) {
+		/* Unlock auto exposure */
+		info->lock_3a->val &= ~V4L2_LOCK_EXPOSURE;
+		m5mols_3a_lock(info, info->lock_3a);
+
 		ret = m5mols_set_metering_mode(info, info->metering->val);
 		if (ret < 0)
 			return ret;
@@ -429,6 +421,26 @@ static int m5mols_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
 		if (status != REG_ISO_AUTO)
 			info->iso->val = status - 1;
 		break;
+
+	case V4L2_CID_3A_LOCK:
+		ctrl->val &= ~0x7;
+
+		ret = m5mols_read_u8(sd, AE_LOCK, &status);
+		if (ret)
+			return ret;
+		if (status)
+			info->lock_3a->val |= V4L2_LOCK_EXPOSURE;
+
+		ret = m5mols_read_u8(sd, AWB_LOCK, &status);
+		if (ret)
+			return ret;
+		if (status)
+			info->lock_3a->val |= V4L2_LOCK_EXPOSURE;
+
+		ret = m5mols_read_u8(sd, AF_EXECUTE, &status);
+		if (!status)
+			info->lock_3a->val |= V4L2_LOCK_EXPOSURE;
+		break;
 	}
 
 	return ret;
@@ -461,6 +473,10 @@ static int m5mols_s_ctrl(struct v4l2_ctrl *ctrl)
 	}
 
 	switch (ctrl->id) {
+	case V4L2_CID_3A_LOCK:
+		ret = m5mols_3a_lock(info, ctrl);
+		break;
+
 	case V4L2_CID_ZOOM_ABSOLUTE:
 		ret = m5mols_write(sd, MON_ZOOM, ctrl->val);
 		break;
@@ -585,6 +601,9 @@ int m5mols_init_controls(struct v4l2_subdev *sd)
 	info->jpeg_quality = v4l2_ctrl_new_std(&info->handle, &m5mols_ctrl_ops,
 			V4L2_CID_JPEG_COMPRESSION_QUALITY, 1, 100, 1, 80);
 
+	info->lock_3a = v4l2_ctrl_new_std(&info->handle, &m5mols_ctrl_ops,
+			V4L2_CID_3A_LOCK, 0, 0x7, 0, 0);
+
 	if (info->handle.error) {
 		int ret = info->handle.error;
 		v4l2_err(sd, "Failed to initialize controls: %d\n", ret);
@@ -597,6 +616,8 @@ int m5mols_init_controls(struct v4l2_subdev *sd)
 				V4L2_CTRL_FLAG_UPDATE;
 	v4l2_ctrl_auto_cluster(2, &info->auto_iso, 0, false);
 
+	info->lock_3a->flags |= V4L2_CTRL_FLAG_VOLATILE;
+
 	m5mols_set_ctrl_mode(info->auto_exposure, REG_PARAMETER);
 	m5mols_set_ctrl_mode(info->auto_wb, REG_PARAMETER);
 	m5mols_set_ctrl_mode(info->colorfx, REG_MONITOR);
-- 
1.7.10

