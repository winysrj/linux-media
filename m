Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5TMTT5h009538
	for <video4linux-list@redhat.com>; Sun, 29 Jun 2008 18:29:30 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.157])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5TMSic9004230
	for <video4linux-list@redhat.com>; Sun, 29 Jun 2008 18:29:12 -0400
Received: by fg-out-1718.google.com with SMTP id e21so776901fga.7
	for <video4linux-list@redhat.com>; Sun, 29 Jun 2008 15:28:43 -0700 (PDT)
Message-ID: <30353c3d0806291528qd61f4eey871db12dda64d38b@mail.gmail.com>
Date: Sun, 29 Jun 2008 18:28:43 -0400
From: "David Ellingsworth" <david@identd.dyndns.org>
To: video4linux-list@redhat.com,
	"Mauro Carvalho Chehab" <mchehab@infradead.org>
In-Reply-To: <30353c3d0806281807p7b78dcd2xe2a91d560ae6df12@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <30353c3d0806281807p7b78dcd2xe2a91d560ae6df12@mail.gmail.com>
Cc: 
Subject: Re: [RFC] videodev: properly reference count video_device
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

[RFC v2] This patch should cleanly apply to the v4l-dvb devel branch.
The addition of the reference count results in the wrapping of the
file_operations release callback. Since open and release both take the
videodev_lock, the big kernel lock is no longer necessary to prevent
race conditions in sub-drivers.

Regards,

David Ellingsworth

============================================

[PATCH] videodev: add ref count to video_device


Signed-off-by: David Ellingsworth <david@identd.dyndns.org>
---
 drivers/media/video/videodev.c |   72 ++++++++++++++++++++++++++++++++-------
 include/media/v4l2-dev.h       |    3 ++
 2 files changed, 62 insertions(+), 13 deletions(-)

diff --git a/drivers/media/video/videodev.c b/drivers/media/video/videodev.c
index 0d52819..bd48b4c 100644
--- a/drivers/media/video/videodev.c
+++ b/drivers/media/video/videodev.c
@@ -406,10 +406,20 @@ void video_device_release(struct video_device *vfd)
 }
 EXPORT_SYMBOL(video_device_release);

-static void video_release(struct device *cd)
+/*
+ *     Active devices
+ */
+
+static struct video_device *video_device[VIDEO_NUM_DEVICES];
+static DEFINE_MUTEX(videodev_lock);
+
+/* videodev_lock should be held before calling this */
+static void video_free(struct kref *kref)
 {
-       struct video_device *vfd = container_of(cd, struct video_device,
-                                                               class_dev);
+       struct video_device *vfd =
+               container_of(kref, struct video_device, kref);
+
+       video_device[vfd->minor] = NULL;

 #if 1
        /* needed until all drivers are fixed */
@@ -419,6 +429,29 @@ static void video_release(struct device *cd)
        vfd->release(vfd);
 }

+static inline void video_kref_get(struct video_device *vfd)
+{
+       kref_get(&vfd->kref);
+}
+
+/* videodev_lock should be held before calling this */
+static inline void video_kref_put(struct video_device *vfd)
+{
+       kref_put(&vfd->kref, video_free);
+}
+
+/*
+ * called within the context of video_unregister_device with
+ * videodev_lock held
+ */
+static void video_release(struct device *cd)
+{
+       struct video_device *vfd = container_of(cd, struct video_device,
+                                                               class_dev);
+
+       video_kref_put(vfd);
+}
+
 static struct device_attribute video_device_attrs[] = {
        __ATTR(name, S_IRUGO, show_name, NULL),
        __ATTR(index, S_IRUGO, show_index, NULL),
@@ -431,19 +464,27 @@ static struct class video_class = {
        .dev_release = video_release,
 };

-/*
- *     Active devices
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
+       unsigned int minor = iminor(inode);
+       struct video_device *vfl;
+       int err = 0;
+
+       mutex_lock(&videodev_lock);
+       vfl = video_device[minor];
+       err = vfl->fops->release(inode, file);
+       video_kref_put(vfl);
+       mutex_unlock(&videodev_lock);
+
+       return err;
+}
+
 /*
  *     Open a video device - FIXME: Obsoleted
  */
@@ -469,10 +510,13 @@ static int video_open(struct inode *inode,
struct file *file)
                }
        }
        old_fops = file->f_op;
-       file->f_op = fops_get(vfl->fops);
-       if(file->f_op->open)
+       file->f_op = fops_get(&vfl->priv_fops);
+       if (file->f_op->open) {
+               video_kref_get(vfl);
                err = file->f_op->open(inode,file);
+       }
        if (err) {
+               video_kref_put(vfl);
                fops_put(file->f_op);
                file->f_op = fops_get(old_fops);
        }
@@ -2166,6 +2210,8 @@ int video_register_device_index(struct
video_device *vfd, int type, int nr,
        }
        video_device[i]=vfd;
        vfd->minor=i;
+       vfd->priv_fops = *vfd->fops;
+       vfd->priv_fops.release = video_close;

        ret = get_index(vfd, index);
        if (ret < 0) {
@@ -2178,6 +2224,7 @@ int video_register_device_index(struct
video_device *vfd, int type, int nr,

        mutex_unlock(&videodev_lock);
        mutex_init(&vfd->lock);
+       kref_init(&vfd->kref);

        /* sysfs class */
        memset(&vfd->class_dev, 0x00, sizeof(vfd->class_dev));
@@ -2225,7 +2272,6 @@ void video_unregister_device(struct video_device *vfd)
        if(video_device[vfd->minor]!=vfd)
                panic("videodev: bad unregister");

-       video_device[vfd->minor]=NULL;
        device_unregister(&vfd->class_dev);
        mutex_unlock(&videodev_lock);
 }
diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
index 3c93414..7d26b25 100644
--- a/include/media/v4l2-dev.h
+++ b/include/media/v4l2-dev.h
@@ -342,6 +342,9 @@ void *priv;
        /* for videodev.c intenal usage -- please don't touch */
        int users;                     /* video_exclusive_{open|close} ... */
        struct mutex lock;             /* ... helper function uses these   */
+       /* private file ops for release callback */
+       struct file_operations priv_fops;
+       struct kref kref;              /* internal reference count */
 };

 /* Class-dev to video-device */
--
1.5.5.1

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
