Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8U0Trw0002370
	for <video4linux-list@redhat.com>; Mon, 29 Sep 2008 20:29:54 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.157])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8U0TpiU012031
	for <video4linux-list@redhat.com>; Mon, 29 Sep 2008 20:29:52 -0400
Received: by fg-out-1718.google.com with SMTP id e21so1712268fga.7
	for <video4linux-list@redhat.com>; Mon, 29 Sep 2008 17:29:51 -0700 (PDT)
Message-ID: <30353c3d0809291729t15be3e4cjee3198a016dc7474@mail.gmail.com>
Date: Mon, 29 Sep 2008 20:29:51 -0400
From: "David Ellingsworth" <david@identd.dyndns.org>
To: v4l <video4linux-list@redhat.com>,
	"Jaime Velasco Juan" <jsagarribay@gmail.com>,
	"Mauro Carvalho Chehab" <mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_26761_28604461.1222734591289"
Cc: 
Subject: [PATCH 3/3] stkwebcam: simplify access to stk_camera struct
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

------=_Part_26761_28604461.1222734591289
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

>From 4a7648e95119fb923f9c5656ea7512ae624dc4ba Mon Sep 17 00:00:00 2001
From: David Ellingsworth <david@identd.dyndns.org>
Date: Mon, 29 Sep 2008 20:00:26 -0400
Subject: [PATCH] stkwebcam: simplify access to stk_camera struct


Signed-off-by: David Ellingsworth <david@identd.dyndns.org>
---
 drivers/media/video/stk-webcam.c |   40 ++++---------------------------------
 1 files changed, 5 insertions(+), 35 deletions(-)

diff --git a/drivers/media/video/stk-webcam.c b/drivers/media/video/stk-webcam.c
index 442dcd2..8ca9a89 100644
--- a/drivers/media/video/stk-webcam.c
+++ b/drivers/media/video/stk-webcam.c
@@ -677,7 +677,7 @@ static int v4l_stk_open(struct inode *inode,
struct file *fp)
 		unlock_kernel();
 		return -ENXIO;
 	}
-	fp->private_data = vdev;
+	fp->private_data = dev;
 	usb_autopm_get_interface(dev->interface);
 	unlock_kernel();

