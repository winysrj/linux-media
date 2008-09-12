Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8C7YPJZ019989
	for <video4linux-list@redhat.com>; Fri, 12 Sep 2008 03:34:26 -0400
Received: from mail-gx0-f15.google.com (mail-gx0-f15.google.com
	[209.85.217.15])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8C7Y4s3025685
	for <video4linux-list@redhat.com>; Fri, 12 Sep 2008 03:34:11 -0400
Received: by gxk8 with SMTP id 8so11285259gxk.3
	for <video4linux-list@redhat.com>; Fri, 12 Sep 2008 00:34:04 -0700 (PDT)
Message-ID: <3192d3cd0809120034q4d40469cob5f0f0bbfbff5fb5@mail.gmail.com>
Date: Fri, 12 Sep 2008 07:34:03 +0000
From: "Christian Gmeiner" <christian.gmeiner@gmail.com>
To: "Linux and Kernel Video" <video4linux-list@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_131089_2511572.1221204844067"
Subject: [PATCH] Clean up bt819 driver
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

------=_Part_131089_2511572.1221204844067
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

This patch removes some not needed includes.

Signed-off-by: Christian Gmeiner <christian.gmeiner@gmail.com>

-- 
Christian Gmeiner, B.Sc.

------=_Part_131089_2511572.1221204844067
Content-Type: application/octet-stream; name=bt819_cleanup.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fl0lzm1p0
Content-Disposition: attachment; filename=bt819_cleanup.patch

ZGlmZiAtciBlNWNhNDUzNGI1NDMgbGludXgvZHJpdmVycy9tZWRpYS92aWRlby9idDgxOS5jCi0t
LSBhL2xpbnV4L2RyaXZlcnMvbWVkaWEvdmlkZW8vYnQ4MTkuYwlUdWUgU2VwIDA5IDA4OjI5OjU2
IDIwMDggLTA3MDAKKysrIGIvbGludXgvZHJpdmVycy9tZWRpYS92aWRlby9idDgxOS5jCUZyaSBT
ZXAgMTIgMDk6MjU6MjUgMjAwOCArMDAwMApAQCAtMjgsMjYgKzI4LDkgQEAKICAqIEZvdW5kYXRp
b24sIEluYy4sIDY3NSBNYXNzIEF2ZSwgQ2FtYnJpZGdlLCBNQSAwMjEzOSwgVVNBLgogICovCiAK
LSNpbmNsdWRlIDxsaW51eC9tb2R1bGUuaD4KLSNpbmNsdWRlIDxsaW51eC9pbml0Lmg+Ci0jaW5j
bHVkZSA8bGludXgvZGVsYXkuaD4KLSNpbmNsdWRlIDxsaW51eC9lcnJuby5oPgotI2luY2x1ZGUg
PGxpbnV4L2ZzLmg+Ci0jaW5jbHVkZSA8bGludXgva2VybmVsLmg+Ci0jaW5jbHVkZSA8bGludXgv
bWFqb3IuaD4KLSNpbmNsdWRlIDxsaW51eC9zbGFiLmg+Ci0jaW5jbHVkZSA8bGludXgvbW0uaD4K
LSNpbmNsdWRlIDxsaW51eC9zaWduYWwuaD4KLSNpbmNsdWRlIDxsaW51eC90eXBlcy5oPgogI2lu
Y2x1ZGUgPGxpbnV4L2kyYy5oPgotI2luY2x1ZGUgPGFzbS9pby5oPgotI2luY2x1ZGUgPGFzbS9w
Z3RhYmxlLmg+Ci0jaW5jbHVkZSA8YXNtL3BhZ2UuaD4KLSNpbmNsdWRlIDxhc20vdWFjY2Vzcy5o
PgotCiAjaW5jbHVkZSA8bGludXgvdmlkZW9kZXYuaD4KICNpbmNsdWRlIDxsaW51eC92aWRlb19k
ZWNvZGVyLmg+Ci0KICNpbmNsdWRlICJjb21wYXQuaCIKIAogTU9EVUxFX0RFU0NSSVBUSU9OKCJC
cm9va3RyZWUtODE5IHZpZGVvIGRlY29kZXIgZHJpdmVyIik7Cg==
------=_Part_131089_2511572.1221204844067
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
------=_Part_131089_2511572.1221204844067--
