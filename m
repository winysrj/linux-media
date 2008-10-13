Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9DMVQLe029412
	for <video4linux-list@redhat.com>; Mon, 13 Oct 2008 18:31:26 -0400
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.171])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9DMVF8T008361
	for <video4linux-list@redhat.com>; Mon, 13 Oct 2008 18:31:16 -0400
Received: by ug-out-1314.google.com with SMTP id o38so601681ugd.13
	for <video4linux-list@redhat.com>; Mon, 13 Oct 2008 15:31:15 -0700 (PDT)
Message-ID: <30353c3d0810131531p1d69d656t2dfd136866ecc8c1@mail.gmail.com>
Date: Mon, 13 Oct 2008 18:31:15 -0400
From: "David Ellingsworth" <david@identd.dyndns.org>
To: "Mauro Carvalho Chehab" <mchehab@infradead.org>,
	v4l <video4linux-list@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_31866_18248630.1223937075096"
Cc: 
Subject: [PATCH 2/2] stk-webcam: fix crash on close after disconnect
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

------=_Part_31866_18248630.1223937075096
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

This patch prevents stk-webcam from updating usb device information
once the camera has been removed. This prevents a crash that would
otherwise occur if the camera is disconnected while it is still in
use.

Regards,

David Ellingsworth

==========================================================
>From 2e456d9bbe370d4019a991b193df1e869df9d532 Mon Sep 17 00:00:00 2001
From: David Ellingsworth <david@identd.dyndns.org>
Date: Mon, 13 Oct 2008 16:58:58 -0400
Subject: [PATCH] stk-webcam: fix crash on close after disconnect


Signed-off-by: David Ellingsworth <david@identd.dyndns.org>
---
 drivers/media/video/stk-webcam.c |   18 +++++++-----------
 1 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/media/video/stk-webcam.c b/drivers/media/video/stk-webcam.c
index f1d5b3e..edaea49 100644
--- a/drivers/media/video/stk-webcam.c
+++ b/drivers/media/video/stk-webcam.c
@@ -559,7 +559,7 @@ static void stk_clean_iso(struct stk_camera *dev)

 		urb = dev->isobufs[i].urb;
 		if (urb) {
-			if (atomic_read(&dev->urbs_used))
+			if (atomic_read(&dev->urbs_used) && is_present(dev))
 				usb_kill_urb(urb);
 			usb_free_urb(urb);
 		}
