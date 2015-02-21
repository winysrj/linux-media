Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:41109 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155AbbBUSka (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Feb 2015 13:40:30 -0500
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: Scott Jiang <scott.jiang.linux@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	adi-buildroot-devel@lists.sourceforge.net
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	LMML <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v3 02/15] media: blackfin: bfin_capture: release buffers in case start_streaming() call back fails
Date: Sat, 21 Feb 2015 18:39:48 +0000
Message-Id: <1424544001-19045-3-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1424544001-19045-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1424544001-19045-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

this patch adds support to release the buffer by calling
vb2_buffer_done(), with state marked as VB2_BUF_STATE_QUEUED
if start_streaming() call back fails.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/blackfin/bfin_capture.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index c6d8b95..2c720bc 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -345,6 +345,7 @@ static int bcap_start_streaming(struct vb2_queue *vq, unsigned int count)
 {
 	struct bcap_device *bcap_dev = vb2_get_drv_priv(vq);
 	struct ppi_if *ppi = bcap_dev->ppi;
+	struct bcap_buffer *buf, *tmp;
 	struct ppi_params params;
 	int ret;
 
@@ -352,7 +353,7 @@ static int bcap_start_streaming(struct vb2_queue *vq, unsigned int count)
 	ret = v4l2_subdev_call(bcap_dev->sd, video, s_stream, 1);
 	if (ret && (ret != -ENOIOCTLCMD)) {
 		v4l2_err(&bcap_dev->v4l2_dev, "stream on failed in subdev\n");
-		return ret;
+		goto err;
 	}
 
 	/* set ppi params */
@@ -391,7 +392,7 @@ static int bcap_start_streaming(struct vb2_queue *vq, unsigned int count)
 	if (ret < 0) {
 		v4l2_err(&bcap_dev->v4l2_dev,
 				"Error in setting ppi params\n");
-		return ret;
+		goto err;
 	}
 
 	/* attach ppi DMA irq handler */
@@ -399,12 +400,21 @@ static int bcap_start_streaming(struct vb2_queue *vq, unsigned int count)
 	if (ret < 0) {
 		v4l2_err(&bcap_dev->v4l2_dev,
 				"Error in attaching interrupt handler\n");
-		return ret;
+		goto err;
 	}
 
 	reinit_completion(&bcap_dev->comp);
 	bcap_dev->stop = false;
+
 	return 0;
+
+err:
+	list_for_each_entry_safe(buf, tmp, &bcap_dev->dma_queue, list) {
+		list_del(&buf->list);
+		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+	}
+
+	return ret;
 }
 
 static void bcap_stop_streaming(struct vb2_queue *vq)
-- 
2.1.0

