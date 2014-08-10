Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3253 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbaHJL6T (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Aug 2014 07:58:19 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: stoth@kernellabs.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 03/19] cx23885: support v4l2_fh and g/s_priority
Date: Sun, 10 Aug 2014 13:57:40 +0200
Message-Id: <1407671876-39386-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1407671876-39386-1-git-send-email-hverkuil@xs4all.nl>
References: <1407671876-39386-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add support for struct v4l2_fh and priority handling.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx23885/cx23885-417.c   | 5 +++++
 drivers/media/pci/cx23885/cx23885-video.c | 6 +++++-
 drivers/media/pci/cx23885/cx23885.h       | 2 ++
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/cx23885/cx23885-417.c b/drivers/media/pci/cx23885/cx23885-417.c
index bf89fc8..b65de33 100644
--- a/drivers/media/pci/cx23885/cx23885-417.c
+++ b/drivers/media/pci/cx23885/cx23885-417.c
@@ -1550,6 +1550,7 @@ static int vidioc_queryctrl(struct file *file, void *priv,
 
 static int mpeg_open(struct file *file)
 {
+	struct video_device *vdev = video_devdata(file);
 	struct cx23885_dev *dev = video_drvdata(file);
 	struct cx23885_fh *fh;
 
@@ -1560,6 +1561,7 @@ static int mpeg_open(struct file *file)
 	if (!fh)
 		return -ENOMEM;
 
+	v4l2_fh_init(&fh->fh, vdev);
 	file->private_data = fh;
 	fh->dev      = dev;
 
@@ -1569,6 +1571,7 @@ static int mpeg_open(struct file *file)
 			    V4L2_FIELD_INTERLACED,
 			    sizeof(struct cx23885_buffer),
 			    fh, NULL);
+	v4l2_fh_add(&fh->fh);
 	return 0;
 }
 
@@ -1601,6 +1604,8 @@ static int mpeg_release(struct file *file)
 		videobuf_read_stop(&fh->mpegq);
 
 	videobuf_mmap_free(&fh->mpegq);
+	v4l2_fh_del(&fh->fh);
+	v4l2_fh_exit(&fh->fh);
 	file->private_data = NULL;
 	kfree(fh);
 
diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index 79de4ac..d575bfc 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -883,7 +883,8 @@ static int video_open(struct file *file)
 	if (NULL == fh)
 		return -ENOMEM;
 
-	file->private_data = fh;
+	v4l2_fh_init(&fh->fh, vdev);
+	file->private_data = &fh->fh;
 	fh->dev      = dev;
 	fh->radio    = radio;
 	fh->type     = type;
@@ -905,6 +906,7 @@ static int video_open(struct file *file)
 		sizeof(struct cx23885_buffer),
 		fh, NULL);
 
+	v4l2_fh_add(&fh->fh);
 
 	dprintk(1, "post videobuf_queue_init()\n");
 
@@ -1003,6 +1005,8 @@ static int video_release(struct file *file)
 	videobuf_mmap_free(&fh->vidq);
 	videobuf_mmap_free(&fh->vbiq);
 
+	v4l2_fh_del(&fh->fh);
+	v4l2_fh_exit(&fh->fh);
 	file->private_data = NULL;
 	kfree(fh);
 
diff --git a/drivers/media/pci/cx23885/cx23885.h b/drivers/media/pci/cx23885/cx23885.h
index 0e086c0..de164c9 100644
--- a/drivers/media/pci/cx23885/cx23885.h
+++ b/drivers/media/pci/cx23885/cx23885.h
@@ -25,6 +25,7 @@
 #include <linux/slab.h>
 
 #include <media/v4l2-device.h>
+#include <media/v4l2-fh.h>
 #include <media/tuner.h>
 #include <media/tveeprom.h>
 #include <media/videobuf-dma-sg.h>
@@ -147,6 +148,7 @@ struct cx23885_tvnorm {
 };
 
 struct cx23885_fh {
+	struct v4l2_fh		   fh;
 	struct cx23885_dev         *dev;
 	enum v4l2_buf_type         type;
 	int                        radio;
-- 
2.0.1

