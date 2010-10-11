Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:47196 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755074Ab0JKPkU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Oct 2010 11:40:20 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o9BFeJMh001759
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 11 Oct 2010 11:40:20 -0400
Received: from pedra (vpn-225-124.phx2.redhat.com [10.3.225.124])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o9BFdDOW032640
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 11 Oct 2010 11:40:18 -0400
Date: Mon, 11 Oct 2010 12:37:16 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/4] tm6000: don't use BKL at the driver
Message-ID: <20101011123716.6d15219b@pedra>
In-Reply-To: <cover.1286807828.git.mchehab@redhat.com>
References: <cover.1286807828.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Instead, use core lock handling.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
index 9d091c3..4106ae0 100644
--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -909,8 +909,6 @@ static void tm6000_usb_disconnect(struct usb_interface *interface)
 
 	printk(KERN_INFO "tm6000: disconnecting %s\n", dev->name);
 
-	mutex_lock(&dev->lock);
-
 	tm6000_ir_fini(dev);
 
 	if (dev->gpio.power_led) {
@@ -945,7 +943,6 @@ static void tm6000_usb_disconnect(struct usb_interface *interface)
 	tm6000_close_extension(dev);
 	tm6000_remove_from_devlist(dev);
 
-	mutex_unlock(&dev->lock);
 	kfree(dev);
 }
 
diff --git a/drivers/staging/tm6000/tm6000-core.c b/drivers/staging/tm6000/tm6000-core.c
index 57cb69e..f5f8632 100644
--- a/drivers/staging/tm6000/tm6000-core.c
+++ b/drivers/staging/tm6000/tm6000-core.c
@@ -326,10 +326,8 @@ int tm6000_init_analog_mode(struct tm6000_core *dev)
 
 	/*FIXME: Hack!!! */
 	struct v4l2_frequency f;
-	mutex_lock(&dev->lock);
 	f.frequency = dev->freq;
 	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_frequency, &f);
-	mutex_unlock(&dev->lock);
 
 	msleep(100);
 	tm6000_set_standard(dev, &dev->norm);
diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
index a45b012..23c85fd 100644
--- a/drivers/staging/tm6000/tm6000-video.c
+++ b/drivers/staging/tm6000/tm6000-video.c
@@ -791,16 +791,11 @@ static struct videobuf_queue_ops tm6000_video_qops = {
 static int res_get(struct tm6000_core *dev, struct tm6000_fh *fh)
 {
 	/* is it free? */
-	mutex_lock(&dev->lock);
-	if (dev->resources) {
-		/* no, someone else uses it */
-		mutex_unlock(&dev->lock);
+	if (dev->resources)
 		return 0;
-	}
 	/* it's free, grab it */
 	dev->resources =1;
 	dprintk(dev, V4L2_DEBUG_RES_LOCK, "res: get\n");
-	mutex_unlock(&dev->lock);
 	return 1;
 }
 
@@ -811,10 +806,8 @@ static int res_locked(struct tm6000_core *dev)
 
 static void res_free(struct tm6000_core *dev, struct tm6000_fh *fh)
 {
-	mutex_lock(&dev->lock);
 	dev->resources = 0;
 	dprintk(dev, V4L2_DEBUG_RES_LOCK, "res: put\n");
-	mutex_unlock(&dev->lock);
 }
 
 /* ------------------------------------------------------------------
@@ -1229,10 +1222,8 @@ static int vidioc_s_frequency (struct file *file, void *priv,
 	if (unlikely(f->tuner != 0))
 		return -EINVAL;
 
-//	mutex_lock(&dev->lock);
 	dev->freq = f->frequency;
 	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_frequency, f);
-//	mutex_unlock(&dev->lock);
 
 	return 0;
 }
@@ -1308,7 +1299,7 @@ static int tm6000_open(struct file *file)
 			NULL, &dev->slock,
 			fh->type,
 			V4L2_FIELD_INTERLACED,
-			sizeof(struct tm6000_buffer), fh, NULL);
+			sizeof(struct tm6000_buffer), fh, &dev->lock);
 
 	return 0;
 }
@@ -1389,7 +1380,7 @@ static struct v4l2_file_operations tm6000_fops = {
 	.owner		= THIS_MODULE,
 	.open           = tm6000_open,
 	.release        = tm6000_release,
-	.ioctl          = video_ioctl2, /* V4L2 ioctl handler */
+	.unlocked_ioctl	= video_ioctl2, /* V4L2 ioctl handler */
 	.read           = tm6000_read,
 	.poll		= tm6000_poll,
 	.mmap		= tm6000_mmap,
@@ -1451,8 +1442,10 @@ int tm6000_v4l2_register(struct tm6000_core *dev)
 	INIT_LIST_HEAD(&dev->vidq.active);
 	INIT_LIST_HEAD(&dev->vidq.queued);
 
-	memcpy (dev->vfd, &tm6000_template, sizeof(*(dev->vfd)));
-	dev->vfd->debug=tm6000_debug;
+	memcpy(dev->vfd, &tm6000_template, sizeof(*(dev->vfd)));
+	dev->vfd->debug = tm6000_debug;
+	dev->vfd->lock = &dev->lock;
+
 	vfd->v4l2_dev = &dev->v4l2_dev;
 	video_set_drvdata(vfd, dev);
 
-- 
1.7.1


