Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:57991 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751798AbcDWLEC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Apr 2016 07:04:02 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv4 03/13] v4l2-pci-skeleton: set q->dev instead of allocating a context
Date: Sat, 23 Apr 2016 13:03:39 +0200
Message-Id: <1461409429-24995-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1461409429-24995-1-git-send-email-hverkuil@xs4all.nl>
References: <1461409429-24995-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Stop using alloc_ctx as that is now no longer needed.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/video4linux/v4l2-pci-skeleton.c | 15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/Documentation/video4linux/v4l2-pci-skeleton.c b/Documentation/video4linux/v4l2-pci-skeleton.c
index a55cf94..5f91d76 100644
--- a/Documentation/video4linux/v4l2-pci-skeleton.c
+++ b/Documentation/video4linux/v4l2-pci-skeleton.c
@@ -56,7 +56,6 @@ MODULE_LICENSE("GPL v2");
  * @format: current pix format
  * @input: current video input (0 = SDTV, 1 = HDTV)
  * @queue: vb2 video capture queue
- * @alloc_ctx: vb2 contiguous DMA context
  * @qlock: spinlock controlling access to buf_list and sequence
  * @buf_list: list of buffers queued for DMA
  * @sequence: frame sequence counter
@@ -73,7 +72,6 @@ struct skeleton {
 	unsigned input;
 
 	struct vb2_queue queue;
-	struct vb2_alloc_ctx *alloc_ctx;
 
 	spinlock_t qlock;
 	struct list_head buf_list;
@@ -182,7 +180,6 @@ static int queue_setup(struct vb2_queue *vq,
 
 	if (vq->num_buffers + *nbuffers < 3)
 		*nbuffers = 3 - vq->num_buffers;
-	alloc_ctxs[0] = skel->alloc_ctx;
 
 	if (*nplanes)
 		return sizes[0] < skel->format.sizeimage ? -EINVAL : 0;
@@ -820,6 +817,7 @@ static int skeleton_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	q = &skel->queue;
 	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	q->io_modes = VB2_MMAP | VB2_DMABUF | VB2_READ;
+	q->dev = &pdev->dev;
 	q->drv_priv = skel;
 	q->buf_struct_size = sizeof(struct skel_buffer);
 	q->ops = &skel_qops;
@@ -850,12 +848,6 @@ static int skeleton_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (ret)
 		goto free_hdl;
 
-	skel->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
-	if (IS_ERR(skel->alloc_ctx)) {
-		dev_err(&pdev->dev, "Can't allocate buffer context");
-		ret = PTR_ERR(skel->alloc_ctx);
-		goto free_hdl;
-	}
 	INIT_LIST_HEAD(&skel->buf_list);
 	spin_lock_init(&skel->qlock);
 
@@ -885,13 +877,11 @@ static int skeleton_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	ret = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
 	if (ret)
-		goto free_ctx;
+		goto free_hdl;
 
 	dev_info(&pdev->dev, "V4L2 PCI Skeleton Driver loaded\n");
 	return 0;
 
-free_ctx:
-	vb2_dma_contig_cleanup_ctx(skel->alloc_ctx);
 free_hdl:
 	v4l2_ctrl_handler_free(&skel->ctrl_handler);
 	v4l2_device_unregister(&skel->v4l2_dev);
@@ -907,7 +897,6 @@ static void skeleton_remove(struct pci_dev *pdev)
 
 	video_unregister_device(&skel->vdev);
 	v4l2_ctrl_handler_free(&skel->ctrl_handler);
-	vb2_dma_contig_cleanup_ctx(skel->alloc_ctx);
 	v4l2_device_unregister(&skel->v4l2_dev);
 	pci_disable_device(skel->pdev);
 }
-- 
2.8.0.rc3

