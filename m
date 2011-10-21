Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:40274 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841Ab1JUHfq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Oct 2011 03:35:46 -0400
Received: from epcpsbgm2.samsung.com (mailout1.samsung.com [203.254.224.24])
 by mailout1.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LTE00IQUNRJCHP0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 21 Oct 2011 16:35:43 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp2.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTPA id <0LTE0023ENRJDQG0@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 21 Oct 2011 16:35:43 +0900 (KST)
From: "HeungJun, Kim" <riverful.kim@samsung.com>
To: linux-media@vger.kernel.org
Cc: "HeungJun, Kim" <riverful.kim@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 5/5] m5mols: Relocation the order and count for CAPTURE
 interrupt
Date: Fri, 21 Oct 2011 16:35:54 +0900
Message-id: <1319182554-10645-5-git-send-email-riverful.kim@samsung.com>
In-reply-to: <1319182554-10645-1-git-send-email-riverful.kim@samsung.com>
References: <1319182554-10645-1-git-send-email-riverful.kim@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The double enabling CAPTURE interrupt is not needed in m5mols_start_capture(),
so remove these, and add one at the only booting time once. Also, fix the order
of CAPTURE sequence to the right way.

Signed-off-by: HeungJun, Kim <riverful.kim@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/m5mols/m5mols_capture.c |   37 ++++++++------------------
 drivers/media/video/m5mols/m5mols_core.c    |    4 ++-
 2 files changed, 15 insertions(+), 26 deletions(-)

diff --git a/drivers/media/video/m5mols/m5mols_capture.c b/drivers/media/video/m5mols/m5mols_capture.c
index 18a56bf..5bb0f96 100644
--- a/drivers/media/video/m5mols/m5mols_capture.c
+++ b/drivers/media/video/m5mols/m5mols_capture.c
@@ -108,51 +108,38 @@ int m5mols_start_capture(struct m5mols_info *info)
 	int ret;
 
 	/*
-	 * Preparing capture. Setting control & interrupt before entering
-	 * capture mode
-	 *
-	 * 1) change to MONITOR mode for operating control & interrupt
-	 * 2) set controls (considering v4l2_control value & lock 3A)
-	 * 3) set interrupt
-	 * 4) change to CAPTURE mode
+	 * CAPTURE - capture using ISP in the various sized and formats
+	 * (JPEG/RAW-BAYER/YUV422 for recording). As soon as changing to
+	 * CAPTURE mode, the CAPTURE is started. And until desired jiffies,
+	 * wait interrupt.
 	 */
 	ret = m5mols_mode(info, REG_MONITOR);
 	if (!ret)
 		ret = m5mols_sync_controls(info);
 	if (!ret)
-		ret = m5mols_lock_3a(info, true);
+		ret = m5mols_write(sd, CAPP_YUVOUT_MAIN, REG_JPEG);
+	if (!ret)
+		ret = m5mols_write(sd, CAPP_MAIN_IMAGE_SIZE, resolution);
 	if (!ret)
-		ret = m5mols_enable_interrupt(sd, REG_INT_CAPTURE);
+		ret = m5mols_lock_3a(info, true);
 	if (!ret)
 		ret = m5mols_mode(info, REG_CAPTURE);
 	if (!ret)
-		/* Wait for capture interrupt, after changing capture mode */
 		ret = m5mols_timeout_interrupt(sd, REG_INT_CAPTURE, 2000);
 	if (!ret)
 		ret = m5mols_lock_3a(info, false);
 	if (ret)
 		return ret;
+
 	/*
-	 * Starting capture. Setting capture frame count and resolution and
-	 * the format(available format: JPEG, Bayer RAW, YUV).
-	 *
-	 * 1) select single or multi(enable to 25), format, size
-	 * 2) set interrupt
-	 * 3) start capture(for main image, now)
-	 * 4) get information
-	 * 5) notify file size to v4l2 device(e.g, to s5p-fimc v4l2 device)
+	 * TRANSFER - transfer captured image and information. As soon as
+	 * sending CAPC_START commands, the TRANSFER is started. And until
+	 * desired jiffies, wait interrupt.
 	 */
 	ret = m5mols_write(sd, CAPC_SEL_FRAME, 1);
 	if (!ret)
-		ret = m5mols_write(sd, CAPP_YUVOUT_MAIN, REG_JPEG);
-	if (!ret)
-		ret = m5mols_write(sd, CAPP_MAIN_IMAGE_SIZE, resolution);
-	if (!ret)
-		ret = m5mols_enable_interrupt(sd, REG_INT_CAPTURE);
-	if (!ret)
 		ret = m5mols_write(sd, CAPC_START, REG_CAP_START_MAIN);
 	if (!ret) {
-		/* Wait for the capture completion interrupt */
 		ret = m5mols_timeout_interrupt(sd, REG_INT_CAPTURE, 2000);
 		if (!ret) {
 			ret = m5mols_capture_info(info);
diff --git a/drivers/media/video/m5mols/m5mols_core.c b/drivers/media/video/m5mols/m5mols_core.c
index 0aae868..09bb258 100644
--- a/drivers/media/video/m5mols/m5mols_core.c
+++ b/drivers/media/video/m5mols/m5mols_core.c
@@ -806,9 +806,11 @@ static int m5mols_sensor_armboot(struct v4l2_subdev *sd)
 
 	v4l2_dbg(1, m5mols_debug, sd, "Success ARM Booting\n");
 
+	/* Initialize general setting for M-5MOLS */
 	ret = m5mols_write(sd, PARM_INTERFACE, REG_INTERFACE_MIPI);
 	if (!ret)
-		ret = m5mols_enable_interrupt(sd, REG_INT_AF);
+		ret = m5mols_enable_interrupt(sd,
+				REG_INT_AF | REG_INT_CAPTURE);
 
 	return ret;
 }
-- 
1.7.4.1

