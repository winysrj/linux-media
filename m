Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8UN4PUV002599
	for <video4linux-list@redhat.com>; Tue, 30 Sep 2008 19:04:25 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.156])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8UN4D7T016759
	for <video4linux-list@redhat.com>; Tue, 30 Sep 2008 19:04:14 -0400
Received: by fg-out-1718.google.com with SMTP id e21so209597fga.7
	for <video4linux-list@redhat.com>; Tue, 30 Sep 2008 16:04:13 -0700 (PDT)
Message-ID: <30353c3d0809301604p393ee1bbh29d8b9f3be424f22@mail.gmail.com>
Date: Tue, 30 Sep 2008 19:04:13 -0400
From: "David Ellingsworth" <david@identd.dyndns.org>
To: v4l <video4linux-list@redhat.com>,
	"Jaime Velasco Juan" <jsagarribay@gmail.com>,
	"Mauro Carvalho Chehab" <mchehab@redhat.com>
In-Reply-To: <30353c3d0809301329g505d88deu981ef9086bc81d6c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_43447_10981909.1222815853204"
References: <30353c3d0809291729t15be3e4cjee3198a016dc7474@mail.gmail.com>
	<30353c3d0809301329g505d88deu981ef9086bc81d6c@mail.gmail.com>
Cc: 
Subject: Re: [PATCH 3/3] stkwebcam: simplify access to stk_camera struct
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

------=_Part_43447_10981909.1222815853204
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Here is the updated patch. It removes the now unnecessary checks for
NULL in the read and poll functions.

Regards,

David Ellingsworth

>From b11cdb579a64776eec1c87b0e3edbba23567a2fc Mon Sep 17 00:00:00 2001
From: David Ellingsworth <david@identd.dyndns.org>
Date: Tue, 30 Sep 2008 18:54:05 -0400
Subject: [PATCH] stkwebcam: simplify access to stk_camera struct


Signed-off-by: David Ellingsworth <david@identd.dyndns.org>
---
 drivers/media/video/stk-webcam.c |   46 ++++---------------------------------
 1 files changed, 5 insertions(+), 41 deletions(-)

