Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37251 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508Ab1KUVIk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Nov 2011 16:08:40 -0500
Received: by mail-ww0-f44.google.com with SMTP id 5so11147238wwe.1
        for <linux-media@vger.kernel.org>; Mon, 21 Nov 2011 13:08:39 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 22 Nov 2011 02:38:38 +0530
Message-ID: <CAHFNz9J9Hd2sGURVZOU1qGaBskmjORZd3hKk=r-Dodp9uc+5Qw@mail.gmail.com>
Subject: PATCH 10/13: 0010-TDA10071-Query-DVB-frontend-delivery-capabilities
From: Manu Abraham <abraham.manu@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Andreas Oberritter <obi@linuxtv.org>,
	Antti Palosaari <crope@iki.fi>
Content-Type: multipart/mixed; boundary=00163646c0f23a82c404b2451747
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--00163646c0f23a82c404b2451747
Content-Type: text/plain; charset=ISO-8859-1



--00163646c0f23a82c404b2451747
Content-Type: text/x-patch; charset=US-ASCII;
	name="0010-TDA10071-Query-DVB-frontend-delivery-capabilities.patch"
Content-Disposition: attachment;
	filename="0010-TDA10071-Query-DVB-frontend-delivery-capabilities.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: file0

RnJvbSBhN2Q3Y2ViNjJiMGEwMGJhMzA5M2RmNmIxOTY2Njk4MjZhM2M2MjVmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNYW51IEFicmFoYW0gPGFicmFoYW0ubWFudUBnbWFpbC5jb20+
CkRhdGU6IFRodSwgMTcgTm92IDIwMTEgMTM6Mjg6MjkgKzA1MzAKU3ViamVjdDogW1BBVENIIDEw
LzEzXSBUREExMDA3MTogUXVlcnkgRFZCIGZyb250ZW5kIGRlbGl2ZXJ5IGNhcGFiaWxpdGllcwoK
T3ZlcnJpZGUgZGVmYXVsdCBkZWxpdmVyeSBzeXN0ZW0gaW5mb3JtYXRpb24gcHJvdmlkZWQgYnkg
RkVfR0VUX0lORk8sIHNvCnRoYXQgYXBwbGljYXRpb25zIGNhbiBlbnVtZXJhdGUgZGVsaXZlcnkg
c3lzdGVtcyBwcm92aWRlZCBieSB0aGUgZnJvbnRlbmQuCgpTaWduZWQtb2ZmLWJ5OiBNYW51IEFi
cmFoYW0gPGFicmFoYW0ubWFudUBnbWFpbC5jb20+Ci0tLQogZHJpdmVycy9tZWRpYS9kdmIvZnJv
bnRlbmRzL3RkYTEwMDcxLmMgfCAgIDE2ICsrKysrKysrKysrKysrKysKIDEgZmlsZXMgY2hhbmdl
ZCwgMTYgaW5zZXJ0aW9ucygrKSwgMCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJz
L21lZGlhL2R2Yi9mcm9udGVuZHMvdGRhMTAwNzEuYyBiL2RyaXZlcnMvbWVkaWEvZHZiL2Zyb250
ZW5kcy90ZGExMDA3MS5jCmluZGV4IDBjMzc0MzQuLmY5YWJlMWQgMTAwNjQ0Ci0tLSBhL2RyaXZl
cnMvbWVkaWEvZHZiL2Zyb250ZW5kcy90ZGExMDA3MS5jCisrKyBiL2RyaXZlcnMvbWVkaWEvZHZi
L2Zyb250ZW5kcy90ZGExMDA3MS5jCkBAIC0xMjE2LDYgKzEyMTYsMjAgQEAgZXJyb3I6CiB9CiBF
WFBPUlRfU1lNQk9MKHRkYTEwMDcxX2F0dGFjaCk7CiAKK3N0YXRpYyBpbnQgdGRhMTAwNzFfZ2V0
X3Byb3BlcnR5KHN0cnVjdCBkdmJfZnJvbnRlbmQgKmZlLCBzdHJ1Y3QgZHR2X3Byb3BlcnR5ICpw
KQoreworCXN3aXRjaCAocC0+Y21kKSB7CisJY2FzZSBEVFZfRU5VTV9ERUxTWVM6CisJCXAtPnUu
YnVmZmVyLmRhdGFbMF0gPSBTWVNfRFZCUzsKKwkJcC0+dS5idWZmZXIuZGF0YVsxXSA9IFNZU19E
VkJTMjsKKwkJcC0+dS5idWZmZXIubGVuID0gMjsKKwkJYnJlYWs7CisJZGVmYXVsdDoKKwkJYnJl
YWs7CisJfQorCXJldHVybiAwOworfQorCiBzdGF0aWMgc3RydWN0IGR2Yl9mcm9udGVuZF9vcHMg
dGRhMTAwNzFfb3BzID0gewogCS5pbmZvID0gewogCQkubmFtZSA9ICJOWFAgVERBMTAwNzEiLApA
QCAtMTI2Miw2ICsxMjc2LDggQEAgc3RhdGljIHN0cnVjdCBkdmJfZnJvbnRlbmRfb3BzIHRkYTEw
MDcxX29wcyA9IHsKIAogCS5zZXRfdG9uZSA9IHRkYTEwMDcxX3NldF90b25lLAogCS5zZXRfdm9s
dGFnZSA9IHRkYTEwMDcxX3NldF92b2x0YWdlLAorCisJLmdldF9wcm9wZXJ0eSA9IHRkYTEwMDcx
X2dldF9wcm9wZXJ0eSwKIH07CiAKIE1PRFVMRV9BVVRIT1IoIkFudHRpIFBhbG9zYWFyaSA8Y3Jv
cGVAaWtpLmZpPiIpOwotLSAKMS43LjEKCg==
--00163646c0f23a82c404b2451747--
