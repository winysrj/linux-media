Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8U0SG4P001958
	for <video4linux-list@redhat.com>; Mon, 29 Sep 2008 20:28:16 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.155])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8U0S5Sq011328
	for <video4linux-list@redhat.com>; Mon, 29 Sep 2008 20:28:05 -0400
Received: by fg-out-1718.google.com with SMTP id e21so1711841fga.7
	for <video4linux-list@redhat.com>; Mon, 29 Sep 2008 17:28:04 -0700 (PDT)
Message-ID: <30353c3d0809291728u120b75ffhd45aea94b979f12e@mail.gmail.com>
Date: Mon, 29 Sep 2008 20:28:04 -0400
From: "David Ellingsworth" <david@identd.dyndns.org>
To: v4l <video4linux-list@redhat.com>,
	"Jaime Velasco Juan" <jsagarribay@gmail.com>,
	"Mauro Carvalho Chehab" <mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_26732_23968454.1222734484581"
Cc: 
Subject: [PATCH 2/3] stkwebcam: free via video_device release callback
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

------=_Part_26732_23968454.1222734484581
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

>From da738165054dbf82470b947017c10b09ae779162 Mon Sep 17 00:00:00 2001
From: David Ellingsworth <david@identd.dyndns.org>
Date: Mon, 29 Sep 2008 19:59:46 -0400
Subject: [PATCH] stkwebcam: free via video_device release callback


Signed-off-by: David Ellingsworth <david@identd.dyndns.org>
---
 drivers/media/video/stk-webcam.c |   45 +++++++++++++++----------------------
 drivers/media/video/stk-webcam.h |    3 --
 2 files changed, 18 insertions(+), 30 deletions(-)

diff --git a/drivers/media/video/stk-webcam.c b/drivers/media/video/stk-webcam.c
index 3198549..442dcd2 100644
--- a/drivers/media/video/stk-webcam.c
+++ b/drivers/media/video/stk-webcam.c
@@ -27,7 +27,6 @@
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
-#include <linux/kref.h>

 #include <linux/usb.h>
 #include <linux/mm.h>
@@ -65,22 +64,6 @@ static struct usb_device_id stkwebcam_table[] = {
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
@@ -695,7 +678,6 @@ static int v4l_stk_open(struct inode *inode,
struct file *fp)
 		return -ENXIO;
 	}
 	fp->private_data = vdev;
-	kref_get(&dev->kref);
 	usb_autopm_get_interface(dev->interface);
 	unlock_kernel();

@@ -727,8 +709,6 @@ static int v4l_stk_release(struct inode *inode,
struct file *fp)
 	if(is_present(dev))
 		usb_autopm_put_interface(dev->interface);

-	kref_put(&dev->kref, stk_camera_cleanup);
-
 	return 0;
 }

