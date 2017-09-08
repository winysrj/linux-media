Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:56798 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756688AbdIHTqT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Sep 2017 15:46:19 -0400
Subject: [PATCH 3/3] [media] fsl-viu: Adjust six checks for null pointers
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Geliang Tang <geliangtang@gmail.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <bf912679-c695-c9c0-a464-3bd3e976fa8a@users.sourceforge.net>
Message-ID: <ec2a2c6d-b007-bc7c-e01e-2f98024a3d97@users.sourceforge.net>
Date: Fri, 8 Sep 2017 21:46:08 +0200
MIME-Version: 1.0
In-Reply-To: <bf912679-c695-c9c0-a464-3bd3e976fa8a@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 8 Sep 2017 21:16:50 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The script “checkpatch.pl” pointed information out like the following.

Comparison to NULL could be written !…

Thus fix the affected source code places.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/platform/fsl-viu.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/fsl-viu.c b/drivers/media/platform/fsl-viu.c
index 1fe2a295db93..a133dfdd869a 100644
--- a/drivers/media/platform/fsl-viu.c
+++ b/drivers/media/platform/fsl-viu.c
@@ -313,7 +313,7 @@ static int restart_video_queue(struct viu_dmaqueue *vidq)
 		if (list_empty(&vidq->queued))
 			return 0;
 		buf = list_entry(vidq->queued.next, struct viu_buf, vb.queue);
-		if (prev == NULL) {
+		if (!prev) {
 			list_move_tail(&buf->vb.queue, &vidq->active);
 
 			dprintk(1, "Restarting video dma\n");
@@ -450,7 +450,7 @@ static int buffer_prepare(struct videobuf_queue *vq,
 	struct viu_buf *buf = container_of(vb, struct viu_buf, vb);
 	int rc;
 
-	BUG_ON(fh->fmt == NULL);
+	BUG_ON(!fh->fmt);
 
 	if (fh->width  < 48 || fh->width  > norm_maxw() ||
 	    fh->height < 32 || fh->height > norm_maxh())
@@ -668,9 +668,9 @@ static int verify_preview(struct viu_dev *dev, struct v4l2_window *win)
 	enum v4l2_field field;
 	int maxw, maxh;
 
-	if (dev->ovbuf.base == NULL)
+	if (!dev->ovbuf.base)
 		return -EINVAL;
-	if (dev->ovfmt == NULL)
+	if (!dev->ovfmt)
 		return -EINVAL;
 	if (win->w.width < 48 || win->w.height < 32)
 		return -EINVAL;
@@ -825,7 +825,7 @@ int vidioc_s_fbuf(struct file *file, void *priv, const struct v4l2_framebuffer *
 
 	/* check args */
 	fmt = format_by_fourcc(fb->fmt.pixelformat);
-	if (fmt == NULL)
+	if (!fmt)
 		return -EINVAL;
 
 	/* ok, accept it */
@@ -1472,7 +1472,7 @@ static int viu_of_probe(struct platform_device *op)
 
 	/* Allocate memory for video device */
 	vdev = video_device_alloc();
-	if (vdev == NULL) {
+	if (!vdev) {
 		ret = -ENOMEM;
 		goto err_vdev;
 	}
-- 
2.14.1
