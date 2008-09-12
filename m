Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8C7YE0n019899
	for <video4linux-list@redhat.com>; Fri, 12 Sep 2008 03:34:14 -0400
Received: from mail-gx0-f15.google.com (mail-gx0-f15.google.com
	[209.85.217.15])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8C7WF8l025054
	for <video4linux-list@redhat.com>; Fri, 12 Sep 2008 03:33:04 -0400
Received: by mail-gx0-f15.google.com with SMTP id 8so11282924gxk.3
	for <video4linux-list@redhat.com>; Fri, 12 Sep 2008 00:33:04 -0700 (PDT)
Message-ID: <3192d3cd0809120033h37c504b3i36f3f1d47fe6a045@mail.gmail.com>
Date: Fri, 12 Sep 2008 07:33:04 +0000
From: "Christian Gmeiner" <christian.gmeiner@gmail.com>
To: "Linux and Kernel Video" <video4linux-list@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_131074_20387767.1221204784305"
Subject: [PATCH] Clean up bt856 driver
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

------=_Part_131074_20387767.1221204784305
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

This patch removes some not needed includes.

Signed-off-by: Christian Gmeiner <christian.gmeiner@gmail.com>

-- 
Christian Gmeiner, B.Sc.

------=_Part_131074_20387767.1221204784305
Content-Type: application/octet-stream; name=bt856_cleanup.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fl0ly66d0
Content-Disposition: attachment; filename=bt856_cleanup.patch

ZGlmZiAtciBlNWNhNDUzNGI1NDMgbGludXgvZHJpdmVycy9tZWRpYS92aWRlby9idDg1Ni5jCi0t
LSBhL2xpbnV4L2RyaXZlcnMvbWVkaWEvdmlkZW8vYnQ4NTYuYwlUdWUgU2VwIDA5IDA4OjI5OjU2
IDIwMDggLTA3MDAKKysrIGIvbGludXgvZHJpdmVycy9tZWRpYS92aWRlby9idDg1Ni5jCUZyaSBT
ZXAgMTIgMDk6MjI6MzQgMjAwOCArMDAwMApAQCAtMjgsMjYgKzI4LDEwIEBACiAgKiBGb3VuZGF0
aW9uLCBJbmMuLCA2NzUgTWFzcyBBdmUsIENhbWJyaWRnZSwgTUEgMDIxMzksIFVTQS4KICAqLwog
Ci0jaW5jbHVkZSA8bGludXgvbW9kdWxlLmg+Ci0jaW5jbHVkZSA8bGludXgvaW5pdC5oPgotI2lu
Y2x1ZGUgPGxpbnV4L2RlbGF5Lmg+Ci0jaW5jbHVkZSA8bGludXgvZXJybm8uaD4KLSNpbmNsdWRl
IDxsaW51eC9mcy5oPgotI2luY2x1ZGUgPGxpbnV4L2tlcm5lbC5oPgotI2luY2x1ZGUgPGxpbnV4
L21ham9yLmg+Ci0jaW5jbHVkZSA8bGludXgvc2xhYi5oPgotI2luY2x1ZGUgPGxpbnV4L21tLmg+
Ci0jaW5jbHVkZSA8bGludXgvc2lnbmFsLmg+Ci0jaW5jbHVkZSA8bGludXgvdHlwZXMuaD4KICNp
bmNsdWRlIDxsaW51eC9pMmMuaD4KKyNpbmNsdWRlIDxsaW51eC92aWRlb2Rldi5oPgogI2luY2x1
ZGUgPGxpbnV4L3ZpZGVvX2VuY29kZXIuaD4KLSNpbmNsdWRlIDxhc20vaW8uaD4KLSNpbmNsdWRl
IDxhc20vcGd0YWJsZS5oPgotI2luY2x1ZGUgPGFzbS9wYWdlLmg+Ci0jaW5jbHVkZSA8YXNtL3Vh
Y2Nlc3MuaD4KLQogI2luY2x1ZGUgImNvbXBhdC5oIgotI2luY2x1ZGUgPGxpbnV4L3ZpZGVvZGV2
Lmg+CiAKIE1PRFVMRV9ERVNDUklQVElPTigiQnJvb2t0cmVlLTg1NkEgdmlkZW8gZW5jb2RlciBk
cml2ZXIiKTsKIE1PRFVMRV9BVVRIT1IoIk1pa2UgQmVybnNvbiAmIERhdmUgUGVya3MiKTsK
------=_Part_131074_20387767.1221204784305
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
------=_Part_131074_20387767.1221204784305--
