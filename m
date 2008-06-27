Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5RNaFeS021743
	for <video4linux-list@redhat.com>; Fri, 27 Jun 2008 19:36:15 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.155])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5RNa4XH005702
	for <video4linux-list@redhat.com>; Fri, 27 Jun 2008 19:36:04 -0400
Received: by fg-out-1718.google.com with SMTP id e21so399075fga.7
	for <video4linux-list@redhat.com>; Fri, 27 Jun 2008 16:36:03 -0700 (PDT)
Message-ID: <30353c3d0806271636k31f1fac7r90d1dccafde99f1b@mail.gmail.com>
Date: Fri, 27 Jun 2008 19:36:03 -0400
From: "David Ellingsworth" <david@identd.dyndns.org>
To: video4linux-list@redhat.com, jsagarribay@gmail.com
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_25552_22059720.1214609763765"
Cc: 
Subject: stk-webcam: [RFT] Fix video_device handling
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

------=_Part_25552_22059720.1214609763765
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

This patch replaces the internal video_device struct of the stk_camera
struct with a pointer. video_device_alloc() is the used to fill this
pointer and video_device_release to free it. This prevents freeing of
the video_device struct before the release callback of the
video_device has been called per the V4L2 api specs.

This patch also relocates the call to video_unregister_device to the
disconnect callback of the usb_driver. This prevents calling
video_unregister_device from the usb probe callback in error paths.
Doing so removes the /dev device from the system when the physical
device no longer exists thus preventing future opens. Careful
attention has been paid to close after disconnect as well.

- David

================cut here==============================
---
 drivers/media/video/stk-webcam.c |  107 ++++++++++++++-----------------------
 drivers/media/video/stk-webcam.h |    3 +-
 2 files changed, 42 insertions(+), 68 deletions(-)

