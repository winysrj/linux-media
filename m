Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n2UF6xiA030406
	for <video4linux-list@redhat.com>; Mon, 30 Mar 2009 11:06:59 -0400
Received: from mail11a.verio-web.com (mail11a.verio-web.com [204.202.242.23])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id n2UF6f40018896
	for <video4linux-list@redhat.com>; Mon, 30 Mar 2009 11:06:41 -0400
Received: from mx22.stngva01.us.mxservers.net (204.202.242.39)
	by mail11a.verio-web.com (RS ver 1.0.95vs) with SMTP id 0-0440415600
	for <video4linux-list@redhat.com>; Mon, 30 Mar 2009 11:06:41 -0400 (EDT)
Date: Mon, 30 Mar 2009 07:59:56 -0700 (PDT)
From: "Dean A." <dean@sensoray.com>
To: video4linux-list@redhat.com, mchehab@infradead.org
Message-ID: <tkrat.eb14d9287e8c3389@sensoray.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Cc: eteo@redhat.com, error27@gmail.com, marcin.slusarz@gmail.com
Subject: patch: s2255drv driver removal problem fixed
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


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