@@ -686,19 +686,7 @@ static int v4l_stk_open(struct inode *inode,
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

 	if (dev->owner == fp) {
 		stk_stop_stream(dev);
@@ -718,14 +706,8 @@ static ssize_t v4l_stk_read(struct file *fp, char
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
@@ -784,15 +766,8 @@ static ssize_t v4l_stk_read(struct file *fp, char
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

@@ -830,16 +805,12 @@ static int v4l_stk_mmap(struct file *fp, struct
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
@@ -1361,7 +1332,6 @@ static int stk_register_video_device(struct
stk_camera *dev)
 	dev->vdev = stk_v4l_data;
 	dev->vdev.debug = debug;
 	dev->vdev.parent = &dev->interface->dev;
-	video_set_drvdata(&dev->vdev, dev);
 	err = video_register_device(&dev->vdev, VFL_TYPE_GRABBER, -1);
 	if (err)
 		STK_ERROR("v4l registration failed\n");
-- 
1.5.6

------=_Part_26761_28604461.1222734591289
Content-Type: text/x-diff;
	name=0003-stkwebcam-simplify-access-to-stk_camera-struct.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_flpsko3g0
Content-Disposition: attachment;
	filename=0003-stkwebcam-simplify-access-to-stk_camera-struct.patch

RnJvbSA0YTc2NDhlOTUxMTlmYjkyM2Y5YzU2NTZlYTc1MTJhZTYyNGRjNGJhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBEYXZpZCBFbGxpbmdzd29ydGggPGRhdmlkQGlkZW50ZC5keW5k
bnMub3JnPgpEYXRlOiBNb24sIDI5IFNlcCAyMDA4IDIwOjAwOjI2IC0wNDAwClN1YmplY3Q6IFtQ
QVRDSF0gc3Rrd2ViY2FtOiBzaW1wbGlmeSBhY2Nlc3MgdG8gc3RrX2NhbWVyYSBzdHJ1Y3QKCgpT
aWduZWQtb2ZmLWJ5OiBEYXZpZCBFbGxpbmdzd29ydGggPGRhdmlkQGlkZW50ZC5keW5kbnMub3Jn
PgotLS0KIGRyaXZlcnMvbWVkaWEvdmlkZW8vc3RrLXdlYmNhbS5jIHwgICA0MCArKysrLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tCiAxIGZpbGVzIGNoYW5nZWQsIDUgaW5zZXJ0aW9u
cygrKSwgMzUgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZWRpYS92aWRlby9z
dGstd2ViY2FtLmMgYi9kcml2ZXJzL21lZGlhL3ZpZGVvL3N0ay13ZWJjYW0uYwppbmRleCA0NDJk
Y2QyLi44Y2E5YTg5IDEwMDY0NAotLS0gYS9kcml2ZXJzL21lZGlhL3ZpZGVvL3N0ay13ZWJjYW0u
YworKysgYi9kcml2ZXJzL21lZGlhL3ZpZGVvL3N0ay13ZWJjYW0uYwpAQCAtNjc3LDcgKzY3Nyw3
IEBAIHN0YXRpYyBpbnQgdjRsX3N0a19vcGVuKHN0cnVjdCBpbm9kZSAqaW5vZGUsIHN0cnVjdCBm
aWxlICpmcCkKIAkJdW5sb2NrX2tlcm5lbCgpOwogCQlyZXR1cm4gLUVOWElPOwogCX0KLQlmcC0+
cHJpdmF0ZV9kYXRhID0gdmRldjsKKwlmcC0+cHJpdmF0ZV9kYXRhID0gZGV2OwogCXVzYl9hdXRv
cG1fZ2V0X2ludGVyZmFjZShkZXYtPmludGVyZmFjZSk7CiAJdW5sb2NrX2tlcm5lbCgpOwogCkBA
IC02ODYsMTkgKzY4Niw3IEBAIHN0YXRpYyBpbnQgdjRsX3N0a19vcGVuKHN0cnVjdCBpbm9kZSAq
aW5vZGUsIHN0cnVjdCBmaWxlICpmcCkKIAogc3RhdGljIGludCB2NGxfc3RrX3JlbGVhc2Uoc3Ry
dWN0IGlub2RlICppbm9kZSwgc3RydWN0IGZpbGUgKmZwKQogewotCXN0cnVjdCBzdGtfY2FtZXJh
ICpkZXY7Ci0Jc3RydWN0IHZpZGVvX2RldmljZSAqdmRldjsKLQotCXZkZXYgPSB2aWRlb19kZXZk
YXRhKGZwKTsKLQlpZiAodmRldiA9PSBOVUxMKSB7Ci0JCVNUS19FUlJPUigidjRsX3JlbGVhc2Ug
Y2FsbGVkIHcvbyB2aWRlbyBkZXZkYXRhXG4iKTsKLQkJcmV0dXJuIC1FRkFVTFQ7Ci0JfQotCWRl
diA9IHZkZXZfdG9fY2FtZXJhKHZkZXYpOwotCWlmIChkZXYgPT0gTlVMTCkgewotCQlTVEtfRVJS
T1IoInY0bF9yZWxlYXNlIGNhbGxlZCBvbiByZW1vdmVkIGRldmljZVxuIik7Ci0JCXJldHVybiAt
RU5PREVWOwotCX0KKwlzdHJ1Y3Qgc3RrX2NhbWVyYSAqZGV2ID0gZnAtPnByaXZhdGVfZGF0YTsK
IAogCWlmIChkZXYtPm93bmVyID09IGZwKSB7CiAJCXN0a19zdG9wX3N0cmVhbShkZXYpOwpAQCAt
NzE4LDE0ICs3MDYsOCBAQCBzdGF0aWMgc3NpemVfdCB2NGxfc3RrX3JlYWQoc3RydWN0IGZpbGUg
KmZwLCBjaGFyIF9fdXNlciAqYnVmLAogCWludCBpOwogCWludCByZXQ7CiAJdW5zaWduZWQgbG9u
ZyBmbGFnczsKLQlzdHJ1Y3Qgc3RrX2NhbWVyYSAqZGV2OwotCXN0cnVjdCB2aWRlb19kZXZpY2Ug
KnZkZXY7CiAJc3RydWN0IHN0a19zaW9fYnVmZmVyICpzYnVmOwotCi0JdmRldiA9IHZpZGVvX2Rl
dmRhdGEoZnApOwotCWlmICh2ZGV2ID09IE5VTEwpCi0JCXJldHVybiAtRUZBVUxUOwotCWRldiA9
IHZkZXZfdG9fY2FtZXJhKHZkZXYpOworCXN0cnVjdCBzdGtfY2FtZXJhICpkZXYgPSBmcC0+cHJp
dmF0ZV9kYXRhOwogCiAJaWYgKGRldiA9PSBOVUxMKQogCQlyZXR1cm4gLUVJTzsKQEAgLTc4NCwx
NSArNzY2LDggQEAgc3RhdGljIHNzaXplX3QgdjRsX3N0a19yZWFkKHN0cnVjdCBmaWxlICpmcCwg
Y2hhciBfX3VzZXIgKmJ1ZiwKIAogc3RhdGljIHVuc2lnbmVkIGludCB2NGxfc3RrX3BvbGwoc3Ry
dWN0IGZpbGUgKmZwLCBwb2xsX3RhYmxlICp3YWl0KQogewotCXN0cnVjdCBzdGtfY2FtZXJhICpk
ZXY7Ci0Jc3RydWN0IHZpZGVvX2RldmljZSAqdmRldjsKLQotCXZkZXYgPSB2aWRlb19kZXZkYXRh
KGZwKTsKLQotCWlmICh2ZGV2ID09IE5VTEwpCi0JCXJldHVybiAtRUZBVUxUOworCXN0cnVjdCBz
dGtfY2FtZXJhICpkZXYgPSBmcC0+cHJpdmF0ZV9kYXRhOwogCi0JZGV2ID0gdmRldl90b19jYW1l
cmEodmRldik7CiAJaWYgKGRldiA9PSBOVUxMKQogCQlyZXR1cm4gLUVOT0RFVjsKIApAQCAtODMw
LDE2ICs4MDUsMTIgQEAgc3RhdGljIGludCB2NGxfc3RrX21tYXAoc3RydWN0IGZpbGUgKmZwLCBz
dHJ1Y3Qgdm1fYXJlYV9zdHJ1Y3QgKnZtYSkKIAl1bnNpZ25lZCBpbnQgaTsKIAlpbnQgcmV0Owog
CXVuc2lnbmVkIGxvbmcgb2Zmc2V0ID0gdm1hLT52bV9wZ29mZiA8PCBQQUdFX1NISUZUOwotCXN0
cnVjdCBzdGtfY2FtZXJhICpkZXY7Ci0Jc3RydWN0IHZpZGVvX2RldmljZSAqdmRldjsKKwlzdHJ1
Y3Qgc3RrX2NhbWVyYSAqZGV2ID0gZnAtPnByaXZhdGVfZGF0YTsKIAlzdHJ1Y3Qgc3RrX3Npb19i
dWZmZXIgKnNidWYgPSBOVUxMOwogCiAJaWYgKCEodm1hLT52bV9mbGFncyAmIFZNX1dSSVRFKSB8
fCAhKHZtYS0+dm1fZmxhZ3MgJiBWTV9TSEFSRUQpKQogCQlyZXR1cm4gLUVJTlZBTDsKIAotCXZk
ZXYgPSB2aWRlb19kZXZkYXRhKGZwKTsKLQlkZXYgPSB2ZGV2X3RvX2NhbWVyYSh2ZGV2KTsKLQog
CWZvciAoaSA9IDA7IGkgPCBkZXYtPm5fc2J1ZnM7IGkrKykgewogCQlpZiAoZGV2LT5zaW9fYnVm
c1tpXS52NGxidWYubS5vZmZzZXQgPT0gb2Zmc2V0KSB7CiAJCQlzYnVmID0gZGV2LT5zaW9fYnVm
cyArIGk7CkBAIC0xMzYxLDcgKzEzMzIsNiBAQCBzdGF0aWMgaW50IHN0a19yZWdpc3Rlcl92aWRl
b19kZXZpY2Uoc3RydWN0IHN0a19jYW1lcmEgKmRldikKIAlkZXYtPnZkZXYgPSBzdGtfdjRsX2Rh
dGE7CiAJZGV2LT52ZGV2LmRlYnVnID0gZGVidWc7CiAJZGV2LT52ZGV2LnBhcmVudCA9ICZkZXYt
PmludGVyZmFjZS0+ZGV2OwotCXZpZGVvX3NldF9kcnZkYXRhKCZkZXYtPnZkZXYsIGRldik7CiAJ
ZXJyID0gdmlkZW9fcmVnaXN0ZXJfZGV2aWNlKCZkZXYtPnZkZXYsIFZGTF9UWVBFX0dSQUJCRVIs
IC0xKTsKIAlpZiAoZXJyKQogCQlTVEtfRVJST1IoInY0bCByZWdpc3RyYXRpb24gZmFpbGVkXG4i
KTsKLS0gCjEuNS42Cgo=
------=_Part_26761_28604461.1222734591289
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
------=_Part_26761_28604461.1222734591289--
