Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9DMPYiQ026906
	for <video4linux-list@redhat.com>; Mon, 13 Oct 2008 18:25:34 -0400
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.189])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9DMPBSd004833
	for <video4linux-list@redhat.com>; Mon, 13 Oct 2008 18:25:20 -0400
Received: by nf-out-0910.google.com with SMTP id d3so828344nfc.21
	for <video4linux-list@redhat.com>; Mon, 13 Oct 2008 15:25:10 -0700 (PDT)
Message-ID: <30353c3d0810131525w3b8eb273u9136b020cb75c8a5@mail.gmail.com>
Date: Mon, 13 Oct 2008 18:25:10 -0400
From: "David Ellingsworth" <david@identd.dyndns.org>
To: "Mauro Carvalho Chehab" <mchehab@infradead.org>,
	v4l <video4linux-list@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_31838_8411976.1223936710590"
Cc: 
Subject: [PATCH 1/2] stk-webcam: minor cleanup
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

------=_Part_31838_8411976.1223936710590
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

The following patch corrects minor issues with the initial patch I
submitted for testing. This patch:
1) removes the unnecessary kref.h include file
2) removes unnecessary pointer validation from read and poll routines.
(Neither poll nor read may be called unless a call to open succeeds. A
successful call to open will always set the file private_data pointer.
Verifying that it is not null is therefore unnecessary. The associated
release and mmap calls currently ignore this check.)
3) adds a space to syslog output.
4) removes an unused function prototype.

Regards,

David Ellingsworth

======================================================================

>From 88670a05622419cd8c23de1e5029ead76e49ec50 Mon Sep 17 00:00:00 2001
From: David Ellingsworth <david@identd.dyndns.org>
Date: Mon, 13 Oct 2008 16:54:52 -0400
Subject: [PATCH] stk-webcam: minor cleanup


Signed-off-by: David Ellingsworth <david@identd.dyndns.org>
---
 drivers/media/video/stk-webcam.c |    9 +--------
 drivers/media/video/stk-webcam.h |    1 -
 2 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/drivers/media/video/stk-webcam.c b/drivers/media/video/stk-webcam.c
index db69bc5..f1d5b3e 100644
--- a/drivers/media/video/stk-webcam.c
+++ b/drivers/media/video/stk-webcam.c
@@ -27,7 +27,6 @@
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
-#include <linux/kref.h>

 #include <linux/usb.h>
 #include <linux/mm.h>
