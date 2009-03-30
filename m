Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:50952 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261AbZC3QO7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Mar 2009 12:14:59 -0400
Date: Mon, 30 Mar 2009 13:14:49 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: "Dean A." <dean@sensoray.com>
Subject: Fw: patch: s2255drv driver removal problem fixed
Message-ID: <20090330131449.319f1fbe@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

C/C to the right mailing list, to allow Patchwork to catch this.

Forwarded message:

Date: Mon, 30 Mar 2009 07:59:56 -0700 (PDT)
From: "Dean A." <dean@sensoray.com>
To: video4linux-list@redhat.com, mchehab@infradead.org
Cc: eteo@redhat.com, error27@gmail.com, marcin.slusarz@gmail.com
Subject: patch: s2255drv driver removal problem fixed


From: Dean Anderson <dean@sensoray.com>

This patch fixes kfree problem on driver removal, fixes streamoff problem
and removes unnecessary videobuf_waiton from free_buffer function.

Signed-off-by: Dean Anderson <dean@sensoray.com>

--- linux/drivers/media/video/s2255drv.c.orig	2009-03-30 07:30:25.000000000 -0700
+++ linux/drivers/media/video/s2255drv.c	2009-03-30 07:44:32.000000000 -0700
@@ -723,7 +723,6 @@
 {
 	dprintk(4, "%s\n", __func__);
 
-	videobuf_waiton(&buf->vb, 0, 0);
 	videobuf_vmalloc_free(&buf->vb);
 	buf->vb.state = VIDEOBUF_NEEDS_INIT;
 }
@@ -1325,7 +1324,6 @@
 
 static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
 {
-	int res;
 	struct s2255_fh *fh = priv;
 	struct s2255_dev *dev = fh->dev;
 
@@ -1339,9 +1337,7 @@
 		return -EINVAL;
 	}
 	s2255_stop_acquire(dev, fh->channel);
-	res = videobuf_streamoff(&fh->vb_vidq);
-	if (res < 0)
-		return res;
+	videobuf_streamoff(&fh->vb_vidq);
 	res_free(dev, fh);
 	return 0;
 }
@@ -1708,13 +1704,13 @@
 	kfree(dev->fw_data);
 	usb_put_dev(dev->udev);
 	dprintk(1, "%s", __func__);
-	kfree(dev);
 
 	while (!list_empty(&s2255_devlist)) {
 		list = s2255_devlist.next;
 		list_del(list);
 	}
 	mutex_unlock(&dev->open_lock);
+	kfree(dev);
 }
 
 static int s2255_close(struct file *file)






Cheers,
Mauro