@@ -1355,6 +1335,12 @@ static const struct v4l2_ioctl_ops v4l_stk_ioctl_ops = {

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
@@ -1392,7 +1378,7 @@ static int stk_camera_probe(struct usb_interface
*interface,
 		const struct usb_device_id *id)
 {
 	int i;
-	int err;
+	int err = 0;

 	struct stk_camera *dev = NULL;
 	struct usb_device *udev = interface_to_usbdev(interface);
@@ -1405,7 +1391,6 @@ static int stk_camera_probe(struct usb_interface
*interface,
 		return -ENOMEM;
 	}

-	kref_init(&dev->kref);
 	spin_lock_init(&dev->spinlock);
 	init_waitqueue_head(&dev->wait_frame);

@@ -1438,8 +1423,8 @@ static int stk_camera_probe(struct usb_interface
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
@@ -1453,14 +1438,17 @@ static int stk_camera_probe(struct
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
@@ -1473,7 +1461,10 @@ static void stk_camera_disconnect(struct
usb_interface *interface)
 	wake_up_interruptible(&dev->wait_frame);
 	stk_remove_sysfs_files(&dev->vdev);

-	kref_put(&dev->kref, stk_camera_cleanup);
+	STK_INFO("Syntek USB2.0 Camera release resources "
+		"video device /dev/video%d\n", dev->vdev.minor);
+
+	video_unregister_device(&dev->vdev);
 }

 #ifdef CONFIG_PM
diff --git a/drivers/media/video/stk-webcam.h b/drivers/media/video/stk-webcam.h
index df4dfef..9f67366 100644
--- a/drivers/media/video/stk-webcam.h
+++ b/drivers/media/video/stk-webcam.h
@@ -99,7 +99,6 @@ struct stk_camera {

 	u8 isoc_ep;

-	struct kref kref;
 	/* Not sure if this is right */
 	atomic_t urbs_used;

@@ -121,10 +120,8 @@ struct stk_camera {
 	unsigned sequence;
 };

-#define to_stk_camera(d) container_of(d, struct stk_camera, kref)
 #define vdev_to_camera(d) container_of(d, struct stk_camera, vdev)

-void stk_camera_delete(struct kref *);
 int stk_camera_write_reg(struct stk_camera *, u16, u8);
 int stk_camera_read_reg(struct stk_camera *, u16, int *);

-- 
1.5.6

------=_Part_26732_23968454.1222734484581
Content-Type: text/x-diff;
	name=0002-stkwebcam-free-via-video_device-release-callback.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_flpsi3830
Content-Disposition: attachment;
	filename=0002-stkwebcam-free-via-video_device-release-callback.patch

RnJvbSBkYTczODE2NTA1NGRiZjgyNDcwYjk0NzAxN2MxMGIwOWFlNzc5MTYyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBEYXZpZCBFbGxpbmdzd29ydGggPGRhdmlkQGlkZW50ZC5keW5k
bnMub3JnPgpEYXRlOiBNb24sIDI5IFNlcCAyMDA4IDE5OjU5OjQ2IC0wNDAwClN1YmplY3Q6IFtQ
QVRDSF0gc3Rrd2ViY2FtOiBmcmVlIHZpYSB2aWRlb19kZXZpY2UgcmVsZWFzZSBjYWxsYmFjawoK
ClNpZ25lZC1vZmYtYnk6IERhdmlkIEVsbGluZ3N3b3J0aCA8ZGF2aWRAaWRlbnRkLmR5bmRucy5v
cmc+Ci0tLQogZHJpdmVycy9tZWRpYS92aWRlby9zdGstd2ViY2FtLmMgfCAgIDQ1ICsrKysrKysr
KysrKysrKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KIGRyaXZlcnMvbWVkaWEvdmlkZW8vc3RrLXdl
YmNhbS5oIHwgICAgMyAtLQogMiBmaWxlcyBjaGFuZ2VkLCAxOCBpbnNlcnRpb25zKCspLCAzMCBk
ZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL21lZGlhL3ZpZGVvL3N0ay13ZWJjYW0u
YyBiL2RyaXZlcnMvbWVkaWEvdmlkZW8vc3RrLXdlYmNhbS5jCmluZGV4IDMxOTg1NDkuLjQ0MmRj
ZDIgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbWVkaWEvdmlkZW8vc3RrLXdlYmNhbS5jCisrKyBiL2Ry
aXZlcnMvbWVkaWEvdmlkZW8vc3RrLXdlYmNhbS5jCkBAIC0yNyw3ICsyNyw2IEBACiAjaW5jbHVk
ZSA8bGludXgva2VybmVsLmg+CiAjaW5jbHVkZSA8bGludXgvZXJybm8uaD4KICNpbmNsdWRlIDxs
aW51eC9zbGFiLmg+Ci0jaW5jbHVkZSA8bGludXgva3JlZi5oPgogCiAjaW5jbHVkZSA8bGludXgv
dXNiLmg+CiAjaW5jbHVkZSA8bGludXgvbW0uaD4KQEAgLTY1LDIyICs2NCw2IEBAIHN0YXRpYyBz
dHJ1Y3QgdXNiX2RldmljZV9pZCBzdGt3ZWJjYW1fdGFibGVbXSA9IHsKIH07CiBNT0RVTEVfREVW
SUNFX1RBQkxFKHVzYiwgc3Rrd2ViY2FtX3RhYmxlKTsKIAotc3RhdGljIHZvaWQgc3RrX2NhbWVy
YV9jbGVhbnVwKHN0cnVjdCBrcmVmICprcmVmKQotewotCXN0cnVjdCBzdGtfY2FtZXJhICpkZXYg
PSB0b19zdGtfY2FtZXJhKGtyZWYpOwotCi0JU1RLX0lORk8oIlN5bnRlayBVU0IyLjAgQ2FtZXJh
IHJlbGVhc2UgcmVzb3VyY2VzIgotCQkiIHZpZGVvIGRldmljZSAvZGV2L3ZpZGVvJWRcbiIsIGRl
di0+dmRldi5taW5vcik7Ci0JdmlkZW9fdW5yZWdpc3Rlcl9kZXZpY2UoJmRldi0+dmRldik7Ci0J
dmlkZW9fc2V0X2RydmRhdGEoJmRldi0+dmRldiwgTlVMTCk7Ci0KLQlpZiAoZGV2LT5zaW9fYnVm
cyAhPSBOVUxMIHx8IGRldi0+aXNvYnVmcyAhPSBOVUxMKQotCQlTVEtfRVJST1IoIldlIGFyZSBs
ZWFraW5nIG1lbW9yeVxuIik7Ci0JdXNiX3B1dF9pbnRmKGRldi0+aW50ZXJmYWNlKTsKLQlrZnJl
ZShkZXYpOwotfQotCi0KIC8qCiAgKiBCYXNpYyBzdHVmZgogICovCkBAIC02OTUsNyArNjc4LDYg
QEAgc3RhdGljIGludCB2NGxfc3RrX29wZW4oc3RydWN0IGlub2RlICppbm9kZSwgc3RydWN0IGZp
bGUgKmZwKQogCQlyZXR1cm4gLUVOWElPOwogCX0KIAlmcC0+cHJpdmF0ZV9kYXRhID0gdmRldjsK
LQlrcmVmX2dldCgmZGV2LT5rcmVmKTsKIAl1c2JfYXV0b3BtX2dldF9pbnRlcmZhY2UoZGV2LT5p
bnRlcmZhY2UpOwogCXVubG9ja19rZXJuZWwoKTsKIApAQCAtNzI3LDggKzcwOSw2IEBAIHN0YXRp
YyBpbnQgdjRsX3N0a19yZWxlYXNlKHN0cnVjdCBpbm9kZSAqaW5vZGUsIHN0cnVjdCBmaWxlICpm
cCkKIAlpZihpc19wcmVzZW50KGRldikpCiAJCXVzYl9hdXRvcG1fcHV0X2ludGVyZmFjZShkZXYt
PmludGVyZmFjZSk7CiAKLQlrcmVmX3B1dCgmZGV2LT5rcmVmLCBzdGtfY2FtZXJhX2NsZWFudXAp
OwotCiAJcmV0dXJuIDA7CiB9CiAKQEAgLTEzNTUsNiArMTMzNSwxMiBAQCBzdGF0aWMgY29uc3Qg
c3RydWN0IHY0bDJfaW9jdGxfb3BzIHY0bF9zdGtfaW9jdGxfb3BzID0gewogCiBzdGF0aWMgdm9p
ZCBzdGtfdjRsX2Rldl9yZWxlYXNlKHN0cnVjdCB2aWRlb19kZXZpY2UgKnZkKQogeworCXN0cnVj
dCBzdGtfY2FtZXJhICpkZXYgPSB2ZGV2X3RvX2NhbWVyYSh2ZCk7CisKKwlpZiAoZGV2LT5zaW9f
YnVmcyAhPSBOVUxMIHx8IGRldi0+aXNvYnVmcyAhPSBOVUxMKQorCQlTVEtfRVJST1IoIldlIGFy
ZSBsZWFraW5nIG1lbW9yeVxuIik7CisJdXNiX3B1dF9pbnRmKGRldi0+aW50ZXJmYWNlKTsKKwlr
ZnJlZShkZXYpOwogfQogCiBzdGF0aWMgc3RydWN0IHZpZGVvX2RldmljZSBzdGtfdjRsX2RhdGEg
PSB7CkBAIC0xMzkyLDcgKzEzNzgsNyBAQCBzdGF0aWMgaW50IHN0a19jYW1lcmFfcHJvYmUoc3Ry
dWN0IHVzYl9pbnRlcmZhY2UgKmludGVyZmFjZSwKIAkJY29uc3Qgc3RydWN0IHVzYl9kZXZpY2Vf
aWQgKmlkKQogewogCWludCBpOwotCWludCBlcnI7CisJaW50IGVyciA9IDA7CiAKIAlzdHJ1Y3Qg
c3RrX2NhbWVyYSAqZGV2ID0gTlVMTDsKIAlzdHJ1Y3QgdXNiX2RldmljZSAqdWRldiA9IGludGVy
ZmFjZV90b191c2JkZXYoaW50ZXJmYWNlKTsKQEAgLTE0MDUsNyArMTM5MSw2IEBAIHN0YXRpYyBp
bnQgc3RrX2NhbWVyYV9wcm9iZShzdHJ1Y3QgdXNiX2ludGVyZmFjZSAqaW50ZXJmYWNlLAogCQly
ZXR1cm4gLUVOT01FTTsKIAl9CiAKLQlrcmVmX2luaXQoJmRldi0+a3JlZik7CiAJc3Bpbl9sb2Nr
X2luaXQoJmRldi0+c3BpbmxvY2spOwogCWluaXRfd2FpdHF1ZXVlX2hlYWQoJmRldi0+d2FpdF9m
cmFtZSk7CiAKQEAgLTE0MzgsOCArMTQyMyw4IEBAIHN0YXRpYyBpbnQgc3RrX2NhbWVyYV9wcm9i
ZShzdHJ1Y3QgdXNiX2ludGVyZmFjZSAqaW50ZXJmYWNlLAogCX0KIAlpZiAoIWRldi0+aXNvY19l
cCkgewogCQlTVEtfRVJST1IoIkNvdWxkIG5vdCBmaW5kIGlzb2MtaW4gZW5kcG9pbnQiKTsKLQkJ
a3JlZl9wdXQoJmRldi0+a3JlZiwgc3RrX2NhbWVyYV9jbGVhbnVwKTsKLQkJcmV0dXJuIC1FTk9E
RVY7CisJCWVyciA9IC1FTk9ERVY7CisJCWdvdG8gZXJyb3I7CiAJfQogCWRldi0+dnNldHRpbmdz
LmJyaWdodG5lc3MgPSAweDdmZmY7CiAJZGV2LT52c2V0dGluZ3MucGFsZXR0ZSA9IFY0TDJfUElY
X0ZNVF9SR0I1NjU7CkBAIC0xNDUzLDE0ICsxNDM4LDE3IEBAIHN0YXRpYyBpbnQgc3RrX2NhbWVy
YV9wcm9iZShzdHJ1Y3QgdXNiX2ludGVyZmFjZSAqaW50ZXJmYWNlLAogCiAJZXJyID0gc3RrX3Jl
Z2lzdGVyX3ZpZGVvX2RldmljZShkZXYpOwogCWlmIChlcnIpIHsKLQkJa3JlZl9wdXQoJmRldi0+
a3JlZiwgc3RrX2NhbWVyYV9jbGVhbnVwKTsKLQkJcmV0dXJuIGVycjsKKwkJZ290byBlcnJvcjsK
IAl9CiAKIAlzdGtfY3JlYXRlX3N5c2ZzX2ZpbGVzKCZkZXYtPnZkZXYpOwogCXVzYl9hdXRvcG1f
ZW5hYmxlKGRldi0+aW50ZXJmYWNlKTsKIAogCXJldHVybiAwOworCitlcnJvcjoKKwlrZnJlZShk
ZXYpOworCXJldHVybiBlcnI7CiB9CiAKIHN0YXRpYyB2b2lkIHN0a19jYW1lcmFfZGlzY29ubmVj
dChzdHJ1Y3QgdXNiX2ludGVyZmFjZSAqaW50ZXJmYWNlKQpAQCAtMTQ3Myw3ICsxNDYxLDEwIEBA
IHN0YXRpYyB2b2lkIHN0a19jYW1lcmFfZGlzY29ubmVjdChzdHJ1Y3QgdXNiX2ludGVyZmFjZSAq
aW50ZXJmYWNlKQogCXdha2VfdXBfaW50ZXJydXB0aWJsZSgmZGV2LT53YWl0X2ZyYW1lKTsKIAlz
dGtfcmVtb3ZlX3N5c2ZzX2ZpbGVzKCZkZXYtPnZkZXYpOwogCi0Ja3JlZl9wdXQoJmRldi0+a3Jl
Ziwgc3RrX2NhbWVyYV9jbGVhbnVwKTsKKwlTVEtfSU5GTygiU3ludGVrIFVTQjIuMCBDYW1lcmEg
cmVsZWFzZSByZXNvdXJjZXMgIgorCQkidmlkZW8gZGV2aWNlIC9kZXYvdmlkZW8lZFxuIiwgZGV2
LT52ZGV2Lm1pbm9yKTsKKworCXZpZGVvX3VucmVnaXN0ZXJfZGV2aWNlKCZkZXYtPnZkZXYpOwog
fQogCiAjaWZkZWYgQ09ORklHX1BNCmRpZmYgLS1naXQgYS9kcml2ZXJzL21lZGlhL3ZpZGVvL3N0
ay13ZWJjYW0uaCBiL2RyaXZlcnMvbWVkaWEvdmlkZW8vc3RrLXdlYmNhbS5oCmluZGV4IGRmNGRm
ZWYuLjlmNjczNjYgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbWVkaWEvdmlkZW8vc3RrLXdlYmNhbS5o
CisrKyBiL2RyaXZlcnMvbWVkaWEvdmlkZW8vc3RrLXdlYmNhbS5oCkBAIC05OSw3ICs5OSw2IEBA
IHN0cnVjdCBzdGtfY2FtZXJhIHsKIAogCXU4IGlzb2NfZXA7CiAKLQlzdHJ1Y3Qga3JlZiBrcmVm
OwogCS8qIE5vdCBzdXJlIGlmIHRoaXMgaXMgcmlnaHQgKi8KIAlhdG9taWNfdCB1cmJzX3VzZWQ7
CiAKQEAgLTEyMSwxMCArMTIwLDggQEAgc3RydWN0IHN0a19jYW1lcmEgewogCXVuc2lnbmVkIHNl
cXVlbmNlOwogfTsKIAotI2RlZmluZSB0b19zdGtfY2FtZXJhKGQpIGNvbnRhaW5lcl9vZihkLCBz
dHJ1Y3Qgc3RrX2NhbWVyYSwga3JlZikKICNkZWZpbmUgdmRldl90b19jYW1lcmEoZCkgY29udGFp
bmVyX29mKGQsIHN0cnVjdCBzdGtfY2FtZXJhLCB2ZGV2KQogCi12b2lkIHN0a19jYW1lcmFfZGVs
ZXRlKHN0cnVjdCBrcmVmICopOwogaW50IHN0a19jYW1lcmFfd3JpdGVfcmVnKHN0cnVjdCBzdGtf
Y2FtZXJhICosIHUxNiwgdTgpOwogaW50IHN0a19jYW1lcmFfcmVhZF9yZWcoc3RydWN0IHN0a19j
YW1lcmEgKiwgdTE2LCBpbnQgKik7CiAKLS0gCjEuNS42Cgo=
------=_Part_26732_23968454.1222734484581
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
------=_Part_26732_23968454.1222734484581--