@@ -714,9 +713,6 @@ static ssize_t v4l_stk_read(struct file *fp, char
__user *buf,
 	struct stk_sio_buffer *sbuf;
 	struct stk_camera *dev = fp->private_data;

-	if (dev == NULL)
-		return -EIO;
-
 	if (!is_present(dev))
 		return -EIO;
 	if (dev->owner && dev->owner != fp)
@@ -773,9 +769,6 @@ static unsigned int v4l_stk_poll(struct file *fp,
poll_table *wait)
 {
 	struct stk_camera *dev = fp->private_data;

-	if (dev == NULL)
-		return -ENODEV;
-
 	poll_wait(fp, &dev->wait_frame, wait);

 	if (!is_present(dev))
@@ -1436,7 +1429,7 @@ static void stk_camera_disconnect(struct
usb_interface *interface)
 	wake_up_interruptible(&dev->wait_frame);
 	stk_remove_sysfs_files(&dev->vdev);

-	STK_INFO("Syntek USB2.0 Camera release resources"
+	STK_INFO("Syntek USB2.0 Camera release resources "
 		"video device /dev/video%d\n", dev->vdev.minor);

 	video_unregister_device(&dev->vdev);
diff --git a/drivers/media/video/stk-webcam.h b/drivers/media/video/stk-webcam.h
index 084a85b..9f67366 100644
--- a/drivers/media/video/stk-webcam.h
+++ b/drivers/media/video/stk-webcam.h
@@ -122,7 +122,6 @@ struct stk_camera {

 #define vdev_to_camera(d) container_of(d, struct stk_camera, vdev)

-void stk_camera_delete(struct kref *);
 int stk_camera_write_reg(struct stk_camera *, u16, u8);
 int stk_camera_read_reg(struct stk_camera *, u16, int *);

-- 
1.5.6.5

------=_Part_31838_8411976.1223936710590
Content-Type: application/octet-stream;
	name=0001-stk-webcam-minor-cleanup.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fm9o8vtb0
Content-Disposition: attachment; filename=0001-stk-webcam-minor-cleanup.patch

RnJvbSA4ODY3MGEwNTYyMjQxOWNkOGMyM2RlMWU1MDI5ZWFkNzZlNDllYzUwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBEYXZpZCBFbGxpbmdzd29ydGggPGRhdmlkQGlkZW50ZC5keW5k
bnMub3JnPgpEYXRlOiBNb24sIDEzIE9jdCAyMDA4IDE2OjU0OjUyIC0wNDAwClN1YmplY3Q6IFtQ
QVRDSF0gc3RrLXdlYmNhbTogbWlub3IgY2xlYW51cAoKClNpZ25lZC1vZmYtYnk6IERhdmlkIEVs
bGluZ3N3b3J0aCA8ZGF2aWRAaWRlbnRkLmR5bmRucy5vcmc+Ci0tLQogZHJpdmVycy9tZWRpYS92
aWRlby9zdGstd2ViY2FtLmMgfCAgICA5ICstLS0tLS0tLQogZHJpdmVycy9tZWRpYS92aWRlby9z
dGstd2ViY2FtLmggfCAgICAxIC0KIDIgZmlsZXMgY2hhbmdlZCwgMSBpbnNlcnRpb25zKCspLCA5
IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWVkaWEvdmlkZW8vc3RrLXdlYmNh
bS5jIGIvZHJpdmVycy9tZWRpYS92aWRlby9zdGstd2ViY2FtLmMKaW5kZXggZGI2OWJjNS4uZjFk
NWIzZSAxMDA2NDQKLS0tIGEvZHJpdmVycy9tZWRpYS92aWRlby9zdGstd2ViY2FtLmMKKysrIGIv
ZHJpdmVycy9tZWRpYS92aWRlby9zdGstd2ViY2FtLmMKQEAgLTI3LDcgKzI3LDYgQEAKICNpbmNs
dWRlIDxsaW51eC9rZXJuZWwuaD4KICNpbmNsdWRlIDxsaW51eC9lcnJuby5oPgogI2luY2x1ZGUg
PGxpbnV4L3NsYWIuaD4KLSNpbmNsdWRlIDxsaW51eC9rcmVmLmg+CiAKICNpbmNsdWRlIDxsaW51
eC91c2IuaD4KICNpbmNsdWRlIDxsaW51eC9tbS5oPgpAQCAtNzE0LDkgKzcxMyw2IEBAIHN0YXRp
YyBzc2l6ZV90IHY0bF9zdGtfcmVhZChzdHJ1Y3QgZmlsZSAqZnAsIGNoYXIgX191c2VyICpidWYs
CiAJc3RydWN0IHN0a19zaW9fYnVmZmVyICpzYnVmOwogCXN0cnVjdCBzdGtfY2FtZXJhICpkZXYg
PSBmcC0+cHJpdmF0ZV9kYXRhOwogCi0JaWYgKGRldiA9PSBOVUxMKQotCQlyZXR1cm4gLUVJTzsK
LQogCWlmICghaXNfcHJlc2VudChkZXYpKQogCQlyZXR1cm4gLUVJTzsKIAlpZiAoZGV2LT5vd25l
ciAmJiBkZXYtPm93bmVyICE9IGZwKQpAQCAtNzczLDkgKzc2OSw2IEBAIHN0YXRpYyB1bnNpZ25l
ZCBpbnQgdjRsX3N0a19wb2xsKHN0cnVjdCBmaWxlICpmcCwgcG9sbF90YWJsZSAqd2FpdCkKIHsK
IAlzdHJ1Y3Qgc3RrX2NhbWVyYSAqZGV2ID0gZnAtPnByaXZhdGVfZGF0YTsKIAotCWlmIChkZXYg
PT0gTlVMTCkKLQkJcmV0dXJuIC1FTk9ERVY7Ci0KIAlwb2xsX3dhaXQoZnAsICZkZXYtPndhaXRf
ZnJhbWUsIHdhaXQpOwogCiAJaWYgKCFpc19wcmVzZW50KGRldikpCkBAIC0xNDM2LDcgKzE0Mjks
NyBAQCBzdGF0aWMgdm9pZCBzdGtfY2FtZXJhX2Rpc2Nvbm5lY3Qoc3RydWN0IHVzYl9pbnRlcmZh
Y2UgKmludGVyZmFjZSkKIAl3YWtlX3VwX2ludGVycnVwdGlibGUoJmRldi0+d2FpdF9mcmFtZSk7
CiAJc3RrX3JlbW92ZV9zeXNmc19maWxlcygmZGV2LT52ZGV2KTsKIAotCVNUS19JTkZPKCJTeW50
ZWsgVVNCMi4wIENhbWVyYSByZWxlYXNlIHJlc291cmNlcyIKKwlTVEtfSU5GTygiU3ludGVrIFVT
QjIuMCBDYW1lcmEgcmVsZWFzZSByZXNvdXJjZXMgIgogCQkidmlkZW8gZGV2aWNlIC9kZXYvdmlk
ZW8lZFxuIiwgZGV2LT52ZGV2Lm1pbm9yKTsKIAogCXZpZGVvX3VucmVnaXN0ZXJfZGV2aWNlKCZk
ZXYtPnZkZXYpOwpkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZWRpYS92aWRlby9zdGstd2ViY2FtLmgg
Yi9kcml2ZXJzL21lZGlhL3ZpZGVvL3N0ay13ZWJjYW0uaAppbmRleCAwODRhODViLi45ZjY3MzY2
IDEwMDY0NAotLS0gYS9kcml2ZXJzL21lZGlhL3ZpZGVvL3N0ay13ZWJjYW0uaAorKysgYi9kcml2
ZXJzL21lZGlhL3ZpZGVvL3N0ay13ZWJjYW0uaApAQCAtMTIyLDcgKzEyMiw2IEBAIHN0cnVjdCBz
dGtfY2FtZXJhIHsKIAogI2RlZmluZSB2ZGV2X3RvX2NhbWVyYShkKSBjb250YWluZXJfb2YoZCwg
c3RydWN0IHN0a19jYW1lcmEsIHZkZXYpCiAKLXZvaWQgc3RrX2NhbWVyYV9kZWxldGUoc3RydWN0
IGtyZWYgKik7CiBpbnQgc3RrX2NhbWVyYV93cml0ZV9yZWcoc3RydWN0IHN0a19jYW1lcmEgKiwg
dTE2LCB1OCk7CiBpbnQgc3RrX2NhbWVyYV9yZWFkX3JlZyhzdHJ1Y3Qgc3RrX2NhbWVyYSAqLCB1
MTYsIGludCAqKTsKIAotLSAKMS41LjYuNQoK
------=_Part_31838_8411976.1223936710590
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
------=_Part_31838_8411976.1223936710590--
