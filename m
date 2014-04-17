Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2000 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbaDQKje (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Apr 2014 06:39:34 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv2 PATCH 07/11] saa7134: rename empress_tsq to empress_vbq
Date: Thu, 17 Apr 2014 12:39:10 +0200
Message-Id: <1397731154-34337-8-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1397731154-34337-1-git-send-email-hverkuil@xs4all.nl>
References: <1397731154-34337-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Create consistent _vbq suffix for videobuf_queue fields.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/saa7134/saa7134-empress.c | 12 ++++++------
 drivers/media/pci/saa7134/saa7134-video.c   |  2 +-
 drivers/media/pci/saa7134/saa7134.h         |  2 +-
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-empress.c b/drivers/media/pci/saa7134/saa7134-empress.c
index 393c9f1..7d4d390 100644
--- a/drivers/media/pci/saa7134/saa7134-empress.c
+++ b/drivers/media/pci/saa7134/saa7134-empress.c
@@ -112,8 +112,8 @@ static int ts_release(struct file *file)
 	struct saa7134_fh *fh = file->private_data;
 
 	if (res_check(fh, RESOURCE_EMPRESS)) {
-		videobuf_stop(&dev->empress_tsq);
-		videobuf_mmap_free(&dev->empress_tsq);
+		videobuf_stop(&dev->empress_vbq);
+		videobuf_mmap_free(&dev->empress_vbq);
 
 		/* stop the encoder */
 		ts_reset_encoder(dev);
@@ -138,7 +138,7 @@ ts_read(struct file *file, char __user *data, size_t count, loff_t *ppos)
 	if (!dev->empress_started)
 		ts_init_encoder(dev);
 
-	return videobuf_read_stream(&dev->empress_tsq,
+	return videobuf_read_stream(&dev->empress_vbq,
 				    data, count, ppos, 0,
 				    file->f_flags & O_NONBLOCK);
 }
@@ -155,7 +155,7 @@ ts_poll(struct file *file, struct poll_table_struct *wait)
 		rc = POLLPRI;
 	else if (req_events & POLLPRI)
 		poll_wait(file, &fh->fh.wait, wait);
-	return rc | videobuf_poll_stream(file, &dev->empress_tsq, wait);
+	return rc | videobuf_poll_stream(file, &dev->empress_vbq, wait);
 }
 
 
@@ -164,7 +164,7 @@ ts_mmap(struct file *file, struct vm_area_struct * vma)
 {
 	struct saa7134_dev *dev = video_drvdata(file);
 
-	return videobuf_mmap_mapper(&dev->empress_tsq, vma);
+	return videobuf_mmap_mapper(&dev->empress_vbq, vma);
 }
 
 static int empress_enum_fmt_vid_cap(struct file *file, void  *priv,
@@ -354,7 +354,7 @@ static int empress_init(struct saa7134_dev *dev)
 	printk(KERN_INFO "%s: registered device %s [mpeg]\n",
 	       dev->name, video_device_node_name(dev->empress_dev));
 
-	videobuf_queue_sg_init(&dev->empress_tsq, &saa7134_ts_qops,
+	videobuf_queue_sg_init(&dev->empress_vbq, &saa7134_ts_qops,
 			    &dev->pci->dev, &dev->slock,
 			    V4L2_BUF_TYPE_VIDEO_CAPTURE,
 			    V4L2_FIELD_ALTERNATE,
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index f331501..e5b2beb 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -1086,7 +1086,7 @@ static struct videobuf_queue *saa7134_queue(struct file *file)
 
 	switch (vdev->vfl_type) {
 	case VFL_TYPE_GRABBER:
-		q = fh->is_empress ? &dev->empress_tsq : &dev->cap;
+		q = fh->is_empress ? &dev->empress_vbq : &dev->cap;
 		break;
 	case VFL_TYPE_VBI:
 		q = &dev->vbi;
diff --git a/drivers/media/pci/saa7134/saa7134.h b/drivers/media/pci/saa7134/saa7134.h
index d2ee545..482489a 100644
--- a/drivers/media/pci/saa7134/saa7134.h
+++ b/drivers/media/pci/saa7134/saa7134.h
@@ -647,7 +647,7 @@ struct saa7134_dev {
 	/* SAA7134_MPEG_EMPRESS only */
 	struct video_device        *empress_dev;
 	struct v4l2_subdev	   *empress_sd;
-	struct videobuf_queue      empress_tsq;
+	struct videobuf_queue      empress_vbq;
 	struct work_struct         empress_workqueue;
 	int                        empress_started;
 	struct v4l2_ctrl_handler   empress_ctrl_handler;
-- 
1.9.2

