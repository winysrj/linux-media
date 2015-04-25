Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:46806 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933272AbbDYPn3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Apr 2015 11:43:29 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 03/12] dt3155v4l: add v4l2_device support
Date: Sat, 25 Apr 2015 17:42:42 +0200
Message-Id: <1429976571-34872-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1429976571-34872-1-git-send-email-hverkuil@xs4all.nl>
References: <1429976571-34872-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add struct v4l2_device and register it. Also move the request_irq to
probe instead of doing that in open().

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/dt3155v4l/dt3155v4l.c | 45 +++++++++++++++++------------
 drivers/staging/media/dt3155v4l/dt3155v4l.h |  4 +++
 2 files changed, 31 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/media/dt3155v4l/dt3155v4l.c b/drivers/staging/media/dt3155v4l/dt3155v4l.c
index 5734dde..564483a 100644
--- a/drivers/staging/media/dt3155v4l/dt3155v4l.c
+++ b/drivers/staging/media/dt3155v4l/dt3155v4l.c
@@ -378,10 +378,6 @@ static int dt3155_open(struct file *filp)
 		/* disable all irqs, clear all irq flags */
 		iowrite32(FLD_START | FLD_END_EVEN | FLD_END_ODD,
 						pd->regs + INT_CSR);
-		ret = request_irq(pd->pdev->irq, dt3155_irq_handler_even,
-						IRQF_SHARED, DT3155_NAME, pd);
-		if (ret)
-			goto err_request_irq;
 	}
 	pd->users++;
 	mutex_unlock(&pd->mux);
@@ -403,7 +399,6 @@ static int dt3155_release(struct file *filp)
 	BUG_ON(pd->users < 0);
 	if (!pd->users) {
 		vb2_queue_release(pd->q);
-		free_irq(pd->pdev->irq, pd);
 		if (pd->q->alloc_ctx[0])
 			vb2_dma_contig_cleanup_ctx(pd->q->alloc_ctx[0]);
 		kfree(pd->q);
@@ -652,9 +647,9 @@ static const struct v4l2_ioctl_ops dt3155_ioctl_ops = {
 	.vidioc_s_parm = dt3155_s_parm,
 };
 
-static int dt3155_init_board(struct pci_dev *pdev)
+static int dt3155_init_board(struct dt3155_priv *pd)
 {
-	struct dt3155_priv *pd = pci_get_drvdata(pdev);
+	struct pci_dev *pdev = pd->pdev;
 	void *buf_cpu;
 	dma_addr_t buf_dma;
 	int i;
@@ -833,8 +828,11 @@ static int dt3155_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (!pd)
 		return -ENOMEM;
 
+	err = v4l2_device_register(&pdev->dev, &pd->v4l2_dev);
+	if (err)
+		return err;
 	pd->vdev = dt3155_vdev;
-	pci_set_drvdata(pdev, pd);    /* for use in dt3155_remove() */
+	pd->vdev.v4l2_dev = &pd->v4l2_dev;
 	video_set_drvdata(&pd->vdev, pd);  /* for use in video_fops */
 	pd->users = 0;
 	pd->pdev = pdev;
@@ -846,42 +844,53 @@ static int dt3155_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	pd->config = config_init;
 	err = pci_enable_device(pdev);
 	if (err)
-		return err;
+		goto err_v4l2_dev_unreg;
 	err = pci_request_region(pdev, 0, pci_name(pdev));
 	if (err)
-		goto err_req_region;
+		goto err_pci_disable;
 	pd->regs = pci_iomap(pdev, 0, pci_resource_len(pd->pdev, 0));
 	if (!pd->regs) {
 		err = -ENOMEM;
-		goto err_pci_iomap;
+		goto err_free_reg;
 	}
-	err = dt3155_init_board(pdev);
+	err = dt3155_init_board(pd);
+	if (err)
+		goto err_iounmap;
+	err = request_irq(pd->pdev->irq, dt3155_irq_handler_even,
+					IRQF_SHARED, DT3155_NAME, pd);
 	if (err)
-		goto err_init_board;
+		goto err_iounmap;
 	err = video_register_device(&pd->vdev, VFL_TYPE_GRABBER, -1);
 	if (err)
-		goto err_init_board;
+		goto err_free_irq;
 	if (dt3155_alloc_coherent(&pdev->dev, DT3155_CHUNK_SIZE,
 							DMA_MEMORY_MAP))
 		dev_info(&pdev->dev, "preallocated 8 buffers\n");
 	dev_info(&pdev->dev, "/dev/video%i is ready\n", pd->vdev.minor);
 	return 0;  /*   success   */
 
-err_init_board:
+err_free_irq:
+	free_irq(pd->pdev->irq, pd);
+err_iounmap:
 	pci_iounmap(pdev, pd->regs);
-err_pci_iomap:
+err_free_reg:
 	pci_release_region(pdev, 0);
-err_req_region:
+err_pci_disable:
 	pci_disable_device(pdev);
+err_v4l2_dev_unreg:
+	v4l2_device_unregister(&pd->v4l2_dev);
 	return err;
 }
 
 static void dt3155_remove(struct pci_dev *pdev)
 {
-	struct dt3155_priv *pd = pci_get_drvdata(pdev);
+	struct v4l2_device *v4l2_dev = pci_get_drvdata(pdev);
+	struct dt3155_priv *pd = container_of(v4l2_dev, struct dt3155_priv, v4l2_dev);
 
 	dt3155_free_coherent(&pdev->dev);
 	video_unregister_device(&pd->vdev);
+	free_irq(pd->pdev->irq, pd);
+	v4l2_device_unregister(&pd->v4l2_dev);
 	pci_iounmap(pdev, pd->regs);
 	pci_release_region(pdev, 0);
 	pci_disable_device(pdev);
diff --git a/drivers/staging/media/dt3155v4l/dt3155v4l.h b/drivers/staging/media/dt3155v4l/dt3155v4l.h
index b4cb412..16faefe 100644
--- a/drivers/staging/media/dt3155v4l/dt3155v4l.h
+++ b/drivers/staging/media/dt3155v4l/dt3155v4l.h
@@ -20,6 +20,8 @@
 
 #include <linux/pci.h>
 #include <linux/interrupt.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-dev.h>
 
 #define DT3155_NAME "dt3155"
 #define DT3155_VER_MAJ 1
@@ -157,6 +159,7 @@
 /**
  * struct dt3155_priv - private data structure
  *
+ * @v4l2_dev:		v4l2_device structure
  * @vdev:		video_device structure
  * @pdev:		pointer to pci_dev structure
  * @q			pointer to vb2_queue structure
@@ -172,6 +175,7 @@
  * @config:		local copy of config register
  */
 struct dt3155_priv {
+	struct v4l2_device v4l2_dev;
 	struct video_device vdev;
 	struct pci_dev *pdev;
 	struct vb2_queue *q;
-- 
2.1.4

