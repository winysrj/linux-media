Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:54571 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601Ab1LLRpH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Dec 2011 12:45:07 -0500
Received: from euspt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LW3000C7QN3JX@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 12 Dec 2011 17:45:03 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LW3007UZQN2EF@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 12 Dec 2011 17:45:03 +0000 (GMT)
Date: Mon, 12 Dec 2011 18:44:51 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 07/14] m5mols: Optimize the capture set up sequence
In-reply-to: <1323711898-17162-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, s.nawrocki@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1323711898-17162-8-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1323711898-17162-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: HeungJun Kim <riverful.kim@samsung.com>

Improve the single frame capture set up sequence. Since there is
no need to re-enable the interrupts in each capture sequence, unmask
the required interrupts once at the device initialization time.

Signed-off-by: HeungJun Kim <riverful.kim@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/m5mols/m5mols_capture.c |   40 +++++++++------------------
 drivers/media/video/m5mols/m5mols_core.c    |    3 +-
 2 files changed, 15 insertions(+), 28 deletions(-)

diff --git a/drivers/media/video/m5mols/m5mols_capture.c b/drivers/media/video/m5mols/m5mols_capture.c
index 6409c3f..8bb284d 100644
--- a/drivers/media/video/m5mols/m5mols_capture.c
+++ b/drivers/media/video/m5mols/m5mols_capture.c
@@ -109,51 +109,37 @@ int m5mols_start_capture(struct m5mols_info *info)
 	int ret;
 
 	/*
-	 * Preparing capture. Setting control & interrupt before entering
-	 * capture mode
-	 *
-	 * 1) change to MONITOR mode for operating control & interrupt
-	 * 2) set controls (considering v4l2_control value & lock 3A)
-	 * 3) set interrupt
-	 * 4) change to CAPTURE mode
+	 * Synchronize the controls, set the capture frame resolution and color
+	 * format. The frame capture is initiated during switching from Monitor
+	 * to Capture mode.
 	 */
 	ret = m5mols_mode(info, REG_MONITOR);
 	if (!ret)
 		ret = m5mols_sync_controls(info);
 	if (!ret)
-		ret = m5mols_lock_3a(info, true);
+		ret = m5mols_write(sd, CAPP_YUVOUT_MAIN, REG_JPEG);
 	if (!ret)
-		ret = m5mols_enable_interrupt(sd, REG_INT_CAPTURE);
+		ret = m5mols_write(sd, CAPP_MAIN_IMAGE_SIZE, resolution);
+	if (!ret)
+		ret = m5mols_write(sd, CAPP_JPEG_SIZE_MAX,
+				   mf->framesamples - M5MOLS_JPEG_TAGS_SIZE);
+	if (!ret)
+		ret = m5mols_lock_3a(info, true);
 	if (!ret)
 		ret = m5mols_mode(info, REG_CAPTURE);
 	if (!ret)
-		/* Wait for capture interrupt, after changing capture mode */
+		/* Wait until a frame is captured to ISP internal memory */
 		ret = m5mols_wait_interrupt(sd, REG_INT_CAPTURE, 2000);
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
+	 * Initiate the captured data transfer to a MIPI-CSI receiver.
 	 */
 	ret = m5mols_write(sd, CAPC_SEL_FRAME, 1);
 	if (!ret)
-		ret = m5mols_write(sd, CAPP_YUVOUT_MAIN, REG_JPEG);
-	if (!ret)
-		ret = m5mols_write(sd, CAPP_MAIN_IMAGE_SIZE, resolution);
-	if (!ret)
-		ret = m5mols_write(sd, CAPP_JPEG_SIZE_MAX,
-				   mf->framesamples - M5MOLS_JPEG_TAGS_SIZE);
-	if (!ret)
-		ret = m5mols_enable_interrupt(sd, REG_INT_CAPTURE);
-	if (!ret)
 		ret = m5mols_write(sd, CAPC_START, REG_CAP_START_MAIN);
 	if (!ret) {
 		/* Wait for the capture completion interrupt */
diff --git a/drivers/media/video/m5mols/m5mols_core.c b/drivers/media/video/m5mols/m5mols_core.c
index 3298c6f..f47d406 100644
--- a/drivers/media/video/m5mols/m5mols_core.c
+++ b/drivers/media/video/m5mols/m5mols_core.c
@@ -801,7 +801,8 @@ static int m5mols_fw_start(struct v4l2_subdev *sd)
 
 	ret = m5mols_write(sd, PARM_INTERFACE, REG_INTERFACE_MIPI);
 	if (!ret)
-		ret = m5mols_enable_interrupt(sd, REG_INT_AF);
+		ret = m5mols_enable_interrupt(sd,
+				REG_INT_AF | REG_INT_CAPTURE);
 
 	return ret;
 }
-- 
1.7.8

