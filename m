Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44084 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550Ab3LKQHu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Dec 2013 11:07:50 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Josh Wu <josh.wu@atmel.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH v2 4/7] v4l: atmel-isi: Reset the ISI when starting the stream
Date: Wed, 11 Dec 2013 17:07:42 +0100
Message-Id: <1386778065-14135-5-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1386778065-14135-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1386778065-14135-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The queue setup operation isn't the right place to reset the ISI. Move
the reset call to the start streaming operation.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Josh Wu <josh.wu@atmel.com>
---
 drivers/media/platform/soc_camera/atmel-isi.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index ea8816c..ae2c8c1 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -241,16 +241,6 @@ static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct atmel_isi *isi = ici->priv;
 	unsigned long size;
-	int ret;
-
-	/* Reset ISI */
-	ret = atmel_isi_wait_status(isi, WAIT_ISI_RESET);
-	if (ret < 0) {
-		dev_err(icd->parent, "Reset ISI timed out\n");
-		return ret;
-	}
-	/* Disable all interrupts */
-	isi_writel(isi, ISI_INTDIS, ~0UL);
 
 	size = icd->sizeimage;
 
@@ -390,6 +380,16 @@ static int start_streaming(struct vb2_queue *vq, unsigned int count)
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct atmel_isi *isi = ici->priv;
 	u32 sr = 0;
+	int ret;
+
+	/* Reset ISI */
+	ret = atmel_isi_wait_status(isi, WAIT_ISI_RESET);
+	if (ret < 0) {
+		dev_err(icd->parent, "Reset ISI timed out\n");
+		return ret;
+	}
+	/* Disable all interrupts */
+	isi_writel(isi, ISI_INTDIS, ~0UL);
 
 	spin_lock_irq(&isi->lock);
 	/* Clear any pending interrupt */
-- 
1.8.3.2

