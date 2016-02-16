Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-3.cisco.com ([173.38.203.53]:57989 "EHLO
	aer-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755199AbcBPMxA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Feb 2016 07:53:00 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Florian Echtler <floe@butterbrot.org>
Subject: [PATCH 03/12] sur40: set q->dev instead of allocating a context
Date: Tue, 16 Feb 2016 13:42:58 +0100
Message-Id: <1455626587-8051-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1455626587-8051-1-git-send-email-hverkuil@xs4all.nl>
References: <1455626587-8051-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Stop using alloc_ctx and just fill in the device pointer.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Florian Echtler <floe@butterbrot.org>
#
#total: 0 errors, 0 warnings, 304 lines checked
#
#Your patch has no obvious style problems and is ready for submission.
#
#total: 0 errors, 0 warnings, 8 lines checked
#
#Your patch has no obvious style problems and is ready for submission.
---
 drivers/input/touchscreen/sur40.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/input/touchscreen/sur40.c b/drivers/input/touchscreen/sur40.c
index b6c4d03..4608010 100644
--- a/drivers/input/touchscreen/sur40.c
+++ b/drivers/input/touchscreen/sur40.c
@@ -151,7 +151,6 @@ struct sur40_state {
 	struct mutex lock;
 
 	struct vb2_queue queue;
-	struct vb2_alloc_ctx *alloc_ctx;
 	struct list_head buf_list;
 	spinlock_t qlock;
 	int sequence;
@@ -573,19 +572,13 @@ static int sur40_probe(struct usb_interface *interface,
 	sur40->queue = sur40_queue;
 	sur40->queue.drv_priv = sur40;
 	sur40->queue.lock = &sur40->lock;
+	sur40->queue.dev = sur40->dev;
 
 	/* initialize the queue */
 	error = vb2_queue_init(&sur40->queue);
 	if (error)
 		goto err_unreg_v4l2;
 
-	sur40->alloc_ctx = vb2_dma_sg_init_ctx(sur40->dev);
-	if (IS_ERR(sur40->alloc_ctx)) {
-		dev_err(sur40->dev, "Can't allocate buffer context");
-		error = PTR_ERR(sur40->alloc_ctx);
-		goto err_unreg_v4l2;
-	}
-
 	sur40->vdev = sur40_video_device;
 	sur40->vdev.v4l2_dev = &sur40->v4l2;
 	sur40->vdev.lock = &sur40->lock;
@@ -626,7 +619,6 @@ static void sur40_disconnect(struct usb_interface *interface)
 
 	video_unregister_device(&sur40->vdev);
 	v4l2_device_unregister(&sur40->v4l2);
-	vb2_dma_sg_cleanup_ctx(sur40->alloc_ctx);
 
 	input_unregister_polled_device(sur40->input);
 	input_free_polled_device(sur40->input);
@@ -648,11 +640,8 @@ static int sur40_queue_setup(struct vb2_queue *q,
 		       unsigned int *nbuffers, unsigned int *nplanes,
 		       unsigned int sizes[], void *alloc_ctxs[])
 {
-	struct sur40_state *sur40 = vb2_get_drv_priv(q);
-
 	if (q->num_buffers + *nbuffers < 3)
 		*nbuffers = 3 - q->num_buffers;
-	alloc_ctxs[0] = sur40->alloc_ctx;
 
 	if (*nplanes)
 		return sizes[0] < sur40_video_format.sizeimage ? -EINVAL : 0;
-- 
2.7.0

