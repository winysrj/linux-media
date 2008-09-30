Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8U0Pokp001473
	for <video4linux-list@redhat.com>; Mon, 29 Sep 2008 20:25:51 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.156])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8U0PdOW010497
	for <video4linux-list@redhat.com>; Mon, 29 Sep 2008 20:25:39 -0400
Received: by fg-out-1718.google.com with SMTP id e21so1711159fga.7
	for <video4linux-list@redhat.com>; Mon, 29 Sep 2008 17:25:38 -0700 (PDT)
Message-ID: <30353c3d0809291725y58606c71ufc43438169add254@mail.gmail.com>
Date: Mon, 29 Sep 2008 20:25:38 -0400
From: "David Ellingsworth" <david@identd.dyndns.org>
To: v4l <video4linux-list@redhat.com>,
	"Jaime Velasco Juan" <jsagarribay@gmail.com>,
	"Mauro Carvalho Chehab" <mchehab@infradead.org>
In-Reply-To: <30353c3d0809291723i26eb15c1rea55369750d932c9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_26717_3969797.1222734338865"
References: <30353c3d0809291723i26eb15c1rea55369750d932c9@mail.gmail.com>
Cc: 
Subject: Re: [PATCH 1/3] stkwebcam: fix crash on close after disconnect
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

------=_Part_26717_3969797.1222734338865
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Sorry, patch attached here.

Regards,

David Ellingsworth

------=_Part_26717_3969797.1222734338865
Content-Type: text/x-diff;
	name=0001-stkwebcam-fix-crash-on-close-after-disconnect.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_flpseghv0
Content-Disposition: attachment;
	filename=0001-stkwebcam-fix-crash-on-close-after-disconnect.patch

RnJvbSA4ZDY1ZWNhMzgzZmZmYjMwMjU5YmUzYTMzNTM5ZWMzNmI1MTk2YzRlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBEYXZpZCBFbGxpbmdzd29ydGggPGRhdmlkQGlkZW50ZC5keW5k
bnMub3JnPgpEYXRlOiBNb24sIDI5IFNlcCAyMDA4IDE5OjU5OjExIC0wNDAwClN1YmplY3Q6IFtQ
QVRDSF0gc3Rrd2ViY2FtOiBmaXggY3Jhc2ggb24gY2xvc2UgYWZ0ZXIgZGlzY29ubmVjdAoKClNp
Z25lZC1vZmYtYnk6IERhdmlkIEVsbGluZ3N3b3J0aCA8ZGF2aWRAaWRlbnRkLmR5bmRucy5vcmc+
Ci0tLQogZHJpdmVycy9tZWRpYS92aWRlby9zdGstd2ViY2FtLmMgfCAgIDE4ICsrKysrKystLS0t
LS0tLS0tLQogMSBmaWxlcyBjaGFuZ2VkLCA3IGluc2VydGlvbnMoKyksIDExIGRlbGV0aW9ucygt
KQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWVkaWEvdmlkZW8vc3RrLXdlYmNhbS5jIGIvZHJpdmVy
cy9tZWRpYS92aWRlby9zdGstd2ViY2FtLmMKaW5kZXggOGRkYTU2OC4uMzE5ODU0OSAxMDA2NDQK
LS0tIGEvZHJpdmVycy9tZWRpYS92aWRlby9zdGstd2ViY2FtLmMKKysrIGIvZHJpdmVycy9tZWRp
YS92aWRlby9zdGstd2ViY2FtLmMKQEAgLTU3Niw3ICs1NzYsNyBAQCBzdGF0aWMgdm9pZCBzdGtf
Y2xlYW5faXNvKHN0cnVjdCBzdGtfY2FtZXJhICpkZXYpCiAKIAkJdXJiID0gZGV2LT5pc29idWZz
W2ldLnVyYjsKIAkJaWYgKHVyYikgewotCQkJaWYgKGF0b21pY19yZWFkKCZkZXYtPnVyYnNfdXNl
ZCkpCisJCQlpZiAoYXRvbWljX3JlYWQoJmRldi0+dXJic191c2VkKSAmJiBpc19wcmVzZW50KGRl
dikpCiAJCQkJdXNiX2tpbGxfdXJiKHVyYik7CiAJCQl1c2JfZnJlZV91cmIodXJiKTsKIAkJfQpA
QCAtNzE4LDE5ICs3MTgsMTUgQEAgc3RhdGljIGludCB2NGxfc3RrX3JlbGVhc2Uoc3RydWN0IGlu
b2RlICppbm9kZSwgc3RydWN0IGZpbGUgKmZwKQogCQlyZXR1cm4gLUVOT0RFVjsKIAl9CiAKLQlp
ZiAoZGV2LT5vd25lciAhPSBmcCkgewotCQl1c2JfYXV0b3BtX3B1dF9pbnRlcmZhY2UoZGV2LT5p
bnRlcmZhY2UpOwotCQlrcmVmX3B1dCgmZGV2LT5rcmVmLCBzdGtfY2FtZXJhX2NsZWFudXApOwot
CQlyZXR1cm4gMDsKKwlpZiAoZGV2LT5vd25lciA9PSBmcCkgeworCQlzdGtfc3RvcF9zdHJlYW0o
ZGV2KTsKKwkJc3RrX2ZyZWVfYnVmZmVycyhkZXYpOworCQlkZXYtPm93bmVyID0gTlVMTDsKIAl9
CiAKLQlzdGtfc3RvcF9zdHJlYW0oZGV2KTsKLQotCXN0a19mcmVlX2J1ZmZlcnMoZGV2KTsKLQot
CWRldi0+b3duZXIgPSBOVUxMOworCWlmKGlzX3ByZXNlbnQoZGV2KSkKKwkJdXNiX2F1dG9wbV9w
dXRfaW50ZXJmYWNlKGRldi0+aW50ZXJmYWNlKTsKIAotCXVzYl9hdXRvcG1fcHV0X2ludGVyZmFj
ZShkZXYtPmludGVyZmFjZSk7CiAJa3JlZl9wdXQoJmRldi0+a3JlZiwgc3RrX2NhbWVyYV9jbGVh
bnVwKTsKIAogCXJldHVybiAwOwotLSAKMS41LjYKCg==
------=_Part_26717_3969797.1222734338865
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
------=_Part_26717_3969797.1222734338865--
