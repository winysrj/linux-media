Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:59087 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620Ab0IPBCM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Sep 2010 21:02:12 -0400
Date: Wed, 15 Sep 2010 21:56:40 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 6/8] V4L/DVB: cx88: Remove BKL
Message-ID: <20100915215640.4767fc72@pedra>
In-Reply-To: <cover.1284597566.git.mchehab@redhat.com>
References: <cover.1284597566.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/cx88/cx88-blackbird.c b/drivers/media/video/cx88/cx88-blackbird.c
index e46e1ce..ec32995 100644
--- a/drivers/media/video/cx88/cx88-blackbird.c
+++ b/drivers/media/video/cx88/cx88-blackbird.c
@@ -1057,7 +1057,7 @@ static int mpeg_open(struct file *file)
 
 	dprintk( 1, "%s\n", __func__);
 
-	lock_kernel();
+	mutex_lock(&dev->core->lock);
 
 	/* Make sure we can acquire the hardware */
 	drv = cx8802_get_driver(dev, CX88_MPEG_BLACKBIRD);
@@ -1065,7 +1065,7 @@ static int mpeg_open(struct file *file)
 		err = drv->request_acquire(drv);
 		if(err != 0) {
 			dprintk(1,"%s: Unable to acquire hardware, %d\n", __func__, err);
-			unlock_kernel();
+			mutex_unlock(&dev->core->lock);;
 			return err;
 		}
 	}
@@ -1073,7 +1073,7 @@ static int mpeg_open(struct file *file)
 	if (!atomic_read(&dev->core->mpeg_users) && blackbird_initialize_codec(dev) < 0) {
 		if (drv)
 			drv->request_release(drv);
-		unlock_kernel();
+		mutex_unlock(&dev->core->lock);
 		return -EINVAL;
 	}
 	dprintk(1, "open dev=%s\n", video_device_node_name(vdev));
@@ -1083,7 +1083,7 @@ static int mpeg_open(struct file *file)
 	if (NULL == fh) {
 		if (drv)
 			drv->request_release(drv);
-		unlock_kernel();
+		mutex_unlock(&dev->core->lock);
 		return -ENOMEM;
 	}
 	file->private_data = fh;
@@ -1099,10 +1099,9 @@ static int mpeg_open(struct file *file)
 	/* FIXME: locking against other video device */
 	cx88_set_scale(dev->core, dev->width, dev->height,
 			fh->mpegq.field);
-	unlock_kernel();
 
 	atomic_inc(&dev->core->mpeg_users);
-
+	mutex_unlock(&dev->core->lock);
 	return 0;
 }
 
@@ -1120,8 +1119,11 @@ static int mpeg_release(struct file *file)
 	videobuf_stop(&fh->mpegq);
 
 	videobuf_mmap_free(&fh->mpegq);
+
+	mutex_lock(&dev->core->lock);
 	file->private_data = NULL;
 	kfree(fh);
+	mutex_unlock(&dev->core->lock);
 
 	/* Make sure we release the hardware */
 	drv = cx8802_get_driver(dev, CX88_MPEG_BLACKBIRD);
diff --git a/drivers/media/video/cx88/cx88-video.c b/drivers/media/video/cx88/cx88-video.c
index 0fab65c..381398d 100644
--- a/drivers/media/video/cx88/cx88-video.c
+++ b/drivers/media/video/cx88/cx88-video.c
@@ -769,19 +769,14 @@ static int video_open(struct file *file)
 		break;
 	}
 
-	lock_kernel();
-
-	core = dev->core;
-
 	dprintk(1, "open dev=%s radio=%d type=%s\n",
 		video_device_node_name(vdev), radio, v4l2_type_names[type]);
 
 	/* allocate + initialize per filehandle data */
 	fh = kzalloc(sizeof(*fh),GFP_KERNEL);
-	if (NULL == fh) {
-		unlock_kernel();
+	if (unlikely(!fh))
 		return -ENOMEM;
-	}
+
 	file->private_data = fh;
 	fh->dev      = dev;
 	fh->radio    = radio;
@@ -790,6 +785,9 @@ static int video_open(struct file *file)
 	fh->height   = 240;
 	fh->fmt      = format_by_fourcc(V4L2_PIX_FMT_BGR24);
 
+	mutex_lock(&core->lock);
+	core = dev->core;
+
 	videobuf_queue_sg_init(&fh->vidq, &cx8800_video_qops,
 			    &dev->pci->dev, &dev->slock,
 			    V4L2_BUF_TYPE_VIDEO_CAPTURE,
@@ -826,9 +824,9 @@ static int video_open(struct file *file)
 		}
 		call_all(core, tuner, s_radio);
 	}
-	unlock_kernel();
 
 	atomic_inc(&core->users);
+	mutex_unlock(&core->lock);
 
 	return 0;
 }
@@ -920,10 +918,11 @@ static int video_release(struct file *file)
 
 	videobuf_mmap_free(&fh->vidq);
 	videobuf_mmap_free(&fh->vbiq);
+
+	mutex_lock(&dev->core->lock);
 	file->private_data = NULL;
 	kfree(fh);
 
-	mutex_lock(&dev->core->lock);
 	if(atomic_dec_and_test(&dev->core->users))
 		call_all(dev->core, core, s_power, 0);
 	mutex_unlock(&dev->core->lock);
-- 
1.7.1


