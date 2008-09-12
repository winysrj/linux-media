Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8C7UHLr019427
	for <video4linux-list@redhat.com>; Fri, 12 Sep 2008 03:30:18 -0400
Received: from mail-gx0-f15.google.com (mail-gx0-f15.google.com
	[209.85.217.15])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8C7U7oP024278
	for <video4linux-list@redhat.com>; Fri, 12 Sep 2008 03:30:07 -0400
Received: by gxk8 with SMTP id 8so11280159gxk.3
	for <video4linux-list@redhat.com>; Fri, 12 Sep 2008 00:30:07 -0700 (PDT)
Message-ID: <3192d3cd0809120030g28d71c7aw4787e15f98601b02@mail.gmail.com>
Date: Fri, 12 Sep 2008 07:30:07 +0000
From: "Christian Gmeiner" <christian.gmeiner@gmail.com>
To: "Linux and Kernel Video" <video4linux-list@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_131048_190240.1221204607127"
Subject: [PATCH] Clean up adv7170 driver
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

------=_Part_131048_190240.1221204607127
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

This patch removes some not needed includes and also removes some not supported
variables from struct adv7170.

Signed-off-by: Christian Gmeiner <christian.gmeiner@gmail.com>

-- 
Christian Gmeiner, B.Sc.

------=_Part_131048_190240.1221204607127
Content-Type: application/octet-stream; name=adv7170_cleanup.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fl0lu8l90
Content-Disposition: attachment; filename=adv7170_cleanup.patch

ZGlmZiAtciBlNWNhNDUzNGI1NDMgbGludXgvZHJpdmVycy9tZWRpYS92aWRlby9hZHY3MTcwLmMK
LS0tIGEvbGludXgvZHJpdmVycy9tZWRpYS92aWRlby9hZHY3MTcwLmMJVHVlIFNlcCAwOSAwODoy
OTo1NiAyMDA4IC0wNzAwCisrKyBiL2xpbnV4L2RyaXZlcnMvbWVkaWEvdmlkZW8vYWR2NzE3MC5j
CUZyaSBTZXAgMTIgMDk6MjA6NDggMjAwOCArMDAwMApAQCAtMjgsMjMgKzI4LDcgQEAKICAqIEZv
dW5kYXRpb24sIEluYy4sIDY3NSBNYXNzIEF2ZSwgQ2FtYnJpZGdlLCBNQSAwMjEzOSwgVVNBLgog
ICovCiAKLSNpbmNsdWRlIDxsaW51eC9tb2R1bGUuaD4KLSNpbmNsdWRlIDxsaW51eC9pbml0Lmg+
Ci0jaW5jbHVkZSA8bGludXgvZGVsYXkuaD4KLSNpbmNsdWRlIDxsaW51eC9lcnJuby5oPgotI2lu
Y2x1ZGUgPGxpbnV4L2ZzLmg+Ci0jaW5jbHVkZSA8bGludXgva2VybmVsLmg+Ci0jaW5jbHVkZSA8
bGludXgvbWFqb3IuaD4KLSNpbmNsdWRlIDxsaW51eC9zbGFiLmg+Ci0jaW5jbHVkZSA8bGludXgv
bW0uaD4KLSNpbmNsdWRlIDxsaW51eC9zaWduYWwuaD4KLSNpbmNsdWRlIDxsaW51eC90eXBlcy5o
PgogI2luY2x1ZGUgPGxpbnV4L2kyYy5oPgotI2luY2x1ZGUgPGFzbS9pby5oPgotI2luY2x1ZGUg
PGFzbS9wZ3RhYmxlLmg+Ci0jaW5jbHVkZSA8YXNtL3BhZ2UuaD4KLSNpbmNsdWRlIDxhc20vdWFj
Y2Vzcy5oPgotCiAjaW5jbHVkZSAiY29tcGF0LmgiCiAjaW5jbHVkZSA8bGludXgvdmlkZW9kZXYu
aD4KICNpbmNsdWRlIDxsaW51eC92aWRlb19lbmNvZGVyLmg+CkBAIC03NSwxMCArNTksNiBAQAog
CWludCBub3JtOwogCWludCBpbnB1dDsKIAlpbnQgZW5hYmxlOwotCWludCBicmlnaHQ7Ci0JaW50
IGNvbnRyYXN0OwotCWludCBodWU7Ci0JaW50IHNhdDsKIH07CiAKICNkZWZpbmUgICBJMkNfQURW
NzE3MCAgICAgICAgMHhkNAo=
------=_Part_131048_190240.1221204607127
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
------=_Part_131048_190240.1221204607127--
