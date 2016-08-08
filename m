Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp06.smtpout.orange.fr ([80.12.242.128]:38983 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932411AbcHHTb2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Aug 2016 15:31:28 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Jiri Kosina <trivial@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH v3 09/14] media: platform: pxa_camera: add buffer sequencing
Date: Mon,  8 Aug 2016 21:30:47 +0200
Message-Id: <1470684652-16295-10-git-send-email-robert.jarzmik@free.fr>
In-Reply-To: <1470684652-16295-1-git-send-email-robert.jarzmik@free.fr>
References: <1470684652-16295-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add sequence numbers to completed buffers.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 drivers/media/platform/soc_camera/pxa_camera.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
index d66443ac1f4d..8a65f126d091 100644
--- a/drivers/media/platform/soc_camera/pxa_camera.c
+++ b/drivers/media/platform/soc_camera/pxa_camera.c
@@ -223,6 +223,7 @@ struct pxa_camera_dev {
 	struct list_head	capture;
 
 	spinlock_t		lock;
+	unsigned int		buf_sequence;
 
 	struct pxa_buffer	*active;
 	struct tasklet_struct	task_eof;
@@ -401,6 +402,7 @@ static void pxa_camera_start_capture(struct pxa_camera_dev *pcdev)
 	unsigned long cicr0;
 
 	dev_dbg(pcdev_to_dev(pcdev), "%s\n", __func__);
+	pcdev->buf_sequence = 0;
 	__raw_writel(__raw_readl(pcdev->base + CISR), pcdev->base + CISR);
 	/* Enable End-Of-Frame Interrupt */
 	cicr0 = __raw_readl(pcdev->base + CICR0) | CICR0_ENB;
@@ -425,10 +427,13 @@ static void pxa_camera_wakeup(struct pxa_camera_dev *pcdev,
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
-- 
2.1.4

