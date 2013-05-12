Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:61527 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab3ELUDx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 May 2013 16:03:53 -0400
Received: by mail-pa0-f44.google.com with SMTP id jh10so4132567pab.3
        for <linux-media@vger.kernel.org>; Sun, 12 May 2013 13:03:52 -0700 (PDT)
MIME-Version: 1.0
From: =?ISO-8859-1?Q?Roberto_Alc=E2ntara?= <roberto@eletronica.org>
Date: Sun, 12 May 2013 17:03:31 -0300
Message-ID: <CAEt6MXk3xqb3D6-j30JigGahYVvQvf5ZcikD5WO0A=5cm8_GJw@mail.gmail.com>
Subject: [PATCH] smscoreapi: fixing memory leak
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: multipart/mixed; boundary=047d7b675a5a35203904dc8ae639
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--047d7b675a5a35203904dc8ae639
Content-Type: text/plain; charset=ISO-8859-1

 - Roberto

--047d7b675a5a35203904dc8ae639
Content-Type: application/octet-stream; name="mem.patch"
Content-Disposition: attachment; filename="mem.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hgmmfql60

U2lnbmVkLW9mZi1ieTogUm9iZXJ0byBBbGNhbnRhcmEgPHJvYmVydG9AZWxldHJvbmljYS5vcmc+
CmRpZmYgLS1naXQgYS9kcml2ZXJzL21lZGlhL2NvbW1vbi9zaWFuby9zbXNjb3JlYXBpLmMgYi9k
cml2ZXJzL21lZGlhL2NvbW1vbi9zaWFuby9zbXNjb3JlYXBpLmMKaW5kZXggZGJlOWI0ZC4uZjY1
YjRlMyAxMDA2NDQKLS0tIGEvZHJpdmVycy9tZWRpYS9jb21tb24vc2lhbm8vc21zY29yZWFwaS5j
CisrKyBiL2RyaXZlcnMvbWVkaWEvY29tbW9uL3NpYW5vL3Ntc2NvcmVhcGkuYwpAQCAtMTE3Mywx
NiArMTE3MywxNiBAQCBzdGF0aWMgaW50IHNtc2NvcmVfbG9hZF9maXJtd2FyZV9mcm9tX2ZpbGUo
c3RydWN0IHNtc2NvcmVfZGV2aWNlX3QgKmNvcmVkZXYsCiAJCQkgR0ZQX0tFUk5FTCB8IEdGUF9E
TUEpOwogCWlmICghZndfYnVmKSB7CiAJCXNtc19lcnIoImZhaWxlZCB0byBhbGxvY2F0ZSBmaXJt
d2FyZSBidWZmZXIiKTsKLQkJcmV0dXJuIC1FTk9NRU07Ci0JfQotCW1lbWNweShmd19idWYsIGZ3
LT5kYXRhLCBmdy0+c2l6ZSk7Ci0JZndfYnVmX3NpemUgPSBmdy0+c2l6ZTsKLQotCXJjID0gKGNv
cmVkZXYtPmRldmljZV9mbGFncyAmIFNNU19ERVZJQ0VfRkFNSUxZMikgPwotCQlzbXNjb3JlX2xv
YWRfZmlybXdhcmVfZmFtaWx5Mihjb3JlZGV2LCBmd19idWYsIGZ3X2J1Zl9zaXplKQotCQk6IGxv
YWRmaXJtd2FyZV9oYW5kbGVyKGNvcmVkZXYtPmNvbnRleHQsIGZ3X2J1ZiwKLQkJZndfYnVmX3Np
emUpOworCQlyYyA9IC1FTk9NRU07CisJfSBlbHNlIHsKKwkJbWVtY3B5KGZ3X2J1ZiwgZnctPmRh
dGEsIGZ3LT5zaXplKTsKKwkJZndfYnVmX3NpemUgPSBmdy0+c2l6ZTsKIAorCQlyYyA9IChjb3Jl
ZGV2LT5kZXZpY2VfZmxhZ3MgJiBTTVNfREVWSUNFX0ZBTUlMWTIpID8KKwkJCXNtc2NvcmVfbG9h
ZF9maXJtd2FyZV9mYW1pbHkyKGNvcmVkZXYsIGZ3X2J1ZiwgZndfYnVmX3NpemUpCisJCQk6IGxv
YWRmaXJtd2FyZV9oYW5kbGVyKGNvcmVkZXYtPmNvbnRleHQsIGZ3X2J1ZiwKKwkJCWZ3X2J1Zl9z
aXplKTsKKwl9CiAJa2ZyZWUoZndfYnVmKTsKIAlyZWxlYXNlX2Zpcm13YXJlKGZ3KTsKIAo=
--047d7b675a5a35203904dc8ae639--