@@ -688,18 +688,14 @@ static int v4l_stk_release(struct inode *inode,
struct file *fp)
 {
 	struct stk_camera *dev = fp->private_data;

-	if (dev->owner != fp) {
-		usb_autopm_put_interface(dev->interface);
-		return 0;
+	if (dev->owner == fp) {
+		stk_stop_stream(dev);
+		stk_free_buffers(dev);
+		dev->owner = NULL;
 	}

-	stk_stop_stream(dev);
-
-	stk_free_buffers(dev);
-
-	dev->owner = NULL;
-
-	usb_autopm_put_interface(dev->interface);
+	if(is_present(dev))
+		usb_autopm_put_interface(dev->interface);

 	return 0;
 }
-- 
1.5.6.5

------=_Part_31866_18248630.1223937075096
Content-Type: application/octet-stream;
	name=0002-stk-webcam-fix-crash-on-close-after-disconnect.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fm9oj0he0
Content-Disposition: attachment;
	filename=0002-stk-webcam-fix-crash-on-close-after-disconnect.patch

RnJvbSAyZTQ1NmQ5YmJlMzcwZDQwMTlhOTkxYjE5M2RmMWU4NjlkZjlkNTMyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBEYXZpZCBFbGxpbmdzd29ydGggPGRhdmlkQGlkZW50ZC5keW5k
bnMub3JnPgpEYXRlOiBNb24sIDEzIE9jdCAyMDA4IDE2OjU4OjU4IC0wNDAwClN1YmplY3Q6IFtQ
QVRDSF0gc3RrLXdlYmNhbTogZml4IGNyYXNoIG9uIGNsb3NlIGFmdGVyIGRpc2Nvbm5lY3QKCgpT
aWduZWQtb2ZmLWJ5OiBEYXZpZCBFbGxpbmdzd29ydGggPGRhdmlkQGlkZW50ZC5keW5kbnMub3Jn
PgotLS0KIGRyaXZlcnMvbWVkaWEvdmlkZW8vc3RrLXdlYmNhbS5jIHwgICAxOCArKysrKysrLS0t
LS0tLS0tLS0KIDEgZmlsZXMgY2hhbmdlZCwgNyBpbnNlcnRpb25zKCspLCAxMSBkZWxldGlvbnMo
LSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL21lZGlhL3ZpZGVvL3N0ay13ZWJjYW0uYyBiL2RyaXZl
cnMvbWVkaWEvdmlkZW8vc3RrLXdlYmNhbS5jCmluZGV4IGYxZDViM2UuLmVkYWVhNDkgMTAwNjQ0
Ci0tLSBhL2RyaXZlcnMvbWVkaWEvdmlkZW8vc3RrLXdlYmNhbS5jCisrKyBiL2RyaXZlcnMvbWVk
aWEvdmlkZW8vc3RrLXdlYmNhbS5jCkBAIC01NTksNyArNTU5LDcgQEAgc3RhdGljIHZvaWQgc3Rr
X2NsZWFuX2lzbyhzdHJ1Y3Qgc3RrX2NhbWVyYSAqZGV2KQogCiAJCXVyYiA9IGRldi0+aXNvYnVm
c1tpXS51cmI7CiAJCWlmICh1cmIpIHsKLQkJCWlmIChhdG9taWNfcmVhZCgmZGV2LT51cmJzX3Vz
ZWQpKQorCQkJaWYgKGF0b21pY19yZWFkKCZkZXYtPnVyYnNfdXNlZCkgJiYgaXNfcHJlc2VudChk
ZXYpKQogCQkJCXVzYl9raWxsX3VyYih1cmIpOwogCQkJdXNiX2ZyZWVfdXJiKHVyYik7CiAJCX0K
QEAgLTY4OCwxOCArNjg4LDE0IEBAIHN0YXRpYyBpbnQgdjRsX3N0a19yZWxlYXNlKHN0cnVjdCBp
bm9kZSAqaW5vZGUsIHN0cnVjdCBmaWxlICpmcCkKIHsKIAlzdHJ1Y3Qgc3RrX2NhbWVyYSAqZGV2
ID0gZnAtPnByaXZhdGVfZGF0YTsKIAotCWlmIChkZXYtPm93bmVyICE9IGZwKSB7Ci0JCXVzYl9h
dXRvcG1fcHV0X2ludGVyZmFjZShkZXYtPmludGVyZmFjZSk7Ci0JCXJldHVybiAwOworCWlmIChk
ZXYtPm93bmVyID09IGZwKSB7CisJCXN0a19zdG9wX3N0cmVhbShkZXYpOworCQlzdGtfZnJlZV9i
dWZmZXJzKGRldik7CisJCWRldi0+b3duZXIgPSBOVUxMOwogCX0KIAotCXN0a19zdG9wX3N0cmVh
bShkZXYpOwotCi0Jc3RrX2ZyZWVfYnVmZmVycyhkZXYpOwotCi0JZGV2LT5vd25lciA9IE5VTEw7
Ci0KLQl1c2JfYXV0b3BtX3B1dF9pbnRlcmZhY2UoZGV2LT5pbnRlcmZhY2UpOworCWlmKGlzX3By
ZXNlbnQoZGV2KSkKKwkJdXNiX2F1dG9wbV9wdXRfaW50ZXJmYWNlKGRldi0+aW50ZXJmYWNlKTsK
IAogCXJldHVybiAwOwogfQotLSAKMS41LjYuNQoK
------=_Part_31866_18248630.1223937075096
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
------=_Part_31866_18248630.1223937075096--
