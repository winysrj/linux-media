Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:55543 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932602AbbCIQfD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 12:35:03 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 05/19] dt3155v4l: embed video_device
Date: Mon,  9 Mar 2015 17:33:59 +0100
Message-Id: <1425918853-12371-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425918853-12371-1-git-send-email-hverkuil@xs4all.nl>
References: <1425918853-12371-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Embed the video_device struct to simplify the error handling and in
order to (eventually) get rid of video_device_alloc/release.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/dt3155v4l/dt3155v4l.c | 30 ++++++++++-------------------
 drivers/staging/media/dt3155v4l/dt3155v4l.h |  4 ++--
 2 files changed, 12 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/media/dt3155v4l/dt3155v4l.c b/drivers/staging/media/dt3155v4l/dt3155v4l.c
index e60a53e..52a8ffe 100644
--- a/drivers/staging/media/dt3155v4l/dt3155v4l.c
+++ b/drivers/staging/media/dt3155v4l/dt3155v4l.c
@@ -244,7 +244,7 @@ dt3155_wait_prepare(struct vb2_queue *q)
 {
 	struct dt3155_priv *pd = vb2_get_drv_priv(q);
 
-	mutex_unlock(pd->vdev->lock);
+	mutex_unlock(pd->vdev.lock);
 }
 
 static void
@@ -252,7 +252,7 @@ dt3155_wait_finish(struct vb2_queue *q)
 {
 	struct dt3155_priv *pd = vb2_get_drv_priv(q);
 
-	mutex_lock(pd->vdev->lock);
+	mutex_lock(pd->vdev.lock);
 }
 
 static int
@@ -824,7 +824,7 @@ static struct video_device dt3155_vdev = {
 	.fops = &dt3155_fops,
 	.ioctl_ops = &dt3155_ioctl_ops,
 	.minor = -1,
-	.release = video_device_release,
+	.release = video_device_release_empty,
 	.tvnorms = DT3155_CURRENT_NORM,
 };
 
@@ -904,24 +904,21 @@ dt3155_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	pd = devm_kzalloc(&pdev->dev, sizeof(*pd), GFP_KERNEL);
 	if (!pd)
 		return -ENOMEM;
-	pd->vdev = video_device_alloc();
-	if (!pd->vdev)
-		return -ENOMEM;
 
-	*pd->vdev = dt3155_vdev;
+	pd->vdev = dt3155_vdev;
 	pci_set_drvdata(pdev, pd);    /* for use in dt3155_remove() */
-	video_set_drvdata(pd->vdev, pd);  /* for use in video_fops */
+	video_set_drvdata(&pd->vdev, pd);  /* for use in video_fops */
 	pd->users = 0;
 	pd->pdev = pdev;
 	INIT_LIST_HEAD(&pd->dmaq);
 	mutex_init(&pd->mux);
-	pd->vdev->lock = &pd->mux; /* for locking v4l2_file_operations */
+	pd->vdev.lock = &pd->mux; /* for locking v4l2_file_operations */
 	spin_lock_init(&pd->lock);
 	pd->csr2 = csr2_init;
 	pd->config = config_init;
 	err = pci_enable_device(pdev);
 	if (err)
-		goto err_enable_dev;
+		return err;
 	err = pci_request_region(pdev, 0, pci_name(pdev));
 	if (err)
 		goto err_req_region;
@@ -933,13 +930,13 @@ dt3155_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	err = dt3155_init_board(pdev);
 	if (err)
 		goto err_init_board;
-	err = video_register_device(pd->vdev, VFL_TYPE_GRABBER, -1);
+	err = video_register_device(&pd->vdev, VFL_TYPE_GRABBER, -1);
 	if (err)
 		goto err_init_board;
 	if (dt3155_alloc_coherent(&pdev->dev, DT3155_CHUNK_SIZE,
 							DMA_MEMORY_MAP))
 		dev_info(&pdev->dev, "preallocated 8 buffers\n");
-	dev_info(&pdev->dev, "/dev/video%i is ready\n", pd->vdev->minor);
+	dev_info(&pdev->dev, "/dev/video%i is ready\n", pd->vdev.minor);
 	return 0;  /*   success   */
 
 err_init_board:
@@ -948,9 +945,6 @@ err_pci_iomap:
 	pci_release_region(pdev, 0);
 err_req_region:
 	pci_disable_device(pdev);
-err_enable_dev:
-	video_device_release(pd->vdev);
-
 	return err;
 }
 
@@ -960,14 +954,10 @@ dt3155_remove(struct pci_dev *pdev)
 	struct dt3155_priv *pd = pci_get_drvdata(pdev);
 
 	dt3155_free_coherent(&pdev->dev);
-	video_unregister_device(pd->vdev);
+	video_unregister_device(&pd->vdev);
 	pci_iounmap(pdev, pd->regs);
 	pci_release_region(pdev, 0);
 	pci_disable_device(pdev);
-	/*
-	 * video_device_release() is invoked automatically
-	 * see: struct video_device dt3155_vdev
-	 */
 }
 
 static const struct pci_device_id pci_ids[] = {
diff --git a/drivers/staging/media/dt3155v4l/dt3155v4l.h b/drivers/staging/media/dt3155v4l/dt3155v4l.h
index 2e4f89d..96f01a0 100644
--- a/drivers/staging/media/dt3155v4l/dt3155v4l.h
+++ b/drivers/staging/media/dt3155v4l/dt3155v4l.h
@@ -178,7 +178,7 @@ struct dt3155_stats {
 /**
  * struct dt3155_priv - private data structure
  *
- * @vdev:		pointer to video_device structure
+ * @vdev:		video_device structure
  * @pdev:		pointer to pci_dev structure
  * @q			pointer to vb2_queue structure
  * @curr_buf:		pointer to curren buffer
@@ -193,7 +193,7 @@ struct dt3155_stats {
  * @config:		local copy of config register
  */
 struct dt3155_priv {
-	struct video_device *vdev;
+	struct video_device vdev;
 	struct pci_dev *pdev;
 	struct vb2_queue *q;
 	struct vb2_buffer *curr_buf;
-- 
2.1.4

