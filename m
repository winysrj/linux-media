Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8C7h02v022656
	for <video4linux-list@redhat.com>; Fri, 12 Sep 2008 03:43:03 -0400
Received: from mail-gx0-f15.google.com (mail-gx0-f15.google.com
	[209.85.217.15])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8C7WF8k025054
	for <video4linux-list@redhat.com>; Fri, 12 Sep 2008 03:32:29 -0400
Received: by gxk8 with SMTP id 8so11282924gxk.3
	for <video4linux-list@redhat.com>; Fri, 12 Sep 2008 00:32:15 -0700 (PDT)
Message-ID: <3192d3cd0809120032v5a49ac70o52e3a283ee3f1856@mail.gmail.com>
Date: Fri, 12 Sep 2008 07:32:14 +0000
From: "Christian Gmeiner" <christian.gmeiner@gmail.com>
To: "Linux and Kernel Video" <video4linux-list@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_131069_25392033.1221204734765"
Subject: [PATCH] Clean up bt866 driver
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

------=_Part_131069_25392033.1221204734765
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

This patch removes some not needed includes and also removes some not supported
variables from struct bt866.

Signed-off-by: Christian Gmeiner <christian.gmeiner@gmail.com>

-- 
Christian Gmeiner, B.Sc.

------=_Part_131069_25392033.1221204734765
Content-Type: application/octet-stream; name=bt866_cleanup.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fl0lwoad0
Content-Disposition: attachment; filename=bt866_cleanup.patch

ZGlmZiAtciBlNWNhNDUzNGI1NDMgbGludXgvZHJpdmVycy9tZWRpYS92aWRlby9idDg2Ni5jCi0t
LSBhL2xpbnV4L2RyaXZlcnMvbWVkaWEvdmlkZW8vYnQ4NjYuYwlUdWUgU2VwIDA5IDA4OjI5OjU2
IDIwMDggLTA3MDAKKysrIGIvbGludXgvZHJpdmVycy9tZWRpYS92aWRlby9idDg2Ni5jCUZyaSBT
ZXAgMTIgMDk6MjQ6MTIgMjAwOCArMDAwMApAQCAtMjgsMjggKzI4LDEwIEBACiAgICAgRm91bmRh
dGlvbiwgSW5jLiwgNjc1IE1hc3MgQXZlLCBDYW1icmlkZ2UsIE1BIDAyMTM5LCBVU0EuCiAqLwog
Ci0jaW5jbHVkZSA8bGludXgvbW9kdWxlLmg+Ci0jaW5jbHVkZSA8bGludXgvaW5pdC5oPgotI2lu
Y2x1ZGUgPGxpbnV4L2RlbGF5Lmg+Ci0jaW5jbHVkZSA8bGludXgvZXJybm8uaD4KLSNpbmNsdWRl
IDxsaW51eC9mcy5oPgotI2luY2x1ZGUgPGxpbnV4L2tlcm5lbC5oPgotI2luY2x1ZGUgPGxpbnV4
L21ham9yLmg+Ci0jaW5jbHVkZSA8bGludXgvc2xhYi5oPgotI2luY2x1ZGUgPGxpbnV4L21tLmg+
Ci0jaW5jbHVkZSA8bGludXgvc2lnbmFsLmg+Ci0jaW5jbHVkZSA8YXNtL2lvLmg+Ci0jaW5jbHVk
ZSA8YXNtL3BndGFibGUuaD4KLSNpbmNsdWRlIDxhc20vcGFnZS5oPgotI2luY2x1ZGUgPGxpbnV4
L3NjaGVkLmg+Ci0jaW5jbHVkZSA8bGludXgvdHlwZXMuaD4KICNpbmNsdWRlIDxsaW51eC9pMmMu
aD4KLQorI2luY2x1ZGUgPGxpbnV4L3ZpZGVvZGV2Lmg+CisjaW5jbHVkZSA8bGludXgvdmlkZW9f
ZW5jb2Rlci5oPgogI2luY2x1ZGUgImNvbXBhdC5oIgotI2luY2x1ZGUgPGxpbnV4L3ZpZGVvZGV2
Lmg+Ci0jaW5jbHVkZSA8YXNtL3VhY2Nlc3MuaD4KLQotI2luY2x1ZGUgPGxpbnV4L3ZpZGVvX2Vu
Y29kZXIuaD4KIAogTU9EVUxFX0xJQ0VOU0UoIkdQTCIpOwogCkBAIC02OSwxMCArNTEsNiBAQAog
CiAJaW50IG5vcm07CiAJaW50IGVuYWJsZTsKLQlpbnQgYnJpZ2h0OwotCWludCBjb250cmFzdDsK
LQlpbnQgaHVlOwotCWludCBzYXQ7CiB9OwogCiBzdGF0aWMgaW50IGJ0ODY2X3dyaXRlKHN0cnVj
dCBidDg2NiAqZGV2LAo=
------=_Part_131069_25392033.1221204734765
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
------=_Part_131069_25392033.1221204734765--
