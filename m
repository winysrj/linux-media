Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4193 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754684AbaHNJyZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Aug 2014 05:54:25 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: stoth@kernellabs.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 20/20] cx23885: Add busy checks before changing formats
Date: Thu, 14 Aug 2014 11:54:05 +0200
Message-Id: <1408010045-24016-21-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1408010045-24016-1-git-send-email-hverkuil@xs4all.nl>
References: <1408010045-24016-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Before you can change the standard or the capture format, make sure the
various vb2_queues aren't in use since you cannot change the buffer size from
underneath a a busy vb2_queue.

Also make sure that the return code of cx23885_set_tvnorm is returned
correctly, otherwise the -EBUSY will be lost.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx23885/cx23885-417.c   | 10 +++++-----
 drivers/media/pci/cx23885/cx23885-video.c | 15 ++++++++++++---
 2 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/media/pci/cx23885/cx23885-417.c b/drivers/media/pci/cx23885/cx23885-417.c
index f1ef901..6973055 100644
--- a/drivers/media/pci/cx23885/cx23885-417.c
+++ b/drivers/media/pci/cx23885/cx23885-417.c
@@ -1248,18 +1248,18 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id id)
 {
 	struct cx23885_dev *dev = video_drvdata(file);
 	unsigned int i;
+	int ret;
 
 	for (i = 0; i < ARRAY_SIZE(cx23885_tvnorms); i++)
 		if (id & cx23885_tvnorms[i].id)
 			break;
 	if (i == ARRAY_SIZE(cx23885_tvnorms))
 		return -EINVAL;
-	dev->encodernorm = cx23885_tvnorms[i];
-
-	/* Have the drier core notify the subdevices */
-	cx23885_set_tvnorm(dev, id);
 
-	return 0;
+	ret = cx23885_set_tvnorm(dev, id);
+	if (!ret)
+		dev->encodernorm = cx23885_tvnorms[i];
+	return ret;
 }
 
 static int vidioc_enum_input(struct file *file, void *priv,
diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index defdf74..f0ea904 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -119,6 +119,12 @@ int cx23885_set_tvnorm(struct cx23885_dev *dev, v4l2_std_id norm)
 		(unsigned int)norm,
 		v4l2_norm_to_name(norm));
 
+	if (dev->tvnorm != norm) {
+		if (vb2_is_busy(&dev->vb2_vidq) || vb2_is_busy(&dev->vb2_vbiq) ||
+		    vb2_is_busy(&dev->vb2_mpegq))
+			return -EBUSY;
+	}
+
 	dev->tvnorm = norm;
 
 	call_all(dev, video, s_std, norm);
@@ -591,6 +597,11 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 
 	if (0 != err)
 		return err;
+
+	if (vb2_is_busy(&dev->vb2_vidq) || vb2_is_busy(&dev->vb2_vbiq) ||
+	    vb2_is_busy(&dev->vb2_mpegq))
+		return -EBUSY;
+
 	dev->fmt        = format_by_fourcc(f->fmt.pix.pixelformat);
 	dev->width      = f->fmt.pix.width;
 	dev->height     = f->fmt.pix.height;
@@ -654,9 +665,7 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id tvnorms)
 	struct cx23885_dev *dev = video_drvdata(file);
 	dprintk(1, "%s()\n", __func__);
 
-	cx23885_set_tvnorm(dev, tvnorms);
-
-	return 0;
+	return cx23885_set_tvnorm(dev, tvnorms);
 }
 
 int cx23885_enum_input(struct cx23885_dev *dev, struct v4l2_input *i)
-- 
2.1.0.rc1

