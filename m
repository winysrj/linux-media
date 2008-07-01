Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m61MCwIj021076
	for <video4linux-list@redhat.com>; Tue, 1 Jul 2008 18:12:58 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.236])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m61MClhP009658
	for <video4linux-list@redhat.com>; Tue, 1 Jul 2008 18:12:48 -0400
Received: by rv-out-0506.google.com with SMTP id f6so101851rvb.51
	for <video4linux-list@redhat.com>; Tue, 01 Jul 2008 15:12:47 -0700 (PDT)
Message-ID: <30353c3d0807011512u737f7fc2pc1a50e298d140e1@mail.gmail.com>
Date: Tue, 1 Jul 2008 18:12:47 -0400
From: "David Ellingsworth" <david@identd.dyndns.org>
To: "Laurent Pinchart" <laurent.pinchart@skynet.be>
In-Reply-To: <200807012328.08469.laurent.pinchart@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <30353c3d0806281807p7b78dcd2xe2a91d560ae6df12@mail.gmail.com>
	<200806300315.42610.laurent.pinchart@skynet.be>
	<30353c3d0806292009r5556afd6s5d5e271d1c7ff575@mail.gmail.com>
	<200807012328.08469.laurent.pinchart@skynet.be>
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>
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

On Tue, Jul 1, 2008 at 5:28 PM, Laurent Pinchart
<laurent.pinchart@skynet.be> wrote:
> Hi David,
>
> you sure seem in a hurry :-) I haven't had time to answer your mail yesterday,
> sorry.
>
> On Monday 30 June 2008, David Ellingsworth wrote:
>> On Sun, Jun 29, 2008 at 9:15 PM, Laurent Pinchart
>>
>> <laurent.pinchart@skynet.be> wrote:
>> > Hi David,
>> >
>> > On Sunday 29 June 2008, David Ellingsworth wrote:
>> >> I noticed that the video_device structure wasn't properly being
>> >> reference counted. Under certain circumstances,
>> >
>> > Can you detail those certain circumstances ?
>>
>> Sure.
>>
>> For drivers which have to handle unexpected disconnects, I.E. usb and
>> pci drivers, it's possible for a user to physically remove the device
>> while it is in use. In the usb/pci disconnect callback, the correct
>> thing to do is to unregister the device in order to prevent future
>> opens.
>
> Unregistering the device ultimately frees resources, so
> video_unregister_device() in its current form can't be called in the
> disconnect callback, we agree on that.
>
>> When video_unregister_device is called in this context, it sets
>> video_device[minor number] to NULL and calls device_unregister().
>> device_unregister() causes the release callback to be called when the
>> sysfs entry is no longer in use. Under most circumstances, the release
>> callback occurs right after the call to device_unregister(). This will
>> cause a crash in __video_do_ioctl(), called from video_ioctl2, when
>> subsequent ioctls are encountered since the return value of
>> video_devdata() is NULL
>
> Your analysis is correct.
>
>> Current drivers do one of two things to avoid this crash. They either
>> use a custom ioctl callback and return an error when video_devdata()
>> is NULL,
>
> That opens the door to race conditions. I don't think this approach can safely
> be implemented without modifying the videodev core.
>
>> or they delay the call to video_unregister_device until the
>> final close occurs. The first solution means that if a usb/pci driver
>> uses video_devdata() in its ioctl or release callback, it has to check
>> that the return is not NULL. The second means the drivers must be
>> prepared to handle opens after the pci/usb disconnect callback has
>> been called since the video device is still registered.
>
> That's right. This is just a matter of setting a flag in the disconnect
> callback, and checking the flag in the open handler.
>
>> This patch prevents the video_device struct from being freed under the
>> circumstances above, and should not affect the behavior of current
>> drivers. The reference count is set to 1 during video_register_device,
>> incremented during video_open, and decremented during video_close and
>> video_unregister_device. Thus allowing for the following series of
>> calls to occur.
>>
>> With patch:
>> -----------------------------------------------------------
>> usb/pci_probe -> video_register_device
>> video_open -> usb/pci_open
>> usb/pci_disconnect -> video_unregister_device
>> video_ioctl2
>> video_close -> usb/pci_close
>> release_callback
>>
>> Without patch:
>> -----------------------------------------------------------
>> usb/pci_probe -> video_register_device
>> video_open -> usb/pci_open
>> usb/pci_disconnect -> video_unregister_device
>> release_callback
>> video_ioctl2 (crash)
>>
>> Without patch (crash avoidance #1)
>> ----------------------------------------------------------
>> usb/pci_probe -> video_register_device
>> video_open -> usb/pci_open
>> usb/pci_disconnect -> video_unregister_device
>> release_callback
>> usb/pci_ioctl (return err, video_devdata() is NULL)
>> usb/pci_close (return err, video_devdata() is NULL)
>>
>> Without patch (crash avoidance #2)
>> ----------------------------------------------------------
>> usb/pci_probe -> video_register_device
>> video_open -> usb/pci_open
>> usb/pci_disconnect
>> video_ioctl2
>> usb/pci_close -> video_unregister_device
>> release_callback
>
> What's wrong with the 'crash avoidance #2' use case ?
>
> Best regards,
>
> Laurent Pinchart
>

The main issue with both of these techniques is that (1)drivers using
videodev have to maintain their own reference count in order to
determine when it's safe to free their internal objects and (2) the
sysfs release callback clearly does not occur at the appropriate time
and therefore adds a layer of complexity to all drivers using
videodev.

The final patch I just submitted for videodev increases it's size by a
mere 17 lines of code. The patch I'm about to submit for tests, which
uses that patch, decreases the size of stk-webcam by 40 lines of code
and makes the code much easier to understand and maintain. It also
fully prepares the stk-webcam driver to handle the conversion of
videodev over to using the char_dev api.

The benefits of applying this patch are 10 fold, for it allows
videodev to provide the expected sysfs behavior while reducing the
size and complexity of all videodev drivers.

Below is the final patch, repeated here for completeness.

Regards,

David Ellingsworth

[PATCH] videodev: fix sysfs kobj ref count
=====================================

Signed-off-by: David Ellingsworth <david@identd.dyndns.org>
---
 drivers/media/video/videodev.c |   52 ++++++++++++++++++++++++++--------------
 include/media/v4l2-dev.h       |    1 +
 2 files changed, 35 insertions(+), 18 deletions(-)

diff --git a/drivers/media/video/videodev.c b/drivers/media/video/videodev.c
index 0d52819..0ef51b8 100644
--- a/drivers/media/video/videodev.c
+++ b/drivers/media/video/videodev.c
@@ -406,17 +406,23 @@ void video_device_release(struct video_device *vfd)
 }
 EXPORT_SYMBOL(video_device_release);

+/*
+ *	Active devices
+ */
+
+static struct video_device *video_device[VIDEO_NUM_DEVICES];
+static DEFINE_MUTEX(videodev_lock);
+
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
+	mutex_lock(&videodev_lock);
+	if (vfd->release)
+		vfd->release(vfd);
+	video_device[vfd->minor] = NULL;
+	mutex_unlock(&videodev_lock);
 }

 static struct device_attribute video_device_attrs[] = {
@@ -431,19 +437,30 @@ static struct class video_class = {
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
+	mutex_lock(&videodev_lock);
+	vfl = video_device[minor];
+
+	if (vfl->fops && vfl->fops->release)
+		err = vfl->fops->release(inode, file);
+
+	mutex_unlock(&videodev_lock);
+	kobject_put(&vfl->class_dev.kobj);
+
+	return err;
+}
+
 /*
  *	Open a video device - FIXME: Obsoleted
  */
@@ -469,8 +486,8 @@ static int video_open(struct inode *inode, struct
file *file)
 		}
 	}
 	old_fops = file->f_op;
-	file->f_op = fops_get(vfl->fops);
-	if(file->f_op->open)
+	file->f_op = fops_get(&vfl->priv_fops);
+	if(file->f_op->open && kobject_get(&vfl->class_dev.kobj))
 		err = file->f_op->open(inode,file);
 	if (err) {
 		fops_put(file->f_op);
@@ -2175,6 +2192,8 @@ int video_register_device_index(struct
video_device *vfd, int type, int nr,
 	}

 	vfd->index = ret;
+	vfd->priv_fops = *vfd->fops;
+	vfd->priv_fops.release = video_close;

 	mutex_unlock(&videodev_lock);
 	mutex_init(&vfd->lock);
@@ -2221,13 +2240,10 @@ EXPORT_SYMBOL(video_register_device_index);

 void video_unregister_device(struct video_device *vfd)
 {
-	mutex_lock(&videodev_lock);
 	if(video_device[vfd->minor]!=vfd)
 		panic("videodev: bad unregister");

-	video_device[vfd->minor]=NULL;
 	device_unregister(&vfd->class_dev);
-	mutex_unlock(&videodev_lock);
 }
 EXPORT_SYMBOL(video_unregister_device);

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
