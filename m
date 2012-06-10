Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:1689 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694Ab2FJKzM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jun 2012 06:55:12 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Steven Toth <stoth@kernellabs.com>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 07/11] cx88: add priority support.
Date: Sun, 10 Jun 2012 12:54:53 +0200
Message-Id: <3a80130adb44279efa5631d4339e14dc376b59d0.1339325224.git.hans.verkuil@cisco.com>
In-Reply-To: <1339325697-23280-1-git-send-email-hverkuil@xs4all.nl>
References: <1339325697-23280-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <541a39bdcc8a94d3de87a6a6d0b1b7c476983984.1339325224.git.hans.verkuil@cisco.com>
References: <541a39bdcc8a94d3de87a6a6d0b1b7c476983984.1339325224.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/cx88/cx88-blackbird.c |    4 ++++
 drivers/media/video/cx88/cx88-core.c      |    1 +
 drivers/media/video/cx88/cx88-video.c     |    4 ++++
 drivers/media/video/cx88/cx88.h           |    3 +++
 4 files changed, 12 insertions(+)

diff --git a/drivers/media/video/cx88/cx88-blackbird.c b/drivers/media/video/cx88/cx88-blackbird.c
index 18ed14b..ac8473e 100644
--- a/drivers/media/video/cx88/cx88-blackbird.c
+++ b/drivers/media/video/cx88/cx88-blackbird.c
@@ -974,6 +974,7 @@ static int mpeg_open(struct file *file)
 		mutex_unlock(&dev->core->lock);
 		return -ENOMEM;
 	}
+	v4l2_fh_init(&fh->fh, vdev);
 	file->private_data = fh;
 	fh->dev      = dev;
 
@@ -990,6 +991,7 @@ static int mpeg_open(struct file *file)
 
 	dev->core->mpeg_users++;
 	mutex_unlock(&dev->core->lock);
+	v4l2_fh_add(&fh->fh);
 	return 0;
 }
 
@@ -1010,6 +1012,8 @@ static int mpeg_release(struct file *file)
 
 	videobuf_mmap_free(&fh->mpegq);
 
+	v4l2_fh_del(&fh->fh);
+	v4l2_fh_exit(&fh->fh);
 	file->private_data = NULL;
 	kfree(fh);
 
diff --git a/drivers/media/video/cx88/cx88-core.c b/drivers/media/video/cx88/cx88-core.c
index 8bd925d..e81c735f 100644
--- a/drivers/media/video/cx88/cx88-core.c
+++ b/drivers/media/video/cx88/cx88-core.c
@@ -1036,6 +1036,7 @@ struct video_device *cx88_vdev_init(struct cx88_core *core,
 	vfd->release = video_device_release;
 	snprintf(vfd->name, sizeof(vfd->name), "%s %s (%s)",
 		 core->name, type, core->board.name);
+	set_bit(V4L2_FL_USE_FH_PRIO, &vfd->flags);
 	return vfd;
 }
 
diff --git a/drivers/media/video/cx88/cx88-video.c b/drivers/media/video/cx88/cx88-video.c
index bd1f52f..673f88b 100644
--- a/drivers/media/video/cx88/cx88-video.c
+++ b/drivers/media/video/cx88/cx88-video.c
@@ -744,6 +744,7 @@ static int video_open(struct file *file)
 	if (unlikely(!fh))
 		return -ENOMEM;
 
+	v4l2_fh_init(&fh->fh, vdev);
 	file->private_data = fh;
 	fh->dev      = dev;
 
@@ -788,6 +789,7 @@ static int video_open(struct file *file)
 
 	core->users++;
 	mutex_unlock(&core->lock);
+	v4l2_fh_add(&fh->fh);
 
 	return 0;
 }
@@ -883,6 +885,8 @@ static int video_release(struct file *file)
 	videobuf_mmap_free(&fh->vbiq);
 
 	mutex_lock(&dev->core->lock);
+	v4l2_fh_del(&fh->fh);
+	v4l2_fh_exit(&fh->fh);
 	file->private_data = NULL;
 	kfree(fh);
 
diff --git a/drivers/media/video/cx88/cx88.h b/drivers/media/video/cx88/cx88.h
index 94af48e..0cae0fd 100644
--- a/drivers/media/video/cx88/cx88.h
+++ b/drivers/media/video/cx88/cx88.h
@@ -26,6 +26,7 @@
 #include <linux/kdev_t.h>
 
 #include <media/v4l2-device.h>
+#include <media/v4l2-fh.h>
 #include <media/tuner.h>
 #include <media/tveeprom.h>
 #include <media/videobuf-dma-sg.h>
@@ -454,6 +455,7 @@ struct cx8802_dev;
 /* function 0: video stuff                                     */
 
 struct cx8800_fh {
+	struct v4l2_fh		   fh;
 	struct cx8800_dev          *dev;
 	unsigned int               resources;
 
@@ -504,6 +506,7 @@ struct cx8800_dev {
 /* function 2: mpeg stuff                                      */
 
 struct cx8802_fh {
+	struct v4l2_fh		   fh;
 	struct cx8802_dev          *dev;
 	struct videobuf_queue      mpegq;
 };
-- 
1.7.10