diff --git a/drivers/media/video/stk-webcam.c b/drivers/media/video/stk-webcam.c
index 442dcd2..edaea49 100644
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
@@ -718,17 +706,8 @@ static ssize_t v4l_stk_read(struct file *fp, char
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
-
-	if (dev == NULL)
-		return -EIO;
+	struct stk_camera *dev = fp->private_data;

 	if (!is_present(dev))
 		return -EIO;
@@ -784,17 +763,7 @@ static ssize_t v4l_stk_read(struct file *fp, char
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
-
-	dev = vdev_to_camera(vdev);
-	if (dev == NULL)
-		return -ENODEV;
+	struct stk_camera *dev = fp->private_data;

 	poll_wait(fp, &dev->wait_frame, wait);

@@ -830,16 +799,12 @@ static int v4l_stk_mmap(struct file *fp, struct
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
@@ -1361,7 +1326,6 @@ static int stk_register_video_device(struct
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

------=_Part_43447_10981909.1222815853204
Content-Type: text/x-diff;
	name=0003-stkwebcam-simplify-access-to-stk_camera-struct.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_flr4ws2p0
Content-Disposition: attachment;
	filename=0003-stkwebcam-simplify-access-to-stk_camera-struct.patch

RnJvbSBiMTFjZGI1NzlhNjQ3NzZlZWMxYzg3YjBlM2VkYmJhMjM1NjdhMmZjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBEYXZpZCBFbGxpbmdzd29ydGggPGRhdmlkQGlkZW50ZC5keW5k
bnMub3JnPgpEYXRlOiBUdWUsIDMwIFNlcCAyMDA4IDE4OjU0OjA1IC0wNDAwClN1YmplY3Q6IFtQ
QVRDSF0gc3Rrd2ViY2FtOiBzaW1wbGlmeSBhY2Nlc3MgdG8gc3RrX2NhbWVyYSBzdHJ1Y3QKCgpT
aWduZWQtb2ZmLWJ5OiBEYXZpZCBFbGxpbmdzd29ydGggPGRhdmlkQGlkZW50ZC5keW5kbnMub3Jn
PgotLS0KIGRyaXZlcnMvbWVkaWEvdmlkZW8vc3RrLXdlYmNhbS5jIHwgICA0NiArKysrLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tCiAxIGZpbGVzIGNoYW5nZWQsIDUgaW5zZXJ0aW9u
cygrKSwgNDEgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZWRpYS92aWRlby9z
dGstd2ViY2FtLmMgYi9kcml2ZXJzL21lZGlhL3ZpZGVvL3N0ay13ZWJjYW0uYwppbmRleCA0NDJk
Y2QyLi5lZGFlYTQ5IDEwMDY0NAotLS0gYS9kcml2ZXJzL21lZGlhL3ZpZGVvL3N0ay13ZWJjYW0u
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
NzE4LDE3ICs3MDYsOCBAQCBzdGF0aWMgc3NpemVfdCB2NGxfc3RrX3JlYWQoc3RydWN0IGZpbGUg
KmZwLCBjaGFyIF9fdXNlciAqYnVmLAogCWludCBpOwogCWludCByZXQ7CiAJdW5zaWduZWQgbG9u
ZyBmbGFnczsKLQlzdHJ1Y3Qgc3RrX2NhbWVyYSAqZGV2OwotCXN0cnVjdCB2aWRlb19kZXZpY2Ug
KnZkZXY7CiAJc3RydWN0IHN0a19zaW9fYnVmZmVyICpzYnVmOwotCi0JdmRldiA9IHZpZGVvX2Rl
dmRhdGEoZnApOwotCWlmICh2ZGV2ID09IE5VTEwpCi0JCXJldHVybiAtRUZBVUxUOwotCWRldiA9
IHZkZXZfdG9fY2FtZXJhKHZkZXYpOwotCi0JaWYgKGRldiA9PSBOVUxMKQotCQlyZXR1cm4gLUVJ
TzsKKwlzdHJ1Y3Qgc3RrX2NhbWVyYSAqZGV2ID0gZnAtPnByaXZhdGVfZGF0YTsKIAogCWlmICgh
aXNfcHJlc2VudChkZXYpKQogCQlyZXR1cm4gLUVJTzsKQEAgLTc4NCwxNyArNzYzLDcgQEAgc3Rh
dGljIHNzaXplX3QgdjRsX3N0a19yZWFkKHN0cnVjdCBmaWxlICpmcCwgY2hhciBfX3VzZXIgKmJ1
ZiwKIAogc3RhdGljIHVuc2lnbmVkIGludCB2NGxfc3RrX3BvbGwoc3RydWN0IGZpbGUgKmZwLCBw
b2xsX3RhYmxlICp3YWl0KQogewotCXN0cnVjdCBzdGtfY2FtZXJhICpkZXY7Ci0Jc3RydWN0IHZp
ZGVvX2RldmljZSAqdmRldjsKLQotCXZkZXYgPSB2aWRlb19kZXZkYXRhKGZwKTsKLQotCWlmICh2
ZGV2ID09IE5VTEwpCi0JCXJldHVybiAtRUZBVUxUOwotCi0JZGV2ID0gdmRldl90b19jYW1lcmEo
dmRldik7Ci0JaWYgKGRldiA9PSBOVUxMKQotCQlyZXR1cm4gLUVOT0RFVjsKKwlzdHJ1Y3Qgc3Rr
X2NhbWVyYSAqZGV2ID0gZnAtPnByaXZhdGVfZGF0YTsKIAogCXBvbGxfd2FpdChmcCwgJmRldi0+
d2FpdF9mcmFtZSwgd2FpdCk7CiAKQEAgLTgzMCwxNiArNzk5LDEyIEBAIHN0YXRpYyBpbnQgdjRs
X3N0a19tbWFwKHN0cnVjdCBmaWxlICpmcCwgc3RydWN0IHZtX2FyZWFfc3RydWN0ICp2bWEpCiAJ
dW5zaWduZWQgaW50IGk7CiAJaW50IHJldDsKIAl1bnNpZ25lZCBsb25nIG9mZnNldCA9IHZtYS0+
dm1fcGdvZmYgPDwgUEFHRV9TSElGVDsKLQlzdHJ1Y3Qgc3RrX2NhbWVyYSAqZGV2OwotCXN0cnVj
dCB2aWRlb19kZXZpY2UgKnZkZXY7CisJc3RydWN0IHN0a19jYW1lcmEgKmRldiA9IGZwLT5wcml2
YXRlX2RhdGE7CiAJc3RydWN0IHN0a19zaW9fYnVmZmVyICpzYnVmID0gTlVMTDsKIAogCWlmICgh
KHZtYS0+dm1fZmxhZ3MgJiBWTV9XUklURSkgfHwgISh2bWEtPnZtX2ZsYWdzICYgVk1fU0hBUkVE
KSkKIAkJcmV0dXJuIC1FSU5WQUw7CiAKLQl2ZGV2ID0gdmlkZW9fZGV2ZGF0YShmcCk7Ci0JZGV2
ID0gdmRldl90b19jYW1lcmEodmRldik7Ci0KIAlmb3IgKGkgPSAwOyBpIDwgZGV2LT5uX3NidWZz
OyBpKyspIHsKIAkJaWYgKGRldi0+c2lvX2J1ZnNbaV0udjRsYnVmLm0ub2Zmc2V0ID09IG9mZnNl
dCkgewogCQkJc2J1ZiA9IGRldi0+c2lvX2J1ZnMgKyBpOwpAQCAtMTM2MSw3ICsxMzI2LDYgQEAg
c3RhdGljIGludCBzdGtfcmVnaXN0ZXJfdmlkZW9fZGV2aWNlKHN0cnVjdCBzdGtfY2FtZXJhICpk
ZXYpCiAJZGV2LT52ZGV2ID0gc3RrX3Y0bF9kYXRhOwogCWRldi0+dmRldi5kZWJ1ZyA9IGRlYnVn
OwogCWRldi0+dmRldi5wYXJlbnQgPSAmZGV2LT5pbnRlcmZhY2UtPmRldjsKLQl2aWRlb19zZXRf
ZHJ2ZGF0YSgmZGV2LT52ZGV2LCBkZXYpOwogCWVyciA9IHZpZGVvX3JlZ2lzdGVyX2RldmljZSgm
ZGV2LT52ZGV2LCBWRkxfVFlQRV9HUkFCQkVSLCAtMSk7CiAJaWYgKGVycikKIAkJU1RLX0VSUk9S
KCJ2NGwgcmVnaXN0cmF0aW9uIGZhaWxlZFxuIik7Ci0tIAoxLjUuNgoK
------=_Part_43447_10981909.1222815853204
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
------=_Part_43447_10981909.1222815853204--
