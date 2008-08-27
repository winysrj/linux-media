Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7RM3uhd002735
	for <video4linux-list@redhat.com>; Wed, 27 Aug 2008 18:03:57 -0400
Received: from smtp4.pp.htv.fi (smtp4.pp.htv.fi [213.243.153.38])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7RM3kmr002788
	for <video4linux-list@redhat.com>; Wed, 27 Aug 2008 18:03:46 -0400
Date: Thu, 28 Aug 2008 01:02:53 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Jean-Francois Moine <moinejf@free.fr>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	v4l-dvb-maintainer@linuxtv.org
Message-ID: <20080827220253.GM11734@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Cc: video4linux-list@redhat.com
Subject: [2.6 patch] gspca.c:dev_open(): fix use of uninitialized variable
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

If we got through dev_open() without any error condition setting "ret" 
to a non-zero value, and with "gspca_dev->users != 0" then "ret" should 
be set to 0, not some random value.

Reported-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/media/video/gspca/gspca.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

004e7a80e3635b7198475d95189697bb0f3e8d2c 
diff --git a/drivers/media/video/gspca/gspca.c b/drivers/media/video/gspca/gspca.c
index 15d302b..e737307 100644
--- a/drivers/media/video/gspca/gspca.c
+++ b/drivers/media/video/gspca/gspca.c
@@ -716,87 +716,87 @@ static int vidioc_try_fmt_vid_cap(struct file *file,
 
 static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 			    struct v4l2_format *fmt)
 {
 	struct gspca_dev *gspca_dev = priv;
 	int ret;
 
 	if (mutex_lock_interruptible(&gspca_dev->queue_lock))
 		return -ERESTARTSYS;
 
 	ret = try_fmt_vid_cap(gspca_dev, fmt);
 	if (ret < 0)
 		goto out;
 
 	if (gspca_dev->nframes != 0
 	    && fmt->fmt.pix.sizeimage > gspca_dev->frsz) {
 		ret = -EINVAL;
 		goto out;
 	}
 
 	if (ret == gspca_dev->curr_mode) {
 		ret = 0;
 		goto out;			/* same mode */
 	}
 
 	if (gspca_dev->streaming) {
 		ret = -EBUSY;
 		goto out;
 	}
 	gspca_dev->width = fmt->fmt.pix.width;
 	gspca_dev->height = fmt->fmt.pix.height;
 	gspca_dev->pixfmt = fmt->fmt.pix.pixelformat;
 	gspca_dev->curr_mode = ret;
 
 	ret = 0;
 out:
 	mutex_unlock(&gspca_dev->queue_lock);
 	return ret;
 }
 
 static int dev_open(struct inode *inode, struct file *file)
 {
 	struct gspca_dev *gspca_dev;
-	int ret;
+	int ret = 0;
 
 	PDEBUG(D_STREAM, "%s open", current->comm);
 	gspca_dev = (struct gspca_dev *) video_devdata(file);
 	if (mutex_lock_interruptible(&gspca_dev->queue_lock))
 		return -ERESTARTSYS;
 	if (!gspca_dev->present) {
 		ret = -ENODEV;
 		goto out;
 	}
 
 	/* if not done yet, initialize the sensor */
 	if (gspca_dev->users == 0) {
 		if (mutex_lock_interruptible(&gspca_dev->usb_lock)) {
 			ret = -ERESTARTSYS;
 			goto out;
 		}
 		ret = gspca_dev->sd_desc->open(gspca_dev);
 		mutex_unlock(&gspca_dev->usb_lock);
 		if (ret != 0) {
 			PDEBUG(D_ERR|D_CONF, "init device failed %d", ret);
 			goto out;
 		}
 	} else if (gspca_dev->users > 4) {	/* (arbitrary value) */
 		ret = -EBUSY;
 		goto out;
 	}
 	gspca_dev->users++;
 	file->private_data = gspca_dev;
 #ifdef GSPCA_DEBUG
 	/* activate the v4l2 debug */
 	if (gspca_debug & D_V4L2)
 		gspca_dev->vdev.debug |= 3;
 	else
 		gspca_dev->vdev.debug &= ~3;
 #endif
 out:
 	mutex_unlock(&gspca_dev->queue_lock);
 	if (ret != 0)
 		PDEBUG(D_ERR|D_STREAM, "open failed err %d", ret);
 	else
 		PDEBUG(D_STREAM, "open done");
 	return ret;
 }

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
