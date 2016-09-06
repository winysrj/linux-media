Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp10.smtpout.orange.fr ([80.12.242.132]:38664 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755920AbcIFJEd (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Sep 2016 05:04:33 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Jiri Kosina <trivial@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH v6 08/14] media: platform: pxa_camera: add buffer sequencing
Date: Tue,  6 Sep 2016 11:04:18 +0200
Message-Id: <1473152664-5077-8-git-send-email-robert.jarzmik@free.fr>
In-Reply-To: <1473152664-5077-1-git-send-email-robert.jarzmik@free.fr>
References: <1473152664-5077-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add sequence numbers to completed buffers.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 drivers/media/platform/soc_camera/pxa_camera.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
index 026ed308fea8..d9e2570d3931 100644
--- a/drivers/media/platform/soc_camera/pxa_camera.c
+++ b/drivers/media/platform/soc_camera/pxa_camera.c
@@ -223,6 +223,7 @@ struct pxa_camera_dev {
 	struct list_head	capture;
 
 	spinlock_t		lock;
+	unsigned int		buf_sequence;
 
 	struct pxa_buffer	*active;
 	struct tasklet_struct	task_eof;
@@ -423,10 +424,13 @@ static void pxa_camera_wakeup(struct pxa_camera_dev *pcdev,
 			      struct pxa_buffer *buf)
 {
 	struct vb2_buffer *vb = &buf->vbuf.vb2_buf;
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 
 	/* _init is used to debug races, see comment in pxa_camera_reqbufs() */
 	list_del_init(&buf->queue);
 	vb->timestamp = ktime_get_ns();
+	vbuf->sequence = pcdev->buf_sequence++;
+	vbuf->field = V4L2_FIELD_NONE;
 	vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
 	dev_dbg(pcdev_to_dev(pcdev), "%s dequeud buffer (buf=0x%p)\n",
 		__func__, buf);
@@ -1022,6 +1026,7 @@ static int pxac_vb2_start_streaming(struct vb2_queue *vq, unsigned int count)
 	dev_dbg(pcdev_to_dev(pcdev), "%s(count=%d) active=%p\n",
 		__func__, count, pcdev->active);
 
+	pcdev->buf_sequence = 0;
 	if (!pcdev->active)
 		pxa_camera_start_capture(pcdev);
 
-- 
2.1.4

