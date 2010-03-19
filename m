Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:38148 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153Ab0CSGEW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Mar 2010 02:04:22 -0400
Received: from dbdp31.itg.ti.com ([172.24.170.98])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id o2J64JSm003962
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Fri, 19 Mar 2010 01:04:21 -0500
From: hvaibhav@ti.com
To: linux-media@vger.kernel.org
Cc: m-karicheri2@ti.com, Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [PATCH-V2 6/7] VPFE Capture: Add support for USERPTR mode of operation
Date: Fri, 19 Mar 2010 11:34:12 +0530
Message-Id: <1268978653-32710-7-git-send-email-hvaibhav@ti.com>
In-Reply-To: <hvaibhav@ti.com>
References: <hvaibhav@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Vaibhav Hiremath <hvaibhav@ti.com>


Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
---
 drivers/media/video/davinci/vpfe_capture.c |   42 ++++++++++++++++++---------
 1 files changed, 28 insertions(+), 14 deletions(-)

diff --git a/drivers/media/video/davinci/vpfe_capture.c b/drivers/media/video/davinci/vpfe_capture.c
index 3946a70..51f6213 100644
--- a/drivers/media/video/davinci/vpfe_capture.c
+++ b/drivers/media/video/davinci/vpfe_capture.c
@@ -539,6 +539,16 @@ static void vpfe_schedule_next_buffer(struct vpfe_device *vpfe_dev)
 	list_del(&vpfe_dev->next_frm->queue);
 	vpfe_dev->next_frm->state = VIDEOBUF_ACTIVE;
 	addr = videobuf_to_dma_contig(vpfe_dev->next_frm);
+
+	ccdc_dev->hw_ops.setfbaddr(addr);
+}
+
+static void vpfe_schedule_bottom_field(struct vpfe_device *vpfe_dev)
+{
+	unsigned long addr;
+
+	addr = videobuf_to_dma_contig(vpfe_dev->cur_frm);
+	addr += vpfe_dev->field_off;
 	ccdc_dev->hw_ops.setfbaddr(addr);
 }

@@ -559,7 +569,6 @@ static irqreturn_t vpfe_isr(int irq, void *dev_id)
 {
 	struct vpfe_device *vpfe_dev = dev_id;
 	enum v4l2_field field;
-	unsigned long addr;
 	int fid;

 	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "\nStarting vpfe_isr...\n");
@@ -604,10 +613,7 @@ static irqreturn_t vpfe_isr(int irq, void *dev_id)
 			 * the CCDC memory address
 			 */
 			if (field == V4L2_FIELD_SEQ_TB) {
-				addr =
-				  videobuf_to_dma_contig(vpfe_dev->cur_frm);
-				addr += vpfe_dev->field_off;
-				ccdc_dev->hw_ops.setfbaddr(addr);
+				vpfe_schedule_bottom_field(vpfe_dev);
 			}
 			goto clear_intr;
 		}
@@ -1234,7 +1240,10 @@ static int vpfe_videobuf_setup(struct videobuf_queue *vq,
 	struct vpfe_device *vpfe_dev = fh->vpfe_dev;

 	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_buffer_setup\n");
-	*size = config_params.device_bufsize;
+	*size = vpfe_dev->fmt.fmt.pix.sizeimage;
+	if (vpfe_dev->memory == V4L2_MEMORY_MMAP &&
+		vpfe_dev->fmt.fmt.pix.sizeimage > config_params.device_bufsize)
+		*size = config_params.device_bufsize;

 	if (*count < config_params.min_numbuffers)
 		*count = config_params.min_numbuffers;
@@ -1249,6 +1258,8 @@ static int vpfe_videobuf_prepare(struct videobuf_queue *vq,
 {
 	struct vpfe_fh *fh = vq->priv_data;
 	struct vpfe_device *vpfe_dev = fh->vpfe_dev;
+	unsigned long addr;
+	int ret;

 	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_buffer_prepare\n");

@@ -1258,8 +1269,18 @@ static int vpfe_videobuf_prepare(struct videobuf_queue *vq,
 		vb->height = vpfe_dev->fmt.fmt.pix.height;
 		vb->size = vpfe_dev->fmt.fmt.pix.sizeimage;
 		vb->field = field;
+
+		ret = videobuf_iolock(vq, vb, NULL);;
+		if (ret < 0)
+			return ret;
+
+		addr = videobuf_to_dma_contig(vb);
+		/* Make sure user addresses are aligned to 32 bytes */
+		if (!ALIGN(addr, 32))
+			return -EINVAL;
+
+		vb->state = VIDEOBUF_PREPARED;
 	}
-	vb->state = VIDEOBUF_PREPARED;
 	return 0;
 }

@@ -1327,13 +1348,6 @@ static int vpfe_reqbufs(struct file *file, void *priv,
 		return -EINVAL;
 	}

-	if (V4L2_MEMORY_USERPTR == req_buf->memory) {
-		/* we don't support user ptr IO */
-		v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_reqbufs:"
-			 " USERPTR IO not supported\n");
-		return  -EINVAL;
-	}
-
 	ret = mutex_lock_interruptible(&vpfe_dev->lock);
 	if (ret)
 		return ret;
--
1.6.2.4

