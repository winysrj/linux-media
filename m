Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp06.smtpout.orange.fr ([80.12.242.128]:30323 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932357AbcHHTjA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Aug 2016 15:39:00 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Jiri Kosina <trivial@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH v3 13/14] media: platform: pxa_camera: change stop_streaming semantics
Date: Mon,  8 Aug 2016 21:30:51 +0200
Message-Id: <1470684652-16295-14-git-send-email-robert.jarzmik@free.fr>
In-Reply-To: <1470684652-16295-1-git-send-email-robert.jarzmik@free.fr>
References: <1470684652-16295-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of the legacy behavior where it was required to wait for all
video buffers to be finished by the hardware, use a cancel like strategy
: as soon as the stop_streaming() call is done, abort all DMA transfers,
report the already buffers as failed and return.

This makes stop_streaming() more a "cancel capture" than a "wait for end
of capture" semantic.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 drivers/media/platform/soc_camera/pxa_camera.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
index 20340489e07e..a161b64d420d 100644
--- a/drivers/media/platform/soc_camera/pxa_camera.c
+++ b/drivers/media/platform/soc_camera/pxa_camera.c
@@ -526,7 +526,8 @@ static void pxa_camera_stop_capture(struct pxa_camera_dev *pcdev)
 }
 
 static void pxa_camera_wakeup(struct pxa_camera_dev *pcdev,
-			      struct pxa_buffer *buf)
+			      struct pxa_buffer *buf,
+			      enum vb2_buffer_state state)
 {
 	struct vb2_buffer *vb = &buf->vbuf.vb2_buf;
 	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
@@ -648,7 +649,7 @@ static void pxa_camera_dma_irq(struct pxa_camera_dev *pcdev,
 	}
 	buf->active_dma &= ~act_dma;
 	if (!buf->active_dma) {
-		pxa_camera_wakeup(pcdev, buf);
+		pxa_camera_wakeup(pcdev, buf, VB2_BUF_STATE_DONE);
 		pxa_camera_check_link_miss(pcdev, last_buf->cookie[chan],
 					   last_issued);
 	}
@@ -1090,7 +1091,15 @@ static int pxac_vb2_start_streaming(struct vb2_queue *vq, unsigned int count)
 
 static void pxac_vb2_stop_streaming(struct vb2_queue *vq)
 {
-	vb2_wait_for_all_buffers(vq);
+	struct pxa_camera_dev *pcdev = vb2_get_drv_priv(vq);
+	struct pxa_buffer *buf, *tmp;
+
+	dev_dbg(pcdev_to_dev(pcdev), "%s active=%p\n",
+		__func__, pcdev->active);
+	pxa_camera_stop_capture(pcdev);
+
+	list_for_each_entry_safe(buf, tmp, &pcdev->capture, queue)
+		pxa_camera_wakeup(pcdev, buf, VB2_BUF_STATE_ERROR);
 }
 
 static struct vb2_ops pxac_vb2_ops = {
-- 
2.1.4

