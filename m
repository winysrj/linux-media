Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:55410 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673AbaKZWnO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Nov 2014 17:43:14 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org,
	Hans Verkuil <hans.verkuil@cisco.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: [PATCH v2 01/11] media: s3c-camif: use vb2_ops_wait_prepare/finish helper
Date: Wed, 26 Nov 2014 22:42:24 +0000
Message-Id: <1417041754-8714-2-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1417041754-8714-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1417041754-8714-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch drops driver specific wait_prepare() and
wait_finish() callbacks from vb2_ops and instead uses
the the helpers vb2_ops_wait_prepare/finish() provided
by the vb2 core, the lock member of the queue needs
to be initalized to a mutex so that vb2 helpers
vb2_ops_wait_prepare/finish() can make use of it.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
---
 drivers/media/platform/s3c-camif/camif-capture.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/media/platform/s3c-camif/camif-capture.c b/drivers/media/platform/s3c-camif/camif-capture.c
index aa40c82..54479d6 100644
--- a/drivers/media/platform/s3c-camif/camif-capture.c
+++ b/drivers/media/platform/s3c-camif/camif-capture.c
@@ -536,24 +536,12 @@ static void buffer_queue(struct vb2_buffer *vb)
 	spin_unlock_irqrestore(&camif->slock, flags);
 }
 
-static void camif_lock(struct vb2_queue *vq)
-{
-	struct camif_vp *vp = vb2_get_drv_priv(vq);
-	mutex_lock(&vp->camif->lock);
-}
-
-static void camif_unlock(struct vb2_queue *vq)
-{
-	struct camif_vp *vp = vb2_get_drv_priv(vq);
-	mutex_unlock(&vp->camif->lock);
-}
-
 static const struct vb2_ops s3c_camif_qops = {
 	.queue_setup	 = queue_setup,
 	.buf_prepare	 = buffer_prepare,
 	.buf_queue	 = buffer_queue,
-	.wait_prepare	 = camif_unlock,
-	.wait_finish	 = camif_lock,
+	.wait_prepare	 = vb2_ops_wait_prepare,
+	.wait_finish	 = vb2_ops_wait_finish,
 	.start_streaming = start_streaming,
 	.stop_streaming	 = stop_streaming,
 };
@@ -1161,6 +1149,7 @@ int s3c_camif_register_video_node(struct camif_dev *camif, int idx)
 	q->buf_struct_size = sizeof(struct camif_buffer);
 	q->drv_priv = vp;
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+	q->lock = &vp->camif->lock;
 
 	ret = vb2_queue_init(q);
 	if (ret)
-- 
1.9.1

