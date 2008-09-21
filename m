Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8L4CJYk030326
	for <video4linux-list@redhat.com>; Sun, 21 Sep 2008 00:12:19 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.155])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8L4C30i009212
	for <video4linux-list@redhat.com>; Sun, 21 Sep 2008 00:12:04 -0400
Received: by fg-out-1718.google.com with SMTP id e21so1033737fga.7
	for <video4linux-list@redhat.com>; Sat, 20 Sep 2008 21:12:03 -0700 (PDT)
Message-ID: <30353c3d0809202112i6f1b7f5do48dd7c9e299ba877@mail.gmail.com>
Date: Sun, 21 Sep 2008 00:12:03 -0400
From: "David Ellingsworth" <david@identd.dyndns.org>
To: v4l <video4linux-list@redhat.com>,
	"Mauro Carvalho Chehab" <mchehab@infradead.org>,
	"Jaime Velasco Juan" <jsagarribay@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_10040_8007072.1221970323503"
Cc: 
Subject: [PATCH RFT]: stk-webcam: release via video_device release callback
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

------=_Part_10040_8007072.1221970323503
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

With the recent patch to v4l2 titled "v4l2: use register_chrdev_region
instead of register_chrdev", the internal reference count is no longer
necessary in order to free the internal stk_webcam struct. This patch
removes the reference counter from the stk_webcam struct and frees the
struct via the video_device release callback. It also fixes an
associated bug in stk_camera_probe which could result from
video_unregister_device being called before video_register_device.
Lastly, it simplifies access to the stk_webcam struct in several
places. This patch should apply cleanly against the "working" branch
of the v4l-dvb git repository.

This patch is identical to the patch I sent a couple of months back
titled "stk-webcam: Fix video_device handling" except that it has been
rebased against current modifications to stk-webcam and it no longer
depends on any other outstanding patches.

Regards,

David Ellingsworth

=============================================================
[PATCH] stk-webcam: release via video_device release callback


Signed-off-by: David Ellingsworth <david@identd.dyndns.org>
---
 drivers/media/video/stk-webcam.c |   84 ++++++++++---------------------------
 drivers/media/video/stk-webcam.h |    2 -
 2 files changed, 23 insertions(+), 63 deletions(-)

diff --git a/drivers/media/video/stk-webcam.c b/drivers/media/video/stk-webcam.c
index 8dda568..db69bc5 100644
--- a/drivers/media/video/stk-webcam.c
+++ b/drivers/media/video/stk-webcam.c
@@ -65,22 +65,6 @@ static struct usb_device_id stkwebcam_table[] = {
 };
 MODULE_DEVICE_TABLE(usb, stkwebcam_table);

-static void stk_camera_cleanup(struct kref *kref)
-{
-	struct stk_camera *dev = to_stk_camera(kref);
-
-	STK_INFO("Syntek USB2.0 Camera release resources"
-		" video device /dev/video%d\n", dev->vdev.minor);
-	video_unregister_device(&dev->vdev);
-	video_set_drvdata(&dev->vdev, NULL);
-
-	if (dev->sio_bufs != NULL || dev->isobufs != NULL)
-		STK_ERROR("We are leaking memory\n");
-	usb_put_intf(dev->interface);
-	kfree(dev);
-}
-
-
 /*
  * Basic stuff
  */
@@ -694,8 +678,7 @@ static int v4l_stk_open(struct inode *inode,
struct file *fp)
 		unlock_kernel();
 		return -ENXIO;
 	}
-	fp->private_data = vdev;
-	kref_get(&dev->kref);
+	fp->private_data = dev;
 	usb_autopm_get_interface(dev->interface);
 	unlock_kernel();

