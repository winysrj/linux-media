Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2T5oeq3030907
	for <video4linux-list@redhat.com>; Sat, 29 Mar 2008 01:50:40 -0400
Received: from qb-out-0506.google.com (qb-out-0506.google.com [72.14.204.237])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2T5o1AY001072
	for <video4linux-list@redhat.com>; Sat, 29 Mar 2008 01:50:31 -0400
Received: by qb-out-0506.google.com with SMTP id o12so5266898qba.17
	for <video4linux-list@redhat.com>; Fri, 28 Mar 2008 22:50:31 -0700 (PDT)
Date: Fri, 28 Mar 2008 22:25:59 -0700
From: Brandon Philips <brandon@ifup.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Message-ID: <20080329052559.GA4470@plankton.ifup.org>
References: <patchbomb.1206699511@localhost> <20080328160946.029009d8@gaivota>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080328160946.029009d8@gaivota>
Cc: v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com
Subject: Re: [PATCH 0 of 9] videobuf fixes
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

> I've opened 3 mplayer windows, reading /dev/video0. I closed the second one and
> opened again. I got an error:

Shouldn't V4L2 devices not be able to stream to multiple applications at
once?  Quoting the spec:

"V4L2 drivers should not support multiple applications reading or
writing the same data stream on a device by copying buffers, time
multiplexing or similar means. This is better handled by a proxy
application in user space. When the driver supports stream sharing
anyway it must be implemented transparently. The V4L2 API does not
specify how conflicts are solved."

How about this patch?

Signed-off-by: Brandon Philips <bphilips@suse.de>

---
 linux/drivers/media/video/vivi.c |   23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

Index: v4l-dvb/linux/drivers/media/video/vivi.c
===================================================================
--- v4l-dvb.orig/linux/drivers/media/video/vivi.c
+++ v4l-dvb/linux/drivers/media/video/vivi.c
@@ -5,9 +5,10 @@
  *      Mauro Carvalho Chehab <mchehab--a.t--infradead.org>
  *      Ted Walther <ted--a.t--enumera.com>
  *      John Sokol <sokol--a.t--videotechnology.com>
- *      Brandon Philips <brandon@ifup.org>
  *      http://v4l.videotechnology.com/
  *
+ * Copyright (c) 2008 by Brandon Philips <bphilips@suse.de>
+ *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the BSD Licence, GNU General Public License
  * as published by the Free Software Foundation; either version 2 of the
@@ -175,6 +176,7 @@ struct vivi_dev {
 	struct list_head           vivi_devlist;
 
 	spinlock_t                 slock;
+	mutex			   mutex;
 
 	int                        users;
 
@@ -960,6 +962,7 @@ static int vivi_open(struct inode *inode
 	struct vivi_dev *dev;
 	struct vivi_fh *fh;
 	int i;
+	int retval;
 
 	printk(KERN_DEBUG "vivi: open called (minor=%d)\n", minor);
 
@@ -969,9 +972,15 @@ static int vivi_open(struct inode *inode
 	return -ENODEV;
 
 found:
-	/* If more than one user, mutex should be added */
+	mutex_lock(&dev->mutex);
 	dev->users++;
 
+	if (dev->users > 1) {
+		dev->users--;
+		retval = -EBUSY;
+		goto unlock;
+	}
+
 	dprintk(dev, 1, "open minor=%d type=%s users=%d\n", minor,
 		v4l2_type_names[V4L2_BUF_TYPE_VIDEO_CAPTURE], dev->users);
 
@@ -979,8 +988,13 @@ found:
 	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
 	if (NULL == fh) {
 		dev->users--;
-		return -ENOMEM;
+		retval = -ENOMEM;
+		goto unlock;
 	}
+unlock:
+	if (retval)
+		return retval;
+	mutex_unlock(&dev->mutex);
 
 	file->private_data = fh;
 	fh->dev      = dev;
@@ -1054,7 +1068,9 @@ static int vivi_close(struct inode *inod
 
 	kfree(fh);
 
+	mutex_lock(&dev->mutex);
 	dev->users--;
+	mutex_unlock(&dev->mutex);
 
 	dprintk(dev, 1, "close called (minor=%d, users=%d)\n",
 		minor, dev->users);
@@ -1166,6 +1182,7 @@ static int __init vivi_init(void)
 
 		/* initialize locks */
 		spin_lock_init(&dev->slock);
+		INIT_MUTEX(&dev->mutex);
 
 		vfd = video_device_alloc();
 		if (NULL == vfd)

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
