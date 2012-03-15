Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:30756 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031970Ab2COQyw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Mar 2012 12:54:52 -0400
Received: from euspt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M0X009O6QZ6NE@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 15 Mar 2012 16:54:42 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M0X002OFQZ3O0@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 15 Mar 2012 16:54:40 +0000 (GMT)
Date: Thu, 15 Mar 2012 17:54:24 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH/RFC 10/23] m5mols: Comments and data structures cleanup
In-reply-to: <1331830477-12146-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, riverful.kim@samsung.com,
	kyungmin.park@samsung.com, s.nawrocki@samsung.com
Message-id: <1331830477-12146-11-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1331830477-12146-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Update data structures documentation, fix typos and use more descriptive
names for some structure members.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/m5mols/m5mols.h          |   12 ++++++------
 drivers/media/video/m5mols/m5mols_controls.c |    8 ++++----
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/media/video/m5mols/m5mols.h b/drivers/media/video/m5mols/m5mols.h
index 4b021e1..35a3949 100644
--- a/drivers/media/video/m5mols/m5mols.h
+++ b/drivers/media/video/m5mols/m5mols.h
@@ -163,7 +163,7 @@ struct m5mols_version {
  * @ffmt: current fmt according to resolution type
  * @res_type: current resolution type
  * @irq_waitq: waitqueue for the capture
- * @flags: state variable for the interrupt handler
+ * @irq_done: set to 1 in the interrupt handler
  * @handle: control handler
  * @autoexposure: Auto Exposure control
  * @exposure: Exposure control
@@ -173,11 +173,11 @@ struct m5mols_version {
  * @zoom: Zoom control
  * @ver: information of the version
  * @cap: the capture mode attributes
- * @power: current sensor's power status
  * @isp_ready: 1 when the ISP controller has completed booting
+ * @power: current sensor's power status
  * @ctrl_sync: 1 when the control handler state is restored in H/W
- * @lock_ae: true means the Auto Exposure is locked
- * @lock_awb: true means the Aut WhiteBalance is locked
+ * @ae_locked: true when the Auto Exposure algorithm is locked
+ * @awb_locked: true when the Auto White Balance is locked
  * @resolution:	register value for current resolution
  * @mode: register value for current operation mode
  * @set_power: optional power callback to the board code
@@ -210,8 +210,8 @@ struct m5mols_info {
 	unsigned int power:1;
 	unsigned int ctrl_sync:1;
 
-	bool lock_ae;
-	bool lock_awb;
+	bool ae_locked;
+	bool awb_locked;
 	u8 resolution;
 	u8 mode;
 
diff --git a/drivers/media/video/m5mols/m5mols_controls.c b/drivers/media/video/m5mols/m5mols_controls.c
index d135d20..0730e50 100644
--- a/drivers/media/video/m5mols/m5mols_controls.c
+++ b/drivers/media/video/m5mols/m5mols_controls.c
@@ -190,11 +190,11 @@ static int m5mols_lock_ae(struct m5mols_info *info, bool lock)
 {
 	int ret = 0;
 
-	if (info->lock_ae != lock)
+	if (info->ae_locked != lock)
 		ret = m5mols_write(&info->sd, AE_LOCK,
 				lock ? REG_AE_LOCK : REG_AE_UNLOCK);
 	if (!ret)
-		info->lock_ae = lock;
+		info->ae_locked = lock;
 
 	return ret;
 }
@@ -203,11 +203,11 @@ static int m5mols_lock_awb(struct m5mols_info *info, bool lock)
 {
 	int ret = 0;
 
-	if (info->lock_awb != lock)
+	if (info->awb_locked != lock)
 		ret = m5mols_write(&info->sd, AWB_LOCK,
 				lock ? REG_AWB_LOCK : REG_AWB_UNLOCK);
 	if (!ret)
-		info->lock_awb = lock;
+		info->awb_locked = lock;
 
 	return ret;
 }
-- 
1.7.9.2

