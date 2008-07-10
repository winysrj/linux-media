Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6A2Xdse015631
	for <video4linux-list@redhat.com>; Wed, 9 Jul 2008 22:33:39 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.159])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6A2XSUl013032
	for <video4linux-list@redhat.com>; Wed, 9 Jul 2008 22:33:29 -0400
Received: by fg-out-1718.google.com with SMTP id e21so1760445fga.7
	for <video4linux-list@redhat.com>; Wed, 09 Jul 2008 19:33:28 -0700 (PDT)
Message-ID: <30353c3d0807091933x1617f2f3h430ff0623e7953f@mail.gmail.com>
Date: Wed, 9 Jul 2008 22:33:28 -0400
From: "David Ellingsworth" <david@identd.dyndns.org>
To: "Laurent Pinchart" <laurent.pinchart@skynet.be>
In-Reply-To: <30353c3d0807091603v3c276a15ld15aebd6571d6244@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <30353c3d0807081923o6ba66d34oac44d5bb98fd0e3a@mail.gmail.com>
	<200807092342.51633.laurent.pinchart@skynet.be>
	<30353c3d0807091603v3c276a15ld15aebd6571d6244@mail.gmail.com>
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] videodev: fix kobj ref count
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

[snip]
>>>  /*
>>>   *   Open a video device - FIXME: Obsoleted
>>>   */
>>> @@ -469,10 +485,11 @@ static int video_open(struct inode *inode,
>>> struct file *file)
>>>               }
>>>       }
>>>       old_fops = file->f_op;
>>> -     file->f_op = fops_get(vfl->fops);
>>> -     if(file->f_op->open)
>>> +     file->f_op = fops_get(&vfl->priv_fops);
>>> +     if (file->f_op->open && kobject_get(&vfl->class_dev.kobj))
>>
>> Shouldn't kobject_get be called even if file->f_op->open is NULL ?
> Now that I've looked at it again, it seems you are right, kobject_get
> should be called even if file->f_op->open is null since we return err
> and it will remain 0. This means a subsequent call to video_close
> would occur. Good catch.
>
> There are two ways to handle this, (1) initialize err to something
> like -ENODEV so the open fails if file->f_op->open is not defined or
> (2) always call kobject_get and wait for the call to video_close to do
> the kobject_put.
>
Keeping with the behavior of char_dev, the correct thing to do is to
always increment the kobject reference and allow the call to open to
succeed.

The following patch implements this behavior. I've also thrown in
quite a few comments to help document the new behavior.

Regards,

David Ellingsworth

[PATCH] videodev: fix kobj ref count


Signed-off-by: David Ellingsworth <david@identd.dyndns.org>
---
 drivers/media/video/videodev.c |   91 +++++++++++++++++++++++++++++++--------
 include/media/v4l2-dev.h       |    1 +
 2 files changed, 73 insertions(+), 19 deletions(-)

diff --git a/drivers/media/video/videodev.c b/drivers/media/video/videodev.c
index 0d52819..fd6aec1 100644
--- a/drivers/media/video/videodev.c
+++ b/drivers/media/video/videodev.c
@@ -406,17 +406,31 @@ void video_device_release(struct video_device *vfd)
 }
 EXPORT_SYMBOL(video_device_release);

+/*
+ *	Active devices
+ */
+
+static struct video_device *video_device[VIDEO_NUM_DEVICES];
+
+/*
+ * videodev_lock is used to ensure exclusive access to the
+ * global video_device array and the kobject.
+ */
+static DEFINE_MUTEX(videodev_lock);
+
+/*
+ * video_release handles the kobject release callback.
+ * It must be called with the videodev_lock held
+ * since it modifies the global video_device array.
+ */
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
@@ -431,13 +445,6 @@ static struct class video_class = {
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
@@ -445,7 +452,49 @@ struct video_device* video_devdata(struct file *file)
 EXPORT_SYMBOL(video_devdata);

 /*
+ * video_close intercepts the file_operations release callback in
+ * order to decrement the kobject reference count and counteract
+ * the increment in video_open.
+ *
+ * This function is obsolete and will be removed in future releases.
+ * Races between video_open and video_close are currently prevented
+ * by the BKL.
+ */
+static int video_close(struct inode *inode, struct file *file)
+{
+	unsigned int minor = iminor(inode);
+	int err = 0;
+	struct video_device *vfl;
+
+	/*
+	 * videodev_lock is not taken here to prevent a deadlock that
+	 * would occur if vfl->fops->release calls video_unregister_device.
+	 * video_device[minor] is guaranteed not to be null in this case
+	 * since the kobject release callback has not yet been called.
+	 */
+	vfl = video_device[minor];
+
+	if (vfl->fops && vfl->fops->release)
+		err = vfl->fops->release(inode, file);
+
+	mutex_lock(&videodev_lock);
+	/*
+	 * The following kobject_put will cause video_release to be called
+	 * if the reference count is decremented to 0. This will only happen
+	 * if video_unregister_device has already been called and this is the
+	 * last call to video_close.
+	 */
+	kobject_put(&vfl->class_dev.kobj);
+	mutex_unlock(&videodev_lock);
+
+	return err;
+}
+
+/*
  *	Open a video device - FIXME: Obsoleted
+ *
+ *	A successful call to video_open increments the kobject
+ *	reference count.
  */
 static int video_open(struct inode *inode, struct file *file)
 {
@@ -469,10 +518,12 @@ static int video_open(struct inode *inode,
struct file *file)
 		}
 	}
 	old_fops = file->f_op;
-	file->f_op = fops_get(vfl->fops);
-	if(file->f_op->open)
+	file->f_op = fops_get(&vfl->priv_fops);
+	kobject_get(&vfl->class_dev.kobj);
+	if (file->f_op->open)
 		err = file->f_op->open(inode,file);
 	if (err) {
+		kobject_put(&vfl->class_dev.kobj);
 		fops_put(file->f_op);
 		file->f_op = fops_get(old_fops);
 	}
@@ -2175,6 +2226,8 @@ int video_register_device_index(struct
video_device *vfd, int type, int nr,
 	}

 	vfd->index = ret;
+	vfd->priv_fops = *vfd->fops;
+	vfd->priv_fops.release = video_close;

 	mutex_unlock(&videodev_lock);
 	mutex_init(&vfd->lock);
@@ -2215,17 +2268,17 @@ EXPORT_SYMBOL(video_register_device_index);
  *	video_unregister_device - unregister a video4linux device
  *	@vfd: the device to unregister
  *
- *	This unregisters the passed device and deassigns the minor
- *	number. Future open calls will be met with errors.
+ * 	This unregisters the passed device and decrements the kobject
+ * 	reference count. If the kobject reference count is decremented to
+ * 	0 video_release will be called to unassign the minor number.
+ * 	Calls to video_open will not occur after this function completes.
  */
-
 void video_unregister_device(struct video_device *vfd)
 {
 	mutex_lock(&videodev_lock);
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
1.5.6

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