diff --git a/drivers/media/video/stk-webcam.c b/drivers/media/video/stk-webcam.c
index b12c60c..db39995 100644
--- a/drivers/media/video/stk-webcam.c
+++ b/drivers/media/video/stk-webcam.c
@@ -68,11 +68,6 @@ static void stk_camera_cleanup(struct kref *kref)
 {
        struct stk_camera *dev = to_stk_camera(kref);

-       STK_INFO("Syntek USB2.0 Camera release resources"
-               " video device /dev/video%d\n", dev->vdev.minor);
-       video_unregister_device(&dev->vdev);
-       dev->vdev.priv = NULL;
-
        if (dev->sio_bufs != NULL || dev->isobufs != NULL)
                STK_ERROR("We are leaking memory\n");
        usb_put_intf(dev->interface);
@@ -255,7 +250,7 @@ static ssize_t show_brightness(struct device *class,
                        struct device_attribute *attr, char *buf)
 {
        struct video_device *vdev = to_video_device(class);
-       struct stk_camera *dev = vdev_to_camera(vdev);
+       struct stk_camera *dev = video_get_drvdata(vdev);

        return sprintf(buf, "%X\n", dev->vsettings.brightness);
 }
@@ -268,7 +263,7 @@ static ssize_t store_brightness(struct device *class,
        int ret;

        struct video_device *vdev = to_video_device(class);
-       struct stk_camera *dev = vdev_to_camera(vdev);
+       struct stk_camera *dev = video_get_drvdata(vdev);

        value = simple_strtoul(buf, &endp, 16);

@@ -285,7 +280,7 @@ static ssize_t show_hflip(struct device *class,
                struct device_attribute *attr, char *buf)
 {
        struct video_device *vdev = to_video_device(class);
-       struct stk_camera *dev = vdev_to_camera(vdev);
+       struct stk_camera *dev = video_get_drvdata(vdev);

        return sprintf(buf, "%d\n", dev->vsettings.hflip);
 }
@@ -294,7 +289,7 @@ static ssize_t store_hflip(struct device *class,
                struct device_attribute *attr, const char *buf, size_t count)
 {
        struct video_device *vdev = to_video_device(class);
-       struct stk_camera *dev = vdev_to_camera(vdev);
+       struct stk_camera *dev = video_get_drvdata(vdev);

        if (strncmp(buf, "1", 1) == 0)
                dev->vsettings.hflip = 1;
@@ -310,7 +305,7 @@ static ssize_t show_vflip(struct device *class,
                struct device_attribute *attr, char *buf)
 {
        struct video_device *vdev = to_video_device(class);
-       struct stk_camera *dev = vdev_to_camera(vdev);
+       struct stk_camera *dev = video_get_drvdata(vdev);

        return sprintf(buf, "%d\n", dev->vsettings.vflip);
 }
@@ -319,7 +314,7 @@ static ssize_t store_vflip(struct device *class,
                struct device_attribute *attr, const char *buf, size_t count)
 {
        struct video_device *vdev = to_video_device(class);
-       struct stk_camera *dev = vdev_to_camera(vdev);
+       struct stk_camera *dev = video_get_drvdata(vdev);

        if (strncmp(buf, "1", 1) == 0)
                dev->vsettings.vflip = 1;
@@ -683,11 +678,11 @@ static int v4l_stk_open(struct inode *inode,
struct file *fp)
        struct video_device *vdev;

        vdev = video_devdata(fp);
-       dev = vdev_to_camera(vdev);
+       dev = video_get_drvdata(vdev);

        if (dev == NULL || !is_present(dev))
                return -ENXIO;
-       fp->private_data = vdev;
+       fp->private_data = dev;
        kref_get(&dev->kref);
        usb_autopm_get_interface(dev->interface);

@@ -696,19 +691,7 @@ static int v4l_stk_open(struct inode *inode,
struct file *fp)

 static int v4l_stk_release(struct inode *inode, struct file *fp)
 {
-       struct stk_camera *dev;
-       struct video_device *vdev;
-
-       vdev = video_devdata(fp);
-       if (vdev == NULL) {
-               STK_ERROR("v4l_release called w/o video devdata\n");
-               return -EFAULT;
-       }
-       dev = vdev_to_camera(vdev);
-       if (dev == NULL) {
-               STK_ERROR("v4l_release called on removed device\n");
-               return -ENODEV;
-       }
+       struct stk_camera *dev = fp->private_data;

        if (dev->owner != fp) {
                usb_autopm_put_interface(dev->interface);
@@ -734,14 +717,8 @@ static ssize_t v4l_stk_read(struct file *fp, char
__user *buf,
        int i;
        int ret;
        unsigned long flags;
-       struct stk_camera *dev;
-       struct video_device *vdev;
        struct stk_sio_buffer *sbuf;
-
-       vdev = video_devdata(fp);
-       if (vdev == NULL)
-               return -EFAULT;
-       dev = vdev_to_camera(vdev);
+       struct stk_camera *dev = fp->private_data;

        if (dev == NULL)
                return -EIO;
@@ -800,15 +777,8 @@ static ssize_t v4l_stk_read(struct file *fp, char
__user *buf,

 static unsigned int v4l_stk_poll(struct file *fp, poll_table *wait)
 {
-       struct stk_camera *dev;
-       struct video_device *vdev;
-
-       vdev = video_devdata(fp);
-
-       if (vdev == NULL)
-               return -EFAULT;
+       struct stk_camera *dev = fp->private_data;

-       dev = vdev_to_camera(vdev);
        if (dev == NULL)
                return -ENODEV;

@@ -846,16 +816,12 @@ static int v4l_stk_mmap(struct file *fp, struct
vm_area_struct *vma)
        unsigned int i;
        int ret;
        unsigned long offset = vma->vm_pgoff << PAGE_SHIFT;
-       struct stk_camera *dev;
-       struct video_device *vdev;
+       struct stk_camera *dev = fp->private_data;
        struct stk_sio_buffer *sbuf = NULL;

        if (!(vma->vm_flags & VM_WRITE) || !(vma->vm_flags & VM_SHARED))
                return -EINVAL;

-       vdev = video_devdata(fp);
-       dev = vdev_to_camera(vdev);
-
        for (i = 0; i < dev->n_sbufs; i++) {
                if (dev->sio_bufs[i].v4lbuf.m.offset == offset) {
                        sbuf = dev->sio_bufs + i;
@@ -1327,10 +1293,6 @@ static struct file_operations v4l_stk_fops = {
        .llseek = no_llseek
 };

-static void stk_v4l_dev_release(struct video_device *vd)
-{
-}
-
 static struct video_device stk_v4l_data = {
        .name = "stkwebcam",
        .type = VFL_TYPE_GRABBER,
@@ -1339,7 +1301,7 @@ static struct video_device stk_v4l_data = {
        .tvnorms = V4L2_STD_UNKNOWN,
        .current_norm = V4L2_STD_UNKNOWN,
        .fops = &v4l_stk_fops,
-       .release = stk_v4l_dev_release,
+       .release = video_device_release,

        .vidioc_querycap = stk_vidioc_querycap,
        .vidioc_enum_fmt_cap = stk_vidioc_enum_fmt_cap,
@@ -1367,16 +1329,16 @@ static int stk_register_video_device(struct
stk_camera *dev)
 {
        int err;

-       dev->vdev = stk_v4l_data;
-       dev->vdev.debug = debug;
-       dev->vdev.dev = &dev->interface->dev;
-       dev->vdev.priv = dev;
-       err = video_register_device(&dev->vdev, VFL_TYPE_GRABBER, -1);
+       *dev->vdev = stk_v4l_data;
+       dev->vdev->debug = debug;
+       dev->vdev->dev = &dev->interface->dev;
+       video_set_drvdata(dev->vdev, dev);
+       err = video_register_device(dev->vdev, VFL_TYPE_GRABBER, -1);
        if (err)
                STK_ERROR("v4l registration failed\n");
        else
                STK_INFO("Syntek USB2.0 Camera is now controlling video device"
-                       " /dev/video%d\n", dev->vdev.minor);
+                       " /dev/video%d\n", dev->vdev->minor);
        return err;
 }

@@ -1387,7 +1349,7 @@ static int stk_camera_probe(struct usb_interface
*interface,
                const struct usb_device_id *id)
 {
        int i;
-       int err;
+       int err = 0;

        struct stk_camera *dev = NULL;
        struct usb_device *udev = interface_to_usbdev(interface);
@@ -1433,8 +1395,8 @@ static int stk_camera_probe(struct usb_interface
*interface,
        }
        if (!dev->isoc_ep) {
                STK_ERROR("Could not find isoc-in endpoint");
-               kref_put(&dev->kref, stk_camera_cleanup);
-               return -ENODEV;
+               err = -ENODEV;
+               goto error;
        }
        dev->vsettings.brightness = 0x7fff;
        dev->vsettings.palette = V4L2_PIX_FMT_RGB565;
@@ -1446,16 +1408,24 @@ static int stk_camera_probe(struct
usb_interface *interface,

        usb_set_intfdata(interface, dev);

-       err = stk_register_video_device(dev);
-       if (err) {
-               kref_put(&dev->kref, stk_camera_cleanup);
-               return err;
+       if((dev->vdev = video_device_alloc()) == NULL) {
+               err = -ENOMEM;
+               goto error;
        }

-       stk_create_sysfs_files(&dev->vdev);
+       if((err = stk_register_video_device(dev)))
+               goto error_vdev;
+
+       stk_create_sysfs_files(dev->vdev);
        usb_autopm_enable(dev->interface);

        return 0;
+
+error_vdev:
+       video_device_release(dev->vdev);
+error:
+       kref_put(&dev->kref, stk_camera_cleanup);
+       return err;
 }

 static void stk_camera_disconnect(struct usb_interface *interface)
@@ -1466,7 +1436,12 @@ static void stk_camera_disconnect(struct
usb_interface *interface)
        unset_present(dev);

        wake_up_interruptible(&dev->wait_frame);
-       stk_remove_sysfs_files(&dev->vdev);
+       stk_remove_sysfs_files(dev->vdev);
+
+       STK_INFO("Syntek USB2.0 Camera release resources"
+               " video device /dev/video%d\n", dev->vdev->minor);
+
+       video_unregister_device(dev->vdev);

        kref_put(&dev->kref, stk_camera_cleanup);
 }
diff --git a/drivers/media/video/stk-webcam.h b/drivers/media/video/stk-webcam.h
index df4dfef..84257fe 100644
--- a/drivers/media/video/stk-webcam.h
+++ b/drivers/media/video/stk-webcam.h
@@ -91,7 +91,7 @@ struct regval {
 };

 struct stk_camera {
-       struct video_device vdev;
+       struct video_device *vdev;
        struct usb_device *udev;
        struct usb_interface *interface;
        int webcam_model;
@@ -122,7 +122,6 @@ struct stk_camera {
 };

 #define to_stk_camera(d) container_of(d, struct stk_camera, kref)
-#define vdev_to_camera(d) container_of(d, struct stk_camera, vdev)

 void stk_camera_delete(struct kref *);
 int stk_camera_write_reg(struct stk_camera *, u16, u8);
--
1.5.5.1

------=_Part_25552_22059720.1214609763765
Content-Type: text/x-diff; name=stk-webcam.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fhzeyb2e0
Content-Disposition: attachment; filename=stk-webcam.patch

LS0tCiBkcml2ZXJzL21lZGlhL3ZpZGVvL3N0ay13ZWJjYW0uYyB8ICAxMDcgKysrKysrKysrKysr
KystLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQogZHJpdmVycy9tZWRpYS92aWRlby9zdGstd2ViY2Ft
LmggfCAgICAzICstCiAyIGZpbGVzIGNoYW5nZWQsIDQyIGluc2VydGlvbnMoKyksIDY4IGRlbGV0
aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWVkaWEvdmlkZW8vc3RrLXdlYmNhbS5jIGIv
ZHJpdmVycy9tZWRpYS92aWRlby9zdGstd2ViY2FtLmMKaW5kZXggYjEyYzYwYy4uZGIzOTk5NSAx
MDA2NDQKLS0tIGEvZHJpdmVycy9tZWRpYS92aWRlby9zdGstd2ViY2FtLmMKKysrIGIvZHJpdmVy
cy9tZWRpYS92aWRlby9zdGstd2ViY2FtLmMKQEAgLTY4LDExICs2OCw2IEBAIHN0YXRpYyB2b2lk
IHN0a19jYW1lcmFfY2xlYW51cChzdHJ1Y3Qga3JlZiAqa3JlZikKIHsKIAlzdHJ1Y3Qgc3RrX2Nh
bWVyYSAqZGV2ID0gdG9fc3RrX2NhbWVyYShrcmVmKTsKIAotCVNUS19JTkZPKCJTeW50ZWsgVVNC
Mi4wIENhbWVyYSByZWxlYXNlIHJlc291cmNlcyIKLQkJIiB2aWRlbyBkZXZpY2UgL2Rldi92aWRl
byVkXG4iLCBkZXYtPnZkZXYubWlub3IpOwotCXZpZGVvX3VucmVnaXN0ZXJfZGV2aWNlKCZkZXYt
PnZkZXYpOwotCWRldi0+dmRldi5wcml2ID0gTlVMTDsKLQogCWlmIChkZXYtPnNpb19idWZzICE9
IE5VTEwgfHwgZGV2LT5pc29idWZzICE9IE5VTEwpCiAJCVNUS19FUlJPUigiV2UgYXJlIGxlYWtp
bmcgbWVtb3J5XG4iKTsKIAl1c2JfcHV0X2ludGYoZGV2LT5pbnRlcmZhY2UpOwpAQCAtMjU1LDcg
KzI1MCw3IEBAIHN0YXRpYyBzc2l6ZV90IHNob3dfYnJpZ2h0bmVzcyhzdHJ1Y3QgZGV2aWNlICpj
bGFzcywKIAkJCXN0cnVjdCBkZXZpY2VfYXR0cmlidXRlICphdHRyLCBjaGFyICpidWYpCiB7CiAJ
c3RydWN0IHZpZGVvX2RldmljZSAqdmRldiA9IHRvX3ZpZGVvX2RldmljZShjbGFzcyk7Ci0Jc3Ry
dWN0IHN0a19jYW1lcmEgKmRldiA9IHZkZXZfdG9fY2FtZXJhKHZkZXYpOworCXN0cnVjdCBzdGtf
Y2FtZXJhICpkZXYgPSB2aWRlb19nZXRfZHJ2ZGF0YSh2ZGV2KTsKIAogCXJldHVybiBzcHJpbnRm
KGJ1ZiwgIiVYXG4iLCBkZXYtPnZzZXR0aW5ncy5icmlnaHRuZXNzKTsKIH0KQEAgLTI2OCw3ICsy
NjMsNyBAQCBzdGF0aWMgc3NpemVfdCBzdG9yZV9icmlnaHRuZXNzKHN0cnVjdCBkZXZpY2UgKmNs
YXNzLAogCWludCByZXQ7CiAKIAlzdHJ1Y3QgdmlkZW9fZGV2aWNlICp2ZGV2ID0gdG9fdmlkZW9f
ZGV2aWNlKGNsYXNzKTsKLQlzdHJ1Y3Qgc3RrX2NhbWVyYSAqZGV2ID0gdmRldl90b19jYW1lcmEo
dmRldik7CisJc3RydWN0IHN0a19jYW1lcmEgKmRldiA9IHZpZGVvX2dldF9kcnZkYXRhKHZkZXYp
OwogCiAJdmFsdWUgPSBzaW1wbGVfc3RydG91bChidWYsICZlbmRwLCAxNik7CiAKQEAgLTI4NSw3
ICsyODAsNyBAQCBzdGF0aWMgc3NpemVfdCBzaG93X2hmbGlwKHN0cnVjdCBkZXZpY2UgKmNsYXNz
LAogCQlzdHJ1Y3QgZGV2aWNlX2F0dHJpYnV0ZSAqYXR0ciwgY2hhciAqYnVmKQogewogCXN0cnVj
dCB2aWRlb19kZXZpY2UgKnZkZXYgPSB0b192aWRlb19kZXZpY2UoY2xhc3MpOwotCXN0cnVjdCBz
dGtfY2FtZXJhICpkZXYgPSB2ZGV2X3RvX2NhbWVyYSh2ZGV2KTsKKwlzdHJ1Y3Qgc3RrX2NhbWVy
YSAqZGV2ID0gdmlkZW9fZ2V0X2RydmRhdGEodmRldik7CiAKIAlyZXR1cm4gc3ByaW50ZihidWYs
ICIlZFxuIiwgZGV2LT52c2V0dGluZ3MuaGZsaXApOwogfQpAQCAtMjk0LDcgKzI4OSw3IEBAIHN0
YXRpYyBzc2l6ZV90IHN0b3JlX2hmbGlwKHN0cnVjdCBkZXZpY2UgKmNsYXNzLAogCQlzdHJ1Y3Qg
ZGV2aWNlX2F0dHJpYnV0ZSAqYXR0ciwgY29uc3QgY2hhciAqYnVmLCBzaXplX3QgY291bnQpCiB7
CiAJc3RydWN0IHZpZGVvX2RldmljZSAqdmRldiA9IHRvX3ZpZGVvX2RldmljZShjbGFzcyk7Ci0J
c3RydWN0IHN0a19jYW1lcmEgKmRldiA9IHZkZXZfdG9fY2FtZXJhKHZkZXYpOworCXN0cnVjdCBz
dGtfY2FtZXJhICpkZXYgPSB2aWRlb19nZXRfZHJ2ZGF0YSh2ZGV2KTsKIAogCWlmIChzdHJuY21w
KGJ1ZiwgIjEiLCAxKSA9PSAwKQogCQlkZXYtPnZzZXR0aW5ncy5oZmxpcCA9IDE7CkBAIC0zMTAs
NyArMzA1LDcgQEAgc3RhdGljIHNzaXplX3Qgc2hvd192ZmxpcChzdHJ1Y3QgZGV2aWNlICpjbGFz
cywKIAkJc3RydWN0IGRldmljZV9hdHRyaWJ1dGUgKmF0dHIsIGNoYXIgKmJ1ZikKIHsKIAlzdHJ1
Y3QgdmlkZW9fZGV2aWNlICp2ZGV2ID0gdG9fdmlkZW9fZGV2aWNlKGNsYXNzKTsKLQlzdHJ1Y3Qg
c3RrX2NhbWVyYSAqZGV2ID0gdmRldl90b19jYW1lcmEodmRldik7CisJc3RydWN0IHN0a19jYW1l
cmEgKmRldiA9IHZpZGVvX2dldF9kcnZkYXRhKHZkZXYpOwogCiAJcmV0dXJuIHNwcmludGYoYnVm
LCAiJWRcbiIsIGRldi0+dnNldHRpbmdzLnZmbGlwKTsKIH0KQEAgLTMxOSw3ICszMTQsNyBAQCBz
dGF0aWMgc3NpemVfdCBzdG9yZV92ZmxpcChzdHJ1Y3QgZGV2aWNlICpjbGFzcywKIAkJc3RydWN0
IGRldmljZV9hdHRyaWJ1dGUgKmF0dHIsIGNvbnN0IGNoYXIgKmJ1Ziwgc2l6ZV90IGNvdW50KQog
ewogCXN0cnVjdCB2aWRlb19kZXZpY2UgKnZkZXYgPSB0b192aWRlb19kZXZpY2UoY2xhc3MpOwot
CXN0cnVjdCBzdGtfY2FtZXJhICpkZXYgPSB2ZGV2X3RvX2NhbWVyYSh2ZGV2KTsKKwlzdHJ1Y3Qg
c3RrX2NhbWVyYSAqZGV2ID0gdmlkZW9fZ2V0X2RydmRhdGEodmRldik7CiAKIAlpZiAoc3RybmNt
cChidWYsICIxIiwgMSkgPT0gMCkKIAkJZGV2LT52c2V0dGluZ3MudmZsaXAgPSAxOwpAQCAtNjgz
LDExICs2NzgsMTEgQEAgc3RhdGljIGludCB2NGxfc3RrX29wZW4oc3RydWN0IGlub2RlICppbm9k
ZSwgc3RydWN0IGZpbGUgKmZwKQogCXN0cnVjdCB2aWRlb19kZXZpY2UgKnZkZXY7CiAKIAl2ZGV2
ID0gdmlkZW9fZGV2ZGF0YShmcCk7Ci0JZGV2ID0gdmRldl90b19jYW1lcmEodmRldik7CisJZGV2
ID0gdmlkZW9fZ2V0X2RydmRhdGEodmRldik7CiAKIAlpZiAoZGV2ID09IE5VTEwgfHwgIWlzX3By
ZXNlbnQoZGV2KSkKIAkJcmV0dXJuIC1FTlhJTzsKLQlmcC0+cHJpdmF0ZV9kYXRhID0gdmRldjsK
KwlmcC0+cHJpdmF0ZV9kYXRhID0gZGV2OwogCWtyZWZfZ2V0KCZkZXYtPmtyZWYpOwogCXVzYl9h
dXRvcG1fZ2V0X2ludGVyZmFjZShkZXYtPmludGVyZmFjZSk7CiAKQEAgLTY5NiwxOSArNjkxLDcg
QEAgc3RhdGljIGludCB2NGxfc3RrX29wZW4oc3RydWN0IGlub2RlICppbm9kZSwgc3RydWN0IGZp
bGUgKmZwKQogCiBzdGF0aWMgaW50IHY0bF9zdGtfcmVsZWFzZShzdHJ1Y3QgaW5vZGUgKmlub2Rl
LCBzdHJ1Y3QgZmlsZSAqZnApCiB7Ci0Jc3RydWN0IHN0a19jYW1lcmEgKmRldjsKLQlzdHJ1Y3Qg
dmlkZW9fZGV2aWNlICp2ZGV2OwotCi0JdmRldiA9IHZpZGVvX2RldmRhdGEoZnApOwotCWlmICh2
ZGV2ID09IE5VTEwpIHsKLQkJU1RLX0VSUk9SKCJ2NGxfcmVsZWFzZSBjYWxsZWQgdy9vIHZpZGVv
IGRldmRhdGFcbiIpOwotCQlyZXR1cm4gLUVGQVVMVDsKLQl9Ci0JZGV2ID0gdmRldl90b19jYW1l
cmEodmRldik7Ci0JaWYgKGRldiA9PSBOVUxMKSB7Ci0JCVNUS19FUlJPUigidjRsX3JlbGVhc2Ug
Y2FsbGVkIG9uIHJlbW92ZWQgZGV2aWNlXG4iKTsKLQkJcmV0dXJuIC1FTk9ERVY7Ci0JfQorCXN0
cnVjdCBzdGtfY2FtZXJhICpkZXYgPSBmcC0+cHJpdmF0ZV9kYXRhOwogCiAJaWYgKGRldi0+b3du
ZXIgIT0gZnApIHsKIAkJdXNiX2F1dG9wbV9wdXRfaW50ZXJmYWNlKGRldi0+aW50ZXJmYWNlKTsK
QEAgLTczNCwxNCArNzE3LDggQEAgc3RhdGljIHNzaXplX3QgdjRsX3N0a19yZWFkKHN0cnVjdCBm
aWxlICpmcCwgY2hhciBfX3VzZXIgKmJ1ZiwKIAlpbnQgaTsKIAlpbnQgcmV0OwogCXVuc2lnbmVk
IGxvbmcgZmxhZ3M7Ci0Jc3RydWN0IHN0a19jYW1lcmEgKmRldjsKLQlzdHJ1Y3QgdmlkZW9fZGV2
aWNlICp2ZGV2OwogCXN0cnVjdCBzdGtfc2lvX2J1ZmZlciAqc2J1ZjsKLQotCXZkZXYgPSB2aWRl
b19kZXZkYXRhKGZwKTsKLQlpZiAodmRldiA9PSBOVUxMKQotCQlyZXR1cm4gLUVGQVVMVDsKLQlk
ZXYgPSB2ZGV2X3RvX2NhbWVyYSh2ZGV2KTsKKwlzdHJ1Y3Qgc3RrX2NhbWVyYSAqZGV2ID0gZnAt
PnByaXZhdGVfZGF0YTsKIAogCWlmIChkZXYgPT0gTlVMTCkKIAkJcmV0dXJuIC1FSU87CkBAIC04
MDAsMTUgKzc3Nyw4IEBAIHN0YXRpYyBzc2l6ZV90IHY0bF9zdGtfcmVhZChzdHJ1Y3QgZmlsZSAq
ZnAsIGNoYXIgX191c2VyICpidWYsCiAKIHN0YXRpYyB1bnNpZ25lZCBpbnQgdjRsX3N0a19wb2xs
KHN0cnVjdCBmaWxlICpmcCwgcG9sbF90YWJsZSAqd2FpdCkKIHsKLQlzdHJ1Y3Qgc3RrX2NhbWVy
YSAqZGV2OwotCXN0cnVjdCB2aWRlb19kZXZpY2UgKnZkZXY7Ci0KLQl2ZGV2ID0gdmlkZW9fZGV2
ZGF0YShmcCk7Ci0KLQlpZiAodmRldiA9PSBOVUxMKQotCQlyZXR1cm4gLUVGQVVMVDsKKwlzdHJ1
Y3Qgc3RrX2NhbWVyYSAqZGV2ID0gZnAtPnByaXZhdGVfZGF0YTsKIAotCWRldiA9IHZkZXZfdG9f
Y2FtZXJhKHZkZXYpOwogCWlmIChkZXYgPT0gTlVMTCkKIAkJcmV0dXJuIC1FTk9ERVY7CiAKQEAg
LTg0NiwxNiArODE2LDEyIEBAIHN0YXRpYyBpbnQgdjRsX3N0a19tbWFwKHN0cnVjdCBmaWxlICpm
cCwgc3RydWN0IHZtX2FyZWFfc3RydWN0ICp2bWEpCiAJdW5zaWduZWQgaW50IGk7CiAJaW50IHJl
dDsKIAl1bnNpZ25lZCBsb25nIG9mZnNldCA9IHZtYS0+dm1fcGdvZmYgPDwgUEFHRV9TSElGVDsK
LQlzdHJ1Y3Qgc3RrX2NhbWVyYSAqZGV2OwotCXN0cnVjdCB2aWRlb19kZXZpY2UgKnZkZXY7CisJ
c3RydWN0IHN0a19jYW1lcmEgKmRldiA9IGZwLT5wcml2YXRlX2RhdGE7CiAJc3RydWN0IHN0a19z
aW9fYnVmZmVyICpzYnVmID0gTlVMTDsKIAogCWlmICghKHZtYS0+dm1fZmxhZ3MgJiBWTV9XUklU
RSkgfHwgISh2bWEtPnZtX2ZsYWdzICYgVk1fU0hBUkVEKSkKIAkJcmV0dXJuIC1FSU5WQUw7CiAK
LQl2ZGV2ID0gdmlkZW9fZGV2ZGF0YShmcCk7Ci0JZGV2ID0gdmRldl90b19jYW1lcmEodmRldik7
Ci0KIAlmb3IgKGkgPSAwOyBpIDwgZGV2LT5uX3NidWZzOyBpKyspIHsKIAkJaWYgKGRldi0+c2lv
X2J1ZnNbaV0udjRsYnVmLm0ub2Zmc2V0ID09IG9mZnNldCkgewogCQkJc2J1ZiA9IGRldi0+c2lv
X2J1ZnMgKyBpOwpAQCAtMTMyNywxMCArMTI5Myw2IEBAIHN0YXRpYyBzdHJ1Y3QgZmlsZV9vcGVy
YXRpb25zIHY0bF9zdGtfZm9wcyA9IHsKIAkubGxzZWVrID0gbm9fbGxzZWVrCiB9OwogCi1zdGF0
aWMgdm9pZCBzdGtfdjRsX2Rldl9yZWxlYXNlKHN0cnVjdCB2aWRlb19kZXZpY2UgKnZkKQotewot
fQotCiBzdGF0aWMgc3RydWN0IHZpZGVvX2RldmljZSBzdGtfdjRsX2RhdGEgPSB7CiAJLm5hbWUg
PSAic3Rrd2ViY2FtIiwKIAkudHlwZSA9IFZGTF9UWVBFX0dSQUJCRVIsCkBAIC0xMzM5LDcgKzEz
MDEsNyBAQCBzdGF0aWMgc3RydWN0IHZpZGVvX2RldmljZSBzdGtfdjRsX2RhdGEgPSB7CiAJLnR2
bm9ybXMgPSBWNEwyX1NURF9VTktOT1dOLAogCS5jdXJyZW50X25vcm0gPSBWNEwyX1NURF9VTktO
T1dOLAogCS5mb3BzID0gJnY0bF9zdGtfZm9wcywKLQkucmVsZWFzZSA9IHN0a192NGxfZGV2X3Jl
bGVhc2UsCisJLnJlbGVhc2UgPSB2aWRlb19kZXZpY2VfcmVsZWFzZSwKIAogCS52aWRpb2NfcXVl
cnljYXAgPSBzdGtfdmlkaW9jX3F1ZXJ5Y2FwLAogCS52aWRpb2NfZW51bV9mbXRfY2FwID0gc3Rr
X3ZpZGlvY19lbnVtX2ZtdF9jYXAsCkBAIC0xMzY3LDE2ICsxMzI5LDE2IEBAIHN0YXRpYyBpbnQg
c3RrX3JlZ2lzdGVyX3ZpZGVvX2RldmljZShzdHJ1Y3Qgc3RrX2NhbWVyYSAqZGV2KQogewogCWlu
dCBlcnI7CiAKLQlkZXYtPnZkZXYgPSBzdGtfdjRsX2RhdGE7Ci0JZGV2LT52ZGV2LmRlYnVnID0g
ZGVidWc7Ci0JZGV2LT52ZGV2LmRldiA9ICZkZXYtPmludGVyZmFjZS0+ZGV2OwotCWRldi0+dmRl
di5wcml2ID0gZGV2OwotCWVyciA9IHZpZGVvX3JlZ2lzdGVyX2RldmljZSgmZGV2LT52ZGV2LCBW
RkxfVFlQRV9HUkFCQkVSLCAtMSk7CisJKmRldi0+dmRldiA9IHN0a192NGxfZGF0YTsKKwlkZXYt
PnZkZXYtPmRlYnVnID0gZGVidWc7CisJZGV2LT52ZGV2LT5kZXYgPSAmZGV2LT5pbnRlcmZhY2Ut
PmRldjsKKwl2aWRlb19zZXRfZHJ2ZGF0YShkZXYtPnZkZXYsIGRldik7CisJZXJyID0gdmlkZW9f
cmVnaXN0ZXJfZGV2aWNlKGRldi0+dmRldiwgVkZMX1RZUEVfR1JBQkJFUiwgLTEpOwogCWlmIChl
cnIpCiAJCVNUS19FUlJPUigidjRsIHJlZ2lzdHJhdGlvbiBmYWlsZWRcbiIpOwogCWVsc2UKIAkJ
U1RLX0lORk8oIlN5bnRlayBVU0IyLjAgQ2FtZXJhIGlzIG5vdyBjb250cm9sbGluZyB2aWRlbyBk
ZXZpY2UiCi0JCQkiIC9kZXYvdmlkZW8lZFxuIiwgZGV2LT52ZGV2Lm1pbm9yKTsKKwkJCSIgL2Rl
di92aWRlbyVkXG4iLCBkZXYtPnZkZXYtPm1pbm9yKTsKIAlyZXR1cm4gZXJyOwogfQogCkBAIC0x
Mzg3LDcgKzEzNDksNyBAQCBzdGF0aWMgaW50IHN0a19jYW1lcmFfcHJvYmUoc3RydWN0IHVzYl9p
bnRlcmZhY2UgKmludGVyZmFjZSwKIAkJY29uc3Qgc3RydWN0IHVzYl9kZXZpY2VfaWQgKmlkKQog
ewogCWludCBpOwotCWludCBlcnI7CisJaW50IGVyciA9IDA7CiAKIAlzdHJ1Y3Qgc3RrX2NhbWVy
YSAqZGV2ID0gTlVMTDsKIAlzdHJ1Y3QgdXNiX2RldmljZSAqdWRldiA9IGludGVyZmFjZV90b191
c2JkZXYoaW50ZXJmYWNlKTsKQEAgLTE0MzMsOCArMTM5NSw4IEBAIHN0YXRpYyBpbnQgc3RrX2Nh
bWVyYV9wcm9iZShzdHJ1Y3QgdXNiX2ludGVyZmFjZSAqaW50ZXJmYWNlLAogCX0KIAlpZiAoIWRl
di0+aXNvY19lcCkgewogCQlTVEtfRVJST1IoIkNvdWxkIG5vdCBmaW5kIGlzb2MtaW4gZW5kcG9p
bnQiKTsKLQkJa3JlZl9wdXQoJmRldi0+a3JlZiwgc3RrX2NhbWVyYV9jbGVhbnVwKTsKLQkJcmV0
dXJuIC1FTk9ERVY7CisJCWVyciA9IC1FTk9ERVY7CisJCWdvdG8gZXJyb3I7CiAJfQogCWRldi0+
dnNldHRpbmdzLmJyaWdodG5lc3MgPSAweDdmZmY7CiAJZGV2LT52c2V0dGluZ3MucGFsZXR0ZSA9
IFY0TDJfUElYX0ZNVF9SR0I1NjU7CkBAIC0xNDQ2LDE2ICsxNDA4LDI0IEBAIHN0YXRpYyBpbnQg
c3RrX2NhbWVyYV9wcm9iZShzdHJ1Y3QgdXNiX2ludGVyZmFjZSAqaW50ZXJmYWNlLAogCiAJdXNi
X3NldF9pbnRmZGF0YShpbnRlcmZhY2UsIGRldik7CiAKLQllcnIgPSBzdGtfcmVnaXN0ZXJfdmlk
ZW9fZGV2aWNlKGRldik7Ci0JaWYgKGVycikgewotCQlrcmVmX3B1dCgmZGV2LT5rcmVmLCBzdGtf
Y2FtZXJhX2NsZWFudXApOwotCQlyZXR1cm4gZXJyOworCWlmKChkZXYtPnZkZXYgPSB2aWRlb19k
ZXZpY2VfYWxsb2MoKSkgPT0gTlVMTCkgeworCQllcnIgPSAtRU5PTUVNOworCQlnb3RvIGVycm9y
OwogCX0KIAotCXN0a19jcmVhdGVfc3lzZnNfZmlsZXMoJmRldi0+dmRldik7CisJaWYoKGVyciA9
IHN0a19yZWdpc3Rlcl92aWRlb19kZXZpY2UoZGV2KSkpCisJCWdvdG8gZXJyb3JfdmRldjsKKwor
CXN0a19jcmVhdGVfc3lzZnNfZmlsZXMoZGV2LT52ZGV2KTsKIAl1c2JfYXV0b3BtX2VuYWJsZShk
ZXYtPmludGVyZmFjZSk7CiAKIAlyZXR1cm4gMDsKKworZXJyb3JfdmRldjoKKwl2aWRlb19kZXZp
Y2VfcmVsZWFzZShkZXYtPnZkZXYpOworZXJyb3I6CisJa3JlZl9wdXQoJmRldi0+a3JlZiwgc3Rr
X2NhbWVyYV9jbGVhbnVwKTsKKwlyZXR1cm4gZXJyOwogfQogCiBzdGF0aWMgdm9pZCBzdGtfY2Ft
ZXJhX2Rpc2Nvbm5lY3Qoc3RydWN0IHVzYl9pbnRlcmZhY2UgKmludGVyZmFjZSkKQEAgLTE0NjYs
NyArMTQzNiwxMiBAQCBzdGF0aWMgdm9pZCBzdGtfY2FtZXJhX2Rpc2Nvbm5lY3Qoc3RydWN0IHVz
Yl9pbnRlcmZhY2UgKmludGVyZmFjZSkKIAl1bnNldF9wcmVzZW50KGRldik7CiAKIAl3YWtlX3Vw
X2ludGVycnVwdGlibGUoJmRldi0+d2FpdF9mcmFtZSk7Ci0Jc3RrX3JlbW92ZV9zeXNmc19maWxl
cygmZGV2LT52ZGV2KTsKKwlzdGtfcmVtb3ZlX3N5c2ZzX2ZpbGVzKGRldi0+dmRldik7CisKKwlT
VEtfSU5GTygiU3ludGVrIFVTQjIuMCBDYW1lcmEgcmVsZWFzZSByZXNvdXJjZXMiCisJCSIgdmlk
ZW8gZGV2aWNlIC9kZXYvdmlkZW8lZFxuIiwgZGV2LT52ZGV2LT5taW5vcik7CisKKwl2aWRlb191
bnJlZ2lzdGVyX2RldmljZShkZXYtPnZkZXYpOwogCiAJa3JlZl9wdXQoJmRldi0+a3JlZiwgc3Rr
X2NhbWVyYV9jbGVhbnVwKTsKIH0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWVkaWEvdmlkZW8vc3Rr
LXdlYmNhbS5oIGIvZHJpdmVycy9tZWRpYS92aWRlby9zdGstd2ViY2FtLmgKaW5kZXggZGY0ZGZl
Zi4uODQyNTdmZSAxMDA2NDQKLS0tIGEvZHJpdmVycy9tZWRpYS92aWRlby9zdGstd2ViY2FtLmgK
KysrIGIvZHJpdmVycy9tZWRpYS92aWRlby9zdGstd2ViY2FtLmgKQEAgLTkxLDcgKzkxLDcgQEAg
c3RydWN0IHJlZ3ZhbCB7CiB9OwogCiBzdHJ1Y3Qgc3RrX2NhbWVyYSB7Ci0Jc3RydWN0IHZpZGVv
X2RldmljZSB2ZGV2OworCXN0cnVjdCB2aWRlb19kZXZpY2UgKnZkZXY7CiAJc3RydWN0IHVzYl9k
ZXZpY2UgKnVkZXY7CiAJc3RydWN0IHVzYl9pbnRlcmZhY2UgKmludGVyZmFjZTsKIAlpbnQgd2Vi
Y2FtX21vZGVsOwpAQCAtMTIyLDcgKzEyMiw2IEBAIHN0cnVjdCBzdGtfY2FtZXJhIHsKIH07CiAK
ICNkZWZpbmUgdG9fc3RrX2NhbWVyYShkKSBjb250YWluZXJfb2YoZCwgc3RydWN0IHN0a19jYW1l
cmEsIGtyZWYpCi0jZGVmaW5lIHZkZXZfdG9fY2FtZXJhKGQpIGNvbnRhaW5lcl9vZihkLCBzdHJ1
Y3Qgc3RrX2NhbWVyYSwgdmRldikKIAogdm9pZCBzdGtfY2FtZXJhX2RlbGV0ZShzdHJ1Y3Qga3Jl
ZiAqKTsKIGludCBzdGtfY2FtZXJhX3dyaXRlX3JlZyhzdHJ1Y3Qgc3RrX2NhbWVyYSAqLCB1MTYs
IHU4KTsKLS0gCjEuNS41LjEKCg==
------=_Part_25552_22059720.1214609763765
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
------=_Part_25552_22059720.1214609763765--
