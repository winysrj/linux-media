Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44098 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129Ab3LDA40 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Dec 2013 19:56:26 -0500
Received: from avalon.ideasonboard.com (unknown [91.177.177.98])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 2CBF235AB1
	for <linux-media@vger.kernel.org>; Wed,  4 Dec 2013 01:55:38 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 02/25] v4l: omap4iss: Don't split log strings on multiple lines
Date: Wed,  4 Dec 2013 01:56:02 +0100
Message-Id: <1386118585-12449-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1386118585-12449-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1386118585-12449-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Non-split strings help grepping for messages.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/staging/media/omap4iss/iss.c         |  6 +++---
 drivers/staging/media/omap4iss/iss_csi2.c    | 13 ++++---------
 drivers/staging/media/omap4iss/iss_resizer.c |  5 +----
 drivers/staging/media/omap4iss/iss_video.c   |  4 ++--
 4 files changed, 10 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
index 3ac986e..53dcb54 100644
--- a/drivers/staging/media/omap4iss/iss.c
+++ b/drivers/staging/media/omap4iss/iss.c
@@ -1073,9 +1073,9 @@ iss_register_subdev_group(struct iss_device *iss,
 
 		adapter = i2c_get_adapter(board_info->i2c_adapter_id);
 		if (adapter == NULL) {
-			dev_err(iss->dev, "%s: Unable to get I2C adapter %d for "
-				"device %s\n", __func__,
-				board_info->i2c_adapter_id,
+			dev_err(iss->dev,
+				"%s: Unable to get I2C adapter %d for device %s\n",
+				__func__, board_info->i2c_adapter_id,
 				board_info->board_info->type);
 			continue;
 		}
diff --git a/drivers/staging/media/omap4iss/iss_csi2.c b/drivers/staging/media/omap4iss/iss_csi2.c
index 9ced9ce..c3a5fca 100644
--- a/drivers/staging/media/omap4iss/iss_csi2.c
+++ b/drivers/staging/media/omap4iss/iss_csi2.c
@@ -754,8 +754,8 @@ void omap4iss_csi2_isr(struct iss_csi2_device *csi2)
 					 CSI2_COMPLEXIO_IRQSTATUS);
 		writel(cpxio1_irqstatus,
 			csi2->regs1 + CSI2_COMPLEXIO_IRQSTATUS);
-		dev_dbg(iss->dev, "CSI2: ComplexIO Error IRQ "
-			"%x\n", cpxio1_irqstatus);
+		dev_dbg(iss->dev, "CSI2: ComplexIO Error IRQ %x\n",
+			cpxio1_irqstatus);
 		pipe->error = true;
 	}
 
@@ -764,13 +764,8 @@ void omap4iss_csi2_isr(struct iss_csi2_device *csi2)
 			      CSI2_IRQ_ECC_NO_CORRECTION |
 			      CSI2_IRQ_COMPLEXIO_ERR |
 			      CSI2_IRQ_FIFO_OVF)) {
-		dev_dbg(iss->dev, "CSI2 Err:"
-			" OCP:%d,"
-			" Short_pack:%d,"
-			" ECC:%d,"
-			" CPXIO:%d,"
-			" FIFO_OVF:%d,"
-			"\n",
+		dev_dbg(iss->dev,
+			"CSI2 Err: OCP:%d SHORT:%d ECC:%d CPXIO:%d OVF:%d\n",
 			(csi2_irqstatus &
 			 CSI2_IRQ_OCP_ERR) ? 1 : 0,
 			(csi2_irqstatus &
diff --git a/drivers/staging/media/omap4iss/iss_resizer.c b/drivers/staging/media/omap4iss/iss_resizer.c
index cb5df52..e5a3a8cf 100644
--- a/drivers/staging/media/omap4iss/iss_resizer.c
+++ b/drivers/staging/media/omap4iss/iss_resizer.c
@@ -321,10 +321,7 @@ void omap4iss_resizer_isr(struct iss_resizer_device *resizer, u32 events)
 
 	if (events & (ISP5_IRQ_RSZ_FIFO_IN_BLK |
 		      ISP5_IRQ_RSZ_FIFO_OVF)) {
-		dev_dbg(iss->dev, "RSZ Err:"
-			" FIFO_IN_BLK:%d,"
-			" FIFO_OVF:%d,"
-			"\n",
+		dev_dbg(iss->dev, "RSZ Err: FIFO_IN_BLK:%d, FIFO_OVF:%d\n",
 			(events &
 			 ISP5_IRQ_RSZ_FIFO_IN_BLK) ? 1 : 0,
 			(events &
diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
index 5a92bac..3e543d9 100644
--- a/drivers/staging/media/omap4iss/iss_video.c
+++ b/drivers/staging/media/omap4iss/iss_video.c
@@ -324,8 +324,8 @@ static int iss_video_buf_prepare(struct vb2_buffer *vb)
 
 	addr = vb2_dma_contig_plane_dma_addr(vb, 0);
 	if (!IS_ALIGNED(addr, 32)) {
-		dev_dbg(video->iss->dev, "Buffer address must be "
-			"aligned to 32 bytes boundary.\n");
+		dev_dbg(video->iss->dev,
+			"Buffer address must be aligned to 32 bytes boundary.\n");
 		return -EINVAL;
 	}
 
-- 
1.8.3.2

