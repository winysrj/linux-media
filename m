Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m62FeVku006449
	for <video4linux-list@redhat.com>; Wed, 2 Jul 2008 11:40:31 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.155])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m62FdxB1027352
	for <video4linux-list@redhat.com>; Wed, 2 Jul 2008 11:40:00 -0400
Received: by fg-out-1718.google.com with SMTP id e21so209097fga.7
	for <video4linux-list@redhat.com>; Wed, 02 Jul 2008 08:39:59 -0700 (PDT)
Message-ID: <30353c3d0807020839r6e18978dqc0b38f6c8d9c177@mail.gmail.com>
Date: Wed, 2 Jul 2008 11:39:58 -0400
From: "David Ellingsworth" <david@identd.dyndns.org>
To: "Laurent Pinchart" <laurent.pinchart@skynet.be>
In-Reply-To: <30353c3d0807012115i6f53cf2l3bf615e526a3a3c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <30353c3d0807011346yccc6ad1yab269d0b47068f15@mail.gmail.com>
	<200807012350.53604.laurent.pinchart@skynet.be>
	<30353c3d0807011528v561d4de8ycb7c3f1d8afc82f9@mail.gmail.com>
	<200807020104.52122.laurent.pinchart@skynet.be>
	<30353c3d0807011649n5b225ef7t11bbf36217427647@mail.gmail.com>
	<30353c3d0807012026n60815935g82a6746e5ca67b1a@mail.gmail.com>
	<30353c3d0807012115i6f53cf2l3bf615e526a3a3c@mail.gmail.com>
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] videodev: fix sysfs kobj ref count
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

Fix fail open condition. When the open fails, kobject_put needs to be
called to ensure the kobject ref count is restored. Did I miss
anything else?

Regards,

David Ellingsworth

[PATCH] videodev: fix kobj ref count


Signed-off-by: David Ellingsworth <david@identd.dyndns.org>
---
 drivers/media/video/videodev.c |   50 +++++++++++++++++++++++++++------------
 include/media/v4l2-dev.h       |    1 +
 2 files changed, 35 insertions(+), 16 deletions(-)

diff --git a/drivers/media/video/videodev.c b/drivers/media/video/videodev.c
index 0d52819..9922cd6 100644
--- a/drivers/media/video/videodev.c
+++ b/drivers/media/video/videodev.c
@@ -406,17 +406,22 @@ void video_device_release(struct video_device *vfd)
 }
 EXPORT_SYMBOL(video_device_release);

+/*
+ *	Active devices
+ */
+
+static struct video_device *video_device[VIDEO_NUM_DEVICES];
+static DEFINE_MUTEX(videodev_lock);
+
+/* must be called with videodev_lock held */
 static void video_release(struct device *cd)
 {
 	struct video_device *vfd = container_of(cd, struct video_device,
 								class_dev);

-#if 1
-	/* needed until all drivers are fixed */
-	if (!vfd->release)
-		return;
-#endif
-	vfd->release(vfd);
+	if (vfd->release)
+		vfd->release(vfd);
+	video_device[vfd->minor] = NULL;
 }

 static struct device_attribute video_device_attrs[] = {
@@ -431,19 +436,30 @@ static struct class video_class = {
 	.dev_release = video_release,
 };

-/*
- *	Active devices
- */
-
-static struct video_device *video_device[VIDEO_NUM_DEVICES];
-static DEFINE_MUTEX(videodev_lock);
-
 struct video_device* video_devdata(struct file *file)
 {
 	return video_device[iminor(file->f_path.dentry->d_inode)];
 }
 EXPORT_SYMBOL(video_devdata);

+static int video_close(struct inode *inode, struct file *file)
+{
+	unsigned int minor = iminor(inode);
+	int err = 0;
+	struct video_device *vfl;
+
+	vfl = video_device[minor];
+
+	if (vfl->fops && vfl->fops->release)
+		err = vfl->fops->release(inode, file);
+
+	mutex_lock(&videodev_lock);
+	kobject_put(&vfl->class_dev.kobj);
+	mutex_unlock(&videodev_lock);
+
+	return err;
+}
+
 /*
  *	Open a video device - FIXME: Obsoleted
  */
@@ -469,10 +485,11 @@ static int video_open(struct inode *inode,
struct file *file)
 		}
 	}
 	old_fops = file->f_op;
-	file->f_op = fops_get(vfl->fops);
-	if(file->f_op->open)
+	file->f_op = fops_get(&vfl->priv_fops);
+	if (file->f_op->open && kobject_get(&vfl->class_dev.kobj))
 		err = file->f_op->open(inode,file);
 	if (err) {
+		kobject_put(&vfl->class_dev.kobj);
 		fops_put(file->f_op);
 		file->f_op = fops_get(old_fops);
 	}
@@ -2175,6 +2192,8 @@ int video_register_device_index(struct
video_device *vfd, int type, int nr,
 	}

 	vfd->index = ret;
+	vfd->priv_fops = *vfd->fops;
+	vfd->priv_fops.release = video_close;

 	mutex_unlock(&videodev_lock);
 	mutex_init(&vfd->lock);
@@ -2225,7 +2244,6 @@ void video_unregister_device(struct video_device *vfd)
 	if(video_device[vfd->minor]!=vfd)
 		panic("videodev: bad unregister");

-	video_device[vfd->minor]=NULL;
 	device_unregister(&vfd->class_dev);
 	mutex_unlock(&videodev_lock);
 }
diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
index 3c93414..d4fe617 100644
--- a/include/media/v4l2-dev.h
+++ b/include/media/v4l2-dev.h
@@ -342,6 +342,7 @@ void *priv;
 	/* for videodev.c intenal usage -- please don't touch */
 	int users;                     /* video_exclusive_{open|close} ... */
 	struct mutex lock;             /* ... helper function uses these   */
+	struct file_operations priv_fops; /* video_close */
 };

 /* Class-dev to video-device */
-- 
1.5.5.1

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
