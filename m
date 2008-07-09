Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m692NQvN031016
	for <video4linux-list@redhat.com>; Tue, 8 Jul 2008 22:23:26 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.153])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m692NFNY030880
	for <video4linux-list@redhat.com>; Tue, 8 Jul 2008 22:23:16 -0400
Received: by fg-out-1718.google.com with SMTP id e21so1495103fga.7
	for <video4linux-list@redhat.com>; Tue, 08 Jul 2008 19:23:15 -0700 (PDT)
Message-ID: <30353c3d0807081923o6ba66d34oac44d5bb98fd0e3a@mail.gmail.com>
Date: Tue, 8 Jul 2008 22:23:15 -0400
From: "David Ellingsworth" <david@identd.dyndns.org>
To: "Mauro Carvalho Chehab" <mchehab@infradead.org>,
	"Laurent Pinchart" <laurent.pinchart@skynet.be>,
	video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Cc: 
Subject: [PATCH] videodev: fix kobj ref count
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

Mauro,

If Laurent approves, please apply the following patch to the devel
branch. I've been using it locally for the past five days or so
without issue.

This patch increments the kobject reference count during video_open
and decrements it during video_close. Doing so allows
video_unregister_device to be called during the disconnect callback of
usb and pci devices. It also ensures that the video_device struct is
not freed while it is still in use and that the kobject release
callback occurs at the appropriate time. With this patch, the
following sequence is now possible and no longer results in a crash.

video_open
  disconnect
    video_unregister_device
      video_ioctl2 (crash was here)
        video_close
          video_release

Regards,

David Ellingsworth

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
+ *	Active devicesSigned-off-by: David Ellingsworth <david@identd.dyndns.org>
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
