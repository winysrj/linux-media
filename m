Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:35858 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934701AbeFOTHx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Jun 2018 15:07:53 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH v4 02/17] sta2x11: Add video_device and vb2_queue locks
Date: Fri, 15 Jun 2018 16:07:22 -0300
Message-Id: <20180615190737.24139-3-ezequiel@collabora.com>
In-Reply-To: <20180615190737.24139-1-ezequiel@collabora.com>
References: <20180615190737.24139-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently, this driver does not serialize its video4linux
ioctls, which is a bug, as race conditions might appear.

In addition, video_device and vb2_queue locks are now both
mandatory. Add them, and implement wait_prepare and
wait_finish.

To stay on the safe side, this commit uses a single mutex
for both locks. Better latency can be obtained by separating
these if needed.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 drivers/media/pci/sta2x11/sta2x11_vip.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/pci/sta2x11/sta2x11_vip.c b/drivers/media/pci/sta2x11/sta2x11_vip.c
index 069c4a853346..da2b2a2292d0 100644
--- a/drivers/media/pci/sta2x11/sta2x11_vip.c
+++ b/drivers/media/pci/sta2x11/sta2x11_vip.c
@@ -145,6 +145,7 @@ struct sta2x11_vip {
 	unsigned int sequence;
 	struct vip_buffer *active; /* current active buffer */
 	spinlock_t lock; /* Used in videobuf2 callback */
+	struct mutex v4l_lock;
 
 	/* Interrupt counters */
 	int tcount, bcount;
@@ -385,6 +386,8 @@ static const struct vb2_ops vip_video_qops = {
 	.buf_queue		= buffer_queue,
 	.start_streaming	= start_streaming,
 	.stop_streaming		= stop_streaming,
+	.wait_prepare		= vb2_ops_wait_prepare,
+	.wait_finish		= vb2_ops_wait_finish,
 };
 
 
@@ -870,6 +873,7 @@ static int sta2x11_vip_init_buffer(struct sta2x11_vip *vip)
 	vip->vb_vidq.mem_ops = &vb2_dma_contig_memops;
 	vip->vb_vidq.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	vip->vb_vidq.dev = &vip->pdev->dev;
+	vip->vb_vidq.lock = &vip->v4l_lock;
 	err = vb2_queue_init(&vip->vb_vidq);
 	if (err)
 		return err;
@@ -1034,6 +1038,7 @@ static int sta2x11_vip_init_one(struct pci_dev *pdev,
 	vip->std = V4L2_STD_PAL;
 	vip->format = formats_50[0];
 	vip->config = config;
+	mutex_init(&vip->v4l_lock);
 
 	ret = sta2x11_vip_init_controls(vip);
 	if (ret)
@@ -1080,6 +1085,7 @@ static int sta2x11_vip_init_one(struct pci_dev *pdev,
 	vip->video_dev = video_dev_template;
 	vip->video_dev.v4l2_dev = &vip->v4l2_dev;
 	vip->video_dev.queue = &vip->vb_vidq;
+	vip->video_dev.lock = &vip->v4l_lock;
 	video_set_drvdata(&vip->video_dev, vip);
 
 	ret = video_register_device(&vip->video_dev, VFL_TYPE_GRABBER, -1);
-- 
2.17.1
