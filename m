Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:58408 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489AbbG2Tmp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jul 2015 15:42:45 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jiri Kosina <trivial@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Robert Jarzmik <robert.jarzmik@intel.com>
Subject: [PATCH v3 3/4] media: pxa_camera: trivial move of dma irq functions
Date: Wed, 29 Jul 2015 21:39:03 +0200
Message-Id: <1438198744-6150-4-git-send-email-robert.jarzmik@free.fr>
In-Reply-To: <1438198744-6150-1-git-send-email-robert.jarzmik@free.fr>
References: <1438198744-6150-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Robert Jarzmik <robert.jarzmik@intel.com>

This moves the dma irq handling functions up in the source file, so that
they are available before DMA preparation functions. It prepares the
conversion to DMA engine, where the descriptors are populated with these
functions as callbacks.

Signed-off-by: Robert Jarzmik <robert.jarzmik@intel.com>
---
Since v1: fixed prototypes change
---
 drivers/media/platform/soc_camera/pxa_camera.c | 42 +++++++++++++++-----------
 1 file changed, 24 insertions(+), 18 deletions(-)

diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
index 39c7e7519b3c..cdfb93aaee43 100644
--- a/drivers/media/platform/soc_camera/pxa_camera.c
+++ b/drivers/media/platform/soc_camera/pxa_camera.c
@@ -313,6 +313,30 @@ static int calculate_dma_sglen(struct scatterlist *sglist, int sglen,
 	return i + 1;
 }
 
+static void pxa_camera_dma_irq(struct pxa_camera_dev *pcdev,
+			       enum pxa_camera_active_dma act_dma);
+
+static void pxa_camera_dma_irq_y(int channel, void *data)
+{
+	struct pxa_camera_dev *pcdev = data;
+
+	pxa_camera_dma_irq(pcdev, DMA_Y);
+}
+
+static void pxa_camera_dma_irq_u(int channel, void *data)
+{
+	struct pxa_camera_dev *pcdev = data;
+
+	pxa_camera_dma_irq(pcdev, DMA_U);
+}
+
+static void pxa_camera_dma_irq_v(int channel, void *data)
+{
+	struct pxa_camera_dev *pcdev = data;
+
+	pxa_camera_dma_irq(pcdev, DMA_V);
+}
+
 /**
  * pxa_init_dma_channel - init dma descriptors
  * @pcdev: pxa camera device
@@ -810,24 +834,6 @@ out:
 	spin_unlock_irqrestore(&pcdev->lock, flags);
 }
 
-static void pxa_camera_dma_irq_y(int channel, void *data)
-{
-	struct pxa_camera_dev *pcdev = data;
-	pxa_camera_dma_irq(channel, pcdev, DMA_Y);
-}
-
-static void pxa_camera_dma_irq_u(int channel, void *data)
-{
-	struct pxa_camera_dev *pcdev = data;
-	pxa_camera_dma_irq(channel, pcdev, DMA_U);
-}
-
-static void pxa_camera_dma_irq_v(int channel, void *data)
-{
-	struct pxa_camera_dev *pcdev = data;
-	pxa_camera_dma_irq(channel, pcdev, DMA_V);
-}
-
 static struct videobuf_queue_ops pxa_videobuf_ops = {
 	.buf_setup      = pxa_videobuf_setup,
 	.buf_prepare    = pxa_videobuf_prepare,
-- 
2.1.4