@@ -704,23 +687,10 @@ static int v4l_stk_open(struct inode *inode,
struct file *fp)

 static int v4l_stk_release(struct inode *inode, struct file *fp)
 {
-	struct stk_camera *dev;
-	struct video_device *vdev;
-
-	vdev = video_devdata(fp);
-	if (vdev == NULL) {
-		STK_ERROR("v4l_release called w/o video devdata\n");
-		return -EFAULT;
-	}
-	dev = vdev_to_camera(vdev);
-	if (dev == NULL) {
-		STK_ERROR("v4l_release called on removed device\n");
-		return -ENODEV;
-	}
+	struct stk_camera *dev = fp->private_data;

 	if (dev->owner != fp) {
 		usb_autopm_put_interface(dev->interface);
-		kref_put(&dev->kref, stk_camera_cleanup);
 		return 0;
 	}

@@ -731,7 +701,6 @@ static int v4l_stk_release(struct inode *inode,
struct file *fp)
 	dev->owner = NULL;

 	usb_autopm_put_interface(dev->interface);
-	kref_put(&dev->kref, stk_camera_cleanup);

 	return 0;
 }
@@ -742,14 +711,8 @@ static ssize_t v4l_stk_read(struct file *fp, char
__user *buf,
 	int i;
 	int ret;
 	unsigned long flags;
-	struct stk_camera *dev;
-	struct video_device *vdev;
 	struct stk_sio_buffer *sbuf;
-
-	vdev = video_devdata(fp);
-	if (vdev == NULL)
-		return -EFAULT;
-	dev = vdev_to_camera(vdev);
+	struct stk_camera *dev = fp->private_data;

 	if (dev == NULL)
 		return -EIO;
@@ -808,15 +771,8 @@ static ssize_t v4l_stk_read(struct file *fp, char
__user *buf,

 static unsigned int v4l_stk_poll(struct file *fp, poll_table *wait)
 {
-	struct stk_camera *dev;
-	struct video_device *vdev;
-
-	vdev = video_devdata(fp);
-
-	if (vdev == NULL)
-		return -EFAULT;
+	struct stk_camera *dev = fp->private_data;

-	dev = vdev_to_camera(vdev);
 	if (dev == NULL)
 		return -ENODEV;

@@ -854,16 +810,12 @@ static int v4l_stk_mmap(struct file *fp, struct
vm_area_struct *vma)
 	unsigned int i;
 	int ret;
 	unsigned long offset = vma->vm_pgoff << PAGE_SHIFT;
-	struct stk_camera *dev;
-	struct video_device *vdev;
+	struct stk_camera *dev = fp->private_data;
 	struct stk_sio_buffer *sbuf = NULL;

 	if (!(vma->vm_flags & VM_WRITE) || !(vma->vm_flags & VM_SHARED))
 		return -EINVAL;

-	vdev = video_devdata(fp);
-	dev = vdev_to_camera(vdev);
-
 	for (i = 0; i < dev->n_sbufs; i++) {
 		if (dev->sio_bufs[i].v4lbuf.m.offset == offset) {
 			sbuf = dev->sio_bufs + i;
@@ -1359,6 +1311,12 @@ static const struct v4l2_ioctl_ops v4l_stk_ioctl_ops = {

 static void stk_v4l_dev_release(struct video_device *vd)
 {
+	struct stk_camera *dev = vdev_to_camera(vd);
+
+	if (dev->sio_bufs != NULL || dev->isobufs != NULL)
+		STK_ERROR("We are leaking memory\n");
+	usb_put_intf(dev->interface);
+	kfree(dev);
 }

 static struct video_device stk_v4l_data = {
@@ -1379,7 +1337,6 @@ static int stk_register_video_device(struct
stk_camera *dev)
 	dev->vdev = stk_v4l_data;
 	dev->vdev.debug = debug;
 	dev->vdev.parent = &dev->interface->dev;
-	video_set_drvdata(&dev->vdev, dev);
 	err = video_register_device(&dev->vdev, VFL_TYPE_GRABBER, -1);
 	if (err)
 		STK_ERROR("v4l registration failed\n");
@@ -1396,7 +1353,7 @@ static int stk_camera_probe(struct usb_interface
*interface,
 		const struct usb_device_id *id)
 {
 	int i;
-	int err;
+	int err = 0;

 	struct stk_camera *dev = NULL;
 	struct usb_device *udev = interface_to_usbdev(interface);
@@ -1409,7 +1366,6 @@ static int stk_camera_probe(struct usb_interface
*interface,
 		return -ENOMEM;
 	}

-	kref_init(&dev->kref);
 	spin_lock_init(&dev->spinlock);
 	init_waitqueue_head(&dev->wait_frame);

@@ -1442,8 +1398,8 @@ static int stk_camera_probe(struct usb_interface
*interface,
 	}
 	if (!dev->isoc_ep) {
 		STK_ERROR("Could not find isoc-in endpoint");
-		kref_put(&dev->kref, stk_camera_cleanup);
-		return -ENODEV;
+		err = -ENODEV;
+		goto error;
 	}
 	dev->vsettings.brightness = 0x7fff;
 	dev->vsettings.palette = V4L2_PIX_FMT_RGB565;
@@ -1457,14 +1413,17 @@ static int stk_camera_probe(struct
usb_interface *interface,

 	err = stk_register_video_device(dev);
 	if (err) {
-		kref_put(&dev->kref, stk_camera_cleanup);
-		return err;
+		goto error;
 	}

 	stk_create_sysfs_files(&dev->vdev);
 	usb_autopm_enable(dev->interface);

 	return 0;
+
+error:
+	kfree(dev);
+	return err;
 }

 static void stk_camera_disconnect(struct usb_interface *interface)
@@ -1477,7 +1436,10 @@ static void stk_camera_disconnect(struct
usb_interface *interface)
 	wake_up_interruptible(&dev->wait_frame);
 	stk_remove_sysfs_files(&dev->vdev);

-	kref_put(&dev->kref, stk_camera_cleanup);
+	STK_INFO("Syntek USB2.0 Camera release resources"
+		"video device /dev/video%d\n", dev->vdev.minor);
+
+	video_unregister_device(&dev->vdev);
 }

 #ifdef CONFIG_PM
diff --git a/drivers/media/video/stk-webcam.h b/drivers/media/video/stk-webcam.h
index df4dfef..084a85b 100644
--- a/drivers/media/video/stk-webcam.h
+++ b/drivers/media/video/stk-webcam.h
@@ -99,7 +99,6 @@ struct stk_camera {

 	u8 isoc_ep;

-	struct kref kref;
 	/* Not sure if this is right */
 	atomic_t urbs_used;

@@ -121,7 +120,6 @@ struct stk_camera {
 	unsigned sequence;
 };

-#define to_stk_camera(d) container_of(d, struct stk_camera, kref)
 #define vdev_to_camera(d) container_of(d, struct stk_camera, vdev)

 void stk_camera_delete(struct kref *);
-- 
1.5.6

------=_Part_10040_8007072.1221970323503
Content-Type: text/x-diff;
	name=0001-stk-webcam-release-via-video_device-release-callbac.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fld5cwa60
Content-Disposition: attachment;
	filename=0001-stk-webcam-release-via-video_device-release-callbac.patch

W1BBVENIXSBzdGstd2ViY2FtOiByZWxlYXNlIHZpYSB2aWRlb19kZXZpY2UgcmVsZWFzZSBjYWxs
YmFjawoKClNpZ25lZC1vZmYtYnk6IERhdmlkIEVsbGluZ3N3b3J0aCA8ZGF2aWRAaWRlbnRkLmR5
bmRucy5vcmc+Ci0tLQogZHJpdmVycy9tZWRpYS92aWRlby9zdGstd2ViY2FtLmMgfCAgIDg0ICsr
KysrKysrKystLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KIGRyaXZlcnMvbWVkaWEvdmlkZW8v
c3RrLXdlYmNhbS5oIHwgICAgMiAtCiAyIGZpbGVzIGNoYW5nZWQsIDIzIGluc2VydGlvbnMoKyks
IDYzIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWVkaWEvdmlkZW8vc3RrLXdl
YmNhbS5jIGIvZHJpdmVycy9tZWRpYS92aWRlby9zdGstd2ViY2FtLmMKaW5kZXggOGRkYTU2OC4u
ZGI2OWJjNSAxMDA2NDQKLS0tIGEvZHJpdmVycy9tZWRpYS92aWRlby9zdGstd2ViY2FtLmMKKysr
IGIvZHJpdmVycy9tZWRpYS92aWRlby9zdGstd2ViY2FtLmMKQEAgLTY1LDIyICs2NSw2IEBAIHN0
YXRpYyBzdHJ1Y3QgdXNiX2RldmljZV9pZCBzdGt3ZWJjYW1fdGFibGVbXSA9IHsKIH07CiBNT0RV
TEVfREVWSUNFX1RBQkxFKHVzYiwgc3Rrd2ViY2FtX3RhYmxlKTsKIAotc3RhdGljIHZvaWQgc3Rr
X2NhbWVyYV9jbGVhbnVwKHN0cnVjdCBrcmVmICprcmVmKQotewotCXN0cnVjdCBzdGtfY2FtZXJh
ICpkZXYgPSB0b19zdGtfY2FtZXJhKGtyZWYpOwotCi0JU1RLX0lORk8oIlN5bnRlayBVU0IyLjAg
Q2FtZXJhIHJlbGVhc2UgcmVzb3VyY2VzIgotCQkiIHZpZGVvIGRldmljZSAvZGV2L3ZpZGVvJWRc
biIsIGRldi0+dmRldi5taW5vcik7Ci0JdmlkZW9fdW5yZWdpc3Rlcl9kZXZpY2UoJmRldi0+dmRl
dik7Ci0JdmlkZW9fc2V0X2RydmRhdGEoJmRldi0+dmRldiwgTlVMTCk7Ci0KLQlpZiAoZGV2LT5z
aW9fYnVmcyAhPSBOVUxMIHx8IGRldi0+aXNvYnVmcyAhPSBOVUxMKQotCQlTVEtfRVJST1IoIldl
IGFyZSBsZWFraW5nIG1lbW9yeVxuIik7Ci0JdXNiX3B1dF9pbnRmKGRldi0+aW50ZXJmYWNlKTsK
LQlrZnJlZShkZXYpOwotfQotCi0KIC8qCiAgKiBCYXNpYyBzdHVmZgogICovCkBAIC02OTQsOCAr
Njc4LDcgQEAgc3RhdGljIGludCB2NGxfc3RrX29wZW4oc3RydWN0IGlub2RlICppbm9kZSwgc3Ry
dWN0IGZpbGUgKmZwKQogCQl1bmxvY2tfa2VybmVsKCk7CiAJCXJldHVybiAtRU5YSU87CiAJfQot
CWZwLT5wcml2YXRlX2RhdGEgPSB2ZGV2OwotCWtyZWZfZ2V0KCZkZXYtPmtyZWYpOworCWZwLT5w
cml2YXRlX2RhdGEgPSBkZXY7CiAJdXNiX2F1dG9wbV9nZXRfaW50ZXJmYWNlKGRldi0+aW50ZXJm
YWNlKTsKIAl1bmxvY2tfa2VybmVsKCk7CiAKQEAgLTcwNCwyMyArNjg3LDEwIEBAIHN0YXRpYyBp
bnQgdjRsX3N0a19vcGVuKHN0cnVjdCBpbm9kZSAqaW5vZGUsIHN0cnVjdCBmaWxlICpmcCkKIAog
c3RhdGljIGludCB2NGxfc3RrX3JlbGVhc2Uoc3RydWN0IGlub2RlICppbm9kZSwgc3RydWN0IGZp
bGUgKmZwKQogewotCXN0cnVjdCBzdGtfY2FtZXJhICpkZXY7Ci0Jc3RydWN0IHZpZGVvX2Rldmlj
ZSAqdmRldjsKLQotCXZkZXYgPSB2aWRlb19kZXZkYXRhKGZwKTsKLQlpZiAodmRldiA9PSBOVUxM
KSB7Ci0JCVNUS19FUlJPUigidjRsX3JlbGVhc2UgY2FsbGVkIHcvbyB2aWRlbyBkZXZkYXRhXG4i
KTsKLQkJcmV0dXJuIC1FRkFVTFQ7Ci0JfQotCWRldiA9IHZkZXZfdG9fY2FtZXJhKHZkZXYpOwot
CWlmIChkZXYgPT0gTlVMTCkgewotCQlTVEtfRVJST1IoInY0bF9yZWxlYXNlIGNhbGxlZCBvbiBy
ZW1vdmVkIGRldmljZVxuIik7Ci0JCXJldHVybiAtRU5PREVWOwotCX0KKwlzdHJ1Y3Qgc3RrX2Nh
bWVyYSAqZGV2ID0gZnAtPnByaXZhdGVfZGF0YTsKIAogCWlmIChkZXYtPm93bmVyICE9IGZwKSB7
CiAJCXVzYl9hdXRvcG1fcHV0X2ludGVyZmFjZShkZXYtPmludGVyZmFjZSk7Ci0JCWtyZWZfcHV0
KCZkZXYtPmtyZWYsIHN0a19jYW1lcmFfY2xlYW51cCk7CiAJCXJldHVybiAwOwogCX0KIApAQCAt
NzMxLDcgKzcwMSw2IEBAIHN0YXRpYyBpbnQgdjRsX3N0a19yZWxlYXNlKHN0cnVjdCBpbm9kZSAq
aW5vZGUsIHN0cnVjdCBmaWxlICpmcCkKIAlkZXYtPm93bmVyID0gTlVMTDsKIAogCXVzYl9hdXRv
cG1fcHV0X2ludGVyZmFjZShkZXYtPmludGVyZmFjZSk7Ci0Ja3JlZl9wdXQoJmRldi0+a3JlZiwg
c3RrX2NhbWVyYV9jbGVhbnVwKTsKIAogCXJldHVybiAwOwogfQpAQCAtNzQyLDE0ICs3MTEsOCBA
QCBzdGF0aWMgc3NpemVfdCB2NGxfc3RrX3JlYWQoc3RydWN0IGZpbGUgKmZwLCBjaGFyIF9fdXNl
ciAqYnVmLAogCWludCBpOwogCWludCByZXQ7CiAJdW5zaWduZWQgbG9uZyBmbGFnczsKLQlzdHJ1
Y3Qgc3RrX2NhbWVyYSAqZGV2OwotCXN0cnVjdCB2aWRlb19kZXZpY2UgKnZkZXY7CiAJc3RydWN0
IHN0a19zaW9fYnVmZmVyICpzYnVmOwotCi0JdmRldiA9IHZpZGVvX2RldmRhdGEoZnApOwotCWlm
ICh2ZGV2ID09IE5VTEwpCi0JCXJldHVybiAtRUZBVUxUOwotCWRldiA9IHZkZXZfdG9fY2FtZXJh
KHZkZXYpOworCXN0cnVjdCBzdGtfY2FtZXJhICpkZXYgPSBmcC0+cHJpdmF0ZV9kYXRhOwogCiAJ
aWYgKGRldiA9PSBOVUxMKQogCQlyZXR1cm4gLUVJTzsKQEAgLTgwOCwxNSArNzcxLDggQEAgc3Rh
dGljIHNzaXplX3QgdjRsX3N0a19yZWFkKHN0cnVjdCBmaWxlICpmcCwgY2hhciBfX3VzZXIgKmJ1
ZiwKIAogc3RhdGljIHVuc2lnbmVkIGludCB2NGxfc3RrX3BvbGwoc3RydWN0IGZpbGUgKmZwLCBw
b2xsX3RhYmxlICp3YWl0KQogewotCXN0cnVjdCBzdGtfY2FtZXJhICpkZXY7Ci0Jc3RydWN0IHZp
ZGVvX2RldmljZSAqdmRldjsKLQotCXZkZXYgPSB2aWRlb19kZXZkYXRhKGZwKTsKLQotCWlmICh2
ZGV2ID09IE5VTEwpCi0JCXJldHVybiAtRUZBVUxUOworCXN0cnVjdCBzdGtfY2FtZXJhICpkZXYg
PSBmcC0+cHJpdmF0ZV9kYXRhOwogCi0JZGV2ID0gdmRldl90b19jYW1lcmEodmRldik7CiAJaWYg
KGRldiA9PSBOVUxMKQogCQlyZXR1cm4gLUVOT0RFVjsKIApAQCAtODU0LDE2ICs4MTAsMTIgQEAg
c3RhdGljIGludCB2NGxfc3RrX21tYXAoc3RydWN0IGZpbGUgKmZwLCBzdHJ1Y3Qgdm1fYXJlYV9z
dHJ1Y3QgKnZtYSkKIAl1bnNpZ25lZCBpbnQgaTsKIAlpbnQgcmV0OwogCXVuc2lnbmVkIGxvbmcg
b2Zmc2V0ID0gdm1hLT52bV9wZ29mZiA8PCBQQUdFX1NISUZUOwotCXN0cnVjdCBzdGtfY2FtZXJh
ICpkZXY7Ci0Jc3RydWN0IHZpZGVvX2RldmljZSAqdmRldjsKKwlzdHJ1Y3Qgc3RrX2NhbWVyYSAq
ZGV2ID0gZnAtPnByaXZhdGVfZGF0YTsKIAlzdHJ1Y3Qgc3RrX3Npb19idWZmZXIgKnNidWYgPSBO
VUxMOwogCiAJaWYgKCEodm1hLT52bV9mbGFncyAmIFZNX1dSSVRFKSB8fCAhKHZtYS0+dm1fZmxh
Z3MgJiBWTV9TSEFSRUQpKQogCQlyZXR1cm4gLUVJTlZBTDsKIAotCXZkZXYgPSB2aWRlb19kZXZk
YXRhKGZwKTsKLQlkZXYgPSB2ZGV2X3RvX2NhbWVyYSh2ZGV2KTsKLQogCWZvciAoaSA9IDA7IGkg
PCBkZXYtPm5fc2J1ZnM7IGkrKykgewogCQlpZiAoZGV2LT5zaW9fYnVmc1tpXS52NGxidWYubS5v
ZmZzZXQgPT0gb2Zmc2V0KSB7CiAJCQlzYnVmID0gZGV2LT5zaW9fYnVmcyArIGk7CkBAIC0xMzU5
LDYgKzEzMTEsMTIgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCB2NGwyX2lvY3RsX29wcyB2NGxfc3Rr
X2lvY3RsX29wcyA9IHsKIAogc3RhdGljIHZvaWQgc3RrX3Y0bF9kZXZfcmVsZWFzZShzdHJ1Y3Qg
dmlkZW9fZGV2aWNlICp2ZCkKIHsKKwlzdHJ1Y3Qgc3RrX2NhbWVyYSAqZGV2ID0gdmRldl90b19j
YW1lcmEodmQpOworCisJaWYgKGRldi0+c2lvX2J1ZnMgIT0gTlVMTCB8fCBkZXYtPmlzb2J1ZnMg
IT0gTlVMTCkKKwkJU1RLX0VSUk9SKCJXZSBhcmUgbGVha2luZyBtZW1vcnlcbiIpOworCXVzYl9w
dXRfaW50ZihkZXYtPmludGVyZmFjZSk7CisJa2ZyZWUoZGV2KTsKIH0KIAogc3RhdGljIHN0cnVj
dCB2aWRlb19kZXZpY2Ugc3RrX3Y0bF9kYXRhID0gewpAQCAtMTM3OSw3ICsxMzM3LDYgQEAgc3Rh
dGljIGludCBzdGtfcmVnaXN0ZXJfdmlkZW9fZGV2aWNlKHN0cnVjdCBzdGtfY2FtZXJhICpkZXYp
CiAJZGV2LT52ZGV2ID0gc3RrX3Y0bF9kYXRhOwogCWRldi0+dmRldi5kZWJ1ZyA9IGRlYnVnOwog
CWRldi0+dmRldi5wYXJlbnQgPSAmZGV2LT5pbnRlcmZhY2UtPmRldjsKLQl2aWRlb19zZXRfZHJ2
ZGF0YSgmZGV2LT52ZGV2LCBkZXYpOwogCWVyciA9IHZpZGVvX3JlZ2lzdGVyX2RldmljZSgmZGV2
LT52ZGV2LCBWRkxfVFlQRV9HUkFCQkVSLCAtMSk7CiAJaWYgKGVycikKIAkJU1RLX0VSUk9SKCJ2
NGwgcmVnaXN0cmF0aW9uIGZhaWxlZFxuIik7CkBAIC0xMzk2LDcgKzEzNTMsNyBAQCBzdGF0aWMg
aW50IHN0a19jYW1lcmFfcHJvYmUoc3RydWN0IHVzYl9pbnRlcmZhY2UgKmludGVyZmFjZSwKIAkJ
Y29uc3Qgc3RydWN0IHVzYl9kZXZpY2VfaWQgKmlkKQogewogCWludCBpOwotCWludCBlcnI7CisJ
aW50IGVyciA9IDA7CiAKIAlzdHJ1Y3Qgc3RrX2NhbWVyYSAqZGV2ID0gTlVMTDsKIAlzdHJ1Y3Qg
dXNiX2RldmljZSAqdWRldiA9IGludGVyZmFjZV90b191c2JkZXYoaW50ZXJmYWNlKTsKQEAgLTE0
MDksNyArMTM2Niw2IEBAIHN0YXRpYyBpbnQgc3RrX2NhbWVyYV9wcm9iZShzdHJ1Y3QgdXNiX2lu
dGVyZmFjZSAqaW50ZXJmYWNlLAogCQlyZXR1cm4gLUVOT01FTTsKIAl9CiAKLQlrcmVmX2luaXQo
JmRldi0+a3JlZik7CiAJc3Bpbl9sb2NrX2luaXQoJmRldi0+c3BpbmxvY2spOwogCWluaXRfd2Fp
dHF1ZXVlX2hlYWQoJmRldi0+d2FpdF9mcmFtZSk7CiAKQEAgLTE0NDIsOCArMTM5OCw4IEBAIHN0
YXRpYyBpbnQgc3RrX2NhbWVyYV9wcm9iZShzdHJ1Y3QgdXNiX2ludGVyZmFjZSAqaW50ZXJmYWNl
LAogCX0KIAlpZiAoIWRldi0+aXNvY19lcCkgewogCQlTVEtfRVJST1IoIkNvdWxkIG5vdCBmaW5k
IGlzb2MtaW4gZW5kcG9pbnQiKTsKLQkJa3JlZl9wdXQoJmRldi0+a3JlZiwgc3RrX2NhbWVyYV9j
bGVhbnVwKTsKLQkJcmV0dXJuIC1FTk9ERVY7CisJCWVyciA9IC1FTk9ERVY7CisJCWdvdG8gZXJy
b3I7CiAJfQogCWRldi0+dnNldHRpbmdzLmJyaWdodG5lc3MgPSAweDdmZmY7CiAJZGV2LT52c2V0
dGluZ3MucGFsZXR0ZSA9IFY0TDJfUElYX0ZNVF9SR0I1NjU7CkBAIC0xNDU3LDE0ICsxNDEzLDE3
IEBAIHN0YXRpYyBpbnQgc3RrX2NhbWVyYV9wcm9iZShzdHJ1Y3QgdXNiX2ludGVyZmFjZSAqaW50
ZXJmYWNlLAogCiAJZXJyID0gc3RrX3JlZ2lzdGVyX3ZpZGVvX2RldmljZShkZXYpOwogCWlmIChl
cnIpIHsKLQkJa3JlZl9wdXQoJmRldi0+a3JlZiwgc3RrX2NhbWVyYV9jbGVhbnVwKTsKLQkJcmV0
dXJuIGVycjsKKwkJZ290byBlcnJvcjsKIAl9CiAKIAlzdGtfY3JlYXRlX3N5c2ZzX2ZpbGVzKCZk
ZXYtPnZkZXYpOwogCXVzYl9hdXRvcG1fZW5hYmxlKGRldi0+aW50ZXJmYWNlKTsKIAogCXJldHVy
biAwOworCitlcnJvcjoKKwlrZnJlZShkZXYpOworCXJldHVybiBlcnI7CiB9CiAKIHN0YXRpYyB2
b2lkIHN0a19jYW1lcmFfZGlzY29ubmVjdChzdHJ1Y3QgdXNiX2ludGVyZmFjZSAqaW50ZXJmYWNl
KQpAQCAtMTQ3Nyw3ICsxNDM2LDEwIEBAIHN0YXRpYyB2b2lkIHN0a19jYW1lcmFfZGlzY29ubmVj
dChzdHJ1Y3QgdXNiX2ludGVyZmFjZSAqaW50ZXJmYWNlKQogCXdha2VfdXBfaW50ZXJydXB0aWJs
ZSgmZGV2LT53YWl0X2ZyYW1lKTsKIAlzdGtfcmVtb3ZlX3N5c2ZzX2ZpbGVzKCZkZXYtPnZkZXYp
OwogCi0Ja3JlZl9wdXQoJmRldi0+a3JlZiwgc3RrX2NhbWVyYV9jbGVhbnVwKTsKKwlTVEtfSU5G
TygiU3ludGVrIFVTQjIuMCBDYW1lcmEgcmVsZWFzZSByZXNvdXJjZXMiCisJCSJ2aWRlbyBkZXZp
Y2UgL2Rldi92aWRlbyVkXG4iLCBkZXYtPnZkZXYubWlub3IpOworCisJdmlkZW9fdW5yZWdpc3Rl
cl9kZXZpY2UoJmRldi0+dmRldik7CiB9CiAKICNpZmRlZiBDT05GSUdfUE0KZGlmZiAtLWdpdCBh
L2RyaXZlcnMvbWVkaWEvdmlkZW8vc3RrLXdlYmNhbS5oIGIvZHJpdmVycy9tZWRpYS92aWRlby9z
dGstd2ViY2FtLmgKaW5kZXggZGY0ZGZlZi4uMDg0YTg1YiAxMDA2NDQKLS0tIGEvZHJpdmVycy9t
ZWRpYS92aWRlby9zdGstd2ViY2FtLmgKKysrIGIvZHJpdmVycy9tZWRpYS92aWRlby9zdGstd2Vi
Y2FtLmgKQEAgLTk5LDcgKzk5LDYgQEAgc3RydWN0IHN0a19jYW1lcmEgewogCiAJdTggaXNvY19l
cDsKIAotCXN0cnVjdCBrcmVmIGtyZWY7CiAJLyogTm90IHN1cmUgaWYgdGhpcyBpcyByaWdodCAq
LwogCWF0b21pY190IHVyYnNfdXNlZDsKIApAQCAtMTIxLDcgKzEyMCw2IEBAIHN0cnVjdCBzdGtf
Y2FtZXJhIHsKIAl1bnNpZ25lZCBzZXF1ZW5jZTsKIH07CiAKLSNkZWZpbmUgdG9fc3RrX2NhbWVy
YShkKSBjb250YWluZXJfb2YoZCwgc3RydWN0IHN0a19jYW1lcmEsIGtyZWYpCiAjZGVmaW5lIHZk
ZXZfdG9fY2FtZXJhKGQpIGNvbnRhaW5lcl9vZihkLCBzdHJ1Y3Qgc3RrX2NhbWVyYSwgdmRldikK
IAogdm9pZCBzdGtfY2FtZXJhX2RlbGV0ZShzdHJ1Y3Qga3JlZiAqKTsKLS0gCjEuNS42Cgo=
------=_Part_10040_8007072.1221970323503
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
------=_Part_10040_8007072.1221970323503--
